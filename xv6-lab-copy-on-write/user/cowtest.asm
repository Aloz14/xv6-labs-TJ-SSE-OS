
user/_cowtest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:

// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
    uint64 phys_size = PHYSTOP - KERNBASE;
    int sz = (phys_size / 3) * 2;

    printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c7250513          	addi	a0,a0,-910 # c80 <malloc+0xf4>
  16:	00001097          	auipc	ra,0x1
  1a:	abe080e7          	jalr	-1346(ra) # ad4 <printf>

    char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5550544>
  26:	00000097          	auipc	ra,0x0
  2a:	7bc080e7          	jalr	1980(ra) # 7e2 <sbrk>
    if (p == (char *)0xffffffffffffffffL) {
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
        printf("sbrk(%d) failed\n", sz);
        exit(-1);
    }

    for (char *q = p; q < p + sz; q += 4096) {
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
        *(int *)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	79c080e7          	jalr	1948(ra) # 7da <getpid>
  46:	c088                	sw	a0,0(s1)
    for (char *q = p; q < p + sz; q += 4096) {
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
    }

    int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	704080e7          	jalr	1796(ra) # 752 <fork>
    if (pid < 0) {
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
        printf("fork() failed\n");
        exit(-1);
    }

    if (pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
        exit(0);

    wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	704080e7          	jalr	1796(ra) # 762 <wait>

    if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  6e:	00000097          	auipc	ra,0x0
  72:	774080e7          	jalr	1908(ra) # 7e2 <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
        printf("sbrk(-%d) failed\n", sz);
        exit(-1);
    }

    printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	c5450513          	addi	a0,a0,-940 # cd0 <malloc+0x144>
  84:	00001097          	auipc	ra,0x1
  88:	a50080e7          	jalr	-1456(ra) # ad4 <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
        printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  a2:	00001517          	auipc	a0,0x1
  a6:	bee50513          	addi	a0,a0,-1042 # c90 <malloc+0x104>
  aa:	00001097          	auipc	ra,0x1
  ae:	a2a080e7          	jalr	-1494(ra) # ad4 <printf>
        exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	6a6080e7          	jalr	1702(ra) # 75a <exit>
        printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	bec50513          	addi	a0,a0,-1044 # ca8 <malloc+0x11c>
  c4:	00001097          	auipc	ra,0x1
  c8:	a10080e7          	jalr	-1520(ra) # ad4 <printf>
        exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	68c080e7          	jalr	1676(ra) # 75a <exit>
        exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	684080e7          	jalr	1668(ra) # 75a <exit>
        printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  e6:	00001517          	auipc	a0,0x1
  ea:	bd250513          	addi	a0,a0,-1070 # cb8 <malloc+0x12c>
  ee:	00001097          	auipc	ra,0x1
  f2:	9e6080e7          	jalr	-1562(ra) # ad4 <printf>
        exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	662080e7          	jalr	1634(ra) # 75a <exit>

0000000000000100 <threetest>:
// three processes all write COW memory.
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
    uint64 phys_size = PHYSTOP - KERNBASE;
    int sz = phys_size / 4;
    int pid1, pid2;

    printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	bc850513          	addi	a0,a0,-1080 # cd8 <malloc+0x14c>
 118:	00001097          	auipc	ra,0x1
 11c:	9bc080e7          	jalr	-1604(ra) # ad4 <printf>

    char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	6be080e7          	jalr	1726(ra) # 7e2 <sbrk>
    if (p == (char *)0xffffffffffffffffL) {
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
        printf("sbrk(%d) failed\n", sz);
        exit(-1);
    }

    pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	61e080e7          	jalr	1566(ra) # 752 <fork>
    if (pid1 < 0) {
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
        printf("fork failed\n");
        exit(-1);
    }
    if (pid1 == 0) {
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
            *(int *)q = 9999;
        }
        exit(0);
    }

    for (char *q = p; q < p + sz; q += 4096) {
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	68e080e7          	jalr	1678(ra) # 7da <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
    for (char *q = p; q < p + sz; q += 4096) {
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
    }

    wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	602080e7          	jalr	1538(ra) # 762 <wait>

    sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	680080e7          	jalr	1664(ra) # 7ea <sleep>

    for (char *q = p; q < p + sz; q += 4096) {
 172:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid()) {
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	662080e7          	jalr	1634(ra) # 7da <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
    for (char *q = p; q < p + sz; q += 4096) {
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
            printf("wrong content\n");
            exit(-1);
        }
    }

    if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	654080e7          	jalr	1620(ra) # 7e2 <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
        printf("sbrk(-%d) failed\n", sz);
        exit(-1);
    }

    printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b3450513          	addi	a0,a0,-1228 # cd0 <malloc+0x144>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	930080e7          	jalr	-1744(ra) # ad4 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
        printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	ad050513          	addi	a0,a0,-1328 # c90 <malloc+0x104>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	90c080e7          	jalr	-1780(ra) # ad4 <printf>
        exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	588080e7          	jalr	1416(ra) # 75a <exit>
        printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	b0650513          	addi	a0,a0,-1274 # ce0 <malloc+0x154>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	8f2080e7          	jalr	-1806(ra) # ad4 <printf>
        exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	56e080e7          	jalr	1390(ra) # 75a <exit>
        pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	55e080e7          	jalr	1374(ra) # 752 <fork>
        if (pid2 < 0) {
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
        if (pid2 == 0) {
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
            for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
                *(int *)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	5ce080e7          	jalr	1486(ra) # 7da <getpid>
 214:	00a92023          	sw	a0,0(s2)
            for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
            for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 21e:	6a05                	lui	s4,0x1
                if (*(int *)q != getpid()) {
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	5b6080e7          	jalr	1462(ra) # 7da <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
            for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
            exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	522080e7          	jalr	1314(ra) # 75a <exit>
            printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	ab050513          	addi	a0,a0,-1360 # cf0 <malloc+0x164>
 248:	00001097          	auipc	ra,0x1
 24c:	88c080e7          	jalr	-1908(ra) # ad4 <printf>
            exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	508080e7          	jalr	1288(ra) # 75a <exit>
        for (char *q = p; q < p + (sz / 2); q += 4096) {
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
            *(int *)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x6ff>
        for (char *q = p; q < p + (sz / 2); q += 4096) {
 266:	6685                	lui	a3,0x1
            *(int *)q = 9999;
 268:	c09c                	sw	a5,0(s1)
        for (char *q = p; q < p + (sz / 2); q += 4096) {
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
        exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	4e8080e7          	jalr	1256(ra) # 75a <exit>
                    printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a8650513          	addi	a0,a0,-1402 # d00 <malloc+0x174>
 282:	00001097          	auipc	ra,0x1
 286:	852080e7          	jalr	-1966(ra) # ad4 <printf>
                    exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	4ce080e7          	jalr	1230(ra) # 75a <exit>
            printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a6c50513          	addi	a0,a0,-1428 # d00 <malloc+0x174>
 29c:	00001097          	auipc	ra,0x1
 2a0:	838080e7          	jalr	-1992(ra) # ad4 <printf>
            exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	4b4080e7          	jalr	1204(ra) # 75a <exit>
        printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	a0650513          	addi	a0,a0,-1530 # cb8 <malloc+0x12c>
 2ba:	00001097          	auipc	ra,0x1
 2be:	81a080e7          	jalr	-2022(ra) # ad4 <printf>
        exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	496080e7          	jalr	1174(ra) # 75a <exit>

00000000000002cc <filetest>:
char buf[4096];
char junk3[4096];

// test whether copyout() simulates COW faults.
void filetest()
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
    printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	a3850513          	addi	a0,a0,-1480 # d10 <malloc+0x184>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	7f4080e7          	jalr	2036(ra) # ad4 <printf>

    buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	d2f70223          	sb	a5,-732(a4) # 2010 <buf>

    for (int i = 0; i < 4; i++) {
 2f4:	fc042c23          	sw	zero,-40(s0)
        if (pipe(fds) != 0) {
 2f8:	00001497          	auipc	s1,0x1
 2fc:	d0848493          	addi	s1,s1,-760 # 1000 <fds>
    for (int i = 0; i < 4; i++) {
 300:	490d                	li	s2,3
        if (pipe(fds) != 0) {
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	466080e7          	jalr	1126(ra) # 76a <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
            printf("pipe() failed\n");
            exit(-1);
        }
        int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	444080e7          	jalr	1092(ra) # 752 <fork>
        if (pid < 0) {
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
            printf("fork failed\n");
            exit(-1);
        }
        if (pid == 0) {
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
                printf("error: read the wrong value\n");
                exit(1);
            }
            exit(0);
        }
        if (write(fds[1], &i, sizeof(i)) != sizeof(i)) {
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	456080e7          	jalr	1110(ra) # 77a <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
    for (int i = 0; i < 4; i++) {
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
            printf("error: write failed\n");
            exit(-1);
        }
    }

    int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
    for (int i = 0; i < 4; i++) {
        wait(&xstatus);
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	414080e7          	jalr	1044(ra) # 762 <wait>
        if (xstatus != 0) {
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
    for (int i = 0; i < 4; i++) {
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
            exit(1);
        }
    }

    if (buf[0] != 99) {
 362:	00002717          	auipc	a4,0x2
 366:	cae74703          	lbu	a4,-850(a4) # 2010 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
        printf("error: child overwrote parent\n");
        exit(1);
    }

    printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	95e50513          	addi	a0,a0,-1698 # cd0 <malloc+0x144>
 37a:	00000097          	auipc	ra,0x0
 37e:	75a080e7          	jalr	1882(ra) # ad4 <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
            printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	98a50513          	addi	a0,a0,-1654 # d18 <malloc+0x18c>
 396:	00000097          	auipc	ra,0x0
 39a:	73e080e7          	jalr	1854(ra) # ad4 <printf>
            exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	3ba080e7          	jalr	954(ra) # 75a <exit>
            printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	93850513          	addi	a0,a0,-1736 # ce0 <malloc+0x154>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	724080e7          	jalr	1828(ra) # ad4 <printf>
            exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	3a0080e7          	jalr	928(ra) # 75a <exit>
            sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	426080e7          	jalr	1062(ra) # 7ea <sleep>
            if (read(fds[0], buf, sizeof(i)) != sizeof(i)) {
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	c4258593          	addi	a1,a1,-958 # 2010 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	c2a52503          	lw	a0,-982(a0) # 1000 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	394080e7          	jalr	916(ra) # 772 <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
            sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	3fc080e7          	jalr	1020(ra) # 7ea <sleep>
            if (j != i) {
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	c167a783          	lw	a5,-1002(a5) # 2010 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
                printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	93a50513          	addi	a0,a0,-1734 # d40 <malloc+0x1b4>
 40e:	00000097          	auipc	ra,0x0
 412:	6c6080e7          	jalr	1734(ra) # ad4 <printf>
                exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	342080e7          	jalr	834(ra) # 75a <exit>
                printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	90850513          	addi	a0,a0,-1784 # d28 <malloc+0x19c>
 428:	00000097          	auipc	ra,0x0
 42c:	6ac080e7          	jalr	1708(ra) # ad4 <printf>
                exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	328080e7          	jalr	808(ra) # 75a <exit>
            exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	31e080e7          	jalr	798(ra) # 75a <exit>
            printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	91c50513          	addi	a0,a0,-1764 # d60 <malloc+0x1d4>
 44c:	00000097          	auipc	ra,0x0
 450:	688080e7          	jalr	1672(ra) # ad4 <printf>
            exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	304080e7          	jalr	772(ra) # 75a <exit>
            exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	2fa080e7          	jalr	762(ra) # 75a <exit>
        printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	91050513          	addi	a0,a0,-1776 # d78 <malloc+0x1ec>
 470:	00000097          	auipc	ra,0x0
 474:	664080e7          	jalr	1636(ra) # ad4 <printf>
        exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	2e0080e7          	jalr	736(ra) # 75a <exit>

0000000000000482 <main>:

int main(int argc, char *argv[])
{
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
    simpletest();
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <simpletest>

    // check that the first simpletest() freed the physical memory.
    simpletest();
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>

    threetest();
 49a:	00000097          	auipc	ra,0x0
 49e:	c66080e7          	jalr	-922(ra) # 100 <threetest>
    threetest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	c5e080e7          	jalr	-930(ra) # 100 <threetest>
    threetest();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c56080e7          	jalr	-938(ra) # 100 <threetest>

    filetest();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e1a080e7          	jalr	-486(ra) # 2cc <filetest>

    printf("ALL COW TESTS PASSED\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	8de50513          	addi	a0,a0,-1826 # d98 <malloc+0x20c>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	612080e7          	jalr	1554(ra) # ad4 <printf>

    exit(0);
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	28e080e7          	jalr	654(ra) # 75a <exit>

00000000000004d4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4dc:	00000097          	auipc	ra,0x0
 4e0:	fa6080e7          	jalr	-90(ra) # 482 <main>
  exit(0);
 4e4:	4501                	li	a0,0
 4e6:	00000097          	auipc	ra,0x0
 4ea:	274080e7          	jalr	628(ra) # 75a <exit>

00000000000004ee <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f4:	87aa                	mv	a5,a0
 4f6:	0585                	addi	a1,a1,1
 4f8:	0785                	addi	a5,a5,1
 4fa:	fff5c703          	lbu	a4,-1(a1)
 4fe:	fee78fa3          	sb	a4,-1(a5)
 502:	fb75                	bnez	a4,4f6 <strcpy+0x8>
    ;
  return os;
}
 504:	6422                	ld	s0,8(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e422                	sd	s0,8(sp)
 50e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 510:	00054783          	lbu	a5,0(a0)
 514:	cb91                	beqz	a5,528 <strcmp+0x1e>
 516:	0005c703          	lbu	a4,0(a1)
 51a:	00f71763          	bne	a4,a5,528 <strcmp+0x1e>
    p++, q++;
 51e:	0505                	addi	a0,a0,1
 520:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 522:	00054783          	lbu	a5,0(a0)
 526:	fbe5                	bnez	a5,516 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 528:	0005c503          	lbu	a0,0(a1)
}
 52c:	40a7853b          	subw	a0,a5,a0
 530:	6422                	ld	s0,8(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret

0000000000000536 <strlen>:

uint
strlen(const char *s)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 53c:	00054783          	lbu	a5,0(a0)
 540:	cf91                	beqz	a5,55c <strlen+0x26>
 542:	0505                	addi	a0,a0,1
 544:	87aa                	mv	a5,a0
 546:	4685                	li	a3,1
 548:	9e89                	subw	a3,a3,a0
 54a:	00f6853b          	addw	a0,a3,a5
 54e:	0785                	addi	a5,a5,1
 550:	fff7c703          	lbu	a4,-1(a5)
 554:	fb7d                	bnez	a4,54a <strlen+0x14>
    ;
  return n;
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
  for(n = 0; s[n]; n++)
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <strlen+0x20>

0000000000000560 <memset>:

void*
memset(void *dst, int c, uint n)
{
 560:	1141                	addi	sp,sp,-16
 562:	e422                	sd	s0,8(sp)
 564:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 566:	ca19                	beqz	a2,57c <memset+0x1c>
 568:	87aa                	mv	a5,a0
 56a:	1602                	slli	a2,a2,0x20
 56c:	9201                	srli	a2,a2,0x20
 56e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 572:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 576:	0785                	addi	a5,a5,1
 578:	fee79de3          	bne	a5,a4,572 <memset+0x12>
  }
  return dst;
}
 57c:	6422                	ld	s0,8(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret

0000000000000582 <strchr>:

char*
strchr(const char *s, char c)
{
 582:	1141                	addi	sp,sp,-16
 584:	e422                	sd	s0,8(sp)
 586:	0800                	addi	s0,sp,16
  for(; *s; s++)
 588:	00054783          	lbu	a5,0(a0)
 58c:	cb99                	beqz	a5,5a2 <strchr+0x20>
    if(*s == c)
 58e:	00f58763          	beq	a1,a5,59c <strchr+0x1a>
  for(; *s; s++)
 592:	0505                	addi	a0,a0,1
 594:	00054783          	lbu	a5,0(a0)
 598:	fbfd                	bnez	a5,58e <strchr+0xc>
      return (char*)s;
  return 0;
 59a:	4501                	li	a0,0
}
 59c:	6422                	ld	s0,8(sp)
 59e:	0141                	addi	sp,sp,16
 5a0:	8082                	ret
  return 0;
 5a2:	4501                	li	a0,0
 5a4:	bfe5                	j	59c <strchr+0x1a>

00000000000005a6 <gets>:

char*
gets(char *buf, int max)
{
 5a6:	711d                	addi	sp,sp,-96
 5a8:	ec86                	sd	ra,88(sp)
 5aa:	e8a2                	sd	s0,80(sp)
 5ac:	e4a6                	sd	s1,72(sp)
 5ae:	e0ca                	sd	s2,64(sp)
 5b0:	fc4e                	sd	s3,56(sp)
 5b2:	f852                	sd	s4,48(sp)
 5b4:	f456                	sd	s5,40(sp)
 5b6:	f05a                	sd	s6,32(sp)
 5b8:	ec5e                	sd	s7,24(sp)
 5ba:	1080                	addi	s0,sp,96
 5bc:	8baa                	mv	s7,a0
 5be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c0:	892a                	mv	s2,a0
 5c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5c4:	4aa9                	li	s5,10
 5c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5c8:	89a6                	mv	s3,s1
 5ca:	2485                	addiw	s1,s1,1
 5cc:	0344d863          	bge	s1,s4,5fc <gets+0x56>
    cc = read(0, &c, 1);
 5d0:	4605                	li	a2,1
 5d2:	faf40593          	addi	a1,s0,-81
 5d6:	4501                	li	a0,0
 5d8:	00000097          	auipc	ra,0x0
 5dc:	19a080e7          	jalr	410(ra) # 772 <read>
    if(cc < 1)
 5e0:	00a05e63          	blez	a0,5fc <gets+0x56>
    buf[i++] = c;
 5e4:	faf44783          	lbu	a5,-81(s0)
 5e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ec:	01578763          	beq	a5,s5,5fa <gets+0x54>
 5f0:	0905                	addi	s2,s2,1
 5f2:	fd679be3          	bne	a5,s6,5c8 <gets+0x22>
  for(i=0; i+1 < max; ){
 5f6:	89a6                	mv	s3,s1
 5f8:	a011                	j	5fc <gets+0x56>
 5fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5fc:	99de                	add	s3,s3,s7
 5fe:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1994ff0>
  return buf;
}
 602:	855e                	mv	a0,s7
 604:	60e6                	ld	ra,88(sp)
 606:	6446                	ld	s0,80(sp)
 608:	64a6                	ld	s1,72(sp)
 60a:	6906                	ld	s2,64(sp)
 60c:	79e2                	ld	s3,56(sp)
 60e:	7a42                	ld	s4,48(sp)
 610:	7aa2                	ld	s5,40(sp)
 612:	7b02                	ld	s6,32(sp)
 614:	6be2                	ld	s7,24(sp)
 616:	6125                	addi	sp,sp,96
 618:	8082                	ret

000000000000061a <stat>:

int
stat(const char *n, struct stat *st)
{
 61a:	1101                	addi	sp,sp,-32
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	e426                	sd	s1,8(sp)
 622:	e04a                	sd	s2,0(sp)
 624:	1000                	addi	s0,sp,32
 626:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 628:	4581                	li	a1,0
 62a:	00000097          	auipc	ra,0x0
 62e:	170080e7          	jalr	368(ra) # 79a <open>
  if(fd < 0)
 632:	02054563          	bltz	a0,65c <stat+0x42>
 636:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 638:	85ca                	mv	a1,s2
 63a:	00000097          	auipc	ra,0x0
 63e:	178080e7          	jalr	376(ra) # 7b2 <fstat>
 642:	892a                	mv	s2,a0
  close(fd);
 644:	8526                	mv	a0,s1
 646:	00000097          	auipc	ra,0x0
 64a:	13c080e7          	jalr	316(ra) # 782 <close>
  return r;
}
 64e:	854a                	mv	a0,s2
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	64a2                	ld	s1,8(sp)
 656:	6902                	ld	s2,0(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret
    return -1;
 65c:	597d                	li	s2,-1
 65e:	bfc5                	j	64e <stat+0x34>

0000000000000660 <atoi>:

int
atoi(const char *s)
{
 660:	1141                	addi	sp,sp,-16
 662:	e422                	sd	s0,8(sp)
 664:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 666:	00054683          	lbu	a3,0(a0)
 66a:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x1c0>
 66e:	0ff7f793          	zext.b	a5,a5
 672:	4625                	li	a2,9
 674:	02f66863          	bltu	a2,a5,6a4 <atoi+0x44>
 678:	872a                	mv	a4,a0
  n = 0;
 67a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 67c:	0705                	addi	a4,a4,1
 67e:	0025179b          	slliw	a5,a0,0x2
 682:	9fa9                	addw	a5,a5,a0
 684:	0017979b          	slliw	a5,a5,0x1
 688:	9fb5                	addw	a5,a5,a3
 68a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 68e:	00074683          	lbu	a3,0(a4)
 692:	fd06879b          	addiw	a5,a3,-48
 696:	0ff7f793          	zext.b	a5,a5
 69a:	fef671e3          	bgeu	a2,a5,67c <atoi+0x1c>
  return n;
}
 69e:	6422                	ld	s0,8(sp)
 6a0:	0141                	addi	sp,sp,16
 6a2:	8082                	ret
  n = 0;
 6a4:	4501                	li	a0,0
 6a6:	bfe5                	j	69e <atoi+0x3e>

00000000000006a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6a8:	1141                	addi	sp,sp,-16
 6aa:	e422                	sd	s0,8(sp)
 6ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6ae:	02b57463          	bgeu	a0,a1,6d6 <memmove+0x2e>
    while(n-- > 0)
 6b2:	00c05f63          	blez	a2,6d0 <memmove+0x28>
 6b6:	1602                	slli	a2,a2,0x20
 6b8:	9201                	srli	a2,a2,0x20
 6ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6be:	872a                	mv	a4,a0
      *dst++ = *src++;
 6c0:	0585                	addi	a1,a1,1
 6c2:	0705                	addi	a4,a4,1
 6c4:	fff5c683          	lbu	a3,-1(a1)
 6c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6cc:	fee79ae3          	bne	a5,a4,6c0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6d0:	6422                	ld	s0,8(sp)
 6d2:	0141                	addi	sp,sp,16
 6d4:	8082                	ret
    dst += n;
 6d6:	00c50733          	add	a4,a0,a2
    src += n;
 6da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6dc:	fec05ae3          	blez	a2,6d0 <memmove+0x28>
 6e0:	fff6079b          	addiw	a5,a2,-1
 6e4:	1782                	slli	a5,a5,0x20
 6e6:	9381                	srli	a5,a5,0x20
 6e8:	fff7c793          	not	a5,a5
 6ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6ee:	15fd                	addi	a1,a1,-1
 6f0:	177d                	addi	a4,a4,-1
 6f2:	0005c683          	lbu	a3,0(a1)
 6f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6fa:	fee79ae3          	bne	a5,a4,6ee <memmove+0x46>
 6fe:	bfc9                	j	6d0 <memmove+0x28>

0000000000000700 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 700:	1141                	addi	sp,sp,-16
 702:	e422                	sd	s0,8(sp)
 704:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 706:	ca05                	beqz	a2,736 <memcmp+0x36>
 708:	fff6069b          	addiw	a3,a2,-1
 70c:	1682                	slli	a3,a3,0x20
 70e:	9281                	srli	a3,a3,0x20
 710:	0685                	addi	a3,a3,1
 712:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 714:	00054783          	lbu	a5,0(a0)
 718:	0005c703          	lbu	a4,0(a1)
 71c:	00e79863          	bne	a5,a4,72c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 720:	0505                	addi	a0,a0,1
    p2++;
 722:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 724:	fed518e3          	bne	a0,a3,714 <memcmp+0x14>
  }
  return 0;
 728:	4501                	li	a0,0
 72a:	a019                	j	730 <memcmp+0x30>
      return *p1 - *p2;
 72c:	40e7853b          	subw	a0,a5,a4
}
 730:	6422                	ld	s0,8(sp)
 732:	0141                	addi	sp,sp,16
 734:	8082                	ret
  return 0;
 736:	4501                	li	a0,0
 738:	bfe5                	j	730 <memcmp+0x30>

000000000000073a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 73a:	1141                	addi	sp,sp,-16
 73c:	e406                	sd	ra,8(sp)
 73e:	e022                	sd	s0,0(sp)
 740:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 742:	00000097          	auipc	ra,0x0
 746:	f66080e7          	jalr	-154(ra) # 6a8 <memmove>
}
 74a:	60a2                	ld	ra,8(sp)
 74c:	6402                	ld	s0,0(sp)
 74e:	0141                	addi	sp,sp,16
 750:	8082                	ret

0000000000000752 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 752:	4885                	li	a7,1
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <exit>:
.global exit
exit:
 li a7, SYS_exit
 75a:	4889                	li	a7,2
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <wait>:
.global wait
wait:
 li a7, SYS_wait
 762:	488d                	li	a7,3
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 76a:	4891                	li	a7,4
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <read>:
.global read
read:
 li a7, SYS_read
 772:	4895                	li	a7,5
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <write>:
.global write
write:
 li a7, SYS_write
 77a:	48c1                	li	a7,16
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <close>:
.global close
close:
 li a7, SYS_close
 782:	48d5                	li	a7,21
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <kill>:
.global kill
kill:
 li a7, SYS_kill
 78a:	4899                	li	a7,6
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <exec>:
.global exec
exec:
 li a7, SYS_exec
 792:	489d                	li	a7,7
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <open>:
.global open
open:
 li a7, SYS_open
 79a:	48bd                	li	a7,15
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7a2:	48c5                	li	a7,17
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7aa:	48c9                	li	a7,18
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7b2:	48a1                	li	a7,8
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <link>:
.global link
link:
 li a7, SYS_link
 7ba:	48cd                	li	a7,19
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7c2:	48d1                	li	a7,20
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ca:	48a5                	li	a7,9
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7d2:	48a9                	li	a7,10
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7da:	48ad                	li	a7,11
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7e2:	48b1                	li	a7,12
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7ea:	48b5                	li	a7,13
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7f2:	48b9                	li	a7,14
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7fa:	1101                	addi	sp,sp,-32
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 806:	4605                	li	a2,1
 808:	fef40593          	addi	a1,s0,-17
 80c:	00000097          	auipc	ra,0x0
 810:	f6e080e7          	jalr	-146(ra) # 77a <write>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6105                	addi	sp,sp,32
 81a:	8082                	ret

000000000000081c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 81c:	7139                	addi	sp,sp,-64
 81e:	fc06                	sd	ra,56(sp)
 820:	f822                	sd	s0,48(sp)
 822:	f426                	sd	s1,40(sp)
 824:	f04a                	sd	s2,32(sp)
 826:	ec4e                	sd	s3,24(sp)
 828:	0080                	addi	s0,sp,64
 82a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 82c:	c299                	beqz	a3,832 <printint+0x16>
 82e:	0805c963          	bltz	a1,8c0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 832:	2581                	sext.w	a1,a1
  neg = 0;
 834:	4881                	li	a7,0
 836:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 83a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 83c:	2601                	sext.w	a2,a2
 83e:	00000517          	auipc	a0,0x0
 842:	5d250513          	addi	a0,a0,1490 # e10 <digits>
 846:	883a                	mv	a6,a4
 848:	2705                	addiw	a4,a4,1
 84a:	02c5f7bb          	remuw	a5,a1,a2
 84e:	1782                	slli	a5,a5,0x20
 850:	9381                	srli	a5,a5,0x20
 852:	97aa                	add	a5,a5,a0
 854:	0007c783          	lbu	a5,0(a5)
 858:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 85c:	0005879b          	sext.w	a5,a1
 860:	02c5d5bb          	divuw	a1,a1,a2
 864:	0685                	addi	a3,a3,1
 866:	fec7f0e3          	bgeu	a5,a2,846 <printint+0x2a>
  if(neg)
 86a:	00088c63          	beqz	a7,882 <printint+0x66>
    buf[i++] = '-';
 86e:	fd070793          	addi	a5,a4,-48
 872:	00878733          	add	a4,a5,s0
 876:	02d00793          	li	a5,45
 87a:	fef70823          	sb	a5,-16(a4)
 87e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 882:	02e05863          	blez	a4,8b2 <printint+0x96>
 886:	fc040793          	addi	a5,s0,-64
 88a:	00e78933          	add	s2,a5,a4
 88e:	fff78993          	addi	s3,a5,-1
 892:	99ba                	add	s3,s3,a4
 894:	377d                	addiw	a4,a4,-1
 896:	1702                	slli	a4,a4,0x20
 898:	9301                	srli	a4,a4,0x20
 89a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 89e:	fff94583          	lbu	a1,-1(s2)
 8a2:	8526                	mv	a0,s1
 8a4:	00000097          	auipc	ra,0x0
 8a8:	f56080e7          	jalr	-170(ra) # 7fa <putc>
  while(--i >= 0)
 8ac:	197d                	addi	s2,s2,-1
 8ae:	ff3918e3          	bne	s2,s3,89e <printint+0x82>
}
 8b2:	70e2                	ld	ra,56(sp)
 8b4:	7442                	ld	s0,48(sp)
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6121                	addi	sp,sp,64
 8be:	8082                	ret
    x = -xx;
 8c0:	40b005bb          	negw	a1,a1
    neg = 1;
 8c4:	4885                	li	a7,1
    x = -xx;
 8c6:	bf85                	j	836 <printint+0x1a>

00000000000008c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8c8:	7119                	addi	sp,sp,-128
 8ca:	fc86                	sd	ra,120(sp)
 8cc:	f8a2                	sd	s0,112(sp)
 8ce:	f4a6                	sd	s1,104(sp)
 8d0:	f0ca                	sd	s2,96(sp)
 8d2:	ecce                	sd	s3,88(sp)
 8d4:	e8d2                	sd	s4,80(sp)
 8d6:	e4d6                	sd	s5,72(sp)
 8d8:	e0da                	sd	s6,64(sp)
 8da:	fc5e                	sd	s7,56(sp)
 8dc:	f862                	sd	s8,48(sp)
 8de:	f466                	sd	s9,40(sp)
 8e0:	f06a                	sd	s10,32(sp)
 8e2:	ec6e                	sd	s11,24(sp)
 8e4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8e6:	0005c903          	lbu	s2,0(a1)
 8ea:	18090f63          	beqz	s2,a88 <vprintf+0x1c0>
 8ee:	8aaa                	mv	s5,a0
 8f0:	8b32                	mv	s6,a2
 8f2:	00158493          	addi	s1,a1,1
  state = 0;
 8f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8f8:	02500a13          	li	s4,37
 8fc:	4c55                	li	s8,21
 8fe:	00000c97          	auipc	s9,0x0
 902:	4bac8c93          	addi	s9,s9,1210 # db8 <malloc+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 906:	02800d93          	li	s11,40
  putc(fd, 'x');
 90a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 90c:	00000b97          	auipc	s7,0x0
 910:	504b8b93          	addi	s7,s7,1284 # e10 <digits>
 914:	a839                	j	932 <vprintf+0x6a>
        putc(fd, c);
 916:	85ca                	mv	a1,s2
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	ee0080e7          	jalr	-288(ra) # 7fa <putc>
 922:	a019                	j	928 <vprintf+0x60>
    } else if(state == '%'){
 924:	01498d63          	beq	s3,s4,93e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 928:	0485                	addi	s1,s1,1
 92a:	fff4c903          	lbu	s2,-1(s1)
 92e:	14090d63          	beqz	s2,a88 <vprintf+0x1c0>
    if(state == 0){
 932:	fe0999e3          	bnez	s3,924 <vprintf+0x5c>
      if(c == '%'){
 936:	ff4910e3          	bne	s2,s4,916 <vprintf+0x4e>
        state = '%';
 93a:	89d2                	mv	s3,s4
 93c:	b7f5                	j	928 <vprintf+0x60>
      if(c == 'd'){
 93e:	11490c63          	beq	s2,s4,a56 <vprintf+0x18e>
 942:	f9d9079b          	addiw	a5,s2,-99
 946:	0ff7f793          	zext.b	a5,a5
 94a:	10fc6e63          	bltu	s8,a5,a66 <vprintf+0x19e>
 94e:	f9d9079b          	addiw	a5,s2,-99
 952:	0ff7f713          	zext.b	a4,a5
 956:	10ec6863          	bltu	s8,a4,a66 <vprintf+0x19e>
 95a:	00271793          	slli	a5,a4,0x2
 95e:	97e6                	add	a5,a5,s9
 960:	439c                	lw	a5,0(a5)
 962:	97e6                	add	a5,a5,s9
 964:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 966:	008b0913          	addi	s2,s6,8
 96a:	4685                	li	a3,1
 96c:	4629                	li	a2,10
 96e:	000b2583          	lw	a1,0(s6)
 972:	8556                	mv	a0,s5
 974:	00000097          	auipc	ra,0x0
 978:	ea8080e7          	jalr	-344(ra) # 81c <printint>
 97c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 97e:	4981                	li	s3,0
 980:	b765                	j	928 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 982:	008b0913          	addi	s2,s6,8
 986:	4681                	li	a3,0
 988:	4629                	li	a2,10
 98a:	000b2583          	lw	a1,0(s6)
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	e8c080e7          	jalr	-372(ra) # 81c <printint>
 998:	8b4a                	mv	s6,s2
      state = 0;
 99a:	4981                	li	s3,0
 99c:	b771                	j	928 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 99e:	008b0913          	addi	s2,s6,8
 9a2:	4681                	li	a3,0
 9a4:	866a                	mv	a2,s10
 9a6:	000b2583          	lw	a1,0(s6)
 9aa:	8556                	mv	a0,s5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	e70080e7          	jalr	-400(ra) # 81c <printint>
 9b4:	8b4a                	mv	s6,s2
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	bf85                	j	928 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9ba:	008b0793          	addi	a5,s6,8
 9be:	f8f43423          	sd	a5,-120(s0)
 9c2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9c6:	03000593          	li	a1,48
 9ca:	8556                	mv	a0,s5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	e2e080e7          	jalr	-466(ra) # 7fa <putc>
  putc(fd, 'x');
 9d4:	07800593          	li	a1,120
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	e20080e7          	jalr	-480(ra) # 7fa <putc>
 9e2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9e4:	03c9d793          	srli	a5,s3,0x3c
 9e8:	97de                	add	a5,a5,s7
 9ea:	0007c583          	lbu	a1,0(a5)
 9ee:	8556                	mv	a0,s5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	e0a080e7          	jalr	-502(ra) # 7fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9f8:	0992                	slli	s3,s3,0x4
 9fa:	397d                	addiw	s2,s2,-1
 9fc:	fe0914e3          	bnez	s2,9e4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 a00:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a04:	4981                	li	s3,0
 a06:	b70d                	j	928 <vprintf+0x60>
        s = va_arg(ap, char*);
 a08:	008b0913          	addi	s2,s6,8
 a0c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 a10:	02098163          	beqz	s3,a32 <vprintf+0x16a>
        while(*s != 0){
 a14:	0009c583          	lbu	a1,0(s3)
 a18:	c5ad                	beqz	a1,a82 <vprintf+0x1ba>
          putc(fd, *s);
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	dde080e7          	jalr	-546(ra) # 7fa <putc>
          s++;
 a24:	0985                	addi	s3,s3,1
        while(*s != 0){
 a26:	0009c583          	lbu	a1,0(s3)
 a2a:	f9e5                	bnez	a1,a1a <vprintf+0x152>
        s = va_arg(ap, char*);
 a2c:	8b4a                	mv	s6,s2
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	bde5                	j	928 <vprintf+0x60>
          s = "(null)";
 a32:	00000997          	auipc	s3,0x0
 a36:	37e98993          	addi	s3,s3,894 # db0 <malloc+0x224>
        while(*s != 0){
 a3a:	85ee                	mv	a1,s11
 a3c:	bff9                	j	a1a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a3e:	008b0913          	addi	s2,s6,8
 a42:	000b4583          	lbu	a1,0(s6)
 a46:	8556                	mv	a0,s5
 a48:	00000097          	auipc	ra,0x0
 a4c:	db2080e7          	jalr	-590(ra) # 7fa <putc>
 a50:	8b4a                	mv	s6,s2
      state = 0;
 a52:	4981                	li	s3,0
 a54:	bdd1                	j	928 <vprintf+0x60>
        putc(fd, c);
 a56:	85d2                	mv	a1,s4
 a58:	8556                	mv	a0,s5
 a5a:	00000097          	auipc	ra,0x0
 a5e:	da0080e7          	jalr	-608(ra) # 7fa <putc>
      state = 0;
 a62:	4981                	li	s3,0
 a64:	b5d1                	j	928 <vprintf+0x60>
        putc(fd, '%');
 a66:	85d2                	mv	a1,s4
 a68:	8556                	mv	a0,s5
 a6a:	00000097          	auipc	ra,0x0
 a6e:	d90080e7          	jalr	-624(ra) # 7fa <putc>
        putc(fd, c);
 a72:	85ca                	mv	a1,s2
 a74:	8556                	mv	a0,s5
 a76:	00000097          	auipc	ra,0x0
 a7a:	d84080e7          	jalr	-636(ra) # 7fa <putc>
      state = 0;
 a7e:	4981                	li	s3,0
 a80:	b565                	j	928 <vprintf+0x60>
        s = va_arg(ap, char*);
 a82:	8b4a                	mv	s6,s2
      state = 0;
 a84:	4981                	li	s3,0
 a86:	b54d                	j	928 <vprintf+0x60>
    }
  }
}
 a88:	70e6                	ld	ra,120(sp)
 a8a:	7446                	ld	s0,112(sp)
 a8c:	74a6                	ld	s1,104(sp)
 a8e:	7906                	ld	s2,96(sp)
 a90:	69e6                	ld	s3,88(sp)
 a92:	6a46                	ld	s4,80(sp)
 a94:	6aa6                	ld	s5,72(sp)
 a96:	6b06                	ld	s6,64(sp)
 a98:	7be2                	ld	s7,56(sp)
 a9a:	7c42                	ld	s8,48(sp)
 a9c:	7ca2                	ld	s9,40(sp)
 a9e:	7d02                	ld	s10,32(sp)
 aa0:	6de2                	ld	s11,24(sp)
 aa2:	6109                	addi	sp,sp,128
 aa4:	8082                	ret

0000000000000aa6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 aa6:	715d                	addi	sp,sp,-80
 aa8:	ec06                	sd	ra,24(sp)
 aaa:	e822                	sd	s0,16(sp)
 aac:	1000                	addi	s0,sp,32
 aae:	e010                	sd	a2,0(s0)
 ab0:	e414                	sd	a3,8(s0)
 ab2:	e818                	sd	a4,16(s0)
 ab4:	ec1c                	sd	a5,24(s0)
 ab6:	03043023          	sd	a6,32(s0)
 aba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 abe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ac2:	8622                	mv	a2,s0
 ac4:	00000097          	auipc	ra,0x0
 ac8:	e04080e7          	jalr	-508(ra) # 8c8 <vprintf>
}
 acc:	60e2                	ld	ra,24(sp)
 ace:	6442                	ld	s0,16(sp)
 ad0:	6161                	addi	sp,sp,80
 ad2:	8082                	ret

0000000000000ad4 <printf>:

void
printf(const char *fmt, ...)
{
 ad4:	711d                	addi	sp,sp,-96
 ad6:	ec06                	sd	ra,24(sp)
 ad8:	e822                	sd	s0,16(sp)
 ada:	1000                	addi	s0,sp,32
 adc:	e40c                	sd	a1,8(s0)
 ade:	e810                	sd	a2,16(s0)
 ae0:	ec14                	sd	a3,24(s0)
 ae2:	f018                	sd	a4,32(s0)
 ae4:	f41c                	sd	a5,40(s0)
 ae6:	03043823          	sd	a6,48(s0)
 aea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aee:	00840613          	addi	a2,s0,8
 af2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 af6:	85aa                	mv	a1,a0
 af8:	4505                	li	a0,1
 afa:	00000097          	auipc	ra,0x0
 afe:	dce080e7          	jalr	-562(ra) # 8c8 <vprintf>
}
 b02:	60e2                	ld	ra,24(sp)
 b04:	6442                	ld	s0,16(sp)
 b06:	6125                	addi	sp,sp,96
 b08:	8082                	ret

0000000000000b0a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b0a:	1141                	addi	sp,sp,-16
 b0c:	e422                	sd	s0,8(sp)
 b0e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b10:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b14:	00000797          	auipc	a5,0x0
 b18:	4f47b783          	ld	a5,1268(a5) # 1008 <freep>
 b1c:	a02d                	j	b46 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b1e:	4618                	lw	a4,8(a2)
 b20:	9f2d                	addw	a4,a4,a1
 b22:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b26:	6398                	ld	a4,0(a5)
 b28:	6310                	ld	a2,0(a4)
 b2a:	a83d                	j	b68 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b2c:	ff852703          	lw	a4,-8(a0)
 b30:	9f31                	addw	a4,a4,a2
 b32:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b34:	ff053683          	ld	a3,-16(a0)
 b38:	a091                	j	b7c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b3a:	6398                	ld	a4,0(a5)
 b3c:	00e7e463          	bltu	a5,a4,b44 <free+0x3a>
 b40:	00e6ea63          	bltu	a3,a4,b54 <free+0x4a>
{
 b44:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b46:	fed7fae3          	bgeu	a5,a3,b3a <free+0x30>
 b4a:	6398                	ld	a4,0(a5)
 b4c:	00e6e463          	bltu	a3,a4,b54 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b50:	fee7eae3          	bltu	a5,a4,b44 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b54:	ff852583          	lw	a1,-8(a0)
 b58:	6390                	ld	a2,0(a5)
 b5a:	02059813          	slli	a6,a1,0x20
 b5e:	01c85713          	srli	a4,a6,0x1c
 b62:	9736                	add	a4,a4,a3
 b64:	fae60de3          	beq	a2,a4,b1e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b68:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b6c:	4790                	lw	a2,8(a5)
 b6e:	02061593          	slli	a1,a2,0x20
 b72:	01c5d713          	srli	a4,a1,0x1c
 b76:	973e                	add	a4,a4,a5
 b78:	fae68ae3          	beq	a3,a4,b2c <free+0x22>
    p->s.ptr = bp->s.ptr;
 b7c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b7e:	00000717          	auipc	a4,0x0
 b82:	48f73523          	sd	a5,1162(a4) # 1008 <freep>
}
 b86:	6422                	ld	s0,8(sp)
 b88:	0141                	addi	sp,sp,16
 b8a:	8082                	ret

0000000000000b8c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b8c:	7139                	addi	sp,sp,-64
 b8e:	fc06                	sd	ra,56(sp)
 b90:	f822                	sd	s0,48(sp)
 b92:	f426                	sd	s1,40(sp)
 b94:	f04a                	sd	s2,32(sp)
 b96:	ec4e                	sd	s3,24(sp)
 b98:	e852                	sd	s4,16(sp)
 b9a:	e456                	sd	s5,8(sp)
 b9c:	e05a                	sd	s6,0(sp)
 b9e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ba0:	02051493          	slli	s1,a0,0x20
 ba4:	9081                	srli	s1,s1,0x20
 ba6:	04bd                	addi	s1,s1,15
 ba8:	8091                	srli	s1,s1,0x4
 baa:	0014899b          	addiw	s3,s1,1
 bae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 bb0:	00000517          	auipc	a0,0x0
 bb4:	45853503          	ld	a0,1112(a0) # 1008 <freep>
 bb8:	c515                	beqz	a0,be4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bbc:	4798                	lw	a4,8(a5)
 bbe:	02977f63          	bgeu	a4,s1,bfc <malloc+0x70>
 bc2:	8a4e                	mv	s4,s3
 bc4:	0009871b          	sext.w	a4,s3
 bc8:	6685                	lui	a3,0x1
 bca:	00d77363          	bgeu	a4,a3,bd0 <malloc+0x44>
 bce:	6a05                	lui	s4,0x1
 bd0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bd4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd8:	00000917          	auipc	s2,0x0
 bdc:	43090913          	addi	s2,s2,1072 # 1008 <freep>
  if(p == (char*)-1)
 be0:	5afd                	li	s5,-1
 be2:	a895                	j	c56 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 be4:	00004797          	auipc	a5,0x4
 be8:	42c78793          	addi	a5,a5,1068 # 5010 <base>
 bec:	00000717          	auipc	a4,0x0
 bf0:	40f73e23          	sd	a5,1052(a4) # 1008 <freep>
 bf4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bf6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bfa:	b7e1                	j	bc2 <malloc+0x36>
      if(p->s.size == nunits)
 bfc:	02e48c63          	beq	s1,a4,c34 <malloc+0xa8>
        p->s.size -= nunits;
 c00:	4137073b          	subw	a4,a4,s3
 c04:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c06:	02071693          	slli	a3,a4,0x20
 c0a:	01c6d713          	srli	a4,a3,0x1c
 c0e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c10:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c14:	00000717          	auipc	a4,0x0
 c18:	3ea73a23          	sd	a0,1012(a4) # 1008 <freep>
      return (void*)(p + 1);
 c1c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c20:	70e2                	ld	ra,56(sp)
 c22:	7442                	ld	s0,48(sp)
 c24:	74a2                	ld	s1,40(sp)
 c26:	7902                	ld	s2,32(sp)
 c28:	69e2                	ld	s3,24(sp)
 c2a:	6a42                	ld	s4,16(sp)
 c2c:	6aa2                	ld	s5,8(sp)
 c2e:	6b02                	ld	s6,0(sp)
 c30:	6121                	addi	sp,sp,64
 c32:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c34:	6398                	ld	a4,0(a5)
 c36:	e118                	sd	a4,0(a0)
 c38:	bff1                	j	c14 <malloc+0x88>
  hp->s.size = nu;
 c3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c3e:	0541                	addi	a0,a0,16
 c40:	00000097          	auipc	ra,0x0
 c44:	eca080e7          	jalr	-310(ra) # b0a <free>
  return freep;
 c48:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c4c:	d971                	beqz	a0,c20 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c50:	4798                	lw	a4,8(a5)
 c52:	fa9775e3          	bgeu	a4,s1,bfc <malloc+0x70>
    if(p == freep)
 c56:	00093703          	ld	a4,0(s2)
 c5a:	853e                	mv	a0,a5
 c5c:	fef719e3          	bne	a4,a5,c4e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c60:	8552                	mv	a0,s4
 c62:	00000097          	auipc	ra,0x0
 c66:	b80080e7          	jalr	-1152(ra) # 7e2 <sbrk>
  if(p == (char*)-1)
 c6a:	fd5518e3          	bne	a0,s5,c3a <malloc+0xae>
        return 0;
 c6e:	4501                	li	a0,0
 c70:	bf45                	j	c20 <malloc+0x94>
