
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
    7c2e:	73 75                	jae    7ca5 <puts+0xa>
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
    7c61:	af                   	scas   %es:(%edi),%eax
    7c62:	7c e8                	jl     7c4c <start+0x4c>
    7c64:	35 00 be ca 7c       	xor    $0x7ccabe00,%eax
    7c69:	e8 2f 00 b8 20       	call   20b87c9d <__bss_start+0x20b7ee9d>
    7c6e:	08 8e c0 bb 00 00    	or     %cl,0xbbc0(%esi)
    7c74:	b5 00                	mov    $0x0,%ch
    7c76:	b6 00                	mov    $0x0,%dh
    7c78:	b1 02                	mov    $0x2,%cl
    7c7a:	e8 08 00 be fa       	call   fabe7c87 <__bss_start+0xfabdee87>
    7c7f:	7c e8                	jl     7c69 <entry+0x19>
    7c81:	18 00                	sbb    %al,(%eax)

00007c83 <loop>:
    7c83:	eb fe                	jmp    7c83 <loop>

00007c85 <read>:
    7c85:	8a 16                	mov    (%esi),%dl
    7c87:	fe                   	(bad)  
    7c88:	7d b4                	jge    7c3e <start+0x3e>
    7c8a:	02 b0 01 cd 13 72    	add    0x7213cd01(%eax),%dh
    7c90:	01 c3                	add    %eax,%ebx

00007c92 <error>:
    7c92:	be e3 7c e8 03       	mov    $0x3e87ce3,%esi
    7c97:	00 f4                	add    %dh,%ah
    7c99:	eb e8                	jmp    7c83 <loop>

00007c9b <puts>:
    7c9b:	8a 04 83             	mov    (%ebx,%eax,4),%al
    7c9e:	c6 01 3c             	movb   $0x3c,(%ecx)
    7ca1:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    7ca5:	0e                   	push   %cs
    7ca6:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    7cab:	eb ee                	jmp    7c9b <puts>

00007cad <finish>:
    7cad:	f4                   	hlt    
    7cae:	c3                   	ret    

00007caf <msg>:
    7caf:	0d 0a 6d 79 20       	or     $0x20796d0a,%eax
    7cb4:	62 6f 6f             	bound  %ebp,0x6f(%edi)
    7cb7:	74 6c                	je     7d25 <okmsg+0x2b>
    7cb9:	6f                   	outsl  %ds:(%esi),(%dx)
    7cba:	61                   	popa   
    7cbb:	64                   	fs
    7cbc:	65                   	gs
    7cbd:	72 20                	jb     7cdf <my+0x15>
    7cbf:	69 73 20 72 75 6e 6e 	imul   $0x6e6e7572,0x20(%ebx),%esi
    7cc6:	69 6e 67 00 0d 0a 77 	imul   $0x770a0d00,0x67(%esi),%ebp

00007cca <my>:
    7cca:	0d 0a 77 65 6c       	or     $0x6c65770a,%eax
    7ccf:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    7cd2:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    7cd7:	6f                   	outsl  %ds:(%esi),(%dx)
    7cd8:	75 72                	jne    7d4c <okmsg+0x52>
    7cda:	20 63 6f             	and    %ah,0x6f(%ebx)
    7cdd:	75 72                	jne    7d51 <okmsg+0x57>
    7cdf:	73 65                	jae    7d46 <okmsg+0x4c>
    7ce1:	20 00                	and    %al,(%eax)

00007ce3 <errormsg>:
    7ce3:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7ce8:	64 20 75 20          	and    %dh,%fs:0x20(%ebp)
    7cec:	66                   	data16
    7ced:	6c                   	insb   (%dx),%es:(%edi)
    7cee:	61                   	popa   
    7cef:	73 68                	jae    7d59 <okmsg+0x5f>
    7cf1:	20 66 61             	and    %ah,0x61(%esi)
    7cf4:	69 6c 65 64 20 00 0d 	imul   $0xa0d0020,0x64(%ebp,%eiz,2),%ebp
    7cfb:	0a 

00007cfa <okmsg>:
    7cfa:	0d 0a 72 65 61       	or     $0x6165720a,%eax
    7cff:	64 20 20             	and    %ah,%fs:(%eax)
    7d02:	75 20                	jne    7d24 <okmsg+0x2a>
    7d04:	64 69 73 6b 20 6f 66 	imul   $0x20666f20,%fs:0x6b(%ebx),%esi
    7d0b:	20 
    7d0c:	32 20                	xor    (%eax),%ah
    7d0e:	73 65                	jae    7d75 <okmsg+0x7b>
    7d10:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
    7d14:	2c 20                	sub    $0x20,%al
    7d16:	6f                   	outsl  %ds:(%esi),(%dx)
    7d17:	6b 20 00             	imul   $0x0,(%eax),%esp
	...
    7dfe:	55                   	push   %ebp
    7dff:	aa                   	stos   %al,%es:(%edi)
