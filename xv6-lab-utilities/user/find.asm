
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"

#define MAX_PATH_LENGTH 512

char *fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	368080e7          	jalr	872(ra) # 378 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
        ;
    p++;
  36:	00178493          	addi	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	33c080e7          	jalr	828(ra) # 378 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
            *(i + 1) = '\0';
            break;
        }
    }
    return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
    memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	31a080e7          	jalr	794(ra) # 378 <strlen>
  66:	00001917          	auipc	s2,0x1
  6a:	faa90913          	addi	s2,s2,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854a                	mv	a0,s2
  76:	00000097          	auipc	ra,0x0
  7a:	474080e7          	jalr	1140(ra) # 4ea <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2f8080e7          	jalr	760(ra) # 378 <strlen>
  88:	0005099b          	sext.w	s3,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2ea080e7          	jalr	746(ra) # 378 <strlen>
  96:	1982                	slli	s3,s3,0x20
  98:	0209d993          	srli	s3,s3,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01390533          	add	a0,s2,s3
  a8:	00000097          	auipc	ra,0x0
  ac:	2fa080e7          	jalr	762(ra) # 3a2 <memset>
    for (char *i = buf + strlen(buf);; i--) {
  b0:	854a                	mv	a0,s2
  b2:	00000097          	auipc	ra,0x0
  b6:	2c6080e7          	jalr	710(ra) # 378 <strlen>
  ba:	1502                	slli	a0,a0,0x20
  bc:	9101                	srli	a0,a0,0x20
  be:	954a                	add	a0,a0,s2
  c0:	02000693          	li	a3,32
  c4:	00800737          	lui	a4,0x800
  c8:	074d                	addi	a4,a4,19 # 800013 <base+0x7feff3>
  ca:	0726                	slli	a4,a4,0x9
  cc:	a011                	j	d0 <fmtname+0xd0>
  ce:	157d                	addi	a0,a0,-1
        if (*i != '\0' && *i != ' ' && *i != '\n' && *i != '\r' && *i != '\t') {
  d0:	00054783          	lbu	a5,0(a0)
  d4:	dfed                	beqz	a5,ce <fmtname+0xce>
  d6:	00f6e663          	bltu	a3,a5,e2 <fmtname+0xe2>
  da:	00f757b3          	srl	a5,a4,a5
  de:	8b85                	andi	a5,a5,1
  e0:	f7fd                	bnez	a5,ce <fmtname+0xce>
            *(i + 1) = '\0';
  e2:	000500a3          	sb	zero,1(a0)
    return buf;
  e6:	00001497          	auipc	s1,0x1
  ea:	f2a48493          	addi	s1,s1,-214 # 1010 <buf.0>
  ee:	bfb9                	j	4c <fmtname+0x4c>

00000000000000f0 <find>:

void find(char *path, char *filename)
{
  f0:	d9010113          	addi	sp,sp,-624
  f4:	26113423          	sd	ra,616(sp)
  f8:	26813023          	sd	s0,608(sp)
  fc:	24913c23          	sd	s1,600(sp)
 100:	25213823          	sd	s2,592(sp)
 104:	25313423          	sd	s3,584(sp)
 108:	25413023          	sd	s4,576(sp)
 10c:	23513c23          	sd	s5,568(sp)
 110:	23613823          	sd	s6,560(sp)
 114:	1c80                	addi	s0,sp,624
 116:	892a                	mv	s2,a0
 118:	89ae                	mv	s3,a1
    char *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0) {
 11a:	4581                	li	a1,0
 11c:	00000097          	auipc	ra,0x0
 120:	4c0080e7          	jalr	1216(ra) # 5dc <open>
 124:	06054863          	bltz	a0,194 <find+0xa4>
 128:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0) {
 12a:	d9840593          	addi	a1,s0,-616
 12e:	00000097          	auipc	ra,0x0
 132:	4c6080e7          	jalr	1222(ra) # 5f4 <fstat>
 136:	06054a63          	bltz	a0,1aa <find+0xba>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type) {
 13a:	da041783          	lh	a5,-608(s0)
 13e:	0007869b          	sext.w	a3,a5
 142:	4705                	li	a4,1
 144:	08e68d63          	beq	a3,a4,1de <find+0xee>
 148:	4709                	li	a4,2
 14a:	00e69d63          	bne	a3,a4,164 <find+0x74>
    case T_FILE:
        if (strcmp(fmtname(path), filename) == 0) {
 14e:	854a                	mv	a0,s2
 150:	00000097          	auipc	ra,0x0
 154:	eb0080e7          	jalr	-336(ra) # 0 <fmtname>
 158:	85ce                	mv	a1,s3
 15a:	00000097          	auipc	ra,0x0
 15e:	1f2080e7          	jalr	498(ra) # 34c <strcmp>
 162:	c525                	beqz	a0,1ca <find+0xda>
            find(buf, filename);
        }
        break;
    }

    close(fd);
 164:	8526                	mv	a0,s1
 166:	00000097          	auipc	ra,0x0
 16a:	45e080e7          	jalr	1118(ra) # 5c4 <close>
}
 16e:	26813083          	ld	ra,616(sp)
 172:	26013403          	ld	s0,608(sp)
 176:	25813483          	ld	s1,600(sp)
 17a:	25013903          	ld	s2,592(sp)
 17e:	24813983          	ld	s3,584(sp)
 182:	24013a03          	ld	s4,576(sp)
 186:	23813a83          	ld	s5,568(sp)
 18a:	23013b03          	ld	s6,560(sp)
 18e:	27010113          	addi	sp,sp,624
 192:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
 194:	864a                	mv	a2,s2
 196:	00001597          	auipc	a1,0x1
 19a:	92a58593          	addi	a1,a1,-1750 # ac0 <malloc+0xf2>
 19e:	4509                	li	a0,2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	748080e7          	jalr	1864(ra) # 8e8 <fprintf>
        return;
 1a8:	b7d9                	j	16e <find+0x7e>
        fprintf(2, "find: cannot stat %s\n", path);
 1aa:	864a                	mv	a2,s2
 1ac:	00001597          	auipc	a1,0x1
 1b0:	92c58593          	addi	a1,a1,-1748 # ad8 <malloc+0x10a>
 1b4:	4509                	li	a0,2
 1b6:	00000097          	auipc	ra,0x0
 1ba:	732080e7          	jalr	1842(ra) # 8e8 <fprintf>
        close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	404080e7          	jalr	1028(ra) # 5c4 <close>
        return;
 1c8:	b75d                	j	16e <find+0x7e>
            printf("%s\n", path);
 1ca:	85ca                	mv	a1,s2
 1cc:	00001517          	auipc	a0,0x1
 1d0:	92450513          	addi	a0,a0,-1756 # af0 <malloc+0x122>
 1d4:	00000097          	auipc	ra,0x0
 1d8:	742080e7          	jalr	1858(ra) # 916 <printf>
 1dc:	b761                	j	164 <find+0x74>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
 1de:	854a                	mv	a0,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	198080e7          	jalr	408(ra) # 378 <strlen>
 1e8:	2541                	addiw	a0,a0,16
 1ea:	20000793          	li	a5,512
 1ee:	00a7fc63          	bgeu	a5,a0,206 <find+0x116>
            fprintf(2, "find: path too long\n");
 1f2:	00001597          	auipc	a1,0x1
 1f6:	90658593          	addi	a1,a1,-1786 # af8 <malloc+0x12a>
 1fa:	4509                	li	a0,2
 1fc:	00000097          	auipc	ra,0x0
 200:	6ec080e7          	jalr	1772(ra) # 8e8 <fprintf>
            break;
 204:	b785                	j	164 <find+0x74>
        strcpy(buf, path);
 206:	85ca                	mv	a1,s2
 208:	dc040513          	addi	a0,s0,-576
 20c:	00000097          	auipc	ra,0x0
 210:	124080e7          	jalr	292(ra) # 330 <strcpy>
        p = buf + strlen(buf);
 214:	dc040513          	addi	a0,s0,-576
 218:	00000097          	auipc	ra,0x0
 21c:	160080e7          	jalr	352(ra) # 378 <strlen>
 220:	1502                	slli	a0,a0,0x20
 222:	9101                	srli	a0,a0,0x20
 224:	dc040793          	addi	a5,s0,-576
 228:	00a78933          	add	s2,a5,a0
        *p++ = '/';
 22c:	00190b13          	addi	s6,s2,1
 230:	02f00793          	li	a5,47
 234:	00f90023          	sb	a5,0(s2)
            if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
 238:	00001a17          	auipc	s4,0x1
 23c:	8d8a0a13          	addi	s4,s4,-1832 # b10 <malloc+0x142>
 240:	00001a97          	auipc	s5,0x1
 244:	8d8a8a93          	addi	s5,s5,-1832 # b18 <malloc+0x14a>
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 248:	4641                	li	a2,16
 24a:	db040593          	addi	a1,s0,-592
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	364080e7          	jalr	868(ra) # 5b4 <read>
 258:	47c1                	li	a5,16
 25a:	f0f515e3          	bne	a0,a5,164 <find+0x74>
            if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
 25e:	db045783          	lhu	a5,-592(s0)
 262:	d3fd                	beqz	a5,248 <find+0x158>
 264:	85d2                	mv	a1,s4
 266:	db240513          	addi	a0,s0,-590
 26a:	00000097          	auipc	ra,0x0
 26e:	0e2080e7          	jalr	226(ra) # 34c <strcmp>
 272:	d979                	beqz	a0,248 <find+0x158>
 274:	85d6                	mv	a1,s5
 276:	db240513          	addi	a0,s0,-590
 27a:	00000097          	auipc	ra,0x0
 27e:	0d2080e7          	jalr	210(ra) # 34c <strcmp>
 282:	d179                	beqz	a0,248 <find+0x158>
            memmove(p, de.name, DIRSIZ);
 284:	4639                	li	a2,14
 286:	db240593          	addi	a1,s0,-590
 28a:	855a                	mv	a0,s6
 28c:	00000097          	auipc	ra,0x0
 290:	25e080e7          	jalr	606(ra) # 4ea <memmove>
            p[DIRSIZ] = 0;
 294:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0) {
 298:	d9840593          	addi	a1,s0,-616
 29c:	dc040513          	addi	a0,s0,-576
 2a0:	00000097          	auipc	ra,0x0
 2a4:	1bc080e7          	jalr	444(ra) # 45c <stat>
 2a8:	00054a63          	bltz	a0,2bc <find+0x1cc>
            find(buf, filename);
 2ac:	85ce                	mv	a1,s3
 2ae:	dc040513          	addi	a0,s0,-576
 2b2:	00000097          	auipc	ra,0x0
 2b6:	e3e080e7          	jalr	-450(ra) # f0 <find>
 2ba:	b779                	j	248 <find+0x158>
                fprintf(2, "find: cannot stat %s\n", buf);
 2bc:	dc040613          	addi	a2,s0,-576
 2c0:	00001597          	auipc	a1,0x1
 2c4:	81858593          	addi	a1,a1,-2024 # ad8 <malloc+0x10a>
 2c8:	4509                	li	a0,2
 2ca:	00000097          	auipc	ra,0x0
 2ce:	61e080e7          	jalr	1566(ra) # 8e8 <fprintf>
                continue;
 2d2:	bf9d                	j	248 <find+0x158>

00000000000002d4 <main>:

int main(int argc, char *argv[])
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
    if (argc != 3) {
 2dc:	470d                	li	a4,3
 2de:	02e50063          	beq	a0,a4,2fe <main+0x2a>
        fprintf(2, "Usage: find <directory> <filename>\n");
 2e2:	00001597          	auipc	a1,0x1
 2e6:	83e58593          	addi	a1,a1,-1986 # b20 <malloc+0x152>
 2ea:	4509                	li	a0,2
 2ec:	00000097          	auipc	ra,0x0
 2f0:	5fc080e7          	jalr	1532(ra) # 8e8 <fprintf>
        exit(0);
 2f4:	4501                	li	a0,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	2a6080e7          	jalr	678(ra) # 59c <exit>
 2fe:	87ae                	mv	a5,a1
    }

    find(argv[1], argv[2]);
 300:	698c                	ld	a1,16(a1)
 302:	6788                	ld	a0,8(a5)
 304:	00000097          	auipc	ra,0x0
 308:	dec080e7          	jalr	-532(ra) # f0 <find>
    exit(0);
 30c:	4501                	li	a0,0
 30e:	00000097          	auipc	ra,0x0
 312:	28e080e7          	jalr	654(ra) # 59c <exit>

0000000000000316 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 31e:	00000097          	auipc	ra,0x0
 322:	fb6080e7          	jalr	-74(ra) # 2d4 <main>
  exit(0);
 326:	4501                	li	a0,0
 328:	00000097          	auipc	ra,0x0
 32c:	274080e7          	jalr	628(ra) # 59c <exit>

0000000000000330 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 336:	87aa                	mv	a5,a0
 338:	0585                	addi	a1,a1,1
 33a:	0785                	addi	a5,a5,1
 33c:	fff5c703          	lbu	a4,-1(a1)
 340:	fee78fa3          	sb	a4,-1(a5)
 344:	fb75                	bnez	a4,338 <strcpy+0x8>
    ;
  return os;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 352:	00054783          	lbu	a5,0(a0)
 356:	cb91                	beqz	a5,36a <strcmp+0x1e>
 358:	0005c703          	lbu	a4,0(a1)
 35c:	00f71763          	bne	a4,a5,36a <strcmp+0x1e>
    p++, q++;
 360:	0505                	addi	a0,a0,1
 362:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 364:	00054783          	lbu	a5,0(a0)
 368:	fbe5                	bnez	a5,358 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 36a:	0005c503          	lbu	a0,0(a1)
}
 36e:	40a7853b          	subw	a0,a5,a0
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <strlen>:

