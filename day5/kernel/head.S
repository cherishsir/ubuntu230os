#define CYLS			0x0ff0
#define LEDS			0x0ff1
#define VMODE			0x0ff2
#define SCRNX			0x0ff4
#define SCRNY			0x0ff6
#define VRAM			0x0ff8

#define BOTPAK 			0X00280000
#define DSKCAC 			0x00100000
#define DSKCAC0			0X00008000

.globl start
start:
  .code16                     # Assemble for 16-bit mode
    jmp entry

msg:
  .asciz "\r\n\n\rmy kernel is running \r\n"
imsg:
  .asciz "\r\n\n\rhi,another video mode \r\n"

puts:
	movb (%si),%al
	add $1,%si
	cmp $0,%al
	je over
	movb $0x0e,%ah
	movw $15,%bx
	int $0x10
	jmp puts
over:
	ret
entry:
    mov $0,%ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%ss

    #diplay something
    movw $msg,%si
    call puts
    /*set video mode to 320x200 8bit color-panel*/
    mov $0x13,%al
    mov $0x00,%ah
    int $0x10

    /*display:hi,another video mode*/
    movw $imsg,%si
    call puts

    /*get keyboard status,save it*/
    mov $0x02,%ah
    int $0x16
    //mov $0xaa,%al
    mov %al,(LEDS)

    #save color mode in ram 0x0ff0
    movb  $10,(CYLS)
    movb $8,(VMODE)
    movw $320,(SCRNX)
    movw $200,(SCRNY)
    movl $0x000a0000,(VRAM)

/*write 0xff to port 0x21, port 0xa1*/
    movb $0xff,%al
    outb %al, $0x21 #format  outb data port
    nop
    out %al, $0xa1
    cli
/*enable A20 step 1*/
    seta20.1:
    inb     $0x64,%al                           //read data from port 0x64 ,save it to al
    testb   $0x2,%al   #if 1 :busy ,if 0:idle   //test bit 0b0000 0010
    jnz     seta20.1

    movb    $0xd1,%al                           // 0xd1 -> port 0x64
    outb    %al,$0x64

/*enable A20 step 2*/
seta20.2:
    inb     $0x64,%al                           // Wait for not busy
    testb   $0x02,%al
    jnz     seta20.2

    movb    $0xdf,%al                           //   0xdf -> port 0x60
    outb    %al,$0x60



// 把cr0的bit0打开后，就实现了32位模式了。
    lgdt     gdtdesc
    movl     %cr0, %eax
    andl     $0x7fffffff,%eax
    orl      $0x01, %eax  #CR0_PE_ON=0x1
    movl     %eax, %cr0

    #这个地方非常的重要，一但这条movl %eax,%cr0把cr0的pe位打开后，下面的
    #代码就是32位的，所以空上ljmp的指令是条过度指令，选择 用的gdt是1*8,
    #也就是第一个gdt(从0开始的)。
//16位蹦达到32位的代码处
    ljmp    $(2*8), $protcseg

.code32
protcseg:
  # Set up the protected-mode data segment registers
 # movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
  movw    $(1*8) , %ax
  movw    %ax, %ds                # -> DS: Data Segment  //vip
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS
  movw    %ax, %ss                # -> SS: Stack Segment

  movl    $start, %esp

//把整个软盘上的内容复制到 0x100000 内存地址处
  movl $DSKCAC0, %esi
  movl $DSKCAC , %edi
  movl $0,%ecx
  movb $6,%cl
  imul $(512*63/4) , %ecx
  subl  $(512/4),    %ecx
  call memcpy

//copy c code to 0x280000
  movl $main, %esi
  movl $0x280000  , %edi
  movl $(512*1024/4),%ecx
  call memcpy

//用下面这个种方法居然可以了，哈哈。
  pushl $0x280000
  ret
 // ljmp  $(2*8), $main  //jmp to 0x280000:0x0000 0000
  jmp .


memcpy:
  movl  (%esi),%eax
  addl  $4    ,%esi
  movl  %eax ,(%edi)
  addl   $4    ,%edi
  subl   $1    ,%ecx
  jnz    memcpy
  ret


gdt:
  .word 0x0000,0x0000,0x0000,0x0000     # null seg  0
  .word 0xffff,0x0000,0x9200,0x00cf     #data selector 1
  .word 0xffff,0x0000,0x9a00,0x0047     #entry code    2
  .word 0xffff,0x0000,0x9a28,0x0047     #c code        3
  .word 0x00                            #no use
gdtdesc:
  .word   39         #5*8-1                 # sizeof(gdt) - 1
  .long   gdt                                # address gdt
main:





