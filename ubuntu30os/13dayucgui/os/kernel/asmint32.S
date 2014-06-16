.global asm_inthandler2c
.global asm_inthandler21
.global asm_inthandler20
.global load_gdtr
.global load_idtr

.code32
#interrupt service about timer irq0
asm_inthandler20:
  pushw %es
  pushw %ds
  pushal
  movl %esp,%eax
  pushl %eax
  movw %ss,%ax
  movw %ax,%ds
  movw %ax,%es
  call inthandler20

  popl %eax
  popal
  popw %ds
  popW %es
  iretl


#interrupt service about keyboad irq1
asm_inthandler21:
  pushw %es
  pushw %ds
  pushal
  movl %esp,%eax
  pushl %eax
  movw %ss,%ax
  movw %ax,%ds
  movw %ax,%es
  call inthandler21

  popl %eax
  popal
  popw %ds
  popW %es
  iretl

#interrupt service about mouse irq 0xc
asm_inthandler2c:
  pushw %es
  pushw %ds
  pushal
  movl %esp,%eax
  pushl %eax
  movw %ss,%ax
  movw %ax,%ds
  movw %ax,%es
  call inthandler2c

  popl %eax
  popal
  popw %ds
  popW %es
  iretl
  #iret 与iretl有什么区别？？？
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  mov %ax,6(%esp)
  lgdt 6(%esp)
  ret


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  mov %ax,6(%esp)
  lidt 6(%esp)
  ret
