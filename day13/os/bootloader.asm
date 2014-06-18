; ; ; 
;2x10x18x512字节读入到ram中
;在内存中的地址是0x08200到0x034fff
;kernel.img程序的地址在0x4400,复制到ram后为0xc400
CYLS EQU 10
org 0x7c00
jmp entry  ;two bye instructon
;some information about fat12
db 0x00
db "huangtao"
dw 512  ;bytes per sector
db 1    ;sectors per cluser
dw 1     ;number of reserved sectors
db 2    ;number of fats ,fat#1,tat#2
dw 224  ;maximum number of root director entries
dw 2880 ;total sector count
db 0xf0 ;ignore
dw 9    ;sectors per fat,fat#1,fat#2
dw 18   ;sectors per track  80x18  ,cylinder=track
dw 2    ;number of heads  ;head 0 ,head 1
dd -1    ;ignore
dd 0    ;total sector count for fat32 (0 for fat12/16)d
db 0x00
db 0x00 ;ignore
db 0x29 ;boot signature
dd 0     ;4bytes volume id
db "hello-os0.1" ; volume label 11bytes
db "FAT12   "    ;fs  8bytes
;resb 18          ;ignore
entry:
mov ax ,0
mov ds ,ax
mov es, ax
mov ss, ax

mov sp, 0x7c00

mov si,msg  ;helloworld
call puts

mov si,cpmsg ;start copying to sdram
call puts

	mov ax,0x0820
	mov es,ax

	mov ch,0
	mov dh,0
	mov cl,2
readloop
	mov si,0
retry:

	mov bx,0
	call cp2ram
 	jnc next   ;copy sucessfully

	add si,1   ;copy failed
	cmp si,5
	jae error

	mov ah,0x00
	mov dl,0x00  ;if dl=0x00 ,it means floppy ,so i have to write a 
	int 0x13
	jmp retry

next:
	mov ax,es
	add ax,0x0020
	mov es,ax

	add cl,1 ;sector++
	cmp cl,18
	;cmp cl ,63
	jbe readloop
	
	mov cl,1 ;sector 是从扇区１形始
	add dh,1   ;head++
	cmp dh,2
	;cmp dh,10
	jb  readloop

	mov dh,0
	add ch,1  ;cylinder++
	cmp ch,CYLS  ;这里用了一个宏定义
	jb readloop	
	mov [0x0ff0],ch ;把10cylineder保存到内存0x0ff0位置处
	jmp ok
	
	
	
error:
	mov si,errormsg
	call puts	
	jmp $          ;if read error ,we hang it here

ok:
	mov si,okmsg
	call puts
	jmp finish

finish:

	
;	hlt
;       jmp finish
	jmp 0xc400  ;because of finishing copying,so jump to kernel in ram

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is a assemble function use "call cp2ram" to use it
cp2ram:
	mov ah,0x02
	mov al,1
	mov dl,0x00

	int 0x13
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is a assemble function use call to use it

puts:
	mov al,[si]
	add si,1
	cmp al,0
	je over
	mov ah,0x0e
	mov bx,15
	int 0x10
	jmp puts

over:
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
msg:
	db 0x0a,0x0a
	db "hello,world"
	db 0x0a,0x00 
cpmsg:
	db 0x0d
	db "start copying kernel to ram..."
	db 0x0a,0x0d,0x00
errormsg:
	db 0x0d
	db "copy failed"
	db 0x00
okmsg:
	db 0x0d
	db "copy kernel sucessfully"
	db 0x00

times 510-($-$$) db 0
db 0x55,0xaa
