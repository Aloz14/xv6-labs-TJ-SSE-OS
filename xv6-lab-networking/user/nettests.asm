
user/_nettests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:
}

// Decode a DNS name
static void decode_qname(char *qn, int max)
{
    char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
            break;
        for (int i = 0; i < l; i++) {
            *qn = *(qn + 1);
            qn++;
        }
        *qn++ = '.';
       2:	02e00813          	li	a6,46
        if (qn >= qnMax) {
       6:	02b56a63          	bltu	a0,a1,3a <decode_qname+0x3a>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
            printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	06e50513          	addi	a0,a0,110 # 1080 <malloc+0xee>
      1a:	00001097          	auipc	ra,0x1
      1e:	ec0080e7          	jalr	-320(ra) # eda <printf>
            exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	b2c080e7          	jalr	-1236(ra) # b50 <exit>
        *qn++ = '.';
      2c:	00160793          	addi	a5,a2,1
      30:	953e                	add	a0,a0,a5
      32:	01068023          	sb	a6,0(a3)
        if (qn >= qnMax) {
      36:	fcb57ae3          	bgeu	a0,a1,a <decode_qname+0xa>
        int l = *qn;
      3a:	00054683          	lbu	a3,0(a0)
        if (l == 0)
      3e:	ce89                	beqz	a3,58 <decode_qname+0x58>
        for (int i = 0; i < l; i++) {
      40:	0006861b          	sext.w	a2,a3
      44:	96aa                	add	a3,a3,a0
        if (l == 0)
      46:	87aa                	mv	a5,a0
            *qn = *(qn + 1);
      48:	0017c703          	lbu	a4,1(a5)
      4c:	00e78023          	sb	a4,0(a5)
            qn++;
      50:	0785                	addi	a5,a5,1
        for (int i = 0; i < l; i++) {
      52:	fed79be3          	bne	a5,a3,48 <decode_qname+0x48>
      56:	bfd9                	j	2c <decode_qname+0x2c>
      58:	8082                	ret

000000000000005a <ping>:
{
      5a:	7171                	addi	sp,sp,-176
      5c:	f506                	sd	ra,168(sp)
      5e:	f122                	sd	s0,160(sp)
      60:	ed26                	sd	s1,152(sp)
      62:	e94a                	sd	s2,144(sp)
      64:	e54e                	sd	s3,136(sp)
      66:	e152                	sd	s4,128(sp)
      68:	1900                	addi	s0,sp,176
      6a:	8a32                	mv	s4,a2
    if ((fd = connect(dst, sport, dport)) < 0) {
      6c:	862e                	mv	a2,a1
      6e:	85aa                	mv	a1,a0
      70:	0a000537          	lui	a0,0xa000
      74:	20250513          	addi	a0,a0,514 # a000202 <base+0x9ffe1f2>
      78:	00001097          	auipc	ra,0x1
      7c:	b78080e7          	jalr	-1160(ra) # bf0 <connect>
      80:	08054663          	bltz	a0,10c <ping+0xb2>
      84:	89aa                	mv	s3,a0
    for (int i = 0; i < attempts; i++) {
      86:	4481                	li	s1,0
        if (write(fd, obuf, strlen(obuf)) < 0) {
      88:	00001917          	auipc	s2,0x1
      8c:	02890913          	addi	s2,s2,40 # 10b0 <malloc+0x11e>
    for (int i = 0; i < attempts; i++) {
      90:	03405463          	blez	s4,b8 <ping+0x5e>
        if (write(fd, obuf, strlen(obuf)) < 0) {
      94:	854a                	mv	a0,s2
      96:	00001097          	auipc	ra,0x1
      9a:	896080e7          	jalr	-1898(ra) # 92c <strlen>
      9e:	0005061b          	sext.w	a2,a0
      a2:	85ca                	mv	a1,s2
      a4:	854e                	mv	a0,s3
      a6:	00001097          	auipc	ra,0x1
      aa:	aca080e7          	jalr	-1334(ra) # b70 <write>
      ae:	06054d63          	bltz	a0,128 <ping+0xce>
    for (int i = 0; i < attempts; i++) {
      b2:	2485                	addiw	s1,s1,1
      b4:	fe9a10e3          	bne	s4,s1,94 <ping+0x3a>
    int cc = read(fd, ibuf, sizeof(ibuf) - 1);
      b8:	07f00613          	li	a2,127
      bc:	f5040593          	addi	a1,s0,-176
      c0:	854e                	mv	a0,s3
      c2:	00001097          	auipc	ra,0x1
      c6:	aa6080e7          	jalr	-1370(ra) # b68 <read>
      ca:	84aa                	mv	s1,a0
    if (cc < 0) {
      cc:	06054c63          	bltz	a0,144 <ping+0xea>
    close(fd);
      d0:	854e                	mv	a0,s3
      d2:	00001097          	auipc	ra,0x1
      d6:	aa6080e7          	jalr	-1370(ra) # b78 <close>
    ibuf[cc] = '\0';
      da:	fd048793          	addi	a5,s1,-48
      de:	008784b3          	add	s1,a5,s0
      e2:	f8048023          	sb	zero,-128(s1)
    if (strcmp(ibuf, "this is the host!") != 0) {
      e6:	00001597          	auipc	a1,0x1
      ea:	01258593          	addi	a1,a1,18 # 10f8 <malloc+0x166>
      ee:	f5040513          	addi	a0,s0,-176
      f2:	00001097          	auipc	ra,0x1
      f6:	80e080e7          	jalr	-2034(ra) # 900 <strcmp>
      fa:	e13d                	bnez	a0,160 <ping+0x106>
}
      fc:	70aa                	ld	ra,168(sp)
      fe:	740a                	ld	s0,160(sp)
     100:	64ea                	ld	s1,152(sp)
     102:	694a                	ld	s2,144(sp)
     104:	69aa                	ld	s3,136(sp)
     106:	6a0a                	ld	s4,128(sp)
     108:	614d                	addi	sp,sp,176
     10a:	8082                	ret
        fprintf(2, "ping: connect() failed\n");
     10c:	00001597          	auipc	a1,0x1
     110:	f8c58593          	addi	a1,a1,-116 # 1098 <malloc+0x106>
     114:	4509                	li	a0,2
     116:	00001097          	auipc	ra,0x1
     11a:	d96080e7          	jalr	-618(ra) # eac <fprintf>
        exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	a30080e7          	jalr	-1488(ra) # b50 <exit>
            fprintf(2, "ping: send() failed\n");
     128:	00001597          	auipc	a1,0x1
     12c:	fa058593          	addi	a1,a1,-96 # 10c8 <malloc+0x136>
     130:	4509                	li	a0,2
     132:	00001097          	auipc	ra,0x1
     136:	d7a080e7          	jalr	-646(ra) # eac <fprintf>
            exit(1);
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	a14080e7          	jalr	-1516(ra) # b50 <exit>
        fprintf(2, "ping: recv() failed\n");
     144:	00001597          	auipc	a1,0x1
     148:	f9c58593          	addi	a1,a1,-100 # 10e0 <malloc+0x14e>
     14c:	4509                	li	a0,2
     14e:	00001097          	auipc	ra,0x1
     152:	d5e080e7          	jalr	-674(ra) # eac <fprintf>
        exit(1);
     156:	4505                	li	a0,1
     158:	00001097          	auipc	ra,0x1
     15c:	9f8080e7          	jalr	-1544(ra) # b50 <exit>
        fprintf(2, "ping didn't receive correct payload\n");
     160:	00001597          	auipc	a1,0x1
     164:	fb058593          	addi	a1,a1,-80 # 1110 <malloc+0x17e>
     168:	4509                	li	a0,2
     16a:	00001097          	auipc	ra,0x1
     16e:	d42080e7          	jalr	-702(ra) # eac <fprintf>
        exit(1);
     172:	4505                	li	a0,1
     174:	00001097          	auipc	ra,0x1
     178:	9dc080e7          	jalr	-1572(ra) # b50 <exit>

000000000000017c <dns>:
        exit(1);
    }
}

static void dns()
{
     17c:	7119                	addi	sp,sp,-128
     17e:	fc86                	sd	ra,120(sp)
     180:	f8a2                	sd	s0,112(sp)
     182:	f4a6                	sd	s1,104(sp)
     184:	f0ca                	sd	s2,96(sp)
     186:	ecce                	sd	s3,88(sp)
     188:	e8d2                	sd	s4,80(sp)
     18a:	e4d6                	sd	s5,72(sp)
     18c:	e0da                	sd	s6,64(sp)
     18e:	fc5e                	sd	s7,56(sp)
     190:	f862                	sd	s8,48(sp)
     192:	f466                	sd	s9,40(sp)
     194:	f06a                	sd	s10,32(sp)
     196:	ec6e                	sd	s11,24(sp)
     198:	0100                	addi	s0,sp,128
     19a:	82010113          	addi	sp,sp,-2016
    uint8 ibuf[N];
    uint32 dst;
    int fd;
    int len;

    memset(obuf, 0, N);
     19e:	3e800613          	li	a2,1000
     1a2:	4581                	li	a1,0
     1a4:	ba840513          	addi	a0,s0,-1112
     1a8:	00000097          	auipc	ra,0x0
     1ac:	7ae080e7          	jalr	1966(ra) # 956 <memset>
    memset(ibuf, 0, N);
     1b0:	3e800613          	li	a2,1000
     1b4:	4581                	li	a1,0
     1b6:	77fd                	lui	a5,0xfffff
     1b8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     1bc:	00f40533          	add	a0,s0,a5
     1c0:	00000097          	auipc	ra,0x0
     1c4:	796080e7          	jalr	1942(ra) # 956 <memset>

    // 8.8.8.8: google's name server
    dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

    if ((fd = connect(dst, 10000, 53)) < 0) {
     1c8:	03500613          	li	a2,53
     1cc:	6589                	lui	a1,0x2
     1ce:	71058593          	addi	a1,a1,1808 # 2710 <base+0x700>
     1d2:	08081537          	lui	a0,0x8081
     1d6:	80850513          	addi	a0,a0,-2040 # 8080808 <base+0x807e7f8>
     1da:	00001097          	auipc	ra,0x1
     1de:	a16080e7          	jalr	-1514(ra) # bf0 <connect>
     1e2:	777d                	lui	a4,0xfffff
     1e4:	7a870713          	addi	a4,a4,1960 # fffffffffffff7a8 <base+0xffffffffffffd798>
     1e8:	9722                	add	a4,a4,s0
     1ea:	e308                	sd	a0,0(a4)
     1ec:	02054c63          	bltz	a0,224 <dns+0xa8>
    hdr->id = htons(6828);
     1f0:	77ed                	lui	a5,0xffffb
     1f2:	c1a78793          	addi	a5,a5,-998 # ffffffffffffac1a <base+0xffffffffffff8c0a>
     1f6:	baf41423          	sh	a5,-1112(s0)
    hdr->rd = 1;
     1fa:	baa45783          	lhu	a5,-1110(s0)
     1fe:	0017e793          	ori	a5,a5,1
     202:	baf41523          	sh	a5,-1110(s0)
    hdr->qdcount = htons(1);
     206:	10000793          	li	a5,256
     20a:	baf41623          	sh	a5,-1108(s0)
    for (char *c = host; c < host + strlen(host) + 1; c++) {
     20e:	00001497          	auipc	s1,0x1
     212:	f2a48493          	addi	s1,s1,-214 # 1138 <malloc+0x1a6>
    char *l = host;
     216:	8a26                	mv	s4,s1
    for (char *c = host; c < host + strlen(host) + 1; c++) {
     218:	bb440a93          	addi	s5,s0,-1100
     21c:	8926                	mv	s2,s1
        if (*c == '.') {
     21e:	02e00993          	li	s3,46
    for (char *c = host; c < host + strlen(host) + 1; c++) {
     222:	a82d                	j	25c <dns+0xe0>
        fprintf(2, "ping: connect() failed\n");
     224:	00001597          	auipc	a1,0x1
     228:	e7458593          	addi	a1,a1,-396 # 1098 <malloc+0x106>
     22c:	4509                	li	a0,2
     22e:	00001097          	auipc	ra,0x1
     232:	c7e080e7          	jalr	-898(ra) # eac <fprintf>
        exit(1);
     236:	4505                	li	a0,1
     238:	00001097          	auipc	ra,0x1
     23c:	918080e7          	jalr	-1768(ra) # b50 <exit>
                *qn++ = *d;
     240:	0705                	addi	a4,a4,1
     242:	0007c683          	lbu	a3,0(a5)
     246:	fed70fa3          	sb	a3,-1(a4)
            for (char *d = l; d < c; d++) {
     24a:	0785                	addi	a5,a5,1
     24c:	fef49ae3          	bne	s1,a5,240 <dns+0xc4>
                *qn++ = *d;
     250:	41448ab3          	sub	s5,s1,s4
     254:	9ab2                	add	s5,s5,a2
            l = c + 1; // skip .
     256:	00148a13          	addi	s4,s1,1
    for (char *c = host; c < host + strlen(host) + 1; c++) {
     25a:	0485                	addi	s1,s1,1
     25c:	854a                	mv	a0,s2
     25e:	00000097          	auipc	ra,0x0
     262:	6ce080e7          	jalr	1742(ra) # 92c <strlen>
     266:	02051793          	slli	a5,a0,0x20
     26a:	9381                	srli	a5,a5,0x20
     26c:	0785                	addi	a5,a5,1
     26e:	97ca                	add	a5,a5,s2
     270:	02f4f363          	bgeu	s1,a5,296 <dns+0x11a>
        if (*c == '.') {
     274:	0004c783          	lbu	a5,0(s1)
     278:	ff3791e3          	bne	a5,s3,25a <dns+0xde>
            *qn++ = (char)(c - l);
     27c:	001a8613          	addi	a2,s5,1
     280:	414487b3          	sub	a5,s1,s4
     284:	00fa8023          	sb	a5,0(s5)
            for (char *d = l; d < c; d++) {
     288:	009a7563          	bgeu	s4,s1,292 <dns+0x116>
     28c:	87d2                	mv	a5,s4
            *qn++ = (char)(c - l);
     28e:	8732                	mv	a4,a2
     290:	bf45                	j	240 <dns+0xc4>
     292:	8ab2                	mv	s5,a2
     294:	b7c9                	j	256 <dns+0xda>
    *qn = '\0';
     296:	000a8023          	sb	zero,0(s5)
    len += strlen(qname) + 1;
     29a:	bb440513          	addi	a0,s0,-1100
     29e:	00000097          	auipc	ra,0x0
     2a2:	68e080e7          	jalr	1678(ra) # 92c <strlen>
     2a6:	0005049b          	sext.w	s1,a0
    struct dns_question *h = (struct dns_question *)(qname + strlen(qname) + 1);
     2aa:	bb440513          	addi	a0,s0,-1100
     2ae:	00000097          	auipc	ra,0x0
     2b2:	67e080e7          	jalr	1662(ra) # 92c <strlen>
     2b6:	02051793          	slli	a5,a0,0x20
     2ba:	9381                	srli	a5,a5,0x20
     2bc:	0785                	addi	a5,a5,1
     2be:	bb440713          	addi	a4,s0,-1100
     2c2:	97ba                	add	a5,a5,a4
    h->qtype = htons(0x1);
     2c4:	00078023          	sb	zero,0(a5)
     2c8:	4705                	li	a4,1
     2ca:	00e780a3          	sb	a4,1(a5)
    h->qclass = htons(0x1);
     2ce:	00078123          	sb	zero,2(a5)
     2d2:	00e781a3          	sb	a4,3(a5)
    }

    len = dns_req(obuf);

    if (write(fd, obuf, len) < 0) {
     2d6:	0114861b          	addiw	a2,s1,17
     2da:	ba840593          	addi	a1,s0,-1112
     2de:	77fd                	lui	a5,0xfffff
     2e0:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <base+0xffffffffffffd798>
     2e4:	97a2                	add	a5,a5,s0
     2e6:	6388                	ld	a0,0(a5)
     2e8:	00001097          	auipc	ra,0x1
     2ec:	888080e7          	jalr	-1912(ra) # b70 <write>
     2f0:	12054c63          	bltz	a0,428 <dns+0x2ac>
        fprintf(2, "dns: send() failed\n");
        exit(1);
    }
    int cc = read(fd, ibuf, sizeof(ibuf));
     2f4:	3e800613          	li	a2,1000
     2f8:	77fd                	lui	a5,0xfffff
     2fa:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     2fe:	00f405b3          	add	a1,s0,a5
     302:	77fd                	lui	a5,0xfffff
     304:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <base+0xffffffffffffd798>
     308:	97a2                	add	a5,a5,s0
     30a:	6388                	ld	a0,0(a5)
     30c:	00001097          	auipc	ra,0x1
     310:	85c080e7          	jalr	-1956(ra) # b68 <read>
     314:	8a2a                	mv	s4,a0
    if (cc < 0) {
     316:	12054763          	bltz	a0,444 <dns+0x2c8>
    if (cc < sizeof(struct dns)) {
     31a:	0005079b          	sext.w	a5,a0
     31e:	472d                	li	a4,11
     320:	14f77063          	bgeu	a4,a5,460 <dns+0x2e4>
    if (!hdr->qr) {
     324:	77fd                	lui	a5,0xfffff
     326:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <base+0xffffffffffffd7b2>
     32a:	97a2                	add	a5,a5,s0
     32c:	00078783          	lb	a5,0(a5)
     330:	1407d563          	bgez	a5,47a <dns+0x2fe>
    if (hdr->id != htons(6828)) {
     334:	77fd                	lui	a5,0xfffff
     336:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     33a:	97a2                	add	a5,a5,s0
     33c:	0007d703          	lhu	a4,0(a5)
     340:	0007069b          	sext.w	a3,a4
     344:	67ad                	lui	a5,0xb
     346:	c1a78793          	addi	a5,a5,-998 # ac1a <base+0x8c0a>
     34a:	16f69263          	bne	a3,a5,4ae <dns+0x332>
    if (hdr->rcode != 0) {
     34e:	777d                	lui	a4,0xfffff
     350:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     354:	97a2                	add	a5,a5,s0
     356:	0007c783          	lbu	a5,0(a5)
     35a:	8bbd                	andi	a5,a5,15
     35c:	16079d63          	bnez	a5,4d6 <dns+0x35a>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     360:	7c470793          	addi	a5,a4,1988
     364:	97a2                	add	a5,a5,s0
     366:	0007d783          	lhu	a5,0(a5)
     36a:	0087971b          	slliw	a4,a5,0x8
     36e:	83a1                	srli	a5,a5,0x8
     370:	8fd9                	or	a5,a5,a4
    for (int i = 0; i < ntohs(hdr->qdcount); i++) {
     372:	17c2                	slli	a5,a5,0x30
     374:	93c1                	srli	a5,a5,0x30
     376:	4981                	li	s3,0
    len = sizeof(struct dns);
     378:	44b1                	li	s1,12
    char *qname = 0;
     37a:	4901                	li	s2,0
    for (int i = 0; i < ntohs(hdr->qdcount); i++) {
     37c:	c3b9                	beqz	a5,3c2 <dns+0x246>
        char *qn = (char *)(ibuf + len);
     37e:	7afd                	lui	s5,0xfffff
     380:	7c0a8793          	addi	a5,s5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     384:	97a2                	add	a5,a5,s0
     386:	00978933          	add	s2,a5,s1
        decode_qname(qn, cc - len);
     38a:	409a05bb          	subw	a1,s4,s1
     38e:	854a                	mv	a0,s2
     390:	00000097          	auipc	ra,0x0
     394:	c70080e7          	jalr	-912(ra) # 0 <decode_qname>
        len += strlen(qn) + 1;
     398:	854a                	mv	a0,s2
     39a:	00000097          	auipc	ra,0x0
     39e:	592080e7          	jalr	1426(ra) # 92c <strlen>
        len += sizeof(struct dns_question);
     3a2:	2515                	addiw	a0,a0,5
     3a4:	9ca9                	addw	s1,s1,a0
    for (int i = 0; i < ntohs(hdr->qdcount); i++) {
     3a6:	2985                	addiw	s3,s3,1
     3a8:	7c4a8793          	addi	a5,s5,1988
     3ac:	97a2                	add	a5,a5,s0
     3ae:	0007d783          	lhu	a5,0(a5)
     3b2:	0087971b          	slliw	a4,a5,0x8
     3b6:	83a1                	srli	a5,a5,0x8
     3b8:	8fd9                	or	a5,a5,a4
     3ba:	17c2                	slli	a5,a5,0x30
     3bc:	93c1                	srli	a5,a5,0x30
     3be:	fcf9c0e3          	blt	s3,a5,37e <dns+0x202>
     3c2:	77fd                	lui	a5,0xfffff
     3c4:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     3c8:	97a2                	add	a5,a5,s0
     3ca:	0007d783          	lhu	a5,0(a5)
     3ce:	0087971b          	slliw	a4,a5,0x8
     3d2:	83a1                	srli	a5,a5,0x8
     3d4:	8fd9                	or	a5,a5,a4
    for (int i = 0; i < ntohs(hdr->ancount); i++) {
     3d6:	17c2                	slli	a5,a5,0x30
     3d8:	93c1                	srli	a5,a5,0x30
     3da:	26078563          	beqz	a5,644 <dns+0x4c8>
        if (len >= cc) {
     3de:	1344d063          	bge	s1,s4,4fe <dns+0x382>
     3e2:	00001797          	auipc	a5,0x1
     3e6:	e9678793          	addi	a5,a5,-362 # 1278 <malloc+0x2e6>
     3ea:	00090363          	beqz	s2,3f0 <dns+0x274>
     3ee:	87ca                	mv	a5,s2
     3f0:	76fd                	lui	a3,0xfffff
     3f2:	7b068713          	addi	a4,a3,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     3f6:	9722                	add	a4,a4,s0
     3f8:	e31c                	sd	a5,0(a4)
    int record = 0;
     3fa:	7b868793          	addi	a5,a3,1976
     3fe:	97a2                	add	a5,a5,s0
     400:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < ntohs(hdr->ancount); i++) {
     404:	4901                	li	s2,0
        if ((int)qn[0] > 63) { // compression?
     406:	03f00b13          	li	s6,63
        if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     40a:	4a85                	li	s5,1
     40c:	4b91                	li	s7,4
            printf("DNS arecord for %s is ", qname ? qname : "");
     40e:	00001d97          	auipc	s11,0x1
     412:	dd2d8d93          	addi	s11,s11,-558 # 11e0 <malloc+0x24e>
            printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     416:	00001c17          	auipc	s8,0x1
     41a:	de2c0c13          	addi	s8,s8,-542 # 11f8 <malloc+0x266>
            if (ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     41e:	08000d13          	li	s10,128
     422:	03400c93          	li	s9,52
     426:	a2b1                	j	572 <dns+0x3f6>
        fprintf(2, "dns: send() failed\n");
     428:	00001597          	auipc	a1,0x1
     42c:	d2858593          	addi	a1,a1,-728 # 1150 <malloc+0x1be>
     430:	4509                	li	a0,2
     432:	00001097          	auipc	ra,0x1
     436:	a7a080e7          	jalr	-1414(ra) # eac <fprintf>
        exit(1);
     43a:	4505                	li	a0,1
     43c:	00000097          	auipc	ra,0x0
     440:	714080e7          	jalr	1812(ra) # b50 <exit>
        fprintf(2, "dns: recv() failed\n");
     444:	00001597          	auipc	a1,0x1
     448:	d2458593          	addi	a1,a1,-732 # 1168 <malloc+0x1d6>
     44c:	4509                	li	a0,2
     44e:	00001097          	auipc	ra,0x1
     452:	a5e080e7          	jalr	-1442(ra) # eac <fprintf>
        exit(1);
     456:	4505                	li	a0,1
     458:	00000097          	auipc	ra,0x0
     45c:	6f8080e7          	jalr	1784(ra) # b50 <exit>
        printf("DNS reply too short\n");
     460:	00001517          	auipc	a0,0x1
     464:	d2050513          	addi	a0,a0,-736 # 1180 <malloc+0x1ee>
     468:	00001097          	auipc	ra,0x1
     46c:	a72080e7          	jalr	-1422(ra) # eda <printf>
        exit(1);
     470:	4505                	li	a0,1
     472:	00000097          	auipc	ra,0x0
     476:	6de080e7          	jalr	1758(ra) # b50 <exit>
     47a:	77fd                	lui	a5,0xfffff
     47c:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     480:	97a2                	add	a5,a5,s0
     482:	0007d783          	lhu	a5,0(a5)
     486:	0087971b          	slliw	a4,a5,0x8
     48a:	83a1                	srli	a5,a5,0x8
     48c:	00e7e5b3          	or	a1,a5,a4
        printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     490:	15c2                	slli	a1,a1,0x30
     492:	91c1                	srli	a1,a1,0x30
     494:	00001517          	auipc	a0,0x1
     498:	d0450513          	addi	a0,a0,-764 # 1198 <malloc+0x206>
     49c:	00001097          	auipc	ra,0x1
     4a0:	a3e080e7          	jalr	-1474(ra) # eda <printf>
        exit(1);
     4a4:	4505                	li	a0,1
     4a6:	00000097          	auipc	ra,0x0
     4aa:	6aa080e7          	jalr	1706(ra) # b50 <exit>
     4ae:	0087159b          	slliw	a1,a4,0x8
     4b2:	0087571b          	srliw	a4,a4,0x8
     4b6:	8dd9                	or	a1,a1,a4
        printf("DNS wrong id: %d\n", ntohs(hdr->id));
     4b8:	15c2                	slli	a1,a1,0x30
     4ba:	91c1                	srli	a1,a1,0x30
     4bc:	00001517          	auipc	a0,0x1
     4c0:	cf450513          	addi	a0,a0,-780 # 11b0 <malloc+0x21e>
     4c4:	00001097          	auipc	ra,0x1
     4c8:	a16080e7          	jalr	-1514(ra) # eda <printf>
        exit(1);
     4cc:	4505                	li	a0,1
     4ce:	00000097          	auipc	ra,0x0
     4d2:	682080e7          	jalr	1666(ra) # b50 <exit>
        printf("DNS rcode error: %x\n", hdr->rcode);
     4d6:	77fd                	lui	a5,0xfffff
     4d8:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     4dc:	97a2                	add	a5,a5,s0
     4de:	0007c583          	lbu	a1,0(a5)
     4e2:	89bd                	andi	a1,a1,15
     4e4:	00001517          	auipc	a0,0x1
     4e8:	ce450513          	addi	a0,a0,-796 # 11c8 <malloc+0x236>
     4ec:	00001097          	auipc	ra,0x1
     4f0:	9ee080e7          	jalr	-1554(ra) # eda <printf>
        exit(1);
     4f4:	4505                	li	a0,1
     4f6:	00000097          	auipc	ra,0x0
     4fa:	65a080e7          	jalr	1626(ra) # b50 <exit>
            printf("invalid DNS reply\n");
     4fe:	00001517          	auipc	a0,0x1
     502:	b8250513          	addi	a0,a0,-1150 # 1080 <malloc+0xee>
     506:	00001097          	auipc	ra,0x1
     50a:	9d4080e7          	jalr	-1580(ra) # eda <printf>
            exit(1);
     50e:	4505                	li	a0,1
     510:	00000097          	auipc	ra,0x0
     514:	640080e7          	jalr	1600(ra) # b50 <exit>
            decode_qname(qn, cc - len);
     518:	409a05bb          	subw	a1,s4,s1
     51c:	854e                	mv	a0,s3
     51e:	00000097          	auipc	ra,0x0
     522:	ae2080e7          	jalr	-1310(ra) # 0 <decode_qname>
            len += strlen(qn) + 1;
     526:	854e                	mv	a0,s3
     528:	00000097          	auipc	ra,0x0
     52c:	404080e7          	jalr	1028(ra) # 92c <strlen>
     530:	2485                	addiw	s1,s1,1
     532:	9ca9                	addw	s1,s1,a0
     534:	a891                	j	588 <dns+0x40c>
                printf("wrong ip address");
     536:	00001517          	auipc	a0,0x1
     53a:	cd250513          	addi	a0,a0,-814 # 1208 <malloc+0x276>
     53e:	00001097          	auipc	ra,0x1
     542:	99c080e7          	jalr	-1636(ra) # eda <printf>
                exit(1);
     546:	4505                	li	a0,1
     548:	00000097          	auipc	ra,0x0
     54c:	608080e7          	jalr	1544(ra) # b50 <exit>
    for (int i = 0; i < ntohs(hdr->ancount); i++) {
     550:	2905                	addiw	s2,s2,1
     552:	77fd                	lui	a5,0xfffff
     554:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     558:	97a2                	add	a5,a5,s0
     55a:	0007d783          	lhu	a5,0(a5)
     55e:	0087971b          	slliw	a4,a5,0x8
     562:	83a1                	srli	a5,a5,0x8
     564:	8fd9                	or	a5,a5,a4
     566:	17c2                	slli	a5,a5,0x30
     568:	93c1                	srli	a5,a5,0x30
     56a:	0ef95363          	bge	s2,a5,650 <dns+0x4d4>
        if (len >= cc) {
     56e:	f944d8e3          	bge	s1,s4,4fe <dns+0x382>
        char *qn = (char *)(ibuf + len);
     572:	77fd                	lui	a5,0xfffff
     574:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     578:	97a2                	add	a5,a5,s0
     57a:	009789b3          	add	s3,a5,s1
        if ((int)qn[0] > 63) { // compression?
     57e:	0009c783          	lbu	a5,0(s3)
     582:	f8fb7be3          	bgeu	s6,a5,518 <dns+0x39c>
            len += 2;
     586:	2489                	addiw	s1,s1,2
        struct dns_data *d = (struct dns_data *)(ibuf + len);
     588:	77fd                	lui	a5,0xfffff
     58a:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     58e:	97a2                	add	a5,a5,s0
     590:	00978733          	add	a4,a5,s1
        len += sizeof(struct dns_data);
     594:	0004899b          	sext.w	s3,s1
     598:	24a9                	addiw	s1,s1,10
        if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     59a:	00074683          	lbu	a3,0(a4)
     59e:	00174783          	lbu	a5,1(a4)
     5a2:	07a2                	slli	a5,a5,0x8
     5a4:	8fd5                	or	a5,a5,a3
     5a6:	0087969b          	slliw	a3,a5,0x8
     5aa:	83a1                	srli	a5,a5,0x8
     5ac:	8fd5                	or	a5,a5,a3
     5ae:	17c2                	slli	a5,a5,0x30
     5b0:	93c1                	srli	a5,a5,0x30
     5b2:	f9579fe3          	bne	a5,s5,550 <dns+0x3d4>
     5b6:	00874683          	lbu	a3,8(a4)
     5ba:	00974783          	lbu	a5,9(a4)
     5be:	07a2                	slli	a5,a5,0x8
     5c0:	8fd5                	or	a5,a5,a3
     5c2:	0087971b          	slliw	a4,a5,0x8
     5c6:	83a1                	srli	a5,a5,0x8
     5c8:	8fd9                	or	a5,a5,a4
     5ca:	17c2                	slli	a5,a5,0x30
     5cc:	93c1                	srli	a5,a5,0x30
     5ce:	f97791e3          	bne	a5,s7,550 <dns+0x3d4>
            printf("DNS arecord for %s is ", qname ? qname : "");
     5d2:	77fd                	lui	a5,0xfffff
     5d4:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     5d8:	97a2                	add	a5,a5,s0
     5da:	638c                	ld	a1,0(a5)
     5dc:	856e                	mv	a0,s11
     5de:	00001097          	auipc	ra,0x1
     5e2:	8fc080e7          	jalr	-1796(ra) # eda <printf>
            uint8 *ip = (ibuf + len);
     5e6:	77fd                	lui	a5,0xfffff
     5e8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     5ec:	97a2                	add	a5,a5,s0
     5ee:	94be                	add	s1,s1,a5
            printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     5f0:	0034c703          	lbu	a4,3(s1)
     5f4:	0024c683          	lbu	a3,2(s1)
     5f8:	0014c603          	lbu	a2,1(s1)
     5fc:	0004c583          	lbu	a1,0(s1)
     600:	8562                	mv	a0,s8
     602:	00001097          	auipc	ra,0x1
     606:	8d8080e7          	jalr	-1832(ra) # eda <printf>
            if (ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     60a:	0004c783          	lbu	a5,0(s1)
     60e:	f3a794e3          	bne	a5,s10,536 <dns+0x3ba>
     612:	0014c783          	lbu	a5,1(s1)
     616:	f39790e3          	bne	a5,s9,536 <dns+0x3ba>
     61a:	0024c703          	lbu	a4,2(s1)
     61e:	08100793          	li	a5,129
     622:	f0f71ae3          	bne	a4,a5,536 <dns+0x3ba>
     626:	0034c703          	lbu	a4,3(s1)
     62a:	07e00793          	li	a5,126
     62e:	f0f714e3          	bne	a4,a5,536 <dns+0x3ba>
            len += 4;
     632:	00e9849b          	addiw	s1,s3,14
            record = 1;
     636:	77fd                	lui	a5,0xfffff
     638:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     63c:	97a2                	add	a5,a5,s0
     63e:	0157b023          	sd	s5,0(a5)
     642:	b739                	j	550 <dns+0x3d4>
    int record = 0;
     644:	77fd                	lui	a5,0xfffff
     646:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     64a:	97a2                	add	a5,a5,s0
     64c:	0007b023          	sd	zero,0(a5)
     650:	77fd                	lui	a5,0xfffff
     652:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <base+0xffffffffffffd7ba>
     656:	97a2                	add	a5,a5,s0
     658:	0007d783          	lhu	a5,0(a5)
     65c:	0087971b          	slliw	a4,a5,0x8
     660:	0087d593          	srli	a1,a5,0x8
     664:	8dd9                	or	a1,a1,a4
    for (int i = 0; i < ntohs(hdr->arcount); i++) {
     666:	15c2                	slli	a1,a1,0x30
     668:	91c1                	srli	a1,a1,0x30
     66a:	06b05363          	blez	a1,6d0 <dns+0x554>
     66e:	4681                	li	a3,0
        if (ntohs(d->type) != 41) {
     670:	02900513          	li	a0,41
        if (*qn != 0) {
     674:	f9048793          	addi	a5,s1,-112
     678:	97a2                	add	a5,a5,s0
     67a:	8307c783          	lbu	a5,-2000(a5)
     67e:	ebd9                	bnez	a5,714 <dns+0x598>
        struct dns_data *d = (struct dns_data *)(ibuf + len);
     680:	0014871b          	addiw	a4,s1,1
     684:	77fd                	lui	a5,0xfffff
     686:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     68a:	97a2                	add	a5,a5,s0
     68c:	973e                	add	a4,a4,a5
        len += sizeof(struct dns_data);
     68e:	24ad                	addiw	s1,s1,11
        if (ntohs(d->type) != 41) {
     690:	00074603          	lbu	a2,0(a4)
     694:	00174783          	lbu	a5,1(a4)
     698:	07a2                	slli	a5,a5,0x8
     69a:	8fd1                	or	a5,a5,a2
     69c:	0087961b          	slliw	a2,a5,0x8
     6a0:	83a1                	srli	a5,a5,0x8
     6a2:	8fd1                	or	a5,a5,a2
     6a4:	17c2                	slli	a5,a5,0x30
     6a6:	93c1                	srli	a5,a5,0x30
     6a8:	08a79363          	bne	a5,a0,72e <dns+0x5b2>
        len += ntohs(d->len);
     6ac:	00874603          	lbu	a2,8(a4)
     6b0:	00974783          	lbu	a5,9(a4)
     6b4:	07a2                	slli	a5,a5,0x8
     6b6:	8fd1                	or	a5,a5,a2
     6b8:	0087971b          	slliw	a4,a5,0x8
     6bc:	83a1                	srli	a5,a5,0x8
     6be:	8fd9                	or	a5,a5,a4
     6c0:	0107979b          	slliw	a5,a5,0x10
     6c4:	0107d79b          	srliw	a5,a5,0x10
     6c8:	9cbd                	addw	s1,s1,a5
    for (int i = 0; i < ntohs(hdr->arcount); i++) {
     6ca:	2685                	addiw	a3,a3,1
     6cc:	fad594e3          	bne	a1,a3,674 <dns+0x4f8>
    if (len != cc) {
     6d0:	069a1c63          	bne	s4,s1,748 <dns+0x5cc>
    if (!record) {
     6d4:	77fd                	lui	a5,0xfffff
     6d6:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     6da:	97a2                	add	a5,a5,s0
     6dc:	639c                	ld	a5,0(a5)
     6de:	c7c1                	beqz	a5,766 <dns+0x5ea>
    }
    dns_rep(ibuf, cc);

    close(fd);
     6e0:	77fd                	lui	a5,0xfffff
     6e2:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <base+0xffffffffffffd798>
     6e6:	97a2                	add	a5,a5,s0
     6e8:	6388                	ld	a0,0(a5)
     6ea:	00000097          	auipc	ra,0x0
     6ee:	48e080e7          	jalr	1166(ra) # b78 <close>
}
     6f2:	7e010113          	addi	sp,sp,2016
     6f6:	70e6                	ld	ra,120(sp)
     6f8:	7446                	ld	s0,112(sp)
     6fa:	74a6                	ld	s1,104(sp)
     6fc:	7906                	ld	s2,96(sp)
     6fe:	69e6                	ld	s3,88(sp)
     700:	6a46                	ld	s4,80(sp)
     702:	6aa6                	ld	s5,72(sp)
     704:	6b06                	ld	s6,64(sp)
     706:	7be2                	ld	s7,56(sp)
     708:	7c42                	ld	s8,48(sp)
     70a:	7ca2                	ld	s9,40(sp)
     70c:	7d02                	ld	s10,32(sp)
     70e:	6de2                	ld	s11,24(sp)
     710:	6109                	addi	sp,sp,128
     712:	8082                	ret
            printf("invalid name for EDNS\n");
     714:	00001517          	auipc	a0,0x1
     718:	b0c50513          	addi	a0,a0,-1268 # 1220 <malloc+0x28e>
     71c:	00000097          	auipc	ra,0x0
     720:	7be080e7          	jalr	1982(ra) # eda <printf>
            exit(1);
     724:	4505                	li	a0,1
     726:	00000097          	auipc	ra,0x0
     72a:	42a080e7          	jalr	1066(ra) # b50 <exit>
            printf("invalid type for EDNS\n");
     72e:	00001517          	auipc	a0,0x1
     732:	b0a50513          	addi	a0,a0,-1270 # 1238 <malloc+0x2a6>
     736:	00000097          	auipc	ra,0x0
     73a:	7a4080e7          	jalr	1956(ra) # eda <printf>
            exit(1);
     73e:	4505                	li	a0,1
     740:	00000097          	auipc	ra,0x0
     744:	410080e7          	jalr	1040(ra) # b50 <exit>
        printf("Processed %d data bytes but received %d\n", len, cc);
     748:	8652                	mv	a2,s4
     74a:	85a6                	mv	a1,s1
     74c:	00001517          	auipc	a0,0x1
     750:	b0450513          	addi	a0,a0,-1276 # 1250 <malloc+0x2be>
     754:	00000097          	auipc	ra,0x0
     758:	786080e7          	jalr	1926(ra) # eda <printf>
        exit(1);
     75c:	4505                	li	a0,1
     75e:	00000097          	auipc	ra,0x0
     762:	3f2080e7          	jalr	1010(ra) # b50 <exit>
        printf("Didn't receive an arecord\n");
     766:	00001517          	auipc	a0,0x1
     76a:	b1a50513          	addi	a0,a0,-1254 # 1280 <malloc+0x2ee>
     76e:	00000097          	auipc	ra,0x0
     772:	76c080e7          	jalr	1900(ra) # eda <printf>
        exit(1);
     776:	4505                	li	a0,1
     778:	00000097          	auipc	ra,0x0
     77c:	3d8080e7          	jalr	984(ra) # b50 <exit>

0000000000000780 <main>:

int main(int argc, char *argv[])
{
     780:	7179                	addi	sp,sp,-48
     782:	f406                	sd	ra,40(sp)
     784:	f022                	sd	s0,32(sp)
     786:	ec26                	sd	s1,24(sp)
     788:	e84a                	sd	s2,16(sp)
     78a:	1800                	addi	s0,sp,48
    int i, ret;
    uint16 dport = NET_TESTS_PORT;

    printf("nettests running on port %d\n", dport);
     78c:	6499                	lui	s1,0x6
     78e:	20b48593          	addi	a1,s1,523 # 620b <base+0x41fb>
     792:	00001517          	auipc	a0,0x1
     796:	b0e50513          	addi	a0,a0,-1266 # 12a0 <malloc+0x30e>
     79a:	00000097          	auipc	ra,0x0
     79e:	740080e7          	jalr	1856(ra) # eda <printf>

    printf("testing ping: ");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	b1e50513          	addi	a0,a0,-1250 # 12c0 <malloc+0x32e>
     7aa:	00000097          	auipc	ra,0x0
     7ae:	730080e7          	jalr	1840(ra) # eda <printf>
    ping(2000, dport, 1);
     7b2:	4605                	li	a2,1
     7b4:	20b48593          	addi	a1,s1,523
     7b8:	7d000513          	li	a0,2000
     7bc:	00000097          	auipc	ra,0x0
     7c0:	89e080e7          	jalr	-1890(ra) # 5a <ping>
    printf("OK\n");
     7c4:	00001517          	auipc	a0,0x1
     7c8:	b0c50513          	addi	a0,a0,-1268 # 12d0 <malloc+0x33e>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	70e080e7          	jalr	1806(ra) # eda <printf>

    printf("testing single-process pings: ");
     7d4:	00001517          	auipc	a0,0x1
     7d8:	b0450513          	addi	a0,a0,-1276 # 12d8 <malloc+0x346>
     7dc:	00000097          	auipc	ra,0x0
     7e0:	6fe080e7          	jalr	1790(ra) # eda <printf>
     7e4:	06400493          	li	s1,100
    for (i = 0; i < 100; i++)
        ping(2000, dport, 1);
     7e8:	6919                	lui	s2,0x6
     7ea:	20b90913          	addi	s2,s2,523 # 620b <base+0x41fb>
     7ee:	4605                	li	a2,1
     7f0:	85ca                	mv	a1,s2
     7f2:	7d000513          	li	a0,2000
     7f6:	00000097          	auipc	ra,0x0
     7fa:	864080e7          	jalr	-1948(ra) # 5a <ping>
    for (i = 0; i < 100; i++)
     7fe:	34fd                	addiw	s1,s1,-1
     800:	f4fd                	bnez	s1,7ee <main+0x6e>
    printf("OK\n");
     802:	00001517          	auipc	a0,0x1
     806:	ace50513          	addi	a0,a0,-1330 # 12d0 <malloc+0x33e>
     80a:	00000097          	auipc	ra,0x0
     80e:	6d0080e7          	jalr	1744(ra) # eda <printf>

    printf("testing multi-process pings: ");
     812:	00001517          	auipc	a0,0x1
     816:	ae650513          	addi	a0,a0,-1306 # 12f8 <malloc+0x366>
     81a:	00000097          	auipc	ra,0x0
     81e:	6c0080e7          	jalr	1728(ra) # eda <printf>
    for (i = 0; i < 10; i++) {
     822:	4929                	li	s2,10
        int pid = fork();
     824:	00000097          	auipc	ra,0x0
     828:	324080e7          	jalr	804(ra) # b48 <fork>
        if (pid == 0) {
     82c:	c92d                	beqz	a0,89e <main+0x11e>
    for (i = 0; i < 10; i++) {
     82e:	2485                	addiw	s1,s1,1
     830:	ff249ae3          	bne	s1,s2,824 <main+0xa4>
     834:	44a9                	li	s1,10
            ping(2000 + i + 1, dport, 1);
            exit(0);
        }
    }
    for (i = 0; i < 10; i++) {
        wait(&ret);
     836:	fdc40513          	addi	a0,s0,-36
     83a:	00000097          	auipc	ra,0x0
     83e:	31e080e7          	jalr	798(ra) # b58 <wait>
        if (ret != 0)
     842:	fdc42783          	lw	a5,-36(s0)
     846:	efad                	bnez	a5,8c0 <main+0x140>
    for (i = 0; i < 10; i++) {
     848:	34fd                	addiw	s1,s1,-1
     84a:	f4f5                	bnez	s1,836 <main+0xb6>
            exit(1);
    }
    printf("OK\n");
     84c:	00001517          	auipc	a0,0x1
     850:	a8450513          	addi	a0,a0,-1404 # 12d0 <malloc+0x33e>
     854:	00000097          	auipc	ra,0x0
     858:	686080e7          	jalr	1670(ra) # eda <printf>

    printf("testing DNS\n");
     85c:	00001517          	auipc	a0,0x1
     860:	abc50513          	addi	a0,a0,-1348 # 1318 <malloc+0x386>
     864:	00000097          	auipc	ra,0x0
     868:	676080e7          	jalr	1654(ra) # eda <printf>
    dns();
     86c:	00000097          	auipc	ra,0x0
     870:	910080e7          	jalr	-1776(ra) # 17c <dns>
    printf("DNS OK\n");
     874:	00001517          	auipc	a0,0x1
     878:	ab450513          	addi	a0,a0,-1356 # 1328 <malloc+0x396>
     87c:	00000097          	auipc	ra,0x0
     880:	65e080e7          	jalr	1630(ra) # eda <printf>

    printf("all tests passed.\n");
     884:	00001517          	auipc	a0,0x1
     888:	aac50513          	addi	a0,a0,-1364 # 1330 <malloc+0x39e>
     88c:	00000097          	auipc	ra,0x0
     890:	64e080e7          	jalr	1614(ra) # eda <printf>
    exit(0);
     894:	4501                	li	a0,0
     896:	00000097          	auipc	ra,0x0
     89a:	2ba080e7          	jalr	698(ra) # b50 <exit>
            ping(2000 + i + 1, dport, 1);
     89e:	7d14851b          	addiw	a0,s1,2001
     8a2:	4605                	li	a2,1
     8a4:	6599                	lui	a1,0x6
     8a6:	20b58593          	addi	a1,a1,523 # 620b <base+0x41fb>
     8aa:	1542                	slli	a0,a0,0x30
     8ac:	9141                	srli	a0,a0,0x30
     8ae:	fffff097          	auipc	ra,0xfffff
     8b2:	7ac080e7          	jalr	1964(ra) # 5a <ping>
            exit(0);
     8b6:	4501                	li	a0,0
     8b8:	00000097          	auipc	ra,0x0
     8bc:	298080e7          	jalr	664(ra) # b50 <exit>
            exit(1);
     8c0:	4505                	li	a0,1
     8c2:	00000097          	auipc	ra,0x0
     8c6:	28e080e7          	jalr	654(ra) # b50 <exit>

00000000000008ca <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     8ca:	1141                	addi	sp,sp,-16
     8cc:	e406                	sd	ra,8(sp)
     8ce:	e022                	sd	s0,0(sp)
     8d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8d2:	00000097          	auipc	ra,0x0
     8d6:	eae080e7          	jalr	-338(ra) # 780 <main>
  exit(0);
     8da:	4501                	li	a0,0
     8dc:	00000097          	auipc	ra,0x0
     8e0:	274080e7          	jalr	628(ra) # b50 <exit>

00000000000008e4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8e4:	1141                	addi	sp,sp,-16
     8e6:	e422                	sd	s0,8(sp)
     8e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8ea:	87aa                	mv	a5,a0
     8ec:	0585                	addi	a1,a1,1
     8ee:	0785                	addi	a5,a5,1
     8f0:	fff5c703          	lbu	a4,-1(a1)
     8f4:	fee78fa3          	sb	a4,-1(a5)
     8f8:	fb75                	bnez	a4,8ec <strcpy+0x8>
    ;
  return os;
}
     8fa:	6422                	ld	s0,8(sp)
     8fc:	0141                	addi	sp,sp,16
     8fe:	8082                	ret

0000000000000900 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     900:	1141                	addi	sp,sp,-16
     902:	e422                	sd	s0,8(sp)
     904:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     906:	00054783          	lbu	a5,0(a0)
     90a:	cb91                	beqz	a5,91e <strcmp+0x1e>
     90c:	0005c703          	lbu	a4,0(a1)
     910:	00f71763          	bne	a4,a5,91e <strcmp+0x1e>
    p++, q++;
     914:	0505                	addi	a0,a0,1
     916:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     918:	00054783          	lbu	a5,0(a0)
     91c:	fbe5                	bnez	a5,90c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     91e:	0005c503          	lbu	a0,0(a1)
}
     922:	40a7853b          	subw	a0,a5,a0
     926:	6422                	ld	s0,8(sp)
     928:	0141                	addi	sp,sp,16
     92a:	8082                	ret

000000000000092c <strlen>:

uint
strlen(const char *s)
{
     92c:	1141                	addi	sp,sp,-16
     92e:	e422                	sd	s0,8(sp)
     930:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     932:	00054783          	lbu	a5,0(a0)
     936:	cf91                	beqz	a5,952 <strlen+0x26>
     938:	0505                	addi	a0,a0,1
     93a:	87aa                	mv	a5,a0
     93c:	4685                	li	a3,1
     93e:	9e89                	subw	a3,a3,a0
     940:	00f6853b          	addw	a0,a3,a5
     944:	0785                	addi	a5,a5,1
     946:	fff7c703          	lbu	a4,-1(a5)
     94a:	fb7d                	bnez	a4,940 <strlen+0x14>
    ;
  return n;
}
     94c:	6422                	ld	s0,8(sp)
     94e:	0141                	addi	sp,sp,16
     950:	8082                	ret
  for(n = 0; s[n]; n++)
     952:	4501                	li	a0,0
     954:	bfe5                	j	94c <strlen+0x20>

0000000000000956 <memset>:

void*
memset(void *dst, int c, uint n)
{
     956:	1141                	addi	sp,sp,-16
     958:	e422                	sd	s0,8(sp)
     95a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     95c:	ca19                	beqz	a2,972 <memset+0x1c>
     95e:	87aa                	mv	a5,a0
     960:	1602                	slli	a2,a2,0x20
     962:	9201                	srli	a2,a2,0x20
     964:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     968:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     96c:	0785                	addi	a5,a5,1
     96e:	fee79de3          	bne	a5,a4,968 <memset+0x12>
  }
  return dst;
}
     972:	6422                	ld	s0,8(sp)
     974:	0141                	addi	sp,sp,16
     976:	8082                	ret

0000000000000978 <strchr>:

char*
strchr(const char *s, char c)
{
     978:	1141                	addi	sp,sp,-16
     97a:	e422                	sd	s0,8(sp)
     97c:	0800                	addi	s0,sp,16
  for(; *s; s++)
     97e:	00054783          	lbu	a5,0(a0)
     982:	cb99                	beqz	a5,998 <strchr+0x20>
    if(*s == c)
     984:	00f58763          	beq	a1,a5,992 <strchr+0x1a>
  for(; *s; s++)
     988:	0505                	addi	a0,a0,1
     98a:	00054783          	lbu	a5,0(a0)
     98e:	fbfd                	bnez	a5,984 <strchr+0xc>
      return (char*)s;
  return 0;
     990:	4501                	li	a0,0
}
     992:	6422                	ld	s0,8(sp)
     994:	0141                	addi	sp,sp,16
     996:	8082                	ret
  return 0;
     998:	4501                	li	a0,0
     99a:	bfe5                	j	992 <strchr+0x1a>

000000000000099c <gets>:

char*
gets(char *buf, int max)
{
     99c:	711d                	addi	sp,sp,-96
     99e:	ec86                	sd	ra,88(sp)
     9a0:	e8a2                	sd	s0,80(sp)
     9a2:	e4a6                	sd	s1,72(sp)
     9a4:	e0ca                	sd	s2,64(sp)
     9a6:	fc4e                	sd	s3,56(sp)
     9a8:	f852                	sd	s4,48(sp)
     9aa:	f456                	sd	s5,40(sp)
     9ac:	f05a                	sd	s6,32(sp)
     9ae:	ec5e                	sd	s7,24(sp)
     9b0:	1080                	addi	s0,sp,96
     9b2:	8baa                	mv	s7,a0
     9b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9b6:	892a                	mv	s2,a0
     9b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9ba:	4aa9                	li	s5,10
     9bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9be:	89a6                	mv	s3,s1
     9c0:	2485                	addiw	s1,s1,1
     9c2:	0344d863          	bge	s1,s4,9f2 <gets+0x56>
    cc = read(0, &c, 1);
     9c6:	4605                	li	a2,1
     9c8:	faf40593          	addi	a1,s0,-81
     9cc:	4501                	li	a0,0
     9ce:	00000097          	auipc	ra,0x0
     9d2:	19a080e7          	jalr	410(ra) # b68 <read>
    if(cc < 1)
     9d6:	00a05e63          	blez	a0,9f2 <gets+0x56>
    buf[i++] = c;
     9da:	faf44783          	lbu	a5,-81(s0)
     9de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9e2:	01578763          	beq	a5,s5,9f0 <gets+0x54>
     9e6:	0905                	addi	s2,s2,1
     9e8:	fd679be3          	bne	a5,s6,9be <gets+0x22>
  for(i=0; i+1 < max; ){
     9ec:	89a6                	mv	s3,s1
     9ee:	a011                	j	9f2 <gets+0x56>
     9f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9f2:	99de                	add	s3,s3,s7
     9f4:	00098023          	sb	zero,0(s3)
  return buf;
}
     9f8:	855e                	mv	a0,s7
     9fa:	60e6                	ld	ra,88(sp)
     9fc:	6446                	ld	s0,80(sp)
     9fe:	64a6                	ld	s1,72(sp)
     a00:	6906                	ld	s2,64(sp)
     a02:	79e2                	ld	s3,56(sp)
     a04:	7a42                	ld	s4,48(sp)
     a06:	7aa2                	ld	s5,40(sp)
     a08:	7b02                	ld	s6,32(sp)
     a0a:	6be2                	ld	s7,24(sp)
     a0c:	6125                	addi	sp,sp,96
     a0e:	8082                	ret

0000000000000a10 <stat>:

int
stat(const char *n, struct stat *st)
{
     a10:	1101                	addi	sp,sp,-32
     a12:	ec06                	sd	ra,24(sp)
     a14:	e822                	sd	s0,16(sp)
     a16:	e426                	sd	s1,8(sp)
     a18:	e04a                	sd	s2,0(sp)
     a1a:	1000                	addi	s0,sp,32
     a1c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a1e:	4581                	li	a1,0
     a20:	00000097          	auipc	ra,0x0
     a24:	170080e7          	jalr	368(ra) # b90 <open>
  if(fd < 0)
     a28:	02054563          	bltz	a0,a52 <stat+0x42>
     a2c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a2e:	85ca                	mv	a1,s2
     a30:	00000097          	auipc	ra,0x0
     a34:	178080e7          	jalr	376(ra) # ba8 <fstat>
     a38:	892a                	mv	s2,a0
  close(fd);
     a3a:	8526                	mv	a0,s1
     a3c:	00000097          	auipc	ra,0x0
     a40:	13c080e7          	jalr	316(ra) # b78 <close>
  return r;
}
     a44:	854a                	mv	a0,s2
     a46:	60e2                	ld	ra,24(sp)
     a48:	6442                	ld	s0,16(sp)
     a4a:	64a2                	ld	s1,8(sp)
     a4c:	6902                	ld	s2,0(sp)
     a4e:	6105                	addi	sp,sp,32
     a50:	8082                	ret
    return -1;
     a52:	597d                	li	s2,-1
     a54:	bfc5                	j	a44 <stat+0x34>

0000000000000a56 <atoi>:

int
atoi(const char *s)
{
     a56:	1141                	addi	sp,sp,-16
     a58:	e422                	sd	s0,8(sp)
     a5a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a5c:	00054683          	lbu	a3,0(a0)
     a60:	fd06879b          	addiw	a5,a3,-48
     a64:	0ff7f793          	zext.b	a5,a5
     a68:	4625                	li	a2,9
     a6a:	02f66863          	bltu	a2,a5,a9a <atoi+0x44>
     a6e:	872a                	mv	a4,a0
  n = 0;
     a70:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a72:	0705                	addi	a4,a4,1
     a74:	0025179b          	slliw	a5,a0,0x2
     a78:	9fa9                	addw	a5,a5,a0
     a7a:	0017979b          	slliw	a5,a5,0x1
     a7e:	9fb5                	addw	a5,a5,a3
     a80:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a84:	00074683          	lbu	a3,0(a4)
     a88:	fd06879b          	addiw	a5,a3,-48
     a8c:	0ff7f793          	zext.b	a5,a5
     a90:	fef671e3          	bgeu	a2,a5,a72 <atoi+0x1c>
  return n;
}
     a94:	6422                	ld	s0,8(sp)
     a96:	0141                	addi	sp,sp,16
     a98:	8082                	ret
  n = 0;
     a9a:	4501                	li	a0,0
     a9c:	bfe5                	j	a94 <atoi+0x3e>

0000000000000a9e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a9e:	1141                	addi	sp,sp,-16
     aa0:	e422                	sd	s0,8(sp)
     aa2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aa4:	02b57463          	bgeu	a0,a1,acc <memmove+0x2e>
    while(n-- > 0)
     aa8:	00c05f63          	blez	a2,ac6 <memmove+0x28>
     aac:	1602                	slli	a2,a2,0x20
     aae:	9201                	srli	a2,a2,0x20
     ab0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ab4:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab6:	0585                	addi	a1,a1,1
     ab8:	0705                	addi	a4,a4,1
     aba:	fff5c683          	lbu	a3,-1(a1)
     abe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ac2:	fee79ae3          	bne	a5,a4,ab6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac6:	6422                	ld	s0,8(sp)
     ac8:	0141                	addi	sp,sp,16
     aca:	8082                	ret
    dst += n;
     acc:	00c50733          	add	a4,a0,a2
    src += n;
     ad0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ad2:	fec05ae3          	blez	a2,ac6 <memmove+0x28>
     ad6:	fff6079b          	addiw	a5,a2,-1
     ada:	1782                	slli	a5,a5,0x20
     adc:	9381                	srli	a5,a5,0x20
     ade:	fff7c793          	not	a5,a5
     ae2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ae4:	15fd                	addi	a1,a1,-1
     ae6:	177d                	addi	a4,a4,-1
     ae8:	0005c683          	lbu	a3,0(a1)
     aec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     af0:	fee79ae3          	bne	a5,a4,ae4 <memmove+0x46>
     af4:	bfc9                	j	ac6 <memmove+0x28>

0000000000000af6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af6:	1141                	addi	sp,sp,-16
     af8:	e422                	sd	s0,8(sp)
     afa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     afc:	ca05                	beqz	a2,b2c <memcmp+0x36>
     afe:	fff6069b          	addiw	a3,a2,-1
     b02:	1682                	slli	a3,a3,0x20
     b04:	9281                	srli	a3,a3,0x20
     b06:	0685                	addi	a3,a3,1
     b08:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b0a:	00054783          	lbu	a5,0(a0)
     b0e:	0005c703          	lbu	a4,0(a1)
     b12:	00e79863          	bne	a5,a4,b22 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b16:	0505                	addi	a0,a0,1
    p2++;
     b18:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b1a:	fed518e3          	bne	a0,a3,b0a <memcmp+0x14>
  }
  return 0;
     b1e:	4501                	li	a0,0
     b20:	a019                	j	b26 <memcmp+0x30>
      return *p1 - *p2;
     b22:	40e7853b          	subw	a0,a5,a4
}
     b26:	6422                	ld	s0,8(sp)
     b28:	0141                	addi	sp,sp,16
     b2a:	8082                	ret
  return 0;
     b2c:	4501                	li	a0,0
     b2e:	bfe5                	j	b26 <memcmp+0x30>

0000000000000b30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b30:	1141                	addi	sp,sp,-16
     b32:	e406                	sd	ra,8(sp)
     b34:	e022                	sd	s0,0(sp)
     b36:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b38:	00000097          	auipc	ra,0x0
     b3c:	f66080e7          	jalr	-154(ra) # a9e <memmove>
}
     b40:	60a2                	ld	ra,8(sp)
     b42:	6402                	ld	s0,0(sp)
     b44:	0141                	addi	sp,sp,16
     b46:	8082                	ret

0000000000000b48 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b48:	4885                	li	a7,1
 ecall
     b4a:	00000073          	ecall
 ret
     b4e:	8082                	ret

0000000000000b50 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b50:	4889                	li	a7,2
 ecall
     b52:	00000073          	ecall
 ret
     b56:	8082                	ret

0000000000000b58 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b58:	488d                	li	a7,3
 ecall
     b5a:	00000073          	ecall
 ret
     b5e:	8082                	ret

0000000000000b60 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b60:	4891                	li	a7,4
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <read>:
.global read
read:
 li a7, SYS_read
     b68:	4895                	li	a7,5
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <write>:
.global write
write:
 li a7, SYS_write
     b70:	48c1                	li	a7,16
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <close>:
.global close
close:
 li a7, SYS_close
     b78:	48d5                	li	a7,21
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b80:	4899                	li	a7,6
 ecall
     b82:	00000073          	ecall
 ret
     b86:	8082                	ret

0000000000000b88 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b88:	489d                	li	a7,7
 ecall
     b8a:	00000073          	ecall
 ret
     b8e:	8082                	ret

0000000000000b90 <open>:
.global open
open:
 li a7, SYS_open
     b90:	48bd                	li	a7,15
 ecall
     b92:	00000073          	ecall
 ret
     b96:	8082                	ret

0000000000000b98 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b98:	48c5                	li	a7,17
 ecall
     b9a:	00000073          	ecall
 ret
     b9e:	8082                	ret

0000000000000ba0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ba0:	48c9                	li	a7,18
 ecall
     ba2:	00000073          	ecall
 ret
     ba6:	8082                	ret

0000000000000ba8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ba8:	48a1                	li	a7,8
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <link>:
.global link
link:
 li a7, SYS_link
     bb0:	48cd                	li	a7,19
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bb8:	48d1                	li	a7,20
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bc0:	48a5                	li	a7,9
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bc8:	48a9                	li	a7,10
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bd0:	48ad                	li	a7,11
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bd8:	48b1                	li	a7,12
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     be0:	48b5                	li	a7,13
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     be8:	48b9                	li	a7,14
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <connect>:
.global connect
connect:
 li a7, SYS_connect
     bf0:	48f5                	li	a7,29
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     bf8:	48f9                	li	a7,30
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c00:	1101                	addi	sp,sp,-32
     c02:	ec06                	sd	ra,24(sp)
     c04:	e822                	sd	s0,16(sp)
     c06:	1000                	addi	s0,sp,32
     c08:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c0c:	4605                	li	a2,1
     c0e:	fef40593          	addi	a1,s0,-17
     c12:	00000097          	auipc	ra,0x0
     c16:	f5e080e7          	jalr	-162(ra) # b70 <write>
}
     c1a:	60e2                	ld	ra,24(sp)
     c1c:	6442                	ld	s0,16(sp)
     c1e:	6105                	addi	sp,sp,32
     c20:	8082                	ret

0000000000000c22 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c22:	7139                	addi	sp,sp,-64
     c24:	fc06                	sd	ra,56(sp)
     c26:	f822                	sd	s0,48(sp)
     c28:	f426                	sd	s1,40(sp)
     c2a:	f04a                	sd	s2,32(sp)
     c2c:	ec4e                	sd	s3,24(sp)
     c2e:	0080                	addi	s0,sp,64
     c30:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c32:	c299                	beqz	a3,c38 <printint+0x16>
     c34:	0805c963          	bltz	a1,cc6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c38:	2581                	sext.w	a1,a1
  neg = 0;
     c3a:	4881                	li	a7,0
     c3c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c40:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c42:	2601                	sext.w	a2,a2
     c44:	00000517          	auipc	a0,0x0
     c48:	76450513          	addi	a0,a0,1892 # 13a8 <digits>
     c4c:	883a                	mv	a6,a4
     c4e:	2705                	addiw	a4,a4,1
     c50:	02c5f7bb          	remuw	a5,a1,a2
     c54:	1782                	slli	a5,a5,0x20
     c56:	9381                	srli	a5,a5,0x20
     c58:	97aa                	add	a5,a5,a0
     c5a:	0007c783          	lbu	a5,0(a5)
     c5e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c62:	0005879b          	sext.w	a5,a1
     c66:	02c5d5bb          	divuw	a1,a1,a2
     c6a:	0685                	addi	a3,a3,1
     c6c:	fec7f0e3          	bgeu	a5,a2,c4c <printint+0x2a>
  if(neg)
     c70:	00088c63          	beqz	a7,c88 <printint+0x66>
    buf[i++] = '-';
     c74:	fd070793          	addi	a5,a4,-48
     c78:	00878733          	add	a4,a5,s0
     c7c:	02d00793          	li	a5,45
     c80:	fef70823          	sb	a5,-16(a4)
     c84:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c88:	02e05863          	blez	a4,cb8 <printint+0x96>
     c8c:	fc040793          	addi	a5,s0,-64
     c90:	00e78933          	add	s2,a5,a4
     c94:	fff78993          	addi	s3,a5,-1
     c98:	99ba                	add	s3,s3,a4
     c9a:	377d                	addiw	a4,a4,-1
     c9c:	1702                	slli	a4,a4,0x20
     c9e:	9301                	srli	a4,a4,0x20
     ca0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ca4:	fff94583          	lbu	a1,-1(s2)
     ca8:	8526                	mv	a0,s1
     caa:	00000097          	auipc	ra,0x0
     cae:	f56080e7          	jalr	-170(ra) # c00 <putc>
  while(--i >= 0)
     cb2:	197d                	addi	s2,s2,-1
     cb4:	ff3918e3          	bne	s2,s3,ca4 <printint+0x82>
}
     cb8:	70e2                	ld	ra,56(sp)
     cba:	7442                	ld	s0,48(sp)
     cbc:	74a2                	ld	s1,40(sp)
     cbe:	7902                	ld	s2,32(sp)
     cc0:	69e2                	ld	s3,24(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
    x = -xx;
     cc6:	40b005bb          	negw	a1,a1
    neg = 1;
     cca:	4885                	li	a7,1
    x = -xx;
     ccc:	bf85                	j	c3c <printint+0x1a>

0000000000000cce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cce:	7119                	addi	sp,sp,-128
     cd0:	fc86                	sd	ra,120(sp)
     cd2:	f8a2                	sd	s0,112(sp)
     cd4:	f4a6                	sd	s1,104(sp)
     cd6:	f0ca                	sd	s2,96(sp)
     cd8:	ecce                	sd	s3,88(sp)
     cda:	e8d2                	sd	s4,80(sp)
     cdc:	e4d6                	sd	s5,72(sp)
     cde:	e0da                	sd	s6,64(sp)
     ce0:	fc5e                	sd	s7,56(sp)
     ce2:	f862                	sd	s8,48(sp)
     ce4:	f466                	sd	s9,40(sp)
     ce6:	f06a                	sd	s10,32(sp)
     ce8:	ec6e                	sd	s11,24(sp)
     cea:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cec:	0005c903          	lbu	s2,0(a1)
     cf0:	18090f63          	beqz	s2,e8e <vprintf+0x1c0>
     cf4:	8aaa                	mv	s5,a0
     cf6:	8b32                	mv	s6,a2
     cf8:	00158493          	addi	s1,a1,1
  state = 0;
     cfc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     cfe:	02500a13          	li	s4,37
     d02:	4c55                	li	s8,21
     d04:	00000c97          	auipc	s9,0x0
     d08:	64cc8c93          	addi	s9,s9,1612 # 1350 <malloc+0x3be>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     d0c:	02800d93          	li	s11,40
  putc(fd, 'x');
     d10:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d12:	00000b97          	auipc	s7,0x0
     d16:	696b8b93          	addi	s7,s7,1686 # 13a8 <digits>
     d1a:	a839                	j	d38 <vprintf+0x6a>
        putc(fd, c);
     d1c:	85ca                	mv	a1,s2
     d1e:	8556                	mv	a0,s5
     d20:	00000097          	auipc	ra,0x0
     d24:	ee0080e7          	jalr	-288(ra) # c00 <putc>
     d28:	a019                	j	d2e <vprintf+0x60>
    } else if(state == '%'){
     d2a:	01498d63          	beq	s3,s4,d44 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     d2e:	0485                	addi	s1,s1,1
     d30:	fff4c903          	lbu	s2,-1(s1)
     d34:	14090d63          	beqz	s2,e8e <vprintf+0x1c0>
    if(state == 0){
     d38:	fe0999e3          	bnez	s3,d2a <vprintf+0x5c>
      if(c == '%'){
     d3c:	ff4910e3          	bne	s2,s4,d1c <vprintf+0x4e>
        state = '%';
     d40:	89d2                	mv	s3,s4
     d42:	b7f5                	j	d2e <vprintf+0x60>
      if(c == 'd'){
     d44:	11490c63          	beq	s2,s4,e5c <vprintf+0x18e>
     d48:	f9d9079b          	addiw	a5,s2,-99
     d4c:	0ff7f793          	zext.b	a5,a5
     d50:	10fc6e63          	bltu	s8,a5,e6c <vprintf+0x19e>
     d54:	f9d9079b          	addiw	a5,s2,-99
     d58:	0ff7f713          	zext.b	a4,a5
     d5c:	10ec6863          	bltu	s8,a4,e6c <vprintf+0x19e>
     d60:	00271793          	slli	a5,a4,0x2
     d64:	97e6                	add	a5,a5,s9
     d66:	439c                	lw	a5,0(a5)
     d68:	97e6                	add	a5,a5,s9
     d6a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d6c:	008b0913          	addi	s2,s6,8
     d70:	4685                	li	a3,1
     d72:	4629                	li	a2,10
     d74:	000b2583          	lw	a1,0(s6)
     d78:	8556                	mv	a0,s5
     d7a:	00000097          	auipc	ra,0x0
     d7e:	ea8080e7          	jalr	-344(ra) # c22 <printint>
     d82:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d84:	4981                	li	s3,0
     d86:	b765                	j	d2e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d88:	008b0913          	addi	s2,s6,8
     d8c:	4681                	li	a3,0
     d8e:	4629                	li	a2,10
     d90:	000b2583          	lw	a1,0(s6)
     d94:	8556                	mv	a0,s5
     d96:	00000097          	auipc	ra,0x0
     d9a:	e8c080e7          	jalr	-372(ra) # c22 <printint>
     d9e:	8b4a                	mv	s6,s2
      state = 0;
     da0:	4981                	li	s3,0
     da2:	b771                	j	d2e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     da4:	008b0913          	addi	s2,s6,8
     da8:	4681                	li	a3,0
     daa:	866a                	mv	a2,s10
     dac:	000b2583          	lw	a1,0(s6)
     db0:	8556                	mv	a0,s5
     db2:	00000097          	auipc	ra,0x0
     db6:	e70080e7          	jalr	-400(ra) # c22 <printint>
     dba:	8b4a                	mv	s6,s2
      state = 0;
     dbc:	4981                	li	s3,0
     dbe:	bf85                	j	d2e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     dc0:	008b0793          	addi	a5,s6,8
     dc4:	f8f43423          	sd	a5,-120(s0)
     dc8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     dcc:	03000593          	li	a1,48
     dd0:	8556                	mv	a0,s5
     dd2:	00000097          	auipc	ra,0x0
     dd6:	e2e080e7          	jalr	-466(ra) # c00 <putc>
  putc(fd, 'x');
     dda:	07800593          	li	a1,120
     dde:	8556                	mv	a0,s5
     de0:	00000097          	auipc	ra,0x0
     de4:	e20080e7          	jalr	-480(ra) # c00 <putc>
     de8:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dea:	03c9d793          	srli	a5,s3,0x3c
     dee:	97de                	add	a5,a5,s7
     df0:	0007c583          	lbu	a1,0(a5)
     df4:	8556                	mv	a0,s5
     df6:	00000097          	auipc	ra,0x0
     dfa:	e0a080e7          	jalr	-502(ra) # c00 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     dfe:	0992                	slli	s3,s3,0x4
     e00:	397d                	addiw	s2,s2,-1
     e02:	fe0914e3          	bnez	s2,dea <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     e06:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e0a:	4981                	li	s3,0
     e0c:	b70d                	j	d2e <vprintf+0x60>
        s = va_arg(ap, char*);
     e0e:	008b0913          	addi	s2,s6,8
     e12:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     e16:	02098163          	beqz	s3,e38 <vprintf+0x16a>
        while(*s != 0){
     e1a:	0009c583          	lbu	a1,0(s3)
     e1e:	c5ad                	beqz	a1,e88 <vprintf+0x1ba>
          putc(fd, *s);
     e20:	8556                	mv	a0,s5
     e22:	00000097          	auipc	ra,0x0
     e26:	dde080e7          	jalr	-546(ra) # c00 <putc>
          s++;
     e2a:	0985                	addi	s3,s3,1
        while(*s != 0){
     e2c:	0009c583          	lbu	a1,0(s3)
     e30:	f9e5                	bnez	a1,e20 <vprintf+0x152>
        s = va_arg(ap, char*);
     e32:	8b4a                	mv	s6,s2
      state = 0;
     e34:	4981                	li	s3,0
     e36:	bde5                	j	d2e <vprintf+0x60>
          s = "(null)";
     e38:	00000997          	auipc	s3,0x0
     e3c:	51098993          	addi	s3,s3,1296 # 1348 <malloc+0x3b6>
        while(*s != 0){
     e40:	85ee                	mv	a1,s11
     e42:	bff9                	j	e20 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     e44:	008b0913          	addi	s2,s6,8
     e48:	000b4583          	lbu	a1,0(s6)
     e4c:	8556                	mv	a0,s5
     e4e:	00000097          	auipc	ra,0x0
     e52:	db2080e7          	jalr	-590(ra) # c00 <putc>
     e56:	8b4a                	mv	s6,s2
      state = 0;
     e58:	4981                	li	s3,0
     e5a:	bdd1                	j	d2e <vprintf+0x60>
        putc(fd, c);
     e5c:	85d2                	mv	a1,s4
     e5e:	8556                	mv	a0,s5
     e60:	00000097          	auipc	ra,0x0
     e64:	da0080e7          	jalr	-608(ra) # c00 <putc>
      state = 0;
     e68:	4981                	li	s3,0
     e6a:	b5d1                	j	d2e <vprintf+0x60>
        putc(fd, '%');
     e6c:	85d2                	mv	a1,s4
     e6e:	8556                	mv	a0,s5
     e70:	00000097          	auipc	ra,0x0
     e74:	d90080e7          	jalr	-624(ra) # c00 <putc>
        putc(fd, c);
     e78:	85ca                	mv	a1,s2
     e7a:	8556                	mv	a0,s5
     e7c:	00000097          	auipc	ra,0x0
     e80:	d84080e7          	jalr	-636(ra) # c00 <putc>
      state = 0;
     e84:	4981                	li	s3,0
     e86:	b565                	j	d2e <vprintf+0x60>
        s = va_arg(ap, char*);
     e88:	8b4a                	mv	s6,s2
      state = 0;
     e8a:	4981                	li	s3,0
     e8c:	b54d                	j	d2e <vprintf+0x60>
    }
  }
}
     e8e:	70e6                	ld	ra,120(sp)
     e90:	7446                	ld	s0,112(sp)
     e92:	74a6                	ld	s1,104(sp)
     e94:	7906                	ld	s2,96(sp)
     e96:	69e6                	ld	s3,88(sp)
     e98:	6a46                	ld	s4,80(sp)
     e9a:	6aa6                	ld	s5,72(sp)
     e9c:	6b06                	ld	s6,64(sp)
     e9e:	7be2                	ld	s7,56(sp)
     ea0:	7c42                	ld	s8,48(sp)
     ea2:	7ca2                	ld	s9,40(sp)
     ea4:	7d02                	ld	s10,32(sp)
     ea6:	6de2                	ld	s11,24(sp)
     ea8:	6109                	addi	sp,sp,128
     eaa:	8082                	ret

0000000000000eac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eac:	715d                	addi	sp,sp,-80
     eae:	ec06                	sd	ra,24(sp)
     eb0:	e822                	sd	s0,16(sp)
     eb2:	1000                	addi	s0,sp,32
     eb4:	e010                	sd	a2,0(s0)
     eb6:	e414                	sd	a3,8(s0)
     eb8:	e818                	sd	a4,16(s0)
     eba:	ec1c                	sd	a5,24(s0)
     ebc:	03043023          	sd	a6,32(s0)
     ec0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ec4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ec8:	8622                	mv	a2,s0
     eca:	00000097          	auipc	ra,0x0
     ece:	e04080e7          	jalr	-508(ra) # cce <vprintf>
}
     ed2:	60e2                	ld	ra,24(sp)
     ed4:	6442                	ld	s0,16(sp)
     ed6:	6161                	addi	sp,sp,80
     ed8:	8082                	ret

0000000000000eda <printf>:

void
printf(const char *fmt, ...)
{
     eda:	711d                	addi	sp,sp,-96
     edc:	ec06                	sd	ra,24(sp)
     ede:	e822                	sd	s0,16(sp)
     ee0:	1000                	addi	s0,sp,32
     ee2:	e40c                	sd	a1,8(s0)
     ee4:	e810                	sd	a2,16(s0)
     ee6:	ec14                	sd	a3,24(s0)
     ee8:	f018                	sd	a4,32(s0)
     eea:	f41c                	sd	a5,40(s0)
     eec:	03043823          	sd	a6,48(s0)
     ef0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ef4:	00840613          	addi	a2,s0,8
     ef8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     efc:	85aa                	mv	a1,a0
     efe:	4505                	li	a0,1
     f00:	00000097          	auipc	ra,0x0
     f04:	dce080e7          	jalr	-562(ra) # cce <vprintf>
}
     f08:	60e2                	ld	ra,24(sp)
     f0a:	6442                	ld	s0,16(sp)
     f0c:	6125                	addi	sp,sp,96
     f0e:	8082                	ret

0000000000000f10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f10:	1141                	addi	sp,sp,-16
     f12:	e422                	sd	s0,8(sp)
     f14:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f16:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f1a:	00001797          	auipc	a5,0x1
     f1e:	0e67b783          	ld	a5,230(a5) # 2000 <freep>
     f22:	a02d                	j	f4c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f24:	4618                	lw	a4,8(a2)
     f26:	9f2d                	addw	a4,a4,a1
     f28:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f2c:	6398                	ld	a4,0(a5)
     f2e:	6310                	ld	a2,0(a4)
     f30:	a83d                	j	f6e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f32:	ff852703          	lw	a4,-8(a0)
     f36:	9f31                	addw	a4,a4,a2
     f38:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f3a:	ff053683          	ld	a3,-16(a0)
     f3e:	a091                	j	f82 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f40:	6398                	ld	a4,0(a5)
     f42:	00e7e463          	bltu	a5,a4,f4a <free+0x3a>
     f46:	00e6ea63          	bltu	a3,a4,f5a <free+0x4a>
{
     f4a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f4c:	fed7fae3          	bgeu	a5,a3,f40 <free+0x30>
     f50:	6398                	ld	a4,0(a5)
     f52:	00e6e463          	bltu	a3,a4,f5a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f56:	fee7eae3          	bltu	a5,a4,f4a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f5a:	ff852583          	lw	a1,-8(a0)
     f5e:	6390                	ld	a2,0(a5)
     f60:	02059813          	slli	a6,a1,0x20
     f64:	01c85713          	srli	a4,a6,0x1c
     f68:	9736                	add	a4,a4,a3
     f6a:	fae60de3          	beq	a2,a4,f24 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     f6e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f72:	4790                	lw	a2,8(a5)
     f74:	02061593          	slli	a1,a2,0x20
     f78:	01c5d713          	srli	a4,a1,0x1c
     f7c:	973e                	add	a4,a4,a5
     f7e:	fae68ae3          	beq	a3,a4,f32 <free+0x22>
    p->s.ptr = bp->s.ptr;
     f82:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f84:	00001717          	auipc	a4,0x1
     f88:	06f73e23          	sd	a5,124(a4) # 2000 <freep>
}
     f8c:	6422                	ld	s0,8(sp)
     f8e:	0141                	addi	sp,sp,16
     f90:	8082                	ret

0000000000000f92 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f92:	7139                	addi	sp,sp,-64
     f94:	fc06                	sd	ra,56(sp)
     f96:	f822                	sd	s0,48(sp)
     f98:	f426                	sd	s1,40(sp)
     f9a:	f04a                	sd	s2,32(sp)
     f9c:	ec4e                	sd	s3,24(sp)
     f9e:	e852                	sd	s4,16(sp)
     fa0:	e456                	sd	s5,8(sp)
     fa2:	e05a                	sd	s6,0(sp)
     fa4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fa6:	02051493          	slli	s1,a0,0x20
     faa:	9081                	srli	s1,s1,0x20
     fac:	04bd                	addi	s1,s1,15
     fae:	8091                	srli	s1,s1,0x4
     fb0:	0014899b          	addiw	s3,s1,1
     fb4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fb6:	00001517          	auipc	a0,0x1
     fba:	04a53503          	ld	a0,74(a0) # 2000 <freep>
     fbe:	c515                	beqz	a0,fea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fc0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fc2:	4798                	lw	a4,8(a5)
     fc4:	02977f63          	bgeu	a4,s1,1002 <malloc+0x70>
     fc8:	8a4e                	mv	s4,s3
     fca:	0009871b          	sext.w	a4,s3
     fce:	6685                	lui	a3,0x1
     fd0:	00d77363          	bgeu	a4,a3,fd6 <malloc+0x44>
     fd4:	6a05                	lui	s4,0x1
     fd6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fda:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fde:	00001917          	auipc	s2,0x1
     fe2:	02290913          	addi	s2,s2,34 # 2000 <freep>
  if(p == (char*)-1)
     fe6:	5afd                	li	s5,-1
     fe8:	a895                	j	105c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
     fea:	00001797          	auipc	a5,0x1
     fee:	02678793          	addi	a5,a5,38 # 2010 <base>
     ff2:	00001717          	auipc	a4,0x1
     ff6:	00f73723          	sd	a5,14(a4) # 2000 <freep>
     ffa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     ffc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1000:	b7e1                	j	fc8 <malloc+0x36>
      if(p->s.size == nunits)
    1002:	02e48c63          	beq	s1,a4,103a <malloc+0xa8>
        p->s.size -= nunits;
    1006:	4137073b          	subw	a4,a4,s3
    100a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    100c:	02071693          	slli	a3,a4,0x20
    1010:	01c6d713          	srli	a4,a3,0x1c
    1014:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1016:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    101a:	00001717          	auipc	a4,0x1
    101e:	fea73323          	sd	a0,-26(a4) # 2000 <freep>
      return (void*)(p + 1);
    1022:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1026:	70e2                	ld	ra,56(sp)
    1028:	7442                	ld	s0,48(sp)
    102a:	74a2                	ld	s1,40(sp)
    102c:	7902                	ld	s2,32(sp)
    102e:	69e2                	ld	s3,24(sp)
    1030:	6a42                	ld	s4,16(sp)
    1032:	6aa2                	ld	s5,8(sp)
    1034:	6b02                	ld	s6,0(sp)
    1036:	6121                	addi	sp,sp,64
    1038:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    103a:	6398                	ld	a4,0(a5)
    103c:	e118                	sd	a4,0(a0)
    103e:	bff1                	j	101a <malloc+0x88>
  hp->s.size = nu;
    1040:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1044:	0541                	addi	a0,a0,16
    1046:	00000097          	auipc	ra,0x0
    104a:	eca080e7          	jalr	-310(ra) # f10 <free>
  return freep;
    104e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1052:	d971                	beqz	a0,1026 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1054:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1056:	4798                	lw	a4,8(a5)
    1058:	fa9775e3          	bgeu	a4,s1,1002 <malloc+0x70>
    if(p == freep)
    105c:	00093703          	ld	a4,0(s2)
    1060:	853e                	mv	a0,a5
    1062:	fef719e3          	bne	a4,a5,1054 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1066:	8552                	mv	a0,s4
    1068:	00000097          	auipc	ra,0x0
    106c:	b70080e7          	jalr	-1168(ra) # bd8 <sbrk>
  if(p == (char*)-1)
    1070:	fd5518e3          	bne	a0,s5,1040 <malloc+0xae>
        return 0;
    1074:	4501                	li	a0,0
    1076:	bf45                	j	1026 <malloc+0x94>
