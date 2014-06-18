程序运行方法
make run即可


=这是nasm ,intel的汇编语法，但是后面的开发大量用到gnu assemble的语法，所以我们把bootloader也改写成gnu的汇编语法。
org 0x7c00保证编译地址就是运行地址
段寄存器的访问
mov ds,ax
    es,ax
    ss,ax

mov sp ,0x7c00
mov si,msg  ;标号就是地址



读内存：
mov al,[si]
mov ax,[si]
mov al,[bx]
寄存器内容++
add si,1


寄存器内容与常量比较
cmp al,0
je finisn   如果 al==0 jump to finish 这就是汇编执行程序时，打断自然顺序的方法

==========================================================================
一个中断服务程序：int 0x10:功能，显示一个字符：如显示 'a'

mov al,'a'
mov ah,0x0e  ; one character function
mov bx,15    ; define color
int 0x10
============================================================================
;实现死循环
finish:
	jmp finish

============================================================================
msg:

db 0x0a,0x0a
db "hello this is messaga"
db 0x0a,0x00
============================================================================
si,bx这两个寄存器可以用来保存地址。

hlt对中断的发生是有反应的，当然需要把中断开关打开。


==================================================================
gcc -c hello.S -m32 -o hello.o
 ld -m elf_i386 hello.o -e start -Ttext 0x7c00
objcopy -S -O binary -j .text a.out  kernel

