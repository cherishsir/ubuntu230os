
head.elf:     file format elf32-i386


Disassembly of section .text:

0000c400 <start>:
    c400:	31 c0                	xor    %eax,%eax
    c402:	31 c9                	xor    %ecx,%ecx
    c404:	b8 00 00 8e d8       	mov    $0xd88e0000,%eax
    c409:	be b4 c4 e8 77       	mov    $0x77e8c4b4,%esi
    c40e:	01 be aa c4 e8 84    	add    %edi,-0x7b173b56(%esi)
    c414:	01 a1 fe 7d be 8c    	add    %esp,-0x73418202(%ecx)
    c41a:	c4 89 c2 e8 79 01    	les    0x179e8c2(%ecx),%ecx
    c420:	be 04 c5 e8 60       	mov    $0x60e8c504,%esi
    c425:	01 8a 16 fe 7d b4    	add    %ecx,-0x4b8201ea(%edx)
    c42b:	08 cd                	or     %cl,%ch
    c42d:	13 72 3a             	adc    0x3a(%edx),%esi
    c430:	50                   	push   %eax
    c431:	53                   	push   %ebx
    c432:	51                   	push   %ecx
    c433:	be aa c4 e8 60       	mov    $0x60e8c4aa,%esi
    c438:	01 59 89             	add    %ebx,-0x77(%ecx)
    c43b:	ca be a0             	lret   $0xa0be
    c43e:	c4                   	(bad)  
    c43f:	e8 57 01 5b 89       	call   895bc59b <_end+0x895aefc7>
    c444:	da be 96 c4 e8 4e    	fidivrl 0x4ee8c496(%esi)
    c44a:	01 58 89             	add    %ebx,-0x77(%eax)
    c44d:	c2 be 8c             	ret    $0x8cbe
    c450:	c4                   	(bad)  
    c451:	e8 45 01 0e 5a       	call   5a0ec59b <_end+0x5a0defc7>
    c456:	be 7f c4 e8 3d       	mov    $0x3de8c47f,%esi
    c45b:	01 e8                	add    %ebp,%eax
    c45d:	02 00                	add    (%eax),%al
    c45f:	eb 0f                	jmp    c470 <finish>

0000c461 <other>:
    c461:	5a                   	pop    %edx
    c462:	52                   	push   %edx
    c463:	be 72 c4 e8 30       	mov    $0x30e8c472,%esi
    c468:	01 c3                	add    %eax,%ebx

0000c46a <error>:
    c46a:	be 4e c5 e8 16       	mov    $0x16e8c54e,%esi
    c46f:	01 eb                	add    %ebp,%ebx

0000c470 <finish>:
    c470:	eb fe                	jmp    c470 <finish>

0000c472 <ipmsg>:
    c472:	0a 0d 6e 6f 77 20    	or     0x20776f6e,%cl
    c478:	69 70 20 69 73 20 00 	imul   $0x207369,0x20(%eax),%esi

0000c47f <csmsg>:
    c47f:	0a 0d 6e 6f 77 20    	or     0x20776f6e,%cl
    c485:	63 73 20             	arpl   %si,0x20(%ebx)
    c488:	69 73 20 00 0a 0d 20 	imul   $0x200d0a00,0x20(%ebx),%esi

0000c48c <axmsg>:
    c48c:	0a 0d 20 61 78 3d    	or     0x3d786120,%cl
    c492:	30 62 20             	xor    %ah,0x20(%edx)
	...

0000c496 <bxmsg>:
    c496:	0a 0d 20 62 78 3d    	or     0x3d786220,%cl
    c49c:	30 62 20             	xor    %ah,0x20(%edx)
	...

0000c4a0 <cxmsg>:
    c4a0:	0a 0d 20 63 78 3d    	or     0x3d786320,%cl
    c4a6:	30 62 20             	xor    %ah,0x20(%edx)
	...

0000c4aa <dxmsg>:
    c4aa:	0a 0d 20 64 78 3d    	or     0x3d786420,%cl
    c4b0:	30 62 20             	xor    %ah,0x20(%edx)
	...

0000c4b4 <msg>:
    c4b4:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    c4b9:	79 20                	jns    c4db <msg+0x27>
    c4bb:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    c4bf:	65                   	gs
    c4c0:	6c                   	insb   (%dx),%es:(%edi)
    c4c1:	20 69 73             	and    %ch,0x73(%ecx)
    c4c4:	20 72 75             	and    %dh,0x75(%edx)
    c4c7:	6e                   	outsb  %ds:(%esi),(%dx)
    c4c8:	6e                   	outsb  %ds:(%esi),(%dx)
    c4c9:	69 6e 67 20 0d 0a 6a 	imul   $0x6a0a0d20,0x67(%esi),%ebp
    c4d0:	75 73                	jne    c545 <udiskmsg+0x41>
    c4d2:	74 20                	je     c4f4 <msg+0x40>
    c4d4:	75 73                	jne    c549 <udiskmsg+0x45>
    c4d6:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    c4db:	64 69 73 70 6c 61 79 	imul   $0x2079616c,%fs:0x70(%ebx),%esi
    c4e2:	20 
    c4e3:	72 65                	jb     c54a <udiskmsg+0x46>
    c4e5:	67 69 73 74 65 72 73 	imul   $0x2c737265,0x74(%bp,%di),%esi
    c4ec:	2c 
    c4ed:	6c                   	insb   (%dx),%es:(%edi)
    c4ee:	69 6b 65 2c 61 78 2c 	imul   $0x2c78612c,0x65(%ebx),%ebp
    c4f5:	64                   	fs
    c4f6:	78 2c                	js     c524 <udiskmsg+0x20>
    c4f8:	63 78 20             	arpl   %di,0x20(%eax)
    c4fb:	64                   	fs
    c4fc:	78 20                	js     c51e <udiskmsg+0x1a>
    c4fe:	65                   	gs
    c4ff:	74 63                	je     c564 <try+0x16>
    c501:	0a 0d 00 0a 0d 20    	or     0x200d0a00,%cl

