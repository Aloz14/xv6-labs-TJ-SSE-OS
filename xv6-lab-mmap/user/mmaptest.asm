
user/_mmaptest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
}

char *testname = "???";

void err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
    printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002917          	auipc	s2,0x2
      12:	ff293903          	ld	s2,-14(s2) # 2000 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	c1e080e7          	jalr	-994(ra) # c34 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0bc50513          	addi	a0,a0,188 # 10e0 <malloc+0xea>
      2c:	00001097          	auipc	ra,0x1
      30:	f12080e7          	jalr	-238(ra) # f3e <printf>
    exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b7e080e7          	jalr	-1154(ra) # bb4 <exit>

000000000000003e <_v1>:

//
// check the content of the two mapped pages.
//
void _v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4705                	li	a4,1
      48:	4781                	li	a5,0
    int i;
    for (i = 0; i < PGSIZE * 2; i++) {
        if (i < PGSIZE + (PGSIZE / 2)) {
      4a:	6685                	lui	a3,0x1
      4c:	7ff68693          	addi	a3,a3,2047 # 17ff <digits+0x20f>
    for (i = 0; i < PGSIZE * 2; i++) {
      50:	6889                	lui	a7,0x2
            if (p[i] != 'A') {
      52:	04100813          	li	a6,65
      56:	a819                	j	6c <_v1+0x2e>
                printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
                err("v1 mismatch (1)");
            }
        }
        else {
            if (p[i] != 0) {
      58:	00054603          	lbu	a2,0(a0)
      5c:	e221                	bnez	a2,9c <_v1+0x5e>
    for (i = 0; i < PGSIZE * 2; i++) {
      5e:	0007061b          	sext.w	a2,a4
      62:	05165d63          	bge	a2,a7,bc <_v1+0x7e>
      66:	2785                	addiw	a5,a5,1
      68:	2705                	addiw	a4,a4,1
      6a:	0505                	addi	a0,a0,1
      6c:	0007859b          	sext.w	a1,a5
        if (i < PGSIZE + (PGSIZE / 2)) {
      70:	feb6c4e3          	blt	a3,a1,58 <_v1+0x1a>
            if (p[i] != 'A') {
      74:	00054603          	lbu	a2,0(a0)
      78:	ff0607e3          	beq	a2,a6,66 <_v1+0x28>
                printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7c:	00001517          	auipc	a0,0x1
      80:	08c50513          	addi	a0,a0,140 # 1108 <malloc+0x112>
      84:	00001097          	auipc	ra,0x1
      88:	eba080e7          	jalr	-326(ra) # f3e <printf>
                err("v1 mismatch (1)");
      8c:	00001517          	auipc	a0,0x1
      90:	0a450513          	addi	a0,a0,164 # 1130 <malloc+0x13a>
      94:	00000097          	auipc	ra,0x0
      98:	f6c080e7          	jalr	-148(ra) # 0 <err>
                printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9c:	00001517          	auipc	a0,0x1
      a0:	0a450513          	addi	a0,a0,164 # 1140 <malloc+0x14a>
      a4:	00001097          	auipc	ra,0x1
      a8:	e9a080e7          	jalr	-358(ra) # f3e <printf>
                err("v1 mismatch (2)");
      ac:	00001517          	auipc	a0,0x1
      b0:	0bc50513          	addi	a0,a0,188 # 1168 <malloc+0x172>
      b4:	00000097          	auipc	ra,0x0
      b8:	f4c080e7          	jalr	-180(ra) # 0 <err>
            }
        }
    }
}
      bc:	60a2                	ld	ra,8(sp)
      be:	6402                	ld	s0,0(sp)
      c0:	0141                	addi	sp,sp,16
      c2:	8082                	ret

00000000000000c4 <makefile>:
//
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void makefile(const char *f)
{
      c4:	7179                	addi	sp,sp,-48
      c6:	f406                	sd	ra,40(sp)
      c8:	f022                	sd	s0,32(sp)
      ca:	ec26                	sd	s1,24(sp)
      cc:	e84a                	sd	s2,16(sp)
      ce:	e44e                	sd	s3,8(sp)
      d0:	1800                	addi	s0,sp,48
      d2:	84aa                	mv	s1,a0
    int i;
    int n = PGSIZE / BSIZE;

    unlink(f);
      d4:	00001097          	auipc	ra,0x1
      d8:	b30080e7          	jalr	-1232(ra) # c04 <unlink>
    int fd = open(f, O_WRONLY | O_CREATE);
      dc:	20100593          	li	a1,513
      e0:	8526                	mv	a0,s1
      e2:	00001097          	auipc	ra,0x1
      e6:	b12080e7          	jalr	-1262(ra) # bf4 <open>
    if (fd == -1)
      ea:	57fd                	li	a5,-1
      ec:	06f50163          	beq	a0,a5,14e <makefile+0x8a>
      f0:	892a                	mv	s2,a0
        err("open");
    memset(buf, 'A', BSIZE);
      f2:	40000613          	li	a2,1024
      f6:	04100593          	li	a1,65
      fa:	00002517          	auipc	a0,0x2
      fe:	f2650513          	addi	a0,a0,-218 # 2020 <buf>
     102:	00001097          	auipc	ra,0x1
     106:	8b8080e7          	jalr	-1864(ra) # 9ba <memset>
     10a:	4499                	li	s1,6
    // write 1.5 page
    for (i = 0; i < n + n / 2; i++) {
        if (write(fd, buf, BSIZE) != BSIZE)
     10c:	00002997          	auipc	s3,0x2
     110:	f1498993          	addi	s3,s3,-236 # 2020 <buf>
     114:	40000613          	li	a2,1024
     118:	85ce                	mv	a1,s3
     11a:	854a                	mv	a0,s2
     11c:	00001097          	auipc	ra,0x1
     120:	ab8080e7          	jalr	-1352(ra) # bd4 <write>
     124:	40000793          	li	a5,1024
     128:	02f51b63          	bne	a0,a5,15e <makefile+0x9a>
    for (i = 0; i < n + n / 2; i++) {
     12c:	34fd                	addiw	s1,s1,-1
     12e:	f0fd                	bnez	s1,114 <makefile+0x50>
            err("write 0 makefile");
    }
    if (close(fd) == -1)
     130:	854a                	mv	a0,s2
     132:	00001097          	auipc	ra,0x1
     136:	aaa080e7          	jalr	-1366(ra) # bdc <close>
     13a:	57fd                	li	a5,-1
     13c:	02f50963          	beq	a0,a5,16e <makefile+0xaa>
        err("close");
}
     140:	70a2                	ld	ra,40(sp)
     142:	7402                	ld	s0,32(sp)
     144:	64e2                	ld	s1,24(sp)
     146:	6942                	ld	s2,16(sp)
     148:	69a2                	ld	s3,8(sp)
     14a:	6145                	addi	sp,sp,48
     14c:	8082                	ret
        err("open");
     14e:	00001517          	auipc	a0,0x1
     152:	02a50513          	addi	a0,a0,42 # 1178 <malloc+0x182>
     156:	00000097          	auipc	ra,0x0
     15a:	eaa080e7          	jalr	-342(ra) # 0 <err>
            err("write 0 makefile");
     15e:	00001517          	auipc	a0,0x1
     162:	02250513          	addi	a0,a0,34 # 1180 <malloc+0x18a>
     166:	00000097          	auipc	ra,0x0
     16a:	e9a080e7          	jalr	-358(ra) # 0 <err>
        err("close");
     16e:	00001517          	auipc	a0,0x1
     172:	02a50513          	addi	a0,a0,42 # 1198 <malloc+0x1a2>
     176:	00000097          	auipc	ra,0x0
     17a:	e8a080e7          	jalr	-374(ra) # 0 <err>

000000000000017e <mmap_test>:

void mmap_test(void)
{
     17e:	7139                	addi	sp,sp,-64
     180:	fc06                	sd	ra,56(sp)
     182:	f822                	sd	s0,48(sp)
     184:	f426                	sd	s1,40(sp)
     186:	f04a                	sd	s2,32(sp)
     188:	ec4e                	sd	s3,24(sp)
     18a:	e852                	sd	s4,16(sp)
     18c:	0080                	addi	s0,sp,64
    int fd;
    int i;
    const char *const f = "mmap.dur";
    printf("mmap_test starting\n");
     18e:	00001517          	auipc	a0,0x1
     192:	01250513          	addi	a0,a0,18 # 11a0 <malloc+0x1aa>
     196:	00001097          	auipc	ra,0x1
     19a:	da8080e7          	jalr	-600(ra) # f3e <printf>
    testname = "mmap_test";
     19e:	00001797          	auipc	a5,0x1
     1a2:	01a78793          	addi	a5,a5,26 # 11b8 <malloc+0x1c2>
     1a6:	00002717          	auipc	a4,0x2
     1aa:	e4f73d23          	sd	a5,-422(a4) # 2000 <testname>
    //
    // create a file with known content, map it into memory, check that
    // the mapped memory has the same bytes as originally written to the
    // file.
    //
    makefile(f);
     1ae:	00001517          	auipc	a0,0x1
     1b2:	01a50513          	addi	a0,a0,26 # 11c8 <malloc+0x1d2>
     1b6:	00000097          	auipc	ra,0x0
     1ba:	f0e080e7          	jalr	-242(ra) # c4 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     1be:	4581                	li	a1,0
     1c0:	00001517          	auipc	a0,0x1
     1c4:	00850513          	addi	a0,a0,8 # 11c8 <malloc+0x1d2>
     1c8:	00001097          	auipc	ra,0x1
     1cc:	a2c080e7          	jalr	-1492(ra) # bf4 <open>
     1d0:	57fd                	li	a5,-1
     1d2:	3ef50663          	beq	a0,a5,5be <mmap_test+0x440>
     1d6:	892a                	mv	s2,a0
        err("open");

    printf("test mmap f\n");
     1d8:	00001517          	auipc	a0,0x1
     1dc:	00050513          	mv	a0,a0
     1e0:	00001097          	auipc	ra,0x1
     1e4:	d5e080e7          	jalr	-674(ra) # f3e <printf>
    // same file (of course in this case updates are prohibited
    // due to PROT_READ). the fifth argument is the file descriptor
    // of the file to be mapped. the last argument is the starting
    // offset in the file.
    //
    char *p = mmap(0, PGSIZE * 2, PROT_READ, MAP_PRIVATE, fd, 0);
     1e8:	4781                	li	a5,0
     1ea:	874a                	mv	a4,s2
     1ec:	4689                	li	a3,2
     1ee:	4605                	li	a2,1
     1f0:	6589                	lui	a1,0x2
     1f2:	4501                	li	a0,0
     1f4:	00001097          	auipc	ra,0x1
     1f8:	a60080e7          	jalr	-1440(ra) # c54 <mmap>
     1fc:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     1fe:	57fd                	li	a5,-1
     200:	3cf50763          	beq	a0,a5,5ce <mmap_test+0x450>
        err("mmap (1)");
    _v1(p);
     204:	00000097          	auipc	ra,0x0
     208:	e3a080e7          	jalr	-454(ra) # 3e <_v1>
    if (munmap(p, PGSIZE * 2) == -1)
     20c:	6589                	lui	a1,0x2
     20e:	8526                	mv	a0,s1
     210:	00001097          	auipc	ra,0x1
     214:	a4c080e7          	jalr	-1460(ra) # c5c <munmap>
     218:	57fd                	li	a5,-1
     21a:	3cf50263          	beq	a0,a5,5de <mmap_test+0x460>
        err("munmap (1)");
    printf("test mmap f: OK\n");
     21e:	00001517          	auipc	a0,0x1
     222:	fea50513          	addi	a0,a0,-22 # 1208 <malloc+0x212>
     226:	00001097          	auipc	ra,0x1
     22a:	d18080e7          	jalr	-744(ra) # f3e <printf>

    printf("test mmap private\n");
     22e:	00001517          	auipc	a0,0x1
     232:	ff250513          	addi	a0,a0,-14 # 1220 <malloc+0x22a>
     236:	00001097          	auipc	ra,0x1
     23a:	d08080e7          	jalr	-760(ra) # f3e <printf>
    // should be able to map file opened read-only with private writable
    // mapping
    p = mmap(0, PGSIZE * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     23e:	4781                	li	a5,0
     240:	874a                	mv	a4,s2
     242:	4689                	li	a3,2
     244:	460d                	li	a2,3
     246:	6589                	lui	a1,0x2
     248:	4501                	li	a0,0
     24a:	00001097          	auipc	ra,0x1
     24e:	a0a080e7          	jalr	-1526(ra) # c54 <mmap>
     252:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     254:	57fd                	li	a5,-1
     256:	38f50c63          	beq	a0,a5,5ee <mmap_test+0x470>
        err("mmap (2)");
    if (close(fd) == -1)
     25a:	854a                	mv	a0,s2
     25c:	00001097          	auipc	ra,0x1
     260:	980080e7          	jalr	-1664(ra) # bdc <close>
     264:	57fd                	li	a5,-1
     266:	38f50c63          	beq	a0,a5,5fe <mmap_test+0x480>
        err("close");
    _v1(p);
     26a:	8526                	mv	a0,s1
     26c:	00000097          	auipc	ra,0x0
     270:	dd2080e7          	jalr	-558(ra) # 3e <_v1>
    for (i = 0; i < PGSIZE * 2; i++)
     274:	87a6                	mv	a5,s1
     276:	6709                	lui	a4,0x2
     278:	9726                	add	a4,a4,s1
        p[i] = 'Z';
     27a:	05a00693          	li	a3,90
     27e:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     282:	0785                	addi	a5,a5,1
     284:	fef71de3          	bne	a4,a5,27e <mmap_test+0x100>
    if (munmap(p, PGSIZE * 2) == -1)
     288:	6589                	lui	a1,0x2
     28a:	8526                	mv	a0,s1
     28c:	00001097          	auipc	ra,0x1
     290:	9d0080e7          	jalr	-1584(ra) # c5c <munmap>
     294:	57fd                	li	a5,-1
     296:	36f50c63          	beq	a0,a5,60e <mmap_test+0x490>
        err("munmap (2)");

    printf("test mmap private: OK\n");
     29a:	00001517          	auipc	a0,0x1
     29e:	fbe50513          	addi	a0,a0,-66 # 1258 <malloc+0x262>
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c9c080e7          	jalr	-868(ra) # f3e <printf>

    printf("test mmap read-only\n");
     2aa:	00001517          	auipc	a0,0x1
     2ae:	fc650513          	addi	a0,a0,-58 # 1270 <malloc+0x27a>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	c8c080e7          	jalr	-884(ra) # f3e <printf>

    // check that mmap doesn't allow read/write mapping of a
    // file opened read-only.
    if ((fd = open(f, O_RDONLY)) == -1)
     2ba:	4581                	li	a1,0
     2bc:	00001517          	auipc	a0,0x1
     2c0:	f0c50513          	addi	a0,a0,-244 # 11c8 <malloc+0x1d2>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	930080e7          	jalr	-1744(ra) # bf4 <open>
     2cc:	84aa                	mv	s1,a0
     2ce:	57fd                	li	a5,-1
     2d0:	34f50763          	beq	a0,a5,61e <mmap_test+0x4a0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d4:	4781                	li	a5,0
     2d6:	872a                	mv	a4,a0
     2d8:	4685                	li	a3,1
     2da:	460d                	li	a2,3
     2dc:	658d                	lui	a1,0x3
     2de:	4501                	li	a0,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	974080e7          	jalr	-1676(ra) # c54 <mmap>
    if (p != MAP_FAILED)
     2e8:	57fd                	li	a5,-1
     2ea:	34f51263          	bne	a0,a5,62e <mmap_test+0x4b0>
        err("mmap call should have failed");
    if (close(fd) == -1)
     2ee:	8526                	mv	a0,s1
     2f0:	00001097          	auipc	ra,0x1
     2f4:	8ec080e7          	jalr	-1812(ra) # bdc <close>
     2f8:	57fd                	li	a5,-1
     2fa:	34f50263          	beq	a0,a5,63e <mmap_test+0x4c0>
        err("close");

    printf("test mmap read-only: OK\n");
     2fe:	00001517          	auipc	a0,0x1
     302:	faa50513          	addi	a0,a0,-86 # 12a8 <malloc+0x2b2>
     306:	00001097          	auipc	ra,0x1
     30a:	c38080e7          	jalr	-968(ra) # f3e <printf>

    printf("test mmap read/write\n");
     30e:	00001517          	auipc	a0,0x1
     312:	fba50513          	addi	a0,a0,-70 # 12c8 <malloc+0x2d2>
     316:	00001097          	auipc	ra,0x1
     31a:	c28080e7          	jalr	-984(ra) # f3e <printf>

    // check that mmap does allow read/write mapping of a
    // file opened read/write.
    if ((fd = open(f, O_RDWR)) == -1)
     31e:	4589                	li	a1,2
     320:	00001517          	auipc	a0,0x1
     324:	ea850513          	addi	a0,a0,-344 # 11c8 <malloc+0x1d2>
     328:	00001097          	auipc	ra,0x1
     32c:	8cc080e7          	jalr	-1844(ra) # bf4 <open>
     330:	84aa                	mv	s1,a0
     332:	57fd                	li	a5,-1
     334:	30f50d63          	beq	a0,a5,64e <mmap_test+0x4d0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     338:	4781                	li	a5,0
     33a:	872a                	mv	a4,a0
     33c:	4685                	li	a3,1
     33e:	460d                	li	a2,3
     340:	658d                	lui	a1,0x3
     342:	4501                	li	a0,0
     344:	00001097          	auipc	ra,0x1
     348:	910080e7          	jalr	-1776(ra) # c54 <mmap>
     34c:	89aa                	mv	s3,a0
    if (p == MAP_FAILED)
     34e:	57fd                	li	a5,-1
     350:	30f50763          	beq	a0,a5,65e <mmap_test+0x4e0>
        err("mmap (3)");
    if (close(fd) == -1)
     354:	8526                	mv	a0,s1
     356:	00001097          	auipc	ra,0x1
     35a:	886080e7          	jalr	-1914(ra) # bdc <close>
     35e:	57fd                	li	a5,-1
     360:	30f50763          	beq	a0,a5,66e <mmap_test+0x4f0>
        err("close");

    // check that the mapping still works after close(fd).
    _v1(p);
     364:	854e                	mv	a0,s3
     366:	00000097          	auipc	ra,0x0
     36a:	cd8080e7          	jalr	-808(ra) # 3e <_v1>

    // write the mapped memory.
    for (i = 0; i < PGSIZE * 2; i++)
     36e:	87ce                	mv	a5,s3
     370:	6709                	lui	a4,0x2
     372:	974e                	add	a4,a4,s3
        p[i] = 'Z';
     374:	05a00693          	li	a3,90
     378:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     37c:	0785                	addi	a5,a5,1
     37e:	fee79de3          	bne	a5,a4,378 <mmap_test+0x1fa>

    // unmap just the first two of three pages of mapped memory.
    if (munmap(p, PGSIZE * 2) == -1)
     382:	6589                	lui	a1,0x2
     384:	854e                	mv	a0,s3
     386:	00001097          	auipc	ra,0x1
     38a:	8d6080e7          	jalr	-1834(ra) # c5c <munmap>
     38e:	57fd                	li	a5,-1
     390:	2ef50763          	beq	a0,a5,67e <mmap_test+0x500>
        err("munmap (3)");

    printf("test mmap read/write: OK\n");
     394:	00001517          	auipc	a0,0x1
     398:	f6c50513          	addi	a0,a0,-148 # 1300 <malloc+0x30a>
     39c:	00001097          	auipc	ra,0x1
     3a0:	ba2080e7          	jalr	-1118(ra) # f3e <printf>

    printf("test mmap dirty\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	f7c50513          	addi	a0,a0,-132 # 1320 <malloc+0x32a>
     3ac:	00001097          	auipc	ra,0x1
     3b0:	b92080e7          	jalr	-1134(ra) # f3e <printf>

    // check that the writes to the mapped memory were
    // written to the file.
    if ((fd = open(f, O_RDWR)) == -1)
     3b4:	4589                	li	a1,2
     3b6:	00001517          	auipc	a0,0x1
     3ba:	e1250513          	addi	a0,a0,-494 # 11c8 <malloc+0x1d2>
     3be:	00001097          	auipc	ra,0x1
     3c2:	836080e7          	jalr	-1994(ra) # bf4 <open>
     3c6:	892a                	mv	s2,a0
     3c8:	57fd                	li	a5,-1
     3ca:	6489                	lui	s1,0x2
     3cc:	80048493          	addi	s1,s1,-2048 # 1800 <digits+0x210>
        err("open");
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++) {
        char b;
        if (read(fd, &b, 1) != 1)
            err("read (1)");
        if (b != 'Z')
     3d0:	05a00a13          	li	s4,90
    if ((fd = open(f, O_RDWR)) == -1)
     3d4:	2af50d63          	beq	a0,a5,68e <mmap_test+0x510>
        if (read(fd, &b, 1) != 1)
     3d8:	4605                	li	a2,1
     3da:	fcf40593          	addi	a1,s0,-49
     3de:	854a                	mv	a0,s2
     3e0:	00000097          	auipc	ra,0x0
     3e4:	7ec080e7          	jalr	2028(ra) # bcc <read>
     3e8:	4785                	li	a5,1
     3ea:	2af51a63          	bne	a0,a5,69e <mmap_test+0x520>
        if (b != 'Z')
     3ee:	fcf44783          	lbu	a5,-49(s0)
     3f2:	2b479e63          	bne	a5,s4,6ae <mmap_test+0x530>
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++) {
     3f6:	34fd                	addiw	s1,s1,-1
     3f8:	f0e5                	bnez	s1,3d8 <mmap_test+0x25a>
            err("file does not contain modifications");
    }
    if (close(fd) == -1)
     3fa:	854a                	mv	a0,s2
     3fc:	00000097          	auipc	ra,0x0
     400:	7e0080e7          	jalr	2016(ra) # bdc <close>
     404:	57fd                	li	a5,-1
     406:	2af50c63          	beq	a0,a5,6be <mmap_test+0x540>
        err("close");

    printf("test mmap dirty: OK\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f6650513          	addi	a0,a0,-154 # 1370 <malloc+0x37a>
     412:	00001097          	auipc	ra,0x1
     416:	b2c080e7          	jalr	-1236(ra) # f3e <printf>

    printf("test not-mapped unmap\n");
     41a:	00001517          	auipc	a0,0x1
     41e:	f6e50513          	addi	a0,a0,-146 # 1388 <malloc+0x392>
     422:	00001097          	auipc	ra,0x1
     426:	b1c080e7          	jalr	-1252(ra) # f3e <printf>

    // unmap the rest of the mapped memory.
    if (munmap(p + PGSIZE * 2, PGSIZE) == -1)
     42a:	6585                	lui	a1,0x1
     42c:	6509                	lui	a0,0x2
     42e:	954e                	add	a0,a0,s3
     430:	00001097          	auipc	ra,0x1
     434:	82c080e7          	jalr	-2004(ra) # c5c <munmap>
     438:	57fd                	li	a5,-1
     43a:	28f50a63          	beq	a0,a5,6ce <mmap_test+0x550>
        err("munmap (4)");

    printf("test not-mapped unmap: OK\n");
     43e:	00001517          	auipc	a0,0x1
     442:	f7250513          	addi	a0,a0,-142 # 13b0 <malloc+0x3ba>
     446:	00001097          	auipc	ra,0x1
     44a:	af8080e7          	jalr	-1288(ra) # f3e <printf>

    printf("test mmap two files\n");
     44e:	00001517          	auipc	a0,0x1
     452:	f8250513          	addi	a0,a0,-126 # 13d0 <malloc+0x3da>
     456:	00001097          	auipc	ra,0x1
     45a:	ae8080e7          	jalr	-1304(ra) # f3e <printf>

    //
    // mmap two files at the same time.
    //
    int fd1;
    if ((fd1 = open("mmap1", O_RDWR | O_CREATE)) < 0)
     45e:	20200593          	li	a1,514
     462:	00001517          	auipc	a0,0x1
     466:	f8650513          	addi	a0,a0,-122 # 13e8 <malloc+0x3f2>
     46a:	00000097          	auipc	ra,0x0
     46e:	78a080e7          	jalr	1930(ra) # bf4 <open>
     472:	84aa                	mv	s1,a0
     474:	26054563          	bltz	a0,6de <mmap_test+0x560>
        err("open mmap1");
    if (write(fd1, "12345", 5) != 5)
     478:	4615                	li	a2,5
     47a:	00001597          	auipc	a1,0x1
     47e:	f8658593          	addi	a1,a1,-122 # 1400 <malloc+0x40a>
     482:	00000097          	auipc	ra,0x0
     486:	752080e7          	jalr	1874(ra) # bd4 <write>
     48a:	4795                	li	a5,5
     48c:	26f51163          	bne	a0,a5,6ee <mmap_test+0x570>
        err("write mmap1");
    char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     490:	4781                	li	a5,0
     492:	8726                	mv	a4,s1
     494:	4689                	li	a3,2
     496:	4605                	li	a2,1
     498:	6585                	lui	a1,0x1
     49a:	4501                	li	a0,0
     49c:	00000097          	auipc	ra,0x0
     4a0:	7b8080e7          	jalr	1976(ra) # c54 <mmap>
     4a4:	89aa                	mv	s3,a0
    if (p1 == MAP_FAILED)
     4a6:	57fd                	li	a5,-1
     4a8:	24f50b63          	beq	a0,a5,6fe <mmap_test+0x580>
        err("mmap mmap1");
    close(fd1);
     4ac:	8526                	mv	a0,s1
     4ae:	00000097          	auipc	ra,0x0
     4b2:	72e080e7          	jalr	1838(ra) # bdc <close>
    unlink("mmap1");
     4b6:	00001517          	auipc	a0,0x1
     4ba:	f3250513          	addi	a0,a0,-206 # 13e8 <malloc+0x3f2>
     4be:	00000097          	auipc	ra,0x0
     4c2:	746080e7          	jalr	1862(ra) # c04 <unlink>

    int fd2;
    if ((fd2 = open("mmap2", O_RDWR | O_CREATE)) < 0)
     4c6:	20200593          	li	a1,514
     4ca:	00001517          	auipc	a0,0x1
     4ce:	f5e50513          	addi	a0,a0,-162 # 1428 <malloc+0x432>
     4d2:	00000097          	auipc	ra,0x0
     4d6:	722080e7          	jalr	1826(ra) # bf4 <open>
     4da:	892a                	mv	s2,a0
     4dc:	22054963          	bltz	a0,70e <mmap_test+0x590>
        err("open mmap2");
    if (write(fd2, "67890", 5) != 5)
     4e0:	4615                	li	a2,5
     4e2:	00001597          	auipc	a1,0x1
     4e6:	f5e58593          	addi	a1,a1,-162 # 1440 <malloc+0x44a>
     4ea:	00000097          	auipc	ra,0x0
     4ee:	6ea080e7          	jalr	1770(ra) # bd4 <write>
     4f2:	4795                	li	a5,5
     4f4:	22f51563          	bne	a0,a5,71e <mmap_test+0x5a0>
        err("write mmap2");
    char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4f8:	4781                	li	a5,0
     4fa:	874a                	mv	a4,s2
     4fc:	4689                	li	a3,2
     4fe:	4605                	li	a2,1
     500:	6585                	lui	a1,0x1
     502:	4501                	li	a0,0
     504:	00000097          	auipc	ra,0x0
     508:	750080e7          	jalr	1872(ra) # c54 <mmap>
     50c:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     50e:	57fd                	li	a5,-1
     510:	20f50f63          	beq	a0,a5,72e <mmap_test+0x5b0>
        err("mmap mmap2");
    close(fd2);
     514:	854a                	mv	a0,s2
     516:	00000097          	auipc	ra,0x0
     51a:	6c6080e7          	jalr	1734(ra) # bdc <close>
    unlink("mmap2");
     51e:	00001517          	auipc	a0,0x1
     522:	f0a50513          	addi	a0,a0,-246 # 1428 <malloc+0x432>
     526:	00000097          	auipc	ra,0x0
     52a:	6de080e7          	jalr	1758(ra) # c04 <unlink>

    if (memcmp(p1, "12345", 5) != 0)
     52e:	4615                	li	a2,5
     530:	00001597          	auipc	a1,0x1
     534:	ed058593          	addi	a1,a1,-304 # 1400 <malloc+0x40a>
     538:	854e                	mv	a0,s3
     53a:	00000097          	auipc	ra,0x0
     53e:	620080e7          	jalr	1568(ra) # b5a <memcmp>
     542:	1e051e63          	bnez	a0,73e <mmap_test+0x5c0>
        err("mmap1 mismatch");
    if (memcmp(p2, "67890", 5) != 0)
     546:	4615                	li	a2,5
     548:	00001597          	auipc	a1,0x1
     54c:	ef858593          	addi	a1,a1,-264 # 1440 <malloc+0x44a>
     550:	8526                	mv	a0,s1
     552:	00000097          	auipc	ra,0x0
     556:	608080e7          	jalr	1544(ra) # b5a <memcmp>
     55a:	1e051a63          	bnez	a0,74e <mmap_test+0x5d0>
        err("mmap2 mismatch");

    munmap(p1, PGSIZE);
     55e:	6585                	lui	a1,0x1
     560:	854e                	mv	a0,s3
     562:	00000097          	auipc	ra,0x0
     566:	6fa080e7          	jalr	1786(ra) # c5c <munmap>
    if (memcmp(p2, "67890", 5) != 0)
     56a:	4615                	li	a2,5
     56c:	00001597          	auipc	a1,0x1
     570:	ed458593          	addi	a1,a1,-300 # 1440 <malloc+0x44a>
     574:	8526                	mv	a0,s1
     576:	00000097          	auipc	ra,0x0
     57a:	5e4080e7          	jalr	1508(ra) # b5a <memcmp>
     57e:	1e051063          	bnez	a0,75e <mmap_test+0x5e0>
        err("mmap2 mismatch (2)");
    munmap(p2, PGSIZE);
     582:	6585                	lui	a1,0x1
     584:	8526                	mv	a0,s1
     586:	00000097          	auipc	ra,0x0
     58a:	6d6080e7          	jalr	1750(ra) # c5c <munmap>

    printf("test mmap two files: OK\n");
     58e:	00001517          	auipc	a0,0x1
     592:	f1250513          	addi	a0,a0,-238 # 14a0 <malloc+0x4aa>
     596:	00001097          	auipc	ra,0x1
     59a:	9a8080e7          	jalr	-1624(ra) # f3e <printf>

    printf("mmap_test: ALL OK\n");
     59e:	00001517          	auipc	a0,0x1
     5a2:	f2250513          	addi	a0,a0,-222 # 14c0 <malloc+0x4ca>
     5a6:	00001097          	auipc	ra,0x1
     5aa:	998080e7          	jalr	-1640(ra) # f3e <printf>
}
     5ae:	70e2                	ld	ra,56(sp)
     5b0:	7442                	ld	s0,48(sp)
     5b2:	74a2                	ld	s1,40(sp)
     5b4:	7902                	ld	s2,32(sp)
     5b6:	69e2                	ld	s3,24(sp)
     5b8:	6a42                	ld	s4,16(sp)
     5ba:	6121                	addi	sp,sp,64
     5bc:	8082                	ret
        err("open");
     5be:	00001517          	auipc	a0,0x1
     5c2:	bba50513          	addi	a0,a0,-1094 # 1178 <malloc+0x182>
     5c6:	00000097          	auipc	ra,0x0
     5ca:	a3a080e7          	jalr	-1478(ra) # 0 <err>
        err("mmap (1)");
     5ce:	00001517          	auipc	a0,0x1
     5d2:	c1a50513          	addi	a0,a0,-998 # 11e8 <malloc+0x1f2>
     5d6:	00000097          	auipc	ra,0x0
     5da:	a2a080e7          	jalr	-1494(ra) # 0 <err>
        err("munmap (1)");
     5de:	00001517          	auipc	a0,0x1
     5e2:	c1a50513          	addi	a0,a0,-998 # 11f8 <malloc+0x202>
     5e6:	00000097          	auipc	ra,0x0
     5ea:	a1a080e7          	jalr	-1510(ra) # 0 <err>
        err("mmap (2)");
     5ee:	00001517          	auipc	a0,0x1
     5f2:	c4a50513          	addi	a0,a0,-950 # 1238 <malloc+0x242>
     5f6:	00000097          	auipc	ra,0x0
     5fa:	a0a080e7          	jalr	-1526(ra) # 0 <err>
        err("close");
     5fe:	00001517          	auipc	a0,0x1
     602:	b9a50513          	addi	a0,a0,-1126 # 1198 <malloc+0x1a2>
     606:	00000097          	auipc	ra,0x0
     60a:	9fa080e7          	jalr	-1542(ra) # 0 <err>
        err("munmap (2)");
     60e:	00001517          	auipc	a0,0x1
     612:	c3a50513          	addi	a0,a0,-966 # 1248 <malloc+0x252>
     616:	00000097          	auipc	ra,0x0
     61a:	9ea080e7          	jalr	-1558(ra) # 0 <err>
        err("open");
     61e:	00001517          	auipc	a0,0x1
     622:	b5a50513          	addi	a0,a0,-1190 # 1178 <malloc+0x182>
     626:	00000097          	auipc	ra,0x0
     62a:	9da080e7          	jalr	-1574(ra) # 0 <err>
        err("mmap call should have failed");
     62e:	00001517          	auipc	a0,0x1
     632:	c5a50513          	addi	a0,a0,-934 # 1288 <malloc+0x292>
     636:	00000097          	auipc	ra,0x0
     63a:	9ca080e7          	jalr	-1590(ra) # 0 <err>
        err("close");
     63e:	00001517          	auipc	a0,0x1
     642:	b5a50513          	addi	a0,a0,-1190 # 1198 <malloc+0x1a2>
     646:	00000097          	auipc	ra,0x0
     64a:	9ba080e7          	jalr	-1606(ra) # 0 <err>
        err("open");
     64e:	00001517          	auipc	a0,0x1
     652:	b2a50513          	addi	a0,a0,-1238 # 1178 <malloc+0x182>
     656:	00000097          	auipc	ra,0x0
     65a:	9aa080e7          	jalr	-1622(ra) # 0 <err>
        err("mmap (3)");
     65e:	00001517          	auipc	a0,0x1
     662:	c8250513          	addi	a0,a0,-894 # 12e0 <malloc+0x2ea>
     666:	00000097          	auipc	ra,0x0
     66a:	99a080e7          	jalr	-1638(ra) # 0 <err>
        err("close");
     66e:	00001517          	auipc	a0,0x1
     672:	b2a50513          	addi	a0,a0,-1238 # 1198 <malloc+0x1a2>
     676:	00000097          	auipc	ra,0x0
     67a:	98a080e7          	jalr	-1654(ra) # 0 <err>
        err("munmap (3)");
     67e:	00001517          	auipc	a0,0x1
     682:	c7250513          	addi	a0,a0,-910 # 12f0 <malloc+0x2fa>
     686:	00000097          	auipc	ra,0x0
     68a:	97a080e7          	jalr	-1670(ra) # 0 <err>
        err("open");
     68e:	00001517          	auipc	a0,0x1
     692:	aea50513          	addi	a0,a0,-1302 # 1178 <malloc+0x182>
     696:	00000097          	auipc	ra,0x0
     69a:	96a080e7          	jalr	-1686(ra) # 0 <err>
            err("read (1)");
     69e:	00001517          	auipc	a0,0x1
     6a2:	c9a50513          	addi	a0,a0,-870 # 1338 <malloc+0x342>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	95a080e7          	jalr	-1702(ra) # 0 <err>
            err("file does not contain modifications");
     6ae:	00001517          	auipc	a0,0x1
     6b2:	c9a50513          	addi	a0,a0,-870 # 1348 <malloc+0x352>
     6b6:	00000097          	auipc	ra,0x0
     6ba:	94a080e7          	jalr	-1718(ra) # 0 <err>
        err("close");
     6be:	00001517          	auipc	a0,0x1
     6c2:	ada50513          	addi	a0,a0,-1318 # 1198 <malloc+0x1a2>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	93a080e7          	jalr	-1734(ra) # 0 <err>
        err("munmap (4)");
     6ce:	00001517          	auipc	a0,0x1
     6d2:	cd250513          	addi	a0,a0,-814 # 13a0 <malloc+0x3aa>
     6d6:	00000097          	auipc	ra,0x0
     6da:	92a080e7          	jalr	-1750(ra) # 0 <err>
        err("open mmap1");
     6de:	00001517          	auipc	a0,0x1
     6e2:	d1250513          	addi	a0,a0,-750 # 13f0 <malloc+0x3fa>
     6e6:	00000097          	auipc	ra,0x0
     6ea:	91a080e7          	jalr	-1766(ra) # 0 <err>
        err("write mmap1");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	d1a50513          	addi	a0,a0,-742 # 1408 <malloc+0x412>
     6f6:	00000097          	auipc	ra,0x0
     6fa:	90a080e7          	jalr	-1782(ra) # 0 <err>
        err("mmap mmap1");
     6fe:	00001517          	auipc	a0,0x1
     702:	d1a50513          	addi	a0,a0,-742 # 1418 <malloc+0x422>
     706:	00000097          	auipc	ra,0x0
     70a:	8fa080e7          	jalr	-1798(ra) # 0 <err>
        err("open mmap2");
     70e:	00001517          	auipc	a0,0x1
     712:	d2250513          	addi	a0,a0,-734 # 1430 <malloc+0x43a>
     716:	00000097          	auipc	ra,0x0
     71a:	8ea080e7          	jalr	-1814(ra) # 0 <err>
        err("write mmap2");
     71e:	00001517          	auipc	a0,0x1
     722:	d2a50513          	addi	a0,a0,-726 # 1448 <malloc+0x452>
     726:	00000097          	auipc	ra,0x0
     72a:	8da080e7          	jalr	-1830(ra) # 0 <err>
        err("mmap mmap2");
     72e:	00001517          	auipc	a0,0x1
     732:	d2a50513          	addi	a0,a0,-726 # 1458 <malloc+0x462>
     736:	00000097          	auipc	ra,0x0
     73a:	8ca080e7          	jalr	-1846(ra) # 0 <err>
        err("mmap1 mismatch");
     73e:	00001517          	auipc	a0,0x1
     742:	d2a50513          	addi	a0,a0,-726 # 1468 <malloc+0x472>
     746:	00000097          	auipc	ra,0x0
     74a:	8ba080e7          	jalr	-1862(ra) # 0 <err>
        err("mmap2 mismatch");
     74e:	00001517          	auipc	a0,0x1
     752:	d2a50513          	addi	a0,a0,-726 # 1478 <malloc+0x482>
     756:	00000097          	auipc	ra,0x0
     75a:	8aa080e7          	jalr	-1878(ra) # 0 <err>
        err("mmap2 mismatch (2)");
     75e:	00001517          	auipc	a0,0x1
     762:	d2a50513          	addi	a0,a0,-726 # 1488 <malloc+0x492>
     766:	00000097          	auipc	ra,0x0
     76a:	89a080e7          	jalr	-1894(ra) # 0 <err>

000000000000076e <fork_test>:
//
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void fork_test(void)
{
     76e:	7179                	addi	sp,sp,-48
     770:	f406                	sd	ra,40(sp)
     772:	f022                	sd	s0,32(sp)
     774:	ec26                	sd	s1,24(sp)
     776:	e84a                	sd	s2,16(sp)
     778:	1800                	addi	s0,sp,48
    int fd;
    int pid;
    const char *const f = "mmap.dur";

    printf("fork_test starting\n");
     77a:	00001517          	auipc	a0,0x1
     77e:	d5e50513          	addi	a0,a0,-674 # 14d8 <malloc+0x4e2>
     782:	00000097          	auipc	ra,0x0
     786:	7bc080e7          	jalr	1980(ra) # f3e <printf>
    testname = "fork_test";
     78a:	00001797          	auipc	a5,0x1
     78e:	d6678793          	addi	a5,a5,-666 # 14f0 <malloc+0x4fa>
     792:	00002717          	auipc	a4,0x2
     796:	86f73723          	sd	a5,-1938(a4) # 2000 <testname>

    // mmap the file twice.
    makefile(f);
     79a:	00001517          	auipc	a0,0x1
     79e:	a2e50513          	addi	a0,a0,-1490 # 11c8 <malloc+0x1d2>
     7a2:	00000097          	auipc	ra,0x0
     7a6:	922080e7          	jalr	-1758(ra) # c4 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     7aa:	4581                	li	a1,0
     7ac:	00001517          	auipc	a0,0x1
     7b0:	a1c50513          	addi	a0,a0,-1508 # 11c8 <malloc+0x1d2>
     7b4:	00000097          	auipc	ra,0x0
     7b8:	440080e7          	jalr	1088(ra) # bf4 <open>
     7bc:	57fd                	li	a5,-1
     7be:	0af50a63          	beq	a0,a5,872 <fork_test+0x104>
     7c2:	84aa                	mv	s1,a0
        err("open");
    unlink(f);
     7c4:	00001517          	auipc	a0,0x1
     7c8:	a0450513          	addi	a0,a0,-1532 # 11c8 <malloc+0x1d2>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	438080e7          	jalr	1080(ra) # c04 <unlink>
    char *p1 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     7d4:	4781                	li	a5,0
     7d6:	8726                	mv	a4,s1
     7d8:	4685                	li	a3,1
     7da:	4605                	li	a2,1
     7dc:	6589                	lui	a1,0x2
     7de:	4501                	li	a0,0
     7e0:	00000097          	auipc	ra,0x0
     7e4:	474080e7          	jalr	1140(ra) # c54 <mmap>
     7e8:	892a                	mv	s2,a0
    if (p1 == MAP_FAILED)
     7ea:	57fd                	li	a5,-1
     7ec:	08f50b63          	beq	a0,a5,882 <fork_test+0x114>
        err("mmap (4)");
    char *p2 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     7f0:	4781                	li	a5,0
     7f2:	8726                	mv	a4,s1
     7f4:	4685                	li	a3,1
     7f6:	4605                	li	a2,1
     7f8:	6589                	lui	a1,0x2
     7fa:	4501                	li	a0,0
     7fc:	00000097          	auipc	ra,0x0
     800:	458080e7          	jalr	1112(ra) # c54 <mmap>
     804:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     806:	57fd                	li	a5,-1
     808:	08f50563          	beq	a0,a5,892 <fork_test+0x124>
        err("mmap (5)");

    // read just 2nd page.
    if (*(p1 + PGSIZE) != 'A')
     80c:	6785                	lui	a5,0x1
     80e:	97ca                	add	a5,a5,s2
     810:	0007c703          	lbu	a4,0(a5) # 1000 <malloc+0xa>
     814:	04100793          	li	a5,65
     818:	08f71563          	bne	a4,a5,8a2 <fork_test+0x134>
        err("fork mismatch (1)");

    if ((pid = fork()) < 0)
     81c:	00000097          	auipc	ra,0x0
     820:	390080e7          	jalr	912(ra) # bac <fork>
     824:	08054763          	bltz	a0,8b2 <fork_test+0x144>
        err("fork");
    if (pid == 0) {
     828:	cd49                	beqz	a0,8c2 <fork_test+0x154>
        _v1(p1);
        munmap(p1, PGSIZE); // just the first page
        exit(0);            // tell the parent that the mapping looks OK.
    }

    int status = -1;
     82a:	57fd                	li	a5,-1
     82c:	fcf42e23          	sw	a5,-36(s0)
    wait(&status);
     830:	fdc40513          	addi	a0,s0,-36
     834:	00000097          	auipc	ra,0x0
     838:	388080e7          	jalr	904(ra) # bbc <wait>

    if (status != 0) {
     83c:	fdc42783          	lw	a5,-36(s0)
     840:	e3cd                	bnez	a5,8e2 <fork_test+0x174>
        printf("fork_test failed\n");
        exit(1);
    }

    // check that the parent's mappings are still there.
    _v1(p1);
     842:	854a                	mv	a0,s2
     844:	fffff097          	auipc	ra,0xfffff
     848:	7fa080e7          	jalr	2042(ra) # 3e <_v1>
    _v1(p2);
     84c:	8526                	mv	a0,s1
     84e:	fffff097          	auipc	ra,0xfffff
     852:	7f0080e7          	jalr	2032(ra) # 3e <_v1>

    printf("fork_test OK\n");
     856:	00001517          	auipc	a0,0x1
     85a:	d0250513          	addi	a0,a0,-766 # 1558 <malloc+0x562>
     85e:	00000097          	auipc	ra,0x0
     862:	6e0080e7          	jalr	1760(ra) # f3e <printf>
}
     866:	70a2                	ld	ra,40(sp)
     868:	7402                	ld	s0,32(sp)
     86a:	64e2                	ld	s1,24(sp)
     86c:	6942                	ld	s2,16(sp)
     86e:	6145                	addi	sp,sp,48
     870:	8082                	ret
        err("open");
     872:	00001517          	auipc	a0,0x1
     876:	90650513          	addi	a0,a0,-1786 # 1178 <malloc+0x182>
     87a:	fffff097          	auipc	ra,0xfffff
     87e:	786080e7          	jalr	1926(ra) # 0 <err>
        err("mmap (4)");
     882:	00001517          	auipc	a0,0x1
     886:	c7e50513          	addi	a0,a0,-898 # 1500 <malloc+0x50a>
     88a:	fffff097          	auipc	ra,0xfffff
     88e:	776080e7          	jalr	1910(ra) # 0 <err>
        err("mmap (5)");
     892:	00001517          	auipc	a0,0x1
     896:	c7e50513          	addi	a0,a0,-898 # 1510 <malloc+0x51a>
     89a:	fffff097          	auipc	ra,0xfffff
     89e:	766080e7          	jalr	1894(ra) # 0 <err>
        err("fork mismatch (1)");
     8a2:	00001517          	auipc	a0,0x1
     8a6:	c7e50513          	addi	a0,a0,-898 # 1520 <malloc+0x52a>
     8aa:	fffff097          	auipc	ra,0xfffff
     8ae:	756080e7          	jalr	1878(ra) # 0 <err>
        err("fork");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	c8650513          	addi	a0,a0,-890 # 1538 <malloc+0x542>
     8ba:	fffff097          	auipc	ra,0xfffff
     8be:	746080e7          	jalr	1862(ra) # 0 <err>
        _v1(p1);
     8c2:	854a                	mv	a0,s2
     8c4:	fffff097          	auipc	ra,0xfffff
     8c8:	77a080e7          	jalr	1914(ra) # 3e <_v1>
        munmap(p1, PGSIZE); // just the first page
     8cc:	6585                	lui	a1,0x1
     8ce:	854a                	mv	a0,s2
     8d0:	00000097          	auipc	ra,0x0
     8d4:	38c080e7          	jalr	908(ra) # c5c <munmap>
        exit(0);            // tell the parent that the mapping looks OK.
     8d8:	4501                	li	a0,0
     8da:	00000097          	auipc	ra,0x0
     8de:	2da080e7          	jalr	730(ra) # bb4 <exit>
        printf("fork_test failed\n");
     8e2:	00001517          	auipc	a0,0x1
     8e6:	c5e50513          	addi	a0,a0,-930 # 1540 <malloc+0x54a>
     8ea:	00000097          	auipc	ra,0x0
     8ee:	654080e7          	jalr	1620(ra) # f3e <printf>
        exit(1);
     8f2:	4505                	li	a0,1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	2c0080e7          	jalr	704(ra) # bb4 <exit>

00000000000008fc <main>:
{
     8fc:	1141                	addi	sp,sp,-16
     8fe:	e406                	sd	ra,8(sp)
     900:	e022                	sd	s0,0(sp)
     902:	0800                	addi	s0,sp,16
    mmap_test();
     904:	00000097          	auipc	ra,0x0
     908:	87a080e7          	jalr	-1926(ra) # 17e <mmap_test>
    fork_test();
     90c:	00000097          	auipc	ra,0x0
     910:	e62080e7          	jalr	-414(ra) # 76e <fork_test>
    printf("mmaptest: all tests succeeded\n");
     914:	00001517          	auipc	a0,0x1
     918:	c5450513          	addi	a0,a0,-940 # 1568 <malloc+0x572>
     91c:	00000097          	auipc	ra,0x0
     920:	622080e7          	jalr	1570(ra) # f3e <printf>
    exit(0);
     924:	4501                	li	a0,0
     926:	00000097          	auipc	ra,0x0
     92a:	28e080e7          	jalr	654(ra) # bb4 <exit>

000000000000092e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     92e:	1141                	addi	sp,sp,-16
     930:	e406                	sd	ra,8(sp)
     932:	e022                	sd	s0,0(sp)
     934:	0800                	addi	s0,sp,16
  extern int main();
  main();
     936:	00000097          	auipc	ra,0x0
     93a:	fc6080e7          	jalr	-58(ra) # 8fc <main>
  exit(0);
     93e:	4501                	li	a0,0
     940:	00000097          	auipc	ra,0x0
     944:	274080e7          	jalr	628(ra) # bb4 <exit>

0000000000000948 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     948:	1141                	addi	sp,sp,-16
     94a:	e422                	sd	s0,8(sp)
     94c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     94e:	87aa                	mv	a5,a0
     950:	0585                	addi	a1,a1,1 # 1001 <malloc+0xb>
     952:	0785                	addi	a5,a5,1
     954:	fff5c703          	lbu	a4,-1(a1)
     958:	fee78fa3          	sb	a4,-1(a5)
     95c:	fb75                	bnez	a4,950 <strcpy+0x8>
    ;
  return os;
}
     95e:	6422                	ld	s0,8(sp)
     960:	0141                	addi	sp,sp,16
     962:	8082                	ret

0000000000000964 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     964:	1141                	addi	sp,sp,-16
     966:	e422                	sd	s0,8(sp)
     968:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     96a:	00054783          	lbu	a5,0(a0)
     96e:	cb91                	beqz	a5,982 <strcmp+0x1e>
     970:	0005c703          	lbu	a4,0(a1)
     974:	00f71763          	bne	a4,a5,982 <strcmp+0x1e>
    p++, q++;
     978:	0505                	addi	a0,a0,1
     97a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     97c:	00054783          	lbu	a5,0(a0)
     980:	fbe5                	bnez	a5,970 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     982:	0005c503          	lbu	a0,0(a1)
}
     986:	40a7853b          	subw	a0,a5,a0
     98a:	6422                	ld	s0,8(sp)
     98c:	0141                	addi	sp,sp,16
     98e:	8082                	ret

0000000000000990 <strlen>:

uint
strlen(const char *s)
{
     990:	1141                	addi	sp,sp,-16
     992:	e422                	sd	s0,8(sp)
     994:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     996:	00054783          	lbu	a5,0(a0)
     99a:	cf91                	beqz	a5,9b6 <strlen+0x26>
     99c:	0505                	addi	a0,a0,1
     99e:	87aa                	mv	a5,a0
     9a0:	4685                	li	a3,1
     9a2:	9e89                	subw	a3,a3,a0
     9a4:	00f6853b          	addw	a0,a3,a5
     9a8:	0785                	addi	a5,a5,1
     9aa:	fff7c703          	lbu	a4,-1(a5)
     9ae:	fb7d                	bnez	a4,9a4 <strlen+0x14>
    ;
  return n;
}
     9b0:	6422                	ld	s0,8(sp)
     9b2:	0141                	addi	sp,sp,16
     9b4:	8082                	ret
  for(n = 0; s[n]; n++)
     9b6:	4501                	li	a0,0
     9b8:	bfe5                	j	9b0 <strlen+0x20>

00000000000009ba <memset>:

void*
memset(void *dst, int c, uint n)
{
     9ba:	1141                	addi	sp,sp,-16
     9bc:	e422                	sd	s0,8(sp)
     9be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9c0:	ca19                	beqz	a2,9d6 <memset+0x1c>
     9c2:	87aa                	mv	a5,a0
     9c4:	1602                	slli	a2,a2,0x20
     9c6:	9201                	srli	a2,a2,0x20
     9c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     9cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9d0:	0785                	addi	a5,a5,1
     9d2:	fee79de3          	bne	a5,a4,9cc <memset+0x12>
  }
  return dst;
}
     9d6:	6422                	ld	s0,8(sp)
     9d8:	0141                	addi	sp,sp,16
     9da:	8082                	ret

00000000000009dc <strchr>:

char*
strchr(const char *s, char c)
{
     9dc:	1141                	addi	sp,sp,-16
     9de:	e422                	sd	s0,8(sp)
     9e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9e2:	00054783          	lbu	a5,0(a0)
     9e6:	cb99                	beqz	a5,9fc <strchr+0x20>
    if(*s == c)
     9e8:	00f58763          	beq	a1,a5,9f6 <strchr+0x1a>
  for(; *s; s++)
     9ec:	0505                	addi	a0,a0,1
     9ee:	00054783          	lbu	a5,0(a0)
     9f2:	fbfd                	bnez	a5,9e8 <strchr+0xc>
      return (char*)s;
  return 0;
     9f4:	4501                	li	a0,0
}
     9f6:	6422                	ld	s0,8(sp)
     9f8:	0141                	addi	sp,sp,16
     9fa:	8082                	ret
  return 0;
     9fc:	4501                	li	a0,0
     9fe:	bfe5                	j	9f6 <strchr+0x1a>

0000000000000a00 <gets>:

char*
gets(char *buf, int max)
{
     a00:	711d                	addi	sp,sp,-96
     a02:	ec86                	sd	ra,88(sp)
     a04:	e8a2                	sd	s0,80(sp)
     a06:	e4a6                	sd	s1,72(sp)
     a08:	e0ca                	sd	s2,64(sp)
     a0a:	fc4e                	sd	s3,56(sp)
     a0c:	f852                	sd	s4,48(sp)
     a0e:	f456                	sd	s5,40(sp)
     a10:	f05a                	sd	s6,32(sp)
     a12:	ec5e                	sd	s7,24(sp)
     a14:	1080                	addi	s0,sp,96
     a16:	8baa                	mv	s7,a0
     a18:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a1a:	892a                	mv	s2,a0
     a1c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a1e:	4aa9                	li	s5,10
     a20:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a22:	89a6                	mv	s3,s1
     a24:	2485                	addiw	s1,s1,1
     a26:	0344d863          	bge	s1,s4,a56 <gets+0x56>
    cc = read(0, &c, 1);
     a2a:	4605                	li	a2,1
     a2c:	faf40593          	addi	a1,s0,-81
     a30:	4501                	li	a0,0
     a32:	00000097          	auipc	ra,0x0
     a36:	19a080e7          	jalr	410(ra) # bcc <read>
    if(cc < 1)
     a3a:	00a05e63          	blez	a0,a56 <gets+0x56>
    buf[i++] = c;
     a3e:	faf44783          	lbu	a5,-81(s0)
     a42:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a46:	01578763          	beq	a5,s5,a54 <gets+0x54>
     a4a:	0905                	addi	s2,s2,1
     a4c:	fd679be3          	bne	a5,s6,a22 <gets+0x22>
  for(i=0; i+1 < max; ){
     a50:	89a6                	mv	s3,s1
     a52:	a011                	j	a56 <gets+0x56>
     a54:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a56:	99de                	add	s3,s3,s7
     a58:	00098023          	sb	zero,0(s3)
  return buf;
}
     a5c:	855e                	mv	a0,s7
     a5e:	60e6                	ld	ra,88(sp)
     a60:	6446                	ld	s0,80(sp)
     a62:	64a6                	ld	s1,72(sp)
     a64:	6906                	ld	s2,64(sp)
     a66:	79e2                	ld	s3,56(sp)
     a68:	7a42                	ld	s4,48(sp)
     a6a:	7aa2                	ld	s5,40(sp)
     a6c:	7b02                	ld	s6,32(sp)
     a6e:	6be2                	ld	s7,24(sp)
     a70:	6125                	addi	sp,sp,96
     a72:	8082                	ret

0000000000000a74 <stat>:

int
stat(const char *n, struct stat *st)
{
     a74:	1101                	addi	sp,sp,-32
     a76:	ec06                	sd	ra,24(sp)
     a78:	e822                	sd	s0,16(sp)
     a7a:	e426                	sd	s1,8(sp)
     a7c:	e04a                	sd	s2,0(sp)
     a7e:	1000                	addi	s0,sp,32
     a80:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a82:	4581                	li	a1,0
     a84:	00000097          	auipc	ra,0x0
     a88:	170080e7          	jalr	368(ra) # bf4 <open>
  if(fd < 0)
     a8c:	02054563          	bltz	a0,ab6 <stat+0x42>
     a90:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a92:	85ca                	mv	a1,s2
     a94:	00000097          	auipc	ra,0x0
     a98:	178080e7          	jalr	376(ra) # c0c <fstat>
     a9c:	892a                	mv	s2,a0
  close(fd);
     a9e:	8526                	mv	a0,s1
     aa0:	00000097          	auipc	ra,0x0
     aa4:	13c080e7          	jalr	316(ra) # bdc <close>
  return r;
}
     aa8:	854a                	mv	a0,s2
     aaa:	60e2                	ld	ra,24(sp)
     aac:	6442                	ld	s0,16(sp)
     aae:	64a2                	ld	s1,8(sp)
     ab0:	6902                	ld	s2,0(sp)
     ab2:	6105                	addi	sp,sp,32
     ab4:	8082                	ret
    return -1;
     ab6:	597d                	li	s2,-1
     ab8:	bfc5                	j	aa8 <stat+0x34>

0000000000000aba <atoi>:

int
atoi(const char *s)
{
     aba:	1141                	addi	sp,sp,-16
     abc:	e422                	sd	s0,8(sp)
     abe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ac0:	00054683          	lbu	a3,0(a0)
     ac4:	fd06879b          	addiw	a5,a3,-48
     ac8:	0ff7f793          	zext.b	a5,a5
     acc:	4625                	li	a2,9
     ace:	02f66863          	bltu	a2,a5,afe <atoi+0x44>
     ad2:	872a                	mv	a4,a0
  n = 0;
     ad4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     ad6:	0705                	addi	a4,a4,1
     ad8:	0025179b          	slliw	a5,a0,0x2
     adc:	9fa9                	addw	a5,a5,a0
     ade:	0017979b          	slliw	a5,a5,0x1
     ae2:	9fb5                	addw	a5,a5,a3
     ae4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ae8:	00074683          	lbu	a3,0(a4)
     aec:	fd06879b          	addiw	a5,a3,-48
     af0:	0ff7f793          	zext.b	a5,a5
     af4:	fef671e3          	bgeu	a2,a5,ad6 <atoi+0x1c>
  return n;
}
     af8:	6422                	ld	s0,8(sp)
     afa:	0141                	addi	sp,sp,16
     afc:	8082                	ret
  n = 0;
     afe:	4501                	li	a0,0
     b00:	bfe5                	j	af8 <atoi+0x3e>

0000000000000b02 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b02:	1141                	addi	sp,sp,-16
     b04:	e422                	sd	s0,8(sp)
     b06:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b08:	02b57463          	bgeu	a0,a1,b30 <memmove+0x2e>
    while(n-- > 0)
     b0c:	00c05f63          	blez	a2,b2a <memmove+0x28>
     b10:	1602                	slli	a2,a2,0x20
     b12:	9201                	srli	a2,a2,0x20
     b14:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b18:	872a                	mv	a4,a0
      *dst++ = *src++;
     b1a:	0585                	addi	a1,a1,1
     b1c:	0705                	addi	a4,a4,1
     b1e:	fff5c683          	lbu	a3,-1(a1)
     b22:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b26:	fee79ae3          	bne	a5,a4,b1a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b2a:	6422                	ld	s0,8(sp)
     b2c:	0141                	addi	sp,sp,16
     b2e:	8082                	ret
    dst += n;
     b30:	00c50733          	add	a4,a0,a2
    src += n;
     b34:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b36:	fec05ae3          	blez	a2,b2a <memmove+0x28>
     b3a:	fff6079b          	addiw	a5,a2,-1
     b3e:	1782                	slli	a5,a5,0x20
     b40:	9381                	srli	a5,a5,0x20
     b42:	fff7c793          	not	a5,a5
     b46:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b48:	15fd                	addi	a1,a1,-1
     b4a:	177d                	addi	a4,a4,-1
     b4c:	0005c683          	lbu	a3,0(a1)
     b50:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b54:	fee79ae3          	bne	a5,a4,b48 <memmove+0x46>
     b58:	bfc9                	j	b2a <memmove+0x28>

0000000000000b5a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b5a:	1141                	addi	sp,sp,-16
     b5c:	e422                	sd	s0,8(sp)
     b5e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b60:	ca05                	beqz	a2,b90 <memcmp+0x36>
     b62:	fff6069b          	addiw	a3,a2,-1
     b66:	1682                	slli	a3,a3,0x20
     b68:	9281                	srli	a3,a3,0x20
     b6a:	0685                	addi	a3,a3,1
     b6c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b6e:	00054783          	lbu	a5,0(a0)
     b72:	0005c703          	lbu	a4,0(a1)
     b76:	00e79863          	bne	a5,a4,b86 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b7a:	0505                	addi	a0,a0,1
    p2++;
     b7c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b7e:	fed518e3          	bne	a0,a3,b6e <memcmp+0x14>
  }
  return 0;
     b82:	4501                	li	a0,0
     b84:	a019                	j	b8a <memcmp+0x30>
      return *p1 - *p2;
     b86:	40e7853b          	subw	a0,a5,a4
}
     b8a:	6422                	ld	s0,8(sp)
     b8c:	0141                	addi	sp,sp,16
     b8e:	8082                	ret
  return 0;
     b90:	4501                	li	a0,0
     b92:	bfe5                	j	b8a <memcmp+0x30>

0000000000000b94 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b94:	1141                	addi	sp,sp,-16
     b96:	e406                	sd	ra,8(sp)
     b98:	e022                	sd	s0,0(sp)
     b9a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b9c:	00000097          	auipc	ra,0x0
     ba0:	f66080e7          	jalr	-154(ra) # b02 <memmove>
}
     ba4:	60a2                	ld	ra,8(sp)
     ba6:	6402                	ld	s0,0(sp)
     ba8:	0141                	addi	sp,sp,16
     baa:	8082                	ret

0000000000000bac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bac:	4885                	li	a7,1
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bb4:	4889                	li	a7,2
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <wait>:
.global wait
wait:
 li a7, SYS_wait
     bbc:	488d                	li	a7,3
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bc4:	4891                	li	a7,4
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <read>:
.global read
read:
 li a7, SYS_read
     bcc:	4895                	li	a7,5
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <write>:
.global write
write:
 li a7, SYS_write
     bd4:	48c1                	li	a7,16
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <close>:
.global close
close:
 li a7, SYS_close
     bdc:	48d5                	li	a7,21
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     be4:	4899                	li	a7,6
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <exec>:
.global exec
exec:
 li a7, SYS_exec
     bec:	489d                	li	a7,7
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <open>:
.global open
open:
 li a7, SYS_open
     bf4:	48bd                	li	a7,15
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bfc:	48c5                	li	a7,17
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c04:	48c9                	li	a7,18
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c0c:	48a1                	li	a7,8
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <link>:
.global link
link:
 li a7, SYS_link
     c14:	48cd                	li	a7,19
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c1c:	48d1                	li	a7,20
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c24:	48a5                	li	a7,9
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <dup>:
.global dup
dup:
 li a7, SYS_dup
     c2c:	48a9                	li	a7,10
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c34:	48ad                	li	a7,11
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c3c:	48b1                	li	a7,12
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c44:	48b5                	li	a7,13
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c4c:	48b9                	li	a7,14
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c54:	48d9                	li	a7,22
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c5c:	48dd                	li	a7,23
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c64:	1101                	addi	sp,sp,-32
     c66:	ec06                	sd	ra,24(sp)
     c68:	e822                	sd	s0,16(sp)
     c6a:	1000                	addi	s0,sp,32
     c6c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c70:	4605                	li	a2,1
     c72:	fef40593          	addi	a1,s0,-17
     c76:	00000097          	auipc	ra,0x0
     c7a:	f5e080e7          	jalr	-162(ra) # bd4 <write>
}
     c7e:	60e2                	ld	ra,24(sp)
     c80:	6442                	ld	s0,16(sp)
     c82:	6105                	addi	sp,sp,32
     c84:	8082                	ret

0000000000000c86 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c86:	7139                	addi	sp,sp,-64
     c88:	fc06                	sd	ra,56(sp)
     c8a:	f822                	sd	s0,48(sp)
     c8c:	f426                	sd	s1,40(sp)
     c8e:	f04a                	sd	s2,32(sp)
     c90:	ec4e                	sd	s3,24(sp)
     c92:	0080                	addi	s0,sp,64
     c94:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c96:	c299                	beqz	a3,c9c <printint+0x16>
     c98:	0805c963          	bltz	a1,d2a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c9c:	2581                	sext.w	a1,a1
  neg = 0;
     c9e:	4881                	li	a7,0
     ca0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ca4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ca6:	2601                	sext.w	a2,a2
     ca8:	00001517          	auipc	a0,0x1
     cac:	94850513          	addi	a0,a0,-1720 # 15f0 <digits>
     cb0:	883a                	mv	a6,a4
     cb2:	2705                	addiw	a4,a4,1
     cb4:	02c5f7bb          	remuw	a5,a1,a2
     cb8:	1782                	slli	a5,a5,0x20
     cba:	9381                	srli	a5,a5,0x20
     cbc:	97aa                	add	a5,a5,a0
     cbe:	0007c783          	lbu	a5,0(a5)
     cc2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cc6:	0005879b          	sext.w	a5,a1
     cca:	02c5d5bb          	divuw	a1,a1,a2
     cce:	0685                	addi	a3,a3,1
     cd0:	fec7f0e3          	bgeu	a5,a2,cb0 <printint+0x2a>
  if(neg)
     cd4:	00088c63          	beqz	a7,cec <printint+0x66>
    buf[i++] = '-';
     cd8:	fd070793          	addi	a5,a4,-48
     cdc:	00878733          	add	a4,a5,s0
     ce0:	02d00793          	li	a5,45
     ce4:	fef70823          	sb	a5,-16(a4)
     ce8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cec:	02e05863          	blez	a4,d1c <printint+0x96>
     cf0:	fc040793          	addi	a5,s0,-64
     cf4:	00e78933          	add	s2,a5,a4
     cf8:	fff78993          	addi	s3,a5,-1
     cfc:	99ba                	add	s3,s3,a4
     cfe:	377d                	addiw	a4,a4,-1
     d00:	1702                	slli	a4,a4,0x20
     d02:	9301                	srli	a4,a4,0x20
     d04:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d08:	fff94583          	lbu	a1,-1(s2)
     d0c:	8526                	mv	a0,s1
     d0e:	00000097          	auipc	ra,0x0
     d12:	f56080e7          	jalr	-170(ra) # c64 <putc>
  while(--i >= 0)
     d16:	197d                	addi	s2,s2,-1
     d18:	ff3918e3          	bne	s2,s3,d08 <printint+0x82>
}
     d1c:	70e2                	ld	ra,56(sp)
     d1e:	7442                	ld	s0,48(sp)
     d20:	74a2                	ld	s1,40(sp)
     d22:	7902                	ld	s2,32(sp)
     d24:	69e2                	ld	s3,24(sp)
     d26:	6121                	addi	sp,sp,64
     d28:	8082                	ret
    x = -xx;
     d2a:	40b005bb          	negw	a1,a1
    neg = 1;
     d2e:	4885                	li	a7,1
    x = -xx;
     d30:	bf85                	j	ca0 <printint+0x1a>

