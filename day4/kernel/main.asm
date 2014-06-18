
main.elf:     file format elf32-i386


Disassembly of section .text:

00000000 <bootmain>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
   6:	c7 45 f4 00 00 0a 00 	movl   $0xa0000,-0xc(%ebp)
   d:	eb 0a                	jmp    19 <bootmain+0x19>
   f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  12:	c6 00 0f             	movb   $0xf,(%eax)
  15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  19:	81 7d f4 ff ff 0a 00 	cmpl   $0xaffff,-0xc(%ebp)
  20:	7e ed                	jle    f <bootmain+0xf>
  22:	e8 99 00 00 00       	call   c0 <init_palette>
  27:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
  2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  35:	eb 14                	jmp    4b <bootmain+0x4b>
  37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  3d:	01 d0                	add    %edx,%eax
  3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  42:	83 e2 0f             	and    $0xf,%edx
  45:	88 10                	mov    %dl,(%eax)
  47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  4b:	81 7d f4 ff ff 00 00 	cmpl   $0xffff,-0xc(%ebp)
  52:	7e e3                	jle    37 <bootmain+0x37>
  54:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  5b:	e8 07 00 00 00       	call   67 <clear_screen>
  60:	e8 85 02 00 00       	call   2ea <draw_window>
  65:	eb fe                	jmp    65 <bootmain+0x65>

00000067 <clear_screen>:
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 14             	sub    $0x14,%esp
  6d:	8b 45 08             	mov    0x8(%ebp),%eax
  70:	88 45 ec             	mov    %al,-0x14(%ebp)
  73:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  7a:	eb 0d                	jmp    89 <clear_screen+0x22>
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  7f:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  83:	88 10                	mov    %dl,(%eax)
  85:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  89:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  90:	7e ea                	jle    7c <clear_screen+0x15>
  92:	c9                   	leave  
  93:	c3                   	ret    

00000094 <color_screen>:
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	83 ec 14             	sub    $0x14,%esp
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	88 45 ec             	mov    %al,-0x14(%ebp)
  a0:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  a7:	eb 0c                	jmp    b5 <color_screen+0x21>
  a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  af:	88 10                	mov    %dl,(%eax)
  b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b5:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  bc:	7e eb                	jle    a9 <color_screen+0x15>
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <init_palette>:
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 48             	sub    $0x48,%esp
  c6:	c6 45 c8 00          	movb   $0x0,-0x38(%ebp)
  ca:	c6 45 c9 00          	movb   $0x0,-0x37(%ebp)
  ce:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  d2:	c6 45 cb ff          	movb   $0xff,-0x35(%ebp)
  d6:	c6 45 cc 00          	movb   $0x0,-0x34(%ebp)
  da:	c6 45 cd 00          	movb   $0x0,-0x33(%ebp)
  de:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  e2:	c6 45 cf ff          	movb   $0xff,-0x31(%ebp)
  e6:	c6 45 d0 00          	movb   $0x0,-0x30(%ebp)
  ea:	c6 45 d1 ff          	movb   $0xff,-0x2f(%ebp)
  ee:	c6 45 d2 ff          	movb   $0xff,-0x2e(%ebp)
  f2:	c6 45 d3 00          	movb   $0x0,-0x2d(%ebp)
  f6:	c6 45 d4 00          	movb   $0x0,-0x2c(%ebp)
  fa:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
  fe:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
 102:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
 106:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
 10a:	c6 45 d9 ff          	movb   $0xff,-0x27(%ebp)
 10e:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
 112:	c6 45 db ff          	movb   $0xff,-0x25(%ebp)
 116:	c6 45 dc ff          	movb   $0xff,-0x24(%ebp)
 11a:	c6 45 dd ff          	movb   $0xff,-0x23(%ebp)
 11e:	c6 45 de ff          	movb   $0xff,-0x22(%ebp)
 122:	c6 45 df ff          	movb   $0xff,-0x21(%ebp)
 126:	c6 45 e0 c6          	movb   $0xc6,-0x20(%ebp)
 12a:	c6 45 e1 c6          	movb   $0xc6,-0x1f(%ebp)
 12e:	c6 45 e2 c6          	movb   $0xc6,-0x1e(%ebp)
 132:	c6 45 e3 84          	movb   $0x84,-0x1d(%ebp)
 136:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
 13a:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
 13e:	c6 45 e6 00          	movb   $0x0,-0x1a(%ebp)
 142:	c6 45 e7 84          	movb   $0x84,-0x19(%ebp)
 146:	c6 45 e8 00          	movb   $0x0,-0x18(%ebp)
 14a:	c6 45 e9 84          	movb   $0x84,-0x17(%ebp)
 14e:	c6 45 ea 84          	movb   $0x84,-0x16(%ebp)
 152:	c6 45 eb 00          	movb   $0x0,-0x15(%ebp)
 156:	c6 45 ec 00          	movb   $0x0,-0x14(%ebp)
 15a:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
 15e:	c6 45 ee 84          	movb   $0x84,-0x12(%ebp)
 162:	c6 45 ef 84          	movb   $0x84,-0x11(%ebp)
 166:	c6 45 f0 00          	movb   $0x0,-0x10(%ebp)
 16a:	c6 45 f1 84          	movb   $0x84,-0xf(%ebp)
 16e:	c6 45 f2 00          	movb   $0x0,-0xe(%ebp)
 172:	c6 45 f3 84          	movb   $0x84,-0xd(%ebp)
 176:	c6 45 f4 84          	movb   $0x84,-0xc(%ebp)
 17a:	c6 45 f5 84          	movb   $0x84,-0xb(%ebp)
 17e:	c6 45 f6 84          	movb   $0x84,-0xa(%ebp)
 182:	c6 45 f7 84          	movb   $0x84,-0x9(%ebp)
 186:	8d 45 c8             	lea    -0x38(%ebp),%eax
 189:	89 44 24 08          	mov    %eax,0x8(%esp)
 18d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
 194:	00 
 195:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19c:	e8 02 00 00 00       	call   1a3 <set_palette>
 1a1:	c9                   	leave  
 1a2:	c3                   	ret    

