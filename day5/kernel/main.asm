
main.elf:     file format elf32-i386


Disassembly of section .text:

00280000 <bootmain>:
  280000:	55                   	push   %ebp
  280001:	89 e5                	mov    %esp,%ebp
  280003:	81 ec 58 01 00 00    	sub    $0x158,%esp
  280009:	e8 b0 01 00 00       	call   2801be <init_palette>
  28000e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280015:	e8 4b 01 00 00       	call   280165 <clear_screen>
  28001a:	e8 c9 03 00 00       	call   2803e8 <draw_window>
  28001f:	c7 45 f4 f0 0f 00 00 	movl   $0xff0,-0xc(%ebp)
  280026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280029:	89 04 24             	mov    %eax,(%esp)
  28002c:	e8 8f 06 00 00       	call   2806c0 <init_screen>
  280031:	c7 44 24 0c 28 00 00 	movl   $0x28,0xc(%esp)
  280038:	00 
  280039:	c7 44 24 08 1e 00 00 	movl   $0x1e,0x8(%esp)
  280040:	00 
  280041:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
  280048:	00 
  280049:	c7 04 24 61 00 00 00 	movl   $0x61,(%esp)
  280050:	e8 ae 07 00 00       	call   280803 <putchar>
  280055:	c7 44 24 0c 46 00 00 	movl   $0x46,0xc(%esp)
  28005c:	00 
  28005d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  280064:	00 
  280065:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  28006c:	00 
  28006d:	c7 04 24 c0 0c 28 00 	movl   $0x280cc0,(%esp)
  280074:	e8 5a 08 00 00       	call   2808d3 <puts>
  280079:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  280080:	00 
  280081:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  280088:	00 
  280089:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  280090:	00 
  280091:	c7 04 24 cb 0c 28 00 	movl   $0x280ccb,(%esp)
  280098:	e8 36 08 00 00       	call   2808d3 <puts>
  28009d:	c7 45 f0 40 01 00 00 	movl   $0x140,-0x10(%ebp)
  2800a4:	c7 45 ec c8 00 00 00 	movl   $0xc8,-0x14(%ebp)
  2800ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  2800ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2800b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2800b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  2800b9:	c7 44 24 04 d7 0c 28 	movl   $0x280cd7,0x4(%esp)
  2800c0:	00 
  2800c1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  2800c4:	89 04 24             	mov    %eax,(%esp)
  2800c7:	e8 52 08 00 00       	call   28091e <sprintf>
  2800cc:	c7 44 24 0c 82 00 00 	movl   $0x82,0xc(%esp)
  2800d3:	00 
  2800d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  2800db:	00 
  2800dc:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  2800e3:	00 
  2800e4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  2800e7:	89 04 24             	mov    %eax,(%esp)
  2800ea:	e8 e4 07 00 00       	call   2808d3 <puts>
  2800ef:	e8 28 0a 00 00       	call   280b1c <init_gdtidt>
  2800f4:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
  2800fb:	00 
  2800fc:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  280102:	89 04 24             	mov    %eax,(%esp)
  280105:	e8 df 05 00 00       	call   2806e9 <init_mouse>
  28010a:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  280111:	00 
  280112:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  280118:	89 44 24 18          	mov    %eax,0x18(%esp)
  28011c:	c7 44 24 14 64 00 00 	movl   $0x64,0x14(%esp)
  280123:	00 
  280124:	c7 44 24 10 a0 00 00 	movl   $0xa0,0x10(%esp)
  28012b:	00 
  28012c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  280133:	00 
  280134:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  28013b:	00 
  28013c:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  280143:	00 
  280144:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  28014b:	e8 4a 06 00 00       	call   28079a <display_mouse>
  280150:	c7 45 e8 65 01 28 00 	movl   $0x280165,-0x18(%ebp)
  280157:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  28015e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  280161:	ff d0                	call   *%eax
  280163:	eb fe                	jmp    280163 <bootmain+0x163>

00280165 <clear_screen>:
  280165:	55                   	push   %ebp
  280166:	89 e5                	mov    %esp,%ebp
  280168:	83 ec 14             	sub    $0x14,%esp
  28016b:	8b 45 08             	mov    0x8(%ebp),%eax
  28016e:	88 45 ec             	mov    %al,-0x14(%ebp)
  280171:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  280178:	eb 0d                	jmp    280187 <clear_screen+0x22>
  28017a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28017d:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  280181:	88 10                	mov    %dl,(%eax)
  280183:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280187:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  28018e:	7e ea                	jle    28017a <clear_screen+0x15>
  280190:	c9                   	leave  
  280191:	c3                   	ret    

00280192 <color_screen>:
  280192:	55                   	push   %ebp
  280193:	89 e5                	mov    %esp,%ebp
  280195:	83 ec 14             	sub    $0x14,%esp
  280198:	8b 45 08             	mov    0x8(%ebp),%eax
  28019b:	88 45 ec             	mov    %al,-0x14(%ebp)
  28019e:	c7 45 fc 00 00 0a 00 	movl   $0xa0000,-0x4(%ebp)
  2801a5:	eb 0c                	jmp    2801b3 <color_screen+0x21>
  2801a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2801aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  2801ad:	88 10                	mov    %dl,(%eax)
  2801af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2801b3:	81 7d fc fe ff 0a 00 	cmpl   $0xafffe,-0x4(%ebp)
  2801ba:	7e eb                	jle    2801a7 <color_screen+0x15>
  2801bc:	c9                   	leave  
  2801bd:	c3                   	ret    

002801be <init_palette>:
  2801be:	55                   	push   %ebp
  2801bf:	89 e5                	mov    %esp,%ebp
  2801c1:	83 ec 48             	sub    $0x48,%esp
  2801c4:	c6 45 c8 00          	movb   $0x0,-0x38(%ebp)
  2801c8:	c6 45 c9 00          	movb   $0x0,-0x37(%ebp)
  2801cc:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  2801d0:	c6 45 cb ff          	movb   $0xff,-0x35(%ebp)
  2801d4:	c6 45 cc 00          	movb   $0x0,-0x34(%ebp)
  2801d8:	c6 45 cd 00          	movb   $0x0,-0x33(%ebp)
  2801dc:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  2801e0:	c6 45 cf ff          	movb   $0xff,-0x31(%ebp)
  2801e4:	c6 45 d0 00          	movb   $0x0,-0x30(%ebp)
  2801e8:	c6 45 d1 ff          	movb   $0xff,-0x2f(%ebp)
  2801ec:	c6 45 d2 ff          	movb   $0xff,-0x2e(%ebp)
  2801f0:	c6 45 d3 00          	movb   $0x0,-0x2d(%ebp)
  2801f4:	c6 45 d4 00          	movb   $0x0,-0x2c(%ebp)
  2801f8:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
  2801fc:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  280200:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  280204:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  280208:	c6 45 d9 ff          	movb   $0xff,-0x27(%ebp)
  28020c:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
  280210:	c6 45 db ff          	movb   $0xff,-0x25(%ebp)
  280214:	c6 45 dc ff          	movb   $0xff,-0x24(%ebp)
  280218:	c6 45 dd ff          	movb   $0xff,-0x23(%ebp)
  28021c:	c6 45 de ff          	movb   $0xff,-0x22(%ebp)
  280220:	c6 45 df ff          	movb   $0xff,-0x21(%ebp)
  280224:	c6 45 e0 c6          	movb   $0xc6,-0x20(%ebp)
  280228:	c6 45 e1 c6          	movb   $0xc6,-0x1f(%ebp)
  28022c:	c6 45 e2 c6          	movb   $0xc6,-0x1e(%ebp)
  280230:	c6 45 e3 84          	movb   $0x84,-0x1d(%ebp)
  280234:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
  280238:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  28023c:	c6 45 e6 00          	movb   $0x0,-0x1a(%ebp)
  280240:	c6 45 e7 84          	movb   $0x84,-0x19(%ebp)
  280244:	c6 45 e8 00          	movb   $0x0,-0x18(%ebp)
  280248:	c6 45 e9 84          	movb   $0x84,-0x17(%ebp)
  28024c:	c6 45 ea 84          	movb   $0x84,-0x16(%ebp)
  280250:	c6 45 eb 00          	movb   $0x0,-0x15(%ebp)
  280254:	c6 45 ec 00          	movb   $0x0,-0x14(%ebp)
  280258:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
  28025c:	c6 45 ee 84          	movb   $0x84,-0x12(%ebp)
  280260:	c6 45 ef 84          	movb   $0x84,-0x11(%ebp)
  280264:	c6 45 f0 00          	movb   $0x0,-0x10(%ebp)
  280268:	c6 45 f1 84          	movb   $0x84,-0xf(%ebp)
  28026c:	c6 45 f2 00          	movb   $0x0,-0xe(%ebp)
  280270:	c6 45 f3 84          	movb   $0x84,-0xd(%ebp)
  280274:	c6 45 f4 84          	movb   $0x84,-0xc(%ebp)
  280278:	c6 45 f5 84          	movb   $0x84,-0xb(%ebp)
  28027c:	c6 45 f6 84          	movb   $0x84,-0xa(%ebp)
  280280:	c6 45 f7 84          	movb   $0x84,-0x9(%ebp)
  280284:	8d 45 c8             	lea    -0x38(%ebp),%eax
  280287:	89 44 24 08          	mov    %eax,0x8(%esp)
  28028b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  280292:	00 
  280293:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  28029a:	e8 02 00 00 00       	call   2802a1 <set_palette>
  28029f:	c9                   	leave  
  2802a0:	c3                   	ret    

002802a1 <set_palette>:
  2802a1:	55                   	push   %ebp
  2802a2:	89 e5                	mov    %esp,%ebp
  2802a4:	83 ec 30             	sub    $0x30,%esp
  2802a7:	9c                   	pushf  
  2802a8:	58                   	pop    %eax
  2802a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  2802ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2802af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  2802b2:	fa                   	cli    
  2802b3:	8b 45 08             	mov    0x8(%ebp),%eax
  2802b6:	0f b6 c0             	movzbl %al,%eax
  2802b9:	c7 45 f0 c8 03 00 00 	movl   $0x3c8,-0x10(%ebp)
  2802c0:	88 45 ef             	mov    %al,-0x11(%ebp)
  2802c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  2802c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  2802ca:	ee                   	out    %al,(%dx)
  2802cb:	8b 45 08             	mov    0x8(%ebp),%eax
  2802ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  2802d1:	eb 68                	jmp    28033b <set_palette+0x9a>
  2802d3:	8b 45 10             	mov    0x10(%ebp),%eax
  2802d6:	0f b6 00             	movzbl (%eax),%eax
  2802d9:	c0 e8 02             	shr    $0x2,%al
  2802dc:	0f b6 c0             	movzbl %al,%eax
  2802df:	c7 45 e8 c9 03 00 00 	movl   $0x3c9,-0x18(%ebp)
  2802e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  2802e9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  2802ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  2802f0:	ee                   	out    %al,(%dx)
  2802f1:	8b 45 10             	mov    0x10(%ebp),%eax
  2802f4:	83 c0 01             	add    $0x1,%eax
  2802f7:	0f b6 00             	movzbl (%eax),%eax
  2802fa:	c0 e8 02             	shr    $0x2,%al
  2802fd:	0f b6 c0             	movzbl %al,%eax
  280300:	c7 45 e0 c9 03 00 00 	movl   $0x3c9,-0x20(%ebp)
  280307:	88 45 df             	mov    %al,-0x21(%ebp)
  28030a:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  28030e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  280311:	ee                   	out    %al,(%dx)
  280312:	8b 45 10             	mov    0x10(%ebp),%eax
  280315:	83 c0 02             	add    $0x2,%eax
  280318:	0f b6 00             	movzbl (%eax),%eax
  28031b:	c0 e8 02             	shr    $0x2,%al
  28031e:	0f b6 c0             	movzbl %al,%eax
  280321:	c7 45 d8 c9 03 00 00 	movl   $0x3c9,-0x28(%ebp)
  280328:	88 45 d7             	mov    %al,-0x29(%ebp)
  28032b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  28032f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  280332:	ee                   	out    %al,(%dx)
  280333:	83 45 10 03          	addl   $0x3,0x10(%ebp)
  280337:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  28033b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28033e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  280341:	7e 90                	jle    2802d3 <set_palette+0x32>
  280343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280346:	89 45 d0             	mov    %eax,-0x30(%ebp)
  280349:	8b 45 d0             	mov    -0x30(%ebp),%eax
  28034c:	50                   	push   %eax
  28034d:	9d                   	popf   
  28034e:	90                   	nop
  28034f:	c9                   	leave  
  280350:	c3                   	ret    

