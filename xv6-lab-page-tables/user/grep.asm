
user/_grep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	ed6a8a93          	addi	s5,s5,-298 # 1010 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	200080e7          	jalr	512(ra) # 34c <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	3de080e7          	jalr	990(ra) # 55a <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	3be080e7          	jalr	958(ra) # 552 <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	2b4080e7          	jalr	692(ra) # 472 <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	360080e7          	jalr	864(ra) # 57a <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	32c080e7          	jalr	812(ra) # 562 <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	2f4080e7          	jalr	756(ra) # 53a <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24e:	00001597          	auipc	a1,0x1
 252:	82258593          	addi	a1,a1,-2014 # a70 <malloc+0xf4>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	63e080e7          	jalr	1598(ra) # 896 <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	2d8080e7          	jalr	728(ra) # 53a <exit>
    grep(pattern, 0);
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
    exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	2c2080e7          	jalr	706(ra) # 53a <exit>
      printf("grep: cannot open %s\n", argv[i]);
 280:	00093583          	ld	a1,0(s2)
 284:	00001517          	auipc	a0,0x1
 288:	80c50513          	addi	a0,a0,-2036 # a90 <malloc+0x114>
 28c:	00000097          	auipc	ra,0x0
 290:	638080e7          	jalr	1592(ra) # 8c4 <printf>
      exit(1);
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	2a4080e7          	jalr	676(ra) # 53a <exit>

000000000000029e <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
    extern int main();
    main();
 2a6:	00000097          	auipc	ra,0x0
 2aa:	f38080e7          	jalr	-200(ra) # 1de <main>
    exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	28a080e7          	jalr	650(ra) # 53a <exit>

00000000000002b8 <strcpy>:
}

char *strcpy(char *s, const char *t)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 2be:	87aa                	mv	a5,a0
 2c0:	0585                	addi	a1,a1,1
 2c2:	0785                	addi	a5,a5,1
 2c4:	fff5c703          	lbu	a4,-1(a1)
 2c8:	fee78fa3          	sb	a4,-1(a5)
 2cc:	fb75                	bnez	a4,2c0 <strcpy+0x8>
        ;
    return os;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <strcmp>:

int strcmp(const char *p, const char *q)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	cb91                	beqz	a5,2f2 <strcmp+0x1e>
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00f71763          	bne	a4,a5,2f2 <strcmp+0x1e>
        p++, q++;
 2e8:	0505                	addi	a0,a0,1
 2ea:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbe5                	bnez	a5,2e0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 2f2:	0005c503          	lbu	a0,0(a1)
}
 2f6:	40a7853b          	subw	a0,a5,a0
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strlen>:

uint strlen(const char *s)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cf91                	beqz	a5,326 <strlen+0x26>
 30c:	0505                	addi	a0,a0,1
 30e:	87aa                	mv	a5,a0
 310:	4685                	li	a3,1
 312:	9e89                	subw	a3,a3,a0
 314:	00f6853b          	addw	a0,a3,a5
 318:	0785                	addi	a5,a5,1
 31a:	fff7c703          	lbu	a4,-1(a5)
 31e:	fb7d                	bnez	a4,314 <strlen+0x14>
        ;
    return n;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
    for (n = 0; s[n]; n++)
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strlen+0x20>

000000000000032a <memset>:

void *memset(void *dst, int c, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
 330:	ca19                	beqz	a2,346 <memset+0x1c>
 332:	87aa                	mv	a5,a0
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
 33c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
 340:	0785                	addi	a5,a5,1
 342:	fee79de3          	bne	a5,a4,33c <memset+0x12>
    }
    return dst;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strchr>:

