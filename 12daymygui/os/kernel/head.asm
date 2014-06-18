
head.out:     file format elf32-i386


Disassembly of section .text:

0000c400 <entry>:

.globl entry
entry:
  .code16                     # Assemble for 16-bit mode

  jmp start
    c400:	eb 40                	jmp    c442 <start>

0000c402 <msg>:
    c402:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    c407:	79 20                	jns    c429 <try+0xb>
    c409:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    c40d:	65                   	gs
    c40e:	6c                   	insb   (%dx),%es:(%edi)
    c40f:	20 69 73             	and    %ch,0x73(%ecx)
    c412:	20 72 75             	and    %dh,0x75(%edx)
    c415:	6e                   	outsb  %ds:(%esi),(%dx)
    c416:	69 6e 67 20 6a 6f 73 	imul   $0x736f6a20,0x67(%esi),%ebp
	...

0000c41e <try>:
    c41e:	0d 0a 0a 0d 74       	or     $0x740d0a0a,%eax
    c423:	72 79                	jb     c49e <seta20.2+0x10>
    c425:	20 69 74             	and    %ch,0x74(%ecx)
    c428:	20 61 67             	and    %ah,0x67(%ecx)
    c42b:	61                   	popa   
    c42c:	69 6e 00 8a 04 83 c6 	imul   $0xc683048a,0x0(%esi),%ebp

0000c42f <puts>:
 try:
  .asciz "\r\n\n\rtry it again"

puts:

	movb (%si),%al
    c42f:	8a 04 83             	mov    (%ebx,%eax,4),%al
	add $1,%si
    c432:	c6 01 3c             	movb   $0x3c,(%ecx)
	cmp $0,%al
    c435:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
	je over
	movb $0x0e,%ah
    c439:	0e                   	push   %cs
	movw $15,%bx
    c43a:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
	int $0x10
	jmp puts
    c43f:	eb ee                	jmp    c42f <puts>

0000c441 <over>:
over:
	ret
    c441:	c3                   	ret    

0000c442 <start>:
start:
 # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    c442:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    c444:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    c446:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    c448:	8e d0                	mov    %eax,%ss

#################### # 利用中断int 0x10来改变显示模式
  movb $0x13,%al  # ;vga 320x200x8 位,color mode
    c44a:	b0 13                	mov    $0x13,%al
  movb $0x00,%ah
    c44c:	b4 00                	mov    $0x0,%ah
   int $0x10
    c44e:	cd 10                	int    $0x10
#save color mode in ram 0x0ff0
 movb  $10,(CYLS)
    c450:	c6 06 f0             	movb   $0xf0,(%esi)
    c453:	0f 0a                	(bad)  
 movb $8,(VMODE)
    c455:	c6 06 f2             	movb   $0xf2,(%esi)
    c458:	0f 08                	invd   
 movw $320,(SCRNX)
    c45a:	c7 06 f4 0f 40 01    	movl   $0x1400ff4,(%esi)
 movw $200,(SCRNY)
    c460:	c7 06 f6 0f c8 00    	movl   $0xc80ff6,(%esi)
 movl $0x000a0000,(VRAM)
    c466:	66 c7 06 f8 0f       	movw   $0xff8,(%esi)
    c46b:	00 00                	add    %al,(%eax)
    c46d:	0a 00                	or     (%eax),%al

 #get keyboard led status
 movb	$0x02,%ah
    c46f:	b4 02                	mov    $0x2,%ah
 int     $0x16			#keyboard interrupts
    c471:	cd 16                	int    $0x16
 movb   %al,(LEDS)
    c473:	a2 f1 0f be 02       	mov    %al,0x2be0ff1
#diplay "my kernel is runing jos"
  movw $msg,%si
    c478:	c4                   	(bad)  
  call puts
    c479:	e8 b3 ff b0 ff       	call   ffb1c431 <__bss_start+0xffb0fedd>


