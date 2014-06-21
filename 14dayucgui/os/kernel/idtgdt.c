
#include<idtgdt.h>
#include<int.h>
//只有这一个被main调用
void  init_gdtidt()
{
  //这里是直接指定了内存的空间，需要注意记得这里
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0xc092);//entry.s main.c data 4GB空间的数据都能访问
  setgdt(gdt+2,0x000fffff   ,0x00000000,0xc09a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0xc09a);  //main.c code　 0x7ffff=512kB
  //setgdt(gdt+3,0xffffffff   ,0x00000000,0x409a);//entry.S code
   load_gdtr(0xfff,0X00270000);//this is right
  for(i=0;i<256;i++)
  {
      setidt(idt+i,(int)asm_inthandler21,2*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x20,(int)asm_inthandler20,2*8,0x008e);//挂载timer interrrupt service 汇编程序
  setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service汇编程序
  setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt service汇编程序

 // setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service
 // setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt serv
  //printdebug(asm_inthandler2c,0);
  load_idtr(0x7ff,0x0026f800);//this is right
  return;
}

void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  if(limit>0xffff)
  {
    access|=0x8000;  //应该是这个地方吧
    //limit /=0x1000;  //这里limit =limit/0x1000=0x100000/0x1000=1MB
    //所以 如果把上面的这一句打找，我们就只能访问1MB的长度，而我们的段基址是0x0,
    //但是我们的中断程序是在0x280000之后的某个位置，所以很显然 会超出段的访问空间

    //我们采用了分页机制，不能像日本作者那样，作者没有采用分页机制，而且只用了512KB的段长度
    //打开这个地方，在qemu上不会有问题，但是在真实的机器上会不停重启，因为在保护模式下，访问的段超过了大小
  }

  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  sd->base_high=(base>>24)&0xff;

}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  //16位的selector决定了base address
  gd->selector=selector;
  gd->dw_count=(access>>8)&0xff;//00
  gd->access_right=access&0xff;//0x8e晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  gd->offset_high=(offset>>16)&0xffff;
}