00280351 <boxfill8>:
  280351:	55                   	push   %ebp
  280352:	89 e5                	mov    %esp,%ebp
  280354:	83 ec 14             	sub    $0x14,%esp
  280357:	8b 45 10             	mov    0x10(%ebp),%eax
  28035a:	88 45 ec             	mov    %al,-0x14(%ebp)
  28035d:	8b 45 18             	mov    0x18(%ebp),%eax
  280360:	89 45 f8             	mov    %eax,-0x8(%ebp)
  280363:	eb 33                	jmp    280398 <boxfill8+0x47>
  280365:	8b 45 14             	mov    0x14(%ebp),%eax
  280368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  28036b:	eb 1f                	jmp    28038c <boxfill8+0x3b>
  28036d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280370:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280374:	89 c2                	mov    %eax,%edx
  280376:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280379:	01 d0                	add    %edx,%eax
  28037b:	89 c2                	mov    %eax,%edx
  28037d:	8b 45 08             	mov    0x8(%ebp),%eax
  280380:	01 c2                	add    %eax,%edx
  280382:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  280386:	88 02                	mov    %al,(%edx)
  280388:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  28038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28038f:	3b 45 1c             	cmp    0x1c(%ebp),%eax
  280392:	7e d9                	jle    28036d <boxfill8+0x1c>
  280394:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  280398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28039b:	3b 45 20             	cmp    0x20(%ebp),%eax
  28039e:	7e c5                	jle    280365 <boxfill8+0x14>
  2803a0:	c9                   	leave  
  2803a1:	c3                   	ret    

002803a2 <boxfill>:
  2803a2:	55                   	push   %ebp
  2803a3:	89 e5                	mov    %esp,%ebp
  2803a5:	83 ec 20             	sub    $0x20,%esp
  2803a8:	8b 45 08             	mov    0x8(%ebp),%eax
  2803ab:	88 45 fc             	mov    %al,-0x4(%ebp)
  2803ae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  2803b2:	8b 55 18             	mov    0x18(%ebp),%edx
  2803b5:	89 54 24 18          	mov    %edx,0x18(%esp)
  2803b9:	8b 55 14             	mov    0x14(%ebp),%edx
  2803bc:	89 54 24 14          	mov    %edx,0x14(%esp)
  2803c0:	8b 55 10             	mov    0x10(%ebp),%edx
  2803c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  2803c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  2803ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  2803ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  2803d2:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  2803d9:	00 
  2803da:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  2803e1:	e8 6b ff ff ff       	call   280351 <boxfill8>
  2803e6:	c9                   	leave  
  2803e7:	c3                   	ret    

002803e8 <draw_window>:
  2803e8:	55                   	push   %ebp
  2803e9:	89 e5                	mov    %esp,%ebp
  2803eb:	53                   	push   %ebx
  2803ec:	83 ec 24             	sub    $0x24,%esp
  2803ef:	c7 45 f8 40 01 00 00 	movl   $0x140,-0x8(%ebp)
  2803f6:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
  2803fd:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
  280404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280407:	8d 50 e3             	lea    -0x1d(%eax),%edx
  28040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28040d:	83 e8 01             	sub    $0x1,%eax
  280410:	89 54 24 10          	mov    %edx,0x10(%esp)
  280414:	89 44 24 0c          	mov    %eax,0xc(%esp)
  280418:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  28041f:	00 
  280420:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280427:	00 
  280428:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  28042f:	e8 6e ff ff ff       	call   2803a2 <boxfill>
  280434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280437:	8d 48 e4             	lea    -0x1c(%eax),%ecx
  28043a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28043d:	8d 50 ff             	lea    -0x1(%eax),%edx
  280440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280443:	83 e8 1c             	sub    $0x1c,%eax
  280446:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  28044a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  28044e:	89 44 24 08          	mov    %eax,0x8(%esp)
  280452:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280459:	00 
  28045a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  280461:	e8 3c ff ff ff       	call   2803a2 <boxfill>
  280466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280469:	8d 48 e5             	lea    -0x1b(%eax),%ecx
  28046c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28046f:	8d 50 ff             	lea    -0x1(%eax),%edx
  280472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280475:	83 e8 1b             	sub    $0x1b,%eax
  280478:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  28047c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  280480:	89 44 24 08          	mov    %eax,0x8(%esp)
  280484:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  28048b:	00 
  28048c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  280493:	e8 0a ff ff ff       	call   2803a2 <boxfill>
  280498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28049b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  28049e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2804a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  2804a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804a7:	83 e8 1a             	sub    $0x1a,%eax
  2804aa:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  2804ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  2804b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  2804b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  2804bd:	00 
  2804be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  2804c5:	e8 d8 fe ff ff       	call   2803a2 <boxfill>
  2804ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804cd:	8d 50 e8             	lea    -0x18(%eax),%edx
  2804d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804d3:	83 e8 18             	sub    $0x18,%eax
  2804d6:	89 54 24 10          	mov    %edx,0x10(%esp)
  2804da:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  2804e1:	00 
  2804e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  2804e6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  2804ed:	00 
  2804ee:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  2804f5:	e8 a8 fe ff ff       	call   2803a2 <boxfill>
  2804fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2804fd:	8d 50 fc             	lea    -0x4(%eax),%edx
  280500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280503:	83 e8 18             	sub    $0x18,%eax
  280506:	89 54 24 10          	mov    %edx,0x10(%esp)
  28050a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  280511:	00 
  280512:	89 44 24 08          	mov    %eax,0x8(%esp)
  280516:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  28051d:	00 
  28051e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  280525:	e8 78 fe ff ff       	call   2803a2 <boxfill>
  28052a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28052d:	8d 50 fc             	lea    -0x4(%eax),%edx
  280530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280533:	83 e8 04             	sub    $0x4,%eax
  280536:	89 54 24 10          	mov    %edx,0x10(%esp)
  28053a:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  280541:	00 
  280542:	89 44 24 08          	mov    %eax,0x8(%esp)
  280546:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  28054d:	00 
  28054e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280555:	e8 48 fe ff ff       	call   2803a2 <boxfill>
  28055a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28055d:	8d 50 fb             	lea    -0x5(%eax),%edx
  280560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280563:	83 e8 17             	sub    $0x17,%eax
  280566:	89 54 24 10          	mov    %edx,0x10(%esp)
  28056a:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  280571:	00 
  280572:	89 44 24 08          	mov    %eax,0x8(%esp)
  280576:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  28057d:	00 
  28057e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280585:	e8 18 fe ff ff       	call   2803a2 <boxfill>
  28058a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28058d:	8d 50 fd             	lea    -0x3(%eax),%edx
  280590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280593:	83 e8 03             	sub    $0x3,%eax
  280596:	89 54 24 10          	mov    %edx,0x10(%esp)
  28059a:	c7 44 24 0c 3b 00 00 	movl   $0x3b,0xc(%esp)
  2805a1:	00 
  2805a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  2805a6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  2805ad:	00 
  2805ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2805b5:	e8 e8 fd ff ff       	call   2803a2 <boxfill>
  2805ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805bd:	8d 50 fd             	lea    -0x3(%eax),%edx
  2805c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805c3:	83 e8 18             	sub    $0x18,%eax
  2805c6:	89 54 24 10          	mov    %edx,0x10(%esp)
  2805ca:	c7 44 24 0c 3c 00 00 	movl   $0x3c,0xc(%esp)
  2805d1:	00 
  2805d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  2805d6:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  2805dd:	00 
  2805de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2805e5:	e8 b8 fd ff ff       	call   2803a2 <boxfill>
  2805ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805ed:	8d 58 e8             	lea    -0x18(%eax),%ebx
  2805f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2805f3:	8d 48 fc             	lea    -0x4(%eax),%ecx
  2805f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2805f9:	8d 50 e8             	lea    -0x18(%eax),%edx
  2805fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2805ff:	83 e8 2f             	sub    $0x2f,%eax
  280602:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  280606:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  28060a:	89 54 24 08          	mov    %edx,0x8(%esp)
  28060e:	89 44 24 04          	mov    %eax,0x4(%esp)
  280612:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280619:	e8 84 fd ff ff       	call   2803a2 <boxfill>
  28061e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280621:	8d 58 fc             	lea    -0x4(%eax),%ebx
  280624:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280627:	8d 48 d1             	lea    -0x2f(%eax),%ecx
  28062a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28062d:	8d 50 e9             	lea    -0x17(%eax),%edx
  280630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280633:	83 e8 2f             	sub    $0x2f,%eax
  280636:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  28063a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  28063e:	89 54 24 08          	mov    %edx,0x8(%esp)
  280642:	89 44 24 04          	mov    %eax,0x4(%esp)
  280646:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  28064d:	e8 50 fd ff ff       	call   2803a2 <boxfill>
  280652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280655:	8d 58 fd             	lea    -0x3(%eax),%ebx
  280658:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28065b:	8d 48 fc             	lea    -0x4(%eax),%ecx
  28065e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280661:	8d 50 fd             	lea    -0x3(%eax),%edx
  280664:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280667:	83 e8 2f             	sub    $0x2f,%eax
  28066a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  28066e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  280672:	89 54 24 08          	mov    %edx,0x8(%esp)
  280676:	89 44 24 04          	mov    %eax,0x4(%esp)
  28067a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  280681:	e8 1c fd ff ff       	call   2803a2 <boxfill>
  280686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280689:	8d 58 fd             	lea    -0x3(%eax),%ebx
  28068c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28068f:	8d 48 fd             	lea    -0x3(%eax),%ecx
  280692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280695:	8d 50 e8             	lea    -0x18(%eax),%edx
  280698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28069b:	83 e8 03             	sub    $0x3,%eax
  28069e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  2806a2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2806a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  2806aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  2806ae:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  2806b5:	e8 e8 fc ff ff       	call   2803a2 <boxfill>
  2806ba:	83 c4 24             	add    $0x24,%esp
  2806bd:	5b                   	pop    %ebx
  2806be:	5d                   	pop    %ebp
  2806bf:	c3                   	ret    

002806c0 <init_screen>:
  2806c0:	55                   	push   %ebp
  2806c1:	89 e5                	mov    %esp,%ebp
  2806c3:	8b 45 08             	mov    0x8(%ebp),%eax
  2806c6:	c7 00 00 00 0a 00    	movl   $0xa0000,(%eax)
  2806cc:	8b 45 08             	mov    0x8(%ebp),%eax
  2806cf:	c6 40 04 08          	movb   $0x8,0x4(%eax)
  2806d3:	8b 45 08             	mov    0x8(%ebp),%eax
  2806d6:	c7 40 08 40 01 00 00 	movl   $0x140,0x8(%eax)
  2806dd:	8b 45 08             	mov    0x8(%ebp),%eax
  2806e0:	c7 40 0c c8 00 00 00 	movl   $0xc8,0xc(%eax)
  2806e7:	5d                   	pop    %ebp
  2806e8:	c3                   	ret    

002806e9 <init_mouse>:
  2806e9:	55                   	push   %ebp
  2806ea:	89 e5                	mov    %esp,%ebp
  2806ec:	83 ec 14             	sub    $0x14,%esp
  2806ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  2806f2:	88 45 ec             	mov    %al,-0x14(%ebp)
  2806f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  2806fc:	e9 8d 00 00 00       	jmp    28078e <init_mouse+0xa5>
  280701:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  280708:	eb 7a                	jmp    280784 <init_mouse+0x9b>
  28070a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28070d:	c1 e0 04             	shl    $0x4,%eax
  280710:	89 c2                	mov    %eax,%edx
  280712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280715:	01 d0                	add    %edx,%eax
  280717:	05 00 0d 28 00       	add    $0x280d00,%eax
  28071c:	0f b6 00             	movzbl (%eax),%eax
  28071f:	0f be c0             	movsbl %al,%eax
  280722:	83 f8 2e             	cmp    $0x2e,%eax
  280725:	74 0c                	je     280733 <init_mouse+0x4a>
  280727:	83 f8 4f             	cmp    $0x4f,%eax
  28072a:	74 3c                	je     280768 <init_mouse+0x7f>
  28072c:	83 f8 2a             	cmp    $0x2a,%eax
  28072f:	74 1e                	je     28074f <init_mouse+0x66>
  280731:	eb 4d                	jmp    280780 <init_mouse+0x97>
  280733:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280736:	c1 e0 04             	shl    $0x4,%eax
  280739:	89 c2                	mov    %eax,%edx
  28073b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28073e:	01 d0                	add    %edx,%eax
  280740:	89 c2                	mov    %eax,%edx
  280742:	8b 45 08             	mov    0x8(%ebp),%eax
  280745:	01 c2                	add    %eax,%edx
  280747:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  28074b:	88 02                	mov    %al,(%edx)
  28074d:	eb 31                	jmp    280780 <init_mouse+0x97>
  28074f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280752:	c1 e0 04             	shl    $0x4,%eax
  280755:	89 c2                	mov    %eax,%edx
  280757:	8b 45 fc             	mov    -0x4(%ebp),%eax
  28075a:	01 d0                	add    %edx,%eax
  28075c:	89 c2                	mov    %eax,%edx
  28075e:	8b 45 08             	mov    0x8(%ebp),%eax
  280761:	01 d0                	add    %edx,%eax
  280763:	c6 00 00             	movb   $0x0,(%eax)
  280766:	eb 18                	jmp    280780 <init_mouse+0x97>
  280768:	8b 45 f8             	mov    -0x8(%ebp),%eax
  28076b:	c1 e0 04             	shl    $0x4,%eax
  28076e:	89 c2                	mov    %eax,%edx
  280770:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280773:	01 d0                	add    %edx,%eax
  280775:	89 c2                	mov    %eax,%edx
  280777:	8b 45 08             	mov    0x8(%ebp),%eax
  28077a:	01 d0                	add    %edx,%eax
  28077c:	c6 00 02             	movb   $0x2,(%eax)
  28077f:	90                   	nop
  280780:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280784:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
  280788:	7e 80                	jle    28070a <init_mouse+0x21>
  28078a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  28078e:	83 7d f8 0f          	cmpl   $0xf,-0x8(%ebp)
  280792:	0f 8e 69 ff ff ff    	jle    280701 <init_mouse+0x18>
  280798:	c9                   	leave  
  280799:	c3                   	ret    

