
/**********************************************************************
关于刷新图层加速的部分没有实现，感觉没有太大的必要去理解学习这一部分，不是重点
 **********************************************************************/
#include<header.h>

//需要用到的函数，halt,cli,out8,read_eflags,write_eflags,这些函数在x86.h中
//init _palette, set_palette 这两个函数我想放在screen.c中

void bootmain(void)
{

struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
gboot=bootp;
//所有中断中读到数据都保存到下面的fifo
struct FIFO32 fifo;
unsigned fifobuf[132];
init_palette();  //color table from 0 to 15
//clear_screen(3);   	//red

int mx,my;//mouse position
cli();
//set gdt idt
init_gdtidt();
//remap irq 0-15
//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
init_pic();
//设置完了gdt,idt后再enable cpu interrupt才是安全的
unsigned char s[40];		     //sprintf buffer
unsigned  data;		             //data=fifo data

fifo32_init(&fifo ,128,fifobuf);//keyfifo是一个global data defined in int.c
//初始化　鼠标按键控制电路
init_keyboard(&fifo,256);

//enable timer ,keyboard and mouse   //1111 1000 后面的三个0代表 accept interrupt request, irq0=timer interrupt
outb(PIC0_IMR, 0xf8);//1111 1000  irq 1 2打开 因为keyboard是irq 1,irq2 enable 8259B 芯片发生的中断请求                                 // enable pic slave and keyboard interrupt
//enable mouse interrupt 1110 1111  irq 12 打开　mouse是irq 12  所以要把pic 1 pic 2的芯片中断响应位打开。
outb(PIC1_IMR, 0xef);

unsigned int memtotal;
//get the total memory
memtotal=memtest(0x400000,0xffffffff);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *desktop=(char*)memman_alloc(memman,bootp->xsize*bootp->ysize);
char *mousepic=(char*)memman_alloc(memman,16*16);
//char mousepic[16*16];
init_mouse_pic(mousepic,99);	//99　means background color
//display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);
//printdebug(desktop,0);
//while(1);
char *win_buf=( char*)memman_alloc_4K(memman,160*65);
TIMERCTL * timerctl=(TIMERCTL *)memman_alloc_4K(memman,sizeof(TIMERCTL));
gtimerctl=timerctl;
init_pit(timerctl);//init timerctl

TIMER *timer,*timer2,*timer3;

timer=timer_alloc(timerctl,0);
timer2=timer_alloc(timerctl,1);
timer3=timer_alloc(timerctl,2);

timer_init(timer,&fifo,10);//data set
timer_init(timer2,&fifo,3);//data set
timer_init(timer3,&fifo,1);//data set

timer_settime(timer,1000,timerctl);
timer_settime(timer2,300,timerctl);
timer_settime(timer3,50,timerctl);

make_window8(win_buf,160,68,"window");
//显示内存使用情况


//从内存中分配出shtctl的管理空间
SHTCTL *shtctl;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
sht_mouse=sheet_alloc(shtctl);
sht_win=sheet_alloc(shtctl);

sheet_setbuf(sht_back,desktop,bootp->xsize,bootp->ysize,-1);
sheet_setbuf(sht_mouse,mousepic,16,16,99);
sheet_setbuf(sht_win,win_buf,160,65,-1);
mx=200;my=100;//set mouse initial position
sheet_move(sht_back,0,0);
sheet_move(sht_mouse,mx,my);
sheet_move(sht_win,gboot->xsize/2,gboot->ysize/2);

//set sht_back to layer0 ;set sht_mouse to layer1
sheet_updown(sht_back,0);
sheet_updown(sht_win,1);
sheet_updown(sht_mouse,2);
//refresh a specific rectangle
//sheet_refresh(sht_back,0,0,bootp->xsize,bootp->ysize);
struct MOUSE_DEC mdec;
enable_mouse(&fifo,512,&mdec);   //这里会产生一个mouse interrupt


GUI_Init();
draw_win_buf(desktop);

GUI_SetFont(&GUI_Font8x16);

GUI_SetBkColorIndex(2);
GUI_SetColorIndex(2);
GUI_SetTextStyle(GUI_TS_NORMAL);//GUI_TS_NORMAL GUI_TS_UNDERLINE GUI_TS_STRIKETHRU


unsigned yn,xn,base;

base=100;
for(yn=0;yn<4;yn++)
{
 for(xn=0;xn<6;xn++)
 {
  GUI_SetColorIndex(15-xn);
  GUI_DrawCircle(xn*50+25+base,yn*50+25+base,25);
  GUI_SetColorIndex(xn);
  GUI_FillCircle(xn*50+25+base,yn*50+25+base,25);
  GUI_SetColorIndex(xn+1);
  GUI_FillCircle(xn*50+25+base,yn*50+25+base,20);
 }
}
    GUI_DispCharAt('b',150,0);
    GUI_Context.DispPosX = 400;
    GUI_Context.DispPosY = 400;
    GUI_DispString("hello worldxxxxxxxxxxxxxxxxx");
    GUI_SetColorIndex(0);
    GUI_SetPenSize(3);
    sheet_refresh(sht_back,0,0,bootp->xsize,bootp->ysize);
    GUI_Context.TextMode=0;
    GUI_SetBkColorIndex(0);
    GUI_SetColorIndex(7);
    GUI_GotoXY(400,100);
    GUI_DispString("xsize:");
    GUI_DispDecMin(gboot->xsize);
    GUI_DispString(" ysize:");
    GUI_DispDecMin(gboot->ysize);
    GUI_DispString(" VRAM:");
    GUI_DispHex(gboot->vram,8);
sheet_refresh(sht_back,400,90,gboot->xsize,100+16);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20,memman_avail(memman)>>20,memman->cellnum);
wrtrfrsh(sht_back,0,400,WHITE,BLACK,s,30);