0000c504 <udiskmsg>:
    c504:	0a 0d 20 67 65 74    	or     0x74656720,%cl
    c50a:	20 69 6e             	and    %ch,0x6e(%ecx)
    c50d:	66 6f                	outsw  %ds:(%esi),(%dx)
    c50f:	72 6d                	jb     c57e <try+0x30>
    c511:	61                   	popa   
    c512:	74 69                	je     c57d <try+0x2f>
    c514:	6f                   	outsl  %ds:(%esi),(%dx)
    c515:	6e                   	outsb  %ds:(%esi),(%dx)
    c516:	20 61 62             	and    %ah,0x62(%ecx)
    c519:	6f                   	outsl  %ds:(%esi),(%dx)
    c51a:	75 74                	jne    c590 <puts+0xa>
    c51c:	20 75 73             	and    %dh,0x73(%ebp)
    c51f:	62 20                	bound  %esp,(%eax)
    c521:	64 69 73 6b 3a 0a 0d 	imul   $0x200d0a3a,%fs:0x6b(%ebx),%esi
    c528:	20 
    c529:	41                   	inc    %ecx
    c52a:	58                   	pop    %eax
    c52b:	20 6e 6f             	and    %ch,0x6f(%esi)
    c52e:	20 63 61             	and    %ah,0x61(%ebx)
    c531:	72 65                	jb     c598 <over>
    c533:	2c 42                	sub    $0x42,%al
    c535:	4c                   	dec    %esp
    c536:	20 2c 43             	and    %ch,(%ebx,%eax,2)
    c539:	48                   	dec    %eax
    c53a:	20 2c 43             	and    %ch,(%ebx,%eax,2)
    c53d:	4c                   	dec    %esp
    c53e:	20 44 48 2c          	and    %al,0x2c(%eax,%ecx,2)
    c542:	44                   	inc    %esp
    c543:	4c                   	dec    %esp
    c544:	20 63 72             	and    %ah,0x72(%ebx)
    c547:	69 74 69 63 61 6c 00 	imul   $0xa006c61,0x63(%ecx,%ebp,2),%esi
    c54e:	0a 

0000c54e <try>:
    c54e:	0a 0d 20 72 65 61    	or     0x61657220,%cl
    c554:	64 20 75 73          	and    %dh,%fs:0x73(%ebp)
    c558:	62 20                	bound  %esp,(%eax)
    c55a:	64 69 73 6b 20 70 61 	imul   $0x72617020,%fs:0x6b(%ebx),%esi
    c561:	72 
    c562:	61                   	popa   
    c563:	6d                   	insl   (%dx),%es:(%edi)
    c564:	65                   	gs
    c565:	74 65                	je     c5cc <dispbit+0xb>
    c567:	72 73                	jb     c5dc <dispbit+0x1b>
    c569:	20 66 61             	and    %ah,0x61(%esi)
    c56c:	69 6c 65 64 2c 72 65 	imul   $0x6265722c,0x64(%ebp,%eiz,2),%ebp
    c573:	62 
    c574:	6f                   	outsl  %ds:(%esi),(%dx)
    c575:	6f                   	outsl  %ds:(%esi),(%dx)
    c576:	74 20                	je     c598 <over>
    c578:	79 6f                	jns    c5e9 <dispbit+0x28>
    c57a:	75 20                	jne    c59c <dispreg16+0x3>
    c57c:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    c57f:	70 75                	jo     c5f6 <dispbit+0x35>
    c581:	74 65                	je     c5e8 <dispbit+0x27>
    c583:	72 20                	jb     c5a5 <bit+0x7>
	...

0000c586 <puts>:
    c586:	8a 04 83             	mov    (%ebx,%eax,4),%al
    c589:	c6 01 3c             	movb   $0x3c,(%ecx)
    c58c:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    c590:	0e                   	push   %cs
    c591:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    c596:	eb ee                	jmp    c586 <puts>

0000c598 <over>:
    c598:	c3                   	ret    

0000c599 <dispreg16>:
    c599:	e8 ea ff b1 10       	call   10b2c588 <_end+0x10b1efb4>

0000c59e <bit>:
    c59e:	51                   	push   %ecx
    c59f:	52                   	push   %edx
    c5a0:	80 e9 01             	sub    $0x1,%cl
    c5a3:	d3 ea                	shr    %cl,%edx
    c5a5:	e8 19 00 80 f9       	call   f980c5c3 <_end+0xf97fefef>
    c5aa:	08 75 09             	or     %dh,0x9(%ebp)
    c5ad:	b0 20                	mov    $0x20,%al
    c5af:	b4 0e                	mov    $0xe,%ah
    c5b1:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx

0000c5b6 <skipblank>:
    c5b6:	5a                   	pop    %edx
    c5b7:	59                   	pop    %ecx
    c5b8:	80 e9 01             	sub    $0x1,%cl
    c5bb:	80 f9 00             	cmp    $0x0,%cl
    c5be:	75 de                	jne    c59e <bit>
    c5c0:	c3                   	ret    

0000c5c1 <dispbit>:
    c5c1:	31 c0                	xor    %eax,%eax
    c5c3:	89 d0                	mov    %edx,%eax
    c5c5:	24 01                	and    $0x1,%al
    c5c7:	04 30                	add    $0x30,%al
    c5c9:	b4 0e                	mov    $0xe,%ah
    c5cb:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    c5d0:	c3                   	ret    