0028079a <display_mouse>:
  28079a:	55                   	push   %ebp
  28079b:	89 e5                	mov    %esp,%ebp
  28079d:	83 ec 10             	sub    $0x10,%esp
  2807a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  2807a7:	eb 50                	jmp    2807f9 <display_mouse+0x5f>
  2807a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2807b0:	eb 3b                	jmp    2807ed <display_mouse+0x53>
  2807b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807b5:	8b 55 1c             	mov    0x1c(%ebp),%edx
  2807b8:	01 d0                	add    %edx,%eax
  2807ba:	0f af 45 0c          	imul   0xc(%ebp),%eax
  2807be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  2807c1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  2807c4:	01 ca                	add    %ecx,%edx
  2807c6:	01 d0                	add    %edx,%eax
  2807c8:	89 c2                	mov    %eax,%edx
  2807ca:	8b 45 08             	mov    0x8(%ebp),%eax
  2807cd:	01 c2                	add    %eax,%edx
  2807cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807d2:	0f af 45 24          	imul   0x24(%ebp),%eax
  2807d6:	89 c1                	mov    %eax,%ecx
  2807d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2807db:	01 c8                	add    %ecx,%eax
  2807dd:	89 c1                	mov    %eax,%ecx
  2807df:	8b 45 20             	mov    0x20(%ebp),%eax
  2807e2:	01 c8                	add    %ecx,%eax
  2807e4:	0f b6 00             	movzbl (%eax),%eax
  2807e7:	88 02                	mov    %al,(%edx)
  2807e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2807ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2807f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  2807f3:	7c bd                	jl     2807b2 <display_mouse+0x18>
  2807f5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  2807f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2807fc:	3b 45 14             	cmp    0x14(%ebp),%eax
  2807ff:	7c a8                	jl     2807a9 <display_mouse+0xf>
  280801:	c9                   	leave  
  280802:	c3                   	ret    

00280803 <putchar>:
  280803:	55                   	push   %ebp
  280804:	89 e5                	mov    %esp,%ebp
  280806:	83 ec 18             	sub    $0x18,%esp
  280809:	8b 55 08             	mov    0x8(%ebp),%edx
  28080c:	8b 45 0c             	mov    0xc(%ebp),%eax
  28080f:	88 55 ec             	mov    %dl,-0x14(%ebp)
  280812:	88 45 e8             	mov    %al,-0x18(%ebp)
  280815:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
  280819:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  280820:	e9 a2 00 00 00       	jmp    2808c7 <putchar+0xc4>
  280825:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  280829:	c1 e0 04             	shl    $0x4,%eax
  28082c:	89 c2                	mov    %eax,%edx
  28082e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  280831:	01 d0                	add    %edx,%eax
  280833:	0f b6 80 60 10 28 00 	movzbl 0x281060(%eax),%eax
  28083a:	88 45 f6             	mov    %al,-0xa(%ebp)
  28083d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  280844:	eb 77                	jmp    2808bd <putchar+0xba>
  280846:	b8 07 00 00 00       	mov    $0x7,%eax
  28084b:	2b 45 fc             	sub    -0x4(%ebp),%eax
  28084e:	ba 01 00 00 00       	mov    $0x1,%edx
  280853:	89 c1                	mov    %eax,%ecx
  280855:	d3 e2                	shl    %cl,%edx
  280857:	89 d0                	mov    %edx,%eax
  280859:	88 45 f7             	mov    %al,-0x9(%ebp)
  28085c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  280860:	0f b6 55 f6          	movzbl -0xa(%ebp),%edx
  280864:	21 d0                	and    %edx,%eax
  280866:	84 c0                	test   %al,%al
  280868:	74 2a                	je     280894 <putchar+0x91>
  28086a:	8b 45 10             	mov    0x10(%ebp),%eax
  28086d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  280870:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  280873:	8b 45 14             	mov    0x14(%ebp),%eax
  280876:	8b 55 f8             	mov    -0x8(%ebp),%edx
  280879:	01 c2                	add    %eax,%edx
  28087b:	89 d0                	mov    %edx,%eax
  28087d:	c1 e0 02             	shl    $0x2,%eax
  280880:	01 d0                	add    %edx,%eax
  280882:	c1 e0 06             	shl    $0x6,%eax
  280885:	01 c8                	add    %ecx,%eax
  280887:	05 00 00 0a 00       	add    $0xa0000,%eax
  28088c:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
  280890:	88 10                	mov    %dl,(%eax)
  280892:	eb 25                	jmp    2808b9 <putchar+0xb6>
  280894:	8b 45 10             	mov    0x10(%ebp),%eax
  280897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  28089a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  28089d:	8b 45 14             	mov    0x14(%ebp),%eax
  2808a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  2808a3:	01 c2                	add    %eax,%edx
  2808a5:	89 d0                	mov    %edx,%eax
  2808a7:	c1 e0 02             	shl    $0x2,%eax
  2808aa:	01 d0                	add    %edx,%eax
  2808ac:	c1 e0 06             	shl    $0x6,%eax
  2808af:	01 c8                	add    %ecx,%eax
  2808b1:	05 00 00 0a 00       	add    $0xa0000,%eax
  2808b6:	c6 00 00             	movb   $0x0,(%eax)
  2808b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2808bd:	83 7d fc 07          	cmpl   $0x7,-0x4(%ebp)
  2808c1:	76 83                	jbe    280846 <putchar+0x43>
  2808c3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  2808c7:	83 7d f8 0f          	cmpl   $0xf,-0x8(%ebp)
  2808cb:	0f 86 54 ff ff ff    	jbe    280825 <putchar+0x22>
  2808d1:	c9                   	leave  
  2808d2:	c3                   	ret    

002808d3 <puts>:
  2808d3:	55                   	push   %ebp
  2808d4:	89 e5                	mov    %esp,%ebp
  2808d6:	83 ec 14             	sub    $0x14,%esp
  2808d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  2808dc:	88 45 fc             	mov    %al,-0x4(%ebp)
  2808df:	eb 31                	jmp    280912 <puts+0x3f>
  2808e1:	83 45 10 08          	addl   $0x8,0x10(%ebp)
  2808e5:	0f be 55 fc          	movsbl -0x4(%ebp),%edx
  2808e9:	8b 45 08             	mov    0x8(%ebp),%eax
  2808ec:	8d 48 01             	lea    0x1(%eax),%ecx
  2808ef:	89 4d 08             	mov    %ecx,0x8(%ebp)
  2808f2:	0f b6 00             	movzbl (%eax),%eax
  2808f5:	0f b6 c0             	movzbl %al,%eax
  2808f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  2808fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2808ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  280902:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  280906:	89 54 24 04          	mov    %edx,0x4(%esp)
  28090a:	89 04 24             	mov    %eax,(%esp)
  28090d:	e8 f1 fe ff ff       	call   280803 <putchar>
  280912:	8b 45 08             	mov    0x8(%ebp),%eax
  280915:	0f b6 00             	movzbl (%eax),%eax
  280918:	84 c0                	test   %al,%al
  28091a:	75 c5                	jne    2808e1 <puts+0xe>
  28091c:	c9                   	leave  
  28091d:	c3                   	ret    

0028091e <sprintf>:
  28091e:	55                   	push   %ebp
  28091f:	89 e5                	mov    %esp,%ebp
  280921:	83 ec 28             	sub    $0x28,%esp
  280924:	8d 45 0c             	lea    0xc(%ebp),%eax
  280927:	83 c0 04             	add    $0x4,%eax
  28092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  28092d:	e9 83 00 00 00       	jmp    2809b5 <sprintf+0x97>
  280932:	8b 45 0c             	mov    0xc(%ebp),%eax
  280935:	0f b6 00             	movzbl (%eax),%eax
  280938:	3c 25                	cmp    $0x25,%al
  28093a:	75 62                	jne    28099e <sprintf+0x80>
  28093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  28093f:	83 c0 01             	add    $0x1,%eax
  280942:	89 45 0c             	mov    %eax,0xc(%ebp)
  280945:	8b 45 0c             	mov    0xc(%ebp),%eax
  280948:	0f b6 00             	movzbl (%eax),%eax
  28094b:	0f be c0             	movsbl %al,%eax
  28094e:	83 f8 25             	cmp    $0x25,%eax
  280951:	74 07                	je     28095a <sprintf+0x3c>
  280953:	83 f8 64             	cmp    $0x64,%eax
  280956:	74 19                	je     280971 <sprintf+0x53>
  280958:	eb 42                	jmp    28099c <sprintf+0x7e>
  28095a:	8b 45 08             	mov    0x8(%ebp),%eax
  28095d:	8d 50 01             	lea    0x1(%eax),%edx
  280960:	89 55 08             	mov    %edx,0x8(%ebp)
  280963:	c6 00 25             	movb   $0x25,(%eax)
  280966:	8b 45 0c             	mov    0xc(%ebp),%eax
  280969:	83 c0 01             	add    $0x1,%eax
  28096c:	89 45 0c             	mov    %eax,0xc(%ebp)
  28096f:	eb 2b                	jmp    28099c <sprintf+0x7e>
  280971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280974:	8b 00                	mov    (%eax),%eax
  280976:	8b 55 08             	mov    0x8(%ebp),%edx
  280979:	89 54 24 04          	mov    %edx,0x4(%esp)
  28097d:	89 04 24             	mov    %eax,(%esp)
  280980:	e8 40 00 00 00       	call   2809c5 <int2str>
  280985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  280988:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
  28098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  28098f:	83 c0 01             	add    $0x1,%eax
  280992:	89 45 0c             	mov    %eax,0xc(%ebp)
  280995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280998:	01 45 08             	add    %eax,0x8(%ebp)
  28099b:	90                   	nop
  28099c:	eb 17                	jmp    2809b5 <sprintf+0x97>
  28099e:	8b 45 08             	mov    0x8(%ebp),%eax
  2809a1:	8d 50 01             	lea    0x1(%eax),%edx
  2809a4:	89 55 08             	mov    %edx,0x8(%ebp)
  2809a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  2809aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  2809ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  2809b0:	0f b6 12             	movzbl (%edx),%edx
  2809b3:	88 10                	mov    %dl,(%eax)
  2809b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  2809b8:	0f b6 00             	movzbl (%eax),%eax
  2809bb:	84 c0                	test   %al,%al
  2809bd:	0f 85 6f ff ff ff    	jne    280932 <sprintf+0x14>
  2809c3:	c9                   	leave  
  2809c4:	c3                   	ret    