#对port 0x21 0xa1写1 关闭一切的中断，这样才能对中断进行设置
#从16位模式转换成32位模式之前，一定要把中断源关闭，避免模式转换过程中发生中断
  movb $0xff,%al
  outb %al, $0x21 #format  outb data port
    c47e:	e6 21                	out    %al,$0x21
  nop
    c480:	90                   	nop
  out %al, $0xa1
    c481:	e6 a1                	out    %al,$0xa1
   cli                         # Disable interrupts
    c483:	fa                   	cli    

0000c484 <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is closed , so that addresses higher than
  #   1MB wrap around to zero by default. open A20.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    c484:	e4 64                	in     $0x64,%al
  testb   $0x2,%al   #if 1 :busy ,if 0:idle
    c486:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    c488:	75 fa                	jne    c484 <seta20.1>
#对port 0x64  写0xd1
  movb    $0xd1,%al               # 0xd1 -> port 0x64
    c48a:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    c48c:	e6 64                	out    %al,$0x64

0000c48e <seta20.2>:
seta20.2:
  inb     $0x64,%al               # Wait for not busy
    c48e:	e4 64                	in     $0x64,%al
  testb   $02,%al
    c490:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    c492:	75 fa                	jne    c48e <seta20.2>
#对port 0x60 写0xdf
  movb    $0xdf,%al               # 0xdf -> port 0x60
    c494:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    c496:	e6 60                	out    %al,$0x60
  /*my kerenl is running*/
 // movw $msg,%si
//  call puts

  #jmp .
  lgdt     gdtdesc
    c498:	0f 01 16             	lgdtl  (%esi)
    c49b:	4e                   	dec    %esi
    c49c:	c5 0f                	lds    (%edi),%ecx
  movl     %cr0, %eax
    c49e:	20 c0                	and    %al,%al
  andl     $0x7fffffff,%eax
    c4a0:	66 25 ff ff          	and    $0xffff,%ax
    c4a4:	ff                   	(bad)  
    c4a5:	7f 66                	jg     c50d <all+0x20>
  orl      $CR0_PE_ON, %eax  #CR0_PE_ON=0x1
    c4a7:	83 c8 01             	or     $0x1,%eax

  /*这一步真正的cpu开始成了32位模式*/
  movl     %eax, %cr0
    c4aa:	0f 22 c0             	mov    %eax,%cr0
  # Switches processor into 32-bit mode.  这一个跳转的意义重大
  /*选择子为2，跳转指令进行跳转，跳转到哪？看下面：
  选择子2的基地址是：0x0000
  offset偏移地址是：protecseg代表的地址，所以会跳转到32位的代码处
  */
  ljmp    $(2*8), $protcseg   #PROT_MODE_CSEG=0x8 #32位的跳转指令。 ljmp selector ,offset
    c4ad:	ea b2 c4 10 00 66 b8 	ljmp   $0xb866,$0x10c4b2

0000c4b2 <protcseg>:
#正式进入32位的保护模式。
  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
 # movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
  movw    $(1*8) , %ax
    c4b2:	66 b8 08 00          	mov    $0x8,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    c4b6:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    c4b8:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    c4ba:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    c4bc:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    c4be:	8e d0                	mov    %eax,%ss

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    c4c0:	bc 42 c4 00 00       	mov    $0xc442,%esp

0000c4c5 <ccode>:
ccode:
  #把c代码部分复制到memory0x280000处的地址  ，复制了512kB的c代码，所以c代码不能超过这个大小
  #memcopy(bootmain,BOTPAK,size=512*1024/4);#BOTPAK =0X00280000
  #main标号后面放的是c程序，我是用cat cobj>>entry的方法实现的。

  movl $main, %esi
    c4c5:	be 54 c5 00 00       	mov    $0xc554,%esi
  movl $0X00280000  , %edi
    c4ca:	bf 00 00 28 00       	mov    $0x280000,%edi
  movl $(512*1024/4),%ecx
    c4cf:	b9 00 00 02 00       	mov    $0x20000,%ecx
  call memcpy
    c4d4:	e8 41 00 00 00       	call   c51a <memcpy>

0000c4d9 <bootsector>:
  #ljmp   $(2*8),$0x0000
