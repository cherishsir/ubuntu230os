#ifndef __screen_h_
#define __screen_h_
#define write_mem8(addr,data8)   (*(volatile char *)(addr))=(char)data8
#define BLACK           0
#define WHITE           7


#define VRAM            (0XA0000)
#define ADDR_BOOT       0X00000FF0
//just used in main
struct boot_info
{
  char cylinder,led,color_mode;
  char reserved;
  short xsize;
  short ysize;
  char *vram;
};





extern void puts8(char *vram ,int xsize,int x,int y,char color,char *font);//x=0 311 y=0 183
extern void putfont8(char *vram ,int xsize,int x,int y,char color,char *font);
extern void puts16(char *vram ,int xsize,int x,int y,char color,char *font);
extern void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font);
extern void sprintf( char *str, char *format ,...);
extern void printdebug(unsigned int i,unsigned int x);

extern void draw_win_buf(unsigned char *p);
extern void init_screen(struct boot_info * bootp);
extern void clear_screen(char color) ; //color=15 pure white color=40 red
extern void color_screen(char color) ;
extern void init_palette(void);//用现成的table_rgb来初始化调色板
extern void set_palette(int start,int end, unsigned char *rgb);
extern void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1);
extern void boxfill(unsigned char color,int x0,int y0,int x1,int y1);
extern void draw_window();
extern void init_mouse_pic(char *mouse,char bg);
extern void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize);

extern void wrtrfrsh(SHEET * sht,int x,int y,unsigned char fontcolor,unsigned backcolor,char *s,int length);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#endif // __screen_h_