002809c5 <int2str>:
  2809c5:	55                   	push   %ebp
  2809c6:	89 e5                	mov    %esp,%ebp
  2809c8:	83 ec 20             	sub    $0x20,%esp
  2809cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2809d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2809d5:	ba 67 66 66 66       	mov    $0x66666667,%edx
  2809da:	89 c8                	mov    %ecx,%eax
  2809dc:	f7 ea                	imul   %edx
  2809de:	c1 fa 02             	sar    $0x2,%edx
  2809e1:	89 c8                	mov    %ecx,%eax
  2809e3:	c1 f8 1f             	sar    $0x1f,%eax
  2809e6:	29 c2                	sub    %eax,%edx
  2809e8:	89 d0                	mov    %edx,%eax
  2809ea:	c1 e0 02             	shl    $0x2,%eax
  2809ed:	01 d0                	add    %edx,%eax
  2809ef:	01 c0                	add    %eax,%eax
  2809f1:	29 c1                	sub    %eax,%ecx
  2809f3:	89 c8                	mov    %ecx,%eax
  2809f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  2809f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2809fb:	83 c0 30             	add    $0x30,%eax
  2809fe:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  280a01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  280a04:	01 ca                	add    %ecx,%edx
  280a06:	88 02                	mov    %al,(%edx)
  280a08:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  280a0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  280a0f:	ba 67 66 66 66       	mov    $0x66666667,%edx
  280a14:	89 c8                	mov    %ecx,%eax
  280a16:	f7 ea                	imul   %edx
  280a18:	c1 fa 02             	sar    $0x2,%edx
  280a1b:	89 c8                	mov    %ecx,%eax
  280a1d:	c1 f8 1f             	sar    $0x1f,%eax
  280a20:	29 c2                	sub    %eax,%edx
  280a22:	89 d0                	mov    %edx,%eax
  280a24:	89 45 08             	mov    %eax,0x8(%ebp)
  280a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  280a2b:	75 a5                	jne    2809d2 <int2str+0xd>
  280a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  280a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  280a33:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  280a37:	eb 1a                	jmp    280a53 <int2str+0x8e>
  280a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a3c:	8d 50 01             	lea    0x1(%eax),%edx
  280a3f:	89 55 0c             	mov    %edx,0xc(%ebp)
  280a42:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  280a45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  280a48:	01 ca                	add    %ecx,%edx
  280a4a:	0f b6 12             	movzbl (%edx),%edx
  280a4d:	88 10                	mov    %dl,(%eax)
  280a4f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  280a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  280a57:	79 e0                	jns    280a39 <int2str+0x74>
  280a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280a5c:	c9                   	leave  
  280a5d:	c3                   	ret    

00280a5e <setgdt>:
  280a5e:	55                   	push   %ebp
  280a5f:	89 e5                	mov    %esp,%ebp
  280a61:	81 7d 0c ff ff 00 00 	cmpl   $0xffff,0xc(%ebp)
  280a68:	76 10                	jbe    280a7a <setgdt+0x1c>
  280a6a:	81 4d 14 00 80 00 00 	orl    $0x8000,0x14(%ebp)
  280a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a74:	c1 e8 0c             	shr    $0xc,%eax
  280a77:	89 45 0c             	mov    %eax,0xc(%ebp)
  280a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  280a7d:	89 c2                	mov    %eax,%edx
  280a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  280a82:	66 89 10             	mov    %dx,(%eax)
  280a85:	8b 45 10             	mov    0x10(%ebp),%eax
  280a88:	89 c2                	mov    %eax,%edx
  280a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  280a8d:	66 89 50 02          	mov    %dx,0x2(%eax)
  280a91:	8b 45 10             	mov    0x10(%ebp),%eax
  280a94:	c1 f8 10             	sar    $0x10,%eax
  280a97:	89 c2                	mov    %eax,%edx
  280a99:	8b 45 08             	mov    0x8(%ebp),%eax
  280a9c:	88 50 04             	mov    %dl,0x4(%eax)
  280a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  280aa2:	89 c2                	mov    %eax,%edx
  280aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  280aa7:	88 50 05             	mov    %dl,0x5(%eax)
  280aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  280aad:	c1 e8 10             	shr    $0x10,%eax
  280ab0:	83 e0 0f             	and    $0xf,%eax
  280ab3:	89 c2                	mov    %eax,%edx
  280ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  280ab8:	c1 f8 08             	sar    $0x8,%eax
  280abb:	83 e0 f0             	and    $0xfffffff0,%eax
  280abe:	09 d0                	or     %edx,%eax
  280ac0:	89 c2                	mov    %eax,%edx
  280ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  280ac5:	88 50 06             	mov    %dl,0x6(%eax)
  280ac8:	8b 45 10             	mov    0x10(%ebp),%eax
  280acb:	c1 e8 18             	shr    $0x18,%eax
  280ace:	89 c2                	mov    %eax,%edx
  280ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  280ad3:	88 50 07             	mov    %dl,0x7(%eax)
  280ad6:	5d                   	pop    %ebp
  280ad7:	c3                   	ret    

00280ad8 <setidt>:
  280ad8:	55                   	push   %ebp
  280ad9:	89 e5                	mov    %esp,%ebp
  280adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  280ade:	89 c2                	mov    %eax,%edx
  280ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  280ae3:	66 89 10             	mov    %dx,(%eax)
  280ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  280ae9:	c1 e8 10             	shr    $0x10,%eax
  280aec:	89 c2                	mov    %eax,%edx
  280aee:	8b 45 08             	mov    0x8(%ebp),%eax
  280af1:	66 89 50 06          	mov    %dx,0x6(%eax)
  280af5:	8b 45 10             	mov    0x10(%ebp),%eax
  280af8:	89 c2                	mov    %eax,%edx
  280afa:	8b 45 08             	mov    0x8(%ebp),%eax
  280afd:	66 89 50 02          	mov    %dx,0x2(%eax)
  280b01:	8b 45 14             	mov    0x14(%ebp),%eax
  280b04:	c1 f8 08             	sar    $0x8,%eax
  280b07:	89 c2                	mov    %eax,%edx
  280b09:	8b 45 08             	mov    0x8(%ebp),%eax
  280b0c:	88 50 04             	mov    %dl,0x4(%eax)
  280b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  280b12:	89 c2                	mov    %eax,%edx
  280b14:	8b 45 08             	mov    0x8(%ebp),%eax
  280b17:	88 50 05             	mov    %dl,0x5(%eax)
  280b1a:	5d                   	pop    %ebp
  280b1b:	c3                   	ret    

00280b1c <init_gdtidt>:
  280b1c:	55                   	push   %ebp
  280b1d:	89 e5                	mov    %esp,%ebp
  280b1f:	83 ec 28             	sub    $0x28,%esp
  280b22:	c7 45 f0 00 00 27 00 	movl   $0x270000,-0x10(%ebp)
  280b29:	c7 45 ec 00 f8 26 00 	movl   $0x26f800,-0x14(%ebp)
  280b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280b37:	eb 33                	jmp    280b6c <init_gdtidt+0x50>
  280b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280b3c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  280b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b46:	01 d0                	add    %edx,%eax
  280b48:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  280b4f:	00 
  280b50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280b57:	00 
  280b58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280b5f:	00 
  280b60:	89 04 24             	mov    %eax,(%esp)
  280b63:	e8 f6 fe ff ff       	call   280a5e <setgdt>
  280b68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280b6c:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  280b73:	7e c4                	jle    280b39 <init_gdtidt+0x1d>
  280b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b78:	83 c0 08             	add    $0x8,%eax
  280b7b:	c7 44 24 0c 92 40 00 	movl   $0x4092,0xc(%esp)
  280b82:	00 
  280b83:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280b8a:	00 
  280b8b:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
  280b92:	ff 
  280b93:	89 04 24             	mov    %eax,(%esp)
  280b96:	e8 c3 fe ff ff       	call   280a5e <setgdt>
  280b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b9e:	83 c0 10             	add    $0x10,%eax
  280ba1:	c7 44 24 0c 9a 40 00 	movl   $0x409a,0xc(%esp)
  280ba8:	00 
  280ba9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280bb0:	00 
  280bb1:	c7 44 24 04 ff ff 0f 	movl   $0xfffff,0x4(%esp)
  280bb8:	00 
  280bb9:	89 04 24             	mov    %eax,(%esp)
  280bbc:	e8 9d fe ff ff       	call   280a5e <setgdt>
  280bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280bc4:	83 c0 18             	add    $0x18,%eax
  280bc7:	c7 44 24 0c 9a 40 00 	movl   $0x409a,0xc(%esp)
  280bce:	00 
  280bcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280bd6:	00 
  280bd7:	c7 44 24 04 ff ff 0f 	movl   $0xfffff,0x4(%esp)
  280bde:	00 
  280bdf:	89 04 24             	mov    %eax,(%esp)
  280be2:	e8 77 fe ff ff       	call   280a5e <setgdt>
  280be7:	c7 44 24 04 00 00 27 	movl   $0x270000,0x4(%esp)
  280bee:	00 
  280bef:	c7 04 24 ff 0f 00 00 	movl   $0xfff,(%esp)
  280bf6:	e8 88 00 00 00       	call   280c83 <load_gdtr>
  280bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280c02:	eb 33                	jmp    280c37 <init_gdtidt+0x11b>
  280c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  280c07:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  280c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  280c11:	01 d0                	add    %edx,%eax
  280c13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  280c1a:	00 
  280c1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  280c22:	00 
  280c23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  280c2a:	00 
  280c2b:	89 04 24             	mov    %eax,(%esp)
  280c2e:	e8 a5 fe ff ff       	call   280ad8 <setidt>
  280c33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280c37:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
  280c3e:	7e c4                	jle    280c04 <init_gdtidt+0xe8>
  280c40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  280c47:	eb 04                	jmp    280c4d <init_gdtidt+0x131>
  280c49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  280c4d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
  280c54:	7e f3                	jle    280c49 <init_gdtidt+0x12d>
  280c56:	c7 44 24 04 00 f8 26 	movl   $0x26f800,0x4(%esp)
  280c5d:	00 
  280c5e:	c7 04 24 ff 07 00 00 	movl   $0x7ff,(%esp)
  280c65:	e8 29 00 00 00       	call   280c93 <load_idtr>
  280c6a:	90                   	nop
  280c6b:	c9                   	leave  
  280c6c:	c3                   	ret    

00280c6d <asm_inthandler21>:
  280c6d:	66 06                	pushw  %es
  280c6f:	66 1e                	pushw  %ds
  280c71:	60                   	pusha  
  280c72:	89 e0                	mov    %esp,%eax
  280c74:	50                   	push   %eax
  280c75:	66 8c d0             	mov    %ss,%ax
  280c78:	8e d8                	mov    %eax,%ds
  280c7a:	8e c0                	mov    %eax,%es
  280c7c:	58                   	pop    %eax
  280c7d:	61                   	popa   
  280c7e:	66 1f                	popw   %ds
  280c80:	66 07                	popw   %es
  280c82:	cf                   	iret   

00280c83 <load_gdtr>:
  280c83:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  280c88:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  280c8d:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  280c92:	c3                   	ret    

00280c93 <load_idtr>:
  280c93:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  280c98:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  280c9d:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  280ca2:	c3                   	ret    

Disassembly of section .rodata:

00280cc0 <cursor.1704-0x40>:
  280cc0:	31 32                	xor    %esi,(%edx)
  280cc2:	33 34 33             	xor    (%ebx,%esi,1),%esi
  280cc5:	35 35 36 35 36       	xor    $0x36353635,%eax
  280cca:	00 68 65             	add    %ch,0x65(%eax)
  280ccd:	6c                   	insb   (%dx),%es:(%edi)
  280cce:	6c                   	insb   (%dx),%es:(%edi)
  280ccf:	6f                   	outsl  %ds:(%esi),(%dx)
  280cd0:	20 77 6f             	and    %dh,0x6f(%edi)
  280cd3:	72 6c                	jb     280d41 <cursor.1704+0x41>
  280cd5:	64 00 78 73          	add    %bh,%fs:0x73(%eax)
  280cd9:	69 7a 65 3d 25 64 2c 	imul   $0x2c64253d,0x65(%edx),%edi
  280ce0:	79 73                	jns    280d55 <cursor.1704+0x55>
  280ce2:	69 7a 65 3d 25 64 00 	imul   $0x64253d,0x65(%edx),%edi
	...

