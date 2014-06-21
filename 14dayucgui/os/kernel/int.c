#include<int.h>


struct FIFO32 *keyfifo;//a global data
unsigned keydata;
struct FIFO32 *mousefifo;
unsigned mousedata;

//keyboard的中断服务程序。
void inthandler21(int *esp)
{
  //struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  unsigned  data;
  outb(PIC0_OCW2,0X61);//0X61-->PIC0_OCW2 　告之pic0这个芯片，irq1中断(就是keyboard产生的中断)cpu已经处理，这样pic0才会响应　下一次的irq1中断
  //如果不告之pic0已经处理了这次中断，pico对已后的irq1中断就会响应了。这种cpu处理完了中断，对pic0的反馈机制是非常好的，不会漏掉任何数据。
  data=inb(PORT_KEYDAT);
  fifo32_write(keyfifo,data+keydata);
  return;

}
// 鼠标的中断服务程序
void inthandler2c(int *esp)//可以看到一运行enable_后就，就产生了中断，进入了这个中断服务函数。
{

  unsigned  data;
  outb(PIC1_OCW2,0X64);//cpu tell pic1　that I got IRQ12
  outb(PIC0_OCW2,0X62);//cpu tell pic0  that I got IRQ2
  data = inb(PORT_KEYDAT);
  fifo32_write(mousefifo,data+mousedata);
}
/**************************************************************************/
//wait keyboard is read for work
void wait_KBC_sendready(void)				//send ready and wait keyboard control ready
{
  while(1)
  {
    /*等待按键控制电路准备完毕*/
    if( (inb(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0)	//读port 0x0064 看bit1是否是为０/if 0 ready ,if 1 not ready　
    {							//bit 1是０说明键盘控制电路是准备好的，可以接受cpu的指令了。
      break;
    }
  }

}

//init keyboard
void init_keyboard(struct FIFO32 *fifo,unsigned data)
{


  keyfifo=fifo;
  keydata=data;
  /*这里才是真正的初始化按键电路*/
  wait_KBC_sendready();				//wait ready
  outb(PORT_KEYCMD,KEYCMD_WRITE_MODE);		//向port 0x0064写　0x60
  wait_KBC_sendready();				//保证能写入有效的数据到　port 0x0064
  outb(PORT_KEYDAT,KBC_MODE);			//向port 0x0060 写数据0x47
  return;
}


//中断号remap irq0-irq15到int 0x20到int 0x2f
void init_pic()
{
  outb(PIC0_IMR, 0xff);
  outb(PIC1_IMR, 0xff);//向port 0x21 ,0xa1写0xff　　禁止所有的irq中断
  //对master pic进行设置
  outb(PIC0_ICW1, 0x11);//设置产生中断的方式为边沿触发　　　							0x20
  outb(PIC0_ICW2, 0x20);//设置中断号的基地址，原来是irq 0x0到0x7,现在基地址是0x20，所以中断号变为int20到int27     0x21
  outb(PIC0_ICW3, 1<<2);//对master pic的bit2进行写１操作，设置slave pic由irq2连接				0x21
  outb(PIC0_ICW4, 0x01);// no buffer mode								0x21

  outb(PIC1_ICW1,  0x11);//edge trigger mode
  outb(PIC1_ICW2,  0x28);//设置中断号的基地址，中断号变为int28 int0x2f 接收
  outb(PIC1_ICW3,  2   );//pic0 bit2
  outb(PIC1_ICW4,  0x01);//no buffer mode

  outb(PIC0_IMR,  0xfb);//1111 1011 打开pic1的中断请求位 port 0x21
  outb(PIC1_IMR,  0xff);//禁止pic１芯片的所有请求　　port 0xa1
    return;
}

void enable_mouse(struct FIFO32 *fifo,unsigned data,struct MOUSE_DEC *mdec)
{
  mousefifo=fifo;
  mousedata=data;

  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  outb(PORT_KEYCMD,KEYCMD_SENDTO_MOUSE);//向port 0x0064　写　0XD4命令  下面的命令发给mouse
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  outb(PORT_KEYDAT,MOUSECMD_ENABLE); 	//向port 0x0060　写　0Xf4命令  给mouse发送enable命令
  mdec->phase=0;
  return ; 				//if sucessful ,will create an interrupt ,and return ０xfa(ACK),产生的这个0xfa是给cpu的答复信号
					//就算鼠标不动，也会产生这个中断，所以我们一调用enable_mouse，就会产生鼠标中断，必须有这个服务函数。
}


//通过data的不同，来确定发生的中断是 三次中的哪一次
int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  if(mdec->phase==0)//第一次开按键中断
  {
    if(data==0xfa)
    {
      mdec->phase = 1;

    }
    return 0;
  }
  else if(mdec->phase==1)
  {
    //鼠标的第一字节的数据
    if( (data & 0xc8) == 0x08 )//如果第一个字节的数据正确  ,只要第一个字节的数据是正确的，后面两个phase的数据就是关于左移 和右移的数据
    {
    mdec->buf[0] = data; //发生三中断，第一次是关于鼠标 按键的中断
    mdec->phase  = 2;
    return 0;
    }
  }
  else if(mdec->phase==2)
  {
    mdec->buf[1] = data;  //第二次中断是保存 dx的大小
    mdec->phase  = 3;
    return 0;
  }
  else if(mdec->phase==3)
  {
    mdec->buf[2] = data;  //第三次中断是保存 dy的大小
    mdec->phase  = 1;//从1开始，下一次的鼠标的三个数据


    mdec->button =mdec->buf[0] & 0x07;//只取buf[0]的低3位， ，1,2,4 分别对应鼠标的LRM
    mdec->x =mdec->buf[1];  //这里面放的两个方向的dx dy信息
    mdec->y =mdec->buf[2];

    //why do this
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1 说明鼠标有x方向的移动
    {
      mdec->x |=0xffffff00;//-x 根据buf[0]的bit4为1时，确定鼠标的移动方向是负方向。
    }
    if( (mdec->buf[0] & 0x20) != 0)//bit5为1时 2 说明鼠标有y方向的移动，
    {
      mdec->y |=0xffffff00;//-y
    }

    mdec->y= - mdec->y;//鼠标的移动方向与屏幕的方向是相反的。


    return 1;
  }
  //buf0中的数据非常的重要，低四位与左右按键有关，高四位与方向有关。
  //高四位0－1－2－3，低四位8 9(left) a(right) b(both) c(middle)
   return -1;
}

/*
 对于鼠标，每三个字节的数据，可以反映鼠标的移动信息和是否按下了按键：
 buf[0] 低四位包含的信息：0：no button press,
		       1:left button press,
		       2:right button press,
		       3:both press,
		       4:middle button press
 */
