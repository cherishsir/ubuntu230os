
boot.elf:     file format elf32-i386


Disassembly of section .text:

00008200 <start>:
    8200:	31 c0                	xor    %eax,%eax
    8202:	8e d8                	mov    %eax,%ds
    8204:	8e c0                	mov    %eax,%es
    8206:	8e d0                	mov    %eax,%ss
    8208:	31 c0                	xor    %eax,%eax
    820a:	31 c9                	xor    %ecx,%ecx
    820c:	52                   	push   %edx
    820d:	be b5 82 e8 89       	mov    $0x89e882b5,%esi
    8212:	01 be ab 82 e8 96    	add    %edi,-0x69177d55(%esi)
    8218:	01 a1 fe 7d be 8d    	add    %esp,-0x72418202(%ecx)
    821e:	82                   	(bad)  
    821f:	89 c2                	mov    %eax,%edx
    8221:	e8 8b 01 be 1a       	call   1abe83b1 <_end+0x1abdefc9>
    8226:	83 e8 72             	sub    $0x72,%eax
    8229:	01 5a b4             	add    %ebx,-0x4c(%edx)
    822c:	08 cd                	or     %cl,%ch
    822e:	13 72 3a             	adc    0x3a(%edx),%esi
    8231:	50                   	push   %eax
    8232:	53                   	push   %ebx
    8233:	51                   	push   %ecx
    8234:	be ab 82 e8 75       	mov    $0x75e882ab,%esi
    8239:	01 59 89             	add    %ebx,-0x77(%ecx)
    823c:	ca be a1             	lret   $0xa1be
    823f:	82                   	(bad)  
    8240:	e8 6c 01 5b 89       	call   895b83b1 <_end+0x895aefc9>
    8245:	da be 97 82 e8 63    	fidivrl 0x63e88297(%esi)
    824b:	01 58 89             	add    %ebx,-0x77(%eax)
    824e:	c2 be 8d             	ret    $0x8dbe
    8251:	82                   	(bad)  
    8252:	e8 5a 01 0e 5a       	call   5a0e83b1 <_end+0x5a0defc9>
    8257:	be 80 82 e8 52       	mov    $0x52e88280,%esi
    825c:	01 e8                	add    %ebp,%eax
    825e:	02 00                	add    (%eax),%al
    8260:	eb 0f                	jmp    8271 <finish>

00008262 <other>:
    8262:	5a                   	pop    %edx
    8263:	52                   	push   %edx
    8264:	be 73 82 e8 45       	mov    $0x45e88273,%esi
    8269:	01 c3                	add    %eax,%ebx

0000826b <error>:
    826b:	be 64 83 e8 2b       	mov    $0x2be88364,%esi
    8270:	01 eb                	add    %ebp,%ebx

00008271 <finish>:
    8271:	eb fe                	jmp    8271 <finish>

00008273 <ipmsg>:
    8273:	0a 0d 6e 6f 77 20    	or     0x20776f6e,%cl
    8279:	69 70 20 69 73 20 00 	imul   $0x207369,0x20(%eax),%esi

00008280 <csmsg>:
    8280:	0a 0d 6e 6f 77 20    	or     0x20776f6e,%cl
    8286:	63 73 20             	arpl   %si,0x20(%ebx)
    8289:	69 73 20 00 0a 0d 20 	imul   $0x200d0a00,0x20(%ebx),%esi

0000828d <axmsg>:
    828d:	0a 0d 20 61 78 3d    	or     0x3d786120,%cl
    8293:	30 62 20             	xor    %ah,0x20(%edx)
	...

00008297 <bxmsg>:
    8297:	0a 0d 20 62 78 3d    	or     0x3d786220,%cl
    829d:	30 62 20             	xor    %ah,0x20(%edx)
	...

000082a1 <cxmsg>:
    82a1:	0a 0d 20 63 78 3d    	or     0x3d786320,%cl
    82a7:	30 62 20             	xor    %ah,0x20(%edx)
	...