wrtrfrsh16(sht_back,0,424,WHITE,BLACK,s,27);
unsigned count=0;
struct Cursor cursor;
cursor.cx=12;
cursor.cy=44;
cursor.cheight=16;
cursor.cwidth=8;
while(1)
 {
   count++;
    sprintf(s,"%d ",timerctl->count);
    wrtrfrsh(sht_win,18,24,BLACK,WHITE,s,7);

   sti();
   if(fifo32_status(&fifo)== 0)//no data in fifo
    {

   // hlt();//wait for interrupt
   }
   else
   {
     data=fifo32_read(&fifo);
     sti();
     if(data>=256 && data<=511) //keyboard data
     {
        sprintf(s,"%x ",data-256);
        wrtrfrsh(sht_back,100,0,7,0,s,7);//按下松手都会产生中断
        //判断data是否在可显示的范围内
        if(data<256+0x54&& cursor.cx<140)
        {
            if(keytable[data-256]!=0)
            {
              s[0]=keytable[data-256];
              s[1]=0;
              wrtrfrsh(sht_win,cursor.cx,cursor.cy,BLACK,WHITE,s,2);//做一个键位对应的数组？？
              cursor.cx+=8;

            }

        }
        if(data==256+0x0e && cursor.cx>19)
        {
         wrtrfrsh(sht_win,cursor.cx,cursor.cy,WHITE,WHITE,"  ",2);//做一个键位对应的数组？？
         cursor.cx-=8;
        }

     }
     else if(data>=512 && data<=512+255)//mouse data
     {
      if(mouse_decode(&mdec,data-512))
        {
              //3个字节都得到了
             sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);//dx,dy
              switch (mdec.button) //根据mdec的button属性重写lmr
              {
                case 1:s[1]='L';break;
                case 2:s[3]='R';break;
                case 4:s[2]='M';break;
              }
              wrtrfrsh(sht_back,32,16,0,7,s,10);
              mx +=mdec.x;//mx=mx+dx
              my +=mdec.y;//my=my+dy
              if(mx<0)mx=0;
              if(my<0)my=0;

              if(mx>bootp->xsize-1)
              {
                mx=bootp->xsize-1;
              }
              if(my>bootp->ysize-1)
              {
                my=bootp->ysize-1;
              }
              sprintf(s,"(%d, %d)",mx,my);//the position of mouse
              wrtrfrsh(sht_back,0,0,0,7,s,10);
              sheet_move(sht_mouse,mx,my);
        }
      }//end of mouse decoder
      else if(data==10)//10s
      {
            puts8(desktop ,bootp->xsize,0,64,0,"10[sec]");//显示坐标
            sheet_refresh(sht_back,0,64,bootp->xsize,80);
            sprintf(s,"%d",count);//6363
            wrtrfrsh(sht_back,200,0,0,6,s,10);
      }
      else if(data==3)
      {
            puts8(desktop ,bootp->xsize,0,80,0,"3[sec]");//显示坐标
            sheet_refresh(sht_back,0,80,bootp->xsize,96);
            count=0;
      }
      else//50ms
      {
             if(data!=0)
             {
                    timer_init(timer3,&fifo,0);//write data
                    boxfill8(sht_win->buf,sht_win->bxsize,7,cursor.cx,cursor.cy,cursor.cx+cursor.cwidth,cursor.cy+cursor.cheight);


             }
             else
             {

                    timer_init(timer3,&fifo,1);//50ms
                    boxfill8(sht_win->buf,sht_win->bxsize,0,cursor.cx,cursor.cy,cursor.cx+cursor.cwidth,cursor.cy+cursor.cheight);


             }
                timer_settime(timer3,50,timerctl);
                sheet_refresh(sht_win,cursor.cx,cursor.cy,cursor.cx+cursor.cwidth,cursor.cy+cursor.cheight);
                sheet_refresh(sht_back,250,100,320,108);
     }

     }


   }
}