uint
strlen(const char *s)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 37e:	00054783          	lbu	a5,0(a0)
 382:	cf91                	beqz	a5,39e <strlen+0x26>
 384:	0505                	addi	a0,a0,1
 386:	87aa                	mv	a5,a0
 388:	4685                	li	a3,1
 38a:	9e89                	subw	a3,a3,a0
 38c:	00f6853b          	addw	a0,a3,a5
 390:	0785                	addi	a5,a5,1
 392:	fff7c703          	lbu	a4,-1(a5)
 396:	fb7d                	bnez	a4,38c <strlen+0x14>
    ;
  return n;
}
 398:	6422                	ld	s0,8(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret
  for(n = 0; s[n]; n++)
 39e:	4501                	li	a0,0
 3a0:	bfe5                	j	398 <strlen+0x20>

00000000000003a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3a8:	ca19                	beqz	a2,3be <memset+0x1c>
 3aa:	87aa                	mv	a5,a0
 3ac:	1602                	slli	a2,a2,0x20
 3ae:	9201                	srli	a2,a2,0x20
 3b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b8:	0785                	addi	a5,a5,1
 3ba:	fee79de3          	bne	a5,a4,3b4 <memset+0x12>
  }
  return dst;
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <strchr>:

char*
strchr(const char *s, char c)
{
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e422                	sd	s0,8(sp)
 3c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	cb99                	beqz	a5,3e4 <strchr+0x20>
    if(*s == c)
 3d0:	00f58763          	beq	a1,a5,3de <strchr+0x1a>
  for(; *s; s++)
 3d4:	0505                	addi	a0,a0,1
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	fbfd                	bnez	a5,3d0 <strchr+0xc>
      return (char*)s;
  return 0;
 3dc:	4501                	li	a0,0
}
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	bfe5                	j	3de <strchr+0x1a>