00280d00 <cursor.1704>:
  280d00:	2a 2a                	sub    (%edx),%ch
  280d02:	2a 2a                	sub    (%edx),%ch
  280d04:	2a 2a                	sub    (%edx),%ch
  280d06:	2a 2a                	sub    (%edx),%ch
  280d08:	2a 2a                	sub    (%edx),%ch
  280d0a:	2a 2a                	sub    (%edx),%ch
  280d0c:	2a 2a                	sub    (%edx),%ch
  280d0e:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  280d13:	4f                   	dec    %edi
  280d14:	4f                   	dec    %edi
  280d15:	4f                   	dec    %edi
  280d16:	4f                   	dec    %edi
  280d17:	4f                   	dec    %edi
  280d18:	4f                   	dec    %edi
  280d19:	4f                   	dec    %edi
  280d1a:	4f                   	dec    %edi
  280d1b:	4f                   	dec    %edi
  280d1c:	2a 2e                	sub    (%esi),%ch
  280d1e:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  280d23:	4f                   	dec    %edi
  280d24:	4f                   	dec    %edi
  280d25:	4f                   	dec    %edi
  280d26:	4f                   	dec    %edi
  280d27:	4f                   	dec    %edi
  280d28:	4f                   	dec    %edi
  280d29:	4f                   	dec    %edi
  280d2a:	4f                   	dec    %edi
  280d2b:	2a 2e                	sub    (%esi),%ch
  280d2d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280d33:	4f                   	dec    %edi
  280d34:	4f                   	dec    %edi
  280d35:	4f                   	dec    %edi
  280d36:	4f                   	dec    %edi
  280d37:	4f                   	dec    %edi
  280d38:	4f                   	dec    %edi
  280d39:	4f                   	dec    %edi
  280d3a:	2a 2e                	sub    (%esi),%ch
  280d3c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  280d43:	4f                   	dec    %edi
  280d44:	4f                   	dec    %edi
  280d45:	4f                   	dec    %edi
  280d46:	4f                   	dec    %edi
  280d47:	4f                   	dec    %edi
  280d48:	4f                   	dec    %edi
  280d49:	2a 2e                	sub    (%esi),%ch
  280d4b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d52:	4f 
  280d53:	4f                   	dec    %edi
  280d54:	4f                   	dec    %edi
  280d55:	4f                   	dec    %edi
  280d56:	4f                   	dec    %edi
  280d57:	4f                   	dec    %edi
  280d58:	2a 2e                	sub    (%esi),%ch
  280d5a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d61:	4f 4f 
  280d63:	4f                   	dec    %edi
  280d64:	4f                   	dec    %edi
  280d65:	4f                   	dec    %edi
  280d66:	4f                   	dec    %edi
  280d67:	4f                   	dec    %edi
  280d68:	2a 2e                	sub    (%esi),%ch
  280d6a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d71:	4f 4f 
  280d73:	4f                   	dec    %edi
  280d74:	4f                   	dec    %edi
  280d75:	4f                   	dec    %edi
  280d76:	4f                   	dec    %edi
  280d77:	4f                   	dec    %edi
  280d78:	4f                   	dec    %edi
  280d79:	2a 2e                	sub    (%esi),%ch
  280d7b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  280d82:	4f 
  280d83:	4f                   	dec    %edi
  280d84:	4f                   	dec    %edi
  280d85:	2a 2a                	sub    (%edx),%ch
  280d87:	4f                   	dec    %edi
  280d88:	4f                   	dec    %edi
  280d89:	4f                   	dec    %edi
  280d8a:	2a 2e                	sub    (%esi),%ch
  280d8c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  280d93:	4f                   	dec    %edi
  280d94:	2a 2e                	sub    (%esi),%ch
  280d96:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  280d9a:	4f                   	dec    %edi
  280d9b:	2a 2e                	sub    (%esi),%ch
  280d9d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280da3:	2a 2e                	sub    (%esi),%ch
  280da5:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  280dab:	4f                   	dec    %edi
  280dac:	2a 2e                	sub    (%esi),%ch
  280dae:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  280db3:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280dba:	4f 4f 
  280dbc:	4f                   	dec    %edi
  280dbd:	2a 2e                	sub    (%esi),%ch
  280dbf:	2e 2a 2a             	sub    %cs:(%edx),%ch
  280dc2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280dc9:	2e 2a 4f 4f 
  280dcd:	4f                   	dec    %edi
  280dce:	2a 2e                	sub    (%esi),%ch
  280dd0:	2a 2e                	sub    (%esi),%ch
  280dd2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280dd9:	2e 2e 2a 4f 4f 
  280dde:	4f                   	dec    %edi
  280ddf:	2a 2e                	sub    (%esi),%ch
  280de1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  280de8:	2e 2e 2e 2e 2a 4f 4f 
  280def:	2a 2e                	sub    (%esi),%ch
  280df1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  280df8:	2e 2e 2e 2e 2e 2a 2a 
  280dff:	2a                   	.byte 0x2a

Disassembly of section .eh_frame:

00280e00 <.eh_frame>:
  280e00:	14 00                	adc    $0x0,%al
  280e02:	00 00                	add    %al,(%eax)
  280e04:	00 00                	add    %al,(%eax)
  280e06:	00 00                	add    %al,(%eax)
  280e08:	01 7a 52             	add    %edi,0x52(%edx)
  280e0b:	00 01                	add    %al,(%ecx)
  280e0d:	7c 08                	jl     280e17 <cursor.1704+0x117>
  280e0f:	01 1b                	add    %ebx,(%ebx)
  280e11:	0c 04                	or     $0x4,%al
  280e13:	04 88                	add    $0x88,%al
  280e15:	01 00                	add    %eax,(%eax)
  280e17:	00 18                	add    %bl,(%eax)
  280e19:	00 00                	add    %al,(%eax)
  280e1b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280e1e:	00 00                	add    %al,(%eax)
  280e20:	e0 f1                	loopne 280e13 <cursor.1704+0x113>
  280e22:	ff                   	(bad)  
  280e23:	ff 65 01             	jmp    *0x1(%ebp)
  280e26:	00 00                	add    %al,(%eax)
  280e28:	00 41 0e             	add    %al,0xe(%ecx)
  280e2b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e31:	00 00                	add    %al,(%eax)
  280e33:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280e36:	00 00                	add    %al,(%eax)
  280e38:	38 00                	cmp    %al,(%eax)
  280e3a:	00 00                	add    %al,(%eax)
  280e3c:	29 f3                	sub    %esi,%ebx
  280e3e:	ff                   	(bad)  
  280e3f:	ff 2d 00 00 00 00    	ljmp   *0x0
  280e45:	41                   	inc    %ecx
  280e46:	0e                   	push   %cs
  280e47:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e4d:	69 c5 0c 04 04 00    	imul   $0x4040c,%ebp,%eax
  280e53:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280e56:	00 00                	add    %al,(%eax)
  280e58:	58                   	pop    %eax
  280e59:	00 00                	add    %al,(%eax)
  280e5b:	00 36                	add    %dh,(%esi)
  280e5d:	f3 ff                	repz (bad) 
  280e5f:	ff 2c 00             	ljmp   *(%eax,%eax,1)
  280e62:	00 00                	add    %al,(%eax)
  280e64:	00 41 0e             	add    %al,0xe(%ecx)
  280e67:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e6d:	68 c5 0c 04 04       	push   $0x4040cc5
  280e72:	00 00                	add    %al,(%eax)
  280e74:	1c 00                	sbb    $0x0,%al
  280e76:	00 00                	add    %al,(%eax)
  280e78:	78 00                	js     280e7a <cursor.1704+0x17a>
  280e7a:	00 00                	add    %al,(%eax)
  280e7c:	42                   	inc    %edx
  280e7d:	f3 ff                	repz (bad) 
  280e7f:	ff e3                	jmp    *%ebx
  280e81:	00 00                	add    %al,(%eax)
  280e83:	00 00                	add    %al,(%eax)
  280e85:	41                   	inc    %ecx
  280e86:	0e                   	push   %cs
  280e87:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280e8d:	02 df                	add    %bh,%bl
  280e8f:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280e92:	04 00                	add    $0x0,%al
  280e94:	1c 00                	sbb    $0x0,%al
  280e96:	00 00                	add    %al,(%eax)
  280e98:	98                   	cwtl   
  280e99:	00 00                	add    %al,(%eax)
  280e9b:	00 05 f4 ff ff b0    	add    %al,0xb0fffff4
  280ea1:	00 00                	add    %al,(%eax)
  280ea3:	00 00                	add    %al,(%eax)
  280ea5:	41                   	inc    %ecx
  280ea6:	0e                   	push   %cs
  280ea7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ead:	02 ac c5 0c 04 04 00 	add    0x4040c(%ebp,%eax,8),%ch
  280eb4:	1c 00                	sbb    $0x0,%al
  280eb6:	00 00                	add    %al,(%eax)
  280eb8:	b8 00 00 00 95       	mov    $0x95000000,%eax
  280ebd:	f4                   	hlt    
  280ebe:	ff                   	(bad)  
  280ebf:	ff 51 00             	call   *0x0(%ecx)
  280ec2:	00 00                	add    %al,(%eax)
  280ec4:	00 41 0e             	add    %al,0xe(%ecx)
  280ec7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ecd:	02 4d c5             	add    -0x3b(%ebp),%cl
  280ed0:	0c 04                	or     $0x4,%al
  280ed2:	04 00                	add    $0x0,%al
  280ed4:	1c 00                	sbb    $0x0,%al
  280ed6:	00 00                	add    %al,(%eax)
  280ed8:	d8 00                	fadds  (%eax)
  280eda:	00 00                	add    %al,(%eax)
  280edc:	c6                   	(bad)  
  280edd:	f4                   	hlt    
  280ede:	ff                   	(bad)  
  280edf:	ff 46 00             	incl   0x0(%esi)
  280ee2:	00 00                	add    %al,(%eax)
  280ee4:	00 41 0e             	add    %al,0xe(%ecx)
  280ee7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280eed:	02 42 c5             	add    -0x3b(%edx),%al
  280ef0:	0c 04                	or     $0x4,%al
  280ef2:	04 00                	add    $0x0,%al
  280ef4:	24 00                	and    $0x0,%al
  280ef6:	00 00                	add    %al,(%eax)
  280ef8:	f8                   	clc    
  280ef9:	00 00                	add    %al,(%eax)
  280efb:	00 ec                	add    %ch,%ah
  280efd:	f4                   	hlt    
  280efe:	ff                   	(bad)  
  280eff:	ff                   	(bad)  
  280f00:	d8 02                	fadds  (%edx)
  280f02:	00 00                	add    %al,(%eax)
  280f04:	00 41 0e             	add    %al,0xe(%ecx)
  280f07:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f0d:	44                   	inc    %esp
  280f0e:	83 03 03             	addl   $0x3,(%ebx)
  280f11:	cf                   	iret   
  280f12:	02 c3                	add    %bl,%al
  280f14:	41                   	inc    %ecx
  280f15:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280f18:	04 00                	add    $0x0,%al
  280f1a:	00 00                	add    %al,(%eax)
  280f1c:	1c 00                	sbb    $0x0,%al
  280f1e:	00 00                	add    %al,(%eax)
  280f20:	20 01                	and    %al,(%ecx)
  280f22:	00 00                	add    %al,(%eax)
  280f24:	9c                   	pushf  
  280f25:	f7 ff                	idiv   %edi
  280f27:	ff 29                	ljmp   *(%ecx)
  280f29:	00 00                	add    %al,(%eax)
  280f2b:	00 00                	add    %al,(%eax)
  280f2d:	41                   	inc    %ecx
  280f2e:	0e                   	push   %cs
  280f2f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f35:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
  280f39:	04 00                	add    $0x0,%al
  280f3b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280f3e:	00 00                	add    %al,(%eax)
  280f40:	40                   	inc    %eax
  280f41:	01 00                	add    %eax,(%eax)
  280f43:	00 a5 f7 ff ff b1    	add    %ah,-0x4e000009(%ebp)
  280f49:	00 00                	add    %al,(%eax)
  280f4b:	00 00                	add    %al,(%eax)
  280f4d:	41                   	inc    %ecx
  280f4e:	0e                   	push   %cs
  280f4f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f55:	02 ad c5 0c 04 04    	add    0x4040cc5(%ebp),%ch
  280f5b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280f5e:	00 00                	add    %al,(%eax)
  280f60:	60                   	pusha  
  280f61:	01 00                	add    %eax,(%eax)
  280f63:	00 36                	add    %dh,(%esi)
  280f65:	f8                   	clc    
  280f66:	ff                   	(bad)  
  280f67:	ff 69 00             	ljmp   *0x0(%ecx)
  280f6a:	00 00                	add    %al,(%eax)
  280f6c:	00 41 0e             	add    %al,0xe(%ecx)
  280f6f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f75:	02 65 c5             	add    -0x3b(%ebp),%ah
  280f78:	0c 04                	or     $0x4,%al
  280f7a:	04 00                	add    $0x0,%al
  280f7c:	1c 00                	sbb    $0x0,%al
  280f7e:	00 00                	add    %al,(%eax)
  280f80:	80 01 00             	addb   $0x0,(%ecx)
  280f83:	00 7f f8             	add    %bh,-0x8(%edi)
  280f86:	ff                   	(bad)  
  280f87:	ff d0                	call   *%eax
  280f89:	00 00                	add    %al,(%eax)
  280f8b:	00 00                	add    %al,(%eax)
  280f8d:	41                   	inc    %ecx
  280f8e:	0e                   	push   %cs
  280f8f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280f95:	02 cc                	add    %ah,%cl
  280f97:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  280f9a:	04 00                	add    $0x0,%al
  280f9c:	1c 00                	sbb    $0x0,%al
  280f9e:	00 00                	add    %al,(%eax)
  280fa0:	a0 01 00 00 2f       	mov    0x2f000001,%al
  280fa5:	f9                   	stc    
  280fa6:	ff                   	(bad)  
  280fa7:	ff 4b 00             	decl   0x0(%ebx)
  280faa:	00 00                	add    %al,(%eax)
  280fac:	00 41 0e             	add    %al,0xe(%ecx)
  280faf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280fb5:	02 47 c5             	add    -0x3b(%edi),%al
  280fb8:	0c 04                	or     $0x4,%al
  280fba:	04 00                	add    $0x0,%al
  280fbc:	1c 00                	sbb    $0x0,%al
  280fbe:	00 00                	add    %al,(%eax)
  280fc0:	c0 01 00             	rolb   $0x0,(%ecx)
  280fc3:	00 5a f9             	add    %bl,-0x7(%edx)
  280fc6:	ff                   	(bad)  
  280fc7:	ff a7 00 00 00 00    	jmp    *0x0(%edi)
  280fcd:	41                   	inc    %ecx
  280fce:	0e                   	push   %cs
  280fcf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280fd5:	02 a3 c5 0c 04 04    	add    0x4040cc5(%ebx),%ah
  280fdb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280fde:	00 00                	add    %al,(%eax)
  280fe0:	e0 01                	loopne 280fe3 <cursor.1704+0x2e3>
  280fe2:	00 00                	add    %al,(%eax)
  280fe4:	e1 f9                	loope  280fdf <cursor.1704+0x2df>
  280fe6:	ff                   	(bad)  
  280fe7:	ff 99 00 00 00 00    	lcall  *0x0(%ecx)
  280fed:	41                   	inc    %ecx
  280fee:	0e                   	push   %cs
  280fef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  280ff5:	02 95 c5 0c 04 04    	add    0x4040cc5(%ebp),%dl
  280ffb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  280ffe:	00 00                	add    %al,(%eax)
  281000:	00 02                	add    %al,(%edx)
  281002:	00 00                	add    %al,(%eax)
  281004:	5a                   	pop    %edx
  281005:	fa                   	cli    
  281006:	ff                   	(bad)  
  281007:	ff                   	(bad)  
  281008:	7a 00                	jp     28100a <cursor.1704+0x30a>
  28100a:	00 00                	add    %al,(%eax)
  28100c:	00 41 0e             	add    %al,0xe(%ecx)
  28100f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  281015:	02 76 c5             	add    -0x3b(%esi),%dh
  281018:	0c 04                	or     $0x4,%al
  28101a:	04 00                	add    $0x0,%al
  28101c:	1c 00                	sbb    $0x0,%al
  28101e:	00 00                	add    %al,(%eax)
  281020:	20 02                	and    %al,(%edx)
  281022:	00 00                	add    %al,(%eax)
  281024:	b4 fa                	mov    $0xfa,%ah
  281026:	ff                   	(bad)  
  281027:	ff 44 00 00          	incl   0x0(%eax,%eax,1)
  28102b:	00 00                	add    %al,(%eax)
  28102d:	41                   	inc    %ecx
  28102e:	0e                   	push   %cs
  28102f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  281035:	02 40 c5             	add    -0x3b(%eax),%al
  281038:	0c 04                	or     $0x4,%al
  28103a:	04 00                	add    $0x0,%al
  28103c:	1c 00                	sbb    $0x0,%al
  28103e:	00 00                	add    %al,(%eax)
  281040:	40                   	inc    %eax
  281041:	02 00                	add    (%eax),%al
  281043:	00 d8                	add    %bl,%al
  281045:	fa                   	cli    
  281046:	ff                   	(bad)  
  281047:	ff 51 01             	call   *0x1(%ecx)
  28104a:	00 00                	add    %al,(%eax)
  28104c:	00 41 0e             	add    %al,0xe(%ecx)
  28104f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  281055:	03 4d 01             	add    0x1(%ebp),%ecx
  281058:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28105b:	04                   	.byte 0x4