0000000000000d32 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d32:	7119                	addi	sp,sp,-128
     d34:	fc86                	sd	ra,120(sp)
     d36:	f8a2                	sd	s0,112(sp)
     d38:	f4a6                	sd	s1,104(sp)
     d3a:	f0ca                	sd	s2,96(sp)
     d3c:	ecce                	sd	s3,88(sp)
     d3e:	e8d2                	sd	s4,80(sp)
     d40:	e4d6                	sd	s5,72(sp)
     d42:	e0da                	sd	s6,64(sp)
     d44:	fc5e                	sd	s7,56(sp)
     d46:	f862                	sd	s8,48(sp)
     d48:	f466                	sd	s9,40(sp)
     d4a:	f06a                	sd	s10,32(sp)
     d4c:	ec6e                	sd	s11,24(sp)
     d4e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d50:	0005c903          	lbu	s2,0(a1)
     d54:	18090f63          	beqz	s2,ef2 <vprintf+0x1c0>
     d58:	8aaa                	mv	s5,a0
     d5a:	8b32                	mv	s6,a2
     d5c:	00158493          	addi	s1,a1,1
  state = 0;
     d60:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d62:	02500a13          	li	s4,37
     d66:	4c55                	li	s8,21
     d68:	00001c97          	auipc	s9,0x1
     d6c:	830c8c93          	addi	s9,s9,-2000 # 1598 <malloc+0x5a2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     d70:	02800d93          	li	s11,40
  putc(fd, 'x');
     d74:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d76:	00001b97          	auipc	s7,0x1
     d7a:	87ab8b93          	addi	s7,s7,-1926 # 15f0 <digits>
     d7e:	a839                	j	d9c <vprintf+0x6a>
        putc(fd, c);
     d80:	85ca                	mv	a1,s2
     d82:	8556                	mv	a0,s5
     d84:	00000097          	auipc	ra,0x0
     d88:	ee0080e7          	jalr	-288(ra) # c64 <putc>
     d8c:	a019                	j	d92 <vprintf+0x60>
    } else if(state == '%'){
     d8e:	01498d63          	beq	s3,s4,da8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     d92:	0485                	addi	s1,s1,1
     d94:	fff4c903          	lbu	s2,-1(s1)
     d98:	14090d63          	beqz	s2,ef2 <vprintf+0x1c0>
    if(state == 0){
     d9c:	fe0999e3          	bnez	s3,d8e <vprintf+0x5c>
      if(c == '%'){
     da0:	ff4910e3          	bne	s2,s4,d80 <vprintf+0x4e>
        state = '%';
     da4:	89d2                	mv	s3,s4
     da6:	b7f5                	j	d92 <vprintf+0x60>
      if(c == 'd'){
     da8:	11490c63          	beq	s2,s4,ec0 <vprintf+0x18e>
     dac:	f9d9079b          	addiw	a5,s2,-99
     db0:	0ff7f793          	zext.b	a5,a5
     db4:	10fc6e63          	bltu	s8,a5,ed0 <vprintf+0x19e>
     db8:	f9d9079b          	addiw	a5,s2,-99
     dbc:	0ff7f713          	zext.b	a4,a5
     dc0:	10ec6863          	bltu	s8,a4,ed0 <vprintf+0x19e>
     dc4:	00271793          	slli	a5,a4,0x2
     dc8:	97e6                	add	a5,a5,s9
     dca:	439c                	lw	a5,0(a5)
     dcc:	97e6                	add	a5,a5,s9
     dce:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     dd0:	008b0913          	addi	s2,s6,8
     dd4:	4685                	li	a3,1
     dd6:	4629                	li	a2,10
     dd8:	000b2583          	lw	a1,0(s6)
     ddc:	8556                	mv	a0,s5
     dde:	00000097          	auipc	ra,0x0
     de2:	ea8080e7          	jalr	-344(ra) # c86 <printint>
     de6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     de8:	4981                	li	s3,0
     dea:	b765                	j	d92 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dec:	008b0913          	addi	s2,s6,8
     df0:	4681                	li	a3,0
     df2:	4629                	li	a2,10
     df4:	000b2583          	lw	a1,0(s6)
     df8:	8556                	mv	a0,s5
     dfa:	00000097          	auipc	ra,0x0
     dfe:	e8c080e7          	jalr	-372(ra) # c86 <printint>
     e02:	8b4a                	mv	s6,s2
      state = 0;
     e04:	4981                	li	s3,0
     e06:	b771                	j	d92 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     e08:	008b0913          	addi	s2,s6,8
     e0c:	4681                	li	a3,0
     e0e:	866a                	mv	a2,s10
     e10:	000b2583          	lw	a1,0(s6)
     e14:	8556                	mv	a0,s5
     e16:	00000097          	auipc	ra,0x0
     e1a:	e70080e7          	jalr	-400(ra) # c86 <printint>
     e1e:	8b4a                	mv	s6,s2
      state = 0;
     e20:	4981                	li	s3,0
     e22:	bf85                	j	d92 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     e24:	008b0793          	addi	a5,s6,8
     e28:	f8f43423          	sd	a5,-120(s0)
     e2c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     e30:	03000593          	li	a1,48
     e34:	8556                	mv	a0,s5
     e36:	00000097          	auipc	ra,0x0
     e3a:	e2e080e7          	jalr	-466(ra) # c64 <putc>
  putc(fd, 'x');
     e3e:	07800593          	li	a1,120
     e42:	8556                	mv	a0,s5
     e44:	00000097          	auipc	ra,0x0
     e48:	e20080e7          	jalr	-480(ra) # c64 <putc>
     e4c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e4e:	03c9d793          	srli	a5,s3,0x3c
     e52:	97de                	add	a5,a5,s7
     e54:	0007c583          	lbu	a1,0(a5)
     e58:	8556                	mv	a0,s5
     e5a:	00000097          	auipc	ra,0x0
     e5e:	e0a080e7          	jalr	-502(ra) # c64 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e62:	0992                	slli	s3,s3,0x4
     e64:	397d                	addiw	s2,s2,-1
     e66:	fe0914e3          	bnez	s2,e4e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     e6a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e6e:	4981                	li	s3,0
     e70:	b70d                	j	d92 <vprintf+0x60>
        s = va_arg(ap, char*);
     e72:	008b0913          	addi	s2,s6,8
     e76:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     e7a:	02098163          	beqz	s3,e9c <vprintf+0x16a>
        while(*s != 0){
     e7e:	0009c583          	lbu	a1,0(s3)
     e82:	c5ad                	beqz	a1,eec <vprintf+0x1ba>
          putc(fd, *s);
     e84:	8556                	mv	a0,s5
     e86:	00000097          	auipc	ra,0x0
     e8a:	dde080e7          	jalr	-546(ra) # c64 <putc>
          s++;
     e8e:	0985                	addi	s3,s3,1
        while(*s != 0){
     e90:	0009c583          	lbu	a1,0(s3)
     e94:	f9e5                	bnez	a1,e84 <vprintf+0x152>
        s = va_arg(ap, char*);
     e96:	8b4a                	mv	s6,s2
      state = 0;
     e98:	4981                	li	s3,0
     e9a:	bde5                	j	d92 <vprintf+0x60>
          s = "(null)";
     e9c:	00000997          	auipc	s3,0x0
     ea0:	6f498993          	addi	s3,s3,1780 # 1590 <malloc+0x59a>
        while(*s != 0){
     ea4:	85ee                	mv	a1,s11
     ea6:	bff9                	j	e84 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     ea8:	008b0913          	addi	s2,s6,8
     eac:	000b4583          	lbu	a1,0(s6)
     eb0:	8556                	mv	a0,s5
     eb2:	00000097          	auipc	ra,0x0
     eb6:	db2080e7          	jalr	-590(ra) # c64 <putc>
     eba:	8b4a                	mv	s6,s2
      state = 0;
     ebc:	4981                	li	s3,0
     ebe:	bdd1                	j	d92 <vprintf+0x60>
        putc(fd, c);
     ec0:	85d2                	mv	a1,s4
     ec2:	8556                	mv	a0,s5
     ec4:	00000097          	auipc	ra,0x0
     ec8:	da0080e7          	jalr	-608(ra) # c64 <putc>
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	b5d1                	j	d92 <vprintf+0x60>
        putc(fd, '%');
     ed0:	85d2                	mv	a1,s4
     ed2:	8556                	mv	a0,s5
     ed4:	00000097          	auipc	ra,0x0
     ed8:	d90080e7          	jalr	-624(ra) # c64 <putc>
        putc(fd, c);
     edc:	85ca                	mv	a1,s2
     ede:	8556                	mv	a0,s5
     ee0:	00000097          	auipc	ra,0x0
     ee4:	d84080e7          	jalr	-636(ra) # c64 <putc>
      state = 0;
     ee8:	4981                	li	s3,0
     eea:	b565                	j	d92 <vprintf+0x60>
        s = va_arg(ap, char*);
     eec:	8b4a                	mv	s6,s2
      state = 0;
     eee:	4981                	li	s3,0
     ef0:	b54d                	j	d92 <vprintf+0x60>
    }
  }
}
     ef2:	70e6                	ld	ra,120(sp)
     ef4:	7446                	ld	s0,112(sp)
     ef6:	74a6                	ld	s1,104(sp)
     ef8:	7906                	ld	s2,96(sp)
     efa:	69e6                	ld	s3,88(sp)
     efc:	6a46                	ld	s4,80(sp)
     efe:	6aa6                	ld	s5,72(sp)
     f00:	6b06                	ld	s6,64(sp)
     f02:	7be2                	ld	s7,56(sp)
     f04:	7c42                	ld	s8,48(sp)
     f06:	7ca2                	ld	s9,40(sp)
     f08:	7d02                	ld	s10,32(sp)
     f0a:	6de2                	ld	s11,24(sp)
     f0c:	6109                	addi	sp,sp,128
     f0e:	8082                	ret

0000000000000f10 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f10:	715d                	addi	sp,sp,-80
     f12:	ec06                	sd	ra,24(sp)
     f14:	e822                	sd	s0,16(sp)
     f16:	1000                	addi	s0,sp,32
     f18:	e010                	sd	a2,0(s0)
     f1a:	e414                	sd	a3,8(s0)
     f1c:	e818                	sd	a4,16(s0)
     f1e:	ec1c                	sd	a5,24(s0)
     f20:	03043023          	sd	a6,32(s0)
     f24:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f28:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f2c:	8622                	mv	a2,s0
     f2e:	00000097          	auipc	ra,0x0
     f32:	e04080e7          	jalr	-508(ra) # d32 <vprintf>
}
     f36:	60e2                	ld	ra,24(sp)
     f38:	6442                	ld	s0,16(sp)
     f3a:	6161                	addi	sp,sp,80
     f3c:	8082                	ret

0000000000000f3e <printf>:

void
printf(const char *fmt, ...)
{
     f3e:	711d                	addi	sp,sp,-96
     f40:	ec06                	sd	ra,24(sp)
     f42:	e822                	sd	s0,16(sp)
     f44:	1000                	addi	s0,sp,32
     f46:	e40c                	sd	a1,8(s0)
     f48:	e810                	sd	a2,16(s0)
     f4a:	ec14                	sd	a3,24(s0)
     f4c:	f018                	sd	a4,32(s0)
     f4e:	f41c                	sd	a5,40(s0)
     f50:	03043823          	sd	a6,48(s0)
     f54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f58:	00840613          	addi	a2,s0,8
     f5c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f60:	85aa                	mv	a1,a0
     f62:	4505                	li	a0,1
     f64:	00000097          	auipc	ra,0x0
     f68:	dce080e7          	jalr	-562(ra) # d32 <vprintf>
}
     f6c:	60e2                	ld	ra,24(sp)
     f6e:	6442                	ld	s0,16(sp)
     f70:	6125                	addi	sp,sp,96
     f72:	8082                	ret

0000000000000f74 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f74:	1141                	addi	sp,sp,-16
     f76:	e422                	sd	s0,8(sp)
     f78:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f7a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f7e:	00001797          	auipc	a5,0x1
     f82:	0927b783          	ld	a5,146(a5) # 2010 <freep>
     f86:	a02d                	j	fb0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f88:	4618                	lw	a4,8(a2)
     f8a:	9f2d                	addw	a4,a4,a1
     f8c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f90:	6398                	ld	a4,0(a5)
     f92:	6310                	ld	a2,0(a4)
     f94:	a83d                	j	fd2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f96:	ff852703          	lw	a4,-8(a0)
     f9a:	9f31                	addw	a4,a4,a2
     f9c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f9e:	ff053683          	ld	a3,-16(a0)
     fa2:	a091                	j	fe6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fa4:	6398                	ld	a4,0(a5)
     fa6:	00e7e463          	bltu	a5,a4,fae <free+0x3a>
     faa:	00e6ea63          	bltu	a3,a4,fbe <free+0x4a>
{
     fae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fb0:	fed7fae3          	bgeu	a5,a3,fa4 <free+0x30>
     fb4:	6398                	ld	a4,0(a5)
     fb6:	00e6e463          	bltu	a3,a4,fbe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fba:	fee7eae3          	bltu	a5,a4,fae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     fbe:	ff852583          	lw	a1,-8(a0)
     fc2:	6390                	ld	a2,0(a5)
     fc4:	02059813          	slli	a6,a1,0x20
     fc8:	01c85713          	srli	a4,a6,0x1c
     fcc:	9736                	add	a4,a4,a3
     fce:	fae60de3          	beq	a2,a4,f88 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     fd2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fd6:	4790                	lw	a2,8(a5)
     fd8:	02061593          	slli	a1,a2,0x20
     fdc:	01c5d713          	srli	a4,a1,0x1c
     fe0:	973e                	add	a4,a4,a5
     fe2:	fae68ae3          	beq	a3,a4,f96 <free+0x22>
    p->s.ptr = bp->s.ptr;
     fe6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     fe8:	00001717          	auipc	a4,0x1
     fec:	02f73423          	sd	a5,40(a4) # 2010 <freep>
}
     ff0:	6422                	ld	s0,8(sp)
     ff2:	0141                	addi	sp,sp,16
     ff4:	8082                	ret

0000000000000ff6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     ff6:	7139                	addi	sp,sp,-64
     ff8:	fc06                	sd	ra,56(sp)
     ffa:	f822                	sd	s0,48(sp)
     ffc:	f426                	sd	s1,40(sp)
     ffe:	f04a                	sd	s2,32(sp)
    1000:	ec4e                	sd	s3,24(sp)
    1002:	e852                	sd	s4,16(sp)
    1004:	e456                	sd	s5,8(sp)
    1006:	e05a                	sd	s6,0(sp)
    1008:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    100a:	02051493          	slli	s1,a0,0x20
    100e:	9081                	srli	s1,s1,0x20
    1010:	04bd                	addi	s1,s1,15
    1012:	8091                	srli	s1,s1,0x4
    1014:	0014899b          	addiw	s3,s1,1
    1018:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    101a:	00001517          	auipc	a0,0x1
    101e:	ff653503          	ld	a0,-10(a0) # 2010 <freep>
    1022:	c515                	beqz	a0,104e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1024:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1026:	4798                	lw	a4,8(a5)
    1028:	02977f63          	bgeu	a4,s1,1066 <malloc+0x70>
    102c:	8a4e                	mv	s4,s3
    102e:	0009871b          	sext.w	a4,s3
    1032:	6685                	lui	a3,0x1
    1034:	00d77363          	bgeu	a4,a3,103a <malloc+0x44>
    1038:	6a05                	lui	s4,0x1
    103a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    103e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1042:	00001917          	auipc	s2,0x1
    1046:	fce90913          	addi	s2,s2,-50 # 2010 <freep>
  if(p == (char*)-1)
    104a:	5afd                	li	s5,-1
    104c:	a895                	j	10c0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    104e:	00001797          	auipc	a5,0x1
    1052:	3d278793          	addi	a5,a5,978 # 2420 <base>
    1056:	00001717          	auipc	a4,0x1
    105a:	faf73d23          	sd	a5,-70(a4) # 2010 <freep>
    105e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1060:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1064:	b7e1                	j	102c <malloc+0x36>
      if(p->s.size == nunits)
    1066:	02e48c63          	beq	s1,a4,109e <malloc+0xa8>
        p->s.size -= nunits;
    106a:	4137073b          	subw	a4,a4,s3
    106e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1070:	02071693          	slli	a3,a4,0x20
    1074:	01c6d713          	srli	a4,a3,0x1c
    1078:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    107a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    107e:	00001717          	auipc	a4,0x1
    1082:	f8a73923          	sd	a0,-110(a4) # 2010 <freep>
      return (void*)(p + 1);
    1086:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    108a:	70e2                	ld	ra,56(sp)
    108c:	7442                	ld	s0,48(sp)
    108e:	74a2                	ld	s1,40(sp)
    1090:	7902                	ld	s2,32(sp)
    1092:	69e2                	ld	s3,24(sp)
    1094:	6a42                	ld	s4,16(sp)
    1096:	6aa2                	ld	s5,8(sp)
    1098:	6b02                	ld	s6,0(sp)
    109a:	6121                	addi	sp,sp,64
    109c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    109e:	6398                	ld	a4,0(a5)
    10a0:	e118                	sd	a4,0(a0)
    10a2:	bff1                	j	107e <malloc+0x88>
  hp->s.size = nu;
    10a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10a8:	0541                	addi	a0,a0,16
    10aa:	00000097          	auipc	ra,0x0
    10ae:	eca080e7          	jalr	-310(ra) # f74 <free>
  return freep;
    10b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10b6:	d971                	beqz	a0,108a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10ba:	4798                	lw	a4,8(a5)
    10bc:	fa9775e3          	bgeu	a4,s1,1066 <malloc+0x70>
    if(p == freep)
    10c0:	00093703          	ld	a4,0(s2)
    10c4:	853e                	mv	a0,a5
    10c6:	fef719e3          	bne	a4,a5,10b8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    10ca:	8552                	mv	a0,s4
    10cc:	00000097          	auipc	ra,0x0
    10d0:	b70080e7          	jalr	-1168(ra) # c3c <sbrk>
  if(p == (char*)-1)
    10d4:	fd5518e3          	bne	a0,s5,10a4 <malloc+0xae>
        return 0;
    10d8:	4501                	li	a0,0
    10da:	bf45                	j	108a <malloc+0x94>
