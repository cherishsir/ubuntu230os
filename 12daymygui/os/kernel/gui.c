#include<header.h>
#include<gui.h>
void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
    0x00,0x00,0x00,   /*0:black*/
    0xff,0x00,0x00,   /*1:light red*/
    0x00,0xff,0x00,   /*2:light green*/
    0xff,0xff,0x00,   /*3:light yellow*/

    0x00,0x00,0xff,   /*4:light blue*/
    0xff,0x00,0xff,   /*5:light purper*/
    0x00,0xff,0xff,   /*6:light blue*/
    0xff,0xff,0xff,   /*7:white*/

    0xc6,0xc6,0xc6,   /*8:light gray*/
    0x84,0x00,0x00,   /*9:dark red*/
    0x00,0x84,0x00,   /*10:dark green*/
    0x84,0x84,0x00,   /*11:dark yellow*/

    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  int i,eflag;
  eflag=read_eflags();   //记录从前的cpsr值

  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
    outb(0x03c9,*(rgb+1)/4);
    outb(0x03c9,*(rgb+2)/4);
    rgb=rgb+3;
  }

write_eflags(eflag);  //恢复从前的cpsr
  return;

}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
   {
      vram[y*xsize+x]=color;
   }
 }

}
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
}


void draw_win_buf(unsigned char *p)
{

  int x=320,y=200;
    //p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill8(p,320,7 ,0, 0   ,x-1,y-29);
//task button
    boxfill8(p,320,8  ,0, y-28,x-1,y-28);
    boxfill8(p,320,7  ,0, y-27,x-1,y-27);
    boxfill8(p,320,8  ,0, y-26,x-1,y-1);


//left button
    boxfill8(p,320,7, 3,  y-24, 59,  y-24);
    boxfill8(p,320,7, 2,  y-24, 2 ,  y-4);
    boxfill8(p,320,15, 3,  y-4,  59,  y-4);
    boxfill8(p,320,15, 59, y-23, 59,  y-5);
    boxfill8(p,320,0, 2,  y-3,  59,  y-3);
    boxfill8(p,320,0, 60, y-24, 60,  y-3);

//
//right button
    boxfill8(p,320,15, x-47, y-24,x-4,y-24);
    boxfill8(p,320,15, x-47, y-23,x-47,y-4);
    boxfill8(p,320,7, x-47, y-3,x-4,y-3);
    boxfill8(p,320,7, x-3, y-24,x-3,y-3);
}
void draw_window()
{
  unsigned char *p;
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
//task button
    boxfill(8  ,0, y-28,x-1,y-28);
    boxfill(7  ,0, y-27,x-1,y-27);
    boxfill(8  ,0, y-26,x-1,y-1);


//left button
    boxfill(7, 3,  y-24, 59,  y-24);
    boxfill(7, 2,  y-24, 2 ,  y-4);
    boxfill(15, 3,  y-4,  59,  y-4);
    boxfill(15, 59, y-23, 59,  y-5);
    boxfill(0, 2,  y-3,  59,  y-3);
    boxfill(0, 60, y-24, 60,  y-3);

//
//right button
    boxfill(15, x-47, y-24,x-4,y-24);
    boxfill(15, x-47, y-23,x-47,y-4);
    boxfill(7, x-47, y-3,x-4,y-3);
    boxfill(7, x-3, y-24,x-3,y-3);
}


void init_screen(struct boot_info * bootp)
{
  bootp->vram=(char *)VRAM;
  bootp->color_mode=8;
  bootp->xsize=320;
  bootp->ysize=200;

}

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
#define background 7
#define outline    0
#define inside     2

 const static char cursor[16][16] = {
		"**************..",
		"*OOOOOOOOOOO*...",
		"*OOOOOOOOOO*....",
		"*OOOOOOOOO*.....",
		"*OOOOOOOO*......",
		"*OOOOOOO*.......",
		"*OOOOOOO*.......",
		"*OOOOOOOO*......",
		"*OOOO**OOO*.....",
		"*OOO*..*OOO*....",
		"*OO*....*OOO*...",
		"*O*......*OOO*..",
		"**........*OOO*.",
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside

	    }

	  }

	}

}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }

}