Disassembly of section .data:

00281060 <Font8x16>:
	...
  281270:	00 00                	add    %al,(%eax)
  281272:	00 10                	add    %dl,(%eax)
  281274:	10 10                	adc    %dl,(%eax)
  281276:	10 10                	adc    %dl,(%eax)
  281278:	10 00                	adc    %al,(%eax)
  28127a:	10 10                	adc    %dl,(%eax)
  28127c:	00 00                	add    %al,(%eax)
  28127e:	00 00                	add    %al,(%eax)
  281280:	00 00                	add    %al,(%eax)
  281282:	00 24 24             	add    %ah,(%esp)
  281285:	24 00                	and    $0x0,%al
	...
  281293:	24 24                	and    $0x24,%al
  281295:	7e 24                	jle    2812bb <Font8x16+0x25b>
  281297:	24 24                	and    $0x24,%al
  281299:	7e 24                	jle    2812bf <Font8x16+0x25f>
  28129b:	24 00                	and    $0x0,%al
  28129d:	00 00                	add    %al,(%eax)
  28129f:	00 00                	add    %al,(%eax)
  2812a1:	00 00                	add    %al,(%eax)
  2812a3:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  2812a7:	7c 12                	jl     2812bb <Font8x16+0x25b>
  2812a9:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  2812ad:	00 00                	add    %al,(%eax)
  2812af:	00 00                	add    %al,(%eax)
  2812b1:	00 00                	add    %al,(%eax)
  2812b3:	00 62 64             	add    %ah,0x64(%edx)
  2812b6:	08 10                	or     %dl,(%eax)
  2812b8:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  2812c4:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  2812c7:	50                   	push   %eax
  2812c8:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  2812cf:	00 00                	add    %al,(%eax)
  2812d1:	00 00                	add    %al,(%eax)
  2812d3:	10 10                	adc    %dl,(%eax)
  2812d5:	20 00                	and    %al,(%eax)
	...
  2812df:	00 00                	add    %al,(%eax)
  2812e1:	00 08                	add    %cl,(%eax)
  2812e3:	10 20                	adc    %ah,(%eax)
  2812e5:	20 20                	and    %ah,(%eax)
  2812e7:	20 20                	and    %ah,(%eax)
  2812e9:	20 20                	and    %ah,(%eax)
  2812eb:	10 08                	adc    %cl,(%eax)
  2812ed:	00 00                	add    %al,(%eax)
  2812ef:	00 00                	add    %al,(%eax)
  2812f1:	00 20                	add    %ah,(%eax)
  2812f3:	10 08                	adc    %cl,(%eax)
  2812f5:	08 08                	or     %cl,(%eax)
  2812f7:	08 08                	or     %cl,(%eax)
  2812f9:	08 08                	or     %cl,(%eax)
  2812fb:	10 20                	adc    %ah,(%eax)
	...
  281305:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  281309:	54                   	push   %esp
  28130a:	10 00                	adc    %al,(%eax)
	...
  281314:	00 10                	add    %dl,(%eax)
  281316:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  28132a:	10 10                	adc    %dl,(%eax)
  28132c:	20 00                	and    %al,(%eax)
	...
  281336:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  28134a:	00 10                	add    %dl,(%eax)
	...
  281354:	00 02                	add    %al,(%edx)
  281356:	04 08                	add    $0x8,%al
  281358:	10 20                	adc    %ah,(%eax)
  28135a:	40                   	inc    %eax
	...
  281363:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  281367:	54                   	push   %esp
  281368:	64                   	fs
  281369:	44                   	inc    %esp
  28136a:	44                   	inc    %esp
  28136b:	38 00                	cmp    %al,(%eax)
  28136d:	00 00                	add    %al,(%eax)
  28136f:	00 00                	add    %al,(%eax)
  281371:	00 00                	add    %al,(%eax)
  281373:	10 30                	adc    %dh,(%eax)
  281375:	10 10                	adc    %dl,(%eax)
  281377:	10 10                	adc    %dl,(%eax)
  281379:	10 10                	adc    %dl,(%eax)
  28137b:	38 00                	cmp    %al,(%eax)
  28137d:	00 00                	add    %al,(%eax)
  28137f:	00 00                	add    %al,(%eax)
  281381:	00 00                	add    %al,(%eax)
  281383:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  281387:	08 10                	or     %dl,(%eax)
  281389:	20 40 7c             	and    %al,0x7c(%eax)
  28138c:	00 00                	add    %al,(%eax)
  28138e:	00 00                	add    %al,(%eax)
  281390:	00 00                	add    %al,(%eax)
  281392:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  281396:	10 38                	adc    %bh,(%eax)
  281398:	04 04                	add    $0x4,%al
  28139a:	04 78                	add    $0x78,%al
  28139c:	00 00                	add    %al,(%eax)
  28139e:	00 00                	add    %al,(%eax)
  2813a0:	00 00                	add    %al,(%eax)
  2813a2:	00 08                	add    %cl,(%eax)
  2813a4:	18 28                	sbb    %ch,(%eax)
  2813a6:	48                   	dec    %eax
  2813a7:	48                   	dec    %eax
  2813a8:	7c 08                	jl     2813b2 <Font8x16+0x352>
  2813aa:	08 08                	or     %cl,(%eax)
  2813ac:	00 00                	add    %al,(%eax)
  2813ae:	00 00                	add    %al,(%eax)
  2813b0:	00 00                	add    %al,(%eax)
  2813b2:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  2813b6:	40                   	inc    %eax
  2813b7:	78 04                	js     2813bd <Font8x16+0x35d>
  2813b9:	04 04                	add    $0x4,%al
  2813bb:	78 00                	js     2813bd <Font8x16+0x35d>
  2813bd:	00 00                	add    %al,(%eax)
  2813bf:	00 00                	add    %al,(%eax)
  2813c1:	00 00                	add    %al,(%eax)
  2813c3:	3c 40                	cmp    $0x40,%al
  2813c5:	40                   	inc    %eax
  2813c6:	40                   	inc    %eax
  2813c7:	78 44                	js     28140d <Font8x16+0x3ad>
  2813c9:	44                   	inc    %esp
  2813ca:	44                   	inc    %esp
  2813cb:	38 00                	cmp    %al,(%eax)
  2813cd:	00 00                	add    %al,(%eax)
  2813cf:	00 00                	add    %al,(%eax)
  2813d1:	00 00                	add    %al,(%eax)
  2813d3:	7c 04                	jl     2813d9 <Font8x16+0x379>
  2813d5:	04 08                	add    $0x8,%al
  2813d7:	10 20                	adc    %ah,(%eax)
  2813d9:	20 20                	and    %ah,(%eax)
  2813db:	20 00                	and    %al,(%eax)
  2813dd:	00 00                	add    %al,(%eax)
  2813df:	00 00                	add    %al,(%eax)
  2813e1:	00 00                	add    %al,(%eax)
  2813e3:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813e7:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813eb:	38 00                	cmp    %al,(%eax)
  2813ed:	00 00                	add    %al,(%eax)
  2813ef:	00 00                	add    %al,(%eax)
  2813f1:	00 00                	add    %al,(%eax)
  2813f3:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2813f7:	3c 04                	cmp    $0x4,%al
  2813f9:	04 04                	add    $0x4,%al
  2813fb:	38 00                	cmp    %al,(%eax)
	...
  281405:	00 00                	add    %al,(%eax)
  281407:	10 00                	adc    %al,(%eax)
  281409:	00 10                	add    %dl,(%eax)
	...
  281417:	00 10                	add    %dl,(%eax)
  281419:	00 10                	add    %dl,(%eax)
  28141b:	10 20                	adc    %ah,(%eax)
	...
  281425:	04 08                	add    $0x8,%al
  281427:	10 20                	adc    %ah,(%eax)
  281429:	10 08                	adc    %cl,(%eax)
  28142b:	04 00                	add    $0x0,%al
	...
  281435:	00 00                	add    %al,(%eax)
  281437:	7c 00                	jl     281439 <Font8x16+0x3d9>
  281439:	7c 00                	jl     28143b <Font8x16+0x3db>
	...
  281443:	00 00                	add    %al,(%eax)
  281445:	20 10                	and    %dl,(%eax)
  281447:	08 04 08             	or     %al,(%eax,%ecx,1)
  28144a:	10 20                	adc    %ah,(%eax)
  28144c:	00 00                	add    %al,(%eax)
  28144e:	00 00                	add    %al,(%eax)
  281450:	00 00                	add    %al,(%eax)
  281452:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  281456:	08 10                	or     %dl,(%eax)
  281458:	10 00                	adc    %al,(%eax)
  28145a:	10 10                	adc    %dl,(%eax)
	...
  281464:	00 38                	add    %bh,(%eax)
  281466:	44                   	inc    %esp
  281467:	5c                   	pop    %esp
  281468:	54                   	push   %esp
  281469:	5c                   	pop    %esp
  28146a:	40                   	inc    %eax
  28146b:	3c 00                	cmp    $0x0,%al
  28146d:	00 00                	add    %al,(%eax)
  28146f:	00 00                	add    %al,(%eax)
  281471:	00 18                	add    %bl,(%eax)
  281473:	24 42                	and    $0x42,%al
  281475:	42                   	inc    %edx
  281476:	42                   	inc    %edx
  281477:	7e 42                	jle    2814bb <Font8x16+0x45b>
  281479:	42                   	inc    %edx
  28147a:	42                   	inc    %edx
  28147b:	42                   	inc    %edx
  28147c:	00 00                	add    %al,(%eax)
  28147e:	00 00                	add    %al,(%eax)
  281480:	00 00                	add    %al,(%eax)
  281482:	7c 42                	jl     2814c6 <Font8x16+0x466>
  281484:	42                   	inc    %edx
  281485:	42                   	inc    %edx
  281486:	7c 42                	jl     2814ca <Font8x16+0x46a>
  281488:	42                   	inc    %edx
  281489:	42                   	inc    %edx
  28148a:	42                   	inc    %edx
  28148b:	7c 00                	jl     28148d <Font8x16+0x42d>
  28148d:	00 00                	add    %al,(%eax)
  28148f:	00 00                	add    %al,(%eax)
  281491:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281494:	40                   	inc    %eax
  281495:	40                   	inc    %eax
  281496:	40                   	inc    %eax
  281497:	40                   	inc    %eax
  281498:	40                   	inc    %eax
  281499:	40                   	inc    %eax
  28149a:	42                   	inc    %edx
  28149b:	3c 00                	cmp    $0x0,%al
  28149d:	00 00                	add    %al,(%eax)
  28149f:	00 00                	add    %al,(%eax)
  2814a1:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  2814a5:	42                   	inc    %edx
  2814a6:	42                   	inc    %edx
  2814a7:	42                   	inc    %edx
  2814a8:	42                   	inc    %edx
  2814a9:	42                   	inc    %edx
  2814aa:	42                   	inc    %edx
  2814ab:	7c 00                	jl     2814ad <Font8x16+0x44d>
  2814ad:	00 00                	add    %al,(%eax)
  2814af:	00 00                	add    %al,(%eax)
  2814b1:	00 7e 40             	add    %bh,0x40(%esi)
  2814b4:	40                   	inc    %eax
  2814b5:	40                   	inc    %eax
  2814b6:	78 40                	js     2814f8 <Font8x16+0x498>
  2814b8:	40                   	inc    %eax
  2814b9:	40                   	inc    %eax
  2814ba:	40                   	inc    %eax
  2814bb:	7e 00                	jle    2814bd <Font8x16+0x45d>
  2814bd:	00 00                	add    %al,(%eax)
  2814bf:	00 00                	add    %al,(%eax)
  2814c1:	00 7e 40             	add    %bh,0x40(%esi)
  2814c4:	40                   	inc    %eax
  2814c5:	40                   	inc    %eax
  2814c6:	78 40                	js     281508 <Font8x16+0x4a8>
  2814c8:	40                   	inc    %eax
  2814c9:	40                   	inc    %eax
  2814ca:	40                   	inc    %eax
  2814cb:	40                   	inc    %eax
  2814cc:	00 00                	add    %al,(%eax)
  2814ce:	00 00                	add    %al,(%eax)
  2814d0:	00 00                	add    %al,(%eax)
  2814d2:	3c 42                	cmp    $0x42,%al
  2814d4:	40                   	inc    %eax
  2814d5:	40                   	inc    %eax
  2814d6:	5e                   	pop    %esi
  2814d7:	42                   	inc    %edx
  2814d8:	42                   	inc    %edx
  2814d9:	42                   	inc    %edx
  2814da:	42                   	inc    %edx
  2814db:	3c 00                	cmp    $0x0,%al
  2814dd:	00 00                	add    %al,(%eax)
  2814df:	00 00                	add    %al,(%eax)
  2814e1:	00 42 42             	add    %al,0x42(%edx)
  2814e4:	42                   	inc    %edx
  2814e5:	42                   	inc    %edx
  2814e6:	7e 42                	jle    28152a <Font8x16+0x4ca>
  2814e8:	42                   	inc    %edx
  2814e9:	42                   	inc    %edx
  2814ea:	42                   	inc    %edx
  2814eb:	42                   	inc    %edx
  2814ec:	00 00                	add    %al,(%eax)
  2814ee:	00 00                	add    %al,(%eax)
  2814f0:	00 00                	add    %al,(%eax)
  2814f2:	38 10                	cmp    %dl,(%eax)
  2814f4:	10 10                	adc    %dl,(%eax)
  2814f6:	10 10                	adc    %dl,(%eax)
  2814f8:	10 10                	adc    %dl,(%eax)
  2814fa:	10 38                	adc    %bh,(%eax)
  2814fc:	00 00                	add    %al,(%eax)
  2814fe:	00 00                	add    %al,(%eax)
  281500:	00 00                	add    %al,(%eax)
  281502:	1c 08                	sbb    $0x8,%al
  281504:	08 08                	or     %cl,(%eax)
  281506:	08 08                	or     %cl,(%eax)
  281508:	08 08                	or     %cl,(%eax)
  28150a:	48                   	dec    %eax
  28150b:	30 00                	xor    %al,(%eax)
  28150d:	00 00                	add    %al,(%eax)
  28150f:	00 00                	add    %al,(%eax)
  281511:	00 42 44             	add    %al,0x44(%edx)
  281514:	48                   	dec    %eax
  281515:	50                   	push   %eax
  281516:	60                   	pusha  
  281517:	60                   	pusha  
  281518:	50                   	push   %eax
  281519:	48                   	dec    %eax
  28151a:	44                   	inc    %esp
  28151b:	42                   	inc    %edx
  28151c:	00 00                	add    %al,(%eax)
  28151e:	00 00                	add    %al,(%eax)
  281520:	00 00                	add    %al,(%eax)
  281522:	40                   	inc    %eax
  281523:	40                   	inc    %eax
  281524:	40                   	inc    %eax
  281525:	40                   	inc    %eax
  281526:	40                   	inc    %eax
  281527:	40                   	inc    %eax
  281528:	40                   	inc    %eax
  281529:	40                   	inc    %eax
  28152a:	40                   	inc    %eax
  28152b:	7e 00                	jle    28152d <Font8x16+0x4cd>
  28152d:	00 00                	add    %al,(%eax)
  28152f:	00 00                	add    %al,(%eax)
  281531:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  281537:	aa                   	stos   %al,%es:(%edi)
  281538:	92                   	xchg   %eax,%edx
  281539:	92                   	xchg   %eax,%edx
  28153a:	82                   	(bad)  
  28153b:	82                   	(bad)  
  28153c:	00 00                	add    %al,(%eax)
  28153e:	00 00                	add    %al,(%eax)
  281540:	00 00                	add    %al,(%eax)
  281542:	42                   	inc    %edx
  281543:	62 62 52             	bound  %esp,0x52(%edx)
  281546:	52                   	push   %edx
  281547:	4a                   	dec    %edx
  281548:	4a                   	dec    %edx
  281549:	46                   	inc    %esi
  28154a:	46                   	inc    %esi
  28154b:	42                   	inc    %edx
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
  28155a:	42                   	inc    %edx
  28155b:	3c 00                	cmp    $0x0,%al
  28155d:	00 00                	add    %al,(%eax)
  28155f:	00 00                	add    %al,(%eax)
  281561:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281565:	42                   	inc    %edx
  281566:	42                   	inc    %edx
  281567:	7c 40                	jl     2815a9 <Font8x16+0x549>
  281569:	40                   	inc    %eax
  28156a:	40                   	inc    %eax
  28156b:	40                   	inc    %eax
  28156c:	00 00                	add    %al,(%eax)
  28156e:	00 00                	add    %al,(%eax)
  281570:	00 00                	add    %al,(%eax)
  281572:	3c 42                	cmp    $0x42,%al
  281574:	42                   	inc    %edx
  281575:	42                   	inc    %edx
  281576:	42                   	inc    %edx
  281577:	42                   	inc    %edx
  281578:	42                   	inc    %edx
  281579:	42                   	inc    %edx
  28157a:	4a                   	dec    %edx
  28157b:	3c 0e                	cmp    $0xe,%al
  28157d:	00 00                	add    %al,(%eax)
  28157f:	00 00                	add    %al,(%eax)
  281581:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281585:	42                   	inc    %edx
  281586:	42                   	inc    %edx
  281587:	7c 50                	jl     2815d9 <Font8x16+0x579>
  281589:	48                   	dec    %eax
  28158a:	44                   	inc    %esp
  28158b:	42                   	inc    %edx
  28158c:	00 00                	add    %al,(%eax)
  28158e:	00 00                	add    %al,(%eax)
  281590:	00 00                	add    %al,(%eax)
  281592:	3c 42                	cmp    $0x42,%al
  281594:	40                   	inc    %eax
  281595:	40                   	inc    %eax
  281596:	3c 02                	cmp    $0x2,%al
  281598:	02 02                	add    (%edx),%al
  28159a:	42                   	inc    %edx
  28159b:	3c 00                	cmp    $0x0,%al
  28159d:	00 00                	add    %al,(%eax)
  28159f:	00 00                	add    %al,(%eax)
  2815a1:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  2815a5:	10 10                	adc    %dl,(%eax)
  2815a7:	10 10                	adc    %dl,(%eax)
  2815a9:	10 10                	adc    %dl,(%eax)
  2815ab:	10 00                	adc    %al,(%eax)
  2815ad:	00 00                	add    %al,(%eax)
  2815af:	00 00                	add    %al,(%eax)
  2815b1:	00 42 42             	add    %al,0x42(%edx)
  2815b4:	42                   	inc    %edx
  2815b5:	42                   	inc    %edx
  2815b6:	42                   	inc    %edx
  2815b7:	42                   	inc    %edx
  2815b8:	42                   	inc    %edx
  2815b9:	42                   	inc    %edx
  2815ba:	42                   	inc    %edx
  2815bb:	3c 00                	cmp    $0x0,%al
  2815bd:	00 00                	add    %al,(%eax)
  2815bf:	00 00                	add    %al,(%eax)
  2815c1:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  2815c5:	44                   	inc    %esp
  2815c6:	28 28                	sub    %ch,(%eax)
  2815c8:	28 10                	sub    %dl,(%eax)
  2815ca:	10 10                	adc    %dl,(%eax)
  2815cc:	00 00                	add    %al,(%eax)
  2815ce:	00 00                	add    %al,(%eax)
  2815d0:	00 00                	add    %al,(%eax)
  2815d2:	82                   	(bad)  
  2815d3:	82                   	(bad)  
  2815d4:	82                   	(bad)  
  2815d5:	82                   	(bad)  
  2815d6:	54                   	push   %esp
  2815d7:	54                   	push   %esp
  2815d8:	54                   	push   %esp
  2815d9:	28 28                	sub    %ch,(%eax)
  2815db:	28 00                	sub    %al,(%eax)
  2815dd:	00 00                	add    %al,(%eax)
  2815df:	00 00                	add    %al,(%eax)
  2815e1:	00 42 42             	add    %al,0x42(%edx)
  2815e4:	24 18                	and    $0x18,%al
  2815e6:	18 18                	sbb    %bl,(%eax)
  2815e8:	24 24                	and    $0x24,%al
  2815ea:	42                   	inc    %edx
  2815eb:	42                   	inc    %edx
  2815ec:	00 00                	add    %al,(%eax)
  2815ee:	00 00                	add    %al,(%eax)
  2815f0:	00 00                	add    %al,(%eax)
  2815f2:	44                   	inc    %esp
  2815f3:	44                   	inc    %esp
  2815f4:	44                   	inc    %esp
  2815f5:	44                   	inc    %esp
  2815f6:	28 28                	sub    %ch,(%eax)
  2815f8:	10 10                	adc    %dl,(%eax)
  2815fa:	10 10                	adc    %dl,(%eax)
  2815fc:	00 00                	add    %al,(%eax)
  2815fe:	00 00                	add    %al,(%eax)
  281600:	00 00                	add    %al,(%eax)
  281602:	7e 02                	jle    281606 <Font8x16+0x5a6>
  281604:	02 04 08             	add    (%eax,%ecx,1),%al
  281607:	10 20                	adc    %ah,(%eax)
  281609:	40                   	inc    %eax
  28160a:	40                   	inc    %eax
  28160b:	7e 00                	jle    28160d <Font8x16+0x5ad>
  28160d:	00 00                	add    %al,(%eax)
  28160f:	00 00                	add    %al,(%eax)
  281611:	00 38                	add    %bh,(%eax)
  281613:	20 20                	and    %ah,(%eax)
  281615:	20 20                	and    %ah,(%eax)
  281617:	20 20                	and    %ah,(%eax)
  281619:	20 20                	and    %ah,(%eax)
  28161b:	38 00                	cmp    %al,(%eax)
	...
  281625:	00 40 20             	add    %al,0x20(%eax)
  281628:	10 08                	adc    %cl,(%eax)
  28162a:	04 02                	add    $0x2,%al
  28162c:	00 00                	add    %al,(%eax)
  28162e:	00 00                	add    %al,(%eax)
  281630:	00 00                	add    %al,(%eax)
  281632:	1c 04                	sbb    $0x4,%al
  281634:	04 04                	add    $0x4,%al
  281636:	04 04                	add    $0x4,%al
  281638:	04 04                	add    $0x4,%al
  28163a:	04 1c                	add    $0x1c,%al
	...
  281644:	10 28                	adc    %ch,(%eax)
  281646:	44                   	inc    %esp
	...
  28165b:	00 ff                	add    %bh,%bh
  28165d:	00 00                	add    %al,(%eax)
  28165f:	00 00                	add    %al,(%eax)
  281661:	00 00                	add    %al,(%eax)
  281663:	10 10                	adc    %dl,(%eax)
  281665:	08 00                	or     %al,(%eax)
	...
  281673:	00 00                	add    %al,(%eax)
  281675:	78 04                	js     28167b <Font8x16+0x61b>
  281677:	3c 44                	cmp    $0x44,%al
  281679:	44                   	inc    %esp
  28167a:	44                   	inc    %esp
  28167b:	3a 00                	cmp    (%eax),%al
  28167d:	00 00                	add    %al,(%eax)
  28167f:	00 00                	add    %al,(%eax)
  281681:	00 40 40             	add    %al,0x40(%eax)
  281684:	40                   	inc    %eax
  281685:	5c                   	pop    %esp
  281686:	62 42 42             	bound  %eax,0x42(%edx)
  281689:	42                   	inc    %edx
  28168a:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  28168e:	00 00                	add    %al,(%eax)
  281690:	00 00                	add    %al,(%eax)
  281692:	00 00                	add    %al,(%eax)
  281694:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281697:	40                   	inc    %eax
  281698:	40                   	inc    %eax
  281699:	40                   	inc    %eax
  28169a:	42                   	inc    %edx
  28169b:	3c 00                	cmp    $0x0,%al
  28169d:	00 00                	add    %al,(%eax)
  28169f:	00 00                	add    %al,(%eax)
  2816a1:	00 02                	add    %al,(%edx)
  2816a3:	02 02                	add    (%edx),%al
  2816a5:	3a 46 42             	cmp    0x42(%esi),%al
  2816a8:	42                   	inc    %edx
  2816a9:	42                   	inc    %edx
  2816aa:	46                   	inc    %esi
  2816ab:	3a 00                	cmp    (%eax),%al
	...
  2816b5:	3c 42                	cmp    $0x42,%al
  2816b7:	42                   	inc    %edx
  2816b8:	7e 40                	jle    2816fa <Font8x16+0x69a>
  2816ba:	42                   	inc    %edx
  2816bb:	3c 00                	cmp    $0x0,%al
  2816bd:	00 00                	add    %al,(%eax)
  2816bf:	00 00                	add    %al,(%eax)
  2816c1:	00 0e                	add    %cl,(%esi)
  2816c3:	10 10                	adc    %dl,(%eax)
  2816c5:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  2816c8:	10 10                	adc    %dl,(%eax)
  2816ca:	10 10                	adc    %dl,(%eax)
	...
  2816d4:	00 3e                	add    %bh,(%esi)
  2816d6:	42                   	inc    %edx
  2816d7:	42                   	inc    %edx
  2816d8:	42                   	inc    %edx
  2816d9:	42                   	inc    %edx
  2816da:	3e 02 02             	add    %ds:(%edx),%al
  2816dd:	3c 00                	cmp    $0x0,%al
  2816df:	00 00                	add    %al,(%eax)
  2816e1:	00 40 40             	add    %al,0x40(%eax)
  2816e4:	40                   	inc    %eax
  2816e5:	5c                   	pop    %esp
  2816e6:	62 42 42             	bound  %eax,0x42(%edx)
  2816e9:	42                   	inc    %edx
  2816ea:	42                   	inc    %edx
  2816eb:	42                   	inc    %edx
  2816ec:	00 00                	add    %al,(%eax)
  2816ee:	00 00                	add    %al,(%eax)
  2816f0:	00 00                	add    %al,(%eax)
  2816f2:	00 08                	add    %cl,(%eax)
  2816f4:	00 08                	add    %cl,(%eax)
  2816f6:	08 08                	or     %cl,(%eax)
  2816f8:	08 08                	or     %cl,(%eax)
  2816fa:	08 08                	or     %cl,(%eax)
  2816fc:	00 00                	add    %al,(%eax)
  2816fe:	00 00                	add    %al,(%eax)
  281700:	00 00                	add    %al,(%eax)
  281702:	00 04 00             	add    %al,(%eax,%eax,1)
  281705:	04 04                	add    $0x4,%al
  281707:	04 04                	add    $0x4,%al
  281709:	04 04                	add    $0x4,%al
  28170b:	04 44                	add    $0x44,%al
  28170d:	38 00                	cmp    %al,(%eax)
  28170f:	00 00                	add    %al,(%eax)
  281711:	00 40 40             	add    %al,0x40(%eax)
  281714:	40                   	inc    %eax
  281715:	42                   	inc    %edx
  281716:	44                   	inc    %esp
  281717:	48                   	dec    %eax
  281718:	50                   	push   %eax
  281719:	68 44 42 00 00       	push   $0x4244
  28171e:	00 00                	add    %al,(%eax)
  281720:	00 00                	add    %al,(%eax)
  281722:	10 10                	adc    %dl,(%eax)
  281724:	10 10                	adc    %dl,(%eax)
  281726:	10 10                	adc    %dl,(%eax)
  281728:	10 10                	adc    %dl,(%eax)
  28172a:	10 10                	adc    %dl,(%eax)
	...
  281734:	00 ec                	add    %ch,%ah
  281736:	92                   	xchg   %eax,%edx
  281737:	92                   	xchg   %eax,%edx
  281738:	92                   	xchg   %eax,%edx
  281739:	92                   	xchg   %eax,%edx
  28173a:	92                   	xchg   %eax,%edx
  28173b:	92                   	xchg   %eax,%edx
	...
  281744:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281748:	42                   	inc    %edx
  281749:	42                   	inc    %edx
  28174a:	42                   	inc    %edx
  28174b:	42                   	inc    %edx
	...
  281754:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281757:	42                   	inc    %edx
  281758:	42                   	inc    %edx
  281759:	42                   	inc    %edx
  28175a:	42                   	inc    %edx
  28175b:	3c 00                	cmp    $0x0,%al
	...
  281765:	5c                   	pop    %esp
  281766:	62 42 42             	bound  %eax,0x42(%edx)
  281769:	42                   	inc    %edx
  28176a:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  28176e:	00 00                	add    %al,(%eax)
  281770:	00 00                	add    %al,(%eax)
  281772:	00 00                	add    %al,(%eax)
  281774:	00 3a                	add    %bh,(%edx)
  281776:	46                   	inc    %esi
  281777:	42                   	inc    %edx
  281778:	42                   	inc    %edx
  281779:	42                   	inc    %edx
  28177a:	46                   	inc    %esi
  28177b:	3a 02                	cmp    (%edx),%al
  28177d:	02 00                	add    (%eax),%al
  28177f:	00 00                	add    %al,(%eax)
  281781:	00 00                	add    %al,(%eax)
  281783:	00 00                	add    %al,(%eax)
  281785:	5c                   	pop    %esp
  281786:	62 40 40             	bound  %eax,0x40(%eax)
  281789:	40                   	inc    %eax
  28178a:	40                   	inc    %eax
  28178b:	40                   	inc    %eax
	...
  281794:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281797:	40                   	inc    %eax
  281798:	3c 02                	cmp    $0x2,%al
  28179a:	42                   	inc    %edx
  28179b:	3c 00                	cmp    $0x0,%al
  28179d:	00 00                	add    %al,(%eax)
  28179f:	00 00                	add    %al,(%eax)
  2817a1:	00 00                	add    %al,(%eax)
  2817a3:	20 20                	and    %ah,(%eax)
  2817a5:	78 20                	js     2817c7 <Font8x16+0x767>
  2817a7:	20 20                	and    %ah,(%eax)
  2817a9:	20 22                	and    %ah,(%edx)
  2817ab:	1c 00                	sbb    $0x0,%al
	...
  2817b5:	42                   	inc    %edx
  2817b6:	42                   	inc    %edx
  2817b7:	42                   	inc    %edx
  2817b8:	42                   	inc    %edx
  2817b9:	42                   	inc    %edx
  2817ba:	42                   	inc    %edx
  2817bb:	3e 00 00             	add    %al,%ds:(%eax)
  2817be:	00 00                	add    %al,(%eax)
  2817c0:	00 00                	add    %al,(%eax)
  2817c2:	00 00                	add    %al,(%eax)
  2817c4:	00 42 42             	add    %al,0x42(%edx)
  2817c7:	42                   	inc    %edx
  2817c8:	42                   	inc    %edx
  2817c9:	42                   	inc    %edx
  2817ca:	24 18                	and    $0x18,%al
	...
  2817d4:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  2817da:	aa                   	stos   %al,%es:(%edi)
  2817db:	44                   	inc    %esp
	...
  2817e4:	00 42 42             	add    %al,0x42(%edx)
  2817e7:	24 18                	and    $0x18,%al
  2817e9:	24 42                	and    $0x42,%al
  2817eb:	42                   	inc    %edx
	...
  2817f4:	00 42 42             	add    %al,0x42(%edx)
  2817f7:	42                   	inc    %edx
  2817f8:	42                   	inc    %edx
  2817f9:	42                   	inc    %edx
  2817fa:	3e 02 02             	add    %ds:(%edx),%al
  2817fd:	3c 00                	cmp    $0x0,%al
  2817ff:	00 00                	add    %al,(%eax)
  281801:	00 00                	add    %al,(%eax)
  281803:	00 00                	add    %al,(%eax)
  281805:	7e 02                	jle    281809 <Font8x16+0x7a9>
  281807:	04 18                	add    $0x18,%al
  281809:	20 40 7e             	and    %al,0x7e(%eax)
  28180c:	00 00                	add    %al,(%eax)
  28180e:	00 00                	add    %al,(%eax)
  281810:	00 00                	add    %al,(%eax)
  281812:	08 10                	or     %dl,(%eax)
  281814:	10 10                	adc    %dl,(%eax)
  281816:	20 40 20             	and    %al,0x20(%eax)
  281819:	10 10                	adc    %dl,(%eax)
  28181b:	10 08                	adc    %cl,(%eax)
  28181d:	00 00                	add    %al,(%eax)
  28181f:	00 00                	add    %al,(%eax)
  281821:	10 10                	adc    %dl,(%eax)
  281823:	10 10                	adc    %dl,(%eax)
  281825:	10 10                	adc    %dl,(%eax)
  281827:	10 10                	adc    %dl,(%eax)
  281829:	10 10                	adc    %dl,(%eax)
  28182b:	10 10                	adc    %dl,(%eax)
  28182d:	10 10                	adc    %dl,(%eax)
  28182f:	00 00                	add    %al,(%eax)
  281831:	00 20                	add    %ah,(%eax)
  281833:	10 10                	adc    %dl,(%eax)
  281835:	10 08                	adc    %cl,(%eax)
  281837:	04 08                	add    $0x8,%al
  281839:	10 10                	adc    %dl,(%eax)
  28183b:	10 20                	adc    %ah,(%eax)
	...
  281845:	00 22                	add    %ah,(%edx)
  281847:	54                   	push   %esp
  281848:	88 00                	mov    %al,(%eax)
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
