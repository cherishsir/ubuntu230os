
main.elf:     file format elf32-i386


Disassembly of section .text:

00280000 <bootmain>:
  280000:	55                   	push   %ebp
  280001:	89 e5                	mov    %esp,%ebp
  280003:	81 ec 48 01 00 00    	sub    $0x148,%esp
  280009:	e8 9d 01 00 00       	call   2801ab <init_palette>
  28000e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280015:	e8 38 01 00 00       	call   280152 <clear_screen>
  28001a:	e8 b6 03 00 00       	call   2803d5 <draw_window>
  28001f:	c7 45 f4 f0 0f 00 00 	movl   $0xff0,-0xc(%ebp)
  280026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280029:	89 04 24             	mov    %eax,(%esp)
  28002c:	e8 7c 06 00 00       	call   2806ad <init_screen>
  280031:	c7 44 24 0c 28 00 00 	movl   $0x28,0xc(%esp)
  280038:	00 
  280039:	c7 44 24 08 1e 00 00 	movl   $0x1e,0x8(%esp)
  280040:	00 
  280041:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
  280048:	00 
  280049:	c7 04 24 61 00 00 00 	movl   $0x61,(%esp)
  280050:	e8 9b 07 00 00       	call   2807f0 <putchar>
  280055:	c7 44 24 0c 46 00 00 	movl   $0x46,0xc(%esp)
  28005c:	00 
  28005d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  280064:	00 
  280065:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  28006c:	00 
  28006d:	c7 04 24 a0 0c 28 00 	movl   $0x280ca0,(%esp)
  280074:	e8 47 08 00 00       	call   2808c0 <puts>
  280079:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  280080:	00 
  280081:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  280088:	00 
  280089:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  280090:	00 
  280091:	c7 04 24 ab 0c 28 00 	movl   $0x280cab,(%esp)
  280098:	e8 23 08 00 00       	call   2808c0 <puts>
  28009d:	c7 45 f0 40 01 00 00 	movl   $0x140,-0x10(%ebp)
  2800a4:	c7 45 ec c8 00 00 00 	movl   $0xc8,-0x14(%ebp)
  2800ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  2800ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2800b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2800b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  2800b9:	c7 44 24 04 b7 0c 28 	movl   $0x280cb7,0x4(%esp)
  2800c0:	00 
  2800c1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  2800c4:	89 04 24             	mov    %eax,(%esp)
  2800c7:	e8 3f 08 00 00       	call   28090b <sprintf>
  2800cc:	c7 44 24 0c 82 00 00 	movl   $0x82,0xc(%esp)
  2800d3:	00 
  2800d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  2800db:	00 
  2800dc:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  2800e3:	00 
  2800e4:	8d 45 d8             	lea    -0x28(%ebp),%eax
  2800e7:	89 04 24             	mov    %eax,(%esp)
  2800ea:	e8 d1 07 00 00       	call   2808c0 <puts>
  2800ef:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
  2800f6:	00 
  2800f7:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  2800fd:	89 04 24             	mov    %eax,(%esp)
  280100:	e8 d1 05 00 00       	call   2806d6 <init_mouse>
  280105:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  28010c:	00 
  28010d:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  280113:	89 44 24 18          	mov    %eax,0x18(%esp)
  280117:	c7 44 24 14 64 00 00 	movl   $0x64,0x14(%esp)
  28011e:	00 
  28011f:	c7 44 24 10 a0 00 00 	movl   $0xa0,0x10(%esp)
  280126:	00 
  280127:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  28012e:	00 
  28012f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  280136:	00 
  280137:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  28013e:	00 
  28013f:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  280146:	e8 3c 06 00 00       	call   280787 <display_mouse>
  28014b:	e8 b9 09 00 00       	call   280b09 <init_gdtidt>
  280150:	eb fe                	jmp    280150 <bootmain+0x150>

00280152 <clear_screen>:
  280152:	55                   	push   %ebp
  280153:	89 e5                	mov    %esp,%ebp
  280155:	83 ec 14             	sub    $0x14,%esp
  280158:	8b 45 08             	mov    0x8(%ebp),%eax
  28015b:	88 45 ec             	mov    %al,-0x14(%ebp)
  28015e:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  280165:	eb 0d                	jmp    280174 <clear_screen+0x22>
  280167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28016a:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  28016e:	88 10                	mov    %dl,(%eax)
  280170:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280174:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  28017b:	7e ea                	jle    280167 <clear_screen+0x15>
  28017d:	c9                   	leave  
  28017e:	c3                   	ret    

0028017f <color_screen>:
  28017f:	55                   	push   %ebp
  280180:	89 e5                	mov    %esp,%ebp
  280182:	83 ec 14             	sub    $0x14,%esp
  280185:	8b 45 08             	mov    0x8(%ebp),%eax
  280188:	88 45 ec             	mov    %al,-0x14(%ebp)
  28018b:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  280192:	eb 0c                	jmp    2801a0 <color_screen+0x21>
  280194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280197:	8b 55 fc             	mov    -0x4(%ebp),%edx
  28019a:	88 10                	mov    %dl,(%eax)
  28019c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2801a0:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  2801a7:	7e eb                	jle    280194 <color_screen+0x15>
  2801a9:	c9                   	leave  
  2801aa:	c3                   	ret    

002801ab <init_palette>:
  2801ab:	55                   	push   %ebp
  2801ac:	89 e5                	mov    %esp,%ebp
  2801ae:	83 ec 48             	sub    $0x48,%esp
  2801b1:	c6 45 c8 00          	movb   $0x0,-0x38(%ebp)
  2801b5:	c6 45 c9 00          	movb   $0x0,-0x37(%ebp)
  2801b9:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  2801bd:	c6 45 cb ff          	movb   $0xff,-0x35(%ebp)
  2801c1:	c6 45 cc 00          	movb   $0x0,-0x34(%ebp)
  2801c5:	c6 45 cd 00          	movb   $0x0,-0x33(%ebp)
  2801c9:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  2801cd:	c6 45 cf ff          	movb   $0xff,-0x31(%ebp)
  2801d1:	c6 45 d0 00          	movb   $0x0,-0x30(%ebp)
  2801d5:	c6 45 d1 ff          	movb   $0xff,-0x2f(%ebp)
  2801d9:	c6 45 d2 ff          	movb   $0xff,-0x2e(%ebp)
  2801dd:	c6 45 d3 00          	movb   $0x0,-0x2d(%ebp)
  2801e1:	c6 45 d4 00          	movb   $0x0,-0x2c(%ebp)
  2801e5:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
  2801e9:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  2801ed:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  2801f1:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  2801f5:	c6 45 d9 ff          	movb   $0xff,-0x27(%ebp)
  2801f9:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
  2801fd:	c6 45 db ff          	movb   $0xff,-0x25(%ebp)
  280201:	c6 45 dc ff          	movb   $0xff,-0x24(%ebp)
  280205:	c6 45 dd ff          	movb   $0xff,-0x23(%ebp)
  280209:	c6 45 de ff          	movb   $0xff,-0x22(%ebp)
  28020d:	c6 45 df ff          	movb   $0xff,-0x21(%ebp)
  280211:	c6 45 e0 c6          	movb   $0xc6,-0x20(%ebp)
  280215:	c6 45 e1 c6          	movb   $0xc6,-0x1f(%ebp)
  280219:	c6 45 e2 c6          	movb   $0xc6,-0x1e(%ebp)
  28021d:	c6 45 e3 84          	movb   $0x84,-0x1d(%ebp)
  280221:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
  280225:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  280229:	c6 45 e6 00          	movb   $0x0,-0x1a(%ebp)
  28022d:	c6 45 e7 84          	movb   $0x84,-0x19(%ebp)
  280231:	c6 45 e8 00          	movb   $0x0,-0x18(%ebp)
  280235:	c6 45 e9 84          	movb   $0x84,-0x17(%ebp)
  280239:	c6 45 ea 84          	movb   $0x84,-0x16(%ebp)
  28023d:	c6 45 eb 00          	movb   $0x0,-0x15(%ebp)
  280241:	c6 45 ec 00          	movb   $0x0,-0x14(%ebp)
  280245:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
  280249:	c6 45 ee 84          	movb   $0x84,-0x12(%ebp)
  28024d:	c6 45 ef 84          	movb   $0x84,-0x11(%ebp)
  280251:	c6 45 f0 00          	movb   $0x0,-0x10(%ebp)
  280255:	c6 45 f1 84          	movb   $0x84,-0xf(%ebp)
  280259:	c6 45 f2 00          	movb   $0x0,-0xe(%ebp)
  28025d:	c6 45 f3 84          	movb   $0x84,-0xd(%ebp)
  280261:	c6 45 f4 84          	movb   $0x84,-0xc(%ebp)
  280265:	c6 45 f5 84          	movb   $0x84,-0xb(%ebp)
  280269:	c6 45 f6 84          	movb   $0x84,-0xa(%ebp)
  28026d:	c6 45 f7 84          	movb   $0x84,-0x9(%ebp)
  280271:	8d 45 c8             	lea    -0x38(%ebp),%eax
  280274:	89 44 24 08          	mov    %eax,0x8(%esp)
  280278:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  28027f:	00 
  280280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  280287:	e8 02 00 00 00       	call   28028e <set_palette>
  28028c:	c9                   	leave  
  28028d:	c3                   	ret    

0028028e <set_palette>:
  28028e:	55                   	push   %ebp
  28028f:	89 e5                	mov    %esp,%ebp
  280291:	83 ec 30             	sub    $0x30,%esp
  280294:	9c                   	pushf  
  280295:	58                   	pop    %eax
  280296:	89 45 f4             	mov    %eax,-0xc(%ebp)
  280299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28029c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  28029f:	fa                   	cli    
  2802a0:	8b 45 08             	mov    0x8(%ebp),%eax
  2802a3:	0f b6 c0             	movzbl %al,%eax
  2802a6:	c7 45 f0 c8 03 00 00 	movl   $0x3c8,-0x10(%ebp)
  2802ad:	88 45 ef             	mov    %al,-0x11(%ebp)
  2802b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  2802b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  2802b7:	ee                   	out    %al,(%dx)
  2802b8:	8b 45 08             	mov    0x8(%ebp),%eax
  2802bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  2802be:	eb 68                	jmp    280328 <set_palette+0x9a>
  2802c0:	8b 45 10             	mov    0x10(%ebp),%eax
  2802c3:	0f b6 00             	movzbl (%eax),%eax
  2802c6:	c0 e8 02             	shr    $0x2,%al
  2802c9:	0f b6 c0             	movzbl %al,%eax
  2802cc:	c7 45 e8 c9 03 00 00 	movl   $0x3c9,-0x18(%ebp)
  2802d3:	88 45 e7             	mov    %al,-0x19(%ebp)
  2802d6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  2802da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  2802dd:	ee                   	out    %al,(%dx)
  2802de:	8b 45 10             	mov    0x10(%ebp),%eax
  2802e1:	83 c0 01             	add    $0x1,%eax
  2802e4:	0f b6 00             	movzbl (%eax),%eax
  2802e7:	c0 e8 02             	shr    $0x2,%al
  2802ea:	0f b6 c0             	movzbl %al,%eax
  2802ed:	c7 45 e0 c9 03 00 00 	movl   $0x3c9,-0x20(%ebp)
  2802f4:	88 45 df             	mov    %al,-0x21(%ebp)
  2802f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  2802fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  2802fe:	ee                   	out    %al,(%dx)
  2802ff:	8b 45 10             	mov    0x10(%ebp),%eax
  280302:	83 c0 02             	add    $0x2,%eax
  280305:	0f b6 00             	movzbl (%eax),%eax
  280308:	c0 e8 02             	shr    $0x2,%al
  28030b:	0f b6 c0             	movzbl %al,%eax
  28030e:	c7 45 d8 c9 03 00 00 	movl   $0x3c9,-0x28(%ebp)
  280315:	88 45 d7             	mov    %al,-0x29(%ebp)
  280318:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  28031c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  28031f:	ee                   	out    %al,(%dx)
  280320:	83 45 10 03          	addl   $0x3,0x10(%ebp)
  280324:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28032b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  28032e:	7e 90                	jle    2802c0 <set_palette+0x32>
  280330:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280333:	89 45 d0             	mov    %eax,-0x30(%ebp)
  280336:	8b 45 d0             	mov    -0x30(%ebp),%eax
  280339:	50                   	push   %eax
  28033a:	9d                   	popf   
  28033b:	90                   	nop
  28033c:	c9                   	leave  
  28033d:	c3                   	ret    

