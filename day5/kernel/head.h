#ifndef __HEAD_H
#define  __HEAD_H

#define VRAM 0XA0000
extern void set_palette(int start,int end, unsigned char *rgb);
extern void init_palette(void);

extern void putchar(unsigned char ch,char color,unsigned int x,unsigned int y);
extern void sprintf(char *des,const char *str,...);

extern void load_gdtr(int limit, int addr);//it works
extern void load_idtr(int limit, int addr);//it works
extern void asm_inthandler21();
extern void  init_gdtidt();

typedef struct boot_info
{
  unsigned char * vram;
  unsigned char color_mode;
  unsigned int xsize;
  unsigned int ysize;
}bootinfo;

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


#endif
