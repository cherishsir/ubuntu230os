.global start
.code16
start:

    jmp entry
    /*定义fat12文件格式*/
    .byte 0x00
    .ascii "helloOSX"
    .word  512
    .byte  1
    .word  1
    .byte  2
    .word  224
    .word  2880
    .byte  0xf0
    .word  9
    .word  18
    .word  2
    .long  0
    .long  2880
    .byte  0,0,0x29
    .long  0xffffffff
    .ascii  "myosudisk  "
    .ascii  "fat12   "
    .fill 18


entry:
    mov $0,%ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%ss
    mov $0x7c00,%sp

    mov $msg,%si
    call puts
    mov $my,%si
    call puts


/*
this is a subfunction to display string
usage: mov $address,%si
       call puts
or     mov $label,%si
       call puts
*/
puts:
  movb (%si),%al
  add $1,%si
  cmp $0,%al
  je finish
  movb $0x0e,%ah
  movw $15,%bx
  int $0x10
  jmp puts
finish:
  ;hlt
  ret


msg:
	.asciz "\r\nmy bootloader is running"
my: .asciz "\r\nwelcome to our course "

.org 510
.word 0xaa55
















