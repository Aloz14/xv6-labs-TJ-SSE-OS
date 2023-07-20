
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	31e58593          	addi	a1,a1,798 # 1330 <malloc+0xf4>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	dfe080e7          	jalr	-514(ra) # e1a <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bc0080e7          	jalr	-1088(ra) # bea <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	bfa080e7          	jalr	-1030(ra) # c30 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	2d858593          	addi	a1,a1,728 # 1338 <malloc+0xfc>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	0ec080e7          	jalr	236(ra) # 1156 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	d86080e7          	jalr	-634(ra) # dfa <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d6e080e7          	jalr	-658(ra) # df2 <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	2a650513          	addi	a0,a0,678 # 1340 <malloc+0x104>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	ec26                	sd	s1,24(sp)
      b2:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b4:	c10d                	beqz	a0,d6 <runcmd+0x2c>
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e263          	bltu	a5,a4,e0 <runcmd+0x36>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	37a70713          	addi	a4,a4,890 # 1440 <malloc+0x204>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	d22080e7          	jalr	-734(ra) # dfa <exit>
    panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	26850513          	addi	a0,a0,616 # 1348 <malloc+0x10c>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6e080e7          	jalr	-146(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	addi	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	d3a080e7          	jalr	-710(ra) # e32 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	24e58593          	addi	a1,a1,590 # 1350 <malloc+0x114>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	04a080e7          	jalr	74(ra) # 1156 <fprintf>
  exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	ce4080e7          	jalr	-796(ra) # dfa <exit>
      exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	cda080e7          	jalr	-806(ra) # dfa <exit>
    close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	cf8080e7          	jalr	-776(ra) # e22 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	d04080e7          	jalr	-764(ra) # e3a <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa2>
    runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f66080e7          	jalr	-154(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	21258593          	addi	a1,a1,530 # 1360 <malloc+0x124>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	ffe080e7          	jalr	-2(ra) # 1156 <fprintf>
      exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	c98080e7          	jalr	-872(ra) # dfa <exit>
    if(fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f12080e7          	jalr	-238(ra) # 7c <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd4>
      runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f34080e7          	jalr	-204(ra) # aa <runcmd>
    wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	c82080e7          	jalr	-894(ra) # e02 <wait>
    runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f20080e7          	jalr	-224(ra) # aa <runcmd>
    if(pipe(p) < 0)
     192:	fd840513          	addi	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	c74080e7          	jalr	-908(ra) # e0a <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13a>
    if(fork1() == 0){
     1a2:	00000097          	auipc	ra,0x0
     1a6:	eda080e7          	jalr	-294(ra) # 7c <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14a>
      close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	c74080e7          	jalr	-908(ra) # e22 <close>
      dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	cb8080e7          	jalr	-840(ra) # e72 <dup>
      close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	c5c080e7          	jalr	-932(ra) # e22 <close>
      close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c50080e7          	jalr	-944(ra) # e22 <close>
      runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ece080e7          	jalr	-306(ra) # aa <runcmd>
      panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	18c50513          	addi	a0,a0,396 # 1370 <malloc+0x134>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e6a080e7          	jalr	-406(ra) # 56 <panic>
    if(fork1() == 0){
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e88080e7          	jalr	-376(ra) # 7c <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18a>
      close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	c24080e7          	jalr	-988(ra) # e22 <close>
      dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	c68080e7          	jalr	-920(ra) # e72 <dup>
      close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	c0c080e7          	jalr	-1012(ra) # e22 <close>
      close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	c00080e7          	jalr	-1024(ra) # e22 <close>
      runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7e080e7          	jalr	-386(ra) # aa <runcmd>
    close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	bea080e7          	jalr	-1046(ra) # e22 <close>
    close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	bde080e7          	jalr	-1058(ra) # e22 <close>
    wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	bb4080e7          	jalr	-1100(ra) # e02 <wait>
    wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	baa080e7          	jalr	-1110(ra) # e02 <wait>
    break;
     260:	bd55                	j	114 <runcmd+0x6a>
    if(fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e1a080e7          	jalr	-486(ra) # 7c <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e3a080e7          	jalr	-454(ra) # aa <runcmd>

0000000000000278 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     278:	1101                	addi	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	fb6080e7          	jalr	-74(ra) # 123c <malloc>
     28e:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	954080e7          	jalr	-1708(ra) # bea <memset>
  cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	addi	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	addi	s0,sp,64
     2c2:	8b2a                	mv	s6,a0
     2c4:	8aae                	mv	s5,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	89b6                	mv	s3,a3
     2ca:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	f6c080e7          	jalr	-148(ra) # 123c <malloc>
     2d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	90a080e7          	jalr	-1782(ra) # bea <memset>
  cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ec:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f0:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f8:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fc:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	addi	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	addi	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	addi	s0,sp,48
     324:	89aa                	mv	s3,a0
     326:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	f12080e7          	jalr	-238(ra) # 123c <malloc>
     332:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	8b2080e7          	jalr	-1870(ra) # bea <memset>
  cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     344:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     348:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	addi	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	addi	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	addi	s0,sp,48
     36a:	89aa                	mv	s3,a0
     36c:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	ecc080e7          	jalr	-308(ra) # 123c <malloc>
     378:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	86c080e7          	jalr	-1940(ra) # bea <memset>
  cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38a:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38e:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	addi	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	addi	s0,sp,32
     3ae:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	e8a080e7          	jalr	-374(ra) # 123c <malloc>
     3ba:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	82a080e7          	jalr	-2006(ra) # bea <memset>
  cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	addi	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	addi	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	addi	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fa:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fc:	00002997          	auipc	s3,0x2
     400:	c0c98993          	addi	s3,s3,-1012 # 2008 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00000097          	auipc	ra,0x0
     412:	7fe080e7          	jalr	2046(ra) # c0c <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
    s++;
     418:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
    s++;
     41e:	84ca                	mv	s1,s2
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addiw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76d63          	bltu	a4,a5,4ce <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     458:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
    *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	addi	s3,s3,-1114 # 2008 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00000097          	auipc	ra,0x0
     478:	798080e7          	jalr	1944(ra) # c0c <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
    s++;
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  switch(*s){
     4a0:	03e00713          	li	a4,62
     4a4:	02e79163          	bne	a5,a4,4c6 <gettoken+0xe8>
    s++;
     4a8:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ac:	0014c703          	lbu	a4,1(s1)
     4b0:	03e00793          	li	a5,62
      s++;
     4b4:	0489                	addi	s1,s1,2
      ret = '+';
     4b6:	02b00a93          	li	s5,43
    if(*s == '>'){
     4ba:	faf700e3          	beq	a4,a5,45a <gettoken+0x7c>
    s++;
     4be:	84b6                	mv	s1,a3
  ret = *s;
     4c0:	03e00a93          	li	s5,62
     4c4:	bf59                	j	45a <gettoken+0x7c>
  switch(*s){
     4c6:	07c00713          	li	a4,124
     4ca:	f8e787e3          	beq	a5,a4,458 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ce:	00002997          	auipc	s3,0x2
     4d2:	b3a98993          	addi	s3,s3,-1222 # 2008 <whitespace>
     4d6:	00002a97          	auipc	s5,0x2
     4da:	b2aa8a93          	addi	s5,s5,-1238 # 2000 <symbols>
     4de:	0324f663          	bgeu	s1,s2,50a <gettoken+0x12c>
     4e2:	0004c583          	lbu	a1,0(s1)
     4e6:	854e                	mv	a0,s3
     4e8:	00000097          	auipc	ra,0x0
     4ec:	724080e7          	jalr	1828(ra) # c0c <strchr>
     4f0:	e50d                	bnez	a0,51a <gettoken+0x13c>
     4f2:	0004c583          	lbu	a1,0(s1)
     4f6:	8556                	mv	a0,s5
     4f8:	00000097          	auipc	ra,0x0
     4fc:	714080e7          	jalr	1812(ra) # c0c <strchr>
     500:	e911                	bnez	a0,514 <gettoken+0x136>
      s++;
     502:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     504:	fc991fe3          	bne	s2,s1,4e2 <gettoken+0x104>
      s++;
     508:	84ca                	mv	s1,s2
  if(eq)
     50a:	06100a93          	li	s5,97
     50e:	f40b18e3          	bnez	s6,45e <gettoken+0x80>
     512:	bf95                	j	486 <gettoken+0xa8>
    ret = 'a';
     514:	06100a93          	li	s5,97
     518:	b789                	j	45a <gettoken+0x7c>
     51a:	06100a93          	li	s5,97
     51e:	bf35                	j	45a <gettoken+0x7c>

0000000000000520 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     520:	7139                	addi	sp,sp,-64
     522:	fc06                	sd	ra,56(sp)
     524:	f822                	sd	s0,48(sp)
     526:	f426                	sd	s1,40(sp)
     528:	f04a                	sd	s2,32(sp)
     52a:	ec4e                	sd	s3,24(sp)
     52c:	e852                	sd	s4,16(sp)
     52e:	e456                	sd	s5,8(sp)
     530:	0080                	addi	s0,sp,64
     532:	8a2a                	mv	s4,a0
     534:	892e                	mv	s2,a1
     536:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     538:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     53a:	00002997          	auipc	s3,0x2
     53e:	ace98993          	addi	s3,s3,-1330 # 2008 <whitespace>
     542:	00b4fe63          	bgeu	s1,a1,55e <peek+0x3e>
     546:	0004c583          	lbu	a1,0(s1)
     54a:	854e                	mv	a0,s3
     54c:	00000097          	auipc	ra,0x0
     550:	6c0080e7          	jalr	1728(ra) # c0c <strchr>
     554:	c509                	beqz	a0,55e <peek+0x3e>
    s++;
     556:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     558:	fe9917e3          	bne	s2,s1,546 <peek+0x26>
    s++;
     55c:	84ca                	mv	s1,s2
  *ps = s;
     55e:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     562:	0004c583          	lbu	a1,0(s1)
     566:	4501                	li	a0,0
     568:	e991                	bnez	a1,57c <peek+0x5c>
}
     56a:	70e2                	ld	ra,56(sp)
     56c:	7442                	ld	s0,48(sp)
     56e:	74a2                	ld	s1,40(sp)
     570:	7902                	ld	s2,32(sp)
     572:	69e2                	ld	s3,24(sp)
     574:	6a42                	ld	s4,16(sp)
     576:	6aa2                	ld	s5,8(sp)
     578:	6121                	addi	sp,sp,64
     57a:	8082                	ret
  return *s && strchr(toks, *s);
     57c:	8556                	mv	a0,s5
     57e:	00000097          	auipc	ra,0x0
     582:	68e080e7          	jalr	1678(ra) # c0c <strchr>
     586:	00a03533          	snez	a0,a0
     58a:	b7c5                	j	56a <peek+0x4a>

000000000000058c <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     58c:	7159                	addi	sp,sp,-112
     58e:	f486                	sd	ra,104(sp)
     590:	f0a2                	sd	s0,96(sp)
     592:	eca6                	sd	s1,88(sp)
     594:	e8ca                	sd	s2,80(sp)
     596:	e4ce                	sd	s3,72(sp)
     598:	e0d2                	sd	s4,64(sp)
     59a:	fc56                	sd	s5,56(sp)
     59c:	f85a                	sd	s6,48(sp)
     59e:	f45e                	sd	s7,40(sp)
     5a0:	f062                	sd	s8,32(sp)
     5a2:	ec66                	sd	s9,24(sp)
     5a4:	1880                	addi	s0,sp,112
     5a6:	8a2a                	mv	s4,a0
     5a8:	89ae                	mv	s3,a1
     5aa:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5ac:	00001b97          	auipc	s7,0x1
     5b0:	decb8b93          	addi	s7,s7,-532 # 1398 <malloc+0x15c>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5b4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5b8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5bc:	a02d                	j	5e6 <parseredirs+0x5a>
      panic("missing file for redirection");
     5be:	00001517          	auipc	a0,0x1
     5c2:	dba50513          	addi	a0,a0,-582 # 1378 <malloc+0x13c>
     5c6:	00000097          	auipc	ra,0x0
     5ca:	a90080e7          	jalr	-1392(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5ce:	4701                	li	a4,0
     5d0:	4681                	li	a3,0
     5d2:	f9043603          	ld	a2,-112(s0)
     5d6:	f9843583          	ld	a1,-104(s0)
     5da:	8552                	mv	a0,s4
     5dc:	00000097          	auipc	ra,0x0
     5e0:	cd2080e7          	jalr	-814(ra) # 2ae <redircmd>
     5e4:	8a2a                	mv	s4,a0
    switch(tok){
     5e6:	03e00b13          	li	s6,62
     5ea:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5ee:	865e                	mv	a2,s7
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f2c080e7          	jalr	-212(ra) # 520 <peek>
     5fc:	c925                	beqz	a0,66c <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dd8080e7          	jalr	-552(ra) # 3de <gettoken>
     60e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     610:	f9040693          	addi	a3,s0,-112
     614:	f9840613          	addi	a2,s0,-104
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc2080e7          	jalr	-574(ra) # 3de <gettoken>
     624:	f9851de3          	bne	a0,s8,5be <parseredirs+0x32>
    switch(tok){
     628:	fb9483e3          	beq	s1,s9,5ce <parseredirs+0x42>
     62c:	03648263          	beq	s1,s6,650 <parseredirs+0xc4>
     630:	fb549fe3          	bne	s1,s5,5ee <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     634:	4705                	li	a4,1
     636:	20100693          	li	a3,513
     63a:	f9043603          	ld	a2,-112(s0)
     63e:	f9843583          	ld	a1,-104(s0)
     642:	8552                	mv	a0,s4
     644:	00000097          	auipc	ra,0x0
     648:	c6a080e7          	jalr	-918(ra) # 2ae <redircmd>
     64c:	8a2a                	mv	s4,a0
      break;
     64e:	bf61                	j	5e6 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     650:	4705                	li	a4,1
     652:	60100693          	li	a3,1537
     656:	f9043603          	ld	a2,-112(s0)
     65a:	f9843583          	ld	a1,-104(s0)
     65e:	8552                	mv	a0,s4
     660:	00000097          	auipc	ra,0x0
     664:	c4e080e7          	jalr	-946(ra) # 2ae <redircmd>
     668:	8a2a                	mv	s4,a0
      break;
     66a:	bfb5                	j	5e6 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     66c:	8552                	mv	a0,s4
     66e:	70a6                	ld	ra,104(sp)
     670:	7406                	ld	s0,96(sp)
     672:	64e6                	ld	s1,88(sp)
     674:	6946                	ld	s2,80(sp)
     676:	69a6                	ld	s3,72(sp)
     678:	6a06                	ld	s4,64(sp)
     67a:	7ae2                	ld	s5,56(sp)
     67c:	7b42                	ld	s6,48(sp)
     67e:	7ba2                	ld	s7,40(sp)
     680:	7c02                	ld	s8,32(sp)
     682:	6ce2                	ld	s9,24(sp)
     684:	6165                	addi	sp,sp,112
     686:	8082                	ret

0000000000000688 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     688:	7159                	addi	sp,sp,-112
     68a:	f486                	sd	ra,104(sp)
     68c:	f0a2                	sd	s0,96(sp)
     68e:	eca6                	sd	s1,88(sp)
     690:	e8ca                	sd	s2,80(sp)
     692:	e4ce                	sd	s3,72(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	f85a                	sd	s6,48(sp)
     69a:	f45e                	sd	s7,40(sp)
     69c:	f062                	sd	s8,32(sp)
     69e:	ec66                	sd	s9,24(sp)
     6a0:	1880                	addi	s0,sp,112
     6a2:	8a2a                	mv	s4,a0
     6a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6a6:	00001617          	auipc	a2,0x1
     6aa:	cfa60613          	addi	a2,a2,-774 # 13a0 <malloc+0x164>
     6ae:	00000097          	auipc	ra,0x0
     6b2:	e72080e7          	jalr	-398(ra) # 520 <peek>
     6b6:	e905                	bnez	a0,6e6 <parseexec+0x5e>
     6b8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6ba:	00000097          	auipc	ra,0x0
     6be:	bbe080e7          	jalr	-1090(ra) # 278 <execcmd>
     6c2:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c4:	8656                	mv	a2,s5
     6c6:	85d2                	mv	a1,s4
     6c8:	00000097          	auipc	ra,0x0
     6cc:	ec4080e7          	jalr	-316(ra) # 58c <parseredirs>
     6d0:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d2:	008c0913          	addi	s2,s8,8
     6d6:	00001b17          	auipc	s6,0x1
     6da:	ceab0b13          	addi	s6,s6,-790 # 13c0 <malloc+0x184>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6de:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e2:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e4:	a0b1                	j	730 <parseexec+0xa8>
    return parseblock(ps, es);
     6e6:	85d6                	mv	a1,s5
     6e8:	8552                	mv	a0,s4
     6ea:	00000097          	auipc	ra,0x0
     6ee:	1bc080e7          	jalr	444(ra) # 8a6 <parseblock>
     6f2:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f4:	8526                	mv	a0,s1
     6f6:	70a6                	ld	ra,104(sp)
     6f8:	7406                	ld	s0,96(sp)
     6fa:	64e6                	ld	s1,88(sp)
     6fc:	6946                	ld	s2,80(sp)
     6fe:	69a6                	ld	s3,72(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	7b42                	ld	s6,48(sp)
     706:	7ba2                	ld	s7,40(sp)
     708:	7c02                	ld	s8,32(sp)
     70a:	6ce2                	ld	s9,24(sp)
     70c:	6165                	addi	sp,sp,112
     70e:	8082                	ret
      panic("syntax");
     710:	00001517          	auipc	a0,0x1
     714:	c9850513          	addi	a0,a0,-872 # 13a8 <malloc+0x16c>
     718:	00000097          	auipc	ra,0x0
     71c:	93e080e7          	jalr	-1730(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     720:	8656                	mv	a2,s5
     722:	85d2                	mv	a1,s4
     724:	8526                	mv	a0,s1
     726:	00000097          	auipc	ra,0x0
     72a:	e66080e7          	jalr	-410(ra) # 58c <parseredirs>
     72e:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     730:	865a                	mv	a2,s6
     732:	85d6                	mv	a1,s5
     734:	8552                	mv	a0,s4
     736:	00000097          	auipc	ra,0x0
     73a:	dea080e7          	jalr	-534(ra) # 520 <peek>
     73e:	e131                	bnez	a0,782 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     740:	f9040693          	addi	a3,s0,-112
     744:	f9840613          	addi	a2,s0,-104
     748:	85d6                	mv	a1,s5
     74a:	8552                	mv	a0,s4
     74c:	00000097          	auipc	ra,0x0
     750:	c92080e7          	jalr	-878(ra) # 3de <gettoken>
     754:	c51d                	beqz	a0,782 <parseexec+0xfa>
    if(tok != 'a')
     756:	fb951de3          	bne	a0,s9,710 <parseexec+0x88>
    cmd->argv[argc] = q;
     75a:	f9843783          	ld	a5,-104(s0)
     75e:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     762:	f9043783          	ld	a5,-112(s0)
     766:	04f93823          	sd	a5,80(s2)
    argc++;
     76a:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     76c:	0921                	addi	s2,s2,8
     76e:	fb7999e3          	bne	s3,s7,720 <parseexec+0x98>
      panic("too many args");
     772:	00001517          	auipc	a0,0x1
     776:	c3e50513          	addi	a0,a0,-962 # 13b0 <malloc+0x174>
     77a:	00000097          	auipc	ra,0x0
     77e:	8dc080e7          	jalr	-1828(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     782:	098e                	slli	s3,s3,0x3
     784:	9c4e                	add	s8,s8,s3
     786:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     78a:	040c3c23          	sd	zero,88(s8)
  return ret;
     78e:	b79d                	j	6f4 <parseexec+0x6c>

0000000000000790 <parsepipe>:
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	e84a                	sd	s2,16(sp)
     79a:	e44e                	sd	s3,8(sp)
     79c:	1800                	addi	s0,sp,48
     79e:	892a                	mv	s2,a0
     7a0:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a2:	00000097          	auipc	ra,0x0
     7a6:	ee6080e7          	jalr	-282(ra) # 688 <parseexec>
     7aa:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7ac:	00001617          	auipc	a2,0x1
     7b0:	c1c60613          	addi	a2,a2,-996 # 13c8 <malloc+0x18c>
     7b4:	85ce                	mv	a1,s3
     7b6:	854a                	mv	a0,s2
     7b8:	00000097          	auipc	ra,0x0
     7bc:	d68080e7          	jalr	-664(ra) # 520 <peek>
     7c0:	e909                	bnez	a0,7d2 <parsepipe+0x42>
}
     7c2:	8526                	mv	a0,s1
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d2:	4681                	li	a3,0
     7d4:	4601                	li	a2,0
     7d6:	85ce                	mv	a1,s3
     7d8:	854a                	mv	a0,s2
     7da:	00000097          	auipc	ra,0x0
     7de:	c04080e7          	jalr	-1020(ra) # 3de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e2:	85ce                	mv	a1,s3
     7e4:	854a                	mv	a0,s2
     7e6:	00000097          	auipc	ra,0x0
     7ea:	faa080e7          	jalr	-86(ra) # 790 <parsepipe>
     7ee:	85aa                	mv	a1,a0
     7f0:	8526                	mv	a0,s1
     7f2:	00000097          	auipc	ra,0x0
     7f6:	b24080e7          	jalr	-1244(ra) # 316 <pipecmd>
     7fa:	84aa                	mv	s1,a0
  return cmd;
     7fc:	b7d9                	j	7c2 <parsepipe+0x32>

00000000000007fe <parseline>:
{
     7fe:	7179                	addi	sp,sp,-48
     800:	f406                	sd	ra,40(sp)
     802:	f022                	sd	s0,32(sp)
     804:	ec26                	sd	s1,24(sp)
     806:	e84a                	sd	s2,16(sp)
     808:	e44e                	sd	s3,8(sp)
     80a:	e052                	sd	s4,0(sp)
     80c:	1800                	addi	s0,sp,48
     80e:	892a                	mv	s2,a0
     810:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     812:	00000097          	auipc	ra,0x0
     816:	f7e080e7          	jalr	-130(ra) # 790 <parsepipe>
     81a:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     81c:	00001a17          	auipc	s4,0x1
     820:	bb4a0a13          	addi	s4,s4,-1100 # 13d0 <malloc+0x194>
     824:	a839                	j	842 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     826:	4681                	li	a3,0
     828:	4601                	li	a2,0
     82a:	85ce                	mv	a1,s3
     82c:	854a                	mv	a0,s2
     82e:	00000097          	auipc	ra,0x0
     832:	bb0080e7          	jalr	-1104(ra) # 3de <gettoken>
    cmd = backcmd(cmd);
     836:	8526                	mv	a0,s1
     838:	00000097          	auipc	ra,0x0
     83c:	b6a080e7          	jalr	-1174(ra) # 3a2 <backcmd>
     840:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     842:	8652                	mv	a2,s4
     844:	85ce                	mv	a1,s3
     846:	854a                	mv	a0,s2
     848:	00000097          	auipc	ra,0x0
     84c:	cd8080e7          	jalr	-808(ra) # 520 <peek>
     850:	f979                	bnez	a0,826 <parseline+0x28>
  if(peek(ps, es, ";")){
     852:	00001617          	auipc	a2,0x1
     856:	b8660613          	addi	a2,a2,-1146 # 13d8 <malloc+0x19c>
     85a:	85ce                	mv	a1,s3
     85c:	854a                	mv	a0,s2
     85e:	00000097          	auipc	ra,0x0
     862:	cc2080e7          	jalr	-830(ra) # 520 <peek>
     866:	e911                	bnez	a0,87a <parseline+0x7c>
}
     868:	8526                	mv	a0,s1
     86a:	70a2                	ld	ra,40(sp)
     86c:	7402                	ld	s0,32(sp)
     86e:	64e2                	ld	s1,24(sp)
     870:	6942                	ld	s2,16(sp)
     872:	69a2                	ld	s3,8(sp)
     874:	6a02                	ld	s4,0(sp)
     876:	6145                	addi	sp,sp,48
     878:	8082                	ret
    gettoken(ps, es, 0, 0);
     87a:	4681                	li	a3,0
     87c:	4601                	li	a2,0
     87e:	85ce                	mv	a1,s3
     880:	854a                	mv	a0,s2
     882:	00000097          	auipc	ra,0x0
     886:	b5c080e7          	jalr	-1188(ra) # 3de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     88a:	85ce                	mv	a1,s3
     88c:	854a                	mv	a0,s2
     88e:	00000097          	auipc	ra,0x0
     892:	f70080e7          	jalr	-144(ra) # 7fe <parseline>
     896:	85aa                	mv	a1,a0
     898:	8526                	mv	a0,s1
     89a:	00000097          	auipc	ra,0x0
     89e:	ac2080e7          	jalr	-1342(ra) # 35c <listcmd>
     8a2:	84aa                	mv	s1,a0
  return cmd;
     8a4:	b7d1                	j	868 <parseline+0x6a>

00000000000008a6 <parseblock>:
{
     8a6:	7179                	addi	sp,sp,-48
     8a8:	f406                	sd	ra,40(sp)
     8aa:	f022                	sd	s0,32(sp)
     8ac:	ec26                	sd	s1,24(sp)
     8ae:	e84a                	sd	s2,16(sp)
     8b0:	e44e                	sd	s3,8(sp)
     8b2:	1800                	addi	s0,sp,48
     8b4:	84aa                	mv	s1,a0
     8b6:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8b8:	00001617          	auipc	a2,0x1
     8bc:	ae860613          	addi	a2,a2,-1304 # 13a0 <malloc+0x164>
     8c0:	00000097          	auipc	ra,0x0
     8c4:	c60080e7          	jalr	-928(ra) # 520 <peek>
     8c8:	c12d                	beqz	a0,92a <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8ca:	4681                	li	a3,0
     8cc:	4601                	li	a2,0
     8ce:	85ca                	mv	a1,s2
     8d0:	8526                	mv	a0,s1
     8d2:	00000097          	auipc	ra,0x0
     8d6:	b0c080e7          	jalr	-1268(ra) # 3de <gettoken>
  cmd = parseline(ps, es);
     8da:	85ca                	mv	a1,s2
     8dc:	8526                	mv	a0,s1
     8de:	00000097          	auipc	ra,0x0
     8e2:	f20080e7          	jalr	-224(ra) # 7fe <parseline>
     8e6:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8e8:	00001617          	auipc	a2,0x1
     8ec:	b0860613          	addi	a2,a2,-1272 # 13f0 <malloc+0x1b4>
     8f0:	85ca                	mv	a1,s2
     8f2:	8526                	mv	a0,s1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	c2c080e7          	jalr	-980(ra) # 520 <peek>
     8fc:	cd1d                	beqz	a0,93a <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8fe:	4681                	li	a3,0
     900:	4601                	li	a2,0
     902:	85ca                	mv	a1,s2
     904:	8526                	mv	a0,s1
     906:	00000097          	auipc	ra,0x0
     90a:	ad8080e7          	jalr	-1320(ra) # 3de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     90e:	864a                	mv	a2,s2
     910:	85a6                	mv	a1,s1
     912:	854e                	mv	a0,s3
     914:	00000097          	auipc	ra,0x0
     918:	c78080e7          	jalr	-904(ra) # 58c <parseredirs>
}
     91c:	70a2                	ld	ra,40(sp)
     91e:	7402                	ld	s0,32(sp)
     920:	64e2                	ld	s1,24(sp)
     922:	6942                	ld	s2,16(sp)
     924:	69a2                	ld	s3,8(sp)
     926:	6145                	addi	sp,sp,48
     928:	8082                	ret
    panic("parseblock");
     92a:	00001517          	auipc	a0,0x1
     92e:	ab650513          	addi	a0,a0,-1354 # 13e0 <malloc+0x1a4>
     932:	fffff097          	auipc	ra,0xfffff
     936:	724080e7          	jalr	1828(ra) # 56 <panic>
    panic("syntax - missing )");
     93a:	00001517          	auipc	a0,0x1
     93e:	abe50513          	addi	a0,a0,-1346 # 13f8 <malloc+0x1bc>
     942:	fffff097          	auipc	ra,0xfffff
     946:	714080e7          	jalr	1812(ra) # 56 <panic>

000000000000094a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     94a:	1101                	addi	sp,sp,-32
     94c:	ec06                	sd	ra,24(sp)
     94e:	e822                	sd	s0,16(sp)
     950:	e426                	sd	s1,8(sp)
     952:	1000                	addi	s0,sp,32
     954:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     956:	c521                	beqz	a0,99e <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     958:	4118                	lw	a4,0(a0)
     95a:	4795                	li	a5,5
     95c:	04e7e163          	bltu	a5,a4,99e <nulterminate+0x54>
     960:	00056783          	lwu	a5,0(a0)
     964:	078a                	slli	a5,a5,0x2
     966:	00001717          	auipc	a4,0x1
     96a:	af270713          	addi	a4,a4,-1294 # 1458 <malloc+0x21c>
     96e:	97ba                	add	a5,a5,a4
     970:	439c                	lw	a5,0(a5)
     972:	97ba                	add	a5,a5,a4
     974:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     976:	651c                	ld	a5,8(a0)
     978:	c39d                	beqz	a5,99e <nulterminate+0x54>
     97a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     97e:	67b8                	ld	a4,72(a5)
     980:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     984:	07a1                	addi	a5,a5,8
     986:	ff87b703          	ld	a4,-8(a5)
     98a:	fb75                	bnez	a4,97e <nulterminate+0x34>
     98c:	a809                	j	99e <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     98e:	6508                	ld	a0,8(a0)
     990:	00000097          	auipc	ra,0x0
     994:	fba080e7          	jalr	-70(ra) # 94a <nulterminate>
    *rcmd->efile = 0;
     998:	6c9c                	ld	a5,24(s1)
     99a:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     99e:	8526                	mv	a0,s1
     9a0:	60e2                	ld	ra,24(sp)
     9a2:	6442                	ld	s0,16(sp)
     9a4:	64a2                	ld	s1,8(sp)
     9a6:	6105                	addi	sp,sp,32
     9a8:	8082                	ret
    nulterminate(pcmd->left);
     9aa:	6508                	ld	a0,8(a0)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	f9e080e7          	jalr	-98(ra) # 94a <nulterminate>
    nulterminate(pcmd->right);
     9b4:	6888                	ld	a0,16(s1)
     9b6:	00000097          	auipc	ra,0x0
     9ba:	f94080e7          	jalr	-108(ra) # 94a <nulterminate>
    break;
     9be:	b7c5                	j	99e <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c0:	6508                	ld	a0,8(a0)
     9c2:	00000097          	auipc	ra,0x0
     9c6:	f88080e7          	jalr	-120(ra) # 94a <nulterminate>
    nulterminate(lcmd->right);
     9ca:	6888                	ld	a0,16(s1)
     9cc:	00000097          	auipc	ra,0x0
     9d0:	f7e080e7          	jalr	-130(ra) # 94a <nulterminate>
    break;
     9d4:	b7e9                	j	99e <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9d6:	6508                	ld	a0,8(a0)
     9d8:	00000097          	auipc	ra,0x0
     9dc:	f72080e7          	jalr	-142(ra) # 94a <nulterminate>
    break;
     9e0:	bf7d                	j	99e <nulterminate+0x54>

00000000000009e2 <parsecmd>:
{
     9e2:	7179                	addi	sp,sp,-48
     9e4:	f406                	sd	ra,40(sp)
     9e6:	f022                	sd	s0,32(sp)
     9e8:	ec26                	sd	s1,24(sp)
     9ea:	e84a                	sd	s2,16(sp)
     9ec:	1800                	addi	s0,sp,48
     9ee:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f2:	84aa                	mv	s1,a0
     9f4:	00000097          	auipc	ra,0x0
     9f8:	1cc080e7          	jalr	460(ra) # bc0 <strlen>
     9fc:	1502                	slli	a0,a0,0x20
     9fe:	9101                	srli	a0,a0,0x20
     a00:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a02:	85a6                	mv	a1,s1
     a04:	fd840513          	addi	a0,s0,-40
     a08:	00000097          	auipc	ra,0x0
     a0c:	df6080e7          	jalr	-522(ra) # 7fe <parseline>
     a10:	892a                	mv	s2,a0
  peek(&s, es, "");
     a12:	00001617          	auipc	a2,0x1
     a16:	9fe60613          	addi	a2,a2,-1538 # 1410 <malloc+0x1d4>
     a1a:	85a6                	mv	a1,s1
     a1c:	fd840513          	addi	a0,s0,-40
     a20:	00000097          	auipc	ra,0x0
     a24:	b00080e7          	jalr	-1280(ra) # 520 <peek>
  if(s != es){
     a28:	fd843603          	ld	a2,-40(s0)
     a2c:	00961e63          	bne	a2,s1,a48 <parsecmd+0x66>
  nulterminate(cmd);
     a30:	854a                	mv	a0,s2
     a32:	00000097          	auipc	ra,0x0
     a36:	f18080e7          	jalr	-232(ra) # 94a <nulterminate>
}
     a3a:	854a                	mv	a0,s2
     a3c:	70a2                	ld	ra,40(sp)
     a3e:	7402                	ld	s0,32(sp)
     a40:	64e2                	ld	s1,24(sp)
     a42:	6942                	ld	s2,16(sp)
     a44:	6145                	addi	sp,sp,48
     a46:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a48:	00001597          	auipc	a1,0x1
     a4c:	9d058593          	addi	a1,a1,-1584 # 1418 <malloc+0x1dc>
     a50:	4509                	li	a0,2
     a52:	00000097          	auipc	ra,0x0
     a56:	704080e7          	jalr	1796(ra) # 1156 <fprintf>
    panic("syntax");
     a5a:	00001517          	auipc	a0,0x1
     a5e:	94e50513          	addi	a0,a0,-1714 # 13a8 <malloc+0x16c>
     a62:	fffff097          	auipc	ra,0xfffff
     a66:	5f4080e7          	jalr	1524(ra) # 56 <panic>

0000000000000a6a <main>:
{
     a6a:	7139                	addi	sp,sp,-64
     a6c:	fc06                	sd	ra,56(sp)
     a6e:	f822                	sd	s0,48(sp)
     a70:	f426                	sd	s1,40(sp)
     a72:	f04a                	sd	s2,32(sp)
     a74:	ec4e                	sd	s3,24(sp)
     a76:	e852                	sd	s4,16(sp)
     a78:	e456                	sd	s5,8(sp)
     a7a:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a7c:	00001497          	auipc	s1,0x1
     a80:	9ac48493          	addi	s1,s1,-1620 # 1428 <malloc+0x1ec>
     a84:	4589                	li	a1,2
     a86:	8526                	mv	a0,s1
     a88:	00000097          	auipc	ra,0x0
     a8c:	3b2080e7          	jalr	946(ra) # e3a <open>
     a90:	00054963          	bltz	a0,aa2 <main+0x38>
    if(fd >= 3){
     a94:	4789                	li	a5,2
     a96:	fea7d7e3          	bge	a5,a0,a84 <main+0x1a>
      close(fd);
     a9a:	00000097          	auipc	ra,0x0
     a9e:	388080e7          	jalr	904(ra) # e22 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa2:	00001497          	auipc	s1,0x1
     aa6:	57e48493          	addi	s1,s1,1406 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aaa:	06300913          	li	s2,99
     aae:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     ab2:	00001a17          	auipc	s4,0x1
     ab6:	571a0a13          	addi	s4,s4,1393 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     aba:	00001a97          	auipc	s5,0x1
     abe:	976a8a93          	addi	s5,s5,-1674 # 1430 <malloc+0x1f4>
     ac2:	a819                	j	ad8 <main+0x6e>
    if(fork1() == 0)
     ac4:	fffff097          	auipc	ra,0xfffff
     ac8:	5b8080e7          	jalr	1464(ra) # 7c <fork1>
     acc:	c925                	beqz	a0,b3c <main+0xd2>
    wait(0);
     ace:	4501                	li	a0,0
     ad0:	00000097          	auipc	ra,0x0
     ad4:	332080e7          	jalr	818(ra) # e02 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ad8:	06400593          	li	a1,100
     adc:	8526                	mv	a0,s1
     ade:	fffff097          	auipc	ra,0xfffff
     ae2:	522080e7          	jalr	1314(ra) # 0 <getcmd>
     ae6:	06054763          	bltz	a0,b54 <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aea:	0004c783          	lbu	a5,0(s1)
     aee:	fd279be3          	bne	a5,s2,ac4 <main+0x5a>
     af2:	0014c703          	lbu	a4,1(s1)
     af6:	06400793          	li	a5,100
     afa:	fcf715e3          	bne	a4,a5,ac4 <main+0x5a>
     afe:	0024c783          	lbu	a5,2(s1)
     b02:	fd3791e3          	bne	a5,s3,ac4 <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     b06:	8526                	mv	a0,s1
     b08:	00000097          	auipc	ra,0x0
     b0c:	0b8080e7          	jalr	184(ra) # bc0 <strlen>
     b10:	fff5079b          	addiw	a5,a0,-1
     b14:	1782                	slli	a5,a5,0x20
     b16:	9381                	srli	a5,a5,0x20
     b18:	97a6                	add	a5,a5,s1
     b1a:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b1e:	8552                	mv	a0,s4
     b20:	00000097          	auipc	ra,0x0
     b24:	34a080e7          	jalr	842(ra) # e6a <chdir>
     b28:	fa0558e3          	bgez	a0,ad8 <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2c:	8652                	mv	a2,s4
     b2e:	85d6                	mv	a1,s5
     b30:	4509                	li	a0,2
     b32:	00000097          	auipc	ra,0x0
     b36:	624080e7          	jalr	1572(ra) # 1156 <fprintf>
     b3a:	bf79                	j	ad8 <main+0x6e>
      runcmd(parsecmd(buf));
     b3c:	00001517          	auipc	a0,0x1
     b40:	4e450513          	addi	a0,a0,1252 # 2020 <buf.0>
     b44:	00000097          	auipc	ra,0x0
     b48:	e9e080e7          	jalr	-354(ra) # 9e2 <parsecmd>
     b4c:	fffff097          	auipc	ra,0xfffff
     b50:	55e080e7          	jalr	1374(ra) # aa <runcmd>
  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	2a4080e7          	jalr	676(ra) # dfa <exit>

0000000000000b5e <_main>:

//
// wrapper so that it's OK if main() does not call exit().
//
void _main()
{
     b5e:	1141                	addi	sp,sp,-16
     b60:	e406                	sd	ra,8(sp)
     b62:	e022                	sd	s0,0(sp)
     b64:	0800                	addi	s0,sp,16
    extern int main();
    main();
     b66:	00000097          	auipc	ra,0x0
     b6a:	f04080e7          	jalr	-252(ra) # a6a <main>
    exit(0);
     b6e:	4501                	li	a0,0
     b70:	00000097          	auipc	ra,0x0
     b74:	28a080e7          	jalr	650(ra) # dfa <exit>

0000000000000b78 <strcpy>:
}

char *strcpy(char *s, const char *t)
{
     b78:	1141                	addi	sp,sp,-16
     b7a:	e422                	sd	s0,8(sp)
     b7c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     b7e:	87aa                	mv	a5,a0
     b80:	0585                	addi	a1,a1,1
     b82:	0785                	addi	a5,a5,1
     b84:	fff5c703          	lbu	a4,-1(a1)
     b88:	fee78fa3          	sb	a4,-1(a5)
     b8c:	fb75                	bnez	a4,b80 <strcpy+0x8>
        ;
    return os;
}
     b8e:	6422                	ld	s0,8(sp)
     b90:	0141                	addi	sp,sp,16
     b92:	8082                	ret

0000000000000b94 <strcmp>:

int strcmp(const char *p, const char *q)
{
     b94:	1141                	addi	sp,sp,-16
     b96:	e422                	sd	s0,8(sp)
     b98:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     b9a:	00054783          	lbu	a5,0(a0)
     b9e:	cb91                	beqz	a5,bb2 <strcmp+0x1e>
     ba0:	0005c703          	lbu	a4,0(a1)
     ba4:	00f71763          	bne	a4,a5,bb2 <strcmp+0x1e>
        p++, q++;
     ba8:	0505                	addi	a0,a0,1
     baa:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     bac:	00054783          	lbu	a5,0(a0)
     bb0:	fbe5                	bnez	a5,ba0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
     bb2:	0005c503          	lbu	a0,0(a1)
}
     bb6:	40a7853b          	subw	a0,a5,a0
     bba:	6422                	ld	s0,8(sp)
     bbc:	0141                	addi	sp,sp,16
     bbe:	8082                	ret

0000000000000bc0 <strlen>:

uint strlen(const char *s)
{
     bc0:	1141                	addi	sp,sp,-16
     bc2:	e422                	sd	s0,8(sp)
     bc4:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     bc6:	00054783          	lbu	a5,0(a0)
     bca:	cf91                	beqz	a5,be6 <strlen+0x26>
     bcc:	0505                	addi	a0,a0,1
     bce:	87aa                	mv	a5,a0
     bd0:	4685                	li	a3,1
     bd2:	9e89                	subw	a3,a3,a0
     bd4:	00f6853b          	addw	a0,a3,a5
     bd8:	0785                	addi	a5,a5,1
     bda:	fff7c703          	lbu	a4,-1(a5)
     bde:	fb7d                	bnez	a4,bd4 <strlen+0x14>
        ;
    return n;
}
     be0:	6422                	ld	s0,8(sp)
     be2:	0141                	addi	sp,sp,16
     be4:	8082                	ret
    for (n = 0; s[n]; n++)
     be6:	4501                	li	a0,0
     be8:	bfe5                	j	be0 <strlen+0x20>

0000000000000bea <memset>:

void *memset(void *dst, int c, uint n)
{
     bea:	1141                	addi	sp,sp,-16
     bec:	e422                	sd	s0,8(sp)
     bee:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++) {
     bf0:	ca19                	beqz	a2,c06 <memset+0x1c>
     bf2:	87aa                	mv	a5,a0
     bf4:	1602                	slli	a2,a2,0x20
     bf6:	9201                	srli	a2,a2,0x20
     bf8:	00a60733          	add	a4,a2,a0
        cdst[i] = c;
     bfc:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
     c00:	0785                	addi	a5,a5,1
     c02:	fee79de3          	bne	a5,a4,bfc <memset+0x12>
    }
    return dst;
}
     c06:	6422                	ld	s0,8(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret

0000000000000c0c <strchr>:

char *strchr(const char *s, char c)
{
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e422                	sd	s0,8(sp)
     c10:	0800                	addi	s0,sp,16
    for (; *s; s++)
     c12:	00054783          	lbu	a5,0(a0)
     c16:	cb99                	beqz	a5,c2c <strchr+0x20>
        if (*s == c)
     c18:	00f58763          	beq	a1,a5,c26 <strchr+0x1a>
    for (; *s; s++)
     c1c:	0505                	addi	a0,a0,1
     c1e:	00054783          	lbu	a5,0(a0)
     c22:	fbfd                	bnez	a5,c18 <strchr+0xc>
            return (char *)s;
    return 0;
     c24:	4501                	li	a0,0
}
     c26:	6422                	ld	s0,8(sp)
     c28:	0141                	addi	sp,sp,16
     c2a:	8082                	ret
    return 0;
     c2c:	4501                	li	a0,0
     c2e:	bfe5                	j	c26 <strchr+0x1a>

0000000000000c30 <gets>:

char *gets(char *buf, int max)
{
     c30:	711d                	addi	sp,sp,-96
     c32:	ec86                	sd	ra,88(sp)
     c34:	e8a2                	sd	s0,80(sp)
     c36:	e4a6                	sd	s1,72(sp)
     c38:	e0ca                	sd	s2,64(sp)
     c3a:	fc4e                	sd	s3,56(sp)
     c3c:	f852                	sd	s4,48(sp)
     c3e:	f456                	sd	s5,40(sp)
     c40:	f05a                	sd	s6,32(sp)
     c42:	ec5e                	sd	s7,24(sp)
     c44:	1080                	addi	s0,sp,96
     c46:	8baa                	mv	s7,a0
     c48:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
     c4a:	892a                	mv	s2,a0
     c4c:	4481                	li	s1,0
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
     c4e:	4aa9                	li	s5,10
     c50:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;) {
     c52:	89a6                	mv	s3,s1
     c54:	2485                	addiw	s1,s1,1
     c56:	0344d863          	bge	s1,s4,c86 <gets+0x56>
        cc = read(0, &c, 1);
     c5a:	4605                	li	a2,1
     c5c:	faf40593          	addi	a1,s0,-81
     c60:	4501                	li	a0,0
     c62:	00000097          	auipc	ra,0x0
     c66:	1b0080e7          	jalr	432(ra) # e12 <read>
        if (cc < 1)
     c6a:	00a05e63          	blez	a0,c86 <gets+0x56>
        buf[i++] = c;
     c6e:	faf44783          	lbu	a5,-81(s0)
     c72:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     c76:	01578763          	beq	a5,s5,c84 <gets+0x54>
     c7a:	0905                	addi	s2,s2,1
     c7c:	fd679be3          	bne	a5,s6,c52 <gets+0x22>
    for (i = 0; i + 1 < max;) {
     c80:	89a6                	mv	s3,s1
     c82:	a011                	j	c86 <gets+0x56>
     c84:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
     c86:	99de                	add	s3,s3,s7
     c88:	00098023          	sb	zero,0(s3)
    return buf;
}
     c8c:	855e                	mv	a0,s7
     c8e:	60e6                	ld	ra,88(sp)
     c90:	6446                	ld	s0,80(sp)
     c92:	64a6                	ld	s1,72(sp)
     c94:	6906                	ld	s2,64(sp)
     c96:	79e2                	ld	s3,56(sp)
     c98:	7a42                	ld	s4,48(sp)
     c9a:	7aa2                	ld	s5,40(sp)
     c9c:	7b02                	ld	s6,32(sp)
     c9e:	6be2                	ld	s7,24(sp)
     ca0:	6125                	addi	sp,sp,96
     ca2:	8082                	ret

0000000000000ca4 <stat>:

int stat(const char *n, struct stat *st)
{
     ca4:	1101                	addi	sp,sp,-32
     ca6:	ec06                	sd	ra,24(sp)
     ca8:	e822                	sd	s0,16(sp)
     caa:	e426                	sd	s1,8(sp)
     cac:	e04a                	sd	s2,0(sp)
     cae:	1000                	addi	s0,sp,32
     cb0:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     cb2:	4581                	li	a1,0
     cb4:	00000097          	auipc	ra,0x0
     cb8:	186080e7          	jalr	390(ra) # e3a <open>
    if (fd < 0)
     cbc:	02054563          	bltz	a0,ce6 <stat+0x42>
     cc0:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     cc2:	85ca                	mv	a1,s2
     cc4:	00000097          	auipc	ra,0x0
     cc8:	18e080e7          	jalr	398(ra) # e52 <fstat>
     ccc:	892a                	mv	s2,a0
    close(fd);
     cce:	8526                	mv	a0,s1
     cd0:	00000097          	auipc	ra,0x0
     cd4:	152080e7          	jalr	338(ra) # e22 <close>
    return r;
}
     cd8:	854a                	mv	a0,s2
     cda:	60e2                	ld	ra,24(sp)
     cdc:	6442                	ld	s0,16(sp)
     cde:	64a2                	ld	s1,8(sp)
     ce0:	6902                	ld	s2,0(sp)
     ce2:	6105                	addi	sp,sp,32
     ce4:	8082                	ret
        return -1;
     ce6:	597d                	li	s2,-1
     ce8:	bfc5                	j	cd8 <stat+0x34>

0000000000000cea <atoi>:

int atoi(const char *s)
{
     cea:	1141                	addi	sp,sp,-16
     cec:	e422                	sd	s0,8(sp)
     cee:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     cf0:	00054683          	lbu	a3,0(a0)
     cf4:	fd06879b          	addiw	a5,a3,-48
     cf8:	0ff7f793          	zext.b	a5,a5
     cfc:	4625                	li	a2,9
     cfe:	02f66863          	bltu	a2,a5,d2e <atoi+0x44>
     d02:	872a                	mv	a4,a0
    n = 0;
     d04:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     d06:	0705                	addi	a4,a4,1
     d08:	0025179b          	slliw	a5,a0,0x2
     d0c:	9fa9                	addw	a5,a5,a0
     d0e:	0017979b          	slliw	a5,a5,0x1
     d12:	9fb5                	addw	a5,a5,a3
     d14:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     d18:	00074683          	lbu	a3,0(a4)
     d1c:	fd06879b          	addiw	a5,a3,-48
     d20:	0ff7f793          	zext.b	a5,a5
     d24:	fef671e3          	bgeu	a2,a5,d06 <atoi+0x1c>
    return n;
}
     d28:	6422                	ld	s0,8(sp)
     d2a:	0141                	addi	sp,sp,16
     d2c:	8082                	ret
    n = 0;
     d2e:	4501                	li	a0,0
     d30:	bfe5                	j	d28 <atoi+0x3e>

0000000000000d32 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n)
{
     d32:	1141                	addi	sp,sp,-16
     d34:	e422                	sd	s0,8(sp)
     d36:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
     d38:	02b57463          	bgeu	a0,a1,d60 <memmove+0x2e>
        while (n-- > 0)
     d3c:	00c05f63          	blez	a2,d5a <memmove+0x28>
     d40:	1602                	slli	a2,a2,0x20
     d42:	9201                	srli	a2,a2,0x20
     d44:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     d48:	872a                	mv	a4,a0
            *dst++ = *src++;
     d4a:	0585                	addi	a1,a1,1
     d4c:	0705                	addi	a4,a4,1
     d4e:	fff5c683          	lbu	a3,-1(a1)
     d52:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     d56:	fee79ae3          	bne	a5,a4,d4a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     d5a:	6422                	ld	s0,8(sp)
     d5c:	0141                	addi	sp,sp,16
     d5e:	8082                	ret
        dst += n;
     d60:	00c50733          	add	a4,a0,a2
        src += n;
     d64:	95b2                	add	a1,a1,a2
        while (n-- > 0)
     d66:	fec05ae3          	blez	a2,d5a <memmove+0x28>
     d6a:	fff6079b          	addiw	a5,a2,-1
     d6e:	1782                	slli	a5,a5,0x20
     d70:	9381                	srli	a5,a5,0x20
     d72:	fff7c793          	not	a5,a5
     d76:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     d78:	15fd                	addi	a1,a1,-1
     d7a:	177d                	addi	a4,a4,-1
     d7c:	0005c683          	lbu	a3,0(a1)
     d80:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     d84:	fee79ae3          	bne	a5,a4,d78 <memmove+0x46>
     d88:	bfc9                	j	d5a <memmove+0x28>

0000000000000d8a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     d8a:	1141                	addi	sp,sp,-16
     d8c:	e422                	sd	s0,8(sp)
     d8e:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
     d90:	ca05                	beqz	a2,dc0 <memcmp+0x36>
     d92:	fff6069b          	addiw	a3,a2,-1
     d96:	1682                	slli	a3,a3,0x20
     d98:	9281                	srli	a3,a3,0x20
     d9a:	0685                	addi	a3,a3,1
     d9c:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
     d9e:	00054783          	lbu	a5,0(a0)
     da2:	0005c703          	lbu	a4,0(a1)
     da6:	00e79863          	bne	a5,a4,db6 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
     daa:	0505                	addi	a0,a0,1
        p2++;
     dac:	0585                	addi	a1,a1,1
    while (n-- > 0) {
     dae:	fed518e3          	bne	a0,a3,d9e <memcmp+0x14>
    }
    return 0;
     db2:	4501                	li	a0,0
     db4:	a019                	j	dba <memcmp+0x30>
            return *p1 - *p2;
     db6:	40e7853b          	subw	a0,a5,a4
}
     dba:	6422                	ld	s0,8(sp)
     dbc:	0141                	addi	sp,sp,16
     dbe:	8082                	ret
    return 0;
     dc0:	4501                	li	a0,0
     dc2:	bfe5                	j	dba <memcmp+0x30>

0000000000000dc4 <memcpy>:

void *memcpy(void *dst, const void *src, uint n)
{
     dc4:	1141                	addi	sp,sp,-16
     dc6:	e406                	sd	ra,8(sp)
     dc8:	e022                	sd	s0,0(sp)
     dca:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     dcc:	00000097          	auipc	ra,0x0
     dd0:	f66080e7          	jalr	-154(ra) # d32 <memmove>
}
     dd4:	60a2                	ld	ra,8(sp)
     dd6:	6402                	ld	s0,0(sp)
     dd8:	0141                	addi	sp,sp,16
     dda:	8082                	ret

0000000000000ddc <ugetpid>:

#ifdef LAB_PGTBL
int ugetpid(void)
{
     ddc:	1141                	addi	sp,sp,-16
     dde:	e422                	sd	s0,8(sp)
     de0:	0800                	addi	s0,sp,16
    struct usyscall *u = (struct usyscall *)USYSCALL;
    return u->pid;
     de2:	040007b7          	lui	a5,0x4000
}
     de6:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdf75>
     de8:	07b2                	slli	a5,a5,0xc
     dea:	4388                	lw	a0,0(a5)
     dec:	6422                	ld	s0,8(sp)
     dee:	0141                	addi	sp,sp,16
     df0:	8082                	ret

0000000000000df2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     df2:	4885                	li	a7,1
 ecall
     df4:	00000073          	ecall
 ret
     df8:	8082                	ret

0000000000000dfa <exit>:
.global exit
exit:
 li a7, SYS_exit
     dfa:	4889                	li	a7,2
 ecall
     dfc:	00000073          	ecall
 ret
     e00:	8082                	ret

0000000000000e02 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e02:	488d                	li	a7,3
 ecall
     e04:	00000073          	ecall
 ret
     e08:	8082                	ret

0000000000000e0a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e0a:	4891                	li	a7,4
 ecall
     e0c:	00000073          	ecall
 ret
     e10:	8082                	ret

0000000000000e12 <read>:
.global read
read:
 li a7, SYS_read
     e12:	4895                	li	a7,5
 ecall
     e14:	00000073          	ecall
 ret
     e18:	8082                	ret

0000000000000e1a <write>:
.global write
write:
 li a7, SYS_write
     e1a:	48c1                	li	a7,16
 ecall
     e1c:	00000073          	ecall
 ret
     e20:	8082                	ret

0000000000000e22 <close>:
.global close
close:
 li a7, SYS_close
     e22:	48d5                	li	a7,21
 ecall
     e24:	00000073          	ecall
 ret
     e28:	8082                	ret

0000000000000e2a <kill>:
.global kill
kill:
 li a7, SYS_kill
     e2a:	4899                	li	a7,6
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e32:	489d                	li	a7,7
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <open>:
.global open
open:
 li a7, SYS_open
     e3a:	48bd                	li	a7,15
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e42:	48c5                	li	a7,17
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e4a:	48c9                	li	a7,18
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e52:	48a1                	li	a7,8
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <link>:
.global link
link:
 li a7, SYS_link
     e5a:	48cd                	li	a7,19
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e62:	48d1                	li	a7,20
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e6a:	48a5                	li	a7,9
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e72:	48a9                	li	a7,10
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e7a:	48ad                	li	a7,11
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e82:	48b1                	li	a7,12
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e8a:	48b5                	li	a7,13
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e92:	48b9                	li	a7,14
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <connect>:
.global connect
connect:
 li a7, SYS_connect
     e9a:	48f5                	li	a7,29
 ecall
     e9c:	00000073          	ecall
 ret
     ea0:	8082                	ret

0000000000000ea2 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     ea2:	48f9                	li	a7,30
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     eaa:	1101                	addi	sp,sp,-32
     eac:	ec06                	sd	ra,24(sp)
     eae:	e822                	sd	s0,16(sp)
     eb0:	1000                	addi	s0,sp,32
     eb2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eb6:	4605                	li	a2,1
     eb8:	fef40593          	addi	a1,s0,-17
     ebc:	00000097          	auipc	ra,0x0
     ec0:	f5e080e7          	jalr	-162(ra) # e1a <write>
}
     ec4:	60e2                	ld	ra,24(sp)
     ec6:	6442                	ld	s0,16(sp)
     ec8:	6105                	addi	sp,sp,32
     eca:	8082                	ret

0000000000000ecc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ecc:	7139                	addi	sp,sp,-64
     ece:	fc06                	sd	ra,56(sp)
     ed0:	f822                	sd	s0,48(sp)
     ed2:	f426                	sd	s1,40(sp)
     ed4:	f04a                	sd	s2,32(sp)
     ed6:	ec4e                	sd	s3,24(sp)
     ed8:	0080                	addi	s0,sp,64
     eda:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     edc:	c299                	beqz	a3,ee2 <printint+0x16>
     ede:	0805c963          	bltz	a1,f70 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ee2:	2581                	sext.w	a1,a1
  neg = 0;
     ee4:	4881                	li	a7,0
     ee6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     eea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     eec:	2601                	sext.w	a2,a2
     eee:	00000517          	auipc	a0,0x0
     ef2:	5e250513          	addi	a0,a0,1506 # 14d0 <digits>
     ef6:	883a                	mv	a6,a4
     ef8:	2705                	addiw	a4,a4,1
     efa:	02c5f7bb          	remuw	a5,a1,a2
     efe:	1782                	slli	a5,a5,0x20
     f00:	9381                	srli	a5,a5,0x20
     f02:	97aa                	add	a5,a5,a0
     f04:	0007c783          	lbu	a5,0(a5)
     f08:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f0c:	0005879b          	sext.w	a5,a1
     f10:	02c5d5bb          	divuw	a1,a1,a2
     f14:	0685                	addi	a3,a3,1
     f16:	fec7f0e3          	bgeu	a5,a2,ef6 <printint+0x2a>
  if(neg)
     f1a:	00088c63          	beqz	a7,f32 <printint+0x66>
    buf[i++] = '-';
     f1e:	fd070793          	addi	a5,a4,-48
     f22:	00878733          	add	a4,a5,s0
     f26:	02d00793          	li	a5,45
     f2a:	fef70823          	sb	a5,-16(a4)
     f2e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f32:	02e05863          	blez	a4,f62 <printint+0x96>
     f36:	fc040793          	addi	a5,s0,-64
     f3a:	00e78933          	add	s2,a5,a4
     f3e:	fff78993          	addi	s3,a5,-1
     f42:	99ba                	add	s3,s3,a4
     f44:	377d                	addiw	a4,a4,-1
     f46:	1702                	slli	a4,a4,0x20
     f48:	9301                	srli	a4,a4,0x20
     f4a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f4e:	fff94583          	lbu	a1,-1(s2)
     f52:	8526                	mv	a0,s1
     f54:	00000097          	auipc	ra,0x0
     f58:	f56080e7          	jalr	-170(ra) # eaa <putc>
  while(--i >= 0)
     f5c:	197d                	addi	s2,s2,-1
     f5e:	ff3918e3          	bne	s2,s3,f4e <printint+0x82>
}
     f62:	70e2                	ld	ra,56(sp)
     f64:	7442                	ld	s0,48(sp)
     f66:	74a2                	ld	s1,40(sp)
     f68:	7902                	ld	s2,32(sp)
     f6a:	69e2                	ld	s3,24(sp)
     f6c:	6121                	addi	sp,sp,64
     f6e:	8082                	ret
    x = -xx;
     f70:	40b005bb          	negw	a1,a1
    neg = 1;
     f74:	4885                	li	a7,1
    x = -xx;
     f76:	bf85                	j	ee6 <printint+0x1a>

0000000000000f78 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f78:	7119                	addi	sp,sp,-128
     f7a:	fc86                	sd	ra,120(sp)
     f7c:	f8a2                	sd	s0,112(sp)
     f7e:	f4a6                	sd	s1,104(sp)
     f80:	f0ca                	sd	s2,96(sp)
     f82:	ecce                	sd	s3,88(sp)
     f84:	e8d2                	sd	s4,80(sp)
     f86:	e4d6                	sd	s5,72(sp)
     f88:	e0da                	sd	s6,64(sp)
     f8a:	fc5e                	sd	s7,56(sp)
     f8c:	f862                	sd	s8,48(sp)
     f8e:	f466                	sd	s9,40(sp)
     f90:	f06a                	sd	s10,32(sp)
     f92:	ec6e                	sd	s11,24(sp)
     f94:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f96:	0005c903          	lbu	s2,0(a1)
     f9a:	18090f63          	beqz	s2,1138 <vprintf+0x1c0>
     f9e:	8aaa                	mv	s5,a0
     fa0:	8b32                	mv	s6,a2
     fa2:	00158493          	addi	s1,a1,1
  state = 0;
     fa6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fa8:	02500a13          	li	s4,37
     fac:	4c55                	li	s8,21
     fae:	00000c97          	auipc	s9,0x0
     fb2:	4cac8c93          	addi	s9,s9,1226 # 1478 <malloc+0x23c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     fb6:	02800d93          	li	s11,40
  putc(fd, 'x');
     fba:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fbc:	00000b97          	auipc	s7,0x0
     fc0:	514b8b93          	addi	s7,s7,1300 # 14d0 <digits>
     fc4:	a839                	j	fe2 <vprintf+0x6a>
        putc(fd, c);
     fc6:	85ca                	mv	a1,s2
     fc8:	8556                	mv	a0,s5
     fca:	00000097          	auipc	ra,0x0
     fce:	ee0080e7          	jalr	-288(ra) # eaa <putc>
     fd2:	a019                	j	fd8 <vprintf+0x60>
    } else if(state == '%'){
     fd4:	01498d63          	beq	s3,s4,fee <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     fd8:	0485                	addi	s1,s1,1
     fda:	fff4c903          	lbu	s2,-1(s1)
     fde:	14090d63          	beqz	s2,1138 <vprintf+0x1c0>
    if(state == 0){
     fe2:	fe0999e3          	bnez	s3,fd4 <vprintf+0x5c>
      if(c == '%'){
     fe6:	ff4910e3          	bne	s2,s4,fc6 <vprintf+0x4e>
        state = '%';
     fea:	89d2                	mv	s3,s4
     fec:	b7f5                	j	fd8 <vprintf+0x60>
      if(c == 'd'){
     fee:	11490c63          	beq	s2,s4,1106 <vprintf+0x18e>
     ff2:	f9d9079b          	addiw	a5,s2,-99
     ff6:	0ff7f793          	zext.b	a5,a5
     ffa:	10fc6e63          	bltu	s8,a5,1116 <vprintf+0x19e>
     ffe:	f9d9079b          	addiw	a5,s2,-99
    1002:	0ff7f713          	zext.b	a4,a5
    1006:	10ec6863          	bltu	s8,a4,1116 <vprintf+0x19e>
    100a:	00271793          	slli	a5,a4,0x2
    100e:	97e6                	add	a5,a5,s9
    1010:	439c                	lw	a5,0(a5)
    1012:	97e6                	add	a5,a5,s9
    1014:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1016:	008b0913          	addi	s2,s6,8
    101a:	4685                	li	a3,1
    101c:	4629                	li	a2,10
    101e:	000b2583          	lw	a1,0(s6)
    1022:	8556                	mv	a0,s5
    1024:	00000097          	auipc	ra,0x0
    1028:	ea8080e7          	jalr	-344(ra) # ecc <printint>
    102c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    102e:	4981                	li	s3,0
    1030:	b765                	j	fd8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1032:	008b0913          	addi	s2,s6,8
    1036:	4681                	li	a3,0
    1038:	4629                	li	a2,10
    103a:	000b2583          	lw	a1,0(s6)
    103e:	8556                	mv	a0,s5
    1040:	00000097          	auipc	ra,0x0
    1044:	e8c080e7          	jalr	-372(ra) # ecc <printint>
    1048:	8b4a                	mv	s6,s2
      state = 0;
    104a:	4981                	li	s3,0
    104c:	b771                	j	fd8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    104e:	008b0913          	addi	s2,s6,8
    1052:	4681                	li	a3,0
    1054:	866a                	mv	a2,s10
    1056:	000b2583          	lw	a1,0(s6)
    105a:	8556                	mv	a0,s5
    105c:	00000097          	auipc	ra,0x0
    1060:	e70080e7          	jalr	-400(ra) # ecc <printint>
    1064:	8b4a                	mv	s6,s2
      state = 0;
    1066:	4981                	li	s3,0
    1068:	bf85                	j	fd8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    106a:	008b0793          	addi	a5,s6,8
    106e:	f8f43423          	sd	a5,-120(s0)
    1072:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1076:	03000593          	li	a1,48
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	e2e080e7          	jalr	-466(ra) # eaa <putc>
  putc(fd, 'x');
    1084:	07800593          	li	a1,120
    1088:	8556                	mv	a0,s5
    108a:	00000097          	auipc	ra,0x0
    108e:	e20080e7          	jalr	-480(ra) # eaa <putc>
    1092:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1094:	03c9d793          	srli	a5,s3,0x3c
    1098:	97de                	add	a5,a5,s7
    109a:	0007c583          	lbu	a1,0(a5)
    109e:	8556                	mv	a0,s5
    10a0:	00000097          	auipc	ra,0x0
    10a4:	e0a080e7          	jalr	-502(ra) # eaa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10a8:	0992                	slli	s3,s3,0x4
    10aa:	397d                	addiw	s2,s2,-1
    10ac:	fe0914e3          	bnez	s2,1094 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    10b0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10b4:	4981                	li	s3,0
    10b6:	b70d                	j	fd8 <vprintf+0x60>
        s = va_arg(ap, char*);
    10b8:	008b0913          	addi	s2,s6,8
    10bc:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    10c0:	02098163          	beqz	s3,10e2 <vprintf+0x16a>
        while(*s != 0){
    10c4:	0009c583          	lbu	a1,0(s3)
    10c8:	c5ad                	beqz	a1,1132 <vprintf+0x1ba>
          putc(fd, *s);
    10ca:	8556                	mv	a0,s5
    10cc:	00000097          	auipc	ra,0x0
    10d0:	dde080e7          	jalr	-546(ra) # eaa <putc>
          s++;
    10d4:	0985                	addi	s3,s3,1
        while(*s != 0){
    10d6:	0009c583          	lbu	a1,0(s3)
    10da:	f9e5                	bnez	a1,10ca <vprintf+0x152>
        s = va_arg(ap, char*);
    10dc:	8b4a                	mv	s6,s2
      state = 0;
    10de:	4981                	li	s3,0
    10e0:	bde5                	j	fd8 <vprintf+0x60>
          s = "(null)";
    10e2:	00000997          	auipc	s3,0x0
    10e6:	38e98993          	addi	s3,s3,910 # 1470 <malloc+0x234>
        while(*s != 0){
    10ea:	85ee                	mv	a1,s11
    10ec:	bff9                	j	10ca <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    10ee:	008b0913          	addi	s2,s6,8
    10f2:	000b4583          	lbu	a1,0(s6)
    10f6:	8556                	mv	a0,s5
    10f8:	00000097          	auipc	ra,0x0
    10fc:	db2080e7          	jalr	-590(ra) # eaa <putc>
    1100:	8b4a                	mv	s6,s2
      state = 0;
    1102:	4981                	li	s3,0
    1104:	bdd1                	j	fd8 <vprintf+0x60>
        putc(fd, c);
    1106:	85d2                	mv	a1,s4
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	da0080e7          	jalr	-608(ra) # eaa <putc>
      state = 0;
    1112:	4981                	li	s3,0
    1114:	b5d1                	j	fd8 <vprintf+0x60>
        putc(fd, '%');
    1116:	85d2                	mv	a1,s4
    1118:	8556                	mv	a0,s5
    111a:	00000097          	auipc	ra,0x0
    111e:	d90080e7          	jalr	-624(ra) # eaa <putc>
        putc(fd, c);
    1122:	85ca                	mv	a1,s2
    1124:	8556                	mv	a0,s5
    1126:	00000097          	auipc	ra,0x0
    112a:	d84080e7          	jalr	-636(ra) # eaa <putc>
      state = 0;
    112e:	4981                	li	s3,0
    1130:	b565                	j	fd8 <vprintf+0x60>
        s = va_arg(ap, char*);
    1132:	8b4a                	mv	s6,s2
      state = 0;
    1134:	4981                	li	s3,0
    1136:	b54d                	j	fd8 <vprintf+0x60>
    }
  }
}
    1138:	70e6                	ld	ra,120(sp)
    113a:	7446                	ld	s0,112(sp)
    113c:	74a6                	ld	s1,104(sp)
    113e:	7906                	ld	s2,96(sp)
    1140:	69e6                	ld	s3,88(sp)
    1142:	6a46                	ld	s4,80(sp)
    1144:	6aa6                	ld	s5,72(sp)
    1146:	6b06                	ld	s6,64(sp)
    1148:	7be2                	ld	s7,56(sp)
    114a:	7c42                	ld	s8,48(sp)
    114c:	7ca2                	ld	s9,40(sp)
    114e:	7d02                	ld	s10,32(sp)
    1150:	6de2                	ld	s11,24(sp)
    1152:	6109                	addi	sp,sp,128
    1154:	8082                	ret

0000000000001156 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1156:	715d                	addi	sp,sp,-80
    1158:	ec06                	sd	ra,24(sp)
    115a:	e822                	sd	s0,16(sp)
    115c:	1000                	addi	s0,sp,32
    115e:	e010                	sd	a2,0(s0)
    1160:	e414                	sd	a3,8(s0)
    1162:	e818                	sd	a4,16(s0)
    1164:	ec1c                	sd	a5,24(s0)
    1166:	03043023          	sd	a6,32(s0)
    116a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    116e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1172:	8622                	mv	a2,s0
    1174:	00000097          	auipc	ra,0x0
    1178:	e04080e7          	jalr	-508(ra) # f78 <vprintf>
}
    117c:	60e2                	ld	ra,24(sp)
    117e:	6442                	ld	s0,16(sp)
    1180:	6161                	addi	sp,sp,80
    1182:	8082                	ret

0000000000001184 <printf>:

void
printf(const char *fmt, ...)
{
    1184:	711d                	addi	sp,sp,-96
    1186:	ec06                	sd	ra,24(sp)
    1188:	e822                	sd	s0,16(sp)
    118a:	1000                	addi	s0,sp,32
    118c:	e40c                	sd	a1,8(s0)
    118e:	e810                	sd	a2,16(s0)
    1190:	ec14                	sd	a3,24(s0)
    1192:	f018                	sd	a4,32(s0)
    1194:	f41c                	sd	a5,40(s0)
    1196:	03043823          	sd	a6,48(s0)
    119a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    119e:	00840613          	addi	a2,s0,8
    11a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11a6:	85aa                	mv	a1,a0
    11a8:	4505                	li	a0,1
    11aa:	00000097          	auipc	ra,0x0
    11ae:	dce080e7          	jalr	-562(ra) # f78 <vprintf>
}
    11b2:	60e2                	ld	ra,24(sp)
    11b4:	6442                	ld	s0,16(sp)
    11b6:	6125                	addi	sp,sp,96
    11b8:	8082                	ret

00000000000011ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11ba:	1141                	addi	sp,sp,-16
    11bc:	e422                	sd	s0,8(sp)
    11be:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11c0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c4:	00001797          	auipc	a5,0x1
    11c8:	e4c7b783          	ld	a5,-436(a5) # 2010 <freep>
    11cc:	a02d                	j	11f6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11ce:	4618                	lw	a4,8(a2)
    11d0:	9f2d                	addw	a4,a4,a1
    11d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11d6:	6398                	ld	a4,0(a5)
    11d8:	6310                	ld	a2,0(a4)
    11da:	a83d                	j	1218 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11dc:	ff852703          	lw	a4,-8(a0)
    11e0:	9f31                	addw	a4,a4,a2
    11e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11e4:	ff053683          	ld	a3,-16(a0)
    11e8:	a091                	j	122c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ea:	6398                	ld	a4,0(a5)
    11ec:	00e7e463          	bltu	a5,a4,11f4 <free+0x3a>
    11f0:	00e6ea63          	bltu	a3,a4,1204 <free+0x4a>
{
    11f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11f6:	fed7fae3          	bgeu	a5,a3,11ea <free+0x30>
    11fa:	6398                	ld	a4,0(a5)
    11fc:	00e6e463          	bltu	a3,a4,1204 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1200:	fee7eae3          	bltu	a5,a4,11f4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1204:	ff852583          	lw	a1,-8(a0)
    1208:	6390                	ld	a2,0(a5)
    120a:	02059813          	slli	a6,a1,0x20
    120e:	01c85713          	srli	a4,a6,0x1c
    1212:	9736                	add	a4,a4,a3
    1214:	fae60de3          	beq	a2,a4,11ce <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1218:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    121c:	4790                	lw	a2,8(a5)
    121e:	02061593          	slli	a1,a2,0x20
    1222:	01c5d713          	srli	a4,a1,0x1c
    1226:	973e                	add	a4,a4,a5
    1228:	fae68ae3          	beq	a3,a4,11dc <free+0x22>
    p->s.ptr = bp->s.ptr;
    122c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    122e:	00001717          	auipc	a4,0x1
    1232:	def73123          	sd	a5,-542(a4) # 2010 <freep>
}
    1236:	6422                	ld	s0,8(sp)
    1238:	0141                	addi	sp,sp,16
    123a:	8082                	ret

000000000000123c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    123c:	7139                	addi	sp,sp,-64
    123e:	fc06                	sd	ra,56(sp)
    1240:	f822                	sd	s0,48(sp)
    1242:	f426                	sd	s1,40(sp)
    1244:	f04a                	sd	s2,32(sp)
    1246:	ec4e                	sd	s3,24(sp)
    1248:	e852                	sd	s4,16(sp)
    124a:	e456                	sd	s5,8(sp)
    124c:	e05a                	sd	s6,0(sp)
    124e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1250:	02051493          	slli	s1,a0,0x20
    1254:	9081                	srli	s1,s1,0x20
    1256:	04bd                	addi	s1,s1,15
    1258:	8091                	srli	s1,s1,0x4
    125a:	0014899b          	addiw	s3,s1,1
    125e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1260:	00001517          	auipc	a0,0x1
    1264:	db053503          	ld	a0,-592(a0) # 2010 <freep>
    1268:	c515                	beqz	a0,1294 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    126a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    126c:	4798                	lw	a4,8(a5)
    126e:	02977f63          	bgeu	a4,s1,12ac <malloc+0x70>
    1272:	8a4e                	mv	s4,s3
    1274:	0009871b          	sext.w	a4,s3
    1278:	6685                	lui	a3,0x1
    127a:	00d77363          	bgeu	a4,a3,1280 <malloc+0x44>
    127e:	6a05                	lui	s4,0x1
    1280:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1284:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1288:	00001917          	auipc	s2,0x1
    128c:	d8890913          	addi	s2,s2,-632 # 2010 <freep>
  if(p == (char*)-1)
    1290:	5afd                	li	s5,-1
    1292:	a895                	j	1306 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1294:	00001797          	auipc	a5,0x1
    1298:	df478793          	addi	a5,a5,-524 # 2088 <base>
    129c:	00001717          	auipc	a4,0x1
    12a0:	d6f73a23          	sd	a5,-652(a4) # 2010 <freep>
    12a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12aa:	b7e1                	j	1272 <malloc+0x36>
      if(p->s.size == nunits)
    12ac:	02e48c63          	beq	s1,a4,12e4 <malloc+0xa8>
        p->s.size -= nunits;
    12b0:	4137073b          	subw	a4,a4,s3
    12b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12b6:	02071693          	slli	a3,a4,0x20
    12ba:	01c6d713          	srli	a4,a3,0x1c
    12be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12c4:	00001717          	auipc	a4,0x1
    12c8:	d4a73623          	sd	a0,-692(a4) # 2010 <freep>
      return (void*)(p + 1);
    12cc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12d0:	70e2                	ld	ra,56(sp)
    12d2:	7442                	ld	s0,48(sp)
    12d4:	74a2                	ld	s1,40(sp)
    12d6:	7902                	ld	s2,32(sp)
    12d8:	69e2                	ld	s3,24(sp)
    12da:	6a42                	ld	s4,16(sp)
    12dc:	6aa2                	ld	s5,8(sp)
    12de:	6b02                	ld	s6,0(sp)
    12e0:	6121                	addi	sp,sp,64
    12e2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12e4:	6398                	ld	a4,0(a5)
    12e6:	e118                	sd	a4,0(a0)
    12e8:	bff1                	j	12c4 <malloc+0x88>
  hp->s.size = nu;
    12ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12ee:	0541                	addi	a0,a0,16
    12f0:	00000097          	auipc	ra,0x0
    12f4:	eca080e7          	jalr	-310(ra) # 11ba <free>
  return freep;
    12f8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12fc:	d971                	beqz	a0,12d0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1300:	4798                	lw	a4,8(a5)
    1302:	fa9775e3          	bgeu	a4,s1,12ac <malloc+0x70>
    if(p == freep)
    1306:	00093703          	ld	a4,0(s2)
    130a:	853e                	mv	a0,a5
    130c:	fef719e3          	bne	a4,a5,12fe <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1310:	8552                	mv	a0,s4
    1312:	00000097          	auipc	ra,0x0
    1316:	b70080e7          	jalr	-1168(ra) # e82 <sbrk>
  if(p == (char*)-1)
    131a:	fd5518e3          	bne	a0,s5,12ea <malloc+0xae>
        return 0;
    131e:	4501                	li	a0,0
    1320:	bf45                	j	12d0 <malloc+0x94>