00000000000003e8 <gets>:

char*
gets(char *buf, int max)
{
 3e8:	711d                	addi	sp,sp,-96
 3ea:	ec86                	sd	ra,88(sp)
 3ec:	e8a2                	sd	s0,80(sp)
 3ee:	e4a6                	sd	s1,72(sp)
 3f0:	e0ca                	sd	s2,64(sp)
 3f2:	fc4e                	sd	s3,56(sp)
 3f4:	f852                	sd	s4,48(sp)
 3f6:	f456                	sd	s5,40(sp)
 3f8:	f05a                	sd	s6,32(sp)
 3fa:	ec5e                	sd	s7,24(sp)
 3fc:	1080                	addi	s0,sp,96
 3fe:	8baa                	mv	s7,a0
 400:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 402:	892a                	mv	s2,a0
 404:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 406:	4aa9                	li	s5,10
 408:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 40a:	89a6                	mv	s3,s1
 40c:	2485                	addiw	s1,s1,1
 40e:	0344d863          	bge	s1,s4,43e <gets+0x56>
    cc = read(0, &c, 1);
 412:	4605                	li	a2,1
 414:	faf40593          	addi	a1,s0,-81
 418:	4501                	li	a0,0
 41a:	00000097          	auipc	ra,0x0
 41e:	19a080e7          	jalr	410(ra) # 5b4 <read>
    if(cc < 1)
 422:	00a05e63          	blez	a0,43e <gets+0x56>
    buf[i++] = c;
 426:	faf44783          	lbu	a5,-81(s0)
 42a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 42e:	01578763          	beq	a5,s5,43c <gets+0x54>
 432:	0905                	addi	s2,s2,1
 434:	fd679be3          	bne	a5,s6,40a <gets+0x22>
  for(i=0; i+1 < max; ){
 438:	89a6                	mv	s3,s1
 43a:	a011                	j	43e <gets+0x56>
 43c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 43e:	99de                	add	s3,s3,s7
 440:	00098023          	sb	zero,0(s3)
  return buf;
}
 444:	855e                	mv	a0,s7
 446:	60e6                	ld	ra,88(sp)
 448:	6446                	ld	s0,80(sp)
 44a:	64a6                	ld	s1,72(sp)
 44c:	6906                	ld	s2,64(sp)
 44e:	79e2                	ld	s3,56(sp)
 450:	7a42                	ld	s4,48(sp)
 452:	7aa2                	ld	s5,40(sp)
 454:	7b02                	ld	s6,32(sp)
 456:	6be2                	ld	s7,24(sp)
 458:	6125                	addi	sp,sp,96
 45a:	8082                	ret

000000000000045c <stat>:

int
stat(const char *n, struct stat *st)
{
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	e822                	sd	s0,16(sp)
 462:	e426                	sd	s1,8(sp)
 464:	e04a                	sd	s2,0(sp)
 466:	1000                	addi	s0,sp,32
 468:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 46a:	4581                	li	a1,0
 46c:	00000097          	auipc	ra,0x0
 470:	170080e7          	jalr	368(ra) # 5dc <open>
  if(fd < 0)
 474:	02054563          	bltz	a0,49e <stat+0x42>
 478:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 47a:	85ca                	mv	a1,s2
 47c:	00000097          	auipc	ra,0x0
 480:	178080e7          	jalr	376(ra) # 5f4 <fstat>
 484:	892a                	mv	s2,a0
  close(fd);
 486:	8526                	mv	a0,s1
 488:	00000097          	auipc	ra,0x0
 48c:	13c080e7          	jalr	316(ra) # 5c4 <close>
  return r;
}
 490:	854a                	mv	a0,s2
 492:	60e2                	ld	ra,24(sp)
 494:	6442                	ld	s0,16(sp)
 496:	64a2                	ld	s1,8(sp)
 498:	6902                	ld	s2,0(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret
    return -1;
 49e:	597d                	li	s2,-1
 4a0:	bfc5                	j	490 <stat+0x34>

00000000000004a2 <atoi>:

int
atoi(const char *s)
{
 4a2:	1141                	addi	sp,sp,-16
 4a4:	e422                	sd	s0,8(sp)
 4a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a8:	00054683          	lbu	a3,0(a0)
 4ac:	fd06879b          	addiw	a5,a3,-48
 4b0:	0ff7f793          	zext.b	a5,a5
 4b4:	4625                	li	a2,9
 4b6:	02f66863          	bltu	a2,a5,4e6 <atoi+0x44>
 4ba:	872a                	mv	a4,a0
  n = 0;
 4bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4be:	0705                	addi	a4,a4,1
 4c0:	0025179b          	slliw	a5,a0,0x2
 4c4:	9fa9                	addw	a5,a5,a0
 4c6:	0017979b          	slliw	a5,a5,0x1
 4ca:	9fb5                	addw	a5,a5,a3
 4cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4d0:	00074683          	lbu	a3,0(a4)
 4d4:	fd06879b          	addiw	a5,a3,-48
 4d8:	0ff7f793          	zext.b	a5,a5
 4dc:	fef671e3          	bgeu	a2,a5,4be <atoi+0x1c>
  return n;
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret
  n = 0;
 4e6:	4501                	li	a0,0
 4e8:	bfe5                	j	4e0 <atoi+0x3e>

00000000000004ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e422                	sd	s0,8(sp)
 4ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4f0:	02b57463          	bgeu	a0,a1,518 <memmove+0x2e>
    while(n-- > 0)
 4f4:	00c05f63          	blez	a2,512 <memmove+0x28>
 4f8:	1602                	slli	a2,a2,0x20
 4fa:	9201                	srli	a2,a2,0x20
 4fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 500:	872a                	mv	a4,a0
      *dst++ = *src++;
 502:	0585                	addi	a1,a1,1
 504:	0705                	addi	a4,a4,1
 506:	fff5c683          	lbu	a3,-1(a1)
 50a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 50e:	fee79ae3          	bne	a5,a4,502 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 512:	6422                	ld	s0,8(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret
    dst += n;
 518:	00c50733          	add	a4,a0,a2
    src += n;
 51c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 51e:	fec05ae3          	blez	a2,512 <memmove+0x28>
 522:	fff6079b          	addiw	a5,a2,-1
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	fff7c793          	not	a5,a5
 52e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 530:	15fd                	addi	a1,a1,-1
 532:	177d                	addi	a4,a4,-1
 534:	0005c683          	lbu	a3,0(a1)
 538:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 53c:	fee79ae3          	bne	a5,a4,530 <memmove+0x46>
 540:	bfc9                	j	512 <memmove+0x28>

0000000000000542 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 542:	1141                	addi	sp,sp,-16
 544:	e422                	sd	s0,8(sp)
 546:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 548:	ca05                	beqz	a2,578 <memcmp+0x36>
 54a:	fff6069b          	addiw	a3,a2,-1
 54e:	1682                	slli	a3,a3,0x20
 550:	9281                	srli	a3,a3,0x20
 552:	0685                	addi	a3,a3,1
 554:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 556:	00054783          	lbu	a5,0(a0)
 55a:	0005c703          	lbu	a4,0(a1)
 55e:	00e79863          	bne	a5,a4,56e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 562:	0505                	addi	a0,a0,1
    p2++;
 564:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 566:	fed518e3          	bne	a0,a3,556 <memcmp+0x14>
  }
  return 0;
 56a:	4501                	li	a0,0
 56c:	a019                	j	572 <memcmp+0x30>
      return *p1 - *p2;
 56e:	40e7853b          	subw	a0,a5,a4
}
 572:	6422                	ld	s0,8(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret
  return 0;
 578:	4501                	li	a0,0
 57a:	bfe5                	j	572 <memcmp+0x30>

000000000000057c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 57c:	1141                	addi	sp,sp,-16
 57e:	e406                	sd	ra,8(sp)
 580:	e022                	sd	s0,0(sp)
 582:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 584:	00000097          	auipc	ra,0x0
 588:	f66080e7          	jalr	-154(ra) # 4ea <memmove>
}
 58c:	60a2                	ld	ra,8(sp)
 58e:	6402                	ld	s0,0(sp)
 590:	0141                	addi	sp,sp,16
 592:	8082                	ret

0000000000000594 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 594:	4885                	li	a7,1
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <exit>:
.global exit
exit:
 li a7, SYS_exit
 59c:	4889                	li	a7,2
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a4:	488d                	li	a7,3
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ac:	4891                	li	a7,4
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <read>:
.global read
read:
 li a7, SYS_read
 5b4:	4895                	li	a7,5
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <write>:
.global write
write:
 li a7, SYS_write
 5bc:	48c1                	li	a7,16
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <close>:
.global close
close:
 li a7, SYS_close
 5c4:	48d5                	li	a7,21
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5cc:	4899                	li	a7,6
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d4:	489d                	li	a7,7
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <open>:
.global open
open:
 li a7, SYS_open
 5dc:	48bd                	li	a7,15
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e4:	48c5                	li	a7,17
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ec:	48c9                	li	a7,18
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f4:	48a1                	li	a7,8
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <link>:
.global link
link:
 li a7, SYS_link
 5fc:	48cd                	li	a7,19
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 604:	48d1                	li	a7,20
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60c:	48a5                	li	a7,9
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <dup>:
.global dup
dup:
 li a7, SYS_dup
 614:	48a9                	li	a7,10
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61c:	48ad                	li	a7,11
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 624:	48b1                	li	a7,12
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62c:	48b5                	li	a7,13
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 634:	48b9                	li	a7,14
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63c:	1101                	addi	sp,sp,-32
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 648:	4605                	li	a2,1
 64a:	fef40593          	addi	a1,s0,-17
 64e:	00000097          	auipc	ra,0x0
 652:	f6e080e7          	jalr	-146(ra) # 5bc <write>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6105                	addi	sp,sp,32
 65c:	8082                	ret

000000000000065e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65e:	7139                	addi	sp,sp,-64
 660:	fc06                	sd	ra,56(sp)
 662:	f822                	sd	s0,48(sp)
 664:	f426                	sd	s1,40(sp)
 666:	f04a                	sd	s2,32(sp)
 668:	ec4e                	sd	s3,24(sp)
 66a:	0080                	addi	s0,sp,64
 66c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66e:	c299                	beqz	a3,674 <printint+0x16>
 670:	0805c963          	bltz	a1,702 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 674:	2581                	sext.w	a1,a1
  neg = 0;
 676:	4881                	li	a7,0
 678:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67e:	2601                	sext.w	a2,a2
 680:	00000517          	auipc	a0,0x0
 684:	52850513          	addi	a0,a0,1320 # ba8 <digits>
 688:	883a                	mv	a6,a4
 68a:	2705                	addiw	a4,a4,1
 68c:	02c5f7bb          	remuw	a5,a1,a2
 690:	1782                	slli	a5,a5,0x20
 692:	9381                	srli	a5,a5,0x20
 694:	97aa                	add	a5,a5,a0
 696:	0007c783          	lbu	a5,0(a5)
 69a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69e:	0005879b          	sext.w	a5,a1
 6a2:	02c5d5bb          	divuw	a1,a1,a2
 6a6:	0685                	addi	a3,a3,1
 6a8:	fec7f0e3          	bgeu	a5,a2,688 <printint+0x2a>
  if(neg)
 6ac:	00088c63          	beqz	a7,6c4 <printint+0x66>
    buf[i++] = '-';
 6b0:	fd070793          	addi	a5,a4,-48
 6b4:	00878733          	add	a4,a5,s0
 6b8:	02d00793          	li	a5,45
 6bc:	fef70823          	sb	a5,-16(a4)
 6c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c4:	02e05863          	blez	a4,6f4 <printint+0x96>
 6c8:	fc040793          	addi	a5,s0,-64
 6cc:	00e78933          	add	s2,a5,a4
 6d0:	fff78993          	addi	s3,a5,-1
 6d4:	99ba                	add	s3,s3,a4
 6d6:	377d                	addiw	a4,a4,-1
 6d8:	1702                	slli	a4,a4,0x20
 6da:	9301                	srli	a4,a4,0x20
 6dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e0:	fff94583          	lbu	a1,-1(s2)
 6e4:	8526                	mv	a0,s1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	f56080e7          	jalr	-170(ra) # 63c <putc>
  while(--i >= 0)
 6ee:	197d                	addi	s2,s2,-1
 6f0:	ff3918e3          	bne	s2,s3,6e0 <printint+0x82>
}
 6f4:	70e2                	ld	ra,56(sp)
 6f6:	7442                	ld	s0,48(sp)
 6f8:	74a2                	ld	s1,40(sp)
 6fa:	7902                	ld	s2,32(sp)
 6fc:	69e2                	ld	s3,24(sp)
 6fe:	6121                	addi	sp,sp,64
 700:	8082                	ret
    x = -xx;
 702:	40b005bb          	negw	a1,a1
    neg = 1;
 706:	4885                	li	a7,1
    x = -xx;
 708:	bf85                	j	678 <printint+0x1a>

000000000000070a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70a:	7119                	addi	sp,sp,-128
 70c:	fc86                	sd	ra,120(sp)
 70e:	f8a2                	sd	s0,112(sp)
 710:	f4a6                	sd	s1,104(sp)
 712:	f0ca                	sd	s2,96(sp)
 714:	ecce                	sd	s3,88(sp)
 716:	e8d2                	sd	s4,80(sp)
 718:	e4d6                	sd	s5,72(sp)
 71a:	e0da                	sd	s6,64(sp)
 71c:	fc5e                	sd	s7,56(sp)
 71e:	f862                	sd	s8,48(sp)
 720:	f466                	sd	s9,40(sp)
 722:	f06a                	sd	s10,32(sp)
 724:	ec6e                	sd	s11,24(sp)
 726:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 728:	0005c903          	lbu	s2,0(a1)
 72c:	18090f63          	beqz	s2,8ca <vprintf+0x1c0>
 730:	8aaa                	mv	s5,a0
 732:	8b32                	mv	s6,a2
 734:	00158493          	addi	s1,a1,1
  state = 0;
 738:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 73a:	02500a13          	li	s4,37
 73e:	4c55                	li	s8,21
 740:	00000c97          	auipc	s9,0x0
 744:	410c8c93          	addi	s9,s9,1040 # b50 <malloc+0x182>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 748:	02800d93          	li	s11,40
  putc(fd, 'x');
 74c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74e:	00000b97          	auipc	s7,0x0
 752:	45ab8b93          	addi	s7,s7,1114 # ba8 <digits>
 756:	a839                	j	774 <vprintf+0x6a>
        putc(fd, c);
 758:	85ca                	mv	a1,s2
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ee0080e7          	jalr	-288(ra) # 63c <putc>
 764:	a019                	j	76a <vprintf+0x60>
    } else if(state == '%'){
 766:	01498d63          	beq	s3,s4,780 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 76a:	0485                	addi	s1,s1,1
 76c:	fff4c903          	lbu	s2,-1(s1)
 770:	14090d63          	beqz	s2,8ca <vprintf+0x1c0>
    if(state == 0){
 774:	fe0999e3          	bnez	s3,766 <vprintf+0x5c>
      if(c == '%'){
 778:	ff4910e3          	bne	s2,s4,758 <vprintf+0x4e>
        state = '%';
 77c:	89d2                	mv	s3,s4
 77e:	b7f5                	j	76a <vprintf+0x60>
      if(c == 'd'){
 780:	11490c63          	beq	s2,s4,898 <vprintf+0x18e>
 784:	f9d9079b          	addiw	a5,s2,-99
 788:	0ff7f793          	zext.b	a5,a5
 78c:	10fc6e63          	bltu	s8,a5,8a8 <vprintf+0x19e>
 790:	f9d9079b          	addiw	a5,s2,-99
 794:	0ff7f713          	zext.b	a4,a5
 798:	10ec6863          	bltu	s8,a4,8a8 <vprintf+0x19e>
 79c:	00271793          	slli	a5,a4,0x2
 7a0:	97e6                	add	a5,a5,s9
 7a2:	439c                	lw	a5,0(a5)
 7a4:	97e6                	add	a5,a5,s9
 7a6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7a8:	008b0913          	addi	s2,s6,8
 7ac:	4685                	li	a3,1
 7ae:	4629                	li	a2,10
 7b0:	000b2583          	lw	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	ea8080e7          	jalr	-344(ra) # 65e <printint>
 7be:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b765                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b0913          	addi	s2,s6,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e8c080e7          	jalr	-372(ra) # 65e <printint>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b771                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	4681                	li	a3,0
 7e6:	866a                	mv	a2,s10
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e70080e7          	jalr	-400(ra) # 65e <printint>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf85                	j	76a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7fc:	008b0793          	addi	a5,s6,8
 800:	f8f43423          	sd	a5,-120(s0)
 804:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 808:	03000593          	li	a1,48
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e2e080e7          	jalr	-466(ra) # 63c <putc>
  putc(fd, 'x');
 816:	07800593          	li	a1,120
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	e20080e7          	jalr	-480(ra) # 63c <putc>
 824:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 826:	03c9d793          	srli	a5,s3,0x3c
 82a:	97de                	add	a5,a5,s7
 82c:	0007c583          	lbu	a1,0(a5)
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e0a080e7          	jalr	-502(ra) # 63c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 83a:	0992                	slli	s3,s3,0x4
 83c:	397d                	addiw	s2,s2,-1
 83e:	fe0914e3          	bnez	s2,826 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 842:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 846:	4981                	li	s3,0
 848:	b70d                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 84a:	008b0913          	addi	s2,s6,8
 84e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 852:	02098163          	beqz	s3,874 <vprintf+0x16a>
        while(*s != 0){
 856:	0009c583          	lbu	a1,0(s3)
 85a:	c5ad                	beqz	a1,8c4 <vprintf+0x1ba>
          putc(fd, *s);
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	dde080e7          	jalr	-546(ra) # 63c <putc>
          s++;
 866:	0985                	addi	s3,s3,1
        while(*s != 0){
 868:	0009c583          	lbu	a1,0(s3)
 86c:	f9e5                	bnez	a1,85c <vprintf+0x152>
        s = va_arg(ap, char*);
 86e:	8b4a                	mv	s6,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	bde5                	j	76a <vprintf+0x60>
          s = "(null)";
 874:	00000997          	auipc	s3,0x0
 878:	2d498993          	addi	s3,s3,724 # b48 <malloc+0x17a>
        while(*s != 0){
 87c:	85ee                	mv	a1,s11
 87e:	bff9                	j	85c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 880:	008b0913          	addi	s2,s6,8
 884:	000b4583          	lbu	a1,0(s6)
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	db2080e7          	jalr	-590(ra) # 63c <putc>
 892:	8b4a                	mv	s6,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	bdd1                	j	76a <vprintf+0x60>
        putc(fd, c);
 898:	85d2                	mv	a1,s4
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	da0080e7          	jalr	-608(ra) # 63c <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b5d1                	j	76a <vprintf+0x60>
        putc(fd, '%');
 8a8:	85d2                	mv	a1,s4
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	d90080e7          	jalr	-624(ra) # 63c <putc>
        putc(fd, c);
 8b4:	85ca                	mv	a1,s2
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d84080e7          	jalr	-636(ra) # 63c <putc>
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b565                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 8c4:	8b4a                	mv	s6,s2
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	b54d                	j	76a <vprintf+0x60>
    }
  }
}
 8ca:	70e6                	ld	ra,120(sp)
 8cc:	7446                	ld	s0,112(sp)
 8ce:	74a6                	ld	s1,104(sp)
 8d0:	7906                	ld	s2,96(sp)
 8d2:	69e6                	ld	s3,88(sp)
 8d4:	6a46                	ld	s4,80(sp)
 8d6:	6aa6                	ld	s5,72(sp)
 8d8:	6b06                	ld	s6,64(sp)
 8da:	7be2                	ld	s7,56(sp)
 8dc:	7c42                	ld	s8,48(sp)
 8de:	7ca2                	ld	s9,40(sp)
 8e0:	7d02                	ld	s10,32(sp)
 8e2:	6de2                	ld	s11,24(sp)
 8e4:	6109                	addi	sp,sp,128
 8e6:	8082                	ret

00000000000008e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e8:	715d                	addi	sp,sp,-80
 8ea:	ec06                	sd	ra,24(sp)
 8ec:	e822                	sd	s0,16(sp)
 8ee:	1000                	addi	s0,sp,32
 8f0:	e010                	sd	a2,0(s0)
 8f2:	e414                	sd	a3,8(s0)
 8f4:	e818                	sd	a4,16(s0)
 8f6:	ec1c                	sd	a5,24(s0)
 8f8:	03043023          	sd	a6,32(s0)
 8fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 904:	8622                	mv	a2,s0
 906:	00000097          	auipc	ra,0x0
 90a:	e04080e7          	jalr	-508(ra) # 70a <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6161                	addi	sp,sp,80
 914:	8082                	ret

0000000000000916 <printf>:

void
printf(const char *fmt, ...)
{
 916:	711d                	addi	sp,sp,-96
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e40c                	sd	a1,8(s0)
 920:	e810                	sd	a2,16(s0)
 922:	ec14                	sd	a3,24(s0)
 924:	f018                	sd	a4,32(s0)
 926:	f41c                	sd	a5,40(s0)
 928:	03043823          	sd	a6,48(s0)
 92c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	00840613          	addi	a2,s0,8
 934:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 938:	85aa                	mv	a1,a0
 93a:	4505                	li	a0,1
 93c:	00000097          	auipc	ra,0x0
 940:	dce080e7          	jalr	-562(ra) # 70a <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret

000000000000094c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94c:	1141                	addi	sp,sp,-16
 94e:	e422                	sd	s0,8(sp)
 950:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 952:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	00000797          	auipc	a5,0x0
 95a:	6aa7b783          	ld	a5,1706(a5) # 1000 <freep>
 95e:	a02d                	j	988 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 960:	4618                	lw	a4,8(a2)
 962:	9f2d                	addw	a4,a4,a1
 964:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	6310                	ld	a2,0(a4)
 96c:	a83d                	j	9aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96e:	ff852703          	lw	a4,-8(a0)
 972:	9f31                	addw	a4,a4,a2
 974:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 976:	ff053683          	ld	a3,-16(a0)
 97a:	a091                	j	9be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x3a>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x4a>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x30>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059813          	slli	a6,a1,0x20
 9a0:	01c85713          	srli	a4,a6,0x1c
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60de3          	beq	a2,a4,960 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061593          	slli	a1,a2,0x20
 9b4:	01c5d713          	srli	a4,a1,0x1c
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae68ae3          	beq	a3,a4,96e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73023          	sd	a5,1600(a4) # 1000 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	60e53503          	ld	a0,1550(a0) # 1000 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	5e690913          	addi	s2,s2,1510 # 1000 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a895                	j	a98 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5fa78793          	addi	a5,a5,1530 # 1020 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	5cf73923          	sd	a5,1490(a4) # 1000 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48c63          	beq	s1,a4,a76 <malloc+0xa8>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5aa73523          	sd	a0,1450(a4) # 1000 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6a42                	ld	s4,16(sp)
 a6e:	6aa2                	ld	s5,8(sp)
 a70:	6b02                	ld	s6,0(sp)
 a72:	6121                	addi	sp,sp,64
 a74:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a76:	6398                	ld	a4,0(a5)
 a78:	e118                	sd	a4,0(a0)
 a7a:	bff1                	j	a56 <malloc+0x88>
  hp->s.size = nu;
 a7c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a80:	0541                	addi	a0,a0,16
 a82:	00000097          	auipc	ra,0x0
 a86:	eca080e7          	jalr	-310(ra) # 94c <free>
  return freep;
 a8a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8e:	d971                	beqz	a0,a62 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a92:	4798                	lw	a4,8(a5)
 a94:	fa9775e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a98:	00093703          	ld	a4,0(s2)
 a9c:	853e                	mv	a0,a5
 a9e:	fef719e3          	bne	a4,a5,a90 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 aa2:	8552                	mv	a0,s4
 aa4:	00000097          	auipc	ra,0x0
 aa8:	b80080e7          	jalr	-1152(ra) # 624 <sbrk>
  if(p == (char*)-1)
 aac:	fd5518e3          	bne	a0,s5,a7c <malloc+0xae>
        return 0;
 ab0:	4501                	li	a0,0
 ab2:	bf45                	j	a62 <malloc+0x94>
