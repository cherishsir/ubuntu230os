
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
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
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;

  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的


}



void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }

  for(i=0;i<256;i++)
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x20,(int)asm_inthandler20-0x280000,3*8,0x008e);//挂载timer interrrupt service 汇编程序
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service汇编程序
  setidt(idt+0x2c,(int)asm_inthandler2c-0x280000,3*8,0x008e);//挂载mouse 　　interrupt service汇编程序

 // setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service
 // setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt serv
  //printdebug(asm_inthandler2c,0);

  load_idtr(0x7ff,0x0026f800);//this is right



  return;

}

//对内存写idt与写gdt都是没有问题的，现在只能改lgdt 与lidt这两个函数了










































