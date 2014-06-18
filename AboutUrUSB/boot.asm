
boot.elf:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	eb 4e                	jmp    7c50 <entry>
    7c02:	00 68 65             	add    %ch,0x65(%eax)
    7c05:	6c                   	insb   (%dx),%es:(%edi)
    7c06:	6c                   	insb   (%dx),%es:(%edi)
    7c07:	6f                   	outsl  %ds:(%esi),(%dx)
    7c08:	4f                   	dec    %edi
    7c09:	53                   	push   %ebx
    7c0a:	58                   	pop    %eax
    7c0b:	00 02                	add    %al,(%edx)
    7c0d:	01 01                	add    %eax,(%ecx)
    7c0f:	00 02                	add    %al,(%edx)
    7c11:	e0 00                	loopne 7c13 <start+0x13>
    7c13:	40                   	inc    %eax
    7c14:	0b f0                	or     %eax,%esi
    7c16:	09 00                	or     %eax,(%eax)
    7c18:	12 00                	adc    (%eax),%al
    7c1a:	02 00                	add    (%eax),%al
    7c1c:	00 00                	add    %al,(%eax)
    7c1e:	00 00                	add    %al,(%eax)
    7c20:	40                   	inc    %eax
    7c21:	0b 00                	or     (%eax),%eax
    7c23:	00 00                	add    %al,(%eax)
    7c25:	00 29                	add    %ch,(%ecx)
    7c27:	ff                   	(bad)  
    7c28:	ff                   	(bad)  
    7c29:	ff                   	(bad)  
    7c2a:	ff 6d 79             	ljmp   *0x79(%ebp)
    7c2d:	6f                   	outsl  %ds:(%esi),(%dx)
    7c2e:	73 75                	jae    7ca5 <readloop+0x2b>
    7c30:	64 69 73 6b 20 20 66 	imul   $0x61662020,%fs:0x6b(%ebx),%esi
    7c37:	61 
    7c38:	74 31                	je     7c6b <entry+0x1b>
    7c3a:	32 20                	xor    (%eax),%ah
    7c3c:	20 20                	and    %ah,(%eax)
	...

00007c50 <entry>:
    7c50:	b8 00 00 8e d8       	mov    $0xd88e0000,%eax
    7c55:	8e c0                	mov    %eax,%es
    7c57:	8e d0                	mov    %eax,%ss
    7c59:	bc 00 7c 88 16       	mov    $0x16887c00,%esp
    7c5e:	fe                   	(bad)  
    7c5f:	7d be                	jge    7c1f <start+0x1f>
    7c61:	0e                   	push   %cs
    7c62:	7d e8                	jge    7c4c <start+0x4c>
    7c64:	94                   	xchg   %eax,%esp
    7c65:	00 be 29 7d e8 8e    	add    %bh,-0x711782d7(%esi)
    7c6b:	00 b8 20 08 8e c0    	add    %bh,-0x3f71f7e0(%eax)
    7c71:	bb 00 00 b5 00       	mov    $0xb50000,%ebx
    7c76:	b6 00                	mov    $0x0,%dh
    7c78:	b1 02                	mov    $0x2,%cl

00007c7a <readloop>:
    7c7a:	be 00 00 e8 55       	mov    $0x55e80000,%esi
    7c7f:	00 8c c0 83 c0 20 8e 	add    %cl,-0x71df3f7d(%eax,%eax,8)
    7c86:	c0 80 c1 01 80 f9 12 	rolb   $0x12,-0x67ffe3f(%eax)
    7c8d:	76 eb                	jbe    7c7a <readloop>
    7c8f:	b1 01                	mov    $0x1,%cl
    7c91:	80 c6 01             	add    $0x1,%dh
    7c94:	80 fe 02             	cmp    $0x2,%dh
    7c97:	72 e1                	jb     7c7a <readloop>
    7c99:	b6 00                	mov    $0x0,%dh
    7c9b:	80 c5 01             	add    $0x1,%ch
    7c9e:	80 fd 0a             	cmp    $0xa,%ch
    7ca1:	72 d7                	jb     7c7a <readloop>
    7ca3:	1e                   	push   %ds
    7ca4:	b8 ff 34 8e d8       	mov    $0xd88e34ff,%eax
    7ca9:	bb 0f 00 8a 0f       	mov    $0xf8a000f,%ebx
    7cae:	1f                   	pop    %ds
    7caf:	80 f9 aa             	cmp    $0xaa,%cl
    7cb2:	74 03                	je     7cb7 <haha>

00007cb4 <loop>:
    7cb4:	e9 49 05 be bf       	jmp    bfbe8202 <__bss_start+0xbfbdf402>

00007cb7 <haha>:
    7cb7:	be bf 7c e8 3d       	mov    $0x3de87cbf,%esi
    7cbc:	00 eb                	add    %ch,%bl
    7cbe:	f5                   	cmc    