0028033e <boxfill8>:
  28033e:	55                   	push   %ebp
  28033f:	89 e5                	mov    %esp,%ebp
  280341:	83 ec 14             	sub    $0x14,%esp
  280344:	8b 45 10             	mov    0x10(%ebp),%eax
  280347:	88 45 ec             	mov    %al,-0x14(%ebp)
  28034a:	8b 45 18             	mov    0x18(%ebp),%eax
  28034d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  280350:	eb 33                	jmp    280385 <boxfill8+0x47>
  280352:	8b 45 14             	mov    0x14(%ebp),%eax
  280355:	89 45 fc             	mov    %eax,-0x4(%ebp)
  280358:	eb 1f                	jmp    280379 <boxfill8+0x3b>
  28035a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28035d:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280361:	89 c2                	mov    %eax,%edx
  280363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280366:	01 d0                	add    %edx,%eax
  280368:	89 c2                	mov    %eax,%edx
  28036a:	8b 45 08             	mov    0x8(%ebp),%eax
  28036d:	01 c2                	add    %eax,%edx
  28036f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  280373:	88 02                	mov    %al,(%edx)
  280375:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28037c:	3b 45 1c             	cmp    0x1c(%ebp),%eax
  28037f:	7e d9                	jle    28035a <boxfill8+0x1c>
  280381:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  280385:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280388:	3b 45 20             	cmp    0x20(%ebp),%eax
  28038b:	7e c5                	jle    280352 <boxfill8+0x14>
  28038d:	c9                   	leave  
  28038e:	c3                   	ret    

0028038f <boxfill>:
  28038f:	55                   	push   %ebp
  280390:	89 e5                	mov    %esp,%ebp
  280392:	83 ec 20             	sub    $0x20,%esp
  280395:	8b 45 08             	mov    0x8(%ebp),%eax
  280398:	88 45 fc             	mov    %al,-0x4(%ebp)
  28039b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  28039f:	8b 55 18             	mov    0x18(%ebp),%edx
  2803a2:	89 54 24 18          	mov    %edx,0x18(%esp)
  2803a6:	8b 55 14             	mov    0x14(%ebp),%edx
  2803a9:	89 54 24 14          	mov    %edx,0x14(%esp)
  2803ad:	8b 55 10             	mov    0x10(%ebp),%edx
  2803b0:	89 54 24 10          	mov    %edx,0x10(%esp)
  2803b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  2803b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  2803bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  2803bf:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  2803c6:	00 
  2803c7:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  2803ce:	e8 6b ff ff ff       	call   28033e <boxfill8>
  2803d3:	c9                   	leave  
  2803d4:	c3                   	ret    

002803d5 <draw_window>:
  2803d5:	55                   	push   %ebp
  2803d6:	89 e5                	mov    %esp,%ebp
  2803d8:	53                   	push   %ebx
  2803d9:	83 ec 24             	sub    $0x24,%esp
  2803dc:	c7 45 f8 40 01 00 00 	movl   $0x140,-0x8(%ebp)
  2803e3:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
  2803ea:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
  2803f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2803f4:	8d 50 e3             	lea    -0x1d(%eax),%edx
  2803f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2803fa:	83 e8 01             	sub    $0x1,%eax
  2803fd:	89 54 24 10          	mov    %edx,0x10(%esp)
  280401:	89 44 24 0c          	mov    %eax,0xc(%esp)
  280405:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  28040c:	00 
  28040d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280414:	00 
  280415:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  28041c:	e8 6e ff ff ff       	call   28038f <boxfill>
  280421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280424:	8d 48 e4             	lea    -0x1c(%eax),%ecx
  280427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28042a:	8d 50 ff             	lea    -0x1(%eax),%edx
  28042d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280430:	83 e8 1c             	sub    $0x1c,%eax
  280433:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  280437:	89 54 24 0c          	mov    %edx,0xc(%esp)
  28043b:	89 44 24 08          	mov    %eax,0x8(%esp)
  28043f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280446:	00 
  280447:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  28044e:	e8 3c ff ff ff       	call   28038f <boxfill>
  280453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280456:	8d 48 e5             	lea    -0x1b(%eax),%ecx
  280459:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28045c:	8d 50 ff             	lea    -0x1(%eax),%edx
  28045f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280462:	83 e8 1b             	sub    $0x1b,%eax
  280465:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  280469:	89 54 24 0c          	mov    %edx,0xc(%esp)
  28046d:	89 44 24 08          	mov    %eax,0x8(%esp)
  280471:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280478:	00 
  280479:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  280480:	e8 0a ff ff ff       	call   28038f <boxfill>
  280485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280488:	8d 48 ff             	lea    -0x1(%eax),%ecx
  28048b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28048e:	8d 50 ff             	lea    -0x1(%eax),%edx
  280491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280494:	83 e8 1a             	sub    $0x1a,%eax
  280497:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  28049b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  28049f:	89 44 24 08          	mov    %eax,0x8(%esp)
  2804a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  2804aa:	00 
  2804ab:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  2804b2:	e8 d8 fe ff ff       	call   28038f <boxfill>
  2804b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804ba:	8d 50 e8             	lea    -0x18(%eax),%edx
  2804bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804c0:	83 e8 18             	sub    $0x18,%eax
  2804c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  2804c7:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  2804ce:	00 
  2804cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  2804d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  2804da:	00 
  2804db:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  2804e2:	e8 a8 fe ff ff       	call   28038f <boxfill>
  2804e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804ea:	8d 50 fc             	lea    -0x4(%eax),%edx
  2804ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804f0:	83 e8 18             	sub    $0x18,%eax
  2804f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  2804f7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  2804fe:	00 
  2804ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  280503:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  28050a:	00 
  28050b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  280512:	e8 78 fe ff ff       	call   28038f <boxfill>
  280517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28051a:	8d 50 fc             	lea    -0x4(%eax),%edx
  28051d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280520:	83 e8 04             	sub    $0x4,%eax
  280523:	89 54 24 10          	mov    %edx,0x10(%esp)
  280527:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  28052e:	00 
  28052f:	89 44 24 08          	mov    %eax,0x8(%esp)
  280533:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  28053a:	00 
  28053b:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280542:	e8 48 fe ff ff       	call   28038f <boxfill>
  280547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28054a:	8d 50 fb             	lea    -0x5(%eax),%edx
  28054d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280550:	83 e8 17             	sub    $0x17,%eax
  280553:	89 54 24 10          	mov    %edx,0x10(%esp)
  280557:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  28055e:	00 
  28055f:	89 44 24 08          	mov    %eax,0x8(%esp)
  280563:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  28056a:	00 
  28056b:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280572:	e8 18 fe ff ff       	call   28038f <boxfill>
  280577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28057a:	8d 50 fd             	lea    -0x3(%eax),%edx
  28057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280580:	83 e8 03             	sub    $0x3,%eax
  280583:	89 54 24 10          	mov    %edx,0x10(%esp)
  280587:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  28058e:	00 
  28058f:	89 44 24 08          	mov    %eax,0x8(%esp)
  280593:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  28059a:	00 
  28059b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2805a2:	e8 e8 fd ff ff       	call   28038f <boxfill>
  2805a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805aa:	8d 50 fd             	lea    -0x3(%eax),%edx
  2805ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805b0:	83 e8 18             	sub    $0x18,%eax
  2805b3:	89 54 24 10          	mov    %edx,0x10(%esp)
  2805b7:	c7 44 24 0c 3c 00 00 	movl   $0x3c,0xc(%esp)
  2805be:	00 
  2805bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  2805c3:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  2805ca:	00 
  2805cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2805d2:	e8 b8 fd ff ff       	call   28038f <boxfill>
  2805d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805da:	8d 58 e8             	lea    -0x18(%eax),%ebx
  2805dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2805e0:	8d 48 fc             	lea    -0x4(%eax),%ecx
  2805e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805e6:	8d 50 e8             	lea    -0x18(%eax),%edx
  2805e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2805ec:	83 e8 2f             	sub    $0x2f,%eax
  2805ef:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  2805f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2805f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  2805fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  2805ff:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280606:	e8 84 fd ff ff       	call   28038f <boxfill>
  28060b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28060e:	8d 58 fc             	lea    -0x4(%eax),%ebx
  280611:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280614:	8d 48 d1             	lea    -0x2f(%eax),%ecx
  280617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28061a:	8d 50 e9             	lea    -0x17(%eax),%edx
  28061d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280620:	83 e8 2f             	sub    $0x2f,%eax
  280623:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  280627:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  28062b:	89 54 24 08          	mov    %edx,0x8(%esp)
  28062f:	89 44 24 04          	mov    %eax,0x4(%esp)
  280633:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  28063a:	e8 50 fd ff ff       	call   28038f <boxfill>
  28063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280642:	8d 58 fd             	lea    -0x3(%eax),%ebx
  280645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280648:	8d 48 fc             	lea    -0x4(%eax),%ecx
  28064b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28064e:	8d 50 fd             	lea    -0x3(%eax),%edx
  280651:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280654:	83 e8 2f             	sub    $0x2f,%eax
  280657:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  28065b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  28065f:	89 54 24 08          	mov    %edx,0x8(%esp)
  280663:	89 44 24 04          	mov    %eax,0x4(%esp)
  280667:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  28066e:	e8 1c fd ff ff       	call   28038f <boxfill>
  280673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280676:	8d 58 fd             	lea    -0x3(%eax),%ebx
  280679:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28067c:	8d 48 fd             	lea    -0x3(%eax),%ecx
  28067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280682:	8d 50 e8             	lea    -0x18(%eax),%edx
  280685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280688:	83 e8 03             	sub    $0x3,%eax
  28068b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  28068f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  280693:	89 54 24 08          	mov    %edx,0x8(%esp)
  280697:	89 44 24 04          	mov    %eax,0x4(%esp)
  28069b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  2806a2:	e8 e8 fc ff ff       	call   28038f <boxfill>
  2806a7:	83 c4 24             	add    $0x24,%esp
  2806aa:	5b                   	pop    %ebx
  2806ab:	5d                   	pop    %ebp
  2806ac:	c3                   	ret    

002806ad <init_screen>:
  2806ad:	55                   	push   %ebp
  2806ae:	89 e5                	mov    %esp,%ebp
  2806b0:	8b 45 08             	mov    0x8(%ebp),%eax
  2806b3:	c7 00 00 00 0a 00    	movl   $0xa0000,(%eax)
  2806b9:	8b 45 08             	mov    0x8(%ebp),%eax
  2806bc:	c6 40 04 08          	movb   $0x8,0x4(%eax)
  2806c0:	8b 45 08             	mov    0x8(%ebp),%eax
  2806c3:	c7 40 08 40 01 00 00 	movl   $0x140,0x8(%eax)
  2806ca:	8b 45 08             	mov    0x8(%ebp),%eax
  2806cd:	c7 40 0c c8 00 00 00 	movl   $0xc8,0xc(%eax)
  2806d4:	5d                   	pop    %ebp
  2806d5:	c3                   	ret    

002806d6 <init_mouse>:
  2806d6:	55                   	push   %ebp
  2806d7:	89 e5                	mov    %esp,%ebp
  2806d9:	83 ec 14             	sub    $0x14,%esp
  2806dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  2806df:	88 45 ec             	mov    %al,-0x14(%ebp)
  2806e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  2806e9:	e9 8d 00 00 00       	jmp    28077b <init_mouse+0xa5>
  2806ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2806f5:	eb 7a                	jmp    280771 <init_mouse+0x9b>
  2806f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2806fa:	c1 e0 04             	shl    $0x4,%eax
  2806fd:	89 c2                	mov    %eax,%edx
  2806ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280702:	01 d0                	add    %edx,%eax
  280704:	05 e0 0c 28 00       	add    $0x280ce0,%eax
  280709:	0f b6 00             	movzbl (%eax),%eax
  28070c:	0f be c0             	movsbl %al,%eax
  28070f:	83 f8 2e             	cmp    $0x2e,%eax
  280712:	74 0c                	je     280720 <init_mouse+0x4a>
  280714:	83 f8 4f             	cmp    $0x4f,%eax
  280717:	74 3c                	je     280755 <init_mouse+0x7f>
  280719:	83 f8 2a             	cmp    $0x2a,%eax
  28071c:	74 1e                	je     28073c <init_mouse+0x66>
  28071e:	eb 4d                	jmp    28076d <init_mouse+0x97>
  280720:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280723:	c1 e0 04             	shl    $0x4,%eax
  280726:	89 c2                	mov    %eax,%edx
  280728:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28072b:	01 d0                	add    %edx,%eax
  28072d:	89 c2                	mov    %eax,%edx
  28072f:	8b 45 08             	mov    0x8(%ebp),%eax
  280732:	01 c2                	add    %eax,%edx
  280734:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  280738:	88 02                	mov    %al,(%edx)
  28073a:	eb 31                	jmp    28076d <init_mouse+0x97>
  28073c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28073f:	c1 e0 04             	shl    $0x4,%eax
  280742:	89 c2                	mov    %eax,%edx
  280744:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280747:	01 d0                	add    %edx,%eax
  280749:	89 c2                	mov    %eax,%edx
  28074b:	8b 45 08             	mov    0x8(%ebp),%eax
  28074e:	01 d0                	add    %edx,%eax
  280750:	c6 00 00             	movb   $0x0,(%eax)
  280753:	eb 18                	jmp    28076d <init_mouse+0x97>
  280755:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280758:	c1 e0 04             	shl    $0x4,%eax
  28075b:	89 c2                	mov    %eax,%edx
  28075d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280760:	01 d0                	add    %edx,%eax
  280762:	89 c2                	mov    %eax,%edx
  280764:	8b 45 08             	mov    0x8(%ebp),%eax
  280767:	01 d0                	add    %edx,%eax
  280769:	c6 00 02             	movb   $0x2,(%eax)
  28076c:	90                   	nop
  28076d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280771:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
  280775:	7e 80                	jle    2806f7 <init_mouse+0x21>
  280777:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  28077b:	83 7d f8 0f          	cmpl   $0xf,-0x8(%ebp)
  28077f:	0f 8e 69 ff ff ff    	jle    2806ee <init_mouse+0x18>
  280785:	c9                   	leave  
  280786:	c3                   	ret    