char *strchr(const char *s, char c)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
    for (; *s; s++)
 352:	00054783          	lbu	a5,0(a0)
 356:	cb99                	beqz	a5,36c <strchr+0x20>
        if (*s == c)
 358:	00f58763          	beq	a1,a5,366 <strchr+0x1a>
    for (; *s; s++)
 35c:	0505                	addi	a0,a0,1
 35e:	00054783          	lbu	a5,0(a0)
 362:	fbfd                	bnez	a5,358 <strchr+0xc>
            return (char *)s;
    return 0;
 364:	4501                	li	a0,0
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
    return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strchr+0x1a>

0000000000000370 <gets>:

char *gets(char *buf, int max)
{
 370:	711d                	addi	sp,sp,-96
 372:	ec86                	sd	ra,88(sp)
 374:	e8a2                	sd	s0,80(sp)
 376:	e4a6                	sd	s1,72(sp)
 378:	e0ca                	sd	s2,64(sp)
 37a:	fc4e                	sd	s3,56(sp)
 37c:	f852                	sd	s4,48(sp)
 37e:	f456                	sd	s5,40(sp)
 380:	f05a                	sd	s6,32(sp)
 382:	ec5e                	sd	s7,24(sp)
 384:	1080                	addi	s0,sp,96
 386:	8baa                	mv	s7,a0
 388:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 38a:	892a                	mv	s2,a0
 38c:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 38e:	4aa9                	li	s5,10
 390:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
 392:	89a6                	mv	s3,s1
 394:	2485                	addiw	s1,s1,1
 396:	0344d863          	bge	s1,s4,3c6 <gets+0x56>
        cc = read(0, &c, 1);
 39a:	4605                	li	a2,1
 39c:	faf40593          	addi	a1,s0,-81
 3a0:	4501                	li	a0,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	1b0080e7          	jalr	432(ra) # 552 <read>
        if (cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x56>
        buf[i++] = c;
 3ae:	faf44783          	lbu	a5,-81(s0)
 3b2:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3b6:	01578763          	beq	a5,s5,3c4 <gets+0x54>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd679be3          	bne	a5,s6,392 <gets+0x22>
    for (i = 0; i + 1 < max;) {
 3c0:	89a6                	mv	s3,s1
 3c2:	a011                	j	3c6 <gets+0x56>
 3c4:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3c6:	99de                	add	s3,s3,s7
 3c8:	00098023          	sb	zero,0(s3)
    return buf;
}
 3cc:	855e                	mv	a0,s7
 3ce:	60e6                	ld	ra,88(sp)
 3d0:	6446                	ld	s0,80(sp)
 3d2:	64a6                	ld	s1,72(sp)
 3d4:	6906                	ld	s2,64(sp)
 3d6:	79e2                	ld	s3,56(sp)
 3d8:	7a42                	ld	s4,48(sp)
 3da:	7aa2                	ld	s5,40(sp)
 3dc:	7b02                	ld	s6,32(sp)
 3de:	6be2                	ld	s7,24(sp)
 3e0:	6125                	addi	sp,sp,96
 3e2:	8082                	ret

00000000000003e4 <stat>:

int stat(const char *n, struct stat *st)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	e426                	sd	s1,8(sp)
 3ec:	e04a                	sd	s2,0(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 3f2:	4581                	li	a1,0
 3f4:	00000097          	auipc	ra,0x0
 3f8:	186080e7          	jalr	390(ra) # 57a <open>
    if (fd < 0)
 3fc:	02054563          	bltz	a0,426 <stat+0x42>
 400:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 402:	85ca                	mv	a1,s2
 404:	00000097          	auipc	ra,0x0
 408:	18e080e7          	jalr	398(ra) # 592 <fstat>
 40c:	892a                	mv	s2,a0
    close(fd);
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	152080e7          	jalr	338(ra) # 562 <close>
    return r;
}
 418:	854a                	mv	a0,s2
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	64a2                	ld	s1,8(sp)
 420:	6902                	ld	s2,0(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret
        return -1;
 426:	597d                	li	s2,-1
 428:	bfc5                	j	418 <stat+0x34>

000000000000042a <atoi>:

int atoi(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 430:	00054683          	lbu	a3,0(a0)
 434:	fd06879b          	addiw	a5,a3,-48
 438:	0ff7f793          	zext.b	a5,a5
 43c:	4625                	li	a2,9
 43e:	02f66863          	bltu	a2,a5,46e <atoi+0x44>
 442:	872a                	mv	a4,a0
    n = 0;
 444:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 446:	0705                	addi	a4,a4,1
 448:	0025179b          	slliw	a5,a0,0x2
 44c:	9fa9                	addw	a5,a5,a0
 44e:	0017979b          	slliw	a5,a5,0x1
 452:	9fb5                	addw	a5,a5,a3
 454:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 458:	00074683          	lbu	a3,0(a4)
 45c:	fd06879b          	addiw	a5,a3,-48
 460:	0ff7f793          	zext.b	a5,a5
 464:	fef671e3          	bgeu	a2,a5,446 <atoi+0x1c>
    return n;
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
    n = 0;
 46e:	4501                	li	a0,0
 470:	bfe5                	j	468 <atoi+0x3e>

0000000000000472 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
 478:	02b57463          	bgeu	a0,a1,4a0 <memmove+0x2e>
        while (n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x28>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 488:	872a                	mv	a4,a0
            *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
        dst += n;
 4a0:	00c50733          	add	a4,a0,a2
        src += n;
 4a4:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4a6:	fec05ae3          	blez	a2,49a <memmove+0x28>
 4aa:	fff6079b          	addiw	a5,a2,-1
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	fff7c793          	not	a5,a5
 4b6:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 4b8:	15fd                	addi	a1,a1,-1
 4ba:	177d                	addi	a4,a4,-1
 4bc:	0005c683          	lbu	a3,0(a1)
 4c0:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x46>
 4c8:	bfc9                	j	49a <memmove+0x28>

00000000000004ca <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 4d0:	ca05                	beqz	a2,500 <memcmp+0x36>
 4d2:	fff6069b          	addiw	a3,a2,-1
 4d6:	1682                	slli	a3,a3,0x20
 4d8:	9281                	srli	a3,a3,0x20
 4da:	0685                	addi	a3,a3,1
 4dc:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	0005c703          	lbu	a4,0(a1)
 4e6:	00e79863          	bne	a5,a4,4f6 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 4ea:	0505                	addi	a0,a0,1
        p2++;
 4ec:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 4ee:	fed518e3          	bne	a0,a3,4de <memcmp+0x14>
    }
    return 0;
 4f2:	4501                	li	a0,0
 4f4:	a019                	j	4fa <memcmp+0x30>
            return *p1 - *p2;
 4f6:	40e7853b          	subw	a0,a5,a4
}
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret
    return 0;
 500:	4501                	li	a0,0
 502:	bfe5                	j	4fa <memcmp+0x30>

0000000000000504 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
 504:	1141                	addi	sp,sp,-16
 506:	e406                	sd	ra,8(sp)
 508:	e022                	sd	s0,0(sp)
 50a:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 50c:	00000097          	auipc	ra,0x0
 510:	f66080e7          	jalr	-154(ra) # 472 <memmove>
}
 514:	60a2                	ld	ra,8(sp)
 516:	6402                	ld	s0,0(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
 522:	040007b7          	lui	a5,0x4000
}
 526:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffebed>
 528:	07b2                	slli	a5,a5,0xc
 52a:	4388                	lw	a0,0(a5)
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <connect>:
.global connect
connect:
 li a7, SYS_connect
 5da:	48f5                	li	a7,29
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 5e2:	48f9                	li	a7,30
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ea:	1101                	addi	sp,sp,-32
 5ec:	ec06                	sd	ra,24(sp)
 5ee:	e822                	sd	s0,16(sp)
 5f0:	1000                	addi	s0,sp,32
 5f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f6:	4605                	li	a2,1
 5f8:	fef40593          	addi	a1,s0,-17
 5fc:	00000097          	auipc	ra,0x0
 600:	f5e080e7          	jalr	-162(ra) # 55a <write>
}
 604:	60e2                	ld	ra,24(sp)
 606:	6442                	ld	s0,16(sp)
 608:	6105                	addi	sp,sp,32
 60a:	8082                	ret

000000000000060c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60c:	7139                	addi	sp,sp,-64
 60e:	fc06                	sd	ra,56(sp)
 610:	f822                	sd	s0,48(sp)
 612:	f426                	sd	s1,40(sp)
 614:	f04a                	sd	s2,32(sp)
 616:	ec4e                	sd	s3,24(sp)
 618:	0080                	addi	s0,sp,64
 61a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 61c:	c299                	beqz	a3,622 <printint+0x16>
 61e:	0805c963          	bltz	a1,6b0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 622:	2581                	sext.w	a1,a1
  neg = 0;
 624:	4881                	li	a7,0
 626:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 62a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 62c:	2601                	sext.w	a2,a2
 62e:	00000517          	auipc	a0,0x0
 632:	4da50513          	addi	a0,a0,1242 # b08 <digits>
 636:	883a                	mv	a6,a4
 638:	2705                	addiw	a4,a4,1
 63a:	02c5f7bb          	remuw	a5,a1,a2
 63e:	1782                	slli	a5,a5,0x20
 640:	9381                	srli	a5,a5,0x20
 642:	97aa                	add	a5,a5,a0
 644:	0007c783          	lbu	a5,0(a5)
 648:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 64c:	0005879b          	sext.w	a5,a1
 650:	02c5d5bb          	divuw	a1,a1,a2
 654:	0685                	addi	a3,a3,1
 656:	fec7f0e3          	bgeu	a5,a2,636 <printint+0x2a>
  if(neg)
 65a:	00088c63          	beqz	a7,672 <printint+0x66>
    buf[i++] = '-';
 65e:	fd070793          	addi	a5,a4,-48
 662:	00878733          	add	a4,a5,s0
 666:	02d00793          	li	a5,45
 66a:	fef70823          	sb	a5,-16(a4)
 66e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 672:	02e05863          	blez	a4,6a2 <printint+0x96>
 676:	fc040793          	addi	a5,s0,-64
 67a:	00e78933          	add	s2,a5,a4
 67e:	fff78993          	addi	s3,a5,-1
 682:	99ba                	add	s3,s3,a4
 684:	377d                	addiw	a4,a4,-1
 686:	1702                	slli	a4,a4,0x20
 688:	9301                	srli	a4,a4,0x20
 68a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 68e:	fff94583          	lbu	a1,-1(s2)
 692:	8526                	mv	a0,s1
 694:	00000097          	auipc	ra,0x0
 698:	f56080e7          	jalr	-170(ra) # 5ea <putc>
  while(--i >= 0)
 69c:	197d                	addi	s2,s2,-1
 69e:	ff3918e3          	bne	s2,s3,68e <printint+0x82>
}
 6a2:	70e2                	ld	ra,56(sp)
 6a4:	7442                	ld	s0,48(sp)
 6a6:	74a2                	ld	s1,40(sp)
 6a8:	7902                	ld	s2,32(sp)
 6aa:	69e2                	ld	s3,24(sp)
 6ac:	6121                	addi	sp,sp,64
 6ae:	8082                	ret
    x = -xx;
 6b0:	40b005bb          	negw	a1,a1
    neg = 1;
 6b4:	4885                	li	a7,1
    x = -xx;
 6b6:	bf85                	j	626 <printint+0x1a>