bootsector:
 #把bootsector的内容复制到 0x100000的位置
  movl $0x7c00, %esi
    c4d9:	be 00 7c 00 00       	mov    $0x7c00,%esi
  movl $0x00100000 , %edi  # DSKCAC=0x00100000 把bootsector的内容复制到0x100000地址处
    c4de:	bf 00 00 10 00       	mov    $0x100000,%edi
  movl $(512/4),%ecx
    c4e3:	b9 80 00 00 00       	mov    $0x80,%ecx
  call memcpy
    c4e8:	e8 2d 00 00 00       	call   c51a <memcpy>

0000c4ed <all>:
all:
#把整个软盘上的内容复制到 0x100000内存地址处
  movl $(DSKCAC0+512), %esi
    c4ed:	be 00 82 00 00       	mov    $0x8200,%esi
  movl $(DSKCAC+512) , %edi
    c4f2:	bf 00 02 10 00       	mov    $0x100200,%edi
  movl $0,%ecx
    c4f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  movb (CYLS),%cl
    c4fc:	8a 0d f0 0f 00 00    	mov    0xff0,%cl
  imul $(512*18*2/4) , %ecx
    c502:	69 c9 00 12 00 00    	imul   $0x1200,%ecx,%ecx
  subl  $(512/4),       %ecx
    c508:	81 e9 80 00 00 00    	sub    $0x80,%ecx
  call memcpy
    c50e:	e8 07 00 00 00       	call   c51a <memcpy>
 # call memcpy

#skip:
 # movl 12(%ebx),%esp
 #直接跳转到c语言的地址处，所以c函数在编译时要使用0x280000这个地址。
 ljmp  $(3*8), $0x0000
    c513:	ea 00 00 00 00 18 00 	ljmp   $0x18,$0x0

0000c51a <memcpy>:
 #ljmp  $(1*8), $main

#每次复制4个字节 ，因为这是32位的代码了
memcpy:
  movl  (%esi),%eax
    c51a:	8b 06                	mov    (%esi),%eax
  addl  $4    ,%esi
    c51c:	83 c6 04             	add    $0x4,%esi
  movl  %eax ,(%edi)
    c51f:	89 07                	mov    %eax,(%edi)
  addl   $4    ,%edi
    c521:	83 c7 04             	add    $0x4,%edi
  subl   $1    ,%ecx
    c524:	83 e9 01             	sub    $0x1,%ecx
  jnz    memcpy
    c527:	75 f1                	jne    c51a <memcpy>
  ret
    c529:	c3                   	ret    
    c52a:	66 90                	xchg   %ax,%ax

0000c52c <gdt>:
	...
    c534:	ff                   	(bad)  
    c535:	ff 00                	incl   (%eax)
    c537:	00 00                	add    %al,(%eax)
    c539:	92                   	xchg   %eax,%edx
    c53a:	cf                   	iret   
    c53b:	00 ff                	add    %bh,%bh
    c53d:	ff 00                	incl   (%eax)
    c53f:	00 00                	add    %al,(%eax)
    c541:	9a 47 00 ff ff 00 00 	lcall  $0x0,$0xffff0047
    c548:	28 9a 47 00 00 00    	sub    %bl,0x47(%edx)

0000c54e <gdtdesc>:
    c54e:	1f                   	pop    %ds
    c54f:	00                   	.byte 0x0
    c550:	2c c5                	sub    $0xc5,%al
	...

Disassembly of section .stab:

00000000 <.stab>:
   0:	01 00                	add    %eax,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	00 00                	add    %al,(%eax)
   6:	50                   	push   %eax
   7:	00 19                	add    %bl,(%ecx)
   9:	00 00                	add    %al,(%eax)
   b:	00 01                	add    %al,(%ecx)
   d:	00 00                	add    %al,(%eax)
   f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
  13:	00 00                	add    %al,(%eax)
  15:	c4 00                	les    (%eax),%eax
  17:	00 11                	add    %dl,(%ecx)
  19:	00 00                	add    %al,(%eax)
  1b:	00 84 00 00 00 00 c4 	add    %al,-0x3c000000(%eax,%eax,1)
  22:	00 00                	add    %al,(%eax)
  24:	00 00                	add    %al,(%eax)
  26:	00 00                	add    %al,(%eax)
  28:	44                   	inc    %esp
  29:	00 1a                	add    %bl,(%edx)
  2b:	00 00                	add    %al,(%eax)
  2d:	c4 00                	les    (%eax),%eax
  2f:	00 00                	add    %al,(%eax)
  31:	00 00                	add    %al,(%eax)
  33:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
  37:	00 2f                	add    %ch,(%edi)
  39:	c4 00                	les    (%eax),%eax
  3b:	00 00                	add    %al,(%eax)
  3d:	00 00                	add    %al,(%eax)
  3f:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
  43:	00 31                	add    %dh,(%ecx)
  45:	c4 00                	les    (%eax),%eax
  47:	00 00                	add    %al,(%eax)
  49:	00 00                	add    %al,(%eax)
  4b:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
  4f:	00 34 c4             	add    %dh,(%esp,%eax,8)
  52:	00 00                	add    %al,(%eax)
  54:	00 00                	add    %al,(%eax)
  56:	00 00                	add    %al,(%eax)
  58:	44                   	inc    %esp
  59:	00 27                	add    %ah,(%edi)
  5b:	00 36                	add    %dh,(%esi)
  5d:	c4 00                	les    (%eax),%eax
  5f:	00 00                	add    %al,(%eax)
  61:	00 00                	add    %al,(%eax)
  63:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
  67:	00 38                	add    %bh,(%eax)
  69:	c4 00                	les    (%eax),%eax
  6b:	00 00                	add    %al,(%eax)
  6d:	00 00                	add    %al,(%eax)
  6f:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
  73:	00 3a                	add    %bh,(%edx)
  75:	c4 00                	les    (%eax),%eax
  77:	00 00                	add    %al,(%eax)
  79:	00 00                	add    %al,(%eax)
  7b:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
  7f:	00 3d c4 00 00 00    	add    %bh,0xc4
  85:	00 00                	add    %al,(%eax)
  87:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
  8b:	00 3f                	add    %bh,(%edi)
  8d:	c4 00                	les    (%eax),%eax
  8f:	00 00                	add    %al,(%eax)
  91:	00 00                	add    %al,(%eax)
  93:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
  97:	00 41 c4             	add    %al,-0x3c(%ecx)
  9a:	00 00                	add    %al,(%eax)
  9c:	00 00                	add    %al,(%eax)
  9e:	00 00                	add    %al,(%eax)
  a0:	44                   	inc    %esp
  a1:	00 30                	add    %dh,(%eax)
  a3:	00 42 c4             	add    %al,-0x3c(%edx)
  a6:	00 00                	add    %al,(%eax)
  a8:	00 00                	add    %al,(%eax)
  aa:	00 00                	add    %al,(%eax)
  ac:	44                   	inc    %esp
  ad:	00 31                	add    %dh,(%ecx)
  af:	00 44 c4 00          	add    %al,0x0(%esp,%eax,8)
  b3:	00 00                	add    %al,(%eax)
  b5:	00 00                	add    %al,(%eax)
  b7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
  bb:	00 46 c4             	add    %al,-0x3c(%esi)
  be:	00 00                	add    %al,(%eax)
  c0:	00 00                	add    %al,(%eax)
  c2:	00 00                	add    %al,(%eax)
  c4:	44                   	inc    %esp
  c5:	00 33                	add    %dh,(%ebx)
  c7:	00 48 c4             	add    %cl,-0x3c(%eax)
  ca:	00 00                	add    %al,(%eax)
  cc:	00 00                	add    %al,(%eax)
  ce:	00 00                	add    %al,(%eax)
  d0:	44                   	inc    %esp
  d1:	00 36                	add    %dh,(%esi)
  d3:	00 4a c4             	add    %cl,-0x3c(%edx)
  d6:	00 00                	add    %al,(%eax)
  d8:	00 00                	add    %al,(%eax)
  da:	00 00                	add    %al,(%eax)
  dc:	44                   	inc    %esp
  dd:	00 37                	add    %dh,(%edi)
  df:	00 4c c4 00          	add    %cl,0x0(%esp,%eax,8)
  e3:	00 00                	add    %al,(%eax)
  e5:	00 00                	add    %al,(%eax)
  e7:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
  eb:	00 4e c4             	add    %cl,-0x3c(%esi)
  ee:	00 00                	add    %al,(%eax)
  f0:	00 00                	add    %al,(%eax)
  f2:	00 00                	add    %al,(%eax)
  f4:	44                   	inc    %esp
  f5:	00 3a                	add    %bh,(%edx)
  f7:	00 50 c4             	add    %dl,-0x3c(%eax)
  fa:	00 00                	add    %al,(%eax)
  fc:	00 00                	add    %al,(%eax)
  fe:	00 00                	add    %al,(%eax)
 100:	44                   	inc    %esp
 101:	00 3b                	add    %bh,(%ebx)
 103:	00 55 c4             	add    %dl,-0x3c(%ebp)
 106:	00 00                	add    %al,(%eax)
 108:	00 00                	add    %al,(%eax)
 10a:	00 00                	add    %al,(%eax)
 10c:	44                   	inc    %esp
 10d:	00 3c 00             	add    %bh,(%eax,%eax,1)
 110:	5a                   	pop    %edx
 111:	c4 00                	les    (%eax),%eax
 113:	00 00                	add    %al,(%eax)
 115:	00 00                	add    %al,(%eax)
 117:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
 11b:	00 60 c4             	add    %ah,-0x3c(%eax)
 11e:	00 00                	add    %al,(%eax)
 120:	00 00                	add    %al,(%eax)
 122:	00 00                	add    %al,(%eax)
 124:	44                   	inc    %esp
 125:	00 3e                	add    %bh,(%esi)
 127:	00 66 c4             	add    %ah,-0x3c(%esi)
 12a:	00 00                	add    %al,(%eax)
 12c:	00 00                	add    %al,(%eax)
 12e:	00 00                	add    %al,(%eax)
 130:	44                   	inc    %esp
 131:	00 41 00             	add    %al,0x0(%ecx)
 134:	6f                   	outsl  %ds:(%esi),(%dx)
 135:	c4 00                	les    (%eax),%eax
 137:	00 00                	add    %al,(%eax)
 139:	00 00                	add    %al,(%eax)
 13b:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
 13f:	00 71 c4             	add    %dh,-0x3c(%ecx)
 142:	00 00                	add    %al,(%eax)
 144:	00 00                	add    %al,(%eax)
 146:	00 00                	add    %al,(%eax)
 148:	44                   	inc    %esp
 149:	00 43 00             	add    %al,0x0(%ebx)
 14c:	73 c4                	jae    112 <CR0_PE_ON+0x111>
 14e:	00 00                	add    %al,(%eax)
 150:	00 00                	add    %al,(%eax)
 152:	00 00                	add    %al,(%eax)
 154:	44                   	inc    %esp
 155:	00 45 00             	add    %al,0x0(%ebp)
 158:	76 c4                	jbe    11e <CR0_PE_ON+0x11d>
 15a:	00 00                	add    %al,(%eax)
 15c:	00 00                	add    %al,(%eax)
 15e:	00 00                	add    %al,(%eax)
 160:	44                   	inc    %esp
 161:	00 46 00             	add    %al,0x0(%esi)
 164:	79 c4                	jns    12a <CR0_PE_ON+0x129>
 166:	00 00                	add    %al,(%eax)
 168:	00 00                	add    %al,(%eax)
 16a:	00 00                	add    %al,(%eax)
 16c:	44                   	inc    %esp
 16d:	00 4b 00             	add    %cl,0x0(%ebx)
 170:	7c c4                	jl     136 <CR0_PE_ON+0x135>
 172:	00 00                	add    %al,(%eax)
 174:	00 00                	add    %al,(%eax)
 176:	00 00                	add    %al,(%eax)
 178:	44                   	inc    %esp
 179:	00 4c 00 7e          	add    %cl,0x7e(%eax,%eax,1)
 17d:	c4 00                	les    (%eax),%eax
 17f:	00 00                	add    %al,(%eax)
 181:	00 00                	add    %al,(%eax)
 183:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
 187:	00 80 c4 00 00 00    	add    %al,0xc4(%eax)
 18d:	00 00                	add    %al,(%eax)
 18f:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
 193:	00 81 c4 00 00 00    	add    %al,0xc4(%ecx)
 199:	00 00                	add    %al,(%eax)
 19b:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
 19f:	00 83 c4 00 00 00    	add    %al,0xc4(%ebx)
 1a5:	00 00                	add    %al,(%eax)
 1a7:	00 44 00 57          	add    %al,0x57(%eax,%eax,1)
 1ab:	00 84 c4 00 00 00 00 	add    %al,0x0(%esp,%eax,8)
 1b2:	00 00                	add    %al,(%eax)
 1b4:	44                   	inc    %esp
 1b5:	00 58 00             	add    %bl,0x0(%eax)
 1b8:	86 c4                	xchg   %al,%ah
 1ba:	00 00                	add    %al,(%eax)
 1bc:	00 00                	add    %al,(%eax)
 1be:	00 00                	add    %al,(%eax)
 1c0:	44                   	inc    %esp
 1c1:	00 59 00             	add    %bl,0x0(%ecx)
 1c4:	88 c4                	mov    %al,%ah
 1c6:	00 00                	add    %al,(%eax)
 1c8:	00 00                	add    %al,(%eax)
 1ca:	00 00                	add    %al,(%eax)
 1cc:	44                   	inc    %esp
 1cd:	00 5b 00             	add    %bl,0x0(%ebx)
 1d0:	8a c4                	mov    %ah,%al
 1d2:	00 00                	add    %al,(%eax)
 1d4:	00 00                	add    %al,(%eax)
 1d6:	00 00                	add    %al,(%eax)
 1d8:	44                   	inc    %esp
 1d9:	00 5c 00 8c          	add    %bl,-0x74(%eax,%eax,1)
 1dd:	c4 00                	les    (%eax),%eax
 1df:	00 00                	add    %al,(%eax)
 1e1:	00 00                	add    %al,(%eax)
 1e3:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
 1e7:	00 8e c4 00 00 00    	add    %cl,0xc4(%esi)
 1ed:	00 00                	add    %al,(%eax)
 1ef:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
 1f3:	00 90 c4 00 00 00    	add    %dl,0xc4(%eax)
 1f9:	00 00                	add    %al,(%eax)
 1fb:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
 1ff:	00 92 c4 00 00 00    	add    %dl,0xc4(%edx)
 205:	00 00                	add    %al,(%eax)
 207:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
 20b:	00 94 c4 00 00 00 00 	add    %dl,0x0(%esp,%eax,8)
 212:	00 00                	add    %al,(%eax)
 214:	44                   	inc    %esp
 215:	00 63 00             	add    %ah,0x0(%ebx)
 218:	96                   	xchg   %eax,%esi
 219:	c4 00                	les    (%eax),%eax
 21b:	00 00                	add    %al,(%eax)
 21d:	00 00                	add    %al,(%eax)
 21f:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
 223:	00 98 c4 00 00 00    	add    %bl,0xc4(%eax)
 229:	00 00                	add    %al,(%eax)
 22b:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
 22f:	00 9d c4 00 00 00    	add    %bl,0xc4(%ebp)
 235:	00 00                	add    %al,(%eax)
 237:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
 23b:	00 a0 c4 00 00 00    	add    %ah,0xc4(%eax)
 241:	00 00                	add    %al,(%eax)
 243:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
 247:	00 a6 c4 00 00 00    	add    %ah,0xc4(%esi)
 24d:	00 00                	add    %al,(%eax)
 24f:	00 44 00 76          	add    %al,0x76(%eax,%eax,1)
 253:	00 aa c4 00 00 00    	add    %ch,0xc4(%edx)
 259:	00 00                	add    %al,(%eax)
 25b:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
 25f:	00 ad c4 00 00 00    	add    %ch,0xc4(%ebp)
 265:	00 00                	add    %al,(%eax)
 267:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
 26b:	00 b2 c4 00 00 00    	add    %dh,0xc4(%edx)
 271:	00 00                	add    %al,(%eax)
 273:	00 44 00 8a          	add    %al,-0x76(%eax,%eax,1)
 277:	00 b6 c4 00 00 00    	add    %dh,0xc4(%esi)
 27d:	00 00                	add    %al,(%eax)
 27f:	00 44 00 8b          	add    %al,-0x75(%eax,%eax,1)
 283:	00 b8 c4 00 00 00    	add    %bh,0xc4(%eax)
 289:	00 00                	add    %al,(%eax)
 28b:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
 28f:	00 ba c4 00 00 00    	add    %bh,0xc4(%edx)
 295:	00 00                	add    %al,(%eax)
 297:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
 29b:	00 bc c4 00 00 00 00 	add    %bh,0x0(%esp,%eax,8)
 2a2:	00 00                	add    %al,(%eax)
 2a4:	44                   	inc    %esp
 2a5:	00 8e 00 be c4 00    	add    %cl,0xc4be00(%esi)
 2ab:	00 00                	add    %al,(%eax)
 2ad:	00 00                	add    %al,(%eax)
 2af:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
 2b3:	00 c0                	add    %al,%al
 2b5:	c4 00                	les    (%eax),%eax
 2b7:	00 00                	add    %al,(%eax)
 2b9:	00 00                	add    %al,(%eax)
 2bb:	00 44 00 99          	add    %al,-0x67(%eax,%eax,1)
 2bf:	00 c5                	add    %al,%ch
 2c1:	c4 00                	les    (%eax),%eax
 2c3:	00 00                	add    %al,(%eax)
 2c5:	00 00                	add    %al,(%eax)
 2c7:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
 2cb:	00 ca                	add    %cl,%dl
 2cd:	c4 00                	les    (%eax),%eax
 2cf:	00 00                	add    %al,(%eax)
 2d1:	00 00                	add    %al,(%eax)
 2d3:	00 44 00 9b          	add    %al,-0x65(%eax,%eax,1)
 2d7:	00 cf                	add    %cl,%bh
 2d9:	c4 00                	les    (%eax),%eax
 2db:	00 00                	add    %al,(%eax)
 2dd:	00 00                	add    %al,(%eax)
 2df:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
 2e3:	00 d4                	add    %dl,%ah
 2e5:	c4 00                	les    (%eax),%eax
 2e7:	00 00                	add    %al,(%eax)
 2e9:	00 00                	add    %al,(%eax)
 2eb:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
 2ef:	00 d9                	add    %bl,%cl
 2f1:	c4 00                	les    (%eax),%eax
 2f3:	00 00                	add    %al,(%eax)
 2f5:	00 00                	add    %al,(%eax)
 2f7:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
 2fb:	00 de                	add    %bl,%dh
 2fd:	c4 00                	les    (%eax),%eax
 2ff:	00 00                	add    %al,(%eax)
 301:	00 00                	add    %al,(%eax)
 303:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
 307:	00 e3                	add    %ah,%bl
 309:	c4 00                	les    (%eax),%eax
 30b:	00 00                	add    %al,(%eax)
 30d:	00 00                	add    %al,(%eax)
 30f:	00 44 00 a3          	add    %al,-0x5d(%eax,%eax,1)
 313:	00 e8                	add    %ch,%al
 315:	c4 00                	les    (%eax),%eax
 317:	00 00                	add    %al,(%eax)
 319:	00 00                	add    %al,(%eax)
 31b:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
 31f:	00 ed                	add    %ch,%ch
 321:	c4 00                	les    (%eax),%eax
 323:	00 00                	add    %al,(%eax)
 325:	00 00                	add    %al,(%eax)
 327:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
 32b:	00 f2                	add    %dh,%dl
 32d:	c4 00                	les    (%eax),%eax
 32f:	00 00                	add    %al,(%eax)
 331:	00 00                	add    %al,(%eax)
 333:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
 337:	00 f7                	add    %dh,%bh
 339:	c4 00                	les    (%eax),%eax
 33b:	00 00                	add    %al,(%eax)
 33d:	00 00                	add    %al,(%eax)
 33f:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
 343:	00 fc                	add    %bh,%ah
 345:	c4 00                	les    (%eax),%eax
 347:	00 00                	add    %al,(%eax)
 349:	00 00                	add    %al,(%eax)
 34b:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
 34f:	00 02                	add    %al,(%edx)
 351:	c5 00                	lds    (%eax),%eax
 353:	00 00                	add    %al,(%eax)
 355:	00 00                	add    %al,(%eax)
 357:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
 35b:	00 08                	add    %cl,(%eax)
 35d:	c5 00                	lds    (%eax),%eax
 35f:	00 00                	add    %al,(%eax)
 361:	00 00                	add    %al,(%eax)
 363:	00 44 00 ac          	add    %al,-0x54(%eax,%eax,1)
 367:	00 0e                	add    %cl,(%esi)
 369:	c5 00                	lds    (%eax),%eax
 36b:	00 00                	add    %al,(%eax)
 36d:	00 00                	add    %al,(%eax)
 36f:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
 373:	00 13                	add    %dl,(%ebx)
 375:	c5 00                	lds    (%eax),%eax
 377:	00 00                	add    %al,(%eax)
 379:	00 00                	add    %al,(%eax)
 37b:	00 44 00 c2          	add    %al,-0x3e(%eax,%eax,1)
 37f:	00 1a                	add    %bl,(%edx)
 381:	c5 00                	lds    (%eax),%eax
 383:	00 00                	add    %al,(%eax)
 385:	00 00                	add    %al,(%eax)
 387:	00 44 00 c3          	add    %al,-0x3d(%eax,%eax,1)
 38b:	00 1c c5 00 00 00 00 	add    %bl,0x0(,%eax,8)
 392:	00 00                	add    %al,(%eax)
 394:	44                   	inc    %esp
 395:	00 c4                	add    %al,%ah
 397:	00 1f                	add    %bl,(%edi)
 399:	c5 00                	lds    (%eax),%eax
 39b:	00 00                	add    %al,(%eax)
 39d:	00 00                	add    %al,(%eax)
 39f:	00 44 00 c5          	add    %al,-0x3b(%eax,%eax,1)
 3a3:	00 21                	add    %ah,(%ecx)
 3a5:	c5 00                	lds    (%eax),%eax
 3a7:	00 00                	add    %al,(%eax)
 3a9:	00 00                	add    %al,(%eax)
 3ab:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
 3af:	00 24 c5 00 00 00 00 	add    %ah,0x0(,%eax,8)
 3b6:	00 00                	add    %al,(%eax)
 3b8:	44                   	inc    %esp
 3b9:	00 c7                	add    %al,%bh
 3bb:	00 27                	add    %ah,(%edi)
 3bd:	c5 00                	lds    (%eax),%eax
 3bf:	00 00                	add    %al,(%eax)
 3c1:	00 00                	add    %al,(%eax)
 3c3:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
 3c7:	00 29                	add    %ch,(%ecx)
 3c9:	c5 00                	lds    (%eax),%eax
	...

Disassembly of section .stabstr:

00000000 <.stabstr>:
   0:	00 2f                	add    %ch,(%edi)
   2:	74 6d                	je     71 <CR0_PE_ON+0x70>
   4:	70 2f                	jo     35 <CR0_PE_ON+0x34>
   6:	63 63 77             	arpl   %sp,0x77(%ebx)
   9:	36                   	ss
   a:	5a                   	pop    %edx
   b:	64                   	fs
   c:	59                   	pop    %ecx
   d:	4f                   	dec    %edi
   e:	2e 73 00             	jae,pn 11 <CR0_PE_ON+0x10>
  11:	65 6e                	outsb  %gs:(%esi),(%dx)
  13:	74 72                	je     87 <CR0_PE_ON+0x86>
  15:	79 2e                	jns    45 <CR0_PE_ON+0x44>
  17:	53                   	push   %ebx
	...
