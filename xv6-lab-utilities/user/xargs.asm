
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <alloc_args>:
#define STOUT 1
#define MAXARGLEN 32

void alloc_args(char *args[], int arg_num, int arg_len)
{
    for (int i = 0; i < arg_num; i++) {
   0:	04b05463          	blez	a1,48 <alloc_args+0x48>
{
   4:	7179                	addi	sp,sp,-48
   6:	f406                	sd	ra,40(sp)
   8:	f022                	sd	s0,32(sp)
   a:	ec26                	sd	s1,24(sp)
   c:	e84a                	sd	s2,16(sp)
   e:	e44e                	sd	s3,8(sp)
  10:	1800                	addi	s0,sp,48
  12:	84aa                	mv	s1,a0
  14:	fff5891b          	addiw	s2,a1,-1
  18:	02091793          	slli	a5,s2,0x20
  1c:	01d7d913          	srli	s2,a5,0x1d
  20:	0521                	addi	a0,a0,8
  22:	992a                	add	s2,s2,a0
        args[i] = malloc(arg_len * sizeof(char));
  24:	0006099b          	sext.w	s3,a2
  28:	854e                	mv	a0,s3
  2a:	00001097          	auipc	ra,0x1
  2e:	864080e7          	jalr	-1948(ra) # 88e <malloc>
  32:	e088                	sd	a0,0(s1)
    for (int i = 0; i < arg_num; i++) {
  34:	04a1                	addi	s1,s1,8
  36:	ff2499e3          	bne	s1,s2,28 <alloc_args+0x28>
    }
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6145                	addi	sp,sp,48
  46:	8082                	ret
  48:	8082                	ret

000000000000004a <free_args>:

void free_args(char *args[], int arg_num)
{
    for (int i = 0; i < arg_num; i++) {
  4a:	02b05f63          	blez	a1,88 <free_args+0x3e>
{
  4e:	1101                	addi	sp,sp,-32
  50:	ec06                	sd	ra,24(sp)
  52:	e822                	sd	s0,16(sp)
  54:	e426                	sd	s1,8(sp)
  56:	e04a                	sd	s2,0(sp)
  58:	1000                	addi	s0,sp,32
  5a:	84aa                	mv	s1,a0
  5c:	fff5891b          	addiw	s2,a1,-1
  60:	02091793          	slli	a5,s2,0x20
  64:	01d7d913          	srli	s2,a5,0x1d
  68:	0521                	addi	a0,a0,8
  6a:	992a                	add	s2,s2,a0
        free(args[i]);
  6c:	6088                	ld	a0,0(s1)
  6e:	00000097          	auipc	ra,0x0
  72:	79e080e7          	jalr	1950(ra) # 80c <free>
    for (int i = 0; i < arg_num; i++) {
  76:	04a1                	addi	s1,s1,8
  78:	ff249ae3          	bne	s1,s2,6c <free_args+0x22>
    }
}
  7c:	60e2                	ld	ra,24(sp)
  7e:	6442                	ld	s0,16(sp)
  80:	64a2                	ld	s1,8(sp)
  82:	6902                	ld	s2,0(sp)
  84:	6105                	addi	sp,sp,32
  86:	8082                	ret
  88:	8082                	ret

000000000000008a <main>:

int main(int argc, char *argv[])
{
  8a:	714d                	addi	sp,sp,-336
  8c:	e686                	sd	ra,328(sp)
  8e:	e2a2                	sd	s0,320(sp)
  90:	fe26                	sd	s1,312(sp)
  92:	fa4a                	sd	s2,304(sp)
  94:	f64e                	sd	s3,296(sp)
  96:	f252                	sd	s4,288(sp)
  98:	ee56                	sd	s5,280(sp)
  9a:	0a80                	addi	s0,sp,336
    if (argc < 2) {
  9c:	4785                	li	a5,1
  9e:	06a7d563          	bge	a5,a0,108 <main+0x7e>
  a2:	89aa                	mv	s3,a0
  a4:	892e                	mv	s2,a1
        fprintf(STOUT, "Usage: xargs <command> <args>\n");
        exit(1);
    }

    char *args[MAXARG];
    alloc_args(args, MAXARG, MAXARGLEN);
  a6:	02000613          	li	a2,32
  aa:	02000593          	li	a1,32
  ae:	ec040513          	addi	a0,s0,-320
  b2:	00000097          	auipc	ra,0x0
  b6:	f4e080e7          	jalr	-178(ra) # 0 <alloc_args>
    int retval;
    char tmp;
    int arg_num = 0, arg_len = 0;
    args[arg_num] = argv[1];
  ba:	00893783          	ld	a5,8(s2)
  be:	ecf43023          	sd	a5,-320(s0)
    arg_num++;

    for (int i = 2; i < argc; i++) {
  c2:	4789                	li	a5,2
  c4:	0737d063          	bge	a5,s3,124 <main+0x9a>
  c8:	ec840493          	addi	s1,s0,-312
  cc:	0941                	addi	s2,s2,16
  ce:	00098a1b          	sext.w	s4,s3
  d2:	39f5                	addiw	s3,s3,-3
  d4:	02099793          	slli	a5,s3,0x20
  d8:	01d7d993          	srli	s3,a5,0x1d
  dc:	ed040793          	addi	a5,s0,-304
  e0:	99be                	add	s3,s3,a5
        strcpy(args[arg_num], argv[i]);
  e2:	00093583          	ld	a1,0(s2)
  e6:	6088                	ld	a0,0(s1)
  e8:	00000097          	auipc	ra,0x0
  ec:	108080e7          	jalr	264(ra) # 1f0 <strcpy>
    for (int i = 2; i < argc; i++) {
  f0:	04a1                	addi	s1,s1,8
  f2:	0921                	addi	s2,s2,8
  f4:	ff3497e3          	bne	s1,s3,e2 <main+0x58>
        arg_num++;
  f8:	fffa049b          	addiw	s1,s4,-1
    int arg_num = 0, arg_len = 0;
  fc:	4901                	li	s2,0
    }

    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
  fe:	49fd                	li	s3,31
        if (tmp == '\n' || tmp == ' ') {
 100:	4a29                	li	s4,10
 102:	02000a93          	li	s5,32
 106:	a82d                	j	140 <main+0xb6>
        fprintf(STOUT, "Usage: xargs <command> <args>\n");
 108:	00001597          	auipc	a1,0x1
 10c:	87858593          	addi	a1,a1,-1928 # 980 <malloc+0xf2>
 110:	4505                	li	a0,1
 112:	00000097          	auipc	ra,0x0
 116:	696080e7          	jalr	1686(ra) # 7a8 <fprintf>
        exit(1);
 11a:	4505                	li	a0,1
 11c:	00000097          	auipc	ra,0x0
 120:	340080e7          	jalr	832(ra) # 45c <exit>
    arg_num++;
 124:	4485                	li	s1,1
 126:	bfd9                	j	fc <main+0x72>
            args[arg_num][arg_len] = '\0';
 128:	00349793          	slli	a5,s1,0x3
 12c:	fc078793          	addi	a5,a5,-64
 130:	97a2                	add	a5,a5,s0
 132:	f007b783          	ld	a5,-256(a5)
 136:	97ca                	add	a5,a5,s2
 138:	00078023          	sb	zero,0(a5)
            arg_len = 0;
            arg_num++;
 13c:	2485                	addiw	s1,s1,1
            arg_len = 0;
 13e:	4901                	li	s2,0
    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
 140:	4605                	li	a2,1
 142:	ebf40593          	addi	a1,s0,-321
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	32c080e7          	jalr	812(ra) # 474 <read>
 150:	02a05663          	blez	a0,17c <main+0xf2>
 154:	0299c463          	blt	s3,s1,17c <main+0xf2>
        if (tmp == '\n' || tmp == ' ') {
 158:	ebf44783          	lbu	a5,-321(s0)
 15c:	fd4786e3          	beq	a5,s4,128 <main+0x9e>
 160:	fd5784e3          	beq	a5,s5,128 <main+0x9e>
        }
        else {
            args[arg_num][arg_len] = tmp;
 164:	00349713          	slli	a4,s1,0x3
 168:	fc070713          	addi	a4,a4,-64
 16c:	9722                	add	a4,a4,s0
 16e:	f0073703          	ld	a4,-256(a4)
 172:	974a                	add	a4,a4,s2
 174:	00f70023          	sb	a5,0(a4)
            arg_len++;
 178:	2905                	addiw	s2,s2,1
 17a:	b7d9                	j	140 <main+0xb6>
        }
    }

    // 置NULL
    args[arg_num] = 0;
 17c:	00349793          	slli	a5,s1,0x3
 180:	fc078793          	addi	a5,a5,-64
 184:	97a2                	add	a5,a5,s0
 186:	f007b023          	sd	zero,-256(a5)

    if (fork() == 0) {
 18a:	00000097          	auipc	ra,0x0
 18e:	2ca080e7          	jalr	714(ra) # 454 <fork>
 192:	e50d                	bnez	a0,1bc <main+0x132>
        exec(args[0], args);
 194:	ec040593          	addi	a1,s0,-320
 198:	ec043503          	ld	a0,-320(s0)
 19c:	00000097          	auipc	ra,0x0
 1a0:	2f8080e7          	jalr	760(ra) # 494 <exec>
        free_args(args, arg_num);
 1a4:	85a6                	mv	a1,s1
 1a6:	ec040513          	addi	a0,s0,-320
 1aa:	00000097          	auipc	ra,0x0
 1ae:	ea0080e7          	jalr	-352(ra) # 4a <free_args>
    else {
        wait(0);
        free_args(args, arg_num);
    }

    exit(0);
 1b2:	4501                	li	a0,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	2a8080e7          	jalr	680(ra) # 45c <exit>
        wait(0);
 1bc:	4501                	li	a0,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	2a6080e7          	jalr	678(ra) # 464 <wait>
        free_args(args, arg_num);
 1c6:	85a6                	mv	a1,s1
 1c8:	ec040513          	addi	a0,s0,-320
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e7e080e7          	jalr	-386(ra) # 4a <free_args>
 1d4:	bff9                	j	1b2 <main+0x128>

00000000000001d6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e406                	sd	ra,8(sp)
 1da:	e022                	sd	s0,0(sp)
 1dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1de:	00000097          	auipc	ra,0x0
 1e2:	eac080e7          	jalr	-340(ra) # 8a <main>
  exit(0);
 1e6:	4501                	li	a0,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	274080e7          	jalr	628(ra) # 45c <exit>

00000000000001f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f6:	87aa                	mv	a5,a0
 1f8:	0585                	addi	a1,a1,1
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff5c703          	lbu	a4,-1(a1)
 200:	fee78fa3          	sb	a4,-1(a5)
 204:	fb75                	bnez	a4,1f8 <strcpy+0x8>
    ;
  return os;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 212:	00054783          	lbu	a5,0(a0)
 216:	cb91                	beqz	a5,22a <strcmp+0x1e>
 218:	0005c703          	lbu	a4,0(a1)
 21c:	00f71763          	bne	a4,a5,22a <strcmp+0x1e>
    p++, q++;
 220:	0505                	addi	a0,a0,1
 222:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 224:	00054783          	lbu	a5,0(a0)
 228:	fbe5                	bnez	a5,218 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 22a:	0005c503          	lbu	a0,0(a1)
}
 22e:	40a7853b          	subw	a0,a5,a0
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strlen>:

uint
strlen(const char *s)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cf91                	beqz	a5,25e <strlen+0x26>
 244:	0505                	addi	a0,a0,1
 246:	87aa                	mv	a5,a0
 248:	4685                	li	a3,1
 24a:	9e89                	subw	a3,a3,a0
 24c:	00f6853b          	addw	a0,a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	fb7d                	bnez	a4,24c <strlen+0x14>
    ;
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  for(n = 0; s[n]; n++)
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strlen+0x20>

0000000000000262 <memset>:

void*
memset(void *dst, int c, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 268:	ca19                	beqz	a2,27e <memset+0x1c>
 26a:	87aa                	mv	a5,a0
 26c:	1602                	slli	a2,a2,0x20
 26e:	9201                	srli	a2,a2,0x20
 270:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 274:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 278:	0785                	addi	a5,a5,1
 27a:	fee79de3          	bne	a5,a4,274 <memset+0x12>
  }
  return dst;
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret

0000000000000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	cb99                	beqz	a5,2a4 <strchr+0x20>
    if(*s == c)
 290:	00f58763          	beq	a1,a5,29e <strchr+0x1a>
  for(; *s; s++)
 294:	0505                	addi	a0,a0,1
 296:	00054783          	lbu	a5,0(a0)
 29a:	fbfd                	bnez	a5,290 <strchr+0xc>
      return (char*)s;
  return 0;
 29c:	4501                	li	a0,0
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <strchr+0x1a>

00000000000002a8 <gets>:

char*
gets(char *buf, int max)
{
 2a8:	711d                	addi	sp,sp,-96
 2aa:	ec86                	sd	ra,88(sp)
 2ac:	e8a2                	sd	s0,80(sp)
 2ae:	e4a6                	sd	s1,72(sp)
 2b0:	e0ca                	sd	s2,64(sp)
 2b2:	fc4e                	sd	s3,56(sp)
 2b4:	f852                	sd	s4,48(sp)
 2b6:	f456                	sd	s5,40(sp)
 2b8:	f05a                	sd	s6,32(sp)
 2ba:	ec5e                	sd	s7,24(sp)
 2bc:	1080                	addi	s0,sp,96
 2be:	8baa                	mv	s7,a0
 2c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c2:	892a                	mv	s2,a0
 2c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c6:	4aa9                	li	s5,10
 2c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ca:	89a6                	mv	s3,s1
 2cc:	2485                	addiw	s1,s1,1
 2ce:	0344d863          	bge	s1,s4,2fe <gets+0x56>
    cc = read(0, &c, 1);
 2d2:	4605                	li	a2,1
 2d4:	faf40593          	addi	a1,s0,-81
 2d8:	4501                	li	a0,0
 2da:	00000097          	auipc	ra,0x0
 2de:	19a080e7          	jalr	410(ra) # 474 <read>
    if(cc < 1)
 2e2:	00a05e63          	blez	a0,2fe <gets+0x56>
    buf[i++] = c;
 2e6:	faf44783          	lbu	a5,-81(s0)
 2ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ee:	01578763          	beq	a5,s5,2fc <gets+0x54>
 2f2:	0905                	addi	s2,s2,1
 2f4:	fd679be3          	bne	a5,s6,2ca <gets+0x22>
  for(i=0; i+1 < max; ){
 2f8:	89a6                	mv	s3,s1
 2fa:	a011                	j	2fe <gets+0x56>
 2fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2fe:	99de                	add	s3,s3,s7
 300:	00098023          	sb	zero,0(s3)
  return buf;
}
 304:	855e                	mv	a0,s7
 306:	60e6                	ld	ra,88(sp)
 308:	6446                	ld	s0,80(sp)
 30a:	64a6                	ld	s1,72(sp)
 30c:	6906                	ld	s2,64(sp)
 30e:	79e2                	ld	s3,56(sp)
 310:	7a42                	ld	s4,48(sp)
 312:	7aa2                	ld	s5,40(sp)
 314:	7b02                	ld	s6,32(sp)
 316:	6be2                	ld	s7,24(sp)
 318:	6125                	addi	sp,sp,96
 31a:	8082                	ret

000000000000031c <stat>:

int
stat(const char *n, struct stat *st)
{
 31c:	1101                	addi	sp,sp,-32
 31e:	ec06                	sd	ra,24(sp)
 320:	e822                	sd	s0,16(sp)
 322:	e426                	sd	s1,8(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32a:	4581                	li	a1,0
 32c:	00000097          	auipc	ra,0x0
 330:	170080e7          	jalr	368(ra) # 49c <open>
  if(fd < 0)
 334:	02054563          	bltz	a0,35e <stat+0x42>
 338:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33a:	85ca                	mv	a1,s2
 33c:	00000097          	auipc	ra,0x0
 340:	178080e7          	jalr	376(ra) # 4b4 <fstat>
 344:	892a                	mv	s2,a0
  close(fd);
 346:	8526                	mv	a0,s1
 348:	00000097          	auipc	ra,0x0
 34c:	13c080e7          	jalr	316(ra) # 484 <close>
  return r;
}
 350:	854a                	mv	a0,s2
 352:	60e2                	ld	ra,24(sp)
 354:	6442                	ld	s0,16(sp)
 356:	64a2                	ld	s1,8(sp)
 358:	6902                	ld	s2,0(sp)
 35a:	6105                	addi	sp,sp,32
 35c:	8082                	ret
    return -1;
 35e:	597d                	li	s2,-1
 360:	bfc5                	j	350 <stat+0x34>

0000000000000362 <atoi>:

int
atoi(const char *s)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 368:	00054683          	lbu	a3,0(a0)
 36c:	fd06879b          	addiw	a5,a3,-48
 370:	0ff7f793          	zext.b	a5,a5
 374:	4625                	li	a2,9
 376:	02f66863          	bltu	a2,a5,3a6 <atoi+0x44>
 37a:	872a                	mv	a4,a0
  n = 0;
 37c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 37e:	0705                	addi	a4,a4,1
 380:	0025179b          	slliw	a5,a0,0x2
 384:	9fa9                	addw	a5,a5,a0
 386:	0017979b          	slliw	a5,a5,0x1
 38a:	9fb5                	addw	a5,a5,a3
 38c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 390:	00074683          	lbu	a3,0(a4)
 394:	fd06879b          	addiw	a5,a3,-48
 398:	0ff7f793          	zext.b	a5,a5
 39c:	fef671e3          	bgeu	a2,a5,37e <atoi+0x1c>
  return n;
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  n = 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <atoi+0x3e>

00000000000003aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b0:	02b57463          	bgeu	a0,a1,3d8 <memmove+0x2e>
    while(n-- > 0)
 3b4:	00c05f63          	blez	a2,3d2 <memmove+0x28>
 3b8:	1602                	slli	a2,a2,0x20
 3ba:	9201                	srli	a2,a2,0x20
 3bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c2:	0585                	addi	a1,a1,1
 3c4:	0705                	addi	a4,a4,1
 3c6:	fff5c683          	lbu	a3,-1(a1)
 3ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ce:	fee79ae3          	bne	a5,a4,3c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
    dst += n;
 3d8:	00c50733          	add	a4,a0,a2
    src += n;
 3dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3de:	fec05ae3          	blez	a2,3d2 <memmove+0x28>
 3e2:	fff6079b          	addiw	a5,a2,-1
 3e6:	1782                	slli	a5,a5,0x20
 3e8:	9381                	srli	a5,a5,0x20
 3ea:	fff7c793          	not	a5,a5
 3ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f0:	15fd                	addi	a1,a1,-1
 3f2:	177d                	addi	a4,a4,-1
 3f4:	0005c683          	lbu	a3,0(a1)
 3f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3fc:	fee79ae3          	bne	a5,a4,3f0 <memmove+0x46>
 400:	bfc9                	j	3d2 <memmove+0x28>

0000000000000402 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 408:	ca05                	beqz	a2,438 <memcmp+0x36>
 40a:	fff6069b          	addiw	a3,a2,-1
 40e:	1682                	slli	a3,a3,0x20
 410:	9281                	srli	a3,a3,0x20
 412:	0685                	addi	a3,a3,1
 414:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 416:	00054783          	lbu	a5,0(a0)
 41a:	0005c703          	lbu	a4,0(a1)
 41e:	00e79863          	bne	a5,a4,42e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 422:	0505                	addi	a0,a0,1
    p2++;
 424:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 426:	fed518e3          	bne	a0,a3,416 <memcmp+0x14>
  }
  return 0;
 42a:	4501                	li	a0,0
 42c:	a019                	j	432 <memcmp+0x30>
      return *p1 - *p2;
 42e:	40e7853b          	subw	a0,a5,a4
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
  return 0;
 438:	4501                	li	a0,0
 43a:	bfe5                	j	432 <memcmp+0x30>

000000000000043c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e406                	sd	ra,8(sp)
 440:	e022                	sd	s0,0(sp)
 442:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 444:	00000097          	auipc	ra,0x0
 448:	f66080e7          	jalr	-154(ra) # 3aa <memmove>
}
 44c:	60a2                	ld	ra,8(sp)
 44e:	6402                	ld	s0,0(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret

0000000000000454 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 454:	4885                	li	a7,1
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <exit>:
.global exit
exit:
 li a7, SYS_exit
 45c:	4889                	li	a7,2
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <wait>:
.global wait
wait:
 li a7, SYS_wait
 464:	488d                	li	a7,3
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46c:	4891                	li	a7,4
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <read>:
.global read
read:
 li a7, SYS_read
 474:	4895                	li	a7,5
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <write>:
.global write
write:
 li a7, SYS_write
 47c:	48c1                	li	a7,16
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <close>:
.global close
close:
 li a7, SYS_close
 484:	48d5                	li	a7,21
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <kill>:
.global kill
kill:
 li a7, SYS_kill
 48c:	4899                	li	a7,6
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <exec>:
.global exec
exec:
 li a7, SYS_exec
 494:	489d                	li	a7,7
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <open>:
.global open
open:
 li a7, SYS_open
 49c:	48bd                	li	a7,15
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a4:	48c5                	li	a7,17
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ac:	48c9                	li	a7,18
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b4:	48a1                	li	a7,8
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <link>:
.global link
link:
 li a7, SYS_link
 4bc:	48cd                	li	a7,19
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c4:	48d1                	li	a7,20
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4cc:	48a5                	li	a7,9
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d4:	48a9                	li	a7,10
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4dc:	48ad                	li	a7,11
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e4:	48b1                	li	a7,12
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ec:	48b5                	li	a7,13
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f4:	48b9                	li	a7,14
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	00000097          	auipc	ra,0x0
 512:	f6e080e7          	jalr	-146(ra) # 47c <write>
}
 516:	60e2                	ld	ra,24(sp)
 518:	6442                	ld	s0,16(sp)
 51a:	6105                	addi	sp,sp,32
 51c:	8082                	ret

000000000000051e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51e:	7139                	addi	sp,sp,-64
 520:	fc06                	sd	ra,56(sp)
 522:	f822                	sd	s0,48(sp)
 524:	f426                	sd	s1,40(sp)
 526:	f04a                	sd	s2,32(sp)
 528:	ec4e                	sd	s3,24(sp)
 52a:	0080                	addi	s0,sp,64
 52c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52e:	c299                	beqz	a3,534 <printint+0x16>
 530:	0805c963          	bltz	a1,5c2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 534:	2581                	sext.w	a1,a1
  neg = 0;
 536:	4881                	li	a7,0
 538:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53e:	2601                	sext.w	a2,a2
 540:	00000517          	auipc	a0,0x0
 544:	4c050513          	addi	a0,a0,1216 # a00 <digits>
 548:	883a                	mv	a6,a4
 54a:	2705                	addiw	a4,a4,1
 54c:	02c5f7bb          	remuw	a5,a1,a2
 550:	1782                	slli	a5,a5,0x20
 552:	9381                	srli	a5,a5,0x20
 554:	97aa                	add	a5,a5,a0
 556:	0007c783          	lbu	a5,0(a5)
 55a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55e:	0005879b          	sext.w	a5,a1
 562:	02c5d5bb          	divuw	a1,a1,a2
 566:	0685                	addi	a3,a3,1
 568:	fec7f0e3          	bgeu	a5,a2,548 <printint+0x2a>
  if(neg)
 56c:	00088c63          	beqz	a7,584 <printint+0x66>
    buf[i++] = '-';
 570:	fd070793          	addi	a5,a4,-48
 574:	00878733          	add	a4,a5,s0
 578:	02d00793          	li	a5,45
 57c:	fef70823          	sb	a5,-16(a4)
 580:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 584:	02e05863          	blez	a4,5b4 <printint+0x96>
 588:	fc040793          	addi	a5,s0,-64
 58c:	00e78933          	add	s2,a5,a4
 590:	fff78993          	addi	s3,a5,-1
 594:	99ba                	add	s3,s3,a4
 596:	377d                	addiw	a4,a4,-1
 598:	1702                	slli	a4,a4,0x20
 59a:	9301                	srli	a4,a4,0x20
 59c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a0:	fff94583          	lbu	a1,-1(s2)
 5a4:	8526                	mv	a0,s1
 5a6:	00000097          	auipc	ra,0x0
 5aa:	f56080e7          	jalr	-170(ra) # 4fc <putc>
  while(--i >= 0)
 5ae:	197d                	addi	s2,s2,-1
 5b0:	ff3918e3          	bne	s2,s3,5a0 <printint+0x82>
}
 5b4:	70e2                	ld	ra,56(sp)
 5b6:	7442                	ld	s0,48(sp)
 5b8:	74a2                	ld	s1,40(sp)
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
 5be:	6121                	addi	sp,sp,64
 5c0:	8082                	ret
    x = -xx;
 5c2:	40b005bb          	negw	a1,a1
    neg = 1;
 5c6:	4885                	li	a7,1
    x = -xx;
 5c8:	bf85                	j	538 <printint+0x1a>

00000000000005ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ca:	7119                	addi	sp,sp,-128
 5cc:	fc86                	sd	ra,120(sp)
 5ce:	f8a2                	sd	s0,112(sp)
 5d0:	f4a6                	sd	s1,104(sp)
 5d2:	f0ca                	sd	s2,96(sp)
 5d4:	ecce                	sd	s3,88(sp)
 5d6:	e8d2                	sd	s4,80(sp)
 5d8:	e4d6                	sd	s5,72(sp)
 5da:	e0da                	sd	s6,64(sp)
 5dc:	fc5e                	sd	s7,56(sp)
 5de:	f862                	sd	s8,48(sp)
 5e0:	f466                	sd	s9,40(sp)
 5e2:	f06a                	sd	s10,32(sp)
 5e4:	ec6e                	sd	s11,24(sp)
 5e6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e8:	0005c903          	lbu	s2,0(a1)
 5ec:	18090f63          	beqz	s2,78a <vprintf+0x1c0>
 5f0:	8aaa                	mv	s5,a0
 5f2:	8b32                	mv	s6,a2
 5f4:	00158493          	addi	s1,a1,1
  state = 0;
 5f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fa:	02500a13          	li	s4,37
 5fe:	4c55                	li	s8,21
 600:	00000c97          	auipc	s9,0x0
 604:	3a8c8c93          	addi	s9,s9,936 # 9a8 <malloc+0x11a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 608:	02800d93          	li	s11,40
  putc(fd, 'x');
 60c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00000b97          	auipc	s7,0x0
 612:	3f2b8b93          	addi	s7,s7,1010 # a00 <digits>
 616:	a839                	j	634 <vprintf+0x6a>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	ee0080e7          	jalr	-288(ra) # 4fc <putc>
 624:	a019                	j	62a <vprintf+0x60>
    } else if(state == '%'){
 626:	01498d63          	beq	s3,s4,640 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 62a:	0485                	addi	s1,s1,1
 62c:	fff4c903          	lbu	s2,-1(s1)
 630:	14090d63          	beqz	s2,78a <vprintf+0x1c0>
    if(state == 0){
 634:	fe0999e3          	bnez	s3,626 <vprintf+0x5c>
      if(c == '%'){
 638:	ff4910e3          	bne	s2,s4,618 <vprintf+0x4e>
        state = '%';
 63c:	89d2                	mv	s3,s4
 63e:	b7f5                	j	62a <vprintf+0x60>
      if(c == 'd'){
 640:	11490c63          	beq	s2,s4,758 <vprintf+0x18e>
 644:	f9d9079b          	addiw	a5,s2,-99
 648:	0ff7f793          	zext.b	a5,a5
 64c:	10fc6e63          	bltu	s8,a5,768 <vprintf+0x19e>
 650:	f9d9079b          	addiw	a5,s2,-99
 654:	0ff7f713          	zext.b	a4,a5
 658:	10ec6863          	bltu	s8,a4,768 <vprintf+0x19e>
 65c:	00271793          	slli	a5,a4,0x2
 660:	97e6                	add	a5,a5,s9
 662:	439c                	lw	a5,0(a5)
 664:	97e6                	add	a5,a5,s9
 666:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 668:	008b0913          	addi	s2,s6,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000b2583          	lw	a1,0(s6)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	ea8080e7          	jalr	-344(ra) # 51e <printint>
 67e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 680:	4981                	li	s3,0
 682:	b765                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	008b0913          	addi	s2,s6,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000b2583          	lw	a1,0(s6)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e8c080e7          	jalr	-372(ra) # 51e <printint>
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b771                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a0:	008b0913          	addi	s2,s6,8
 6a4:	4681                	li	a3,0
 6a6:	866a                	mv	a2,s10
 6a8:	000b2583          	lw	a1,0(s6)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e70080e7          	jalr	-400(ra) # 51e <printint>
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bf85                	j	62a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6bc:	008b0793          	addi	a5,s6,8
 6c0:	f8f43423          	sd	a5,-120(s0)
 6c4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c8:	03000593          	li	a1,48
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e2e080e7          	jalr	-466(ra) # 4fc <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e20080e7          	jalr	-480(ra) # 4fc <putc>
 6e4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	03c9d793          	srli	a5,s3,0x3c
 6ea:	97de                	add	a5,a5,s7
 6ec:	0007c583          	lbu	a1,0(a5)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e0a080e7          	jalr	-502(ra) # 4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	397d                	addiw	s2,s2,-1
 6fe:	fe0914e3          	bnez	s2,6e6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 702:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 706:	4981                	li	s3,0
 708:	b70d                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 70a:	008b0913          	addi	s2,s6,8
 70e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 712:	02098163          	beqz	s3,734 <vprintf+0x16a>
        while(*s != 0){
 716:	0009c583          	lbu	a1,0(s3)
 71a:	c5ad                	beqz	a1,784 <vprintf+0x1ba>
          putc(fd, *s);
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dde080e7          	jalr	-546(ra) # 4fc <putc>
          s++;
 726:	0985                	addi	s3,s3,1
        while(*s != 0){
 728:	0009c583          	lbu	a1,0(s3)
 72c:	f9e5                	bnez	a1,71c <vprintf+0x152>
        s = va_arg(ap, char*);
 72e:	8b4a                	mv	s6,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	bde5                	j	62a <vprintf+0x60>
          s = "(null)";
 734:	00000997          	auipc	s3,0x0
 738:	26c98993          	addi	s3,s3,620 # 9a0 <malloc+0x112>
        while(*s != 0){
 73c:	85ee                	mv	a1,s11
 73e:	bff9                	j	71c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 740:	008b0913          	addi	s2,s6,8
 744:	000b4583          	lbu	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	db2080e7          	jalr	-590(ra) # 4fc <putc>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bdd1                	j	62a <vprintf+0x60>
        putc(fd, c);
 758:	85d2                	mv	a1,s4
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	da0080e7          	jalr	-608(ra) # 4fc <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	b5d1                	j	62a <vprintf+0x60>
        putc(fd, '%');
 768:	85d2                	mv	a1,s4
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	d90080e7          	jalr	-624(ra) # 4fc <putc>
        putc(fd, c);
 774:	85ca                	mv	a1,s2
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	d84080e7          	jalr	-636(ra) # 4fc <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b565                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 784:	8b4a                	mv	s6,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	b54d                	j	62a <vprintf+0x60>
    }
  }
}
 78a:	70e6                	ld	ra,120(sp)
 78c:	7446                	ld	s0,112(sp)
 78e:	74a6                	ld	s1,104(sp)
 790:	7906                	ld	s2,96(sp)
 792:	69e6                	ld	s3,88(sp)
 794:	6a46                	ld	s4,80(sp)
 796:	6aa6                	ld	s5,72(sp)
 798:	6b06                	ld	s6,64(sp)
 79a:	7be2                	ld	s7,56(sp)
 79c:	7c42                	ld	s8,48(sp)
 79e:	7ca2                	ld	s9,40(sp)
 7a0:	7d02                	ld	s10,32(sp)
 7a2:	6de2                	ld	s11,24(sp)
 7a4:	6109                	addi	sp,sp,128
 7a6:	8082                	ret

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	8622                	mv	a2,s0
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e04080e7          	jalr	-508(ra) # 5ca <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6161                	addi	sp,sp,80
 7d4:	8082                	ret

00000000000007d6 <printf>:

void
printf(const char *fmt, ...)
{
 7d6:	711d                	addi	sp,sp,-96
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e40c                	sd	a1,8(s0)
 7e0:	e810                	sd	a2,16(s0)
 7e2:	ec14                	sd	a3,24(s0)
 7e4:	f018                	sd	a4,32(s0)
 7e6:	f41c                	sd	a5,40(s0)
 7e8:	03043823          	sd	a6,48(s0)
 7ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	00840613          	addi	a2,s0,8
 7f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f8:	85aa                	mv	a1,a0
 7fa:	4505                	li	a0,1
 7fc:	00000097          	auipc	ra,0x0
 800:	dce080e7          	jalr	-562(ra) # 5ca <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6125                	addi	sp,sp,96
 80a:	8082                	ret

000000000000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	00000797          	auipc	a5,0x0
 81a:	7ea7b783          	ld	a5,2026(a5) # 1000 <freep>
 81e:	a02d                	j	848 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9f2d                	addw	a4,a4,a1
 824:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6310                	ld	a2,0(a4)
 82c:	a83d                	j	86a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9f31                	addw	a4,a4,a2
 834:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053683          	ld	a3,-16(a0)
 83a:	a091                	j	87e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6398                	ld	a4,0(a5)
 83e:	00e7e463          	bltu	a5,a4,846 <free+0x3a>
 842:	00e6ea63          	bltu	a3,a4,856 <free+0x4a>
{
 846:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fed7fae3          	bgeu	a5,a3,83c <free+0x30>
 84c:	6398                	ld	a4,0(a5)
 84e:	00e6e463          	bltu	a3,a4,856 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	fee7eae3          	bltu	a5,a4,846 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 856:	ff852583          	lw	a1,-8(a0)
 85a:	6390                	ld	a2,0(a5)
 85c:	02059813          	slli	a6,a1,0x20
 860:	01c85713          	srli	a4,a6,0x1c
 864:	9736                	add	a4,a4,a3
 866:	fae60de3          	beq	a2,a4,820 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86e:	4790                	lw	a2,8(a5)
 870:	02061593          	slli	a1,a2,0x20
 874:	01c5d713          	srli	a4,a1,0x1c
 878:	973e                	add	a4,a4,a5
 87a:	fae68ae3          	beq	a3,a4,82e <free+0x22>
    p->s.ptr = bp->s.ptr;
 87e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret

000000000000088e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88e:	7139                	addi	sp,sp,-64
 890:	fc06                	sd	ra,56(sp)
 892:	f822                	sd	s0,48(sp)
 894:	f426                	sd	s1,40(sp)
 896:	f04a                	sd	s2,32(sp)
 898:	ec4e                	sd	s3,24(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
 8a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	02051493          	slli	s1,a0,0x20
 8a6:	9081                	srli	s1,s1,0x20
 8a8:	04bd                	addi	s1,s1,15
 8aa:	8091                	srli	s1,s1,0x4
 8ac:	0014899b          	addiw	s3,s1,1
 8b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b2:	00000517          	auipc	a0,0x0
 8b6:	74e53503          	ld	a0,1870(a0) # 1000 <freep>
 8ba:	c515                	beqz	a0,8e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	02977f63          	bgeu	a4,s1,8fe <malloc+0x70>
 8c4:	8a4e                	mv	s4,s3
 8c6:	0009871b          	sext.w	a4,s3
 8ca:	6685                	lui	a3,0x1
 8cc:	00d77363          	bgeu	a4,a3,8d2 <malloc+0x44>
 8d0:	6a05                	lui	s4,0x1
 8d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8da:	00000917          	auipc	s2,0x0
 8de:	72690913          	addi	s2,s2,1830 # 1000 <freep>
  if(p == (char*)-1)
 8e2:	5afd                	li	s5,-1
 8e4:	a895                	j	958 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8e6:	00000797          	auipc	a5,0x0
 8ea:	72a78793          	addi	a5,a5,1834 # 1010 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7e1                	j	8c4 <malloc+0x36>
      if(p->s.size == nunits)
 8fe:	02e48c63          	beq	s1,a4,936 <malloc+0xa8>
        p->s.size -= nunits;
 902:	4137073b          	subw	a4,a4,s3
 906:	c798                	sw	a4,8(a5)
        p += p->s.size;
 908:	02071693          	slli	a3,a4,0x20
 90c:	01c6d713          	srli	a4,a3,0x1c
 910:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 912:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 916:	00000717          	auipc	a4,0x0
 91a:	6ea73523          	sd	a0,1770(a4) # 1000 <freep>
      return (void*)(p + 1);
 91e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 922:	70e2                	ld	ra,56(sp)
 924:	7442                	ld	s0,48(sp)
 926:	74a2                	ld	s1,40(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	6121                	addi	sp,sp,64
 934:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	bff1                	j	916 <malloc+0x88>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	00000097          	auipc	ra,0x0
 946:	eca080e7          	jalr	-310(ra) # 80c <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	d971                	beqz	a0,922 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	fa9775e3          	bgeu	a4,s1,8fe <malloc+0x70>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	00000097          	auipc	ra,0x0
 968:	b80080e7          	jalr	-1152(ra) # 4e4 <sbrk>
  if(p == (char*)-1)
 96c:	fd5518e3          	bne	a0,s5,93c <malloc+0xae>
        return 0;
 970:	4501                	li	a0,0
 972:	bf45                	j	922 <malloc+0x94>