00000000000006b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b8:	7119                	addi	sp,sp,-128
 6ba:	fc86                	sd	ra,120(sp)
 6bc:	f8a2                	sd	s0,112(sp)
 6be:	f4a6                	sd	s1,104(sp)
 6c0:	f0ca                	sd	s2,96(sp)
 6c2:	ecce                	sd	s3,88(sp)
 6c4:	e8d2                	sd	s4,80(sp)
 6c6:	e4d6                	sd	s5,72(sp)
 6c8:	e0da                	sd	s6,64(sp)
 6ca:	fc5e                	sd	s7,56(sp)
 6cc:	f862                	sd	s8,48(sp)
 6ce:	f466                	sd	s9,40(sp)
 6d0:	f06a                	sd	s10,32(sp)
 6d2:	ec6e                	sd	s11,24(sp)
 6d4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d6:	0005c903          	lbu	s2,0(a1)
 6da:	18090f63          	beqz	s2,878 <vprintf+0x1c0>
 6de:	8aaa                	mv	s5,a0
 6e0:	8b32                	mv	s6,a2
 6e2:	00158493          	addi	s1,a1,1
  state = 0;
 6e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e8:	02500a13          	li	s4,37
 6ec:	4c55                	li	s8,21
 6ee:	00000c97          	auipc	s9,0x0
 6f2:	3c2c8c93          	addi	s9,s9,962 # ab0 <malloc+0x134>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f6:	02800d93          	li	s11,40
  putc(fd, 'x');
 6fa:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	00000b97          	auipc	s7,0x0
 700:	40cb8b93          	addi	s7,s7,1036 # b08 <digits>
 704:	a839                	j	722 <vprintf+0x6a>
        putc(fd, c);
 706:	85ca                	mv	a1,s2
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	ee0080e7          	jalr	-288(ra) # 5ea <putc>
 712:	a019                	j	718 <vprintf+0x60>
    } else if(state == '%'){
 714:	01498d63          	beq	s3,s4,72e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 718:	0485                	addi	s1,s1,1
 71a:	fff4c903          	lbu	s2,-1(s1)
 71e:	14090d63          	beqz	s2,878 <vprintf+0x1c0>
    if(state == 0){
 722:	fe0999e3          	bnez	s3,714 <vprintf+0x5c>
      if(c == '%'){
 726:	ff4910e3          	bne	s2,s4,706 <vprintf+0x4e>
        state = '%';
 72a:	89d2                	mv	s3,s4
 72c:	b7f5                	j	718 <vprintf+0x60>
      if(c == 'd'){
 72e:	11490c63          	beq	s2,s4,846 <vprintf+0x18e>
 732:	f9d9079b          	addiw	a5,s2,-99
 736:	0ff7f793          	zext.b	a5,a5
 73a:	10fc6e63          	bltu	s8,a5,856 <vprintf+0x19e>
 73e:	f9d9079b          	addiw	a5,s2,-99
 742:	0ff7f713          	zext.b	a4,a5
 746:	10ec6863          	bltu	s8,a4,856 <vprintf+0x19e>
 74a:	00271793          	slli	a5,a4,0x2
 74e:	97e6                	add	a5,a5,s9
 750:	439c                	lw	a5,0(a5)
 752:	97e6                	add	a5,a5,s9
 754:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 756:	008b0913          	addi	s2,s6,8
 75a:	4685                	li	a3,1
 75c:	4629                	li	a2,10
 75e:	000b2583          	lw	a1,0(s6)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	ea8080e7          	jalr	-344(ra) # 60c <printint>
 76c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 76e:	4981                	li	s3,0
 770:	b765                	j	718 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	008b0913          	addi	s2,s6,8
 776:	4681                	li	a3,0
 778:	4629                	li	a2,10
 77a:	000b2583          	lw	a1,0(s6)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e8c080e7          	jalr	-372(ra) # 60c <printint>
 788:	8b4a                	mv	s6,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b771                	j	718 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 78e:	008b0913          	addi	s2,s6,8
 792:	4681                	li	a3,0
 794:	866a                	mv	a2,s10
 796:	000b2583          	lw	a1,0(s6)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e70080e7          	jalr	-400(ra) # 60c <printint>
 7a4:	8b4a                	mv	s6,s2
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	bf85                	j	718 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7aa:	008b0793          	addi	a5,s6,8
 7ae:	f8f43423          	sd	a5,-120(s0)
 7b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7b6:	03000593          	li	a1,48
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e2e080e7          	jalr	-466(ra) # 5ea <putc>
  putc(fd, 'x');
 7c4:	07800593          	li	a1,120
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e20080e7          	jalr	-480(ra) # 5ea <putc>
 7d2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d4:	03c9d793          	srli	a5,s3,0x3c
 7d8:	97de                	add	a5,a5,s7
 7da:	0007c583          	lbu	a1,0(a5)
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e0a080e7          	jalr	-502(ra) # 5ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e8:	0992                	slli	s3,s3,0x4
 7ea:	397d                	addiw	s2,s2,-1
 7ec:	fe0914e3          	bnez	s2,7d4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b70d                	j	718 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f8:	008b0913          	addi	s2,s6,8
 7fc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 800:	02098163          	beqz	s3,822 <vprintf+0x16a>
        while(*s != 0){
 804:	0009c583          	lbu	a1,0(s3)
 808:	c5ad                	beqz	a1,872 <vprintf+0x1ba>
          putc(fd, *s);
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	dde080e7          	jalr	-546(ra) # 5ea <putc>
          s++;
 814:	0985                	addi	s3,s3,1
        while(*s != 0){
 816:	0009c583          	lbu	a1,0(s3)
 81a:	f9e5                	bnez	a1,80a <vprintf+0x152>
        s = va_arg(ap, char*);
 81c:	8b4a                	mv	s6,s2
      state = 0;
 81e:	4981                	li	s3,0
 820:	bde5                	j	718 <vprintf+0x60>
          s = "(null)";
 822:	00000997          	auipc	s3,0x0
 826:	28698993          	addi	s3,s3,646 # aa8 <malloc+0x12c>
        while(*s != 0){
 82a:	85ee                	mv	a1,s11
 82c:	bff9                	j	80a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 82e:	008b0913          	addi	s2,s6,8
 832:	000b4583          	lbu	a1,0(s6)
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	db2080e7          	jalr	-590(ra) # 5ea <putc>
 840:	8b4a                	mv	s6,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bdd1                	j	718 <vprintf+0x60>
        putc(fd, c);
 846:	85d2                	mv	a1,s4
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	da0080e7          	jalr	-608(ra) # 5ea <putc>
      state = 0;
 852:	4981                	li	s3,0
 854:	b5d1                	j	718 <vprintf+0x60>
        putc(fd, '%');
 856:	85d2                	mv	a1,s4
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	d90080e7          	jalr	-624(ra) # 5ea <putc>
        putc(fd, c);
 862:	85ca                	mv	a1,s2
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	d84080e7          	jalr	-636(ra) # 5ea <putc>
      state = 0;
 86e:	4981                	li	s3,0
 870:	b565                	j	718 <vprintf+0x60>
        s = va_arg(ap, char*);
 872:	8b4a                	mv	s6,s2
      state = 0;
 874:	4981                	li	s3,0
 876:	b54d                	j	718 <vprintf+0x60>
    }
  }
}
 878:	70e6                	ld	ra,120(sp)
 87a:	7446                	ld	s0,112(sp)
 87c:	74a6                	ld	s1,104(sp)
 87e:	7906                	ld	s2,96(sp)
 880:	69e6                	ld	s3,88(sp)
 882:	6a46                	ld	s4,80(sp)
 884:	6aa6                	ld	s5,72(sp)
 886:	6b06                	ld	s6,64(sp)
 888:	7be2                	ld	s7,56(sp)
 88a:	7c42                	ld	s8,48(sp)
 88c:	7ca2                	ld	s9,40(sp)
 88e:	7d02                	ld	s10,32(sp)
 890:	6de2                	ld	s11,24(sp)
 892:	6109                	addi	sp,sp,128
 894:	8082                	ret

0000000000000896 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 896:	715d                	addi	sp,sp,-80
 898:	ec06                	sd	ra,24(sp)
 89a:	e822                	sd	s0,16(sp)
 89c:	1000                	addi	s0,sp,32
 89e:	e010                	sd	a2,0(s0)
 8a0:	e414                	sd	a3,8(s0)
 8a2:	e818                	sd	a4,16(s0)
 8a4:	ec1c                	sd	a5,24(s0)
 8a6:	03043023          	sd	a6,32(s0)
 8aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b2:	8622                	mv	a2,s0
 8b4:	00000097          	auipc	ra,0x0
 8b8:	e04080e7          	jalr	-508(ra) # 6b8 <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6161                	addi	sp,sp,80
 8c2:	8082                	ret

00000000000008c4 <printf>:

void
printf(const char *fmt, ...)
{
 8c4:	711d                	addi	sp,sp,-96
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	addi	s0,sp,32
 8cc:	e40c                	sd	a1,8(s0)
 8ce:	e810                	sd	a2,16(s0)
 8d0:	ec14                	sd	a3,24(s0)
 8d2:	f018                	sd	a4,32(s0)
 8d4:	f41c                	sd	a5,40(s0)
 8d6:	03043823          	sd	a6,48(s0)
 8da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	00840613          	addi	a2,s0,8
 8e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e6:	85aa                	mv	a1,a0
 8e8:	4505                	li	a0,1
 8ea:	00000097          	auipc	ra,0x0
 8ee:	dce080e7          	jalr	-562(ra) # 6b8 <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6125                	addi	sp,sp,96
 8f8:	8082                	ret

00000000000008fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fa:	1141                	addi	sp,sp,-16
 8fc:	e422                	sd	s0,8(sp)
 8fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 900:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 904:	00000797          	auipc	a5,0x0
 908:	6fc7b783          	ld	a5,1788(a5) # 1000 <freep>
 90c:	a02d                	j	936 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90e:	4618                	lw	a4,8(a2)
 910:	9f2d                	addw	a4,a4,a1
 912:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	6310                	ld	a2,0(a4)
 91a:	a83d                	j	958 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91c:	ff852703          	lw	a4,-8(a0)
 920:	9f31                	addw	a4,a4,a2
 922:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 924:	ff053683          	ld	a3,-16(a0)
 928:	a091                	j	96c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	6398                	ld	a4,0(a5)
 92c:	00e7e463          	bltu	a5,a4,934 <free+0x3a>
 930:	00e6ea63          	bltu	a3,a4,944 <free+0x4a>
{
 934:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 936:	fed7fae3          	bgeu	a5,a3,92a <free+0x30>
 93a:	6398                	ld	a4,0(a5)
 93c:	00e6e463          	bltu	a3,a4,944 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	fee7eae3          	bltu	a5,a4,934 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 944:	ff852583          	lw	a1,-8(a0)
 948:	6390                	ld	a2,0(a5)
 94a:	02059813          	slli	a6,a1,0x20
 94e:	01c85713          	srli	a4,a6,0x1c
 952:	9736                	add	a4,a4,a3
 954:	fae60de3          	beq	a2,a4,90e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95c:	4790                	lw	a2,8(a5)
 95e:	02061593          	slli	a1,a2,0x20
 962:	01c5d713          	srli	a4,a1,0x1c
 966:	973e                	add	a4,a4,a5
 968:	fae68ae3          	beq	a3,a4,91c <free+0x22>
    p->s.ptr = bp->s.ptr;
 96c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96e:	00000717          	auipc	a4,0x0
 972:	68f73923          	sd	a5,1682(a4) # 1000 <freep>
}
 976:	6422                	ld	s0,8(sp)
 978:	0141                	addi	sp,sp,16
 97a:	8082                	ret

000000000000097c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97c:	7139                	addi	sp,sp,-64
 97e:	fc06                	sd	ra,56(sp)
 980:	f822                	sd	s0,48(sp)
 982:	f426                	sd	s1,40(sp)
 984:	f04a                	sd	s2,32(sp)
 986:	ec4e                	sd	s3,24(sp)
 988:	e852                	sd	s4,16(sp)
 98a:	e456                	sd	s5,8(sp)
 98c:	e05a                	sd	s6,0(sp)
 98e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 990:	02051493          	slli	s1,a0,0x20
 994:	9081                	srli	s1,s1,0x20
 996:	04bd                	addi	s1,s1,15
 998:	8091                	srli	s1,s1,0x4
 99a:	0014899b          	addiw	s3,s1,1
 99e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a0:	00000517          	auipc	a0,0x0
 9a4:	66053503          	ld	a0,1632(a0) # 1000 <freep>
 9a8:	c515                	beqz	a0,9d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	02977f63          	bgeu	a4,s1,9ec <malloc+0x70>
 9b2:	8a4e                	mv	s4,s3
 9b4:	0009871b          	sext.w	a4,s3
 9b8:	6685                	lui	a3,0x1
 9ba:	00d77363          	bgeu	a4,a3,9c0 <malloc+0x44>
 9be:	6a05                	lui	s4,0x1
 9c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c8:	00000917          	auipc	s2,0x0
 9cc:	63890913          	addi	s2,s2,1592 # 1000 <freep>
  if(p == (char*)-1)
 9d0:	5afd                	li	s5,-1
 9d2:	a895                	j	a46 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9d4:	00001797          	auipc	a5,0x1
 9d8:	a3c78793          	addi	a5,a5,-1476 # 1410 <base>
 9dc:	00000717          	auipc	a4,0x0
 9e0:	62f73223          	sd	a5,1572(a4) # 1000 <freep>
 9e4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ea:	b7e1                	j	9b2 <malloc+0x36>
      if(p->s.size == nunits)
 9ec:	02e48c63          	beq	s1,a4,a24 <malloc+0xa8>
        p->s.size -= nunits;
 9f0:	4137073b          	subw	a4,a4,s3
 9f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f6:	02071693          	slli	a3,a4,0x20
 9fa:	01c6d713          	srli	a4,a3,0x1c
 9fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a04:	00000717          	auipc	a4,0x0
 a08:	5ea73e23          	sd	a0,1532(a4) # 1000 <freep>
      return (void*)(p + 1);
 a0c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a10:	70e2                	ld	ra,56(sp)
 a12:	7442                	ld	s0,48(sp)
 a14:	74a2                	ld	s1,40(sp)
 a16:	7902                	ld	s2,32(sp)
 a18:	69e2                	ld	s3,24(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	6121                	addi	sp,sp,64
 a22:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a24:	6398                	ld	a4,0(a5)
 a26:	e118                	sd	a4,0(a0)
 a28:	bff1                	j	a04 <malloc+0x88>
  hp->s.size = nu;
 a2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2e:	0541                	addi	a0,a0,16
 a30:	00000097          	auipc	ra,0x0
 a34:	eca080e7          	jalr	-310(ra) # 8fa <free>
  return freep;
 a38:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a3c:	d971                	beqz	a0,a10 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a40:	4798                	lw	a4,8(a5)
 a42:	fa9775e3          	bgeu	a4,s1,9ec <malloc+0x70>
    if(p == freep)
 a46:	00093703          	ld	a4,0(s2)
 a4a:	853e                	mv	a0,a5
 a4c:	fef719e3          	bne	a4,a5,a3e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a50:	8552                	mv	a0,s4
 a52:	00000097          	auipc	ra,0x0
 a56:	b70080e7          	jalr	-1168(ra) # 5c2 <sbrk>
  if(p == (char*)-1)
 a5a:	fd5518e3          	bne	a0,s5,a2a <malloc+0xae>
        return 0;
 a5e:	4501                	li	a0,0
 a60:	bf45                	j	a10 <malloc+0x94>
