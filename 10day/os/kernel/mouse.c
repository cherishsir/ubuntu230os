#include<header.h>
//激活鼠标的指令　还是向键盘控制器发送指令
#define KEYCMD_SENDTO_MOUSE 	0XD4
#define MOUSECMD_ENABLE     	0XF4
void enable_mouse(struct MOUSE_DEC *mdec)
{
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  outb(PORT_KEYCMD,KEYCMD_SENDTO_MOUSE);//向port 0x0064　写　0XD4命令  下面的命令发给mouse
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  outb(PORT_KEYDAT,MOUSECMD_ENABLE); 	//向port 0x0060　写　0Xf4命令  给mouse发送enable命令
  
  mdec->phase=0;
  return ; 				//if sucessful ,will create an interrupt ,and return ０xfa(ACK),产生的这个0xfa是给cpu的答复信号
					//就算鼠标不动，也会产生这个中断，所以我们一调用enable_mouse，就会产生鼠标中断，必须有这个服务函数。  
}


int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  if(mdec->phase==0)
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
    mdec->buf[0] = data;
    mdec->phase  = 2;
    return 0;
    }
  }
  else if(mdec->phase==2) 
  {
    mdec->buf[1] = data;
    mdec->phase  = 3;
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
    {
      mdec->x |=0xffffff00;//-x 根据buf[0]的bit4为1时，确定鼠标的移动方向是负方向。
    }
    if( (mdec->buf[0] & 0x20) != 0)//bit5为1时 2
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











