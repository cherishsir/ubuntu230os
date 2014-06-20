#include<head.h>
#include<x86.h>
#include<font.h>
void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
*(char*)i=color;
  //write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  *(char *)i=i;
 // write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

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

  io_cli(); // disable interrupt
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
//xsize=320,pxsize=16,pysize=16,  px0,py0是postion
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



void putchar(unsigned char ch,char color,unsigned int px,unsigned int py)
{
unsigned char temp=1;
unsigned char pt;
unsigned int x,y;
for (y=0;y<16;y++)
{
//char *font=Font8x16;
pt =Font8x16[y+ch*16];
 // pt=font[y+ch*16];
    for (x=0;x<8;x++)
    {

        temp=1<<(7-x);
        if((pt&temp)!=0)
        *((char*)(VRAM+x+px+(y+py)*320))=color;
        else
        *((char*)(VRAM+x+px+(y+py)*320))=0;

    }
}
}


void puts(unsigned char *str,char color,unsigned int x,unsigned int y)
{
while(*str)
{
x=x+8;
putchar(*str++,color,x,y);
}
}

/*简单sprintf 的实现*/
void sprintf(char *des,const char *str,...)
{
 char *arguemnt=&str+1;//这里要注意 ，&str === 0x0时  &str=1 ==0x4了。 所以是下一个参数的地址。

// char **pt=0xff1;
// *pt=&str;
 //pt++;
 //*pt=&str+1;

 int  i;
 while(*str)
 {

  if(*str=='%')
   {
    str++;
      switch (*str)
      {
      case '%':*des++='%';str++;break;
      case 'd':i=int2str(*(int *)arguemnt,des);arguemnt+=4;str++;des+=i;break;
     // case 'x':
     // case 'c':
      default:break;
      }
   }
   else
   {
     *des++=*str++;
   }

  }
}

int int2str(int  number,char * s)
{
//1234
int little;
char temp[20];
int bits;
int i=0;
 do
 {
  little=number%10;
  temp[i]=(char)little+0x30;
  i++;
 }while(number=number/10);
bits=i;
i--;
//4321

for(;i>=0;i--)
{
*s++=temp[i];
}
return bits;

}