00280787 <display_mouse>:
  280787:	55                   	push   %ebp
  280788:	89 e5                	mov    %esp,%ebp
  28078a:	83 ec 10             	sub    $0x10,%esp
  28078d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  280794:	eb 50                	jmp    2807e6 <display_mouse+0x5f>
  280796:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  28079d:	eb 3b                	jmp    2807da <display_mouse+0x53>
  28079f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807a2:	8b 55 1c             	mov    0x1c(%ebp),%edx
  2807a5:	01 d0                	add    %edx,%eax
  2807a7:	0f af 45 0c          	imul   0xc(%ebp),%eax
  2807ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  2807ae:	8b 4d 18             	mov    0x18(%ebp),%ecx
  2807b1:	01 ca                	add    %ecx,%edx
  2807b3:	01 d0                	add    %edx,%eax
  2807b5:	89 c2                	mov    %eax,%edx
  2807b7:	8b 45 08             	mov    0x8(%ebp),%eax
  2807ba:	01 c2                	add    %eax,%edx
  2807bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807bf:	0f af 45 24          	imul   0x24(%ebp),%eax
  2807c3:	89 c1                	mov    %eax,%ecx
  2807c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2807c8:	01 c8                	add    %ecx,%eax
  2807ca:	89 c1                	mov    %eax,%ecx
  2807cc:	8b 45 20             	mov    0x20(%ebp),%eax
  2807cf:	01 c8                	add    %ecx,%eax
  2807d1:	0f b6 00             	movzbl (%eax),%eax
  2807d4:	88 02                	mov    %al,(%edx)
  2807d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2807da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2807dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  2807e0:	7c bd                	jl     28079f <display_mouse+0x18>
  2807e2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  2807e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  2807ec:	7c a8                	jl     280796 <display_mouse+0xf>
  2807ee:	c9                   	leave  
  2807ef:	c3                   	ret    

002807f0 <putchar>:
  2807f0:	55                   	push   %ebp
  2807f1:	89 e5                	mov    %esp,%ebp
  2807f3:	83 ec 18             	sub    $0x18,%esp
  2807f6:	8b 55 08             	mov    0x8(%ebp),%edx
  2807f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  2807fc:	88 55 ec             	mov    %dl,-0x14(%ebp)
  2807ff:	88 45 e8             	mov    %al,-0x18(%ebp)
  280802:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
  280806:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  28080d:	e9 a2 00 00 00       	jmp    2808b4 <putchar+0xc4>
  280812:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  280816:	c1 e0 04             	shl    $0x4,%eax
  280819:	89 c2                	mov    %eax,%edx
  28081b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28081e:	01 d0                	add    %edx,%eax
  280820:	0f b6 80 40 10 28 00 	movzbl 0x281040(%eax),%eax
  280827:	88 45 f6             	mov    %al,-0xa(%ebp)
  28082a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  280831:	eb 77                	jmp    2808aa <putchar+0xba>
  280833:	b8 07 00 00 00       	mov    $0x7,%eax
  280838:	2b 45 fc             	sub    -0x4(%ebp),%eax
  28083b:	ba 01 00 00 00       	mov    $0x1,%edx
  280840:	89 c1                	mov    %eax,%ecx
  280842:	d3 e2                	shl    %cl,%edx
  280844:	89 d0                	mov    %edx,%eax
  280846:	88 45 f7             	mov    %al,-0x9(%ebp)
  280849:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  28084d:	0f b6 55 f6          	movzbl -0xa(%ebp),%edx
  280851:	21 d0                	and    %edx,%eax
  280853:	84 c0                	test   %al,%al
  280855:	74 2a                	je     280881 <putchar+0x91>
  280857:	8b 45 10             	mov    0x10(%ebp),%eax
  28085a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  28085d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  280860:	8b 45 14             	mov    0x14(%ebp),%eax
  280863:	8b 55 f8             	mov    -0x8(%ebp),%edx
  280866:	01 c2                	add    %eax,%edx
  280868:	89 d0                	mov    %edx,%eax
  28086a:	c1 e0 02             	shl    $0x2,%eax
  28086d:	01 d0                	add    %edx,%eax
  28086f:	c1 e0 06             	shl    $0x6,%eax
  280872:	01 c8                	add    %ecx,%eax
  280874:	05 00 00 0a 00       	add    $0xa0000,%eax
  280879:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
  28087d:	88 10                	mov    %dl,(%eax)
  28087f:	eb 25                	jmp    2808a6 <putchar+0xb6>
  280881:	8b 45 10             	mov    0x10(%ebp),%eax
  280884:	8b 55 fc             	mov    -0x4(%ebp),%edx
  280887:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  28088a:	8b 45 14             	mov    0x14(%ebp),%eax
  28088d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  280890:	01 c2                	add    %eax,%edx
  280892:	89 d0                	mov    %edx,%eax
  280894:	c1 e0 02             	shl    $0x2,%eax
  280897:	01 d0                	add    %edx,%eax
  280899:	c1 e0 06             	shl    $0x6,%eax
  28089c:	01 c8                	add    %ecx,%eax
  28089e:	05 00 00 0a 00       	add    $0xa0000,%eax
  2808a3:	c6 00 00             	movb   $0x0,(%eax)
  2808a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2808aa:	83 7d fc 07          	cmpl   $0x7,-0x4(%ebp)
  2808ae:	76 83                	jbe    280833 <putchar+0x43>
  2808b0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  2808b4:	83 7d f8 0f          	cmpl   $0xf,-0x8(%ebp)
  2808b8:	0f 86 54 ff ff ff    	jbe    280812 <putchar+0x22>
  2808be:	c9                   	leave  
  2808bf:	c3                   	ret    

002808c0 <puts>:
  2808c0:	55                   	push   %ebp
  2808c1:	89 e5                	mov    %esp,%ebp
  2808c3:	83 ec 14             	sub    $0x14,%esp
  2808c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  2808c9:	88 45 fc             	mov    %al,-0x4(%ebp)
  2808cc:	eb 31                	jmp    2808ff <puts+0x3f>
  2808ce:	83 45 10 08          	addl   $0x8,0x10(%ebp)
  2808d2:	0f be 55 fc          	movsbl -0x4(%ebp),%edx
  2808d6:	8b 45 08             	mov    0x8(%ebp),%eax
  2808d9:	8d 48 01             	lea    0x1(%eax),%ecx
  2808dc:	89 4d 08             	mov    %ecx,0x8(%ebp)
  2808df:	0f b6 00             	movzbl (%eax),%eax
  2808e2:	0f b6 c0             	movzbl %al,%eax
  2808e5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  2808e8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2808ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  2808ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  2808f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  2808f7:	89 04 24             	mov    %eax,(%esp)
  2808fa:	e8 f1 fe ff ff       	call   2807f0 <putchar>
  2808ff:	8b 45 08             	mov    0x8(%ebp),%eax
  280902:	0f b6 00             	movzbl (%eax),%eax
  280905:	84 c0                	test   %al,%al
  280907:	75 c5                	jne    2808ce <puts+0xe>
  280909:	c9                   	leave  
  28090a:	c3                   	ret    

0028090b <sprintf>:
  28090b:	55                   	push   %ebp
  28090c:	89 e5                	mov    %esp,%ebp
  28090e:	83 ec 28             	sub    $0x28,%esp
  280911:	8d 45 0c             	lea    0xc(%ebp),%eax
  280914:	83 c0 04             	add    $0x4,%eax
  280917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  28091a:	e9 83 00 00 00       	jmp    2809a2 <sprintf+0x97>
  28091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  280922:	0f b6 00             	movzbl (%eax),%eax
  280925:	3c 25                	cmp    $0x25,%al
  280927:	75 62                	jne    28098b <sprintf+0x80>
  280929:	8b 45 0c             	mov    0xc(%ebp),%eax
  28092c:	83 c0 01             	add    $0x1,%eax
  28092f:	89 45 0c             	mov    %eax,0xc(%ebp)
  280932:	8b 45 0c             	mov    0xc(%ebp),%eax
  280935:	0f b6 00             	movzbl (%eax),%eax
  280938:	0f be c0             	movsbl %al,%eax
  28093b:	83 f8 25             	cmp    $0x25,%eax
  28093e:	74 07                	je     280947 <sprintf+0x3c>
  280940:	83 f8 64             	cmp    $0x64,%eax
  280943:	74 19                	je     28095e <sprintf+0x53>
  280945:	eb 42                	jmp    280989 <sprintf+0x7e>
  280947:	8b 45 08             	mov    0x8(%ebp),%eax
  28094a:	8d 50 01             	lea    0x1(%eax),%edx
  28094d:	89 55 08             	mov    %edx,0x8(%ebp)
  280950:	c6 00 25             	movb   $0x25,(%eax)
  280953:	8b 45 0c             	mov    0xc(%ebp),%eax
  280956:	83 c0 01             	add    $0x1,%eax
  280959:	89 45 0c             	mov    %eax,0xc(%ebp)
  28095c:	eb 2b                	jmp    280989 <sprintf+0x7e>
  28095e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280961:	8b 00                	mov    (%eax),%eax
  280963:	8b 55 08             	mov    0x8(%ebp),%edx
  280966:	89 54 24 04          	mov    %edx,0x4(%esp)
  28096a:	89 04 24             	mov    %eax,(%esp)
  28096d:	e8 40 00 00 00       	call   2809b2 <int2str>
  280972:	89 45 f0             	mov    %eax,-0x10(%ebp)
  280975:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
  280979:	8b 45 0c             	mov    0xc(%ebp),%eax
  28097c:	83 c0 01             	add    $0x1,%eax
  28097f:	89 45 0c             	mov    %eax,0xc(%ebp)
  280982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280985:	01 45 08             	add    %eax,0x8(%ebp)
  280988:	90                   	nop
  280989:	eb 17                	jmp    2809a2 <sprintf+0x97>
  28098b:	8b 45 08             	mov    0x8(%ebp),%eax
  28098e:	8d 50 01             	lea    0x1(%eax),%edx
  280991:	89 55 08             	mov    %edx,0x8(%ebp)
  280994:	8b 55 0c             	mov    0xc(%ebp),%edx
  280997:	8d 4a 01             	lea    0x1(%edx),%ecx
  28099a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  28099d:	0f b6 12             	movzbl (%edx),%edx
  2809a0:	88 10                	mov    %dl,(%eax)
  2809a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  2809a5:	0f b6 00             	movzbl (%eax),%eax
  2809a8:	84 c0                	test   %al,%al
  2809aa:	0f 85 6f ff ff ff    	jne    28091f <sprintf+0x14>
  2809b0:	c9                   	leave  
  2809b1:	c3                   	ret    