00007cbf <msgusb>:
    7cbf:	0d 0a 6c 61 73       	or     $0x73616c0a,%eax
    7cc4:	74 20                	je     7ce6 <read+0x11>
    7cc6:	73 65                	jae    7d2d <my+0x4>
    7cc8:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
    7ccc:	20 72 65             	and    %dh,0x65(%edx)
    7ccf:	61                   	popa   
    7cd0:	64 20 6f 6b          	and    %ch,%fs:0x6b(%edi)
	...

00007cd5 <read>:
    7cd5:	8a 16                	mov    (%esi),%dl
    7cd7:	fe                   	(bad)  
    7cd8:	7d b4                	jge    7c8e <readloop+0x14>
    7cda:	02 b0 01 cd 13 73    	add    0x7313cd01(%eax),%dh
    7ce0:	10 83 c6 01 83 fe    	adc    %al,-0x17cfe3a(%ebx)
    7ce6:	05 73 09 b4 00       	add    $0xb40973,%eax
    7ceb:	b2 00                	mov    $0x0,%dl
    7ced:	cd 13                	int    $0x13
    7cef:	eb e4                	jmp    7cd5 <read>

00007cf1 <over>:
    7cf1:	c3                   	ret    

00007cf2 <error>:
    7cf2:	be 42 7d e8 02       	mov    $0x2e87d42,%esi
    7cf7:	00 eb                	add    %ch,%bl
    7cf9:	ba 8a 04 83 c6       	mov    $0xc683048a,%edx

00007cfa <puts>:
    7cfa:	8a 04 83             	mov    (%ebx,%eax,4),%al
    7cfd:	c6 01 3c             	movb   $0x3c,(%ecx)
    7d00:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    7d04:	0e                   	push   %cs
    7d05:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    7d0a:	eb ee                	jmp    7cfa <puts>

00007d0c <finish>:
    7d0c:	f4                   	hlt    
    7d0d:	c3                   	ret    

00007d0e <msg>:
    7d0e:	0d 0a 6d 79 20       	or     $0x20796d0a,%eax
    7d13:	62 6f 6f             	bound  %ebp,0x6f(%edi)
    7d16:	74 6c                	je     7d84 <okmsg+0x2b>
    7d18:	6f                   	outsl  %ds:(%esi),(%dx)
    7d19:	61                   	popa   
    7d1a:	64                   	fs
    7d1b:	65                   	gs
    7d1c:	72 20                	jb     7d3e <my+0x15>
    7d1e:	69 73 20 72 75 6e 6e 	imul   $0x6e6e7572,0x20(%ebx),%esi
    7d25:	69 6e 67 00 0d 0a 77 	imul   $0x770a0d00,0x67(%esi),%ebp

00007d29 <my>:
    7d29:	0d 0a 77 65 6c       	or     $0x6c65770a,%eax
    7d2e:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    7d31:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    7d36:	6f                   	outsl  %ds:(%esi),(%dx)
    7d37:	75 72                	jne    7dab <okmsg+0x52>
    7d39:	20 63 6f             	and    %ah,0x6f(%ebx)
    7d3c:	75 72                	jne    7db0 <okmsg+0x57>
    7d3e:	73 65                	jae    7da5 <okmsg+0x4c>
    7d40:	20 00                	and    %al,(%eax)

00007d42 <errormsg>:
    7d42:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7d47:	64 20 75 20          	and    %dh,%fs:0x20(%ebp)
    7d4b:	66                   	data16
    7d4c:	6c                   	insb   (%dx),%es:(%edi)
    7d4d:	61                   	popa   
    7d4e:	73 68                	jae    7db8 <okmsg+0x5f>
    7d50:	20 66 61             	and    %ah,0x61(%esi)
    7d53:	69 6c 65 64 20 00 0d 	imul   $0xa0d0020,0x64(%ebp,%eiz,2),%ebp
    7d5a:	0a 

00007d59 <okmsg>:
    7d59:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7d5e:	64 20 20             	and    %ah,%fs:(%eax)
    7d61:	75 20                	jne    7d83 <okmsg+0x2a>
    7d63:	64 69 73 6b 20 6f 66 	imul   $0x20666f20,%fs:0x6b(%ebx),%esi
    7d6a:	20 
    7d6b:	20 31                	and    %dh,(%ecx)
    7d6d:	38 30                	cmp    %dh,(%eax)
    7d6f:	6b 42 2c 20          	imul   $0x20,0x2c(%edx),%eax
    7d73:	6f                   	outsl  %ds:(%esi),(%dx)
    7d74:	6b 20 00             	imul   $0x0,(%eax),%esp
	...
    7dfb:	00 00                	add    %al,(%eax)
    7dfd:	00 55 aa             	add    %dl,-0x56(%ebp)