/*       value       color
	   0         black
	   10        light green
	   20	     dark gray
	   30        white
	   40        red
	   50	     a litter dark green
	   60        pink red
	   70        yello+green
	   80        purper
	   90        orange
	   100       light blue
	   110       dark red
	   120       dark green
	   130	     dark purper
	   140       dark orange
	   150	     dark blue
	   160       dark red+gray
	   170       dark green+gray
	   180	     dark zhu red


*/

void make_window8(unsigned char *buf,int xsize,int ysize,char *title)
{
static char closebtn[14][16] = {
		"OOOOOOOOOOOOOOO@",
		"OQQQQQQQQQQQQQ$@",
		"OQQQQQQQQQQQQQ$@",
		"OQQQ@@QQQQ@@QQ$@",
		"OQQQQ@@QQ@@QQQ$@",
		"OQQQQQ@@@@QQQQ$@",
		"OQQQQQQ@@QQQQQ$@",
		"OQQQQQ@@@@QQQQ$@",
		"OQQQQ@@QQ@@QQQ$@",
		"OQQQ@@QQQQ@@QQ$@",
		"OQQQQQQQQQQQQQ$@",
		"OQQQQQQQQQQQQQ$@",
		"O$$$$$$$$$$$$$$@",
		"@@@@@@@@@@@@@@@@"
	};

	int x,y;
	char c;
    boxfill8(buf, xsize, 8, 0,         0,         xsize - 1, 0        );
	boxfill8(buf, xsize, 7, 1,         1,         xsize - 2, 1        );
	boxfill8(buf, xsize, 8, 0,         0,         0,         ysize - 1);
	boxfill8(buf, xsize, 7, 1,         1,         1,         ysize - 2);
	boxfill8(buf, xsize, 15, xsize - 2, 1,         xsize - 2, ysize - 2);
	boxfill8(buf, xsize, 0, xsize - 1, 0,         xsize - 1, ysize - 1);
	boxfill8(buf, xsize, 8, 2,         2,         xsize - 3, ysize - 3);
	boxfill8(buf, xsize, 12, 3,         3,         xsize - 4, 20       );
	boxfill8(buf, xsize, 15, 1,         ysize - 2, xsize - 2, ysize - 2);
	boxfill8(buf, xsize, 0, 0,         ysize - 1, xsize - 1, ysize - 1);


 puts8(buf,xsize,24,4,7,title,Font8x16);
 //write the x button to the buf
 for(y=0;y<14;y++)
 {
    for(x=0;x<16;x++)
    {
        c=closebtn[y][x];
        if(c=='@')
        c=0;
        else if(c=='$')
        c=15;
        else if(c=='Q')
        c=8;
        else c=7;
    }
    buf[(5+y)*xsize+(xsize-21+x)]=c;


 }
 return;
}

//一个一个的反ucgui的函数实现

GUI_Content content;
void GUI_Init(char *Font)
{
 content.x=0;
 content.y=0;
 content.str=0;
 content.vram=VRAM;
 content.xsize=XSIZE;
 content.ysize=YSIZE;
 content.backcolor=BACKCOLOR;
 content.fontcolor=FONTCOLOR;
 content.Font=Font;
 content.mode=DEFAULTMODE;
 content.pensize=DEFAULTPENSIZE;
 content.drawcolor=DEFAULTDRAWCOLOR;

}
void GUI_SetTextMode(unsigned char textmode)
{
    content.mode=textmode;
}
void GUI_DispCharAt(char c,unsigned x,unsigned y)
{
  content.x=x;
  content.y=y;
  unsigned short *pt;
  pt=(unsigned short *)((c)*16+content.Font);
  putfont8(content.vram ,content.xsize,content.x,content.y,content.fontcolor,(char *)pt);
}
void GUI_DispCharAt0(char c,unsigned x,unsigned y,bool poschange)
{
  content.x=x;
  content.y=y;
  GUI_DispChar(c);
  if(poschange)content.x+=8;
}

void GUI_DispChar(char c)
{
  unsigned short *pt;
  pt=(unsigned short *)((c)*16+content.Font);
  unsigned char fontcolor=content.fontcolor;
  unsigned char backcolor;
  unsigned char xorflag=0;
  switch (content.mode)
  {
    case GUI_TEXTMODE_NORMAL:content.fontcolor=white;backcolor=black;break;
    case GUI_TEXTMODE_REVERSE:content.fontcolor=black;backcolor=white;break;
    case GUI_TEXTMODE_TRANSPARENT:content.fontcolor=white;backcolor=content.backcolor;break;
    case GUI_TEXTMODE_XOR:xorflag=1;break;
  }
  if(xorflag)
  {
    // GUI_FillRect(backcolor,content.x,content.y,content.x+8,content.y+16);
     putfont8xor(content.vram ,content.xsize,content.x,content.y,content.fontcolor,(char *)pt);
  }
  else
  {
      GUI_FillRect(backcolor,content.x,content.y,content.x+8,content.y+16);
      putfont8(content.vram ,content.xsize,content.x,content.y,content.fontcolor,(char *)pt);
  }
  content.fontcolor=fontcolor;
}
void GUI_SetVbuf(char *vbuf)
{
 content.vram=vbuf;
}

void GUI_DispChars(char c,unsigned int i)
{
  if(i<=0)return;
  do
  {
   GUI_DispChar(c);
   content.x+=8;
   if(content.x>content.xsize-7)
   {
     content.x=0;
     content.y+=16;
   }
  }while(--i);

}

void GUI_DispString(char *s)
{
 char *pt=s;
 while(*pt)
 {
  if(content.x>=content.xsize-7)
  {
    content.x=0;
    content.y+=16;
  }
   GUI_DispChar(*pt++);
   content.x+=8;
  }
}

void GUI_DispStringBW(char *s,bool isfontwhite)
{
 char *pt=s;
 char color;
 unsigned i=0;
 while(*pt++)i++;
 unsigned length=i*8;
 if(isfontwhite)
 {

 GUI_FillRect(black,content.x,content.y,content.x+length,content.y+16);
 color=content.fontcolor;
 content.fontcolor=white;
 GUI_DispString(s);
 content.fontcolor=color;
 }
 else
 {
 GUI_FillRect(white,content.x,content.y,content.x+length,content.y+16);
 content.fontcolor=black;
 GUI_DispString(s);
 content.fontcolor=color;
 }
}
void GUI_DispStringAt(char *s,unsigned x,unsigned y)
{
 gotoxy(x,y);
 GUI_DispString(s);
}

void gotoxy(unsigned x,unsigned y)
{
 gotox(x);
 gotoy(y);
}

void gotox(unsigned x)
{
 if(x>=content.xsize) return;
  content.x=x;
}

void gotoy(unsigned y)
{
 if(y>=content.ysize) return;
  content.y=y;
}


void GUI_DispStringAtCEOL(char *s,unsigned x,unsigned y)
{
 GUI_FillRect(content.backcolor,x,y,320,y+16);
 gotoxy(x,y);
 GUI_DispString(s);
}
void GUI_FillRect(unsigned char color,unsigned x0,unsigned y0,unsigned x1,unsigned y1)
{
  boxfill8(content.vram,content.xsize,color,x0,y0,x1,y1);
}

unsigned GUI_GetDispPosX()
{
  return content.x;
}

unsigned GUI_GetDispPosY()
{
  return content.y;
}

void GUI_Clear()
{
   unsigned int i;
   unsigned color=content.backcolor;
   GUI_FillRect(color,0,0,content.xsize,content.ysize);
}

void GUI_SetBackcolor(unsigned char color)
{
  content.backcolor=color;
}
void GUI_SetFontcolor(unsigned char color)
{
  content.fontcolor=color;
}

void GUI_DispCEOL()// 清楚当关坐标到行末尾的数据，使用backcolor
{
 unsigned x=content.x;
 unsigned y=content.y;
 GUI_FillRect(content.backcolor,x,y,320,y+16);
}


void GUI_DispDec(int i,unsigned length)
{
    char s[20];
    char *pt=s;
    sprintf(pt,"%d",i);
    while(length)
    {
        GUI_DispChar(*pt);
        content.x+=8;
        if(content.x>content.xsize-7)
        {
            content.x=0;
            content.y+=16;
        }
         pt++;
         if(*pt==0)
         break;
        length--;

    }
}

void GUI_DispDecAt(int i,unsigned length,unsigned x,unsigned y)
{
gotoxy(x,y);
GUI_DispDec(i,length);

}
void GUI_SetPoint(char * vram,unsigned xsize, char color,unsigned x,unsigned y)
{
  vram[x+y*xsize]=color;
}
void GUI_DrawHLine(unsigned char color,unsigned x0,unsigned x1,unsigned y)
{
unsigned x;
unsigned bold;
for(bold=y;bold<y+content.pensize;bold++)
for(x=x0;x<=x1;x++)
 GUI_SetPoint(content.vram,content.xsize,color, x, bold);

}

void GUI_DrawVLine(unsigned char color,unsigned x,unsigned y0,unsigned y1)
{
unsigned y;
for(y=y0;y<=y1;y++)
GUI_DrawHLine(color,x,x+content.pensize,y);
}
void GUI_DrawRect(unsigned char bordercolor,unsigned x0,unsigned y0,unsigned x1,unsigned y1)
{

   if(x0>x1)return;
   if(y0>y1)return;
   GUI_DrawHLine(bordercolor,x0,x1,y0);
   GUI_DrawHLine(bordercolor,x0,x1,y1);
   GUI_DrawVLine(bordercolor,x0,y0, y1);
   GUI_DrawVLine(bordercolor,x1,y0, y1);

}
void GUI_SetPensize(unsigned size)
{
 if(size==0 || size>100)
  size=2;
  content.pensize=size;
}

void GUI_DrawRectinside(unsigned char bordercolor,unsigned char insidecolor,unsigned x0,unsigned y0,unsigned x1,unsigned y1)
{
unsigned pensize=content.pensize;
GUI_DrawRect(bordercolor, x0, y0, x1, y1);
GUI_FillRect(insidecolor,x0+pensize,y0+pensize,x1-1,y1-1);
}

void GUI_ClearRect(unsigned x0,unsigned y0,unsigned x1,unsigned y1)
{
GUI_FillRect(content.backcolor,x0,y0,x1,y1);
}

void GUI_DrawLine(unsigned char color,unsigned x0,unsigned y0,unsigned x1,unsigned y1)
{
 unsigned char middlex,middley;
 GUI_SetPoint(content.vram,content.xsize,color,x0,y0);
 GUI_SetPoint(content.vram,content.xsize,color,x1,y1);
 if(x0>x1)return;
 if(y0>y1)return;
 middlex=(x0+x1)/2;
 middley=(y0+y1)/2;
 //GUI_DispChar('c');
 if(middlex==x0 || middley==y0 || middlex==x1 || middley==y1)
 {
  //GUI_DispDec(middlex,6);
  //GUI_DispDec(middley,6);
  return;
 }
 else
 {
 // GUI_DispDec(middlex,6);
  GUI_SetPoint(content.vram,content.xsize,color,middlex,middley);
  GUI_DrawLine(color,x0,y0,middlex, middley);
  GUI_DrawLine(color,middlex, middley,x1,y1);

 }



}

