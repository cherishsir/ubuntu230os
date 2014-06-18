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
    mov %dl,(0x7dfe)

    mov $msg,%si
    call puts
    mov $my,%si
    call puts

/*memory=0x8200,chs=002*/
    mov $0x820,%ax
    mov %ax,%es
    mov $0x00,%bx
    mov $0x00,%ch
    mov $0x00,%dh
    mov $0x02,%cl
    call read
    mov $okmsg,%si
    call puts

loop:
    jmp loop




read:
    mov (0x7dfe),%dl
    //mov $0x00,%dl
    mov $0x02,%ah
    mov $0x01,%al
    int $0x13
    jc error
    ret

error:
    mov $errormsg,%si
    call puts
    hlt
    //ret
    jmp loop

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
my:
    .asciz "\r\nwelcome to our course "

errormsg:
    .asciz "\r\nread u flash failed "

okmsg:
    .asciz "\r\nread  u disk of 2 sector, ok "

.org 510
.word 0xaa55
















