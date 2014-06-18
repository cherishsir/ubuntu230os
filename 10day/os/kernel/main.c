
/**********************************************************************
关于刷新图层加速的部分没有实现，感觉没有太大的必要去理解学习这一部分，不是重点
 **********************************************************************/
#include<header.h>
#include<fontascii.h>

//需要用到的函数，halt,cli,out8,read_eflags,write_eflags,这些函数在x86.h中
//init _palette, set_palette 这两个函数我想放在screen.c中

#define black 0
#define red   1
#define green 2

void bootmain(void)
{

struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
  clear_screen(40);   	//red
  init_screen((struct boot_info * )bootp);
  init_palette();  //color table from 0 to 15
  //draw_window();

int mx,my;//mouse position
mx=30;
my=30;
//display mouse logo
char mousepic[16*16];     //mouse logo buffer
init_mouse(mousepic,99);	//7　means background color:white
//display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);
cli();

//set gdt idt
init_gdtidt();

//remap irq 0-15
init_pic();		//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
			//设置完了gdt,idt后再enable cpu interrupt才是安全的

unsigned char s[40];		//sprintf buffer
unsigned char keybuf[32];	//keyfifo
unsigned char mousebuf[128];	//mousefifo
unsigned char data;		//temp variable to get fifo data
int count=0;
fifo8_init(&keyfifo ,32,keybuf);//keyfifo是一个global data defined in int.c
fifo8_init(&mousefifo,128,mousebuf);


//enable keyboard and mouse
outb(PIC0_IMR, 0xf9);	//1111 1001  irq 1 2打开 因为keyboard是irq 1 /// enable pic slave and keyboard interrupt
outb(PIC1_IMR, 0xef);	//1110 1111  irq 12打开　mouse是irq 12  所以要把pic 1 pic 2的芯片中断响应位打开。 //enable mouse interrupt

//初始化　鼠标按键控制电路
init_keyboard();
sti();

//inthandler21();
//int addr=inthandler21;
//printdebug(addr,0);
//打印出int0x21处的idt值，主要看offset是否与　asm_inthandler21一样（看反汇编，可以看到地址）




//day8

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
//mem=mem>>20;
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *win=(unsigned char*)memman_alloc(memman,320*200);
draw_win_buf(win);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
,memman_avail(memman)>>20,memman->cellnum);
puts8(win ,bootp->xsize,0,100,0,s);

SHTCTL *shtctl;
SHEET *sht_back,*sht_mouse;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
sht_back=sheet_alloc(shtctl);
sht_mouse=sheet_alloc(shtctl);

sheet_setbuf(sht_back,win,320,200,99);
sheet_setbuf(sht_mouse,mousepic,16,16,99);

sheet_move(shtctl,sht_back,0,0);
mx=160;
my=100;
sheet_move(shtctl,sht_mouse,mx,my);
sheet_updown(shtctl,sht_back,0);
sheet_updown(shtctl,sht_mouse,1);
sheet_refresh(shtctl);







 while(1)
 {
   cli();//disable cpu interrupt

   if(fifo8_status(&keyfifo) +fifo8_status(&mousefifo) == 0)//no data in keyfifo and mousefifo
   {
   count=0;
    sti();
    hlt();
   }
   else
   {
      if(fifo8_status(&keyfifo) != 0)
      {
        data=fifo8_read(&keyfifo);
        sti();
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
      {
        data=fifo8_read(&mousefifo);
        sti();
        if(mouse_decode(&mdec,data))
        {
              //3个字节都得到了
              switch (mdec.button)
              {
                case 1:s[1]='L';break;
                case 2:s[3]='R';break;
                case 4:s[2]='M';break;
              }
              sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
              boxfill8(win,320,0,32,16,32+20*8-1,31);//一个黑色的小box
              puts8(win,bootp->xsize,32,16,7,s);//display e0
              sheet_refresh(shtctl,sht_back,32,16,32+20*8-1,31);
        #define white 7
               //because we use sheet layer ,so we do not need this any more
              //boxfill8(p,320,white,mx,my,mx+15,my+15);//用背景色把鼠标原来的color填充，这样不会看到鼠标移动的path
              mx +=mdec.x;//mx=mx+dx
              my +=mdec.y;//my=my+dy
              if(mx<0)
              {
                mx=0;
              }
              if(my<0)
              {
                my=0;
              }


              if(mx>bootp->xsize-16)
              {
                mx=bootp->xsize-16;
              }

              if(my>bootp->ysize-16)
              {
                my=bootp->ysize-16;
              }
              sprintf(s,"(%d, %d)",mx,my);
              boxfill8(win,320,0,0,0,79,15);//坐标的背景色
              puts8(win ,bootp->xsize,0,0,7,s);//显示坐标
              sheet_refresh(shtctl,sht_back,0,0,79,15);


              sheet_move(shtctl,sht_mouse,mx,my);



        }
      }

   }

 }
}













