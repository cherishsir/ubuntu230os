#include<mm.h>
#include<screen.h>
#include<font.h>
 char keytable[0x54] = {
		0,   0,   '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '^', 0,   0,
		'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '@', '[', 0,   0,   'A', 'S',
		'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', ':', 0,   0,   ']', 'Z', 'X', 'C', 'V',
		'B', 'N', 'M', ',', '.', '/', 0,   '*', 0,   ' ', 0,   0,   0,   0,   0,   0,
		0,   0,   0,   0,   0,   0,   0,   '7', '8', '9', '-', '4', '5', '6', '+', '1',
		'2', '3', '0', '.'
	};
struct boot_info *gboot;

void clear_screen(char color) //15:pure white
{
  int i;
  unsigned xsize=gboot->xsize;
  unsigned ysize=gboot->ysize;
  for(i=gboot->vram;i<gboot->vram+xsize*ysize;i++)
  {
   write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  }
}
void init_screen(struct boot_info * bootp)
{
  bootp->vram=(char *)VRAM;
  bootp->color_mode=8;
  bootp->xsize=320;
  bootp->ysize=200;
  bootp->xsize=640;
  bootp->ysize=480;

}

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  unsigned xsize=gboot->xsize;
  unsigned ysize=gboot->ysize;

  for(i=gboot->vram;i<gboot->vram+xsize*ysize;i++)
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
  boxfill8(gboot->vram,gboot->xsize,color,x0,y0,x1,y1);
}


void draw_win_buf(unsigned char *p)
{

  int x=gboot->xsize,y=gboot->ysize;
    //p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill8(p,gboot->xsize,DGRAY ,0, 0   ,x-1,y-29);
//task button
    boxfill8(p,gboot->xsize,8  ,0, y-28,x-1,y-28);
    boxfill8(p,gboot->xsize,7  ,0, y-27,x-1,y-27);
    boxfill8(p,gboot->xsize,8  ,0, y-26,x-1,y-1);


//left button
    boxfill8(p,gboot->xsize,7, 3,  y-24, 59,  y-24);
    boxfill8(p,gboot->xsize,7, 2,  y-24, 2 ,  y-4);
    boxfill8(p,gboot->xsize,15, 3,  y-4,  59,  y-4);
    boxfill8(p,gboot->xsize,15, 59, y-23, 59,  y-5);
    boxfill8(p,gboot->xsize,0, 2,  y-3,  59,  y-3);
    boxfill8(p,gboot->xsize,0, 60, y-24, 60,  y-3);

//
//right button
    boxfill8(p,gboot->xsize,15, x-47, y-24,x-4,y-24);
    boxfill8(p,gboot->xsize,15, x-47, y-23,x-47,y-4);
    boxfill8(p,gboot->xsize,7, x-47, y-3,x-4,y-3);
    boxfill8(p,gboot->xsize,7, x-3, y-24,x-3,y-3);
}
void draw_window()
{
  unsigned char *p;
  int x=gboot->xsize,y=gboot->ysize;
    p=gboot->vram;
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


///关于mouse的函数
void init_mouse_pic(char *mouse,char bg)
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
	boxfill8(buf, xsize, 7, 8,         ysize - 26, xsize - 8, ysize - 8);

	boxfill8(buf, xsize, DGRAY, 8,     ysize - 28, xsize - 8, ysize - 26);

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
  boxfill8(sht->buf,sht->bxsize,backcolor, x,y,x+length*8-1,y+15+1);
  puts8(sht->buf ,sht->bxsize,x,y,fontcolor,s);
  sheet_refresh(sht,x,y,x+length*8-1,y+15+1);
}

void wrtrfrsh16(SHEET * sht,int x,int y,unsigned char fontcolor,unsigned backcolor,char *s,int length)
{
  boxfill8(sht->buf,sht->bxsize,backcolor, x,y,x+length*16-1,y+24);
  puts16(sht->buf ,sht->bxsize,x,y,fontcolor,s);
  sheet_refresh(sht,x,y,x+length*16-1,y+24);
}


void printdebug(unsigned int i,unsigned int x)
{
char font[30];
sprintf(font,"Debug:var=%x" ,i);
boxfill(7,x,gboot->ysize-20,x+15*8,gboot->ysize-20+16);
puts8(gboot->vram ,gboot->xsize,x,gboot->ysize-20,1,font);

}

void itoa(int value,unsigned char *buf){
   unsigned char tmp_buf[10] = {0};
    unsigned char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
        value = ~value + 1; //将负数变为正数
    }



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
        value /= 10;
    }while(value);


    while(tmp_buf != tbp)
    {
      tbp--;
      *buf++ = *tbp;

    }
    *buf='\0';


}
static  inline unsigned char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
   unsigned char tmp_buf[30] = {0};
   unsigned char *tbp = tmp_buf;

    *buf++='0';
    *buf++='x';

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);


    while(tmp_buf != tbp)
    {
      tbp--;
      *buf++ = *tbp;

    }
    *buf='\0';


}




//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf( char *str, char *format ,...)
{

   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
    char buffer[10];
    char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
      {
	*str++=*format++;
	continue;
      }
      else
      {
	format++;
	switch (*format)
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
	format++;

      }

  }
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color, char *font)//x=0 311 y=0 183
{

 while(*font)
 {
    if(*font=='\n')
    {
      x=0;
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
    x+=8;
    if(x>xsize)
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
	    y=0;

	  }
        }
    }

    font++;
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
      {
	vram[(y+row)*xsize+x+col]=color;

      }
      else
	;
	//vram[(y+row)*xsize+x+col]=15;//for debug

    }

  }
  return;

}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
      y=y+24;

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
	x=x+16;


    }

     font++;

  }

}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;

      }
      else
	;
	//vram[(y+row)*xsize+x+col]=15;//for debug

    }

  }
  return;

}