002809b2 <int2str>:
  2809b2:	55                   	push   %ebp
  2809b3:	89 e5                	mov    %esp,%ebp
  2809b5:	83 ec 20             	sub    $0x20,%esp
  2809b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2809bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2809c2:	ba 67 66 66 66       	mov    $0x66666667,%edx
  2809c7:	89 c8                	mov    %ecx,%eax
  2809c9:	f7 ea                	imul   %edx
  2809cb:	c1 fa 02             	sar    $0x2,%edx
  2809ce:	89 c8                	mov    %ecx,%eax
  2809d0:	c1 f8 1f             	sar    $0x1f,%eax
  2809d3:	29 c2                	sub    %eax,%edx
  2809d5:	89 d0                	mov    %edx,%eax
  2809d7:	c1 e0 02             	shl    $0x2,%eax
  2809da:	01 d0                	add    %edx,%eax
  2809dc:	01 c0                	add    %eax,%eax
  2809de:	29 c1                	sub    %eax,%ecx
  2809e0:	89 c8                	mov    %ecx,%eax
  2809e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  2809e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2809e8:	83 c0 30             	add    $0x30,%eax
  2809eb:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  2809ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  2809f1:	01 ca                	add    %ecx,%edx
  2809f3:	88 02                	mov    %al,(%edx)
  2809f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2809f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2809fc:	ba 67 66 66 66       	mov    $0x66666667,%edx
  280a01:	89 c8                	mov    %ecx,%eax
  280a03:	f7 ea                	imul   %edx
  280a05:	c1 fa 02             	sar    $0x2,%edx
  280a08:	89 c8                	mov    %ecx,%eax
  280a0a:	c1 f8 1f             	sar    $0x1f,%eax
  280a0d:	29 c2                	sub    %eax,%edx
  280a0f:	89 d0                	mov    %edx,%eax
  280a11:	89 45 08             	mov    %eax,0x8(%ebp)
  280a14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  280a18:	75 a5                	jne    2809bf <int2str+0xd>
  280a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  280a20:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  280a24:	eb 1a                	jmp    280a40 <int2str+0x8e>
  280a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a29:	8d 50 01             	lea    0x1(%eax),%edx
  280a2c:	89 55 0c             	mov    %edx,0xc(%ebp)
  280a2f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  280a32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  280a35:	01 ca                	add    %ecx,%edx
  280a37:	0f b6 12             	movzbl (%edx),%edx
  280a3a:	88 10                	mov    %dl,(%eax)
  280a3c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  280a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  280a44:	79 e0                	jns    280a26 <int2str+0x74>
  280a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280a49:	c9                   	leave  
  280a4a:	c3                   	ret    

00280a4b <setgdt>:
  280a4b:	55                   	push   %ebp
  280a4c:	89 e5                	mov    %esp,%ebp
  280a4e:	81 7d 0c ff ff 00 00 	cmpl   $0xffff,0xc(%ebp)
  280a55:	76 10                	jbe    280a67 <setgdt+0x1c>
  280a57:	81 4d 14 00 80 00 00 	orl    $0x8000,0x14(%ebp)
  280a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a61:	c1 e8 0c             	shr    $0xc,%eax
  280a64:	89 45 0c             	mov    %eax,0xc(%ebp)
  280a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a6a:	89 c2                	mov    %eax,%edx
  280a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  280a6f:	66 89 10             	mov    %dx,(%eax)
  280a72:	8b 45 10             	mov    0x10(%ebp),%eax
  280a75:	89 c2                	mov    %eax,%edx
  280a77:	8b 45 08             	mov    0x8(%ebp),%eax
  280a7a:	66 89 50 02          	mov    %dx,0x2(%eax)
  280a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  280a81:	c1 f8 10             	sar    $0x10,%eax
  280a84:	89 c2                	mov    %eax,%edx
  280a86:	8b 45 08             	mov    0x8(%ebp),%eax
  280a89:	88 50 04             	mov    %dl,0x4(%eax)
  280a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  280a8f:	89 c2                	mov    %eax,%edx
  280a91:	8b 45 08             	mov    0x8(%ebp),%eax
  280a94:	88 50 05             	mov    %dl,0x5(%eax)
  280a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a9a:	c1 e8 10             	shr    $0x10,%eax
  280a9d:	83 e0 0f             	and    $0xf,%eax
  280aa0:	89 c2                	mov    %eax,%edx
  280aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  280aa5:	c1 f8 08             	sar    $0x8,%eax
  280aa8:	83 e0 f0             	and    $0xfffffff0,%eax
  280aab:	09 d0                	or     %edx,%eax
  280aad:	89 c2                	mov    %eax,%edx
  280aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  280ab2:	88 50 06             	mov    %dl,0x6(%eax)
  280ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  280ab8:	c1 e8 18             	shr    $0x18,%eax
  280abb:	89 c2                	mov    %eax,%edx
  280abd:	8b 45 08             	mov    0x8(%ebp),%eax
  280ac0:	88 50 07             	mov    %dl,0x7(%eax)
  280ac3:	5d                   	pop    %ebp
  280ac4:	c3                   	ret    

00280ac5 <setidt>:
  280ac5:	55                   	push   %ebp
  280ac6:	89 e5                	mov    %esp,%ebp
  280ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  280acb:	89 c2                	mov    %eax,%edx
  280acd:	8b 45 08             	mov    0x8(%ebp),%eax
  280ad0:	66 89 10             	mov    %dx,(%eax)
  280ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  280ad6:	c1 e8 10             	shr    $0x10,%eax
  280ad9:	89 c2                	mov    %eax,%edx
  280adb:	8b 45 08             	mov    0x8(%ebp),%eax
  280ade:	66 89 50 06          	mov    %dx,0x6(%eax)
  280ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  280ae5:	89 c2                	mov    %eax,%edx
  280ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  280aea:	66 89 50 02          	mov    %dx,0x2(%eax)
  280aee:	8b 45 14             	mov    0x14(%ebp),%eax
  280af1:	c1 f8 08             	sar    $0x8,%eax
  280af4:	89 c2                	mov    %eax,%edx
  280af6:	8b 45 08             	mov    0x8(%ebp),%eax
  280af9:	88 50 04             	mov    %dl,0x4(%eax)
  280afc:	8b 45 14             	mov    0x14(%ebp),%eax
  280aff:	89 c2                	mov    %eax,%edx
  280b01:	8b 45 08             	mov    0x8(%ebp),%eax
  280b04:	88 50 05             	mov    %dl,0x5(%eax)
  280b07:	5d                   	pop    %ebp
  280b08:	c3                   	ret    

00280b09 <init_gdtidt>:
  280b09:	55                   	push   %ebp
  280b0a:	89 e5                	mov    %esp,%ebp
  280b0c:	83 ec 28             	sub    $0x28,%esp
  280b0f:	c7 45 f0 00 00 27 00 	movl   $0x270000,-0x10(%ebp)
  280b16:	c7 45 ec 00 f8 26 00 	movl   $0x26f800,-0x14(%ebp)
  280b1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280b24:	eb 33                	jmp    280b59 <init_gdtidt+0x50>
  280b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280b29:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  280b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b33:	01 d0                	add    %edx,%eax
  280b35:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  280b3c:	00 
  280b3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280b44:	00 
  280b45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280b4c:	00 
  280b4d:	89 04 24             	mov    %eax,(%esp)
  280b50:	e8 f6 fe ff ff       	call   280a4b <setgdt>
  280b55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280b59:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  280b60:	7e c4                	jle    280b26 <init_gdtidt+0x1d>
  280b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b65:	83 c0 08             	add    $0x8,%eax
  280b68:	c7 44 24 0c 92 40 00 	movl   $0x4092,0xc(%esp)
  280b6f:	00 
  280b70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280b77:	00 
  280b78:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
  280b7f:	ff 
  280b80:	89 04 24             	mov    %eax,(%esp)
  280b83:	e8 c3 fe ff ff       	call   280a4b <setgdt>
  280b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b8b:	83 c0 10             	add    $0x10,%eax
  280b8e:	c7 44 24 0c 9a 40 00 	movl   $0x409a,0xc(%esp)
  280b95:	00 
  280b96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280b9d:	00 
  280b9e:	c7 44 24 04 ff ff 0f 	movl   $0xfffff,0x4(%esp)
  280ba5:	00 
  280ba6:	89 04 24             	mov    %eax,(%esp)
  280ba9:	e8 9d fe ff ff       	call   280a4b <setgdt>
  280bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280bb1:	83 c0 18             	add    $0x18,%eax
  280bb4:	c7 44 24 0c 9a 40 00 	movl   $0x409a,0xc(%esp)
  280bbb:	00 
  280bbc:	c7 44 24 08 00 00 28 	movl   $0x280000,0x8(%esp)
  280bc3:	00 
  280bc4:	c7 44 24 04 ff ff 0f 	movl   $0xfffff,0x4(%esp)
  280bcb:	00 
  280bcc:	89 04 24             	mov    %eax,(%esp)
  280bcf:	e8 77 fe ff ff       	call   280a4b <setgdt>
  280bd4:	c7 44 24 04 00 00 27 	movl   $0x270000,0x4(%esp)
  280bdb:	00 
  280bdc:	c7 04 24 ff 0f 00 00 	movl   $0xfff,(%esp)
  280be3:	e8 88 00 00 00       	call   280c70 <load_gdtr>
  280be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280bef:	eb 33                	jmp    280c24 <init_gdtidt+0x11b>
  280bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280bf4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  280bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  280bfe:	01 d0                	add    %edx,%eax
  280c00:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  280c07:	00 
  280c08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280c0f:	00 
  280c10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280c17:	00 
  280c18:	89 04 24             	mov    %eax,(%esp)
  280c1b:	e8 a5 fe ff ff       	call   280ac5 <setidt>
  280c20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280c24:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
  280c2b:	7e c4                	jle    280bf1 <init_gdtidt+0xe8>
  280c2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280c34:	eb 04                	jmp    280c3a <init_gdtidt+0x131>
  280c36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280c3a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
  280c41:	7e f3                	jle    280c36 <init_gdtidt+0x12d>
  280c43:	c7 44 24 04 00 f8 26 	movl   $0x26f800,0x4(%esp)
  280c4a:	00 
  280c4b:	c7 04 24 ff 07 00 00 	movl   $0x7ff,(%esp)
  280c52:	e8 29 00 00 00       	call   280c80 <load_idtr>
  280c57:	90                   	nop
  280c58:	c9                   	leave  
  280c59:	c3                   	ret    

00280c5a <asm_inthandler21>:
  280c5a:	66 06                	pushw  %es
  280c5c:	66 1e                	pushw  %ds
  280c5e:	60                   	pusha  
  280c5f:	89 e0                	mov    %esp,%eax
  280c61:	50                   	push   %eax
  280c62:	66 8c d0             	mov    %ss,%ax
  280c65:	8e d8                	mov    %eax,%ds
  280c67:	8e c0                	mov    %eax,%es
  280c69:	58                   	pop    %eax
  280c6a:	61                   	popa   
  280c6b:	66 1f                	popw   %ds
  280c6d:	66 07                	popw   %es
  280c6f:	cf                   	iret   

00280c70 <load_gdtr>:
  280c70:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  280c75:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  280c7a:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  280c7f:	c3                   	ret    

00280c80 <load_idtr>:
  280c80:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  280c85:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  280c8a:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  280c8f:	c3                   	ret    

Disassembly of section .rodata:

00280ca0 <cursor.1683-0x40>:
  280ca0:	31 32                	xor    %esi,(%edx)
  280ca2:	33 34 33             	xor    (%ebx,%esi,1),%esi
  280ca5:	35 35 36 35 36       	xor    $0x36353635,%eax
  280caa:	00 68 65             	add    %ch,0x65(%eax)
  280cad:	6c                   	insb   (%dx),%es:(%edi)
  280cae:	6c                   	insb   (%dx),%es:(%edi)
  280caf:	6f                   	outsl  %ds:(%esi),(%dx)
  280cb0:	20 77 6f             	and    %dh,0x6f(%edi)
  280cb3:	72 6c                	jb     280d21 <cursor.1683+0x41>
  280cb5:	64 00 78 73          	add    %bh,%fs:0x73(%eax)
  280cb9:	69 7a 65 3d 25 64 2c 	imul   $0x2c64253d,0x65(%edx),%edi
  280cc0:	79 73                	jns    280d35 <cursor.1683+0x55>
  280cc2:	69 7a 65 3d 25 64 00 	imul   $0x64253d,0x65(%edx),%edi
	...