000082ab <dxmsg>:
    82ab:	0a 0d 20 64 78 3d    	or     0x3d786420,%cl
    82b1:	30 62 20             	xor    %ah,0x20(%edx)
	...

000082b5 <msg>:
    82b5:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    82ba:	79 20                	jns    82dc <msg+0x27>
    82bc:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    82c0:	65                   	gs
    82c1:	6c                   	insb   (%dx),%es:(%edi)
    82c2:	20 69 73             	and    %ch,0x73(%ecx)
    82c5:	20 72 75             	and    %dh,0x75(%edx)
    82c8:	6e                   	outsb  %ds:(%esi),(%dx)
    82c9:	6e                   	outsb  %ds:(%esi),(%dx)
    82ca:	69 6e 67 20 74 68 69 	imul   $0x69687420,0x67(%esi),%ebp
    82d1:	73 20                	jae    82f3 <msg+0x3e>
    82d3:	69 73 20 6d 79 20 62 	imul   $0x6220796d,0x20(%ebx),%esi
    82da:	6f                   	outsl  %ds:(%esi),(%dx)
    82db:	6f                   	outsl  %ds:(%esi),(%dx)
    82dc:	74 6c                	je     834a <udiskmsg+0x30>
    82de:	6f                   	outsl  %ds:(%esi),(%dx)
    82df:	61                   	popa   
    82e0:	64                   	fs
    82e1:	65                   	gs
    82e2:	72 0d                	jb     82f1 <msg+0x3c>
    82e4:	0a 6a 75             	or     0x75(%edx),%ch
    82e7:	73 74                	jae    835d <udiskmsg+0x43>
    82e9:	20 75 73             	and    %dh,0x73(%ebp)
    82ec:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    82f1:	64 69 73 70 6c 61 79 	imul   $0x2079616c,%fs:0x70(%ebx),%esi
    82f8:	20 
    82f9:	72 65                	jb     8360 <udiskmsg+0x46>
    82fb:	67 69 73 74 65 72 73 	imul   $0x2c737265,0x74(%bp,%di),%esi
    8302:	2c 
    8303:	6c                   	insb   (%dx),%es:(%edi)
    8304:	69 6b 65 2c 61 78 2c 	imul   $0x2c78612c,0x65(%ebx),%ebp
    830b:	64                   	fs
    830c:	78 2c                	js     833a <udiskmsg+0x20>
    830e:	63 78 20             	arpl   %di,0x20(%eax)
    8311:	64                   	fs
    8312:	78 20                	js     8334 <udiskmsg+0x1a>
    8314:	65                   	gs
    8315:	74 63                	je     837a <try+0x16>
    8317:	0a 0d 00 0a 0d 20    	or     0x200d0a00,%cl

0000831a <udiskmsg>:
    831a:	0a 0d 20 67 65 74    	or     0x74656720,%cl
    8320:	20 69 6e             	and    %ch,0x6e(%ecx)
    8323:	66 6f                	outsw  %ds:(%esi),(%dx)
    8325:	72 6d                	jb     8394 <try+0x30>
    8327:	61                   	popa   
    8328:	74 69                	je     8393 <try+0x2f>
    832a:	6f                   	outsl  %ds:(%esi),(%dx)
    832b:	6e                   	outsb  %ds:(%esi),(%dx)
    832c:	20 61 62             	and    %ah,0x62(%ecx)
    832f:	6f                   	outsl  %ds:(%esi),(%dx)
    8330:	75 74                	jne    83a6 <puts+0xa>
    8332:	20 75 73             	and    %dh,0x73(%ebp)
    8335:	62 20                	bound  %esp,(%eax)
    8337:	64 69 73 6b 3a 0a 0d 	imul   $0x200d0a3a,%fs:0x6b(%ebx),%esi
    833e:	20 
    833f:	41                   	inc    %ecx
    8340:	58                   	pop    %eax
    8341:	20 6e 6f             	and    %ch,0x6f(%esi)
    8344:	20 63 61             	and    %ah,0x61(%ebx)
    8347:	72 65                	jb     83ae <over>
    8349:	2c 42                	sub    $0x42,%al
    834b:	4c                   	dec    %esp
    834c:	20 2c 43             	and    %ch,(%ebx,%eax,2)
    834f:	48                   	dec    %eax
    8350:	20 2c 43             	and    %ch,(%ebx,%eax,2)
    8353:	4c                   	dec    %esp
    8354:	20 44 48 2c          	and    %al,0x2c(%eax,%ecx,2)
    8358:	44                   	inc    %esp
    8359:	4c                   	dec    %esp
    835a:	20 63 72             	and    %ah,0x72(%ebx)
    835d:	69 74 69 63 61 6c 00 	imul   $0xa006c61,0x63(%ecx,%ebp,2),%esi
    8364:	0a 

