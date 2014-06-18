#ifndef _GUI_H
#define _GUI_H
typedef struct GUI_Content
{
 unsigned int x;
 unsigned int y;
 char * str;
 char *vram;
 unsigned xsize;
 unsigned ysize;
 unsigned char backcolor;
 unsigned char fontcolor;
 char *Font;
 unsigned char mode;
 unsigned pensize;
 unsigned drawcolor;
}GUI_Content;


#define     VRAM         0XA0000
#define     XSIZE        320
#define     YSIZE        200
#define     FONTCOLOR    0
#define     BACKCOLOR    7
#define     DEFAULTMODE  GUI_TEXTMODE_NORMAL
#define     DEFAULTPENSIZE 5
#define     DEFAULTDRAWCOLOR white
#define     white        7
#define     black        0
#define     blue         4


//use textcolor=font  backcolor=backbolor
#define     GUI_TEXTMODE_NORMAL      0

#define     GUI_TEXTMODE_REVERSE     1
#define     GUI_TEXTMODE_TRANSPARENT 2
#define     GUI_TEXTMODE_XOR         4






extern void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1);
extern void boxfill(unsigned char color,int x0,int y0,int x1,int y1);
extern void clear_screen(char color) ; //color=15 pure white color=40 red
extern void color_screen(char color) ;
extern void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize);
extern void draw_win_buf(unsigned char *p);
extern void draw_window();
extern void init_palette(void);//用现成的table_rgb来初始化调色板
extern void init_mouse(char *mouse,char bg);
extern void set_palette(int start,int end, unsigned char *rgb);
extern void make_window8(unsigned char *buf,int xsize,int ysize,char *title);
/*about string*/
extern void puts8(char *vram ,int xsize,int x,int y,char color,unsigned char *font,char *Font);//x=0 311 y=0 183
extern void putfont8(char *vram ,int xsize,int x,int y,char color,char *font);
extern void putfont8xor(char *vram ,int xsize,int x,int y,char color,char *font);//x=0 311 y=0 183
extern void puts16(char *vram ,int xsize,int x,int y,char color,char *font,char *Font);
extern void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font);
extern void sprintf( char *str, char *format ,...);




// 模仿ucgui写一个好用的gui库
extern void GUI_Init(char *Font);
extern void GUI_DispCharAt(char c,unsigned x,unsigned y);
extern void GUI_DispChar(char c);
extern void GUI_SetVbuf(char *vbuf); //这个函数用来指定vide的另一个buf，不是直接指向显存
extern void GUI_DispChars(char c,unsigned int i);

extern void gotoxy(unsigned x,unsigned y);
extern void gotox(unsigned x);
extern void gotoy(unsigned y);

extern void GUI_DispStringAt(char *s,unsigned x,unsigned y);
extern void GUI_DispString(char *s);
extern unsigned GUI_GetDispPosX();
extern unsigned GUI_GetDispPosY();

extern void GUI_FillRect(unsigned char color,unsigned x0,unsigned y0,unsigned x1,unsigned y1);
extern void GUI_Clear();// use backcolor to clearn screen
extern void GUI_SetBackcolor(unsigned char color);
extern void GUI_SetFontcolor(unsigned char color);
extern void GUI_DispCEOL();// 清楚当关坐标到行末尾的数据，使用backcolor
#endif

//content 里面应该还要包含活哪些层是活动层的信息。是活动层才需要刷新，刷新的机制以后再思考，可以尝试使用update的方式

