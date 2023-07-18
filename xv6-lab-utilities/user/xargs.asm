
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
  2e:	97e080e7          	jalr	-1666(ra) # 9a8 <malloc>
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
  6e:	00001097          	auipc	ra,0x1
  72:	8b8080e7          	jalr	-1864(ra) # 926 <free>
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
  9e:	0aa7da63          	bge	a5,a0,152 <main+0xc8>
  a2:	8a2a                	mv	s4,a0
  a4:	89ae                	mv	s3,a1
        fprintf(STOUT, "Usage: xargs <command> <args>\n");
        exit(-1);
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
  ba:	0089b783          	ld	a5,8(s3)
  be:	ecf43023          	sd	a5,-320(s0)
    arg_num++;

    for (int i = 2; i < argc; i++) {
  c2:	4789                	li	a5,2
  c4:	2147db63          	bge	a5,s4,2da <main+0x250>
  c8:	ec840913          	addi	s2,s0,-312
  cc:	09c1                	addi	s3,s3,16
  ce:	000a049b          	sext.w	s1,s4
  d2:	3a75                	addiw	s4,s4,-3
  d4:	020a1793          	slli	a5,s4,0x20
  d8:	01d7da13          	srli	s4,a5,0x1d
  dc:	ed040793          	addi	a5,s0,-304
  e0:	9a3e                	add	s4,s4,a5
        strcpy(args[arg_num], argv[i]);
  e2:	0009b583          	ld	a1,0(s3)
  e6:	00093503          	ld	a0,0(s2)
  ea:	00000097          	auipc	ra,0x0
  ee:	220080e7          	jalr	544(ra) # 30a <strcpy>
    for (int i = 2; i < argc; i++) {
  f2:	0921                	addi	s2,s2,8
  f4:	09a1                	addi	s3,s3,8
  f6:	ff4916e3          	bne	s2,s4,e2 <main+0x58>
        arg_num++;
  fa:	34fd                	addiw	s1,s1,-1
    }
    // 打印参数
    fprintf(STOUT, "xargs in argv: ");
  fc:	00001597          	auipc	a1,0x1
 100:	9b458593          	addi	a1,a1,-1612 # ab0 <malloc+0x108>
 104:	4505                	li	a0,1
 106:	00000097          	auipc	ra,0x0
 10a:	7bc080e7          	jalr	1980(ra) # 8c2 <fprintf>
    for (int i = 0; i < arg_num; i++) {
 10e:	ec040993          	addi	s3,s0,-320
    arg_num++;
 112:	4901                	li	s2,0
        fprintf(STOUT, "%s ", args[i]);
 114:	00001a17          	auipc	s4,0x1
 118:	9aca0a13          	addi	s4,s4,-1620 # ac0 <malloc+0x118>
 11c:	0009b603          	ld	a2,0(s3)
 120:	85d2                	mv	a1,s4
 122:	4505                	li	a0,1
 124:	00000097          	auipc	ra,0x0
 128:	79e080e7          	jalr	1950(ra) # 8c2 <fprintf>
    for (int i = 0; i < arg_num; i++) {
 12c:	2905                	addiw	s2,s2,1
 12e:	09a1                	addi	s3,s3,8
 130:	fe9946e3          	blt	s2,s1,11c <main+0x92>
    }
    fprintf(STOUT, "\n");
 134:	00001597          	auipc	a1,0x1
 138:	99458593          	addi	a1,a1,-1644 # ac8 <malloc+0x120>
 13c:	4505                	li	a0,1
 13e:	00000097          	auipc	ra,0x0
 142:	784080e7          	jalr	1924(ra) # 8c2 <fprintf>
    int arg_num = 0, arg_len = 0;
 146:	4901                	li	s2,0

    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
 148:	49fd                	li	s3,31
        if (tmp == '\n') {
 14a:	4a29                	li	s4,10
            args[arg_num][arg_len] = '\0';
            arg_len = 0;
            arg_num++;
            break;
        }
        else if (tmp == ' ') {
 14c:	02000a93          	li	s5,32
    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
 150:	aa01                	j	260 <main+0x1d6>
        fprintf(STOUT, "Usage: xargs <command> <args>\n");
 152:	00001597          	auipc	a1,0x1
 156:	93e58593          	addi	a1,a1,-1730 # a90 <malloc+0xe8>
 15a:	4505                	li	a0,1
 15c:	00000097          	auipc	ra,0x0
 160:	766080e7          	jalr	1894(ra) # 8c2 <fprintf>
        exit(-1);
 164:	557d                	li	a0,-1
 166:	00000097          	auipc	ra,0x0
 16a:	410080e7          	jalr	1040(ra) # 576 <exit>
            args[arg_num][arg_len] = '\0';
 16e:	00349793          	slli	a5,s1,0x3
 172:	fc078793          	addi	a5,a5,-64
 176:	97a2                	add	a5,a5,s0
 178:	f007b783          	ld	a5,-256(a5)
 17c:	97ca                	add	a5,a5,s2
 17e:	00078023          	sb	zero,0(a5)
            arg_num++;
 182:	2485                	addiw	s1,s1,1
            args[arg_num][arg_len] = tmp;
            arg_len++;
        }
    }

    args[arg_num] = 0;
 184:	00349793          	slli	a5,s1,0x3
 188:	fc078793          	addi	a5,a5,-64
 18c:	97a2                	add	a5,a5,s0
 18e:	f007b023          	sd	zero,-256(a5)

    fprintf(STOUT, "xargs in all: ");
 192:	00001597          	auipc	a1,0x1
 196:	93e58593          	addi	a1,a1,-1730 # ad0 <malloc+0x128>
 19a:	4505                	li	a0,1
 19c:	00000097          	auipc	ra,0x0
 1a0:	726080e7          	jalr	1830(ra) # 8c2 <fprintf>
    for (int i = 0; i < arg_num; i++) {
 1a4:	02905c63          	blez	s1,1dc <main+0x152>
 1a8:	ec040913          	addi	s2,s0,-320
 1ac:	fff4899b          	addiw	s3,s1,-1
 1b0:	02099793          	slli	a5,s3,0x20
 1b4:	01d7d993          	srli	s3,a5,0x1d
 1b8:	ec840793          	addi	a5,s0,-312
 1bc:	99be                	add	s3,s3,a5
        fprintf(STOUT, "%s ", args[i]);
 1be:	00001a17          	auipc	s4,0x1
 1c2:	902a0a13          	addi	s4,s4,-1790 # ac0 <malloc+0x118>
 1c6:	00093603          	ld	a2,0(s2)
 1ca:	85d2                	mv	a1,s4
 1cc:	4505                	li	a0,1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	6f4080e7          	jalr	1780(ra) # 8c2 <fprintf>
    for (int i = 0; i < arg_num; i++) {
 1d6:	0921                	addi	s2,s2,8
 1d8:	ff3917e3          	bne	s2,s3,1c6 <main+0x13c>
    }
    fprintf(STOUT, "\n");
 1dc:	00001597          	auipc	a1,0x1
 1e0:	8ec58593          	addi	a1,a1,-1812 # ac8 <malloc+0x120>
 1e4:	4505                	li	a0,1
 1e6:	00000097          	auipc	ra,0x0
 1ea:	6dc080e7          	jalr	1756(ra) # 8c2 <fprintf>

    if (fork() == 0) {
 1ee:	00000097          	auipc	ra,0x0
 1f2:	380080e7          	jalr	896(ra) # 56e <fork>
 1f6:	e169                	bnez	a0,2b8 <main+0x22e>
        int val = exec("/echo", args);
 1f8:	ec040593          	addi	a1,s0,-320
 1fc:	00001517          	auipc	a0,0x1
 200:	8e450513          	addi	a0,a0,-1820 # ae0 <malloc+0x138>
 204:	00000097          	auipc	ra,0x0
 208:	3aa080e7          	jalr	938(ra) # 5ae <exec>
 20c:	892a                	mv	s2,a0
        if (val < 0) {
 20e:	08054763          	bltz	a0,29c <main+0x212>
            fprintf(STOUT, "exec failed\n");
            exit(-1);
        }
        else {
            fprintf(STOUT, "exec success\n");
 212:	00001597          	auipc	a1,0x1
 216:	8e658593          	addi	a1,a1,-1818 # af8 <malloc+0x150>
 21a:	4505                	li	a0,1
 21c:	00000097          	auipc	ra,0x0
 220:	6a6080e7          	jalr	1702(ra) # 8c2 <fprintf>
            fprintf(STOUT, "exec return value: %d\n", val);
 224:	864a                	mv	a2,s2
 226:	00001597          	auipc	a1,0x1
 22a:	8e258593          	addi	a1,a1,-1822 # b08 <malloc+0x160>
 22e:	4505                	li	a0,1
 230:	00000097          	auipc	ra,0x0
 234:	692080e7          	jalr	1682(ra) # 8c2 <fprintf>
        }
        free_args(args, arg_num);
 238:	85a6                	mv	a1,s1
 23a:	ec040513          	addi	a0,s0,-320
 23e:	00000097          	auipc	ra,0x0
 242:	e0c080e7          	jalr	-500(ra) # 4a <free_args>
 246:	a069                	j	2d0 <main+0x246>
            args[arg_num][arg_len] = '\0';
 248:	00349793          	slli	a5,s1,0x3
 24c:	fc078793          	addi	a5,a5,-64
 250:	97a2                	add	a5,a5,s0
 252:	f007b783          	ld	a5,-256(a5)
 256:	97ca                	add	a5,a5,s2
 258:	00078023          	sb	zero,0(a5)
            arg_num++;
 25c:	2485                	addiw	s1,s1,1
            arg_len = 0;
 25e:	4901                	li	s2,0
    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
 260:	4605                	li	a2,1
 262:	ebf40593          	addi	a1,s0,-321
 266:	4501                	li	a0,0
 268:	00000097          	auipc	ra,0x0
 26c:	326080e7          	jalr	806(ra) # 58e <read>
 270:	f0a05ae3          	blez	a0,184 <main+0xfa>
 274:	f099c8e3          	blt	s3,s1,184 <main+0xfa>
        if (tmp == '\n') {
 278:	ebf44783          	lbu	a5,-321(s0)
 27c:	ef4789e3          	beq	a5,s4,16e <main+0xe4>
        else if (tmp == ' ') {
 280:	fd5784e3          	beq	a5,s5,248 <main+0x1be>
            args[arg_num][arg_len] = tmp;
 284:	00349713          	slli	a4,s1,0x3
 288:	fc070713          	addi	a4,a4,-64
 28c:	9722                	add	a4,a4,s0
 28e:	f0073703          	ld	a4,-256(a4)
 292:	974a                	add	a4,a4,s2
 294:	00f70023          	sb	a5,0(a4)
            arg_len++;
 298:	2905                	addiw	s2,s2,1
 29a:	b7d9                	j	260 <main+0x1d6>
            fprintf(STOUT, "exec failed\n");
 29c:	00001597          	auipc	a1,0x1
 2a0:	84c58593          	addi	a1,a1,-1972 # ae8 <malloc+0x140>
 2a4:	4505                	li	a0,1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	61c080e7          	jalr	1564(ra) # 8c2 <fprintf>
            exit(-1);
 2ae:	557d                	li	a0,-1
 2b0:	00000097          	auipc	ra,0x0
 2b4:	2c6080e7          	jalr	710(ra) # 576 <exit>
    }
    else {
        wait(0);
 2b8:	4501                	li	a0,0
 2ba:	00000097          	auipc	ra,0x0
 2be:	2c4080e7          	jalr	708(ra) # 57e <wait>
        free_args(args, arg_num);
 2c2:	85a6                	mv	a1,s1
 2c4:	ec040513          	addi	a0,s0,-320
 2c8:	00000097          	auipc	ra,0x0
 2cc:	d82080e7          	jalr	-638(ra) # 4a <free_args>
    }

    exit(0);
 2d0:	4501                	li	a0,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	2a4080e7          	jalr	676(ra) # 576 <exit>
    fprintf(STOUT, "xargs in argv: ");
 2da:	00000597          	auipc	a1,0x0
 2de:	7d658593          	addi	a1,a1,2006 # ab0 <malloc+0x108>
 2e2:	4505                	li	a0,1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	5de080e7          	jalr	1502(ra) # 8c2 <fprintf>
    arg_num++;
 2ec:	4485                	li	s1,1
 2ee:	b505                	j	10e <main+0x84>

00000000000002f0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2f8:	00000097          	auipc	ra,0x0
 2fc:	d92080e7          	jalr	-622(ra) # 8a <main>
  exit(0);
 300:	4501                	li	a0,0
 302:	00000097          	auipc	ra,0x0
 306:	274080e7          	jalr	628(ra) # 576 <exit>

000000000000030a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 310:	87aa                	mv	a5,a0
 312:	0585                	addi	a1,a1,1
 314:	0785                	addi	a5,a5,1
 316:	fff5c703          	lbu	a4,-1(a1)
 31a:	fee78fa3          	sb	a4,-1(a5)
 31e:	fb75                	bnez	a4,312 <strcpy+0x8>
    ;
  return os;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 32c:	00054783          	lbu	a5,0(a0)
 330:	cb91                	beqz	a5,344 <strcmp+0x1e>
 332:	0005c703          	lbu	a4,0(a1)
 336:	00f71763          	bne	a4,a5,344 <strcmp+0x1e>
    p++, q++;
 33a:	0505                	addi	a0,a0,1
 33c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 33e:	00054783          	lbu	a5,0(a0)
 342:	fbe5                	bnez	a5,332 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 344:	0005c503          	lbu	a0,0(a1)
}
 348:	40a7853b          	subw	a0,a5,a0
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <strlen>:

uint
strlen(const char *s)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cf91                	beqz	a5,378 <strlen+0x26>
 35e:	0505                	addi	a0,a0,1
 360:	87aa                	mv	a5,a0
 362:	4685                	li	a3,1
 364:	9e89                	subw	a3,a3,a0
 366:	00f6853b          	addw	a0,a3,a5
 36a:	0785                	addi	a5,a5,1
 36c:	fff7c703          	lbu	a4,-1(a5)
 370:	fb7d                	bnez	a4,366 <strlen+0x14>
    ;
  return n;
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  for(n = 0; s[n]; n++)
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strlen+0x20>

000000000000037c <memset>:

void*
memset(void *dst, int c, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 382:	ca19                	beqz	a2,398 <memset+0x1c>
 384:	87aa                	mv	a5,a0
 386:	1602                	slli	a2,a2,0x20
 388:	9201                	srli	a2,a2,0x20
 38a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 38e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 392:	0785                	addi	a5,a5,1
 394:	fee79de3          	bne	a5,a4,38e <memset+0x12>
  }
  return dst;
}
 398:	6422                	ld	s0,8(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret

000000000000039e <strchr>:

char*
strchr(const char *s, char c)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	cb99                	beqz	a5,3be <strchr+0x20>
    if(*s == c)
 3aa:	00f58763          	beq	a1,a5,3b8 <strchr+0x1a>
  for(; *s; s++)
 3ae:	0505                	addi	a0,a0,1
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	fbfd                	bnez	a5,3aa <strchr+0xc>
      return (char*)s;
  return 0;
 3b6:	4501                	li	a0,0
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
  return 0;
 3be:	4501                	li	a0,0
 3c0:	bfe5                	j	3b8 <strchr+0x1a>

00000000000003c2 <gets>:

char*
gets(char *buf, int max)
{
 3c2:	711d                	addi	sp,sp,-96
 3c4:	ec86                	sd	ra,88(sp)
 3c6:	e8a2                	sd	s0,80(sp)
 3c8:	e4a6                	sd	s1,72(sp)
 3ca:	e0ca                	sd	s2,64(sp)
 3cc:	fc4e                	sd	s3,56(sp)
 3ce:	f852                	sd	s4,48(sp)
 3d0:	f456                	sd	s5,40(sp)
 3d2:	f05a                	sd	s6,32(sp)
 3d4:	ec5e                	sd	s7,24(sp)
 3d6:	1080                	addi	s0,sp,96
 3d8:	8baa                	mv	s7,a0
 3da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3dc:	892a                	mv	s2,a0
 3de:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e0:	4aa9                	li	s5,10
 3e2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e4:	89a6                	mv	s3,s1
 3e6:	2485                	addiw	s1,s1,1
 3e8:	0344d863          	bge	s1,s4,418 <gets+0x56>
    cc = read(0, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	faf40593          	addi	a1,s0,-81
 3f2:	4501                	li	a0,0
 3f4:	00000097          	auipc	ra,0x0
 3f8:	19a080e7          	jalr	410(ra) # 58e <read>
    if(cc < 1)
 3fc:	00a05e63          	blez	a0,418 <gets+0x56>
    buf[i++] = c;
 400:	faf44783          	lbu	a5,-81(s0)
 404:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 408:	01578763          	beq	a5,s5,416 <gets+0x54>
 40c:	0905                	addi	s2,s2,1
 40e:	fd679be3          	bne	a5,s6,3e4 <gets+0x22>
  for(i=0; i+1 < max; ){
 412:	89a6                	mv	s3,s1
 414:	a011                	j	418 <gets+0x56>
 416:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 418:	99de                	add	s3,s3,s7
 41a:	00098023          	sb	zero,0(s3)
  return buf;
}
 41e:	855e                	mv	a0,s7
 420:	60e6                	ld	ra,88(sp)
 422:	6446                	ld	s0,80(sp)
 424:	64a6                	ld	s1,72(sp)
 426:	6906                	ld	s2,64(sp)
 428:	79e2                	ld	s3,56(sp)
 42a:	7a42                	ld	s4,48(sp)
 42c:	7aa2                	ld	s5,40(sp)
 42e:	7b02                	ld	s6,32(sp)
 430:	6be2                	ld	s7,24(sp)
 432:	6125                	addi	sp,sp,96
 434:	8082                	ret

0000000000000436 <stat>:

int
stat(const char *n, struct stat *st)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	e426                	sd	s1,8(sp)
 43e:	e04a                	sd	s2,0(sp)
 440:	1000                	addi	s0,sp,32
 442:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 444:	4581                	li	a1,0
 446:	00000097          	auipc	ra,0x0
 44a:	170080e7          	jalr	368(ra) # 5b6 <open>
  if(fd < 0)
 44e:	02054563          	bltz	a0,478 <stat+0x42>
 452:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 454:	85ca                	mv	a1,s2
 456:	00000097          	auipc	ra,0x0
 45a:	178080e7          	jalr	376(ra) # 5ce <fstat>
 45e:	892a                	mv	s2,a0
  close(fd);
 460:	8526                	mv	a0,s1
 462:	00000097          	auipc	ra,0x0
 466:	13c080e7          	jalr	316(ra) # 59e <close>
  return r;
}
 46a:	854a                	mv	a0,s2
 46c:	60e2                	ld	ra,24(sp)
 46e:	6442                	ld	s0,16(sp)
 470:	64a2                	ld	s1,8(sp)
 472:	6902                	ld	s2,0(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret
    return -1;
 478:	597d                	li	s2,-1
 47a:	bfc5                	j	46a <stat+0x34>

000000000000047c <atoi>:

int
atoi(const char *s)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 482:	00054683          	lbu	a3,0(a0)
 486:	fd06879b          	addiw	a5,a3,-48
 48a:	0ff7f793          	zext.b	a5,a5
 48e:	4625                	li	a2,9
 490:	02f66863          	bltu	a2,a5,4c0 <atoi+0x44>
 494:	872a                	mv	a4,a0
  n = 0;
 496:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 498:	0705                	addi	a4,a4,1
 49a:	0025179b          	slliw	a5,a0,0x2
 49e:	9fa9                	addw	a5,a5,a0
 4a0:	0017979b          	slliw	a5,a5,0x1
 4a4:	9fb5                	addw	a5,a5,a3
 4a6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4aa:	00074683          	lbu	a3,0(a4)
 4ae:	fd06879b          	addiw	a5,a3,-48
 4b2:	0ff7f793          	zext.b	a5,a5
 4b6:	fef671e3          	bgeu	a2,a5,498 <atoi+0x1c>
  return n;
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
  n = 0;
 4c0:	4501                	li	a0,0
 4c2:	bfe5                	j	4ba <atoi+0x3e>

00000000000004c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ca:	02b57463          	bgeu	a0,a1,4f2 <memmove+0x2e>
    while(n-- > 0)
 4ce:	00c05f63          	blez	a2,4ec <memmove+0x28>
 4d2:	1602                	slli	a2,a2,0x20
 4d4:	9201                	srli	a2,a2,0x20
 4d6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4da:	872a                	mv	a4,a0
      *dst++ = *src++;
 4dc:	0585                	addi	a1,a1,1
 4de:	0705                	addi	a4,a4,1
 4e0:	fff5c683          	lbu	a3,-1(a1)
 4e4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e8:	fee79ae3          	bne	a5,a4,4dc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
    dst += n;
 4f2:	00c50733          	add	a4,a0,a2
    src += n;
 4f6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4f8:	fec05ae3          	blez	a2,4ec <memmove+0x28>
 4fc:	fff6079b          	addiw	a5,a2,-1
 500:	1782                	slli	a5,a5,0x20
 502:	9381                	srli	a5,a5,0x20
 504:	fff7c793          	not	a5,a5
 508:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50a:	15fd                	addi	a1,a1,-1
 50c:	177d                	addi	a4,a4,-1
 50e:	0005c683          	lbu	a3,0(a1)
 512:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 516:	fee79ae3          	bne	a5,a4,50a <memmove+0x46>
 51a:	bfc9                	j	4ec <memmove+0x28>

000000000000051c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 522:	ca05                	beqz	a2,552 <memcmp+0x36>
 524:	fff6069b          	addiw	a3,a2,-1
 528:	1682                	slli	a3,a3,0x20
 52a:	9281                	srli	a3,a3,0x20
 52c:	0685                	addi	a3,a3,1
 52e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 530:	00054783          	lbu	a5,0(a0)
 534:	0005c703          	lbu	a4,0(a1)
 538:	00e79863          	bne	a5,a4,548 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 53c:	0505                	addi	a0,a0,1
    p2++;
 53e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 540:	fed518e3          	bne	a0,a3,530 <memcmp+0x14>
  }
  return 0;
 544:	4501                	li	a0,0
 546:	a019                	j	54c <memcmp+0x30>
      return *p1 - *p2;
 548:	40e7853b          	subw	a0,a5,a4
}
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret
  return 0;
 552:	4501                	li	a0,0
 554:	bfe5                	j	54c <memcmp+0x30>

0000000000000556 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e406                	sd	ra,8(sp)
 55a:	e022                	sd	s0,0(sp)
 55c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 55e:	00000097          	auipc	ra,0x0
 562:	f66080e7          	jalr	-154(ra) # 4c4 <memmove>
}
 566:	60a2                	ld	ra,8(sp)
 568:	6402                	ld	s0,0(sp)
 56a:	0141                	addi	sp,sp,16
 56c:	8082                	ret

000000000000056e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 56e:	4885                	li	a7,1
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <exit>:
.global exit
exit:
 li a7, SYS_exit
 576:	4889                	li	a7,2
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <wait>:
.global wait
wait:
 li a7, SYS_wait
 57e:	488d                	li	a7,3
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 586:	4891                	li	a7,4
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <read>:
.global read
read:
 li a7, SYS_read
 58e:	4895                	li	a7,5
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <write>:
.global write
write:
 li a7, SYS_write
 596:	48c1                	li	a7,16
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <close>:
.global close
close:
 li a7, SYS_close
 59e:	48d5                	li	a7,21
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a6:	4899                	li	a7,6
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ae:	489d                	li	a7,7
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <open>:
.global open
open:
 li a7, SYS_open
 5b6:	48bd                	li	a7,15
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5be:	48c5                	li	a7,17
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c6:	48c9                	li	a7,18
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ce:	48a1                	li	a7,8
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <link>:
.global link
link:
 li a7, SYS_link
 5d6:	48cd                	li	a7,19
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5de:	48d1                	li	a7,20
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e6:	48a5                	li	a7,9
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ee:	48a9                	li	a7,10
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f6:	48ad                	li	a7,11
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fe:	48b1                	li	a7,12
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 606:	48b5                	li	a7,13
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60e:	48b9                	li	a7,14
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 616:	1101                	addi	sp,sp,-32
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	addi	s0,sp,32
 61e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 622:	4605                	li	a2,1
 624:	fef40593          	addi	a1,s0,-17
 628:	00000097          	auipc	ra,0x0
 62c:	f6e080e7          	jalr	-146(ra) # 596 <write>
}
 630:	60e2                	ld	ra,24(sp)
 632:	6442                	ld	s0,16(sp)
 634:	6105                	addi	sp,sp,32
 636:	8082                	ret

0000000000000638 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 638:	7139                	addi	sp,sp,-64
 63a:	fc06                	sd	ra,56(sp)
 63c:	f822                	sd	s0,48(sp)
 63e:	f426                	sd	s1,40(sp)
 640:	f04a                	sd	s2,32(sp)
 642:	ec4e                	sd	s3,24(sp)
 644:	0080                	addi	s0,sp,64
 646:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 648:	c299                	beqz	a3,64e <printint+0x16>
 64a:	0805c963          	bltz	a1,6dc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64e:	2581                	sext.w	a1,a1
  neg = 0;
 650:	4881                	li	a7,0
 652:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 656:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 658:	2601                	sext.w	a2,a2
 65a:	00000517          	auipc	a0,0x0
 65e:	52650513          	addi	a0,a0,1318 # b80 <digits>
 662:	883a                	mv	a6,a4
 664:	2705                	addiw	a4,a4,1
 666:	02c5f7bb          	remuw	a5,a1,a2
 66a:	1782                	slli	a5,a5,0x20
 66c:	9381                	srli	a5,a5,0x20
 66e:	97aa                	add	a5,a5,a0
 670:	0007c783          	lbu	a5,0(a5)
 674:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 678:	0005879b          	sext.w	a5,a1
 67c:	02c5d5bb          	divuw	a1,a1,a2
 680:	0685                	addi	a3,a3,1
 682:	fec7f0e3          	bgeu	a5,a2,662 <printint+0x2a>
  if(neg)
 686:	00088c63          	beqz	a7,69e <printint+0x66>
    buf[i++] = '-';
 68a:	fd070793          	addi	a5,a4,-48
 68e:	00878733          	add	a4,a5,s0
 692:	02d00793          	li	a5,45
 696:	fef70823          	sb	a5,-16(a4)
 69a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 69e:	02e05863          	blez	a4,6ce <printint+0x96>
 6a2:	fc040793          	addi	a5,s0,-64
 6a6:	00e78933          	add	s2,a5,a4
 6aa:	fff78993          	addi	s3,a5,-1
 6ae:	99ba                	add	s3,s3,a4
 6b0:	377d                	addiw	a4,a4,-1
 6b2:	1702                	slli	a4,a4,0x20
 6b4:	9301                	srli	a4,a4,0x20
 6b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ba:	fff94583          	lbu	a1,-1(s2)
 6be:	8526                	mv	a0,s1
 6c0:	00000097          	auipc	ra,0x0
 6c4:	f56080e7          	jalr	-170(ra) # 616 <putc>
  while(--i >= 0)
 6c8:	197d                	addi	s2,s2,-1
 6ca:	ff3918e3          	bne	s2,s3,6ba <printint+0x82>
}
 6ce:	70e2                	ld	ra,56(sp)
 6d0:	7442                	ld	s0,48(sp)
 6d2:	74a2                	ld	s1,40(sp)
 6d4:	7902                	ld	s2,32(sp)
 6d6:	69e2                	ld	s3,24(sp)
 6d8:	6121                	addi	sp,sp,64
 6da:	8082                	ret
    x = -xx;
 6dc:	40b005bb          	negw	a1,a1
    neg = 1;
 6e0:	4885                	li	a7,1
    x = -xx;
 6e2:	bf85                	j	652 <printint+0x1a>

