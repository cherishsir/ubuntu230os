
head.elf:     file format elf32-i386


Disassembly of section .text:

0000c400 <start>:
    c400:	eb 4c                	jmp    c44e <entry>

0000c402 <msg>:
    c402:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    c407:	79 20                	jns    c429 <imsg+0xb>
    c409:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    c40d:	65                   	gs
    c40e:	6c                   	insb   (%dx),%es:(%edi)
    c40f:	20 69 73             	and    %ch,0x73(%ecx)
    c412:	20 72 75             	and    %dh,0x75(%edx)
    c415:	6e                   	outsb  %ds:(%esi),(%dx)
    c416:	6e                   	outsb  %ds:(%esi),(%dx)
    c417:	69 6e 67 20 0d 0a 00 	imul   $0xa0d20,0x67(%esi),%ebp

0000c41e <imsg>:
    c41e:	0d 0a 0a 0d 68       	or     $0x680d0a0a,%eax
    c423:	69 2c 61 6e 6f 74 68 	imul   $0x68746f6e,(%ecx,%eiz,2),%ebp
    c42a:	65                   	gs
    c42b:	72 20                	jb     c44d <over>
    c42d:	76 69                	jbe    c498 <seta20.1+0x1>
    c42f:	64 65 6f             	fs outsl %fs:%gs:(%esi),(%dx)
    c432:	20 6d 6f             	and    %ch,0x6f(%ebp)
    c435:	64 65 20 0d 0a 00 8a 	fs and %cl,%fs:%gs:0x48a000a
    c43c:	04 

0000c43b <puts>:
    c43b:	8a 04 83             	mov    (%ebx,%eax,4),%al
    c43e:	c6 01 3c             	movb   $0x3c,(%ecx)
    c441:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    c445:	0e                   	push   %cs
    c446:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    c44b:	eb ee                	jmp    c43b <puts>

0000c44d <over>:
    c44d:	c3                   	ret    

0000c44e <entry>:
    c44e:	b8 00 00 8e d8       	mov    $0xd88e0000,%eax
    c453:	8e c0                	mov    %eax,%es
    c455:	8e d0                	mov    %eax,%ss
    c457:	be 02 c4 e8 de       	mov    $0xdee8c402,%esi
    c45c:	ff b0 13 b4 00 cd    	pushl  -0x32ff4bed(%eax)
    c462:	10 be 1e c4 e8 d2    	adc    %bh,-0x2d173be2(%esi)
    c468:	ff b4 02 cd 16 a2 f1 	pushl  -0xe5de933(%edx,%eax,1)
    c46f:	0f c6 06 f0          	shufps $0xf0,(%esi),%xmm0
    c473:	0f 0a                	(bad)  
    c475:	c6 06 f2             	movb   $0xf2,(%esi)
    c478:	0f 08                	invd   
    c47a:	c7 06 f4 0f 40 01    	movl   $0x1400ff4,(%esi)
    c480:	c7 06 f6 0f c8 00    	movl   $0xc80ff6,(%esi)
    c486:	66 c7 06 f8 0f       	movw   $0xff8,(%esi)
    c48b:	00 00                	add    %al,(%eax)
    c48d:	0a 00                	or     (%eax),%al
    c48f:	b0 ff                	mov    $0xff,%al
    c491:	e6 21                	out    %al,$0x21
    c493:	90                   	nop
    c494:	e6 a1                	out    %al,$0xa1
    c496:	fa                   	cli    

0000c497 <seta20.1>:
    c497:	e4 64                	in     $0x64,%al
    c499:	a8 02                	test   $0x2,%al
    c49b:	75 fa                	jne    c497 <seta20.1>
    c49d:	b0 d1                	mov    $0xd1,%al
    c49f:	e6 64                	out    %al,$0x64

0000c4a1 <seta20.2>:
    c4a1:	e4 64                	in     $0x64,%al
    c4a3:	a8 02                	test   $0x2,%al
    c4a5:	75 fa                	jne    c4a1 <seta20.2>
    c4a7:	b0 df                	mov    $0xdf,%al
    c4a9:	e6 60                	out    %al,$0x60
    c4ab:	0f 01 16             	lgdtl  (%esi)
    c4ae:	49                   	dec    %ecx
    c4af:	c5 0f                	lds    (%edi),%ecx
    c4b1:	20 c0                	and    %al,%al
    c4b3:	66 25 ff ff          	and    $0xffff,%ax
    c4b7:	ff                   	(bad)  
    c4b8:	7f 66                	jg     c520 <memcpy+0x9>
    c4ba:	83 c8 01             	or     $0x1,%eax
    c4bd:	0f 22 c0             	mov    %eax,%cr0
    c4c0:	ea c5 c4 10 00 66 b8 	ljmp   $0xb866,$0x10c4c5

0000c4c5 <protcseg>:
    c4c5:	66 b8 08 00          	mov    $0x8,%ax
    c4c9:	8e d8                	mov    %eax,%ds
    c4cb:	8e c0                	mov    %eax,%es
    c4cd:	8e e0                	mov    %eax,%fs
    c4cf:	8e e8                	mov    %eax,%gs
    c4d1:	8e d0                	mov    %eax,%ss
    c4d3:	bc 00 c4 00 00       	mov    $0xc400,%esp
    c4d8:	be 00 80 00 00       	mov    $0x8000,%esi
    c4dd:	bf 00 00 10 00       	mov    $0x100000,%edi
    c4e2:	b9 00 00 00 00       	mov    $0x0,%ecx
    c4e7:	b1 06                	mov    $0x6,%cl
    c4e9:	69 c9 80 1f 00 00    	imul   $0x1f80,%ecx,%ecx
    c4ef:	81 e9 80 00 00 00    	sub    $0x80,%ecx
    c4f5:	e8 1d 00 00 00       	call   c517 <memcpy>
    c4fa:	be 4f c5 00 00       	mov    $0xc54f,%esi
    c4ff:	bf 00 00 28 00       	mov    $0x280000,%edi
    c504:	b9 00 00 02 00       	mov    $0x20000,%ecx
    c509:	e8 09 00 00 00       	call   c517 <memcpy>
    c50e:	ea 00 00 00 00 18 00 	ljmp   $0x18,$0x0
    c515:	eb fe                	jmp    c515 <protcseg+0x50>

0000c517 <memcpy>:
    c517:	8b 06                	mov    (%esi),%eax
    c519:	83 c6 04             	add    $0x4,%esi
    c51c:	89 07                	mov    %eax,(%edi)
    c51e:	83 c7 04             	add    $0x4,%edi
    c521:	83 e9 01             	sub    $0x1,%ecx
    c524:	75 f1                	jne    c517 <memcpy>
    c526:	c3                   	ret    

0000c527 <gdt>:
	...
    c52f:	ff                   	(bad)  
    c530:	ff 00                	incl   (%eax)
    c532:	00 00                	add    %al,(%eax)
    c534:	92                   	xchg   %eax,%edx
    c535:	cf                   	iret   
    c536:	00 ff                	add    %bh,%bh
    c538:	ff 00                	incl   (%eax)
    c53a:	00 00                	add    %al,(%eax)
    c53c:	9a 47 00 ff ff 00 00 	lcall  $0x0,$0xffff0047
    c543:	28 9a 47 00 00 00    	sub    %bl,0x47(%edx)

0000c549 <gdtdesc>:
    c549:	1f                   	pop    %ds
    c54a:	00 27                	add    %ah,(%edi)
    c54c:	c5 00                	lds    (%eax),%eax
	...
