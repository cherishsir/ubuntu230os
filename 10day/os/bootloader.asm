
bootloader.elf:     file format elf32-i386


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
    7c2e:	73 75                	jae    7ca5 <msgusb+0x3>
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
    7c61:	09 7d e8             	or     %edi,-0x18(%ebp)
    7c64:	8f 00                	popl   (%eax)
    7c66:	be 24 7d e8 89       	mov    $0x89e87d24,%esi
    7c6b:	00 b8 00 08 8e c0    	add    %bh,-0x3f71f800(%eax)
    7c71:	bb 00 00 b5 00       	mov    $0xb50000,%ebx
    7c76:	b6 00                	mov    $0x0,%dh
    7c78:	b1 01                	mov    $0x1,%cl

00007c7a <readloop>:
    7c7a:	be 00 00 e8 50       	mov    $0x50e80000,%esi
    7c7f:	00 8c c0 83 c0 20 8e 	add    %cl,-0x71df3f7d(%eax,%eax,8)
    7c86:	c0 80 c1 01 80 f9 3f 	rolb   $0x3f,-0x67ffe3f(%eax)
    7c8d:	76 eb                	jbe    7c7a <readloop>
    7c8f:	b1 01                	mov    $0x1,%cl
    7c91:	80 c6 01             	add    $0x1,%dh
    7c94:	80 fe 06             	cmp    $0x6,%dh
    7c97:	72 e1                	jb     7c7a <readloop>
    7c99:	be a2 7c e8 56       	mov    $0x56e87ca2,%esi
	...

00007c9f <loop>:
    7c9f:	e9 5e 47 0d 0a       	jmp    a0dc402 <__bss_start+0xa0d3602>

00007ca2 <msgusb>:
    7ca2:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7ca7:	64 20 75 73          	and    %dh,%fs:0x73(%ebp)
    7cab:	62 20                	bound  %esp,(%eax)
    7cad:	36                   	ss
    7cae:	78 36                	js     7ce6 <read+0x16>
    7cb0:	33 73 65             	xor    0x65(%ebx),%esi
    7cb3:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
    7cb7:	73 3d                	jae    7cf6 <puts+0x1>
    7cb9:	31 38                	xor    %edi,(%eax)
    7cbb:	39 4b 42             	cmp    %ecx,0x42(%ebx)
    7cbe:	20 74 6f 20          	and    %dh,0x20(%edi,%ebp,2)
    7cc2:	6d                   	insl   (%dx),%es:(%edi)
    7cc3:	65                   	gs
    7cc4:	6d                   	insl   (%dx),%es:(%edi)
    7cc5:	6f                   	outsl  %ds:(%esi),(%dx)
    7cc6:	72 79                	jb     7d41 <errormsg+0x4>
    7cc8:	20 30                	and    %dh,(%eax)
    7cca:	78 38                	js     7d04 <puts+0xf>
    7ccc:	30 30                	xor    %dh,(%eax)
    7cce:	30 00                	xor    %al,(%eax)

00007cd0 <read>:
    7cd0:	8a 16                	mov    (%esi),%dl
    7cd2:	fe                   	(bad)  
    7cd3:	7d b4                	jge    7c89 <readloop+0xf>
    7cd5:	02 b0 01 cd 13 73    	add    0x7313cd01(%eax),%dh
    7cdb:	10 83 c6 01 83 fe    	adc    %al,-0x17cfe3a(%ebx)
    7ce1:	05 73 09 b4 00       	add    $0xb40973,%eax
    7ce6:	b2 00                	mov    $0x0,%dl
    7ce8:	cd 13                	int    $0x13
    7cea:	eb e4                	jmp    7cd0 <read>

00007cec <over>:
    7cec:	c3                   	ret    

00007ced <error>:
    7ced:	be 3d 7d e8 02       	mov    $0x2e87d3d,%esi
    7cf2:	00 eb                	add    %ch,%bl
    7cf4:	aa                   	stos   %al,%es:(%edi)

00007cf5 <puts>:
    7cf5:	8a 04 83             	mov    (%ebx,%eax,4),%al
    7cf8:	c6 01 3c             	movb   $0x3c,(%ecx)
    7cfb:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    7cff:	0e                   	push   %cs
    7d00:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    7d05:	eb ee                	jmp    7cf5 <puts>

00007d07 <finish>:
    7d07:	f4                   	hlt    
    7d08:	c3                   	ret    

00007d09 <msg>:
    7d09:	0d 0a 6d 79 20       	or     $0x20796d0a,%eax
    7d0e:	62 6f 6f             	bound  %ebp,0x6f(%edi)
    7d11:	74 6c                	je     7d7f <errormsg+0x42>
    7d13:	6f                   	outsl  %ds:(%esi),(%dx)
    7d14:	61                   	popa   
    7d15:	64                   	fs
    7d16:	65                   	gs
    7d17:	72 20                	jb     7d39 <my+0x15>
    7d19:	69 73 20 72 75 6e 6e 	imul   $0x6e6e7572,0x20(%ebx),%esi
    7d20:	69 6e 67 00 0d 0a 77 	imul   $0x770a0d00,0x67(%esi),%ebp

00007d24 <my>:
    7d24:	0d 0a 77 65 6c       	or     $0x6c65770a,%eax
    7d29:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    7d2c:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    7d31:	6f                   	outsl  %ds:(%esi),(%dx)
    7d32:	75 72                	jne    7da6 <errormsg+0x69>
    7d34:	20 63 6f             	and    %ah,0x6f(%ebx)
    7d37:	75 72                	jne    7dab <errormsg+0x6e>
    7d39:	73 65                	jae    7da0 <errormsg+0x63>
    7d3b:	20 00                	and    %al,(%eax)

00007d3d <errormsg>:
    7d3d:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7d42:	64 20 75 20          	and    %dh,%fs:0x20(%ebp)
    7d46:	66                   	data16
    7d47:	6c                   	insb   (%dx),%es:(%edi)
    7d48:	61                   	popa   
    7d49:	73 68                	jae    7db3 <errormsg+0x76>
    7d4b:	20 66 61             	and    %ah,0x61(%esi)
    7d4e:	69 6c 65 64 20 00 00 	imul   $0x20,0x64(%ebp,%eiz,2),%ebp
    7d55:	00 
	...
    7dfe:	55                   	push   %ebp
    7dff:	aa                   	stos   %al,%es:(%edi)