00280ce0 <cursor.1683>:
  280ce0:	2a 2a                	sub    (%edx),%ch
  280ce2:	2a 2a                	sub    (%edx),%ch
  280ce4:	2a 2a                	sub    (%edx),%ch
  280ce6:	2a 2a                	sub    (%edx),%ch
  280ce8:	2a 2a                	sub    (%edx),%ch
  280cea:	2a 2a                	sub    (%edx),%ch
  280cec:	2a 2a                	sub    (%edx),%ch
  280cee:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  280cf3:	4f                   	dec    %edi
  280cf4:	4f                   	dec    %edi
  280cf5:	4f                   	dec    %edi
  280cf6:	4f                   	dec    %edi
  280cf7:	4f                   	dec    %edi
  280cf8:	4f                   	dec    %edi
  280cf9:	4f                   	dec    %edi
  280cfa:	4f                   	dec    %edi
  280cfb:	4f                   	dec    %edi
  280cfc:	2a 2e                	sub    (%esi),%ch
  280cfe:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  280d03:	4f                   	dec    %edi
  280d04:	4f                   	dec    %edi
  280d05:	4f                   	dec    %edi
  280d06:	4f                   	dec    %edi
  280d07:	4f                   	dec    %edi
  280d08:	4f                   	dec    %edi
  280d09:	4f                   	dec    %edi
  280d0a:	4f                   	dec    %edi
  280d0b:	2a 2e                	sub    (%esi),%ch
  280d0d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280d13:	4f                   	dec    %edi
  280d14:	4f                   	dec    %edi
  280d15:	4f                   	dec    %edi
  280d16:	4f                   	dec    %edi
  280d17:	4f                   	dec    %edi
  280d18:	4f                   	dec    %edi
  280d19:	4f                   	dec    %edi
  280d1a:	2a 2e                	sub    (%esi),%ch
  280d1c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  280d23:	4f                   	dec    %edi
  280d24:	4f                   	dec    %edi
  280d25:	4f                   	dec    %edi
  280d26:	4f                   	dec    %edi
  280d27:	4f                   	dec    %edi
  280d28:	4f                   	dec    %edi
  280d29:	2a 2e                	sub    (%esi),%ch
  280d2b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d32:	4f 
  280d33:	4f                   	dec    %edi
  280d34:	4f                   	dec    %edi
  280d35:	4f                   	dec    %edi
  280d36:	4f                   	dec    %edi
  280d37:	4f                   	dec    %edi
  280d38:	2a 2e                	sub    (%esi),%ch
  280d3a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d41:	4f 4f 
  280d43:	4f                   	dec    %edi
  280d44:	4f                   	dec    %edi
  280d45:	4f                   	dec    %edi
  280d46:	4f                   	dec    %edi
  280d47:	4f                   	dec    %edi
  280d48:	2a 2e                	sub    (%esi),%ch
  280d4a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d51:	4f 4f 
  280d53:	4f                   	dec    %edi
  280d54:	4f                   	dec    %edi
  280d55:	4f                   	dec    %edi
  280d56:	4f                   	dec    %edi
  280d57:	4f                   	dec    %edi
  280d58:	4f                   	dec    %edi
  280d59:	2a 2e                	sub    (%esi),%ch
  280d5b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d62:	4f 
  280d63:	4f                   	dec    %edi
  280d64:	4f                   	dec    %edi
  280d65:	2a 2a                	sub    (%edx),%ch
  280d67:	4f                   	dec    %edi
  280d68:	4f                   	dec    %edi
  280d69:	4f                   	dec    %edi
  280d6a:	2a 2e                	sub    (%esi),%ch
  280d6c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  280d73:	4f                   	dec    %edi
  280d74:	2a 2e                	sub    (%esi),%ch
  280d76:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  280d7a:	4f                   	dec    %edi
  280d7b:	2a 2e                	sub    (%esi),%ch
  280d7d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280d83:	2a 2e                	sub    (%esi),%ch
  280d85:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280d8b:	4f                   	dec    %edi
  280d8c:	2a 2e                	sub    (%esi),%ch
  280d8e:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  280d93:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d9a:	4f 4f 
  280d9c:	4f                   	dec    %edi
  280d9d:	2a 2e                	sub    (%esi),%ch
  280d9f:	2e 2a 2a             	sub    %cs:(%edx),%ch
  280da2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280da9:	2e 2a 4f 4f 
  280dad:	4f                   	dec    %edi
  280dae:	2a 2e                	sub    (%esi),%ch
  280db0:	2a 2e                	sub    (%esi),%ch
  280db2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280db9:	2e 2e 2a 4f 4f 
  280dbe:	4f                   	dec    %edi
  280dbf:	2a 2e                	sub    (%esi),%ch
  280dc1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280dc8:	2e 2e 2e 2e 2a 4f 4f 
  280dcf:	2a 2e                	sub    (%esi),%ch
  280dd1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  280dd8:	2e 2e 2e 2e 2e 2a 2a 
  280ddf:	2a                   	.byte 0x2a

Disassembly of section .eh_frame:

00280de0 <.eh_frame>:
  280de0:	14 00                	adc    $0x0,%al
  280de2:	00 00                	add    %al,(%eax)
  280de4:	00 00                	add    %al,(%eax)
  280de6:	00 00                	add    %al,(%eax)
  280de8:	01 7a 52             	add    %edi,0x52(%edx)
  280deb:	00 01                	add    %al,(%ecx)
  280ded:	7c 08                	jl     280df7 <cursor.1683+0x117>
  280def:	01 1b                	add    %ebx,(%ebx)
  280df1:	0c 04                	or     $0x4,%al
  280df3:	04 88                	add    $0x88,%al
  280df5:	01 00                	add    %eax,(%eax)
  280df7:	00 18                	add    %bl,(%eax)
  280df9:	00 00                	add    %al,(%eax)
  280dfb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280dfe:	00 00                	add    %al,(%eax)
  280e00:	00 f2                	add    %dh,%dl
  280e02:	ff                   	(bad)  
  280e03:	ff 52 01             	call   *0x1(%edx)
  280e06:	00 00                	add    %al,(%eax)
  280e08:	00 41 0e             	add    %al,0xe(%ecx)
  280e0b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e11:	00 00                	add    %al,(%eax)
  280e13:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280e16:	00 00                	add    %al,(%eax)
  280e18:	38 00                	cmp    %al,(%eax)
  280e1a:	00 00                	add    %al,(%eax)
  280e1c:	36                   	ss
  280e1d:	f3 ff                	repz (bad) 
  280e1f:	ff 2d 00 00 00 00    	ljmp   *0x0
  280e25:	41                   	inc    %ecx
  280e26:	0e                   	push   %cs
  280e27:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e2d:	69 c5 0c 04 04 00    	imul   $0x4040c,%ebp,%eax
  280e33:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280e36:	00 00                	add    %al,(%eax)
  280e38:	58                   	pop    %eax
  280e39:	00 00                	add    %al,(%eax)
  280e3b:	00 43 f3             	add    %al,-0xd(%ebx)
  280e3e:	ff                   	(bad)  
  280e3f:	ff 2c 00             	ljmp   *(%eax,%eax,1)
  280e42:	00 00                	add    %al,(%eax)
  280e44:	00 41 0e             	add    %al,0xe(%ecx)
  280e47:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e4d:	68 c5 0c 04 04       	push   $0x4040cc5
  280e52:	00 00                	add    %al,(%eax)
  280e54:	1c 00                	sbb    $0x0,%al
  280e56:	00 00                	add    %al,(%eax)
  280e58:	78 00                	js     280e5a <cursor.1683+0x17a>
  280e5a:	00 00                	add    %al,(%eax)
  280e5c:	4f                   	dec    %edi
  280e5d:	f3 ff                	repz (bad) 
  280e5f:	ff e3                	jmp    *%ebx
  280e61:	00 00                	add    %al,(%eax)
  280e63:	00 00                	add    %al,(%eax)
  280e65:	41                   	inc    %ecx
  280e66:	0e                   	push   %cs
  280e67:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e6d:	02 df                	add    %bh,%bl
  280e6f:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280e72:	04 00                	add    $0x0,%al
  280e74:	1c 00                	sbb    $0x0,%al
  280e76:	00 00                	add    %al,(%eax)
  280e78:	98                   	cwtl   
  280e79:	00 00                	add    %al,(%eax)
  280e7b:	00 12                	add    %dl,(%edx)
  280e7d:	f4                   	hlt    
  280e7e:	ff                   	(bad)  
  280e7f:	ff b0 00 00 00 00    	pushl  0x0(%eax)
  280e85:	41                   	inc    %ecx
  280e86:	0e                   	push   %cs
  280e87:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e8d:	02 ac c5 0c 04 04 00 	add    0x4040c(%ebp,%eax,8),%ch
  280e94:	1c 00                	sbb    $0x0,%al
  280e96:	00 00                	add    %al,(%eax)
  280e98:	b8 00 00 00 a2       	mov    $0xa2000000,%eax
  280e9d:	f4                   	hlt    
  280e9e:	ff                   	(bad)  
  280e9f:	ff 51 00             	call   *0x0(%ecx)
  280ea2:	00 00                	add    %al,(%eax)
  280ea4:	00 41 0e             	add    %al,0xe(%ecx)
  280ea7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ead:	02 4d c5             	add    -0x3b(%ebp),%cl
  280eb0:	0c 04                	or     $0x4,%al
  280eb2:	04 00                	add    $0x0,%al
  280eb4:	1c 00                	sbb    $0x0,%al
  280eb6:	00 00                	add    %al,(%eax)
  280eb8:	d8 00                	fadds  (%eax)
  280eba:	00 00                	add    %al,(%eax)
  280ebc:	d3                   	(bad)  
  280ebd:	f4                   	hlt    
  280ebe:	ff                   	(bad)  
  280ebf:	ff 46 00             	incl   0x0(%esi)
  280ec2:	00 00                	add    %al,(%eax)
  280ec4:	00 41 0e             	add    %al,0xe(%ecx)
  280ec7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ecd:	02 42 c5             	add    -0x3b(%edx),%al
  280ed0:	0c 04                	or     $0x4,%al
  280ed2:	04 00                	add    $0x0,%al
  280ed4:	24 00                	and    $0x0,%al
  280ed6:	00 00                	add    %al,(%eax)
  280ed8:	f8                   	clc    
  280ed9:	00 00                	add    %al,(%eax)
  280edb:	00 f9                	add    %bh,%cl
  280edd:	f4                   	hlt    
  280ede:	ff                   	(bad)  
  280edf:	ff                   	(bad)  
  280ee0:	d8 02                	fadds  (%edx)
  280ee2:	00 00                	add    %al,(%eax)
  280ee4:	00 41 0e             	add    %al,0xe(%ecx)
  280ee7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280eed:	44                   	inc    %esp
  280eee:	83 03 03             	addl   $0x3,(%ebx)
  280ef1:	cf                   	iret   
  280ef2:	02 c3                	add    %bl,%al
  280ef4:	41                   	inc    %ecx
  280ef5:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280ef8:	04 00                	add    $0x0,%al
  280efa:	00 00                	add    %al,(%eax)
  280efc:	1c 00                	sbb    $0x0,%al
  280efe:	00 00                	add    %al,(%eax)
  280f00:	20 01                	and    %al,(%ecx)
  280f02:	00 00                	add    %al,(%eax)
  280f04:	a9 f7 ff ff 29       	test   $0x29fffff7,%eax
  280f09:	00 00                	add    %al,(%eax)
  280f0b:	00 00                	add    %al,(%eax)
  280f0d:	41                   	inc    %ecx
  280f0e:	0e                   	push   %cs
  280f0f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f15:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
  280f19:	04 00                	add    $0x0,%al
  280f1b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280f1e:	00 00                	add    %al,(%eax)
  280f20:	40                   	inc    %eax
  280f21:	01 00                	add    %eax,(%eax)
  280f23:	00 b2 f7 ff ff b1    	add    %dh,-0x4e000009(%edx)
  280f29:	00 00                	add    %al,(%eax)
  280f2b:	00 00                	add    %al,(%eax)
  280f2d:	41                   	inc    %ecx
  280f2e:	0e                   	push   %cs
  280f2f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f35:	02 ad c5 0c 04 04    	add    0x4040cc5(%ebp),%ch
  280f3b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280f3e:	00 00                	add    %al,(%eax)
  280f40:	60                   	pusha  
  280f41:	01 00                	add    %eax,(%eax)
  280f43:	00 43 f8             	add    %al,-0x8(%ebx)
  280f46:	ff                   	(bad)  
  280f47:	ff 69 00             	ljmp   *0x0(%ecx)
  280f4a:	00 00                	add    %al,(%eax)
  280f4c:	00 41 0e             	add    %al,0xe(%ecx)
  280f4f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f55:	02 65 c5             	add    -0x3b(%ebp),%ah
  280f58:	0c 04                	or     $0x4,%al
  280f5a:	04 00                	add    $0x0,%al
  280f5c:	1c 00                	sbb    $0x0,%al
  280f5e:	00 00                	add    %al,(%eax)
  280f60:	80 01 00             	addb   $0x0,(%ecx)
  280f63:	00 8c f8 ff ff d0 00 	add    %cl,0xd0ffff(%eax,%edi,8)
  280f6a:	00 00                	add    %al,(%eax)
  280f6c:	00 41 0e             	add    %al,0xe(%ecx)
  280f6f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f75:	02 cc                	add    %ah,%cl
  280f77:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280f7a:	04 00                	add    $0x0,%al
  280f7c:	1c 00                	sbb    $0x0,%al
  280f7e:	00 00                	add    %al,(%eax)
  280f80:	a0 01 00 00 3c       	mov    0x3c000001,%al
  280f85:	f9                   	stc    
  280f86:	ff                   	(bad)  
  280f87:	ff 4b 00             	decl   0x0(%ebx)
  280f8a:	00 00                	add    %al,(%eax)
  280f8c:	00 41 0e             	add    %al,0xe(%ecx)
  280f8f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f95:	02 47 c5             	add    -0x3b(%edi),%al
  280f98:	0c 04                	or     $0x4,%al
  280f9a:	04 00                	add    $0x0,%al
  280f9c:	1c 00                	sbb    $0x0,%al
  280f9e:	00 00                	add    %al,(%eax)
  280fa0:	c0 01 00             	rolb   $0x0,(%ecx)
  280fa3:	00 67 f9             	add    %ah,-0x7(%edi)
  280fa6:	ff                   	(bad)  
  280fa7:	ff a7 00 00 00 00    	jmp    *0x0(%edi)
  280fad:	41                   	inc    %ecx
  280fae:	0e                   	push   %cs
  280faf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280fb5:	02 a3 c5 0c 04 04    	add    0x4040cc5(%ebx),%ah
  280fbb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280fbe:	00 00                	add    %al,(%eax)
  280fc0:	e0 01                	loopne 280fc3 <cursor.1683+0x2e3>
  280fc2:	00 00                	add    %al,(%eax)
  280fc4:	ee                   	out    %al,(%dx)
  280fc5:	f9                   	stc    
  280fc6:	ff                   	(bad)  
  280fc7:	ff 99 00 00 00 00    	lcall  *0x0(%ecx)
  280fcd:	41                   	inc    %ecx
  280fce:	0e                   	push   %cs
  280fcf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280fd5:	02 95 c5 0c 04 04    	add    0x4040cc5(%ebp),%dl
  280fdb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280fde:	00 00                	add    %al,(%eax)
  280fe0:	00 02                	add    %al,(%edx)
  280fe2:	00 00                	add    %al,(%eax)
  280fe4:	67 fa                	addr16 cli 
  280fe6:	ff                   	(bad)  
  280fe7:	ff                   	(bad)  
  280fe8:	7a 00                	jp     280fea <cursor.1683+0x30a>
  280fea:	00 00                	add    %al,(%eax)
  280fec:	00 41 0e             	add    %al,0xe(%ecx)
  280fef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ff5:	02 76 c5             	add    -0x3b(%esi),%dh
  280ff8:	0c 04                	or     $0x4,%al
  280ffa:	04 00                	add    $0x0,%al
  280ffc:	1c 00                	sbb    $0x0,%al
  280ffe:	00 00                	add    %al,(%eax)
  281000:	20 02                	and    %al,(%edx)
  281002:	00 00                	add    %al,(%eax)
  281004:	c1 fa ff             	sar    $0xff,%edx
  281007:	ff 44 00 00          	incl   0x0(%eax,%eax,1)
  28100b:	00 00                	add    %al,(%eax)
  28100d:	41                   	inc    %ecx
  28100e:	0e                   	push   %cs
  28100f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  281015:	02 40 c5             	add    -0x3b(%eax),%al
  281018:	0c 04                	or     $0x4,%al
  28101a:	04 00                	add    $0x0,%al
  28101c:	1c 00                	sbb    $0x0,%al
  28101e:	00 00                	add    %al,(%eax)
  281020:	40                   	inc    %eax
  281021:	02 00                	add    (%eax),%al
  281023:	00 e5                	add    %ah,%ch
  281025:	fa                   	cli    
  281026:	ff                   	(bad)  
  281027:	ff 51 01             	call   *0x1(%ecx)
  28102a:	00 00                	add    %al,(%eax)
  28102c:	00 41 0e             	add    %al,0xe(%ecx)
  28102f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  281035:	03 4d 01             	add    0x1(%ebp),%ecx
  281038:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28103b:	04                   	.byte 0x4