00000000000006e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e4:	7119                	addi	sp,sp,-128
 6e6:	fc86                	sd	ra,120(sp)
 6e8:	f8a2                	sd	s0,112(sp)
 6ea:	f4a6                	sd	s1,104(sp)
 6ec:	f0ca                	sd	s2,96(sp)
 6ee:	ecce                	sd	s3,88(sp)
 6f0:	e8d2                	sd	s4,80(sp)
 6f2:	e4d6                	sd	s5,72(sp)
 6f4:	e0da                	sd	s6,64(sp)
 6f6:	fc5e                	sd	s7,56(sp)
 6f8:	f862                	sd	s8,48(sp)
 6fa:	f466                	sd	s9,40(sp)
 6fc:	f06a                	sd	s10,32(sp)
 6fe:	ec6e                	sd	s11,24(sp)
 700:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 702:	0005c903          	lbu	s2,0(a1)
 706:	18090f63          	beqz	s2,8a4 <vprintf+0x1c0>
 70a:	8aaa                	mv	s5,a0
 70c:	8b32                	mv	s6,a2
 70e:	00158493          	addi	s1,a1,1
  state = 0;
 712:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 714:	02500a13          	li	s4,37
 718:	4c55                	li	s8,21
 71a:	00000c97          	auipc	s9,0x0
 71e:	40ec8c93          	addi	s9,s9,1038 # b28 <malloc+0x180>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 722:	02800d93          	li	s11,40
  putc(fd, 'x');
 726:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 728:	00000b97          	auipc	s7,0x0
 72c:	458b8b93          	addi	s7,s7,1112 # b80 <digits>
 730:	a839                	j	74e <vprintf+0x6a>
        putc(fd, c);
 732:	85ca                	mv	a1,s2
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	ee0080e7          	jalr	-288(ra) # 616 <putc>
 73e:	a019                	j	744 <vprintf+0x60>
    } else if(state == '%'){
 740:	01498d63          	beq	s3,s4,75a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 744:	0485                	addi	s1,s1,1
 746:	fff4c903          	lbu	s2,-1(s1)
 74a:	14090d63          	beqz	s2,8a4 <vprintf+0x1c0>
    if(state == 0){
 74e:	fe0999e3          	bnez	s3,740 <vprintf+0x5c>
      if(c == '%'){
 752:	ff4910e3          	bne	s2,s4,732 <vprintf+0x4e>
        state = '%';
 756:	89d2                	mv	s3,s4
 758:	b7f5                	j	744 <vprintf+0x60>
      if(c == 'd'){
 75a:	11490c63          	beq	s2,s4,872 <vprintf+0x18e>
 75e:	f9d9079b          	addiw	a5,s2,-99
 762:	0ff7f793          	zext.b	a5,a5
 766:	10fc6e63          	bltu	s8,a5,882 <vprintf+0x19e>
 76a:	f9d9079b          	addiw	a5,s2,-99
 76e:	0ff7f713          	zext.b	a4,a5
 772:	10ec6863          	bltu	s8,a4,882 <vprintf+0x19e>
 776:	00271793          	slli	a5,a4,0x2
 77a:	97e6                	add	a5,a5,s9
 77c:	439c                	lw	a5,0(a5)
 77e:	97e6                	add	a5,a5,s9
 780:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 782:	008b0913          	addi	s2,s6,8
 786:	4685                	li	a3,1
 788:	4629                	li	a2,10
 78a:	000b2583          	lw	a1,0(s6)
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	ea8080e7          	jalr	-344(ra) # 638 <printint>
 798:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b765                	j	744 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	008b0913          	addi	s2,s6,8
 7a2:	4681                	li	a3,0
 7a4:	4629                	li	a2,10
 7a6:	000b2583          	lw	a1,0(s6)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e8c080e7          	jalr	-372(ra) # 638 <printint>
 7b4:	8b4a                	mv	s6,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b771                	j	744 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ba:	008b0913          	addi	s2,s6,8
 7be:	4681                	li	a3,0
 7c0:	866a                	mv	a2,s10
 7c2:	000b2583          	lw	a1,0(s6)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e70080e7          	jalr	-400(ra) # 638 <printint>
 7d0:	8b4a                	mv	s6,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bf85                	j	744 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7d6:	008b0793          	addi	a5,s6,8
 7da:	f8f43423          	sd	a5,-120(s0)
 7de:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7e2:	03000593          	li	a1,48
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e2e080e7          	jalr	-466(ra) # 616 <putc>
  putc(fd, 'x');
 7f0:	07800593          	li	a1,120
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	e20080e7          	jalr	-480(ra) # 616 <putc>
 7fe:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 800:	03c9d793          	srli	a5,s3,0x3c
 804:	97de                	add	a5,a5,s7
 806:	0007c583          	lbu	a1,0(a5)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e0a080e7          	jalr	-502(ra) # 616 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	397d                	addiw	s2,s2,-1
 818:	fe0914e3          	bnez	s2,800 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 81c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 820:	4981                	li	s3,0
 822:	b70d                	j	744 <vprintf+0x60>
        s = va_arg(ap, char*);
 824:	008b0913          	addi	s2,s6,8
 828:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 82c:	02098163          	beqz	s3,84e <vprintf+0x16a>
        while(*s != 0){
 830:	0009c583          	lbu	a1,0(s3)
 834:	c5ad                	beqz	a1,89e <vprintf+0x1ba>
          putc(fd, *s);
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	dde080e7          	jalr	-546(ra) # 616 <putc>
          s++;
 840:	0985                	addi	s3,s3,1
        while(*s != 0){
 842:	0009c583          	lbu	a1,0(s3)
 846:	f9e5                	bnez	a1,836 <vprintf+0x152>
        s = va_arg(ap, char*);
 848:	8b4a                	mv	s6,s2
      state = 0;
 84a:	4981                	li	s3,0
 84c:	bde5                	j	744 <vprintf+0x60>
          s = "(null)";
 84e:	00000997          	auipc	s3,0x0
 852:	2d298993          	addi	s3,s3,722 # b20 <malloc+0x178>
        while(*s != 0){
 856:	85ee                	mv	a1,s11
 858:	bff9                	j	836 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 85a:	008b0913          	addi	s2,s6,8
 85e:	000b4583          	lbu	a1,0(s6)
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	db2080e7          	jalr	-590(ra) # 616 <putc>
 86c:	8b4a                	mv	s6,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	bdd1                	j	744 <vprintf+0x60>
        putc(fd, c);
 872:	85d2                	mv	a1,s4
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	da0080e7          	jalr	-608(ra) # 616 <putc>
      state = 0;
 87e:	4981                	li	s3,0
 880:	b5d1                	j	744 <vprintf+0x60>
        putc(fd, '%');
 882:	85d2                	mv	a1,s4
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	d90080e7          	jalr	-624(ra) # 616 <putc>
        putc(fd, c);
 88e:	85ca                	mv	a1,s2
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	d84080e7          	jalr	-636(ra) # 616 <putc>
      state = 0;
 89a:	4981                	li	s3,0
 89c:	b565                	j	744 <vprintf+0x60>
        s = va_arg(ap, char*);
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b54d                	j	744 <vprintf+0x60>
    }
  }
}
 8a4:	70e6                	ld	ra,120(sp)
 8a6:	7446                	ld	s0,112(sp)
 8a8:	74a6                	ld	s1,104(sp)
 8aa:	7906                	ld	s2,96(sp)
 8ac:	69e6                	ld	s3,88(sp)
 8ae:	6a46                	ld	s4,80(sp)
 8b0:	6aa6                	ld	s5,72(sp)
 8b2:	6b06                	ld	s6,64(sp)
 8b4:	7be2                	ld	s7,56(sp)
 8b6:	7c42                	ld	s8,48(sp)
 8b8:	7ca2                	ld	s9,40(sp)
 8ba:	7d02                	ld	s10,32(sp)
 8bc:	6de2                	ld	s11,24(sp)
 8be:	6109                	addi	sp,sp,128
 8c0:	8082                	ret

00000000000008c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c2:	715d                	addi	sp,sp,-80
 8c4:	ec06                	sd	ra,24(sp)
 8c6:	e822                	sd	s0,16(sp)
 8c8:	1000                	addi	s0,sp,32
 8ca:	e010                	sd	a2,0(s0)
 8cc:	e414                	sd	a3,8(s0)
 8ce:	e818                	sd	a4,16(s0)
 8d0:	ec1c                	sd	a5,24(s0)
 8d2:	03043023          	sd	a6,32(s0)
 8d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8de:	8622                	mv	a2,s0
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e04080e7          	jalr	-508(ra) # 6e4 <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6161                	addi	sp,sp,80
 8ee:	8082                	ret

00000000000008f0 <printf>:

void
printf(const char *fmt, ...)
{
 8f0:	711d                	addi	sp,sp,-96
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	e40c                	sd	a1,8(s0)
 8fa:	e810                	sd	a2,16(s0)
 8fc:	ec14                	sd	a3,24(s0)
 8fe:	f018                	sd	a4,32(s0)
 900:	f41c                	sd	a5,40(s0)
 902:	03043823          	sd	a6,48(s0)
 906:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90a:	00840613          	addi	a2,s0,8
 90e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 912:	85aa                	mv	a1,a0
 914:	4505                	li	a0,1
 916:	00000097          	auipc	ra,0x0
 91a:	dce080e7          	jalr	-562(ra) # 6e4 <vprintf>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6125                	addi	sp,sp,96
 924:	8082                	ret

0000000000000926 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 926:	1141                	addi	sp,sp,-16
 928:	e422                	sd	s0,8(sp)
 92a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	00000797          	auipc	a5,0x0
 934:	6d07b783          	ld	a5,1744(a5) # 1000 <freep>
 938:	a02d                	j	962 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93a:	4618                	lw	a4,8(a2)
 93c:	9f2d                	addw	a4,a4,a1
 93e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	6398                	ld	a4,0(a5)
 944:	6310                	ld	a2,0(a4)
 946:	a83d                	j	984 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 948:	ff852703          	lw	a4,-8(a0)
 94c:	9f31                	addw	a4,a4,a2
 94e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 950:	ff053683          	ld	a3,-16(a0)
 954:	a091                	j	998 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 956:	6398                	ld	a4,0(a5)
 958:	00e7e463          	bltu	a5,a4,960 <free+0x3a>
 95c:	00e6ea63          	bltu	a3,a4,970 <free+0x4a>
{
 960:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 962:	fed7fae3          	bgeu	a5,a3,956 <free+0x30>
 966:	6398                	ld	a4,0(a5)
 968:	00e6e463          	bltu	a3,a4,970 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96c:	fee7eae3          	bltu	a5,a4,960 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 970:	ff852583          	lw	a1,-8(a0)
 974:	6390                	ld	a2,0(a5)
 976:	02059813          	slli	a6,a1,0x20
 97a:	01c85713          	srli	a4,a6,0x1c
 97e:	9736                	add	a4,a4,a3
 980:	fae60de3          	beq	a2,a4,93a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 984:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 988:	4790                	lw	a2,8(a5)
 98a:	02061593          	slli	a1,a2,0x20
 98e:	01c5d713          	srli	a4,a1,0x1c
 992:	973e                	add	a4,a4,a5
 994:	fae68ae3          	beq	a3,a4,948 <free+0x22>
    p->s.ptr = bp->s.ptr;
 998:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99a:	00000717          	auipc	a4,0x0
 99e:	66f73323          	sd	a5,1638(a4) # 1000 <freep>
}
 9a2:	6422                	ld	s0,8(sp)
 9a4:	0141                	addi	sp,sp,16
 9a6:	8082                	ret

00000000000009a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a8:	7139                	addi	sp,sp,-64
 9aa:	fc06                	sd	ra,56(sp)
 9ac:	f822                	sd	s0,48(sp)
 9ae:	f426                	sd	s1,40(sp)
 9b0:	f04a                	sd	s2,32(sp)
 9b2:	ec4e                	sd	s3,24(sp)
 9b4:	e852                	sd	s4,16(sp)
 9b6:	e456                	sd	s5,8(sp)
 9b8:	e05a                	sd	s6,0(sp)
 9ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9bc:	02051493          	slli	s1,a0,0x20
 9c0:	9081                	srli	s1,s1,0x20
 9c2:	04bd                	addi	s1,s1,15
 9c4:	8091                	srli	s1,s1,0x4
 9c6:	0014899b          	addiw	s3,s1,1
 9ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9cc:	00000517          	auipc	a0,0x0
 9d0:	63453503          	ld	a0,1588(a0) # 1000 <freep>
 9d4:	c515                	beqz	a0,a00 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	02977f63          	bgeu	a4,s1,a18 <malloc+0x70>
 9de:	8a4e                	mv	s4,s3
 9e0:	0009871b          	sext.w	a4,s3
 9e4:	6685                	lui	a3,0x1
 9e6:	00d77363          	bgeu	a4,a3,9ec <malloc+0x44>
 9ea:	6a05                	lui	s4,0x1
 9ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f4:	00000917          	auipc	s2,0x0
 9f8:	60c90913          	addi	s2,s2,1548 # 1000 <freep>
  if(p == (char*)-1)
 9fc:	5afd                	li	s5,-1
 9fe:	a895                	j	a72 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a00:	00000797          	auipc	a5,0x0
 a04:	61078793          	addi	a5,a5,1552 # 1010 <base>
 a08:	00000717          	auipc	a4,0x0
 a0c:	5ef73c23          	sd	a5,1528(a4) # 1000 <freep>
 a10:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a12:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a16:	b7e1                	j	9de <malloc+0x36>
      if(p->s.size == nunits)
 a18:	02e48c63          	beq	s1,a4,a50 <malloc+0xa8>
        p->s.size -= nunits;
 a1c:	4137073b          	subw	a4,a4,s3
 a20:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a22:	02071693          	slli	a3,a4,0x20
 a26:	01c6d713          	srli	a4,a3,0x1c
 a2a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a2c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a30:	00000717          	auipc	a4,0x0
 a34:	5ca73823          	sd	a0,1488(a4) # 1000 <freep>
      return (void*)(p + 1);
 a38:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a3c:	70e2                	ld	ra,56(sp)
 a3e:	7442                	ld	s0,48(sp)
 a40:	74a2                	ld	s1,40(sp)
 a42:	7902                	ld	s2,32(sp)
 a44:	69e2                	ld	s3,24(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	6121                	addi	sp,sp,64
 a4e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a50:	6398                	ld	a4,0(a5)
 a52:	e118                	sd	a4,0(a0)
 a54:	bff1                	j	a30 <malloc+0x88>
  hp->s.size = nu;
 a56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5a:	0541                	addi	a0,a0,16
 a5c:	00000097          	auipc	ra,0x0
 a60:	eca080e7          	jalr	-310(ra) # 926 <free>
  return freep;
 a64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a68:	d971                	beqz	a0,a3c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6c:	4798                	lw	a4,8(a5)
 a6e:	fa9775e3          	bgeu	a4,s1,a18 <malloc+0x70>
    if(p == freep)
 a72:	00093703          	ld	a4,0(s2)
 a76:	853e                	mv	a0,a5
 a78:	fef719e3          	bne	a4,a5,a6a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a7c:	8552                	mv	a0,s4
 a7e:	00000097          	auipc	ra,0x0
 a82:	b80080e7          	jalr	-1152(ra) # 5fe <sbrk>
  if(p == (char*)-1)
 a86:	fd5518e3          	bne	a0,s5,a56 <malloc+0xae>
        return 0;
 a8a:	4501                	li	a0,0
 a8c:	bf45                	j	a3c <malloc+0x94>
