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
/*显示一些*/
    mov $msg,%si
    call puts
    mov $my,%si
    call puts
/*memory=0x8200,chs=002*/
    mov $0x800,%ax
    mov %ax,%es
    mov $0x00,%bx

    mov $0x00,%ch
    mov $0x00,%dh
    mov $0x01,%cl
//读取18个扇区数
readloop:
    mov $0x00,%si    /*记住扇区读失败的次数*/
    call read

    mov %es,%ax
    add $0x0020,%ax
    mov %ax,%es
    add $0x01,%cl
    cmp $63,%cl
    jbe readloop
    //63个扇区读完了，可以chs中 h++了
    mov $0x01,%cl  //扇区从1开始
    add  $0x01,%dh
    cmp  $0x6,%dh
    jb readloop

//为了测试从u盘读到内存中的数据是否有正常，我们把内存地址0x34fff中的数据读出来，在u盘中时，地址为0x2d000-1的位置
//使用hexedit编辑这个位置的数据为0xaa
//读出内存中ds:bx=0x34ff:0xf的数据到寄存器cl,与0xaa做比较，如果相等，则说明读取u盘中的数据到内存没有问题，可以进行下一步了。
   push %ds

   mov $0x34ff,%ax
   mov %ax,%ds
   mov $0xf,%bx
   mov (%bx), %cl

   pop %ds
   cmp $0xaa,%cl
   //if equal ,跳转到haha,显示读取u盘最后一个字节没有问题，在进行 u盘测试时，可以先用 qemu的moniter功能，查看一下$cl寄存器的值是否
   //为0xaa
   je  haha

    mov $errormsg,%si
    call puts

loop:
    jmp loop

haha:
   mov $msgusb,%si
   call puts
   jmp loop

msgusb:
	.asciz "\r\nlast sector of usb read ok"



/*读一个扇区的子程序*/
read:
    mov (0x7dfe),%dl
    //mov $0x00,%dl
    mov $0x02,%ah   //read
    mov $0x01,%al   //one sector
    int $0x13
    jnc over        //没有进位就成功了，有进位就会需要重新读取
    add $0x01,%si
    cmp $0x05,%si
    jae error
    mov $0x00,%ah
    mov $0x00,%dl
    int $0x13
    jmp read
over:
    ret


error:
    mov $errormsg,%si
    call puts
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
    .asciz "\r\nread  u disk of  180kB, ok "

.org 510
.word 0xaa55
















