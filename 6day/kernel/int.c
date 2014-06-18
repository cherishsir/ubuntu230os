#include<header.h>
/*
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021

#define PIC0_ICW1		0x0020
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021


#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1

#define PIC1_ICW1		0x00a0
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1
*/


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

    
    
    
  //上面的port只用到了0x20 ,0x21 ,0xa0,0xa1,四个port号。
  //对于这些port 0x20 21 ,a0 a1的初始化为什么这样设置，以后再研究
  //pic对于cpu来说是i/o　
  //cpu对i/o设备通过io port写port寄存器控制i/o device,读i/o　device的port寄存器数据，得到设备的数据
  //注意:写port是为了控制，设置i/o device,读port是为了得到i/o　device的状态或是data.
  //一个或是几个port对应一个i/o　device,从上面的程序可以看到，pic设备０的port号是0x20 0x21,对port 0x21进行３闪连写，可以对pic 0进行工作方式的设置。
  //思考这里３次连写，其实对port０内部的３个不同的寄存器进行了设置。
  //pic的硬性写规则，对icw1(port 0x20)写后，必须要写icw2(port 0x21)，思考这种硬性的规定，可以用两个port口设置完pic的所有功能。硬件上面可能很复杂，但是软件上没有得到了简化。
  
  
  /*
   对上面的设置的简单分析，imr是interrupt mask register,通过对port 21 a1进行写１可以把１６个irq全mask掉。
   只有需要的中断才enable,不需要的全disable.
   
   icw :initial control word,m icw 1 2 3 4:port 0x20 0x21 0x21 0x21
   icw3是有关maste slave的设置，对于maste pic而言，哪一位是1，就说明哪一位接的slave pic,我们的电脑只需要把bit2（１<<2）置１就行了。
   
   对于slave pic，这个slave pic与master pic的第几号相连，就写数字几，用三位二进制表示（0到７），所以直接写２就行了
   
   pc的发展决定了键盘和mouse就是这样设置的，不会有什么改变了。
   
   
   所以在不同的os之间只有icw2不同，也就是中断号的不同。这个中断号就对应着idt中的中断服务程序的入口地址。
   
   pic会产生中断号，然后给cpu，所以cpu需要从pic得到中断号
   
   
   
   
   这里说的pic，就是具体用的8259a芯片。
   
   主片的端口号是 0x20 和 0x21,从片的端口号是 0xa0 和 0xa1,可以通过这些端口访问 8259 芯片,设置它的工作方式,包括 IMR 的内容
   
   IF 标志位可以通过两条指令 cli 和 sti 来改变。
这两条指令都没有操作数,
cli：if=0  disable interrupt　 ,cpu不处理任何中断
sti: if=1  enable  interrupt  ,cpu可以处理响应中断

这一次的中断号，我们设置了0x20到0x2f，来接收中断信号irq0到irq15，为什么不直接用int0到int15,这样就与irq的号码一样了。为什么要加0x20,
这是因为int 0x00-0x1f不能用于irq,因为这２０个Int是留给系统的，是给mi（not mask interrupt）用的。

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}

//interrupt service procedure for keyboard
void inthandler21(int *esp)
{
  struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  boxfill(0,0,0,32*8-1,15);//一个黑色的小box
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int 21(IRQ-1):PS/2 keyboard");
  while(1)
  io_halt();
  
}













