00008364 <try>:
    8364:	0a 0d 20 72 65 61    	or     0x61657220,%cl
    836a:	64 20 75 73          	and    %dh,%fs:0x73(%ebp)
    836e:	62 20                	bound  %esp,(%eax)
    8370:	64 69 73 6b 20 70 61 	imul   $0x72617020,%fs:0x6b(%ebx),%esi
    8377:	72 
    8378:	61                   	popa   
    8379:	6d                   	insl   (%dx),%es:(%edi)
    837a:	65                   	gs
    837b:	74 65                	je     83e2 <dispbit+0xb>
    837d:	72 73                	jb     83f2 <dispbit+0x1b>
    837f:	20 66 61             	and    %ah,0x61(%esi)
    8382:	69 6c 65 64 2c 72 65 	imul   $0x6265722c,0x64(%ebp,%eiz,2),%ebp
    8389:	62 
    838a:	6f                   	outsl  %ds:(%esi),(%dx)
    838b:	6f                   	outsl  %ds:(%esi),(%dx)
    838c:	74 20                	je     83ae <over>
    838e:	79 6f                	jns    83ff <dispbit+0x28>
    8390:	75 20                	jne    83b2 <dispreg16+0x3>
    8392:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    8395:	70 75                	jo     840c <dispbit+0x35>
    8397:	74 65                	je     83fe <dispbit+0x27>
    8399:	72 20                	jb     83bb <bit+0x7>
	...

0000839c <puts>:
    839c:	8a 04 83             	mov    (%ebx,%eax,4),%al
    839f:	c6 01 3c             	movb   $0x3c,(%ecx)
    83a2:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    83a6:	0e                   	push   %cs
    83a7:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    83ac:	eb ee                	jmp    839c <puts>

000083ae <over>:
    83ae:	c3                   	ret    

000083af <dispreg16>:
    83af:	e8 ea ff b1 10       	call   10b2839e <_end+0x10b1efb6>

000083b4 <bit>:
    83b4:	51                   	push   %ecx
    83b5:	52                   	push   %edx
    83b6:	80 e9 01             	sub    $0x1,%cl
    83b9:	d3 ea                	shr    %cl,%edx
    83bb:	e8 19 00 80 f9       	call   f98083d9 <_end+0xf97feff1>
    83c0:	08 75 09             	or     %dh,0x9(%ebp)
    83c3:	b0 20                	mov    $0x20,%al
    83c5:	b4 0e                	mov    $0xe,%ah
    83c7:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx

000083cc <skipblank>:
    83cc:	5a                   	pop    %edx
    83cd:	59                   	pop    %ecx
    83ce:	80 e9 01             	sub    $0x1,%cl
    83d1:	80 f9 00             	cmp    $0x0,%cl
    83d4:	75 de                	jne    83b4 <bit>
    83d6:	c3                   	ret    

000083d7 <dispbit>:
    83d7:	31 c0                	xor    %eax,%eax
    83d9:	89 d0                	mov    %edx,%eax
    83db:	24 01                	and    $0x1,%al
    83dd:	04 30                	add    $0x30,%al
    83df:	b4 0e                	mov    $0xe,%ah
    83e1:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    83e6:	c3                   	ret    
