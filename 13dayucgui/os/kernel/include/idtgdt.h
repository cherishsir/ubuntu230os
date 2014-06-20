#ifndef __idtgdt_h_
#define __idtgdt_h_

struct GDT
{
  short limit_low;
  short base_low;

  char  base_mid;
  char  access_right;
  char  limit_high;
  char  base_high;

};
struct IDT
{
  short offset_low;
  short selector;

  char dw_count;
  char access_right;

  short offset_high;
};
//设置idt gdt的函数，有内存的直接分配
extern void  init_gdtidt();
//下面两个函数是汇编写的
extern void load_gdtr(int limit, int addr);//it works
extern void load_idtr(int limit, int addr);//it works

#endif // __idtgdt_h_
