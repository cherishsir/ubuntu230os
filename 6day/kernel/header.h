#ifndef header
#define header

#include<x86.h>
#include<font.h>
#define io_halt() asm("hlt")
#define write_mem8(addr,data8)   (*(volatile char *)(addr))=(char)data8
#define io_cli()  asm("cli")
#define io_sti()  asm("sti")
#define io_stihlt() (io_cli();io_halt;)

#define BLACK 0
#define VRAM (0XA0000)
#define ADDR_BOOT 0X00000FF0

//below:about pic ,mouse and keyboard pic master is pic 1:port 0x20 0x21 ,pic slave is pic 2:port 0xa0 0xa1
#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021
#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1


struct boot_info
{
  
  char cylinder,led,color_mode;
  char reserved;
  short xsize;
  short ysize;
  char *vram;
};
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


extern void puts8(char *vram ,int xsize,int x,int y,char color,char *font);//x=0 311 y=0 183
extern void putfont8(char *vram ,int xsize,int x,int y,char color,char *font);

extern void puts16(char *vram ,int xsize,int x,int y,char color,char *font);
extern void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font);
extern void init_screen(struct boot_info * bootp);
extern void clear_screen(char color) ; //color=15 pure white color=40 red
extern void color_screen(char color) ;
extern void init_palette(void);//用现成的table_rgb来初始化调色板
extern void set_palette(int start,int end, unsigned char *rgb);
extern void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1);
extern void boxfill(unsigned char color,int x0,int y0,int x1,int y1);
extern void draw_window();
extern void init_mouse(char *mouse,char bg);
extern void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize);
////////////////////////////////////////////////////////////////////
extern void sprintf(char *str,char *format ,...);
extern void printdebug(int i,int x);

extern void  init_gdtidt();
//extern void setidt(struct IDT *gd,int offset,int selector,int access);//gd: gate describe
extern void init_pic();
extern void PIC_remap(int offset1, int offset2);
extern void irq_remap(void);
//extern void asm_int21();

extern void load_gdtr(int limit, int addr);//it works
extern void load_idtr(int limit, int addr);//it works

extern void inthandler21(int *esp);

extern void asm_inthandler21();

extern void setgdt(struct GDT *sd ,unsigned int limit,int base,int access);//sd: selector describe
//extern static void load_gdtr(int limit, int addr);

#endif