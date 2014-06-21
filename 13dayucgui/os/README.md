运行方式 ：

1：
make lib  编译生成libucgui.a的静态链接库


2：
make done  编译，运行


###日本作者没有用分页，而我在ubuntu下的代码，与作者实现有些不同，必须要开分页才能实现正常的 远距离跳转
###在进入c之后，idtgdt的重新分配之后，由于c代码中gdt段的长度，没有设置正确，导致了开始中段后，计算机就重启，但是在虚拟机上没有这样的问题
###由此可见qemu对于段长度的检查，没有很好的模拟真实的硬件

下面是记录一下改变

```c
gdt:
  .word 0x0000,0x0000,0x0000,0x0000  #need a flag
  .word 0xffff,0x0000,0x9200,0x00cf  #data selector 1
  .word 0xffff,0x0000,0x9a00,0x00c7  #entry and c code 2
```