Disassembly of section .data:

00281040 <Font8x16>:
	...
  281250:	00 00                	add    %al,(%eax)
  281252:	00 10                	add    %dl,(%eax)
  281254:	10 10                	adc    %dl,(%eax)
  281256:	10 10                	adc    %dl,(%eax)
  281258:	10 00                	adc    %al,(%eax)
  28125a:	10 10                	adc    %dl,(%eax)
  28125c:	00 00                	add    %al,(%eax)
  28125e:	00 00                	add    %al,(%eax)
  281260:	00 00                	add    %al,(%eax)
  281262:	00 24 24             	add    %ah,(%esp)
  281265:	24 00                	and    $0x0,%al
	...
  281273:	24 24                	and    $0x24,%al
  281275:	7e 24                	jle    28129b <Font8x16+0x25b>
  281277:	24 24                	and    $0x24,%al
  281279:	7e 24                	jle    28129f <Font8x16+0x25f>
  28127b:	24 00                	and    $0x0,%al
  28127d:	00 00                	add    %al,(%eax)
  28127f:	00 00                	add    %al,(%eax)
  281281:	00 00                	add    %al,(%eax)
  281283:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  281287:	7c 12                	jl     28129b <Font8x16+0x25b>
  281289:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  28128d:	00 00                	add    %al,(%eax)
  28128f:	00 00                	add    %al,(%eax)
  281291:	00 00                	add    %al,(%eax)
  281293:	00 62 64             	add    %ah,0x64(%edx)
  281296:	08 10                	or     %dl,(%eax)
  281298:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  2812a4:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  2812a7:	50                   	push   %eax
  2812a8:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  2812af:	00 00                	add    %al,(%eax)
  2812b1:	00 00                	add    %al,(%eax)
  2812b3:	10 10                	adc    %dl,(%eax)
  2812b5:	20 00                	and    %al,(%eax)
	...
  2812bf:	00 00                	add    %al,(%eax)
  2812c1:	00 08                	add    %cl,(%eax)
  2812c3:	10 20                	adc    %ah,(%eax)
  2812c5:	20 20                	and    %ah,(%eax)
  2812c7:	20 20                	and    %ah,(%eax)
  2812c9:	20 20                	and    %ah,(%eax)
  2812cb:	10 08                	adc    %cl,(%eax)
  2812cd:	00 00                	add    %al,(%eax)
  2812cf:	00 00                	add    %al,(%eax)
  2812d1:	00 20                	add    %ah,(%eax)
  2812d3:	10 08                	adc    %cl,(%eax)
  2812d5:	08 08                	or     %cl,(%eax)
  2812d7:	08 08                	or     %cl,(%eax)
  2812d9:	08 08                	or     %cl,(%eax)
  2812db:	10 20                	adc    %ah,(%eax)
	...
  2812e5:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  2812e9:	54                   	push   %esp
  2812ea:	10 00                	adc    %al,(%eax)
	...
  2812f4:	00 10                	add    %dl,(%eax)
  2812f6:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  28130a:	10 10                	adc    %dl,(%eax)
  28130c:	20 00                	and    %al,(%eax)
	...
  281316:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  28132a:	00 10                	add    %dl,(%eax)
	...
  281334:	00 02                	add    %al,(%edx)
  281336:	04 08                	add    $0x8,%al
  281338:	10 20                	adc    %ah,(%eax)
  28133a:	40                   	inc    %eax
	...
  281343:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  281347:	54                   	push   %esp
  281348:	64                   	fs
  281349:	44                   	inc    %esp
  28134a:	44                   	inc    %esp
  28134b:	38 00                	cmp    %al,(%eax)
  28134d:	00 00                	add    %al,(%eax)
  28134f:	00 00                	add    %al,(%eax)
  281351:	00 00                	add    %al,(%eax)
  281353:	10 30                	adc    %dh,(%eax)
  281355:	10 10                	adc    %dl,(%eax)
  281357:	10 10                	adc    %dl,(%eax)
  281359:	10 10                	adc    %dl,(%eax)
  28135b:	38 00                	cmp    %al,(%eax)
  28135d:	00 00                	add    %al,(%eax)
  28135f:	00 00                	add    %al,(%eax)
  281361:	00 00                	add    %al,(%eax)
  281363:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  281367:	08 10                	or     %dl,(%eax)
  281369:	20 40 7c             	and    %al,0x7c(%eax)
  28136c:	00 00                	add    %al,(%eax)
  28136e:	00 00                	add    %al,(%eax)
  281370:	00 00                	add    %al,(%eax)
  281372:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  281376:	10 38                	adc    %bh,(%eax)
  281378:	04 04                	add    $0x4,%al
  28137a:	04 78                	add    $0x78,%al
  28137c:	00 00                	add    %al,(%eax)
  28137e:	00 00                	add    %al,(%eax)
  281380:	00 00                	add    %al,(%eax)
  281382:	00 08                	add    %cl,(%eax)
  281384:	18 28                	sbb    %ch,(%eax)
  281386:	48                   	dec    %eax
  281387:	48                   	dec    %eax
  281388:	7c 08                	jl     281392 <Font8x16+0x352>
  28138a:	08 08                	or     %cl,(%eax)
  28138c:	00 00                	add    %al,(%eax)
  28138e:	00 00                	add    %al,(%eax)
  281390:	00 00                	add    %al,(%eax)
  281392:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  281396:	40                   	inc    %eax
  281397:	78 04                	js     28139d <Font8x16+0x35d>
  281399:	04 04                	add    $0x4,%al
  28139b:	78 00                	js     28139d <Font8x16+0x35d>
  28139d:	00 00                	add    %al,(%eax)
  28139f:	00 00                	add    %al,(%eax)
  2813a1:	00 00                	add    %al,(%eax)
  2813a3:	3c 40                	cmp    $0x40,%al
  2813a5:	40                   	inc    %eax
  2813a6:	40                   	inc    %eax
  2813a7:	78 44                	js     2813ed <Font8x16+0x3ad>
  2813a9:	44                   	inc    %esp
  2813aa:	44                   	inc    %esp
  2813ab:	38 00                	cmp    %al,(%eax)
  2813ad:	00 00                	add    %al,(%eax)
  2813af:	00 00                	add    %al,(%eax)
  2813b1:	00 00                	add    %al,(%eax)
  2813b3:	7c 04                	jl     2813b9 <Font8x16+0x379>
  2813b5:	04 08                	add    $0x8,%al
  2813b7:	10 20                	adc    %ah,(%eax)
  2813b9:	20 20                	and    %ah,(%eax)
  2813bb:	20 00                	and    %al,(%eax)
  2813bd:	00 00                	add    %al,(%eax)
  2813bf:	00 00                	add    %al,(%eax)
  2813c1:	00 00                	add    %al,(%eax)
  2813c3:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813c7:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813cb:	38 00                	cmp    %al,(%eax)
  2813cd:	00 00                	add    %al,(%eax)
  2813cf:	00 00                	add    %al,(%eax)
  2813d1:	00 00                	add    %al,(%eax)
  2813d3:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813d7:	3c 04                	cmp    $0x4,%al
  2813d9:	04 04                	add    $0x4,%al
  2813db:	38 00                	cmp    %al,(%eax)
	...
  2813e5:	00 00                	add    %al,(%eax)
  2813e7:	10 00                	adc    %al,(%eax)
  2813e9:	00 10                	add    %dl,(%eax)
	...
  2813f7:	00 10                	add    %dl,(%eax)
  2813f9:	00 10                	add    %dl,(%eax)
  2813fb:	10 20                	adc    %ah,(%eax)
	...
  281405:	04 08                	add    $0x8,%al
  281407:	10 20                	adc    %ah,(%eax)
  281409:	10 08                	adc    %cl,(%eax)
  28140b:	04 00                	add    $0x0,%al
	...
  281415:	00 00                	add    %al,(%eax)
  281417:	7c 00                	jl     281419 <Font8x16+0x3d9>
  281419:	7c 00                	jl     28141b <Font8x16+0x3db>
	...
  281423:	00 00                	add    %al,(%eax)
  281425:	20 10                	and    %dl,(%eax)
  281427:	08 04 08             	or     %al,(%eax,%ecx,1)
  28142a:	10 20                	adc    %ah,(%eax)
  28142c:	00 00                	add    %al,(%eax)
  28142e:	00 00                	add    %al,(%eax)
  281430:	00 00                	add    %al,(%eax)
  281432:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  281436:	08 10                	or     %dl,(%eax)
  281438:	10 00                	adc    %al,(%eax)
  28143a:	10 10                	adc    %dl,(%eax)
	...
  281444:	00 38                	add    %bh,(%eax)
  281446:	44                   	inc    %esp
  281447:	5c                   	pop    %esp
  281448:	54                   	push   %esp
  281449:	5c                   	pop    %esp
  28144a:	40                   	inc    %eax
  28144b:	3c 00                	cmp    $0x0,%al
  28144d:	00 00                	add    %al,(%eax)
  28144f:	00 00                	add    %al,(%eax)
  281451:	00 18                	add    %bl,(%eax)
  281453:	24 42                	and    $0x42,%al
  281455:	42                   	inc    %edx
  281456:	42                   	inc    %edx
  281457:	7e 42                	jle    28149b <Font8x16+0x45b>
  281459:	42                   	inc    %edx
  28145a:	42                   	inc    %edx
  28145b:	42                   	inc    %edx
  28145c:	00 00                	add    %al,(%eax)
  28145e:	00 00                	add    %al,(%eax)
  281460:	00 00                	add    %al,(%eax)
  281462:	7c 42                	jl     2814a6 <Font8x16+0x466>
  281464:	42                   	inc    %edx
  281465:	42                   	inc    %edx
  281466:	7c 42                	jl     2814aa <Font8x16+0x46a>
  281468:	42                   	inc    %edx
  281469:	42                   	inc    %edx
  28146a:	42                   	inc    %edx
  28146b:	7c 00                	jl     28146d <Font8x16+0x42d>
  28146d:	00 00                	add    %al,(%eax)
  28146f:	00 00                	add    %al,(%eax)
  281471:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281474:	40                   	inc    %eax
  281475:	40                   	inc    %eax
  281476:	40                   	inc    %eax
  281477:	40                   	inc    %eax
  281478:	40                   	inc    %eax
  281479:	40                   	inc    %eax
  28147a:	42                   	inc    %edx
  28147b:	3c 00                	cmp    $0x0,%al
  28147d:	00 00                	add    %al,(%eax)
  28147f:	00 00                	add    %al,(%eax)
  281481:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281485:	42                   	inc    %edx
  281486:	42                   	inc    %edx
  281487:	42                   	inc    %edx
  281488:	42                   	inc    %edx
  281489:	42                   	inc    %edx
  28148a:	42                   	inc    %edx
  28148b:	7c 00                	jl     28148d <Font8x16+0x44d>
  28148d:	00 00                	add    %al,(%eax)
  28148f:	00 00                	add    %al,(%eax)
  281491:	00 7e 40             	add    %bh,0x40(%esi)
  281494:	40                   	inc    %eax
  281495:	40                   	inc    %eax
  281496:	78 40                	js     2814d8 <Font8x16+0x498>
  281498:	40                   	inc    %eax
  281499:	40                   	inc    %eax
  28149a:	40                   	inc    %eax
  28149b:	7e 00                	jle    28149d <Font8x16+0x45d>
  28149d:	00 00                	add    %al,(%eax)
  28149f:	00 00                	add    %al,(%eax)
  2814a1:	00 7e 40             	add    %bh,0x40(%esi)
  2814a4:	40                   	inc    %eax
  2814a5:	40                   	inc    %eax
  2814a6:	78 40                	js     2814e8 <Font8x16+0x4a8>
  2814a8:	40                   	inc    %eax
  2814a9:	40                   	inc    %eax
  2814aa:	40                   	inc    %eax
  2814ab:	40                   	inc    %eax
  2814ac:	00 00                	add    %al,(%eax)
  2814ae:	00 00                	add    %al,(%eax)
  2814b0:	00 00                	add    %al,(%eax)
  2814b2:	3c 42                	cmp    $0x42,%al
  2814b4:	40                   	inc    %eax
  2814b5:	40                   	inc    %eax
  2814b6:	5e                   	pop    %esi
  2814b7:	42                   	inc    %edx
  2814b8:	42                   	inc    %edx
  2814b9:	42                   	inc    %edx
  2814ba:	42                   	inc    %edx
  2814bb:	3c 00                	cmp    $0x0,%al
  2814bd:	00 00                	add    %al,(%eax)
  2814bf:	00 00                	add    %al,(%eax)
  2814c1:	00 42 42             	add    %al,0x42(%edx)
  2814c4:	42                   	inc    %edx
  2814c5:	42                   	inc    %edx
  2814c6:	7e 42                	jle    28150a <Font8x16+0x4ca>
  2814c8:	42                   	inc    %edx
  2814c9:	42                   	inc    %edx
  2814ca:	42                   	inc    %edx
  2814cb:	42                   	inc    %edx
  2814cc:	00 00                	add    %al,(%eax)
  2814ce:	00 00                	add    %al,(%eax)
  2814d0:	00 00                	add    %al,(%eax)
  2814d2:	38 10                	cmp    %dl,(%eax)
  2814d4:	10 10                	adc    %dl,(%eax)
  2814d6:	10 10                	adc    %dl,(%eax)
  2814d8:	10 10                	adc    %dl,(%eax)
  2814da:	10 38                	adc    %bh,(%eax)
  2814dc:	00 00                	add    %al,(%eax)
  2814de:	00 00                	add    %al,(%eax)
  2814e0:	00 00                	add    %al,(%eax)
  2814e2:	1c 08                	sbb    $0x8,%al
  2814e4:	08 08                	or     %cl,(%eax)
  2814e6:	08 08                	or     %cl,(%eax)
  2814e8:	08 08                	or     %cl,(%eax)
  2814ea:	48                   	dec    %eax
  2814eb:	30 00                	xor    %al,(%eax)
  2814ed:	00 00                	add    %al,(%eax)
  2814ef:	00 00                	add    %al,(%eax)
  2814f1:	00 42 44             	add    %al,0x44(%edx)
  2814f4:	48                   	dec    %eax
  2814f5:	50                   	push   %eax
  2814f6:	60                   	pusha  
  2814f7:	60                   	pusha  
  2814f8:	50                   	push   %eax
  2814f9:	48                   	dec    %eax
  2814fa:	44                   	inc    %esp
  2814fb:	42                   	inc    %edx
  2814fc:	00 00                	add    %al,(%eax)
  2814fe:	00 00                	add    %al,(%eax)
  281500:	00 00                	add    %al,(%eax)
  281502:	40                   	inc    %eax
  281503:	40                   	inc    %eax
  281504:	40                   	inc    %eax
  281505:	40                   	inc    %eax
  281506:	40                   	inc    %eax
  281507:	40                   	inc    %eax
  281508:	40                   	inc    %eax
  281509:	40                   	inc    %eax
  28150a:	40                   	inc    %eax
  28150b:	7e 00                	jle    28150d <Font8x16+0x4cd>
  28150d:	00 00                	add    %al,(%eax)
  28150f:	00 00                	add    %al,(%eax)
  281511:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  281517:	aa                   	stos   %al,%es:(%edi)
  281518:	92                   	xchg   %eax,%edx
  281519:	92                   	xchg   %eax,%edx
  28151a:	82                   	(bad)  
  28151b:	82                   	(bad)  
  28151c:	00 00                	add    %al,(%eax)
  28151e:	00 00                	add    %al,(%eax)
  281520:	00 00                	add    %al,(%eax)
  281522:	42                   	inc    %edx
  281523:	62 62 52             	bound  %esp,0x52(%edx)
  281526:	52                   	push   %edx
  281527:	4a                   	dec    %edx
  281528:	4a                   	dec    %edx
  281529:	46                   	inc    %esi
  28152a:	46                   	inc    %esi
  28152b:	42                   	inc    %edx
  28152c:	00 00                	add    %al,(%eax)
  28152e:	00 00                	add    %al,(%eax)
  281530:	00 00                	add    %al,(%eax)
  281532:	3c 42                	cmp    $0x42,%al
  281534:	42                   	inc    %edx
  281535:	42                   	inc    %edx
  281536:	42                   	inc    %edx
  281537:	42                   	inc    %edx
  281538:	42                   	inc    %edx
  281539:	42                   	inc    %edx
  28153a:	42                   	inc    %edx
  28153b:	3c 00                	cmp    $0x0,%al
  28153d:	00 00                	add    %al,(%eax)
  28153f:	00 00                	add    %al,(%eax)
  281541:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281545:	42                   	inc    %edx
  281546:	42                   	inc    %edx
  281547:	7c 40                	jl     281589 <Font8x16+0x549>
  281549:	40                   	inc    %eax
  28154a:	40                   	inc    %eax
  28154b:	40                   	inc    %eax
  28154c:	00 00                	add    %al,(%eax)
  28154e:	00 00                	add    %al,(%eax)
  281550:	00 00                	add    %al,(%eax)
  281552:	3c 42                	cmp    $0x42,%al
  281554:	42                   	inc    %edx
  281555:	42                   	inc    %edx
  281556:	42                   	inc    %edx
  281557:	42                   	inc    %edx
  281558:	42                   	inc    %edx
  281559:	42                   	inc    %edx
  28155a:	4a                   	dec    %edx
  28155b:	3c 0e                	cmp    $0xe,%al
  28155d:	00 00                	add    %al,(%eax)
  28155f:	00 00                	add    %al,(%eax)
  281561:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281565:	42                   	inc    %edx
  281566:	42                   	inc    %edx
  281567:	7c 50                	jl     2815b9 <Font8x16+0x579>
  281569:	48                   	dec    %eax
  28156a:	44                   	inc    %esp
  28156b:	42                   	inc    %edx
  28156c:	00 00                	add    %al,(%eax)
  28156e:	00 00                	add    %al,(%eax)
  281570:	00 00                	add    %al,(%eax)
  281572:	3c 42                	cmp    $0x42,%al
  281574:	40                   	inc    %eax
  281575:	40                   	inc    %eax
  281576:	3c 02                	cmp    $0x2,%al
  281578:	02 02                	add    (%edx),%al
  28157a:	42                   	inc    %edx
  28157b:	3c 00                	cmp    $0x0,%al
  28157d:	00 00                	add    %al,(%eax)
  28157f:	00 00                	add    %al,(%eax)
  281581:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  281585:	10 10                	adc    %dl,(%eax)
  281587:	10 10                	adc    %dl,(%eax)
  281589:	10 10                	adc    %dl,(%eax)
  28158b:	10 00                	adc    %al,(%eax)
  28158d:	00 00                	add    %al,(%eax)
  28158f:	00 00                	add    %al,(%eax)
  281591:	00 42 42             	add    %al,0x42(%edx)
  281594:	42                   	inc    %edx
  281595:	42                   	inc    %edx
  281596:	42                   	inc    %edx
  281597:	42                   	inc    %edx
  281598:	42                   	inc    %edx
  281599:	42                   	inc    %edx
  28159a:	42                   	inc    %edx
  28159b:	3c 00                	cmp    $0x0,%al
  28159d:	00 00                	add    %al,(%eax)
  28159f:	00 00                	add    %al,(%eax)
  2815a1:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  2815a5:	44                   	inc    %esp
  2815a6:	28 28                	sub    %ch,(%eax)
  2815a8:	28 10                	sub    %dl,(%eax)
  2815aa:	10 10                	adc    %dl,(%eax)
  2815ac:	00 00                	add    %al,(%eax)
  2815ae:	00 00                	add    %al,(%eax)
  2815b0:	00 00                	add    %al,(%eax)
  2815b2:	82                   	(bad)  
  2815b3:	82                   	(bad)  
  2815b4:	82                   	(bad)  
  2815b5:	82                   	(bad)  
  2815b6:	54                   	push   %esp
  2815b7:	54                   	push   %esp
  2815b8:	54                   	push   %esp
  2815b9:	28 28                	sub    %ch,(%eax)
  2815bb:	28 00                	sub    %al,(%eax)
  2815bd:	00 00                	add    %al,(%eax)
  2815bf:	00 00                	add    %al,(%eax)
  2815c1:	00 42 42             	add    %al,0x42(%edx)
  2815c4:	24 18                	and    $0x18,%al
  2815c6:	18 18                	sbb    %bl,(%eax)
  2815c8:	24 24                	and    $0x24,%al
  2815ca:	42                   	inc    %edx
  2815cb:	42                   	inc    %edx
  2815cc:	00 00                	add    %al,(%eax)
  2815ce:	00 00                	add    %al,(%eax)
  2815d0:	00 00                	add    %al,(%eax)
  2815d2:	44                   	inc    %esp
  2815d3:	44                   	inc    %esp
  2815d4:	44                   	inc    %esp
  2815d5:	44                   	inc    %esp
  2815d6:	28 28                	sub    %ch,(%eax)
  2815d8:	10 10                	adc    %dl,(%eax)
  2815da:	10 10                	adc    %dl,(%eax)
  2815dc:	00 00                	add    %al,(%eax)
  2815de:	00 00                	add    %al,(%eax)
  2815e0:	00 00                	add    %al,(%eax)
  2815e2:	7e 02                	jle    2815e6 <Font8x16+0x5a6>
  2815e4:	02 04 08             	add    (%eax,%ecx,1),%al
  2815e7:	10 20                	adc    %ah,(%eax)
  2815e9:	40                   	inc    %eax
  2815ea:	40                   	inc    %eax
  2815eb:	7e 00                	jle    2815ed <Font8x16+0x5ad>
  2815ed:	00 00                	add    %al,(%eax)
  2815ef:	00 00                	add    %al,(%eax)
  2815f1:	00 38                	add    %bh,(%eax)
  2815f3:	20 20                	and    %ah,(%eax)
  2815f5:	20 20                	and    %ah,(%eax)
  2815f7:	20 20                	and    %ah,(%eax)
  2815f9:	20 20                	and    %ah,(%eax)
  2815fb:	38 00                	cmp    %al,(%eax)
	...
  281605:	00 40 20             	add    %al,0x20(%eax)
  281608:	10 08                	adc    %cl,(%eax)
  28160a:	04 02                	add    $0x2,%al
  28160c:	00 00                	add    %al,(%eax)
  28160e:	00 00                	add    %al,(%eax)
  281610:	00 00                	add    %al,(%eax)
  281612:	1c 04                	sbb    $0x4,%al
  281614:	04 04                	add    $0x4,%al
  281616:	04 04                	add    $0x4,%al
  281618:	04 04                	add    $0x4,%al
  28161a:	04 1c                	add    $0x1c,%al
	...
  281624:	10 28                	adc    %ch,(%eax)
  281626:	44                   	inc    %esp
	...
  28163b:	00 ff                	add    %bh,%bh
  28163d:	00 00                	add    %al,(%eax)
  28163f:	00 00                	add    %al,(%eax)
  281641:	00 00                	add    %al,(%eax)
  281643:	10 10                	adc    %dl,(%eax)
  281645:	08 00                	or     %al,(%eax)
	...
  281653:	00 00                	add    %al,(%eax)
  281655:	78 04                	js     28165b <Font8x16+0x61b>
  281657:	3c 44                	cmp    $0x44,%al
  281659:	44                   	inc    %esp
  28165a:	44                   	inc    %esp
  28165b:	3a 00                	cmp    (%eax),%al
  28165d:	00 00                	add    %al,(%eax)
  28165f:	00 00                	add    %al,(%eax)
  281661:	00 40 40             	add    %al,0x40(%eax)
  281664:	40                   	inc    %eax
  281665:	5c                   	pop    %esp
  281666:	62 42 42             	bound  %eax,0x42(%edx)
  281669:	42                   	inc    %edx
  28166a:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  28166e:	00 00                	add    %al,(%eax)
  281670:	00 00                	add    %al,(%eax)
  281672:	00 00                	add    %al,(%eax)
  281674:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281677:	40                   	inc    %eax
  281678:	40                   	inc    %eax
  281679:	40                   	inc    %eax
  28167a:	42                   	inc    %edx
  28167b:	3c 00                	cmp    $0x0,%al
  28167d:	00 00                	add    %al,(%eax)
  28167f:	00 00                	add    %al,(%eax)
  281681:	00 02                	add    %al,(%edx)
  281683:	02 02                	add    (%edx),%al
  281685:	3a 46 42             	cmp    0x42(%esi),%al
  281688:	42                   	inc    %edx
  281689:	42                   	inc    %edx
  28168a:	46                   	inc    %esi
  28168b:	3a 00                	cmp    (%eax),%al
	...
  281695:	3c 42                	cmp    $0x42,%al
  281697:	42                   	inc    %edx
  281698:	7e 40                	jle    2816da <Font8x16+0x69a>
  28169a:	42                   	inc    %edx
  28169b:	3c 00                	cmp    $0x0,%al
  28169d:	00 00                	add    %al,(%eax)
  28169f:	00 00                	add    %al,(%eax)
  2816a1:	00 0e                	add    %cl,(%esi)
  2816a3:	10 10                	adc    %dl,(%eax)
  2816a5:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  2816a8:	10 10                	adc    %dl,(%eax)
  2816aa:	10 10                	adc    %dl,(%eax)
	...
  2816b4:	00 3e                	add    %bh,(%esi)
  2816b6:	42                   	inc    %edx
  2816b7:	42                   	inc    %edx
  2816b8:	42                   	inc    %edx
  2816b9:	42                   	inc    %edx
  2816ba:	3e 02 02             	add    %ds:(%edx),%al
  2816bd:	3c 00                	cmp    $0x0,%al
  2816bf:	00 00                	add    %al,(%eax)
  2816c1:	00 40 40             	add    %al,0x40(%eax)
  2816c4:	40                   	inc    %eax
  2816c5:	5c                   	pop    %esp
  2816c6:	62 42 42             	bound  %eax,0x42(%edx)
  2816c9:	42                   	inc    %edx
  2816ca:	42                   	inc    %edx
  2816cb:	42                   	inc    %edx
  2816cc:	00 00                	add    %al,(%eax)
  2816ce:	00 00                	add    %al,(%eax)
  2816d0:	00 00                	add    %al,(%eax)
  2816d2:	00 08                	add    %cl,(%eax)
  2816d4:	00 08                	add    %cl,(%eax)
  2816d6:	08 08                	or     %cl,(%eax)
  2816d8:	08 08                	or     %cl,(%eax)
  2816da:	08 08                	or     %cl,(%eax)
  2816dc:	00 00                	add    %al,(%eax)
  2816de:	00 00                	add    %al,(%eax)
  2816e0:	00 00                	add    %al,(%eax)
  2816e2:	00 04 00             	add    %al,(%eax,%eax,1)
  2816e5:	04 04                	add    $0x4,%al
  2816e7:	04 04                	add    $0x4,%al
  2816e9:	04 04                	add    $0x4,%al
  2816eb:	04 44                	add    $0x44,%al
  2816ed:	38 00                	cmp    %al,(%eax)
  2816ef:	00 00                	add    %al,(%eax)
  2816f1:	00 40 40             	add    %al,0x40(%eax)
  2816f4:	40                   	inc    %eax
  2816f5:	42                   	inc    %edx
  2816f6:	44                   	inc    %esp
  2816f7:	48                   	dec    %eax
  2816f8:	50                   	push   %eax
  2816f9:	68 44 42 00 00       	push   $0x4244
  2816fe:	00 00                	add    %al,(%eax)
  281700:	00 00                	add    %al,(%eax)
  281702:	10 10                	adc    %dl,(%eax)
  281704:	10 10                	adc    %dl,(%eax)
  281706:	10 10                	adc    %dl,(%eax)
  281708:	10 10                	adc    %dl,(%eax)
  28170a:	10 10                	adc    %dl,(%eax)
	...
  281714:	00 ec                	add    %ch,%ah
  281716:	92                   	xchg   %eax,%edx
  281717:	92                   	xchg   %eax,%edx
  281718:	92                   	xchg   %eax,%edx
  281719:	92                   	xchg   %eax,%edx
  28171a:	92                   	xchg   %eax,%edx
  28171b:	92                   	xchg   %eax,%edx
	...
  281724:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281728:	42                   	inc    %edx
  281729:	42                   	inc    %edx
  28172a:	42                   	inc    %edx
  28172b:	42                   	inc    %edx
	...
  281734:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281737:	42                   	inc    %edx
  281738:	42                   	inc    %edx
  281739:	42                   	inc    %edx
  28173a:	42                   	inc    %edx
  28173b:	3c 00                	cmp    $0x0,%al
	...
  281745:	5c                   	pop    %esp
  281746:	62 42 42             	bound  %eax,0x42(%edx)
  281749:	42                   	inc    %edx
  28174a:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  28174e:	00 00                	add    %al,(%eax)
  281750:	00 00                	add    %al,(%eax)
  281752:	00 00                	add    %al,(%eax)
  281754:	00 3a                	add    %bh,(%edx)
  281756:	46                   	inc    %esi
  281757:	42                   	inc    %edx
  281758:	42                   	inc    %edx
  281759:	42                   	inc    %edx
  28175a:	46                   	inc    %esi
  28175b:	3a 02                	cmp    (%edx),%al
  28175d:	02 00                	add    (%eax),%al
  28175f:	00 00                	add    %al,(%eax)
  281761:	00 00                	add    %al,(%eax)
  281763:	00 00                	add    %al,(%eax)
  281765:	5c                   	pop    %esp
  281766:	62 40 40             	bound  %eax,0x40(%eax)
  281769:	40                   	inc    %eax
  28176a:	40                   	inc    %eax
  28176b:	40                   	inc    %eax
	...
  281774:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281777:	40                   	inc    %eax
  281778:	3c 02                	cmp    $0x2,%al
  28177a:	42                   	inc    %edx
  28177b:	3c 00                	cmp    $0x0,%al
  28177d:	00 00                	add    %al,(%eax)
  28177f:	00 00                	add    %al,(%eax)
  281781:	00 00                	add    %al,(%eax)
  281783:	20 20                	and    %ah,(%eax)
  281785:	78 20                	js     2817a7 <Font8x16+0x767>
  281787:	20 20                	and    %ah,(%eax)
  281789:	20 22                	and    %ah,(%edx)
  28178b:	1c 00                	sbb    $0x0,%al
	...
  281795:	42                   	inc    %edx
  281796:	42                   	inc    %edx
  281797:	42                   	inc    %edx
  281798:	42                   	inc    %edx
  281799:	42                   	inc    %edx
  28179a:	42                   	inc    %edx
  28179b:	3e 00 00             	add    %al,%ds:(%eax)
  28179e:	00 00                	add    %al,(%eax)
  2817a0:	00 00                	add    %al,(%eax)
  2817a2:	00 00                	add    %al,(%eax)
  2817a4:	00 42 42             	add    %al,0x42(%edx)
  2817a7:	42                   	inc    %edx
  2817a8:	42                   	inc    %edx
  2817a9:	42                   	inc    %edx
  2817aa:	24 18                	and    $0x18,%al
	...
  2817b4:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  2817ba:	aa                   	stos   %al,%es:(%edi)
  2817bb:	44                   	inc    %esp
	...
  2817c4:	00 42 42             	add    %al,0x42(%edx)
  2817c7:	24 18                	and    $0x18,%al
  2817c9:	24 42                	and    $0x42,%al
  2817cb:	42                   	inc    %edx
	...
  2817d4:	00 42 42             	add    %al,0x42(%edx)
  2817d7:	42                   	inc    %edx
  2817d8:	42                   	inc    %edx
  2817d9:	42                   	inc    %edx
  2817da:	3e 02 02             	add    %ds:(%edx),%al
  2817dd:	3c 00                	cmp    $0x0,%al
  2817df:	00 00                	add    %al,(%eax)
  2817e1:	00 00                	add    %al,(%eax)
  2817e3:	00 00                	add    %al,(%eax)
  2817e5:	7e 02                	jle    2817e9 <Font8x16+0x7a9>
  2817e7:	04 18                	add    $0x18,%al
  2817e9:	20 40 7e             	and    %al,0x7e(%eax)
  2817ec:	00 00                	add    %al,(%eax)
  2817ee:	00 00                	add    %al,(%eax)
  2817f0:	00 00                	add    %al,(%eax)
  2817f2:	08 10                	or     %dl,(%eax)
  2817f4:	10 10                	adc    %dl,(%eax)
  2817f6:	20 40 20             	and    %al,0x20(%eax)
  2817f9:	10 10                	adc    %dl,(%eax)
  2817fb:	10 08                	adc    %cl,(%eax)
  2817fd:	00 00                	add    %al,(%eax)
  2817ff:	00 00                	add    %al,(%eax)
  281801:	10 10                	adc    %dl,(%eax)
  281803:	10 10                	adc    %dl,(%eax)
  281805:	10 10                	adc    %dl,(%eax)
  281807:	10 10                	adc    %dl,(%eax)
  281809:	10 10                	adc    %dl,(%eax)
  28180b:	10 10                	adc    %dl,(%eax)
  28180d:	10 10                	adc    %dl,(%eax)
  28180f:	00 00                	add    %al,(%eax)
  281811:	00 20                	add    %ah,(%eax)
  281813:	10 10                	adc    %dl,(%eax)
  281815:	10 08                	adc    %cl,(%eax)
  281817:	04 08                	add    $0x8,%al
  281819:	10 10                	adc    %dl,(%eax)
  28181b:	10 20                	adc    %ah,(%eax)
	...
  281825:	00 22                	add    %ah,(%edx)
  281827:	54                   	push   %esp
  281828:	88 00                	mov    %al,(%eax)
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <bootmain-0x27ff88>
   a:	74 75                	je     81 <bootmain-0x27ff7f>
   c:	20 34 2e             	and    %dh,(%esi,%ebp,1)
   f:	38 2e                	cmp    %ch,(%esi)
  11:	32 2d 31 39 75 62    	xor    0x62753931,%ch
  17:	75 6e                	jne    87 <bootmain-0x27ff79>
  19:	74 75                	je     90 <bootmain-0x27ff70>
  1b:	31 29                	xor    %ebp,(%ecx)
  1d:	20 34 2e             	and    %dh,(%esi,%ebp,1)
  20:	38 2e                	cmp    %ch,(%esi)
  22:	32 00                	xor    (%eax),%al
