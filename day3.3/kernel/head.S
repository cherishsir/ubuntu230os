.globl start
start:
  .code16                     # Assemble for 16-bit mode
  # i want to get dl ,then to display
  xorw    %ax,%ax             # Segment number zero
  xorw    %cx,%cx             # Segment number zero
   mov $0,%ax
   mov %ax,%ds

  #diplay something
  movw $msg,%si
  call puts

  movw $dxmsg, %si
 # movw %dx,%dx
  call dispreg16


  movw (0x7dfe),%ax
  movw $axmsg, %si
  movw %ax,%dx
  call dispreg16

  movw $udiskmsg,%si
  call puts

  mov (0x7dfe),%dl
  movb $0x08,%ah
  int  $0x13
  jc error

  push %ax
  push %bx
  push %cx

 #display all registers value ,first dx
  movw $dxmsg, %si
 #movw %dx,%dx
  call dispreg16

 #second cx value
  pop %cx
  movw %cx,%dx
  movw $cxmsg,%si
  call dispreg16

#second bx value
  pop %bx
  movw %bx,%dx
  movw $bxmsg,%si
  call dispreg16

#second ax  value
  pop %ax
  movw %ax,%dx
  movw $axmsg,%si
  call dispreg16

  push %cs;
  pop  %dx;
  #movw $0x08c0, %dx
  movw $csmsg,%si
  call dispreg16

  call other




  jmp finish
  #now we get udisk information.let us display to screen

other:
  pop %dx    #这样应该可以得到 74行后的ip地址
  push %dx
  movw $ipmsg,%si
  call dispreg16
  ret



error:
  movw $try,%si
  call puts

finish:
jmp .

ipmsg:
 .asciz "\n\rnow ip is "
csmsg:
 .asciz "\n\rnow cs is "
axmsg:
 .asciz "\n\r ax=0b "
bxmsg:
 .asciz "\n\r bx=0b "
cxmsg:
 .asciz "\n\r cx=0b "
dxmsg:
 .asciz "\n\r dx=0b "

    msg:
  .asciz "\r\n\n\rmy kernel is running \r\njust use to display registers,like,ax,dx,cx dx etc\n\r"
udiskmsg:
 .asciz "\n\r get information about usb disk:\n\r AX no care,BL ,CH ,CL DH,DL critical"
try:
 .asciz "\n\r read usb disk parameters failed,reboot you computer "

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
#################################################################################
#si=ptr reg str"reg=0b"
#movw name,%dx
dispreg16:
  call puts
  movb $16,%cl

  #lower fourbit
bit:
  push %cx
  push %dx

  sub $1,%cl
  shr  %cl,%dx


  call dispbit

  cmp $8,%cl
  jne skipblank
  movb $0x20,%al
  movb $0x0e,%ah
  movw $15,%bx
  int $0x10

skipblank:
  pop %dx
  pop %cx
  sub $1,%cl
  cmp $0,%cl
  jne bit
  ret



dispbit:


  xorw %ax,%ax             # Segment number zero
  movw %dx,%ax
  and  $0x01,%al
  add  $0x30,%al # add al ,0x30


  movb $0x0e,%ah
  movw $15,%bx
  int $0x10


  ret


//.org 510
//.short 0xaa55

