#include<header.h>

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


 puts8(buf,xsize,24,4,7,title);
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

void wrtrfrsh(SHEET * sht,int x,int y,unsigned char fontcolor,unsigned backcolor,char *s,int length)
{
  boxfill8(sht->buf,sht->bxsize,backcolor, x,y,x+length*8-1,y+15);
  puts8(sht->buf ,sht->bxsize,x,y,fontcolor,s);
  sheet_refresh(sht,x,y,x+length*8-1,y+15);
}

