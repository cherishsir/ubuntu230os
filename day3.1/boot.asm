
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
    7c2e:	73 75                	jae    7ca5 <read+0xe>
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
    7c61:	d0 7c e8 56          	sarb   0x56(%eax,%ebp,8)
    7c65:	00 be eb 7c e8 50    	add    %bh,0x50e87ceb(%esi)
    7c6b:	00 b8 20 08 8e c0    	add    %bh,-0x3f71f7e0(%eax)
    7c71:	bb 00 00 b5 00       	mov    $0xb50000,%ebx
    7c76:	b6 00                	mov    $0x0,%dh
    7c78:	b1 02                	mov    $0x2,%cl

00007c7a <readloop>:
    7c7a:	be 00 00 e8 17       	mov    $0x17e80000,%esi
    7c7f:	00 8c c0 83 c0 20 8e 	add    %cl,-0x71df3f7d(%eax,%eax,8)
    7c86:	c0 80 c1 01 80 f9 12 	rolb   $0x12,-0x67ffe3f(%eax)
    7c8d:	76 eb                	jbe    7c7a <readloop>
    7c8f:	be 1b 7d e8 27       	mov    $0x27e87d1b,%esi
	...

00007c95 <loop>:
    7c95:	eb fe                	jmp    7c95 <loop>

00007c97 <read>:
    7c97:	8a 16                	mov    (%esi),%dl
    7c99:	fe                   	(bad)  
    7c9a:	7d b4                	jge    7c50 <entry>
    7c9c:	02 b0 01 cd 13 73    	add    0x7313cd01(%eax),%dh
    7ca2:	10 83 c6 01 83 fe    	adc    %al,-0x17cfe3a(%ebx)
    7ca8:	05 73 09 b4 00       	add    $0xb40973,%eax
    7cad:	b2 00                	mov    $0x0,%dl
    7caf:	cd 13                	int    $0x13
    7cb1:	eb e4                	jmp    7c97 <read>

00007cb3 <over>:
    7cb3:	c3                   	ret    

00007cb4 <error>:
    7cb4:	be 04 7d e8 02       	mov    $0x2e87d04,%esi
    7cb9:	00 eb                	add    %ch,%bl
    7cbb:	d9 8a 04 83 c6 01    	(bad)  0x1c68304(%edx)

00007cbc <puts>:
    7cbc:	8a 04 83             	mov    (%ebx,%eax,4),%al
    7cbf:	c6 01 3c             	movb   $0x3c,(%ecx)
    7cc2:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    7cc6:	0e                   	push   %cs
    7cc7:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    7ccc:	eb ee                	jmp    7cbc <puts>

00007cce <finish>:
    7cce:	f4                   	hlt    
    7ccf:	c3                   	ret    

00007cd0 <msg>:
    7cd0:	0d 0a 6d 79 20       	or     $0x20796d0a,%eax
    7cd5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
    7cd8:	74 6c                	je     7d46 <okmsg+0x2b>
    7cda:	6f                   	outsl  %ds:(%esi),(%dx)
    7cdb:	61                   	popa   
    7cdc:	64                   	fs
    7cdd:	65                   	gs
    7cde:	72 20                	jb     7d00 <my+0x15>
    7ce0:	69 73 20 72 75 6e 6e 	imul   $0x6e6e7572,0x20(%ebx),%esi
    7ce7:	69 6e 67 00 0d 0a 77 	imul   $0x770a0d00,0x67(%esi),%ebp

00007ceb <my>:
    7ceb:	0d 0a 77 65 6c       	or     $0x6c65770a,%eax
    7cf0:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    7cf3:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    7cf8:	6f                   	outsl  %ds:(%esi),(%dx)
    7cf9:	75 72                	jne    7d6d <okmsg+0x52>
    7cfb:	20 63 6f             	and    %ah,0x6f(%ebx)
    7cfe:	75 72                	jne    7d72 <okmsg+0x57>
    7d00:	73 65                	jae    7d67 <okmsg+0x4c>
    7d02:	20 00                	and    %al,(%eax)

00007d04 <errormsg>:
    7d04:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7d09:	64 20 75 20          	and    %dh,%fs:0x20(%ebp)
    7d0d:	66                   	data16
    7d0e:	6c                   	insb   (%dx),%es:(%edi)
    7d0f:	61                   	popa   
    7d10:	73 68                	jae    7d7a <okmsg+0x5f>
    7d12:	20 66 61             	and    %ah,0x61(%esi)
    7d15:	69 6c 65 64 20 00 0d 	imul   $0xa0d0020,0x64(%ebp,%eiz,2),%ebp
    7d1c:	0a 

00007d1b <okmsg>:
    7d1b:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7d20:	64 20 20             	and    %ah,%fs:(%eax)
    7d23:	75 20                	jne    7d45 <okmsg+0x2a>
    7d25:	64 69 73 6b 20 6f 66 	imul   $0x20666f20,%fs:0x6b(%ebx),%esi
    7d2c:	20 
    7d2d:	32 20                	xor    (%eax),%ah
    7d2f:	73 65                	jae    7d96 <okmsg+0x7b>
    7d31:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
    7d35:	2c 20                	sub    $0x20,%al
    7d37:	6f                   	outsl  %ds:(%esi),(%dx)
    7d38:	6b 20 00             	imul   $0x0,(%eax),%esp
	...
    7dfb:	00 00                	add    %al,(%eax)
    7dfd:	00 55 aa             	add    %dl,-0x56(%ebp)