000001a3 <set_palette>:
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 30             	sub    $0x30,%esp
 1a9:	9c                   	pushf  
 1aa:	58                   	pop    %eax
 1ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 1b4:	fa                   	cli    
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 c0             	movzbl %al,%eax
 1bb:	c7 45 f0 c8 03 00 00 	movl   $0x3c8,-0x10(%ebp)
 1c2:	88 45 ef             	mov    %al,-0x11(%ebp)
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1cc:	ee                   	out    %al,(%dx)
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 1d3:	eb 68                	jmp    23d <set_palette+0x9a>
 1d5:	8b 45 10             	mov    0x10(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	c0 e8 02             	shr    $0x2,%al
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	c7 45 e8 c9 03 00 00 	movl   $0x3c9,-0x18(%ebp)
 1e8:	88 45 e7             	mov    %al,-0x19(%ebp)
 1eb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
 1f2:	ee                   	out    %al,(%dx)
 1f3:	8b 45 10             	mov    0x10(%ebp),%eax
 1f6:	83 c0 01             	add    $0x1,%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	c0 e8 02             	shr    $0x2,%al
 1ff:	0f b6 c0             	movzbl %al,%eax
 202:	c7 45 e0 c9 03 00 00 	movl   $0x3c9,-0x20(%ebp)
 209:	88 45 df             	mov    %al,-0x21(%ebp)
 20c:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
 210:	8b 55 e0             	mov    -0x20(%ebp),%edx
 213:	ee                   	out    %al,(%dx)
 214:	8b 45 10             	mov    0x10(%ebp),%eax
 217:	83 c0 02             	add    $0x2,%eax
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	c0 e8 02             	shr    $0x2,%al
 220:	0f b6 c0             	movzbl %al,%eax
 223:	c7 45 d8 c9 03 00 00 	movl   $0x3c9,-0x28(%ebp)
 22a:	88 45 d7             	mov    %al,-0x29(%ebp)
 22d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
 231:	8b 55 d8             	mov    -0x28(%ebp),%edx
 234:	ee                   	out    %al,(%dx)
 235:	83 45 10 03          	addl   $0x3,0x10(%ebp)
 239:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 23d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 240:	3b 45 0c             	cmp    0xc(%ebp),%eax
 243:	7e 90                	jle    1d5 <set_palette+0x32>
 245:	8b 45 f8             	mov    -0x8(%ebp),%eax
 248:	89 45 d0             	mov    %eax,-0x30(%ebp)
 24b:	8b 45 d0             	mov    -0x30(%ebp),%eax
 24e:	50                   	push   %eax
 24f:	9d                   	popf   
 250:	90                   	nop
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <boxfill8>:
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 14             	sub    $0x14,%esp
 259:	8b 45 10             	mov    0x10(%ebp),%eax
 25c:	88 45 ec             	mov    %al,-0x14(%ebp)
 25f:	8b 45 18             	mov    0x18(%ebp),%eax
 262:	89 45 f8             	mov    %eax,-0x8(%ebp)
 265:	eb 33                	jmp    29a <boxfill8+0x47>
 267:	8b 45 14             	mov    0x14(%ebp),%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 26d:	eb 1f                	jmp    28e <boxfill8+0x3b>
 26f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 272:	0f af 45 0c          	imul   0xc(%ebp),%eax
 276:	89 c2                	mov    %eax,%edx
 278:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	89 c2                	mov    %eax,%edx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	01 c2                	add    %eax,%edx
 284:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
 288:	88 02                	mov    %al,(%edx)
 28a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 291:	3b 45 1c             	cmp    0x1c(%ebp),%eax
 294:	7e d9                	jle    26f <boxfill8+0x1c>
 296:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 29a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29d:	3b 45 20             	cmp    0x20(%ebp),%eax
 2a0:	7e c5                	jle    267 <boxfill8+0x14>
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <boxfill>:
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	83 ec 20             	sub    $0x20,%esp
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	88 45 fc             	mov    %al,-0x4(%ebp)
 2b0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 2b4:	8b 55 18             	mov    0x18(%ebp),%edx
 2b7:	89 54 24 18          	mov    %edx,0x18(%esp)
 2bb:	8b 55 14             	mov    0x14(%ebp),%edx
 2be:	89 54 24 14          	mov    %edx,0x14(%esp)
 2c2:	8b 55 10             	mov    0x10(%ebp),%edx
 2c5:	89 54 24 10          	mov    %edx,0x10(%esp)
 2c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 2cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
 2d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 2d4:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
 2db:	00 
 2dc:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
 2e3:	e8 6b ff ff ff       	call   253 <boxfill8>
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <draw_window>:
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	53                   	push   %ebx
 2ee:	83 ec 24             	sub    $0x24,%esp
 2f1:	c7 45 f8 40 01 00 00 	movl   $0x140,-0x8(%ebp)
 2f8:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
 2ff:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
 306:	8b 45 f4             	mov    -0xc(%ebp),%eax
 309:	8d 50 e3             	lea    -0x1d(%eax),%edx
 30c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30f:	83 e8 01             	sub    $0x1,%eax
 312:	89 54 24 10          	mov    %edx,0x10(%esp)
 316:	89 44 24 0c          	mov    %eax,0xc(%esp)
 31a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 321:	00 
 322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 329:	00 
 32a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 331:	e8 6e ff ff ff       	call   2a4 <boxfill>
 336:	8b 45 f4             	mov    -0xc(%ebp),%eax
 339:	8d 48 e4             	lea    -0x1c(%eax),%ecx
 33c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33f:	8d 50 ff             	lea    -0x1(%eax),%edx
 342:	8b 45 f4             	mov    -0xc(%ebp),%eax
 345:	83 e8 1c             	sub    $0x1c,%eax
 348:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 34c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 350:	89 44 24 08          	mov    %eax,0x8(%esp)
 354:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 35b:	00 
 35c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 363:	e8 3c ff ff ff       	call   2a4 <boxfill>
 368:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36b:	8d 48 e5             	lea    -0x1b(%eax),%ecx
 36e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 371:	8d 50 ff             	lea    -0x1(%eax),%edx
 374:	8b 45 f4             	mov    -0xc(%ebp),%eax
 377:	83 e8 1b             	sub    $0x1b,%eax
 37a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 37e:	89 54 24 0c          	mov    %edx,0xc(%esp)
 382:	89 44 24 08          	mov    %eax,0x8(%esp)
 386:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 38d:	00 
 38e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 395:	e8 0a ff ff ff       	call   2a4 <boxfill>
 39a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39d:	8d 48 ff             	lea    -0x1(%eax),%ecx
 3a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a9:	83 e8 1a             	sub    $0x1a,%eax
 3ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 3b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
 3b4:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3bf:	00 
 3c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 3c7:	e8 d8 fe ff ff       	call   2a4 <boxfill>
 3cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cf:	8d 50 e8             	lea    -0x18(%eax),%edx
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	83 e8 18             	sub    $0x18,%eax
 3d8:	89 54 24 10          	mov    %edx,0x10(%esp)
 3dc:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
 3e3:	00 
 3e4:	89 44 24 08          	mov    %eax,0x8(%esp)
 3e8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
 3ef:	00 
 3f0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 3f7:	e8 a8 fe ff ff       	call   2a4 <boxfill>
 3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ff:	8d 50 fc             	lea    -0x4(%eax),%edx
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	83 e8 18             	sub    $0x18,%eax
 408:	89 54 24 10          	mov    %edx,0x10(%esp)
 40c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 413:	00 
 414:	89 44 24 08          	mov    %eax,0x8(%esp)
 418:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 41f:	00 
 420:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 427:	e8 78 fe ff ff       	call   2a4 <boxfill>
 42c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42f:	8d 50 fc             	lea    -0x4(%eax),%edx
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	83 e8 04             	sub    $0x4,%eax
 438:	89 54 24 10          	mov    %edx,0x10(%esp)
 43c:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
 443:	00 
 444:	89 44 24 08          	mov    %eax,0x8(%esp)
 448:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
 44f:	00 
 450:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 457:	e8 48 fe ff ff       	call   2a4 <boxfill>
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	8d 50 fb             	lea    -0x5(%eax),%edx
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	83 e8 17             	sub    $0x17,%eax
 468:	89 54 24 10          	mov    %edx,0x10(%esp)
 46c:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
 473:	00 
 474:	89 44 24 08          	mov    %eax,0x8(%esp)
 478:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
 47f:	00 
 480:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 487:	e8 18 fe ff ff       	call   2a4 <boxfill>
 48c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48f:	8d 50 fd             	lea    -0x3(%eax),%edx
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	83 e8 03             	sub    $0x3,%eax
 498:	89 54 24 10          	mov    %edx,0x10(%esp)
 49c:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
 4a3:	00 
 4a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 4a8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 4af:	00 
 4b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4b7:	e8 e8 fd ff ff       	call   2a4 <boxfill>
 4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bf:	8d 50 fd             	lea    -0x3(%eax),%edx
 4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c5:	83 e8 18             	sub    $0x18,%eax
 4c8:	89 54 24 10          	mov    %edx,0x10(%esp)
 4cc:	c7 44 24 0c 3c 00 00 	movl   $0x3c,0xc(%esp)
 4d3:	00 
 4d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 4d8:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
 4df:	00 
 4e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4e7:	e8 b8 fd ff ff       	call   2a4 <boxfill>
 4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ef:	8d 58 e8             	lea    -0x18(%eax),%ebx
 4f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4f5:	8d 48 fc             	lea    -0x4(%eax),%ecx
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	8d 50 e8             	lea    -0x18(%eax),%edx
 4fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 501:	83 e8 2f             	sub    $0x2f,%eax
 504:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 508:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 50c:	89 54 24 08          	mov    %edx,0x8(%esp)
 510:	89 44 24 04          	mov    %eax,0x4(%esp)
 514:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 51b:	e8 84 fd ff ff       	call   2a4 <boxfill>
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	8d 58 fc             	lea    -0x4(%eax),%ebx
 526:	8b 45 f8             	mov    -0x8(%ebp),%eax
 529:	8d 48 d1             	lea    -0x2f(%eax),%ecx
 52c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52f:	8d 50 e9             	lea    -0x17(%eax),%edx
 532:	8b 45 f8             	mov    -0x8(%ebp),%eax
 535:	83 e8 2f             	sub    $0x2f,%eax
 538:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 53c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 540:	89 54 24 08          	mov    %edx,0x8(%esp)
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 54f:	e8 50 fd ff ff       	call   2a4 <boxfill>
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8d 58 fd             	lea    -0x3(%eax),%ebx
 55a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 55d:	8d 48 fc             	lea    -0x4(%eax),%ecx
 560:	8b 45 f4             	mov    -0xc(%ebp),%eax
 563:	8d 50 fd             	lea    -0x3(%eax),%edx
 566:	8b 45 f8             	mov    -0x8(%ebp),%eax
 569:	83 e8 2f             	sub    $0x2f,%eax
 56c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 570:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 574:	89 54 24 08          	mov    %edx,0x8(%esp)
 578:	89 44 24 04          	mov    %eax,0x4(%esp)
 57c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 583:	e8 1c fd ff ff       	call   2a4 <boxfill>
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	8d 58 fd             	lea    -0x3(%eax),%ebx
 58e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 591:	8d 48 fd             	lea    -0x3(%eax),%ecx
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8d 50 e8             	lea    -0x18(%eax),%edx
 59a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 59d:	83 e8 03             	sub    $0x3,%eax
 5a0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 5a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 5a8:	89 54 24 08          	mov    %edx,0x8(%esp)
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 5b7:	e8 e8 fc ff ff       	call   2a4 <boxfill>
 5bc:	83 c4 24             	add    $0x24,%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    

000005c2 <init_mouse>:
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 14             	sub    $0x14,%esp
 5c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cb:	88 45 ec             	mov    %al,-0x14(%ebp)
 5ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 5d5:	e9 8d 00 00 00       	jmp    667 <init_mouse+0xa5>
 5da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5e1:	eb 7a                	jmp    65d <init_mouse+0x9b>
 5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e6:	c1 e0 04             	shl    $0x4,%eax
 5e9:	89 c2                	mov    %eax,%edx
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	01 d0                	add    %edx,%eax
 5f0:	05 e0 06 00 00       	add    $0x6e0,%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 f8 2e             	cmp    $0x2e,%eax
 5fe:	74 0c                	je     60c <init_mouse+0x4a>
 600:	83 f8 4f             	cmp    $0x4f,%eax
 603:	74 3c                	je     641 <init_mouse+0x7f>
 605:	83 f8 2a             	cmp    $0x2a,%eax
 608:	74 1e                	je     628 <init_mouse+0x66>
 60a:	eb 4d                	jmp    659 <init_mouse+0x97>
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	c1 e0 04             	shl    $0x4,%eax
 612:	89 c2                	mov    %eax,%edx
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	01 d0                	add    %edx,%eax
 619:	89 c2                	mov    %eax,%edx
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	01 c2                	add    %eax,%edx
 620:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
 624:	88 02                	mov    %al,(%edx)
 626:	eb 31                	jmp    659 <init_mouse+0x97>
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	c1 e0 04             	shl    $0x4,%eax
 62e:	89 c2                	mov    %eax,%edx
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	89 c2                	mov    %eax,%edx
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	01 d0                	add    %edx,%eax
 63c:	c6 00 00             	movb   $0x0,(%eax)
 63f:	eb 18                	jmp    659 <init_mouse+0x97>
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	c1 e0 04             	shl    $0x4,%eax
 647:	89 c2                	mov    %eax,%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	01 d0                	add    %edx,%eax
 64e:	89 c2                	mov    %eax,%edx
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	01 d0                	add    %edx,%eax
 655:	c6 00 02             	movb   $0x2,(%eax)
 658:	90                   	nop
 659:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 65d:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
 661:	7e 80                	jle    5e3 <init_mouse+0x21>
 663:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 667:	83 7d f8 0f          	cmpl   $0xf,-0x8(%ebp)
 66b:	0f 8e 69 ff ff ff    	jle    5da <init_mouse+0x18>
 671:	c9                   	leave  
 672:	c3                   	ret    

00000673 <display_mouse>:
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	83 ec 10             	sub    $0x10,%esp
 679:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 680:	eb 50                	jmp    6d2 <display_mouse+0x5f>
 682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 689:	eb 3b                	jmp    6c6 <display_mouse+0x53>
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 55 1c             	mov    0x1c(%ebp),%edx
 691:	01 d0                	add    %edx,%eax
 693:	0f af 45 0c          	imul   0xc(%ebp),%eax
 697:	8b 55 fc             	mov    -0x4(%ebp),%edx
 69a:	8b 4d 18             	mov    0x18(%ebp),%ecx
 69d:	01 ca                	add    %ecx,%edx
 69f:	01 d0                	add    %edx,%eax
 6a1:	89 c2                	mov    %eax,%edx
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	01 c2                	add    %eax,%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	0f af 45 24          	imul   0x24(%ebp),%eax
 6af:	89 c1                	mov    %eax,%ecx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	01 c8                	add    %ecx,%eax
 6b6:	89 c1                	mov    %eax,%ecx
 6b8:	8b 45 20             	mov    0x20(%ebp),%eax
 6bb:	01 c8                	add    %ecx,%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	88 02                	mov    %al,(%edx)
 6c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	3b 45 10             	cmp    0x10(%ebp),%eax
 6cc:	7c bd                	jl     68b <display_mouse+0x18>
 6ce:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	3b 45 14             	cmp    0x14(%ebp),%eax
 6d8:	7c a8                	jl     682 <display_mouse+0xf>
 6da:	c9                   	leave  
 6db:	c3                   	ret    

Disassembly of section .rodata:

000006e0 <cursor.1665>:
 6e0:	2a 2a                	sub    (%edx),%ch
 6e2:	2a 2a                	sub    (%edx),%ch
 6e4:	2a 2a                	sub    (%edx),%ch
 6e6:	2a 2a                	sub    (%edx),%ch
 6e8:	2a 2a                	sub    (%edx),%ch
 6ea:	2a 2a                	sub    (%edx),%ch
 6ec:	2a 2a                	sub    (%edx),%ch
 6ee:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
 6f3:	4f                   	dec    %edi
 6f4:	4f                   	dec    %edi
 6f5:	4f                   	dec    %edi
 6f6:	4f                   	dec    %edi
 6f7:	4f                   	dec    %edi
 6f8:	4f                   	dec    %edi
 6f9:	4f                   	dec    %edi
 6fa:	4f                   	dec    %edi
 6fb:	4f                   	dec    %edi
 6fc:	2a 2e                	sub    (%esi),%ch
 6fe:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
 703:	4f                   	dec    %edi
 704:	4f                   	dec    %edi
 705:	4f                   	dec    %edi
 706:	4f                   	dec    %edi
 707:	4f                   	dec    %edi
 708:	4f                   	dec    %edi
 709:	4f                   	dec    %edi
 70a:	4f                   	dec    %edi
 70b:	2a 2e                	sub    (%esi),%ch
 70d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
 713:	4f                   	dec    %edi
 714:	4f                   	dec    %edi
 715:	4f                   	dec    %edi
 716:	4f                   	dec    %edi
 717:	4f                   	dec    %edi
 718:	4f                   	dec    %edi
 719:	4f                   	dec    %edi
 71a:	2a 2e                	sub    (%esi),%ch
 71c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
 723:	4f                   	dec    %edi
 724:	4f                   	dec    %edi
 725:	4f                   	dec    %edi
 726:	4f                   	dec    %edi
 727:	4f                   	dec    %edi
 728:	4f                   	dec    %edi
 729:	2a 2e                	sub    (%esi),%ch
 72b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
 732:	4f 
 733:	4f                   	dec    %edi
 734:	4f                   	dec    %edi
 735:	4f                   	dec    %edi
 736:	4f                   	dec    %edi
 737:	4f                   	dec    %edi
 738:	2a 2e                	sub    (%esi),%ch
 73a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 741:	4f 4f 
 743:	4f                   	dec    %edi
 744:	4f                   	dec    %edi
 745:	4f                   	dec    %edi
 746:	4f                   	dec    %edi
 747:	4f                   	dec    %edi
 748:	2a 2e                	sub    (%esi),%ch
 74a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 751:	4f 4f 
 753:	4f                   	dec    %edi
 754:	4f                   	dec    %edi
 755:	4f                   	dec    %edi
 756:	4f                   	dec    %edi
 757:	4f                   	dec    %edi
 758:	4f                   	dec    %edi
 759:	2a 2e                	sub    (%esi),%ch
 75b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
 762:	4f 
 763:	4f                   	dec    %edi
 764:	4f                   	dec    %edi
 765:	2a 2a                	sub    (%edx),%ch
 767:	4f                   	dec    %edi
 768:	4f                   	dec    %edi
 769:	4f                   	dec    %edi
 76a:	2a 2e                	sub    (%esi),%ch
 76c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
 773:	4f                   	dec    %edi
 774:	2a 2e                	sub    (%esi),%ch
 776:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
 77a:	4f                   	dec    %edi
 77b:	2a 2e                	sub    (%esi),%ch
 77d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
 783:	2a 2e                	sub    (%esi),%ch
 785:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
 78b:	4f                   	dec    %edi
 78c:	2a 2e                	sub    (%esi),%ch
 78e:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
 793:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 79a:	4f 4f 
 79c:	4f                   	dec    %edi
 79d:	2a 2e                	sub    (%esi),%ch
 79f:	2e 2a 2a             	sub    %cs:(%edx),%ch
 7a2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 7a9:	2e 2a 4f 4f 
 7ad:	4f                   	dec    %edi
 7ae:	2a 2e                	sub    (%esi),%ch
 7b0:	2a 2e                	sub    (%esi),%ch
 7b2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 7b9:	2e 2e 2a 4f 4f 
 7be:	4f                   	dec    %edi
 7bf:	2a 2e                	sub    (%esi),%ch
 7c1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
 7c8:	2e 2e 2e 2e 2a 4f 4f 
 7cf:	2a 2e                	sub    (%esi),%ch
 7d1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
 7d8:	2e 2e 2e 2e 2e 2a 2a 
 7df:	2a                   	.byte 0x2a

Disassembly of section .eh_frame:

000007e0 <.eh_frame>:
 7e0:	14 00                	adc    $0x0,%al
 7e2:	00 00                	add    %al,(%eax)
 7e4:	00 00                	add    %al,(%eax)
 7e6:	00 00                	add    %al,(%eax)
 7e8:	01 7a 52             	add    %edi,0x52(%edx)
 7eb:	00 01                	add    %al,(%ecx)
 7ed:	7c 08                	jl     7f7 <cursor.1665+0x117>
 7ef:	01 1b                	add    %ebx,(%ebx)
 7f1:	0c 04                	or     $0x4,%al
 7f3:	04 88                	add    $0x88,%al
 7f5:	01 00                	add    %eax,(%eax)
 7f7:	00 18                	add    %bl,(%eax)
 7f9:	00 00                	add    %al,(%eax)
 7fb:	00 1c 00             	add    %bl,(%eax,%eax,1)
 7fe:	00 00                	add    %al,(%eax)
 800:	00 f8                	add    %bh,%al
 802:	ff                   	(bad)  
 803:	ff 67 00             	jmp    *0x0(%edi)
 806:	00 00                	add    %al,(%eax)
 808:	00 41 0e             	add    %al,0xe(%ecx)
 80b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 811:	00 00                	add    %al,(%eax)
 813:	00 1c 00             	add    %bl,(%eax,%eax,1)
 816:	00 00                	add    %al,(%eax)
 818:	38 00                	cmp    %al,(%eax)
 81a:	00 00                	add    %al,(%eax)
 81c:	4b                   	dec    %ebx
 81d:	f8                   	clc    
 81e:	ff                   	(bad)  
 81f:	ff 2d 00 00 00 00    	ljmp   *0x0
 825:	41                   	inc    %ecx
 826:	0e                   	push   %cs
 827:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 82d:	69 c5 0c 04 04 00    	imul   $0x4040c,%ebp,%eax
 833:	00 1c 00             	add    %bl,(%eax,%eax,1)
 836:	00 00                	add    %al,(%eax)
 838:	58                   	pop    %eax
 839:	00 00                	add    %al,(%eax)
 83b:	00 58 f8             	add    %bl,-0x8(%eax)
 83e:	ff                   	(bad)  
 83f:	ff 2c 00             	ljmp   *(%eax,%eax,1)
 842:	00 00                	add    %al,(%eax)
 844:	00 41 0e             	add    %al,0xe(%ecx)
 847:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 84d:	68 c5 0c 04 04       	push   $0x4040cc5
 852:	00 00                	add    %al,(%eax)
 854:	1c 00                	sbb    $0x0,%al
 856:	00 00                	add    %al,(%eax)
 858:	78 00                	js     85a <cursor.1665+0x17a>
 85a:	00 00                	add    %al,(%eax)
 85c:	64                   	fs
 85d:	f8                   	clc    
 85e:	ff                   	(bad)  
 85f:	ff e3                	jmp    *%ebx
 861:	00 00                	add    %al,(%eax)
 863:	00 00                	add    %al,(%eax)
 865:	41                   	inc    %ecx
 866:	0e                   	push   %cs
 867:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 86d:	02 df                	add    %bh,%bl
 86f:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 872:	04 00                	add    $0x0,%al
 874:	1c 00                	sbb    $0x0,%al
 876:	00 00                	add    %al,(%eax)
 878:	98                   	cwtl   
 879:	00 00                	add    %al,(%eax)
 87b:	00 27                	add    %ah,(%edi)
 87d:	f9                   	stc    
 87e:	ff                   	(bad)  
 87f:	ff b0 00 00 00 00    	pushl  0x0(%eax)
 885:	41                   	inc    %ecx
 886:	0e                   	push   %cs
 887:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 88d:	02 ac c5 0c 04 04 00 	add    0x4040c(%ebp,%eax,8),%ch
 894:	1c 00                	sbb    $0x0,%al
 896:	00 00                	add    %al,(%eax)
 898:	b8 00 00 00 b7       	mov    $0xb7000000,%eax
 89d:	f9                   	stc    
 89e:	ff                   	(bad)  
 89f:	ff 51 00             	call   *0x0(%ecx)
 8a2:	00 00                	add    %al,(%eax)
 8a4:	00 41 0e             	add    %al,0xe(%ecx)
 8a7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 8ad:	02 4d c5             	add    -0x3b(%ebp),%cl
 8b0:	0c 04                	or     $0x4,%al
 8b2:	04 00                	add    $0x0,%al
 8b4:	1c 00                	sbb    $0x0,%al
 8b6:	00 00                	add    %al,(%eax)
 8b8:	d8 00                	fadds  (%eax)
 8ba:	00 00                	add    %al,(%eax)
 8bc:	e8 f9 ff ff 46       	call   470008ba <cursor.1665+0x470001da>
 8c1:	00 00                	add    %al,(%eax)
 8c3:	00 00                	add    %al,(%eax)
 8c5:	41                   	inc    %ecx
 8c6:	0e                   	push   %cs
 8c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 8cd:	02 42 c5             	add    -0x3b(%edx),%al
 8d0:	0c 04                	or     $0x4,%al
 8d2:	04 00                	add    $0x0,%al
 8d4:	24 00                	and    $0x0,%al
 8d6:	00 00                	add    %al,(%eax)
 8d8:	f8                   	clc    
 8d9:	00 00                	add    %al,(%eax)
 8db:	00 0e                	add    %cl,(%esi)
 8dd:	fa                   	cli    
 8de:	ff                   	(bad)  
 8df:	ff                   	(bad)  
 8e0:	d8 02                	fadds  (%edx)
 8e2:	00 00                	add    %al,(%eax)
 8e4:	00 41 0e             	add    %al,0xe(%ecx)
 8e7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 8ed:	44                   	inc    %esp
 8ee:	83 03 03             	addl   $0x3,(%ebx)
 8f1:	cf                   	iret   
 8f2:	02 c3                	add    %bl,%al
 8f4:	41                   	inc    %ecx
 8f5:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 8f8:	04 00                	add    $0x0,%al
 8fa:	00 00                	add    %al,(%eax)
 8fc:	1c 00                	sbb    $0x0,%al
 8fe:	00 00                	add    %al,(%eax)
 900:	20 01                	and    %al,(%ecx)
 902:	00 00                	add    %al,(%eax)
 904:	be fc ff ff b1       	mov    $0xb1fffffc,%esi
 909:	00 00                	add    %al,(%eax)
 90b:	00 00                	add    %al,(%eax)
 90d:	41                   	inc    %ecx
 90e:	0e                   	push   %cs
 90f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 915:	02 ad c5 0c 04 04    	add    0x4040cc5(%ebp),%ch
 91b:	00 1c 00             	add    %bl,(%eax,%eax,1)
 91e:	00 00                	add    %al,(%eax)
 920:	40                   	inc    %eax
 921:	01 00                	add    %eax,(%eax)
 923:	00 4f fd             	add    %cl,-0x3(%edi)
 926:	ff                   	(bad)  
 927:	ff 69 00             	ljmp   *0x0(%ecx)
 92a:	00 00                	add    %al,(%eax)
 92c:	00 41 0e             	add    %al,0xe(%ecx)
 92f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 935:	02 65 c5             	add    -0x3b(%ebp),%ah
 938:	0c 04                	or     $0x4,%al
 93a:	04 00                	add    $0x0,%al

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <clear_screen+0x11>
   a:	74 75                	je     81 <clear_screen+0x1a>
   c:	20 34 2e             	and    %dh,(%esi,%ebp,1)
   f:	38 2e                	cmp    %ch,(%esi)
  11:	32 2d 31 39 75 62    	xor    0x62753931,%ch
  17:	75 6e                	jne    87 <clear_screen+0x20>
  19:	74 75                	je     90 <clear_screen+0x29>
  1b:	31 29                	xor    %ebp,(%ecx)
  1d:	20 34 2e             	and    %dh,(%esi,%ebp,1)
  20:	38 2e                	cmp    %ch,(%esi)
  22:	32 00                	xor    (%eax),%al
