
ckernel.out:     file format elf32-i386


Disassembly of section .text:

00280000 <bootmain>:
#define black 0
#define red   1
#define green 2

void bootmain(void)
{
  280000:	55                   	push   %ebp
  280001:	89 e5                	mov    %esp,%ebp
  280003:	57                   	push   %edi
  280004:	56                   	push   %esi
  280005:	53                   	push   %ebx
  280006:	81 ec 18 02 00 00    	sub    $0x218,%esp

struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
clear_screen(40);   	//red
  28000c:	6a 28                	push   $0x28
  28000e:	e8 fb 04 00 00       	call   28050e <clear_screen>
init_screen((struct boot_info * )bootp);
  280013:	c7 04 24 f0 0f 00 00 	movl   $0xff0,(%esp)
  28001a:	e8 fd 08 00 00       	call   28091c <init_screen>
init_palette();  //color table from 0 to 15
  28001f:	e8 53 05 00 00       	call   280577 <init_palette>

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280024:	fa                   	cli    

//display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);
cli();

//set gdt idt
init_gdtidt();
  280025:	e8 61 0e 00 00       	call   280e8b <init_gdtidt>
//remap irq 0-15
//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
init_pic();
  28002a:	e8 bc 0f 00 00       	call   280feb <init_pic>
unsigned char s[40];		    //sprintf buffer
unsigned char keybuf[32];	    //keyfifo
unsigned char mousebuf[128];	//mousefifo
unsigned char data;		        //temp variable to get fifo data
int count=0;
fifo8_init(&keyfifo ,32,keybuf);//keyfifo是一个global data defined in int.c
  28002f:	83 c4 0c             	add    $0xc,%esp
  280032:	8d 85 20 fe ff ff    	lea    -0x1e0(%ebp),%eax
  280038:	50                   	push   %eax
  280039:	6a 20                	push   $0x20
  28003b:	68 20 3e 28 00       	push   $0x283e20
  280040:	e8 b1 10 00 00       	call   2810f6 <fifo8_init>
fifo8_init(&mousefifo,128,mousebuf);
  280045:	83 c4 0c             	add    $0xc,%esp
  280048:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  28004e:	50                   	push   %eax
  28004f:	68 80 00 00 00       	push   $0x80
  280054:	68 38 3e 28 00       	push   $0x283e38
  280059:	e8 98 10 00 00       	call   2810f6 <fifo8_init>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  28005e:	ba 21 00 00 00       	mov    $0x21,%edx
  280063:	b0 f9                	mov    $0xf9,%al
  280065:	ee                   	out    %al,(%dx)
  280066:	b0 ef                	mov    $0xef,%al
  280068:	b2 a1                	mov    $0xa1,%dl
  28006a:	ee                   	out    %al,(%dx)
//enable keyboard and mouse
outb(PIC0_IMR, 0xf9);	//1111 1001  irq 1 2打开 因为keyboard是irq 1                                  // enable pic slave and keyboard interrupt
outb(PIC1_IMR, 0xef);	//1110 1111  irq 12 打开　mouse是irq 12  所以要把pic 1 pic 2的芯片中断响应位打开。 //enable mouse interrupt

//初始化　鼠标按键控制电路
init_keyboard();
  28006b:	e8 11 10 00 00       	call   281081 <init_keyboard>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280070:	fb                   	sti    

//enable cpu interrupt
sti();

struct MOUSE_DEC mdec;
enable_mouse(&mdec);   //这里会产生一个mouse interrupt
  280071:	8d 95 10 fe ff ff    	lea    -0x1f0(%ebp),%edx
  280077:	89 14 24             	mov    %edx,(%esp)
  28007a:	89 95 ec fd ff ff    	mov    %edx,-0x214(%ebp)
  280080:	e8 1d 11 00 00       	call   2811a2 <enable_mouse>

unsigned int memtotal;
//get the total memory
memtotal=memtest(0x400000,0xffffffff);
  280085:	58                   	pop    %eax
  280086:	5a                   	pop    %edx
  280087:	6a ff                	push   $0xffffffff
  280089:	68 00 00 40 00       	push   $0x400000
  28008e:	e8 00 12 00 00       	call   281293 <memtest>
//mem=mem>>20; //convert to MBytes
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  280093:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)
struct MOUSE_DEC mdec;
enable_mouse(&mdec);   //这里会产生一个mouse interrupt

unsigned int memtotal;
//get the total memory
memtotal=memtest(0x400000,0xffffffff);
  28009a:	89 c6                	mov    %eax,%esi
//mem=mem>>20; //convert to MBytes
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  28009c:	e8 40 12 00 00       	call   2812e1 <memman_init>
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
  2800a1:	83 c4 0c             	add    $0xc,%esp
  2800a4:	8d 86 00 00 c0 ff    	lea    -0x400000(%esi),%eax
  2800aa:	50                   	push   %eax
  2800ab:	68 00 00 40 00       	push   $0x400000
  2800b0:	68 00 00 3c 00       	push   $0x3c0000
  2800b5:	e8 d9 12 00 00       	call   281393 <memman_free>
draw_win_buf(desktop);
make_window8(win_buf,160,68,"counter");
init_mouse(mousepic,99);	//99　means background color


sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800ba:	c1 ee 14             	shr    $0x14,%esi
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *desktop=(unsigned char*)memman_alloc(memman,320*200);
  2800bd:	59                   	pop    %ecx
  2800be:	5b                   	pop    %ebx
  2800bf:	68 00 fa 00 00       	push   $0xfa00
  2800c4:	68 00 00 3c 00       	push   $0x3c0000
  2800c9:	e8 51 12 00 00       	call   28131f <memman_alloc>
char *win_buf=(unsigned char*)memman_alloc_4K(memman,160*65);
  2800ce:	5f                   	pop    %edi
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *desktop=(unsigned char*)memman_alloc(memman,320*200);
  2800cf:	89 c3                	mov    %eax,%ebx
char *win_buf=(unsigned char*)memman_alloc_4K(memman,160*65);
  2800d1:	58                   	pop    %eax
  2800d2:	68 a0 28 00 00       	push   $0x28a0
  2800d7:	68 00 00 3c 00       	push   $0x3c0000
  2800dc:	e8 99 12 00 00       	call   28137a <memman_alloc_4K>

draw_win_buf(desktop);
  2800e1:	89 1c 24             	mov    %ebx,(%esp)
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *desktop=(unsigned char*)memman_alloc(memman,320*200);
char *win_buf=(unsigned char*)memman_alloc_4K(memman,160*65);
  2800e4:	89 c7                	mov    %eax,%edi

draw_win_buf(desktop);
  2800e6:	e8 14 05 00 00       	call   2805ff <draw_win_buf>
make_window8(win_buf,160,68,"counter");
  2800eb:	68 29 36 28 00       	push   $0x283629
  2800f0:	6a 44                	push   $0x44
  2800f2:	68 a0 00 00 00       	push   $0xa0
  2800f7:	57                   	push   %edi
  2800f8:	89 bd 04 fe ff ff    	mov    %edi,-0x1fc(%ebp)
  2800fe:	e8 c1 08 00 00       	call   2809c4 <make_window8>
init_mouse(mousepic,99);	//99　means background color
  280103:	83 c4 18             	add    $0x18,%esp
  280106:	8d 8d e8 fe ff ff    	lea    -0x118(%ebp),%ecx
  28010c:	6a 63                	push   $0x63
  28010e:	51                   	push   %ecx
  28010f:	89 8d 00 fe ff ff    	mov    %ecx,-0x200(%ebp)
  280115:	e8 21 08 00 00       	call   28093b <init_mouse>


sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  28011a:	8b 3d 00 00 3c 00    	mov    0x3c0000,%edi
,memman_avail(memman)>>20,memman->cellnum);
  280120:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)
  280127:	e8 d8 11 00 00       	call   281304 <memman_avail>
draw_win_buf(desktop);
make_window8(win_buf,160,68,"counter");
init_mouse(mousepic,99);	//99　means background color


sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  28012c:	89 3c 24             	mov    %edi,(%esp)
  28012f:	c1 e8 14             	shr    $0x14,%eax
  280132:	50                   	push   %eax
  280133:	56                   	push   %esi
  280134:	68 08 36 28 00       	push   $0x283608
  280139:	8d b5 40 fe ff ff    	lea    -0x1c0(%ebp),%esi
  28013f:	56                   	push   %esi
  280140:	e8 93 0a 00 00       	call   280bd8 <sprintf>
,memman_avail(memman)>>20,memman->cellnum);
puts8(desktop ,bootp->xsize,0,100,0,s);
  280145:	83 c4 18             	add    $0x18,%esp
  280148:	56                   	push   %esi
  280149:	6a 00                	push   $0x0
  28014b:	6a 64                	push   $0x64
  28014d:	6a 00                	push   $0x0
  28014f:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280156:	50                   	push   %eax
  280157:	53                   	push   %ebx
  280158:	e8 76 0b 00 00       	call   280cd3 <puts8>

SHTCTL *shtctl;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
  28015d:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
  280164:	83 c4 20             	add    $0x20,%esp
  280167:	50                   	push   %eax
  280168:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  28016f:	50                   	push   %eax
  280170:	ff 35 f8 0f 00 00    	pushl  0xff8
  280176:	68 00 00 3c 00       	push   $0x3c0000
  28017b:	e8 16 13 00 00       	call   281496 <shtctl_init>

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
  280180:	89 04 24             	mov    %eax,(%esp)
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
,memman_avail(memman)>>20,memman->cellnum);
puts8(desktop ,bootp->xsize,0,100,0,s);

SHTCTL *shtctl;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
  280183:	89 c7                	mov    %eax,%edi

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
  280185:	e8 90 13 00 00       	call   28151a <sheet_alloc>
sht_mouse=sheet_alloc(shtctl);
  28018a:	89 3c 24             	mov    %edi,(%esp)
SHTCTL *shtctl;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
  28018d:	89 85 f4 fd ff ff    	mov    %eax,-0x20c(%ebp)
sht_mouse=sheet_alloc(shtctl);
  280193:	e8 82 13 00 00       	call   28151a <sheet_alloc>
sht_win=sheet_alloc(shtctl);
  280198:	89 3c 24             	mov    %edi,(%esp)
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
sht_mouse=sheet_alloc(shtctl);
  28019b:	89 85 fc fd ff ff    	mov    %eax,-0x204(%ebp)
sht_win=sheet_alloc(shtctl);
  2801a1:	e8 74 13 00 00       	call   28151a <sheet_alloc>
//puts8(win_buf ,160,24,44,0,"second line");//y=28+16=44



//hoop the buffer with sheet
sheet_setbuf(sht_back,desktop,320,200,-1);
  2801a6:	8b bd f4 fd ff ff    	mov    -0x20c(%ebp),%edi
  2801ac:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  2801b3:	68 c8 00 00 00       	push   $0xc8
  2801b8:	68 40 01 00 00       	push   $0x140
  2801bd:	53                   	push   %ebx
  2801be:	57                   	push   %edi

SHEET *sht_back,*sht_mouse,*sht_win;
//allocate a sheet space from shtctl
sht_back=sheet_alloc(shtctl);
sht_mouse=sheet_alloc(shtctl);
sht_win=sheet_alloc(shtctl);
  2801bf:	89 85 f8 fd ff ff    	mov    %eax,-0x208(%ebp)
//puts8(win_buf ,160,24,44,0,"second line");//y=28+16=44



//hoop the buffer with sheet
sheet_setbuf(sht_back,desktop,320,200,-1);
  2801c5:	e8 83 13 00 00       	call   28154d <sheet_setbuf>
sheet_setbuf(sht_mouse,mousepic,16,16,99);
  2801ca:	83 c4 14             	add    $0x14,%esp
  2801cd:	8b 8d 00 fe ff ff    	mov    -0x200(%ebp),%ecx
  2801d3:	6a 63                	push   $0x63
  2801d5:	6a 10                	push   $0x10
  2801d7:	6a 10                	push   $0x10
  2801d9:	51                   	push   %ecx
  2801da:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  2801e0:	e8 68 13 00 00       	call   28154d <sheet_setbuf>
sheet_setbuf(sht_win,win_buf,160,65,-1);
  2801e5:	83 c4 14             	add    $0x14,%esp
  2801e8:	6a ff                	push   $0xffffffff
  2801ea:	6a 41                	push   $0x41
  2801ec:	68 a0 00 00 00       	push   $0xa0
  2801f1:	ff b5 04 fe ff ff    	pushl  -0x1fc(%ebp)
  2801f7:	ff b5 f8 fd ff ff    	pushl  -0x208(%ebp)
  2801fd:	e8 4b 13 00 00       	call   28154d <sheet_setbuf>




mx=0;my=0;//set mouse initial position
sheet_move(sht_back,0,0);
  280202:	83 c4 1c             	add    $0x1c,%esp
  280205:	6a 00                	push   $0x0
  280207:	6a 00                	push   $0x0
  280209:	57                   	push   %edi
  28020a:	e8 70 17 00 00       	call   28197f <sheet_move>
sheet_move(sht_mouse,mx,my);
  28020f:	83 c4 0c             	add    $0xc,%esp
  280212:	6a 00                	push   $0x0
  280214:	6a 00                	push   $0x0
  280216:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  28021c:	e8 5e 17 00 00       	call   28197f <sheet_move>
sheet_move(sht_win,80,72);
  280221:	83 c4 0c             	add    $0xc,%esp
  280224:	6a 48                	push   $0x48
  280226:	6a 50                	push   $0x50
  280228:	ff b5 f8 fd ff ff    	pushl  -0x208(%ebp)
  28022e:	e8 4c 17 00 00       	call   28197f <sheet_move>

//set sht_back to layer0 ;set sht_mouse to layer1
sheet_updown(sht_back,0);
  280233:	58                   	pop    %eax
  280234:	5a                   	pop    %edx
  280235:	6a 00                	push   $0x0
  280237:	57                   	push   %edi
  280238:	e8 85 15 00 00       	call   2817c2 <sheet_updown>
sheet_updown(sht_win,1);
  28023d:	59                   	pop    %ecx
  28023e:	58                   	pop    %eax
  28023f:	6a 01                	push   $0x1
  280241:	ff b5 f8 fd ff ff    	pushl  -0x208(%ebp)
  280247:	e8 76 15 00 00       	call   2817c2 <sheet_updown>
sheet_updown(sht_mouse,2);
  28024c:	58                   	pop    %eax
  28024d:	5a                   	pop    %edx
  28024e:	6a 02                	push   $0x2
  280250:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  280256:	e8 67 15 00 00       	call   2817c2 <sheet_updown>
//refresh a specific rectangle
sheet_refresh(sht_back,0,0,bootp->xsize,bootp->ysize);
  28025b:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
  280262:	89 04 24             	mov    %eax,(%esp)
  280265:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  28026c:	50                   	push   %eax
  28026d:	6a 00                	push   $0x0
  28026f:	6a 00                	push   $0x0
  280271:	57                   	push   %edi
sheet_setbuf(sht_win,win_buf,160,65,-1);




mx=0;my=0;//set mouse initial position
  280272:	31 ff                	xor    %edi,%edi
//set sht_back to layer0 ;set sht_mouse to layer1
sheet_updown(sht_back,0);
sheet_updown(sht_win,1);
sheet_updown(sht_mouse,2);
//refresh a specific rectangle
sheet_refresh(sht_back,0,0,bootp->xsize,bootp->ysize);
  280274:	e8 06 14 00 00       	call   28167f <sheet_refresh>
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
      {
        data=fifo8_read(&mousefifo);
        sti();
        if(mouse_decode(&mdec,data))
  280279:	8b 95 ec fd ff ff    	mov    -0x214(%ebp),%edx
//set sht_back to layer0 ;set sht_mouse to layer1
sheet_updown(sht_back,0);
sheet_updown(sht_win,1);
sheet_updown(sht_mouse,2);
//refresh a specific rectangle
sheet_refresh(sht_back,0,0,bootp->xsize,bootp->ysize);
  28027f:	83 c4 20             	add    $0x20,%esp

unsigned counter=0;
  280282:	c7 85 f0 fd ff ff 00 	movl   $0x0,-0x210(%ebp)
  280289:	00 00 00 
sheet_setbuf(sht_win,win_buf,160,65,-1);




mx=0;my=0;//set mouse initial position
  28028c:	c7 85 00 fe ff ff 00 	movl   $0x0,-0x200(%ebp)
  280293:	00 00 00 
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
      {
        data=fifo8_read(&mousefifo);
        sti();
        if(mouse_decode(&mdec,data))
  280296:	89 95 e8 fd ff ff    	mov    %edx,-0x218(%ebp)
 {

    counter++;
   // if(counter==20)
   // counter=0;
    puts8(win_buf ,160,24,28,0,"below a counter");
  28029c:	50                   	push   %eax
  28029d:	50                   	push   %eax
  28029e:	68 21 36 28 00       	push   $0x283621
  2802a3:	6a 00                	push   $0x0
  2802a5:	6a 1c                	push   $0x1c
  2802a7:	6a 18                	push   $0x18
  2802a9:	68 a0 00 00 00       	push   $0xa0
  2802ae:	ff b5 04 fe ff ff    	pushl  -0x1fc(%ebp)

unsigned counter=0;
 while(1)
 {

    counter++;
  2802b4:	ff 85 f0 fd ff ff    	incl   -0x210(%ebp)
   // if(counter==20)
   // counter=0;
    puts8(win_buf ,160,24,28,0,"below a counter");
  2802ba:	e8 14 0a 00 00       	call   280cd3 <puts8>
    sprintf(s,"%d",counter);
  2802bf:	83 c4 1c             	add    $0x1c,%esp
  2802c2:	ff b5 f0 fd ff ff    	pushl  -0x210(%ebp)
  2802c8:	68 1e 36 28 00       	push   $0x28361e
  2802cd:	56                   	push   %esi
  2802ce:	e8 05 09 00 00       	call   280bd8 <sprintf>
    boxfill8(win_buf,160,8,20,44,140,60);
  2802d3:	83 c4 0c             	add    $0xc,%esp
  2802d6:	6a 3c                	push   $0x3c
  2802d8:	68 8c 00 00 00       	push   $0x8c
  2802dd:	6a 2c                	push   $0x2c
  2802df:	6a 14                	push   $0x14
  2802e1:	6a 08                	push   $0x8
  2802e3:	68 a0 00 00 00       	push   $0xa0
  2802e8:	ff b5 04 fe ff ff    	pushl  -0x1fc(%ebp)
  2802ee:	e8 b5 02 00 00       	call   2805a8 <boxfill8>
    puts8(win_buf ,160,20,44,0,s);//y=28+16=44
  2802f3:	83 c4 18             	add    $0x18,%esp
  2802f6:	56                   	push   %esi
  2802f7:	6a 00                	push   $0x0
  2802f9:	6a 2c                	push   $0x2c
  2802fb:	6a 14                	push   $0x14
  2802fd:	68 a0 00 00 00       	push   $0xa0
  280302:	ff b5 04 fe ff ff    	pushl  -0x1fc(%ebp)
  280308:	e8 c6 09 00 00       	call   280cd3 <puts8>
    sheet_refresh(sht_win,20,28,140,60);
  28030d:	83 c4 14             	add    $0x14,%esp
  280310:	6a 3c                	push   $0x3c
  280312:	68 8c 00 00 00       	push   $0x8c
  280317:	6a 1c                	push   $0x1c
  280319:	6a 14                	push   $0x14
  28031b:	ff b5 f8 fd ff ff    	pushl  -0x208(%ebp)
  280321:	e8 59 13 00 00       	call   28167f <sheet_refresh>

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280326:	fa                   	cli    
      cli();//disable cpu interrupt
    //while(1);
   if(fifo8_status(&keyfifo) +fifo8_status(&mousefifo) == 0)//no data in keyfifo and mousefifo
  280327:	83 c4 14             	add    $0x14,%esp
  28032a:	68 20 3e 28 00       	push   $0x283e20
  28032f:	e8 60 0e 00 00       	call   281194 <fifo8_status>
  280334:	c7 04 24 38 3e 28 00 	movl   $0x283e38,(%esp)
  28033b:	89 85 ec fd ff ff    	mov    %eax,-0x214(%ebp)
  280341:	e8 4e 0e 00 00       	call   281194 <fifo8_status>
  280346:	83 c4 10             	add    $0x10,%esp
  280349:	03 85 ec fd ff ff    	add    -0x214(%ebp),%eax
  28034f:	85 c0                	test   %eax,%eax
  280351:	75 06                	jne    280359 <bootmain+0x359>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280353:	fb                   	sti    
  280354:	e9 43 ff ff ff       	jmp    28029c <bootmain+0x29c>
    sti();
    //hlt();//wait for interrupt
   }
   else
   {
      if(fifo8_status(&keyfifo) != 0)
  280359:	83 ec 0c             	sub    $0xc,%esp
  28035c:	68 20 3e 28 00       	push   $0x283e20
  280361:	e8 2e 0e 00 00       	call   281194 <fifo8_status>
  280366:	83 c4 10             	add    $0x10,%esp
  280369:	85 c0                	test   %eax,%eax
  28036b:	74 13                	je     280380 <bootmain+0x380>
      {
        data=fifo8_read(&keyfifo);
  28036d:	83 ec 0c             	sub    $0xc,%esp
  280370:	68 20 3e 28 00       	push   $0x283e20
  280375:	e8 e5 0d 00 00       	call   28115f <fifo8_read>
  28037a:	fb                   	sti    
  28037b:	e9 86 01 00 00       	jmp    280506 <bootmain+0x506>
        sti();
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
  280380:	83 ec 0c             	sub    $0xc,%esp
  280383:	68 38 3e 28 00       	push   $0x283e38
  280388:	e8 07 0e 00 00       	call   281194 <fifo8_status>
  28038d:	83 c4 10             	add    $0x10,%esp
  280390:	85 c0                	test   %eax,%eax
  280392:	0f 84 04 ff ff ff    	je     28029c <bootmain+0x29c>
      {
        data=fifo8_read(&mousefifo);
  280398:	83 ec 0c             	sub    $0xc,%esp
  28039b:	68 38 3e 28 00       	push   $0x283e38
  2803a0:	e8 ba 0d 00 00       	call   28115f <fifo8_read>
  2803a5:	fb                   	sti    
        sti();
        if(mouse_decode(&mdec,data))
  2803a6:	5a                   	pop    %edx
  2803a7:	0f b6 c0             	movzbl %al,%eax
  2803aa:	59                   	pop    %ecx
  2803ab:	50                   	push   %eax
  2803ac:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  2803b2:	e8 14 0e 00 00       	call   2811cb <mouse_decode>
  2803b7:	83 c4 10             	add    $0x10,%esp
  2803ba:	85 c0                	test   %eax,%eax
  2803bc:	0f 84 da fe ff ff    	je     28029c <bootmain+0x29c>
        {
              //3个字节都得到了
              switch (mdec.button)
  2803c2:	8b 85 1c fe ff ff    	mov    -0x1e4(%ebp),%eax
  2803c8:	83 f8 02             	cmp    $0x2,%eax
  2803cb:	74 11                	je     2803de <bootmain+0x3de>
  2803cd:	83 f8 04             	cmp    $0x4,%eax
  2803d0:	74 15                	je     2803e7 <bootmain+0x3e7>
  2803d2:	48                   	dec    %eax
  2803d3:	75 19                	jne    2803ee <bootmain+0x3ee>
              {
                case 1:s[1]='L';break;
  2803d5:	c6 85 41 fe ff ff 4c 	movb   $0x4c,-0x1bf(%ebp)
  2803dc:	eb 10                	jmp    2803ee <bootmain+0x3ee>
                case 2:s[3]='R';break;
  2803de:	c6 85 43 fe ff ff 52 	movb   $0x52,-0x1bd(%ebp)
  2803e5:	eb 07                	jmp    2803ee <bootmain+0x3ee>
                case 4:s[2]='M';break;
  2803e7:	c6 85 42 fe ff ff 4d 	movb   $0x4d,-0x1be(%ebp)
              }
              sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
  2803ee:	ff b5 18 fe ff ff    	pushl  -0x1e8(%ebp)
  2803f4:	ff b5 14 fe ff ff    	pushl  -0x1ec(%ebp)
  2803fa:	68 31 36 28 00       	push   $0x283631
  2803ff:	56                   	push   %esi
  280400:	e8 d3 07 00 00       	call   280bd8 <sprintf>
              boxfill8(desktop,320,0,32,16,32+15*8-1,33);//一个黑色的小box
  280405:	83 c4 0c             	add    $0xc,%esp
  280408:	6a 21                	push   $0x21
  28040a:	68 97 00 00 00       	push   $0x97
  28040f:	6a 10                	push   $0x10
  280411:	6a 20                	push   $0x20
  280413:	6a 00                	push   $0x0
  280415:	68 40 01 00 00       	push   $0x140
  28041a:	53                   	push   %ebx
  28041b:	e8 88 01 00 00       	call   2805a8 <boxfill8>
              puts8(desktop,bootp->xsize,32,16,7,s);     //display e0
  280420:	83 c4 18             	add    $0x18,%esp
  280423:	56                   	push   %esi
  280424:	6a 07                	push   $0x7
  280426:	6a 10                	push   $0x10
  280428:	6a 20                	push   $0x20
  28042a:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280431:	50                   	push   %eax
  280432:	53                   	push   %ebx
  280433:	e8 9b 08 00 00       	call   280cd3 <puts8>
              sheet_refresh(sht_back,32,16,32+20*8-1,31);
  280438:	83 c4 14             	add    $0x14,%esp
  28043b:	6a 1f                	push   $0x1f
  28043d:	68 bf 00 00 00       	push   $0xbf
  280442:	6a 10                	push   $0x10
  280444:	6a 20                	push   $0x20
  280446:	ff b5 f4 fd ff ff    	pushl  -0x20c(%ebp)
  28044c:	e8 2e 12 00 00       	call   28167f <sheet_refresh>
  280451:	83 c4 20             	add    $0x20,%esp
  280454:	31 c0                	xor    %eax,%eax
  280456:	89 fa                	mov    %edi,%edx
  280458:	03 95 14 fe ff ff    	add    -0x1ec(%ebp),%edx
  28045e:	89 d7                	mov    %edx,%edi
  280460:	8b 95 00 fe ff ff    	mov    -0x200(%ebp),%edx
  280466:	0f 48 f8             	cmovs  %eax,%edi
  280469:	03 95 18 fe ff ff    	add    -0x1e8(%ebp),%edx
  28046f:	0f 49 c2             	cmovns %edx,%eax
  280472:	89 c1                	mov    %eax,%ecx
              {
                my=0;
              }


              if(mx>bootp->xsize-1)
  280474:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
              {
                mx=bootp->xsize-1;
  28047b:	8d 50 ff             	lea    -0x1(%eax),%edx
  28047e:	39 f8                	cmp    %edi,%eax
              }

              if(my>bootp->ysize-1)
  280480:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
              }


              if(mx>bootp->xsize-1)
              {
                mx=bootp->xsize-1;
  280487:	0f 4e fa             	cmovle %edx,%edi
              }

              if(my>bootp->ysize-1)
              {
                my=bootp->ysize-1;
  28048a:	39 c8                	cmp    %ecx,%eax
  28048c:	8d 50 ff             	lea    -0x1(%eax),%edx
  28048f:	0f 4f d1             	cmovg  %ecx,%edx
              }
              sprintf(s,"(%d, %d)",mx,my);
  280492:	52                   	push   %edx
  280493:	57                   	push   %edi
  280494:	68 3d 36 28 00       	push   $0x28363d
  280499:	56                   	push   %esi
                mx=bootp->xsize-1;
              }

              if(my>bootp->ysize-1)
              {
                my=bootp->ysize-1;
  28049a:	89 95 00 fe ff ff    	mov    %edx,-0x200(%ebp)
              }
              sprintf(s,"(%d, %d)",mx,my);
  2804a0:	e8 33 07 00 00       	call   280bd8 <sprintf>
              boxfill8(desktop,320,0,0,0,79,15);//坐标的背景色
  2804a5:	83 c4 0c             	add    $0xc,%esp
  2804a8:	6a 0f                	push   $0xf
  2804aa:	6a 4f                	push   $0x4f
  2804ac:	6a 00                	push   $0x0
  2804ae:	6a 00                	push   $0x0
  2804b0:	6a 00                	push   $0x0
  2804b2:	68 40 01 00 00       	push   $0x140
  2804b7:	53                   	push   %ebx
  2804b8:	e8 eb 00 00 00       	call   2805a8 <boxfill8>
              puts8(desktop ,bootp->xsize,0,0,7,s);//显示坐标
  2804bd:	83 c4 18             	add    $0x18,%esp
  2804c0:	56                   	push   %esi
  2804c1:	6a 07                	push   $0x7
  2804c3:	6a 00                	push   $0x0
  2804c5:	6a 00                	push   $0x0
  2804c7:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2804ce:	50                   	push   %eax
  2804cf:	53                   	push   %ebx
  2804d0:	e8 fe 07 00 00       	call   280cd3 <puts8>
              sheet_refresh(sht_back,0,0,bootp->xsize,15);
  2804d5:	83 c4 14             	add    $0x14,%esp
  2804d8:	6a 0f                	push   $0xf
  2804da:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2804e1:	50                   	push   %eax
  2804e2:	6a 00                	push   $0x0
  2804e4:	6a 00                	push   $0x0
  2804e6:	ff b5 f4 fd ff ff    	pushl  -0x20c(%ebp)
  2804ec:	e8 8e 11 00 00       	call   28167f <sheet_refresh>
              sheet_move(sht_mouse,mx,my);
  2804f1:	83 c4 1c             	add    $0x1c,%esp
  2804f4:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)
  2804fa:	57                   	push   %edi
  2804fb:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  280501:	e8 79 14 00 00       	call   28197f <sheet_move>
  280506:	83 c4 10             	add    $0x10,%esp
  280509:	e9 8e fd ff ff       	jmp    28029c <bootmain+0x29c>

0028050e <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
  28050e:	55                   	push   %ebp
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  28050f:	b8 00 00 0a 00       	mov    $0xa0000,%eax
#include<header.h>

void clear_screen(char color) //15:pure white
{
  280514:	89 e5                	mov    %esp,%ebp
  280516:	8a 55 08             	mov    0x8(%ebp),%dl
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  280519:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  28051b:	40                   	inc    %eax
  28051c:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280521:	75 f6                	jne    280519 <clear_screen+0xb>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280523:	5d                   	pop    %ebp
  280524:	c3                   	ret    

00280525 <color_screen>:

void color_screen(char color) //15:pure white
{
  280525:	55                   	push   %ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  280526:	b8 00 00 0a 00       	mov    $0xa0000,%eax

  }
}

void color_screen(char color) //15:pure white
{
  28052b:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  28052d:	88 00                	mov    %al,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  28052f:	40                   	inc    %eax
  280530:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280535:	75 f6                	jne    28052d <color_screen+0x8>
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280537:	5d                   	pop    %ebp
  280538:	c3                   	ret    

00280539 <set_palette>:
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  280539:	55                   	push   %ebp
  28053a:	89 e5                	mov    %esp,%ebp
  28053c:	56                   	push   %esi
  28053d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  280540:	53                   	push   %ebx
  280541:	8b 5d 08             	mov    0x8(%ebp),%ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  280544:	9c                   	pushf  
  280545:	5e                   	pop    %esi

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280546:	fa                   	cli    
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280547:	ba c8 03 00 00       	mov    $0x3c8,%edx

  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  28054c:	0f b6 c3             	movzbl %bl,%eax
  28054f:	ee                   	out    %al,(%dx)
  280550:	b2 c9                	mov    $0xc9,%dl
  for(i=start;i<=end;i++)
  280552:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  280555:	7f 1a                	jg     280571 <set_palette+0x38>
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
  280557:	8a 01                	mov    (%ecx),%al
  280559:	c0 e8 02             	shr    $0x2,%al
  28055c:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+1)/4);
  28055d:	8a 41 01             	mov    0x1(%ecx),%al
  280560:	c0 e8 02             	shr    $0x2,%al
  280563:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+2)/4);
  280564:	8a 41 02             	mov    0x2(%ecx),%al
  280567:	c0 e8 02             	shr    $0x2,%al
  28056a:	ee                   	out    %al,(%dx)
    rgb=rgb+3;
  28056b:	83 c1 03             	add    $0x3,%ecx
  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  28056e:	43                   	inc    %ebx
  28056f:	eb e1                	jmp    280552 <set_palette+0x19>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  280571:	56                   	push   %esi
  280572:	9d                   	popf   
  }

write_eflags(eflag);  //恢复从前的cpsr
  return;

}
  280573:	5b                   	pop    %ebx
  280574:	5e                   	pop    %esi
  280575:	5d                   	pop    %ebp
  280576:	c3                   	ret    

00280577 <init_palette>:
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280577:	55                   	push   %ebp
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280578:	b9 0c 00 00 00       	mov    $0xc,%ecx
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  28057d:	89 e5                	mov    %esp,%ebp
  28057f:	57                   	push   %edi
  280580:	56                   	push   %esi
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280581:	be f8 33 28 00       	mov    $0x2833f8,%esi
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280586:	83 ec 30             	sub    $0x30,%esp
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280589:	8d 45 c8             	lea    -0x38(%ebp),%eax
//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  28058c:	8d 7d c8             	lea    -0x38(%ebp),%edi
  28058f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280591:	50                   	push   %eax
  280592:	68 ff 00 00 00       	push   $0xff
  280597:	6a 00                	push   $0x0
  280599:	e8 9b ff ff ff       	call   280539 <set_palette>
  28059e:	83 c4 0c             	add    $0xc,%esp
}
  2805a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  2805a4:	5e                   	pop    %esi
  2805a5:	5f                   	pop    %edi
  2805a6:	5d                   	pop    %ebp
  2805a7:	c3                   	ret    

002805a8 <boxfill8>:
  return;

}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
  2805a8:	55                   	push   %ebp
  2805a9:	89 e5                	mov    %esp,%ebp
  2805ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  2805ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  2805b1:	53                   	push   %ebx
  2805b2:	8a 5d 10             	mov    0x10(%ebp),%bl
  2805b5:	0f af c1             	imul   %ecx,%eax
  2805b8:	03 45 08             	add    0x8(%ebp),%eax
 int x,y;
 for(y=y0;y<=y1;y++)
  2805bb:	3b 4d 20             	cmp    0x20(%ebp),%ecx
  2805be:	7f 14                	jg     2805d4 <boxfill8+0x2c>
  2805c0:	8b 55 14             	mov    0x14(%ebp),%edx
 {
   for(x=x0;x<=x1;x++)
  2805c3:	3b 55 1c             	cmp    0x1c(%ebp),%edx
  2805c6:	7f 06                	jg     2805ce <boxfill8+0x26>
   {
      vram[y*xsize+x]=color;
  2805c8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
  2805cb:	42                   	inc    %edx
  2805cc:	eb f5                	jmp    2805c3 <boxfill8+0x1b>
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
  2805ce:	41                   	inc    %ecx
  2805cf:	03 45 0c             	add    0xc(%ebp),%eax
  2805d2:	eb e7                	jmp    2805bb <boxfill8+0x13>
   {
      vram[y*xsize+x]=color;
   }
 }

}
  2805d4:	5b                   	pop    %ebx
  2805d5:	5d                   	pop    %ebp
  2805d6:	c3                   	ret    

002805d7 <boxfill>:
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  2805d7:	55                   	push   %ebp
  2805d8:	89 e5                	mov    %esp,%ebp
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
  2805da:	ff 75 18             	pushl  0x18(%ebp)
  2805dd:	ff 75 14             	pushl  0x14(%ebp)
  2805e0:	ff 75 10             	pushl  0x10(%ebp)
  2805e3:	ff 75 0c             	pushl  0xc(%ebp)
  2805e6:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  2805ea:	50                   	push   %eax
  2805eb:	68 40 01 00 00       	push   $0x140
  2805f0:	68 00 00 0a 00       	push   $0xa0000
  2805f5:	e8 ae ff ff ff       	call   2805a8 <boxfill8>
  2805fa:	83 c4 1c             	add    $0x1c,%esp
}
  2805fd:	c9                   	leave  
  2805fe:	c3                   	ret    

002805ff <draw_win_buf>:


void draw_win_buf(unsigned char *p)
{
  2805ff:	55                   	push   %ebp
  280600:	89 e5                	mov    %esp,%ebp
  280602:	53                   	push   %ebx
  280603:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int x=320,y=200;
    //p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill8(p,320,7 ,0, 0   ,x-1,y-29);
  280606:	68 ab 00 00 00       	push   $0xab
  28060b:	68 3f 01 00 00       	push   $0x13f
  280610:	6a 00                	push   $0x0
  280612:	6a 00                	push   $0x0
  280614:	6a 07                	push   $0x7
  280616:	68 40 01 00 00       	push   $0x140
  28061b:	53                   	push   %ebx
  28061c:	e8 87 ff ff ff       	call   2805a8 <boxfill8>
//task button
    boxfill8(p,320,8  ,0, y-28,x-1,y-28);
  280621:	68 ac 00 00 00       	push   $0xac
  280626:	68 3f 01 00 00       	push   $0x13f
  28062b:	68 ac 00 00 00       	push   $0xac
  280630:	6a 00                	push   $0x0
  280632:	6a 08                	push   $0x8
  280634:	68 40 01 00 00       	push   $0x140
  280639:	53                   	push   %ebx
  28063a:	e8 69 ff ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,7  ,0, y-27,x-1,y-27);
  28063f:	83 c4 38             	add    $0x38,%esp
  280642:	68 ad 00 00 00       	push   $0xad
  280647:	68 3f 01 00 00       	push   $0x13f
  28064c:	68 ad 00 00 00       	push   $0xad
  280651:	6a 00                	push   $0x0
  280653:	6a 07                	push   $0x7
  280655:	68 40 01 00 00       	push   $0x140
  28065a:	53                   	push   %ebx
  28065b:	e8 48 ff ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,8  ,0, y-26,x-1,y-1);
  280660:	68 c7 00 00 00       	push   $0xc7
  280665:	68 3f 01 00 00       	push   $0x13f
  28066a:	68 ae 00 00 00       	push   $0xae
  28066f:	6a 00                	push   $0x0
  280671:	6a 08                	push   $0x8
  280673:	68 40 01 00 00       	push   $0x140
  280678:	53                   	push   %ebx
  280679:	e8 2a ff ff ff       	call   2805a8 <boxfill8>


//left button
    boxfill8(p,320,7, 3,  y-24, 59,  y-24);
  28067e:	83 c4 38             	add    $0x38,%esp
  280681:	68 b0 00 00 00       	push   $0xb0
  280686:	6a 3b                	push   $0x3b
  280688:	68 b0 00 00 00       	push   $0xb0
  28068d:	6a 03                	push   $0x3
  28068f:	6a 07                	push   $0x7
  280691:	68 40 01 00 00       	push   $0x140
  280696:	53                   	push   %ebx
  280697:	e8 0c ff ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,7, 2,  y-24, 2 ,  y-4);
  28069c:	68 c4 00 00 00       	push   $0xc4
  2806a1:	6a 02                	push   $0x2
  2806a3:	68 b0 00 00 00       	push   $0xb0
  2806a8:	6a 02                	push   $0x2
  2806aa:	6a 07                	push   $0x7
  2806ac:	68 40 01 00 00       	push   $0x140
  2806b1:	53                   	push   %ebx
  2806b2:	e8 f1 fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,15, 3,  y-4,  59,  y-4);
  2806b7:	83 c4 38             	add    $0x38,%esp
  2806ba:	68 c4 00 00 00       	push   $0xc4
  2806bf:	6a 3b                	push   $0x3b
  2806c1:	68 c4 00 00 00       	push   $0xc4
  2806c6:	6a 03                	push   $0x3
  2806c8:	6a 0f                	push   $0xf
  2806ca:	68 40 01 00 00       	push   $0x140
  2806cf:	53                   	push   %ebx
  2806d0:	e8 d3 fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,15, 59, y-23, 59,  y-5);
  2806d5:	68 c3 00 00 00       	push   $0xc3
  2806da:	6a 3b                	push   $0x3b
  2806dc:	68 b1 00 00 00       	push   $0xb1
  2806e1:	6a 3b                	push   $0x3b
  2806e3:	6a 0f                	push   $0xf
  2806e5:	68 40 01 00 00       	push   $0x140
  2806ea:	53                   	push   %ebx
  2806eb:	e8 b8 fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,0, 2,  y-3,  59,  y-3);
  2806f0:	83 c4 38             	add    $0x38,%esp
  2806f3:	68 c5 00 00 00       	push   $0xc5
  2806f8:	6a 3b                	push   $0x3b
  2806fa:	68 c5 00 00 00       	push   $0xc5
  2806ff:	6a 02                	push   $0x2
  280701:	6a 00                	push   $0x0
  280703:	68 40 01 00 00       	push   $0x140
  280708:	53                   	push   %ebx
  280709:	e8 9a fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,0, 60, y-24, 60,  y-3);
  28070e:	68 c5 00 00 00       	push   $0xc5
  280713:	6a 3c                	push   $0x3c
  280715:	68 b0 00 00 00       	push   $0xb0
  28071a:	6a 3c                	push   $0x3c
  28071c:	6a 00                	push   $0x0
  28071e:	68 40 01 00 00       	push   $0x140
  280723:	53                   	push   %ebx
  280724:	e8 7f fe ff ff       	call   2805a8 <boxfill8>

//
//right button
    boxfill8(p,320,15, x-47, y-24,x-4,y-24);
  280729:	83 c4 38             	add    $0x38,%esp
  28072c:	68 b0 00 00 00       	push   $0xb0
  280731:	68 3c 01 00 00       	push   $0x13c
  280736:	68 b0 00 00 00       	push   $0xb0
  28073b:	68 11 01 00 00       	push   $0x111
  280740:	6a 0f                	push   $0xf
  280742:	68 40 01 00 00       	push   $0x140
  280747:	53                   	push   %ebx
  280748:	e8 5b fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,15, x-47, y-23,x-47,y-4);
  28074d:	68 c4 00 00 00       	push   $0xc4
  280752:	68 11 01 00 00       	push   $0x111
  280757:	68 b1 00 00 00       	push   $0xb1
  28075c:	68 11 01 00 00       	push   $0x111
  280761:	6a 0f                	push   $0xf
  280763:	68 40 01 00 00       	push   $0x140
  280768:	53                   	push   %ebx
  280769:	e8 3a fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,7, x-47, y-3,x-4,y-3);
  28076e:	83 c4 38             	add    $0x38,%esp
  280771:	68 c5 00 00 00       	push   $0xc5
  280776:	68 3c 01 00 00       	push   $0x13c
  28077b:	68 c5 00 00 00       	push   $0xc5
  280780:	68 11 01 00 00       	push   $0x111
  280785:	6a 07                	push   $0x7
  280787:	68 40 01 00 00       	push   $0x140
  28078c:	53                   	push   %ebx
  28078d:	e8 16 fe ff ff       	call   2805a8 <boxfill8>
    boxfill8(p,320,7, x-3, y-24,x-3,y-3);
  280792:	68 c5 00 00 00       	push   $0xc5
  280797:	68 3d 01 00 00       	push   $0x13d
  28079c:	68 b0 00 00 00       	push   $0xb0
  2807a1:	68 3d 01 00 00       	push   $0x13d
  2807a6:	6a 07                	push   $0x7
  2807a8:	68 40 01 00 00       	push   $0x140
  2807ad:	53                   	push   %ebx
  2807ae:	e8 f5 fd ff ff       	call   2805a8 <boxfill8>
  2807b3:	83 c4 38             	add    $0x38,%esp
}
  2807b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2807b9:	c9                   	leave  
  2807ba:	c3                   	ret    

002807bb <draw_window>:
void draw_window()
{
  2807bb:	55                   	push   %ebp
  2807bc:	89 e5                	mov    %esp,%ebp
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
  2807be:	68 ab 00 00 00       	push   $0xab
  2807c3:	68 3f 01 00 00       	push   $0x13f
  2807c8:	6a 00                	push   $0x0
  2807ca:	6a 00                	push   $0x0
  2807cc:	6a 07                	push   $0x7
  2807ce:	e8 04 fe ff ff       	call   2805d7 <boxfill>
//task button
    boxfill(8  ,0, y-28,x-1,y-28);
  2807d3:	68 ac 00 00 00       	push   $0xac
  2807d8:	68 3f 01 00 00       	push   $0x13f
  2807dd:	68 ac 00 00 00       	push   $0xac
  2807e2:	6a 00                	push   $0x0
  2807e4:	6a 08                	push   $0x8
  2807e6:	e8 ec fd ff ff       	call   2805d7 <boxfill>
    boxfill(7  ,0, y-27,x-1,y-27);
  2807eb:	83 c4 28             	add    $0x28,%esp
  2807ee:	68 ad 00 00 00       	push   $0xad
  2807f3:	68 3f 01 00 00       	push   $0x13f
  2807f8:	68 ad 00 00 00       	push   $0xad
  2807fd:	6a 00                	push   $0x0
  2807ff:	6a 07                	push   $0x7
  280801:	e8 d1 fd ff ff       	call   2805d7 <boxfill>
    boxfill(8  ,0, y-26,x-1,y-1);
  280806:	68 c7 00 00 00       	push   $0xc7
  28080b:	68 3f 01 00 00       	push   $0x13f
  280810:	68 ae 00 00 00       	push   $0xae
  280815:	6a 00                	push   $0x0
  280817:	6a 08                	push   $0x8
  280819:	e8 b9 fd ff ff       	call   2805d7 <boxfill>


//left button
    boxfill(7, 3,  y-24, 59,  y-24);
  28081e:	83 c4 28             	add    $0x28,%esp
  280821:	68 b0 00 00 00       	push   $0xb0
  280826:	6a 3b                	push   $0x3b
  280828:	68 b0 00 00 00       	push   $0xb0
  28082d:	6a 03                	push   $0x3
  28082f:	6a 07                	push   $0x7
  280831:	e8 a1 fd ff ff       	call   2805d7 <boxfill>
    boxfill(7, 2,  y-24, 2 ,  y-4);
  280836:	68 c4 00 00 00       	push   $0xc4
  28083b:	6a 02                	push   $0x2
  28083d:	68 b0 00 00 00       	push   $0xb0
  280842:	6a 02                	push   $0x2
  280844:	6a 07                	push   $0x7
  280846:	e8 8c fd ff ff       	call   2805d7 <boxfill>
    boxfill(15, 3,  y-4,  59,  y-4);
  28084b:	83 c4 28             	add    $0x28,%esp
  28084e:	68 c4 00 00 00       	push   $0xc4
  280853:	6a 3b                	push   $0x3b
  280855:	68 c4 00 00 00       	push   $0xc4
  28085a:	6a 03                	push   $0x3
  28085c:	6a 0f                	push   $0xf
  28085e:	e8 74 fd ff ff       	call   2805d7 <boxfill>
    boxfill(15, 59, y-23, 59,  y-5);
  280863:	68 c3 00 00 00       	push   $0xc3
  280868:	6a 3b                	push   $0x3b
  28086a:	68 b1 00 00 00       	push   $0xb1
  28086f:	6a 3b                	push   $0x3b
  280871:	6a 0f                	push   $0xf
  280873:	e8 5f fd ff ff       	call   2805d7 <boxfill>
    boxfill(0, 2,  y-3,  59,  y-3);
  280878:	83 c4 28             	add    $0x28,%esp
  28087b:	68 c5 00 00 00       	push   $0xc5
  280880:	6a 3b                	push   $0x3b
  280882:	68 c5 00 00 00       	push   $0xc5
  280887:	6a 02                	push   $0x2
  280889:	6a 00                	push   $0x0
  28088b:	e8 47 fd ff ff       	call   2805d7 <boxfill>
    boxfill(0, 60, y-24, 60,  y-3);
  280890:	68 c5 00 00 00       	push   $0xc5
  280895:	6a 3c                	push   $0x3c
  280897:	68 b0 00 00 00       	push   $0xb0
  28089c:	6a 3c                	push   $0x3c
  28089e:	6a 00                	push   $0x0
  2808a0:	e8 32 fd ff ff       	call   2805d7 <boxfill>

//
//right button
    boxfill(15, x-47, y-24,x-4,y-24);
  2808a5:	83 c4 28             	add    $0x28,%esp
  2808a8:	68 b0 00 00 00       	push   $0xb0
  2808ad:	68 3c 01 00 00       	push   $0x13c
  2808b2:	68 b0 00 00 00       	push   $0xb0
  2808b7:	68 11 01 00 00       	push   $0x111
  2808bc:	6a 0f                	push   $0xf
  2808be:	e8 14 fd ff ff       	call   2805d7 <boxfill>
    boxfill(15, x-47, y-23,x-47,y-4);
  2808c3:	68 c4 00 00 00       	push   $0xc4
  2808c8:	68 11 01 00 00       	push   $0x111
  2808cd:	68 b1 00 00 00       	push   $0xb1
  2808d2:	68 11 01 00 00       	push   $0x111
  2808d7:	6a 0f                	push   $0xf
  2808d9:	e8 f9 fc ff ff       	call   2805d7 <boxfill>
    boxfill(7, x-47, y-3,x-4,y-3);
  2808de:	83 c4 28             	add    $0x28,%esp
  2808e1:	68 c5 00 00 00       	push   $0xc5
  2808e6:	68 3c 01 00 00       	push   $0x13c
  2808eb:	68 c5 00 00 00       	push   $0xc5
  2808f0:	68 11 01 00 00       	push   $0x111
  2808f5:	6a 07                	push   $0x7
  2808f7:	e8 db fc ff ff       	call   2805d7 <boxfill>
    boxfill(7, x-3, y-24,x-3,y-3);
  2808fc:	68 c5 00 00 00       	push   $0xc5
  280901:	68 3d 01 00 00       	push   $0x13d
  280906:	68 b0 00 00 00       	push   $0xb0
  28090b:	68 3d 01 00 00       	push   $0x13d
  280910:	6a 07                	push   $0x7
  280912:	e8 c0 fc ff ff       	call   2805d7 <boxfill>
  280917:	83 c4 28             	add    $0x28,%esp
}
  28091a:	c9                   	leave  
  28091b:	c3                   	ret    

0028091c <init_screen>:


void init_screen(struct boot_info * bootp)
{
  28091c:	55                   	push   %ebp
  28091d:	89 e5                	mov    %esp,%ebp
  28091f:	8b 45 08             	mov    0x8(%ebp),%eax
  bootp->vram=(char *)VRAM;
  280922:	c7 40 08 00 00 0a 00 	movl   $0xa0000,0x8(%eax)
  bootp->color_mode=8;
  280929:	c6 40 02 08          	movb   $0x8,0x2(%eax)
  bootp->xsize=320;
  28092d:	66 c7 40 04 40 01    	movw   $0x140,0x4(%eax)
  bootp->ysize=200;
  280933:	66 c7 40 06 c8 00    	movw   $0xc8,0x6(%eax)

}
  280939:	5d                   	pop    %ebp
  28093a:	c3                   	ret    

0028093b <init_mouse>:

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
  28093b:	55                   	push   %ebp
  28093c:	31 c9                	xor    %ecx,%ecx
  28093e:	89 e5                	mov    %esp,%ebp
  280940:	8a 45 0c             	mov    0xc(%ebp),%al
  280943:	8b 55 08             	mov    0x8(%ebp),%edx
  280946:	56                   	push   %esi
  280947:	53                   	push   %ebx
  280948:	89 c6                	mov    %eax,%esi
  28094a:	31 c0                	xor    %eax,%eax
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
  28094c:	8a 9c 01 08 35 28 00 	mov    0x283508(%ecx,%eax,1),%bl
  280953:	80 fb 2e             	cmp    $0x2e,%bl
  280956:	74 10                	je     280968 <init_mouse+0x2d>
  280958:	80 fb 4f             	cmp    $0x4f,%bl
  28095b:	74 12                	je     28096f <init_mouse+0x34>
  28095d:	80 fb 2a             	cmp    $0x2a,%bl
  280960:	75 11                	jne    280973 <init_mouse+0x38>
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
  280962:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
  280966:	eb 0b                	jmp    280973 <init_mouse+0x38>
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
  280968:	89 f3                	mov    %esi,%ebx
  28096a:	88 1c 02             	mov    %bl,(%edx,%eax,1)
  28096d:	eb 04                	jmp    280973 <init_mouse+0x38>
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside
  28096f:	c6 04 02 02          	movb   $0x2,(%edx,%eax,1)
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
  280973:	40                   	inc    %eax
  280974:	83 f8 10             	cmp    $0x10,%eax
  280977:	75 d3                	jne    28094c <init_mouse+0x11>
  280979:	83 c1 10             	add    $0x10,%ecx
  28097c:	83 c2 10             	add    $0x10,%edx
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
  28097f:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  280985:	75 c3                	jne    28094a <init_mouse+0xf>

	  }

	}

}
  280987:	5b                   	pop    %ebx
  280988:	5e                   	pop    %esi
  280989:	5d                   	pop    %ebp
  28098a:	c3                   	ret    

0028098b <display_mouse>:

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  28098b:	55                   	push   %ebp
  28098c:	89 e5                	mov    %esp,%ebp
  28098e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280991:	56                   	push   %esi
  int x,y;
  for(y=0;y<pysize;y++)
  280992:	31 f6                	xor    %esi,%esi
	}

}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280994:	53                   	push   %ebx
  280995:	8b 5d 20             	mov    0x20(%ebp),%ebx
  280998:	0f af 45 0c          	imul   0xc(%ebp),%eax
  28099c:	03 45 18             	add    0x18(%ebp),%eax
  28099f:	03 45 08             	add    0x8(%ebp),%eax
  int x,y;
  for(y=0;y<pysize;y++)
  2809a2:	3b 75 14             	cmp    0x14(%ebp),%esi
  2809a5:	7d 19                	jge    2809c0 <display_mouse+0x35>
  2809a7:	31 d2                	xor    %edx,%edx
  {
    for(x=0;x<pxsize;x++)
  2809a9:	3b 55 10             	cmp    0x10(%ebp),%edx
  2809ac:	7d 09                	jge    2809b7 <display_mouse+0x2c>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
  2809ae:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  2809b1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
  2809b4:	42                   	inc    %edx
  2809b5:	eb f2                	jmp    2809a9 <display_mouse+0x1e>
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  2809b7:	46                   	inc    %esi
  2809b8:	03 5d 24             	add    0x24(%ebp),%ebx
  2809bb:	03 45 0c             	add    0xc(%ebp),%eax
  2809be:	eb e2                	jmp    2809a2 <display_mouse+0x17>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }

}
  2809c0:	5b                   	pop    %ebx
  2809c1:	5e                   	pop    %esi
  2809c2:	5d                   	pop    %ebp
  2809c3:	c3                   	ret    

002809c4 <make_window8>:


*/

void make_window8(unsigned char *buf,int xsize,int ysize,char *title)
{
  2809c4:	55                   	push   %ebp
  2809c5:	89 e5                	mov    %esp,%ebp
  2809c7:	57                   	push   %edi
  2809c8:	56                   	push   %esi
  2809c9:	53                   	push   %ebx
  2809ca:	83 ec 1c             	sub    $0x1c,%esp
  2809cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		"@@@@@@@@@@@@@@@@"
	};

	int x,y;
	char c;
    boxfill8(buf, xsize, 8, 0,         0,         xsize - 1, 0        );
  2809d0:	6a 00                	push   $0x0


*/

void make_window8(unsigned char *buf,int xsize,int ysize,char *title)
{
  2809d2:	8b 75 08             	mov    0x8(%ebp),%esi
		"@@@@@@@@@@@@@@@@"
	};

	int x,y;
	char c;
    boxfill8(buf, xsize, 8, 0,         0,         xsize - 1, 0        );
  2809d5:	8d 7b ff             	lea    -0x1(%ebx),%edi
  2809d8:	57                   	push   %edi
  2809d9:	6a 00                	push   $0x0
  2809db:	6a 00                	push   $0x0
  2809dd:	6a 08                	push   $0x8
  2809df:	53                   	push   %ebx
  2809e0:	56                   	push   %esi
  2809e1:	e8 c2 fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 7, 1,         1,         xsize - 2, 1        );
  2809e6:	8d 53 fe             	lea    -0x2(%ebx),%edx
  2809e9:	6a 01                	push   $0x1
  2809eb:	52                   	push   %edx
  2809ec:	6a 01                	push   $0x1
  2809ee:	6a 01                	push   $0x1
  2809f0:	6a 07                	push   $0x7
  2809f2:	53                   	push   %ebx
  2809f3:	56                   	push   %esi
  2809f4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  2809f7:	e8 ac fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 8, 0,         0,         0,         ysize - 1);
  2809fc:	8b 45 10             	mov    0x10(%ebp),%eax
  2809ff:	83 c4 38             	add    $0x38,%esp
  280a02:	48                   	dec    %eax
  280a03:	50                   	push   %eax
  280a04:	6a 00                	push   $0x0
  280a06:	6a 00                	push   $0x0
  280a08:	6a 00                	push   $0x0
  280a0a:	6a 08                	push   $0x8
  280a0c:	53                   	push   %ebx
  280a0d:	56                   	push   %esi
  280a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  280a11:	e8 92 fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 7, 1,         1,         1,         ysize - 2);
  280a16:	8b 55 10             	mov    0x10(%ebp),%edx
  280a19:	8d 42 fe             	lea    -0x2(%edx),%eax
  280a1c:	50                   	push   %eax
  280a1d:	6a 01                	push   $0x1
  280a1f:	6a 01                	push   $0x1
  280a21:	6a 01                	push   $0x1
  280a23:	6a 07                	push   $0x7
  280a25:	53                   	push   %ebx
  280a26:	56                   	push   %esi
  280a27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  280a2a:	e8 79 fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 15, xsize - 2, 1,         xsize - 2, ysize - 2);
  280a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  280a32:	83 c4 38             	add    $0x38,%esp
  280a35:	8b 55 d8             	mov    -0x28(%ebp),%edx
  280a38:	50                   	push   %eax
  280a39:	52                   	push   %edx
  280a3a:	6a 01                	push   $0x1
  280a3c:	52                   	push   %edx
  280a3d:	6a 0f                	push   $0xf
  280a3f:	53                   	push   %ebx
  280a40:	56                   	push   %esi
  280a41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  280a44:	89 55 e0             	mov    %edx,-0x20(%ebp)
  280a47:	e8 5c fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 0, xsize - 1, 0,         xsize - 1, ysize - 1);
  280a4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  280a4f:	57                   	push   %edi
  280a50:	6a 00                	push   $0x0
  280a52:	57                   	push   %edi
  280a53:	6a 00                	push   $0x0
  280a55:	53                   	push   %ebx
  280a56:	56                   	push   %esi
  280a57:	e8 4c fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 8, 2,         2,         xsize - 3, ysize - 3);
  280a5c:	8b 55 10             	mov    0x10(%ebp),%edx
  280a5f:	83 c4 38             	add    $0x38,%esp
  280a62:	8d 4a fd             	lea    -0x3(%edx),%ecx
  280a65:	51                   	push   %ecx
  280a66:	8d 4b fd             	lea    -0x3(%ebx),%ecx
  280a69:	51                   	push   %ecx
  280a6a:	6a 02                	push   $0x2
  280a6c:	6a 02                	push   $0x2
  280a6e:	6a 08                	push   $0x8
  280a70:	53                   	push   %ebx
  280a71:	56                   	push   %esi
  280a72:	e8 31 fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 12, 3,         3,         xsize - 4, 20       );
  280a77:	8d 4b fc             	lea    -0x4(%ebx),%ecx
  280a7a:	6a 14                	push   $0x14
  280a7c:	51                   	push   %ecx
  280a7d:	6a 03                	push   $0x3
  280a7f:	6a 03                	push   $0x3
  280a81:	6a 0c                	push   $0xc
  280a83:	53                   	push   %ebx
  280a84:	56                   	push   %esi
  280a85:	e8 1e fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 15, 1,         ysize - 2, xsize - 2, ysize - 2);
  280a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  280a8d:	83 c4 38             	add    $0x38,%esp
  280a90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  280a93:	50                   	push   %eax
  280a94:	52                   	push   %edx
  280a95:	50                   	push   %eax
  280a96:	6a 01                	push   $0x1
  280a98:	6a 0f                	push   $0xf
  280a9a:	53                   	push   %ebx
  280a9b:	56                   	push   %esi
  280a9c:	e8 07 fb ff ff       	call   2805a8 <boxfill8>
	boxfill8(buf, xsize, 0, 0,         ysize - 1, xsize - 1, ysize - 1);
  280aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  280aa4:	50                   	push   %eax
  280aa5:	57                   	push   %edi


 puts8(buf,xsize,24,4,7,title);
  280aa6:	31 ff                	xor    %edi,%edi
	boxfill8(buf, xsize, 15, xsize - 2, 1,         xsize - 2, ysize - 2);
	boxfill8(buf, xsize, 0, xsize - 1, 0,         xsize - 1, ysize - 1);
	boxfill8(buf, xsize, 8, 2,         2,         xsize - 3, ysize - 3);
	boxfill8(buf, xsize, 12, 3,         3,         xsize - 4, 20       );
	boxfill8(buf, xsize, 15, 1,         ysize - 2, xsize - 2, ysize - 2);
	boxfill8(buf, xsize, 0, 0,         ysize - 1, xsize - 1, ysize - 1);
  280aa8:	50                   	push   %eax
  280aa9:	6a 00                	push   $0x0
  280aab:	6a 00                	push   $0x0
  280aad:	53                   	push   %ebx
  280aae:	56                   	push   %esi
  280aaf:	e8 f4 fa ff ff       	call   2805a8 <boxfill8>


 puts8(buf,xsize,24,4,7,title);
  280ab4:	83 c4 30             	add    $0x30,%esp
  280ab7:	ff 75 14             	pushl  0x14(%ebp)
  280aba:	6a 07                	push   $0x7
  280abc:	6a 04                	push   $0x4
  280abe:	6a 18                	push   $0x18
  280ac0:	53                   	push   %ebx
  280ac1:	56                   	push   %esi
  280ac2:	e8 0c 02 00 00       	call   280cd3 <puts8>
  280ac7:	6b c3 06             	imul   $0x6,%ebx,%eax
  280aca:	83 c4 20             	add    $0x20,%esp
  280acd:	31 d2                	xor    %edx,%edx
  280acf:	01 c6                	add    %eax,%esi


*/

void make_window8(unsigned char *buf,int xsize,int ysize,char *title)
{
  280ad1:	31 c0                	xor    %eax,%eax
 //write the x button to the buf
 for(y=0;y<14;y++)
 {
    for(x=0;x<16;x++)
    {
        c=closebtn[y][x];
  280ad3:	8a 8c 02 28 34 28 00 	mov    0x283428(%edx,%eax,1),%cl
        if(c=='@')
  280ada:	80 f9 40             	cmp    $0x40,%cl
  280add:	74 10                	je     280aef <make_window8+0x12b>
        c=0;
        else if(c=='$')
  280adf:	80 f9 24             	cmp    $0x24,%cl
  280ae2:	74 0f                	je     280af3 <make_window8+0x12f>
        c=15;
        else if(c=='Q')
        c=8;
  280ae4:	80 f9 51             	cmp    $0x51,%cl
  280ae7:	0f 94 c1             	sete   %cl
  280aea:	83 c1 07             	add    $0x7,%ecx
  280aed:	eb 06                	jmp    280af5 <make_window8+0x131>
 {
    for(x=0;x<16;x++)
    {
        c=closebtn[y][x];
        if(c=='@')
        c=0;
  280aef:	31 c9                	xor    %ecx,%ecx
  280af1:	eb 02                	jmp    280af5 <make_window8+0x131>
        else if(c=='$')
        c=15;
  280af3:	b1 0f                	mov    $0xf,%cl

 puts8(buf,xsize,24,4,7,title);
 //write the x button to the buf
 for(y=0;y<14;y++)
 {
    for(x=0;x<16;x++)
  280af5:	40                   	inc    %eax
  280af6:	83 f8 10             	cmp    $0x10,%eax
  280af9:	75 d8                	jne    280ad3 <make_window8+0x10f>
  280afb:	83 c2 10             	add    $0x10,%edx
        c=15;
        else if(c=='Q')
        c=8;
        else c=7;
    }
    buf[(5+y)*xsize+(xsize-21+x)]=c;
  280afe:	88 4c 3e fb          	mov    %cl,-0x5(%esi,%edi,1)
  280b02:	01 df                	add    %ebx,%edi
	boxfill8(buf, xsize, 0, 0,         ysize - 1, xsize - 1, ysize - 1);


 puts8(buf,xsize,24,4,7,title);
 //write the x button to the buf
 for(y=0;y<14;y++)
  280b04:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
  280b0a:	75 c5                	jne    280ad1 <make_window8+0x10d>
 return;




}
  280b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280b0f:	5b                   	pop    %ebx
  280b10:	5e                   	pop    %esi
  280b11:	5f                   	pop    %edi
  280b12:	5d                   	pop    %ebp
  280b13:	c3                   	ret    

00280b14 <itoa>:
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  280b14:	55                   	push   %ebp
   unsigned char tmp_buf[10] = {0};
  280b15:	31 c0                	xor    %eax,%eax
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  280b17:	89 e5                	mov    %esp,%ebp
   unsigned char tmp_buf[10] = {0};
  280b19:	b9 0a 00 00 00       	mov    $0xa,%ecx
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  280b1e:	57                   	push   %edi
  280b1f:	56                   	push   %esi
  280b20:	53                   	push   %ebx
  280b21:	83 ec 10             	sub    $0x10,%esp
  280b24:	8b 55 08             	mov    0x8(%ebp),%edx
   unsigned char tmp_buf[10] = {0};
  280b27:	8d 7d ea             	lea    -0x16(%ebp),%edi
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  280b2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   unsigned char tmp_buf[10] = {0};
  280b2d:	f3 aa                	rep stos %al,%es:(%edi)
  280b2f:	8d 7d ea             	lea    -0x16(%ebp),%edi
    unsigned char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
  280b32:	85 d2                	test   %edx,%edx
  280b34:	79 06                	jns    280b3c <itoa+0x28>
    { /* neg num */
        *buf++ = '-';//得到负号
  280b36:	c6 03 2d             	movb   $0x2d,(%ebx)
        value = ~value + 1; //将负数变为正数
  280b39:	f7 da                	neg    %edx
void itoa(int value,unsigned char *buf){
   unsigned char tmp_buf[10] = {0};
    unsigned char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
  280b3b:	43                   	inc    %ebx
  280b3c:	89 f9                	mov    %edi,%ecx



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280b3e:	be 0a 00 00 00       	mov    $0xa,%esi
  280b43:	89 d0                	mov    %edx,%eax
  280b45:	41                   	inc    %ecx
  280b46:	99                   	cltd   
  280b47:	f7 fe                	idiv   %esi
  280b49:	83 c2 30             	add    $0x30,%edx
        value /= 10;
    }while(value);
  280b4c:	85 c0                	test   %eax,%eax



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280b4e:	88 51 ff             	mov    %dl,-0x1(%ecx)
        value /= 10;
  280b51:	89 c2                	mov    %eax,%edx
    }while(value);
  280b53:	75 ee                	jne    280b43 <itoa+0x2f>



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280b55:	89 ce                	mov    %ecx,%esi
  280b57:	89 d8                	mov    %ebx,%eax
        value /= 10;
    }while(value);


    while(tmp_buf != tbp)
  280b59:	39 f9                	cmp    %edi,%ecx
  280b5b:	74 09                	je     280b66 <itoa+0x52>
    {
      tbp--;
  280b5d:	49                   	dec    %ecx
      *buf++ = *tbp;
  280b5e:	8a 11                	mov    (%ecx),%dl
  280b60:	40                   	inc    %eax
  280b61:	88 50 ff             	mov    %dl,-0x1(%eax)
  280b64:	eb f3                	jmp    280b59 <itoa+0x45>
  280b66:	89 f0                	mov    %esi,%eax
  280b68:	29 c8                	sub    %ecx,%eax

    }
    *buf='\0';
  280b6a:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)


}
  280b6e:	83 c4 10             	add    $0x10,%esp
  280b71:	5b                   	pop    %ebx
  280b72:	5e                   	pop    %esi
  280b73:	5f                   	pop    %edi
  280b74:	5d                   	pop    %ebp
  280b75:	c3                   	ret    

00280b76 <xtoa>:
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  280b76:	55                   	push   %ebp
   unsigned char tmp_buf[30] = {0};
  280b77:	31 c0                	xor    %eax,%eax
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  280b79:	89 e5                	mov    %esp,%ebp
   unsigned char tmp_buf[30] = {0};
  280b7b:	b9 1e 00 00 00       	mov    $0x1e,%ecx
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  280b80:	57                   	push   %edi
  280b81:	56                   	push   %esi
  280b82:	53                   	push   %ebx
  280b83:	83 ec 20             	sub    $0x20,%esp
  280b86:	8b 55 0c             	mov    0xc(%ebp),%edx
   unsigned char tmp_buf[30] = {0};
  280b89:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280b8c:	f3 aa                	rep stos %al,%es:(%edi)
   unsigned char *tbp = tmp_buf;
  280b8e:	8d 45 d6             	lea    -0x2a(%ebp),%eax

    *buf++='0';
  280b91:	c6 02 30             	movb   $0x30,(%edx)
    *buf++='x';
  280b94:	8d 72 02             	lea    0x2(%edx),%esi
  280b97:	c6 42 01 78          	movb   $0x78,0x1(%edx)

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  280b9e:	40                   	inc    %eax
  280b9f:	83 e3 0f             	and    $0xf,%ebx


}
static  inline unsigned char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
  280ba2:	83 fb 0a             	cmp    $0xa,%ebx
  280ba5:	8d 4b 37             	lea    0x37(%ebx),%ecx
  280ba8:	8d 7b 30             	lea    0x30(%ebx),%edi
  280bab:	0f 4c cf             	cmovl  %edi,%ecx
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280bae:	c1 6d 08 04          	shrl   $0x4,0x8(%ebp)
static  inline unsigned char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
  280bb2:	88 48 ff             	mov    %cl,-0x1(%eax)
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280bb5:	75 e4                	jne    280b9b <xtoa+0x25>
    *buf++='x';

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280bb7:	89 c3                	mov    %eax,%ebx
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);


    while(tmp_buf != tbp)
  280bb9:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280bbc:	39 f8                	cmp    %edi,%eax
  280bbe:	74 09                	je     280bc9 <xtoa+0x53>
    {
      tbp--;
  280bc0:	48                   	dec    %eax
      *buf++ = *tbp;
  280bc1:	8a 08                	mov    (%eax),%cl
  280bc3:	46                   	inc    %esi
  280bc4:	88 4e ff             	mov    %cl,-0x1(%esi)
  280bc7:	eb f0                	jmp    280bb9 <xtoa+0x43>
  280bc9:	29 c3                	sub    %eax,%ebx

    }
    *buf='\0';
  280bcb:	c6 44 1a 02 00       	movb   $0x0,0x2(%edx,%ebx,1)


}
  280bd0:	83 c4 20             	add    $0x20,%esp
  280bd3:	5b                   	pop    %ebx
  280bd4:	5e                   	pop    %esi
  280bd5:	5f                   	pop    %edi
  280bd6:	5d                   	pop    %ebp
  280bd7:	c3                   	ret    

00280bd8 <sprintf>:



//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf( char *str, char *format ,...)
{
  280bd8:	55                   	push   %ebp
  280bd9:	89 e5                	mov    %esp,%ebp
  280bdb:	57                   	push   %edi
  280bdc:	56                   	push   %esi
  280bdd:	53                   	push   %ebx
  280bde:	83 ec 10             	sub    $0x10,%esp
  280be1:	8b 5d 08             	mov    0x8(%ebp),%ebx

   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
  280be4:	8d 75 10             	lea    0x10(%ebp),%esi
    char buffer[10];
    char *buf=buffer;
  while(*format)
  280be7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  280bea:	8a 07                	mov    (%edi),%al
  280bec:	84 c0                	test   %al,%al
  280bee:	0f 84 83 00 00 00    	je     280c77 <sprintf+0x9f>
  280bf4:	8d 4f 01             	lea    0x1(%edi),%ecx
  {
      if(*format!='%')
  280bf7:	3c 25                	cmp    $0x25,%al
      {
	*str++=*format++;
  280bf9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
    char buffer[10];
    char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
  280bfc:	74 05                	je     280c03 <sprintf+0x2b>
      {
	*str++=*format++;
  280bfe:	88 03                	mov    %al,(%ebx)
  280c00:	43                   	inc    %ebx
	continue;
  280c01:	eb e4                	jmp    280be7 <sprintf+0xf>
      }
      else
      {
	format++;
	switch (*format)
  280c03:	8a 47 01             	mov    0x1(%edi),%al
  280c06:	3c 73                	cmp    $0x73,%al
  280c08:	74 46                	je     280c50 <sprintf+0x78>
  280c0a:	3c 78                	cmp    $0x78,%al
  280c0c:	74 23                	je     280c31 <sprintf+0x59>
  280c0e:	3c 64                	cmp    $0x64,%al
  280c10:	75 53                	jne    280c65 <sprintf+0x8d>
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
  280c12:	8d 45 ea             	lea    -0x16(%ebp),%eax
  280c15:	50                   	push   %eax
  280c16:	ff 36                	pushl  (%esi)
  280c18:	e8 f7 fe ff ff       	call   280b14 <itoa>
  280c1d:	59                   	pop    %ecx
  280c1e:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  280c21:	58                   	pop    %eax
  280c22:	89 d8                	mov    %ebx,%eax
  280c24:	8a 19                	mov    (%ecx),%bl
  280c26:	84 db                	test   %bl,%bl
  280c28:	74 3d                	je     280c67 <sprintf+0x8f>
  280c2a:	40                   	inc    %eax
  280c2b:	41                   	inc    %ecx
  280c2c:	88 58 ff             	mov    %bl,-0x1(%eax)
  280c2f:	eb f3                	jmp    280c24 <sprintf+0x4c>
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
  280c31:	8d 45 ea             	lea    -0x16(%ebp),%eax
  280c34:	50                   	push   %eax
  280c35:	ff 36                	pushl  (%esi)
  280c37:	e8 3a ff ff ff       	call   280b76 <xtoa>
  280c3c:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  280c3f:	58                   	pop    %eax
  280c40:	89 d8                	mov    %ebx,%eax
  280c42:	5a                   	pop    %edx
  280c43:	8a 19                	mov    (%ecx),%bl
  280c45:	84 db                	test   %bl,%bl
  280c47:	74 1e                	je     280c67 <sprintf+0x8f>
  280c49:	40                   	inc    %eax
  280c4a:	41                   	inc    %ecx
  280c4b:	88 58 ff             	mov    %bl,-0x1(%eax)
  280c4e:	eb f3                	jmp    280c43 <sprintf+0x6b>
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
  280c50:	8b 16                	mov    (%esi),%edx
  280c52:	89 d8                	mov    %ebx,%eax
  280c54:	89 c1                	mov    %eax,%ecx
  280c56:	29 d9                	sub    %ebx,%ecx
  280c58:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
  280c5b:	84 c9                	test   %cl,%cl
  280c5d:	74 08                	je     280c67 <sprintf+0x8f>
  280c5f:	40                   	inc    %eax
  280c60:	88 48 ff             	mov    %cl,-0x1(%eax)
  280c63:	eb ef                	jmp    280c54 <sprintf+0x7c>
	continue;
      }
      else
      {
	format++;
	switch (*format)
  280c65:	89 d8                	mov    %ebx,%eax
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
	format++;
  280c67:	83 c7 02             	add    $0x2,%edi
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
  280c6a:	83 c6 04             	add    $0x4,%esi
	format++;
  280c6d:	89 7d 0c             	mov    %edi,0xc(%ebp)
  280c70:	89 c3                	mov    %eax,%ebx
  280c72:	e9 70 ff ff ff       	jmp    280be7 <sprintf+0xf>

      }

  }
  *str='\0';
  280c77:	c6 03 00             	movb   $0x0,(%ebx)

}
  280c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280c7d:	5b                   	pop    %ebx
  280c7e:	5e                   	pop    %esi
  280c7f:	5f                   	pop    %edi
  280c80:	5d                   	pop    %ebp
  280c81:	c3                   	ret    

00280c82 <putfont8>:
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280c82:	55                   	push   %ebp
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280c83:	31 d2                	xor    %edx,%edx
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280c85:	89 e5                	mov    %esp,%ebp
  280c87:	57                   	push   %edi
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280c88:	bf 80 00 00 00       	mov    $0x80,%edi
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280c8d:	56                   	push   %esi
  280c8e:	53                   	push   %ebx
  280c8f:	83 ec 01             	sub    $0x1,%esp
  280c92:	8a 45 18             	mov    0x18(%ebp),%al
  280c95:	88 45 f3             	mov    %al,-0xd(%ebp)
  280c98:	8b 45 14             	mov    0x14(%ebp),%eax
  280c9b:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280c9f:	03 45 10             	add    0x10(%ebp),%eax
  280ca2:	03 45 08             	add    0x8(%ebp),%eax
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280ca5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280ca8:	31 c9                	xor    %ecx,%ecx
    {
      if(d&(0x80>>col))
  280caa:	0f be 34 16          	movsbl (%esi,%edx,1),%esi
  280cae:	89 fb                	mov    %edi,%ebx
  280cb0:	d3 fb                	sar    %cl,%ebx
  280cb2:	85 f3                	test   %esi,%ebx
  280cb4:	74 06                	je     280cbc <putfont8+0x3a>
      {
	vram[(y+row)*xsize+x+col]=color;
  280cb6:	8a 5d f3             	mov    -0xd(%ebp),%bl
  280cb9:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280cbc:	41                   	inc    %ecx
  280cbd:	83 f9 08             	cmp    $0x8,%ecx
  280cc0:	75 ec                	jne    280cae <putfont8+0x2c>

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280cc2:	42                   	inc    %edx
  280cc3:	03 45 0c             	add    0xc(%ebp),%eax
  280cc6:	83 fa 10             	cmp    $0x10,%edx
  280cc9:	75 da                	jne    280ca5 <putfont8+0x23>
    }

  }
  return;

}
  280ccb:	83 c4 01             	add    $0x1,%esp
  280cce:	5b                   	pop    %ebx
  280ccf:	5e                   	pop    %esi
  280cd0:	5f                   	pop    %edi
  280cd1:	5d                   	pop    %ebp
  280cd2:	c3                   	ret    

00280cd3 <puts8>:
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,unsigned char *font)//x=0 311 y=0 183
{
  280cd3:	55                   	push   %ebp
  280cd4:	89 e5                	mov    %esp,%ebp
  280cd6:	57                   	push   %edi
  280cd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  280cda:	56                   	push   %esi
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280cdb:	0f be 75 18          	movsbl 0x18(%ebp),%esi
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,unsigned char *font)//x=0 311 y=0 183
{
  280cdf:	53                   	push   %ebx
  280ce0:	8b 5d 10             	mov    0x10(%ebp),%ebx

 while(*font)
  280ce3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280ce6:	0f b6 00             	movzbl (%eax),%eax
  280ce9:	84 c0                	test   %al,%al
  280ceb:	74 3f                	je     280d2c <puts8+0x59>
 {
    if(*font=='\n')
  280ced:	3c 0a                	cmp    $0xa,%al
  280cef:	75 05                	jne    280cf6 <puts8+0x23>
    {
      x=0;
      y=y+16;
  280cf1:	83 c7 10             	add    $0x10,%edi
  280cf4:	eb 2f                	jmp    280d25 <puts8+0x52>

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280cf6:	c1 e0 04             	shl    $0x4,%eax
  280cf9:	05 28 1a 28 00       	add    $0x281a28,%eax
  280cfe:	50                   	push   %eax
  280cff:	56                   	push   %esi
  280d00:	57                   	push   %edi
  280d01:	53                   	push   %ebx
    x+=8;
  280d02:	83 c3 08             	add    $0x8,%ebx
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280d05:	ff 75 0c             	pushl  0xc(%ebp)
  280d08:	ff 75 08             	pushl  0x8(%ebp)
  280d0b:	e8 72 ff ff ff       	call   280c82 <putfont8>
    x+=8;
    if(x>xsize)
  280d10:	83 c4 18             	add    $0x18,%esp
  280d13:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  280d16:	7e 0f                	jle    280d27 <puts8+0x54>
       {
	  x=0;
	  y+=16;
  280d18:	83 c7 10             	add    $0x10,%edi
	  if(y>183)
  280d1b:	81 ff b7 00 00 00    	cmp    $0xb7,%edi
  280d21:	7e 02                	jle    280d25 <puts8+0x52>
	  {
	    x=0;
	    y=0;
  280d23:	31 ff                	xor    %edi,%edi
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
  280d25:	31 db                	xor    %ebx,%ebx

	  }
        }
    }

    font++;
  280d27:	ff 45 1c             	incl   0x1c(%ebp)
  280d2a:	eb b7                	jmp    280ce3 <puts8+0x10>
}

}
  280d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280d2f:	5b                   	pop    %ebx
  280d30:	5e                   	pop    %esi
  280d31:	5f                   	pop    %edi
  280d32:	5d                   	pop    %ebp
  280d33:	c3                   	ret    

00280d34 <printdebug>:
#include<header.h>


void printdebug(unsigned int i,unsigned int x)
{
  280d34:	55                   	push   %ebp
  280d35:	89 e5                	mov    %esp,%ebp
  280d37:	53                   	push   %ebx
  280d38:	83 ec 20             	sub    $0x20,%esp
char font[30];
sprintf(font,"Debug:var=%x" ,i);
  280d3b:	ff 75 08             	pushl  0x8(%ebp)
  280d3e:	8d 5d de             	lea    -0x22(%ebp),%ebx
  280d41:	68 46 36 28 00       	push   $0x283646
  280d46:	53                   	push   %ebx
  280d47:	e8 8c fe ff ff       	call   280bd8 <sprintf>
puts8((char *)VRAM ,320,x,150,1,font);
  280d4c:	53                   	push   %ebx
  280d4d:	6a 01                	push   $0x1
  280d4f:	68 96 00 00 00       	push   $0x96
  280d54:	ff 75 0c             	pushl  0xc(%ebp)
  280d57:	68 40 01 00 00       	push   $0x140
  280d5c:	68 00 00 0a 00       	push   $0xa0000
  280d61:	e8 6d ff ff ff       	call   280cd3 <puts8>
  280d66:	83 c4 24             	add    $0x24,%esp

}
  280d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280d6c:	c9                   	leave  
  280d6d:	c3                   	ret    

00280d6e <putfont16>:

  }

}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  280d6e:	55                   	push   %ebp
  280d6f:	31 c9                	xor    %ecx,%ecx
  280d71:	89 e5                	mov    %esp,%ebp
  280d73:	57                   	push   %edi
  280d74:	56                   	push   %esi
  280d75:	53                   	push   %ebx
  280d76:	52                   	push   %edx
  280d77:	8b 55 14             	mov    0x14(%ebp),%edx
  280d7a:	0f af 55 0c          	imul   0xc(%ebp),%edx
  280d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  280d81:	03 45 08             	add    0x8(%ebp),%eax
  280d84:	8a 5d 18             	mov    0x18(%ebp),%bl
  280d87:	01 d0                	add    %edx,%eax
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280d89:	31 d2                	xor    %edx,%edx
  280d8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
  280d8e:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  280d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280d94:	0f b7 bc 57 00 fa ff 	movzwl -0x600(%edi,%edx,2),%edi
  280d9b:	ff 
  280d9c:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280d9f:	31 c0                	xor    %eax,%eax
    {
       if( (d&(1 << col) ))
  280da1:	0f a3 c7             	bt     %eax,%edi
  280da4:	73 03                	jae    280da9 <putfont16+0x3b>
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;
  280da6:	88 1c 06             	mov    %bl,(%esi,%eax,1)
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280da9:	40                   	inc    %eax
  280daa:	83 f8 10             	cmp    $0x10,%eax
  280dad:	75 f2                	jne    280da1 <putfont16+0x33>
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280daf:	42                   	inc    %edx
  280db0:	03 4d 0c             	add    0xc(%ebp),%ecx
  280db3:	83 fa 18             	cmp    $0x18,%edx
  280db6:	75 d6                	jne    280d8e <putfont16+0x20>
    }

  }
  return;

}
  280db8:	58                   	pop    %eax
  280db9:	5b                   	pop    %ebx
  280dba:	5e                   	pop    %esi
  280dbb:	5f                   	pop    %edi
  280dbc:	5d                   	pop    %ebp
  280dbd:	c3                   	ret    

00280dbe <puts16>:
  return;

}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  280dbe:	55                   	push   %ebp
  280dbf:	89 e5                	mov    %esp,%ebp
  280dc1:	57                   	push   %edi
  280dc2:	8b 7d 10             	mov    0x10(%ebp),%edi
  280dc5:	56                   	push   %esi
  280dc6:	8b 75 14             	mov    0x14(%ebp),%esi
  280dc9:	53                   	push   %ebx

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280dca:	0f be 5d 18          	movsbl 0x18(%ebp),%ebx
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  280dce:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280dd1:	0f be 00             	movsbl (%eax),%eax
  280dd4:	84 c0                	test   %al,%al
  280dd6:	74 2d                	je     280e05 <puts16+0x47>
  {
    if(*font=='\n')
  280dd8:	3c 0a                	cmp    $0xa,%al
  280dda:	75 07                	jne    280de3 <puts16+0x25>
    {
      x=0;
      y=y+24;
  280ddc:	83 c6 18             	add    $0x18,%esi
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
  280ddf:	31 ff                	xor    %edi,%edi
  280de1:	eb 1d                	jmp    280e00 <puts16+0x42>
      y=y+24;

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
  280de3:	6b c0 30             	imul   $0x30,%eax,%eax
  280de6:	05 28 22 28 00       	add    $0x282228,%eax
	putfont16(vram ,xsize,x,y,color,pt);
  280deb:	50                   	push   %eax
  280dec:	53                   	push   %ebx
  280ded:	56                   	push   %esi
  280dee:	57                   	push   %edi
	x=x+16;
  280def:	83 c7 10             	add    $0x10,%edi

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280df2:	ff 75 0c             	pushl  0xc(%ebp)
  280df5:	ff 75 08             	pushl  0x8(%ebp)
  280df8:	e8 71 ff ff ff       	call   280d6e <putfont16>
	x=x+16;
  280dfd:	83 c4 18             	add    $0x18,%esp


    }

     font++;
  280e00:	ff 45 1c             	incl   0x1c(%ebp)
  280e03:	eb c9                	jmp    280dce <puts16+0x10>

  }

}
  280e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280e08:	5b                   	pop    %ebx
  280e09:	5e                   	pop    %esi
  280e0a:	5f                   	pop    %edi
  280e0b:	5d                   	pop    %ebp
  280e0c:	c3                   	ret    

00280e0d <setgdt>:
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  280e0d:	55                   	push   %ebp
  280e0e:	89 e5                	mov    %esp,%ebp
  280e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  280e13:	57                   	push   %edi
  280e14:	8b 45 08             	mov    0x8(%ebp),%eax
  280e17:	56                   	push   %esi
  280e18:	8b 7d 14             	mov    0x14(%ebp),%edi
  280e1b:	53                   	push   %ebx
  280e1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(limit>0xffff)
  280e1f:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
  280e25:	76 09                	jbe    280e30 <setgdt+0x23>
  {
    access|=0x8000;
  280e27:	81 cf 00 80 00 00    	or     $0x8000,%edi
    limit /=0x1000;
  280e2d:	c1 ea 0c             	shr    $0xc,%edx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  280e30:	89 de                	mov    %ebx,%esi
  280e32:	c1 fe 10             	sar    $0x10,%esi
  280e35:	89 f1                	mov    %esi,%ecx
  280e37:	88 48 04             	mov    %cl,0x4(%eax)
  sd->access_right=access&0xff;
  280e3a:	89 f9                	mov    %edi,%ecx
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280e3c:	c1 ff 08             	sar    $0x8,%edi
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  280e3f:	88 48 05             	mov    %cl,0x5(%eax)
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280e42:	89 f9                	mov    %edi,%ecx
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  280e44:	66 89 10             	mov    %dx,(%eax)
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280e47:	83 e1 f0             	and    $0xfffffff0,%ecx
  280e4a:	c1 ea 10             	shr    $0x10,%edx
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  280e4d:	66 89 58 02          	mov    %bx,0x2(%eax)
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280e51:	09 d1                	or     %edx,%ecx
  sd->base_high=(base>>24)&0xff;
  280e53:	c1 eb 18             	shr    $0x18,%ebx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280e56:	88 48 06             	mov    %cl,0x6(%eax)
  sd->base_high=(base>>24)&0xff;
  280e59:	88 58 07             	mov    %bl,0x7(%eax)

}
  280e5c:	5b                   	pop    %ebx
  280e5d:	5e                   	pop    %esi
  280e5e:	5f                   	pop    %edi
  280e5f:	5d                   	pop    %ebp
  280e60:	c3                   	ret    

00280e61 <setidt>:

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  280e61:	55                   	push   %ebp
  280e62:	89 e5                	mov    %esp,%ebp
  280e64:	8b 45 08             	mov    0x8(%ebp),%eax
  280e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  280e6a:	8b 55 14             	mov    0x14(%ebp),%edx
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280e6d:	66 89 08             	mov    %cx,(%eax)
  gd->offset_high=(offset>>16)&0xffff;
  280e70:	c1 e9 10             	shr    $0x10,%ecx
  280e73:	66 89 48 06          	mov    %cx,0x6(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  280e77:	8b 4d 10             	mov    0x10(%ebp),%ecx

  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280e7a:	88 50 05             	mov    %dl,0x5(%eax)
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  280e7d:	66 89 48 02          	mov    %cx,0x2(%eax)

  gd->dw_count=(access>>8)&0xff;
  280e81:	89 d1                	mov    %edx,%ecx
  280e83:	c1 f9 08             	sar    $0x8,%ecx
  280e86:	88 48 04             	mov    %cl,0x4(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的


}
  280e89:	5d                   	pop    %ebp
  280e8a:	c3                   	ret    

00280e8b <init_gdtidt>:



void  init_gdtidt()
{
  280e8b:	55                   	push   %ebp
  280e8c:	89 e5                	mov    %esp,%ebp
  280e8e:	53                   	push   %ebx
  280e8f:	53                   	push   %ebx
  280e90:	bb 00 00 27 00       	mov    $0x270000,%ebx
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  280e95:	6a 00                	push   $0x0
  280e97:	6a 00                	push   $0x0
  280e99:	6a 00                	push   $0x0
  280e9b:	53                   	push   %ebx
  280e9c:	83 c3 08             	add    $0x8,%ebx
  280e9f:	e8 69 ff ff ff       	call   280e0d <setgdt>
void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  280ea4:	83 c4 10             	add    $0x10,%esp
  280ea7:	81 fb 00 00 28 00    	cmp    $0x280000,%ebx
  280ead:	75 e6                	jne    280e95 <init_gdtidt+0xa>
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  280eaf:	68 92 40 00 00       	push   $0x4092
  280eb4:	6a 00                	push   $0x0
  280eb6:	6a ff                	push   $0xffffffff
  280eb8:	68 08 00 27 00       	push   $0x270008
  280ebd:	e8 4b ff ff ff       	call   280e0d <setgdt>
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  280ec2:	68 9a 40 00 00       	push   $0x409a
  280ec7:	6a 00                	push   $0x0
  280ec9:	68 ff ff 0f 00       	push   $0xfffff
  280ece:	68 10 00 27 00       	push   $0x270010
  280ed3:	e8 35 ff ff ff       	call   280e0d <setgdt>
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  280ed8:	83 c4 20             	add    $0x20,%esp
  280edb:	68 9a 40 00 00       	push   $0x409a
  280ee0:	68 00 00 28 00       	push   $0x280000
  280ee5:	68 ff ff 0f 00       	push   $0xfffff
  280eea:	68 18 00 27 00       	push   $0x270018
  280eef:	e8 19 ff ff ff       	call   280e0d <setgdt>

   load_gdtr(0xfff,0X00270000);//this is right
  280ef4:	5a                   	pop    %edx
  280ef5:	59                   	pop    %ecx
  280ef6:	68 00 00 27 00       	push   $0x270000
  280efb:	68 ff 0f 00 00       	push   $0xfff
  280f00:	e8 d1 01 00 00       	call   2810d6 <load_gdtr>
  280f05:	83 c4 10             	add    $0x10,%esp
  280f08:	31 c0                	xor    %eax,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280f0a:	66 c7 80 00 f8 26 00 	movw   $0x0,0x26f800(%eax)
  280f11:	00 00 
  280f13:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280f16:	66 c7 80 fe f7 26 00 	movw   $0x0,0x26f7fe(%eax)
  280f1d:	00 00 

  //16位的selector决定了base address
  gd->selector=selector;
  280f1f:	66 c7 80 fa f7 26 00 	movw   $0x0,0x26f7fa(%eax)
  280f26:	00 00 

  gd->dw_count=(access>>8)&0xff;
  280f28:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280f2f:	c6 80 fd f7 26 00 00 	movb   $0x0,0x26f7fd(%eax)
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  280f36:	3d 00 08 00 00       	cmp    $0x800,%eax
  280f3b:	75 cd                	jne    280f0a <init_gdtidt+0x7f>

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  280f3d:	ba a0 10 28 00       	mov    $0x2810a0,%edx
  280f42:	66 31 c0             	xor    %ax,%ax
  280f45:	c1 ea 10             	shr    $0x10,%edx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280f48:	b9 a0 10 28 00       	mov    $0x2810a0,%ecx
  280f4d:	66 89 88 00 f8 26 00 	mov    %cx,0x26f800(%eax)
  280f54:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280f57:	66 89 90 fe f7 26 00 	mov    %dx,0x26f7fe(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  280f5e:	66 c7 80 fa f7 26 00 	movw   $0x18,0x26f7fa(%eax)
  280f65:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280f67:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280f6e:	c6 80 fd f7 26 00 8e 	movb   $0x8e,0x26f7fd(%eax)
  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }

  for(i=0;i<256;i++)
  280f75:	3d 00 08 00 00       	cmp    $0x800,%eax
  280f7a:	75 d1                	jne    280f4d <init_gdtidt+0xc2>
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  280f7c:	b8 a0 10 00 00       	mov    $0x10a0,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280f81:	66 a3 08 f9 26 00    	mov    %ax,0x26f908
  gd->offset_high=(offset>>16)&0xffff;
  280f87:	c1 e8 10             	shr    $0x10,%eax
  280f8a:	66 a3 0e f9 26 00    	mov    %ax,0x26f90e
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  setidt(idt+0x2c,(int)asm_inthandler2c-0x280000,3*8,0x008e);//挂载mouse 　　interrupt service
  280f90:	b8 bb 10 00 00       	mov    $0x10bb,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280f95:	66 a3 60 f9 26 00    	mov    %ax,0x26f960
  gd->offset_high=(offset>>16)&0xffff;
  280f9b:	c1 e8 10             	shr    $0x10,%eax
  280f9e:	66 a3 66 f9 26 00    	mov    %ax,0x26f966

  //16位的selector决定了base address
  gd->selector=selector;
  280fa4:	66 c7 05 0a f9 26 00 	movw   $0x18,0x26f90a
  280fab:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280fad:	c6 05 0c f9 26 00 00 	movb   $0x0,0x26f90c
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280fb4:	c6 05 0d f9 26 00 8e 	movb   $0x8e,0x26f90d
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  280fbb:	66 c7 05 62 f9 26 00 	movw   $0x18,0x26f962
  280fc2:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280fc4:	c6 05 64 f9 26 00 00 	movb   $0x0,0x26f964
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280fcb:	c6 05 65 f9 26 00 8e 	movb   $0x8e,0x26f965

 // setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service
 // setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt serv
  //printdebug(asm_inthandler2c,0);

  load_idtr(0x7ff,0x0026f800);//this is right
  280fd2:	50                   	push   %eax
  280fd3:	50                   	push   %eax
  280fd4:	68 00 f8 26 00       	push   $0x26f800
  280fd9:	68 ff 07 00 00       	push   $0x7ff
  280fde:	e8 03 01 00 00       	call   2810e6 <load_idtr>
  280fe3:	83 c4 10             	add    $0x10,%esp



  return;

}
  280fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280fe9:	c9                   	leave  
  280fea:	c3                   	ret    

00280feb <init_pic>:
#define PIC1_ICW4		0x00a1
*/

//remap irq0-irq15到int 0x20到int 0x2f
void init_pic()
{
  280feb:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280fec:	ba 21 00 00 00       	mov    $0x21,%edx
  280ff1:	89 e5                	mov    %esp,%ebp
  280ff3:	b0 ff                	mov    $0xff,%al
  280ff5:	ee                   	out    %al,(%dx)
  280ff6:	b2 a1                	mov    $0xa1,%dl
  280ff8:	ee                   	out    %al,(%dx)
  280ff9:	b0 11                	mov    $0x11,%al
  280ffb:	b2 20                	mov    $0x20,%dl
  280ffd:	ee                   	out    %al,(%dx)
  280ffe:	b0 20                	mov    $0x20,%al
  281000:	b2 21                	mov    $0x21,%dl
  281002:	ee                   	out    %al,(%dx)
  281003:	b0 04                	mov    $0x4,%al
  281005:	ee                   	out    %al,(%dx)
  281006:	b0 01                	mov    $0x1,%al
  281008:	ee                   	out    %al,(%dx)
  281009:	b0 11                	mov    $0x11,%al
  28100b:	b2 a0                	mov    $0xa0,%dl
  28100d:	ee                   	out    %al,(%dx)
  28100e:	b0 28                	mov    $0x28,%al
  281010:	b2 a1                	mov    $0xa1,%dl
  281012:	ee                   	out    %al,(%dx)
  281013:	b0 02                	mov    $0x2,%al
  281015:	ee                   	out    %al,(%dx)
  281016:	b0 01                	mov    $0x1,%al
  281018:	ee                   	out    %al,(%dx)
  281019:	b0 fb                	mov    $0xfb,%al
  28101b:	b2 21                	mov    $0x21,%dl
  28101d:	ee                   	out    %al,(%dx)
  28101e:	b0 ff                	mov    $0xff,%al
  281020:	b2 a1                	mov    $0xa1,%dl
  281022:	ee                   	out    %al,(%dx)

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}
  281023:	5d                   	pop    %ebp
  281024:	c3                   	ret    

00281025 <inthandler21>:
struct FIFO8 keyfifo;//a global data
//上面是一个全局变量

//interrupt service procedure for keyboard  中断服务程序，读取按键的键值。
void inthandler21(int *esp)
{
  281025:	55                   	push   %ebp
  281026:	ba 20 00 00 00       	mov    $0x20,%edx
  28102b:	89 e5                	mov    %esp,%ebp
  28102d:	b0 61                	mov    $0x61,%al
  28102f:	83 ec 10             	sub    $0x10,%esp
  281032:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  281033:	b2 60                	mov    $0x60,%dl
  281035:	ec                   	in     (%dx),%al
  //struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  unsigned char data;
  outb(PIC0_OCW2,0X61);//0X61-->PIC0_OCW2 　告之pic0这个芯片，irq1中断(就是keyboard产生的中断)cpu已经处理，这样pic0才会响应　下一次的irq1中断
  //如果不告之pic0已经处理了这次中断，pico对已后的irq1中断就会响应了。这种cpu处理完了中断，对pic0的反馈机制是非常好的，不会漏掉任何数据。
  data=inb(PORT_KEYDAT);
  fifo8_write(&keyfifo,data);
  281036:	0f b6 c0             	movzbl %al,%eax
  281039:	50                   	push   %eax
  28103a:	68 20 3e 28 00       	push   $0x283e20
  28103f:	e8 dd 00 00 00       	call   281121 <fifo8_write>
  281044:	83 c4 10             	add    $0x10,%esp
  //puts8((char *)binfo->vram ,binfo->xsize,0,0,7,s);

  //while(1)
  //io_halt();
  
}
  281047:	c9                   	leave  
  281048:	c3                   	ret    

00281049 <inthandler2c>:
//中断处理程序不应该有大量的处理部分，应该得到数据后，马上回去，在主函数中处理信息才是对的，与５１中是一个道理。isr尽量短小。

//interrupt service for mouse 
struct FIFO8 mousefifo;
void inthandler2c(int *esp)//可以看到一运行enable_后就，就产生了中断，进入了这个中断服务函数。
{
  281049:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  28104a:	ba a0 00 00 00       	mov    $0xa0,%edx
  28104f:	89 e5                	mov    %esp,%ebp
  281051:	b0 64                	mov    $0x64,%al
  281053:	83 ec 10             	sub    $0x10,%esp
  281056:	ee                   	out    %al,(%dx)
  281057:	b0 62                	mov    $0x62,%al
  281059:	b2 20                	mov    $0x20,%dl
  28105b:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  28105c:	b2 60                	mov    $0x60,%dl
  28105e:	ec                   	in     (%dx),%al
  
  unsigned char data;
  outb(PIC1_OCW2,0X64);//cpu tell pic1　that I got IRQ12 
  outb(PIC0_OCW2,0X62);//cpu tell pic0  that I got IRQ2
  data = inb(PORT_KEYDAT);
  fifo8_write(&mousefifo,data);
  28105f:	0f b6 c0             	movzbl %al,%eax
  281062:	50                   	push   %eax
  281063:	68 38 3e 28 00       	push   $0x283e38
  281068:	e8 b4 00 00 00       	call   281121 <fifo8_write>
  28106d:	83 c4 10             	add    $0x10,%esp
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int2c(IRQ-12):PS2/mouse");

 // while(1)
 // hlt();
 */
}
  281070:	c9                   	leave  
  281071:	c3                   	ret    

00281072 <wait_KBC_sendready>:
//for mouse and keyboard control circuit,鼠标，键盘控制电路的初始化。
//#define PORT_KEYDAT 		0X0060


void wait_KBC_sendready(void)				//send ready and wait keyboard control ready
{
  281072:	55                   	push   %ebp
  281073:	ba 64 00 00 00       	mov    $0x64,%edx
  281078:	89 e5                	mov    %esp,%ebp
  28107a:	ec                   	in     (%dx),%al
  while(1)
  {
    /*等待按键控制电路准备完毕*/
    if( (inb(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0)	//读port 0x0064 看bit1是否是为０/if 0 ready ,if 1 not ready　
  28107b:	a8 02                	test   $0x2,%al
  28107d:	75 fb                	jne    28107a <wait_KBC_sendready+0x8>
    {							//bit 1是０说明键盘控制电路是准备好的，可以接受cpu的指令了。
      break;
    }
  }
  
}
  28107f:	5d                   	pop    %ebp
  281080:	c3                   	ret    

00281081 <init_keyboard>:

void init_keyboard(void)
{
  281081:	55                   	push   %ebp
  281082:	89 e5                	mov    %esp,%ebp
  /*这里才是真正的初始化按键电路*/
  wait_KBC_sendready();				//wait ready
  281084:	e8 e9 ff ff ff       	call   281072 <wait_KBC_sendready>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  281089:	ba 64 00 00 00       	mov    $0x64,%edx
  28108e:	b0 60                	mov    $0x60,%al
  281090:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_WRITE_MODE);		//向port 0x0064写　0x60
  wait_KBC_sendready();				//保证能写入有效的数据到　port 0x0064
  281091:	e8 dc ff ff ff       	call   281072 <wait_KBC_sendready>
  281096:	ba 60 00 00 00       	mov    $0x60,%edx
  28109b:	b0 47                	mov    $0x47,%al
  28109d:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,KBC_MODE);			//向port 0x0060 写数据0x47
  return;
  
}
  28109e:	5d                   	pop    %ebp
  28109f:	c3                   	ret    

002810a0 <asm_inthandler21>:
.global load_idtr

.code32
#interrupt service about keyboad
asm_inthandler21:
  pushw %es
  2810a0:	66 06                	pushw  %es
  pushw %ds
  2810a2:	66 1e                	pushw  %ds
  pushal
  2810a4:	60                   	pusha  
  movl %esp,%eax
  2810a5:	89 e0                	mov    %esp,%eax
  pushl %eax
  2810a7:	50                   	push   %eax
  movw %ss,%ax
  2810a8:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  2810ab:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  2810ad:	8e c0                	mov    %eax,%es
  call inthandler21
  2810af:	e8 71 ff ff ff       	call   281025 <inthandler21>
  
  popl %eax
  2810b4:	58                   	pop    %eax
  popal
  2810b5:	61                   	popa   
  popw %ds
  2810b6:	66 1f                	popw   %ds
  popW %es
  2810b8:	66 07                	popw   %es
  iretl
  2810ba:	cf                   	iret   

002810bb <asm_inthandler2c>:
  
#interrupt service about mouse
asm_inthandler2c:
  pushw %es
  2810bb:	66 06                	pushw  %es
  pushw %ds
  2810bd:	66 1e                	pushw  %ds
  pushal
  2810bf:	60                   	pusha  
  movl %esp,%eax
  2810c0:	89 e0                	mov    %esp,%eax
  pushl %eax
  2810c2:	50                   	push   %eax
  movw %ss,%ax
  2810c3:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  2810c6:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  2810c8:	8e c0                	mov    %eax,%es
  call inthandler2c
  2810ca:	e8 7a ff ff ff       	call   281049 <inthandler2c>
  
  popl %eax
  2810cf:	58                   	pop    %eax
  popal
  2810d0:	61                   	popa   
  popw %ds
  2810d1:	66 1f                	popw   %ds
  popW %es
  2810d3:	66 07                	popw   %es
  iretl
  2810d5:	cf                   	iret   

002810d6 <load_gdtr>:
  #iret 与iretl有什么区别？？？
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2810d6:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2810db:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lgdt 6(%esp)
  2810e0:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  ret
  2810e5:	c3                   	ret    

002810e6 <load_idtr>:


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2810e6:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2810eb:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lidt 6(%esp)
  2810f0:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  2810f5:	c3                   	ret    

002810f6 <fifo8_init>:
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  2810f6:	55                   	push   %ebp
  2810f7:	89 e5                	mov    %esp,%ebp
  2810f9:	8b 45 08             	mov    0x8(%ebp),%eax
  2810fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  fifo->buf=buf;
  2810ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fifo->size=size;
  fifo->free=size;
  fifo->nr=0;
  281102:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  fifo->size=size;
  281109:	89 50 0c             	mov    %edx,0xc(%eax)
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  28110c:	89 08                	mov    %ecx,(%eax)
  fifo->size=size;
  fifo->free=size;
  28110e:	89 50 10             	mov    %edx,0x10(%eax)
  fifo->nr=0;
  fifo->nw=0;
  281111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  fifo->flags=0;
  281118:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  28111f:	5d                   	pop    %ebp
  281120:	c3                   	ret    

00281121 <fifo8_write>:


#define FLAGS_OVERRUN 0X0001
//下面的函数是对fifo类型的变量，写入数据。
int fifo8_write(struct FIFO8 *fifo,unsigned char data)
{
  281121:	55                   	push   %ebp
  281122:	89 e5                	mov    %esp,%ebp
  281124:	8b 45 08             	mov    0x8(%ebp),%eax
  281127:	53                   	push   %ebx
  281128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(fifo->free==0)//fifo is full ,no room for any data
  28112b:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  28112f:	75 09                	jne    28113a <fifo8_write+0x19>
  {
    fifo->flags|=FLAGS_OVERRUN;//if fifo->flags is TRUE, fifo已经满了，不能再写了。
  281131:	83 48 14 01          	orl    $0x1,0x14(%eax)
    return -1; //write error
  281135:	83 c8 ff             	or     $0xffffffff,%eax
  281138:	eb 22                	jmp    28115c <fifo8_write+0x3b>
  }
  
  
 fifo->buf[fifo->nw]=data;
  28113a:	8b 50 04             	mov    0x4(%eax),%edx
  28113d:	8b 08                	mov    (%eax),%ecx
  28113f:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
 fifo->nw++;
  281142:	8b 48 04             	mov    0x4(%eax),%ecx
  281145:	8d 51 01             	lea    0x1(%ecx),%edx
 if(fifo->nw==fifo->size)
  281148:	3b 50 0c             	cmp    0xc(%eax),%edx
    return -1; //write error
  }
  
  
 fifo->buf[fifo->nw]=data;
 fifo->nw++;
  28114b:	89 50 04             	mov    %edx,0x4(%eax)
 if(fifo->nw==fifo->size)
  28114e:	75 07                	jne    281157 <fifo8_write+0x36>
 {
  fifo->nw=0;  
  281150:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 }
 fifo->free--;
  281157:	ff 48 10             	decl   0x10(%eax)
 return 0;//write sucessful
  28115a:	31 c0                	xor    %eax,%eax
 
}
  28115c:	5b                   	pop    %ebx
  28115d:	5d                   	pop    %ebp
  28115e:	c3                   	ret    

0028115f <fifo8_read>:
//只有写fifo 会有fifo full的情况，
//读fifo时，会有empty的情况。
int fifo8_read(struct FIFO8 *fifo)
{
  28115f:	55                   	push   %ebp
  281160:	89 e5                	mov    %esp,%ebp
  281162:	8b 55 08             	mov    0x8(%ebp),%edx
  281165:	57                   	push   %edi
  281166:	56                   	push   %esi
  281167:	53                   	push   %ebx
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  281168:	8b 5a 10             	mov    0x10(%edx),%ebx
  28116b:	8b 7a 0c             	mov    0xc(%edx),%edi
  28116e:	39 fb                	cmp    %edi,%ebx
  281170:	74 1a                	je     28118c <fifo8_read+0x2d>
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  281172:	8b 72 08             	mov    0x8(%edx),%esi
  fifo->nr++;
  281175:	31 c9                	xor    %ecx,%ecx
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  281177:	8b 02                	mov    (%edx),%eax
  281179:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
  fifo->nr++;
  28117d:	46                   	inc    %esi
  28117e:	39 fe                	cmp    %edi,%esi
  281180:	0f 45 ce             	cmovne %esi,%ecx
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  281183:	43                   	inc    %ebx
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  fifo->nr++;
  281184:	89 4a 08             	mov    %ecx,0x8(%edx)
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  281187:	89 5a 10             	mov    %ebx,0x10(%edx)
  
  return data;
  28118a:	eb 03                	jmp    28118f <fifo8_read+0x30>
int fifo8_read(struct FIFO8 *fifo)
{
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  28118c:	83 c8 ff             	or     $0xffffffff,%eax
  fifo->free++;
  
  return data;
  
  
}
  28118f:	5b                   	pop    %ebx
  281190:	5e                   	pop    %esi
  281191:	5f                   	pop    %edi
  281192:	5d                   	pop    %ebp
  281193:	c3                   	ret    

00281194 <fifo8_status>:

int fifo8_status(struct FIFO8 *fifo)
{
  281194:	55                   	push   %ebp
  281195:	89 e5                	mov    %esp,%ebp
  281197:	8b 55 08             	mov    0x8(%ebp),%edx
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  28119a:	5d                   	pop    %ebp
  
}

int fifo8_status(struct FIFO8 *fifo)
{
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  28119b:	8b 42 0c             	mov    0xc(%edx),%eax
  28119e:	2b 42 10             	sub    0x10(%edx),%eax
  2811a1:	c3                   	ret    

002811a2 <enable_mouse>:
#include<header.h>
//激活鼠标的指令　还是向键盘控制器发送指令
#define KEYCMD_SENDTO_MOUSE 	0XD4
#define MOUSECMD_ENABLE     	0XF4
void enable_mouse(struct MOUSE_DEC *mdec)
{
  2811a2:	55                   	push   %ebp
  2811a3:	89 e5                	mov    %esp,%ebp
  2811a5:	83 ec 08             	sub    $0x8,%esp
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  2811a8:	e8 c5 fe ff ff       	call   281072 <wait_KBC_sendready>
  2811ad:	ba 64 00 00 00       	mov    $0x64,%edx
  2811b2:	b0 d4                	mov    $0xd4,%al
  2811b4:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_SENDTO_MOUSE);//向port 0x0064　写　0XD4命令  下面的命令发给mouse
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  2811b5:	e8 b8 fe ff ff       	call   281072 <wait_KBC_sendready>
  2811ba:	ba 60 00 00 00       	mov    $0x60,%edx
  2811bf:	b0 f4                	mov    $0xf4,%al
  2811c1:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,MOUSECMD_ENABLE); 	//向port 0x0060　写　0Xf4命令  给mouse发送enable命令
  
  mdec->phase=0;
  2811c2:	8b 45 08             	mov    0x8(%ebp),%eax
  2811c5:	c6 40 03 00          	movb   $0x0,0x3(%eax)
  return ; 				//if sucessful ,will create an interrupt ,and return ０xfa(ACK),产生的这个0xfa是给cpu的答复信号
					//就算鼠标不动，也会产生这个中断，所以我们一调用enable_mouse，就会产生鼠标中断，必须有这个服务函数。  
}
  2811c9:	c9                   	leave  
  2811ca:	c3                   	ret    

002811cb <mouse_decode>:


int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  2811cb:	55                   	push   %ebp
  2811cc:	89 e5                	mov    %esp,%ebp
  2811ce:	8b 55 08             	mov    0x8(%ebp),%edx
  2811d1:	53                   	push   %ebx
  2811d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(mdec->phase==0)
  2811d5:	8a 42 03             	mov    0x3(%edx),%al
  2811d8:	84 c0                	test   %al,%al
  2811da:	75 0d                	jne    2811e9 <mouse_decode+0x1e>
    if(data==0xfa)
    {
      mdec->phase = 1;
      
    }   
    return 0;
  2811dc:	31 c0                	xor    %eax,%eax

int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  if(mdec->phase==0)
  {
    if(data==0xfa)
  2811de:	80 f9 fa             	cmp    $0xfa,%cl
  2811e1:	75 73                	jne    281256 <mouse_decode+0x8b>
    {
      mdec->phase = 1;
  2811e3:	c6 42 03 01          	movb   $0x1,0x3(%edx)
  2811e7:	eb 6d                	jmp    281256 <mouse_decode+0x8b>
      
    }   
    return 0;
  }
  else if(mdec->phase==1) 
  2811e9:	3c 01                	cmp    $0x1,%al
  2811eb:	75 11                	jne    2811fe <mouse_decode+0x33>
  {
    //鼠标的第一字节的数据
    if( (data & 0xc8) == 0x08 )//如果第一个字节的数据正确  ,只要第一个字节的数据是正确的，后面两个phase的数据就是关于左移 和右移的数据
  2811ed:	88 c8                	mov    %cl,%al
  2811ef:	83 e0 c8             	and    $0xffffffc8,%eax
  2811f2:	3c 08                	cmp    $0x8,%al
  2811f4:	75 5d                	jne    281253 <mouse_decode+0x88>
    {
    mdec->buf[0] = data;
  2811f6:	88 0a                	mov    %cl,(%edx)
    mdec->phase  = 2;
  2811f8:	c6 42 03 02          	movb   $0x2,0x3(%edx)
  2811fc:	eb 0b                	jmp    281209 <mouse_decode+0x3e>
    return 0;
    }
  }
  else if(mdec->phase==2) 
  2811fe:	3c 02                	cmp    $0x2,%al
  281200:	75 0b                	jne    28120d <mouse_decode+0x42>
  {
    mdec->buf[1] = data;
  281202:	88 4a 01             	mov    %cl,0x1(%edx)
    mdec->phase  = 3;
  281205:	c6 42 03 03          	movb   $0x3,0x3(%edx)
    return 0;
  281209:	31 c0                	xor    %eax,%eax
  28120b:	eb 49                	jmp    281256 <mouse_decode+0x8b>
  }
  else if(mdec->phase==3) 
  28120d:	3c 03                	cmp    $0x3,%al
  28120f:	75 42                	jne    281253 <mouse_decode+0x88>
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  281211:	8a 02                	mov    (%edx),%al
    mdec->phase  = 3;
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
  281213:	88 4a 02             	mov    %cl,0x2(%edx)
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  281216:	0f b6 c9             	movzbl %cl,%ecx
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
  281219:	c6 42 03 01          	movb   $0x1,0x3(%edx)
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  28121d:	89 4a 08             	mov    %ecx,0x8(%edx)
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  281220:	89 c3                	mov    %eax,%ebx
  281222:	83 e3 07             	and    $0x7,%ebx
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  281225:	a8 10                	test   $0x10,%al
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  281227:	89 5a 0c             	mov    %ebx,0xc(%edx)
    mdec->x =mdec->buf[1];
  28122a:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  28122e:	89 5a 04             	mov    %ebx,0x4(%edx)
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  281231:	74 09                	je     28123c <mouse_decode+0x71>
    {
      mdec->x |=0xffffff00;//-x 根据buf[0]的bit4为1时，确定鼠标的移动方向是负方向。
  281233:	81 cb 00 ff ff ff    	or     $0xffffff00,%ebx
  281239:	89 5a 04             	mov    %ebx,0x4(%edx)
    }
    if( (mdec->buf[0] & 0x20) != 0)//bit5为1时 2
  28123c:	a8 20                	test   $0x20,%al
  28123e:	74 09                	je     281249 <mouse_decode+0x7e>
    {
      mdec->y |=0xffffff00;//-y
  281240:	81 c9 00 ff ff ff    	or     $0xffffff00,%ecx
  281246:	89 4a 08             	mov    %ecx,0x8(%edx)
    }
    
    mdec->y= - mdec->y;//鼠标的移动方向与屏幕的方向是相反的。
  281249:	f7 5a 08             	negl   0x8(%edx)


    return 1;
  28124c:	b8 01 00 00 00       	mov    $0x1,%eax
  281251:	eb 03                	jmp    281256 <mouse_decode+0x8b>
  }
  //buf0中的数据非常的重要，低四位与左右按键有关，高四位与方向有关。
  //高四位0－1－2－3，低四位8 9(left) a(right) b(both) c(middle)
   return -1;
  281253:	83 c8 ff             	or     $0xffffffff,%eax
}
  281256:	5b                   	pop    %ebx
  281257:	5d                   	pop    %ebp
  281258:	c3                   	ret    

00281259 <getmemorysize>:
#include<mm.h>

 //下面的程序只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
unsigned int getmemorysize(unsigned int start,unsigned int end)
{
  281259:	55                   	push   %ebp
  28125a:	89 e5                	mov    %esp,%ebp
  28125c:	8b 45 08             	mov    0x8(%ebp),%eax
  28125f:	53                   	push   %ebx
 unsigned int old;


 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  281260:	3b 45 0c             	cmp    0xc(%ebp),%eax
  281263:	77 2b                	ja     281290 <getmemorysize+0x37>
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  281265:	8b 90 00 08 00 00    	mov    0x800(%eax),%edx
  *p=pat0;
  28126b:	c7 80 00 08 00 00 55 	movl   $0xaa55aa55,0x800(%eax)
  281272:	aa 55 aa 
  if(*p!=pat0)
  281275:	8b 98 00 08 00 00    	mov    0x800(%eax),%ebx
  {
   *p=old;
  28127b:	89 90 00 08 00 00    	mov    %edx,0x800(%eax)
 for(i=start;i<=end;i+=0x1000)
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  *p=pat0;
  if(*p!=pat0)
  281281:	81 fb 55 aa 55 aa    	cmp    $0xaa55aa55,%ebx
  281287:	75 07                	jne    281290 <getmemorysize+0x37>
 unsigned int old;


 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  281289:	05 00 10 00 00       	add    $0x1000,%eax
  28128e:	eb d0                	jmp    281260 <getmemorysize+0x7>
 }
 return i;//i就是得到的memory size



}
  281290:	5b                   	pop    %ebx
  281291:	5d                   	pop    %ebp
  281292:	c3                   	ret    

00281293 <memtest>:

unsigned int memtest(unsigned int start,unsigned int end)
{
  281293:	55                   	push   %ebp
  281294:	89 e5                	mov    %esp,%ebp
  281296:	53                   	push   %ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  281297:	9c                   	pushf  
  281298:	58                   	pop    %eax
 char flg486=0;
 unsigned int eflg,cr0,i;
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
  281299:	0d 00 00 04 00       	or     $0x40000,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  28129e:	50                   	push   %eax
  28129f:	9d                   	popf   
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  2812a0:	9c                   	pushf  
  2812a1:	58                   	pop    %eax

}

unsigned int memtest(unsigned int start,unsigned int end)
{
 char flg486=0;
  2812a2:	31 db                	xor    %ebx,%ebx
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
  2812a4:	a9 00 00 04 00       	test   $0x40000,%eax
  2812a9:	74 14                	je     2812bf <memtest+0x2c>
 {
  flg486=1;
  eflg&=~EFLAGS_AC_BIT;
  2812ab:	25 ff ff fb ff       	and    $0xfffbffff,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  2812b0:	50                   	push   %eax
  2812b1:	9d                   	popf   

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  2812b2:	0f 20 c0             	mov    %cr0,%eax
  write_eflags(eflg);
 }
 if(flg486)
 {
  cr0=rcr0();
  cr0|=CR0_CACHE_DISABLE;
  2812b5:	0d 00 00 00 60       	or     $0x60000000,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  2812ba:	0f 22 c0             	mov    %eax,%cr0
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
 {
  flg486=1;
  2812bd:	b3 01                	mov    $0x1,%bl
  cr0|=CR0_CACHE_DISABLE;
  lcr0(cr0);
 }


i=getmemorysize(start,end);
  2812bf:	ff 75 0c             	pushl  0xc(%ebp)
  2812c2:	ff 75 08             	pushl  0x8(%ebp)
  2812c5:	e8 8f ff ff ff       	call   281259 <getmemorysize>
//i=0x100000;

  if(flg486)
  2812ca:	84 db                	test   %bl,%bl
  2812cc:	5a                   	pop    %edx
  2812cd:	59                   	pop    %ecx
  2812ce:	74 0c                	je     2812dc <memtest+0x49>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  2812d0:	0f 20 c2             	mov    %cr0,%edx
  {
  cr0=rcr0();
  cr0&=~CR0_CACHE_DISABLE;
  2812d3:	81 e2 ff ff ff 9f    	and    $0x9fffffff,%edx
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  2812d9:	0f 22 c2             	mov    %edx,%cr0
  lcr0(cr0);

  }

  return i;
}
  2812dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2812df:	c9                   	leave  
  2812e0:	c3                   	ret    

002812e1 <memman_init>:


void memman_init(Memman * man)
{
  2812e1:	55                   	push   %ebp
  2812e2:	89 e5                	mov    %esp,%ebp
  2812e4:	8b 45 08             	mov    0x8(%ebp),%eax
 man->cellnum=0;
  2812e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 man->maxcell=0;
  2812ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 man->lostsize=0;
  2812f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
 man->losts=0;
  2812fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  281302:	5d                   	pop    %ebp
  281303:	c3                   	ret    

00281304 <memman_avail>:
//get available memory
unsigned int memman_avail(Memman *man)
{
  281304:	55                   	push   %ebp
 unsigned int i;
 unsigned int freemem=0;
  281305:	31 c0                	xor    %eax,%eax
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  281307:	89 e5                	mov    %esp,%ebp
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  281309:	31 d2                	xor    %edx,%edx
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  28130b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  28130e:	53                   	push   %ebx
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  28130f:	8b 19                	mov    (%ecx),%ebx
  281311:	39 da                	cmp    %ebx,%edx
  281313:	74 07                	je     28131c <memman_avail+0x18>
 {
   freemem+=man->cell[i].size;
  281315:	03 44 d1 14          	add    0x14(%ecx,%edx,8),%eax
//get available memory
unsigned int memman_avail(Memman *man)
{
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  281319:	42                   	inc    %edx
  28131a:	eb f5                	jmp    281311 <memman_avail+0xd>
 {
   freemem+=man->cell[i].size;
 }
 return freemem;
}
  28131c:	5b                   	pop    %ebx
  28131d:	5d                   	pop    %ebp
  28131e:	c3                   	ret    

0028131f <memman_alloc>:
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  28131f:	55                   	push   %ebp
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  281320:	31 d2                	xor    %edx,%edx
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  281322:	89 e5                	mov    %esp,%ebp
  281324:	8b 4d 08             	mov    0x8(%ebp),%ecx
  281327:	57                   	push   %edi
  281328:	56                   	push   %esi
  281329:	53                   	push   %ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  28132a:	8b 39                	mov    (%ecx),%edi
  28132c:	39 fa                	cmp    %edi,%edx
  28132e:	74 43                	je     281373 <memman_alloc+0x54>
    {
        if(man->cell[i].size>size)
  281330:	8b 45 0c             	mov    0xc(%ebp),%eax
  281333:	39 44 d1 14          	cmp    %eax,0x14(%ecx,%edx,8)
  281337:	76 37                	jbe    281370 <memman_alloc+0x51>
  281339:	8d 34 d1             	lea    (%ecx,%edx,8),%esi
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
  28133c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
  28133f:	8b 46 10             	mov    0x10(%esi),%eax
            man->cell[i].address+=size;
  281342:	01 c3                	add    %eax,%ebx
  281344:	89 5e 10             	mov    %ebx,0x10(%esi)
            man->cell[i].size-=size;
  281347:	8b 5e 14             	mov    0x14(%esi),%ebx
  28134a:	2b 5d 0c             	sub    0xc(%ebp),%ebx
            if(man->cell[i].size==0)
  28134d:	85 db                	test   %ebx,%ebx
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
            man->cell[i].size-=size;
  28134f:	89 5e 14             	mov    %ebx,0x14(%esi)
            if(man->cell[i].size==0)
  281352:	75 21                	jne    281375 <memman_alloc+0x56>
            {
                man->cellnum--;
  281354:	8d 5f ff             	lea    -0x1(%edi),%ebx
  281357:	89 19                	mov    %ebx,(%ecx)
                for(;i<man->cellnum;i++)
  281359:	39 da                	cmp    %ebx,%edx
  28135b:	73 18                	jae    281375 <memman_alloc+0x56>
                {
                    man->cell[i]=man->cell[i+1];
  28135d:	42                   	inc    %edx
  28135e:	8b 74 d1 10          	mov    0x10(%ecx,%edx,8),%esi
  281362:	8b 7c d1 14          	mov    0x14(%ecx,%edx,8),%edi
  281366:	89 74 d1 08          	mov    %esi,0x8(%ecx,%edx,8)
  28136a:	89 7c d1 0c          	mov    %edi,0xc(%ecx,%edx,8)
  28136e:	eb e9                	jmp    281359 <memman_alloc+0x3a>
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  281370:	42                   	inc    %edx
  281371:	eb b9                	jmp    28132c <memman_alloc+0xd>
            }

            return a;
        }
    }
    return 0; //no memory can be used
  281373:	31 c0                	xor    %eax,%eax
}
  281375:	5b                   	pop    %ebx
  281376:	5e                   	pop    %esi
  281377:	5f                   	pop    %edi
  281378:	5d                   	pop    %ebp
  281379:	c3                   	ret    

0028137a <memman_alloc_4K>:
 }
 return freemem;
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  28137a:	55                   	push   %ebp
  28137b:	89 e5                	mov    %esp,%ebp
  size=(size+0xfff)&0xfffff000;
  28137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  281380:	05 ff 0f 00 00       	add    $0xfff,%eax
  281385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return memman_alloc(man,size);
  28138a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
  28138d:	5d                   	pop    %ebp
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
  28138e:	e9 8c ff ff ff       	jmp    28131f <memman_alloc>

00281393 <memman_free>:
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  281393:	55                   	push   %ebp
  int i,j;
  for (i=0;i<man->cellnum;i++)
  281394:	31 d2                	xor    %edx,%edx
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  281396:	89 e5                	mov    %esp,%ebp
  281398:	57                   	push   %edi
  281399:	56                   	push   %esi
  28139a:	53                   	push   %ebx
  28139b:	83 ec 08             	sub    $0x8,%esp
  28139e:	8b 45 08             	mov    0x8(%ebp),%eax
  2813a1:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i,j;
  for (i=0;i<man->cellnum;i++)
  2813a4:	8b 18                	mov    (%eax),%ebx
  2813a6:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  2813a9:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  2813ac:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  2813af:	74 09                	je     2813ba <memman_free+0x27>
  {
    if(man->cell[i].address>addr)//这一步可以找到一个合适的i的地址范围
  2813b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  2813b4:	39 5c d0 10          	cmp    %ebx,0x10(%eax,%edx,8)
  2813b8:	76 06                	jbe    2813c0 <memman_free+0x2d>
    }
  }

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  2813ba:	85 d2                	test   %edx,%edx
  2813bc:	75 05                	jne    2813c3 <memman_free+0x30>
  2813be:	eb 4c                	jmp    28140c <memman_free+0x79>
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  int i,j;
  for (i=0;i<man->cellnum;i++)
  2813c0:	42                   	inc    %edx
  2813c1:	eb e9                	jmp    2813ac <memman_free+0x19>
  2813c3:	8d 5c d0 f8          	lea    -0x8(%eax,%edx,8),%ebx

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
  2813c7:	8b 73 14             	mov    0x14(%ebx),%esi
  2813ca:	8b 4b 10             	mov    0x10(%ebx),%ecx
  2813cd:	01 f1                	add    %esi,%ecx
  2813cf:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
  2813d2:	75 38                	jne    28140c <memman_free+0x79>
    {
        man->cell[i-1].size+=size;
  2813d4:	01 fe                	add    %edi,%esi
        if(i<man->cellnum)
  2813d6:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
    {
        man->cell[i-1].size+=size;
  2813d9:	89 73 14             	mov    %esi,0x14(%ebx)
        if(i<man->cellnum)
  2813dc:	73 49                	jae    281427 <memman_free+0x94>
  2813de:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
        {
            if(addr+size==man->cell[i].address)
  2813e1:	03 7d 0c             	add    0xc(%ebp),%edi
  2813e4:	3b 79 10             	cmp    0x10(%ecx),%edi
  2813e7:	75 3e                	jne    281427 <memman_free+0x94>
            {
                man->cell[i-1].size+=man->cell[i].size;
  2813e9:	03 71 14             	add    0x14(%ecx),%esi
  2813ec:	89 73 14             	mov    %esi,0x14(%ebx)
                man->cellnum--;
  2813ef:	8b 75 f0             	mov    -0x10(%ebp),%esi
  2813f2:	4e                   	dec    %esi
  2813f3:	89 30                	mov    %esi,(%eax)

                for(;i<man->cellnum;i++)
  2813f5:	39 f2                	cmp    %esi,%edx
  2813f7:	73 2e                	jae    281427 <memman_free+0x94>
                {
                man->cell[i]=man->cell[i+1];
  2813f9:	42                   	inc    %edx
  2813fa:	8b 4c d0 10          	mov    0x10(%eax,%edx,8),%ecx
  2813fe:	8b 5c d0 14          	mov    0x14(%eax,%edx,8),%ebx
  281402:	89 4c d0 08          	mov    %ecx,0x8(%eax,%edx,8)
  281406:	89 5c d0 0c          	mov    %ebx,0xc(%eax,%edx,8)
  28140a:	eb e9                	jmp    2813f5 <memman_free+0x62>
     //printdebug(200,100);

  }

  //与后面的空间合并
  if(i<man->cellnum)
  28140c:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  28140f:	73 1a                	jae    28142b <memman_free+0x98>
  {
     if(addr+size==man->cell[i].address)
  281411:	8b 75 0c             	mov    0xc(%ebp),%esi
  281414:	8d 1c d0             	lea    (%eax,%edx,8),%ebx
  281417:	01 fe                	add    %edi,%esi
  281419:	3b 73 10             	cmp    0x10(%ebx),%esi
  28141c:	75 0d                	jne    28142b <memman_free+0x98>
     {
        man->cell[i].address=addr;
  28141e:	8b 45 0c             	mov    0xc(%ebp),%eax
        man->cell[i].size+=size;
  281421:	01 7b 14             	add    %edi,0x14(%ebx)
  //与后面的空间合并
  if(i<man->cellnum)
  {
     if(addr+size==man->cell[i].address)
     {
        man->cell[i].address=addr;
  281424:	89 43 10             	mov    %eax,0x10(%ebx)
        man->cell[i].size+=size;

        return 0;
  281427:	31 c0                	xor    %eax,%eax
  281429:	eb 4b                	jmp    281476 <memman_free+0xe3>
     }
  }

  if(man->cellnum<4090)
  28142b:	81 7d f0 f9 0f 00 00 	cmpl   $0xff9,-0x10(%ebp)
  281432:	77 39                	ja     28146d <memman_free+0xda>
  {
        for(j=man->cellnum;j>i;j--)
  281434:	39 55 ec             	cmp    %edx,-0x14(%ebp)
  281437:	7e 18                	jle    281451 <memman_free+0xbe>
        {
            man->cell[j]=man->cell[j-1];
  281439:	ff 4d ec             	decl   -0x14(%ebp)
  28143c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  28143f:	8b 5c c8 10          	mov    0x10(%eax,%ecx,8),%ebx
  281443:	8b 74 c8 14          	mov    0x14(%eax,%ecx,8),%esi
  281447:	89 5c c8 18          	mov    %ebx,0x18(%eax,%ecx,8)
  28144b:	89 74 c8 1c          	mov    %esi,0x1c(%eax,%ecx,8)
  28144f:	eb e3                	jmp    281434 <memman_free+0xa1>
        }

        man->cellnum++;
  281451:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  281454:	41                   	inc    %ecx
        if(man->maxcell<man->cellnum)
  281455:	39 48 04             	cmp    %ecx,0x4(%eax)
        for(j=man->cellnum;j>i;j--)
        {
            man->cell[j]=man->cell[j-1];
        }

        man->cellnum++;
  281458:	89 08                	mov    %ecx,(%eax)
        if(man->maxcell<man->cellnum)
  28145a:	73 03                	jae    28145f <memman_free+0xcc>
        {
            man->maxcell=man->cellnum;
  28145c:	89 48 04             	mov    %ecx,0x4(%eax)
  28145f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        }
        man->cell[i].address=addr;
  281462:	8b 55 0c             	mov    0xc(%ebp),%edx
        man->cell[i].size=size;
  281465:	89 78 14             	mov    %edi,0x14(%eax)
        man->cellnum++;
        if(man->maxcell<man->cellnum)
        {
            man->maxcell=man->cellnum;
        }
        man->cell[i].address=addr;
  281468:	89 50 10             	mov    %edx,0x10(%eax)
  28146b:	eb ba                	jmp    281427 <memman_free+0x94>
       // printdebug(man->cellnum,100);
        return 0;
  }


  man->losts++;
  28146d:	ff 40 0c             	incl   0xc(%eax)
  man->lostsize+=size;
  281470:	01 78 08             	add    %edi,0x8(%eax)

  return  -1;
  281473:	83 c8 ff             	or     $0xffffffff,%eax
}
  281476:	5a                   	pop    %edx
  281477:	59                   	pop    %ecx
  281478:	5b                   	pop    %ebx
  281479:	5e                   	pop    %esi
  28147a:	5f                   	pop    %edi
  28147b:	5d                   	pop    %ebp
  28147c:	c3                   	ret    

0028147d <memman_free_4k>:
    return 0; //no memory can be used
}

//return -1 means free memory failure
int memman_free_4k(Memman *man,unsigned int addr,unsigned int size)
{
  28147d:	55                   	push   %ebp
  28147e:	89 e5                	mov    %esp,%ebp
  size=(size+0xfff)& 0xfffff000;
  281480:	8b 45 10             	mov    0x10(%ebp),%eax
  281483:	05 ff 0f 00 00       	add    $0xfff,%eax
  281488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return memman_free(man,addr,size);
  28148d:	89 45 10             	mov    %eax,0x10(%ebp)
}
  281490:	5d                   	pop    %ebp

//return -1 means free memory failure
int memman_free_4k(Memman *man,unsigned int addr,unsigned int size)
{
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
  281491:	e9 fd fe ff ff       	jmp    281393 <memman_free>

00281496 <shtctl_init>:

  return  -1;
}

SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize)
{
  281496:	55                   	push   %ebp
  281497:	89 e5                	mov    %esp,%ebp
  281499:	57                   	push   %edi
  28149a:	8b 7d 10             	mov    0x10(%ebp),%edi
  28149d:	56                   	push   %esi
  28149e:	53                   	push   %ebx
  28149f:	8b 5d 08             	mov    0x8(%ebp),%ebx
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
  2814a2:	68 00 30 00 00       	push   $0x3000
  2814a7:	53                   	push   %ebx
  2814a8:	e8 72 fe ff ff       	call   28131f <memman_alloc>
  2814ad:	89 c6                	mov    %eax,%esi
SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize)
{
  SHTCTL *ctl;
  int i;
  ctl=(SHTCTL *)memman_alloc_4K(memman,sizeof(SHTCTL));
  if(ctl==0)
  2814af:	85 f6                	test   %esi,%esi
  2814b1:	58                   	pop    %eax
  2814b2:	5a                   	pop    %edx
  2814b3:	74 57                	je     28150c <shtctl_init+0x76>
  return ctl;
  ctl->map=(unsigned char *)memman_alloc_4K(memman,xsize*ysize);
  2814b5:	8b 45 14             	mov    0x14(%ebp),%eax
  2814b8:	0f af c7             	imul   %edi,%eax
  2814bb:	50                   	push   %eax
  2814bc:	53                   	push   %ebx
  2814bd:	e8 b8 fe ff ff       	call   28137a <memman_alloc_4K>

  if(ctl->map==0)
  2814c2:	85 c0                	test   %eax,%eax
  SHTCTL *ctl;
  int i;
  ctl=(SHTCTL *)memman_alloc_4K(memman,sizeof(SHTCTL));
  if(ctl==0)
  return ctl;
  ctl->map=(unsigned char *)memman_alloc_4K(memman,xsize*ysize);
  2814c4:	89 46 04             	mov    %eax,0x4(%esi)

  if(ctl->map==0)
  2814c7:	5a                   	pop    %edx
  2814c8:	59                   	pop    %ecx
  2814c9:	75 11                	jne    2814dc <shtctl_init+0x46>
    {
     memman_free_4k(memman,(int)ctl,sizeof(SHTCTL));
  2814cb:	68 14 28 00 00       	push   $0x2814
  2814d0:	56                   	push   %esi
  2814d1:	53                   	push   %ebx
  2814d2:	e8 a6 ff ff ff       	call   28147d <memman_free_4k>
     return 0;
  2814d7:	83 c4 0c             	add    $0xc,%esp
  2814da:	eb 30                	jmp    28150c <shtctl_init+0x76>
    }
  ctl->vram=vram;
  2814dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  2814df:	8d 8e 00 24 00 00    	lea    0x2400(%esi),%ecx
  ctl->xsize=xsize;
  2814e5:	89 7e 08             	mov    %edi,0x8(%esi)
  ctl->ysize=ysize;
  ctl->top=-1;  //no sheet
  2814e8:	c7 46 10 ff ff ff ff 	movl   $0xffffffff,0x10(%esi)
  if(ctl->map==0)
    {
     memman_free_4k(memman,(int)ctl,sizeof(SHTCTL));
     return 0;
    }
  ctl->vram=vram;
  2814ef:	89 06                	mov    %eax,(%esi)
  ctl->xsize=xsize;
  ctl->ysize=ysize;
  2814f1:	8b 45 14             	mov    0x14(%ebp),%eax
  2814f4:	89 46 0c             	mov    %eax,0xc(%esi)
  2814f7:	89 f0                	mov    %esi,%eax
  ctl->top=-1;  //no sheet
  for(i=0;i<MAX_SHEETS;i++)
  {
    ctl->sheet[i].flags=0;
  2814f9:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  281500:	83 c0 24             	add    $0x24,%eax
    ctl->sheet[i].ctl=ctl;
  281503:	89 70 10             	mov    %esi,0x10(%eax)
    }
  ctl->vram=vram;
  ctl->xsize=xsize;
  ctl->ysize=ysize;
  ctl->top=-1;  //no sheet
  for(i=0;i<MAX_SHEETS;i++)
  281506:	39 c8                	cmp    %ecx,%eax
  281508:	75 ef                	jne    2814f9 <shtctl_init+0x63>
  28150a:	eb 04                	jmp    281510 <shtctl_init+0x7a>
  28150c:	31 c0                	xor    %eax,%eax
  28150e:	eb 02                	jmp    281512 <shtctl_init+0x7c>
  281510:	89 f0                	mov    %esi,%eax
  {
    ctl->sheet[i].flags=0;
    ctl->sheet[i].ctl=ctl;
  }
  return ctl;
}
  281512:	8d 65 f4             	lea    -0xc(%ebp),%esp
  281515:	5b                   	pop    %ebx
  281516:	5e                   	pop    %esi
  281517:	5f                   	pop    %edi
  281518:	5d                   	pop    %ebp
  281519:	c3                   	ret    

0028151a <sheet_alloc>:

SHEET * sheet_alloc(SHTCTL * ctl)
{
  28151a:	55                   	push   %ebp
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  28151b:	31 c0                	xor    %eax,%eax
  }
  return ctl;
}

SHEET * sheet_alloc(SHTCTL * ctl)
{
  28151d:	89 e5                	mov    %esp,%ebp
  28151f:	8b 55 08             	mov    0x8(%ebp),%edx
  281522:	6b c8 24             	imul   $0x24,%eax,%ecx
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  {
    if (ctl->sheet[i].flags==0)
  281525:	83 7c 0a 30 00       	cmpl   $0x0,0x30(%edx,%ecx,1)
  28152a:	75 14                	jne    281540 <sheet_alloc+0x26>
    {
        sht=&ctl->sheet[i];
  28152c:	8d 44 0a 14          	lea    0x14(%edx,%ecx,1),%eax
        sht->flags=1;
  281530:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
        sht->height=-1;
  281537:	c7 40 18 ff ff ff ff 	movl   $0xffffffff,0x18(%eax)
        return sht;
  28153e:	eb 0b                	jmp    28154b <sheet_alloc+0x31>

SHEET * sheet_alloc(SHTCTL * ctl)
{
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  281540:	40                   	inc    %eax
  281541:	3d 00 01 00 00       	cmp    $0x100,%eax
  281546:	75 da                	jne    281522 <sheet_alloc+0x8>
        sht->flags=1;
        sht->height=-1;
        return sht;
    }
  }
  return 0;
  281548:	66 31 c0             	xor    %ax,%ax
}
  28154b:	5d                   	pop    %ebp
  28154c:	c3                   	ret    

0028154d <sheet_setbuf>:



void sheet_setbuf(SHEET * sht,unsigned char *buf,int xsize,int ysize,int col_inv)
{
  28154d:	55                   	push   %ebp
  28154e:	89 e5                	mov    %esp,%ebp
  281550:	8b 45 08             	mov    0x8(%ebp),%eax
  sht->buf=buf;
  281553:	8b 55 0c             	mov    0xc(%ebp),%edx
  281556:	89 10                	mov    %edx,(%eax)
  sht->bxsize=xsize;
  281558:	8b 55 10             	mov    0x10(%ebp),%edx
  28155b:	89 50 04             	mov    %edx,0x4(%eax)
  sht->bysize=ysize;
  28155e:	8b 55 14             	mov    0x14(%ebp),%edx
  281561:	89 50 08             	mov    %edx,0x8(%eax)
  sht->col_inv=col_inv;
  281564:	8b 55 18             	mov    0x18(%ebp),%edx
  281567:	89 50 14             	mov    %edx,0x14(%eax)
  return ;
}
  28156a:	5d                   	pop    %ebp
  28156b:	c3                   	ret    

0028156c <sheet_refreshsub>:
 return;
}


void sheet_refreshsub(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer,int layerend)
{
  28156c:	55                   	push   %ebp
  28156d:	89 e5                	mov    %esp,%ebp
  28156f:	57                   	push   %edi
  281570:	56                   	push   %esi
  281571:	53                   	push   %ebx
  281572:	83 ec 34             	sub    $0x34,%esp
  281575:	8b 55 08             	mov    0x8(%ebp),%edx
  281578:	8b 4d 14             	mov    0x14(%ebp),%ecx
  28157b:	8b 5d 18             	mov    0x18(%ebp),%ebx
int h,bx,by,vx,vy,bx0,bx1,by0,by1;
unsigned char *buf,*vram=ctl->vram;
  28157e:	8b 02                	mov    (%edx),%eax
  281580:	89 45 ec             	mov    %eax,-0x14(%ebp)
unsigned char sid;
unsigned char c;
unsigned char *map=ctl->map;
  281583:	8b 42 04             	mov    0x4(%edx),%eax
  281586:	89 45 e8             	mov    %eax,-0x18(%ebp)


SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
  281589:	8b 42 08             	mov    0x8(%edx),%eax
  28158c:	39 c1                	cmp    %eax,%ecx
  28158e:	0f 4e c1             	cmovle %ecx,%eax
  281591:	89 45 c8             	mov    %eax,-0x38(%ebp)
if(vy1>ctl->ysize)vy1=ctl->ysize;
  281594:	8b 42 0c             	mov    0xc(%edx),%eax
  281597:	39 c3                	cmp    %eax,%ebx
  281599:	0f 4e c3             	cmovle %ebx,%eax
  28159c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  28159f:	8d 42 14             	lea    0x14(%edx),%eax
  2815a2:	89 45 c0             	mov    %eax,-0x40(%ebp)
SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
  2815a5:	8b 45 20             	mov    0x20(%ebp),%eax
  2815a8:	39 45 1c             	cmp    %eax,0x1c(%ebp)
  2815ab:	0f 8f c6 00 00 00    	jg     281677 <sheet_refreshsub+0x10b>
{
  sht=ctl->sheets[h];
  2815b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  2815b4:	8b 5d c8             	mov    -0x38(%ebp),%ebx
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  2815b7:	8b 84 82 14 24 00 00 	mov    0x2414(%edx,%eax,4),%eax
  sid=sht-ctl->sheet;
  2815be:	89 c1                	mov    %eax,%ecx
  buf=sht->buf;
  2815c0:	8b 38                	mov    (%eax),%edi
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  2815c2:	2b 4d c0             	sub    -0x40(%ebp),%ecx
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  2815c5:	8b 70 0c             	mov    0xc(%eax),%esi
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  2815c8:	c1 f9 02             	sar    $0x2,%ecx
  2815cb:	69 c9 39 8e e3 38    	imul   $0x38e38e39,%ecx,%ecx
  buf=sht->buf;
  2815d1:	89 7d e0             	mov    %edi,-0x20(%ebp)

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;
  2815d4:	8b 78 10             	mov    0x10(%eax),%edi

  bx1=vx1-sht->vx0;
  2815d7:	29 f3                	sub    %esi,%ebx
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  2815d9:	88 4d e7             	mov    %cl,-0x19(%ebp)

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  by1=vy1-sht->vy0;
  2815dc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  2815df:	89 7d f0             	mov    %edi,-0x10(%ebp)
  2815e2:	29 f9                	sub    %edi,%ecx
  2815e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  2815e7:	29 f7                	sub    %esi,%edi
  2815e9:	89 fe                	mov    %edi,%esi
  2815eb:	bf 00 00 00 00       	mov    $0x0,%edi
  2815f0:	0f 48 f7             	cmovs  %edi,%esi
  2815f3:	89 75 cc             	mov    %esi,-0x34(%ebp)
  2815f6:	8b 75 10             	mov    0x10(%ebp),%esi
  2815f9:	2b 75 f0             	sub    -0x10(%ebp),%esi
  2815fc:	0f 49 fe             	cmovns %esi,%edi

  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  2815ff:	8b 70 04             	mov    0x4(%eax),%esi
  281602:	39 f3                	cmp    %esi,%ebx
  281604:	0f 4e f3             	cmovle %ebx,%esi
  if(by1>sht->bysize)by1=sht->bysize;
  281607:	8b 58 08             	mov    0x8(%eax),%ebx
  28160a:	89 75 d0             	mov    %esi,-0x30(%ebp)
  28160d:	39 d9                	cmp    %ebx,%ecx
  28160f:	0f 4e d9             	cmovle %ecx,%ebx
  281612:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  for(by=by0;by<by1;by++)
  281615:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
  281618:	7d 55                	jge    28166f <sheet_refreshsub+0x103>
  {
    vy=sht->vy0+by;
  28161a:	8b 48 10             	mov    0x10(%eax),%ecx
  28161d:	01 f9                	add    %edi,%ecx
  28161f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    for(bx=bx0;bx<bx1;bx++)
  281622:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  281625:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  281628:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  28162b:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  28162e:	7d 3c                	jge    28166c <sheet_refreshsub+0x100>
    {
        vx=sht->vx0+bx;

            c=map[vy*ctl->xsize+vx];
  281630:	8b 75 dc             	mov    -0x24(%ebp),%esi
  281633:	0f af 72 08          	imul   0x8(%edx),%esi
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;
  281637:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  28163a:	03 58 0c             	add    0xc(%eax),%ebx

            c=map[vy*ctl->xsize+vx];
            if(c==sid)
  28163d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;

            c=map[vy*ctl->xsize+vx];
  281640:	01 de                	add    %ebx,%esi
            if(c==sid)
  281642:	8a 5d e7             	mov    -0x19(%ebp),%bl
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;

            c=map[vy*ctl->xsize+vx];
  281645:	89 75 d8             	mov    %esi,-0x28(%ebp)
            if(c==sid)
  281648:	38 1c 31             	cmp    %bl,(%ecx,%esi,1)
  28164b:	75 1a                	jne    281667 <sheet_refreshsub+0xfb>
            {
                vram[vy*ctl->xsize+vx]=buf[by*sht->bxsize+bx];;
  28164d:	8b 70 04             	mov    0x4(%eax),%esi
  281650:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  281653:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  281656:	0f af f7             	imul   %edi,%esi
  281659:	01 cb                	add    %ecx,%ebx
  28165b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  28165e:	8a 1c 33             	mov    (%ebx,%esi,1),%bl
  281661:	8b 75 d8             	mov    -0x28(%ebp),%esi
  281664:	88 1c 31             	mov    %bl,(%ecx,%esi,1)
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
  281667:	ff 45 f0             	incl   -0x10(%ebp)
  28166a:	eb bc                	jmp    281628 <sheet_refreshsub+0xbc>

  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  28166c:	47                   	inc    %edi
  28166d:	eb a6                	jmp    281615 <sheet_refreshsub+0xa9>
SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
  28166f:	ff 45 1c             	incl   0x1c(%ebp)
  281672:	e9 2e ff ff ff       	jmp    2815a5 <sheet_refreshsub+0x39>
 // if(h==1)  while(1);

}
return;

}
  281677:	83 c4 34             	add    $0x34,%esp
  28167a:	5b                   	pop    %ebx
  28167b:	5e                   	pop    %esi
  28167c:	5f                   	pop    %edi
  28167d:	5d                   	pop    %ebp
  28167e:	c3                   	ret    

0028167f <sheet_refresh>:
 }

}

void sheet_refresh(SHEET * sht,int bx0,int by0,int bx1,int by1)
{
  28167f:	55                   	push   %ebp
  281680:	89 e5                	mov    %esp,%ebp
  281682:	8b 45 08             	mov    0x8(%ebp),%eax
  281685:	53                   	push   %ebx
SHTCTL *ctl=sht->ctl;
if (sht->height>=0)
  281686:	8b 50 18             	mov    0x18(%eax),%edx

}

void sheet_refresh(SHEET * sht,int bx0,int by0,int bx1,int by1)
{
SHTCTL *ctl=sht->ctl;
  281689:	8b 58 20             	mov    0x20(%eax),%ebx
if (sht->height>=0)
  28168c:	85 d2                	test   %edx,%edx
  28168e:	78 25                	js     2816b5 <sheet_refresh+0x36>
{
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
    sht->vx0+bx1,sht->vy0+by1,sht->height,sht->height);
  281690:	8b 48 10             	mov    0x10(%eax),%ecx
  281693:	8b 40 0c             	mov    0xc(%eax),%eax
void sheet_refresh(SHEET * sht,int bx0,int by0,int bx1,int by1)
{
SHTCTL *ctl=sht->ctl;
if (sht->height>=0)
{
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
  281696:	52                   	push   %edx
  281697:	52                   	push   %edx
  281698:	8b 55 18             	mov    0x18(%ebp),%edx
  28169b:	01 ca                	add    %ecx,%edx
  28169d:	52                   	push   %edx
  28169e:	8b 55 14             	mov    0x14(%ebp),%edx
  2816a1:	03 4d 10             	add    0x10(%ebp),%ecx
  2816a4:	01 c2                	add    %eax,%edx
  2816a6:	03 45 0c             	add    0xc(%ebp),%eax
  2816a9:	52                   	push   %edx
  2816aa:	51                   	push   %ecx
  2816ab:	50                   	push   %eax
  2816ac:	53                   	push   %ebx
  2816ad:	e8 ba fe ff ff       	call   28156c <sheet_refreshsub>
  2816b2:	83 c4 1c             	add    $0x1c,%esp
    sht->vx0+bx1,sht->vy0+by1,sht->height,sht->height);

    }
}
  2816b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2816b8:	c9                   	leave  
  2816b9:	c3                   	ret    

002816ba <sheet_refreshmap>:
}



void sheet_refreshmap(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer)
{
  2816ba:	55                   	push   %ebp
  2816bb:	89 e5                	mov    %esp,%ebp
  2816bd:	57                   	push   %edi
  2816be:	56                   	push   %esi
  2816bf:	53                   	push   %ebx
  2816c0:	83 ec 28             	sub    $0x28,%esp
int h,bx,by,vx,vy, bx0,by0,bx1,by1;
unsigned char *buf,*vram=ctl->vram;
unsigned char *map=ctl->map;
  2816c3:	8b 45 08             	mov    0x8(%ebp),%eax
}



void sheet_refreshmap(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer)
{
  2816c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  2816c9:	8b 4d 18             	mov    0x18(%ebp),%ecx
int h,bx,by,vx,vy, bx0,by0,bx1,by1;
unsigned char *buf,*vram=ctl->vram;
unsigned char *map=ctl->map;
  2816cc:	8b 40 04             	mov    0x4(%eax),%eax
  2816cf:	89 45 f0             	mov    %eax,-0x10(%ebp)


SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
  2816d2:	8b 45 08             	mov    0x8(%ebp),%eax
  2816d5:	8b 40 08             	mov    0x8(%eax),%eax
  2816d8:	39 c3                	cmp    %eax,%ebx
  2816da:	0f 4e c3             	cmovle %ebx,%eax
  2816dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
if(vy1>ctl->ysize)vy1=ctl->ysize;
  2816e0:	8b 45 08             	mov    0x8(%ebp),%eax
  2816e3:	8b 40 0c             	mov    0xc(%eax),%eax
  2816e6:	39 c1                	cmp    %eax,%ecx
  2816e8:	0f 4e c1             	cmovle %ecx,%eax
  2816eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  2816ee:	8b 45 08             	mov    0x8(%ebp),%eax
  2816f1:	83 c0 14             	add    $0x14,%eax
  2816f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
  2816f7:	8b 45 08             	mov    0x8(%ebp),%eax
  2816fa:	8b 40 10             	mov    0x10(%eax),%eax
  2816fd:	39 45 1c             	cmp    %eax,0x1c(%ebp)
  281700:	0f 8f b4 00 00 00    	jg     2817ba <sheet_refreshmap+0x100>
{
  sht=ctl->sheets[h];
  281706:	8b 55 08             	mov    0x8(%ebp),%edx
  281709:	8b 45 1c             	mov    0x1c(%ebp),%eax
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  28170c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  28170f:	8b 84 82 14 24 00 00 	mov    0x2414(%edx,%eax,4),%eax
  sid=sht-ctl->sheet;
  281716:	89 c1                	mov    %eax,%ecx
  //printdebug((unsigned)sid,0);
  buf=sht->buf;
  281718:	8b 10                	mov    (%eax),%edx
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  28171a:	2b 4d cc             	sub    -0x34(%ebp),%ecx
  //printdebug((unsigned)sid,0);
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  28171d:	8b 70 0c             	mov    0xc(%eax),%esi
  by0=vy0-sht->vy0;
  281720:	8b 78 10             	mov    0x10(%eax),%edi
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  281723:	c1 f9 02             	sar    $0x2,%ecx
  281726:	69 c9 39 8e e3 38    	imul   $0x38e38e39,%ecx,%ecx
  //printdebug((unsigned)sid,0);
  buf=sht->buf;
  28172c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  28172f:	8b 55 0c             	mov    0xc(%ebp),%edx

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  281732:	29 f3                	sub    %esi,%ebx
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  281734:	88 4d ef             	mov    %cl,-0x11(%ebp)

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  by1=vy1-sht->vy0;
  281737:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  28173a:	29 f9                	sub    %edi,%ecx
  28173c:	29 f2                	sub    %esi,%edx
  28173e:	89 d6                	mov    %edx,%esi
  281740:	ba 00 00 00 00       	mov    $0x0,%edx
  281745:	0f 48 f2             	cmovs  %edx,%esi
  281748:	89 75 d8             	mov    %esi,-0x28(%ebp)
  28174b:	8b 75 10             	mov    0x10(%ebp),%esi
  28174e:	29 fe                	sub    %edi,%esi
  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  281750:	8b 78 04             	mov    0x4(%eax),%edi
  281753:	0f 48 f2             	cmovs  %edx,%esi
  281756:	39 fb                	cmp    %edi,%ebx
  281758:	0f 4e fb             	cmovle %ebx,%edi
  if(by1>sht->bysize)by1=sht->bysize;
  28175b:	8b 58 08             	mov    0x8(%eax),%ebx
  28175e:	89 7d dc             	mov    %edi,-0x24(%ebp)
  281761:	39 d9                	cmp    %ebx,%ecx
  281763:	0f 4e d9             	cmovle %ecx,%ebx
  281766:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  for(by=by0;by<by1;by++)
  281769:	3b 75 e0             	cmp    -0x20(%ebp),%esi
  28176c:	7d 44                	jge    2817b2 <sheet_refreshmap+0xf8>
  {
    vy=sht->vy0+by;
  28176e:	8b 50 10             	mov    0x10(%eax),%edx
    for(bx=bx0;bx<bx1;bx++)
  281771:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
  281774:	01 f2                	add    %esi,%edx
  281776:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for(bx=bx0;bx<bx1;bx++)
  281779:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
  28177c:	7d 31                	jge    2817af <sheet_refreshmap+0xf5>
    {
        vx=sht->vx0+bx;
            c=buf[by*sht->bxsize+bx];
  28177e:	8b 58 04             	mov    0x4(%eax),%ebx
  281781:	8b 7d e8             	mov    -0x18(%ebp),%edi
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;
  281784:	8b 50 0c             	mov    0xc(%eax),%edx
            c=buf[by*sht->bxsize+bx];
  281787:	0f af de             	imul   %esi,%ebx
  28178a:	01 cf                	add    %ecx,%edi
            if(c!=sht->col_inv)
  28178c:	0f b6 1c 1f          	movzbl (%edi,%ebx,1),%ebx
  281790:	3b 58 14             	cmp    0x14(%eax),%ebx
  281793:	74 17                	je     2817ac <sheet_refreshmap+0xf2>
            {
                map[vy*ctl->xsize+vx]=sid;
  281795:	8b 7d 08             	mov    0x8(%ebp),%edi
  281798:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  28179b:	0f af 5f 08          	imul   0x8(%edi),%ebx
  28179f:	8b 7d f0             	mov    -0x10(%ebp),%edi
  2817a2:	01 cf                	add    %ecx,%edi
  2817a4:	01 d7                	add    %edx,%edi
  2817a6:	8a 55 ef             	mov    -0x11(%ebp),%dl
  2817a9:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
  2817ac:	41                   	inc    %ecx
  2817ad:	eb ca                	jmp    281779 <sheet_refreshmap+0xbf>
  by1=vy1-sht->vy0;
  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  2817af:	46                   	inc    %esi
  2817b0:	eb b7                	jmp    281769 <sheet_refreshmap+0xaf>
SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
  2817b2:	ff 45 1c             	incl   0x1c(%ebp)
  2817b5:	e9 3d ff ff ff       	jmp    2816f7 <sheet_refreshmap+0x3d>
  }

}
return;

}
  2817ba:	83 c4 28             	add    $0x28,%esp
  2817bd:	5b                   	pop    %ebx
  2817be:	5e                   	pop    %esi
  2817bf:	5f                   	pop    %edi
  2817c0:	5d                   	pop    %ebp
  2817c1:	c3                   	ret    

002817c2 <sheet_updown>:
  return ;
}


void sheet_updown(SHEET * sht,int height)
{
  2817c2:	55                   	push   %ebp
  2817c3:	89 e5                	mov    %esp,%ebp
  2817c5:	57                   	push   %edi
  2817c6:	56                   	push   %esi
  2817c7:	53                   	push   %ebx
  2817c8:	83 ec 08             	sub    $0x8,%esp
  2817cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  2817ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 int h ,old=sht->height;
  2817d1:	8b 43 18             	mov    0x18(%ebx),%eax
 SHTCTL *ctl=sht->ctl;
  2817d4:	8b 73 20             	mov    0x20(%ebx),%esi
}


void sheet_updown(SHEET * sht,int height)
{
 int h ,old=sht->height;
  2817d7:	89 c1                	mov    %eax,%ecx
  2817d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 SHTCTL *ctl=sht->ctl;
 if(height>ctl->top+1)
  2817dc:	8b 46 10             	mov    0x10(%esi),%eax
  2817df:	8d 78 01             	lea    0x1(%eax),%edi
  2817e2:	39 fa                	cmp    %edi,%edx
  2817e4:	0f 4f d7             	cmovg  %edi,%edx
  2817e7:	89 7d ec             	mov    %edi,-0x14(%ebp)
  2817ea:	83 cf ff             	or     $0xffffffff,%edi
  2817ed:	85 d2                	test   %edx,%edx
  2817ef:	0f 49 fa             	cmovns %edx,%edi
 {
  height=-1;
 }
 sht->height=height;

 if(old>height)
  2817f2:	39 f9                	cmp    %edi,%ecx

 if(height<-1)
 {
  height=-1;
 }
 sht->height=height;
  2817f4:	89 7b 18             	mov    %edi,0x18(%ebx)

 if(old>height)
  2817f7:	0f 8e b6 00 00 00    	jle    2818b3 <sheet_updown+0xf1>
 {
   if(height>=0)
  2817fd:	85 ff                	test   %edi,%edi
  2817ff:	78 5b                	js     28185c <sheet_updown+0x9a>
  281801:	89 c8                	mov    %ecx,%eax
   {
        for(h=old;h>height;h--)
        {
            ctl->sheets[h]=ctl->sheets[h-1];
  281803:	8d 50 ff             	lea    -0x1(%eax),%edx
  281806:	8b 8c 96 14 24 00 00 	mov    0x2414(%esi,%edx,4),%ecx

 if(old>height)
 {
   if(height>=0)
   {
        for(h=old;h>height;h--)
  28180d:	39 fa                	cmp    %edi,%edx
        {
            ctl->sheets[h]=ctl->sheets[h-1];
  28180f:	89 8c 96 18 24 00 00 	mov    %ecx,0x2418(%esi,%edx,4)
            ctl->sheets[h]->height=h;
  281816:	89 41 18             	mov    %eax,0x18(%ecx)

 if(old>height)
 {
   if(height>=0)
   {
        for(h=old;h>height;h--)
  281819:	74 04                	je     28181f <sheet_updown+0x5d>
  28181b:	89 d0                	mov    %edx,%eax
  28181d:	eb e4                	jmp    281803 <sheet_updown+0x41>
        {
            ctl->sheets[h]=ctl->sheets[h-1];
            ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,sht->height+1);
  28181f:	8b 7b 18             	mov    0x18(%ebx),%edi
  281822:	8b 53 10             	mov    0x10(%ebx),%edx
        for(h=old;h>height;h--)
        {
            ctl->sheets[h]=ctl->sheets[h-1];
            ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
  281825:	89 9c 86 10 24 00 00 	mov    %ebx,0x2410(%esi,%eax,4)
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,sht->height+1);
  28182c:	8b 43 0c             	mov    0xc(%ebx),%eax
  28182f:	8d 4f 01             	lea    0x1(%edi),%ecx
  281832:	51                   	push   %ecx
  281833:	8b 4b 08             	mov    0x8(%ebx),%ecx
  281836:	01 d1                	add    %edx,%ecx
  281838:	51                   	push   %ecx
  281839:	8b 4b 04             	mov    0x4(%ebx),%ecx
  28183c:	01 c1                	add    %eax,%ecx
  28183e:	51                   	push   %ecx
  28183f:	52                   	push   %edx
  281840:	50                   	push   %eax
  281841:	56                   	push   %esi
  281842:	e8 73 fe ff ff       	call   2816ba <sheet_refreshmap>

        sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,sht->height+1,old);
  281847:	8b 53 10             	mov    0x10(%ebx),%edx
  28184a:	8b 43 0c             	mov    0xc(%ebx),%eax
  28184d:	ff 75 f0             	pushl  -0x10(%ebp)
  281850:	8b 7b 18             	mov    0x18(%ebx),%edi
  281853:	8d 4f 01             	lea    0x1(%edi),%ecx
  281856:	51                   	push   %ecx
  281857:	e9 e1 00 00 00       	jmp    28193d <sheet_updown+0x17b>

   }
   else
   {
        if(ctl->top>old)
  28185c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  28185f:	39 f8                	cmp    %edi,%eax
  281861:	89 f9                	mov    %edi,%ecx
  281863:	7f 32                	jg     281897 <sheet_updown+0xd5>
                ctl->sheets[h]=ctl->sheets[h+1];
                ctl->sheets[h]->height=h;
            }

        }
        ctl->top--;
  281865:	48                   	dec    %eax
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0);
  281866:	8b 53 10             	mov    0x10(%ebx),%edx
                ctl->sheets[h]=ctl->sheets[h+1];
                ctl->sheets[h]->height=h;
            }

        }
        ctl->top--;
  281869:	89 46 10             	mov    %eax,0x10(%esi)
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0);
  28186c:	8b 43 0c             	mov    0xc(%ebx),%eax
  28186f:	6a 00                	push   $0x0
  281871:	8b 4b 08             	mov    0x8(%ebx),%ecx
  281874:	01 d1                	add    %edx,%ecx
  281876:	51                   	push   %ecx
  281877:	8b 4b 04             	mov    0x4(%ebx),%ecx
  28187a:	01 c1                	add    %eax,%ecx
  28187c:	51                   	push   %ecx
  28187d:	52                   	push   %edx
  28187e:	50                   	push   %eax
  28187f:	56                   	push   %esi
  281880:	e8 35 fe ff ff       	call   2816ba <sheet_refreshmap>
        sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0,old-1);
  281885:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  281888:	8b 53 10             	mov    0x10(%ebx),%edx
  28188b:	8b 43 0c             	mov    0xc(%ebx),%eax
  28188e:	49                   	dec    %ecx
  28188f:	51                   	push   %ecx
  281890:	6a 00                	push   $0x0
  281892:	e9 a6 00 00 00       	jmp    28193d <sheet_updown+0x17b>
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
            {
                ctl->sheets[h]=ctl->sheets[h+1];
  281897:	8d 51 01             	lea    0x1(%ecx),%edx
  28189a:	8b bc 96 14 24 00 00 	mov    0x2414(%esi,%edx,4),%edi
   }
   else
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
  2818a1:	39 c2                	cmp    %eax,%edx
            {
                ctl->sheets[h]=ctl->sheets[h+1];
  2818a3:	89 bc 96 10 24 00 00 	mov    %edi,0x2410(%esi,%edx,4)
                ctl->sheets[h]->height=h;
  2818aa:	89 4f 18             	mov    %ecx,0x18(%edi)
   }
   else
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
  2818ad:	74 b6                	je     281865 <sheet_updown+0xa3>
  2818af:	89 d1                	mov    %edx,%ecx
  2818b1:	eb e4                	jmp    281897 <sheet_updown+0xd5>
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0);
        sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0,old-1);

   }
 }
 else if(old<height)
  2818b3:	0f 8d 9b 00 00 00    	jge    281954 <sheet_updown+0x192>
 {

    if(old>0)
  2818b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  2818bd:	7e 2c                	jle    2818eb <sheet_updown+0x129>
    {

        for(h=old;h<height;h++)
        {
         ctl->sheets[h]=ctl->sheets[h+1];
  2818bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  2818c2:	89 c8                	mov    %ecx,%eax
  2818c4:	40                   	inc    %eax
  2818c5:	8b 94 86 14 24 00 00 	mov    0x2414(%esi,%eax,4),%edx
 {

    if(old>0)
    {

        for(h=old;h<height;h++)
  2818cc:	39 f8                	cmp    %edi,%eax
        {
         ctl->sheets[h]=ctl->sheets[h+1];
  2818ce:	89 94 86 10 24 00 00 	mov    %edx,0x2410(%esi,%eax,4)
         ctl->sheets[h]->height=h;
  2818d5:	89 4a 18             	mov    %ecx,0x18(%edx)
 {

    if(old>0)
    {

        for(h=old;h<height;h++)
  2818d8:	74 05                	je     2818df <sheet_updown+0x11d>
  2818da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  2818dd:	eb e0                	jmp    2818bf <sheet_updown+0xfd>
        {
         ctl->sheets[h]=ctl->sheets[h+1];
         ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
  2818df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2818e2:	89 9c 86 18 24 00 00 	mov    %ebx,0x2418(%esi,%eax,4)
  2818e9:	eb 2f                	jmp    28191a <sheet_updown+0x158>
    }
    else
    {

        for(h=ctl->top;h>=height;h--)
  2818eb:	39 f8                	cmp    %edi,%eax
  2818ed:	7c 1e                	jl     28190d <sheet_updown+0x14b>
        {
            ctl->sheets[h+1]=ctl->sheets[h];
  2818ef:	8b 94 86 14 24 00 00 	mov    0x2414(%esi,%eax,4),%edx
  2818f6:	8b 8c 86 14 24 00 00 	mov    0x2414(%esi,%eax,4),%ecx
  2818fd:	89 94 86 18 24 00 00 	mov    %edx,0x2418(%esi,%eax,4)
  281904:	8d 50 01             	lea    0x1(%eax),%edx
        ctl->sheets[height]=sht;
    }
    else
    {

        for(h=ctl->top;h>=height;h--)
  281907:	48                   	dec    %eax
  281908:	89 51 18             	mov    %edx,0x18(%ecx)
  28190b:	eb de                	jmp    2818eb <sheet_updown+0x129>
        {
            ctl->sheets[h+1]=ctl->sheets[h];
            ctl->sheets[h+1]->height=h+1;
        }
        ctl->sheets[height]=sht;
        ctl->top++;
  28190d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        for(h=ctl->top;h>=height;h--)
        {
            ctl->sheets[h+1]=ctl->sheets[h];
            ctl->sheets[h+1]->height=h+1;
        }
        ctl->sheets[height]=sht;
  281910:	89 9c be 14 24 00 00 	mov    %ebx,0x2414(%esi,%edi,4)
        ctl->top++;
  281917:	89 46 10             	mov    %eax,0x10(%esi)

    }
      sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,height);
  28191a:	8b 53 10             	mov    0x10(%ebx),%edx
  28191d:	8b 43 0c             	mov    0xc(%ebx),%eax
  281920:	57                   	push   %edi
  281921:	8b 4b 08             	mov    0x8(%ebx),%ecx
  281924:	01 d1                	add    %edx,%ecx
  281926:	51                   	push   %ecx
  281927:	8b 4b 04             	mov    0x4(%ebx),%ecx
  28192a:	01 c1                	add    %eax,%ecx
  28192c:	51                   	push   %ecx
  28192d:	52                   	push   %edx
  28192e:	50                   	push   %eax
  28192f:	56                   	push   %esi
  281930:	e8 85 fd ff ff       	call   2816ba <sheet_refreshmap>
      sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,height,height);
  281935:	8b 53 10             	mov    0x10(%ebx),%edx
  281938:	8b 43 0c             	mov    0xc(%ebx),%eax
  28193b:	57                   	push   %edi
  28193c:	57                   	push   %edi
  28193d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  281940:	01 d1                	add    %edx,%ecx
  281942:	51                   	push   %ecx
  281943:	8b 4b 04             	mov    0x4(%ebx),%ecx
  281946:	01 c1                	add    %eax,%ecx
  281948:	51                   	push   %ecx
  281949:	52                   	push   %edx
  28194a:	50                   	push   %eax
  28194b:	56                   	push   %esi
  28194c:	e8 1b fc ff ff       	call   28156c <sheet_refreshsub>
  281951:	83 c4 34             	add    $0x34,%esp
 }

}
  281954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  281957:	5b                   	pop    %ebx
  281958:	5e                   	pop    %esi
  281959:	5f                   	pop    %edi
  28195a:	5d                   	pop    %ebp
  28195b:	c3                   	ret    

0028195c <sheet_free>:
return;

}

void sheet_free(SHEET *sht)
{
  28195c:	55                   	push   %ebp
  28195d:	89 e5                	mov    %esp,%ebp
  28195f:	53                   	push   %ebx
  281960:	8b 5d 08             	mov    0x8(%ebp),%ebx
 if(sht->height>=0)
  281963:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
  281967:	78 0a                	js     281973 <sheet_free+0x17>
 sheet_updown(sht,-1);
  281969:	6a ff                	push   $0xffffffff
  28196b:	53                   	push   %ebx
  28196c:	e8 51 fe ff ff       	call   2817c2 <sheet_updown>
  281971:	58                   	pop    %eax
  281972:	5a                   	pop    %edx

sht->flags=0;
  281973:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
return;
}
  28197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  28197d:	c9                   	leave  
  28197e:	c3                   	ret    

0028197f <sheet_move>:

    }
}

void sheet_move(SHEET * sht,int vx0,int vy0)
{
  28197f:	55                   	push   %ebp
  281980:	89 e5                	mov    %esp,%ebp
  281982:	57                   	push   %edi
  281983:	56                   	push   %esi
  281984:	53                   	push   %ebx
  281985:	83 ec 08             	sub    $0x8,%esp
  281988:	8b 5d 08             	mov    0x8(%ebp),%ebx
  28198b:	8b 75 10             	mov    0x10(%ebp),%esi
SHTCTL * ctl=sht->ctl;
 int old_vx0=sht->vx0;
 int old_vy0=sht->vy0;

 sht->vx0=vx0;
  28198e:	8b 45 0c             	mov    0xc(%ebp),%eax
 sht->vy0=vy0;
 if(sht->height>=0)
  281991:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
}

void sheet_move(SHEET * sht,int vx0,int vy0)
{
SHTCTL * ctl=sht->ctl;
 int old_vx0=sht->vx0;
  281995:	8b 53 0c             	mov    0xc(%ebx),%edx
 int old_vy0=sht->vy0;
  281998:	8b 4b 10             	mov    0x10(%ebx),%ecx
    }
}

void sheet_move(SHEET * sht,int vx0,int vy0)
{
SHTCTL * ctl=sht->ctl;
  28199b:	8b 7b 20             	mov    0x20(%ebx),%edi
 int old_vx0=sht->vx0;
 int old_vy0=sht->vy0;

 sht->vx0=vx0;
  28199e:	89 43 0c             	mov    %eax,0xc(%ebx)
 sht->vy0=vy0;
  2819a1:	89 73 10             	mov    %esi,0x10(%ebx)
 if(sht->height>=0)
  2819a4:	78 79                	js     281a1f <sheet_move+0xa0>
 {
    //移动之后map要重新生成
    sheet_refreshmap(ctl,old_vx0,old_vy0,old_vx0+sht->bxsize,old_vy0+sht->bysize,0);
  2819a6:	6a 00                	push   $0x0
  2819a8:	8b 43 08             	mov    0x8(%ebx),%eax
  2819ab:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  2819ae:	89 55 f0             	mov    %edx,-0x10(%ebp)
  2819b1:	01 c8                	add    %ecx,%eax
  2819b3:	50                   	push   %eax
  2819b4:	8b 43 04             	mov    0x4(%ebx),%eax
  2819b7:	01 d0                	add    %edx,%eax
  2819b9:	50                   	push   %eax
  2819ba:	51                   	push   %ecx
  2819bb:	52                   	push   %edx
  2819bc:	57                   	push   %edi
  2819bd:	e8 f8 fc ff ff       	call   2816ba <sheet_refreshmap>
    sheet_refreshmap(ctl,vx0,vy0,vx0+sht->bxsize,vy0+sht->bysize,sht->height);
  2819c2:	ff 73 18             	pushl  0x18(%ebx)
  2819c5:	8b 43 08             	mov    0x8(%ebx),%eax
  2819c8:	01 f0                	add    %esi,%eax
  2819ca:	50                   	push   %eax
  2819cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  2819ce:	03 43 04             	add    0x4(%ebx),%eax
  2819d1:	50                   	push   %eax
  2819d2:	56                   	push   %esi
  2819d3:	ff 75 0c             	pushl  0xc(%ebp)
  2819d6:	57                   	push   %edi
  2819d7:	e8 de fc ff ff       	call   2816ba <sheet_refreshmap>
    //sheet_refresh(ctl);
    sheet_refreshsub(ctl,old_vx0,old_vy0,old_vx0+sht->bxsize,old_vy0+sht->bysize,0,sht->height-1);
  2819dc:	8b 43 18             	mov    0x18(%ebx),%eax
  2819df:	83 c4 30             	add    $0x30,%esp
  2819e2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  2819e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  2819e8:	48                   	dec    %eax
  2819e9:	50                   	push   %eax
  2819ea:	6a 00                	push   $0x0
  2819ec:	8b 43 08             	mov    0x8(%ebx),%eax
  2819ef:	01 c8                	add    %ecx,%eax
  2819f1:	50                   	push   %eax
  2819f2:	8b 43 04             	mov    0x4(%ebx),%eax
  2819f5:	01 d0                	add    %edx,%eax
  2819f7:	50                   	push   %eax
  2819f8:	51                   	push   %ecx
  2819f9:	52                   	push   %edx
  2819fa:	57                   	push   %edi
  2819fb:	e8 6c fb ff ff       	call   28156c <sheet_refreshsub>
    sheet_refreshsub(ctl,vx0,vy0,vx0+sht->bxsize,vy0+sht->bysize,sht->height,sht->height);
  281a00:	8b 43 18             	mov    0x18(%ebx),%eax
  281a03:	50                   	push   %eax
  281a04:	50                   	push   %eax
  281a05:	8b 43 08             	mov    0x8(%ebx),%eax
  281a08:	01 f0                	add    %esi,%eax
  281a0a:	50                   	push   %eax
  281a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  281a0e:	03 43 04             	add    0x4(%ebx),%eax
  281a11:	50                   	push   %eax
  281a12:	56                   	push   %esi
  281a13:	ff 75 0c             	pushl  0xc(%ebp)
  281a16:	57                   	push   %edi
  281a17:	e8 50 fb ff ff       	call   28156c <sheet_refreshsub>
  281a1c:	83 c4 38             	add    $0x38,%esp
 }
 return;
}
  281a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  281a22:	5b                   	pop    %ebx
  281a23:	5e                   	pop    %esi
  281a24:	5f                   	pop    %edi
  281a25:	5d                   	pop    %ebp
  281a26:	c3                   	ret    

Disassembly of section .rodata:

00281a28 <Font8x16>:
	...
  281c38:	00 00                	add    %al,(%eax)
  281c3a:	00 10                	add    %dl,(%eax)
  281c3c:	10 10                	adc    %dl,(%eax)
  281c3e:	10 10                	adc    %dl,(%eax)
  281c40:	10 00                	adc    %al,(%eax)
  281c42:	10 10                	adc    %dl,(%eax)
  281c44:	00 00                	add    %al,(%eax)
  281c46:	00 00                	add    %al,(%eax)
  281c48:	00 00                	add    %al,(%eax)
  281c4a:	00 24 24             	add    %ah,(%esp)
  281c4d:	24 00                	and    $0x0,%al
	...
  281c5b:	24 24                	and    $0x24,%al
  281c5d:	7e 24                	jle    281c83 <Font8x16+0x25b>
  281c5f:	24 24                	and    $0x24,%al
  281c61:	7e 24                	jle    281c87 <Font8x16+0x25f>
  281c63:	24 00                	and    $0x0,%al
  281c65:	00 00                	add    %al,(%eax)
  281c67:	00 00                	add    %al,(%eax)
  281c69:	00 00                	add    %al,(%eax)
  281c6b:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  281c6f:	7c 12                	jl     281c83 <Font8x16+0x25b>
  281c71:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  281c75:	00 00                	add    %al,(%eax)
  281c77:	00 00                	add    %al,(%eax)
  281c79:	00 00                	add    %al,(%eax)
  281c7b:	00 62 64             	add    %ah,0x64(%edx)
  281c7e:	08 10                	or     %dl,(%eax)
  281c80:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  281c8c:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  281c8f:	50                   	push   %eax
  281c90:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  281c97:	00 00                	add    %al,(%eax)
  281c99:	00 00                	add    %al,(%eax)
  281c9b:	10 10                	adc    %dl,(%eax)
  281c9d:	20 00                	and    %al,(%eax)
	...
  281ca7:	00 00                	add    %al,(%eax)
  281ca9:	00 08                	add    %cl,(%eax)
  281cab:	10 20                	adc    %ah,(%eax)
  281cad:	20 20                	and    %ah,(%eax)
  281caf:	20 20                	and    %ah,(%eax)
  281cb1:	20 20                	and    %ah,(%eax)
  281cb3:	10 08                	adc    %cl,(%eax)
  281cb5:	00 00                	add    %al,(%eax)
  281cb7:	00 00                	add    %al,(%eax)
  281cb9:	00 20                	add    %ah,(%eax)
  281cbb:	10 08                	adc    %cl,(%eax)
  281cbd:	08 08                	or     %cl,(%eax)
  281cbf:	08 08                	or     %cl,(%eax)
  281cc1:	08 08                	or     %cl,(%eax)
  281cc3:	10 20                	adc    %ah,(%eax)
	...
  281ccd:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  281cd1:	54                   	push   %esp
  281cd2:	10 00                	adc    %al,(%eax)
	...
  281cdc:	00 10                	add    %dl,(%eax)
  281cde:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  281cf2:	10 10                	adc    %dl,(%eax)
  281cf4:	20 00                	and    %al,(%eax)
	...
  281cfe:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  281d12:	00 10                	add    %dl,(%eax)
	...
  281d1c:	00 02                	add    %al,(%edx)
  281d1e:	04 08                	add    $0x8,%al
  281d20:	10 20                	adc    %ah,(%eax)
  281d22:	40                   	inc    %eax
	...
  281d2b:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  281d2f:	54                   	push   %esp
  281d30:	64                   	fs
  281d31:	44                   	inc    %esp
  281d32:	44                   	inc    %esp
  281d33:	38 00                	cmp    %al,(%eax)
  281d35:	00 00                	add    %al,(%eax)
  281d37:	00 00                	add    %al,(%eax)
  281d39:	00 00                	add    %al,(%eax)
  281d3b:	10 30                	adc    %dh,(%eax)
  281d3d:	10 10                	adc    %dl,(%eax)
  281d3f:	10 10                	adc    %dl,(%eax)
  281d41:	10 10                	adc    %dl,(%eax)
  281d43:	38 00                	cmp    %al,(%eax)
  281d45:	00 00                	add    %al,(%eax)
  281d47:	00 00                	add    %al,(%eax)
  281d49:	00 00                	add    %al,(%eax)
  281d4b:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  281d4f:	08 10                	or     %dl,(%eax)
  281d51:	20 40 7c             	and    %al,0x7c(%eax)
  281d54:	00 00                	add    %al,(%eax)
  281d56:	00 00                	add    %al,(%eax)
  281d58:	00 00                	add    %al,(%eax)
  281d5a:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  281d5e:	10 38                	adc    %bh,(%eax)
  281d60:	04 04                	add    $0x4,%al
  281d62:	04 78                	add    $0x78,%al
  281d64:	00 00                	add    %al,(%eax)
  281d66:	00 00                	add    %al,(%eax)
  281d68:	00 00                	add    %al,(%eax)
  281d6a:	00 08                	add    %cl,(%eax)
  281d6c:	18 28                	sbb    %ch,(%eax)
  281d6e:	48                   	dec    %eax
  281d6f:	48                   	dec    %eax
  281d70:	7c 08                	jl     281d7a <Font8x16+0x352>
  281d72:	08 08                	or     %cl,(%eax)
  281d74:	00 00                	add    %al,(%eax)
  281d76:	00 00                	add    %al,(%eax)
  281d78:	00 00                	add    %al,(%eax)
  281d7a:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  281d7e:	40                   	inc    %eax
  281d7f:	78 04                	js     281d85 <Font8x16+0x35d>
  281d81:	04 04                	add    $0x4,%al
  281d83:	78 00                	js     281d85 <Font8x16+0x35d>
  281d85:	00 00                	add    %al,(%eax)
  281d87:	00 00                	add    %al,(%eax)
  281d89:	00 00                	add    %al,(%eax)
  281d8b:	3c 40                	cmp    $0x40,%al
  281d8d:	40                   	inc    %eax
  281d8e:	40                   	inc    %eax
  281d8f:	78 44                	js     281dd5 <Font8x16+0x3ad>
  281d91:	44                   	inc    %esp
  281d92:	44                   	inc    %esp
  281d93:	38 00                	cmp    %al,(%eax)
  281d95:	00 00                	add    %al,(%eax)
  281d97:	00 00                	add    %al,(%eax)
  281d99:	00 00                	add    %al,(%eax)
  281d9b:	7c 04                	jl     281da1 <Font8x16+0x379>
  281d9d:	04 08                	add    $0x8,%al
  281d9f:	10 20                	adc    %ah,(%eax)
  281da1:	20 20                	and    %ah,(%eax)
  281da3:	20 00                	and    %al,(%eax)
  281da5:	00 00                	add    %al,(%eax)
  281da7:	00 00                	add    %al,(%eax)
  281da9:	00 00                	add    %al,(%eax)
  281dab:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281daf:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281db3:	38 00                	cmp    %al,(%eax)
  281db5:	00 00                	add    %al,(%eax)
  281db7:	00 00                	add    %al,(%eax)
  281db9:	00 00                	add    %al,(%eax)
  281dbb:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281dbf:	3c 04                	cmp    $0x4,%al
  281dc1:	04 04                	add    $0x4,%al
  281dc3:	38 00                	cmp    %al,(%eax)
	...
  281dcd:	00 00                	add    %al,(%eax)
  281dcf:	10 00                	adc    %al,(%eax)
  281dd1:	00 10                	add    %dl,(%eax)
	...
  281ddf:	00 10                	add    %dl,(%eax)
  281de1:	00 10                	add    %dl,(%eax)
  281de3:	10 20                	adc    %ah,(%eax)
	...
  281ded:	04 08                	add    $0x8,%al
  281def:	10 20                	adc    %ah,(%eax)
  281df1:	10 08                	adc    %cl,(%eax)
  281df3:	04 00                	add    $0x0,%al
	...
  281dfd:	00 00                	add    %al,(%eax)
  281dff:	7c 00                	jl     281e01 <Font8x16+0x3d9>
  281e01:	7c 00                	jl     281e03 <Font8x16+0x3db>
	...
  281e0b:	00 00                	add    %al,(%eax)
  281e0d:	20 10                	and    %dl,(%eax)
  281e0f:	08 04 08             	or     %al,(%eax,%ecx,1)
  281e12:	10 20                	adc    %ah,(%eax)
  281e14:	00 00                	add    %al,(%eax)
  281e16:	00 00                	add    %al,(%eax)
  281e18:	00 00                	add    %al,(%eax)
  281e1a:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  281e1e:	08 10                	or     %dl,(%eax)
  281e20:	10 00                	adc    %al,(%eax)
  281e22:	10 10                	adc    %dl,(%eax)
	...
  281e2c:	00 38                	add    %bh,(%eax)
  281e2e:	44                   	inc    %esp
  281e2f:	5c                   	pop    %esp
  281e30:	54                   	push   %esp
  281e31:	5c                   	pop    %esp
  281e32:	40                   	inc    %eax
  281e33:	3c 00                	cmp    $0x0,%al
  281e35:	00 00                	add    %al,(%eax)
  281e37:	00 00                	add    %al,(%eax)
  281e39:	00 18                	add    %bl,(%eax)
  281e3b:	24 42                	and    $0x42,%al
  281e3d:	42                   	inc    %edx
  281e3e:	42                   	inc    %edx
  281e3f:	7e 42                	jle    281e83 <Font8x16+0x45b>
  281e41:	42                   	inc    %edx
  281e42:	42                   	inc    %edx
  281e43:	42                   	inc    %edx
  281e44:	00 00                	add    %al,(%eax)
  281e46:	00 00                	add    %al,(%eax)
  281e48:	00 00                	add    %al,(%eax)
  281e4a:	7c 42                	jl     281e8e <Font8x16+0x466>
  281e4c:	42                   	inc    %edx
  281e4d:	42                   	inc    %edx
  281e4e:	7c 42                	jl     281e92 <Font8x16+0x46a>
  281e50:	42                   	inc    %edx
  281e51:	42                   	inc    %edx
  281e52:	42                   	inc    %edx
  281e53:	7c 00                	jl     281e55 <Font8x16+0x42d>
  281e55:	00 00                	add    %al,(%eax)
  281e57:	00 00                	add    %al,(%eax)
  281e59:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281e5c:	40                   	inc    %eax
  281e5d:	40                   	inc    %eax
  281e5e:	40                   	inc    %eax
  281e5f:	40                   	inc    %eax
  281e60:	40                   	inc    %eax
  281e61:	40                   	inc    %eax
  281e62:	42                   	inc    %edx
  281e63:	3c 00                	cmp    $0x0,%al
  281e65:	00 00                	add    %al,(%eax)
  281e67:	00 00                	add    %al,(%eax)
  281e69:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281e6d:	42                   	inc    %edx
  281e6e:	42                   	inc    %edx
  281e6f:	42                   	inc    %edx
  281e70:	42                   	inc    %edx
  281e71:	42                   	inc    %edx
  281e72:	42                   	inc    %edx
  281e73:	7c 00                	jl     281e75 <Font8x16+0x44d>
  281e75:	00 00                	add    %al,(%eax)
  281e77:	00 00                	add    %al,(%eax)
  281e79:	00 7e 40             	add    %bh,0x40(%esi)
  281e7c:	40                   	inc    %eax
  281e7d:	40                   	inc    %eax
  281e7e:	78 40                	js     281ec0 <Font8x16+0x498>
  281e80:	40                   	inc    %eax
  281e81:	40                   	inc    %eax
  281e82:	40                   	inc    %eax
  281e83:	7e 00                	jle    281e85 <Font8x16+0x45d>
  281e85:	00 00                	add    %al,(%eax)
  281e87:	00 00                	add    %al,(%eax)
  281e89:	00 7e 40             	add    %bh,0x40(%esi)
  281e8c:	40                   	inc    %eax
  281e8d:	40                   	inc    %eax
  281e8e:	78 40                	js     281ed0 <Font8x16+0x4a8>
  281e90:	40                   	inc    %eax
  281e91:	40                   	inc    %eax
  281e92:	40                   	inc    %eax
  281e93:	40                   	inc    %eax
  281e94:	00 00                	add    %al,(%eax)
  281e96:	00 00                	add    %al,(%eax)
  281e98:	00 00                	add    %al,(%eax)
  281e9a:	3c 42                	cmp    $0x42,%al
  281e9c:	40                   	inc    %eax
  281e9d:	40                   	inc    %eax
  281e9e:	5e                   	pop    %esi
  281e9f:	42                   	inc    %edx
  281ea0:	42                   	inc    %edx
  281ea1:	42                   	inc    %edx
  281ea2:	42                   	inc    %edx
  281ea3:	3c 00                	cmp    $0x0,%al
  281ea5:	00 00                	add    %al,(%eax)
  281ea7:	00 00                	add    %al,(%eax)
  281ea9:	00 42 42             	add    %al,0x42(%edx)
  281eac:	42                   	inc    %edx
  281ead:	42                   	inc    %edx
  281eae:	7e 42                	jle    281ef2 <Font8x16+0x4ca>
  281eb0:	42                   	inc    %edx
  281eb1:	42                   	inc    %edx
  281eb2:	42                   	inc    %edx
  281eb3:	42                   	inc    %edx
  281eb4:	00 00                	add    %al,(%eax)
  281eb6:	00 00                	add    %al,(%eax)
  281eb8:	00 00                	add    %al,(%eax)
  281eba:	38 10                	cmp    %dl,(%eax)
  281ebc:	10 10                	adc    %dl,(%eax)
  281ebe:	10 10                	adc    %dl,(%eax)
  281ec0:	10 10                	adc    %dl,(%eax)
  281ec2:	10 38                	adc    %bh,(%eax)
  281ec4:	00 00                	add    %al,(%eax)
  281ec6:	00 00                	add    %al,(%eax)
  281ec8:	00 00                	add    %al,(%eax)
  281eca:	1c 08                	sbb    $0x8,%al
  281ecc:	08 08                	or     %cl,(%eax)
  281ece:	08 08                	or     %cl,(%eax)
  281ed0:	08 08                	or     %cl,(%eax)
  281ed2:	48                   	dec    %eax
  281ed3:	30 00                	xor    %al,(%eax)
  281ed5:	00 00                	add    %al,(%eax)
  281ed7:	00 00                	add    %al,(%eax)
  281ed9:	00 42 44             	add    %al,0x44(%edx)
  281edc:	48                   	dec    %eax
  281edd:	50                   	push   %eax
  281ede:	60                   	pusha  
  281edf:	60                   	pusha  
  281ee0:	50                   	push   %eax
  281ee1:	48                   	dec    %eax
  281ee2:	44                   	inc    %esp
  281ee3:	42                   	inc    %edx
  281ee4:	00 00                	add    %al,(%eax)
  281ee6:	00 00                	add    %al,(%eax)
  281ee8:	00 00                	add    %al,(%eax)
  281eea:	40                   	inc    %eax
  281eeb:	40                   	inc    %eax
  281eec:	40                   	inc    %eax
  281eed:	40                   	inc    %eax
  281eee:	40                   	inc    %eax
  281eef:	40                   	inc    %eax
  281ef0:	40                   	inc    %eax
  281ef1:	40                   	inc    %eax
  281ef2:	40                   	inc    %eax
  281ef3:	7e 00                	jle    281ef5 <Font8x16+0x4cd>
  281ef5:	00 00                	add    %al,(%eax)
  281ef7:	00 00                	add    %al,(%eax)
  281ef9:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  281eff:	aa                   	stos   %al,%es:(%edi)
  281f00:	92                   	xchg   %eax,%edx
  281f01:	92                   	xchg   %eax,%edx
  281f02:	82                   	(bad)  
  281f03:	82                   	(bad)  
  281f04:	00 00                	add    %al,(%eax)
  281f06:	00 00                	add    %al,(%eax)
  281f08:	00 00                	add    %al,(%eax)
  281f0a:	42                   	inc    %edx
  281f0b:	62 62 52             	bound  %esp,0x52(%edx)
  281f0e:	52                   	push   %edx
  281f0f:	4a                   	dec    %edx
  281f10:	4a                   	dec    %edx
  281f11:	46                   	inc    %esi
  281f12:	46                   	inc    %esi
  281f13:	42                   	inc    %edx
  281f14:	00 00                	add    %al,(%eax)
  281f16:	00 00                	add    %al,(%eax)
  281f18:	00 00                	add    %al,(%eax)
  281f1a:	3c 42                	cmp    $0x42,%al
  281f1c:	42                   	inc    %edx
  281f1d:	42                   	inc    %edx
  281f1e:	42                   	inc    %edx
  281f1f:	42                   	inc    %edx
  281f20:	42                   	inc    %edx
  281f21:	42                   	inc    %edx
  281f22:	42                   	inc    %edx
  281f23:	3c 00                	cmp    $0x0,%al
  281f25:	00 00                	add    %al,(%eax)
  281f27:	00 00                	add    %al,(%eax)
  281f29:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281f2d:	42                   	inc    %edx
  281f2e:	42                   	inc    %edx
  281f2f:	7c 40                	jl     281f71 <Font8x16+0x549>
  281f31:	40                   	inc    %eax
  281f32:	40                   	inc    %eax
  281f33:	40                   	inc    %eax
  281f34:	00 00                	add    %al,(%eax)
  281f36:	00 00                	add    %al,(%eax)
  281f38:	00 00                	add    %al,(%eax)
  281f3a:	3c 42                	cmp    $0x42,%al
  281f3c:	42                   	inc    %edx
  281f3d:	42                   	inc    %edx
  281f3e:	42                   	inc    %edx
  281f3f:	42                   	inc    %edx
  281f40:	42                   	inc    %edx
  281f41:	42                   	inc    %edx
  281f42:	4a                   	dec    %edx
  281f43:	3c 0e                	cmp    $0xe,%al
  281f45:	00 00                	add    %al,(%eax)
  281f47:	00 00                	add    %al,(%eax)
  281f49:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281f4d:	42                   	inc    %edx
  281f4e:	42                   	inc    %edx
  281f4f:	7c 50                	jl     281fa1 <Font8x16+0x579>
  281f51:	48                   	dec    %eax
  281f52:	44                   	inc    %esp
  281f53:	42                   	inc    %edx
  281f54:	00 00                	add    %al,(%eax)
  281f56:	00 00                	add    %al,(%eax)
  281f58:	00 00                	add    %al,(%eax)
  281f5a:	3c 42                	cmp    $0x42,%al
  281f5c:	40                   	inc    %eax
  281f5d:	40                   	inc    %eax
  281f5e:	3c 02                	cmp    $0x2,%al
  281f60:	02 02                	add    (%edx),%al
  281f62:	42                   	inc    %edx
  281f63:	3c 00                	cmp    $0x0,%al
  281f65:	00 00                	add    %al,(%eax)
  281f67:	00 00                	add    %al,(%eax)
  281f69:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  281f6d:	10 10                	adc    %dl,(%eax)
  281f6f:	10 10                	adc    %dl,(%eax)
  281f71:	10 10                	adc    %dl,(%eax)
  281f73:	10 00                	adc    %al,(%eax)
  281f75:	00 00                	add    %al,(%eax)
  281f77:	00 00                	add    %al,(%eax)
  281f79:	00 42 42             	add    %al,0x42(%edx)
  281f7c:	42                   	inc    %edx
  281f7d:	42                   	inc    %edx
  281f7e:	42                   	inc    %edx
  281f7f:	42                   	inc    %edx
  281f80:	42                   	inc    %edx
  281f81:	42                   	inc    %edx
  281f82:	42                   	inc    %edx
  281f83:	3c 00                	cmp    $0x0,%al
  281f85:	00 00                	add    %al,(%eax)
  281f87:	00 00                	add    %al,(%eax)
  281f89:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  281f8d:	44                   	inc    %esp
  281f8e:	28 28                	sub    %ch,(%eax)
  281f90:	28 10                	sub    %dl,(%eax)
  281f92:	10 10                	adc    %dl,(%eax)
  281f94:	00 00                	add    %al,(%eax)
  281f96:	00 00                	add    %al,(%eax)
  281f98:	00 00                	add    %al,(%eax)
  281f9a:	82                   	(bad)  
  281f9b:	82                   	(bad)  
  281f9c:	82                   	(bad)  
  281f9d:	82                   	(bad)  
  281f9e:	54                   	push   %esp
  281f9f:	54                   	push   %esp
  281fa0:	54                   	push   %esp
  281fa1:	28 28                	sub    %ch,(%eax)
  281fa3:	28 00                	sub    %al,(%eax)
  281fa5:	00 00                	add    %al,(%eax)
  281fa7:	00 00                	add    %al,(%eax)
  281fa9:	00 42 42             	add    %al,0x42(%edx)
  281fac:	24 18                	and    $0x18,%al
  281fae:	18 18                	sbb    %bl,(%eax)
  281fb0:	24 24                	and    $0x24,%al
  281fb2:	42                   	inc    %edx
  281fb3:	42                   	inc    %edx
  281fb4:	00 00                	add    %al,(%eax)
  281fb6:	00 00                	add    %al,(%eax)
  281fb8:	00 00                	add    %al,(%eax)
  281fba:	44                   	inc    %esp
  281fbb:	44                   	inc    %esp
  281fbc:	44                   	inc    %esp
  281fbd:	44                   	inc    %esp
  281fbe:	28 28                	sub    %ch,(%eax)
  281fc0:	10 10                	adc    %dl,(%eax)
  281fc2:	10 10                	adc    %dl,(%eax)
  281fc4:	00 00                	add    %al,(%eax)
  281fc6:	00 00                	add    %al,(%eax)
  281fc8:	00 00                	add    %al,(%eax)
  281fca:	7e 02                	jle    281fce <Font8x16+0x5a6>
  281fcc:	02 04 08             	add    (%eax,%ecx,1),%al
  281fcf:	10 20                	adc    %ah,(%eax)
  281fd1:	40                   	inc    %eax
  281fd2:	40                   	inc    %eax
  281fd3:	7e 00                	jle    281fd5 <Font8x16+0x5ad>
  281fd5:	00 00                	add    %al,(%eax)
  281fd7:	00 00                	add    %al,(%eax)
  281fd9:	00 38                	add    %bh,(%eax)
  281fdb:	20 20                	and    %ah,(%eax)
  281fdd:	20 20                	and    %ah,(%eax)
  281fdf:	20 20                	and    %ah,(%eax)
  281fe1:	20 20                	and    %ah,(%eax)
  281fe3:	38 00                	cmp    %al,(%eax)
	...
  281fed:	00 40 20             	add    %al,0x20(%eax)
  281ff0:	10 08                	adc    %cl,(%eax)
  281ff2:	04 02                	add    $0x2,%al
  281ff4:	00 00                	add    %al,(%eax)
  281ff6:	00 00                	add    %al,(%eax)
  281ff8:	00 00                	add    %al,(%eax)
  281ffa:	1c 04                	sbb    $0x4,%al
  281ffc:	04 04                	add    $0x4,%al
  281ffe:	04 04                	add    $0x4,%al
  282000:	04 04                	add    $0x4,%al
  282002:	04 1c                	add    $0x1c,%al
	...
  28200c:	10 28                	adc    %ch,(%eax)
  28200e:	44                   	inc    %esp
	...
  282023:	00 ff                	add    %bh,%bh
  282025:	00 00                	add    %al,(%eax)
  282027:	00 00                	add    %al,(%eax)
  282029:	00 00                	add    %al,(%eax)
  28202b:	10 10                	adc    %dl,(%eax)
  28202d:	08 00                	or     %al,(%eax)
	...
  28203b:	00 00                	add    %al,(%eax)
  28203d:	78 04                	js     282043 <Font8x16+0x61b>
  28203f:	3c 44                	cmp    $0x44,%al
  282041:	44                   	inc    %esp
  282042:	44                   	inc    %esp
  282043:	3a 00                	cmp    (%eax),%al
  282045:	00 00                	add    %al,(%eax)
  282047:	00 00                	add    %al,(%eax)
  282049:	00 40 40             	add    %al,0x40(%eax)
  28204c:	40                   	inc    %eax
  28204d:	5c                   	pop    %esp
  28204e:	62 42 42             	bound  %eax,0x42(%edx)
  282051:	42                   	inc    %edx
  282052:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  282056:	00 00                	add    %al,(%eax)
  282058:	00 00                	add    %al,(%eax)
  28205a:	00 00                	add    %al,(%eax)
  28205c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  28205f:	40                   	inc    %eax
  282060:	40                   	inc    %eax
  282061:	40                   	inc    %eax
  282062:	42                   	inc    %edx
  282063:	3c 00                	cmp    $0x0,%al
  282065:	00 00                	add    %al,(%eax)
  282067:	00 00                	add    %al,(%eax)
  282069:	00 02                	add    %al,(%edx)
  28206b:	02 02                	add    (%edx),%al
  28206d:	3a 46 42             	cmp    0x42(%esi),%al
  282070:	42                   	inc    %edx
  282071:	42                   	inc    %edx
  282072:	46                   	inc    %esi
  282073:	3a 00                	cmp    (%eax),%al
	...
  28207d:	3c 42                	cmp    $0x42,%al
  28207f:	42                   	inc    %edx
  282080:	7e 40                	jle    2820c2 <Font8x16+0x69a>
  282082:	42                   	inc    %edx
  282083:	3c 00                	cmp    $0x0,%al
  282085:	00 00                	add    %al,(%eax)
  282087:	00 00                	add    %al,(%eax)
  282089:	00 0e                	add    %cl,(%esi)
  28208b:	10 10                	adc    %dl,(%eax)
  28208d:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  282090:	10 10                	adc    %dl,(%eax)
  282092:	10 10                	adc    %dl,(%eax)
	...
  28209c:	00 3e                	add    %bh,(%esi)
  28209e:	42                   	inc    %edx
  28209f:	42                   	inc    %edx
  2820a0:	42                   	inc    %edx
  2820a1:	42                   	inc    %edx
  2820a2:	3e 02 02             	add    %ds:(%edx),%al
  2820a5:	3c 00                	cmp    $0x0,%al
  2820a7:	00 00                	add    %al,(%eax)
  2820a9:	00 40 40             	add    %al,0x40(%eax)
  2820ac:	40                   	inc    %eax
  2820ad:	5c                   	pop    %esp
  2820ae:	62 42 42             	bound  %eax,0x42(%edx)
  2820b1:	42                   	inc    %edx
  2820b2:	42                   	inc    %edx
  2820b3:	42                   	inc    %edx
  2820b4:	00 00                	add    %al,(%eax)
  2820b6:	00 00                	add    %al,(%eax)
  2820b8:	00 00                	add    %al,(%eax)
  2820ba:	00 08                	add    %cl,(%eax)
  2820bc:	00 08                	add    %cl,(%eax)
  2820be:	08 08                	or     %cl,(%eax)
  2820c0:	08 08                	or     %cl,(%eax)
  2820c2:	08 08                	or     %cl,(%eax)
  2820c4:	00 00                	add    %al,(%eax)
  2820c6:	00 00                	add    %al,(%eax)
  2820c8:	00 00                	add    %al,(%eax)
  2820ca:	00 04 00             	add    %al,(%eax,%eax,1)
  2820cd:	04 04                	add    $0x4,%al
  2820cf:	04 04                	add    $0x4,%al
  2820d1:	04 04                	add    $0x4,%al
  2820d3:	04 44                	add    $0x44,%al
  2820d5:	38 00                	cmp    %al,(%eax)
  2820d7:	00 00                	add    %al,(%eax)
  2820d9:	00 40 40             	add    %al,0x40(%eax)
  2820dc:	40                   	inc    %eax
  2820dd:	42                   	inc    %edx
  2820de:	44                   	inc    %esp
  2820df:	48                   	dec    %eax
  2820e0:	50                   	push   %eax
  2820e1:	68 44 42 00 00       	push   $0x4244
  2820e6:	00 00                	add    %al,(%eax)
  2820e8:	00 00                	add    %al,(%eax)
  2820ea:	10 10                	adc    %dl,(%eax)
  2820ec:	10 10                	adc    %dl,(%eax)
  2820ee:	10 10                	adc    %dl,(%eax)
  2820f0:	10 10                	adc    %dl,(%eax)
  2820f2:	10 10                	adc    %dl,(%eax)
	...
  2820fc:	00 ec                	add    %ch,%ah
  2820fe:	92                   	xchg   %eax,%edx
  2820ff:	92                   	xchg   %eax,%edx
  282100:	92                   	xchg   %eax,%edx
  282101:	92                   	xchg   %eax,%edx
  282102:	92                   	xchg   %eax,%edx
  282103:	92                   	xchg   %eax,%edx
	...
  28210c:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  282110:	42                   	inc    %edx
  282111:	42                   	inc    %edx
  282112:	42                   	inc    %edx
  282113:	42                   	inc    %edx
	...
  28211c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  28211f:	42                   	inc    %edx
  282120:	42                   	inc    %edx
  282121:	42                   	inc    %edx
  282122:	42                   	inc    %edx
  282123:	3c 00                	cmp    $0x0,%al
	...
  28212d:	5c                   	pop    %esp
  28212e:	62 42 42             	bound  %eax,0x42(%edx)
  282131:	42                   	inc    %edx
  282132:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  282136:	00 00                	add    %al,(%eax)
  282138:	00 00                	add    %al,(%eax)
  28213a:	00 00                	add    %al,(%eax)
  28213c:	00 3a                	add    %bh,(%edx)
  28213e:	46                   	inc    %esi
  28213f:	42                   	inc    %edx
  282140:	42                   	inc    %edx
  282141:	42                   	inc    %edx
  282142:	46                   	inc    %esi
  282143:	3a 02                	cmp    (%edx),%al
  282145:	02 00                	add    (%eax),%al
  282147:	00 00                	add    %al,(%eax)
  282149:	00 00                	add    %al,(%eax)
  28214b:	00 00                	add    %al,(%eax)
  28214d:	5c                   	pop    %esp
  28214e:	62 40 40             	bound  %eax,0x40(%eax)
  282151:	40                   	inc    %eax
  282152:	40                   	inc    %eax
  282153:	40                   	inc    %eax
	...
  28215c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  28215f:	40                   	inc    %eax
  282160:	3c 02                	cmp    $0x2,%al
  282162:	42                   	inc    %edx
  282163:	3c 00                	cmp    $0x0,%al
  282165:	00 00                	add    %al,(%eax)
  282167:	00 00                	add    %al,(%eax)
  282169:	00 00                	add    %al,(%eax)
  28216b:	20 20                	and    %ah,(%eax)
  28216d:	78 20                	js     28218f <Font8x16+0x767>
  28216f:	20 20                	and    %ah,(%eax)
  282171:	20 22                	and    %ah,(%edx)
  282173:	1c 00                	sbb    $0x0,%al
	...
  28217d:	42                   	inc    %edx
  28217e:	42                   	inc    %edx
  28217f:	42                   	inc    %edx
  282180:	42                   	inc    %edx
  282181:	42                   	inc    %edx
  282182:	42                   	inc    %edx
  282183:	3e 00 00             	add    %al,%ds:(%eax)
  282186:	00 00                	add    %al,(%eax)
  282188:	00 00                	add    %al,(%eax)
  28218a:	00 00                	add    %al,(%eax)
  28218c:	00 42 42             	add    %al,0x42(%edx)
  28218f:	42                   	inc    %edx
  282190:	42                   	inc    %edx
  282191:	42                   	inc    %edx
  282192:	24 18                	and    $0x18,%al
	...
  28219c:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  2821a2:	aa                   	stos   %al,%es:(%edi)
  2821a3:	44                   	inc    %esp
	...
  2821ac:	00 42 42             	add    %al,0x42(%edx)
  2821af:	24 18                	and    $0x18,%al
  2821b1:	24 42                	and    $0x42,%al
  2821b3:	42                   	inc    %edx
	...
  2821bc:	00 42 42             	add    %al,0x42(%edx)
  2821bf:	42                   	inc    %edx
  2821c0:	42                   	inc    %edx
  2821c1:	42                   	inc    %edx
  2821c2:	3e 02 02             	add    %ds:(%edx),%al
  2821c5:	3c 00                	cmp    $0x0,%al
  2821c7:	00 00                	add    %al,(%eax)
  2821c9:	00 00                	add    %al,(%eax)
  2821cb:	00 00                	add    %al,(%eax)
  2821cd:	7e 02                	jle    2821d1 <Font8x16+0x7a9>
  2821cf:	04 18                	add    $0x18,%al
  2821d1:	20 40 7e             	and    %al,0x7e(%eax)
  2821d4:	00 00                	add    %al,(%eax)
  2821d6:	00 00                	add    %al,(%eax)
  2821d8:	00 00                	add    %al,(%eax)
  2821da:	08 10                	or     %dl,(%eax)
  2821dc:	10 10                	adc    %dl,(%eax)
  2821de:	20 40 20             	and    %al,0x20(%eax)
  2821e1:	10 10                	adc    %dl,(%eax)
  2821e3:	10 08                	adc    %cl,(%eax)
  2821e5:	00 00                	add    %al,(%eax)
  2821e7:	00 00                	add    %al,(%eax)
  2821e9:	10 10                	adc    %dl,(%eax)
  2821eb:	10 10                	adc    %dl,(%eax)
  2821ed:	10 10                	adc    %dl,(%eax)
  2821ef:	10 10                	adc    %dl,(%eax)
  2821f1:	10 10                	adc    %dl,(%eax)
  2821f3:	10 10                	adc    %dl,(%eax)
  2821f5:	10 10                	adc    %dl,(%eax)
  2821f7:	00 00                	add    %al,(%eax)
  2821f9:	00 20                	add    %ah,(%eax)
  2821fb:	10 10                	adc    %dl,(%eax)
  2821fd:	10 08                	adc    %cl,(%eax)
  2821ff:	04 08                	add    $0x8,%al
  282201:	10 10                	adc    %dl,(%eax)
  282203:	10 20                	adc    %ah,(%eax)
	...
  28220d:	00 22                	add    %ah,(%edx)
  28220f:	54                   	push   %esp
  282210:	88 00                	mov    %al,(%eax)
	...

00282228 <ASCII_Table>:
	...
  282258:	00 00                	add    %al,(%eax)
  28225a:	80 01 80             	addb   $0x80,(%ecx)
  28225d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282263:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282269:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28226f:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  282275:	00 00                	add    %al,(%eax)
  282277:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282289:	00 00                	add    %al,(%eax)
  28228b:	00 cc                	add    %cl,%ah
  28228d:	00 cc                	add    %cl,%ah
  28228f:	00 cc                	add    %cl,%ah
  282291:	00 cc                	add    %cl,%ah
  282293:	00 cc                	add    %cl,%ah
  282295:	00 cc                	add    %cl,%ah
	...
  2822c3:	00 60 0c             	add    %ah,0xc(%eax)
  2822c6:	60                   	pusha  
  2822c7:	0c 60                	or     $0x60,%al
  2822c9:	0c 30                	or     $0x30,%al
  2822cb:	06                   	push   %es
  2822cc:	30 06                	xor    %al,(%esi)
  2822ce:	fe                   	(bad)  
  2822cf:	1f                   	pop    %ds
  2822d0:	fe                   	(bad)  
  2822d1:	1f                   	pop    %ds
  2822d2:	30 06                	xor    %al,(%esi)
  2822d4:	38 07                	cmp    %al,(%edi)
  2822d6:	18 03                	sbb    %al,(%ebx)
  2822d8:	fe                   	(bad)  
  2822d9:	1f                   	pop    %ds
  2822da:	fe                   	(bad)  
  2822db:	1f                   	pop    %ds
  2822dc:	18 03                	sbb    %al,(%ebx)
  2822de:	18 03                	sbb    %al,(%ebx)
  2822e0:	8c 01                	mov    %es,(%ecx)
  2822e2:	8c 01                	mov    %es,(%ecx)
  2822e4:	8c 01                	mov    %es,(%ecx)
  2822e6:	00 00                	add    %al,(%eax)
  2822e8:	00 00                	add    %al,(%eax)
  2822ea:	80 00 e0             	addb   $0xe0,(%eax)
  2822ed:	03 f8                	add    %eax,%edi
  2822ef:	0f 9c 0e             	setl   (%esi)
  2822f2:	8c 1c 8c             	mov    %ds,(%esp,%ecx,4)
  2822f5:	18 8c 00 98 00 f8 01 	sbb    %cl,0x1f80098(%eax,%eax,1)
  2822fc:	e0 07                	loopne 282305 <ASCII_Table+0xdd>
  2822fe:	80 0e 80             	orb    $0x80,(%esi)
  282301:	1c 8c                	sbb    $0x8c,%al
  282303:	18 8c 18 9c 18 b8 0c 	sbb    %cl,0xcb8189c(%eax,%ebx,1)
  28230a:	f0 0f e0 03          	lock pavgb (%ebx),%mm0
  28230e:	80 00 80             	addb   $0x80,(%eax)
	...
  28231d:	00 0e                	add    %cl,(%esi)
  28231f:	18 1b                	sbb    %bl,(%ebx)
  282321:	0c 11                	or     $0x11,%al
  282323:	0c 11                	or     $0x11,%al
  282325:	06                   	push   %es
  282326:	11 06                	adc    %eax,(%esi)
  282328:	11 03                	adc    %eax,(%ebx)
  28232a:	11 03                	adc    %eax,(%ebx)
  28232c:	9b                   	fwait
  28232d:	01 8e 01 c0 38 c0    	add    %ecx,-0x3fc73fff(%esi)
  282333:	6c                   	insb   (%dx),%es:(%edi)
  282334:	60                   	pusha  
  282335:	44                   	inc    %esp
  282336:	60                   	pusha  
  282337:	44                   	inc    %esp
  282338:	30 44 30 44          	xor    %al,0x44(%eax,%esi,1)
  28233c:	18 44 18 6c          	sbb    %al,0x6c(%eax,%ebx,1)
  282340:	0c 38                	or     $0x38,%al
	...
  28234a:	e0 01                	loopne 28234d <ASCII_Table+0x125>
  28234c:	f0 03 38             	lock add (%eax),%edi
  28234f:	07                   	pop    %es
  282350:	18 06                	sbb    %al,(%esi)
  282352:	18 06                	sbb    %al,(%esi)
  282354:	30 03                	xor    %al,(%ebx)
  282356:	f0 01 f0             	lock add %esi,%eax
  282359:	00 f8                	add    %bh,%al
  28235b:	00 9c 31 0e 33 06 1e 	add    %bl,0x1e06330e(%ecx,%esi,1)
  282362:	06                   	push   %es
  282363:	1c 06                	sbb    $0x6,%al
  282365:	1c 06                	sbb    $0x6,%al
  282367:	3f                   	aas    
  282368:	fc                   	cld    
  282369:	73 f0                	jae    28235b <ASCII_Table+0x133>
  28236b:	21 00                	and    %eax,(%eax)
	...
  282379:	00 00                	add    %al,(%eax)
  28237b:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28237e:	0c 00                	or     $0x0,%al
  282380:	0c 00                	or     $0x0,%al
  282382:	0c 00                	or     $0x0,%al
  282384:	0c 00                	or     $0x0,%al
  282386:	0c 00                	or     $0x0,%al
	...
  2823a8:	00 00                	add    %al,(%eax)
  2823aa:	00 02                	add    %al,(%edx)
  2823ac:	00 03                	add    %al,(%ebx)
  2823ae:	80 01 c0             	addb   $0xc0,(%ecx)
  2823b1:	00 c0                	add    %al,%al
  2823b3:	00 60 00             	add    %ah,0x0(%eax)
  2823b6:	60                   	pusha  
  2823b7:	00 30                	add    %dh,(%eax)
  2823b9:	00 30                	add    %dh,(%eax)
  2823bb:	00 30                	add    %dh,(%eax)
  2823bd:	00 30                	add    %dh,(%eax)
  2823bf:	00 30                	add    %dh,(%eax)
  2823c1:	00 30                	add    %dh,(%eax)
  2823c3:	00 30                	add    %dh,(%eax)
  2823c5:	00 30                	add    %dh,(%eax)
  2823c7:	00 60 00             	add    %ah,0x0(%eax)
  2823ca:	60                   	pusha  
  2823cb:	00 c0                	add    %al,%al
  2823cd:	00 c0                	add    %al,%al
  2823cf:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  2823d5:	02 00                	add    (%eax),%al
  2823d7:	00 00                	add    %al,(%eax)
  2823d9:	00 20                	add    %ah,(%eax)
  2823db:	00 60 00             	add    %ah,0x0(%eax)
  2823de:	c0 00 80             	rolb   $0x80,(%eax)
  2823e1:	01 80 01 00 03 00    	add    %eax,0x30001(%eax)
  2823e7:	03 00                	add    (%eax),%eax
  2823e9:	06                   	push   %es
  2823ea:	00 06                	add    %al,(%esi)
  2823ec:	00 06                	add    %al,(%esi)
  2823ee:	00 06                	add    %al,(%esi)
  2823f0:	00 06                	add    %al,(%esi)
  2823f2:	00 06                	add    %al,(%esi)
  2823f4:	00 06                	add    %al,(%esi)
  2823f6:	00 06                	add    %al,(%esi)
  2823f8:	00 03                	add    %al,(%ebx)
  2823fa:	00 03                	add    %al,(%ebx)
  2823fc:	80 01 80             	addb   $0x80,(%ecx)
  2823ff:	01 c0                	add    %eax,%eax
  282401:	00 60 00             	add    %ah,0x0(%eax)
  282404:	20 00                	and    %al,(%eax)
	...
  282412:	00 00                	add    %al,(%eax)
  282414:	c0 00 c0             	rolb   $0xc0,(%eax)
  282417:	00 d8                	add    %bl,%al
  282419:	06                   	push   %es
  28241a:	f8                   	clc    
  28241b:	07                   	pop    %es
  28241c:	e0 01                	loopne 28241f <ASCII_Table+0x1f7>
  28241e:	30 03                	xor    %al,(%ebx)
  282420:	38 07                	cmp    %al,(%edi)
	...
  282442:	00 00                	add    %al,(%eax)
  282444:	80 01 80             	addb   $0x80,(%ecx)
  282447:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28244d:	01 fc                	add    %edi,%esp
  28244f:	3f                   	aas    
  282450:	fc                   	cld    
  282451:	3f                   	aas    
  282452:	80 01 80             	addb   $0x80,(%ecx)
  282455:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28245b:	01 00                	add    %eax,(%eax)
	...
  282489:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  28248f:	01 00                	add    %eax,(%eax)
  282491:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  2824af:	00 e0                	add    %ah,%al
  2824b1:	07                   	pop    %es
  2824b2:	e0 07                	loopne 2824bb <ASCII_Table+0x293>
	...
  2824e8:	00 00                	add    %al,(%eax)
  2824ea:	c0 00 c0             	rolb   $0xc0,(%eax)
	...
  2824f9:	00 00                	add    %al,(%eax)
  2824fb:	0c 00                	or     $0x0,%al
  2824fd:	0c 00                	or     $0x0,%al
  2824ff:	06                   	push   %es
  282500:	00 06                	add    %al,(%esi)
  282502:	00 06                	add    %al,(%esi)
  282504:	00 03                	add    %al,(%ebx)
  282506:	00 03                	add    %al,(%ebx)
  282508:	00 03                	add    %al,(%ebx)
  28250a:	80 03 80             	addb   $0x80,(%ebx)
  28250d:	01 80 01 80 01 c0    	add    %eax,-0x3ffe7fff(%eax)
  282513:	00 c0                	add    %al,%al
  282515:	00 c0                	add    %al,%al
  282517:	00 60 00             	add    %ah,0x0(%eax)
  28251a:	60                   	pusha  
	...
  282527:	00 00                	add    %al,(%eax)
  282529:	00 e0                	add    %ah,%al
  28252b:	03 f0                	add    %eax,%esi
  28252d:	07                   	pop    %es
  28252e:	38 0e                	cmp    %cl,(%esi)
  282530:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  282533:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282536:	0c 18                	or     $0x18,%al
  282538:	0c 18                	or     $0x18,%al
  28253a:	0c 18                	or     $0x18,%al
  28253c:	0c 18                	or     $0x18,%al
  28253e:	0c 18                	or     $0x18,%al
  282540:	0c 18                	or     $0x18,%al
  282542:	0c 18                	or     $0x18,%al
  282544:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  282547:	0e                   	push   %cs
  282548:	f0 07                	lock pop %es
  28254a:	e0 03                	loopne 28254f <ASCII_Table+0x327>
	...
  282558:	00 00                	add    %al,(%eax)
  28255a:	00 01                	add    %al,(%ecx)
  28255c:	80 01 c0             	addb   $0xc0,(%ecx)
  28255f:	01 f0                	add    %esi,%eax
  282561:	01 98 01 88 01 80    	add    %ebx,-0x7ffe77ff(%eax)
  282567:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28256d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282573:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282579:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  282587:	00 00                	add    %al,(%eax)
  282589:	00 e0                	add    %ah,%al
  28258b:	03 f8                	add    %eax,%edi
  28258d:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  282591:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282594:	00 18                	add    %bl,(%eax)
  282596:	00 18                	add    %bl,(%eax)
  282598:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28259b:	06                   	push   %es
  28259c:	00 03                	add    %al,(%ebx)
  28259e:	80 01 c0             	addb   $0xc0,(%ecx)
  2825a1:	00 60 00             	add    %ah,0x0(%eax)
  2825a4:	30 00                	xor    %al,(%eax)
  2825a6:	18 00                	sbb    %al,(%eax)
  2825a8:	fc                   	cld    
  2825a9:	1f                   	pop    %ds
  2825aa:	fc                   	cld    
  2825ab:	1f                   	pop    %ds
	...
  2825b8:	00 00                	add    %al,(%eax)
  2825ba:	e0 01                	loopne 2825bd <ASCII_Table+0x395>
  2825bc:	f8                   	clc    
  2825bd:	07                   	pop    %es
  2825be:	18 0e                	sbb    %cl,(%esi)
  2825c0:	0c 0c                	or     $0xc,%al
  2825c2:	0c 0c                	or     $0xc,%al
  2825c4:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2825c7:	06                   	push   %es
  2825c8:	c0 03 c0             	rolb   $0xc0,(%ebx)
  2825cb:	07                   	pop    %es
  2825cc:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2825cf:	18 00                	sbb    %al,(%eax)
  2825d1:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2825d4:	0c 18                	or     $0x18,%al
  2825d6:	18 0c f8             	sbb    %cl,(%eax,%edi,8)
  2825d9:	07                   	pop    %es
  2825da:	e0 03                	loopne 2825df <ASCII_Table+0x3b7>
	...
  2825e8:	00 00                	add    %al,(%eax)
  2825ea:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2825ed:	0e                   	push   %cs
  2825ee:	00 0f                	add    %cl,(%edi)
  2825f0:	00 0f                	add    %cl,(%edi)
  2825f2:	80 0d c0 0c 60 0c 60 	orb    $0x60,0xc600cc0
  2825f9:	0c 30                	or     $0x30,%al
  2825fb:	0c 18                	or     $0x18,%al
  2825fd:	0c 0c                	or     $0xc,%al
  2825ff:	0c fc                	or     $0xfc,%al
  282601:	3f                   	aas    
  282602:	fc                   	cld    
  282603:	3f                   	aas    
  282604:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282607:	0c 00                	or     $0x0,%al
  282609:	0c 00                	or     $0x0,%al
  28260b:	0c 00                	or     $0x0,%al
	...
  282619:	00 f8                	add    %bh,%al
  28261b:	0f f8 0f             	psubb  (%edi),%mm1
  28261e:	18 00                	sbb    %al,(%eax)
  282620:	18 00                	sbb    %al,(%eax)
  282622:	0c 00                	or     $0x0,%al
  282624:	ec                   	in     (%dx),%al
  282625:	03 fc                	add    %esp,%edi
  282627:	07                   	pop    %es
  282628:	1c 0e                	sbb    $0xe,%al
  28262a:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28262d:	18 00                	sbb    %al,(%eax)
  28262f:	18 00                	sbb    %al,(%eax)
  282631:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282634:	1c 0c                	sbb    $0xc,%al
  282636:	18 0e                	sbb    %cl,(%esi)
  282638:	f8                   	clc    
  282639:	07                   	pop    %es
  28263a:	e0 03                	loopne 28263f <ASCII_Table+0x417>
	...
  282648:	00 00                	add    %al,(%eax)
  28264a:	c0 07 f0             	rolb   $0xf0,(%edi)
  28264d:	0f 38 1c 18          	pabsb  (%eax),%mm3
  282651:	18 18                	sbb    %bl,(%eax)
  282653:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282656:	cc                   	int3   
  282657:	03 ec                	add    %esp,%ebp
  282659:	0f 3c                	(bad)  
  28265b:	0e                   	push   %cs
  28265c:	1c 1c                	sbb    $0x1c,%al
  28265e:	0c 18                	or     $0x18,%al
  282660:	0c 18                	or     $0x18,%al
  282662:	0c 18                	or     $0x18,%al
  282664:	18 1c 38             	sbb    %bl,(%eax,%edi,1)
  282667:	0e                   	push   %cs
  282668:	f0 07                	lock pop %es
  28266a:	e0 03                	loopne 28266f <ASCII_Table+0x447>
	...
  282678:	00 00                	add    %al,(%eax)
  28267a:	fc                   	cld    
  28267b:	1f                   	pop    %ds
  28267c:	fc                   	cld    
  28267d:	1f                   	pop    %ds
  28267e:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282681:	06                   	push   %es
  282682:	00 06                	add    %al,(%esi)
  282684:	00 03                	add    %al,(%ebx)
  282686:	80 03 80             	addb   $0x80,(%ebx)
  282689:	01 c0                	add    %eax,%eax
  28268b:	01 c0                	add    %eax,%eax
  28268d:	00 e0                	add    %ah,%al
  28268f:	00 60 00             	add    %ah,0x0(%eax)
  282692:	60                   	pusha  
  282693:	00 70 00             	add    %dh,0x0(%eax)
  282696:	30 00                	xor    %al,(%eax)
  282698:	30 00                	xor    %al,(%eax)
  28269a:	30 00                	xor    %al,(%eax)
	...
  2826a8:	00 00                	add    %al,(%eax)
  2826aa:	e0 03                	loopne 2826af <ASCII_Table+0x487>
  2826ac:	f0 07                	lock pop %es
  2826ae:	38 0e                	cmp    %cl,(%esi)
  2826b0:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2826b3:	0c 18                	or     $0x18,%al
  2826b5:	0c 38                	or     $0x38,%al
  2826b7:	06                   	push   %es
  2826b8:	f0 07                	lock pop %es
  2826ba:	f0 07                	lock pop %es
  2826bc:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  2826bf:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2826c2:	0c 18                	or     $0x18,%al
  2826c4:	0c 18                	or     $0x18,%al
  2826c6:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  2826c9:	0f e0 03             	pavgb  (%ebx),%mm0
	...
  2826d8:	00 00                	add    %al,(%eax)
  2826da:	e0 03                	loopne 2826df <ASCII_Table+0x4b7>
  2826dc:	f0 07                	lock pop %es
  2826de:	38 0e                	cmp    %cl,(%esi)
  2826e0:	1c 0c                	sbb    $0xc,%al
  2826e2:	0c 18                	or     $0x18,%al
  2826e4:	0c 18                	or     $0x18,%al
  2826e6:	0c 18                	or     $0x18,%al
  2826e8:	1c 1c                	sbb    $0x1c,%al
  2826ea:	38 1e                	cmp    %bl,(%esi)
  2826ec:	f8                   	clc    
  2826ed:	1b e0                	sbb    %eax,%esp
  2826ef:	19 00                	sbb    %eax,(%eax)
  2826f1:	18 00                	sbb    %al,(%eax)
  2826f3:	0c 00                	or     $0x0,%al
  2826f5:	0c 1c                	or     $0x1c,%al
  2826f7:	0e                   	push   %cs
  2826f8:	f8                   	clc    
  2826f9:	07                   	pop    %es
  2826fa:	f0 01 00             	lock add %eax,(%eax)
	...
  282711:	00 00                	add    %al,(%eax)
  282713:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282725:	00 00                	add    %al,(%eax)
  282727:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282741:	00 00                	add    %al,(%eax)
  282743:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282755:	00 00                	add    %al,(%eax)
  282757:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  28275d:	01 00                	add    %eax,(%eax)
  28275f:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  282779:	10 00                	adc    %al,(%eax)
  28277b:	1c 80                	sbb    $0x80,%al
  28277d:	0f e0 03             	pavgb  (%ebx),%mm0
  282780:	f8                   	clc    
  282781:	00 18                	add    %bl,(%eax)
  282783:	00 f8                	add    %bh,%al
  282785:	00 e0                	add    %ah,%al
  282787:	03 80 0f 00 1c 00    	add    0x1c000f(%eax),%eax
  28278d:	10 00                	adc    %al,(%eax)
	...
  2827a7:	00 f8                	add    %bh,%al
  2827a9:	1f                   	pop    %ds
  2827aa:	00 00                	add    %al,(%eax)
  2827ac:	00 00                	add    %al,(%eax)
  2827ae:	00 00                	add    %al,(%eax)
  2827b0:	f8                   	clc    
  2827b1:	1f                   	pop    %ds
	...
  2827d6:	00 00                	add    %al,(%eax)
  2827d8:	08 00                	or     %al,(%eax)
  2827da:	38 00                	cmp    %al,(%eax)
  2827dc:	f0 01 c0             	lock add %eax,%eax
  2827df:	07                   	pop    %es
  2827e0:	00 1f                	add    %bl,(%edi)
  2827e2:	00 18                	add    %bl,(%eax)
  2827e4:	00 1f                	add    %bl,(%edi)
  2827e6:	c0 07 f0             	rolb   $0xf0,(%edi)
  2827e9:	01 38                	add    %edi,(%eax)
  2827eb:	00 08                	add    %cl,(%eax)
	...
  2827f9:	00 e0                	add    %ah,%al
  2827fb:	03 f8                	add    %eax,%edi
  2827fd:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  282801:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282804:	00 18                	add    %bl,(%eax)
  282806:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282809:	06                   	push   %es
  28280a:	00 03                	add    %al,(%ebx)
  28280c:	80 01 c0             	addb   $0xc0,(%ecx)
  28280f:	00 c0                	add    %al,%al
  282811:	00 c0                	add    %al,%al
  282813:	00 00                	add    %al,(%eax)
  282815:	00 00                	add    %al,(%eax)
  282817:	00 c0                	add    %al,%al
  282819:	00 c0                	add    %al,%al
	...
  28282b:	00 e0                	add    %ah,%al
  28282d:	07                   	pop    %es
  28282e:	18 18                	sbb    %bl,(%eax)
  282830:	04 20                	add    $0x20,%al
  282832:	c2 29 22             	ret    $0x2229
  282835:	4a                   	dec    %edx
  282836:	11 44 09 44          	adc    %eax,0x44(%ecx,%ecx,1)
  28283a:	09 44 09 44          	or     %eax,0x44(%ecx,%ecx,1)
  28283e:	09 22                	or     %esp,(%edx)
  282840:	11 13                	adc    %edx,(%ebx)
  282842:	e2 0c                	loop   282850 <ASCII_Table+0x628>
  282844:	02 40 04             	add    0x4(%eax),%al
  282847:	20 18                	and    %bl,(%eax)
  282849:	18 e0                	sbb    %ah,%al
  28284b:	07                   	pop    %es
	...
  282858:	00 00                	add    %al,(%eax)
  28285a:	80 03 80             	addb   $0x80,(%ebx)
  28285d:	03 c0                	add    %eax,%eax
  28285f:	06                   	push   %es
  282860:	c0 06 c0             	rolb   $0xc0,(%esi)
  282863:	06                   	push   %es
  282864:	60                   	pusha  
  282865:	0c 60                	or     $0x60,%al
  282867:	0c 30                	or     $0x30,%al
  282869:	18 30                	sbb    %dh,(%eax)
  28286b:	18 30                	sbb    %dh,(%eax)
  28286d:	18 f8                	sbb    %bh,%al
  28286f:	3f                   	aas    
  282870:	f8                   	clc    
  282871:	3f                   	aas    
  282872:	1c 70                	sbb    $0x70,%al
  282874:	0c 60                	or     $0x60,%al
  282876:	0c 60                	or     $0x60,%al
  282878:	06                   	push   %es
  282879:	c0 06 c0             	rolb   $0xc0,(%esi)
	...
  282888:	00 00                	add    %al,(%eax)
  28288a:	fc                   	cld    
  28288b:	03 fc                	add    %esp,%edi
  28288d:	0f 0c                	(bad)  
  28288f:	0c 0c                	or     $0xc,%al
  282891:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282894:	0c 18                	or     $0x18,%al
  282896:	0c 0c                	or     $0xc,%al
  282898:	fc                   	cld    
  282899:	07                   	pop    %es
  28289a:	fc                   	cld    
  28289b:	0f 0c                	(bad)  
  28289d:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  2828a0:	0c 30                	or     $0x30,%al
  2828a2:	0c 30                	or     $0x30,%al
  2828a4:	0c 30                	or     $0x30,%al
  2828a6:	0c 18                	or     $0x18,%al
  2828a8:	fc                   	cld    
  2828a9:	1f                   	pop    %ds
  2828aa:	fc                   	cld    
  2828ab:	07                   	pop    %es
	...
  2828b8:	00 00                	add    %al,(%eax)
  2828ba:	c0 07 f0             	rolb   $0xf0,(%edi)
  2828bd:	1f                   	pop    %ds
  2828be:	38 38                	cmp    %bh,(%eax)
  2828c0:	1c 30                	sbb    $0x30,%al
  2828c2:	0c 70                	or     $0x70,%al
  2828c4:	06                   	push   %es
  2828c5:	60                   	pusha  
  2828c6:	06                   	push   %es
  2828c7:	00 06                	add    %al,(%esi)
  2828c9:	00 06                	add    %al,(%esi)
  2828cb:	00 06                	add    %al,(%esi)
  2828cd:	00 06                	add    %al,(%esi)
  2828cf:	00 06                	add    %al,(%esi)
  2828d1:	00 06                	add    %al,(%esi)
  2828d3:	60                   	pusha  
  2828d4:	0c 70                	or     $0x70,%al
  2828d6:	1c 30                	sbb    $0x30,%al
  2828d8:	f0 1f                	lock pop %ds
  2828da:	e0 07                	loopne 2828e3 <ASCII_Table+0x6bb>
	...
  2828e8:	00 00                	add    %al,(%eax)
  2828ea:	fe 03                	incb   (%ebx)
  2828ec:	fe 0f                	decb   (%edi)
  2828ee:	06                   	push   %es
  2828ef:	0e                   	push   %cs
  2828f0:	06                   	push   %es
  2828f1:	18 06                	sbb    %al,(%esi)
  2828f3:	18 06                	sbb    %al,(%esi)
  2828f5:	30 06                	xor    %al,(%esi)
  2828f7:	30 06                	xor    %al,(%esi)
  2828f9:	30 06                	xor    %al,(%esi)
  2828fb:	30 06                	xor    %al,(%esi)
  2828fd:	30 06                	xor    %al,(%esi)
  2828ff:	30 06                	xor    %al,(%esi)
  282901:	30 06                	xor    %al,(%esi)
  282903:	18 06                	sbb    %al,(%esi)
  282905:	18 06                	sbb    %al,(%esi)
  282907:	0e                   	push   %cs
  282908:	fe 0f                	decb   (%edi)
  28290a:	fe 03                	incb   (%ebx)
	...
  282918:	00 00                	add    %al,(%eax)
  28291a:	fc                   	cld    
  28291b:	3f                   	aas    
  28291c:	fc                   	cld    
  28291d:	3f                   	aas    
  28291e:	0c 00                	or     $0x0,%al
  282920:	0c 00                	or     $0x0,%al
  282922:	0c 00                	or     $0x0,%al
  282924:	0c 00                	or     $0x0,%al
  282926:	0c 00                	or     $0x0,%al
  282928:	fc                   	cld    
  282929:	1f                   	pop    %ds
  28292a:	fc                   	cld    
  28292b:	1f                   	pop    %ds
  28292c:	0c 00                	or     $0x0,%al
  28292e:	0c 00                	or     $0x0,%al
  282930:	0c 00                	or     $0x0,%al
  282932:	0c 00                	or     $0x0,%al
  282934:	0c 00                	or     $0x0,%al
  282936:	0c 00                	or     $0x0,%al
  282938:	fc                   	cld    
  282939:	3f                   	aas    
  28293a:	fc                   	cld    
  28293b:	3f                   	aas    
	...
  282948:	00 00                	add    %al,(%eax)
  28294a:	f8                   	clc    
  28294b:	3f                   	aas    
  28294c:	f8                   	clc    
  28294d:	3f                   	aas    
  28294e:	18 00                	sbb    %al,(%eax)
  282950:	18 00                	sbb    %al,(%eax)
  282952:	18 00                	sbb    %al,(%eax)
  282954:	18 00                	sbb    %al,(%eax)
  282956:	18 00                	sbb    %al,(%eax)
  282958:	f8                   	clc    
  282959:	1f                   	pop    %ds
  28295a:	f8                   	clc    
  28295b:	1f                   	pop    %ds
  28295c:	18 00                	sbb    %al,(%eax)
  28295e:	18 00                	sbb    %al,(%eax)
  282960:	18 00                	sbb    %al,(%eax)
  282962:	18 00                	sbb    %al,(%eax)
  282964:	18 00                	sbb    %al,(%eax)
  282966:	18 00                	sbb    %al,(%eax)
  282968:	18 00                	sbb    %al,(%eax)
  28296a:	18 00                	sbb    %al,(%eax)
	...
  282978:	00 00                	add    %al,(%eax)
  28297a:	e0 0f                	loopne 28298b <ASCII_Table+0x763>
  28297c:	f8                   	clc    
  28297d:	3f                   	aas    
  28297e:	3c 78                	cmp    $0x78,%al
  282980:	0e                   	push   %cs
  282981:	60                   	pusha  
  282982:	06                   	push   %es
  282983:	e0 07                	loopne 28298c <ASCII_Table+0x764>
  282985:	c0 03 00             	rolb   $0x0,(%ebx)
  282988:	03 00                	add    (%eax),%eax
  28298a:	03 fe                	add    %esi,%edi
  28298c:	03 fe                	add    %esi,%edi
  28298e:	03 c0                	add    %eax,%eax
  282990:	07                   	pop    %es
  282991:	c0 06 c0             	rolb   $0xc0,(%esi)
  282994:	0e                   	push   %cs
  282995:	c0 3c f0 f8          	sarb   $0xf8,(%eax,%esi,8)
  282999:	3f                   	aas    
  28299a:	e0 0f                	loopne 2829ab <ASCII_Table+0x783>
	...
  2829a8:	00 00                	add    %al,(%eax)
  2829aa:	0c 30                	or     $0x30,%al
  2829ac:	0c 30                	or     $0x30,%al
  2829ae:	0c 30                	or     $0x30,%al
  2829b0:	0c 30                	or     $0x30,%al
  2829b2:	0c 30                	or     $0x30,%al
  2829b4:	0c 30                	or     $0x30,%al
  2829b6:	0c 30                	or     $0x30,%al
  2829b8:	fc                   	cld    
  2829b9:	3f                   	aas    
  2829ba:	fc                   	cld    
  2829bb:	3f                   	aas    
  2829bc:	0c 30                	or     $0x30,%al
  2829be:	0c 30                	or     $0x30,%al
  2829c0:	0c 30                	or     $0x30,%al
  2829c2:	0c 30                	or     $0x30,%al
  2829c4:	0c 30                	or     $0x30,%al
  2829c6:	0c 30                	or     $0x30,%al
  2829c8:	0c 30                	or     $0x30,%al
  2829ca:	0c 30                	or     $0x30,%al
	...
  2829d8:	00 00                	add    %al,(%eax)
  2829da:	80 01 80             	addb   $0x80,(%ecx)
  2829dd:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2829e3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2829e9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2829ef:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2829f5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2829fb:	01 00                	add    %eax,(%eax)
	...
  282a09:	00 00                	add    %al,(%eax)
  282a0b:	06                   	push   %es
  282a0c:	00 06                	add    %al,(%esi)
  282a0e:	00 06                	add    %al,(%esi)
  282a10:	00 06                	add    %al,(%esi)
  282a12:	00 06                	add    %al,(%esi)
  282a14:	00 06                	add    %al,(%esi)
  282a16:	00 06                	add    %al,(%esi)
  282a18:	00 06                	add    %al,(%esi)
  282a1a:	00 06                	add    %al,(%esi)
  282a1c:	00 06                	add    %al,(%esi)
  282a1e:	00 06                	add    %al,(%esi)
  282a20:	00 06                	add    %al,(%esi)
  282a22:	18 06                	sbb    %al,(%esi)
  282a24:	18 06                	sbb    %al,(%esi)
  282a26:	38 07                	cmp    %al,(%edi)
  282a28:	f0 03 e0             	lock add %eax,%esp
  282a2b:	01 00                	add    %eax,(%eax)
	...
  282a39:	00 06                	add    %al,(%esi)
  282a3b:	30 06                	xor    %al,(%esi)
  282a3d:	18 06                	sbb    %al,(%esi)
  282a3f:	0c 06                	or     $0x6,%al
  282a41:	06                   	push   %es
  282a42:	06                   	push   %es
  282a43:	03 86 01 c6 00 66    	add    0x6600c601(%esi),%eax
  282a49:	00 76 00             	add    %dh,0x0(%esi)
  282a4c:	de 00                	fiadd  (%eax)
  282a4e:	8e 01                	mov    (%ecx),%es
  282a50:	06                   	push   %es
  282a51:	03 06                	add    (%esi),%eax
  282a53:	06                   	push   %es
  282a54:	06                   	push   %es
  282a55:	0c 06                	or     $0x6,%al
  282a57:	18 06                	sbb    %al,(%esi)
  282a59:	30 06                	xor    %al,(%esi)
  282a5b:	60                   	pusha  
	...
  282a68:	00 00                	add    %al,(%eax)
  282a6a:	18 00                	sbb    %al,(%eax)
  282a6c:	18 00                	sbb    %al,(%eax)
  282a6e:	18 00                	sbb    %al,(%eax)
  282a70:	18 00                	sbb    %al,(%eax)
  282a72:	18 00                	sbb    %al,(%eax)
  282a74:	18 00                	sbb    %al,(%eax)
  282a76:	18 00                	sbb    %al,(%eax)
  282a78:	18 00                	sbb    %al,(%eax)
  282a7a:	18 00                	sbb    %al,(%eax)
  282a7c:	18 00                	sbb    %al,(%eax)
  282a7e:	18 00                	sbb    %al,(%eax)
  282a80:	18 00                	sbb    %al,(%eax)
  282a82:	18 00                	sbb    %al,(%eax)
  282a84:	18 00                	sbb    %al,(%eax)
  282a86:	18 00                	sbb    %al,(%eax)
  282a88:	f8                   	clc    
  282a89:	1f                   	pop    %ds
  282a8a:	f8                   	clc    
  282a8b:	1f                   	pop    %ds
	...
  282a98:	00 00                	add    %al,(%eax)
  282a9a:	0e                   	push   %cs
  282a9b:	e0 1e                	loopne 282abb <ASCII_Table+0x893>
  282a9d:	f0 1e                	lock push %ds
  282a9f:	f0 1e                	lock push %ds
  282aa1:	f0 36 d8 36          	lock fdivs %ss:(%esi)
  282aa5:	d8 36                	fdivs  (%esi)
  282aa7:	d8 36                	fdivs  (%esi)
  282aa9:	d8 66 cc             	fsubs  -0x34(%esi)
  282aac:	66                   	data16
  282aad:	cc                   	int3   
  282aae:	66                   	data16
  282aaf:	cc                   	int3   
  282ab0:	c6 c6 c6             	mov    $0xc6,%dh
  282ab3:	c6 c6 c6             	mov    $0xc6,%dh
  282ab6:	c6 c6 86             	mov    $0x86,%dh
  282ab9:	c3                   	ret    
  282aba:	86 c3                	xchg   %al,%bl
	...
  282ac8:	00 00                	add    %al,(%eax)
  282aca:	0c 30                	or     $0x30,%al
  282acc:	1c 30                	sbb    $0x30,%al
  282ace:	3c 30                	cmp    $0x30,%al
  282ad0:	3c 30                	cmp    $0x30,%al
  282ad2:	6c                   	insb   (%dx),%es:(%edi)
  282ad3:	30 6c 30 cc          	xor    %ch,-0x34(%eax,%esi,1)
  282ad7:	30 cc                	xor    %cl,%ah
  282ad9:	30 8c 31 0c 33 0c 33 	xor    %cl,0x330c330c(%ecx,%esi,1)
  282ae0:	0c 36                	or     $0x36,%al
  282ae2:	0c 36                	or     $0x36,%al
  282ae4:	0c 3c                	or     $0x3c,%al
  282ae6:	0c 3c                	or     $0x3c,%al
  282ae8:	0c 38                	or     $0x38,%al
  282aea:	0c 30                	or     $0x30,%al
	...
  282af8:	00 00                	add    %al,(%eax)
  282afa:	e0 07                	loopne 282b03 <ASCII_Table+0x8db>
  282afc:	f8                   	clc    
  282afd:	1f                   	pop    %ds
  282afe:	1c 38                	sbb    $0x38,%al
  282b00:	0e                   	push   %cs
  282b01:	70 06                	jo     282b09 <ASCII_Table+0x8e1>
  282b03:	60                   	pusha  
  282b04:	03 c0                	add    %eax,%eax
  282b06:	03 c0                	add    %eax,%eax
  282b08:	03 c0                	add    %eax,%eax
  282b0a:	03 c0                	add    %eax,%eax
  282b0c:	03 c0                	add    %eax,%eax
  282b0e:	03 c0                	add    %eax,%eax
  282b10:	03 c0                	add    %eax,%eax
  282b12:	06                   	push   %es
  282b13:	60                   	pusha  
  282b14:	0e                   	push   %cs
  282b15:	70 1c                	jo     282b33 <ASCII_Table+0x90b>
  282b17:	38 f8                	cmp    %bh,%al
  282b19:	1f                   	pop    %ds
  282b1a:	e0 07                	loopne 282b23 <ASCII_Table+0x8fb>
	...
  282b28:	00 00                	add    %al,(%eax)
  282b2a:	fc                   	cld    
  282b2b:	0f fc 1f             	paddb  (%edi),%mm3
  282b2e:	0c 38                	or     $0x38,%al
  282b30:	0c 30                	or     $0x30,%al
  282b32:	0c 30                	or     $0x30,%al
  282b34:	0c 30                	or     $0x30,%al
  282b36:	0c 30                	or     $0x30,%al
  282b38:	0c 18                	or     $0x18,%al
  282b3a:	fc                   	cld    
  282b3b:	1f                   	pop    %ds
  282b3c:	fc                   	cld    
  282b3d:	07                   	pop    %es
  282b3e:	0c 00                	or     $0x0,%al
  282b40:	0c 00                	or     $0x0,%al
  282b42:	0c 00                	or     $0x0,%al
  282b44:	0c 00                	or     $0x0,%al
  282b46:	0c 00                	or     $0x0,%al
  282b48:	0c 00                	or     $0x0,%al
  282b4a:	0c 00                	or     $0x0,%al
	...
  282b58:	00 00                	add    %al,(%eax)
  282b5a:	e0 07                	loopne 282b63 <ASCII_Table+0x93b>
  282b5c:	f8                   	clc    
  282b5d:	1f                   	pop    %ds
  282b5e:	1c 38                	sbb    $0x38,%al
  282b60:	0e                   	push   %cs
  282b61:	70 06                	jo     282b69 <ASCII_Table+0x941>
  282b63:	60                   	pusha  
  282b64:	03 e0                	add    %eax,%esp
  282b66:	03 c0                	add    %eax,%eax
  282b68:	03 c0                	add    %eax,%eax
  282b6a:	03 c0                	add    %eax,%eax
  282b6c:	03 c0                	add    %eax,%eax
  282b6e:	03 c0                	add    %eax,%eax
  282b70:	07                   	pop    %es
  282b71:	e0 06                	loopne 282b79 <ASCII_Table+0x951>
  282b73:	63 0e                	arpl   %cx,(%esi)
  282b75:	3f                   	aas    
  282b76:	1c 3c                	sbb    $0x3c,%al
  282b78:	f8                   	clc    
  282b79:	3f                   	aas    
  282b7a:	e0 f7                	loopne 282b73 <ASCII_Table+0x94b>
  282b7c:	00 c0                	add    %al,%al
	...
  282b8a:	fe 0f                	decb   (%edi)
  282b8c:	fe                   	(bad)  
  282b8d:	1f                   	pop    %ds
  282b8e:	06                   	push   %es
  282b8f:	38 06                	cmp    %al,(%esi)
  282b91:	30 06                	xor    %al,(%esi)
  282b93:	30 06                	xor    %al,(%esi)
  282b95:	30 06                	xor    %al,(%esi)
  282b97:	38 fe                	cmp    %bh,%dh
  282b99:	1f                   	pop    %ds
  282b9a:	fe 07                	incb   (%edi)
  282b9c:	06                   	push   %es
  282b9d:	03 06                	add    (%esi),%eax
  282b9f:	06                   	push   %es
  282ba0:	06                   	push   %es
  282ba1:	0c 06                	or     $0x6,%al
  282ba3:	18 06                	sbb    %al,(%esi)
  282ba5:	18 06                	sbb    %al,(%esi)
  282ba7:	30 06                	xor    %al,(%esi)
  282ba9:	30 06                	xor    %al,(%esi)
  282bab:	60                   	pusha  
	...
  282bb8:	00 00                	add    %al,(%eax)
  282bba:	e0 03                	loopne 282bbf <ASCII_Table+0x997>
  282bbc:	f8                   	clc    
  282bbd:	0f 1c 0c 0c          	nopl   (%esp,%ecx,1)
  282bc1:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282bc4:	0c 00                	or     $0x0,%al
  282bc6:	1c 00                	sbb    $0x0,%al
  282bc8:	f8                   	clc    
  282bc9:	03 e0                	add    %eax,%esp
  282bcb:	0f 00 1e             	ltr    (%esi)
  282bce:	00 38                	add    %bh,(%eax)
  282bd0:	06                   	push   %es
  282bd1:	30 06                	xor    %al,(%esi)
  282bd3:	30 0e                	xor    %cl,(%esi)
  282bd5:	30 1c 1c             	xor    %bl,(%esp,%ebx,1)
  282bd8:	f8                   	clc    
  282bd9:	0f e0 07             	pavgb  (%edi),%mm0
	...
  282be8:	00 00                	add    %al,(%eax)
  282bea:	fe                   	(bad)  
  282beb:	7f fe                	jg     282beb <ASCII_Table+0x9c3>
  282bed:	7f 80                	jg     282b6f <ASCII_Table+0x947>
  282bef:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282bf5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282bfb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282c01:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282c07:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
	...
  282c19:	00 0c 30             	add    %cl,(%eax,%esi,1)
  282c1c:	0c 30                	or     $0x30,%al
  282c1e:	0c 30                	or     $0x30,%al
  282c20:	0c 30                	or     $0x30,%al
  282c22:	0c 30                	or     $0x30,%al
  282c24:	0c 30                	or     $0x30,%al
  282c26:	0c 30                	or     $0x30,%al
  282c28:	0c 30                	or     $0x30,%al
  282c2a:	0c 30                	or     $0x30,%al
  282c2c:	0c 30                	or     $0x30,%al
  282c2e:	0c 30                	or     $0x30,%al
  282c30:	0c 30                	or     $0x30,%al
  282c32:	0c 30                	or     $0x30,%al
  282c34:	0c 30                	or     $0x30,%al
  282c36:	18 18                	sbb    %bl,(%eax)
  282c38:	f8                   	clc    
  282c39:	1f                   	pop    %ds
  282c3a:	e0 07                	loopne 282c43 <ASCII_Table+0xa1b>
	...
  282c48:	00 00                	add    %al,(%eax)
  282c4a:	03 60 06             	add    0x6(%eax),%esp
  282c4d:	30 06                	xor    %al,(%esi)
  282c4f:	30 06                	xor    %al,(%esi)
  282c51:	30 0c 18             	xor    %cl,(%eax,%ebx,1)
  282c54:	0c 18                	or     $0x18,%al
  282c56:	0c 18                	or     $0x18,%al
  282c58:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282c5b:	0c 38                	or     $0x38,%al
  282c5d:	0e                   	push   %cs
  282c5e:	30 06                	xor    %al,(%esi)
  282c60:	30 06                	xor    %al,(%esi)
  282c62:	70 07                	jo     282c6b <ASCII_Table+0xa43>
  282c64:	60                   	pusha  
  282c65:	03 60 03             	add    0x3(%eax),%esp
  282c68:	c0 01 c0             	rolb   $0xc0,(%ecx)
  282c6b:	01 00                	add    %eax,(%eax)
	...
  282c79:	00 03                	add    %al,(%ebx)
  282c7b:	60                   	pusha  
  282c7c:	c3                   	ret    
  282c7d:	61                   	popa   
  282c7e:	c3                   	ret    
  282c7f:	61                   	popa   
  282c80:	c3                   	ret    
  282c81:	61                   	popa   
  282c82:	66 33 66 33          	xor    0x33(%esi),%sp
  282c86:	66 33 66 33          	xor    0x33(%esi),%sp
  282c8a:	66 33 66 33          	xor    0x33(%esi),%sp
  282c8e:	6c                   	insb   (%dx),%es:(%edi)
  282c8f:	1b 6c 1b 6c          	sbb    0x6c(%ebx,%ebx,1),%ebp
  282c93:	1b 2c 1a             	sbb    (%edx,%ebx,1),%ebp
  282c96:	3c 1e                	cmp    $0x1e,%al
  282c98:	38 0e                	cmp    %cl,(%esi)
  282c9a:	38 0e                	cmp    %cl,(%esi)
	...
  282ca8:	00 00                	add    %al,(%eax)
  282caa:	0f e0 0c 70          	pavgb  (%eax,%esi,2),%mm1
  282cae:	18 30                	sbb    %dh,(%eax)
  282cb0:	30 18                	xor    %bl,(%eax)
  282cb2:	70 0c                	jo     282cc0 <ASCII_Table+0xa98>
  282cb4:	60                   	pusha  
  282cb5:	0e                   	push   %cs
  282cb6:	c0 07 80             	rolb   $0x80,(%edi)
  282cb9:	03 80 03 c0 03 e0    	add    -0x1ffc3ffd(%eax),%eax
  282cbf:	06                   	push   %es
  282cc0:	70 0c                	jo     282cce <ASCII_Table+0xaa6>
  282cc2:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282cc5:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  282cc8:	0e                   	push   %cs
  282cc9:	60                   	pusha  
  282cca:	07                   	pop    %es
  282ccb:	e0 00                	loopne 282ccd <ASCII_Table+0xaa5>
	...
  282cd9:	00 03                	add    %al,(%ebx)
  282cdb:	c0 06 60             	rolb   $0x60,(%esi)
  282cde:	0c 30                	or     $0x30,%al
  282ce0:	1c 38                	sbb    $0x38,%al
  282ce2:	38 18                	cmp    %bl,(%eax)
  282ce4:	30 0c 60             	xor    %cl,(%eax,%eiz,2)
  282ce7:	06                   	push   %es
  282ce8:	e0 07                	loopne 282cf1 <ASCII_Table+0xac9>
  282cea:	c0 03 80             	rolb   $0x80,(%ebx)
  282ced:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282cf3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282cf9:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  282d07:	00 00                	add    %al,(%eax)
  282d09:	00 fc                	add    %bh,%ah
  282d0b:	7f fc                	jg     282d09 <ASCII_Table+0xae1>
  282d0d:	7f 00                	jg     282d0f <ASCII_Table+0xae7>
  282d0f:	60                   	pusha  
  282d10:	00 30                	add    %dh,(%eax)
  282d12:	00 18                	add    %bl,(%eax)
  282d14:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282d17:	06                   	push   %es
  282d18:	00 03                	add    %al,(%ebx)
  282d1a:	80 01 c0             	addb   $0xc0,(%ecx)
  282d1d:	00 60 00             	add    %ah,0x0(%eax)
  282d20:	30 00                	xor    %al,(%eax)
  282d22:	18 00                	sbb    %al,(%eax)
  282d24:	0c 00                	or     $0x0,%al
  282d26:	06                   	push   %es
  282d27:	00 fe                	add    %bh,%dh
  282d29:	7f fe                	jg     282d29 <ASCII_Table+0xb01>
  282d2b:	7f 00                	jg     282d2d <ASCII_Table+0xb05>
	...
  282d39:	00 e0                	add    %ah,%al
  282d3b:	03 e0                	add    %eax,%esp
  282d3d:	03 60 00             	add    0x0(%eax),%esp
  282d40:	60                   	pusha  
  282d41:	00 60 00             	add    %ah,0x0(%eax)
  282d44:	60                   	pusha  
  282d45:	00 60 00             	add    %ah,0x0(%eax)
  282d48:	60                   	pusha  
  282d49:	00 60 00             	add    %ah,0x0(%eax)
  282d4c:	60                   	pusha  
  282d4d:	00 60 00             	add    %ah,0x0(%eax)
  282d50:	60                   	pusha  
  282d51:	00 60 00             	add    %ah,0x0(%eax)
  282d54:	60                   	pusha  
  282d55:	00 60 00             	add    %ah,0x0(%eax)
  282d58:	60                   	pusha  
  282d59:	00 60 00             	add    %ah,0x0(%eax)
  282d5c:	60                   	pusha  
  282d5d:	00 60 00             	add    %ah,0x0(%eax)
  282d60:	60                   	pusha  
  282d61:	00 e0                	add    %ah,%al
  282d63:	03 e0                	add    %eax,%esp
  282d65:	03 00                	add    (%eax),%eax
  282d67:	00 00                	add    %al,(%eax)
  282d69:	00 30                	add    %dh,(%eax)
  282d6b:	00 30                	add    %dh,(%eax)
  282d6d:	00 60 00             	add    %ah,0x0(%eax)
  282d70:	60                   	pusha  
  282d71:	00 60 00             	add    %ah,0x0(%eax)
  282d74:	c0 00 c0             	rolb   $0xc0,(%eax)
  282d77:	00 c0                	add    %al,%al
  282d79:	00 c0                	add    %al,%al
  282d7b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282d81:	01 00                	add    %eax,(%eax)
  282d83:	03 00                	add    (%eax),%eax
  282d85:	03 00                	add    (%eax),%eax
  282d87:	03 00                	add    (%eax),%eax
  282d89:	06                   	push   %es
  282d8a:	00 06                	add    %al,(%esi)
	...
  282d98:	00 00                	add    %al,(%eax)
  282d9a:	e0 03                	loopne 282d9f <ASCII_Table+0xb77>
  282d9c:	e0 03                	loopne 282da1 <ASCII_Table+0xb79>
  282d9e:	00 03                	add    %al,(%ebx)
  282da0:	00 03                	add    %al,(%ebx)
  282da2:	00 03                	add    %al,(%ebx)
  282da4:	00 03                	add    %al,(%ebx)
  282da6:	00 03                	add    %al,(%ebx)
  282da8:	00 03                	add    %al,(%ebx)
  282daa:	00 03                	add    %al,(%ebx)
  282dac:	00 03                	add    %al,(%ebx)
  282dae:	00 03                	add    %al,(%ebx)
  282db0:	00 03                	add    %al,(%ebx)
  282db2:	00 03                	add    %al,(%ebx)
  282db4:	00 03                	add    %al,(%ebx)
  282db6:	00 03                	add    %al,(%ebx)
  282db8:	00 03                	add    %al,(%ebx)
  282dba:	00 03                	add    %al,(%ebx)
  282dbc:	00 03                	add    %al,(%ebx)
  282dbe:	00 03                	add    %al,(%ebx)
  282dc0:	00 03                	add    %al,(%ebx)
  282dc2:	e0 03                	loopne 282dc7 <ASCII_Table+0xb9f>
  282dc4:	e0 03                	loopne 282dc9 <ASCII_Table+0xba1>
  282dc6:	00 00                	add    %al,(%eax)
  282dc8:	00 00                	add    %al,(%eax)
  282dca:	00 00                	add    %al,(%eax)
  282dcc:	c0 01 c0             	rolb   $0xc0,(%ecx)
  282dcf:	01 60 03             	add    %esp,0x3(%eax)
  282dd2:	60                   	pusha  
  282dd3:	03 60 03             	add    0x3(%eax),%esp
  282dd6:	30 06                	xor    %al,(%esi)
  282dd8:	30 06                	xor    %al,(%esi)
  282dda:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282ddd:	0c 00                	or     $0x0,%al
	...
  282e17:	00 00                	add    %al,(%eax)
  282e19:	00 ff                	add    %bh,%bh
  282e1b:	ff                   	(bad)  
  282e1c:	ff                   	(bad)  
  282e1d:	ff 00                	incl   (%eax)
	...
  282e27:	00 00                	add    %al,(%eax)
  282e29:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282e2c:	0c 00                	or     $0x0,%al
  282e2e:	0c 00                	or     $0x0,%al
  282e30:	0c 00                	or     $0x0,%al
  282e32:	0c 00                	or     $0x0,%al
  282e34:	0c 00                	or     $0x0,%al
	...
  282e62:	00 00                	add    %al,(%eax)
  282e64:	f0 03 f8             	lock add %eax,%edi
  282e67:	07                   	pop    %es
  282e68:	1c 0c                	sbb    $0xc,%al
  282e6a:	0c 0c                	or     $0xc,%al
  282e6c:	00 0f                	add    %cl,(%edi)
  282e6e:	f0 0f f8 0c 0c       	lock psubb (%esp,%ecx,1),%mm1
  282e73:	0c 0c                	or     $0xc,%al
  282e75:	0c 1c                	or     $0x1c,%al
  282e77:	0f f8 0f             	psubb  (%edi),%mm1
  282e7a:	f0 18 00             	lock sbb %al,(%eax)
	...
  282e89:	00 18                	add    %bl,(%eax)
  282e8b:	00 18                	add    %bl,(%eax)
  282e8d:	00 18                	add    %bl,(%eax)
  282e8f:	00 18                	add    %bl,(%eax)
  282e91:	00 18                	add    %bl,(%eax)
  282e93:	00 d8                	add    %bl,%al
  282e95:	03 f8                	add    %eax,%edi
  282e97:	0f 38 0c             	(bad)  
  282e9a:	18 18                	sbb    %bl,(%eax)
  282e9c:	18 18                	sbb    %bl,(%eax)
  282e9e:	18 18                	sbb    %bl,(%eax)
  282ea0:	18 18                	sbb    %bl,(%eax)
  282ea2:	18 18                	sbb    %bl,(%eax)
  282ea4:	18 18                	sbb    %bl,(%eax)
  282ea6:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  282ea9:	0f d8 03             	psubusb (%ebx),%mm0
	...
  282ec4:	c0 03 f0             	rolb   $0xf0,(%ebx)
  282ec7:	07                   	pop    %es
  282ec8:	30 0e                	xor    %cl,(%esi)
  282eca:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282ecd:	00 18                	add    %bl,(%eax)
  282ecf:	00 18                	add    %bl,(%eax)
  282ed1:	00 18                	add    %bl,(%eax)
  282ed3:	00 18                	add    %bl,(%eax)
  282ed5:	0c 30                	or     $0x30,%al
  282ed7:	0e                   	push   %cs
  282ed8:	f0 07                	lock pop %es
  282eda:	c0 03 00             	rolb   $0x0,(%ebx)
	...
  282ee9:	00 00                	add    %al,(%eax)
  282eeb:	18 00                	sbb    %al,(%eax)
  282eed:	18 00                	sbb    %al,(%eax)
  282eef:	18 00                	sbb    %al,(%eax)
  282ef1:	18 00                	sbb    %al,(%eax)
  282ef3:	18 c0                	sbb    %al,%al
  282ef5:	1b f0                	sbb    %eax,%esi
  282ef7:	1f                   	pop    %ds
  282ef8:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282efb:	18 18                	sbb    %bl,(%eax)
  282efd:	18 18                	sbb    %bl,(%eax)
  282eff:	18 18                	sbb    %bl,(%eax)
  282f01:	18 18                	sbb    %bl,(%eax)
  282f03:	18 18                	sbb    %bl,(%eax)
  282f05:	18 30                	sbb    %dh,(%eax)
  282f07:	1c f0                	sbb    $0xf0,%al
  282f09:	1f                   	pop    %ds
  282f0a:	c0 1b 00             	rcrb   $0x0,(%ebx)
	...
  282f21:	00 00                	add    %al,(%eax)
  282f23:	00 c0                	add    %al,%al
  282f25:	03 f0                	add    %eax,%esi
  282f27:	0f 30                	wrmsr  
  282f29:	0c 18                	or     $0x18,%al
  282f2b:	18 f8                	sbb    %bh,%al
  282f2d:	1f                   	pop    %ds
  282f2e:	f8                   	clc    
  282f2f:	1f                   	pop    %ds
  282f30:	18 00                	sbb    %al,(%eax)
  282f32:	18 00                	sbb    %al,(%eax)
  282f34:	38 18                	cmp    %bl,(%eax)
  282f36:	30 1c f0             	xor    %bl,(%eax,%esi,8)
  282f39:	0f c0 07             	xadd   %al,(%edi)
	...
  282f48:	00 00                	add    %al,(%eax)
  282f4a:	80 0f c0             	orb    $0xc0,(%edi)
  282f4d:	0f c0 00             	xadd   %al,(%eax)
  282f50:	c0 00 c0             	rolb   $0xc0,(%eax)
  282f53:	00 f0                	add    %dh,%al
  282f55:	07                   	pop    %es
  282f56:	f0 07                	lock pop %es
  282f58:	c0 00 c0             	rolb   $0xc0,(%eax)
  282f5b:	00 c0                	add    %al,%al
  282f5d:	00 c0                	add    %al,%al
  282f5f:	00 c0                	add    %al,%al
  282f61:	00 c0                	add    %al,%al
  282f63:	00 c0                	add    %al,%al
  282f65:	00 c0                	add    %al,%al
  282f67:	00 c0                	add    %al,%al
  282f69:	00 c0                	add    %al,%al
	...
  282f83:	00 e0                	add    %ah,%al
  282f85:	0d f8 0f 18 0e       	or     $0xe180ff8,%eax
  282f8a:	0c 0c                	or     $0xc,%al
  282f8c:	0c 0c                	or     $0xc,%al
  282f8e:	0c 0c                	or     $0xc,%al
  282f90:	0c 0c                	or     $0xc,%al
  282f92:	0c 0c                	or     $0xc,%al
  282f94:	0c 0c                	or     $0xc,%al
  282f96:	18 0e                	sbb    %cl,(%esi)
  282f98:	f8                   	clc    
  282f99:	0f e0 0d 00 0c 0c 0c 	pavgb  0xc0c0c00,%mm1
  282fa0:	1c 06                	sbb    $0x6,%al
  282fa2:	f8                   	clc    
  282fa3:	07                   	pop    %es
  282fa4:	f0 01 00             	lock add %eax,(%eax)
  282fa7:	00 00                	add    %al,(%eax)
  282fa9:	00 18                	add    %bl,(%eax)
  282fab:	00 18                	add    %bl,(%eax)
  282fad:	00 18                	add    %bl,(%eax)
  282faf:	00 18                	add    %bl,(%eax)
  282fb1:	00 18                	add    %bl,(%eax)
  282fb3:	00 d8                	add    %bl,%al
  282fb5:	07                   	pop    %es
  282fb6:	f8                   	clc    
  282fb7:	0f 38 1c 18          	pabsb  (%eax),%mm3
  282fbb:	18 18                	sbb    %bl,(%eax)
  282fbd:	18 18                	sbb    %bl,(%eax)
  282fbf:	18 18                	sbb    %bl,(%eax)
  282fc1:	18 18                	sbb    %bl,(%eax)
  282fc3:	18 18                	sbb    %bl,(%eax)
  282fc5:	18 18                	sbb    %bl,(%eax)
  282fc7:	18 18                	sbb    %bl,(%eax)
  282fc9:	18 18                	sbb    %bl,(%eax)
  282fcb:	18 00                	sbb    %al,(%eax)
	...
  282fd9:	00 c0                	add    %al,%al
  282fdb:	00 c0                	add    %al,%al
  282fdd:	00 00                	add    %al,(%eax)
  282fdf:	00 00                	add    %al,(%eax)
  282fe1:	00 00                	add    %al,(%eax)
  282fe3:	00 c0                	add    %al,%al
  282fe5:	00 c0                	add    %al,%al
  282fe7:	00 c0                	add    %al,%al
  282fe9:	00 c0                	add    %al,%al
  282feb:	00 c0                	add    %al,%al
  282fed:	00 c0                	add    %al,%al
  282fef:	00 c0                	add    %al,%al
  282ff1:	00 c0                	add    %al,%al
  282ff3:	00 c0                	add    %al,%al
  282ff5:	00 c0                	add    %al,%al
  282ff7:	00 c0                	add    %al,%al
  282ff9:	00 c0                	add    %al,%al
	...
  283007:	00 00                	add    %al,(%eax)
  283009:	00 c0                	add    %al,%al
  28300b:	00 c0                	add    %al,%al
  28300d:	00 00                	add    %al,(%eax)
  28300f:	00 00                	add    %al,(%eax)
  283011:	00 00                	add    %al,(%eax)
  283013:	00 c0                	add    %al,%al
  283015:	00 c0                	add    %al,%al
  283017:	00 c0                	add    %al,%al
  283019:	00 c0                	add    %al,%al
  28301b:	00 c0                	add    %al,%al
  28301d:	00 c0                	add    %al,%al
  28301f:	00 c0                	add    %al,%al
  283021:	00 c0                	add    %al,%al
  283023:	00 c0                	add    %al,%al
  283025:	00 c0                	add    %al,%al
  283027:	00 c0                	add    %al,%al
  283029:	00 c0                	add    %al,%al
  28302b:	00 c0                	add    %al,%al
  28302d:	00 c0                	add    %al,%al
  28302f:	00 c0                	add    %al,%al
  283031:	00 f8                	add    %bh,%al
  283033:	00 78 00             	add    %bh,0x0(%eax)
  283036:	00 00                	add    %al,(%eax)
  283038:	00 00                	add    %al,(%eax)
  28303a:	0c 00                	or     $0x0,%al
  28303c:	0c 00                	or     $0x0,%al
  28303e:	0c 00                	or     $0x0,%al
  283040:	0c 00                	or     $0x0,%al
  283042:	0c 00                	or     $0x0,%al
  283044:	0c 0c                	or     $0xc,%al
  283046:	0c 06                	or     $0x6,%al
  283048:	0c 03                	or     $0x3,%al
  28304a:	8c 01                	mov    %es,(%ecx)
  28304c:	cc                   	int3   
  28304d:	00 6c 00 fc          	add    %ch,-0x4(%eax,%eax,1)
  283051:	00 9c 01 8c 03 0c 03 	add    %bl,0x30c038c(%ecx,%eax,1)
  283058:	0c 06                	or     $0x6,%al
  28305a:	0c 0c                	or     $0xc,%al
	...
  283068:	00 00                	add    %al,(%eax)
  28306a:	c0 00 c0             	rolb   $0xc0,(%eax)
  28306d:	00 c0                	add    %al,%al
  28306f:	00 c0                	add    %al,%al
  283071:	00 c0                	add    %al,%al
  283073:	00 c0                	add    %al,%al
  283075:	00 c0                	add    %al,%al
  283077:	00 c0                	add    %al,%al
  283079:	00 c0                	add    %al,%al
  28307b:	00 c0                	add    %al,%al
  28307d:	00 c0                	add    %al,%al
  28307f:	00 c0                	add    %al,%al
  283081:	00 c0                	add    %al,%al
  283083:	00 c0                	add    %al,%al
  283085:	00 c0                	add    %al,%al
  283087:	00 c0                	add    %al,%al
  283089:	00 c0                	add    %al,%al
	...
  2830a3:	00 7c 3c ff          	add    %bh,-0x1(%esp,%edi,1)
  2830a7:	7e c7                	jle    283070 <ASCII_Table+0xe48>
  2830a9:	e3 83                	jecxz  28302e <ASCII_Table+0xe06>
  2830ab:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
  2830b2:	83 c1 83             	add    $0xffffff83,%ecx
  2830b5:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
	...
  2830d4:	98                   	cwtl   
  2830d5:	07                   	pop    %es
  2830d6:	f8                   	clc    
  2830d7:	0f 38 1c 18          	pabsb  (%eax),%mm3
  2830db:	18 18                	sbb    %bl,(%eax)
  2830dd:	18 18                	sbb    %bl,(%eax)
  2830df:	18 18                	sbb    %bl,(%eax)
  2830e1:	18 18                	sbb    %bl,(%eax)
  2830e3:	18 18                	sbb    %bl,(%eax)
  2830e5:	18 18                	sbb    %bl,(%eax)
  2830e7:	18 18                	sbb    %bl,(%eax)
  2830e9:	18 18                	sbb    %bl,(%eax)
  2830eb:	18 00                	sbb    %al,(%eax)
	...
  283101:	00 00                	add    %al,(%eax)
  283103:	00 c0                	add    %al,%al
  283105:	03 f0                	add    %eax,%esi
  283107:	0f 30                	wrmsr  
  283109:	0c 18                	or     $0x18,%al
  28310b:	18 18                	sbb    %bl,(%eax)
  28310d:	18 18                	sbb    %bl,(%eax)
  28310f:	18 18                	sbb    %bl,(%eax)
  283111:	18 18                	sbb    %bl,(%eax)
  283113:	18 18                	sbb    %bl,(%eax)
  283115:	18 30                	sbb    %dh,(%eax)
  283117:	0c f0                	or     $0xf0,%al
  283119:	0f c0 03             	xadd   %al,(%ebx)
	...
  283134:	d8 03                	fadds  (%ebx)
  283136:	f8                   	clc    
  283137:	0f 38 0c             	(bad)  
  28313a:	18 18                	sbb    %bl,(%eax)
  28313c:	18 18                	sbb    %bl,(%eax)
  28313e:	18 18                	sbb    %bl,(%eax)
  283140:	18 18                	sbb    %bl,(%eax)
  283142:	18 18                	sbb    %bl,(%eax)
  283144:	18 18                	sbb    %bl,(%eax)
  283146:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  283149:	0f d8 03             	psubusb (%ebx),%mm0
  28314c:	18 00                	sbb    %al,(%eax)
  28314e:	18 00                	sbb    %al,(%eax)
  283150:	18 00                	sbb    %al,(%eax)
  283152:	18 00                	sbb    %al,(%eax)
  283154:	18 00                	sbb    %al,(%eax)
	...
  283162:	00 00                	add    %al,(%eax)
  283164:	c0 1b f0             	rcrb   $0xf0,(%ebx)
  283167:	1f                   	pop    %ds
  283168:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  28316b:	18 18                	sbb    %bl,(%eax)
  28316d:	18 18                	sbb    %bl,(%eax)
  28316f:	18 18                	sbb    %bl,(%eax)
  283171:	18 18                	sbb    %bl,(%eax)
  283173:	18 18                	sbb    %bl,(%eax)
  283175:	18 30                	sbb    %dh,(%eax)
  283177:	1c f0                	sbb    $0xf0,%al
  283179:	1f                   	pop    %ds
  28317a:	c0 1b 00             	rcrb   $0x0,(%ebx)
  28317d:	18 00                	sbb    %al,(%eax)
  28317f:	18 00                	sbb    %al,(%eax)
  283181:	18 00                	sbb    %al,(%eax)
  283183:	18 00                	sbb    %al,(%eax)
  283185:	18 00                	sbb    %al,(%eax)
	...
  283193:	00 b0 07 f0 03 70    	add    %dh,0x7003f007(%eax)
  283199:	00 30                	add    %dh,(%eax)
  28319b:	00 30                	add    %dh,(%eax)
  28319d:	00 30                	add    %dh,(%eax)
  28319f:	00 30                	add    %dh,(%eax)
  2831a1:	00 30                	add    %dh,(%eax)
  2831a3:	00 30                	add    %dh,(%eax)
  2831a5:	00 30                	add    %dh,(%eax)
  2831a7:	00 30                	add    %dh,(%eax)
  2831a9:	00 30                	add    %dh,(%eax)
	...
  2831c3:	00 e0                	add    %ah,%al
  2831c5:	03 f0                	add    %eax,%esi
  2831c7:	03 38                	add    (%eax),%edi
  2831c9:	0e                   	push   %cs
  2831ca:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  2831cd:	00 f0                	add    %dh,%al
  2831cf:	03 c0                	add    %eax,%eax
  2831d1:	07                   	pop    %es
  2831d2:	00 0c 18             	add    %cl,(%eax,%ebx,1)
  2831d5:	0c 38                	or     $0x38,%al
  2831d7:	0e                   	push   %cs
  2831d8:	f0 07                	lock pop %es
  2831da:	e0 03                	loopne 2831df <ASCII_Table+0xfb7>
	...
  2831ec:	80 00 c0             	addb   $0xc0,(%eax)
  2831ef:	00 c0                	add    %al,%al
  2831f1:	00 c0                	add    %al,%al
  2831f3:	00 f0                	add    %dh,%al
  2831f5:	07                   	pop    %es
  2831f6:	f0 07                	lock pop %es
  2831f8:	c0 00 c0             	rolb   $0xc0,(%eax)
  2831fb:	00 c0                	add    %al,%al
  2831fd:	00 c0                	add    %al,%al
  2831ff:	00 c0                	add    %al,%al
  283201:	00 c0                	add    %al,%al
  283203:	00 c0                	add    %al,%al
  283205:	00 c0                	add    %al,%al
  283207:	00 c0                	add    %al,%al
  283209:	07                   	pop    %es
  28320a:	80 07 00             	addb   $0x0,(%edi)
	...
  283221:	00 00                	add    %al,(%eax)
  283223:	00 18                	add    %bl,(%eax)
  283225:	18 18                	sbb    %bl,(%eax)
  283227:	18 18                	sbb    %bl,(%eax)
  283229:	18 18                	sbb    %bl,(%eax)
  28322b:	18 18                	sbb    %bl,(%eax)
  28322d:	18 18                	sbb    %bl,(%eax)
  28322f:	18 18                	sbb    %bl,(%eax)
  283231:	18 18                	sbb    %bl,(%eax)
  283233:	18 18                	sbb    %bl,(%eax)
  283235:	18 38                	sbb    %bh,(%eax)
  283237:	1c f0                	sbb    $0xf0,%al
  283239:	1f                   	pop    %ds
  28323a:	e0 19                	loopne 283255 <ASCII_Table+0x102d>
	...
  283254:	0c 18                	or     $0x18,%al
  283256:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  283259:	0c 18                	or     $0x18,%al
  28325b:	0c 30                	or     $0x30,%al
  28325d:	06                   	push   %es
  28325e:	30 06                	xor    %al,(%esi)
  283260:	30 06                	xor    %al,(%esi)
  283262:	60                   	pusha  
  283263:	03 60 03             	add    0x3(%eax),%esp
  283266:	60                   	pusha  
  283267:	03 c0                	add    %eax,%eax
  283269:	01 c0                	add    %eax,%eax
  28326b:	01 00                	add    %eax,(%eax)
	...
  283281:	00 00                	add    %al,(%eax)
  283283:	00 c1                	add    %al,%cl
  283285:	41                   	inc    %ecx
  283286:	c1 41 c3 61          	roll   $0x61,-0x3d(%ecx)
  28328a:	63 63 63             	arpl   %sp,0x63(%ebx)
  28328d:	63 63 63             	arpl   %sp,0x63(%ebx)
  283290:	36                   	ss
  283291:	36                   	ss
  283292:	36                   	ss
  283293:	36                   	ss
  283294:	36                   	ss
  283295:	36                   	ss
  283296:	1c 1c                	sbb    $0x1c,%al
  283298:	1c 1c                	sbb    $0x1c,%al
  28329a:	1c 1c                	sbb    $0x1c,%al
	...
  2832b4:	1c 38                	sbb    $0x38,%al
  2832b6:	38 1c 30             	cmp    %bl,(%eax,%esi,1)
  2832b9:	0c 60                	or     $0x60,%al
  2832bb:	06                   	push   %es
  2832bc:	60                   	pusha  
  2832bd:	03 60 03             	add    0x3(%eax),%esp
  2832c0:	60                   	pusha  
  2832c1:	03 60 03             	add    0x3(%eax),%esp
  2832c4:	60                   	pusha  
  2832c5:	06                   	push   %es
  2832c6:	30 0c 38             	xor    %cl,(%eax,%edi,1)
  2832c9:	1c 1c                	sbb    $0x1c,%al
  2832cb:	38 00                	cmp    %al,(%eax)
	...
  2832e1:	00 00                	add    %al,(%eax)
  2832e3:	00 18                	add    %bl,(%eax)
  2832e5:	30 30                	xor    %dh,(%eax)
  2832e7:	18 30                	sbb    %dh,(%eax)
  2832e9:	18 70 18             	sbb    %dh,0x18(%eax)
  2832ec:	60                   	pusha  
  2832ed:	0c 60                	or     $0x60,%al
  2832ef:	0c e0                	or     $0xe0,%al
  2832f1:	0c c0                	or     $0xc0,%al
  2832f3:	06                   	push   %es
  2832f4:	c0 06 80             	rolb   $0x80,(%esi)
  2832f7:	03 80 03 80 03 80    	add    -0x7ffc7ffd(%eax),%eax
  2832fd:	01 80 01 c0 01 f0    	add    %eax,-0xffe3fff(%eax)
  283303:	00 70 00             	add    %dh,0x0(%eax)
	...
  283312:	00 00                	add    %al,(%eax)
  283314:	fc                   	cld    
  283315:	1f                   	pop    %ds
  283316:	fc                   	cld    
  283317:	1f                   	pop    %ds
  283318:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28331b:	06                   	push   %es
  28331c:	00 03                	add    %al,(%ebx)
  28331e:	80 01 c0             	addb   $0xc0,(%ecx)
  283321:	00 60 00             	add    %ah,0x0(%eax)
  283324:	30 00                	xor    %al,(%eax)
  283326:	18 00                	sbb    %al,(%eax)
  283328:	fc                   	cld    
  283329:	1f                   	pop    %ds
  28332a:	fc                   	cld    
  28332b:	1f                   	pop    %ds
	...
  283338:	00 00                	add    %al,(%eax)
  28333a:	00 03                	add    %al,(%ebx)
  28333c:	80 01 c0             	addb   $0xc0,(%ecx)
  28333f:	00 c0                	add    %al,%al
  283341:	00 c0                	add    %al,%al
  283343:	00 c0                	add    %al,%al
  283345:	00 c0                	add    %al,%al
  283347:	00 c0                	add    %al,%al
  283349:	00 60 00             	add    %ah,0x0(%eax)
  28334c:	60                   	pusha  
  28334d:	00 30                	add    %dh,(%eax)
  28334f:	00 60 00             	add    %ah,0x0(%eax)
  283352:	40                   	inc    %eax
  283353:	00 c0                	add    %al,%al
  283355:	00 c0                	add    %al,%al
  283357:	00 c0                	add    %al,%al
  283359:	00 c0                	add    %al,%al
  28335b:	00 c0                	add    %al,%al
  28335d:	00 c0                	add    %al,%al
  28335f:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  283365:	00 00                	add    %al,(%eax)
  283367:	00 00                	add    %al,(%eax)
  283369:	00 80 01 80 01 80    	add    %al,-0x7ffe7fff(%eax)
  28336f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  283375:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28337b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  283381:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  283387:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28338d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  283393:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
  283399:	00 60 00             	add    %ah,0x0(%eax)
  28339c:	c0 00 c0             	rolb   $0xc0,(%eax)
  28339f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2833a5:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  2833ab:	03 00                	add    (%eax),%eax
  2833ad:	03 00                	add    (%eax),%eax
  2833af:	06                   	push   %es
  2833b0:	00 03                	add    %al,(%ebx)
  2833b2:	00 01                	add    %al,(%ecx)
  2833b4:	80 01 80             	addb   $0x80,(%ecx)
  2833b7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2833bd:	01 80 01 c0 00 60    	add    %eax,0x6000c001(%eax)
	...
  2833d7:	00 f0                	add    %dh,%al
  2833d9:	10 f8                	adc    %bh,%al
  2833db:	1f                   	pop    %ds
  2833dc:	08 0f                	or     %cl,(%edi)
	...
  2833fa:	00 ff                	add    %bh,%bh
  2833fc:	00 00                	add    %al,(%eax)
  2833fe:	00 ff                	add    %bh,%bh
  283400:	00 ff                	add    %bh,%bh
  283402:	ff 00                	incl   (%eax)
  283404:	00 00                	add    %al,(%eax)
  283406:	ff                   	(bad)  
  283407:	ff 00                	incl   (%eax)
  283409:	ff 00                	incl   (%eax)
  28340b:	ff                   	(bad)  
  28340c:	ff                   	(bad)  
  28340d:	ff                   	(bad)  
  28340e:	ff                   	(bad)  
  28340f:	ff c6                	inc    %esi
  283411:	c6 c6 84             	mov    $0x84,%dh
  283414:	00 00                	add    %al,(%eax)
  283416:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
  28341d:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
  283424:	84 84 84 84 4f 4f 4f 	test   %al,0x4f4f4f84(%esp,%eax,4)

00283428 <closebtn.1457>:
  283428:	4f                   	dec    %edi
  283429:	4f                   	dec    %edi
  28342a:	4f                   	dec    %edi
  28342b:	4f                   	dec    %edi
  28342c:	4f                   	dec    %edi
  28342d:	4f                   	dec    %edi
  28342e:	4f                   	dec    %edi
  28342f:	4f                   	dec    %edi
  283430:	4f                   	dec    %edi
  283431:	4f                   	dec    %edi
  283432:	4f                   	dec    %edi
  283433:	4f                   	dec    %edi
  283434:	4f                   	dec    %edi
  283435:	4f                   	dec    %edi
  283436:	4f                   	dec    %edi
  283437:	40                   	inc    %eax
  283438:	4f                   	dec    %edi
  283439:	51                   	push   %ecx
  28343a:	51                   	push   %ecx
  28343b:	51                   	push   %ecx
  28343c:	51                   	push   %ecx
  28343d:	51                   	push   %ecx
  28343e:	51                   	push   %ecx
  28343f:	51                   	push   %ecx
  283440:	51                   	push   %ecx
  283441:	51                   	push   %ecx
  283442:	51                   	push   %ecx
  283443:	51                   	push   %ecx
  283444:	51                   	push   %ecx
  283445:	51                   	push   %ecx
  283446:	24 40                	and    $0x40,%al
  283448:	4f                   	dec    %edi
  283449:	51                   	push   %ecx
  28344a:	51                   	push   %ecx
  28344b:	51                   	push   %ecx
  28344c:	51                   	push   %ecx
  28344d:	51                   	push   %ecx
  28344e:	51                   	push   %ecx
  28344f:	51                   	push   %ecx
  283450:	51                   	push   %ecx
  283451:	51                   	push   %ecx
  283452:	51                   	push   %ecx
  283453:	51                   	push   %ecx
  283454:	51                   	push   %ecx
  283455:	51                   	push   %ecx
  283456:	24 40                	and    $0x40,%al
  283458:	4f                   	dec    %edi
  283459:	51                   	push   %ecx
  28345a:	51                   	push   %ecx
  28345b:	51                   	push   %ecx
  28345c:	40                   	inc    %eax
  28345d:	40                   	inc    %eax
  28345e:	51                   	push   %ecx
  28345f:	51                   	push   %ecx
  283460:	51                   	push   %ecx
  283461:	51                   	push   %ecx
  283462:	40                   	inc    %eax
  283463:	40                   	inc    %eax
  283464:	51                   	push   %ecx
  283465:	51                   	push   %ecx
  283466:	24 40                	and    $0x40,%al
  283468:	4f                   	dec    %edi
  283469:	51                   	push   %ecx
  28346a:	51                   	push   %ecx
  28346b:	51                   	push   %ecx
  28346c:	51                   	push   %ecx
  28346d:	40                   	inc    %eax
  28346e:	40                   	inc    %eax
  28346f:	51                   	push   %ecx
  283470:	51                   	push   %ecx
  283471:	40                   	inc    %eax
  283472:	40                   	inc    %eax
  283473:	51                   	push   %ecx
  283474:	51                   	push   %ecx
  283475:	51                   	push   %ecx
  283476:	24 40                	and    $0x40,%al
  283478:	4f                   	dec    %edi
  283479:	51                   	push   %ecx
  28347a:	51                   	push   %ecx
  28347b:	51                   	push   %ecx
  28347c:	51                   	push   %ecx
  28347d:	51                   	push   %ecx
  28347e:	40                   	inc    %eax
  28347f:	40                   	inc    %eax
  283480:	40                   	inc    %eax
  283481:	40                   	inc    %eax
  283482:	51                   	push   %ecx
  283483:	51                   	push   %ecx
  283484:	51                   	push   %ecx
  283485:	51                   	push   %ecx
  283486:	24 40                	and    $0x40,%al
  283488:	4f                   	dec    %edi
  283489:	51                   	push   %ecx
  28348a:	51                   	push   %ecx
  28348b:	51                   	push   %ecx
  28348c:	51                   	push   %ecx
  28348d:	51                   	push   %ecx
  28348e:	51                   	push   %ecx
  28348f:	40                   	inc    %eax
  283490:	40                   	inc    %eax
  283491:	51                   	push   %ecx
  283492:	51                   	push   %ecx
  283493:	51                   	push   %ecx
  283494:	51                   	push   %ecx
  283495:	51                   	push   %ecx
  283496:	24 40                	and    $0x40,%al
  283498:	4f                   	dec    %edi
  283499:	51                   	push   %ecx
  28349a:	51                   	push   %ecx
  28349b:	51                   	push   %ecx
  28349c:	51                   	push   %ecx
  28349d:	51                   	push   %ecx
  28349e:	40                   	inc    %eax
  28349f:	40                   	inc    %eax
  2834a0:	40                   	inc    %eax
  2834a1:	40                   	inc    %eax
  2834a2:	51                   	push   %ecx
  2834a3:	51                   	push   %ecx
  2834a4:	51                   	push   %ecx
  2834a5:	51                   	push   %ecx
  2834a6:	24 40                	and    $0x40,%al
  2834a8:	4f                   	dec    %edi
  2834a9:	51                   	push   %ecx
  2834aa:	51                   	push   %ecx
  2834ab:	51                   	push   %ecx
  2834ac:	51                   	push   %ecx
  2834ad:	40                   	inc    %eax
  2834ae:	40                   	inc    %eax
  2834af:	51                   	push   %ecx
  2834b0:	51                   	push   %ecx
  2834b1:	40                   	inc    %eax
  2834b2:	40                   	inc    %eax
  2834b3:	51                   	push   %ecx
  2834b4:	51                   	push   %ecx
  2834b5:	51                   	push   %ecx
  2834b6:	24 40                	and    $0x40,%al
  2834b8:	4f                   	dec    %edi
  2834b9:	51                   	push   %ecx
  2834ba:	51                   	push   %ecx
  2834bb:	51                   	push   %ecx
  2834bc:	40                   	inc    %eax
  2834bd:	40                   	inc    %eax
  2834be:	51                   	push   %ecx
  2834bf:	51                   	push   %ecx
  2834c0:	51                   	push   %ecx
  2834c1:	51                   	push   %ecx
  2834c2:	40                   	inc    %eax
  2834c3:	40                   	inc    %eax
  2834c4:	51                   	push   %ecx
  2834c5:	51                   	push   %ecx
  2834c6:	24 40                	and    $0x40,%al
  2834c8:	4f                   	dec    %edi
  2834c9:	51                   	push   %ecx
  2834ca:	51                   	push   %ecx
  2834cb:	51                   	push   %ecx
  2834cc:	51                   	push   %ecx
  2834cd:	51                   	push   %ecx
  2834ce:	51                   	push   %ecx
  2834cf:	51                   	push   %ecx
  2834d0:	51                   	push   %ecx
  2834d1:	51                   	push   %ecx
  2834d2:	51                   	push   %ecx
  2834d3:	51                   	push   %ecx
  2834d4:	51                   	push   %ecx
  2834d5:	51                   	push   %ecx
  2834d6:	24 40                	and    $0x40,%al
  2834d8:	4f                   	dec    %edi
  2834d9:	51                   	push   %ecx
  2834da:	51                   	push   %ecx
  2834db:	51                   	push   %ecx
  2834dc:	51                   	push   %ecx
  2834dd:	51                   	push   %ecx
  2834de:	51                   	push   %ecx
  2834df:	51                   	push   %ecx
  2834e0:	51                   	push   %ecx
  2834e1:	51                   	push   %ecx
  2834e2:	51                   	push   %ecx
  2834e3:	51                   	push   %ecx
  2834e4:	51                   	push   %ecx
  2834e5:	51                   	push   %ecx
  2834e6:	24 40                	and    $0x40,%al
  2834e8:	4f                   	dec    %edi
  2834e9:	24 24                	and    $0x24,%al
  2834eb:	24 24                	and    $0x24,%al
  2834ed:	24 24                	and    $0x24,%al
  2834ef:	24 24                	and    $0x24,%al
  2834f1:	24 24                	and    $0x24,%al
  2834f3:	24 24                	and    $0x24,%al
  2834f5:	24 24                	and    $0x24,%al
  2834f7:	40                   	inc    %eax
  2834f8:	40                   	inc    %eax
  2834f9:	40                   	inc    %eax
  2834fa:	40                   	inc    %eax
  2834fb:	40                   	inc    %eax
  2834fc:	40                   	inc    %eax
  2834fd:	40                   	inc    %eax
  2834fe:	40                   	inc    %eax
  2834ff:	40                   	inc    %eax
  283500:	40                   	inc    %eax
  283501:	40                   	inc    %eax
  283502:	40                   	inc    %eax
  283503:	40                   	inc    %eax
  283504:	40                   	inc    %eax
  283505:	40                   	inc    %eax
  283506:	40                   	inc    %eax
  283507:	40                   	inc    %eax

00283508 <cursor.1420>:
  283508:	2a 2a                	sub    (%edx),%ch
  28350a:	2a 2a                	sub    (%edx),%ch
  28350c:	2a 2a                	sub    (%edx),%ch
  28350e:	2a 2a                	sub    (%edx),%ch
  283510:	2a 2a                	sub    (%edx),%ch
  283512:	2a 2a                	sub    (%edx),%ch
  283514:	2a 2a                	sub    (%edx),%ch
  283516:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  28351b:	4f                   	dec    %edi
  28351c:	4f                   	dec    %edi
  28351d:	4f                   	dec    %edi
  28351e:	4f                   	dec    %edi
  28351f:	4f                   	dec    %edi
  283520:	4f                   	dec    %edi
  283521:	4f                   	dec    %edi
  283522:	4f                   	dec    %edi
  283523:	4f                   	dec    %edi
  283524:	2a 2e                	sub    (%esi),%ch
  283526:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  28352b:	4f                   	dec    %edi
  28352c:	4f                   	dec    %edi
  28352d:	4f                   	dec    %edi
  28352e:	4f                   	dec    %edi
  28352f:	4f                   	dec    %edi
  283530:	4f                   	dec    %edi
  283531:	4f                   	dec    %edi
  283532:	4f                   	dec    %edi
  283533:	2a 2e                	sub    (%esi),%ch
  283535:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  28353b:	4f                   	dec    %edi
  28353c:	4f                   	dec    %edi
  28353d:	4f                   	dec    %edi
  28353e:	4f                   	dec    %edi
  28353f:	4f                   	dec    %edi
  283540:	4f                   	dec    %edi
  283541:	4f                   	dec    %edi
  283542:	2a 2e                	sub    (%esi),%ch
  283544:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  28354b:	4f                   	dec    %edi
  28354c:	4f                   	dec    %edi
  28354d:	4f                   	dec    %edi
  28354e:	4f                   	dec    %edi
  28354f:	4f                   	dec    %edi
  283550:	4f                   	dec    %edi
  283551:	2a 2e                	sub    (%esi),%ch
  283553:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  28355a:	4f 
  28355b:	4f                   	dec    %edi
  28355c:	4f                   	dec    %edi
  28355d:	4f                   	dec    %edi
  28355e:	4f                   	dec    %edi
  28355f:	4f                   	dec    %edi
  283560:	2a 2e                	sub    (%esi),%ch
  283562:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  283569:	4f 4f 
  28356b:	4f                   	dec    %edi
  28356c:	4f                   	dec    %edi
  28356d:	4f                   	dec    %edi
  28356e:	4f                   	dec    %edi
  28356f:	4f                   	dec    %edi
  283570:	2a 2e                	sub    (%esi),%ch
  283572:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  283579:	4f 4f 
  28357b:	4f                   	dec    %edi
  28357c:	4f                   	dec    %edi
  28357d:	4f                   	dec    %edi
  28357e:	4f                   	dec    %edi
  28357f:	4f                   	dec    %edi
  283580:	4f                   	dec    %edi
  283581:	2a 2e                	sub    (%esi),%ch
  283583:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  28358a:	4f 
  28358b:	4f                   	dec    %edi
  28358c:	4f                   	dec    %edi
  28358d:	2a 2a                	sub    (%edx),%ch
  28358f:	4f                   	dec    %edi
  283590:	4f                   	dec    %edi
  283591:	4f                   	dec    %edi
  283592:	2a 2e                	sub    (%esi),%ch
  283594:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  28359b:	4f                   	dec    %edi
  28359c:	2a 2e                	sub    (%esi),%ch
  28359e:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  2835a2:	4f                   	dec    %edi
  2835a3:	2a 2e                	sub    (%esi),%ch
  2835a5:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  2835ab:	2a 2e                	sub    (%esi),%ch
  2835ad:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  2835b3:	4f                   	dec    %edi
  2835b4:	2a 2e                	sub    (%esi),%ch
  2835b6:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  2835bb:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2835c2:	4f 4f 
  2835c4:	4f                   	dec    %edi
  2835c5:	2a 2e                	sub    (%esi),%ch
  2835c7:	2e 2a 2a             	sub    %cs:(%edx),%ch
  2835ca:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2835d1:	2e 2a 4f 4f 
  2835d5:	4f                   	dec    %edi
  2835d6:	2a 2e                	sub    (%esi),%ch
  2835d8:	2a 2e                	sub    (%esi),%ch
  2835da:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2835e1:	2e 2e 2a 4f 4f 
  2835e6:	4f                   	dec    %edi
  2835e7:	2a 2e                	sub    (%esi),%ch
  2835e9:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2835f0:	2e 2e 2e 2e 2a 4f 4f 
  2835f7:	2a 2e                	sub    (%esi),%ch
  2835f9:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  283600:	2e 2e 2e 2e 2e 2a 2a 
  283607:	2a                   	.byte 0x2a

Disassembly of section .rodata.str1.1:

00283608 <.rodata.str1.1>:
  283608:	6d                   	insl   (%dx),%es:(%edi)
  283609:	65                   	gs
  28360a:	6d                   	insl   (%dx),%es:(%edi)
  28360b:	6f                   	outsl  %ds:(%esi),(%dx)
  28360c:	72 79                	jb     283687 <cursor.1420+0x17f>
  28360e:	3a 25 64 4d 42 2c    	cmp    0x2c424d64,%ah
  283614:	66                   	data16
  283615:	72 65                	jb     28367c <cursor.1420+0x174>
  283617:	65 3a 25 64 4d 42 2c 	cmp    %gs:0x2c424d64,%ah
  28361e:	25 64 00 62 65       	and    $0x65620064,%eax
  283623:	6c                   	insb   (%dx),%es:(%edi)
  283624:	6f                   	outsl  %ds:(%esi),(%dx)
  283625:	77 20                	ja     283647 <cursor.1420+0x13f>
  283627:	61                   	popa   
  283628:	20 63 6f             	and    %ah,0x6f(%ebx)
  28362b:	75 6e                	jne    28369b <cursor.1420+0x193>
  28362d:	74 65                	je     283694 <cursor.1420+0x18c>
  28362f:	72 00                	jb     283631 <cursor.1420+0x129>
  283631:	5b                   	pop    %ebx
  283632:	6c                   	insb   (%dx),%es:(%edi)
  283633:	6d                   	insl   (%dx),%es:(%edi)
  283634:	72 3a                	jb     283670 <cursor.1420+0x168>
  283636:	25 64 20 25 64       	and    $0x64252064,%eax
  28363b:	5d                   	pop    %ebp
  28363c:	00 28                	add    %ch,(%eax)
  28363e:	25 64 2c 20 25       	and    $0x25202c64,%eax
  283643:	64 29 00             	sub    %eax,%fs:(%eax)
  283646:	44                   	inc    %esp
  283647:	65 62 75 67          	bound  %esi,%gs:0x67(%ebp)
  28364b:	3a 76 61             	cmp    0x61(%esi),%dh
  28364e:	72 3d                	jb     28368d <cursor.1420+0x185>
  283650:	25                   	.byte 0x25
  283651:	78 00                	js     283653 <cursor.1420+0x14b>

Disassembly of section .eh_frame:

00283654 <.eh_frame>:
  283654:	14 00                	adc    $0x0,%al
  283656:	00 00                	add    %al,(%eax)
  283658:	00 00                	add    %al,(%eax)
  28365a:	00 00                	add    %al,(%eax)
  28365c:	01 7a 52             	add    %edi,0x52(%edx)
  28365f:	00 01                	add    %al,(%ecx)
  283661:	7c 08                	jl     28366b <cursor.1420+0x163>
  283663:	01 1b                	add    %ebx,(%ebx)
  283665:	0c 04                	or     $0x4,%al
  283667:	04 88                	add    $0x88,%al
  283669:	01 00                	add    %eax,(%eax)
  28366b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28366e:	00 00                	add    %al,(%eax)
  283670:	1c 00                	sbb    $0x0,%al
  283672:	00 00                	add    %al,(%eax)
  283674:	8c c9                	mov    %cs,%ecx
  283676:	ff                   	(bad)  
  283677:	ff 0e                	decl   (%esi)
  283679:	05 00 00 00 41       	add    $0x41000000,%eax
  28367e:	0e                   	push   %cs
  28367f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283685:	49                   	dec    %ecx
  283686:	87 03                	xchg   %eax,(%ebx)
  283688:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28368b:	05 1c 00 00 00       	add    $0x1c,%eax
  283690:	3c 00                	cmp    $0x0,%al
  283692:	00 00                	add    %al,(%eax)
  283694:	7a ce                	jp     283664 <cursor.1420+0x15c>
  283696:	ff                   	(bad)  
  283697:	ff 17                	call   *(%edi)
  283699:	00 00                	add    %al,(%eax)
  28369b:	00 00                	add    %al,(%eax)
  28369d:	41                   	inc    %ecx
  28369e:	0e                   	push   %cs
  28369f:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2836a5:	4e                   	dec    %esi
  2836a6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2836a9:	04 00                	add    $0x0,%al
  2836ab:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2836ae:	00 00                	add    %al,(%eax)
  2836b0:	5c                   	pop    %esp
  2836b1:	00 00                	add    %al,(%eax)
  2836b3:	00 71 ce             	add    %dh,-0x32(%ecx)
  2836b6:	ff                   	(bad)  
  2836b7:	ff 14 00             	call   *(%eax,%eax,1)
  2836ba:	00 00                	add    %al,(%eax)
  2836bc:	00 41 0e             	add    %al,0xe(%ecx)
  2836bf:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2836c5:	4b                   	dec    %ebx
  2836c6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2836c9:	04 00                	add    $0x0,%al
  2836cb:	00 24 00             	add    %ah,(%eax,%eax,1)
  2836ce:	00 00                	add    %al,(%eax)
  2836d0:	7c 00                	jl     2836d2 <cursor.1420+0x1ca>
  2836d2:	00 00                	add    %al,(%eax)
  2836d4:	65                   	gs
  2836d5:	ce                   	into   
  2836d6:	ff                   	(bad)  
  2836d7:	ff                   	(bad)  
  2836d8:	3e 00 00             	add    %al,%ds:(%eax)
  2836db:	00 00                	add    %al,(%eax)
  2836dd:	41                   	inc    %ecx
  2836de:	0e                   	push   %cs
  2836df:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2836e5:	45                   	inc    %ebp
  2836e6:	86 03                	xchg   %al,(%ebx)
  2836e8:	83 04 73 c3          	addl   $0xffffffc3,(%ebx,%esi,2)
  2836ec:	41                   	inc    %ecx
  2836ed:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  2836f1:	04 04                	add    $0x4,%al
  2836f3:	00 24 00             	add    %ah,(%eax,%eax,1)
  2836f6:	00 00                	add    %al,(%eax)
  2836f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  2836f9:	00 00                	add    %al,(%eax)
  2836fb:	00 7b ce             	add    %bh,-0x32(%ebx)
  2836fe:	ff                   	(bad)  
  2836ff:	ff 31                	pushl  (%ecx)
  283701:	00 00                	add    %al,(%eax)
  283703:	00 00                	add    %al,(%eax)
  283705:	41                   	inc    %ecx
  283706:	0e                   	push   %cs
  283707:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  28370d:	42                   	inc    %edx
  28370e:	87 03                	xchg   %eax,(%ebx)
  283710:	86 04 64             	xchg   %al,(%esp,%eiz,2)
  283713:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283717:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28371a:	04 00                	add    $0x0,%al
  28371c:	20 00                	and    %al,(%eax)
  28371e:	00 00                	add    %al,(%eax)
  283720:	cc                   	int3   
  283721:	00 00                	add    %al,(%eax)
  283723:	00 84 ce ff ff 2f 00 	add    %al,0x2fffff(%esi,%ecx,8)
  28372a:	00 00                	add    %al,(%eax)
  28372c:	00 41 0e             	add    %al,0xe(%ecx)
  28372f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283735:	47                   	inc    %edi
  283736:	83 03 63             	addl   $0x63,(%ebx)
  283739:	c3                   	ret    
  28373a:	41                   	inc    %ecx
  28373b:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28373e:	04 00                	add    $0x0,%al
  283740:	1c 00                	sbb    $0x0,%al
  283742:	00 00                	add    %al,(%eax)
  283744:	f0 00 00             	lock add %al,(%eax)
  283747:	00 8f ce ff ff 28    	add    %cl,0x28ffffce(%edi)
  28374d:	00 00                	add    %al,(%eax)
  28374f:	00 00                	add    %al,(%eax)
  283751:	41                   	inc    %ecx
  283752:	0e                   	push   %cs
  283753:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283759:	64 c5 0c 04          	lds    %fs:(%esp,%eax,1),%ecx
  28375d:	04 00                	add    $0x0,%al
  28375f:	00 20                	add    %ah,(%eax)
  283761:	00 00                	add    %al,(%eax)
  283763:	00 10                	add    %dl,(%eax)
  283765:	01 00                	add    %eax,(%eax)
  283767:	00 97 ce ff ff bc    	add    %dl,-0x43000032(%edi)
  28376d:	01 00                	add    %eax,(%eax)
  28376f:	00 00                	add    %al,(%eax)
  283771:	41                   	inc    %ecx
  283772:	0e                   	push   %cs
  283773:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283779:	41                   	inc    %ecx
  28377a:	83 03 03             	addl   $0x3,(%ebx)
  28377d:	b7 01                	mov    $0x1,%bh
  28377f:	c5 c3 0c             	(bad)  
  283782:	04 04                	add    $0x4,%al
  283784:	1c 00                	sbb    $0x0,%al
  283786:	00 00                	add    %al,(%eax)
  283788:	34 01                	xor    $0x1,%al
  28378a:	00 00                	add    %al,(%eax)
  28378c:	2f                   	das    
  28378d:	d0 ff                	sar    %bh
  28378f:	ff 61 01             	jmp    *0x1(%ecx)
  283792:	00 00                	add    %al,(%eax)
  283794:	00 41 0e             	add    %al,0xe(%ecx)
  283797:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28379d:	03 5d 01             	add    0x1(%ebp),%ebx
  2837a0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2837a3:	04 1c                	add    $0x1c,%al
  2837a5:	00 00                	add    %al,(%eax)
  2837a7:	00 54 01 00          	add    %dl,0x0(%ecx,%eax,1)
  2837ab:	00 70 d1             	add    %dh,-0x2f(%eax)
  2837ae:	ff                   	(bad)  
  2837af:	ff 1f                	lcall  *(%edi)
  2837b1:	00 00                	add    %al,(%eax)
  2837b3:	00 00                	add    %al,(%eax)
  2837b5:	41                   	inc    %ecx
  2837b6:	0e                   	push   %cs
  2837b7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2837bd:	5b                   	pop    %ebx
  2837be:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2837c1:	04 00                	add    $0x0,%al
  2837c3:	00 24 00             	add    %ah,(%eax,%eax,1)
  2837c6:	00 00                	add    %al,(%eax)
  2837c8:	74 01                	je     2837cb <cursor.1420+0x2c3>
  2837ca:	00 00                	add    %al,(%eax)
  2837cc:	6f                   	outsl  %ds:(%esi),(%dx)
  2837cd:	d1 ff                	sar    %edi
  2837cf:	ff 50 00             	call   *0x0(%eax)
  2837d2:	00 00                	add    %al,(%eax)
  2837d4:	00 41 0e             	add    %al,0xe(%ecx)
  2837d7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2837dd:	48                   	dec    %eax
  2837de:	86 03                	xchg   %al,(%ebx)
  2837e0:	83 04 02 40          	addl   $0x40,(%edx,%eax,1)
  2837e4:	c3                   	ret    
  2837e5:	41                   	inc    %ecx
  2837e6:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  2837ea:	04 04                	add    $0x4,%al
  2837ec:	24 00                	and    $0x0,%al
  2837ee:	00 00                	add    %al,(%eax)
  2837f0:	9c                   	pushf  
  2837f1:	01 00                	add    %eax,(%eax)
  2837f3:	00 97 d1 ff ff 39    	add    %dl,0x39ffffd1(%edi)
  2837f9:	00 00                	add    %al,(%eax)
  2837fb:	00 00                	add    %al,(%eax)
  2837fd:	41                   	inc    %ecx
  2837fe:	0e                   	push   %cs
  2837ff:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283805:	44                   	inc    %esp
  283806:	86 03                	xchg   %al,(%ebx)
  283808:	43                   	inc    %ebx
  283809:	83 04 6c c3          	addl   $0xffffffc3,(%esp,%ebp,2)
  28380d:	41                   	inc    %ecx
  28380e:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  283812:	04 04                	add    $0x4,%al
  283814:	2c 00                	sub    $0x0,%al
  283816:	00 00                	add    %al,(%eax)
  283818:	c4 01                	les    (%ecx),%eax
  28381a:	00 00                	add    %al,(%eax)
  28381c:	a8 d1                	test   $0xd1,%al
  28381e:	ff                   	(bad)  
  28381f:	ff 50 01             	call   *0x1(%eax)
  283822:	00 00                	add    %al,(%eax)
  283824:	00 41 0e             	add    %al,0xe(%ecx)
  283827:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28382d:	46                   	inc    %esi
  28382e:	87 03                	xchg   %eax,(%ebx)
  283830:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283833:	05 03 43 01 c3       	add    $0xc3014303,%eax
  283838:	41                   	inc    %ecx
  283839:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28383d:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283840:	04 00                	add    $0x0,%al
  283842:	00 00                	add    %al,(%eax)
  283844:	28 00                	sub    %al,(%eax)
  283846:	00 00                	add    %al,(%eax)
  283848:	f4                   	hlt    
  283849:	01 00                	add    %eax,(%eax)
  28384b:	00 c8                	add    %cl,%al
  28384d:	d2 ff                	sar    %cl,%bh
  28384f:	ff 62 00             	jmp    *0x0(%edx)
  283852:	00 00                	add    %al,(%eax)
  283854:	00 41 0e             	add    %al,0xe(%ecx)
  283857:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  28385d:	4b                   	dec    %ebx
  28385e:	87 03                	xchg   %eax,(%ebx)
  283860:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283863:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  283868:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28386c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28386f:	04 28                	add    $0x28,%al
  283871:	00 00                	add    %al,(%eax)
  283873:	00 20                	add    %ah,(%eax)
  283875:	02 00                	add    (%eax),%al
  283877:	00 fe                	add    %bh,%dh
  283879:	d2 ff                	sar    %cl,%bh
  28387b:	ff 62 00             	jmp    *0x0(%edx)
  28387e:	00 00                	add    %al,(%eax)
  283880:	00 41 0e             	add    %al,0xe(%ecx)
  283883:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283889:	4b                   	dec    %ebx
  28388a:	87 03                	xchg   %eax,(%ebx)
  28388c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28388f:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  283894:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283898:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28389b:	04 28                	add    $0x28,%al
  28389d:	00 00                	add    %al,(%eax)
  28389f:	00 4c 02 00          	add    %cl,0x0(%edx,%eax,1)
  2838a3:	00 34 d3             	add    %dh,(%ebx,%edx,8)
  2838a6:	ff                   	(bad)  
  2838a7:	ff aa 00 00 00 00    	ljmp   *0x0(%edx)
  2838ad:	41                   	inc    %ecx
  2838ae:	0e                   	push   %cs
  2838af:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2838b5:	46                   	inc    %esi
  2838b6:	87 03                	xchg   %eax,(%ebx)
  2838b8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2838bb:	05 02 9d c3 41       	add    $0x41c39d02,%eax
  2838c0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2838c4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2838c7:	04 28                	add    $0x28,%al
  2838c9:	00 00                	add    %al,(%eax)
  2838cb:	00 78 02             	add    %bh,0x2(%eax)
  2838ce:	00 00                	add    %al,(%eax)
  2838d0:	b2 d3                	mov    $0xd3,%dl
  2838d2:	ff                   	(bad)  
  2838d3:	ff 51 00             	call   *0x0(%ecx)
  2838d6:	00 00                	add    %al,(%eax)
  2838d8:	00 41 0e             	add    %al,0xe(%ecx)
  2838db:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2838e1:	41                   	inc    %ecx
  2838e2:	87 03                	xchg   %eax,(%ebx)
  2838e4:	4a                   	dec    %edx
  2838e5:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2838e8:	05 7d c3 41 c6       	add    $0xc641c37d,%eax
  2838ed:	41                   	inc    %ecx
  2838ee:	c7 41 c5 0c 04 04 2c 	movl   $0x2c04040c,-0x3b(%ecx)
  2838f5:	00 00                	add    %al,(%eax)
  2838f7:	00 a4 02 00 00 d7 d3 	add    %ah,-0x2c290000(%edx,%eax,1)
  2838fe:	ff                   	(bad)  
  2838ff:	ff 61 00             	jmp    *0x0(%ecx)
  283902:	00 00                	add    %al,(%eax)
  283904:	00 41 0e             	add    %al,0xe(%ecx)
  283907:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28390d:	41                   	inc    %ecx
  28390e:	87 03                	xchg   %eax,(%ebx)
  283910:	44                   	inc    %esp
  283911:	86 04 45 83 05 02 50 	xchg   %al,0x50020583(,%eax,2)
  283918:	c3                   	ret    
  283919:	41                   	inc    %ecx
  28391a:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28391e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283921:	04 00                	add    $0x0,%al
  283923:	00 20                	add    %ah,(%eax)
  283925:	00 00                	add    %al,(%eax)
  283927:	00 d4                	add    %dl,%ah
  283929:	02 00                	add    (%eax),%al
  28392b:	00 08                	add    %cl,(%eax)
  28392d:	d4 ff                	aam    $0xff
  28392f:	ff                   	(bad)  
  283930:	3a 00                	cmp    (%eax),%al
  283932:	00 00                	add    %al,(%eax)
  283934:	00 41 0e             	add    %al,0xe(%ecx)
  283937:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28393d:	44                   	inc    %esp
  28393e:	83 03 72             	addl   $0x72,(%ebx)
  283941:	c5 c3 0c             	(bad)  
  283944:	04 04                	add    $0x4,%al
  283946:	00 00                	add    %al,(%eax)
  283948:	28 00                	sub    %al,(%eax)
  28394a:	00 00                	add    %al,(%eax)
  28394c:	f8                   	clc    
  28394d:	02 00                	add    (%eax),%al
  28394f:	00 1e                	add    %bl,(%esi)
  283951:	d4 ff                	aam    $0xff
  283953:	ff 50 00             	call   *0x0(%eax)
  283956:	00 00                	add    %al,(%eax)
  283958:	00 41 0e             	add    %al,0xe(%ecx)
  28395b:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283961:	44                   	inc    %esp
  283962:	87 03                	xchg   %eax,(%ebx)
  283964:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283967:	05 02 43 c3 41       	add    $0x41c34302,%eax
  28396c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283970:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283973:	04 2c                	add    $0x2c,%al
  283975:	00 00                	add    %al,(%eax)
  283977:	00 24 03             	add    %ah,(%ebx,%eax,1)
  28397a:	00 00                	add    %al,(%eax)
  28397c:	42                   	inc    %edx
  28397d:	d4 ff                	aam    $0xff
  28397f:	ff 4f 00             	decl   0x0(%edi)
  283982:	00 00                	add    %al,(%eax)
  283984:	00 41 0e             	add    %al,0xe(%ecx)
  283987:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28398d:	41                   	inc    %ecx
  28398e:	87 03                	xchg   %eax,(%ebx)
  283990:	44                   	inc    %esp
  283991:	86 04 44             	xchg   %al,(%esp,%eax,2)
  283994:	83 05 7f c3 41 c6 41 	addl   $0x41,0xc641c37f
  28399b:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  2839a2:	00 00                	add    %al,(%eax)
  2839a4:	2c 00                	sub    $0x0,%al
  2839a6:	00 00                	add    %al,(%eax)
  2839a8:	54                   	push   %esp
  2839a9:	03 00                	add    (%eax),%eax
  2839ab:	00 61 d4             	add    %ah,-0x2c(%ecx)
  2839ae:	ff                   	(bad)  
  2839af:	ff 54 00 00          	call   *0x0(%eax,%eax,1)
  2839b3:	00 00                	add    %al,(%eax)
  2839b5:	41                   	inc    %ecx
  2839b6:	0e                   	push   %cs
  2839b7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2839bd:	48                   	dec    %eax
  2839be:	87 03                	xchg   %eax,(%ebx)
  2839c0:	86 04 44             	xchg   %al,(%esp,%eax,2)
  2839c3:	83 05 02 41 c3 41 c6 	addl   $0xffffffc6,0x41c34102
  2839ca:	41                   	inc    %ecx
  2839cb:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  2839d2:	00 00                	add    %al,(%eax)
  2839d4:	1c 00                	sbb    $0x0,%al
  2839d6:	00 00                	add    %al,(%eax)
  2839d8:	84 03                	test   %al,(%ebx)
  2839da:	00 00                	add    %al,(%eax)
  2839dc:	85 d4                	test   %edx,%esp
  2839de:	ff                   	(bad)  
  2839df:	ff 2a                	ljmp   *(%edx)
  2839e1:	00 00                	add    %al,(%eax)
  2839e3:	00 00                	add    %al,(%eax)
  2839e5:	41                   	inc    %ecx
  2839e6:	0e                   	push   %cs
  2839e7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2839ed:	66 c5 0c 04          	lds    (%esp,%eax,1),%cx
  2839f1:	04 00                	add    $0x0,%al
  2839f3:	00 20                	add    %ah,(%eax)
  2839f5:	00 00                	add    %al,(%eax)
  2839f7:	00 a4 03 00 00 8f d4 	add    %ah,-0x2b710000(%ebx,%eax,1)
  2839fe:	ff                   	(bad)  
  2839ff:	ff 60 01             	jmp    *0x1(%eax)
  283a02:	00 00                	add    %al,(%eax)
  283a04:	00 41 0e             	add    %al,0xe(%ecx)
  283a07:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283a0d:	41                   	inc    %ecx
  283a0e:	83 03 03             	addl   $0x3,(%ebx)
  283a11:	5b                   	pop    %ebx
  283a12:	01 c5                	add    %eax,%ebp
  283a14:	c3                   	ret    
  283a15:	0c 04                	or     $0x4,%al
  283a17:	04 1c                	add    $0x1c,%al
  283a19:	00 00                	add    %al,(%eax)
  283a1b:	00 c8                	add    %cl,%al
  283a1d:	03 00                	add    (%eax),%eax
  283a1f:	00 cb                	add    %cl,%bl
  283a21:	d5 ff                	aad    $0xff
  283a23:	ff                   	(bad)  
  283a24:	3a 00                	cmp    (%eax),%al
  283a26:	00 00                	add    %al,(%eax)
  283a28:	00 41 0e             	add    %al,0xe(%ecx)
  283a2b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283a31:	71 c5                	jno    2839f8 <cursor.1420+0x4f0>
  283a33:	0c 04                	or     $0x4,%al
  283a35:	04 00                	add    $0x0,%al
  283a37:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283a3a:	00 00                	add    %al,(%eax)
  283a3c:	e8 03 00 00 e5       	call   e5283a44 <mousefifo+0xe4fffc0c>
  283a41:	d5 ff                	aad    $0xff
  283a43:	ff 24 00             	jmp    *(%eax,%eax,1)
  283a46:	00 00                	add    %al,(%eax)
  283a48:	00 41 0e             	add    %al,0xe(%ecx)
  283a4b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283a51:	5b                   	pop    %ebx
  283a52:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283a55:	04 00                	add    $0x0,%al
  283a57:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283a5a:	00 00                	add    %al,(%eax)
  283a5c:	08 04 00             	or     %al,(%eax,%eax,1)
  283a5f:	00 e9                	add    %ch,%cl
  283a61:	d5 ff                	aad    $0xff
  283a63:	ff 29                	ljmp   *(%ecx)
  283a65:	00 00                	add    %al,(%eax)
  283a67:	00 00                	add    %al,(%eax)
  283a69:	41                   	inc    %ecx
  283a6a:	0e                   	push   %cs
  283a6b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283a71:	60                   	pusha  
  283a72:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283a75:	04 00                	add    $0x0,%al
  283a77:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283a7a:	00 00                	add    %al,(%eax)
  283a7c:	28 04 00             	sub    %al,(%eax,%eax,1)
  283a7f:	00 f2                	add    %dh,%dl
  283a81:	d5 ff                	aad    $0xff
  283a83:	ff 0f                	decl   (%edi)
  283a85:	00 00                	add    %al,(%eax)
  283a87:	00 00                	add    %al,(%eax)
  283a89:	41                   	inc    %ecx
  283a8a:	0e                   	push   %cs
  283a8b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283a91:	46                   	inc    %esi
  283a92:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283a95:	04 00                	add    $0x0,%al
  283a97:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283a9a:	00 00                	add    %al,(%eax)
  283a9c:	48                   	dec    %eax
  283a9d:	04 00                	add    $0x0,%al
  283a9f:	00 e1                	add    %ah,%cl
  283aa1:	d5 ff                	aad    $0xff
  283aa3:	ff 1f                	lcall  *(%edi)
  283aa5:	00 00                	add    %al,(%eax)
  283aa7:	00 00                	add    %al,(%eax)
  283aa9:	41                   	inc    %ecx
  283aaa:	0e                   	push   %cs
  283aab:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283ab1:	5b                   	pop    %ebx
  283ab2:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283ab5:	04 00                	add    $0x0,%al
  283ab7:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283aba:	00 00                	add    %al,(%eax)
  283abc:	68 04 00 00 36       	push   $0x36000004
  283ac1:	d6                   	(bad)  
  283ac2:	ff                   	(bad)  
  283ac3:	ff 2b                	ljmp   *(%ebx)
  283ac5:	00 00                	add    %al,(%eax)
  283ac7:	00 00                	add    %al,(%eax)
  283ac9:	41                   	inc    %ecx
  283aca:	0e                   	push   %cs
  283acb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283ad1:	67 c5 0c             	lds    (%si),%ecx
  283ad4:	04 04                	add    $0x4,%al
  283ad6:	00 00                	add    %al,(%eax)
  283ad8:	20 00                	and    %al,(%eax)
  283ada:	00 00                	add    %al,(%eax)
  283adc:	88 04 00             	mov    %al,(%eax,%eax,1)
  283adf:	00 41 d6             	add    %al,-0x2a(%ecx)
  283ae2:	ff                   	(bad)  
  283ae3:	ff                   	(bad)  
  283ae4:	3e 00 00             	add    %al,%ds:(%eax)
  283ae7:	00 00                	add    %al,(%eax)
  283ae9:	41                   	inc    %ecx
  283aea:	0e                   	push   %cs
  283aeb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283af1:	44                   	inc    %esp
  283af2:	83 03 75             	addl   $0x75,(%ebx)
  283af5:	c3                   	ret    
  283af6:	41                   	inc    %ecx
  283af7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283afa:	04 00                	add    $0x0,%al
  283afc:	28 00                	sub    %al,(%eax)
  283afe:	00 00                	add    %al,(%eax)
  283b00:	ac                   	lods   %ds:(%esi),%al
  283b01:	04 00                	add    $0x0,%al
  283b03:	00 5b d6             	add    %bl,-0x2a(%ebx)
  283b06:	ff                   	(bad)  
  283b07:	ff 35 00 00 00 00    	pushl  0x0
  283b0d:	41                   	inc    %ecx
  283b0e:	0e                   	push   %cs
  283b0f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283b15:	46                   	inc    %esi
  283b16:	87 03                	xchg   %eax,(%ebx)
  283b18:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283b1b:	05 68 c3 41 c6       	add    $0xc641c368,%eax
  283b20:	41                   	inc    %ecx
  283b21:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  283b28:	1c 00                	sbb    $0x0,%al
  283b2a:	00 00                	add    %al,(%eax)
  283b2c:	d8 04 00             	fadds  (%eax,%eax,1)
  283b2f:	00 64 d6 ff          	add    %ah,-0x1(%esi,%edx,8)
  283b33:	ff 0e                	decl   (%esi)
  283b35:	00 00                	add    %al,(%eax)
  283b37:	00 00                	add    %al,(%eax)
  283b39:	41                   	inc    %ecx
  283b3a:	0e                   	push   %cs
  283b3b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283b41:	44                   	inc    %esp
  283b42:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283b45:	04 00                	add    $0x0,%al
  283b47:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283b4a:	00 00                	add    %al,(%eax)
  283b4c:	f8                   	clc    
  283b4d:	04 00                	add    $0x0,%al
  283b4f:	00 52 d6             	add    %dl,-0x2a(%edx)
  283b52:	ff                   	(bad)  
  283b53:	ff 29                	ljmp   *(%ecx)
  283b55:	00 00                	add    %al,(%eax)
  283b57:	00 00                	add    %al,(%eax)
  283b59:	41                   	inc    %ecx
  283b5a:	0e                   	push   %cs
  283b5b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283b61:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
  283b65:	04 00                	add    $0x0,%al
  283b67:	00 20                	add    %ah,(%eax)
  283b69:	00 00                	add    %al,(%eax)
  283b6b:	00 18                	add    %bl,(%eax)
  283b6d:	05 00 00 5b d6       	add    $0xd65b0000,%eax
  283b72:	ff                   	(bad)  
  283b73:	ff 8e 00 00 00 00    	decl   0x0(%esi)
  283b79:	41                   	inc    %ecx
  283b7a:	0e                   	push   %cs
  283b7b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283b81:	44                   	inc    %esp
  283b82:	83 03 02             	addl   $0x2,(%ebx)
  283b85:	85 c3                	test   %eax,%ebx
  283b87:	41                   	inc    %ecx
  283b88:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283b8b:	04 20                	add    $0x20,%al
  283b8d:	00 00                	add    %al,(%eax)
  283b8f:	00 3c 05 00 00 c5 d6 	add    %bh,-0x293b0000(,%eax,1)
  283b96:	ff                   	(bad)  
  283b97:	ff                   	(bad)  
  283b98:	3a 00                	cmp    (%eax),%al
  283b9a:	00 00                	add    %al,(%eax)
  283b9c:	00 41 0e             	add    %al,0xe(%ecx)
  283b9f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283ba5:	44                   	inc    %esp
  283ba6:	83 03 71             	addl   $0x71,(%ebx)
  283ba9:	c3                   	ret    
  283baa:	41                   	inc    %ecx
  283bab:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283bae:	04 00                	add    $0x0,%al
  283bb0:	20 00                	and    %al,(%eax)
  283bb2:	00 00                	add    %al,(%eax)
  283bb4:	60                   	pusha  
  283bb5:	05 00 00 db d6       	add    $0xd6db0000,%eax
  283bba:	ff                   	(bad)  
  283bbb:	ff 4e 00             	decl   0x0(%esi)
  283bbe:	00 00                	add    %al,(%eax)
  283bc0:	00 41 0e             	add    %al,0xe(%ecx)
  283bc3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283bc9:	41                   	inc    %ecx
  283bca:	83 03 02             	addl   $0x2,(%ebx)
  283bcd:	49                   	dec    %ecx
  283bce:	c5 c3 0c             	(bad)  
  283bd1:	04 04                	add    $0x4,%al
  283bd3:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283bd6:	00 00                	add    %al,(%eax)
  283bd8:	84 05 00 00 05 d7    	test   %al,0xd7050000
  283bde:	ff                   	(bad)  
  283bdf:	ff 23                	jmp    *(%ebx)
  283be1:	00 00                	add    %al,(%eax)
  283be3:	00 00                	add    %al,(%eax)
  283be5:	41                   	inc    %ecx
  283be6:	0e                   	push   %cs
  283be7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283bed:	5f                   	pop    %edi
  283bee:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283bf1:	04 00                	add    $0x0,%al
  283bf3:	00 20                	add    %ah,(%eax)
  283bf5:	00 00                	add    %al,(%eax)
  283bf7:	00 a4 05 00 00 08 d7 	add    %ah,-0x28f80000(%ebp,%eax,1)
  283bfe:	ff                   	(bad)  
  283bff:	ff 1b                	lcall  *(%ebx)
  283c01:	00 00                	add    %al,(%eax)
  283c03:	00 00                	add    %al,(%eax)
  283c05:	41                   	inc    %ecx
  283c06:	0e                   	push   %cs
  283c07:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283c0d:	46                   	inc    %esi
  283c0e:	83 03 4e             	addl   $0x4e,(%ebx)
  283c11:	c3                   	ret    
  283c12:	41                   	inc    %ecx
  283c13:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283c16:	04 00                	add    $0x0,%al
  283c18:	28 00                	sub    %al,(%eax)
  283c1a:	00 00                	add    %al,(%eax)
  283c1c:	c8 05 00 00          	enter  $0x5,$0x0
  283c20:	ff d6                	call   *%esi
  283c22:	ff                   	(bad)  
  283c23:	ff 5b 00             	lcall  *0x0(%ebx)
  283c26:	00 00                	add    %al,(%eax)
  283c28:	00 41 0e             	add    %al,0xe(%ecx)
  283c2b:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283c31:	46                   	inc    %esi
  283c32:	87 03                	xchg   %eax,(%ebx)
  283c34:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283c37:	05 02 4c c3 41       	add    $0x41c34c02,%eax
  283c3c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283c40:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283c43:	04 1c                	add    $0x1c,%al
  283c45:	00 00                	add    %al,(%eax)
  283c47:	00 f4                	add    %dh,%ah
  283c49:	05 00 00 2e d7       	add    $0xd72e0000,%eax
  283c4e:	ff                   	(bad)  
  283c4f:	ff 19                	lcall  *(%ecx)
  283c51:	00 00                	add    %al,(%eax)
  283c53:	00 00                	add    %al,(%eax)
  283c55:	41                   	inc    %ecx
  283c56:	0e                   	push   %cs
  283c57:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283c5d:	51                   	push   %ecx
  283c5e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283c61:	04 00                	add    $0x0,%al
  283c63:	00 28                	add    %ch,(%eax)
  283c65:	00 00                	add    %al,(%eax)
  283c67:	00 14 06             	add    %dl,(%esi,%eax,1)
  283c6a:	00 00                	add    %al,(%eax)
  283c6c:	27                   	daa    
  283c6d:	d7                   	xlat   %ds:(%ebx)
  283c6e:	ff                   	(bad)  
  283c6f:	ff                   	(bad)  
  283c70:	ea 00 00 00 00 41 0e 	ljmp   $0xe41,$0x0
  283c77:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283c7d:	46                   	inc    %esi
  283c7e:	87 03                	xchg   %eax,(%ebx)
  283c80:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283c83:	05 02 db c3 41       	add    $0x41c3db02,%eax
  283c88:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283c8c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283c8f:	04 1c                	add    $0x1c,%al
  283c91:	00 00                	add    %al,(%eax)
  283c93:	00 40 06             	add    %al,0x6(%eax)
  283c96:	00 00                	add    %al,(%eax)
  283c98:	e5 d7                	in     $0xd7,%eax
  283c9a:	ff                   	(bad)  
  283c9b:	ff 19                	lcall  *(%ecx)
  283c9d:	00 00                	add    %al,(%eax)
  283c9f:	00 00                	add    %al,(%eax)
  283ca1:	41                   	inc    %ecx
  283ca2:	0e                   	push   %cs
  283ca3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283ca9:	51                   	push   %ecx
  283caa:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283cad:	04 00                	add    $0x0,%al
  283caf:	00 2c 00             	add    %ch,(%eax,%eax,1)
  283cb2:	00 00                	add    %al,(%eax)
  283cb4:	60                   	pusha  
  283cb5:	06                   	push   %es
  283cb6:	00 00                	add    %al,(%eax)
  283cb8:	de d7                	(bad)  
  283cba:	ff                   	(bad)  
  283cbb:	ff 84 00 00 00 00 41 	incl   0x41000000(%eax,%eax,1)
  283cc2:	0e                   	push   %cs
  283cc3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283cc9:	41                   	inc    %ecx
  283cca:	87 03                	xchg   %eax,(%ebx)
  283ccc:	45                   	inc    %ebp
  283ccd:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283cd0:	05 02 77 c3 41       	add    $0x41c37702,%eax
  283cd5:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283cd9:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283cdc:	04 00                	add    $0x0,%al
  283cde:	00 00                	add    %al,(%eax)
  283ce0:	1c 00                	sbb    $0x0,%al
  283ce2:	00 00                	add    %al,(%eax)
  283ce4:	90                   	nop
  283ce5:	06                   	push   %es
  283ce6:	00 00                	add    %al,(%eax)
  283ce8:	32 d8                	xor    %al,%bl
  283cea:	ff                   	(bad)  
  283ceb:	ff 33                	pushl  (%ebx)
  283ced:	00 00                	add    %al,(%eax)
  283cef:	00 00                	add    %al,(%eax)
  283cf1:	41                   	inc    %ecx
  283cf2:	0e                   	push   %cs
  283cf3:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283cf9:	6d                   	insl   (%dx),%es:(%edi)
  283cfa:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283cfd:	04 00                	add    $0x0,%al
  283cff:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283d02:	00 00                	add    %al,(%eax)
  283d04:	b0 06                	mov    $0x6,%al
  283d06:	00 00                	add    %al,(%eax)
  283d08:	45                   	inc    %ebp
  283d09:	d8 ff                	fdivr  %st(7),%st
  283d0b:	ff 1f                	lcall  *(%edi)
  283d0d:	00 00                	add    %al,(%eax)
  283d0f:	00 00                	add    %al,(%eax)
  283d11:	41                   	inc    %ecx
  283d12:	0e                   	push   %cs
  283d13:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283d19:	5b                   	pop    %ebx
  283d1a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283d1d:	04 00                	add    $0x0,%al
  283d1f:	00 2c 00             	add    %ch,(%eax,%eax,1)
  283d22:	00 00                	add    %al,(%eax)
  283d24:	d0 06                	rolb   (%esi)
  283d26:	00 00                	add    %al,(%eax)
  283d28:	44                   	inc    %esp
  283d29:	d8 ff                	fdivr  %st(7),%st
  283d2b:	ff 13                	call   *(%ebx)
  283d2d:	01 00                	add    %eax,(%eax)
  283d2f:	00 00                	add    %al,(%eax)
  283d31:	41                   	inc    %ecx
  283d32:	0e                   	push   %cs
  283d33:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283d39:	46                   	inc    %esi
  283d3a:	87 03                	xchg   %eax,(%ebx)
  283d3c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283d3f:	05 03 06 01 c3       	add    $0xc3010603,%eax
  283d44:	41                   	inc    %ecx
  283d45:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283d49:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283d4c:	04 00                	add    $0x0,%al
  283d4e:	00 00                	add    %al,(%eax)
  283d50:	20 00                	and    %al,(%eax)
  283d52:	00 00                	add    %al,(%eax)
  283d54:	00 07                	add    %al,(%edi)
  283d56:	00 00                	add    %al,(%eax)
  283d58:	27                   	daa    
  283d59:	d9 ff                	fcos   
  283d5b:	ff                   	(bad)  
  283d5c:	3b 00                	cmp    (%eax),%eax
  283d5e:	00 00                	add    %al,(%eax)
  283d60:	00 41 0e             	add    %al,0xe(%ecx)
  283d63:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283d69:	44                   	inc    %esp
  283d6a:	83 03 73             	addl   $0x73,(%ebx)
  283d6d:	c5 c3 0c             	(bad)  
  283d70:	04 04                	add    $0x4,%al
  283d72:	00 00                	add    %al,(%eax)
  283d74:	28 00                	sub    %al,(%eax)
  283d76:	00 00                	add    %al,(%eax)
  283d78:	24 07                	and    $0x7,%al
  283d7a:	00 00                	add    %al,(%eax)
  283d7c:	3e                   	ds
  283d7d:	d9 ff                	fcos   
  283d7f:	ff 08                	decl   (%eax)
  283d81:	01 00                	add    %eax,(%eax)
  283d83:	00 00                	add    %al,(%eax)
  283d85:	41                   	inc    %ecx
  283d86:	0e                   	push   %cs
  283d87:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283d8d:	46                   	inc    %esi
  283d8e:	87 03                	xchg   %eax,(%ebx)
  283d90:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283d93:	05 02 fb c3 41       	add    $0x41c3fb02,%eax
  283d98:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283d9c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283d9f:	04 2c                	add    $0x2c,%al
  283da1:	00 00                	add    %al,(%eax)
  283da3:	00 50 07             	add    %dl,0x7(%eax)
  283da6:	00 00                	add    %al,(%eax)
  283da8:	1a da                	sbb    %dl,%bl
  283daa:	ff                   	(bad)  
  283dab:	ff 9a 01 00 00 00    	lcall  *0x1(%edx)
  283db1:	41                   	inc    %ecx
  283db2:	0e                   	push   %cs
  283db3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283db9:	46                   	inc    %esi
  283dba:	87 03                	xchg   %eax,(%ebx)
  283dbc:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283dbf:	05 03 8d 01 c3       	add    $0xc3018d03,%eax
  283dc4:	41                   	inc    %ecx
  283dc5:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283dc9:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283dcc:	04 00                	add    $0x0,%al
  283dce:	00 00                	add    %al,(%eax)
  283dd0:	20 00                	and    %al,(%eax)
  283dd2:	00 00                	add    %al,(%eax)
  283dd4:	80 07 00             	addb   $0x0,(%edi)
  283dd7:	00 84 db ff ff 23 00 	add    %al,0x23ffff(%ebx,%ebx,8)
  283dde:	00 00                	add    %al,(%eax)
  283de0:	00 41 0e             	add    %al,0xe(%ecx)
  283de3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283de9:	41                   	inc    %ecx
  283dea:	83 03 5e             	addl   $0x5e,(%ebx)
  283ded:	c5 c3 0c             	(bad)  
  283df0:	04 04                	add    $0x4,%al
  283df2:	00 00                	add    %al,(%eax)
  283df4:	28 00                	sub    %al,(%eax)
  283df6:	00 00                	add    %al,(%eax)
  283df8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  283df9:	07                   	pop    %es
  283dfa:	00 00                	add    %al,(%eax)
  283dfc:	83 db ff             	sbb    $0xffffffff,%ebx
  283dff:	ff a8 00 00 00 00    	ljmp   *0x0(%eax)
  283e05:	41                   	inc    %ecx
  283e06:	0e                   	push   %cs
  283e07:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283e0d:	46                   	inc    %esi
  283e0e:	87 03                	xchg   %eax,(%ebx)
  283e10:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283e13:	05 02 9b c3 41       	add    $0x41c39b02,%eax
  283e18:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283e1c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283e1f:	04                   	.byte 0x4

Disassembly of section .bss:

00283e20 <keyfifo>:
	...

00283e38 <mousefifo>:
	...

Disassembly of section .stab:

00000000 <.stab>:
       0:	01 00                	add    %eax,(%eax)
       2:	00 00                	add    %al,(%eax)
       4:	00 00                	add    %al,(%eax)
       6:	1d 06 32 16 00       	sbb    $0x163206,%eax
       b:	00 01                	add    %al,(%ecx)
       d:	00 00                	add    %al,(%eax)
       f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
      13:	00 00                	add    %al,(%eax)
      15:	00 28                	add    %ch,(%eax)
      17:	00 08                	add    %cl,(%eax)
      19:	00 00                	add    %al,(%eax)
      1b:	00 3c 00             	add    %bh,(%eax,%eax,1)
      1e:	00 00                	add    %al,(%eax)
      20:	00 00                	add    %al,(%eax)
      22:	00 00                	add    %al,(%eax)
      24:	17                   	pop    %ss
      25:	00 00                	add    %al,(%eax)
      27:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      2d:	00 00                	add    %al,(%eax)
      2f:	00 41 00             	add    %al,0x0(%ecx)
      32:	00 00                	add    %al,(%eax)
      34:	80 00 00             	addb   $0x0,(%eax)
      37:	00 00                	add    %al,(%eax)
      39:	00 00                	add    %al,(%eax)
      3b:	00 5b 00             	add    %bl,0x0(%ebx)
      3e:	00 00                	add    %al,(%eax)
      40:	80 00 00             	addb   $0x0,(%eax)
      43:	00 00                	add    %al,(%eax)
      45:	00 00                	add    %al,(%eax)
      47:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
      4d:	00 00                	add    %al,(%eax)
      4f:	00 00                	add    %al,(%eax)
      51:	00 00                	add    %al,(%eax)
      53:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
      59:	00 00                	add    %al,(%eax)
      5b:	00 00                	add    %al,(%eax)
      5d:	00 00                	add    %al,(%eax)
      5f:	00 e1                	add    %ah,%cl
      61:	00 00                	add    %al,(%eax)
      63:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      69:	00 00                	add    %al,(%eax)
      6b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
      6e:	00 00                	add    %al,(%eax)
      70:	80 00 00             	addb   $0x0,(%eax)
      73:	00 00                	add    %al,(%eax)
      75:	00 00                	add    %al,(%eax)
      77:	00 37                	add    %dh,(%edi)
      79:	01 00                	add    %eax,(%eax)
      7b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      81:	00 00                	add    %al,(%eax)
      83:	00 5d 01             	add    %bl,0x1(%ebp)
      86:	00 00                	add    %al,(%eax)
      88:	80 00 00             	addb   $0x0,(%eax)
      8b:	00 00                	add    %al,(%eax)
      8d:	00 00                	add    %al,(%eax)
      8f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
      95:	00 00                	add    %al,(%eax)
      97:	00 00                	add    %al,(%eax)
      99:	00 00                	add    %al,(%eax)
      9b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
      a1:	00 00                	add    %al,(%eax)
      a3:	00 00                	add    %al,(%eax)
      a5:	00 00                	add    %al,(%eax)
      a7:	00 d2                	add    %dl,%dl
      a9:	01 00                	add    %eax,(%eax)
      ab:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      b1:	00 00                	add    %al,(%eax)
      b3:	00 ec                	add    %ch,%ah
      b5:	01 00                	add    %eax,(%eax)
      b7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      bd:	00 00                	add    %al,(%eax)
      bf:	00 07                	add    %al,(%edi)
      c1:	02 00                	add    (%eax),%al
      c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      c9:	00 00                	add    %al,(%eax)
      cb:	00 28                	add    %ch,(%eax)
      cd:	02 00                	add    (%eax),%al
      cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
      d5:	00 00                	add    %al,(%eax)
      d7:	00 47 02             	add    %al,0x2(%edi)
      da:	00 00                	add    %al,(%eax)
      dc:	80 00 00             	addb   $0x0,(%eax)
      df:	00 00                	add    %al,(%eax)
      e1:	00 00                	add    %al,(%eax)
      e3:	00 66 02             	add    %ah,0x2(%esi)
      e6:	00 00                	add    %al,(%eax)
      e8:	80 00 00             	addb   $0x0,(%eax)
      eb:	00 00                	add    %al,(%eax)
      ed:	00 00                	add    %al,(%eax)
      ef:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
      f5:	00 00                	add    %al,(%eax)
      f7:	00 00                	add    %al,(%eax)
      f9:	00 00                	add    %al,(%eax)
      fb:	00 9b 02 00 00 82    	add    %bl,-0x7dfffffe(%ebx)
     101:	00 00                	add    %al,(%eax)
     103:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
     109:	02 00                	add    (%eax),%al
     10b:	00 82 00 00 00 00    	add    %al,0x0(%edx)
     111:	00 00                	add    %al,(%eax)
     113:	00 be 02 00 00 82    	add    %bh,-0x7dfffffe(%esi)
     119:	00 00                	add    %al,(%eax)
     11b:	00 37                	add    %dh,(%edi)
     11d:	53                   	push   %ebx
     11e:	00 00                	add    %al,(%eax)
     120:	d0 02                	rolb   (%edx)
     122:	00 00                	add    %al,(%eax)
     124:	80 00 00             	addb   $0x0,(%eax)
     127:	00 00                	add    %al,(%eax)
     129:	00 00                	add    %al,(%eax)
     12b:	00 e2                	add    %ah,%dl
     12d:	02 00                	add    (%eax),%al
     12f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     135:	00 00                	add    %al,(%eax)
     137:	00 f7                	add    %dh,%bh
     139:	02 00                	add    (%eax),%al
     13b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     141:	00 00                	add    %al,(%eax)
     143:	00 0d 03 00 00 80    	add    %cl,0x80000003
     149:	00 00                	add    %al,(%eax)
     14b:	00 00                	add    %al,(%eax)
     14d:	00 00                	add    %al,(%eax)
     14f:	00 22                	add    %ah,(%edx)
     151:	03 00                	add    (%eax),%eax
     153:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     159:	00 00                	add    %al,(%eax)
     15b:	00 38                	add    %bh,(%eax)
     15d:	03 00                	add    (%eax),%eax
     15f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     165:	00 00                	add    %al,(%eax)
     167:	00 4d 03             	add    %cl,0x3(%ebp)
     16a:	00 00                	add    %al,(%eax)
     16c:	80 00 00             	addb   $0x0,(%eax)
     16f:	00 00                	add    %al,(%eax)
     171:	00 00                	add    %al,(%eax)
     173:	00 63 03             	add    %ah,0x3(%ebx)
     176:	00 00                	add    %al,(%eax)
     178:	80 00 00             	addb   $0x0,(%eax)
     17b:	00 00                	add    %al,(%eax)
     17d:	00 00                	add    %al,(%eax)
     17f:	00 78 03             	add    %bh,0x3(%eax)
     182:	00 00                	add    %al,(%eax)
     184:	80 00 00             	addb   $0x0,(%eax)
     187:	00 00                	add    %al,(%eax)
     189:	00 00                	add    %al,(%eax)
     18b:	00 8e 03 00 00 80    	add    %cl,-0x7ffffffd(%esi)
     191:	00 00                	add    %al,(%eax)
     193:	00 00                	add    %al,(%eax)
     195:	00 00                	add    %al,(%eax)
     197:	00 a5 03 00 00 80    	add    %ah,-0x7ffffffd(%ebp)
     19d:	00 00                	add    %al,(%eax)
     19f:	00 00                	add    %al,(%eax)
     1a1:	00 00                	add    %al,(%eax)
     1a3:	00 bd 03 00 00 80    	add    %bh,-0x7ffffffd(%ebp)
     1a9:	00 00                	add    %al,(%eax)
     1ab:	00 00                	add    %al,(%eax)
     1ad:	00 00                	add    %al,(%eax)
     1af:	00 d6                	add    %dl,%dh
     1b1:	03 00                	add    (%eax),%eax
     1b3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1b9:	00 00                	add    %al,(%eax)
     1bb:	00 ea                	add    %ch,%dl
     1bd:	03 00                	add    (%eax),%eax
     1bf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1c5:	00 00                	add    %al,(%eax)
     1c7:	00 ff                	add    %bh,%bh
     1c9:	03 00                	add    (%eax),%eax
     1cb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1d1:	00 00                	add    %al,(%eax)
     1d3:	00 15 04 00 00 80    	add    %dl,0x80000004
	...
     1e1:	00 00                	add    %al,(%eax)
     1e3:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     1e9:	00 00                	add    %al,(%eax)
     1eb:	00 00                	add    %al,(%eax)
     1ed:	00 00                	add    %al,(%eax)
     1ef:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     1f5:	00 00                	add    %al,(%eax)
     1f7:	00 29                	add    %ch,(%ecx)
     1f9:	04 00                	add    $0x0,%al
     1fb:	00 82 00 00 00 17    	add    %al,0x17000000(%edx)
     201:	a4                   	movsb  %ds:(%esi),%es:(%edi)
     202:	00 00                	add    %al,(%eax)
     204:	38 04 00             	cmp    %al,(%eax,%eax,1)
     207:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     20d:	00 00                	add    %al,(%eax)
     20f:	00 6c 04 00          	add    %ch,0x0(%esp,%eax,1)
     213:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     219:	00 00                	add    %al,(%eax)
     21b:	00 7e 04             	add    %bh,0x4(%esi)
     21e:	00 00                	add    %al,(%eax)
     220:	80 00 00             	addb   $0x0,(%eax)
     223:	00 00                	add    %al,(%eax)
     225:	00 00                	add    %al,(%eax)
     227:	00 22                	add    %ah,(%edx)
     229:	05 00 00 80 00       	add    $0x800000,%eax
     22e:	00 00                	add    %al,(%eax)
     230:	00 00                	add    %al,(%eax)
     232:	00 00                	add    %al,(%eax)
     234:	36                   	ss
     235:	05 00 00 80 00       	add    $0x800000,%eax
     23a:	00 00                	add    %al,(%eax)
     23c:	00 00                	add    %al,(%eax)
     23e:	00 00                	add    %al,(%eax)
     240:	05 06 00 00 80       	add    $0x80000006,%eax
     245:	00 00                	add    %al,(%eax)
     247:	00 00                	add    %al,(%eax)
     249:	00 00                	add    %al,(%eax)
     24b:	00 19                	add    %bl,(%ecx)
     24d:	06                   	push   %es
     24e:	00 00                	add    %al,(%eax)
     250:	80 00 00             	addb   $0x0,(%eax)
     253:	00 00                	add    %al,(%eax)
     255:	00 00                	add    %al,(%eax)
     257:	00 e7                	add    %ah,%bh
     259:	06                   	push   %es
     25a:	00 00                	add    %al,(%eax)
     25c:	80 00 00             	addb   $0x0,(%eax)
	...
     267:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     26d:	00 00                	add    %al,(%eax)
     26f:	00 fd                	add    %bh,%ch
     271:	06                   	push   %es
     272:	00 00                	add    %al,(%eax)
     274:	80 00 00             	addb   $0x0,(%eax)
     277:	00 00                	add    %al,(%eax)
     279:	00 00                	add    %al,(%eax)
     27b:	00 9a 07 00 00 80    	add    %bl,-0x7ffffff9(%edx)
     281:	00 00                	add    %al,(%eax)
     283:	00 00                	add    %al,(%eax)
     285:	00 00                	add    %al,(%eax)
     287:	00 2a                	add    %ch,(%edx)
     289:	08 00                	or     %al,(%eax)
     28b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     291:	00 00                	add    %al,(%eax)
     293:	00 a8 08 00 00 80    	add    %ch,-0x7ffffff8(%eax)
     299:	00 00                	add    %al,(%eax)
     29b:	00 00                	add    %al,(%eax)
     29d:	00 00                	add    %al,(%eax)
     29f:	00 1d 09 00 00 80    	add    %bl,0x80000009
	...
     2ad:	00 00                	add    %al,(%eax)
     2af:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     2b5:	00 00                	add    %al,(%eax)
     2b7:	00 96 09 00 00 24    	add    %dl,0x24000009(%esi)
     2bd:	00 00                	add    %al,(%eax)
     2bf:	00 00                	add    %al,(%eax)
     2c1:	00 28                	add    %ch,(%eax)
     2c3:	00 00                	add    %al,(%eax)
     2c5:	00 00                	add    %al,(%eax)
     2c7:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
	...
     2d3:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     2d7:	00 0c 00             	add    %cl,(%eax,%eax,1)
     2da:	00 00                	add    %al,(%eax)
     2dc:	00 00                	add    %al,(%eax)
     2de:	00 00                	add    %al,(%eax)
     2e0:	44                   	inc    %esp
     2e1:	00 14 00             	add    %dl,(%eax,%eax,1)
     2e4:	13 00                	adc    (%eax),%eax
     2e6:	00 00                	add    %al,(%eax)
     2e8:	00 00                	add    %al,(%eax)
     2ea:	00 00                	add    %al,(%eax)
     2ec:	44                   	inc    %esp
     2ed:	00 15 00 1f 00 00    	add    %dl,0x1f00
     2f3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     2f9:	00 00                	add    %al,(%eax)
     2fb:	00 24 00             	add    %ah,(%eax,%eax,1)
     2fe:	28 00                	sub    %al,(%eax)
     300:	00 00                	add    %al,(%eax)
     302:	00 00                	add    %al,(%eax)
     304:	44                   	inc    %esp
     305:	00 3e                	add    %bh,(%esi)
     307:	00 24 00             	add    %ah,(%eax,%eax,1)
     30a:	00 00                	add    %al,(%eax)
     30c:	01 00                	add    %eax,(%eax)
     30e:	00 00                	add    %al,(%eax)
     310:	84 00                	test   %al,(%eax)
     312:	00 00                	add    %al,(%eax)
     314:	25 00 28 00 00       	and    $0x2800,%eax
     319:	00 00                	add    %al,(%eax)
     31b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
     31f:	00 25 00 00 00 00    	add    %ah,0x0
     325:	00 00                	add    %al,(%eax)
     327:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
     32b:	00 2a                	add    %ch,(%edx)
     32d:	00 00                	add    %al,(%eax)
     32f:	00 00                	add    %al,(%eax)
     331:	00 00                	add    %al,(%eax)
     333:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
     337:	00 2f                	add    %ch,(%edi)
     339:	00 00                	add    %al,(%eax)
     33b:	00 00                	add    %al,(%eax)
     33d:	00 00                	add    %al,(%eax)
     33f:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
     343:	00 45 00             	add    %al,0x0(%ebp)
     346:	00 00                	add    %al,(%eax)
     348:	ae                   	scas   %es:(%edi),%al
     349:	02 00                	add    (%eax),%al
     34b:	00 84 00 00 00 5e 00 	add    %al,0x5e0000(%eax,%eax,1)
     352:	28 00                	sub    %al,(%eax)
     354:	00 00                	add    %al,(%eax)
     356:	00 00                	add    %al,(%eax)
     358:	44                   	inc    %esp
     359:	00 6c 00 5e          	add    %ch,0x5e(%eax,%eax,1)
     35d:	00 00                	add    %al,(%eax)
     35f:	00 01                	add    %al,(%ecx)
     361:	00 00                	add    %al,(%eax)
     363:	00 84 00 00 00 6b 00 	add    %al,0x6b0000(%eax,%eax,1)
     36a:	28 00                	sub    %al,(%eax)
     36c:	00 00                	add    %al,(%eax)
     36e:	00 00                	add    %al,(%eax)
     370:	44                   	inc    %esp
     371:	00 34 00             	add    %dh,(%eax,%eax,1)
     374:	6b 00 00             	imul   $0x0,(%eax),%eax
     377:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     37d:	00 00                	add    %al,(%eax)
     37f:	00 70 00             	add    %dh,0x0(%eax)
     382:	28 00                	sub    %al,(%eax)
     384:	00 00                	add    %al,(%eax)
     386:	00 00                	add    %al,(%eax)
     388:	44                   	inc    %esp
     389:	00 37                	add    %dh,(%edi)
     38b:	00 70 00             	add    %dh,0x0(%eax)
     38e:	00 00                	add    %al,(%eax)
     390:	01 00                	add    %eax,(%eax)
     392:	00 00                	add    %al,(%eax)
     394:	84 00                	test   %al,(%eax)
     396:	00 00                	add    %al,(%eax)
     398:	71 00                	jno    39a <bootmain-0x27fc66>
     39a:	28 00                	sub    %al,(%eax)
     39c:	00 00                	add    %al,(%eax)
     39e:	00 00                	add    %al,(%eax)
     3a0:	44                   	inc    %esp
     3a1:	00 3a                	add    %bh,(%edx)
     3a3:	00 71 00             	add    %dh,0x0(%ecx)
     3a6:	00 00                	add    %al,(%eax)
     3a8:	00 00                	add    %al,(%eax)
     3aa:	00 00                	add    %al,(%eax)
     3ac:	44                   	inc    %esp
     3ad:	00 3e                	add    %bh,(%esi)
     3af:	00 85 00 00 00 00    	add    %al,0x0(%ebp)
     3b5:	00 00                	add    %al,(%eax)
     3b7:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
     3bb:	00 93 00 00 00 00    	add    %dl,0x0(%ebx)
     3c1:	00 00                	add    %al,(%eax)
     3c3:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
     3c7:	00 9a 00 00 00 00    	add    %bl,0x0(%edx)
     3cd:	00 00                	add    %al,(%eax)
     3cf:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
     3d3:	00 9c 00 00 00 00 00 	add    %bl,0x0(%eax,%eax,1)
     3da:	00 00                	add    %al,(%eax)
     3dc:	44                   	inc    %esp
     3dd:	00 45 00             	add    %al,0x0(%ebp)
     3e0:	a1 00 00 00 00       	mov    0x0,%eax
     3e5:	00 00                	add    %al,(%eax)
     3e7:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     3eb:	00 ba 00 00 00 00    	add    %bh,0x0(%edx)
     3f1:	00 00                	add    %al,(%eax)
     3f3:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
     3f7:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     3fd:	00 00                	add    %al,(%eax)
     3ff:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
     403:	00 ce                	add    %cl,%dh
     405:	00 00                	add    %al,(%eax)
     407:	00 00                	add    %al,(%eax)
     409:	00 00                	add    %al,(%eax)
     40b:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
     40f:	00 cf                	add    %cl,%bh
     411:	00 00                	add    %al,(%eax)
     413:	00 00                	add    %al,(%eax)
     415:	00 00                	add    %al,(%eax)
     417:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
     41b:	00 d1                	add    %dl,%cl
     41d:	00 00                	add    %al,(%eax)
     41f:	00 00                	add    %al,(%eax)
     421:	00 00                	add    %al,(%eax)
     423:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
     427:	00 e1                	add    %ah,%cl
     429:	00 00                	add    %al,(%eax)
     42b:	00 00                	add    %al,(%eax)
     42d:	00 00                	add    %al,(%eax)
     42f:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
     433:	00 e4                	add    %ah,%ah
     435:	00 00                	add    %al,(%eax)
     437:	00 00                	add    %al,(%eax)
     439:	00 00                	add    %al,(%eax)
     43b:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
     43f:	00 e6                	add    %ah,%dh
     441:	00 00                	add    %al,(%eax)
     443:	00 00                	add    %al,(%eax)
     445:	00 00                	add    %al,(%eax)
     447:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
     44b:	00 eb                	add    %ch,%bl
     44d:	00 00                	add    %al,(%eax)
     44f:	00 00                	add    %al,(%eax)
     451:	00 00                	add    %al,(%eax)
     453:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
     457:	00 03                	add    %al,(%ebx)
     459:	01 00                	add    %eax,(%eax)
     45b:	00 00                	add    %al,(%eax)
     45d:	00 00                	add    %al,(%eax)
     45f:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     463:	00 1a                	add    %bl,(%edx)
     465:	01 00                	add    %eax,(%eax)
     467:	00 00                	add    %al,(%eax)
     469:	00 00                	add    %al,(%eax)
     46b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     46f:	00 20                	add    %ah,(%eax)
     471:	01 00                	add    %eax,(%eax)
     473:	00 00                	add    %al,(%eax)
     475:	00 00                	add    %al,(%eax)
     477:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     47b:	00 2c 01             	add    %ch,(%ecx,%eax,1)
     47e:	00 00                	add    %al,(%eax)
     480:	00 00                	add    %al,(%eax)
     482:	00 00                	add    %al,(%eax)
     484:	44                   	inc    %esp
     485:	00 52 00             	add    %dl,0x0(%edx)
     488:	45                   	inc    %ebp
     489:	01 00                	add    %eax,(%eax)
     48b:	00 00                	add    %al,(%eax)
     48d:	00 00                	add    %al,(%eax)
     48f:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
     493:	00 5d 01             	add    %bl,0x1(%ebp)
     496:	00 00                	add    %al,(%eax)
     498:	00 00                	add    %al,(%eax)
     49a:	00 00                	add    %al,(%eax)
     49c:	44                   	inc    %esp
     49d:	00 59 00             	add    %bl,0x0(%ecx)
     4a0:	80 01 00             	addb   $0x0,(%ecx)
     4a3:	00 00                	add    %al,(%eax)
     4a5:	00 00                	add    %al,(%eax)
     4a7:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
     4ab:	00 83 01 00 00 00    	add    %al,0x1(%ebx)
     4b1:	00 00                	add    %al,(%eax)
     4b3:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
     4b7:	00 85 01 00 00 00    	add    %al,0x1(%ebp)
     4bd:	00 00                	add    %al,(%eax)
     4bf:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
     4c3:	00 8a 01 00 00 00    	add    %cl,0x1(%edx)
     4c9:	00 00                	add    %al,(%eax)
     4cb:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
     4cf:	00 8d 01 00 00 00    	add    %cl,0x1(%ebp)
     4d5:	00 00                	add    %al,(%eax)
     4d7:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
     4db:	00 93 01 00 00 00    	add    %dl,0x1(%ebx)
     4e1:	00 00                	add    %al,(%eax)
     4e3:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     4e7:	00 98 01 00 00 00    	add    %bl,0x1(%eax)
     4ed:	00 00                	add    %al,(%eax)
     4ef:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
     4f3:	00 9b 01 00 00 00    	add    %bl,0x1(%ebx)
     4f9:	00 00                	add    %al,(%eax)
     4fb:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     4ff:	00 a1 01 00 00 00    	add    %ah,0x1(%ecx)
     505:	00 00                	add    %al,(%eax)
     507:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
     50b:	00 a6 01 00 00 00    	add    %ah,0x1(%esi)
     511:	00 00                	add    %al,(%eax)
     513:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     517:	00 bf 01 00 00 00    	add    %bh,0x1(%edi)
     51d:	00 00                	add    %al,(%eax)
     51f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
     523:	00 c5                	add    %al,%ch
     525:	01 00                	add    %eax,(%eax)
     527:	00 00                	add    %al,(%eax)
     529:	00 00                	add    %al,(%eax)
     52b:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
     52f:	00 ca                	add    %cl,%dl
     531:	01 00                	add    %eax,(%eax)
     533:	00 00                	add    %al,(%eax)
     535:	00 00                	add    %al,(%eax)
     537:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
     53b:	00 e5                	add    %ah,%ch
     53d:	01 00                	add    %eax,(%eax)
     53f:	00 00                	add    %al,(%eax)
     541:	00 00                	add    %al,(%eax)
     543:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     547:	00 02                	add    %al,(%edx)
     549:	02 00                	add    (%eax),%al
     54b:	00 00                	add    %al,(%eax)
     54d:	00 00                	add    %al,(%eax)
     54f:	00 44 00 6d          	add    %al,0x6d(%eax,%eax,1)
     553:	00 0f                	add    %cl,(%edi)
     555:	02 00                	add    (%eax),%al
     557:	00 00                	add    %al,(%eax)
     559:	00 00                	add    %al,(%eax)
     55b:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
     55f:	00 21                	add    %ah,(%ecx)
     561:	02 00                	add    (%eax),%al
     563:	00 00                	add    %al,(%eax)
     565:	00 00                	add    %al,(%eax)
     567:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     56b:	00 33                	add    %dh,(%ebx)
     56d:	02 00                	add    (%eax),%al
     56f:	00 00                	add    %al,(%eax)
     571:	00 00                	add    %al,(%eax)
     573:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     577:	00 3d 02 00 00 00    	add    %bh,0x2
     57d:	00 00                	add    %al,(%eax)
     57f:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     583:	00 4c 02 00          	add    %cl,0x0(%edx,%eax,1)
     587:	00 00                	add    %al,(%eax)
     589:	00 00                	add    %al,(%eax)
     58b:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
     58f:	00 5b 02             	add    %bl,0x2(%ebx)
     592:	00 00                	add    %al,(%eax)
     594:	00 00                	add    %al,(%eax)
     596:	00 00                	add    %al,(%eax)
     598:	44                   	inc    %esp
     599:	00 6b 00             	add    %ch,0x0(%ebx)
     59c:	72 02                	jb     5a0 <bootmain-0x27fa60>
     59e:	00 00                	add    %al,(%eax)
     5a0:	00 00                	add    %al,(%eax)
     5a2:	00 00                	add    %al,(%eax)
     5a4:	44                   	inc    %esp
     5a5:	00 75 00             	add    %dh,0x0(%ebp)
     5a8:	74 02                	je     5ac <bootmain-0x27fa54>
     5aa:	00 00                	add    %al,(%eax)
     5ac:	00 00                	add    %al,(%eax)
     5ae:	00 00                	add    %al,(%eax)
     5b0:	44                   	inc    %esp
     5b1:	00 97 00 79 02 00    	add    %dl,0x27900(%edi)
     5b7:	00 00                	add    %al,(%eax)
     5b9:	00 00                	add    %al,(%eax)
     5bb:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
     5bf:	00 7f 02             	add    %bh,0x2(%edi)
     5c2:	00 00                	add    %al,(%eax)
     5c4:	00 00                	add    %al,(%eax)
     5c6:	00 00                	add    %al,(%eax)
     5c8:	44                   	inc    %esp
     5c9:	00 77 00             	add    %dh,0x0(%edi)
     5cc:	82                   	(bad)  
     5cd:	02 00                	add    (%eax),%al
     5cf:	00 00                	add    %al,(%eax)
     5d1:	00 00                	add    %al,(%eax)
     5d3:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
     5d7:	00 8c 02 00 00 00 00 	add    %cl,0x0(%edx,%eax,1)
     5de:	00 00                	add    %al,(%eax)
     5e0:	44                   	inc    %esp
     5e1:	00 97 00 96 02 00    	add    %dl,0x29600(%edi)
     5e7:	00 00                	add    %al,(%eax)
     5e9:	00 00                	add    %al,(%eax)
     5eb:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
     5ef:	00 9c 02 00 00 00 00 	add    %bl,0x0(%edx,%eax,1)
     5f6:	00 00                	add    %al,(%eax)
     5f8:	44                   	inc    %esp
     5f9:	00 7b 00             	add    %bh,0x0(%ebx)
     5fc:	b4 02                	mov    $0x2,%ah
     5fe:	00 00                	add    %al,(%eax)
     600:	00 00                	add    %al,(%eax)
     602:	00 00                	add    %al,(%eax)
     604:	44                   	inc    %esp
     605:	00 7e 00             	add    %bh,0x0(%esi)
     608:	ba 02 00 00 00       	mov    $0x2,%edx
     60d:	00 00                	add    %al,(%eax)
     60f:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     613:	00 bf 02 00 00 00    	add    %bh,0x2(%edi)
     619:	00 00                	add    %al,(%eax)
     61b:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
     61f:	00 d3                	add    %dl,%bl
     621:	02 00                	add    (%eax),%al
     623:	00 00                	add    %al,(%eax)
     625:	00 00                	add    %al,(%eax)
     627:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
     62b:	00 f3                	add    %dh,%bl
     62d:	02 00                	add    (%eax),%al
     62f:	00 00                	add    %al,(%eax)
     631:	00 00                	add    %al,(%eax)
     633:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
     637:	00 0d 03 00 00 ae    	add    %cl,0xae000003
     63d:	02 00                	add    (%eax),%al
     63f:	00 84 00 00 00 26 03 	add    %al,0x3260000(%eax,%eax,1)
     646:	28 00                	sub    %al,(%eax)
     648:	00 00                	add    %al,(%eax)
     64a:	00 00                	add    %al,(%eax)
     64c:	44                   	inc    %esp
     64d:	00 3e                	add    %bh,(%esi)
     64f:	00 26                	add    %ah,(%esi)
     651:	03 00                	add    (%eax),%eax
     653:	00 01                	add    %al,(%ecx)
     655:	00 00                	add    %al,(%eax)
     657:	00 84 00 00 00 27 03 	add    %al,0x3270000(%eax,%eax,1)
     65e:	28 00                	sub    %al,(%eax)
     660:	00 00                	add    %al,(%eax)
     662:	00 00                	add    %al,(%eax)
     664:	44                   	inc    %esp
     665:	00 85 00 27 03 00    	add    %al,0x32700(%ebp)
     66b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     671:	00 00                	add    %al,(%eax)
     673:	00 53 03             	add    %dl,0x3(%ebx)
     676:	28 00                	sub    %al,(%eax)
     678:	00 00                	add    %al,(%eax)
     67a:	00 00                	add    %al,(%eax)
     67c:	44                   	inc    %esp
     67d:	00 37                	add    %dh,(%edi)
     67f:	00 53 03             	add    %dl,0x3(%ebx)
     682:	00 00                	add    %al,(%eax)
     684:	01 00                	add    %eax,(%eax)
     686:	00 00                	add    %al,(%eax)
     688:	84 00                	test   %al,(%eax)
     68a:	00 00                	add    %al,(%eax)
     68c:	59                   	pop    %ecx
     68d:	03 28                	add    (%eax),%ebp
     68f:	00 00                	add    %al,(%eax)
     691:	00 00                	add    %al,(%eax)
     693:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
     697:	00 59 03             	add    %bl,0x3(%ecx)
     69a:	00 00                	add    %al,(%eax)
     69c:	00 00                	add    %al,(%eax)
     69e:	00 00                	add    %al,(%eax)
     6a0:	44                   	inc    %esp
     6a1:	00 90 00 6d 03 00    	add    %dl,0x36d00(%eax)
     6a7:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     6ad:	00 00                	add    %al,(%eax)
     6af:	00 7a 03             	add    %bh,0x3(%edx)
     6b2:	28 00                	sub    %al,(%eax)
     6b4:	00 00                	add    %al,(%eax)
     6b6:	00 00                	add    %al,(%eax)
     6b8:	44                   	inc    %esp
     6b9:	00 37                	add    %dh,(%edi)
     6bb:	00 7a 03             	add    %bh,0x3(%edx)
     6be:	00 00                	add    %al,(%eax)
     6c0:	01 00                	add    %eax,(%eax)
     6c2:	00 00                	add    %al,(%eax)
     6c4:	84 00                	test   %al,(%eax)
     6c6:	00 00                	add    %al,(%eax)
     6c8:	80 03 28             	addb   $0x28,(%ebx)
     6cb:	00 00                	add    %al,(%eax)
     6cd:	00 00                	add    %al,(%eax)
     6cf:	00 44 00 93          	add    %al,-0x6d(%eax,%eax,1)
     6d3:	00 80 03 00 00 00    	add    %al,0x3(%eax)
     6d9:	00 00                	add    %al,(%eax)
     6db:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
     6df:	00 98 03 00 00 ae    	add    %bl,-0x51fffffd(%eax)
     6e5:	02 00                	add    (%eax),%al
     6e7:	00 84 00 00 00 a5 03 	add    %al,0x3a50000(%eax,%eax,1)
     6ee:	28 00                	sub    %al,(%eax)
     6f0:	00 00                	add    %al,(%eax)
     6f2:	00 00                	add    %al,(%eax)
     6f4:	44                   	inc    %esp
     6f5:	00 37                	add    %dh,(%edi)
     6f7:	00 a5 03 00 00 01    	add    %ah,0x1000003(%ebp)
     6fd:	00 00                	add    %al,(%eax)
     6ff:	00 84 00 00 00 a6 03 	add    %al,0x3a60000(%eax,%eax,1)
     706:	28 00                	sub    %al,(%eax)
     708:	00 00                	add    %al,(%eax)
     70a:	00 00                	add    %al,(%eax)
     70c:	44                   	inc    %esp
     70d:	00 97 00 a6 03 00    	add    %dl,0x3a600(%edi)
     713:	00 00                	add    %al,(%eax)
     715:	00 00                	add    %al,(%eax)
     717:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
     71b:	00 c2                	add    %al,%dl
     71d:	03 00                	add    (%eax),%eax
     71f:	00 00                	add    %al,(%eax)
     721:	00 00                	add    %al,(%eax)
     723:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
     727:	00 d5                	add    %dl,%ch
     729:	03 00                	add    (%eax),%eax
     72b:	00 00                	add    %al,(%eax)
     72d:	00 00                	add    %al,(%eax)
     72f:	00 44 00 9d          	add    %al,-0x63(%eax,%eax,1)
     733:	00 de                	add    %bl,%dh
     735:	03 00                	add    (%eax),%eax
     737:	00 00                	add    %al,(%eax)
     739:	00 00                	add    %al,(%eax)
     73b:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
     73f:	00 e7                	add    %ah,%bh
     741:	03 00                	add    (%eax),%eax
     743:	00 00                	add    %al,(%eax)
     745:	00 00                	add    %al,(%eax)
     747:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
     74b:	00 ee                	add    %ch,%dh
     74d:	03 00                	add    (%eax),%eax
     74f:	00 00                	add    %al,(%eax)
     751:	00 00                	add    %al,(%eax)
     753:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
     757:	00 05 04 00 00 00    	add    %al,0x4
     75d:	00 00                	add    %al,(%eax)
     75f:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
     763:	00 20                	add    %ah,(%eax)
     765:	04 00                	add    $0x0,%al
     767:	00 00                	add    %al,(%eax)
     769:	00 00                	add    %al,(%eax)
     76b:	00 44 00 a3          	add    %al,-0x5d(%eax,%eax,1)
     76f:	00 38                	add    %bh,(%eax)
     771:	04 00                	add    $0x0,%al
     773:	00 00                	add    %al,(%eax)
     775:	00 00                	add    %al,(%eax)
     777:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
     77b:	00 74 04 00          	add    %dh,0x0(%esp,%eax,1)
     77f:	00 00                	add    %al,(%eax)
     781:	00 00                	add    %al,(%eax)
     783:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
     787:	00 7b 04             	add    %bh,0x4(%ebx)
     78a:	00 00                	add    %al,(%eax)
     78c:	00 00                	add    %al,(%eax)
     78e:	00 00                	add    %al,(%eax)
     790:	44                   	inc    %esp
     791:	00 b8 00 80 04 00    	add    %bh,0x48000(%eax)
     797:	00 00                	add    %al,(%eax)
     799:	00 00                	add    %al,(%eax)
     79b:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
     79f:	00 87 04 00 00 00    	add    %al,0x4(%edi)
     7a5:	00 00                	add    %al,(%eax)
     7a7:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
     7ab:	00 8a 04 00 00 00    	add    %cl,0x4(%edx)
     7b1:	00 00                	add    %al,(%eax)
     7b3:	00 44 00 bc          	add    %al,-0x44(%eax,%eax,1)
     7b7:	00 92 04 00 00 00    	add    %dl,0x4(%edx)
     7bd:	00 00                	add    %al,(%eax)
     7bf:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
     7c3:	00 9a 04 00 00 00    	add    %bl,0x4(%edx)
     7c9:	00 00                	add    %al,(%eax)
     7cb:	00 44 00 bc          	add    %al,-0x44(%eax,%eax,1)
     7cf:	00 a0 04 00 00 00    	add    %ah,0x4(%eax)
     7d5:	00 00                	add    %al,(%eax)
     7d7:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
     7db:	00 a5 04 00 00 00    	add    %ah,0x4(%ebp)
     7e1:	00 00                	add    %al,(%eax)
     7e3:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
     7e7:	00 bd 04 00 00 00    	add    %bh,0x4(%ebp)
     7ed:	00 00                	add    %al,(%eax)
     7ef:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
     7f3:	00 d5                	add    %dl,%ch
     7f5:	04 00                	add    $0x0,%al
     7f7:	00 00                	add    %al,(%eax)
     7f9:	00 00                	add    %al,(%eax)
     7fb:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
     7ff:	00 f1                	add    %dh,%cl
     801:	04 00                	add    $0x0,%al
     803:	00 a7 09 00 00 80    	add    %ah,-0x7ffffff7(%edi)
     809:	00 00                	add    %al,(%eax)
     80b:	00 f8                	add    %bh,%al
     80d:	fe                   	(bad)  
     80e:	ff                   	(bad)  
     80f:	ff cb                	dec    %ebx
     811:	09 00                	or     %eax,(%eax)
     813:	00 80 00 00 00 50    	add    %al,0x50000000(%eax)
     819:	fe                   	(bad)  
     81a:	ff                   	(bad)  
     81b:	ff                   	(bad)  
     81c:	e8 09 00 00 80       	call   8000082a <mousefifo+0x7fd7c9f2>
     821:	00 00                	add    %al,(%eax)
     823:	00 30                	add    %dh,(%eax)
     825:	fe                   	(bad)  
     826:	ff                   	(bad)  
     827:	ff 0a                	decl   (%edx)
     829:	0a 00                	or     (%eax),%al
     82b:	00 80 00 00 00 78    	add    %al,0x78000000(%eax)
     831:	fe                   	(bad)  
     832:	ff                   	(bad)  
     833:	ff 2f                	ljmp   *(%edi)
     835:	0a 00                	or     (%eax),%al
     837:	00 80 00 00 00 20    	add    %al,0x20000000(%eax)
     83d:	fe                   	(bad)  
     83e:	ff                   	(bad)  
     83f:	ff                   	(bad)  
     840:	3a 0a                	cmp    (%edx),%cl
     842:	00 00                	add    %al,(%eax)
     844:	40                   	inc    %eax
     845:	00 00                	add    %al,(%eax)
     847:	00 06                	add    %al,(%esi)
     849:	00 00                	add    %al,(%eax)
     84b:	00 4a 0a             	add    %cl,0xa(%edx)
     84e:	00 00                	add    %al,(%eax)
     850:	40                   	inc    %eax
     851:	00 00                	add    %al,(%eax)
     853:	00 03                	add    %al,(%ebx)
     855:	00 00                	add    %al,(%eax)
     857:	00 00                	add    %al,(%eax)
     859:	00 00                	add    %al,(%eax)
     85b:	00 c0                	add    %al,%al
	...
     865:	00 00                	add    %al,(%eax)
     867:	00 e0                	add    %ah,%al
     869:	00 00                	add    %al,(%eax)
     86b:	00 0e                	add    %cl,(%esi)
     86d:	05 00 00 59 0a       	add    $0xa590000,%eax
     872:	00 00                	add    %al,(%eax)
     874:	20 00                	and    %al,(%eax)
     876:	00 00                	add    %al,(%eax)
     878:	00 00                	add    %al,(%eax)
     87a:	00 00                	add    %al,(%eax)
     87c:	82                   	(bad)  
     87d:	0a 00                	or     (%eax),%al
     87f:	00 20                	add    %ah,(%eax)
	...
     889:	00 00                	add    %al,(%eax)
     88b:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
     88f:	00 0e                	add    %cl,(%esi)
     891:	05 28 00 a9 0a       	add    $0xaa90028,%eax
     896:	00 00                	add    %al,(%eax)
     898:	64 00 02             	add    %al,%fs:(%edx)
     89b:	00 0e                	add    %cl,(%esi)
     89d:	05 28 00 08 00       	add    $0x80028,%eax
     8a2:	00 00                	add    %al,(%eax)
     8a4:	3c 00                	cmp    $0x0,%al
     8a6:	00 00                	add    %al,(%eax)
     8a8:	00 00                	add    %al,(%eax)
     8aa:	00 00                	add    %al,(%eax)
     8ac:	17                   	pop    %ss
     8ad:	00 00                	add    %al,(%eax)
     8af:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     8b5:	00 00                	add    %al,(%eax)
     8b7:	00 41 00             	add    %al,0x0(%ecx)
     8ba:	00 00                	add    %al,(%eax)
     8bc:	80 00 00             	addb   $0x0,(%eax)
     8bf:	00 00                	add    %al,(%eax)
     8c1:	00 00                	add    %al,(%eax)
     8c3:	00 5b 00             	add    %bl,0x0(%ebx)
     8c6:	00 00                	add    %al,(%eax)
     8c8:	80 00 00             	addb   $0x0,(%eax)
     8cb:	00 00                	add    %al,(%eax)
     8cd:	00 00                	add    %al,(%eax)
     8cf:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     8d5:	00 00                	add    %al,(%eax)
     8d7:	00 00                	add    %al,(%eax)
     8d9:	00 00                	add    %al,(%eax)
     8db:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     8e1:	00 00                	add    %al,(%eax)
     8e3:	00 00                	add    %al,(%eax)
     8e5:	00 00                	add    %al,(%eax)
     8e7:	00 e1                	add    %ah,%cl
     8e9:	00 00                	add    %al,(%eax)
     8eb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     8f1:	00 00                	add    %al,(%eax)
     8f3:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     8f6:	00 00                	add    %al,(%eax)
     8f8:	80 00 00             	addb   $0x0,(%eax)
     8fb:	00 00                	add    %al,(%eax)
     8fd:	00 00                	add    %al,(%eax)
     8ff:	00 37                	add    %dh,(%edi)
     901:	01 00                	add    %eax,(%eax)
     903:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     909:	00 00                	add    %al,(%eax)
     90b:	00 5d 01             	add    %bl,0x1(%ebp)
     90e:	00 00                	add    %al,(%eax)
     910:	80 00 00             	addb   $0x0,(%eax)
     913:	00 00                	add    %al,(%eax)
     915:	00 00                	add    %al,(%eax)
     917:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     91d:	00 00                	add    %al,(%eax)
     91f:	00 00                	add    %al,(%eax)
     921:	00 00                	add    %al,(%eax)
     923:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     929:	00 00                	add    %al,(%eax)
     92b:	00 00                	add    %al,(%eax)
     92d:	00 00                	add    %al,(%eax)
     92f:	00 d2                	add    %dl,%dl
     931:	01 00                	add    %eax,(%eax)
     933:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     939:	00 00                	add    %al,(%eax)
     93b:	00 ec                	add    %ch,%ah
     93d:	01 00                	add    %eax,(%eax)
     93f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     945:	00 00                	add    %al,(%eax)
     947:	00 07                	add    %al,(%edi)
     949:	02 00                	add    (%eax),%al
     94b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     951:	00 00                	add    %al,(%eax)
     953:	00 28                	add    %ch,(%eax)
     955:	02 00                	add    (%eax),%al
     957:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     95d:	00 00                	add    %al,(%eax)
     95f:	00 47 02             	add    %al,0x2(%edi)
     962:	00 00                	add    %al,(%eax)
     964:	80 00 00             	addb   $0x0,(%eax)
     967:	00 00                	add    %al,(%eax)
     969:	00 00                	add    %al,(%eax)
     96b:	00 66 02             	add    %ah,0x2(%esi)
     96e:	00 00                	add    %al,(%eax)
     970:	80 00 00             	addb   $0x0,(%eax)
     973:	00 00                	add    %al,(%eax)
     975:	00 00                	add    %al,(%eax)
     977:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     97d:	00 00                	add    %al,(%eax)
     97f:	00 00                	add    %al,(%eax)
     981:	00 00                	add    %al,(%eax)
     983:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     989:	00 00                	add    %al,(%eax)
     98b:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
     991:	02 00                	add    (%eax),%al
     993:	00 c2                	add    %al,%dl
     995:	00 00                	add    %al,(%eax)
     997:	00 00                	add    %al,(%eax)
     999:	00 00                	add    %al,(%eax)
     99b:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
     9a1:	00 00                	add    %al,(%eax)
     9a3:	00 37                	add    %dh,(%edi)
     9a5:	53                   	push   %ebx
     9a6:	00 00                	add    %al,(%eax)
     9a8:	29 04 00             	sub    %eax,(%eax,%eax,1)
     9ab:	00 c2                	add    %al,%dl
     9ad:	00 00                	add    %al,(%eax)
     9af:	00 17                	add    %dl,(%edi)
     9b1:	a4                   	movsb  %ds:(%esi),%es:(%edi)
     9b2:	00 00                	add    %al,(%eax)
     9b4:	b2 0a                	mov    $0xa,%dl
     9b6:	00 00                	add    %al,(%eax)
     9b8:	24 00                	and    $0x0,%al
     9ba:	00 00                	add    %al,(%eax)
     9bc:	0e                   	push   %cs
     9bd:	05 28 00 c7 0a       	add    $0xac70028,%eax
     9c2:	00 00                	add    %al,(%eax)
     9c4:	a0 00 00 00 08       	mov    0x8000000,%al
     9c9:	00 00                	add    %al,(%eax)
     9cb:	00 00                	add    %al,(%eax)
     9cd:	00 00                	add    %al,(%eax)
     9cf:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
	...
     9db:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     9df:	00 01                	add    %al,(%ecx)
     9e1:	00 00                	add    %al,(%eax)
     9e3:	00 00                	add    %al,(%eax)
     9e5:	00 00                	add    %al,(%eax)
     9e7:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     9eb:	00 06                	add    %al,(%esi)
     9ed:	00 00                	add    %al,(%eax)
     9ef:	00 00                	add    %al,(%eax)
     9f1:	00 00                	add    %al,(%eax)
     9f3:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     9f7:	00 08                	add    %cl,(%eax)
     9f9:	00 00                	add    %al,(%eax)
     9fb:	00 00                	add    %al,(%eax)
     9fd:	00 00                	add    %al,(%eax)
     9ff:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
     a03:	00 0b                	add    %cl,(%ebx)
     a05:	00 00                	add    %al,(%eax)
     a07:	00 00                	add    %al,(%eax)
     a09:	00 00                	add    %al,(%eax)
     a0b:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     a0f:	00 0d 00 00 00 00    	add    %cl,0x0
     a15:	00 00                	add    %al,(%eax)
     a17:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
     a1b:	00 15 00 00 00 d4    	add    %dl,0xd4000000
     a21:	0a 00                	or     (%eax),%al
     a23:	00 40 00             	add    %al,0x0(%eax)
     a26:	00 00                	add    %al,(%eax)
     a28:	00 00                	add    %al,(%eax)
     a2a:	00 00                	add    %al,(%eax)
     a2c:	dd 0a                	fisttpll (%edx)
     a2e:	00 00                	add    %al,(%eax)
     a30:	40                   	inc    %eax
     a31:	00 00                	add    %al,(%eax)
     a33:	00 02                	add    %al,(%edx)
     a35:	00 00                	add    %al,(%eax)
     a37:	00 00                	add    %al,(%eax)
     a39:	00 00                	add    %al,(%eax)
     a3b:	00 c0                	add    %al,%al
	...
     a45:	00 00                	add    %al,(%eax)
     a47:	00 e0                	add    %ah,%al
     a49:	00 00                	add    %al,(%eax)
     a4b:	00 17                	add    %dl,(%edi)
     a4d:	00 00                	add    %al,(%eax)
     a4f:	00 ea                	add    %ch,%dl
     a51:	0a 00                	or     (%eax),%al
     a53:	00 24 00             	add    %ah,(%eax,%eax,1)
     a56:	00 00                	add    %al,(%eax)
     a58:	25 05 28 00 c7       	and    $0xc7002805,%eax
     a5d:	0a 00                	or     (%eax),%al
     a5f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     a65:	00 00                	add    %al,(%eax)
     a67:	00 00                	add    %al,(%eax)
     a69:	00 00                	add    %al,(%eax)
     a6b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
	...
     a77:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     a7b:	00 01                	add    %al,(%ecx)
     a7d:	00 00                	add    %al,(%eax)
     a7f:	00 00                	add    %al,(%eax)
     a81:	00 00                	add    %al,(%eax)
     a83:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
     a87:	00 06                	add    %al,(%esi)
     a89:	00 00                	add    %al,(%eax)
     a8b:	00 00                	add    %al,(%eax)
     a8d:	00 00                	add    %al,(%eax)
     a8f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     a93:	00 08                	add    %cl,(%eax)
     a95:	00 00                	add    %al,(%eax)
     a97:	00 00                	add    %al,(%eax)
     a99:	00 00                	add    %al,(%eax)
     a9b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     a9f:	00 0a                	add    %cl,(%edx)
     aa1:	00 00                	add    %al,(%eax)
     aa3:	00 00                	add    %al,(%eax)
     aa5:	00 00                	add    %al,(%eax)
     aa7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     aab:	00 12                	add    %dl,(%edx)
     aad:	00 00                	add    %al,(%eax)
     aaf:	00 d4                	add    %dl,%ah
     ab1:	0a 00                	or     (%eax),%al
     ab3:	00 40 00             	add    %al,0x0(%eax)
	...
     abe:	00 00                	add    %al,(%eax)
     ac0:	c0 00 00             	rolb   $0x0,(%eax)
	...
     acb:	00 e0                	add    %ah,%al
     acd:	00 00                	add    %al,(%eax)
     acf:	00 14 00             	add    %dl,(%eax,%eax,1)
     ad2:	00 00                	add    %al,(%eax)
     ad4:	ff 0a                	decl   (%edx)
     ad6:	00 00                	add    %al,(%eax)
     ad8:	24 00                	and    $0x0,%al
     ada:	00 00                	add    %al,(%eax)
     adc:	39 05 28 00 13 0b    	cmp    %eax,0xb130028
     ae2:	00 00                	add    %al,(%eax)
     ae4:	a0 00 00 00 08       	mov    0x8000000,%al
     ae9:	00 00                	add    %al,(%eax)
     aeb:	00 20                	add    %ah,(%eax)
     aed:	0b 00                	or     (%eax),%eax
     aef:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
     af5:	00 00                	add    %al,(%eax)
     af7:	00 2b                	add    %ch,(%ebx)
     af9:	0b 00                	or     (%eax),%eax
     afb:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     b01:	00 00                	add    %al,(%eax)
     b03:	00 00                	add    %al,(%eax)
     b05:	00 00                	add    %al,(%eax)
     b07:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
	...
     b13:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     b17:	00 08                	add    %cl,(%eax)
     b19:	00 00                	add    %al,(%eax)
     b1b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     b21:	00 00                	add    %al,(%eax)
     b23:	00 44 05 28          	add    %al,0x28(%ebp,%eax,1)
     b27:	00 00                	add    %al,(%eax)
     b29:	00 00                	add    %al,(%eax)
     b2b:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
     b2f:	01 0b                	add    %ecx,(%ebx)
     b31:	00 00                	add    %al,(%eax)
     b33:	00 00                	add    %al,(%eax)
     b35:	00 00                	add    %al,(%eax)
     b37:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
     b3b:	00 0d 00 00 00 00    	add    %cl,0x0
     b41:	00 00                	add    %al,(%eax)
     b43:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     b47:	00 0e                	add    %cl,(%esi)
     b49:	00 00                	add    %al,(%eax)
     b4b:	00 a9 0a 00 00 84    	add    %ch,-0x7bfffff6(%ecx)
     b51:	00 00                	add    %al,(%eax)
     b53:	00 4c 05 28          	add    %cl,0x28(%ebp,%eax,1)
     b57:	00 00                	add    %al,(%eax)
     b59:	00 00                	add    %al,(%eax)
     b5b:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
     b5f:	00 13                	add    %dl,(%ebx)
     b61:	00 00                	add    %al,(%eax)
     b63:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     b69:	00 00                	add    %al,(%eax)
     b6b:	00 4f 05             	add    %cl,0x5(%edi)
     b6e:	28 00                	sub    %al,(%eax)
     b70:	00 00                	add    %al,(%eax)
     b72:	00 00                	add    %al,(%eax)
     b74:	44                   	inc    %esp
     b75:	00 6c 00 16          	add    %ch,0x16(%eax,%eax,1)
     b79:	00 00                	add    %al,(%eax)
     b7b:	00 a9 0a 00 00 84    	add    %ch,-0x7bfffff6(%ecx)
     b81:	00 00                	add    %al,(%eax)
     b83:	00 52 05             	add    %dl,0x5(%edx)
     b86:	28 00                	sub    %al,(%eax)
     b88:	00 00                	add    %al,(%eax)
     b8a:	00 00                	add    %al,(%eax)
     b8c:	44                   	inc    %esp
     b8d:	00 40 00             	add    %al,0x0(%eax)
     b90:	19 00                	sbb    %eax,(%eax)
     b92:	00 00                	add    %al,(%eax)
     b94:	00 00                	add    %al,(%eax)
     b96:	00 00                	add    %al,(%eax)
     b98:	44                   	inc    %esp
     b99:	00 42 00             	add    %al,0x0(%edx)
     b9c:	1e                   	push   %ds
     b9d:	00 00                	add    %al,(%eax)
     b9f:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     ba5:	00 00                	add    %al,(%eax)
     ba7:	00 5c 05 28          	add    %bl,0x28(%ebp,%eax,1)
     bab:	00 00                	add    %al,(%eax)
     bad:	00 00                	add    %al,(%eax)
     baf:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     bb3:	00 23                	add    %ah,(%ebx)
     bb5:	00 00                	add    %al,(%eax)
     bb7:	00 a9 0a 00 00 84    	add    %ch,-0x7bfffff6(%ecx)
     bbd:	00 00                	add    %al,(%eax)
     bbf:	00 5d 05             	add    %bl,0x5(%ebp)
     bc2:	28 00                	sub    %al,(%eax)
     bc4:	00 00                	add    %al,(%eax)
     bc6:	00 00                	add    %al,(%eax)
     bc8:	44                   	inc    %esp
     bc9:	00 43 00             	add    %al,0x0(%ebx)
     bcc:	24 00                	and    $0x0,%al
     bce:	00 00                	add    %al,(%eax)
     bd0:	ae                   	scas   %es:(%edi),%al
     bd1:	02 00                	add    (%eax),%al
     bd3:	00 84 00 00 00 63 05 	add    %al,0x5630000(%eax,%eax,1)
     bda:	28 00                	sub    %al,(%eax)
     bdc:	00 00                	add    %al,(%eax)
     bde:	00 00                	add    %al,(%eax)
     be0:	44                   	inc    %esp
     be1:	00 6c 00 2a          	add    %ch,0x2a(%eax,%eax,1)
     be5:	00 00                	add    %al,(%eax)
     be7:	00 a9 0a 00 00 84    	add    %ch,-0x7bfffff6(%ecx)
     bed:	00 00                	add    %al,(%eax)
     bef:	00 64 05 28          	add    %ah,0x28(%ebp,%eax,1)
     bf3:	00 00                	add    %al,(%eax)
     bf5:	00 00                	add    %al,(%eax)
     bf7:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     bfb:	00 2b                	add    %ch,(%ebx)
     bfd:	00 00                	add    %al,(%eax)
     bff:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     c05:	00 00                	add    %al,(%eax)
     c07:	00 6a 05             	add    %ch,0x5(%edx)
     c0a:	28 00                	sub    %al,(%eax)
     c0c:	00 00                	add    %al,(%eax)
     c0e:	00 00                	add    %al,(%eax)
     c10:	44                   	inc    %esp
     c11:	00 6c 00 31          	add    %ch,0x31(%eax,%eax,1)
     c15:	00 00                	add    %al,(%eax)
     c17:	00 a9 0a 00 00 84    	add    %ch,-0x7bfffff6(%ecx)
     c1d:	00 00                	add    %al,(%eax)
     c1f:	00 6b 05             	add    %ch,0x5(%ebx)
     c22:	28 00                	sub    %al,(%eax)
     c24:	00 00                	add    %al,(%eax)
     c26:	00 00                	add    %al,(%eax)
     c28:	44                   	inc    %esp
     c29:	00 45 00             	add    %al,0x0(%ebp)
     c2c:	32 00                	xor    (%eax),%al
     c2e:	00 00                	add    %al,(%eax)
     c30:	00 00                	add    %al,(%eax)
     c32:	00 00                	add    %al,(%eax)
     c34:	44                   	inc    %esp
     c35:	00 40 00             	add    %al,0x0(%eax)
     c38:	35 00 00 00 ae       	xor    $0xae000000,%eax
     c3d:	02 00                	add    (%eax),%al
     c3f:	00 84 00 00 00 71 05 	add    %al,0x5710000(%eax,%eax,1)
     c46:	28 00                	sub    %al,(%eax)
     c48:	00 00                	add    %al,(%eax)
     c4a:	00 00                	add    %al,(%eax)
     c4c:	44                   	inc    %esp
     c4d:	00 43 01             	add    %al,0x1(%ebx)
     c50:	38 00                	cmp    %al,(%eax)
     c52:	00 00                	add    %al,(%eax)
     c54:	a9 0a 00 00 84       	test   $0x8400000a,%eax
     c59:	00 00                	add    %al,(%eax)
     c5b:	00 73 05             	add    %dh,0x5(%ebx)
     c5e:	28 00                	sub    %al,(%eax)
     c60:	00 00                	add    %al,(%eax)
     c62:	00 00                	add    %al,(%eax)
     c64:	44                   	inc    %esp
     c65:	00 4b 00             	add    %cl,0x0(%ebx)
     c68:	3a 00                	cmp    (%eax),%al
     c6a:	00 00                	add    %al,(%eax)
     c6c:	36 0b 00             	or     %ss:(%eax),%eax
     c6f:	00 40 00             	add    %al,0x0(%eax)
     c72:	00 00                	add    %al,(%eax)
     c74:	03 00                	add    (%eax),%eax
     c76:	00 00                	add    %al,(%eax)
     c78:	43                   	inc    %ebx
     c79:	0b 00                	or     (%eax),%eax
     c7b:	00 40 00             	add    %al,0x0(%eax)
     c7e:	00 00                	add    %al,(%eax)
     c80:	01 00                	add    %eax,(%eax)
     c82:	00 00                	add    %al,(%eax)
     c84:	4e                   	dec    %esi
     c85:	0b 00                	or     (%eax),%eax
     c87:	00 24 00             	add    %ah,(%eax,%eax,1)
     c8a:	00 00                	add    %al,(%eax)
     c8c:	77 05                	ja     c93 <bootmain-0x27f36d>
     c8e:	28 00                	sub    %al,(%eax)
     c90:	00 00                	add    %al,(%eax)
     c92:	00 00                	add    %al,(%eax)
     c94:	44                   	inc    %esp
     c95:	00 1b                	add    %bl,(%ebx)
	...
     c9f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     ca3:	00 01                	add    %al,(%ecx)
     ca5:	00 00                	add    %al,(%eax)
     ca7:	00 00                	add    %al,(%eax)
     ca9:	00 00                	add    %al,(%eax)
     cab:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     caf:	00 06                	add    %al,(%esi)
     cb1:	00 00                	add    %al,(%eax)
     cb3:	00 00                	add    %al,(%eax)
     cb5:	00 00                	add    %al,(%eax)
     cb7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     cbb:	00 0a                	add    %cl,(%edx)
     cbd:	00 00                	add    %al,(%eax)
     cbf:	00 00                	add    %al,(%eax)
     cc1:	00 00                	add    %al,(%eax)
     cc3:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     cc7:	00 0f                	add    %cl,(%edi)
     cc9:	00 00                	add    %al,(%eax)
     ccb:	00 00                	add    %al,(%eax)
     ccd:	00 00                	add    %al,(%eax)
     ccf:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     cd3:	00 12                	add    %dl,(%edx)
     cd5:	00 00                	add    %al,(%eax)
     cd7:	00 00                	add    %al,(%eax)
     cd9:	00 00                	add    %al,(%eax)
     cdb:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     cdf:	00 15 00 00 00 00    	add    %dl,0x0
     ce5:	00 00                	add    %al,(%eax)
     ce7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     ceb:	00 1a                	add    %bl,(%edx)
     ced:	00 00                	add    %al,(%eax)
     cef:	00 00                	add    %al,(%eax)
     cf1:	00 00                	add    %al,(%eax)
     cf3:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
     cf7:	00 2a                	add    %ch,(%edx)
     cf9:	00 00                	add    %al,(%eax)
     cfb:	00 63 0b             	add    %ah,0xb(%ebx)
     cfe:	00 00                	add    %al,(%eax)
     d00:	80 00 00             	addb   $0x0,(%eax)
     d03:	00 d0                	add    %dl,%al
     d05:	ff                   	(bad)  
     d06:	ff                   	(bad)  
     d07:	ff 00                	incl   (%eax)
     d09:	00 00                	add    %al,(%eax)
     d0b:	00 c0                	add    %al,%al
	...
     d15:	00 00                	add    %al,(%eax)
     d17:	00 e0                	add    %ah,%al
     d19:	00 00                	add    %al,(%eax)
     d1b:	00 31                	add    %dh,(%ecx)
     d1d:	00 00                	add    %al,(%eax)
     d1f:	00 88 0b 00 00 24    	add    %cl,0x2400000b(%eax)
     d25:	00 00                	add    %al,(%eax)
     d27:	00 a8 05 28 00 99    	add    %ch,-0x66ffd7fb(%eax)
     d2d:	0b 00                	or     (%eax),%eax
     d2f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     d35:	00 00                	add    %al,(%eax)
     d37:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
     d3d:	00 00                	add    %al,(%eax)
     d3f:	00 0c 00             	add    %cl,(%eax,%eax,1)
     d42:	00 00                	add    %al,(%eax)
     d44:	c7                   	(bad)  
     d45:	0a 00                	or     (%eax),%al
     d47:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     d4d:	00 00                	add    %al,(%eax)
     d4f:	00 b2 0b 00 00 a0    	add    %dh,-0x5ffffff5(%edx)
     d55:	00 00                	add    %al,(%eax)
     d57:	00 14 00             	add    %dl,(%eax,%eax,1)
     d5a:	00 00                	add    %al,(%eax)
     d5c:	bc 0b 00 00 a0       	mov    $0xa000000b,%esp
     d61:	00 00                	add    %al,(%eax)
     d63:	00 18                	add    %bl,(%eax)
     d65:	00 00                	add    %al,(%eax)
     d67:	00 c6                	add    %al,%dh
     d69:	0b 00                	or     (%eax),%eax
     d6b:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
     d71:	00 00                	add    %al,(%eax)
     d73:	00 d0                	add    %dl,%al
     d75:	0b 00                	or     (%eax),%eax
     d77:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     d7d:	00 00                	add    %al,(%eax)
     d7f:	00 00                	add    %al,(%eax)
     d81:	00 00                	add    %al,(%eax)
     d83:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
	...
     d8f:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     d93:	00 0a                	add    %cl,(%edx)
     d95:	00 00                	add    %al,(%eax)
     d97:	00 00                	add    %al,(%eax)
     d99:	00 00                	add    %al,(%eax)
     d9b:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     d9f:	00 13                	add    %dl,(%ebx)
     da1:	00 00                	add    %al,(%eax)
     da3:	00 00                	add    %al,(%eax)
     da5:	00 00                	add    %al,(%eax)
     da7:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     dab:	00 18                	add    %bl,(%eax)
     dad:	00 00                	add    %al,(%eax)
     daf:	00 00                	add    %al,(%eax)
     db1:	00 00                	add    %al,(%eax)
     db3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     db7:	00 1b                	add    %bl,(%ebx)
     db9:	00 00                	add    %al,(%eax)
     dbb:	00 00                	add    %al,(%eax)
     dbd:	00 00                	add    %al,(%eax)
     dbf:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     dc3:	00 20                	add    %ah,(%eax)
     dc5:	00 00                	add    %al,(%eax)
     dc7:	00 00                	add    %al,(%eax)
     dc9:	00 00                	add    %al,(%eax)
     dcb:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     dcf:	00 23                	add    %ah,(%ebx)
     dd1:	00 00                	add    %al,(%eax)
     dd3:	00 00                	add    %al,(%eax)
     dd5:	00 00                	add    %al,(%eax)
     dd7:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     ddb:	00 26                	add    %ah,(%esi)
     ddd:	00 00                	add    %al,(%eax)
     ddf:	00 00                	add    %al,(%eax)
     de1:	00 00                	add    %al,(%eax)
     de3:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
     de7:	00 2c 00             	add    %ch,(%eax,%eax,1)
     dea:	00 00                	add    %al,(%eax)
     dec:	da 0b                	fimull (%ebx)
     dee:	00 00                	add    %al,(%eax)
     df0:	40                   	inc    %eax
     df1:	00 00                	add    %al,(%eax)
     df3:	00 03                	add    %al,(%ebx)
     df5:	00 00                	add    %al,(%eax)
     df7:	00 e8                	add    %ch,%al
     df9:	0b 00                	or     (%eax),%eax
     dfb:	00 40 00             	add    %al,0x0(%eax)
     dfe:	00 00                	add    %al,(%eax)
     e00:	01 00                	add    %eax,(%eax)
     e02:	00 00                	add    %al,(%eax)
     e04:	f2 0b 00             	repnz or (%eax),%eax
     e07:	00 24 00             	add    %ah,(%eax,%eax,1)
     e0a:	00 00                	add    %al,(%eax)
     e0c:	d7                   	xlat   %ds:(%ebx)
     e0d:	05 28 00 c7 0a       	add    $0xac70028,%eax
     e12:	00 00                	add    %al,(%eax)
     e14:	a0 00 00 00 08       	mov    0x8000000,%al
     e19:	00 00                	add    %al,(%eax)
     e1b:	00 b2 0b 00 00 a0    	add    %dh,-0x5ffffff5(%edx)
     e21:	00 00                	add    %al,(%eax)
     e23:	00 0c 00             	add    %cl,(%eax,%eax,1)
     e26:	00 00                	add    %al,(%eax)
     e28:	bc 0b 00 00 a0       	mov    $0xa000000b,%esp
     e2d:	00 00                	add    %al,(%eax)
     e2f:	00 10                	add    %dl,(%eax)
     e31:	00 00                	add    %al,(%eax)
     e33:	00 c6                	add    %al,%dh
     e35:	0b 00                	or     (%eax),%eax
     e37:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     e3d:	00 00                	add    %al,(%eax)
     e3f:	00 d0                	add    %dl,%al
     e41:	0b 00                	or     (%eax),%eax
     e43:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     e49:	00 00                	add    %al,(%eax)
     e4b:	00 00                	add    %al,(%eax)
     e4d:	00 00                	add    %al,(%eax)
     e4f:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
     e5b:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     e5f:	00 03                	add    %al,(%ebx)
     e61:	00 00                	add    %al,(%eax)
     e63:	00 00                	add    %al,(%eax)
     e65:	00 00                	add    %al,(%eax)
     e67:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     e6b:	00 26                	add    %ah,(%esi)
     e6d:	00 00                	add    %al,(%eax)
     e6f:	00 02                	add    %al,(%edx)
     e71:	0c 00                	or     $0x0,%al
     e73:	00 24 00             	add    %ah,(%eax,%eax,1)
     e76:	00 00                	add    %al,(%eax)
     e78:	ff 05 28 00 17 0c    	incl   0xc170028
     e7e:	00 00                	add    %al,(%eax)
     e80:	a0 00 00 00 08       	mov    0x8000000,%al
     e85:	00 00                	add    %al,(%eax)
     e87:	00 00                	add    %al,(%eax)
     e89:	00 00                	add    %al,(%eax)
     e8b:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
	...
     e97:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
     e9b:	00 04 00             	add    %al,(%eax,%eax,1)
     e9e:	00 00                	add    %al,(%eax)
     ea0:	00 00                	add    %al,(%eax)
     ea2:	00 00                	add    %al,(%eax)
     ea4:	44                   	inc    %esp
     ea5:	00 67 00             	add    %ah,0x0(%edi)
     ea8:	07                   	pop    %es
     ea9:	00 00                	add    %al,(%eax)
     eab:	00 00                	add    %al,(%eax)
     ead:	00 00                	add    %al,(%eax)
     eaf:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
     eb3:	00 22                	add    %ah,(%edx)
     eb5:	00 00                	add    %al,(%eax)
     eb7:	00 00                	add    %al,(%eax)
     eb9:	00 00                	add    %al,(%eax)
     ebb:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
     ebf:	00 40 00             	add    %al,0x0(%eax)
     ec2:	00 00                	add    %al,(%eax)
     ec4:	00 00                	add    %al,(%eax)
     ec6:	00 00                	add    %al,(%eax)
     ec8:	44                   	inc    %esp
     ec9:	00 6b 00             	add    %ch,0x0(%ebx)
     ecc:	61                   	popa   
     ecd:	00 00                	add    %al,(%eax)
     ecf:	00 00                	add    %al,(%eax)
     ed1:	00 00                	add    %al,(%eax)
     ed3:	00 44 00 6f          	add    %al,0x6f(%eax,%eax,1)
     ed7:	00 7f 00             	add    %bh,0x0(%edi)
     eda:	00 00                	add    %al,(%eax)
     edc:	00 00                	add    %al,(%eax)
     ede:	00 00                	add    %al,(%eax)
     ee0:	44                   	inc    %esp
     ee1:	00 70 00             	add    %dh,0x0(%eax)
     ee4:	9d                   	popf   
     ee5:	00 00                	add    %al,(%eax)
     ee7:	00 00                	add    %al,(%eax)
     ee9:	00 00                	add    %al,(%eax)
     eeb:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     eef:	00 b8 00 00 00 00    	add    %bh,0x0(%eax)
     ef5:	00 00                	add    %al,(%eax)
     ef7:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     efb:	00 d6                	add    %dl,%dh
     efd:	00 00                	add    %al,(%eax)
     eff:	00 00                	add    %al,(%eax)
     f01:	00 00                	add    %al,(%eax)
     f03:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     f07:	00 f1                	add    %dh,%cl
     f09:	00 00                	add    %al,(%eax)
     f0b:	00 00                	add    %al,(%eax)
     f0d:	00 00                	add    %al,(%eax)
     f0f:	00 44 00 74          	add    %al,0x74(%eax,%eax,1)
     f13:	00 0f                	add    %cl,(%edi)
     f15:	01 00                	add    %eax,(%eax)
     f17:	00 00                	add    %al,(%eax)
     f19:	00 00                	add    %al,(%eax)
     f1b:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     f1f:	00 2a                	add    %ch,(%edx)
     f21:	01 00                	add    %eax,(%eax)
     f23:	00 00                	add    %al,(%eax)
     f25:	00 00                	add    %al,(%eax)
     f27:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
     f2b:	00 4e 01             	add    %cl,0x1(%esi)
     f2e:	00 00                	add    %al,(%eax)
     f30:	00 00                	add    %al,(%eax)
     f32:	00 00                	add    %al,(%eax)
     f34:	44                   	inc    %esp
     f35:	00 7a 00             	add    %bh,0x0(%edx)
     f38:	6f                   	outsl  %ds:(%esi),(%dx)
     f39:	01 00                	add    %eax,(%eax)
     f3b:	00 00                	add    %al,(%eax)
     f3d:	00 00                	add    %al,(%eax)
     f3f:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
     f43:	00 93 01 00 00 00    	add    %dl,0x1(%ebx)
     f49:	00 00                	add    %al,(%eax)
     f4b:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
     f4f:	00 b7 01 00 00 20    	add    %dh,0x20000001(%edi)
     f55:	0c 00                	or     $0x0,%al
     f57:	00 40 00             	add    %al,0x0(%eax)
     f5a:	00 00                	add    %al,(%eax)
     f5c:	03 00                	add    (%eax),%eax
     f5e:	00 00                	add    %al,(%eax)
     f60:	29 0c 00             	sub    %ecx,(%eax,%eax,1)
     f63:	00 24 00             	add    %ah,(%eax,%eax,1)
     f66:	00 00                	add    %al,(%eax)
     f68:	bb 07 28 00 00       	mov    $0x2807,%ebx
     f6d:	00 00                	add    %al,(%eax)
     f6f:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
	...
     f7b:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
     f7f:	00 03                	add    %al,(%ebx)
     f81:	00 00                	add    %al,(%eax)
     f83:	00 00                	add    %al,(%eax)
     f85:	00 00                	add    %al,(%eax)
     f87:	00 44 00 87          	add    %al,-0x79(%eax,%eax,1)
     f8b:	00 18                	add    %bl,(%eax)
     f8d:	00 00                	add    %al,(%eax)
     f8f:	00 00                	add    %al,(%eax)
     f91:	00 00                	add    %al,(%eax)
     f93:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
     f97:	00 30                	add    %dh,(%eax)
     f99:	00 00                	add    %al,(%eax)
     f9b:	00 00                	add    %al,(%eax)
     f9d:	00 00                	add    %al,(%eax)
     f9f:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     fa3:	00 4b 00             	add    %cl,0x0(%ebx)
     fa6:	00 00                	add    %al,(%eax)
     fa8:	00 00                	add    %al,(%eax)
     faa:	00 00                	add    %al,(%eax)
     fac:	44                   	inc    %esp
     fad:	00 8d 00 63 00 00    	add    %cl,0x6300(%ebp)
     fb3:	00 00                	add    %al,(%eax)
     fb5:	00 00                	add    %al,(%eax)
     fb7:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
     fbb:	00 7b 00             	add    %bh,0x0(%ebx)
     fbe:	00 00                	add    %al,(%eax)
     fc0:	00 00                	add    %al,(%eax)
     fc2:	00 00                	add    %al,(%eax)
     fc4:	44                   	inc    %esp
     fc5:	00 8f 00 90 00 00    	add    %cl,0x9000(%edi)
     fcb:	00 00                	add    %al,(%eax)
     fcd:	00 00                	add    %al,(%eax)
     fcf:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
     fd3:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
     fd9:	00 00                	add    %al,(%eax)
     fdb:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
     fdf:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     fe5:	00 00                	add    %al,(%eax)
     fe7:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
     feb:	00 d5                	add    %dl,%ch
     fed:	00 00                	add    %al,(%eax)
     fef:	00 00                	add    %al,(%eax)
     ff1:	00 00                	add    %al,(%eax)
     ff3:	00 44 00 96          	add    %al,-0x6a(%eax,%eax,1)
     ff7:	00 ea                	add    %ch,%dl
     ff9:	00 00                	add    %al,(%eax)
     ffb:	00 00                	add    %al,(%eax)
     ffd:	00 00                	add    %al,(%eax)
     fff:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1003:	00 08                	add    %cl,(%eax)
    1005:	01 00                	add    %eax,(%eax)
    1007:	00 00                	add    %al,(%eax)
    1009:	00 00                	add    %al,(%eax)
    100b:	00 44 00 98          	add    %al,-0x68(%eax,%eax,1)
    100f:	00 23                	add    %ah,(%ebx)
    1011:	01 00                	add    %eax,(%eax)
    1013:	00 00                	add    %al,(%eax)
    1015:	00 00                	add    %al,(%eax)
    1017:	00 44 00 99          	add    %al,-0x67(%eax,%eax,1)
    101b:	00 41 01             	add    %al,0x1(%ecx)
    101e:	00 00                	add    %al,(%eax)
    1020:	00 00                	add    %al,(%eax)
    1022:	00 00                	add    %al,(%eax)
    1024:	44                   	inc    %esp
    1025:	00 9a 00 5f 01 00    	add    %bl,0x15f00(%edx)
    102b:	00 3d 0c 00 00 24    	add    %bh,0x2400000c
    1031:	00 00                	add    %al,(%eax)
    1033:	00 1c 09             	add    %bl,(%ecx,%ecx,1)
    1036:	28 00                	sub    %al,(%eax)
    1038:	51                   	push   %ecx
    1039:	0c 00                	or     $0x0,%al
    103b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1041:	00 00                	add    %al,(%eax)
    1043:	00 00                	add    %al,(%eax)
    1045:	00 00                	add    %al,(%eax)
    1047:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
	...
    1053:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    1057:	00 03                	add    %al,(%ebx)
    1059:	00 00                	add    %al,(%eax)
    105b:	00 00                	add    %al,(%eax)
    105d:	00 00                	add    %al,(%eax)
    105f:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
    1063:	00 06                	add    %al,(%esi)
    1065:	00 00                	add    %al,(%eax)
    1067:	00 00                	add    %al,(%eax)
    1069:	00 00                	add    %al,(%eax)
    106b:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
    106f:	00 0d 00 00 00 00    	add    %cl,0x0
    1075:	00 00                	add    %al,(%eax)
    1077:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
    107b:	00 11                	add    %dl,(%ecx)
    107d:	00 00                	add    %al,(%eax)
    107f:	00 00                	add    %al,(%eax)
    1081:	00 00                	add    %al,(%eax)
    1083:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
    1087:	00 17                	add    %dl,(%edi)
    1089:	00 00                	add    %al,(%eax)
    108b:	00 00                	add    %al,(%eax)
    108d:	00 00                	add    %al,(%eax)
    108f:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
    1093:	00 1d 00 00 00 66    	add    %bl,0x66000000
    1099:	0c 00                	or     $0x0,%al
    109b:	00 40 00             	add    %al,0x0(%eax)
    109e:	00 00                	add    %al,(%eax)
    10a0:	00 00                	add    %al,(%eax)
    10a2:	00 00                	add    %al,(%eax)
    10a4:	74 0c                	je     10b2 <bootmain-0x27ef4e>
    10a6:	00 00                	add    %al,(%eax)
    10a8:	24 00                	and    $0x0,%al
    10aa:	00 00                	add    %al,(%eax)
    10ac:	3b 09                	cmp    (%ecx),%ecx
    10ae:	28 00                	sub    %al,(%eax)
    10b0:	87 0c 00             	xchg   %ecx,(%eax,%eax,1)
    10b3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    10b9:	00 00                	add    %al,(%eax)
    10bb:	00 94 0c 00 00 a0 00 	add    %dl,0xa00000(%esp,%ecx,1)
    10c2:	00 00                	add    %al,(%eax)
    10c4:	0c 00                	or     $0x0,%al
    10c6:	00 00                	add    %al,(%eax)
    10c8:	00 00                	add    %al,(%eax)
    10ca:	00 00                	add    %al,(%eax)
    10cc:	44                   	inc    %esp
    10cd:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
    10d3:	00 00                	add    %al,(%eax)
    10d5:	00 00                	add    %al,(%eax)
    10d7:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    10db:	00 0d 00 00 00 00    	add    %cl,0x0
    10e1:	00 00                	add    %al,(%eax)
    10e3:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    10e7:	00 0f                	add    %cl,(%edi)
    10e9:	00 00                	add    %al,(%eax)
    10eb:	00 00                	add    %al,(%eax)
    10ed:	00 00                	add    %al,(%eax)
    10ef:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
    10f3:	00 11                	add    %dl,(%ecx)
    10f5:	00 00                	add    %al,(%eax)
    10f7:	00 00                	add    %al,(%eax)
    10f9:	00 00                	add    %al,(%eax)
    10fb:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
    10ff:	00 27                	add    %ah,(%edi)
    1101:	00 00                	add    %al,(%eax)
    1103:	00 00                	add    %al,(%eax)
    1105:	00 00                	add    %al,(%eax)
    1107:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    110b:	00 2d 00 00 00 00    	add    %ch,0x0
    1111:	00 00                	add    %al,(%eax)
    1113:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
    1117:	00 34 00             	add    %dh,(%eax,%eax,1)
    111a:	00 00                	add    %al,(%eax)
    111c:	00 00                	add    %al,(%eax)
    111e:	00 00                	add    %al,(%eax)
    1120:	44                   	inc    %esp
    1121:	00 c2                	add    %al,%dl
    1123:	00 38                	add    %bh,(%eax)
    1125:	00 00                	add    %al,(%eax)
    1127:	00 00                	add    %al,(%eax)
    1129:	00 00                	add    %al,(%eax)
    112b:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    112f:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1133:	00 00                	add    %al,(%eax)
    1135:	00 00                	add    %al,(%eax)
    1137:	00 44 00 d0          	add    %al,-0x30(%eax,%eax,1)
    113b:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    113f:	00 9e 0c 00 00 26    	add    %bl,0x2600000c(%esi)
    1145:	00 00                	add    %al,(%eax)
    1147:	00 08                	add    %cl,(%eax)
    1149:	35 28 00 d4 0c       	xor    $0xcd40028,%eax
    114e:	00 00                	add    %al,(%eax)
    1150:	40                   	inc    %eax
    1151:	00 00                	add    %al,(%eax)
    1153:	00 00                	add    %al,(%eax)
    1155:	00 00                	add    %al,(%eax)
    1157:	00 dd                	add    %bl,%ch
    1159:	0c 00                	or     $0x0,%al
    115b:	00 40 00             	add    %al,0x0(%eax)
    115e:	00 00                	add    %al,(%eax)
    1160:	06                   	push   %es
    1161:	00 00                	add    %al,(%eax)
    1163:	00 00                	add    %al,(%eax)
    1165:	00 00                	add    %al,(%eax)
    1167:	00 c0                	add    %al,%al
	...
    1171:	00 00                	add    %al,(%eax)
    1173:	00 e0                	add    %ah,%al
    1175:	00 00                	add    %al,(%eax)
    1177:	00 50 00             	add    %dl,0x0(%eax)
    117a:	00 00                	add    %al,(%eax)
    117c:	e7 0c                	out    %eax,$0xc
    117e:	00 00                	add    %al,(%eax)
    1180:	24 00                	and    $0x0,%al
    1182:	00 00                	add    %al,(%eax)
    1184:	8b 09                	mov    (%ecx),%ecx
    1186:	28 00                	sub    %al,(%eax)
    1188:	fd                   	std    
    1189:	0c 00                	or     $0x0,%al
    118b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1191:	00 00                	add    %al,(%eax)
    1193:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    1199:	00 00                	add    %al,(%eax)
    119b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    119e:	00 00                	add    %al,(%eax)
    11a0:	09 0d 00 00 a0 00    	or     %ecx,0xa00000
    11a6:	00 00                	add    %al,(%eax)
    11a8:	10 00                	adc    %al,(%eax)
    11aa:	00 00                	add    %al,(%eax)
    11ac:	17                   	pop    %ss
    11ad:	0d 00 00 a0 00       	or     $0xa00000,%eax
    11b2:	00 00                	add    %al,(%eax)
    11b4:	14 00                	adc    $0x0,%al
    11b6:	00 00                	add    %al,(%eax)
    11b8:	25 0d 00 00 a0       	and    $0xa000000d,%eax
    11bd:	00 00                	add    %al,(%eax)
    11bf:	00 18                	add    %bl,(%eax)
    11c1:	00 00                	add    %al,(%eax)
    11c3:	00 30                	add    %dh,(%eax)
    11c5:	0d 00 00 a0 00       	or     $0xa00000,%eax
    11ca:	00 00                	add    %al,(%eax)
    11cc:	1c 00                	sbb    $0x0,%al
    11ce:	00 00                	add    %al,(%eax)
    11d0:	3b 0d 00 00 a0 00    	cmp    0xa00000,%ecx
    11d6:	00 00                	add    %al,(%eax)
    11d8:	20 00                	and    %al,(%eax)
    11da:	00 00                	add    %al,(%eax)
    11dc:	46                   	inc    %esi
    11dd:	0d 00 00 a0 00       	or     $0xa00000,%eax
    11e2:	00 00                	add    %al,(%eax)
    11e4:	24 00                	and    $0x0,%al
    11e6:	00 00                	add    %al,(%eax)
    11e8:	00 00                	add    %al,(%eax)
    11ea:	00 00                	add    %al,(%eax)
    11ec:	44                   	inc    %esp
    11ed:	00 d3                	add    %dl,%bl
	...
    11f7:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    11fb:	00 07                	add    %al,(%edi)
    11fd:	00 00                	add    %al,(%eax)
    11ff:	00 00                	add    %al,(%eax)
    1201:	00 00                	add    %al,(%eax)
    1203:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    1207:	00 09                	add    %cl,(%ecx)
    1209:	00 00                	add    %al,(%eax)
    120b:	00 00                	add    %al,(%eax)
    120d:	00 00                	add    %al,(%eax)
    120f:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    1213:	00 17                	add    %dl,(%edi)
    1215:	00 00                	add    %al,(%eax)
    1217:	00 00                	add    %al,(%eax)
    1219:	00 00                	add    %al,(%eax)
    121b:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    121f:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1222:	00 00                	add    %al,(%eax)
    1224:	00 00                	add    %al,(%eax)
    1226:	00 00                	add    %al,(%eax)
    1228:	44                   	inc    %esp
    1229:	00 d7                	add    %dl,%bh
    122b:	00 1e                	add    %bl,(%esi)
    122d:	00 00                	add    %al,(%eax)
    122f:	00 00                	add    %al,(%eax)
    1231:	00 00                	add    %al,(%eax)
    1233:	00 44 00 d9          	add    %al,-0x27(%eax,%eax,1)
    1237:	00 23                	add    %ah,(%ebx)
    1239:	00 00                	add    %al,(%eax)
    123b:	00 00                	add    %al,(%eax)
    123d:	00 00                	add    %al,(%eax)
    123f:	00 44 00 d7          	add    %al,-0x29(%eax,%eax,1)
    1243:	00 29                	add    %ch,(%ecx)
    1245:	00 00                	add    %al,(%eax)
    1247:	00 00                	add    %al,(%eax)
    1249:	00 00                	add    %al,(%eax)
    124b:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    124f:	00 2c 00             	add    %ch,(%eax,%eax,1)
    1252:	00 00                	add    %al,(%eax)
    1254:	00 00                	add    %al,(%eax)
    1256:	00 00                	add    %al,(%eax)
    1258:	44                   	inc    %esp
    1259:	00 dd                	add    %bl,%ch
    125b:	00 35 00 00 00 d4    	add    %dh,0xd4000000
    1261:	0c 00                	or     $0x0,%al
    1263:	00 40 00             	add    %al,0x0(%eax)
    1266:	00 00                	add    %al,(%eax)
    1268:	02 00                	add    (%eax),%al
    126a:	00 00                	add    %al,(%eax)
    126c:	54                   	push   %esp
    126d:	0d 00 00 40 00       	or     $0x400000,%eax
    1272:	00 00                	add    %al,(%eax)
    1274:	06                   	push   %es
    1275:	00 00                	add    %al,(%eax)
    1277:	00 00                	add    %al,(%eax)
    1279:	00 00                	add    %al,(%eax)
    127b:	00 c0                	add    %al,%al
	...
    1285:	00 00                	add    %al,(%eax)
    1287:	00 e0                	add    %ah,%al
    1289:	00 00                	add    %al,(%eax)
    128b:	00 39                	add    %bh,(%ecx)
    128d:	00 00                	add    %al,(%eax)
    128f:	00 5d 0d             	add    %bl,0xd(%ebp)
    1292:	00 00                	add    %al,(%eax)
    1294:	24 00                	and    $0x0,%al
    1296:	00 00                	add    %al,(%eax)
    1298:	c4 09                	les    (%ecx),%ecx
    129a:	28 00                	sub    %al,(%eax)
    129c:	72 0d                	jb     12ab <bootmain-0x27ed55>
    129e:	00 00                	add    %al,(%eax)
    12a0:	a0 00 00 00 08       	mov    0x8000000,%al
    12a5:	00 00                	add    %al,(%eax)
    12a7:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    12ad:	00 00                	add    %al,(%eax)
    12af:	00 0c 00             	add    %cl,(%eax,%eax,1)
    12b2:	00 00                	add    %al,(%eax)
    12b4:	7d 0d                	jge    12c3 <bootmain-0x27ed3d>
    12b6:	00 00                	add    %al,(%eax)
    12b8:	a0 00 00 00 10       	mov    0x10000000,%al
    12bd:	00 00                	add    %al,(%eax)
    12bf:	00 8a 0d 00 00 a0    	add    %cl,-0x5ffffff3(%edx)
    12c5:	00 00                	add    %al,(%eax)
    12c7:	00 14 00             	add    %dl,(%eax,%eax,1)
    12ca:	00 00                	add    %al,(%eax)
    12cc:	00 00                	add    %al,(%eax)
    12ce:	00 00                	add    %al,(%eax)
    12d0:	44                   	inc    %esp
    12d1:	00 f8                	add    %bh,%al
	...
    12db:	00 44 00 f8          	add    %al,-0x8(%eax,%eax,1)
    12df:	00 09                	add    %cl,(%ecx)
    12e1:	00 00                	add    %al,(%eax)
    12e3:	00 00                	add    %al,(%eax)
    12e5:	00 00                	add    %al,(%eax)
    12e7:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    12eb:	01 0c 00             	add    %ecx,(%eax,%eax,1)
    12ee:	00 00                	add    %al,(%eax)
    12f0:	00 00                	add    %al,(%eax)
    12f2:	00 00                	add    %al,(%eax)
    12f4:	44                   	inc    %esp
    12f5:	00 f8                	add    %bh,%al
    12f7:	00 0e                	add    %cl,(%esi)
    12f9:	00 00                	add    %al,(%eax)
    12fb:	00 00                	add    %al,(%eax)
    12fd:	00 00                	add    %al,(%eax)
    12ff:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1303:	01 11                	add    %edx,(%ecx)
    1305:	00 00                	add    %al,(%eax)
    1307:	00 00                	add    %al,(%eax)
    1309:	00 00                	add    %al,(%eax)
    130b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    130f:	01 22                	add    %esp,(%edx)
    1311:	00 00                	add    %al,(%eax)
    1313:	00 00                	add    %al,(%eax)
    1315:	00 00                	add    %al,(%eax)
    1317:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    131b:	01 38                	add    %edi,(%eax)
    131d:	00 00                	add    %al,(%eax)
    131f:	00 00                	add    %al,(%eax)
    1321:	00 00                	add    %al,(%eax)
    1323:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    1327:	01 52 00             	add    %edx,0x0(%edx)
    132a:	00 00                	add    %al,(%eax)
    132c:	00 00                	add    %al,(%eax)
    132e:	00 00                	add    %al,(%eax)
    1330:	44                   	inc    %esp
    1331:	00 10                	add    %dl,(%eax)
    1333:	01 6b 00             	add    %ebp,0x0(%ebx)
    1336:	00 00                	add    %al,(%eax)
    1338:	00 00                	add    %al,(%eax)
    133a:	00 00                	add    %al,(%eax)
    133c:	44                   	inc    %esp
    133d:	00 11                	add    %dl,(%ecx)
    133f:	01 88 00 00 00 00    	add    %ecx,0x0(%eax)
    1345:	00 00                	add    %al,(%eax)
    1347:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    134b:	01 98 00 00 00 00    	add    %ebx,0x0(%eax)
    1351:	00 00                	add    %al,(%eax)
    1353:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    1357:	01 b3 00 00 00 00    	add    %esi,0x0(%ebx)
    135d:	00 00                	add    %al,(%eax)
    135f:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1363:	01 c6                	add    %eax,%esi
    1365:	00 00                	add    %al,(%eax)
    1367:	00 00                	add    %al,(%eax)
    1369:	00 00                	add    %al,(%eax)
    136b:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    136f:	01 dd                	add    %ebx,%ebp
    1371:	00 00                	add    %al,(%eax)
    1373:	00 00                	add    %al,(%eax)
    1375:	00 00                	add    %al,(%eax)
    1377:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    137b:	01 e2                	add    %esp,%edx
    137d:	00 00                	add    %al,(%eax)
    137f:	00 00                	add    %al,(%eax)
    1381:	00 00                	add    %al,(%eax)
    1383:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    1387:	01 e4                	add    %esp,%esp
    1389:	00 00                	add    %al,(%eax)
    138b:	00 00                	add    %al,(%eax)
    138d:	00 00                	add    %al,(%eax)
    138f:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    1393:	01 f0                	add    %esi,%eax
    1395:	00 00                	add    %al,(%eax)
    1397:	00 00                	add    %al,(%eax)
    1399:	00 00                	add    %al,(%eax)
    139b:	00 44 00 f8          	add    %al,-0x8(%eax,%eax,1)
    139f:	00 0d 01 00 00 00    	add    %cl,0x1
    13a5:	00 00                	add    %al,(%eax)
    13a7:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    13ab:	01 0f                	add    %ecx,(%edi)
    13ad:	01 00                	add    %eax,(%eax)
    13af:	00 00                	add    %al,(%eax)
    13b1:	00 00                	add    %al,(%eax)
    13b3:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    13b7:	01 16                	add    %edx,(%esi)
    13b9:	01 00                	add    %eax,(%eax)
    13bb:	00 00                	add    %al,(%eax)
    13bd:	00 00                	add    %al,(%eax)
    13bf:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    13c3:	01 1b                	add    %ebx,(%ebx)
    13c5:	01 00                	add    %eax,(%eax)
    13c7:	00 00                	add    %al,(%eax)
    13c9:	00 00                	add    %al,(%eax)
    13cb:	00 44 00 24          	add    %al,0x24(%eax,%eax,1)
    13cf:	01 20                	add    %esp,(%eax)
    13d1:	01 00                	add    %eax,(%eax)
    13d3:	00 00                	add    %al,(%eax)
    13d5:	00 00                	add    %al,(%eax)
    13d7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    13db:	01 2b                	add    %ebp,(%ebx)
    13dd:	01 00                	add    %eax,(%eax)
    13df:	00 00                	add    %al,(%eax)
    13e1:	00 00                	add    %al,(%eax)
    13e3:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    13e7:	01 2f                	add    %ebp,(%edi)
    13e9:	01 00                	add    %eax,(%eax)
    13eb:	00 00                	add    %al,(%eax)
    13ed:	00 00                	add    %al,(%eax)
    13ef:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    13f3:	01 31                	add    %esi,(%ecx)
    13f5:	01 00                	add    %eax,(%eax)
    13f7:	00 00                	add    %al,(%eax)
    13f9:	00 00                	add    %al,(%eax)
    13fb:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    13ff:	01 3a                	add    %edi,(%edx)
    1401:	01 00                	add    %eax,(%eax)
    1403:	00 00                	add    %al,(%eax)
    1405:	00 00                	add    %al,(%eax)
    1407:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    140b:	01 40 01             	add    %eax,0x1(%eax)
    140e:	00 00                	add    %al,(%eax)
    1410:	00 00                	add    %al,(%eax)
    1412:	00 00                	add    %al,(%eax)
    1414:	44                   	inc    %esp
    1415:	00 30                	add    %dh,(%eax)
    1417:	01 48 01             	add    %ecx,0x1(%eax)
    141a:	00 00                	add    %al,(%eax)
    141c:	97                   	xchg   %eax,%edi
    141d:	0d 00 00 26 00       	or     $0x260000,%eax
    1422:	00 00                	add    %al,(%eax)
    1424:	28 34 28             	sub    %dh,(%eax,%ebp,1)
    1427:	00 d4                	add    %dl,%ah
    1429:	0c 00                	or     $0x0,%al
    142b:	00 40 00             	add    %al,0x0(%eax)
    142e:	00 00                	add    %al,(%eax)
    1430:	00 00                	add    %al,(%eax)
    1432:	00 00                	add    %al,(%eax)
    1434:	bc 0d 00 00 40       	mov    $0x4000000d,%esp
    1439:	00 00                	add    %al,(%eax)
    143b:	00 06                	add    %al,(%esi)
    143d:	00 00                	add    %al,(%eax)
    143f:	00 c7                	add    %al,%bh
    1441:	0d 00 00 40 00       	or     $0x400000,%eax
    1446:	00 00                	add    %al,(%eax)
    1448:	03 00                	add    (%eax),%eax
    144a:	00 00                	add    %al,(%eax)
    144c:	00 00                	add    %al,(%eax)
    144e:	00 00                	add    %al,(%eax)
    1450:	c0 00 00             	rolb   $0x0,(%eax)
	...
    145b:	00 e0                	add    %ah,%al
    145d:	00 00                	add    %al,(%eax)
    145f:	00 50 01             	add    %dl,0x1(%eax)
    1462:	00 00                	add    %al,(%eax)
    1464:	00 00                	add    %al,(%eax)
    1466:	00 00                	add    %al,(%eax)
    1468:	64 00 00             	add    %al,%fs:(%eax)
    146b:	00 14 0b             	add    %dl,(%ebx,%ecx,1)
    146e:	28 00                	sub    %al,(%eax)
    1470:	d4 0d                	aam    $0xd
    1472:	00 00                	add    %al,(%eax)
    1474:	64 00 02             	add    %al,%fs:(%edx)
    1477:	00 14 0b             	add    %dl,(%ebx,%ecx,1)
    147a:	28 00                	sub    %al,(%eax)
    147c:	08 00                	or     %al,(%eax)
    147e:	00 00                	add    %al,(%eax)
    1480:	3c 00                	cmp    $0x0,%al
    1482:	00 00                	add    %al,(%eax)
    1484:	00 00                	add    %al,(%eax)
    1486:	00 00                	add    %al,(%eax)
    1488:	17                   	pop    %ss
    1489:	00 00                	add    %al,(%eax)
    148b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1491:	00 00                	add    %al,(%eax)
    1493:	00 41 00             	add    %al,0x0(%ecx)
    1496:	00 00                	add    %al,(%eax)
    1498:	80 00 00             	addb   $0x0,(%eax)
    149b:	00 00                	add    %al,(%eax)
    149d:	00 00                	add    %al,(%eax)
    149f:	00 5b 00             	add    %bl,0x0(%ebx)
    14a2:	00 00                	add    %al,(%eax)
    14a4:	80 00 00             	addb   $0x0,(%eax)
    14a7:	00 00                	add    %al,(%eax)
    14a9:	00 00                	add    %al,(%eax)
    14ab:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    14b1:	00 00                	add    %al,(%eax)
    14b3:	00 00                	add    %al,(%eax)
    14b5:	00 00                	add    %al,(%eax)
    14b7:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    14bd:	00 00                	add    %al,(%eax)
    14bf:	00 00                	add    %al,(%eax)
    14c1:	00 00                	add    %al,(%eax)
    14c3:	00 e1                	add    %ah,%cl
    14c5:	00 00                	add    %al,(%eax)
    14c7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    14cd:	00 00                	add    %al,(%eax)
    14cf:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    14d2:	00 00                	add    %al,(%eax)
    14d4:	80 00 00             	addb   $0x0,(%eax)
    14d7:	00 00                	add    %al,(%eax)
    14d9:	00 00                	add    %al,(%eax)
    14db:	00 37                	add    %dh,(%edi)
    14dd:	01 00                	add    %eax,(%eax)
    14df:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    14e5:	00 00                	add    %al,(%eax)
    14e7:	00 5d 01             	add    %bl,0x1(%ebp)
    14ea:	00 00                	add    %al,(%eax)
    14ec:	80 00 00             	addb   $0x0,(%eax)
    14ef:	00 00                	add    %al,(%eax)
    14f1:	00 00                	add    %al,(%eax)
    14f3:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    14f9:	00 00                	add    %al,(%eax)
    14fb:	00 00                	add    %al,(%eax)
    14fd:	00 00                	add    %al,(%eax)
    14ff:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1505:	00 00                	add    %al,(%eax)
    1507:	00 00                	add    %al,(%eax)
    1509:	00 00                	add    %al,(%eax)
    150b:	00 d2                	add    %dl,%dl
    150d:	01 00                	add    %eax,(%eax)
    150f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1515:	00 00                	add    %al,(%eax)
    1517:	00 ec                	add    %ch,%ah
    1519:	01 00                	add    %eax,(%eax)
    151b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1521:	00 00                	add    %al,(%eax)
    1523:	00 07                	add    %al,(%edi)
    1525:	02 00                	add    (%eax),%al
    1527:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    152d:	00 00                	add    %al,(%eax)
    152f:	00 28                	add    %ch,(%eax)
    1531:	02 00                	add    (%eax),%al
    1533:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1539:	00 00                	add    %al,(%eax)
    153b:	00 47 02             	add    %al,0x2(%edi)
    153e:	00 00                	add    %al,(%eax)
    1540:	80 00 00             	addb   $0x0,(%eax)
    1543:	00 00                	add    %al,(%eax)
    1545:	00 00                	add    %al,(%eax)
    1547:	00 66 02             	add    %ah,0x2(%esi)
    154a:	00 00                	add    %al,(%eax)
    154c:	80 00 00             	addb   $0x0,(%eax)
    154f:	00 00                	add    %al,(%eax)
    1551:	00 00                	add    %al,(%eax)
    1553:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1559:	00 00                	add    %al,(%eax)
    155b:	00 00                	add    %al,(%eax)
    155d:	00 00                	add    %al,(%eax)
    155f:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1565:	00 00                	add    %al,(%eax)
    1567:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    156d:	02 00                	add    (%eax),%al
    156f:	00 c2                	add    %al,%dl
    1571:	00 00                	add    %al,(%eax)
    1573:	00 00                	add    %al,(%eax)
    1575:	00 00                	add    %al,(%eax)
    1577:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    157d:	00 00                	add    %al,(%eax)
    157f:	00 37                	add    %dh,(%edi)
    1581:	53                   	push   %ebx
    1582:	00 00                	add    %al,(%eax)
    1584:	29 04 00             	sub    %eax,(%eax,%eax,1)
    1587:	00 c2                	add    %al,%dl
    1589:	00 00                	add    %al,(%eax)
    158b:	00 17                	add    %dl,(%edi)
    158d:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    158e:	00 00                	add    %al,(%eax)
    1590:	00 00                	add    %al,(%eax)
    1592:	00 00                	add    %al,(%eax)
    1594:	64 00 00             	add    %al,%fs:(%eax)
    1597:	00 14 0b             	add    %dl,(%ebx,%ecx,1)
    159a:	28 00                	sub    %al,(%eax)
    159c:	db 0d 00 00 64 00    	fisttpl 0x640000
    15a2:	02 00                	add    (%eax),%al
    15a4:	14 0b                	adc    $0xb,%al
    15a6:	28 00                	sub    %al,(%eax)
    15a8:	08 00                	or     %al,(%eax)
    15aa:	00 00                	add    %al,(%eax)
    15ac:	3c 00                	cmp    $0x0,%al
    15ae:	00 00                	add    %al,(%eax)
    15b0:	00 00                	add    %al,(%eax)
    15b2:	00 00                	add    %al,(%eax)
    15b4:	17                   	pop    %ss
    15b5:	00 00                	add    %al,(%eax)
    15b7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    15bd:	00 00                	add    %al,(%eax)
    15bf:	00 41 00             	add    %al,0x0(%ecx)
    15c2:	00 00                	add    %al,(%eax)
    15c4:	80 00 00             	addb   $0x0,(%eax)
    15c7:	00 00                	add    %al,(%eax)
    15c9:	00 00                	add    %al,(%eax)
    15cb:	00 5b 00             	add    %bl,0x0(%ebx)
    15ce:	00 00                	add    %al,(%eax)
    15d0:	80 00 00             	addb   $0x0,(%eax)
    15d3:	00 00                	add    %al,(%eax)
    15d5:	00 00                	add    %al,(%eax)
    15d7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    15dd:	00 00                	add    %al,(%eax)
    15df:	00 00                	add    %al,(%eax)
    15e1:	00 00                	add    %al,(%eax)
    15e3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    15e9:	00 00                	add    %al,(%eax)
    15eb:	00 00                	add    %al,(%eax)
    15ed:	00 00                	add    %al,(%eax)
    15ef:	00 e1                	add    %ah,%cl
    15f1:	00 00                	add    %al,(%eax)
    15f3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    15f9:	00 00                	add    %al,(%eax)
    15fb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    15fe:	00 00                	add    %al,(%eax)
    1600:	80 00 00             	addb   $0x0,(%eax)
    1603:	00 00                	add    %al,(%eax)
    1605:	00 00                	add    %al,(%eax)
    1607:	00 37                	add    %dh,(%edi)
    1609:	01 00                	add    %eax,(%eax)
    160b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1611:	00 00                	add    %al,(%eax)
    1613:	00 5d 01             	add    %bl,0x1(%ebp)
    1616:	00 00                	add    %al,(%eax)
    1618:	80 00 00             	addb   $0x0,(%eax)
    161b:	00 00                	add    %al,(%eax)
    161d:	00 00                	add    %al,(%eax)
    161f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1625:	00 00                	add    %al,(%eax)
    1627:	00 00                	add    %al,(%eax)
    1629:	00 00                	add    %al,(%eax)
    162b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1631:	00 00                	add    %al,(%eax)
    1633:	00 00                	add    %al,(%eax)
    1635:	00 00                	add    %al,(%eax)
    1637:	00 d2                	add    %dl,%dl
    1639:	01 00                	add    %eax,(%eax)
    163b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1641:	00 00                	add    %al,(%eax)
    1643:	00 ec                	add    %ch,%ah
    1645:	01 00                	add    %eax,(%eax)
    1647:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    164d:	00 00                	add    %al,(%eax)
    164f:	00 07                	add    %al,(%edi)
    1651:	02 00                	add    (%eax),%al
    1653:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1659:	00 00                	add    %al,(%eax)
    165b:	00 28                	add    %ch,(%eax)
    165d:	02 00                	add    (%eax),%al
    165f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1665:	00 00                	add    %al,(%eax)
    1667:	00 47 02             	add    %al,0x2(%edi)
    166a:	00 00                	add    %al,(%eax)
    166c:	80 00 00             	addb   $0x0,(%eax)
    166f:	00 00                	add    %al,(%eax)
    1671:	00 00                	add    %al,(%eax)
    1673:	00 66 02             	add    %ah,0x2(%esi)
    1676:	00 00                	add    %al,(%eax)
    1678:	80 00 00             	addb   $0x0,(%eax)
    167b:	00 00                	add    %al,(%eax)
    167d:	00 00                	add    %al,(%eax)
    167f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1685:	00 00                	add    %al,(%eax)
    1687:	00 00                	add    %al,(%eax)
    1689:	00 00                	add    %al,(%eax)
    168b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1691:	00 00                	add    %al,(%eax)
    1693:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    1699:	02 00                	add    (%eax),%al
    169b:	00 c2                	add    %al,%dl
    169d:	00 00                	add    %al,(%eax)
    169f:	00 00                	add    %al,(%eax)
    16a1:	00 00                	add    %al,(%eax)
    16a3:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    16a9:	00 00                	add    %al,(%eax)
    16ab:	00 37                	add    %dh,(%edi)
    16ad:	53                   	push   %ebx
    16ae:	00 00                	add    %al,(%eax)
    16b0:	29 04 00             	sub    %eax,(%eax,%eax,1)
    16b3:	00 c2                	add    %al,%dl
    16b5:	00 00                	add    %al,(%eax)
    16b7:	00 17                	add    %dl,(%edi)
    16b9:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    16ba:	00 00                	add    %al,(%eax)
    16bc:	e3 0d                	jecxz  16cb <bootmain-0x27e935>
    16be:	00 00                	add    %al,(%eax)
    16c0:	24 00                	and    $0x0,%al
    16c2:	00 00                	add    %al,(%eax)
    16c4:	14 0b                	adc    $0xb,%al
    16c6:	28 00                	sub    %al,(%eax)
    16c8:	f0 0d 00 00 a0 00    	lock or $0xa00000,%eax
    16ce:	00 00                	add    %al,(%eax)
    16d0:	08 00                	or     %al,(%eax)
    16d2:	00 00                	add    %al,(%eax)
    16d4:	72 0d                	jb     16e3 <bootmain-0x27e91d>
    16d6:	00 00                	add    %al,(%eax)
    16d8:	a0 00 00 00 0c       	mov    0xc000000,%al
    16dd:	00 00                	add    %al,(%eax)
    16df:	00 00                	add    %al,(%eax)
    16e1:	00 00                	add    %al,(%eax)
    16e3:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
	...
    16ef:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    16f3:	00 01                	add    %al,(%ecx)
    16f5:	00 00                	add    %al,(%eax)
    16f7:	00 00                	add    %al,(%eax)
    16f9:	00 00                	add    %al,(%eax)
    16fb:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    16ff:	00 03                	add    %al,(%ebx)
    1701:	00 00                	add    %al,(%eax)
    1703:	00 00                	add    %al,(%eax)
    1705:	00 00                	add    %al,(%eax)
    1707:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    170b:	00 05 00 00 00 00    	add    %al,0x0
    1711:	00 00                	add    %al,(%eax)
    1713:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1717:	00 0a                	add    %cl,(%edx)
    1719:	00 00                	add    %al,(%eax)
    171b:	00 00                	add    %al,(%eax)
    171d:	00 00                	add    %al,(%eax)
    171f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1723:	00 10                	add    %dl,(%eax)
    1725:	00 00                	add    %al,(%eax)
    1727:	00 00                	add    %al,(%eax)
    1729:	00 00                	add    %al,(%eax)
    172b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    172f:	00 13                	add    %dl,(%ebx)
    1731:	00 00                	add    %al,(%eax)
    1733:	00 00                	add    %al,(%eax)
    1735:	00 00                	add    %al,(%eax)
    1737:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    173b:	00 16                	add    %dl,(%esi)
    173d:	00 00                	add    %al,(%eax)
    173f:	00 00                	add    %al,(%eax)
    1741:	00 00                	add    %al,(%eax)
    1743:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1747:	00 19                	add    %bl,(%ecx)
    1749:	00 00                	add    %al,(%eax)
    174b:	00 00                	add    %al,(%eax)
    174d:	00 00                	add    %al,(%eax)
    174f:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    1753:	00 1e                	add    %bl,(%esi)
    1755:	00 00                	add    %al,(%eax)
    1757:	00 00                	add    %al,(%eax)
    1759:	00 00                	add    %al,(%eax)
    175b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    175f:	00 22                	add    %ah,(%edx)
    1761:	00 00                	add    %al,(%eax)
    1763:	00 00                	add    %al,(%eax)
    1765:	00 00                	add    %al,(%eax)
    1767:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    176b:	00 25 00 00 00 00    	add    %ah,0x0
    1771:	00 00                	add    %al,(%eax)
    1773:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1777:	00 27                	add    %ah,(%edi)
    1779:	00 00                	add    %al,(%eax)
    177b:	00 00                	add    %al,(%eax)
    177d:	00 00                	add    %al,(%eax)
    177f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1783:	00 28                	add    %ch,(%eax)
    1785:	00 00                	add    %al,(%eax)
    1787:	00 00                	add    %al,(%eax)
    1789:	00 00                	add    %al,(%eax)
    178b:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    178f:	00 2a                	add    %ch,(%edx)
    1791:	00 00                	add    %al,(%eax)
    1793:	00 00                	add    %al,(%eax)
    1795:	00 00                	add    %al,(%eax)
    1797:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    179b:	00 38                	add    %bh,(%eax)
    179d:	00 00                	add    %al,(%eax)
    179f:	00 00                	add    %al,(%eax)
    17a1:	00 00                	add    %al,(%eax)
    17a3:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    17a7:	00 3a                	add    %bh,(%edx)
    17a9:	00 00                	add    %al,(%eax)
    17ab:	00 00                	add    %al,(%eax)
    17ad:	00 00                	add    %al,(%eax)
    17af:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    17b3:	00 3d 00 00 00 00    	add    %bh,0x0
    17b9:	00 00                	add    %al,(%eax)
    17bb:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    17bf:	00 3f                	add    %bh,(%edi)
    17c1:	00 00                	add    %al,(%eax)
    17c3:	00 00                	add    %al,(%eax)
    17c5:	00 00                	add    %al,(%eax)
    17c7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    17cb:	00 41 00             	add    %al,0x0(%ecx)
    17ce:	00 00                	add    %al,(%eax)
    17d0:	00 00                	add    %al,(%eax)
    17d2:	00 00                	add    %al,(%eax)
    17d4:	44                   	inc    %esp
    17d5:	00 1e                	add    %bl,(%esi)
    17d7:	00 45 00             	add    %al,0x0(%ebp)
    17da:	00 00                	add    %al,(%eax)
    17dc:	00 00                	add    %al,(%eax)
    17de:	00 00                	add    %al,(%eax)
    17e0:	44                   	inc    %esp
    17e1:	00 20                	add    %ah,(%eax)
    17e3:	00 49 00             	add    %cl,0x0(%ecx)
    17e6:	00 00                	add    %al,(%eax)
    17e8:	00 00                	add    %al,(%eax)
    17ea:	00 00                	add    %al,(%eax)
    17ec:	44                   	inc    %esp
    17ed:	00 21                	add    %ah,(%ecx)
    17ef:	00 4a 00             	add    %cl,0x0(%edx)
    17f2:	00 00                	add    %al,(%eax)
    17f4:	00 00                	add    %al,(%eax)
    17f6:	00 00                	add    %al,(%eax)
    17f8:	44                   	inc    %esp
    17f9:	00 24 00             	add    %ah,(%eax,%eax,1)
    17fc:	56                   	push   %esi
    17fd:	00 00                	add    %al,(%eax)
    17ff:	00 00                	add    %al,(%eax)
    1801:	00 00                	add    %al,(%eax)
    1803:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    1807:	00 5a 00             	add    %bl,0x0(%edx)
    180a:	00 00                	add    %al,(%eax)
    180c:	fd                   	std    
    180d:	0d 00 00 80 00       	or     $0x800000,%eax
    1812:	00 00                	add    %al,(%eax)
    1814:	f6 ff                	idiv   %bh
    1816:	ff                   	(bad)  
    1817:	ff 1f                	lcall  *(%edi)
    1819:	0e                   	push   %cs
    181a:	00 00                	add    %al,(%eax)
    181c:	40                   	inc    %eax
    181d:	00 00                	add    %al,(%eax)
    181f:	00 02                	add    %al,(%edx)
    1821:	00 00                	add    %al,(%eax)
    1823:	00 bc 0d 00 00 40 00 	add    %bh,0x400000(%ebp,%ecx,1)
    182a:	00 00                	add    %al,(%eax)
    182c:	03 00                	add    (%eax),%eax
    182e:	00 00                	add    %al,(%eax)
    1830:	00 00                	add    %al,(%eax)
    1832:	00 00                	add    %al,(%eax)
    1834:	c0 00 00             	rolb   $0x0,(%eax)
	...
    183f:	00 e0                	add    %ah,%al
    1841:	00 00                	add    %al,(%eax)
    1843:	00 62 00             	add    %ah,0x0(%edx)
    1846:	00 00                	add    %al,(%eax)
    1848:	2c 0e                	sub    $0xe,%al
    184a:	00 00                	add    %al,(%eax)
    184c:	24 00                	and    $0x0,%al
    184e:	00 00                	add    %al,(%eax)
    1850:	76 0b                	jbe    185d <bootmain-0x27e7a3>
    1852:	28 00                	sub    %al,(%eax)
    1854:	39 0e                	cmp    %ecx,(%esi)
    1856:	00 00                	add    %al,(%eax)
    1858:	a0 00 00 00 08       	mov    0x8000000,%al
    185d:	00 00                	add    %al,(%eax)
    185f:	00 72 0d             	add    %dh,0xd(%edx)
    1862:	00 00                	add    %al,(%eax)
    1864:	a0 00 00 00 0c       	mov    0xc000000,%al
    1869:	00 00                	add    %al,(%eax)
    186b:	00 00                	add    %al,(%eax)
    186d:	00 00                	add    %al,(%eax)
    186f:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
	...
    187b:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    187f:	00 01                	add    %al,(%ecx)
    1881:	00 00                	add    %al,(%eax)
    1883:	00 00                	add    %al,(%eax)
    1885:	00 00                	add    %al,(%eax)
    1887:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    188b:	00 03                	add    %al,(%ebx)
    188d:	00 00                	add    %al,(%eax)
    188f:	00 00                	add    %al,(%eax)
    1891:	00 00                	add    %al,(%eax)
    1893:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    1897:	00 05 00 00 00 00    	add    %al,0x0
    189d:	00 00                	add    %al,(%eax)
    189f:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    18a3:	00 0a                	add    %cl,(%edx)
    18a5:	00 00                	add    %al,(%eax)
    18a7:	00 00                	add    %al,(%eax)
    18a9:	00 00                	add    %al,(%eax)
    18ab:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    18af:	00 10                	add    %dl,(%eax)
    18b1:	00 00                	add    %al,(%eax)
    18b3:	00 00                	add    %al,(%eax)
    18b5:	00 00                	add    %al,(%eax)
    18b7:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    18bb:	00 13                	add    %dl,(%ebx)
    18bd:	00 00                	add    %al,(%eax)
    18bf:	00 00                	add    %al,(%eax)
    18c1:	00 00                	add    %al,(%eax)
    18c3:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    18c7:	00 18                	add    %bl,(%eax)
    18c9:	00 00                	add    %al,(%eax)
    18cb:	00 00                	add    %al,(%eax)
    18cd:	00 00                	add    %al,(%eax)
    18cf:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    18d3:	00 1b                	add    %bl,(%ebx)
    18d5:	00 00                	add    %al,(%eax)
    18d7:	00 00                	add    %al,(%eax)
    18d9:	00 00                	add    %al,(%eax)
    18db:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    18df:	00 1e                	add    %bl,(%esi)
    18e1:	00 00                	add    %al,(%eax)
    18e3:	00 00                	add    %al,(%eax)
    18e5:	00 00                	add    %al,(%eax)
    18e7:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    18eb:	00 25 00 00 00 00    	add    %ah,0x0
    18f1:	00 00                	add    %al,(%eax)
    18f3:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    18f7:	00 2c 00             	add    %ch,(%eax,%eax,1)
    18fa:	00 00                	add    %al,(%eax)
    18fc:	00 00                	add    %al,(%eax)
    18fe:	00 00                	add    %al,(%eax)
    1900:	44                   	inc    %esp
    1901:	00 3e                	add    %bh,(%esi)
    1903:	00 38                	add    %bh,(%eax)
    1905:	00 00                	add    %al,(%eax)
    1907:	00 00                	add    %al,(%eax)
    1909:	00 00                	add    %al,(%eax)
    190b:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    190f:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1912:	00 00                	add    %al,(%eax)
    1914:	00 00                	add    %al,(%eax)
    1916:	00 00                	add    %al,(%eax)
    1918:	44                   	inc    %esp
    1919:	00 3e                	add    %bh,(%esi)
    191b:	00 3f                	add    %bh,(%edi)
    191d:	00 00                	add    %al,(%eax)
    191f:	00 00                	add    %al,(%eax)
    1921:	00 00                	add    %al,(%eax)
    1923:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    1927:	00 41 00             	add    %al,0x0(%ecx)
    192a:	00 00                	add    %al,(%eax)
    192c:	00 00                	add    %al,(%eax)
    192e:	00 00                	add    %al,(%eax)
    1930:	44                   	inc    %esp
    1931:	00 41 00             	add    %al,0x0(%ecx)
    1934:	43                   	inc    %ebx
    1935:	00 00                	add    %al,(%eax)
    1937:	00 00                	add    %al,(%eax)
    1939:	00 00                	add    %al,(%eax)
    193b:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    193f:	00 4a 00             	add    %cl,0x0(%edx)
    1942:	00 00                	add    %al,(%eax)
    1944:	00 00                	add    %al,(%eax)
    1946:	00 00                	add    %al,(%eax)
    1948:	44                   	inc    %esp
    1949:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    194d:	00 00                	add    %al,(%eax)
    194f:	00 00                	add    %al,(%eax)
    1951:	00 00                	add    %al,(%eax)
    1953:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    1957:	00 55 00             	add    %dl,0x0(%ebp)
    195a:	00 00                	add    %al,(%eax)
    195c:	00 00                	add    %al,(%eax)
    195e:	00 00                	add    %al,(%eax)
    1960:	44                   	inc    %esp
    1961:	00 4a 00             	add    %cl,0x0(%edx)
    1964:	5a                   	pop    %edx
    1965:	00 00                	add    %al,(%eax)
    1967:	00 46 0e             	add    %al,0xe(%esi)
    196a:	00 00                	add    %al,(%eax)
    196c:	80 00 00             	addb   $0x0,(%eax)
    196f:	00 e2                	add    %ah,%dl
    1971:	ff                   	(bad)  
    1972:	ff                   	(bad)  
    1973:	ff                   	(bad)  
    1974:	bc 0d 00 00 40       	mov    $0x4000000d,%esp
    1979:	00 00                	add    %al,(%eax)
    197b:	00 02                	add    %al,(%edx)
    197d:	00 00                	add    %al,(%eax)
    197f:	00 00                	add    %al,(%eax)
    1981:	00 00                	add    %al,(%eax)
    1983:	00 c0                	add    %al,%al
    1985:	00 00                	add    %al,(%eax)
    1987:	00 00                	add    %al,(%eax)
    1989:	00 00                	add    %al,(%eax)
    198b:	00 1f                	add    %bl,(%edi)
    198d:	0e                   	push   %cs
    198e:	00 00                	add    %al,(%eax)
    1990:	40                   	inc    %eax
    1991:	00 00                	add    %al,(%eax)
    1993:	00 01                	add    %al,(%ecx)
    1995:	00 00                	add    %al,(%eax)
    1997:	00 00                	add    %al,(%eax)
    1999:	00 00                	add    %al,(%eax)
    199b:	00 c0                	add    %al,%al
    199d:	00 00                	add    %al,(%eax)
    199f:	00 2c 00             	add    %ch,(%eax,%eax,1)
    19a2:	00 00                	add    %al,(%eax)
    19a4:	00 00                	add    %al,(%eax)
    19a6:	00 00                	add    %al,(%eax)
    19a8:	e0 00                	loopne 19aa <bootmain-0x27e656>
    19aa:	00 00                	add    %al,(%eax)
    19ac:	38 00                	cmp    %al,(%eax)
    19ae:	00 00                	add    %al,(%eax)
    19b0:	1f                   	pop    %ds
    19b1:	0e                   	push   %cs
    19b2:	00 00                	add    %al,(%eax)
    19b4:	40                   	inc    %eax
    19b5:	00 00                	add    %al,(%eax)
    19b7:	00 01                	add    %al,(%ecx)
    19b9:	00 00                	add    %al,(%eax)
    19bb:	00 00                	add    %al,(%eax)
    19bd:	00 00                	add    %al,(%eax)
    19bf:	00 c0                	add    %al,%al
    19c1:	00 00                	add    %al,(%eax)
    19c3:	00 3c 00             	add    %bh,(%eax,%eax,1)
    19c6:	00 00                	add    %al,(%eax)
    19c8:	00 00                	add    %al,(%eax)
    19ca:	00 00                	add    %al,(%eax)
    19cc:	e0 00                	loopne 19ce <bootmain-0x27e632>
    19ce:	00 00                	add    %al,(%eax)
    19d0:	3f                   	aas    
    19d1:	00 00                	add    %al,(%eax)
    19d3:	00 00                	add    %al,(%eax)
    19d5:	00 00                	add    %al,(%eax)
    19d7:	00 e0                	add    %ah,%al
    19d9:	00 00                	add    %al,(%eax)
    19db:	00 62 00             	add    %ah,0x0(%edx)
    19de:	00 00                	add    %al,(%eax)
    19e0:	69 0e 00 00 24 00    	imul   $0x240000,(%esi),%ecx
    19e6:	00 00                	add    %al,(%eax)
    19e8:	d8 0b                	fmuls  (%ebx)
    19ea:	28 00                	sub    %al,(%eax)
    19ec:	79 0e                	jns    19fc <bootmain-0x27e604>
    19ee:	00 00                	add    %al,(%eax)
    19f0:	a0 00 00 00 08       	mov    0x8000000,%al
    19f5:	00 00                	add    %al,(%eax)
    19f7:	00 84 0e 00 00 a0 00 	add    %al,0xa00000(%esi,%ecx,1)
    19fe:	00 00                	add    %al,(%eax)
    1a00:	0c 00                	or     $0x0,%al
    1a02:	00 00                	add    %al,(%eax)
    1a04:	00 00                	add    %al,(%eax)
    1a06:	00 00                	add    %al,(%eax)
    1a08:	44                   	inc    %esp
    1a09:	00 51 00             	add    %dl,0x0(%ecx)
	...
    1a14:	44                   	inc    %esp
    1a15:	00 51 00             	add    %dl,0x0(%ecx)
    1a18:	09 00                	or     %eax,(%eax)
    1a1a:	00 00                	add    %al,(%eax)
    1a1c:	00 00                	add    %al,(%eax)
    1a1e:	00 00                	add    %al,(%eax)
    1a20:	44                   	inc    %esp
    1a21:	00 53 00             	add    %dl,0x0(%ebx)
    1a24:	0c 00                	or     $0x0,%al
    1a26:	00 00                	add    %al,(%eax)
    1a28:	00 00                	add    %al,(%eax)
    1a2a:	00 00                	add    %al,(%eax)
    1a2c:	44                   	inc    %esp
    1a2d:	00 56 00             	add    %dl,0x0(%esi)
    1a30:	0f 00 00             	sldt   (%eax)
    1a33:	00 00                	add    %al,(%eax)
    1a35:	00 00                	add    %al,(%eax)
    1a37:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    1a3b:	00 1f                	add    %bl,(%edi)
    1a3d:	00 00                	add    %al,(%eax)
    1a3f:	00 00                	add    %al,(%eax)
    1a41:	00 00                	add    %al,(%eax)
    1a43:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    1a47:	00 21                	add    %ah,(%ecx)
    1a49:	00 00                	add    %al,(%eax)
    1a4b:	00 00                	add    %al,(%eax)
    1a4d:	00 00                	add    %al,(%eax)
    1a4f:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    1a53:	00 24 00             	add    %ah,(%eax,%eax,1)
    1a56:	00 00                	add    %al,(%eax)
    1a58:	00 00                	add    %al,(%eax)
    1a5a:	00 00                	add    %al,(%eax)
    1a5c:	44                   	inc    %esp
    1a5d:	00 5a 00             	add    %bl,0x0(%edx)
    1a60:	26 00 00             	add    %al,%es:(%eax)
    1a63:	00 00                	add    %al,(%eax)
    1a65:	00 00                	add    %al,(%eax)
    1a67:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    1a6b:	00 29                	add    %ch,(%ecx)
    1a6d:	00 00                	add    %al,(%eax)
    1a6f:	00 00                	add    %al,(%eax)
    1a71:	00 00                	add    %al,(%eax)
    1a73:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    1a77:	00 2b                	add    %ch,(%ebx)
    1a79:	00 00                	add    %al,(%eax)
    1a7b:	00 00                	add    %al,(%eax)
    1a7d:	00 00                	add    %al,(%eax)
    1a7f:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    1a83:	00 3a                	add    %bh,(%edx)
    1a85:	00 00                	add    %al,(%eax)
    1a87:	00 00                	add    %al,(%eax)
    1a89:	00 00                	add    %al,(%eax)
    1a8b:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    1a8f:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1a93:	00 00                	add    %al,(%eax)
    1a95:	00 00                	add    %al,(%eax)
    1a97:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    1a9b:	00 52 00             	add    %dl,0x0(%edx)
    1a9e:	00 00                	add    %al,(%eax)
    1aa0:	00 00                	add    %al,(%eax)
    1aa2:	00 00                	add    %al,(%eax)
    1aa4:	44                   	inc    %esp
    1aa5:	00 63 00             	add    %ah,0x0(%ebx)
    1aa8:	59                   	pop    %ecx
    1aa9:	00 00                	add    %al,(%eax)
    1aab:	00 00                	add    %al,(%eax)
    1aad:	00 00                	add    %al,(%eax)
    1aaf:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    1ab3:	00 6b 00             	add    %ch,0x0(%ebx)
    1ab6:	00 00                	add    %al,(%eax)
    1ab8:	00 00                	add    %al,(%eax)
    1aba:	00 00                	add    %al,(%eax)
    1abc:	44                   	inc    %esp
    1abd:	00 63 00             	add    %ah,0x0(%ebx)
    1ac0:	71 00                	jno    1ac2 <bootmain-0x27e53e>
    1ac2:	00 00                	add    %al,(%eax)
    1ac4:	00 00                	add    %al,(%eax)
    1ac6:	00 00                	add    %al,(%eax)
    1ac8:	44                   	inc    %esp
    1ac9:	00 64 00 78          	add    %ah,0x78(%eax,%eax,1)
    1acd:	00 00                	add    %al,(%eax)
    1acf:	00 00                	add    %al,(%eax)
    1ad1:	00 00                	add    %al,(%eax)
    1ad3:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1ad7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1add:	00 00                	add    %al,(%eax)
    1adf:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1ae3:	00 87 00 00 00 00    	add    %al,0x0(%edi)
    1ae9:	00 00                	add    %al,(%eax)
    1aeb:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    1aef:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
    1af5:	00 00                	add    %al,(%eax)
    1af7:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    1afb:	00 8f 00 00 00 00    	add    %cl,0x0(%edi)
    1b01:	00 00                	add    %al,(%eax)
    1b03:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    1b07:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
    1b0d:	00 00                	add    %al,(%eax)
    1b0f:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    1b13:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
    1b19:	00 00                	add    %al,(%eax)
    1b1b:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    1b1f:	00 9f 00 00 00 00    	add    %bl,0x0(%edi)
    1b25:	00 00                	add    %al,(%eax)
    1b27:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
    1b2b:	00 a2 00 00 00 92    	add    %ah,-0x6e000000(%edx)
    1b31:	0e                   	push   %cs
    1b32:	00 00                	add    %al,(%eax)
    1b34:	40                   	inc    %eax
    1b35:	00 00                	add    %al,(%eax)
    1b37:	00 06                	add    %al,(%esi)
    1b39:	00 00                	add    %al,(%eax)
    1b3b:	00 a5 0e 00 00 80    	add    %ah,-0x7ffffff2(%ebp)
    1b41:	00 00                	add    %al,(%eax)
    1b43:	00 f6                	add    %dh,%dh
    1b45:	ff                   	(bad)  
    1b46:	ff                   	(bad)  
    1b47:	ff c5                	inc    %ebp
    1b49:	0e                   	push   %cs
    1b4a:	00 00                	add    %al,(%eax)
    1b4c:	40                   	inc    %eax
    1b4d:	00 00                	add    %al,(%eax)
    1b4f:	00 03                	add    %al,(%ebx)
    1b51:	00 00                	add    %al,(%eax)
    1b53:	00 00                	add    %al,(%eax)
    1b55:	00 00                	add    %al,(%eax)
    1b57:	00 c0                	add    %al,%al
	...
    1b61:	00 00                	add    %al,(%eax)
    1b63:	00 e0                	add    %ah,%al
    1b65:	00 00                	add    %al,(%eax)
    1b67:	00 aa 00 00 00 d0    	add    %ch,-0x30000000(%edx)
    1b6d:	0e                   	push   %cs
    1b6e:	00 00                	add    %al,(%eax)
    1b70:	24 00                	and    $0x0,%al
    1b72:	00 00                	add    %al,(%eax)
    1b74:	82                   	(bad)  
    1b75:	0c 28                	or     $0x28,%al
    1b77:	00 fd                	add    %bh,%ch
    1b79:	0c 00                	or     $0x0,%al
    1b7b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1b81:	00 00                	add    %al,(%eax)
    1b83:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    1b89:	00 00                	add    %al,(%eax)
    1b8b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1b8e:	00 00                	add    %al,(%eax)
    1b90:	e1 0e                	loope  1ba0 <bootmain-0x27e460>
    1b92:	00 00                	add    %al,(%eax)
    1b94:	a0 00 00 00 10       	mov    0x10000000,%al
    1b99:	00 00                	add    %al,(%eax)
    1b9b:	00 ea                	add    %ch,%dl
    1b9d:	0e                   	push   %cs
    1b9e:	00 00                	add    %al,(%eax)
    1ba0:	a0 00 00 00 14       	mov    0x14000000,%al
    1ba5:	00 00                	add    %al,(%eax)
    1ba7:	00 c7                	add    %al,%bh
    1ba9:	0a 00                	or     (%eax),%al
    1bab:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1bb1:	00 00                	add    %al,(%eax)
    1bb3:	00 f3                	add    %dh,%bl
    1bb5:	0e                   	push   %cs
    1bb6:	00 00                	add    %al,(%eax)
    1bb8:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1bbd:	00 00                	add    %al,(%eax)
    1bbf:	00 00                	add    %al,(%eax)
    1bc1:	00 00                	add    %al,(%eax)
    1bc3:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
	...
    1bcf:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1bd3:	00 01                	add    %al,(%ecx)
    1bd5:	00 00                	add    %al,(%eax)
    1bd7:	00 00                	add    %al,(%eax)
    1bd9:	00 00                	add    %al,(%eax)
    1bdb:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1bdf:	00 03                	add    %al,(%ebx)
    1be1:	00 00                	add    %al,(%eax)
    1be3:	00 00                	add    %al,(%eax)
    1be5:	00 00                	add    %al,(%eax)
    1be7:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1beb:	00 06                	add    %al,(%esi)
    1bed:	00 00                	add    %al,(%eax)
    1bef:	00 00                	add    %al,(%eax)
    1bf1:	00 00                	add    %al,(%eax)
    1bf3:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1bf7:	00 0b                	add    %cl,(%ebx)
    1bf9:	00 00                	add    %al,(%eax)
    1bfb:	00 00                	add    %al,(%eax)
    1bfd:	00 00                	add    %al,(%eax)
    1bff:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1c03:	00 10                	add    %dl,(%eax)
    1c05:	00 00                	add    %al,(%eax)
    1c07:	00 00                	add    %al,(%eax)
    1c09:	00 00                	add    %al,(%eax)
    1c0b:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1c0f:	00 23                	add    %ah,(%ebx)
    1c11:	00 00                	add    %al,(%eax)
    1c13:	00 00                	add    %al,(%eax)
    1c15:	00 00                	add    %al,(%eax)
    1c17:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    1c1b:	00 26                	add    %ah,(%esi)
    1c1d:	00 00                	add    %al,(%eax)
    1c1f:	00 00                	add    %al,(%eax)
    1c21:	00 00                	add    %al,(%eax)
    1c23:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1c27:	00 28                	add    %ch,(%eax)
    1c29:	00 00                	add    %al,(%eax)
    1c2b:	00 00                	add    %al,(%eax)
    1c2d:	00 00                	add    %al,(%eax)
    1c2f:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    1c33:	00 34 00             	add    %dh,(%eax,%eax,1)
    1c36:	00 00                	add    %al,(%eax)
    1c38:	00 00                	add    %al,(%eax)
    1c3a:	00 00                	add    %al,(%eax)
    1c3c:	44                   	inc    %esp
    1c3d:	00 9a 00 3a 00 00    	add    %bl,0x3a00(%edx)
    1c43:	00 00                	add    %al,(%eax)
    1c45:	00 00                	add    %al,(%eax)
    1c47:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1c4b:	00 40 00             	add    %al,0x0(%eax)
    1c4e:	00 00                	add    %al,(%eax)
    1c50:	00 00                	add    %al,(%eax)
    1c52:	00 00                	add    %al,(%eax)
    1c54:	44                   	inc    %esp
    1c55:	00 aa 00 49 00 00    	add    %ch,0x4900(%edx)
    1c5b:	00 ff                	add    %bh,%bh
    1c5d:	0e                   	push   %cs
    1c5e:	00 00                	add    %al,(%eax)
    1c60:	40                   	inc    %eax
    1c61:	00 00                	add    %al,(%eax)
    1c63:	00 02                	add    %al,(%edx)
    1c65:	00 00                	add    %al,(%eax)
    1c67:	00 0a                	add    %cl,(%edx)
    1c69:	0f 00 00             	sldt   (%eax)
    1c6c:	40                   	inc    %eax
    1c6d:	00 00                	add    %al,(%eax)
    1c6f:	00 01                	add    %al,(%ecx)
    1c71:	00 00                	add    %al,(%eax)
    1c73:	00 00                	add    %al,(%eax)
    1c75:	00 00                	add    %al,(%eax)
    1c77:	00 c0                	add    %al,%al
	...
    1c81:	00 00                	add    %al,(%eax)
    1c83:	00 e0                	add    %ah,%al
    1c85:	00 00                	add    %al,(%eax)
    1c87:	00 51 00             	add    %dl,0x0(%ecx)
    1c8a:	00 00                	add    %al,(%eax)
    1c8c:	15 0f 00 00 24       	adc    $0x2400000f,%eax
    1c91:	00 00                	add    %al,(%eax)
    1c93:	00 d3                	add    %dl,%bl
    1c95:	0c 28                	or     $0x28,%al
    1c97:	00 fd                	add    %bh,%ch
    1c99:	0c 00                	or     $0x0,%al
    1c9b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1ca1:	00 00                	add    %al,(%eax)
    1ca3:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    1ca9:	00 00                	add    %al,(%eax)
    1cab:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1cae:	00 00                	add    %al,(%eax)
    1cb0:	e1 0e                	loope  1cc0 <bootmain-0x27e340>
    1cb2:	00 00                	add    %al,(%eax)
    1cb4:	a0 00 00 00 10       	mov    0x10000000,%al
    1cb9:	00 00                	add    %al,(%eax)
    1cbb:	00 ea                	add    %ch,%dl
    1cbd:	0e                   	push   %cs
    1cbe:	00 00                	add    %al,(%eax)
    1cc0:	a0 00 00 00 14       	mov    0x14000000,%al
    1cc5:	00 00                	add    %al,(%eax)
    1cc7:	00 c7                	add    %al,%bh
    1cc9:	0a 00                	or     (%eax),%al
    1ccb:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1cd1:	00 00                	add    %al,(%eax)
    1cd3:	00 23                	add    %ah,(%ebx)
    1cd5:	0f 00 00             	sldt   (%eax)
    1cd8:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1cdd:	00 00                	add    %al,(%eax)
    1cdf:	00 00                	add    %al,(%eax)
    1ce1:	00 00                	add    %al,(%eax)
    1ce3:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
	...
    1cef:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1cf3:	00 08                	add    %cl,(%eax)
    1cf5:	00 00                	add    %al,(%eax)
    1cf7:	00 00                	add    %al,(%eax)
    1cf9:	00 00                	add    %al,(%eax)
    1cfb:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
    1cff:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1d02:	00 00                	add    %al,(%eax)
    1d04:	00 00                	add    %al,(%eax)
    1d06:	00 00                	add    %al,(%eax)
    1d08:	44                   	inc    %esp
    1d09:	00 73 00             	add    %dh,0x0(%ebx)
    1d0c:	0d 00 00 00 00       	or     $0x0,%eax
    1d11:	00 00                	add    %al,(%eax)
    1d13:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    1d17:	00 10                	add    %dl,(%eax)
    1d19:	00 00                	add    %al,(%eax)
    1d1b:	00 00                	add    %al,(%eax)
    1d1d:	00 00                	add    %al,(%eax)
    1d1f:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    1d23:	00 1a                	add    %bl,(%edx)
    1d25:	00 00                	add    %al,(%eax)
    1d27:	00 00                	add    %al,(%eax)
    1d29:	00 00                	add    %al,(%eax)
    1d2b:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
    1d2f:	00 1e                	add    %bl,(%esi)
    1d31:	00 00                	add    %al,(%eax)
    1d33:	00 00                	add    %al,(%eax)
    1d35:	00 00                	add    %al,(%eax)
    1d37:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1d3b:	00 23                	add    %ah,(%ebx)
    1d3d:	00 00                	add    %al,(%eax)
    1d3f:	00 00                	add    %al,(%eax)
    1d41:	00 00                	add    %al,(%eax)
    1d43:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    1d47:	00 2f                	add    %ch,(%edi)
    1d49:	00 00                	add    %al,(%eax)
    1d4b:	00 00                	add    %al,(%eax)
    1d4d:	00 00                	add    %al,(%eax)
    1d4f:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1d53:	00 32                	add    %dh,(%edx)
    1d55:	00 00                	add    %al,(%eax)
    1d57:	00 00                	add    %al,(%eax)
    1d59:	00 00                	add    %al,(%eax)
    1d5b:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    1d5f:	00 3d 00 00 00 00    	add    %bh,0x0
    1d65:	00 00                	add    %al,(%eax)
    1d67:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
    1d6b:	00 45 00             	add    %al,0x0(%ebp)
    1d6e:	00 00                	add    %al,(%eax)
    1d70:	00 00                	add    %al,(%eax)
    1d72:	00 00                	add    %al,(%eax)
    1d74:	44                   	inc    %esp
    1d75:	00 85 00 48 00 00    	add    %al,0x4800(%ebp)
    1d7b:	00 00                	add    %al,(%eax)
    1d7d:	00 00                	add    %al,(%eax)
    1d7f:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    1d83:	00 50 00             	add    %dl,0x0(%eax)
    1d86:	00 00                	add    %al,(%eax)
    1d88:	00 00                	add    %al,(%eax)
    1d8a:	00 00                	add    %al,(%eax)
    1d8c:	44                   	inc    %esp
    1d8d:	00 87 00 52 00 00    	add    %al,0x5200(%edi)
    1d93:	00 00                	add    %al,(%eax)
    1d95:	00 00                	add    %al,(%eax)
    1d97:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
    1d9b:	00 54 00 00          	add    %dl,0x0(%eax,%eax,1)
    1d9f:	00 00                	add    %al,(%eax)
    1da1:	00 00                	add    %al,(%eax)
    1da3:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
    1da7:	00 59 00             	add    %bl,0x0(%ecx)
    1daa:	00 00                	add    %al,(%eax)
    1dac:	d4 0c                	aam    $0xc
    1dae:	00 00                	add    %al,(%eax)
    1db0:	40                   	inc    %eax
    1db1:	00 00                	add    %al,(%eax)
    1db3:	00 03                	add    %al,(%ebx)
    1db5:	00 00                	add    %al,(%eax)
    1db7:	00 54 0d 00          	add    %dl,0x0(%ebp,%ecx,1)
    1dbb:	00 40 00             	add    %al,0x0(%eax)
    1dbe:	00 00                	add    %al,(%eax)
    1dc0:	07                   	pop    %es
    1dc1:	00 00                	add    %al,(%eax)
    1dc3:	00 2f                	add    %ch,(%edi)
    1dc5:	0f 00 00             	sldt   (%eax)
    1dc8:	24 00                	and    $0x0,%al
    1dca:	00 00                	add    %al,(%eax)
    1dcc:	34 0d                	xor    $0xd,%al
    1dce:	28 00                	sub    %al,(%eax)
    1dd0:	42                   	inc    %edx
    1dd1:	0f 00 00             	sldt   (%eax)
    1dd4:	a0 00 00 00 08       	mov    0x8000000,%al
    1dd9:	00 00                	add    %al,(%eax)
    1ddb:	00 4b 0f             	add    %cl,0xf(%ebx)
    1dde:	00 00                	add    %al,(%eax)
    1de0:	a0 00 00 00 0c       	mov    0xc000000,%al
    1de5:	00 00                	add    %al,(%eax)
    1de7:	00 00                	add    %al,(%eax)
    1de9:	00 00                	add    %al,(%eax)
    1deb:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    1df7:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1dfb:	00 07                	add    %al,(%edi)
    1dfd:	00 00                	add    %al,(%eax)
    1dff:	00 00                	add    %al,(%eax)
    1e01:	00 00                	add    %al,(%eax)
    1e03:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1e07:	00 18                	add    %bl,(%eax)
    1e09:	00 00                	add    %al,(%eax)
    1e0b:	00 00                	add    %al,(%eax)
    1e0d:	00 00                	add    %al,(%eax)
    1e0f:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1e13:	00 35 00 00 00 54    	add    %dh,0x54000000
    1e19:	0f 00 00             	sldt   (%eax)
    1e1c:	80 00 00             	addb   $0x0,(%eax)
    1e1f:	00 e2                	add    %ah,%dl
    1e21:	ff                   	(bad)  
    1e22:	ff                   	(bad)  
    1e23:	ff 00                	incl   (%eax)
    1e25:	00 00                	add    %al,(%eax)
    1e27:	00 c0                	add    %al,%al
	...
    1e31:	00 00                	add    %al,(%eax)
    1e33:	00 e0                	add    %ah,%al
    1e35:	00 00                	add    %al,(%eax)
    1e37:	00 3a                	add    %bh,(%edx)
    1e39:	00 00                	add    %al,(%eax)
    1e3b:	00 73 0f             	add    %dh,0xf(%ebx)
    1e3e:	00 00                	add    %al,(%eax)
    1e40:	24 00                	and    $0x0,%al
    1e42:	00 00                	add    %al,(%eax)
    1e44:	6e                   	outsb  %ds:(%esi),(%dx)
    1e45:	0d 28 00 fd 0c       	or     $0xcfd0028,%eax
    1e4a:	00 00                	add    %al,(%eax)
    1e4c:	a0 00 00 00 08       	mov    0x8000000,%al
    1e51:	00 00                	add    %al,(%eax)
    1e53:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    1e59:	00 00                	add    %al,(%eax)
    1e5b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1e5e:	00 00                	add    %al,(%eax)
    1e60:	e1 0e                	loope  1e70 <bootmain-0x27e190>
    1e62:	00 00                	add    %al,(%eax)
    1e64:	a0 00 00 00 10       	mov    0x10000000,%al
    1e69:	00 00                	add    %al,(%eax)
    1e6b:	00 ea                	add    %ch,%dl
    1e6d:	0e                   	push   %cs
    1e6e:	00 00                	add    %al,(%eax)
    1e70:	a0 00 00 00 14       	mov    0x14000000,%al
    1e75:	00 00                	add    %al,(%eax)
    1e77:	00 c7                	add    %al,%bh
    1e79:	0a 00                	or     (%eax),%al
    1e7b:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1e81:	00 00                	add    %al,(%eax)
    1e83:	00 85 0f 00 00 a0    	add    %al,-0x5ffffff1(%ebp)
    1e89:	00 00                	add    %al,(%eax)
    1e8b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1e8e:	00 00                	add    %al,(%eax)
    1e90:	00 00                	add    %al,(%eax)
    1e92:	00 00                	add    %al,(%eax)
    1e94:	44                   	inc    %esp
    1e95:	00 c6                	add    %al,%dh
	...
    1e9f:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    1ea3:	00 10                	add    %dl,(%eax)
    1ea5:	00 00                	add    %al,(%eax)
    1ea7:	00 00                	add    %al,(%eax)
    1ea9:	00 00                	add    %al,(%eax)
    1eab:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    1eaf:	00 1b                	add    %bl,(%ebx)
    1eb1:	00 00                	add    %al,(%eax)
    1eb3:	00 00                	add    %al,(%eax)
    1eb5:	00 00                	add    %al,(%eax)
    1eb7:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    1ebb:	00 20                	add    %ah,(%eax)
    1ebd:	00 00                	add    %al,(%eax)
    1ebf:	00 00                	add    %al,(%eax)
    1ec1:	00 00                	add    %al,(%eax)
    1ec3:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1ec7:	00 31                	add    %dh,(%ecx)
    1ec9:	00 00                	add    %al,(%eax)
    1ecb:	00 00                	add    %al,(%eax)
    1ecd:	00 00                	add    %al,(%eax)
    1ecf:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    1ed3:	00 33                	add    %dh,(%ebx)
    1ed5:	00 00                	add    %al,(%eax)
    1ed7:	00 00                	add    %al,(%eax)
    1ed9:	00 00                	add    %al,(%eax)
    1edb:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    1edf:	00 38                	add    %bh,(%eax)
    1ee1:	00 00                	add    %al,(%eax)
    1ee3:	00 00                	add    %al,(%eax)
    1ee5:	00 00                	add    %al,(%eax)
    1ee7:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1eeb:	00 3b                	add    %bh,(%ebx)
    1eed:	00 00                	add    %al,(%eax)
    1eef:	00 00                	add    %al,(%eax)
    1ef1:	00 00                	add    %al,(%eax)
    1ef3:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    1ef7:	00 41 00             	add    %al,0x0(%ecx)
    1efa:	00 00                	add    %al,(%eax)
    1efc:	00 00                	add    %al,(%eax)
    1efe:	00 00                	add    %al,(%eax)
    1f00:	44                   	inc    %esp
    1f01:	00 de                	add    %bl,%dh
    1f03:	00 4a 00             	add    %cl,0x0(%edx)
    1f06:	00 00                	add    %al,(%eax)
    1f08:	ff 0e                	decl   (%esi)
    1f0a:	00 00                	add    %al,(%eax)
    1f0c:	40                   	inc    %eax
    1f0d:	00 00                	add    %al,(%eax)
    1f0f:	00 02                	add    %al,(%edx)
    1f11:	00 00                	add    %al,(%eax)
    1f13:	00 0a                	add    %cl,(%edx)
    1f15:	0f 00 00             	sldt   (%eax)
    1f18:	40                   	inc    %eax
    1f19:	00 00                	add    %al,(%eax)
    1f1b:	00 00                	add    %al,(%eax)
    1f1d:	00 00                	add    %al,(%eax)
    1f1f:	00 dd                	add    %bl,%ch
    1f21:	0a 00                	or     (%eax),%al
    1f23:	00 40 00             	add    %al,0x0(%eax)
    1f26:	00 00                	add    %al,(%eax)
    1f28:	03 00                	add    (%eax),%eax
    1f2a:	00 00                	add    %al,(%eax)
    1f2c:	00 00                	add    %al,(%eax)
    1f2e:	00 00                	add    %al,(%eax)
    1f30:	c0 00 00             	rolb   $0x0,(%eax)
	...
    1f3b:	00 e0                	add    %ah,%al
    1f3d:	00 00                	add    %al,(%eax)
    1f3f:	00 50 00             	add    %dl,0x0(%eax)
    1f42:	00 00                	add    %al,(%eax)
    1f44:	99                   	cltd   
    1f45:	0f 00 00             	sldt   (%eax)
    1f48:	24 00                	and    $0x0,%al
    1f4a:	00 00                	add    %al,(%eax)
    1f4c:	be 0d 28 00 fd       	mov    $0xfd00280d,%esi
    1f51:	0c 00                	or     $0x0,%al
    1f53:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1f59:	00 00                	add    %al,(%eax)
    1f5b:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    1f61:	00 00                	add    %al,(%eax)
    1f63:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1f66:	00 00                	add    %al,(%eax)
    1f68:	e1 0e                	loope  1f78 <bootmain-0x27e088>
    1f6a:	00 00                	add    %al,(%eax)
    1f6c:	a0 00 00 00 10       	mov    0x10000000,%al
    1f71:	00 00                	add    %al,(%eax)
    1f73:	00 ea                	add    %ch,%dl
    1f75:	0e                   	push   %cs
    1f76:	00 00                	add    %al,(%eax)
    1f78:	a0 00 00 00 14       	mov    0x14000000,%al
    1f7d:	00 00                	add    %al,(%eax)
    1f7f:	00 c7                	add    %al,%bh
    1f81:	0a 00                	or     (%eax),%al
    1f83:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1f89:	00 00                	add    %al,(%eax)
    1f8b:	00 f3                	add    %dh,%bl
    1f8d:	0e                   	push   %cs
    1f8e:	00 00                	add    %al,(%eax)
    1f90:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1f95:	00 00                	add    %al,(%eax)
    1f97:	00 00                	add    %al,(%eax)
    1f99:	00 00                	add    %al,(%eax)
    1f9b:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
	...
    1fa7:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1fab:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1fae:	00 00                	add    %al,(%eax)
    1fb0:	00 00                	add    %al,(%eax)
    1fb2:	00 00                	add    %al,(%eax)
    1fb4:	44                   	inc    %esp
    1fb5:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    1fbb:	00 00                	add    %al,(%eax)
    1fbd:	00 00                	add    %al,(%eax)
    1fbf:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    1fc3:	00 1a                	add    %bl,(%edx)
    1fc5:	00 00                	add    %al,(%eax)
    1fc7:	00 00                	add    %al,(%eax)
    1fc9:	00 00                	add    %al,(%eax)
    1fcb:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
    1fcf:	00 1e                	add    %bl,(%esi)
    1fd1:	00 00                	add    %al,(%eax)
    1fd3:	00 00                	add    %al,(%eax)
    1fd5:	00 00                	add    %al,(%eax)
    1fd7:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    1fdb:	00 21                	add    %ah,(%ecx)
    1fdd:	00 00                	add    %al,(%eax)
    1fdf:	00 00                	add    %al,(%eax)
    1fe1:	00 00                	add    %al,(%eax)
    1fe3:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    1fe7:	00 25 00 00 00 00    	add    %ah,0x0
    1fed:	00 00                	add    %al,(%eax)
    1fef:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1ff3:	00 2d 00 00 00 00    	add    %ch,0x0
    1ff9:	00 00                	add    %al,(%eax)
    1ffb:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    1fff:	00 31                	add    %dh,(%ecx)
    2001:	00 00                	add    %al,(%eax)
    2003:	00 00                	add    %al,(%eax)
    2005:	00 00                	add    %al,(%eax)
    2007:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    200b:	00 34 00             	add    %dh,(%eax,%eax,1)
    200e:	00 00                	add    %al,(%eax)
    2010:	00 00                	add    %al,(%eax)
    2012:	00 00                	add    %al,(%eax)
    2014:	44                   	inc    %esp
    2015:	00 bb 00 3f 00 00    	add    %bh,0x3f00(%ebx)
    201b:	00 00                	add    %al,(%eax)
    201d:	00 00                	add    %al,(%eax)
    201f:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    2023:	00 42 00             	add    %al,0x0(%edx)
    2026:	00 00                	add    %al,(%eax)
    2028:	00 00                	add    %al,(%eax)
    202a:	00 00                	add    %al,(%eax)
    202c:	44                   	inc    %esp
    202d:	00 c4                	add    %al,%ah
    202f:	00 47 00             	add    %al,0x0(%edi)
    2032:	00 00                	add    %al,(%eax)
    2034:	d4 0c                	aam    $0xc
    2036:	00 00                	add    %al,(%eax)
    2038:	40                   	inc    %eax
    2039:	00 00                	add    %al,(%eax)
    203b:	00 07                	add    %al,(%edi)
    203d:	00 00                	add    %al,(%eax)
    203f:	00 54 0d 00          	add    %dl,0x0(%ebp,%ecx,1)
    2043:	00 40 00             	add    %al,0x0(%eax)
    2046:	00 00                	add    %al,(%eax)
    2048:	06                   	push   %es
    2049:	00 00                	add    %al,(%eax)
    204b:	00 00                	add    %al,(%eax)
    204d:	00 00                	add    %al,(%eax)
    204f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    2053:	00 0d 0e 28 00 a8    	add    %cl,0xa800280e
    2059:	0f 00 00             	sldt   (%eax)
    205c:	64 00 02             	add    %al,%fs:(%edx)
    205f:	00 0d 0e 28 00 08    	add    %cl,0x800280e
    2065:	00 00                	add    %al,(%eax)
    2067:	00 3c 00             	add    %bh,(%eax,%eax,1)
    206a:	00 00                	add    %al,(%eax)
    206c:	00 00                	add    %al,(%eax)
    206e:	00 00                	add    %al,(%eax)
    2070:	17                   	pop    %ss
    2071:	00 00                	add    %al,(%eax)
    2073:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2079:	00 00                	add    %al,(%eax)
    207b:	00 41 00             	add    %al,0x0(%ecx)
    207e:	00 00                	add    %al,(%eax)
    2080:	80 00 00             	addb   $0x0,(%eax)
    2083:	00 00                	add    %al,(%eax)
    2085:	00 00                	add    %al,(%eax)
    2087:	00 5b 00             	add    %bl,0x0(%ebx)
    208a:	00 00                	add    %al,(%eax)
    208c:	80 00 00             	addb   $0x0,(%eax)
    208f:	00 00                	add    %al,(%eax)
    2091:	00 00                	add    %al,(%eax)
    2093:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2099:	00 00                	add    %al,(%eax)
    209b:	00 00                	add    %al,(%eax)
    209d:	00 00                	add    %al,(%eax)
    209f:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    20a5:	00 00                	add    %al,(%eax)
    20a7:	00 00                	add    %al,(%eax)
    20a9:	00 00                	add    %al,(%eax)
    20ab:	00 e1                	add    %ah,%cl
    20ad:	00 00                	add    %al,(%eax)
    20af:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    20b5:	00 00                	add    %al,(%eax)
    20b7:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    20ba:	00 00                	add    %al,(%eax)
    20bc:	80 00 00             	addb   $0x0,(%eax)
    20bf:	00 00                	add    %al,(%eax)
    20c1:	00 00                	add    %al,(%eax)
    20c3:	00 37                	add    %dh,(%edi)
    20c5:	01 00                	add    %eax,(%eax)
    20c7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    20cd:	00 00                	add    %al,(%eax)
    20cf:	00 5d 01             	add    %bl,0x1(%ebp)
    20d2:	00 00                	add    %al,(%eax)
    20d4:	80 00 00             	addb   $0x0,(%eax)
    20d7:	00 00                	add    %al,(%eax)
    20d9:	00 00                	add    %al,(%eax)
    20db:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    20e1:	00 00                	add    %al,(%eax)
    20e3:	00 00                	add    %al,(%eax)
    20e5:	00 00                	add    %al,(%eax)
    20e7:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    20ed:	00 00                	add    %al,(%eax)
    20ef:	00 00                	add    %al,(%eax)
    20f1:	00 00                	add    %al,(%eax)
    20f3:	00 d2                	add    %dl,%dl
    20f5:	01 00                	add    %eax,(%eax)
    20f7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    20fd:	00 00                	add    %al,(%eax)
    20ff:	00 ec                	add    %ch,%ah
    2101:	01 00                	add    %eax,(%eax)
    2103:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2109:	00 00                	add    %al,(%eax)
    210b:	00 07                	add    %al,(%edi)
    210d:	02 00                	add    (%eax),%al
    210f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2115:	00 00                	add    %al,(%eax)
    2117:	00 28                	add    %ch,(%eax)
    2119:	02 00                	add    (%eax),%al
    211b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2121:	00 00                	add    %al,(%eax)
    2123:	00 47 02             	add    %al,0x2(%edi)
    2126:	00 00                	add    %al,(%eax)
    2128:	80 00 00             	addb   $0x0,(%eax)
    212b:	00 00                	add    %al,(%eax)
    212d:	00 00                	add    %al,(%eax)
    212f:	00 66 02             	add    %ah,0x2(%esi)
    2132:	00 00                	add    %al,(%eax)
    2134:	80 00 00             	addb   $0x0,(%eax)
    2137:	00 00                	add    %al,(%eax)
    2139:	00 00                	add    %al,(%eax)
    213b:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2141:	00 00                	add    %al,(%eax)
    2143:	00 00                	add    %al,(%eax)
    2145:	00 00                	add    %al,(%eax)
    2147:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    214d:	00 00                	add    %al,(%eax)
    214f:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    2155:	02 00                	add    (%eax),%al
    2157:	00 c2                	add    %al,%dl
    2159:	00 00                	add    %al,(%eax)
    215b:	00 00                	add    %al,(%eax)
    215d:	00 00                	add    %al,(%eax)
    215f:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    2165:	00 00                	add    %al,(%eax)
    2167:	00 37                	add    %dh,(%edi)
    2169:	53                   	push   %ebx
    216a:	00 00                	add    %al,(%eax)
    216c:	29 04 00             	sub    %eax,(%eax,%eax,1)
    216f:	00 c2                	add    %al,%dl
    2171:	00 00                	add    %al,(%eax)
    2173:	00 17                	add    %dl,(%edi)
    2175:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    2176:	00 00                	add    %al,(%eax)
    2178:	b1 0f                	mov    $0xf,%cl
    217a:	00 00                	add    %al,(%eax)
    217c:	24 00                	and    $0x0,%al
    217e:	00 00                	add    %al,(%eax)
    2180:	0d 0e 28 00 c0       	or     $0xc000280e,%eax
    2185:	0f 00 00             	sldt   (%eax)
    2188:	a0 00 00 00 08       	mov    0x8000000,%al
    218d:	00 00                	add    %al,(%eax)
    218f:	00 d2                	add    %dl,%dl
    2191:	0f 00 00             	sldt   (%eax)
    2194:	a0 00 00 00 0c       	mov    0xc000000,%al
    2199:	00 00                	add    %al,(%eax)
    219b:	00 df                	add    %bl,%bh
    219d:	0f 00 00             	sldt   (%eax)
    21a0:	a0 00 00 00 10       	mov    0x10000000,%al
    21a5:	00 00                	add    %al,(%eax)
    21a7:	00 eb                	add    %ch,%bl
    21a9:	0f 00 00             	sldt   (%eax)
    21ac:	a0 00 00 00 14       	mov    0x14000000,%al
    21b1:	00 00                	add    %al,(%eax)
    21b3:	00 00                	add    %al,(%eax)
    21b5:	00 00                	add    %al,(%eax)
    21b7:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
	...
    21c3:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    21c7:	00 0f                	add    %cl,(%edi)
    21c9:	00 00                	add    %al,(%eax)
    21cb:	00 00                	add    %al,(%eax)
    21cd:	00 00                	add    %al,(%eax)
    21cf:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    21d3:	00 12                	add    %dl,(%edx)
    21d5:	00 00                	add    %al,(%eax)
    21d7:	00 00                	add    %al,(%eax)
    21d9:	00 00                	add    %al,(%eax)
    21db:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    21df:	00 1a                	add    %bl,(%edx)
    21e1:	00 00                	add    %al,(%eax)
    21e3:	00 00                	add    %al,(%eax)
    21e5:	00 00                	add    %al,(%eax)
    21e7:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    21eb:	00 20                	add    %ah,(%eax)
    21ed:	00 00                	add    %al,(%eax)
    21ef:	00 00                	add    %al,(%eax)
    21f1:	00 00                	add    %al,(%eax)
    21f3:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    21f7:	00 23                	add    %ah,(%ebx)
    21f9:	00 00                	add    %al,(%eax)
    21fb:	00 00                	add    %al,(%eax)
    21fd:	00 00                	add    %al,(%eax)
    21ff:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    2203:	00 2d 00 00 00 00    	add    %ch,0x0
    2209:	00 00                	add    %al,(%eax)
    220b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    220f:	00 2f                	add    %ch,(%edi)
    2211:	00 00                	add    %al,(%eax)
    2213:	00 00                	add    %al,(%eax)
    2215:	00 00                	add    %al,(%eax)
    2217:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    221b:	00 32                	add    %dh,(%edx)
    221d:	00 00                	add    %al,(%eax)
    221f:	00 00                	add    %al,(%eax)
    2221:	00 00                	add    %al,(%eax)
    2223:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    2227:	00 35 00 00 00 00    	add    %dh,0x0
    222d:	00 00                	add    %al,(%eax)
    222f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    2233:	00 37                	add    %dh,(%edi)
    2235:	00 00                	add    %al,(%eax)
    2237:	00 00                	add    %al,(%eax)
    2239:	00 00                	add    %al,(%eax)
    223b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    223f:	00 3a                	add    %bh,(%edx)
    2241:	00 00                	add    %al,(%eax)
    2243:	00 00                	add    %al,(%eax)
    2245:	00 00                	add    %al,(%eax)
    2247:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    224b:	00 40 00             	add    %al,0x0(%eax)
    224e:	00 00                	add    %al,(%eax)
    2250:	00 00                	add    %al,(%eax)
    2252:	00 00                	add    %al,(%eax)
    2254:	44                   	inc    %esp
    2255:	00 11                	add    %dl,(%ecx)
    2257:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    225b:	00 00                	add    %al,(%eax)
    225d:	00 00                	add    %al,(%eax)
    225f:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    2263:	00 46 00             	add    %al,0x0(%esi)
    2266:	00 00                	add    %al,(%eax)
    2268:	00 00                	add    %al,(%eax)
    226a:	00 00                	add    %al,(%eax)
    226c:	44                   	inc    %esp
    226d:	00 11                	add    %dl,(%ecx)
    226f:	00 49 00             	add    %cl,0x0(%ecx)
    2272:	00 00                	add    %al,(%eax)
    2274:	00 00                	add    %al,(%eax)
    2276:	00 00                	add    %al,(%eax)
    2278:	44                   	inc    %esp
    2279:	00 12                	add    %dl,(%edx)
    227b:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    227f:	00 00                	add    %al,(%eax)
    2281:	00 00                	add    %al,(%eax)
    2283:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    2287:	00 4f 00             	add    %cl,0x0(%edi)
    228a:	00 00                	add    %al,(%eax)
    228c:	f9                   	stc    
    228d:	0f 00 00             	sldt   (%eax)
    2290:	40                   	inc    %eax
    2291:	00 00                	add    %al,(%eax)
    2293:	00 00                	add    %al,(%eax)
    2295:	00 00                	add    %al,(%eax)
    2297:	00 04 10             	add    %al,(%eax,%edx,1)
    229a:	00 00                	add    %al,(%eax)
    229c:	40                   	inc    %eax
    229d:	00 00                	add    %al,(%eax)
    229f:	00 02                	add    %al,(%edx)
    22a1:	00 00                	add    %al,(%eax)
    22a3:	00 11                	add    %dl,(%ecx)
    22a5:	10 00                	adc    %al,(%eax)
    22a7:	00 40 00             	add    %al,0x0(%eax)
    22aa:	00 00                	add    %al,(%eax)
    22ac:	03 00                	add    (%eax),%eax
    22ae:	00 00                	add    %al,(%eax)
    22b0:	1d 10 00 00 40       	sbb    $0x40000010,%eax
    22b5:	00 00                	add    %al,(%eax)
    22b7:	00 07                	add    %al,(%edi)
    22b9:	00 00                	add    %al,(%eax)
    22bb:	00 2b                	add    %ch,(%ebx)
    22bd:	10 00                	adc    %al,(%eax)
    22bf:	00 24 00             	add    %ah,(%eax,%eax,1)
    22c2:	00 00                	add    %al,(%eax)
    22c4:	61                   	popa   
    22c5:	0e                   	push   %cs
    22c6:	28 00                	sub    %al,(%eax)
    22c8:	3a 10                	cmp    (%eax),%dl
    22ca:	00 00                	add    %al,(%eax)
    22cc:	a0 00 00 00 08       	mov    0x8000000,%al
    22d1:	00 00                	add    %al,(%eax)
    22d3:	00 4c 10 00          	add    %cl,0x0(%eax,%edx,1)
    22d7:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    22dd:	00 00                	add    %al,(%eax)
    22df:	00 5a 10             	add    %bl,0x10(%edx)
    22e2:	00 00                	add    %al,(%eax)
    22e4:	a0 00 00 00 10       	mov    0x10000000,%al
    22e9:	00 00                	add    %al,(%eax)
    22eb:	00 eb                	add    %ch,%bl
    22ed:	0f 00 00             	sldt   (%eax)
    22f0:	a0 00 00 00 14       	mov    0x14000000,%al
    22f5:	00 00                	add    %al,(%eax)
    22f7:	00 00                	add    %al,(%eax)
    22f9:	00 00                	add    %al,(%eax)
    22fb:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
	...
    2307:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    230b:	00 03                	add    %al,(%ebx)
    230d:	00 00                	add    %al,(%eax)
    230f:	00 00                	add    %al,(%eax)
    2311:	00 00                	add    %al,(%eax)
    2313:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    2317:	00 0c 00             	add    %cl,(%eax,%eax,1)
    231a:	00 00                	add    %al,(%eax)
    231c:	00 00                	add    %al,(%eax)
    231e:	00 00                	add    %al,(%eax)
    2320:	44                   	inc    %esp
    2321:	00 1a                	add    %bl,(%edx)
    2323:	00 0f                	add    %cl,(%edi)
    2325:	00 00                	add    %al,(%eax)
    2327:	00 00                	add    %al,(%eax)
    2329:	00 00                	add    %al,(%eax)
    232b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    232f:	00 16                	add    %dl,(%esi)
    2331:	00 00                	add    %al,(%eax)
    2333:	00 00                	add    %al,(%eax)
    2335:	00 00                	add    %al,(%eax)
    2337:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    233b:	00 19                	add    %bl,(%ecx)
    233d:	00 00                	add    %al,(%eax)
    233f:	00 00                	add    %al,(%eax)
    2341:	00 00                	add    %al,(%eax)
    2343:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    2347:	00 1c 00             	add    %bl,(%eax,%eax,1)
    234a:	00 00                	add    %al,(%eax)
    234c:	00 00                	add    %al,(%eax)
    234e:	00 00                	add    %al,(%eax)
    2350:	44                   	inc    %esp
    2351:	00 1f                	add    %bl,(%edi)
    2353:	00 20                	add    %ah,(%eax)
    2355:	00 00                	add    %al,(%eax)
    2357:	00 00                	add    %al,(%eax)
    2359:	00 00                	add    %al,(%eax)
    235b:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    235f:	00 28                	add    %ch,(%eax)
    2361:	00 00                	add    %al,(%eax)
    2363:	00 6a 10             	add    %ch,0x10(%edx)
    2366:	00 00                	add    %al,(%eax)
    2368:	40                   	inc    %eax
    2369:	00 00                	add    %al,(%eax)
    236b:	00 00                	add    %al,(%eax)
    236d:	00 00                	add    %al,(%eax)
    236f:	00 75 10             	add    %dh,0x10(%ebp)
    2372:	00 00                	add    %al,(%eax)
    2374:	40                   	inc    %eax
    2375:	00 00                	add    %al,(%eax)
    2377:	00 01                	add    %al,(%ecx)
    2379:	00 00                	add    %al,(%eax)
    237b:	00 83 10 00 00 40    	add    %al,0x40000010(%ebx)
    2381:	00 00                	add    %al,(%eax)
    2383:	00 01                	add    %al,(%ecx)
    2385:	00 00                	add    %al,(%eax)
    2387:	00 1d 10 00 00 40    	add    %bl,0x40000010
    238d:	00 00                	add    %al,(%eax)
    238f:	00 02                	add    %al,(%edx)
    2391:	00 00                	add    %al,(%eax)
    2393:	00 93 10 00 00 24    	add    %dl,0x24000010(%ebx)
    2399:	00 00                	add    %al,(%eax)
    239b:	00 8b 0e 28 00 00    	add    %cl,0x280e(%ebx)
    23a1:	00 00                	add    %al,(%eax)
    23a3:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
	...
    23af:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    23b3:	00 05 00 00 00 00    	add    %al,0x0
    23b9:	00 00                	add    %al,(%eax)
    23bb:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    23bf:	00 0a                	add    %cl,(%edx)
    23c1:	00 00                	add    %al,(%eax)
    23c3:	00 00                	add    %al,(%eax)
    23c5:	00 00                	add    %al,(%eax)
    23c7:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    23cb:	00 19                	add    %bl,(%ecx)
    23cd:	00 00                	add    %al,(%eax)
    23cf:	00 00                	add    %al,(%eax)
    23d1:	00 00                	add    %al,(%eax)
    23d3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    23d7:	00 24 00             	add    %ah,(%eax,%eax,1)
    23da:	00 00                	add    %al,(%eax)
    23dc:	00 00                	add    %al,(%eax)
    23de:	00 00                	add    %al,(%eax)
    23e0:	44                   	inc    %esp
    23e1:	00 31                	add    %dh,(%ecx)
    23e3:	00 37                	add    %dh,(%edi)
    23e5:	00 00                	add    %al,(%eax)
    23e7:	00 00                	add    %al,(%eax)
    23e9:	00 00                	add    %al,(%eax)
    23eb:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    23ef:	00 4d 00             	add    %cl,0x0(%ebp)
    23f2:	00 00                	add    %al,(%eax)
    23f4:	00 00                	add    %al,(%eax)
    23f6:	00 00                	add    %al,(%eax)
    23f8:	44                   	inc    %esp
    23f9:	00 34 00             	add    %dh,(%eax,%eax,1)
    23fc:	69 00 00 00 00 00    	imul   $0x0,(%eax),%eax
    2402:	00 00                	add    %al,(%eax)
    2404:	44                   	inc    %esp
    2405:	00 19                	add    %bl,(%ecx)
    2407:	00 7f 00             	add    %bh,0x0(%edi)
    240a:	00 00                	add    %al,(%eax)
    240c:	00 00                	add    %al,(%eax)
    240e:	00 00                	add    %al,(%eax)
    2410:	44                   	inc    %esp
    2411:	00 1a                	add    %bl,(%edx)
    2413:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    2419:	00 00                	add    %al,(%eax)
    241b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    241f:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    2426:	00 00                	add    %al,(%eax)
    2428:	44                   	inc    %esp
    2429:	00 1f                	add    %bl,(%edi)
    242b:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
    2431:	00 00                	add    %al,(%eax)
    2433:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2437:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
    243e:	00 00                	add    %al,(%eax)
    2440:	44                   	inc    %esp
    2441:	00 36                	add    %dh,(%esi)
    2443:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    2449:	00 00                	add    %al,(%eax)
    244b:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    244f:	00 b2 00 00 00 00    	add    %dh,0x0(%edx)
    2455:	00 00                	add    %al,(%eax)
    2457:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    245b:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
    2461:	00 00                	add    %al,(%eax)
    2463:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    2467:	00 c2                	add    %al,%dl
    2469:	00 00                	add    %al,(%eax)
    246b:	00 00                	add    %al,(%eax)
    246d:	00 00                	add    %al,(%eax)
    246f:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    2473:	00 cc                	add    %cl,%ah
    2475:	00 00                	add    %al,(%eax)
    2477:	00 00                	add    %al,(%eax)
    2479:	00 00                	add    %al,(%eax)
    247b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    247f:	00 d3                	add    %dl,%bl
    2481:	00 00                	add    %al,(%eax)
    2483:	00 00                	add    %al,(%eax)
    2485:	00 00                	add    %al,(%eax)
    2487:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    248b:	00 dc                	add    %bl,%ah
    248d:	00 00                	add    %al,(%eax)
    248f:	00 00                	add    %al,(%eax)
    2491:	00 00                	add    %al,(%eax)
    2493:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2497:	00 e3                	add    %ah,%bl
    2499:	00 00                	add    %al,(%eax)
    249b:	00 00                	add    %al,(%eax)
    249d:	00 00                	add    %al,(%eax)
    249f:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    24a3:	00 ea                	add    %ch,%dl
    24a5:	00 00                	add    %al,(%eax)
    24a7:	00 00                	add    %al,(%eax)
    24a9:	00 00                	add    %al,(%eax)
    24ab:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    24af:	00 f1                	add    %dh,%cl
    24b1:	00 00                	add    %al,(%eax)
    24b3:	00 00                	add    %al,(%eax)
    24b5:	00 00                	add    %al,(%eax)
    24b7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    24bb:	00 f6                	add    %dh,%dh
    24bd:	00 00                	add    %al,(%eax)
    24bf:	00 00                	add    %al,(%eax)
    24c1:	00 00                	add    %al,(%eax)
    24c3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    24c7:	00 fc                	add    %bh,%ah
    24c9:	00 00                	add    %al,(%eax)
    24cb:	00 00                	add    %al,(%eax)
    24cd:	00 00                	add    %al,(%eax)
    24cf:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    24d3:	00 05 01 00 00 00    	add    %al,0x1
    24d9:	00 00                	add    %al,(%eax)
    24db:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    24df:	00 0a                	add    %cl,(%edx)
    24e1:	01 00                	add    %eax,(%eax)
    24e3:	00 00                	add    %al,(%eax)
    24e5:	00 00                	add    %al,(%eax)
    24e7:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    24eb:	00 10                	add    %dl,(%eax)
    24ed:	01 00                	add    %eax,(%eax)
    24ef:	00 00                	add    %al,(%eax)
    24f1:	00 00                	add    %al,(%eax)
    24f3:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    24f7:	00 19                	add    %bl,(%ecx)
    24f9:	01 00                	add    %eax,(%eax)
    24fb:	00 00                	add    %al,(%eax)
    24fd:	00 00                	add    %al,(%eax)
    24ff:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2503:	00 22                	add    %ah,(%edx)
    2505:	01 00                	add    %eax,(%eax)
    2507:	00 00                	add    %al,(%eax)
    2509:	00 00                	add    %al,(%eax)
    250b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    250f:	00 29                	add    %ch,(%ecx)
    2511:	01 00                	add    %eax,(%eax)
    2513:	00 00                	add    %al,(%eax)
    2515:	00 00                	add    %al,(%eax)
    2517:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    251b:	00 30                	add    %dh,(%eax)
    251d:	01 00                	add    %eax,(%eax)
    251f:	00 00                	add    %al,(%eax)
    2521:	00 00                	add    %al,(%eax)
    2523:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2527:	00 39                	add    %bh,(%ecx)
    2529:	01 00                	add    %eax,(%eax)
    252b:	00 00                	add    %al,(%eax)
    252d:	00 00                	add    %al,(%eax)
    252f:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2533:	00 40 01             	add    %al,0x1(%eax)
    2536:	00 00                	add    %al,(%eax)
    2538:	00 00                	add    %al,(%eax)
    253a:	00 00                	add    %al,(%eax)
    253c:	44                   	inc    %esp
    253d:	00 47 00             	add    %al,0x0(%edi)
    2540:	47                   	inc    %edi
    2541:	01 00                	add    %eax,(%eax)
    2543:	00 00                	add    %al,(%eax)
    2545:	00 00                	add    %al,(%eax)
    2547:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
    254b:	00 5b 01             	add    %bl,0x1(%ebx)
    254e:	00 00                	add    %al,(%eax)
    2550:	00 00                	add    %al,(%eax)
    2552:	00 00                	add    %al,(%eax)
    2554:	64 00 00             	add    %al,%fs:(%eax)
    2557:	00 eb                	add    %ch,%bl
    2559:	0f 28 00             	movaps (%eax),%xmm0
    255c:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    255d:	10 00                	adc    %al,(%eax)
    255f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    2563:	00 eb                	add    %ch,%bl
    2565:	0f 28 00             	movaps (%eax),%xmm0
    2568:	08 00                	or     %al,(%eax)
    256a:	00 00                	add    %al,(%eax)
    256c:	3c 00                	cmp    $0x0,%al
    256e:	00 00                	add    %al,(%eax)
    2570:	00 00                	add    %al,(%eax)
    2572:	00 00                	add    %al,(%eax)
    2574:	17                   	pop    %ss
    2575:	00 00                	add    %al,(%eax)
    2577:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    257d:	00 00                	add    %al,(%eax)
    257f:	00 41 00             	add    %al,0x0(%ecx)
    2582:	00 00                	add    %al,(%eax)
    2584:	80 00 00             	addb   $0x0,(%eax)
    2587:	00 00                	add    %al,(%eax)
    2589:	00 00                	add    %al,(%eax)
    258b:	00 5b 00             	add    %bl,0x0(%ebx)
    258e:	00 00                	add    %al,(%eax)
    2590:	80 00 00             	addb   $0x0,(%eax)
    2593:	00 00                	add    %al,(%eax)
    2595:	00 00                	add    %al,(%eax)
    2597:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    259d:	00 00                	add    %al,(%eax)
    259f:	00 00                	add    %al,(%eax)
    25a1:	00 00                	add    %al,(%eax)
    25a3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    25a9:	00 00                	add    %al,(%eax)
    25ab:	00 00                	add    %al,(%eax)
    25ad:	00 00                	add    %al,(%eax)
    25af:	00 e1                	add    %ah,%cl
    25b1:	00 00                	add    %al,(%eax)
    25b3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    25b9:	00 00                	add    %al,(%eax)
    25bb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    25be:	00 00                	add    %al,(%eax)
    25c0:	80 00 00             	addb   $0x0,(%eax)
    25c3:	00 00                	add    %al,(%eax)
    25c5:	00 00                	add    %al,(%eax)
    25c7:	00 37                	add    %dh,(%edi)
    25c9:	01 00                	add    %eax,(%eax)
    25cb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    25d1:	00 00                	add    %al,(%eax)
    25d3:	00 5d 01             	add    %bl,0x1(%ebp)
    25d6:	00 00                	add    %al,(%eax)
    25d8:	80 00 00             	addb   $0x0,(%eax)
    25db:	00 00                	add    %al,(%eax)
    25dd:	00 00                	add    %al,(%eax)
    25df:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    25e5:	00 00                	add    %al,(%eax)
    25e7:	00 00                	add    %al,(%eax)
    25e9:	00 00                	add    %al,(%eax)
    25eb:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    25f1:	00 00                	add    %al,(%eax)
    25f3:	00 00                	add    %al,(%eax)
    25f5:	00 00                	add    %al,(%eax)
    25f7:	00 d2                	add    %dl,%dl
    25f9:	01 00                	add    %eax,(%eax)
    25fb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2601:	00 00                	add    %al,(%eax)
    2603:	00 ec                	add    %ch,%ah
    2605:	01 00                	add    %eax,(%eax)
    2607:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    260d:	00 00                	add    %al,(%eax)
    260f:	00 07                	add    %al,(%edi)
    2611:	02 00                	add    (%eax),%al
    2613:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2619:	00 00                	add    %al,(%eax)
    261b:	00 28                	add    %ch,(%eax)
    261d:	02 00                	add    (%eax),%al
    261f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2625:	00 00                	add    %al,(%eax)
    2627:	00 47 02             	add    %al,0x2(%edi)
    262a:	00 00                	add    %al,(%eax)
    262c:	80 00 00             	addb   $0x0,(%eax)
    262f:	00 00                	add    %al,(%eax)
    2631:	00 00                	add    %al,(%eax)
    2633:	00 66 02             	add    %ah,0x2(%esi)
    2636:	00 00                	add    %al,(%eax)
    2638:	80 00 00             	addb   $0x0,(%eax)
    263b:	00 00                	add    %al,(%eax)
    263d:	00 00                	add    %al,(%eax)
    263f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2645:	00 00                	add    %al,(%eax)
    2647:	00 00                	add    %al,(%eax)
    2649:	00 00                	add    %al,(%eax)
    264b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    2651:	00 00                	add    %al,(%eax)
    2653:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    2659:	02 00                	add    (%eax),%al
    265b:	00 c2                	add    %al,%dl
    265d:	00 00                	add    %al,(%eax)
    265f:	00 00                	add    %al,(%eax)
    2661:	00 00                	add    %al,(%eax)
    2663:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    2669:	00 00                	add    %al,(%eax)
    266b:	00 37                	add    %dh,(%edi)
    266d:	53                   	push   %ebx
    266e:	00 00                	add    %al,(%eax)
    2670:	29 04 00             	sub    %eax,(%eax,%eax,1)
    2673:	00 c2                	add    %al,%dl
    2675:	00 00                	add    %al,(%eax)
    2677:	00 17                	add    %dl,(%edi)
    2679:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    267a:	00 00                	add    %al,(%eax)
    267c:	ad                   	lods   %ds:(%esi),%eax
    267d:	10 00                	adc    %al,(%eax)
    267f:	00 24 00             	add    %ah,(%eax,%eax,1)
    2682:	00 00                	add    %al,(%eax)
    2684:	eb 0f                	jmp    2695 <bootmain-0x27d96b>
    2686:	28 00                	sub    %al,(%eax)
    2688:	00 00                	add    %al,(%eax)
    268a:	00 00                	add    %al,(%eax)
    268c:	44                   	inc    %esp
    268d:	00 17                	add    %dl,(%edi)
    268f:	00 00                	add    %al,(%eax)
    2691:	00 00                	add    %al,(%eax)
    2693:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2699:	00 00                	add    %al,(%eax)
    269b:	00 ec                	add    %ch,%ah
    269d:	0f 28 00             	movaps (%eax),%xmm0
    26a0:	00 00                	add    %al,(%eax)
    26a2:	00 00                	add    %al,(%eax)
    26a4:	44                   	inc    %esp
    26a5:	00 6c 00 01          	add    %ch,0x1(%eax,%eax,1)
    26a9:	00 00                	add    %al,(%eax)
    26ab:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    26b1:	00 00                	add    %al,(%eax)
    26b3:	00 f1                	add    %dh,%cl
    26b5:	0f 28 00             	movaps (%eax),%xmm0
    26b8:	00 00                	add    %al,(%eax)
    26ba:	00 00                	add    %al,(%eax)
    26bc:	44                   	inc    %esp
    26bd:	00 17                	add    %dl,(%edi)
    26bf:	00 06                	add    %al,(%esi)
    26c1:	00 00                	add    %al,(%eax)
    26c3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    26c9:	00 00                	add    %al,(%eax)
    26cb:	00 f3                	add    %dh,%bl
    26cd:	0f 28 00             	movaps (%eax),%xmm0
    26d0:	00 00                	add    %al,(%eax)
    26d2:	00 00                	add    %al,(%eax)
    26d4:	44                   	inc    %esp
    26d5:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    26d9:	00 00                	add    %al,(%eax)
    26db:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    26e1:	00 00                	add    %al,(%eax)
    26e3:	00 23                	add    %ah,(%ebx)
    26e5:	10 28                	adc    %ch,(%eax)
    26e7:	00 00                	add    %al,(%eax)
    26e9:	00 00                	add    %al,(%eax)
    26eb:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
    26ef:	00 38                	add    %bh,(%eax)
    26f1:	00 00                	add    %al,(%eax)
    26f3:	00 be 10 00 00 24    	add    %bh,0x24000010(%esi)
    26f9:	00 00                	add    %al,(%eax)
    26fb:	00 25 10 28 00 d3    	add    %ah,0xd3002810
    2701:	10 00                	adc    %al,(%eax)
    2703:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2709:	00 00                	add    %al,(%eax)
    270b:	00 00                	add    %al,(%eax)
    270d:	00 00                	add    %al,(%eax)
    270f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    2713:	00 00                	add    %al,(%eax)
    2715:	00 00                	add    %al,(%eax)
    2717:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    271d:	00 00                	add    %al,(%eax)
    271f:	00 26                	add    %ah,(%esi)
    2721:	10 28                	adc    %ch,(%eax)
    2723:	00 00                	add    %al,(%eax)
    2725:	00 00                	add    %al,(%eax)
    2727:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    272b:	00 01                	add    %al,(%ecx)
    272d:	00 00                	add    %al,(%eax)
    272f:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    2735:	00 00                	add    %al,(%eax)
    2737:	00 2b                	add    %ch,(%ebx)
    2739:	10 28                	adc    %ch,(%eax)
    273b:	00 00                	add    %al,(%eax)
    273d:	00 00                	add    %al,(%eax)
    273f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    2743:	00 06                	add    %al,(%esi)
    2745:	00 00                	add    %al,(%eax)
    2747:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    274d:	00 00                	add    %al,(%eax)
    274f:	00 2d 10 28 00 00    	add    %ch,0x2810
    2755:	00 00                	add    %al,(%eax)
    2757:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    275b:	00 08                	add    %cl,(%eax)
    275d:	00 00                	add    %al,(%eax)
    275f:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    2765:	00 00                	add    %al,(%eax)
    2767:	00 2f                	add    %ch,(%edi)
    2769:	10 28                	adc    %ch,(%eax)
    276b:	00 00                	add    %al,(%eax)
    276d:	00 00                	add    %al,(%eax)
    276f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    2773:	00 0a                	add    %cl,(%edx)
    2775:	00 00                	add    %al,(%eax)
    2777:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    277d:	00 00                	add    %al,(%eax)
    277f:	00 32                	add    %dh,(%edx)
    2781:	10 28                	adc    %ch,(%eax)
    2783:	00 00                	add    %al,(%eax)
    2785:	00 00                	add    %al,(%eax)
    2787:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    278b:	00 0d 00 00 00 00    	add    %cl,0x0
    2791:	00 00                	add    %al,(%eax)
    2793:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    2797:	00 0e                	add    %cl,(%esi)
    2799:	00 00                	add    %al,(%eax)
    279b:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    27a1:	00 00                	add    %al,(%eax)
    27a3:	00 36                	add    %dh,(%esi)
    27a5:	10 28                	adc    %ch,(%eax)
    27a7:	00 00                	add    %al,(%eax)
    27a9:	00 00                	add    %al,(%eax)
    27ab:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
    27af:	00 11                	add    %dl,(%ecx)
    27b1:	00 00                	add    %al,(%eax)
    27b3:	00 00                	add    %al,(%eax)
    27b5:	00 00                	add    %al,(%eax)
    27b7:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
    27bb:	00 22                	add    %ah,(%edx)
    27bd:	00 00                	add    %al,(%eax)
    27bf:	00 e6                	add    %ah,%dh
    27c1:	10 00                	adc    %al,(%eax)
    27c3:	00 24 00             	add    %ah,(%eax,%eax,1)
    27c6:	00 00                	add    %al,(%eax)
    27c8:	49                   	dec    %ecx
    27c9:	10 28                	adc    %ch,(%eax)
    27cb:	00 fb                	add    %bh,%bl
    27cd:	10 00                	adc    %al,(%eax)
    27cf:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    27d5:	00 00                	add    %al,(%eax)
    27d7:	00 00                	add    %al,(%eax)
    27d9:	00 00                	add    %al,(%eax)
    27db:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
    27df:	00 00                	add    %al,(%eax)
    27e1:	00 00                	add    %al,(%eax)
    27e3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    27e9:	00 00                	add    %al,(%eax)
    27eb:	00 4a 10             	add    %cl,0x10(%edx)
    27ee:	28 00                	sub    %al,(%eax)
    27f0:	00 00                	add    %al,(%eax)
    27f2:	00 00                	add    %al,(%eax)
    27f4:	44                   	inc    %esp
    27f5:	00 6c 00 01          	add    %ch,0x1(%eax,%eax,1)
    27f9:	00 00                	add    %al,(%eax)
    27fb:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    2801:	00 00                	add    %al,(%eax)
    2803:	00 4f 10             	add    %cl,0x10(%edi)
    2806:	28 00                	sub    %al,(%eax)
    2808:	00 00                	add    %al,(%eax)
    280a:	00 00                	add    %al,(%eax)
    280c:	44                   	inc    %esp
    280d:	00 82 00 06 00 00    	add    %al,0x600(%edx)
    2813:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2819:	00 00                	add    %al,(%eax)
    281b:	00 51 10             	add    %dl,0x10(%ecx)
    281e:	28 00                	sub    %al,(%eax)
    2820:	00 00                	add    %al,(%eax)
    2822:	00 00                	add    %al,(%eax)
    2824:	44                   	inc    %esp
    2825:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    2829:	00 00                	add    %al,(%eax)
    282b:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    2831:	00 00                	add    %al,(%eax)
    2833:	00 53 10             	add    %dl,0x10(%ebx)
    2836:	28 00                	sub    %al,(%eax)
    2838:	00 00                	add    %al,(%eax)
    283a:	00 00                	add    %al,(%eax)
    283c:	44                   	inc    %esp
    283d:	00 82 00 0a 00 00    	add    %al,0xa00(%edx)
    2843:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2849:	00 00                	add    %al,(%eax)
    284b:	00 56 10             	add    %dl,0x10(%esi)
    284e:	28 00                	sub    %al,(%eax)
    2850:	00 00                	add    %al,(%eax)
    2852:	00 00                	add    %al,(%eax)
    2854:	44                   	inc    %esp
    2855:	00 6c 00 0d          	add    %ch,0xd(%eax,%eax,1)
    2859:	00 00                	add    %al,(%eax)
    285b:	00 00                	add    %al,(%eax)
    285d:	00 00                	add    %al,(%eax)
    285f:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    2863:	00 13                	add    %dl,(%ebx)
    2865:	00 00                	add    %al,(%eax)
    2867:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    286d:	00 00                	add    %al,(%eax)
    286f:	00 5f 10             	add    %bl,0x10(%edi)
    2872:	28 00                	sub    %al,(%eax)
    2874:	00 00                	add    %al,(%eax)
    2876:	00 00                	add    %al,(%eax)
    2878:	44                   	inc    %esp
    2879:	00 88 00 16 00 00    	add    %cl,0x1600(%eax)
    287f:	00 00                	add    %al,(%eax)
    2881:	00 00                	add    %al,(%eax)
    2883:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    2887:	00 27                	add    %ah,(%edi)
    2889:	00 00                	add    %al,(%eax)
    288b:	00 07                	add    %al,(%edi)
    288d:	11 00                	adc    %eax,(%eax)
    288f:	00 24 00             	add    %ah,(%eax,%eax,1)
    2892:	00 00                	add    %al,(%eax)
    2894:	72 10                	jb     28a6 <bootmain-0x27d75a>
    2896:	28 00                	sub    %al,(%eax)
    2898:	00 00                	add    %al,(%eax)
    289a:	00 00                	add    %al,(%eax)
    289c:	44                   	inc    %esp
    289d:	00 9e 00 00 00 00    	add    %bl,0x0(%esi)
    28a3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    28a9:	00 00                	add    %al,(%eax)
    28ab:	00 73 10             	add    %dh,0x10(%ebx)
    28ae:	28 00                	sub    %al,(%eax)
    28b0:	00 00                	add    %al,(%eax)
    28b2:	00 00                	add    %al,(%eax)
    28b4:	44                   	inc    %esp
    28b5:	00 52 00             	add    %dl,0x0(%edx)
    28b8:	01 00                	add    %eax,(%eax)
    28ba:	00 00                	add    %al,(%eax)
    28bc:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    28bd:	10 00                	adc    %al,(%eax)
    28bf:	00 84 00 00 00 78 10 	add    %al,0x10780000(%eax,%eax,1)
    28c6:	28 00                	sub    %al,(%eax)
    28c8:	00 00                	add    %al,(%eax)
    28ca:	00 00                	add    %al,(%eax)
    28cc:	44                   	inc    %esp
    28cd:	00 9e 00 06 00 00    	add    %bl,0x600(%esi)
    28d3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    28d9:	00 00                	add    %al,(%eax)
    28db:	00 7a 10             	add    %bh,0x10(%edx)
    28de:	28 00                	sub    %al,(%eax)
    28e0:	00 00                	add    %al,(%eax)
    28e2:	00 00                	add    %al,(%eax)
    28e4:	44                   	inc    %esp
    28e5:	00 52 00             	add    %dl,0x0(%edx)
    28e8:	08 00                	or     %al,(%eax)
    28ea:	00 00                	add    %al,(%eax)
    28ec:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    28ed:	10 00                	adc    %al,(%eax)
    28ef:	00 84 00 00 00 7b 10 	add    %al,0x107b0000(%eax,%eax,1)
    28f6:	28 00                	sub    %al,(%eax)
    28f8:	00 00                	add    %al,(%eax)
    28fa:	00 00                	add    %al,(%eax)
    28fc:	44                   	inc    %esp
    28fd:	00 a2 00 09 00 00    	add    %ah,0x900(%edx)
    2903:	00 00                	add    %al,(%eax)
    2905:	00 00                	add    %al,(%eax)
    2907:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    290b:	00 0d 00 00 00 22    	add    %cl,0x22000000
    2911:	11 00                	adc    %eax,(%eax)
    2913:	00 24 00             	add    %ah,(%eax,%eax,1)
    2916:	00 00                	add    %al,(%eax)
    2918:	81 10 28 00 00 00    	adcl   $0x28,(%eax)
    291e:	00 00                	add    %al,(%eax)
    2920:	44                   	inc    %esp
    2921:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    2927:	00 00                	add    %al,(%eax)
    2929:	00 00                	add    %al,(%eax)
    292b:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    292f:	00 03                	add    %al,(%ebx)
    2931:	00 00                	add    %al,(%eax)
    2933:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2939:	00 00                	add    %al,(%eax)
    293b:	00 89 10 28 00 00    	add    %cl,0x2810(%ecx)
    2941:	00 00                	add    %al,(%eax)
    2943:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    2947:	00 08                	add    %cl,(%eax)
    2949:	00 00                	add    %al,(%eax)
    294b:	00 a7 10 00 00 84    	add    %ah,-0x7bfffff0(%edi)
    2951:	00 00                	add    %al,(%eax)
    2953:	00 91 10 28 00 00    	add    %dl,0x2810(%ecx)
    2959:	00 00                	add    %al,(%eax)
    295b:	00 44 00 af          	add    %al,-0x51(%eax,%eax,1)
    295f:	00 10                	add    %dl,(%eax)
    2961:	00 00                	add    %al,(%eax)
    2963:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2969:	00 00                	add    %al,(%eax)
    296b:	00 96 10 28 00 00    	add    %dl,0x2810(%esi)
    2971:	00 00                	add    %al,(%eax)
    2973:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    2977:	00 15 00 00 00 a7    	add    %dl,0xa7000000
    297d:	10 00                	adc    %al,(%eax)
    297f:	00 84 00 00 00 9e 10 	add    %al,0x109e0000(%eax,%eax,1)
    2986:	28 00                	sub    %al,(%eax)
    2988:	00 00                	add    %al,(%eax)
    298a:	00 00                	add    %al,(%eax)
    298c:	44                   	inc    %esp
    298d:	00 b3 00 1d 00 00    	add    %dh,0x1d00(%ebx)
    2993:	00 38                	add    %bh,(%eax)
    2995:	11 00                	adc    %eax,(%eax)
    2997:	00 20                	add    %ah,(%eax)
    2999:	00 00                	add    %al,(%eax)
    299b:	00 00                	add    %al,(%eax)
    299d:	00 00                	add    %al,(%eax)
    299f:	00 47 11             	add    %al,0x11(%edi)
    29a2:	00 00                	add    %al,(%eax)
    29a4:	20 00                	and    %al,(%eax)
	...
    29ae:	00 00                	add    %al,(%eax)
    29b0:	64 00 00             	add    %al,%fs:(%eax)
    29b3:	00 a0 10 28 00 58    	add    %ah,0x58002810(%eax)
    29b9:	11 00                	adc    %eax,(%eax)
    29bb:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    29bf:	00 a0 10 28 00 68    	add    %ah,0x68002810(%eax)
    29c5:	11 00                	adc    %eax,(%eax)
    29c7:	00 84 00 00 00 a0 10 	add    %al,0x10a00000(%eax,%eax,1)
    29ce:	28 00                	sub    %al,(%eax)
    29d0:	00 00                	add    %al,(%eax)
    29d2:	00 00                	add    %al,(%eax)
    29d4:	44                   	inc    %esp
    29d5:	00 09                	add    %cl,(%ecx)
    29d7:	00 a0 10 28 00 00    	add    %ah,0x2810(%eax)
    29dd:	00 00                	add    %al,(%eax)
    29df:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    29e3:	00 a2 10 28 00 00    	add    %ah,0x2810(%edx)
    29e9:	00 00                	add    %al,(%eax)
    29eb:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    29ef:	00 a4 10 28 00 00 00 	add    %ah,0x28(%eax,%edx,1)
    29f6:	00 00                	add    %al,(%eax)
    29f8:	44                   	inc    %esp
    29f9:	00 0c 00             	add    %cl,(%eax,%eax,1)
    29fc:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    29fd:	10 28                	adc    %ch,(%eax)
    29ff:	00 00                	add    %al,(%eax)
    2a01:	00 00                	add    %al,(%eax)
    2a03:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    2a07:	00 a7 10 28 00 00    	add    %ah,0x2810(%edi)
    2a0d:	00 00                	add    %al,(%eax)
    2a0f:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    2a13:	00 a8 10 28 00 00    	add    %ch,0x2810(%eax)
    2a19:	00 00                	add    %al,(%eax)
    2a1b:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    2a1f:	00 ab 10 28 00 00    	add    %ch,0x2810(%ebx)
    2a25:	00 00                	add    %al,(%eax)
    2a27:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    2a2b:	00 ad 10 28 00 00    	add    %ch,0x2810(%ebp)
    2a31:	00 00                	add    %al,(%eax)
    2a33:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    2a37:	00 af 10 28 00 00    	add    %ch,0x2810(%edi)
    2a3d:	00 00                	add    %al,(%eax)
    2a3f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2a43:	00 b4 10 28 00 00 00 	add    %dh,0x28(%eax,%edx,1)
    2a4a:	00 00                	add    %al,(%eax)
    2a4c:	44                   	inc    %esp
    2a4d:	00 14 00             	add    %dl,(%eax,%eax,1)
    2a50:	b5 10                	mov    $0x10,%ch
    2a52:	28 00                	sub    %al,(%eax)
    2a54:	00 00                	add    %al,(%eax)
    2a56:	00 00                	add    %al,(%eax)
    2a58:	44                   	inc    %esp
    2a59:	00 15 00 b6 10 28    	add    %dl,0x2810b600
    2a5f:	00 00                	add    %al,(%eax)
    2a61:	00 00                	add    %al,(%eax)
    2a63:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    2a67:	00 b8 10 28 00 00    	add    %bh,0x2810(%eax)
    2a6d:	00 00                	add    %al,(%eax)
    2a6f:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    2a73:	00 ba 10 28 00 00    	add    %bh,0x2810(%edx)
    2a79:	00 00                	add    %al,(%eax)
    2a7b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2a7f:	00 bb 10 28 00 00    	add    %bh,0x2810(%ebx)
    2a85:	00 00                	add    %al,(%eax)
    2a87:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2a8b:	00 bd 10 28 00 00    	add    %bh,0x2810(%ebp)
    2a91:	00 00                	add    %al,(%eax)
    2a93:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    2a97:	00 bf 10 28 00 00    	add    %bh,0x2810(%edi)
    2a9d:	00 00                	add    %al,(%eax)
    2a9f:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2aa3:	00 c0                	add    %al,%al
    2aa5:	10 28                	adc    %ch,(%eax)
    2aa7:	00 00                	add    %al,(%eax)
    2aa9:	00 00                	add    %al,(%eax)
    2aab:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2aaf:	00 c2                	add    %al,%dl
    2ab1:	10 28                	adc    %ch,(%eax)
    2ab3:	00 00                	add    %al,(%eax)
    2ab5:	00 00                	add    %al,(%eax)
    2ab7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2abb:	00 c3                	add    %al,%bl
    2abd:	10 28                	adc    %ch,(%eax)
    2abf:	00 00                	add    %al,(%eax)
    2ac1:	00 00                	add    %al,(%eax)
    2ac3:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    2ac7:	00 c6                	add    %al,%dh
    2ac9:	10 28                	adc    %ch,(%eax)
    2acb:	00 00                	add    %al,(%eax)
    2acd:	00 00                	add    %al,(%eax)
    2acf:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    2ad3:	00 c8                	add    %cl,%al
    2ad5:	10 28                	adc    %ch,(%eax)
    2ad7:	00 00                	add    %al,(%eax)
    2ad9:	00 00                	add    %al,(%eax)
    2adb:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2adf:	00 ca                	add    %cl,%dl
    2ae1:	10 28                	adc    %ch,(%eax)
    2ae3:	00 00                	add    %al,(%eax)
    2ae5:	00 00                	add    %al,(%eax)
    2ae7:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
    2aeb:	00 cf                	add    %cl,%bh
    2aed:	10 28                	adc    %ch,(%eax)
    2aef:	00 00                	add    %al,(%eax)
    2af1:	00 00                	add    %al,(%eax)
    2af3:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
    2af7:	00 d0                	add    %dl,%al
    2af9:	10 28                	adc    %ch,(%eax)
    2afb:	00 00                	add    %al,(%eax)
    2afd:	00 00                	add    %al,(%eax)
    2aff:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    2b03:	00 d1                	add    %dl,%cl
    2b05:	10 28                	adc    %ch,(%eax)
    2b07:	00 00                	add    %al,(%eax)
    2b09:	00 00                	add    %al,(%eax)
    2b0b:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    2b0f:	00 d3                	add    %dl,%bl
    2b11:	10 28                	adc    %ch,(%eax)
    2b13:	00 00                	add    %al,(%eax)
    2b15:	00 00                	add    %al,(%eax)
    2b17:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    2b1b:	00 d5                	add    %dl,%ch
    2b1d:	10 28                	adc    %ch,(%eax)
    2b1f:	00 00                	add    %al,(%eax)
    2b21:	00 00                	add    %al,(%eax)
    2b23:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    2b27:	00 d6                	add    %dl,%dh
    2b29:	10 28                	adc    %ch,(%eax)
    2b2b:	00 00                	add    %al,(%eax)
    2b2d:	00 00                	add    %al,(%eax)
    2b2f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    2b33:	00 db                	add    %bl,%bl
    2b35:	10 28                	adc    %ch,(%eax)
    2b37:	00 00                	add    %al,(%eax)
    2b39:	00 00                	add    %al,(%eax)
    2b3b:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2b3f:	00 e0                	add    %ah,%al
    2b41:	10 28                	adc    %ch,(%eax)
    2b43:	00 00                	add    %al,(%eax)
    2b45:	00 00                	add    %al,(%eax)
    2b47:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    2b4b:	00 e5                	add    %ah,%ch
    2b4d:	10 28                	adc    %ch,(%eax)
    2b4f:	00 00                	add    %al,(%eax)
    2b51:	00 00                	add    %al,(%eax)
    2b53:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    2b57:	00 e6                	add    %ah,%dh
    2b59:	10 28                	adc    %ch,(%eax)
    2b5b:	00 00                	add    %al,(%eax)
    2b5d:	00 00                	add    %al,(%eax)
    2b5f:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2b63:	00 eb                	add    %ch,%bl
    2b65:	10 28                	adc    %ch,(%eax)
    2b67:	00 00                	add    %al,(%eax)
    2b69:	00 00                	add    %al,(%eax)
    2b6b:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    2b6f:	00 f0                	add    %dh,%al
    2b71:	10 28                	adc    %ch,(%eax)
    2b73:	00 00                	add    %al,(%eax)
    2b75:	00 00                	add    %al,(%eax)
    2b77:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    2b7b:	00 f5                	add    %dh,%ch
    2b7d:	10 28                	adc    %ch,(%eax)
    2b7f:	00 73 11             	add    %dh,0x11(%ebx)
    2b82:	00 00                	add    %al,(%eax)
    2b84:	64 00 02             	add    %al,%fs:(%edx)
    2b87:	00 f6                	add    %dh,%dh
    2b89:	10 28                	adc    %ch,(%eax)
    2b8b:	00 08                	add    %cl,(%eax)
    2b8d:	00 00                	add    %al,(%eax)
    2b8f:	00 3c 00             	add    %bh,(%eax,%eax,1)
    2b92:	00 00                	add    %al,(%eax)
    2b94:	00 00                	add    %al,(%eax)
    2b96:	00 00                	add    %al,(%eax)
    2b98:	17                   	pop    %ss
    2b99:	00 00                	add    %al,(%eax)
    2b9b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2ba1:	00 00                	add    %al,(%eax)
    2ba3:	00 41 00             	add    %al,0x0(%ecx)
    2ba6:	00 00                	add    %al,(%eax)
    2ba8:	80 00 00             	addb   $0x0,(%eax)
    2bab:	00 00                	add    %al,(%eax)
    2bad:	00 00                	add    %al,(%eax)
    2baf:	00 5b 00             	add    %bl,0x0(%ebx)
    2bb2:	00 00                	add    %al,(%eax)
    2bb4:	80 00 00             	addb   $0x0,(%eax)
    2bb7:	00 00                	add    %al,(%eax)
    2bb9:	00 00                	add    %al,(%eax)
    2bbb:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2bc1:	00 00                	add    %al,(%eax)
    2bc3:	00 00                	add    %al,(%eax)
    2bc5:	00 00                	add    %al,(%eax)
    2bc7:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2bcd:	00 00                	add    %al,(%eax)
    2bcf:	00 00                	add    %al,(%eax)
    2bd1:	00 00                	add    %al,(%eax)
    2bd3:	00 e1                	add    %ah,%cl
    2bd5:	00 00                	add    %al,(%eax)
    2bd7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2bdd:	00 00                	add    %al,(%eax)
    2bdf:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2be2:	00 00                	add    %al,(%eax)
    2be4:	80 00 00             	addb   $0x0,(%eax)
    2be7:	00 00                	add    %al,(%eax)
    2be9:	00 00                	add    %al,(%eax)
    2beb:	00 37                	add    %dh,(%edi)
    2bed:	01 00                	add    %eax,(%eax)
    2bef:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2bf5:	00 00                	add    %al,(%eax)
    2bf7:	00 5d 01             	add    %bl,0x1(%ebp)
    2bfa:	00 00                	add    %al,(%eax)
    2bfc:	80 00 00             	addb   $0x0,(%eax)
    2bff:	00 00                	add    %al,(%eax)
    2c01:	00 00                	add    %al,(%eax)
    2c03:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2c09:	00 00                	add    %al,(%eax)
    2c0b:	00 00                	add    %al,(%eax)
    2c0d:	00 00                	add    %al,(%eax)
    2c0f:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2c15:	00 00                	add    %al,(%eax)
    2c17:	00 00                	add    %al,(%eax)
    2c19:	00 00                	add    %al,(%eax)
    2c1b:	00 d2                	add    %dl,%dl
    2c1d:	01 00                	add    %eax,(%eax)
    2c1f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2c25:	00 00                	add    %al,(%eax)
    2c27:	00 ec                	add    %ch,%ah
    2c29:	01 00                	add    %eax,(%eax)
    2c2b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2c31:	00 00                	add    %al,(%eax)
    2c33:	00 07                	add    %al,(%edi)
    2c35:	02 00                	add    (%eax),%al
    2c37:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2c3d:	00 00                	add    %al,(%eax)
    2c3f:	00 28                	add    %ch,(%eax)
    2c41:	02 00                	add    (%eax),%al
    2c43:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2c49:	00 00                	add    %al,(%eax)
    2c4b:	00 47 02             	add    %al,0x2(%edi)
    2c4e:	00 00                	add    %al,(%eax)
    2c50:	80 00 00             	addb   $0x0,(%eax)
    2c53:	00 00                	add    %al,(%eax)
    2c55:	00 00                	add    %al,(%eax)
    2c57:	00 66 02             	add    %ah,0x2(%esi)
    2c5a:	00 00                	add    %al,(%eax)
    2c5c:	80 00 00             	addb   $0x0,(%eax)
    2c5f:	00 00                	add    %al,(%eax)
    2c61:	00 00                	add    %al,(%eax)
    2c63:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2c69:	00 00                	add    %al,(%eax)
    2c6b:	00 00                	add    %al,(%eax)
    2c6d:	00 00                	add    %al,(%eax)
    2c6f:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    2c75:	00 00                	add    %al,(%eax)
    2c77:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    2c7d:	02 00                	add    (%eax),%al
    2c7f:	00 c2                	add    %al,%dl
    2c81:	00 00                	add    %al,(%eax)
    2c83:	00 00                	add    %al,(%eax)
    2c85:	00 00                	add    %al,(%eax)
    2c87:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    2c8d:	00 00                	add    %al,(%eax)
    2c8f:	00 37                	add    %dh,(%edi)
    2c91:	53                   	push   %ebx
    2c92:	00 00                	add    %al,(%eax)
    2c94:	29 04 00             	sub    %eax,(%eax,%eax,1)
    2c97:	00 c2                	add    %al,%dl
    2c99:	00 00                	add    %al,(%eax)
    2c9b:	00 17                	add    %dl,(%edi)
    2c9d:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    2c9e:	00 00                	add    %al,(%eax)
    2ca0:	7a 11                	jp     2cb3 <bootmain-0x27d34d>
    2ca2:	00 00                	add    %al,(%eax)
    2ca4:	24 00                	and    $0x0,%al
    2ca6:	00 00                	add    %al,(%eax)
    2ca8:	f6 10                	notb   (%eax)
    2caa:	28 00                	sub    %al,(%eax)
    2cac:	8d 11                	lea    (%ecx),%edx
    2cae:	00 00                	add    %al,(%eax)
    2cb0:	a0 00 00 00 08       	mov    0x8000000,%al
    2cb5:	00 00                	add    %al,(%eax)
    2cb7:	00 a1 11 00 00 a0    	add    %ah,-0x5fffffef(%ecx)
    2cbd:	00 00                	add    %al,(%eax)
    2cbf:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2cc2:	00 00                	add    %al,(%eax)
    2cc4:	72 0d                	jb     2cd3 <bootmain-0x27d32d>
    2cc6:	00 00                	add    %al,(%eax)
    2cc8:	a0 00 00 00 10       	mov    0x10000000,%al
    2ccd:	00 00                	add    %al,(%eax)
    2ccf:	00 00                	add    %al,(%eax)
    2cd1:	00 00                	add    %al,(%eax)
    2cd3:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    2cdf:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
    2ce3:	00 03                	add    %al,(%ebx)
    2ce5:	00 00                	add    %al,(%eax)
    2ce7:	00 00                	add    %al,(%eax)
    2ce9:	00 00                	add    %al,(%eax)
    2ceb:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2cef:	00 09                	add    %cl,(%ecx)
    2cf1:	00 00                	add    %al,(%eax)
    2cf3:	00 00                	add    %al,(%eax)
    2cf5:	00 00                	add    %al,(%eax)
    2cf7:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
    2cfb:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2cfe:	00 00                	add    %al,(%eax)
    2d00:	00 00                	add    %al,(%eax)
    2d02:	00 00                	add    %al,(%eax)
    2d04:	44                   	inc    %esp
    2d05:	00 07                	add    %al,(%edi)
    2d07:	00 13                	add    %dl,(%ebx)
    2d09:	00 00                	add    %al,(%eax)
    2d0b:	00 00                	add    %al,(%eax)
    2d0d:	00 00                	add    %al,(%eax)
    2d0f:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2d13:	00 16                	add    %dl,(%esi)
    2d15:	00 00                	add    %al,(%eax)
    2d17:	00 00                	add    %al,(%eax)
    2d19:	00 00                	add    %al,(%eax)
    2d1b:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    2d1f:	00 18                	add    %bl,(%eax)
    2d21:	00 00                	add    %al,(%eax)
    2d23:	00 00                	add    %al,(%eax)
    2d25:	00 00                	add    %al,(%eax)
    2d27:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    2d2b:	00 1b                	add    %bl,(%ebx)
    2d2d:	00 00                	add    %al,(%eax)
    2d2f:	00 00                	add    %al,(%eax)
    2d31:	00 00                	add    %al,(%eax)
    2d33:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    2d37:	00 22                	add    %ah,(%edx)
    2d39:	00 00                	add    %al,(%eax)
    2d3b:	00 00                	add    %al,(%eax)
    2d3d:	00 00                	add    %al,(%eax)
    2d3f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    2d43:	00 29                	add    %ch,(%ecx)
    2d45:	00 00                	add    %al,(%eax)
    2d47:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
    2d4d:	00 00                	add    %al,(%eax)
    2d4f:	00 00                	add    %al,(%eax)
    2d51:	00 00                	add    %al,(%eax)
    2d53:	00 ba 11 00 00 40    	add    %bh,0x40000011(%edx)
    2d59:	00 00                	add    %al,(%eax)
    2d5b:	00 02                	add    %al,(%edx)
    2d5d:	00 00                	add    %al,(%eax)
    2d5f:	00 bc 0d 00 00 40 00 	add    %bh,0x400000(%ebp,%ecx,1)
    2d66:	00 00                	add    %al,(%eax)
    2d68:	01 00                	add    %eax,(%eax)
    2d6a:	00 00                	add    %al,(%eax)
    2d6c:	c6                   	(bad)  
    2d6d:	11 00                	adc    %eax,(%eax)
    2d6f:	00 24 00             	add    %ah,(%eax,%eax,1)
    2d72:	00 00                	add    %al,(%eax)
    2d74:	21 11                	and    %edx,(%ecx)
    2d76:	28 00                	sub    %al,(%eax)
    2d78:	d9 11                	fsts   (%ecx)
    2d7a:	00 00                	add    %al,(%eax)
    2d7c:	a0 00 00 00 08       	mov    0x8000000,%al
    2d81:	00 00                	add    %al,(%eax)
    2d83:	00 e6                	add    %ah,%dh
    2d85:	11 00                	adc    %eax,(%eax)
    2d87:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    2d8d:	00 00                	add    %al,(%eax)
    2d8f:	00 00                	add    %al,(%eax)
    2d91:	00 00                	add    %al,(%eax)
    2d93:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
	...
    2d9f:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    2da3:	00 07                	add    %al,(%edi)
    2da5:	00 00                	add    %al,(%eax)
    2da7:	00 00                	add    %al,(%eax)
    2da9:	00 00                	add    %al,(%eax)
    2dab:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2daf:	00 0a                	add    %cl,(%edx)
    2db1:	00 00                	add    %al,(%eax)
    2db3:	00 00                	add    %al,(%eax)
    2db5:	00 00                	add    %al,(%eax)
    2db7:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    2dbb:	00 10                	add    %dl,(%eax)
    2dbd:	00 00                	add    %al,(%eax)
    2dbf:	00 00                	add    %al,(%eax)
    2dc1:	00 00                	add    %al,(%eax)
    2dc3:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    2dc7:	00 14 00             	add    %dl,(%eax,%eax,1)
    2dca:	00 00                	add    %al,(%eax)
    2dcc:	00 00                	add    %al,(%eax)
    2dce:	00 00                	add    %al,(%eax)
    2dd0:	44                   	inc    %esp
    2dd1:	00 1a                	add    %bl,(%edx)
    2dd3:	00 19                	add    %bl,(%ecx)
    2dd5:	00 00                	add    %al,(%eax)
    2dd7:	00 00                	add    %al,(%eax)
    2dd9:	00 00                	add    %al,(%eax)
    2ddb:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2ddf:	00 21                	add    %ah,(%ecx)
    2de1:	00 00                	add    %al,(%eax)
    2de3:	00 00                	add    %al,(%eax)
    2de5:	00 00                	add    %al,(%eax)
    2de7:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2deb:	00 27                	add    %ah,(%edi)
    2ded:	00 00                	add    %al,(%eax)
    2def:	00 00                	add    %al,(%eax)
    2df1:	00 00                	add    %al,(%eax)
    2df3:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2df7:	00 2a                	add    %ch,(%edx)
    2df9:	00 00                	add    %al,(%eax)
    2dfb:	00 00                	add    %al,(%eax)
    2dfd:	00 00                	add    %al,(%eax)
    2dff:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2e03:	00 2d 00 00 00 00    	add    %ch,0x0
    2e09:	00 00                	add    %al,(%eax)
    2e0b:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2e0f:	00 2f                	add    %ch,(%edi)
    2e11:	00 00                	add    %al,(%eax)
    2e13:	00 00                	add    %al,(%eax)
    2e15:	00 00                	add    %al,(%eax)
    2e17:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2e1b:	00 36                	add    %dh,(%esi)
    2e1d:	00 00                	add    %al,(%eax)
    2e1f:	00 00                	add    %al,(%eax)
    2e21:	00 00                	add    %al,(%eax)
    2e23:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    2e27:	00 39                	add    %bh,(%ecx)
    2e29:	00 00                	add    %al,(%eax)
    2e2b:	00 00                	add    %al,(%eax)
    2e2d:	00 00                	add    %al,(%eax)
    2e2f:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2e33:	00 3b                	add    %bh,(%ebx)
    2e35:	00 00                	add    %al,(%eax)
    2e37:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
    2e3d:	00 00                	add    %al,(%eax)
    2e3f:	00 00                	add    %al,(%eax)
    2e41:	00 00                	add    %al,(%eax)
    2e43:	00 f2                	add    %dh,%dl
    2e45:	11 00                	adc    %eax,(%eax)
    2e47:	00 24 00             	add    %ah,(%eax,%eax,1)
    2e4a:	00 00                	add    %al,(%eax)
    2e4c:	5f                   	pop    %edi
    2e4d:	11 28                	adc    %ebp,(%eax)
    2e4f:	00 d9                	add    %bl,%cl
    2e51:	11 00                	adc    %eax,(%eax)
    2e53:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2e59:	00 00                	add    %al,(%eax)
    2e5b:	00 00                	add    %al,(%eax)
    2e5d:	00 00                	add    %al,(%eax)
    2e5f:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
	...
    2e6b:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    2e6f:	00 09                	add    %cl,(%ecx)
    2e71:	00 00                	add    %al,(%eax)
    2e73:	00 00                	add    %al,(%eax)
    2e75:	00 00                	add    %al,(%eax)
    2e77:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2e7b:	00 13                	add    %dl,(%ebx)
    2e7d:	00 00                	add    %al,(%eax)
    2e7f:	00 00                	add    %al,(%eax)
    2e81:	00 00                	add    %al,(%eax)
    2e83:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    2e87:	00 16                	add    %dl,(%esi)
    2e89:	00 00                	add    %al,(%eax)
    2e8b:	00 00                	add    %al,(%eax)
    2e8d:	00 00                	add    %al,(%eax)
    2e8f:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2e93:	00 18                	add    %bl,(%eax)
    2e95:	00 00                	add    %al,(%eax)
    2e97:	00 00                	add    %al,(%eax)
    2e99:	00 00                	add    %al,(%eax)
    2e9b:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    2e9f:	00 1e                	add    %bl,(%esi)
    2ea1:	00 00                	add    %al,(%eax)
    2ea3:	00 00                	add    %al,(%eax)
    2ea5:	00 00                	add    %al,(%eax)
    2ea7:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2eab:	00 24 00             	add    %ah,(%eax,%eax,1)
    2eae:	00 00                	add    %al,(%eax)
    2eb0:	00 00                	add    %al,(%eax)
    2eb2:	00 00                	add    %al,(%eax)
    2eb4:	44                   	inc    %esp
    2eb5:	00 2f                	add    %ch,(%edi)
    2eb7:	00 25 00 00 00 00    	add    %ah,0x0
    2ebd:	00 00                	add    %al,(%eax)
    2ebf:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2ec3:	00 28                	add    %ch,(%eax)
    2ec5:	00 00                	add    %al,(%eax)
    2ec7:	00 00                	add    %al,(%eax)
    2ec9:	00 00                	add    %al,(%eax)
    2ecb:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    2ecf:	00 2b                	add    %ch,(%ebx)
    2ed1:	00 00                	add    %al,(%eax)
    2ed3:	00 00                	add    %al,(%eax)
    2ed5:	00 00                	add    %al,(%eax)
    2ed7:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    2edb:	00 2d 00 00 00 00    	add    %ch,0x0
    2ee1:	00 00                	add    %al,(%eax)
    2ee3:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
    2ee7:	00 30                	add    %dh,(%eax)
    2ee9:	00 00                	add    %al,(%eax)
    2eeb:	00 04 12             	add    %al,(%edx,%edx,1)
    2eee:	00 00                	add    %al,(%eax)
    2ef0:	40                   	inc    %eax
    2ef1:	00 00                	add    %al,(%eax)
    2ef3:	00 00                	add    %al,(%eax)
    2ef5:	00 00                	add    %al,(%eax)
    2ef7:	00 ad 11 00 00 40    	add    %ch,0x40000011(%ebp)
    2efd:	00 00                	add    %al,(%eax)
    2eff:	00 02                	add    %al,(%edx)
    2f01:	00 00                	add    %al,(%eax)
    2f03:	00 00                	add    %al,(%eax)
    2f05:	00 00                	add    %al,(%eax)
    2f07:	00 c0                	add    %al,%al
	...
    2f11:	00 00                	add    %al,(%eax)
    2f13:	00 e0                	add    %ah,%al
    2f15:	00 00                	add    %al,(%eax)
    2f17:	00 35 00 00 00 10    	add    %dh,0x10000000
    2f1d:	12 00                	adc    (%eax),%al
    2f1f:	00 24 00             	add    %ah,(%eax,%eax,1)
    2f22:	00 00                	add    %al,(%eax)
    2f24:	94                   	xchg   %eax,%esp
    2f25:	11 28                	adc    %ebp,(%eax)
    2f27:	00 d9                	add    %bl,%cl
    2f29:	11 00                	adc    %eax,(%eax)
    2f2b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2f31:	00 00                	add    %al,(%eax)
    2f33:	00 00                	add    %al,(%eax)
    2f35:	00 00                	add    %al,(%eax)
    2f37:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
	...
    2f43:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    2f47:	00 03                	add    %al,(%ebx)
    2f49:	00 00                	add    %al,(%eax)
    2f4b:	00 00                	add    %al,(%eax)
    2f4d:	00 00                	add    %al,(%eax)
    2f4f:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2f53:	00 06                	add    %al,(%esi)
    2f55:	00 00                	add    %al,(%eax)
    2f57:	00 00                	add    %al,(%eax)
    2f59:	00 00                	add    %al,(%eax)
    2f5b:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
    2f5f:	00 07                	add    %al,(%edi)
    2f61:	00 00                	add    %al,(%eax)
    2f63:	00 00                	add    %al,(%eax)
    2f65:	00 00                	add    %al,(%eax)
    2f67:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2f6b:	00 0d 00 00 00 ad    	add    %cl,0xad000000
    2f71:	11 00                	adc    %eax,(%eax)
    2f73:	00 40 00             	add    %al,0x0(%eax)
    2f76:	00 00                	add    %al,(%eax)
    2f78:	02 00                	add    (%eax),%al
    2f7a:	00 00                	add    %al,(%eax)
    2f7c:	00 00                	add    %al,(%eax)
    2f7e:	00 00                	add    %al,(%eax)
    2f80:	64 00 00             	add    %al,%fs:(%eax)
    2f83:	00 a2 11 28 00 24    	add    %ah,0x24002811(%edx)
    2f89:	12 00                	adc    (%eax),%al
    2f8b:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    2f8f:	00 a2 11 28 00 08    	add    %ah,0x8002811(%edx)
    2f95:	00 00                	add    %al,(%eax)
    2f97:	00 3c 00             	add    %bh,(%eax,%eax,1)
    2f9a:	00 00                	add    %al,(%eax)
    2f9c:	00 00                	add    %al,(%eax)
    2f9e:	00 00                	add    %al,(%eax)
    2fa0:	17                   	pop    %ss
    2fa1:	00 00                	add    %al,(%eax)
    2fa3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2fa9:	00 00                	add    %al,(%eax)
    2fab:	00 41 00             	add    %al,0x0(%ecx)
    2fae:	00 00                	add    %al,(%eax)
    2fb0:	80 00 00             	addb   $0x0,(%eax)
    2fb3:	00 00                	add    %al,(%eax)
    2fb5:	00 00                	add    %al,(%eax)
    2fb7:	00 5b 00             	add    %bl,0x0(%ebx)
    2fba:	00 00                	add    %al,(%eax)
    2fbc:	80 00 00             	addb   $0x0,(%eax)
    2fbf:	00 00                	add    %al,(%eax)
    2fc1:	00 00                	add    %al,(%eax)
    2fc3:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2fc9:	00 00                	add    %al,(%eax)
    2fcb:	00 00                	add    %al,(%eax)
    2fcd:	00 00                	add    %al,(%eax)
    2fcf:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2fd5:	00 00                	add    %al,(%eax)
    2fd7:	00 00                	add    %al,(%eax)
    2fd9:	00 00                	add    %al,(%eax)
    2fdb:	00 e1                	add    %ah,%cl
    2fdd:	00 00                	add    %al,(%eax)
    2fdf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2fe5:	00 00                	add    %al,(%eax)
    2fe7:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2fea:	00 00                	add    %al,(%eax)
    2fec:	80 00 00             	addb   $0x0,(%eax)
    2fef:	00 00                	add    %al,(%eax)
    2ff1:	00 00                	add    %al,(%eax)
    2ff3:	00 37                	add    %dh,(%edi)
    2ff5:	01 00                	add    %eax,(%eax)
    2ff7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2ffd:	00 00                	add    %al,(%eax)
    2fff:	00 5d 01             	add    %bl,0x1(%ebp)
    3002:	00 00                	add    %al,(%eax)
    3004:	80 00 00             	addb   $0x0,(%eax)
    3007:	00 00                	add    %al,(%eax)
    3009:	00 00                	add    %al,(%eax)
    300b:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    3011:	00 00                	add    %al,(%eax)
    3013:	00 00                	add    %al,(%eax)
    3015:	00 00                	add    %al,(%eax)
    3017:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    301d:	00 00                	add    %al,(%eax)
    301f:	00 00                	add    %al,(%eax)
    3021:	00 00                	add    %al,(%eax)
    3023:	00 d2                	add    %dl,%dl
    3025:	01 00                	add    %eax,(%eax)
    3027:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    302d:	00 00                	add    %al,(%eax)
    302f:	00 ec                	add    %ch,%ah
    3031:	01 00                	add    %eax,(%eax)
    3033:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3039:	00 00                	add    %al,(%eax)
    303b:	00 07                	add    %al,(%edi)
    303d:	02 00                	add    (%eax),%al
    303f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3045:	00 00                	add    %al,(%eax)
    3047:	00 28                	add    %ch,(%eax)
    3049:	02 00                	add    (%eax),%al
    304b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3051:	00 00                	add    %al,(%eax)
    3053:	00 47 02             	add    %al,0x2(%edi)
    3056:	00 00                	add    %al,(%eax)
    3058:	80 00 00             	addb   $0x0,(%eax)
    305b:	00 00                	add    %al,(%eax)
    305d:	00 00                	add    %al,(%eax)
    305f:	00 66 02             	add    %ah,0x2(%esi)
    3062:	00 00                	add    %al,(%eax)
    3064:	80 00 00             	addb   $0x0,(%eax)
    3067:	00 00                	add    %al,(%eax)
    3069:	00 00                	add    %al,(%eax)
    306b:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    3071:	00 00                	add    %al,(%eax)
    3073:	00 00                	add    %al,(%eax)
    3075:	00 00                	add    %al,(%eax)
    3077:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    307d:	00 00                	add    %al,(%eax)
    307f:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    3085:	02 00                	add    (%eax),%al
    3087:	00 c2                	add    %al,%dl
    3089:	00 00                	add    %al,(%eax)
    308b:	00 00                	add    %al,(%eax)
    308d:	00 00                	add    %al,(%eax)
    308f:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    3095:	00 00                	add    %al,(%eax)
    3097:	00 37                	add    %dh,(%edi)
    3099:	53                   	push   %ebx
    309a:	00 00                	add    %al,(%eax)
    309c:	29 04 00             	sub    %eax,(%eax,%eax,1)
    309f:	00 c2                	add    %al,%dl
    30a1:	00 00                	add    %al,(%eax)
    30a3:	00 17                	add    %dl,(%edi)
    30a5:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    30a6:	00 00                	add    %al,(%eax)
    30a8:	2c 12                	sub    $0x12,%al
    30aa:	00 00                	add    %al,(%eax)
    30ac:	24 00                	and    $0x0,%al
    30ae:	00 00                	add    %al,(%eax)
    30b0:	a2 11 28 00 41       	mov    %al,0x41002811
    30b5:	12 00                	adc    (%eax),%al
    30b7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    30bd:	00 00                	add    %al,(%eax)
    30bf:	00 00                	add    %al,(%eax)
    30c1:	00 00                	add    %al,(%eax)
    30c3:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
	...
    30cf:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    30d3:	00 06                	add    %al,(%esi)
    30d5:	00 00                	add    %al,(%eax)
    30d7:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    30dd:	00 00                	add    %al,(%eax)
    30df:	00 ad 11 28 00 00    	add    %ch,0x2811(%ebp)
    30e5:	00 00                	add    %al,(%eax)
    30e7:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    30eb:	00 0b                	add    %cl,(%ebx)
    30ed:	00 00                	add    %al,(%eax)
    30ef:	00 24 12             	add    %ah,(%edx,%edx,1)
    30f2:	00 00                	add    %al,(%eax)
    30f4:	84 00                	test   %al,(%eax)
    30f6:	00 00                	add    %al,(%eax)
    30f8:	b5 11                	mov    $0x11,%ch
    30fa:	28 00                	sub    %al,(%eax)
    30fc:	00 00                	add    %al,(%eax)
    30fe:	00 00                	add    %al,(%eax)
    3100:	44                   	inc    %esp
    3101:	00 09                	add    %cl,(%ecx)
    3103:	00 13                	add    %dl,(%ebx)
    3105:	00 00                	add    %al,(%eax)
    3107:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    310d:	00 00                	add    %al,(%eax)
    310f:	00 ba 11 28 00 00    	add    %bh,0x2811(%edx)
    3115:	00 00                	add    %al,(%eax)
    3117:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    311b:	00 18                	add    %bl,(%eax)
    311d:	00 00                	add    %al,(%eax)
    311f:	00 24 12             	add    %ah,(%edx,%edx,1)
    3122:	00 00                	add    %al,(%eax)
    3124:	84 00                	test   %al,(%eax)
    3126:	00 00                	add    %al,(%eax)
    3128:	c2 11 28             	ret    $0x2811
    312b:	00 00                	add    %al,(%eax)
    312d:	00 00                	add    %al,(%eax)
    312f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    3133:	00 20                	add    %ah,(%eax)
    3135:	00 00                	add    %al,(%eax)
    3137:	00 00                	add    %al,(%eax)
    3139:	00 00                	add    %al,(%eax)
    313b:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    313f:	00 27                	add    %ah,(%edi)
    3141:	00 00                	add    %al,(%eax)
    3143:	00 55 12             	add    %dl,0x12(%ebp)
    3146:	00 00                	add    %al,(%eax)
    3148:	40                   	inc    %eax
    3149:	00 00                	add    %al,(%eax)
    314b:	00 00                	add    %al,(%eax)
    314d:	00 00                	add    %al,(%eax)
    314f:	00 62 12             	add    %ah,0x12(%edx)
    3152:	00 00                	add    %al,(%eax)
    3154:	24 00                	and    $0x0,%al
    3156:	00 00                	add    %al,(%eax)
    3158:	cb                   	lret   
    3159:	11 28                	adc    %ebp,(%eax)
    315b:	00 76 12             	add    %dh,0x12(%esi)
    315e:	00 00                	add    %al,(%eax)
    3160:	a0 00 00 00 08       	mov    0x8000000,%al
    3165:	00 00                	add    %al,(%eax)
    3167:	00 e6                	add    %ah,%dh
    3169:	11 00                	adc    %eax,(%eax)
    316b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3171:	00 00                	add    %al,(%eax)
    3173:	00 00                	add    %al,(%eax)
    3175:	00 00                	add    %al,(%eax)
    3177:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
	...
    3183:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    3187:	00 07                	add    %al,(%edi)
    3189:	00 00                	add    %al,(%eax)
    318b:	00 00                	add    %al,(%eax)
    318d:	00 00                	add    %al,(%eax)
    318f:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    3193:	00 0a                	add    %cl,(%edx)
    3195:	00 00                	add    %al,(%eax)
    3197:	00 00                	add    %al,(%eax)
    3199:	00 00                	add    %al,(%eax)
    319b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    319f:	00 11                	add    %dl,(%ecx)
    31a1:	00 00                	add    %al,(%eax)
    31a3:	00 00                	add    %al,(%eax)
    31a5:	00 00                	add    %al,(%eax)
    31a7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    31ab:	00 13                	add    %dl,(%ebx)
    31ad:	00 00                	add    %al,(%eax)
    31af:	00 00                	add    %al,(%eax)
    31b1:	00 00                	add    %al,(%eax)
    31b3:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    31b7:	00 18                	add    %bl,(%eax)
    31b9:	00 00                	add    %al,(%eax)
    31bb:	00 00                	add    %al,(%eax)
    31bd:	00 00                	add    %al,(%eax)
    31bf:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    31c3:	00 1e                	add    %bl,(%esi)
    31c5:	00 00                	add    %al,(%eax)
    31c7:	00 00                	add    %al,(%eax)
    31c9:	00 00                	add    %al,(%eax)
    31cb:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    31cf:	00 22                	add    %ah,(%edx)
    31d1:	00 00                	add    %al,(%eax)
    31d3:	00 00                	add    %al,(%eax)
    31d5:	00 00                	add    %al,(%eax)
    31d7:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    31db:	00 2b                	add    %ch,(%ebx)
    31dd:	00 00                	add    %al,(%eax)
    31df:	00 00                	add    %al,(%eax)
    31e1:	00 00                	add    %al,(%eax)
    31e3:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    31e7:	00 2d 00 00 00 00    	add    %ch,0x0
    31ed:	00 00                	add    %al,(%eax)
    31ef:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    31f3:	00 33                	add    %dh,(%ebx)
    31f5:	00 00                	add    %al,(%eax)
    31f7:	00 00                	add    %al,(%eax)
    31f9:	00 00                	add    %al,(%eax)
    31fb:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    31ff:	00 37                	add    %dh,(%edi)
    3201:	00 00                	add    %al,(%eax)
    3203:	00 00                	add    %al,(%eax)
    3205:	00 00                	add    %al,(%eax)
    3207:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    320b:	00 3a                	add    %bh,(%edx)
    320d:	00 00                	add    %al,(%eax)
    320f:	00 00                	add    %al,(%eax)
    3211:	00 00                	add    %al,(%eax)
    3213:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    3217:	00 3e                	add    %bh,(%esi)
    3219:	00 00                	add    %al,(%eax)
    321b:	00 00                	add    %al,(%eax)
    321d:	00 00                	add    %al,(%eax)
    321f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    3223:	00 42 00             	add    %al,0x0(%edx)
    3226:	00 00                	add    %al,(%eax)
    3228:	00 00                	add    %al,(%eax)
    322a:	00 00                	add    %al,(%eax)
    322c:	44                   	inc    %esp
    322d:	00 33                	add    %dh,(%ebx)
    322f:	00 46 00             	add    %al,0x0(%esi)
    3232:	00 00                	add    %al,(%eax)
    3234:	00 00                	add    %al,(%eax)
    3236:	00 00                	add    %al,(%eax)
    3238:	44                   	inc    %esp
    3239:	00 2f                	add    %ch,(%edi)
    323b:	00 48 00             	add    %cl,0x0(%eax)
    323e:	00 00                	add    %al,(%eax)
    3240:	00 00                	add    %al,(%eax)
    3242:	00 00                	add    %al,(%eax)
    3244:	44                   	inc    %esp
    3245:	00 35 00 4b 00 00    	add    %dh,0x4b00
    324b:	00 00                	add    %al,(%eax)
    324d:	00 00                	add    %al,(%eax)
    324f:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    3253:	00 4e 00             	add    %cl,0x0(%esi)
    3256:	00 00                	add    %al,(%eax)
    3258:	00 00                	add    %al,(%eax)
    325a:	00 00                	add    %al,(%eax)
    325c:	44                   	inc    %esp
    325d:	00 35 00 52 00 00    	add    %dh,0x5200
    3263:	00 00                	add    %al,(%eax)
    3265:	00 00                	add    %al,(%eax)
    3267:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    326b:	00 55 00             	add    %dl,0x0(%ebp)
    326e:	00 00                	add    %al,(%eax)
    3270:	00 00                	add    %al,(%eax)
    3272:	00 00                	add    %al,(%eax)
    3274:	44                   	inc    %esp
    3275:	00 38                	add    %bh,(%eax)
    3277:	00 5a 00             	add    %bl,0x0(%edx)
    327a:	00 00                	add    %al,(%eax)
    327c:	00 00                	add    %al,(%eax)
    327e:	00 00                	add    %al,(%eax)
    3280:	44                   	inc    %esp
    3281:	00 33                	add    %dh,(%ebx)
    3283:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    3287:	00 00                	add    %al,(%eax)
    3289:	00 00                	add    %al,(%eax)
    328b:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    328f:	00 5f 00             	add    %bl,0x0(%edi)
    3292:	00 00                	add    %al,(%eax)
    3294:	00 00                	add    %al,(%eax)
    3296:	00 00                	add    %al,(%eax)
    3298:	44                   	inc    %esp
    3299:	00 38                	add    %bh,(%eax)
    329b:	00 66 00             	add    %ah,0x0(%esi)
    329e:	00 00                	add    %al,(%eax)
    32a0:	00 00                	add    %al,(%eax)
    32a2:	00 00                	add    %al,(%eax)
    32a4:	44                   	inc    %esp
    32a5:	00 3a                	add    %bh,(%edx)
    32a7:	00 68 00             	add    %ch,0x0(%eax)
    32aa:	00 00                	add    %al,(%eax)
    32ac:	00 00                	add    %al,(%eax)
    32ae:	00 00                	add    %al,(%eax)
    32b0:	44                   	inc    %esp
    32b1:	00 3c 00             	add    %bh,(%eax,%eax,1)
    32b4:	71 00                	jno    32b6 <bootmain-0x27cd4a>
    32b6:	00 00                	add    %al,(%eax)
    32b8:	00 00                	add    %al,(%eax)
    32ba:	00 00                	add    %al,(%eax)
    32bc:	44                   	inc    %esp
    32bd:	00 3e                	add    %bh,(%esi)
    32bf:	00 75 00             	add    %dh,0x0(%ebp)
    32c2:	00 00                	add    %al,(%eax)
    32c4:	00 00                	add    %al,(%eax)
    32c6:	00 00                	add    %al,(%eax)
    32c8:	44                   	inc    %esp
    32c9:	00 41 00             	add    %al,0x0(%ecx)
    32cc:	7e 00                	jle    32ce <bootmain-0x27cd32>
    32ce:	00 00                	add    %al,(%eax)
    32d0:	00 00                	add    %al,(%eax)
    32d2:	00 00                	add    %al,(%eax)
    32d4:	44                   	inc    %esp
    32d5:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    32d9:	00 00                	add    %al,(%eax)
    32db:	00 00                	add    %al,(%eax)
    32dd:	00 00                	add    %al,(%eax)
    32df:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    32e3:	00 88 00 00 00 00    	add    %cl,0x0(%eax)
    32e9:	00 00                	add    %al,(%eax)
    32eb:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    32ef:	00 8b 00 00 00 55    	add    %cl,0x55000000(%ebx)
    32f5:	12 00                	adc    (%eax),%al
    32f7:	00 40 00             	add    %al,0x0(%eax)
    32fa:	00 00                	add    %al,(%eax)
    32fc:	02 00                	add    (%eax),%al
    32fe:	00 00                	add    %al,(%eax)
    3300:	00 00                	add    %al,(%eax)
    3302:	00 00                	add    %al,(%eax)
    3304:	64 00 00             	add    %al,%fs:(%eax)
    3307:	00 59 12             	add    %bl,0x12(%ecx)
    330a:	28 00                	sub    %al,(%eax)
    330c:	83 12 00             	adcl   $0x0,(%edx)
    330f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    3313:	00 59 12             	add    %bl,0x12(%ecx)
    3316:	28 00                	sub    %al,(%eax)
    3318:	08 00                	or     %al,(%eax)
    331a:	00 00                	add    %al,(%eax)
    331c:	3c 00                	cmp    $0x0,%al
    331e:	00 00                	add    %al,(%eax)
    3320:	00 00                	add    %al,(%eax)
    3322:	00 00                	add    %al,(%eax)
    3324:	17                   	pop    %ss
    3325:	00 00                	add    %al,(%eax)
    3327:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    332d:	00 00                	add    %al,(%eax)
    332f:	00 41 00             	add    %al,0x0(%ecx)
    3332:	00 00                	add    %al,(%eax)
    3334:	80 00 00             	addb   $0x0,(%eax)
    3337:	00 00                	add    %al,(%eax)
    3339:	00 00                	add    %al,(%eax)
    333b:	00 5b 00             	add    %bl,0x0(%ebx)
    333e:	00 00                	add    %al,(%eax)
    3340:	80 00 00             	addb   $0x0,(%eax)
    3343:	00 00                	add    %al,(%eax)
    3345:	00 00                	add    %al,(%eax)
    3347:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    334d:	00 00                	add    %al,(%eax)
    334f:	00 00                	add    %al,(%eax)
    3351:	00 00                	add    %al,(%eax)
    3353:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    3359:	00 00                	add    %al,(%eax)
    335b:	00 00                	add    %al,(%eax)
    335d:	00 00                	add    %al,(%eax)
    335f:	00 e1                	add    %ah,%cl
    3361:	00 00                	add    %al,(%eax)
    3363:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3369:	00 00                	add    %al,(%eax)
    336b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    336e:	00 00                	add    %al,(%eax)
    3370:	80 00 00             	addb   $0x0,(%eax)
    3373:	00 00                	add    %al,(%eax)
    3375:	00 00                	add    %al,(%eax)
    3377:	00 37                	add    %dh,(%edi)
    3379:	01 00                	add    %eax,(%eax)
    337b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3381:	00 00                	add    %al,(%eax)
    3383:	00 5d 01             	add    %bl,0x1(%ebp)
    3386:	00 00                	add    %al,(%eax)
    3388:	80 00 00             	addb   $0x0,(%eax)
    338b:	00 00                	add    %al,(%eax)
    338d:	00 00                	add    %al,(%eax)
    338f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    3395:	00 00                	add    %al,(%eax)
    3397:	00 00                	add    %al,(%eax)
    3399:	00 00                	add    %al,(%eax)
    339b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    33a1:	00 00                	add    %al,(%eax)
    33a3:	00 00                	add    %al,(%eax)
    33a5:	00 00                	add    %al,(%eax)
    33a7:	00 d2                	add    %dl,%dl
    33a9:	01 00                	add    %eax,(%eax)
    33ab:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    33b1:	00 00                	add    %al,(%eax)
    33b3:	00 ec                	add    %ch,%ah
    33b5:	01 00                	add    %eax,(%eax)
    33b7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    33bd:	00 00                	add    %al,(%eax)
    33bf:	00 07                	add    %al,(%edi)
    33c1:	02 00                	add    (%eax),%al
    33c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    33c9:	00 00                	add    %al,(%eax)
    33cb:	00 28                	add    %ch,(%eax)
    33cd:	02 00                	add    (%eax),%al
    33cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    33d5:	00 00                	add    %al,(%eax)
    33d7:	00 47 02             	add    %al,0x2(%edi)
    33da:	00 00                	add    %al,(%eax)
    33dc:	80 00 00             	addb   $0x0,(%eax)
    33df:	00 00                	add    %al,(%eax)
    33e1:	00 00                	add    %al,(%eax)
    33e3:	00 66 02             	add    %ah,0x2(%esi)
    33e6:	00 00                	add    %al,(%eax)
    33e8:	80 00 00             	addb   $0x0,(%eax)
    33eb:	00 00                	add    %al,(%eax)
    33ed:	00 00                	add    %al,(%eax)
    33ef:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    33f5:	00 00                	add    %al,(%eax)
    33f7:	00 00                	add    %al,(%eax)
    33f9:	00 00                	add    %al,(%eax)
    33fb:	00 29                	add    %ch,(%ecx)
    33fd:	04 00                	add    $0x0,%al
    33ff:	00 c2                	add    %al,%dl
    3401:	00 00                	add    %al,(%eax)
    3403:	00 17                	add    %dl,(%edi)
    3405:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    3406:	00 00                	add    %al,(%eax)
    3408:	ae                   	scas   %es:(%edi),%al
    3409:	02 00                	add    (%eax),%al
    340b:	00 c2                	add    %al,%dl
    340d:	00 00                	add    %al,(%eax)
    340f:	00 00                	add    %al,(%eax)
    3411:	00 00                	add    %al,(%eax)
    3413:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    3419:	00 00                	add    %al,(%eax)
    341b:	00 37                	add    %dh,(%edi)
    341d:	53                   	push   %ebx
    341e:	00 00                	add    %al,(%eax)
    3420:	88 12                	mov    %dl,(%edx)
    3422:	00 00                	add    %al,(%eax)
    3424:	24 00                	and    $0x0,%al
    3426:	00 00                	add    %al,(%eax)
    3428:	59                   	pop    %ecx
    3429:	12 28                	adc    (%eax),%ch
    342b:	00 9d 12 00 00 a0    	add    %bl,-0x5fffffee(%ebp)
    3431:	00 00                	add    %al,(%eax)
    3433:	00 08                	add    %cl,(%eax)
    3435:	00 00                	add    %al,(%eax)
    3437:	00 aa 12 00 00 a0    	add    %ch,-0x5fffffee(%edx)
    343d:	00 00                	add    %al,(%eax)
    343f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    3442:	00 00                	add    %al,(%eax)
    3444:	00 00                	add    %al,(%eax)
    3446:	00 00                	add    %al,(%eax)
    3448:	44                   	inc    %esp
    3449:	00 05 00 00 00 00    	add    %al,0x0
    344f:	00 00                	add    %al,(%eax)
    3451:	00 00                	add    %al,(%eax)
    3453:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    3457:	00 07                	add    %al,(%edi)
    3459:	00 00                	add    %al,(%eax)
    345b:	00 00                	add    %al,(%eax)
    345d:	00 00                	add    %al,(%eax)
    345f:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    3463:	00 0c 00             	add    %cl,(%eax,%eax,1)
    3466:	00 00                	add    %al,(%eax)
    3468:	00 00                	add    %al,(%eax)
    346a:	00 00                	add    %al,(%eax)
    346c:	44                   	inc    %esp
    346d:	00 11                	add    %dl,(%ecx)
    346f:	00 12                	add    %dl,(%edx)
    3471:	00 00                	add    %al,(%eax)
    3473:	00 00                	add    %al,(%eax)
    3475:	00 00                	add    %al,(%eax)
    3477:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    347b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    347e:	00 00                	add    %al,(%eax)
    3480:	00 00                	add    %al,(%eax)
    3482:	00 00                	add    %al,(%eax)
    3484:	44                   	inc    %esp
    3485:	00 14 00             	add    %dl,(%eax,%eax,1)
    3488:	22 00                	and    (%eax),%al
    348a:	00 00                	add    %al,(%eax)
    348c:	00 00                	add    %al,(%eax)
    348e:	00 00                	add    %al,(%eax)
    3490:	44                   	inc    %esp
    3491:	00 12                	add    %dl,(%edx)
    3493:	00 28                	add    %ch,(%eax)
    3495:	00 00                	add    %al,(%eax)
    3497:	00 00                	add    %al,(%eax)
    3499:	00 00                	add    %al,(%eax)
    349b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    349f:	00 30                	add    %dh,(%eax)
    34a1:	00 00                	add    %al,(%eax)
    34a3:	00 00                	add    %al,(%eax)
    34a5:	00 00                	add    %al,(%eax)
    34a7:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    34ab:	00 37                	add    %dh,(%edi)
    34ad:	00 00                	add    %al,(%eax)
    34af:	00 b5 12 00 00 40    	add    %dh,0x40000012(%ebp)
    34b5:	00 00                	add    %al,(%eax)
    34b7:	00 02                	add    %al,(%edx)
    34b9:	00 00                	add    %al,(%eax)
    34bb:	00 c0                	add    %al,%al
    34bd:	12 00                	adc    (%eax),%al
    34bf:	00 40 00             	add    %al,0x0(%eax)
    34c2:	00 00                	add    %al,(%eax)
    34c4:	01 00                	add    %eax,(%eax)
    34c6:	00 00                	add    %al,(%eax)
    34c8:	d1 12                	rcll   (%edx)
    34ca:	00 00                	add    %al,(%eax)
    34cc:	40                   	inc    %eax
	...
    34d5:	00 00                	add    %al,(%eax)
    34d7:	00 c0                	add    %al,%al
	...
    34e1:	00 00                	add    %al,(%eax)
    34e3:	00 e0                	add    %ah,%al
    34e5:	00 00                	add    %al,(%eax)
    34e7:	00 3a                	add    %bh,(%edx)
    34e9:	00 00                	add    %al,(%eax)
    34eb:	00 de                	add    %bl,%dh
    34ed:	12 00                	adc    (%eax),%al
    34ef:	00 24 00             	add    %ah,(%eax,%eax,1)
    34f2:	00 00                	add    %al,(%eax)
    34f4:	93                   	xchg   %eax,%ebx
    34f5:	12 28                	adc    (%eax),%ch
    34f7:	00 9d 12 00 00 a0    	add    %bl,-0x5fffffee(%ebp)
    34fd:	00 00                	add    %al,(%eax)
    34ff:	00 08                	add    %cl,(%eax)
    3501:	00 00                	add    %al,(%eax)
    3503:	00 aa 12 00 00 a0    	add    %ch,-0x5fffffee(%edx)
    3509:	00 00                	add    %al,(%eax)
    350b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    350e:	00 00                	add    %al,(%eax)
    3510:	00 00                	add    %al,(%eax)
    3512:	00 00                	add    %al,(%eax)
    3514:	44                   	inc    %esp
    3515:	00 21                	add    %ah,(%ecx)
    3517:	00 00                	add    %al,(%eax)
    3519:	00 00                	add    %al,(%eax)
    351b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3521:	00 00                	add    %al,(%eax)
    3523:	00 97 12 28 00 00    	add    %dl,0x2812(%edi)
    3529:	00 00                	add    %al,(%eax)
    352b:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    352f:	01 04 00             	add    %eax,(%eax,%eax,1)
    3532:	00 00                	add    %al,(%eax)
    3534:	83 12 00             	adcl   $0x0,(%edx)
    3537:	00 84 00 00 00 99 12 	add    %al,0x12990000(%eax,%eax,1)
    353e:	28 00                	sub    %al,(%eax)
    3540:	00 00                	add    %al,(%eax)
    3542:	00 00                	add    %al,(%eax)
    3544:	44                   	inc    %esp
    3545:	00 25 00 06 00 00    	add    %ah,0x600
    354b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3551:	00 00                	add    %al,(%eax)
    3553:	00 9e 12 28 00 00    	add    %bl,0x2812(%esi)
    3559:	00 00                	add    %al,(%eax)
    355b:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    355f:	01 0b                	add    %ecx,(%ebx)
    3561:	00 00                	add    %al,(%eax)
    3563:	00 00                	add    %al,(%eax)
    3565:	00 00                	add    %al,(%eax)
    3567:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    356b:	01 0d 00 00 00 83    	add    %ecx,0x83000000
    3571:	12 00                	adc    (%eax),%al
    3573:	00 84 00 00 00 a2 12 	add    %al,0x12a20000(%eax,%eax,1)
    357a:	28 00                	sub    %al,(%eax)
    357c:	00 00                	add    %al,(%eax)
    357e:	00 00                	add    %al,(%eax)
    3580:	44                   	inc    %esp
    3581:	00 22                	add    %ah,(%edx)
    3583:	00 0f                	add    %cl,(%edi)
    3585:	00 00                	add    %al,(%eax)
    3587:	00 00                	add    %al,(%eax)
    3589:	00 00                	add    %al,(%eax)
    358b:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    358f:	00 11                	add    %dl,(%ecx)
    3591:	00 00                	add    %al,(%eax)
    3593:	00 00                	add    %al,(%eax)
    3595:	00 00                	add    %al,(%eax)
    3597:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    359b:	00 18                	add    %bl,(%eax)
    359d:	00 00                	add    %al,(%eax)
    359f:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    35a5:	00 00                	add    %al,(%eax)
    35a7:	00 b0 12 28 00 00    	add    %dh,0x2812(%eax)
    35ad:	00 00                	add    %al,(%eax)
    35af:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    35b3:	01 1d 00 00 00 00    	add    %ebx,0x0
    35b9:	00 00                	add    %al,(%eax)
    35bb:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
    35bf:	00 1f                	add    %bl,(%edi)
    35c1:	00 00                	add    %al,(%eax)
    35c3:	00 83 12 00 00 84    	add    %al,-0x7bffffee(%ebx)
    35c9:	00 00                	add    %al,(%eax)
    35cb:	00 b5 12 28 00 00    	add    %dh,0x2812(%ebp)
    35d1:	00 00                	add    %al,(%eax)
    35d3:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    35d7:	00 22                	add    %ah,(%edx)
    35d9:	00 00                	add    %al,(%eax)
    35db:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    35e1:	00 00                	add    %al,(%eax)
    35e3:	00 ba 12 28 00 00    	add    %bh,0x2812(%edx)
    35e9:	00 00                	add    %al,(%eax)
    35eb:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    35ef:	00 27                	add    %ah,(%edi)
    35f1:	00 00                	add    %al,(%eax)
    35f3:	00 83 12 00 00 84    	add    %al,-0x7bffffee(%ebx)
    35f9:	00 00                	add    %al,(%eax)
    35fb:	00 bd 12 28 00 00    	add    %bh,0x2812(%ebp)
    3601:	00 00                	add    %al,(%eax)
    3603:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    3607:	00 2a                	add    %ch,(%edx)
    3609:	00 00                	add    %al,(%eax)
    360b:	00 00                	add    %al,(%eax)
    360d:	00 00                	add    %al,(%eax)
    360f:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
    3613:	00 2c 00             	add    %ch,(%eax,%eax,1)
    3616:	00 00                	add    %al,(%eax)
    3618:	00 00                	add    %al,(%eax)
    361a:	00 00                	add    %al,(%eax)
    361c:	44                   	inc    %esp
    361d:	00 3a                	add    %bh,(%edx)
    361f:	00 37                	add    %dh,(%edi)
    3621:	00 00                	add    %al,(%eax)
    3623:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3629:	00 00                	add    %al,(%eax)
    362b:	00 d0                	add    %dl,%al
    362d:	12 28                	adc    (%eax),%ch
    362f:	00 00                	add    %al,(%eax)
    3631:	00 00                	add    %al,(%eax)
    3633:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
    3637:	00 3d 00 00 00 83    	add    %bh,0x83000000
    363d:	12 00                	adc    (%eax),%al
    363f:	00 84 00 00 00 d3 12 	add    %al,0x12d30000(%eax,%eax,1)
    3646:	28 00                	sub    %al,(%eax)
    3648:	00 00                	add    %al,(%eax)
    364a:	00 00                	add    %al,(%eax)
    364c:	44                   	inc    %esp
    364d:	00 3d 00 40 00 00    	add    %bh,0x4000
    3653:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3659:	00 00                	add    %al,(%eax)
    365b:	00 d9                	add    %bl,%cl
    365d:	12 28                	adc    (%eax),%ch
    365f:	00 00                	add    %al,(%eax)
    3661:	00 00                	add    %al,(%eax)
    3663:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    3667:	00 46 00             	add    %al,0x0(%esi)
    366a:	00 00                	add    %al,(%eax)
    366c:	83 12 00             	adcl   $0x0,(%edx)
    366f:	00 84 00 00 00 dc 12 	add    %al,0x12dc0000(%eax,%eax,1)
    3676:	28 00                	sub    %al,(%eax)
    3678:	00 00                	add    %al,(%eax)
    367a:	00 00                	add    %al,(%eax)
    367c:	44                   	inc    %esp
    367d:	00 43 00             	add    %al,0x0(%ebx)
    3680:	49                   	dec    %ecx
    3681:	00 00                	add    %al,(%eax)
    3683:	00 ed                	add    %ch,%ch
    3685:	12 00                	adc    (%eax),%al
    3687:	00 40 00             	add    %al,0x0(%eax)
    368a:	00 00                	add    %al,(%eax)
    368c:	03 00                	add    (%eax),%eax
    368e:	00 00                	add    %al,(%eax)
    3690:	fb                   	sti    
    3691:	12 00                	adc    (%eax),%al
    3693:	00 40 00             	add    %al,0x0(%eax)
	...
    369e:	00 00                	add    %al,(%eax)
    36a0:	c0 00 00             	rolb   $0x0,(%eax)
	...
    36ab:	00 e0                	add    %ah,%al
    36ad:	00 00                	add    %al,(%eax)
    36af:	00 4e 00             	add    %cl,0x0(%esi)
    36b2:	00 00                	add    %al,(%eax)
    36b4:	04 13                	add    $0x13,%al
    36b6:	00 00                	add    %al,(%eax)
    36b8:	24 00                	and    $0x0,%al
    36ba:	00 00                	add    %al,(%eax)
    36bc:	e1 12                	loope  36d0 <bootmain-0x27c930>
    36be:	28 00                	sub    %al,(%eax)
    36c0:	18 13                	sbb    %dl,(%ebx)
    36c2:	00 00                	add    %al,(%eax)
    36c4:	a0 00 00 00 08       	mov    0x8000000,%al
    36c9:	00 00                	add    %al,(%eax)
    36cb:	00 00                	add    %al,(%eax)
    36cd:	00 00                	add    %al,(%eax)
    36cf:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
	...
    36db:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    36df:	00 03                	add    %al,(%ebx)
    36e1:	00 00                	add    %al,(%eax)
    36e3:	00 00                	add    %al,(%eax)
    36e5:	00 00                	add    %al,(%eax)
    36e7:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    36eb:	00 06                	add    %al,(%esi)
    36ed:	00 00                	add    %al,(%eax)
    36ef:	00 00                	add    %al,(%eax)
    36f1:	00 00                	add    %al,(%eax)
    36f3:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    36f7:	00 0c 00             	add    %cl,(%eax,%eax,1)
    36fa:	00 00                	add    %al,(%eax)
    36fc:	00 00                	add    %al,(%eax)
    36fe:	00 00                	add    %al,(%eax)
    3700:	44                   	inc    %esp
    3701:	00 4a 00             	add    %cl,0x0(%edx)
    3704:	13 00                	adc    (%eax),%eax
    3706:	00 00                	add    %al,(%eax)
    3708:	00 00                	add    %al,(%eax)
    370a:	00 00                	add    %al,(%eax)
    370c:	44                   	inc    %esp
    370d:	00 4b 00             	add    %cl,0x0(%ebx)
    3710:	1a 00                	sbb    (%eax),%al
    3712:	00 00                	add    %al,(%eax)
    3714:	00 00                	add    %al,(%eax)
    3716:	00 00                	add    %al,(%eax)
    3718:	44                   	inc    %esp
    3719:	00 4c 00 21          	add    %cl,0x21(%eax,%eax,1)
    371d:	00 00                	add    %al,(%eax)
    371f:	00 2b                	add    %ch,(%ebx)
    3721:	13 00                	adc    (%eax),%eax
    3723:	00 40 00             	add    %al,0x0(%eax)
    3726:	00 00                	add    %al,(%eax)
    3728:	00 00                	add    %al,(%eax)
    372a:	00 00                	add    %al,(%eax)
    372c:	37                   	aaa    
    372d:	13 00                	adc    (%eax),%eax
    372f:	00 24 00             	add    %ah,(%eax,%eax,1)
    3732:	00 00                	add    %al,(%eax)
    3734:	04 13                	add    $0x13,%al
    3736:	28 00                	sub    %al,(%eax)
    3738:	4b                   	dec    %ebx
    3739:	13 00                	adc    (%eax),%eax
    373b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3741:	00 00                	add    %al,(%eax)
    3743:	00 00                	add    %al,(%eax)
    3745:	00 00                	add    %al,(%eax)
    3747:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
	...
    3753:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    3757:	00 01                	add    %al,(%ecx)
    3759:	00 00                	add    %al,(%eax)
    375b:	00 00                	add    %al,(%eax)
    375d:	00 00                	add    %al,(%eax)
    375f:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    3763:	00 03                	add    %al,(%ebx)
    3765:	00 00                	add    %al,(%eax)
    3767:	00 00                	add    %al,(%eax)
    3769:	00 00                	add    %al,(%eax)
    376b:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    376f:	00 05 00 00 00 00    	add    %al,0x0
    3775:	00 00                	add    %al,(%eax)
    3777:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    377b:	00 07                	add    %al,(%edi)
    377d:	00 00                	add    %al,(%eax)
    377f:	00 00                	add    %al,(%eax)
    3781:	00 00                	add    %al,(%eax)
    3783:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    3787:	00 0b                	add    %cl,(%ebx)
    3789:	00 00                	add    %al,(%eax)
    378b:	00 00                	add    %al,(%eax)
    378d:	00 00                	add    %al,(%eax)
    378f:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    3793:	00 0d 00 00 00 00    	add    %cl,0x0
    3799:	00 00                	add    %al,(%eax)
    379b:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
    379f:	00 11                	add    %dl,(%ecx)
    37a1:	00 00                	add    %al,(%eax)
    37a3:	00 00                	add    %al,(%eax)
    37a5:	00 00                	add    %al,(%eax)
    37a7:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    37ab:	00 15 00 00 00 00    	add    %dl,0x0
    37b1:	00 00                	add    %al,(%eax)
    37b3:	00 44 00 57          	add    %al,0x57(%eax,%eax,1)
    37b7:	00 18                	add    %bl,(%eax)
    37b9:	00 00                	add    %al,(%eax)
    37bb:	00 fb                	add    %bh,%bl
    37bd:	12 00                	adc    (%eax),%al
    37bf:	00 40 00             	add    %al,0x0(%eax)
    37c2:	00 00                	add    %al,(%eax)
    37c4:	02 00                	add    (%eax),%al
    37c6:	00 00                	add    %al,(%eax)
    37c8:	57                   	push   %edi
    37c9:	13 00                	adc    (%eax),%eax
    37cb:	00 40 00             	add    %al,0x0(%eax)
    37ce:	00 00                	add    %al,(%eax)
    37d0:	00 00                	add    %al,(%eax)
    37d2:	00 00                	add    %al,(%eax)
    37d4:	2b 13                	sub    (%ebx),%edx
    37d6:	00 00                	add    %al,(%eax)
    37d8:	40                   	inc    %eax
    37d9:	00 00                	add    %al,(%eax)
    37db:	00 01                	add    %al,(%ecx)
    37dd:	00 00                	add    %al,(%eax)
    37df:	00 00                	add    %al,(%eax)
    37e1:	00 00                	add    %al,(%eax)
    37e3:	00 c0                	add    %al,%al
	...
    37ed:	00 00                	add    %al,(%eax)
    37ef:	00 e0                	add    %ah,%al
    37f1:	00 00                	add    %al,(%eax)
    37f3:	00 1b                	add    %bl,(%ebx)
    37f5:	00 00                	add    %al,(%eax)
    37f7:	00 66 13             	add    %ah,0x13(%esi)
    37fa:	00 00                	add    %al,(%eax)
    37fc:	24 00                	and    $0x0,%al
    37fe:	00 00                	add    %al,(%eax)
    3800:	1f                   	pop    %ds
    3801:	13 28                	adc    (%eax),%ebp
    3803:	00 4b 13             	add    %cl,0x13(%ebx)
    3806:	00 00                	add    %al,(%eax)
    3808:	a0 00 00 00 08       	mov    0x8000000,%al
    380d:	00 00                	add    %al,(%eax)
    380f:	00 7a 13             	add    %bh,0x13(%edx)
    3812:	00 00                	add    %al,(%eax)
    3814:	a0 00 00 00 0c       	mov    0xc000000,%al
    3819:	00 00                	add    %al,(%eax)
    381b:	00 00                	add    %al,(%eax)
    381d:	00 00                	add    %al,(%eax)
    381f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
	...
    382b:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    382f:	00 01                	add    %al,(%ecx)
    3831:	00 00                	add    %al,(%eax)
    3833:	00 00                	add    %al,(%eax)
    3835:	00 00                	add    %al,(%eax)
    3837:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    383b:	00 03                	add    %al,(%ebx)
    383d:	00 00                	add    %al,(%eax)
    383f:	00 00                	add    %al,(%eax)
    3841:	00 00                	add    %al,(%eax)
    3843:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    3847:	00 0b                	add    %cl,(%ebx)
    3849:	00 00                	add    %al,(%eax)
    384b:	00 00                	add    %al,(%eax)
    384d:	00 00                	add    %al,(%eax)
    384f:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    3853:	00 0d 00 00 00 00    	add    %cl,0x0
    3859:	00 00                	add    %al,(%eax)
    385b:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    385f:	00 11                	add    %dl,(%ecx)
    3861:	00 00                	add    %al,(%eax)
    3863:	00 00                	add    %al,(%eax)
    3865:	00 00                	add    %al,(%eax)
    3867:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    386b:	00 1d 00 00 00 00    	add    %bl,0x0
    3871:	00 00                	add    %al,(%eax)
    3873:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    3877:	00 20                	add    %ah,(%eax)
    3879:	00 00                	add    %al,(%eax)
    387b:	00 00                	add    %al,(%eax)
    387d:	00 00                	add    %al,(%eax)
    387f:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    3883:	00 23                	add    %ah,(%ebx)
    3885:	00 00                	add    %al,(%eax)
    3887:	00 00                	add    %al,(%eax)
    3889:	00 00                	add    %al,(%eax)
    388b:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    388f:	00 28                	add    %ch,(%eax)
    3891:	00 00                	add    %al,(%eax)
    3893:	00 00                	add    %al,(%eax)
    3895:	00 00                	add    %al,(%eax)
    3897:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    389b:	00 2e                	add    %ch,(%esi)
    389d:	00 00                	add    %al,(%eax)
    389f:	00 00                	add    %al,(%eax)
    38a1:	00 00                	add    %al,(%eax)
    38a3:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    38a7:	00 30                	add    %dh,(%eax)
    38a9:	00 00                	add    %al,(%eax)
    38ab:	00 00                	add    %al,(%eax)
    38ad:	00 00                	add    %al,(%eax)
    38af:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    38b3:	00 33                	add    %dh,(%ebx)
    38b5:	00 00                	add    %al,(%eax)
    38b7:	00 00                	add    %al,(%eax)
    38b9:	00 00                	add    %al,(%eax)
    38bb:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
    38bf:	00 35 00 00 00 00    	add    %dh,0x0
    38c5:	00 00                	add    %al,(%eax)
    38c7:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    38cb:	00 3a                	add    %bh,(%edx)
    38cd:	00 00                	add    %al,(%eax)
    38cf:	00 00                	add    %al,(%eax)
    38d1:	00 00                	add    %al,(%eax)
    38d3:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    38d7:	00 3e                	add    %bh,(%esi)
    38d9:	00 00                	add    %al,(%eax)
    38db:	00 00                	add    %al,(%eax)
    38dd:	00 00                	add    %al,(%eax)
    38df:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    38e3:	00 51 00             	add    %dl,0x0(%ecx)
    38e6:	00 00                	add    %al,(%eax)
    38e8:	00 00                	add    %al,(%eax)
    38ea:	00 00                	add    %al,(%eax)
    38ec:	44                   	inc    %esp
    38ed:	00 76 00             	add    %dh,0x0(%esi)
    38f0:	54                   	push   %esp
    38f1:	00 00                	add    %al,(%eax)
    38f3:	00 00                	add    %al,(%eax)
    38f5:	00 00                	add    %al,(%eax)
    38f7:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    38fb:	00 56 00             	add    %dl,0x0(%esi)
    38fe:	00 00                	add    %al,(%eax)
    3900:	86 13                	xchg   %dl,(%ebx)
    3902:	00 00                	add    %al,(%eax)
    3904:	40                   	inc    %eax
    3905:	00 00                	add    %al,(%eax)
    3907:	00 00                	add    %al,(%eax)
    3909:	00 00                	add    %al,(%eax)
    390b:	00 2b                	add    %ch,(%ebx)
    390d:	13 00                	adc    (%eax),%eax
    390f:	00 40 00             	add    %al,0x0(%eax)
    3912:	00 00                	add    %al,(%eax)
    3914:	01 00                	add    %eax,(%eax)
    3916:	00 00                	add    %al,(%eax)
    3918:	00 00                	add    %al,(%eax)
    391a:	00 00                	add    %al,(%eax)
    391c:	c0 00 00             	rolb   $0x0,(%eax)
	...
    3927:	00 e0                	add    %ah,%al
    3929:	00 00                	add    %al,(%eax)
    392b:	00 5b 00             	add    %bl,0x0(%ebx)
    392e:	00 00                	add    %al,(%eax)
    3930:	8f                   	(bad)  
    3931:	13 00                	adc    (%eax),%eax
    3933:	00 24 00             	add    %ah,(%eax,%eax,1)
    3936:	00 00                	add    %al,(%eax)
    3938:	7a 13                	jp     394d <bootmain-0x27c6b3>
    393a:	28 00                	sub    %al,(%eax)
    393c:	4b                   	dec    %ebx
    393d:	13 00                	adc    (%eax),%eax
    393f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3945:	00 00                	add    %al,(%eax)
    3947:	00 7a 13             	add    %bh,0x13(%edx)
    394a:	00 00                	add    %al,(%eax)
    394c:	a0 00 00 00 0c       	mov    0xc000000,%al
    3951:	00 00                	add    %al,(%eax)
    3953:	00 00                	add    %al,(%eax)
    3955:	00 00                	add    %al,(%eax)
    3957:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
    3963:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    3967:	00 03                	add    %al,(%ebx)
    3969:	00 00                	add    %al,(%eax)
    396b:	00 00                	add    %al,(%eax)
    396d:	00 00                	add    %al,(%eax)
    396f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    3973:	00 10                	add    %dl,(%eax)
    3975:	00 00                	add    %al,(%eax)
    3977:	00 00                	add    %al,(%eax)
    3979:	00 00                	add    %al,(%eax)
    397b:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
    397f:	00 13                	add    %dl,(%ebx)
    3981:	00 00                	add    %al,(%eax)
    3983:	00 00                	add    %al,(%eax)
    3985:	00 00                	add    %al,(%eax)
    3987:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    398b:	00 14 00             	add    %dl,(%eax,%eax,1)
    398e:	00 00                	add    %al,(%eax)
    3990:	2b 13                	sub    (%ebx),%edx
    3992:	00 00                	add    %al,(%eax)
    3994:	40                   	inc    %eax
    3995:	00 00                	add    %al,(%eax)
    3997:	00 00                	add    %al,(%eax)
    3999:	00 00                	add    %al,(%eax)
    399b:	00 a6 13 00 00 24    	add    %ah,0x24000013(%esi)
    39a1:	00 00                	add    %al,(%eax)
    39a3:	00 93 13 28 00 4b    	add    %dl,0x4b002813(%ebx)
    39a9:	13 00                	adc    (%eax),%eax
    39ab:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    39b1:	00 00                	add    %al,(%eax)
    39b3:	00 b9 13 00 00 a0    	add    %bh,-0x5fffffed(%ecx)
    39b9:	00 00                	add    %al,(%eax)
    39bb:	00 0c 00             	add    %cl,(%eax,%eax,1)
    39be:	00 00                	add    %al,(%eax)
    39c0:	7a 13                	jp     39d5 <bootmain-0x27c62b>
    39c2:	00 00                	add    %al,(%eax)
    39c4:	a0 00 00 00 10       	mov    0x10000000,%al
    39c9:	00 00                	add    %al,(%eax)
    39cb:	00 00                	add    %al,(%eax)
    39cd:	00 00                	add    %al,(%eax)
    39cf:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
	...
    39db:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    39df:	00 01                	add    %al,(%ecx)
    39e1:	00 00                	add    %al,(%eax)
    39e3:	00 00                	add    %al,(%eax)
    39e5:	00 00                	add    %al,(%eax)
    39e7:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    39eb:	00 03                	add    %al,(%ebx)
    39ed:	00 00                	add    %al,(%eax)
    39ef:	00 00                	add    %al,(%eax)
    39f1:	00 00                	add    %al,(%eax)
    39f3:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    39f7:	00 0b                	add    %cl,(%ebx)
    39f9:	00 00                	add    %al,(%eax)
    39fb:	00 00                	add    %al,(%eax)
    39fd:	00 00                	add    %al,(%eax)
    39ff:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3a03:	00 11                	add    %dl,(%ecx)
    3a05:	00 00                	add    %al,(%eax)
    3a07:	00 00                	add    %al,(%eax)
    3a09:	00 00                	add    %al,(%eax)
    3a0b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3a0f:	00 19                	add    %bl,(%ecx)
    3a11:	00 00                	add    %al,(%eax)
    3a13:	00 00                	add    %al,(%eax)
    3a15:	00 00                	add    %al,(%eax)
    3a17:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
    3a1b:	00 1e                	add    %bl,(%esi)
    3a1d:	00 00                	add    %al,(%eax)
    3a1f:	00 00                	add    %al,(%eax)
    3a21:	00 00                	add    %al,(%eax)
    3a23:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
    3a27:	00 27                	add    %ah,(%edi)
    3a29:	00 00                	add    %al,(%eax)
    3a2b:	00 00                	add    %al,(%eax)
    3a2d:	00 00                	add    %al,(%eax)
    3a2f:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3a33:	00 2d 00 00 00 00    	add    %ch,0x0
    3a39:	00 00                	add    %al,(%eax)
    3a3b:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
    3a3f:	00 34 00             	add    %dh,(%eax,%eax,1)
    3a42:	00 00                	add    %al,(%eax)
    3a44:	00 00                	add    %al,(%eax)
    3a46:	00 00                	add    %al,(%eax)
    3a48:	44                   	inc    %esp
    3a49:	00 91 00 41 00 00    	add    %dl,0x4100(%ecx)
    3a4f:	00 00                	add    %al,(%eax)
    3a51:	00 00                	add    %al,(%eax)
    3a53:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    3a57:	00 43 00             	add    %al,0x0(%ebx)
    3a5a:	00 00                	add    %al,(%eax)
    3a5c:	00 00                	add    %al,(%eax)
    3a5e:	00 00                	add    %al,(%eax)
    3a60:	44                   	inc    %esp
    3a61:	00 91 00 46 00 00    	add    %dl,0x4600(%ecx)
    3a67:	00 00                	add    %al,(%eax)
    3a69:	00 00                	add    %al,(%eax)
    3a6b:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    3a6f:	00 49 00             	add    %cl,0x0(%ecx)
    3a72:	00 00                	add    %al,(%eax)
    3a74:	00 00                	add    %al,(%eax)
    3a76:	00 00                	add    %al,(%eax)
    3a78:	44                   	inc    %esp
    3a79:	00 94 00 4e 00 00 00 	add    %dl,0x4e(%eax,%eax,1)
    3a80:	00 00                	add    %al,(%eax)
    3a82:	00 00                	add    %al,(%eax)
    3a84:	44                   	inc    %esp
    3a85:	00 96 00 56 00 00    	add    %dl,0x5600(%esi)
    3a8b:	00 00                	add    %al,(%eax)
    3a8d:	00 00                	add    %al,(%eax)
    3a8f:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    3a93:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    3a97:	00 00                	add    %al,(%eax)
    3a99:	00 00                	add    %al,(%eax)
    3a9b:	00 44 00 99          	add    %al,-0x67(%eax,%eax,1)
    3a9f:	00 62 00             	add    %ah,0x0(%edx)
    3aa2:	00 00                	add    %al,(%eax)
    3aa4:	00 00                	add    %al,(%eax)
    3aa6:	00 00                	add    %al,(%eax)
    3aa8:	44                   	inc    %esp
    3aa9:	00 9b 00 66 00 00    	add    %bl,0x6600(%ebx)
    3aaf:	00 00                	add    %al,(%eax)
    3ab1:	00 00                	add    %al,(%eax)
    3ab3:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
    3ab7:	00 79 00             	add    %bh,0x0(%ecx)
    3aba:	00 00                	add    %al,(%eax)
    3abc:	00 00                	add    %al,(%eax)
    3abe:	00 00                	add    %al,(%eax)
    3ac0:	44                   	inc    %esp
    3ac1:	00 a8 00 7e 00 00    	add    %ch,0x7e00(%eax)
    3ac7:	00 00                	add    %al,(%eax)
    3ac9:	00 00                	add    %al,(%eax)
    3acb:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
    3acf:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    3ad5:	00 00                	add    %al,(%eax)
    3ad7:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
    3adb:	00 8e 00 00 00 00    	add    %cl,0x0(%esi)
    3ae1:	00 00                	add    %al,(%eax)
    3ae3:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
    3ae7:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
    3aed:	00 00                	add    %al,(%eax)
    3aef:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    3af3:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    3afa:	00 00                	add    %al,(%eax)
    3afc:	44                   	inc    %esp
    3afd:	00 b1 00 98 00 00    	add    %dh,0x9800(%ecx)
    3b03:	00 00                	add    %al,(%eax)
    3b05:	00 00                	add    %al,(%eax)
    3b07:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    3b0b:	00 a1 00 00 00 00    	add    %ah,0x0(%ecx)
    3b11:	00 00                	add    %al,(%eax)
    3b13:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
    3b17:	00 a6 00 00 00 00    	add    %ah,0x0(%esi)
    3b1d:	00 00                	add    %al,(%eax)
    3b1f:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
    3b23:	00 be 00 00 00 00    	add    %bh,0x0(%esi)
    3b29:	00 00                	add    %al,(%eax)
    3b2b:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    3b2f:	00 c2                	add    %al,%dl
    3b31:	00 00                	add    %al,(%eax)
    3b33:	00 00                	add    %al,(%eax)
    3b35:	00 00                	add    %al,(%eax)
    3b37:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
    3b3b:	00 c5                	add    %al,%ch
    3b3d:	00 00                	add    %al,(%eax)
    3b3f:	00 00                	add    %al,(%eax)
    3b41:	00 00                	add    %al,(%eax)
    3b43:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    3b47:	00 c7                	add    %al,%bh
    3b49:	00 00                	add    %al,(%eax)
    3b4b:	00 00                	add    %al,(%eax)
    3b4d:	00 00                	add    %al,(%eax)
    3b4f:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    3b53:	00 c9                	add    %cl,%cl
    3b55:	00 00                	add    %al,(%eax)
    3b57:	00 00                	add    %al,(%eax)
    3b59:	00 00                	add    %al,(%eax)
    3b5b:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
    3b5f:	00 cf                	add    %cl,%bh
    3b61:	00 00                	add    %al,(%eax)
    3b63:	00 00                	add    %al,(%eax)
    3b65:	00 00                	add    %al,(%eax)
    3b67:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
    3b6b:	00 d2                	add    %dl,%dl
    3b6d:	00 00                	add    %al,(%eax)
    3b6f:	00 00                	add    %al,(%eax)
    3b71:	00 00                	add    %al,(%eax)
    3b73:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
    3b77:	00 d5                	add    %dl,%ch
    3b79:	00 00                	add    %al,(%eax)
    3b7b:	00 00                	add    %al,(%eax)
    3b7d:	00 00                	add    %al,(%eax)
    3b7f:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
    3b83:	00 da                	add    %bl,%dl
    3b85:	00 00                	add    %al,(%eax)
    3b87:	00 00                	add    %al,(%eax)
    3b89:	00 00                	add    %al,(%eax)
    3b8b:	00 44 00 c5          	add    %al,-0x3b(%eax,%eax,1)
    3b8f:	00 dd                	add    %bl,%ch
    3b91:	00 00                	add    %al,(%eax)
    3b93:	00 00                	add    %al,(%eax)
    3b95:	00 00                	add    %al,(%eax)
    3b97:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
    3b9b:	00 e0                	add    %ah,%al
    3b9d:	00 00                	add    %al,(%eax)
    3b9f:	00 00                	add    %al,(%eax)
    3ba1:	00 00                	add    %al,(%eax)
    3ba3:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
    3ba7:	00 e3                	add    %ah,%bl
    3ba9:	00 00                	add    %al,(%eax)
    3bab:	00 2b                	add    %ch,(%ebx)
    3bad:	13 00                	adc    (%eax),%eax
    3baf:	00 40 00             	add    %al,0x0(%eax)
    3bb2:	00 00                	add    %al,(%eax)
    3bb4:	00 00                	add    %al,(%eax)
    3bb6:	00 00                	add    %al,(%eax)
    3bb8:	c5 13                	lds    (%ebx),%edx
    3bba:	00 00                	add    %al,(%eax)
    3bbc:	40                   	inc    %eax
    3bbd:	00 00                	add    %al,(%eax)
    3bbf:	00 07                	add    %al,(%edi)
    3bc1:	00 00                	add    %al,(%eax)
    3bc3:	00 d1                	add    %dl,%cl
    3bc5:	13 00                	adc    (%eax),%eax
    3bc7:	00 24 00             	add    %ah,(%eax,%eax,1)
    3bca:	00 00                	add    %al,(%eax)
    3bcc:	7d 14                	jge    3be2 <bootmain-0x27c41e>
    3bce:	28 00                	sub    %al,(%eax)
    3bd0:	4b                   	dec    %ebx
    3bd1:	13 00                	adc    (%eax),%eax
    3bd3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3bd9:	00 00                	add    %al,(%eax)
    3bdb:	00 b9 13 00 00 a0    	add    %bh,-0x5fffffed(%ecx)
    3be1:	00 00                	add    %al,(%eax)
    3be3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    3be6:	00 00                	add    %al,(%eax)
    3be8:	7a 13                	jp     3bfd <bootmain-0x27c403>
    3bea:	00 00                	add    %al,(%eax)
    3bec:	a0 00 00 00 10       	mov    0x10000000,%al
    3bf1:	00 00                	add    %al,(%eax)
    3bf3:	00 00                	add    %al,(%eax)
    3bf5:	00 00                	add    %al,(%eax)
    3bf7:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
	...
    3c03:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
    3c07:	00 03                	add    %al,(%ebx)
    3c09:	00 00                	add    %al,(%eax)
    3c0b:	00 00                	add    %al,(%eax)
    3c0d:	00 00                	add    %al,(%eax)
    3c0f:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    3c13:	00 10                	add    %dl,(%eax)
    3c15:	00 00                	add    %al,(%eax)
    3c17:	00 00                	add    %al,(%eax)
    3c19:	00 00                	add    %al,(%eax)
    3c1b:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
    3c1f:	00 13                	add    %dl,(%ebx)
    3c21:	00 00                	add    %al,(%eax)
    3c23:	00 00                	add    %al,(%eax)
    3c25:	00 00                	add    %al,(%eax)
    3c27:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    3c2b:	00 14 00             	add    %dl,(%eax,%eax,1)
    3c2e:	00 00                	add    %al,(%eax)
    3c30:	2b 13                	sub    (%ebx),%edx
    3c32:	00 00                	add    %al,(%eax)
    3c34:	40                   	inc    %eax
    3c35:	00 00                	add    %al,(%eax)
    3c37:	00 00                	add    %al,(%eax)
    3c39:	00 00                	add    %al,(%eax)
    3c3b:	00 e7                	add    %ah,%bh
    3c3d:	13 00                	adc    (%eax),%eax
    3c3f:	00 40 00             	add    %al,0x0(%eax)
    3c42:	00 00                	add    %al,(%eax)
    3c44:	00 00                	add    %al,(%eax)
    3c46:	00 00                	add    %al,(%eax)
    3c48:	f3 13 00             	repz adc (%eax),%eax
    3c4b:	00 24 00             	add    %ah,(%eax,%eax,1)
    3c4e:	00 00                	add    %al,(%eax)
    3c50:	96                   	xchg   %eax,%esi
    3c51:	14 28                	adc    $0x28,%al
    3c53:	00 0f                	add    %cl,(%edi)
    3c55:	14 00                	adc    $0x0,%al
    3c57:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3c5d:	00 00                	add    %al,(%eax)
    3c5f:	00 1e                	add    %bl,(%esi)
    3c61:	14 00                	adc    $0x0,%al
    3c63:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3c69:	00 00                	add    %al,(%eax)
    3c6b:	00 a5 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ebp)
    3c71:	00 00                	add    %al,(%eax)
    3c73:	00 10                	add    %dl,(%eax)
    3c75:	00 00                	add    %al,(%eax)
    3c77:	00 7d 0d             	add    %bh,0xd(%ebp)
    3c7a:	00 00                	add    %al,(%eax)
    3c7c:	a0 00 00 00 14       	mov    0x14000000,%al
    3c81:	00 00                	add    %al,(%eax)
    3c83:	00 00                	add    %al,(%eax)
    3c85:	00 00                	add    %al,(%eax)
    3c87:	00 44 00 cb          	add    %al,-0x35(%eax,%eax,1)
	...
    3c93:	00 44 00 cb          	add    %al,-0x35(%eax,%eax,1)
    3c97:	00 09                	add    %cl,(%ecx)
    3c99:	00 00                	add    %al,(%eax)
    3c9b:	00 00                	add    %al,(%eax)
    3c9d:	00 00                	add    %al,(%eax)
    3c9f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    3ca3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    3ca6:	00 00                	add    %al,(%eax)
    3ca8:	00 00                	add    %al,(%eax)
    3caa:	00 00                	add    %al,(%eax)
    3cac:	44                   	inc    %esp
    3cad:	00 cf                	add    %cl,%bh
    3caf:	00 19                	add    %bl,(%ecx)
    3cb1:	00 00                	add    %al,(%eax)
    3cb3:	00 00                	add    %al,(%eax)
    3cb5:	00 00                	add    %al,(%eax)
    3cb7:	00 44 00 d1          	add    %al,-0x2f(%eax,%eax,1)
    3cbb:	00 1f                	add    %bl,(%edi)
    3cbd:	00 00                	add    %al,(%eax)
    3cbf:	00 00                	add    %al,(%eax)
    3cc1:	00 00                	add    %al,(%eax)
    3cc3:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    3cc7:	00 2c 00             	add    %ch,(%eax,%eax,1)
    3cca:	00 00                	add    %al,(%eax)
    3ccc:	00 00                	add    %al,(%eax)
    3cce:	00 00                	add    %al,(%eax)
    3cd0:	44                   	inc    %esp
    3cd1:	00 d1                	add    %dl,%cl
    3cd3:	00 2e                	add    %ch,(%esi)
    3cd5:	00 00                	add    %al,(%eax)
    3cd7:	00 00                	add    %al,(%eax)
    3cd9:	00 00                	add    %al,(%eax)
    3cdb:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    3cdf:	00 31                	add    %dh,(%ecx)
    3ce1:	00 00                	add    %al,(%eax)
    3ce3:	00 00                	add    %al,(%eax)
    3ce5:	00 00                	add    %al,(%eax)
    3ce7:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    3ceb:	00 35 00 00 00 00    	add    %dh,0x0
    3cf1:	00 00                	add    %al,(%eax)
    3cf3:	00 44 00 d6          	add    %al,-0x2a(%eax,%eax,1)
    3cf7:	00 41 00             	add    %al,0x0(%ecx)
    3cfa:	00 00                	add    %al,(%eax)
    3cfc:	00 00                	add    %al,(%eax)
    3cfe:	00 00                	add    %al,(%eax)
    3d00:	44                   	inc    %esp
    3d01:	00 d8                	add    %bl,%al
    3d03:	00 46 00             	add    %al,0x0(%esi)
    3d06:	00 00                	add    %al,(%eax)
    3d08:	00 00                	add    %al,(%eax)
    3d0a:	00 00                	add    %al,(%eax)
    3d0c:	44                   	inc    %esp
    3d0d:	00 d9                	add    %bl,%cl
    3d0f:	00 4f 00             	add    %cl,0x0(%edi)
    3d12:	00 00                	add    %al,(%eax)
    3d14:	00 00                	add    %al,(%eax)
    3d16:	00 00                	add    %al,(%eax)
    3d18:	44                   	inc    %esp
    3d19:	00 db                	add    %bl,%bl
    3d1b:	00 52 00             	add    %dl,0x0(%edx)
    3d1e:	00 00                	add    %al,(%eax)
    3d20:	00 00                	add    %al,(%eax)
    3d22:	00 00                	add    %al,(%eax)
    3d24:	44                   	inc    %esp
    3d25:	00 d8                	add    %bl,%al
    3d27:	00 59 00             	add    %bl,0x0(%ecx)
    3d2a:	00 00                	add    %al,(%eax)
    3d2c:	00 00                	add    %al,(%eax)
    3d2e:	00 00                	add    %al,(%eax)
    3d30:	44                   	inc    %esp
    3d31:	00 da                	add    %bl,%dl
    3d33:	00 5b 00             	add    %bl,0x0(%ebx)
    3d36:	00 00                	add    %al,(%eax)
    3d38:	00 00                	add    %al,(%eax)
    3d3a:	00 00                	add    %al,(%eax)
    3d3c:	44                   	inc    %esp
    3d3d:	00 de                	add    %bl,%dh
    3d3f:	00 63 00             	add    %ah,0x0(%ebx)
    3d42:	00 00                	add    %al,(%eax)
    3d44:	00 00                	add    %al,(%eax)
    3d46:	00 00                	add    %al,(%eax)
    3d48:	44                   	inc    %esp
    3d49:	00 df                	add    %bl,%bh
    3d4b:	00 6d 00             	add    %ch,0x0(%ebp)
    3d4e:	00 00                	add    %al,(%eax)
    3d50:	00 00                	add    %al,(%eax)
    3d52:	00 00                	add    %al,(%eax)
    3d54:	44                   	inc    %esp
    3d55:	00 dc                	add    %bl,%ah
    3d57:	00 70 00             	add    %dh,0x0(%eax)
    3d5a:	00 00                	add    %al,(%eax)
    3d5c:	00 00                	add    %al,(%eax)
    3d5e:	00 00                	add    %al,(%eax)
    3d60:	44                   	inc    %esp
    3d61:	00 e2                	add    %ah,%dl
    3d63:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
    3d67:	00 2a                	add    %ch,(%edx)
    3d69:	14 00                	adc    $0x0,%al
    3d6b:	00 40 00             	add    %al,0x0(%eax)
    3d6e:	00 00                	add    %al,(%eax)
    3d70:	06                   	push   %es
    3d71:	00 00                	add    %al,(%eax)
    3d73:	00 36                	add    %dh,(%esi)
    3d75:	14 00                	adc    $0x0,%al
    3d77:	00 40 00             	add    %al,0x0(%eax)
    3d7a:	00 00                	add    %al,(%eax)
    3d7c:	03 00                	add    (%eax),%eax
    3d7e:	00 00                	add    %al,(%eax)
    3d80:	45                   	inc    %ebp
    3d81:	14 00                	adc    $0x0,%al
    3d83:	00 40 00             	add    %al,0x0(%eax)
    3d86:	00 00                	add    %al,(%eax)
    3d88:	00 00                	add    %al,(%eax)
    3d8a:	00 00                	add    %al,(%eax)
    3d8c:	c7                   	(bad)  
    3d8d:	0d 00 00 40 00       	or     $0x400000,%eax
    3d92:	00 00                	add    %al,(%eax)
    3d94:	07                   	pop    %es
    3d95:	00 00                	add    %al,(%eax)
    3d97:	00 00                	add    %al,(%eax)
    3d99:	00 00                	add    %al,(%eax)
    3d9b:	00 c0                	add    %al,%al
	...
    3da5:	00 00                	add    %al,(%eax)
    3da7:	00 e0                	add    %ah,%al
    3da9:	00 00                	add    %al,(%eax)
    3dab:	00 84 00 00 00 51 14 	add    %al,0x14510000(%eax,%eax,1)
    3db2:	00 00                	add    %al,(%eax)
    3db4:	24 00                	and    $0x0,%al
    3db6:	00 00                	add    %al,(%eax)
    3db8:	1a 15 28 00 65 14    	sbb    0x14650028,%dl
    3dbe:	00 00                	add    %al,(%eax)
    3dc0:	a0 00 00 00 08       	mov    0x8000000,%al
    3dc5:	00 00                	add    %al,(%eax)
    3dc7:	00 00                	add    %al,(%eax)
    3dc9:	00 00                	add    %al,(%eax)
    3dcb:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
	...
    3dd7:	00 44 00 e8          	add    %al,-0x18(%eax,%eax,1)
    3ddb:	00 01                	add    %al,(%ecx)
    3ddd:	00 00                	add    %al,(%eax)
    3ddf:	00 00                	add    %al,(%eax)
    3de1:	00 00                	add    %al,(%eax)
    3de3:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
    3de7:	00 03                	add    %al,(%ebx)
    3de9:	00 00                	add    %al,(%eax)
    3deb:	00 00                	add    %al,(%eax)
    3ded:	00 00                	add    %al,(%eax)
    3def:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
    3df3:	00 05 00 00 00 00    	add    %al,0x0
    3df9:	00 00                	add    %al,(%eax)
    3dfb:	00 44 00 ea          	add    %al,-0x16(%eax,%eax,1)
    3dff:	00 0b                	add    %cl,(%ebx)
    3e01:	00 00                	add    %al,(%eax)
    3e03:	00 00                	add    %al,(%eax)
    3e05:	00 00                	add    %al,(%eax)
    3e07:	00 44 00 ec          	add    %al,-0x14(%eax,%eax,1)
    3e0b:	00 12                	add    %dl,(%edx)
    3e0d:	00 00                	add    %al,(%eax)
    3e0f:	00 00                	add    %al,(%eax)
    3e11:	00 00                	add    %al,(%eax)
    3e13:	00 44 00 ed          	add    %al,-0x13(%eax,%eax,1)
    3e17:	00 16                	add    %dl,(%esi)
    3e19:	00 00                	add    %al,(%eax)
    3e1b:	00 00                	add    %al,(%eax)
    3e1d:	00 00                	add    %al,(%eax)
    3e1f:	00 44 00 ee          	add    %al,-0x12(%eax,%eax,1)
    3e23:	00 1d 00 00 00 00    	add    %bl,0x0
    3e29:	00 00                	add    %al,(%eax)
    3e2b:	00 44 00 ef          	add    %al,-0x11(%eax,%eax,1)
    3e2f:	00 24 00             	add    %ah,(%eax,%eax,1)
    3e32:	00 00                	add    %al,(%eax)
    3e34:	00 00                	add    %al,(%eax)
    3e36:	00 00                	add    %al,(%eax)
    3e38:	44                   	inc    %esp
    3e39:	00 e8                	add    %ch,%al
    3e3b:	00 26                	add    %ah,(%esi)
    3e3d:	00 00                	add    %al,(%eax)
    3e3f:	00 00                	add    %al,(%eax)
    3e41:	00 00                	add    %al,(%eax)
    3e43:	00 44 00 f2          	add    %al,-0xe(%eax,%eax,1)
    3e47:	00 2e                	add    %ch,(%esi)
    3e49:	00 00                	add    %al,(%eax)
    3e4b:	00 00                	add    %al,(%eax)
    3e4d:	00 00                	add    %al,(%eax)
    3e4f:	00 44 00 f3          	add    %al,-0xd(%eax,%eax,1)
    3e53:	00 31                	add    %dh,(%ecx)
    3e55:	00 00                	add    %al,(%eax)
    3e57:	00 71 14             	add    %dh,0x14(%ecx)
    3e5a:	00 00                	add    %al,(%eax)
    3e5c:	40                   	inc    %eax
    3e5d:	00 00                	add    %al,(%eax)
    3e5f:	00 00                	add    %al,(%eax)
    3e61:	00 00                	add    %al,(%eax)
    3e63:	00 d4                	add    %dl,%ah
    3e65:	0a 00                	or     (%eax),%al
    3e67:	00 40 00             	add    %al,0x0(%eax)
    3e6a:	00 00                	add    %al,(%eax)
    3e6c:	00 00                	add    %al,(%eax)
    3e6e:	00 00                	add    %al,(%eax)
    3e70:	2a 14 00             	sub    (%eax,%eax,1),%dl
    3e73:	00 40 00             	add    %al,0x0(%eax)
    3e76:	00 00                	add    %al,(%eax)
    3e78:	02 00                	add    (%eax),%al
    3e7a:	00 00                	add    %al,(%eax)
    3e7c:	00 00                	add    %al,(%eax)
    3e7e:	00 00                	add    %al,(%eax)
    3e80:	c0 00 00             	rolb   $0x0,(%eax)
	...
    3e8b:	00 e0                	add    %ah,%al
    3e8d:	00 00                	add    %al,(%eax)
    3e8f:	00 33                	add    %dh,(%ebx)
    3e91:	00 00                	add    %al,(%eax)
    3e93:	00 7d 14             	add    %bh,0x14(%ebp)
    3e96:	00 00                	add    %al,(%eax)
    3e98:	24 00                	and    $0x0,%al
    3e9a:	00 00                	add    %al,(%eax)
    3e9c:	4d                   	dec    %ebp
    3e9d:	15 28 00 92 14       	adc    $0x14920028,%eax
    3ea2:	00 00                	add    %al,(%eax)
    3ea4:	a0 00 00 00 08       	mov    0x8000000,%al
    3ea9:	00 00                	add    %al,(%eax)
    3eab:	00 9e 14 00 00 a0    	add    %bl,-0x5fffffec(%esi)
    3eb1:	00 00                	add    %al,(%eax)
    3eb3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    3eb6:	00 00                	add    %al,(%eax)
    3eb8:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    3eb9:	0b 00                	or     (%eax),%eax
    3ebb:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    3ec1:	00 00                	add    %al,(%eax)
    3ec3:	00 7d 0d             	add    %bh,0xd(%ebp)
    3ec6:	00 00                	add    %al,(%eax)
    3ec8:	a0 00 00 00 14       	mov    0x14000000,%al
    3ecd:	00 00                	add    %al,(%eax)
    3ecf:	00 a9 14 00 00 a0    	add    %ch,-0x5fffffec(%ecx)
    3ed5:	00 00                	add    %al,(%eax)
    3ed7:	00 18                	add    %bl,(%eax)
    3ed9:	00 00                	add    %al,(%eax)
    3edb:	00 00                	add    %al,(%eax)
    3edd:	00 00                	add    %al,(%eax)
    3edf:	00 44 00 f8          	add    %al,-0x8(%eax,%eax,1)
	...
    3eeb:	00 44 00 f8          	add    %al,-0x8(%eax,%eax,1)
    3eef:	00 03                	add    %al,(%ebx)
    3ef1:	00 00                	add    %al,(%eax)
    3ef3:	00 00                	add    %al,(%eax)
    3ef5:	00 00                	add    %al,(%eax)
    3ef7:	00 44 00 f9          	add    %al,-0x7(%eax,%eax,1)
    3efb:	00 06                	add    %al,(%esi)
    3efd:	00 00                	add    %al,(%eax)
    3eff:	00 00                	add    %al,(%eax)
    3f01:	00 00                	add    %al,(%eax)
    3f03:	00 44 00 fa          	add    %al,-0x6(%eax,%eax,1)
    3f07:	00 0b                	add    %cl,(%ebx)
    3f09:	00 00                	add    %al,(%eax)
    3f0b:	00 00                	add    %al,(%eax)
    3f0d:	00 00                	add    %al,(%eax)
    3f0f:	00 44 00 fb          	add    %al,-0x5(%eax,%eax,1)
    3f13:	00 11                	add    %dl,(%ecx)
    3f15:	00 00                	add    %al,(%eax)
    3f17:	00 00                	add    %al,(%eax)
    3f19:	00 00                	add    %al,(%eax)
    3f1b:	00 44 00 fc          	add    %al,-0x4(%eax,%eax,1)
    3f1f:	00 17                	add    %dl,(%edi)
    3f21:	00 00                	add    %al,(%eax)
    3f23:	00 00                	add    %al,(%eax)
    3f25:	00 00                	add    %al,(%eax)
    3f27:	00 44 00 fe          	add    %al,-0x2(%eax,%eax,1)
    3f2b:	00 1d 00 00 00 71    	add    %bl,0x71000000
    3f31:	14 00                	adc    $0x0,%al
    3f33:	00 40 00             	add    %al,0x0(%eax)
    3f36:	00 00                	add    %al,(%eax)
    3f38:	00 00                	add    %al,(%eax)
    3f3a:	00 00                	add    %al,(%eax)
    3f3c:	b8 14 00 00 40       	mov    $0x40000014,%eax
    3f41:	00 00                	add    %al,(%eax)
    3f43:	00 02                	add    %al,(%edx)
    3f45:	00 00                	add    %al,(%eax)
    3f47:	00 c7                	add    %al,%bh
    3f49:	0d 00 00 40 00       	or     $0x400000,%eax
    3f4e:	00 00                	add    %al,(%eax)
    3f50:	02 00                	add    (%eax),%al
    3f52:	00 00                	add    %al,(%eax)
    3f54:	c3                   	ret    
    3f55:	14 00                	adc    $0x0,%al
    3f57:	00 40 00             	add    %al,0x0(%eax)
    3f5a:	00 00                	add    %al,(%eax)
    3f5c:	02 00                	add    (%eax),%al
    3f5e:	00 00                	add    %al,(%eax)
    3f60:	d0 14 00             	rclb   (%eax,%eax,1)
    3f63:	00 40 00             	add    %al,0x0(%eax)
    3f66:	00 00                	add    %al,(%eax)
    3f68:	02 00                	add    (%eax),%al
    3f6a:	00 00                	add    %al,(%eax)
    3f6c:	df 14 00             	fist   (%eax,%eax,1)
    3f6f:	00 24 00             	add    %ah,(%eax,%eax,1)
    3f72:	00 00                	add    %al,(%eax)
    3f74:	6c                   	insb   (%dx),%es:(%edi)
    3f75:	15 28 00 65 14       	adc    $0x14650028,%eax
    3f7a:	00 00                	add    %al,(%eax)
    3f7c:	a0 00 00 00 08       	mov    0x8000000,%al
    3f81:	00 00                	add    %al,(%eax)
    3f83:	00 f8                	add    %bh,%al
    3f85:	14 00                	adc    $0x0,%al
    3f87:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3f8d:	00 00                	add    %al,(%eax)
    3f8f:	00 03                	add    %al,(%ebx)
    3f91:	15 00 00 a0 00       	adc    $0xa00000,%eax
    3f96:	00 00                	add    %al,(%eax)
    3f98:	10 00                	adc    %al,(%eax)
    3f9a:	00 00                	add    %al,(%eax)
    3f9c:	0e                   	push   %cs
    3f9d:	15 00 00 a0 00       	adc    $0xa00000,%eax
    3fa2:	00 00                	add    %al,(%eax)
    3fa4:	14 00                	adc    $0x0,%al
    3fa6:	00 00                	add    %al,(%eax)
    3fa8:	19 15 00 00 a0 00    	sbb    %edx,0xa00000
    3fae:	00 00                	add    %al,(%eax)
    3fb0:	18 00                	sbb    %al,(%eax)
    3fb2:	00 00                	add    %al,(%eax)
    3fb4:	24 15                	and    $0x15,%al
    3fb6:	00 00                	add    %al,(%eax)
    3fb8:	a0 00 00 00 1c       	mov    0x1c000000,%al
    3fbd:	00 00                	add    %al,(%eax)
    3fbf:	00 31                	add    %dh,(%ecx)
    3fc1:	15 00 00 a0 00       	adc    $0xa00000,%eax
    3fc6:	00 00                	add    %al,(%eax)
    3fc8:	20 00                	and    %al,(%eax)
    3fca:	00 00                	add    %al,(%eax)
    3fcc:	00 00                	add    %al,(%eax)
    3fce:	00 00                	add    %al,(%eax)
    3fd0:	44                   	inc    %esp
    3fd1:	00 70 01             	add    %dh,0x1(%eax)
	...
    3fdc:	44                   	inc    %esp
    3fdd:	00 70 01             	add    %dh,0x1(%eax)
    3fe0:	09 00                	or     %eax,(%eax)
    3fe2:	00 00                	add    %al,(%eax)
    3fe4:	00 00                	add    %al,(%eax)
    3fe6:	00 00                	add    %al,(%eax)
    3fe8:	44                   	inc    %esp
    3fe9:	00 72 01             	add    %dh,0x1(%edx)
    3fec:	12 00                	adc    (%eax),%al
    3fee:	00 00                	add    %al,(%eax)
    3ff0:	00 00                	add    %al,(%eax)
    3ff2:	00 00                	add    %al,(%eax)
    3ff4:	44                   	inc    %esp
    3ff5:	00 75 01             	add    %dh,0x1(%ebp)
    3ff8:	17                   	pop    %ss
    3ff9:	00 00                	add    %al,(%eax)
    3ffb:	00 00                	add    %al,(%eax)
    3ffd:	00 00                	add    %al,(%eax)
    3fff:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
    4003:	01 1d 00 00 00 00    	add    %ebx,0x0
    4009:	00 00                	add    %al,(%eax)
    400b:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
    400f:	01 28                	add    %ebp,(%eax)
    4011:	00 00                	add    %al,(%eax)
    4013:	00 00                	add    %al,(%eax)
    4015:	00 00                	add    %al,(%eax)
    4017:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    401b:	01 33                	add    %esi,(%ebx)
    401d:	00 00                	add    %al,(%eax)
    401f:	00 00                	add    %al,(%eax)
    4021:	00 00                	add    %al,(%eax)
    4023:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    4027:	01 39                	add    %edi,(%ecx)
    4029:	00 00                	add    %al,(%eax)
    402b:	00 00                	add    %al,(%eax)
    402d:	00 00                	add    %al,(%eax)
    402f:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    4033:	01 45 00             	add    %eax,0x0(%ebp)
    4036:	00 00                	add    %al,(%eax)
    4038:	00 00                	add    %al,(%eax)
    403a:	00 00                	add    %al,(%eax)
    403c:	44                   	inc    %esp
    403d:	00 86 01 48 00 00    	add    %al,0x4801(%esi)
    4043:	00 00                	add    %al,(%eax)
    4045:	00 00                	add    %al,(%eax)
    4047:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    404b:	01 4b 00             	add    %ecx,0x0(%ebx)
    404e:	00 00                	add    %al,(%eax)
    4050:	00 00                	add    %al,(%eax)
    4052:	00 00                	add    %al,(%eax)
    4054:	44                   	inc    %esp
    4055:	00 80 01 52 00 00    	add    %al,0x5201(%eax)
    405b:	00 00                	add    %al,(%eax)
    405d:	00 00                	add    %al,(%eax)
    405f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    4063:	01 54 00 00          	add    %edx,0x0(%eax,%eax,1)
    4067:	00 00                	add    %al,(%eax)
    4069:	00 00                	add    %al,(%eax)
    406b:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    406f:	01 56 00             	add    %edx,0x0(%esi)
    4072:	00 00                	add    %al,(%eax)
    4074:	00 00                	add    %al,(%eax)
    4076:	00 00                	add    %al,(%eax)
    4078:	44                   	inc    %esp
    4079:	00 83 01 59 00 00    	add    %al,0x5901(%ebx)
    407f:	00 00                	add    %al,(%eax)
    4081:	00 00                	add    %al,(%eax)
    4083:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    4087:	01 5c 00 00          	add    %ebx,0x0(%eax,%eax,1)
    408b:	00 00                	add    %al,(%eax)
    408d:	00 00                	add    %al,(%eax)
    408f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    4093:	01 65 00             	add    %esp,0x0(%ebp)
    4096:	00 00                	add    %al,(%eax)
    4098:	00 00                	add    %al,(%eax)
    409a:	00 00                	add    %al,(%eax)
    409c:	44                   	inc    %esp
    409d:	00 84 01 68 00 00 00 	add    %al,0x68(%ecx,%eax,1)
    40a4:	00 00                	add    %al,(%eax)
    40a6:	00 00                	add    %al,(%eax)
    40a8:	44                   	inc    %esp
    40a9:	00 86 01 6b 00 00    	add    %al,0x6b01(%esi)
    40af:	00 00                	add    %al,(%eax)
    40b1:	00 00                	add    %al,(%eax)
    40b3:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    40b7:	01 6d 00             	add    %ebp,0x0(%ebp)
    40ba:	00 00                	add    %al,(%eax)
    40bc:	00 00                	add    %al,(%eax)
    40be:	00 00                	add    %al,(%eax)
    40c0:	44                   	inc    %esp
    40c1:	00 87 01 70 00 00    	add    %al,0x7001(%edi)
    40c7:	00 00                	add    %al,(%eax)
    40c9:	00 00                	add    %al,(%eax)
    40cb:	00 44 00 8b          	add    %al,-0x75(%eax,%eax,1)
    40cf:	01 93 00 00 00 00    	add    %edx,0x0(%ebx)
    40d5:	00 00                	add    %al,(%eax)
    40d7:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
    40db:	01 9b 00 00 00 00    	add    %ebx,0x0(%ebx)
    40e1:	00 00                	add    %al,(%eax)
    40e3:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
    40e7:	01 a9 00 00 00 00    	add    %ebp,0x0(%ecx)
    40ed:	00 00                	add    %al,(%eax)
    40ef:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
    40f3:	01 ae 00 00 00 00    	add    %ebp,0x0(%esi)
    40f9:	00 00                	add    %al,(%eax)
    40fb:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
    40ff:	01 b6 00 00 00 00    	add    %esi,0x0(%esi)
    4105:	00 00                	add    %al,(%eax)
    4107:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
    410b:	01 bc 00 00 00 00 00 	add    %edi,0x0(%eax,%eax,1)
    4112:	00 00                	add    %al,(%eax)
    4114:	44                   	inc    %esp
    4115:	00 94 01 c4 00 00 00 	add    %dl,0xc4(%ecx,%eax,1)
    411c:	00 00                	add    %al,(%eax)
    411e:	00 00                	add    %al,(%eax)
    4120:	44                   	inc    %esp
    4121:	00 92 01 cb 00 00    	add    %dl,0xcb01(%edx)
    4127:	00 00                	add    %al,(%eax)
    4129:	00 00                	add    %al,(%eax)
    412b:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
    412f:	01 d1                	add    %edx,%ecx
    4131:	00 00                	add    %al,(%eax)
    4133:	00 00                	add    %al,(%eax)
    4135:	00 00                	add    %al,(%eax)
    4137:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    413b:	01 d4                	add    %edx,%esp
    413d:	00 00                	add    %al,(%eax)
    413f:	00 00                	add    %al,(%eax)
    4141:	00 00                	add    %al,(%eax)
    4143:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
    4147:	01 d6                	add    %edx,%esi
    4149:	00 00                	add    %al,(%eax)
    414b:	00 00                	add    %al,(%eax)
    414d:	00 00                	add    %al,(%eax)
    414f:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    4153:	01 d9                	add    %ebx,%ecx
    4155:	00 00                	add    %al,(%eax)
    4157:	00 00                	add    %al,(%eax)
    4159:	00 00                	add    %al,(%eax)
    415b:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
    415f:	01 dc                	add    %ebx,%esp
    4161:	00 00                	add    %al,(%eax)
    4163:	00 00                	add    %al,(%eax)
    4165:	00 00                	add    %al,(%eax)
    4167:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    416b:	01 e1                	add    %esp,%ecx
    416d:	00 00                	add    %al,(%eax)
    416f:	00 00                	add    %al,(%eax)
    4171:	00 00                	add    %al,(%eax)
    4173:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
    4177:	01 fb                	add    %edi,%ebx
    4179:	00 00                	add    %al,(%eax)
    417b:	00 00                	add    %al,(%eax)
    417d:	00 00                	add    %al,(%eax)
    417f:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
    4183:	01 00                	add    %eax,(%eax)
    4185:	01 00                	add    %eax,(%eax)
    4187:	00 00                	add    %al,(%eax)
    4189:	00 00                	add    %al,(%eax)
    418b:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    418f:	01 03                	add    %eax,(%ebx)
    4191:	01 00                	add    %eax,(%eax)
    4193:	00 00                	add    %al,(%eax)
    4195:	00 00                	add    %al,(%eax)
    4197:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
    419b:	01 0b                	add    %ecx,(%ebx)
    419d:	01 00                	add    %eax,(%eax)
    419f:	00 71 14             	add    %dh,0x14(%ecx)
    41a2:	00 00                	add    %al,(%eax)
    41a4:	40                   	inc    %eax
    41a5:	00 00                	add    %al,(%eax)
    41a7:	00 00                	add    %al,(%eax)
    41a9:	00 00                	add    %al,(%eax)
    41ab:	00 2a                	add    %ch,(%edx)
    41ad:	14 00                	adc    $0x0,%al
    41af:	00 40 00             	add    %al,0x0(%eax)
    41b2:	00 00                	add    %al,(%eax)
    41b4:	02 00                	add    (%eax),%al
    41b6:	00 00                	add    %al,(%eax)
    41b8:	41                   	inc    %ecx
    41b9:	15 00 00 40 00       	adc    $0x400000,%eax
    41be:	00 00                	add    %al,(%eax)
    41c0:	01 00                	add    %eax,(%eax)
    41c2:	00 00                	add    %al,(%eax)
    41c4:	4c                   	dec    %esp
    41c5:	15 00 00 40 00       	adc    $0x400000,%eax
    41ca:	00 00                	add    %al,(%eax)
    41cc:	03 00                	add    (%eax),%eax
    41ce:	00 00                	add    %al,(%eax)
    41d0:	00 00                	add    %al,(%eax)
    41d2:	00 00                	add    %al,(%eax)
    41d4:	c0 00 00             	rolb   $0x0,(%eax)
	...
    41df:	00 e0                	add    %ah,%al
    41e1:	00 00                	add    %al,(%eax)
    41e3:	00 13                	add    %dl,(%ebx)
    41e5:	01 00                	add    %eax,(%eax)
    41e7:	00 57 15             	add    %dl,0x15(%edi)
    41ea:	00 00                	add    %al,(%eax)
    41ec:	24 00                	and    $0x0,%al
    41ee:	00 00                	add    %al,(%eax)
    41f0:	7f 16                	jg     4208 <bootmain-0x27bdf8>
    41f2:	28 00                	sub    %al,(%eax)
    41f4:	92                   	xchg   %eax,%edx
    41f5:	14 00                	adc    $0x0,%al
    41f7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    41fd:	00 00                	add    %al,(%eax)
    41ff:	00 6d 15             	add    %ch,0x15(%ebp)
    4202:	00 00                	add    %al,(%eax)
    4204:	a0 00 00 00 0c       	mov    0xc000000,%al
    4209:	00 00                	add    %al,(%eax)
    420b:	00 78 15             	add    %bh,0x15(%eax)
    420e:	00 00                	add    %al,(%eax)
    4210:	a0 00 00 00 10       	mov    0x10000000,%al
    4215:	00 00                	add    %al,(%eax)
    4217:	00 83 15 00 00 a0    	add    %al,-0x5fffffeb(%ebx)
    421d:	00 00                	add    %al,(%eax)
    421f:	00 14 00             	add    %dl,(%eax,%eax,1)
    4222:	00 00                	add    %al,(%eax)
    4224:	8e 15 00 00 a0 00    	mov    0xa00000,%ss
    422a:	00 00                	add    %al,(%eax)
    422c:	18 00                	sbb    %al,(%eax)
    422e:	00 00                	add    %al,(%eax)
    4230:	00 00                	add    %al,(%eax)
    4232:	00 00                	add    %al,(%eax)
    4234:	44                   	inc    %esp
    4235:	00 50 01             	add    %dl,0x1(%eax)
	...
    4240:	44                   	inc    %esp
    4241:	00 52 01             	add    %dl,0x1(%edx)
    4244:	07                   	pop    %es
    4245:	00 00                	add    %al,(%eax)
    4247:	00 00                	add    %al,(%eax)
    4249:	00 00                	add    %al,(%eax)
    424b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    424f:	01 0a                	add    %ecx,(%edx)
    4251:	00 00                	add    %al,(%eax)
    4253:	00 00                	add    %al,(%eax)
    4255:	00 00                	add    %al,(%eax)
    4257:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    425b:	01 0d 00 00 00 00    	add    %ecx,0x0
    4261:	00 00                	add    %al,(%eax)
    4263:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
    4267:	01 11                	add    %edx,(%ecx)
    4269:	00 00                	add    %al,(%eax)
    426b:	00 00                	add    %al,(%eax)
    426d:	00 00                	add    %al,(%eax)
    426f:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
    4273:	01 17                	add    %edx,(%edi)
    4275:	00 00                	add    %al,(%eax)
    4277:	00 00                	add    %al,(%eax)
    4279:	00 00                	add    %al,(%eax)
    427b:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    427f:	01 36                	add    %esi,(%esi)
    4281:	00 00                	add    %al,(%eax)
    4283:	00 2a                	add    %ch,(%edx)
    4285:	14 00                	adc    $0x0,%al
    4287:	00 40 00             	add    %al,0x0(%eax)
    428a:	00 00                	add    %al,(%eax)
    428c:	03 00                	add    (%eax),%eax
    428e:	00 00                	add    %al,(%eax)
    4290:	71 14                	jno    42a6 <bootmain-0x27bd5a>
    4292:	00 00                	add    %al,(%eax)
    4294:	40                   	inc    %eax
	...
    429d:	00 00                	add    %al,(%eax)
    429f:	00 c0                	add    %al,%al
	...
    42a9:	00 00                	add    %al,(%eax)
    42ab:	00 e0                	add    %ah,%al
    42ad:	00 00                	add    %al,(%eax)
    42af:	00 3b                	add    %bh,(%ebx)
    42b1:	00 00                	add    %al,(%eax)
    42b3:	00 99 15 00 00 24    	add    %bl,0x24000015(%ecx)
    42b9:	00 00                	add    %al,(%eax)
    42bb:	00 ba 16 28 00 65    	add    %bh,0x65002816(%edx)
    42c1:	14 00                	adc    $0x0,%al
    42c3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    42c9:	00 00                	add    %al,(%eax)
    42cb:	00 f8                	add    %bh,%al
    42cd:	14 00                	adc    $0x0,%al
    42cf:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    42d5:	00 00                	add    %al,(%eax)
    42d7:	00 03                	add    %al,(%ebx)
    42d9:	15 00 00 a0 00       	adc    $0xa00000,%eax
    42de:	00 00                	add    %al,(%eax)
    42e0:	10 00                	adc    %al,(%eax)
    42e2:	00 00                	add    %al,(%eax)
    42e4:	0e                   	push   %cs
    42e5:	15 00 00 a0 00       	adc    $0xa00000,%eax
    42ea:	00 00                	add    %al,(%eax)
    42ec:	14 00                	adc    $0x0,%al
    42ee:	00 00                	add    %al,(%eax)
    42f0:	19 15 00 00 a0 00    	sbb    %edx,0xa00000
    42f6:	00 00                	add    %al,(%eax)
    42f8:	18 00                	sbb    %al,(%eax)
    42fa:	00 00                	add    %al,(%eax)
    42fc:	24 15                	and    $0x15,%al
    42fe:	00 00                	add    %al,(%eax)
    4300:	a0 00 00 00 1c       	mov    0x1c000000,%al
    4305:	00 00                	add    %al,(%eax)
    4307:	00 00                	add    %al,(%eax)
    4309:	00 00                	add    %al,(%eax)
    430b:	00 44 00 af          	add    %al,-0x51(%eax,%eax,1)
    430f:	01 00                	add    %eax,(%eax)
    4311:	00 00                	add    %al,(%eax)
    4313:	00 00                	add    %al,(%eax)
    4315:	00 00                	add    %al,(%eax)
    4317:	00 44 00 b2          	add    %al,-0x4e(%eax,%eax,1)
    431b:	01 09                	add    %ecx,(%ecx)
    431d:	00 00                	add    %al,(%eax)
    431f:	00 00                	add    %al,(%eax)
    4321:	00 00                	add    %al,(%eax)
    4323:	00 44 00 af          	add    %al,-0x51(%eax,%eax,1)
    4327:	01 0c 00             	add    %ecx,(%eax,%eax,1)
    432a:	00 00                	add    %al,(%eax)
    432c:	00 00                	add    %al,(%eax)
    432e:	00 00                	add    %al,(%eax)
    4330:	44                   	inc    %esp
    4331:	00 b2 01 12 00 00    	add    %dh,0x1201(%edx)
    4337:	00 00                	add    %al,(%eax)
    4339:	00 00                	add    %al,(%eax)
    433b:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    433f:	01 18                	add    %ebx,(%eax)
    4341:	00 00                	add    %al,(%eax)
    4343:	00 00                	add    %al,(%eax)
    4345:	00 00                	add    %al,(%eax)
    4347:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    434b:	01 26                	add    %esp,(%esi)
    434d:	00 00                	add    %al,(%eax)
    434f:	00 00                	add    %al,(%eax)
    4351:	00 00                	add    %al,(%eax)
    4353:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
    4357:	01 34 00             	add    %esi,(%eax,%eax,1)
    435a:	00 00                	add    %al,(%eax)
    435c:	00 00                	add    %al,(%eax)
    435e:	00 00                	add    %al,(%eax)
    4360:	44                   	inc    %esp
    4361:	00 bc 01 3d 00 00 00 	add    %bh,0x3d(%ecx,%eax,1)
    4368:	00 00                	add    %al,(%eax)
    436a:	00 00                	add    %al,(%eax)
    436c:	44                   	inc    %esp
    436d:	00 be 01 4c 00 00    	add    %bh,0x4c01(%esi)
    4373:	00 00                	add    %al,(%eax)
    4375:	00 00                	add    %al,(%eax)
    4377:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    437b:	01 52 00             	add    %edx,0x0(%edx)
    437e:	00 00                	add    %al,(%eax)
    4380:	00 00                	add    %al,(%eax)
    4382:	00 00                	add    %al,(%eax)
    4384:	44                   	inc    %esp
    4385:	00 be 01 55 00 00    	add    %bh,0x5501(%esi)
    438b:	00 00                	add    %al,(%eax)
    438d:	00 00                	add    %al,(%eax)
    438f:	00 44 00 bf          	add    %al,-0x41(%eax,%eax,1)
    4393:	01 5c 00 00          	add    %ebx,0x0(%eax,%eax,1)
    4397:	00 00                	add    %al,(%eax)
    4399:	00 00                	add    %al,(%eax)
    439b:	00 44 00 c1          	add    %al,-0x3f(%eax,%eax,1)
    439f:	01 5e 00             	add    %ebx,0x0(%esi)
    43a2:	00 00                	add    %al,(%eax)
    43a4:	00 00                	add    %al,(%eax)
    43a6:	00 00                	add    %al,(%eax)
    43a8:	44                   	inc    %esp
    43a9:	00 bf 01 60 00 00    	add    %bh,0x6001(%edi)
    43af:	00 00                	add    %al,(%eax)
    43b1:	00 00                	add    %al,(%eax)
    43b3:	00 44 00 c3          	add    %al,-0x3d(%eax,%eax,1)
    43b7:	01 63 00             	add    %esp,0x0(%ebx)
    43ba:	00 00                	add    %al,(%eax)
    43bc:	00 00                	add    %al,(%eax)
    43be:	00 00                	add    %al,(%eax)
    43c0:	44                   	inc    %esp
    43c1:	00 c4                	add    %al,%ah
    43c3:	01 66 00             	add    %esp,0x0(%esi)
    43c6:	00 00                	add    %al,(%eax)
    43c8:	00 00                	add    %al,(%eax)
    43ca:	00 00                	add    %al,(%eax)
    43cc:	44                   	inc    %esp
    43cd:	00 bf 01 69 00 00    	add    %bh,0x6901(%edi)
    43d3:	00 00                	add    %al,(%eax)
    43d5:	00 00                	add    %al,(%eax)
    43d7:	00 44 00 c1          	add    %al,-0x3f(%eax,%eax,1)
    43db:	01 72 00             	add    %esi,0x0(%edx)
    43de:	00 00                	add    %al,(%eax)
    43e0:	00 00                	add    %al,(%eax)
    43e2:	00 00                	add    %al,(%eax)
    43e4:	44                   	inc    %esp
    43e5:	00 c6                	add    %al,%dh
    43e7:	01 78 00             	add    %edi,0x0(%eax)
    43ea:	00 00                	add    %al,(%eax)
    43ec:	00 00                	add    %al,(%eax)
    43ee:	00 00                	add    %al,(%eax)
    43f0:	44                   	inc    %esp
    43f1:	00 bf 01 7a 00 00    	add    %bh,0x7a01(%edi)
    43f7:	00 00                	add    %al,(%eax)
    43f9:	00 00                	add    %al,(%eax)
    43fb:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
    43ff:	01 7d 00             	add    %edi,0x0(%ebp)
    4402:	00 00                	add    %al,(%eax)
    4404:	00 00                	add    %al,(%eax)
    4406:	00 00                	add    %al,(%eax)
    4408:	44                   	inc    %esp
    4409:	00 ca                	add    %cl,%dl
    440b:	01 96 00 00 00 00    	add    %edx,0x0(%esi)
    4411:	00 00                	add    %al,(%eax)
    4413:	00 44 00 cb          	add    %al,-0x35(%eax,%eax,1)
    4417:	01 a1 00 00 00 00    	add    %esp,0x0(%ecx)
    441d:	00 00                	add    %al,(%eax)
    441f:	00 44 00 cc          	add    %al,-0x34(%eax,%eax,1)
    4423:	01 af 00 00 00 00    	add    %ebp,0x0(%edi)
    4429:	00 00                	add    %al,(%eax)
    442b:	00 44 00 ce          	add    %al,-0x32(%eax,%eax,1)
    442f:	01 b4 00 00 00 00 00 	add    %esi,0x0(%eax,%eax,1)
    4436:	00 00                	add    %al,(%eax)
    4438:	44                   	inc    %esp
    4439:	00 cf                	add    %cl,%bh
    443b:	01 b7 00 00 00 00    	add    %esi,0x0(%edi)
    4441:	00 00                	add    %al,(%eax)
    4443:	00 44 00 ce          	add    %al,-0x32(%eax,%eax,1)
    4447:	01 ba 00 00 00 00    	add    %edi,0x0(%edx)
    444d:	00 00                	add    %al,(%eax)
    444f:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    4453:	01 bf 00 00 00 00    	add    %edi,0x0(%edi)
    4459:	00 00                	add    %al,(%eax)
    445b:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    445f:	01 c4                	add    %eax,%esp
    4461:	00 00                	add    %al,(%eax)
    4463:	00 00                	add    %al,(%eax)
    4465:	00 00                	add    %al,(%eax)
    4467:	00 44 00 d1          	add    %al,-0x2f(%eax,%eax,1)
    446b:	01 ca                	add    %ecx,%edx
    446d:	00 00                	add    %al,(%eax)
    446f:	00 00                	add    %al,(%eax)
    4471:	00 00                	add    %al,(%eax)
    4473:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    4477:	01 cd                	add    %ecx,%ebp
    4479:	00 00                	add    %al,(%eax)
    447b:	00 00                	add    %al,(%eax)
    447d:	00 00                	add    %al,(%eax)
    447f:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    4483:	01 d2                	add    %edx,%edx
    4485:	00 00                	add    %al,(%eax)
    4487:	00 00                	add    %al,(%eax)
    4489:	00 00                	add    %al,(%eax)
    448b:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    448f:	01 db                	add    %ebx,%ebx
    4491:	00 00                	add    %al,(%eax)
    4493:	00 00                	add    %al,(%eax)
    4495:	00 00                	add    %al,(%eax)
    4497:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    449b:	01 f2                	add    %esi,%edx
    449d:	00 00                	add    %al,(%eax)
    449f:	00 00                	add    %al,(%eax)
    44a1:	00 00                	add    %al,(%eax)
    44a3:	00 44 00 cc          	add    %al,-0x34(%eax,%eax,1)
    44a7:	01 f5                	add    %esi,%ebp
    44a9:	00 00                	add    %al,(%eax)
    44ab:	00 00                	add    %al,(%eax)
    44ad:	00 00                	add    %al,(%eax)
    44af:	00 44 00 bc          	add    %al,-0x44(%eax,%eax,1)
    44b3:	01 f8                	add    %edi,%eax
    44b5:	00 00                	add    %al,(%eax)
    44b7:	00 00                	add    %al,(%eax)
    44b9:	00 00                	add    %al,(%eax)
    44bb:	00 44 00 de          	add    %al,-0x22(%eax,%eax,1)
    44bf:	01 00                	add    %eax,(%eax)
    44c1:	01 00                	add    %eax,(%eax)
    44c3:	00 71 14             	add    %dh,0x14(%ecx)
    44c6:	00 00                	add    %al,(%eax)
    44c8:	40                   	inc    %eax
    44c9:	00 00                	add    %al,(%eax)
    44cb:	00 00                	add    %al,(%eax)
    44cd:	00 00                	add    %al,(%eax)
    44cf:	00 41 15             	add    %al,0x15(%ecx)
    44d2:	00 00                	add    %al,(%eax)
    44d4:	40                   	inc    %eax
    44d5:	00 00                	add    %al,(%eax)
    44d7:	00 03                	add    %al,(%ebx)
    44d9:	00 00                	add    %al,(%eax)
    44db:	00 4c 15 00          	add    %cl,0x0(%ebp,%edx,1)
    44df:	00 40 00             	add    %al,0x0(%eax)
    44e2:	00 00                	add    %al,(%eax)
    44e4:	01 00                	add    %eax,(%eax)
    44e6:	00 00                	add    %al,(%eax)
    44e8:	00 00                	add    %al,(%eax)
    44ea:	00 00                	add    %al,(%eax)
    44ec:	c0 00 00             	rolb   $0x0,(%eax)
	...
    44f7:	00 e0                	add    %ah,%al
    44f9:	00 00                	add    %al,(%eax)
    44fb:	00 08                	add    %cl,(%eax)
    44fd:	01 00                	add    %eax,(%eax)
    44ff:	00 b2 15 00 00 24    	add    %dh,0x24000015(%edx)
    4505:	00 00                	add    %al,(%eax)
    4507:	00 c2                	add    %al,%dl
    4509:	17                   	pop    %ss
    450a:	28 00                	sub    %al,(%eax)
    450c:	92                   	xchg   %eax,%edx
    450d:	14 00                	adc    $0x0,%al
    450f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    4515:	00 00                	add    %al,(%eax)
    4517:	00 c7                	add    %al,%bh
    4519:	15 00 00 a0 00       	adc    $0xa00000,%eax
    451e:	00 00                	add    %al,(%eax)
    4520:	0c 00                	or     $0x0,%al
    4522:	00 00                	add    %al,(%eax)
    4524:	00 00                	add    %al,(%eax)
    4526:	00 00                	add    %al,(%eax)
    4528:	44                   	inc    %esp
    4529:	00 02                	add    %al,(%edx)
    452b:	01 00                	add    %eax,(%eax)
    452d:	00 00                	add    %al,(%eax)
    452f:	00 00                	add    %al,(%eax)
    4531:	00 00                	add    %al,(%eax)
    4533:	00 44 00 02          	add    %al,0x2(%eax,%eax,1)
    4537:	01 09                	add    %ecx,(%ecx)
    4539:	00 00                	add    %al,(%eax)
    453b:	00 00                	add    %al,(%eax)
    453d:	00 00                	add    %al,(%eax)
    453f:	00 44 00 03          	add    %al,0x3(%eax,%eax,1)
    4543:	01 0f                	add    %ecx,(%edi)
    4545:	00 00                	add    %al,(%eax)
    4547:	00 00                	add    %al,(%eax)
    4549:	00 00                	add    %al,(%eax)
    454b:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
    454f:	01 12                	add    %edx,(%edx)
    4551:	00 00                	add    %al,(%eax)
    4553:	00 00                	add    %al,(%eax)
    4555:	00 00                	add    %al,(%eax)
    4557:	00 44 00 03          	add    %al,0x3(%eax,%eax,1)
    455b:	01 15 00 00 00 00    	add    %edx,0x0
    4561:	00 00                	add    %al,(%eax)
    4563:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
    4567:	01 1a                	add    %ebx,(%edx)
    4569:	00 00                	add    %al,(%eax)
    456b:	00 00                	add    %al,(%eax)
    456d:	00 00                	add    %al,(%eax)
    456f:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    4573:	01 30                	add    %esi,(%eax)
    4575:	00 00                	add    %al,(%eax)
    4577:	00 00                	add    %al,(%eax)
    4579:	00 00                	add    %al,(%eax)
    457b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    457f:	01 32                	add    %esi,(%edx)
    4581:	00 00                	add    %al,(%eax)
    4583:	00 00                	add    %al,(%eax)
    4585:	00 00                	add    %al,(%eax)
    4587:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    458b:	01 35 00 00 00 00    	add    %esi,0x0
    4591:	00 00                	add    %al,(%eax)
    4593:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    4597:	01 3b                	add    %edi,(%ebx)
    4599:	00 00                	add    %al,(%eax)
    459b:	00 00                	add    %al,(%eax)
    459d:	00 00                	add    %al,(%eax)
    459f:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    45a3:	01 41 00             	add    %eax,0x0(%ecx)
    45a6:	00 00                	add    %al,(%eax)
    45a8:	00 00                	add    %al,(%eax)
    45aa:	00 00                	add    %al,(%eax)
    45ac:	44                   	inc    %esp
    45ad:	00 14 01             	add    %dl,(%ecx,%eax,1)
    45b0:	4b                   	dec    %ebx
    45b1:	00 00                	add    %al,(%eax)
    45b3:	00 00                	add    %al,(%eax)
    45b5:	00 00                	add    %al,(%eax)
    45b7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    45bb:	01 4d 00             	add    %ecx,0x0(%ebp)
    45be:	00 00                	add    %al,(%eax)
    45c0:	00 00                	add    %al,(%eax)
    45c2:	00 00                	add    %al,(%eax)
    45c4:	44                   	inc    %esp
    45c5:	00 17                	add    %dl,(%edi)
    45c7:	01 54 00 00          	add    %edx,0x0(%eax,%eax,1)
    45cb:	00 00                	add    %al,(%eax)
    45cd:	00 00                	add    %al,(%eax)
    45cf:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    45d3:	01 57 00             	add    %edx,0x0(%edi)
    45d6:	00 00                	add    %al,(%eax)
    45d8:	00 00                	add    %al,(%eax)
    45da:	00 00                	add    %al,(%eax)
    45dc:	44                   	inc    %esp
    45dd:	00 14 01             	add    %dl,(%ecx,%eax,1)
    45e0:	59                   	pop    %ecx
    45e1:	00 00                	add    %al,(%eax)
    45e3:	00 00                	add    %al,(%eax)
    45e5:	00 00                	add    %al,(%eax)
    45e7:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    45eb:	01 5d 00             	add    %ebx,0x0(%ebp)
    45ee:	00 00                	add    %al,(%eax)
    45f0:	00 00                	add    %al,(%eax)
    45f2:	00 00                	add    %al,(%eax)
    45f4:	44                   	inc    %esp
    45f5:	00 19                	add    %bl,(%ecx)
    45f7:	01 63 00             	add    %esp,0x0(%ebx)
    45fa:	00 00                	add    %al,(%eax)
    45fc:	00 00                	add    %al,(%eax)
    45fe:	00 00                	add    %al,(%eax)
    4600:	44                   	inc    %esp
    4601:	00 1a                	add    %bl,(%edx)
    4603:	01 6a 00             	add    %ebp,0x0(%edx)
    4606:	00 00                	add    %al,(%eax)
    4608:	00 00                	add    %al,(%eax)
    460a:	00 00                	add    %al,(%eax)
    460c:	44                   	inc    %esp
    460d:	00 1c 01             	add    %bl,(%ecx,%eax,1)
    4610:	85 00                	test   %eax,(%eax)
    4612:	00 00                	add    %al,(%eax)
    4614:	00 00                	add    %al,(%eax)
    4616:	00 00                	add    %al,(%eax)
    4618:	44                   	inc    %esp
    4619:	00 21                	add    %ah,(%ecx)
    461b:	01 9a 00 00 00 00    	add    %ebx,0x0(%edx)
    4621:	00 00                	add    %al,(%eax)
    4623:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    4627:	01 a3 00 00 00 00    	add    %esp,0x0(%ebx)
    462d:	00 00                	add    %al,(%eax)
    462f:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    4633:	01 a4 00 00 00 00 00 	add    %esp,0x0(%eax,%eax,1)
    463a:	00 00                	add    %al,(%eax)
    463c:	44                   	inc    %esp
    463d:	00 2a                	add    %ch,(%edx)
    463f:	01 a7 00 00 00 00    	add    %esp,0x0(%edi)
    4645:	00 00                	add    %al,(%eax)
    4647:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    464b:	01 aa 00 00 00 00    	add    %ebp,0x0(%edx)
    4651:	00 00                	add    %al,(%eax)
    4653:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    4657:	01 c3                	add    %eax,%ebx
    4659:	00 00                	add    %al,(%eax)
    465b:	00 00                	add    %al,(%eax)
    465d:	00 00                	add    %al,(%eax)
    465f:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
    4663:	01 d5                	add    %edx,%ebp
    4665:	00 00                	add    %al,(%eax)
    4667:	00 00                	add    %al,(%eax)
    4669:	00 00                	add    %al,(%eax)
    466b:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    466f:	01 df                	add    %ebx,%edi
    4671:	00 00                	add    %al,(%eax)
    4673:	00 00                	add    %al,(%eax)
    4675:	00 00                	add    %al,(%eax)
    4677:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
    467b:	01 e1                	add    %esp,%ecx
    467d:	00 00                	add    %al,(%eax)
    467f:	00 00                	add    %al,(%eax)
    4681:	00 00                	add    %al,(%eax)
    4683:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
    4687:	01 e8                	add    %ebp,%eax
    4689:	00 00                	add    %al,(%eax)
    468b:	00 00                	add    %al,(%eax)
    468d:	00 00                	add    %al,(%eax)
    468f:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    4693:	01 eb                	add    %ebp,%ebx
    4695:	00 00                	add    %al,(%eax)
    4697:	00 00                	add    %al,(%eax)
    4699:	00 00                	add    %al,(%eax)
    469b:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    469f:	01 ed                	add    %ebp,%ebp
    46a1:	00 00                	add    %al,(%eax)
    46a3:	00 00                	add    %al,(%eax)
    46a5:	00 00                	add    %al,(%eax)
    46a7:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    46ab:	01 f1                	add    %esi,%ecx
    46ad:	00 00                	add    %al,(%eax)
    46af:	00 00                	add    %al,(%eax)
    46b1:	00 00                	add    %al,(%eax)
    46b3:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    46b7:	01 f7                	add    %esi,%edi
    46b9:	00 00                	add    %al,(%eax)
    46bb:	00 00                	add    %al,(%eax)
    46bd:	00 00                	add    %al,(%eax)
    46bf:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
    46c3:	01 fd                	add    %edi,%ebp
    46c5:	00 00                	add    %al,(%eax)
    46c7:	00 00                	add    %al,(%eax)
    46c9:	00 00                	add    %al,(%eax)
    46cb:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    46cf:	01 0a                	add    %ecx,(%edx)
    46d1:	01 00                	add    %eax,(%eax)
    46d3:	00 00                	add    %al,(%eax)
    46d5:	00 00                	add    %al,(%eax)
    46d7:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
    46db:	01 0c 01             	add    %ecx,(%ecx,%eax,1)
    46de:	00 00                	add    %al,(%eax)
    46e0:	00 00                	add    %al,(%eax)
    46e2:	00 00                	add    %al,(%eax)
    46e4:	44                   	inc    %esp
    46e5:	00 39                	add    %bh,(%ecx)
    46e7:	01 13                	add    %edx,(%ebx)
    46e9:	01 00                	add    %eax,(%eax)
    46eb:	00 00                	add    %al,(%eax)
    46ed:	00 00                	add    %al,(%eax)
    46ef:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    46f3:	01 16                	add    %edx,(%esi)
    46f5:	01 00                	add    %eax,(%eax)
    46f7:	00 00                	add    %al,(%eax)
    46f9:	00 00                	add    %al,(%eax)
    46fb:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    46ff:	01 18                	add    %ebx,(%eax)
    4701:	01 00                	add    %eax,(%eax)
    4703:	00 00                	add    %al,(%eax)
    4705:	00 00                	add    %al,(%eax)
    4707:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    470b:	01 1d 01 00 00 00    	add    %ebx,0x1
    4711:	00 00                	add    %al,(%eax)
    4713:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    4717:	01 29                	add    %ebp,(%ecx)
    4719:	01 00                	add    %eax,(%eax)
    471b:	00 00                	add    %al,(%eax)
    471d:	00 00                	add    %al,(%eax)
    471f:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
    4723:	01 2d 01 00 00 00    	add    %ebp,0x1
    4729:	00 00                	add    %al,(%eax)
    472b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    472f:	01 45 01             	add    %eax,0x1(%ebp)
    4732:	00 00                	add    %al,(%eax)
    4734:	00 00                	add    %al,(%eax)
    4736:	00 00                	add    %al,(%eax)
    4738:	44                   	inc    %esp
    4739:	00 46 01             	add    %al,0x1(%esi)
    473c:	4b                   	dec    %ebx
    473d:	01 00                	add    %eax,(%eax)
    473f:	00 00                	add    %al,(%eax)
    4741:	00 00                	add    %al,(%eax)
    4743:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
    4747:	01 4e 01             	add    %ecx,0x1(%esi)
    474a:	00 00                	add    %al,(%eax)
    474c:	00 00                	add    %al,(%eax)
    474e:	00 00                	add    %al,(%eax)
    4750:	44                   	inc    %esp
    4751:	00 46 01             	add    %al,0x1(%esi)
    4754:	55                   	push   %ebp
    4755:	01 00                	add    %eax,(%eax)
    4757:	00 00                	add    %al,(%eax)
    4759:	00 00                	add    %al,(%eax)
    475b:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    475f:	01 58 01             	add    %ebx,0x1(%eax)
    4762:	00 00                	add    %al,(%eax)
    4764:	00 00                	add    %al,(%eax)
    4766:	00 00                	add    %al,(%eax)
    4768:	44                   	inc    %esp
    4769:	00 4a 01             	add    %cl,0x1(%edx)
    476c:	73 01                	jae    476f <bootmain-0x27b891>
    476e:	00 00                	add    %al,(%eax)
    4770:	00 00                	add    %al,(%eax)
    4772:	00 00                	add    %al,(%eax)
    4774:	44                   	inc    %esp
    4775:	00 4d 01             	add    %cl,0x1(%ebp)
    4778:	92                   	xchg   %eax,%edx
    4779:	01 00                	add    %eax,(%eax)
    477b:	00 2a                	add    %ch,(%edx)
    477d:	14 00                	adc    $0x0,%al
    477f:	00 40 00             	add    %al,0x0(%eax)
    4782:	00 00                	add    %al,(%eax)
    4784:	06                   	push   %es
    4785:	00 00                	add    %al,(%eax)
    4787:	00 71 14             	add    %dh,0x14(%ecx)
    478a:	00 00                	add    %al,(%eax)
    478c:	40                   	inc    %eax
    478d:	00 00                	add    %al,(%eax)
    478f:	00 03                	add    %al,(%ebx)
    4791:	00 00                	add    %al,(%eax)
    4793:	00 d5                	add    %dl,%ch
    4795:	15 00 00 40 00       	adc    $0x400000,%eax
    479a:	00 00                	add    %al,(%eax)
    479c:	02 00                	add    (%eax),%al
    479e:	00 00                	add    %al,(%eax)
    47a0:	00 00                	add    %al,(%eax)
    47a2:	00 00                	add    %al,(%eax)
    47a4:	c0 00 00             	rolb   $0x0,(%eax)
	...
    47af:	00 e0                	add    %ah,%al
    47b1:	00 00                	add    %al,(%eax)
    47b3:	00 9a 01 00 00 e3    	add    %bl,-0x1cffffff(%edx)
    47b9:	15 00 00 24 00       	adc    $0x240000,%eax
    47be:	00 00                	add    %al,(%eax)
    47c0:	5c                   	pop    %esp
    47c1:	19 28                	sbb    %ebp,(%eax)
    47c3:	00 92 14 00 00 a0    	add    %dl,-0x5fffffec(%edx)
    47c9:	00 00                	add    %al,(%eax)
    47cb:	00 08                	add    %cl,(%eax)
    47cd:	00 00                	add    %al,(%eax)
    47cf:	00 00                	add    %al,(%eax)
    47d1:	00 00                	add    %al,(%eax)
    47d3:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
    47d7:	01 00                	add    %eax,(%eax)
    47d9:	00 00                	add    %al,(%eax)
    47db:	00 00                	add    %al,(%eax)
    47dd:	00 00                	add    %al,(%eax)
    47df:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
    47e3:	01 04 00             	add    %eax,(%eax,%eax,1)
    47e6:	00 00                	add    %al,(%eax)
    47e8:	00 00                	add    %al,(%eax)
    47ea:	00 00                	add    %al,(%eax)
    47ec:	44                   	inc    %esp
    47ed:	00 a5 01 07 00 00    	add    %ah,0x701(%ebp)
    47f3:	00 00                	add    %al,(%eax)
    47f5:	00 00                	add    %al,(%eax)
    47f7:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
    47fb:	01 0d 00 00 00 00    	add    %ecx,0x0
    4801:	00 00                	add    %al,(%eax)
    4803:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    4807:	01 17                	add    %edx,(%edi)
    4809:	00 00                	add    %al,(%eax)
    480b:	00 00                	add    %al,(%eax)
    480d:	00 00                	add    %al,(%eax)
    480f:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
    4813:	01 1e                	add    %ebx,(%esi)
    4815:	00 00                	add    %al,(%eax)
    4817:	00 71 14             	add    %dh,0x14(%ecx)
    481a:	00 00                	add    %al,(%eax)
    481c:	40                   	inc    %eax
    481d:	00 00                	add    %al,(%eax)
    481f:	00 03                	add    %al,(%ebx)
    4821:	00 00                	add    %al,(%eax)
    4823:	00 f6                	add    %dh,%dh
    4825:	15 00 00 24 00       	adc    $0x240000,%eax
    482a:	00 00                	add    %al,(%eax)
    482c:	7f 19                	jg     4847 <bootmain-0x27b7b9>
    482e:	28 00                	sub    %al,(%eax)
    4830:	92                   	xchg   %eax,%edx
    4831:	14 00                	adc    $0x0,%al
    4833:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    4839:	00 00                	add    %al,(%eax)
    483b:	00 f8                	add    %bh,%al
    483d:	14 00                	adc    $0x0,%al
    483f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    4845:	00 00                	add    %al,(%eax)
    4847:	00 03                	add    %al,(%ebx)
    4849:	15 00 00 a0 00       	adc    $0xa00000,%eax
    484e:	00 00                	add    %al,(%eax)
    4850:	10 00                	adc    %al,(%eax)
    4852:	00 00                	add    %al,(%eax)
    4854:	00 00                	add    %al,(%eax)
    4856:	00 00                	add    %al,(%eax)
    4858:	44                   	inc    %esp
    4859:	00 5b 01             	add    %bl,0x1(%ebx)
	...
    4864:	44                   	inc    %esp
    4865:	00 5b 01             	add    %bl,0x1(%ebx)
    4868:	09 00                	or     %eax,(%eax)
    486a:	00 00                	add    %al,(%eax)
    486c:	00 00                	add    %al,(%eax)
    486e:	00 00                	add    %al,(%eax)
    4870:	44                   	inc    %esp
    4871:	00 60 01             	add    %ah,0x1(%eax)
    4874:	0f 00 00             	sldt   (%eax)
    4877:	00 00                	add    %al,(%eax)
    4879:	00 00                	add    %al,(%eax)
    487b:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    487f:	01 12                	add    %edx,(%edx)
    4881:	00 00                	add    %al,(%eax)
    4883:	00 00                	add    %al,(%eax)
    4885:	00 00                	add    %al,(%eax)
    4887:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
    488b:	01 16                	add    %edx,(%esi)
    488d:	00 00                	add    %al,(%eax)
    488f:	00 00                	add    %al,(%eax)
    4891:	00 00                	add    %al,(%eax)
    4893:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
    4897:	01 19                	add    %ebx,(%ecx)
    4899:	00 00                	add    %al,(%eax)
    489b:	00 00                	add    %al,(%eax)
    489d:	00 00                	add    %al,(%eax)
    489f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    48a3:	01 1c 00             	add    %ebx,(%eax,%eax,1)
    48a6:	00 00                	add    %al,(%eax)
    48a8:	00 00                	add    %al,(%eax)
    48aa:	00 00                	add    %al,(%eax)
    48ac:	44                   	inc    %esp
    48ad:	00 60 01             	add    %ah,0x1(%eax)
    48b0:	1f                   	pop    %ds
    48b1:	00 00                	add    %al,(%eax)
    48b3:	00 00                	add    %al,(%eax)
    48b5:	00 00                	add    %al,(%eax)
    48b7:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
    48bb:	01 22                	add    %esp,(%edx)
    48bd:	00 00                	add    %al,(%eax)
    48bf:	00 00                	add    %al,(%eax)
    48c1:	00 00                	add    %al,(%eax)
    48c3:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    48c7:	01 25 00 00 00 00    	add    %esp,0x0
    48cd:	00 00                	add    %al,(%eax)
    48cf:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
    48d3:	01 27                	add    %esp,(%edi)
    48d5:	00 00                	add    %al,(%eax)
    48d7:	00 00                	add    %al,(%eax)
    48d9:	00 00                	add    %al,(%eax)
    48db:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    48df:	01 43 00             	add    %eax,0x0(%ebx)
    48e2:	00 00                	add    %al,(%eax)
    48e4:	00 00                	add    %al,(%eax)
    48e6:	00 00                	add    %al,(%eax)
    48e8:	44                   	inc    %esp
    48e9:	00 68 01             	add    %ch,0x1(%eax)
    48ec:	5d                   	pop    %ebp
    48ed:	00 00                	add    %al,(%eax)
    48ef:	00 00                	add    %al,(%eax)
    48f1:	00 00                	add    %al,(%eax)
    48f3:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    48f7:	01 81 00 00 00 00    	add    %eax,0x0(%ecx)
    48fd:	00 00                	add    %al,(%eax)
    48ff:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    4903:	01 a0 00 00 00 2a    	add    %esp,0x2a000000(%eax)
    4909:	14 00                	adc    $0x0,%al
    490b:	00 40 00             	add    %al,0x0(%eax)
    490e:	00 00                	add    %al,(%eax)
    4910:	07                   	pop    %es
    4911:	00 00                	add    %al,(%eax)
    4913:	00 09                	add    %cl,(%ecx)
    4915:	16                   	push   %ss
    4916:	00 00                	add    %al,(%eax)
    4918:	40                   	inc    %eax
    4919:	00 00                	add    %al,(%eax)
    491b:	00 02                	add    %al,(%edx)
    491d:	00 00                	add    %al,(%eax)
    491f:	00 18                	add    %bl,(%eax)
    4921:	16                   	push   %ss
    4922:	00 00                	add    %al,(%eax)
    4924:	40                   	inc    %eax
    4925:	00 00                	add    %al,(%eax)
    4927:	00 01                	add    %al,(%ecx)
    4929:	00 00                	add    %al,(%eax)
    492b:	00 71 14             	add    %dh,0x14(%ecx)
    492e:	00 00                	add    %al,(%eax)
    4930:	40                   	inc    %eax
    4931:	00 00                	add    %al,(%eax)
    4933:	00 03                	add    %al,(%ebx)
    4935:	00 00                	add    %al,(%eax)
    4937:	00 27                	add    %ah,(%edi)
    4939:	16                   	push   %ss
    493a:	00 00                	add    %al,(%eax)
    493c:	40                   	inc    %eax
    493d:	00 00                	add    %al,(%eax)
    493f:	00 06                	add    %al,(%esi)
    4941:	00 00                	add    %al,(%eax)
    4943:	00 00                	add    %al,(%eax)
    4945:	00 00                	add    %al,(%eax)
    4947:	00 c0                	add    %al,%al
	...
    4951:	00 00                	add    %al,(%eax)
    4953:	00 e0                	add    %ah,%al
    4955:	00 00                	add    %al,(%eax)
    4957:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
    495d:	00 00                	add    %al,(%eax)
    495f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    4963:	00 27                	add    %ah,(%edi)
    4965:	1a 28                	sbb    (%eax),%ch
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <bootmain-0x27ff88>
   a:	74 75                	je     81 <bootmain-0x27ff7f>
   c:	20 34 2e             	and    %dh,(%esi,%ebp,1)
   f:	38 2e                	cmp    %ch,(%esi)
  11:	32 2d 31 39 75 62    	xor    0x62753931,%ch
  17:	75 6e                	jne    87 <bootmain-0x27ff79>
  19:	74 75                	je     90 <bootmain-0x27ff70>
  1b:	31 29                	xor    %ebp,(%ecx)
  1d:	20 34 2e             	and    %dh,(%esi,%ebp,1)
  20:	38 2e                	cmp    %ch,(%esi)
  22:	32 00                	xor    (%eax),%al

Disassembly of section .stabstr:

00000000 <.stabstr>:
       0:	00 6d 61             	add    %ch,0x61(%ebp)
       3:	69 6e 2e 63 00 67 63 	imul   $0x63670063,0x2e(%esi),%ebp
       a:	63 32                	arpl   %si,(%edx)
       c:	5f                   	pop    %edi
       d:	63 6f 6d             	arpl   %bp,0x6d(%edi)
      10:	70 69                	jo     7b <bootmain-0x27ff85>
      12:	6c                   	insb   (%dx),%es:(%edi)
      13:	65 64 2e 00 69 6e    	gs fs add %ch,%cs:%fs:%gs:0x6e(%ecx)
      19:	74 3a                	je     55 <bootmain-0x27ffab>
      1b:	74 28                	je     45 <bootmain-0x27ffbb>
      1d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
      20:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
      26:	31 29                	xor    %ebp,(%ecx)
      28:	3b 2d 32 31 34 37    	cmp    0x37343132,%ebp
      2e:	34 38                	xor    $0x38,%al
      30:	33 36                	xor    (%esi),%esi
      32:	34 38                	xor    $0x38,%al
      34:	3b 32                	cmp    (%edx),%esi
      36:	31 34 37             	xor    %esi,(%edi,%esi,1)
      39:	34 38                	xor    $0x38,%al
      3b:	33 36                	xor    (%esi),%esi
      3d:	34 37                	xor    $0x37,%al
      3f:	3b 00                	cmp    (%eax),%eax
      41:	63 68 61             	arpl   %bp,0x61(%eax)
      44:	72 3a                	jb     80 <bootmain-0x27ff80>
      46:	74 28                	je     70 <bootmain-0x27ff90>
      48:	30 2c 32             	xor    %ch,(%edx,%esi,1)
      4b:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
      51:	32 29                	xor    (%ecx),%ch
      53:	3b 30                	cmp    (%eax),%esi
      55:	3b 31                	cmp    (%ecx),%esi
      57:	32 37                	xor    (%edi),%dh
      59:	3b 00                	cmp    (%eax),%eax
      5b:	6c                   	insb   (%dx),%es:(%edi)
      5c:	6f                   	outsl  %ds:(%esi),(%dx)
      5d:	6e                   	outsb  %ds:(%esi),(%dx)
      5e:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
      62:	74 3a                	je     9e <bootmain-0x27ff62>
      64:	74 28                	je     8e <bootmain-0x27ff72>
      66:	30 2c 33             	xor    %ch,(%ebx,%esi,1)
      69:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
      6f:	33 29                	xor    (%ecx),%ebp
      71:	3b 2d 32 31 34 37    	cmp    0x37343132,%ebp
      77:	34 38                	xor    $0x38,%al
      79:	33 36                	xor    (%esi),%esi
      7b:	34 38                	xor    $0x38,%al
      7d:	3b 32                	cmp    (%edx),%esi
      7f:	31 34 37             	xor    %esi,(%edi,%esi,1)
      82:	34 38                	xor    $0x38,%al
      84:	33 36                	xor    (%esi),%esi
      86:	34 37                	xor    $0x37,%al
      88:	3b 00                	cmp    (%eax),%eax
      8a:	75 6e                	jne    fa <bootmain-0x27ff06>
      8c:	73 69                	jae    f7 <bootmain-0x27ff09>
      8e:	67 6e                	outsb  %ds:(%si),(%dx)
      90:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
      95:	74 3a                	je     d1 <bootmain-0x27ff2f>
      97:	74 28                	je     c1 <bootmain-0x27ff3f>
      99:	30 2c 34             	xor    %ch,(%esp,%esi,1)
      9c:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
      a2:	34 29                	xor    $0x29,%al
      a4:	3b 30                	cmp    (%eax),%esi
      a6:	3b 34 32             	cmp    (%edx,%esi,1),%esi
      a9:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
      ac:	36                   	ss
      ad:	37                   	aaa    
      ae:	32 39                	xor    (%ecx),%bh
      b0:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
      b5:	6e                   	outsb  %ds:(%esi),(%dx)
      b6:	67 20 75 6e          	and    %dh,0x6e(%di)
      ba:	73 69                	jae    125 <bootmain-0x27fedb>
      bc:	67 6e                	outsb  %ds:(%si),(%dx)
      be:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
      c3:	74 3a                	je     ff <bootmain-0x27ff01>
      c5:	74 28                	je     ef <bootmain-0x27ff11>
      c7:	30 2c 35 29 3d 72 28 	xor    %ch,0x28723d29(,%esi,1)
      ce:	30 2c 35 29 3b 30 3b 	xor    %ch,0x3b303b29(,%esi,1)
      d5:	34 32                	xor    $0x32,%al
      d7:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
      da:	36                   	ss
      db:	37                   	aaa    
      dc:	32 39                	xor    (%ecx),%bh
      de:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
      e3:	6e                   	outsb  %ds:(%esi),(%dx)
      e4:	67 20 6c 6f          	and    %ch,0x6f(%si)
      e8:	6e                   	outsb  %ds:(%esi),(%dx)
      e9:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
      ed:	74 3a                	je     129 <bootmain-0x27fed7>
      ef:	74 28                	je     119 <bootmain-0x27fee7>
      f1:	30 2c 36             	xor    %ch,(%esi,%esi,1)
      f4:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
      fa:	36 29 3b             	sub    %edi,%ss:(%ebx)
      fd:	2d 30 3b 34 32       	sub    $0x32343b30,%eax
     102:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
     105:	36                   	ss
     106:	37                   	aaa    
     107:	32 39                	xor    (%ecx),%bh
     109:	35 3b 00 6c 6f       	xor    $0x6f6c003b,%eax
     10e:	6e                   	outsb  %ds:(%esi),(%dx)
     10f:	67 20 6c 6f          	and    %ch,0x6f(%si)
     113:	6e                   	outsb  %ds:(%esi),(%dx)
     114:	67 20 75 6e          	and    %dh,0x6e(%di)
     118:	73 69                	jae    183 <bootmain-0x27fe7d>
     11a:	67 6e                	outsb  %ds:(%si),(%dx)
     11c:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
     121:	74 3a                	je     15d <bootmain-0x27fea3>
     123:	74 28                	je     14d <bootmain-0x27feb3>
     125:	30 2c 37             	xor    %ch,(%edi,%esi,1)
     128:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
     12e:	37                   	aaa    
     12f:	29 3b                	sub    %edi,(%ebx)
     131:	30 3b                	xor    %bh,(%ebx)
     133:	2d 31 3b 00 73       	sub    $0x73003b31,%eax
     138:	68 6f 72 74 20       	push   $0x2074726f
     13d:	69 6e 74 3a 74 28 30 	imul   $0x3028743a,0x74(%esi),%ebp
     144:	2c 38                	sub    $0x38,%al
     146:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
     14c:	38 29                	cmp    %ch,(%ecx)
     14e:	3b 2d 33 32 37 36    	cmp    0x36373233,%ebp
     154:	38 3b                	cmp    %bh,(%ebx)
     156:	33 32                	xor    (%edx),%esi
     158:	37                   	aaa    
     159:	36                   	ss
     15a:	37                   	aaa    
     15b:	3b 00                	cmp    (%eax),%eax
     15d:	73 68                	jae    1c7 <bootmain-0x27fe39>
     15f:	6f                   	outsl  %ds:(%esi),(%dx)
     160:	72 74                	jb     1d6 <bootmain-0x27fe2a>
     162:	20 75 6e             	and    %dh,0x6e(%ebp)
     165:	73 69                	jae    1d0 <bootmain-0x27fe30>
     167:	67 6e                	outsb  %ds:(%si),(%dx)
     169:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
     16e:	74 3a                	je     1aa <bootmain-0x27fe56>
     170:	74 28                	je     19a <bootmain-0x27fe66>
     172:	30 2c 39             	xor    %ch,(%ecx,%edi,1)
     175:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
     17b:	39 29                	cmp    %ebp,(%ecx)
     17d:	3b 30                	cmp    (%eax),%esi
     17f:	3b 36                	cmp    (%esi),%esi
     181:	35 35 33 35 3b       	xor    $0x3b353335,%eax
     186:	00 73 69             	add    %dh,0x69(%ebx)
     189:	67 6e                	outsb  %ds:(%si),(%dx)
     18b:	65 64 20 63 68       	gs and %ah,%fs:%gs:0x68(%ebx)
     190:	61                   	popa   
     191:	72 3a                	jb     1cd <bootmain-0x27fe33>
     193:	74 28                	je     1bd <bootmain-0x27fe43>
     195:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     198:	30 29                	xor    %ch,(%ecx)
     19a:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
     19f:	31 30                	xor    %esi,(%eax)
     1a1:	29 3b                	sub    %edi,(%ebx)
     1a3:	2d 31 32 38 3b       	sub    $0x3b383231,%eax
     1a8:	31 32                	xor    %esi,(%edx)
     1aa:	37                   	aaa    
     1ab:	3b 00                	cmp    (%eax),%eax
     1ad:	75 6e                	jne    21d <bootmain-0x27fde3>
     1af:	73 69                	jae    21a <bootmain-0x27fde6>
     1b1:	67 6e                	outsb  %ds:(%si),(%dx)
     1b3:	65 64 20 63 68       	gs and %ah,%fs:%gs:0x68(%ebx)
     1b8:	61                   	popa   
     1b9:	72 3a                	jb     1f5 <bootmain-0x27fe0b>
     1bb:	74 28                	je     1e5 <bootmain-0x27fe1b>
     1bd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     1c0:	31 29                	xor    %ebp,(%ecx)
     1c2:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
     1c7:	31 31                	xor    %esi,(%ecx)
     1c9:	29 3b                	sub    %edi,(%ebx)
     1cb:	30 3b                	xor    %bh,(%ebx)
     1cd:	32 35 35 3b 00 66    	xor    0x66003b35,%dh
     1d3:	6c                   	insb   (%dx),%es:(%edi)
     1d4:	6f                   	outsl  %ds:(%esi),(%dx)
     1d5:	61                   	popa   
     1d6:	74 3a                	je     212 <bootmain-0x27fdee>
     1d8:	74 28                	je     202 <bootmain-0x27fdfe>
     1da:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     1dd:	32 29                	xor    (%ecx),%ch
     1df:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
     1e4:	31 29                	xor    %ebp,(%ecx)
     1e6:	3b 34 3b             	cmp    (%ebx,%edi,1),%esi
     1e9:	30 3b                	xor    %bh,(%ebx)
     1eb:	00 64 6f 75          	add    %ah,0x75(%edi,%ebp,2)
     1ef:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
     1f3:	74 28                	je     21d <bootmain-0x27fde3>
     1f5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     1f8:	33 29                	xor    (%ecx),%ebp
     1fa:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
     1ff:	31 29                	xor    %ebp,(%ecx)
     201:	3b 38                	cmp    (%eax),%edi
     203:	3b 30                	cmp    (%eax),%esi
     205:	3b 00                	cmp    (%eax),%eax
     207:	6c                   	insb   (%dx),%es:(%edi)
     208:	6f                   	outsl  %ds:(%esi),(%dx)
     209:	6e                   	outsb  %ds:(%esi),(%dx)
     20a:	67 20 64 6f          	and    %ah,0x6f(%si)
     20e:	75 62                	jne    272 <bootmain-0x27fd8e>
     210:	6c                   	insb   (%dx),%es:(%edi)
     211:	65 3a 74 28 30       	cmp    %gs:0x30(%eax,%ebp,1),%dh
     216:	2c 31                	sub    $0x31,%al
     218:	34 29                	xor    $0x29,%al
     21a:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
     21f:	31 29                	xor    %ebp,(%ecx)
     221:	3b 31                	cmp    (%ecx),%esi
     223:	32 3b                	xor    (%ebx),%bh
     225:	30 3b                	xor    %bh,(%ebx)
     227:	00 5f 44             	add    %bl,0x44(%edi)
     22a:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
     22e:	61                   	popa   
     22f:	6c                   	insb   (%dx),%es:(%edi)
     230:	33 32                	xor    (%edx),%esi
     232:	3a 74 28 30          	cmp    0x30(%eax,%ebp,1),%dh
     236:	2c 31                	sub    $0x31,%al
     238:	35 29 3d 72 28       	xor    $0x28723d29,%eax
     23d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     240:	29 3b                	sub    %edi,(%ebx)
     242:	34 3b                	xor    $0x3b,%al
     244:	30 3b                	xor    %bh,(%ebx)
     246:	00 5f 44             	add    %bl,0x44(%edi)
     249:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
     24d:	61                   	popa   
     24e:	6c                   	insb   (%dx),%es:(%edi)
     24f:	36                   	ss
     250:	34 3a                	xor    $0x3a,%al
     252:	74 28                	je     27c <bootmain-0x27fd84>
     254:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     257:	36 29 3d 72 28 30 2c 	sub    %edi,%ss:0x2c302872
     25e:	31 29                	xor    %ebp,(%ecx)
     260:	3b 38                	cmp    (%eax),%edi
     262:	3b 30                	cmp    (%eax),%esi
     264:	3b 00                	cmp    (%eax),%eax
     266:	5f                   	pop    %edi
     267:	44                   	inc    %esp
     268:	65 63 69 6d          	arpl   %bp,%gs:0x6d(%ecx)
     26c:	61                   	popa   
     26d:	6c                   	insb   (%dx),%es:(%edi)
     26e:	31 32                	xor    %esi,(%edx)
     270:	38 3a                	cmp    %bh,(%edx)
     272:	74 28                	je     29c <bootmain-0x27fd64>
     274:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     277:	37                   	aaa    
     278:	29 3d 72 28 30 2c    	sub    %edi,0x2c302872
     27e:	31 29                	xor    %ebp,(%ecx)
     280:	3b 31                	cmp    (%ecx),%esi
     282:	36 3b 30             	cmp    %ss:(%eax),%esi
     285:	3b 00                	cmp    (%eax),%eax
     287:	76 6f                	jbe    2f8 <bootmain-0x27fd08>
     289:	69 64 3a 74 28 30 2c 	imul   $0x312c3028,0x74(%edx,%edi,1),%esp
     290:	31 
     291:	38 29                	cmp    %ch,(%ecx)
     293:	3d 28 30 2c 31       	cmp    $0x312c3028,%eax
     298:	38 29                	cmp    %ch,(%ecx)
     29a:	00 2e                	add    %ch,(%esi)
     29c:	2f                   	das    
     29d:	69 6e 63 6c 75 64 65 	imul   $0x6564756c,0x63(%esi),%ebp
     2a4:	2f                   	das    
     2a5:	68 65 61 64 65       	push   $0x65646165
     2aa:	72 2e                	jb     2da <bootmain-0x27fd26>
     2ac:	68 00 2e 2f 69       	push   $0x692f2e00
     2b1:	6e                   	outsb  %ds:(%esi),(%dx)
     2b2:	63 6c 75 64          	arpl   %bp,0x64(%ebp,%esi,2)
     2b6:	65                   	gs
     2b7:	2f                   	das    
     2b8:	78 38                	js     2f2 <bootmain-0x27fd0e>
     2ba:	36                   	ss
     2bb:	2e                   	cs
     2bc:	68 00 2e 2f 69       	push   $0x692f2e00
     2c1:	6e                   	outsb  %ds:(%esi),(%dx)
     2c2:	63 6c 75 64          	arpl   %bp,0x64(%ebp,%esi,2)
     2c6:	65                   	gs
     2c7:	2f                   	das    
     2c8:	74 79                	je     343 <bootmain-0x27fcbd>
     2ca:	70 65                	jo     331 <bootmain-0x27fccf>
     2cc:	73 2e                	jae    2fc <bootmain-0x27fd04>
     2ce:	68 00 62 6f 6f       	push   $0x6f6f6200
     2d3:	6c                   	insb   (%dx),%es:(%edi)
     2d4:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     2d8:	2c 31                	sub    $0x31,%al
     2da:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     2e0:	29 00                	sub    %eax,(%eax)
     2e2:	69 6e 74 38 5f 74 3a 	imul   $0x3a745f38,0x74(%esi),%ebp
     2e9:	74 28                	je     313 <bootmain-0x27fced>
     2eb:	33 2c 32             	xor    (%edx,%esi,1),%ebp
     2ee:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     2f4:	30 29                	xor    %ch,(%ecx)
     2f6:	00 75 69             	add    %dh,0x69(%ebp)
     2f9:	6e                   	outsb  %ds:(%esi),(%dx)
     2fa:	74 38                	je     334 <bootmain-0x27fccc>
     2fc:	5f                   	pop    %edi
     2fd:	74 3a                	je     339 <bootmain-0x27fcc7>
     2ff:	74 28                	je     329 <bootmain-0x27fcd7>
     301:	33 2c 33             	xor    (%ebx,%esi,1),%ebp
     304:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     30a:	31 29                	xor    %ebp,(%ecx)
     30c:	00 69 6e             	add    %ch,0x6e(%ecx)
     30f:	74 31                	je     342 <bootmain-0x27fcbe>
     311:	36                   	ss
     312:	5f                   	pop    %edi
     313:	74 3a                	je     34f <bootmain-0x27fcb1>
     315:	74 28                	je     33f <bootmain-0x27fcc1>
     317:	33 2c 34             	xor    (%esp,%esi,1),%ebp
     31a:	29 3d 28 30 2c 38    	sub    %edi,0x382c3028
     320:	29 00                	sub    %eax,(%eax)
     322:	75 69                	jne    38d <bootmain-0x27fc73>
     324:	6e                   	outsb  %ds:(%esi),(%dx)
     325:	74 31                	je     358 <bootmain-0x27fca8>
     327:	36                   	ss
     328:	5f                   	pop    %edi
     329:	74 3a                	je     365 <bootmain-0x27fc9b>
     32b:	74 28                	je     355 <bootmain-0x27fcab>
     32d:	33 2c 35 29 3d 28 30 	xor    0x30283d29(,%esi,1),%ebp
     334:	2c 39                	sub    $0x39,%al
     336:	29 00                	sub    %eax,(%eax)
     338:	69 6e 74 33 32 5f 74 	imul   $0x745f3233,0x74(%esi),%ebp
     33f:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     343:	2c 36                	sub    $0x36,%al
     345:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     34b:	29 00                	sub    %eax,(%eax)
     34d:	75 69                	jne    3b8 <bootmain-0x27fc48>
     34f:	6e                   	outsb  %ds:(%esi),(%dx)
     350:	74 33                	je     385 <bootmain-0x27fc7b>
     352:	32 5f 74             	xor    0x74(%edi),%bl
     355:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     359:	2c 37                	sub    $0x37,%al
     35b:	29 3d 28 30 2c 34    	sub    %edi,0x342c3028
     361:	29 00                	sub    %eax,(%eax)
     363:	69 6e 74 36 34 5f 74 	imul   $0x745f3436,0x74(%esi),%ebp
     36a:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     36e:	2c 38                	sub    $0x38,%al
     370:	29 3d 28 30 2c 36    	sub    %edi,0x362c3028
     376:	29 00                	sub    %eax,(%eax)
     378:	75 69                	jne    3e3 <bootmain-0x27fc1d>
     37a:	6e                   	outsb  %ds:(%esi),(%dx)
     37b:	74 36                	je     3b3 <bootmain-0x27fc4d>
     37d:	34 5f                	xor    $0x5f,%al
     37f:	74 3a                	je     3bb <bootmain-0x27fc45>
     381:	74 28                	je     3ab <bootmain-0x27fc55>
     383:	33 2c 39             	xor    (%ecx,%edi,1),%ebp
     386:	29 3d 28 30 2c 37    	sub    %edi,0x372c3028
     38c:	29 00                	sub    %eax,(%eax)
     38e:	69 6e 74 70 74 72 5f 	imul   $0x5f727470,0x74(%esi),%ebp
     395:	74 3a                	je     3d1 <bootmain-0x27fc2f>
     397:	74 28                	je     3c1 <bootmain-0x27fc3f>
     399:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     39c:	30 29                	xor    %ch,(%ecx)
     39e:	3d 28 33 2c 36       	cmp    $0x362c3328,%eax
     3a3:	29 00                	sub    %eax,(%eax)
     3a5:	75 69                	jne    410 <bootmain-0x27fbf0>
     3a7:	6e                   	outsb  %ds:(%esi),(%dx)
     3a8:	74 70                	je     41a <bootmain-0x27fbe6>
     3aa:	74 72                	je     41e <bootmain-0x27fbe2>
     3ac:	5f                   	pop    %edi
     3ad:	74 3a                	je     3e9 <bootmain-0x27fc17>
     3af:	74 28                	je     3d9 <bootmain-0x27fc27>
     3b1:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3b4:	31 29                	xor    %ebp,(%ecx)
     3b6:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3bb:	29 00                	sub    %eax,(%eax)
     3bd:	70 68                	jo     427 <bootmain-0x27fbd9>
     3bf:	79 73                	jns    434 <bootmain-0x27fbcc>
     3c1:	61                   	popa   
     3c2:	64                   	fs
     3c3:	64                   	fs
     3c4:	72 5f                	jb     425 <bootmain-0x27fbdb>
     3c6:	74 3a                	je     402 <bootmain-0x27fbfe>
     3c8:	74 28                	je     3f2 <bootmain-0x27fc0e>
     3ca:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3cd:	32 29                	xor    (%ecx),%ch
     3cf:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3d4:	29 00                	sub    %eax,(%eax)
     3d6:	70 70                	jo     448 <bootmain-0x27fbb8>
     3d8:	6e                   	outsb  %ds:(%esi),(%dx)
     3d9:	5f                   	pop    %edi
     3da:	74 3a                	je     416 <bootmain-0x27fbea>
     3dc:	74 28                	je     406 <bootmain-0x27fbfa>
     3de:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3e1:	33 29                	xor    (%ecx),%ebp
     3e3:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3e8:	29 00                	sub    %eax,(%eax)
     3ea:	73 69                	jae    455 <bootmain-0x27fbab>
     3ec:	7a 65                	jp     453 <bootmain-0x27fbad>
     3ee:	5f                   	pop    %edi
     3ef:	74 3a                	je     42b <bootmain-0x27fbd5>
     3f1:	74 28                	je     41b <bootmain-0x27fbe5>
     3f3:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3f6:	34 29                	xor    $0x29,%al
     3f8:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3fd:	29 00                	sub    %eax,(%eax)
     3ff:	73 73                	jae    474 <bootmain-0x27fb8c>
     401:	69 7a 65 5f 74 3a 74 	imul   $0x743a745f,0x65(%edx),%edi
     408:	28 33                	sub    %dh,(%ebx)
     40a:	2c 31                	sub    $0x31,%al
     40c:	35 29 3d 28 33       	xor    $0x33283d29,%eax
     411:	2c 36                	sub    $0x36,%al
     413:	29 00                	sub    %eax,(%eax)
     415:	6f                   	outsl  %ds:(%esi),(%dx)
     416:	66 66 5f             	data32 pop %di
     419:	74 3a                	je     455 <bootmain-0x27fbab>
     41b:	74 28                	je     445 <bootmain-0x27fbbb>
     41d:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     420:	36 29 3d 28 33 2c 36 	sub    %edi,%ss:0x362c3328
     427:	29 00                	sub    %eax,(%eax)
     429:	2e                   	cs
     42a:	2f                   	das    
     42b:	69 6e 63 6c 75 64 65 	imul   $0x6564756c,0x63(%esi),%ebp
     432:	2f                   	das    
     433:	6d                   	insl   (%dx),%es:(%edi)
     434:	6d                   	insl   (%dx),%es:(%edi)
     435:	2e                   	cs
     436:	68 00 43 65 6c       	push   $0x6c654300
     43b:	6c                   	insb   (%dx),%es:(%edi)
     43c:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     440:	2c 31                	sub    $0x31,%al
     442:	29 3d 73 38 61 64    	sub    %edi,0x64613873
     448:	64                   	fs
     449:	72 65                	jb     4b0 <bootmain-0x27fb50>
     44b:	73 73                	jae    4c0 <bootmain-0x27fb40>
     44d:	3a 28                	cmp    (%eax),%ch
     44f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     452:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     455:	2c 33                	sub    $0x33,%al
     457:	32 3b                	xor    (%ebx),%bh
     459:	73 69                	jae    4c4 <bootmain-0x27fb3c>
     45b:	7a 65                	jp     4c2 <bootmain-0x27fb3e>
     45d:	3a 28                	cmp    (%eax),%ch
     45f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     462:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     465:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     468:	32 3b                	xor    (%ebx),%bh
     46a:	3b 00                	cmp    (%eax),%eax
     46c:	43                   	inc    %ebx
     46d:	65                   	gs
     46e:	6c                   	insb   (%dx),%es:(%edi)
     46f:	6c                   	insb   (%dx),%es:(%edi)
     470:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     474:	2c 32                	sub    $0x32,%al
     476:	29 3d 28 34 2c 31    	sub    %edi,0x312c3428
     47c:	29 00                	sub    %eax,(%eax)
     47e:	4d                   	dec    %ebp
     47f:	65                   	gs
     480:	6d                   	insl   (%dx),%es:(%edi)
     481:	6d                   	insl   (%dx),%es:(%edi)
     482:	61                   	popa   
     483:	6e                   	outsb  %ds:(%esi),(%dx)
     484:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     488:	2c 33                	sub    $0x33,%al
     48a:	29 3d 73 33 32 37    	sub    %edi,0x37323373
     490:	33 36                	xor    (%esi),%esi
     492:	63 65 6c             	arpl   %sp,0x6c(%ebp)
     495:	6c                   	insb   (%dx),%es:(%edi)
     496:	6e                   	outsb  %ds:(%esi),(%dx)
     497:	75 6d                	jne    506 <bootmain-0x27fafa>
     499:	3a 28                	cmp    (%eax),%ch
     49b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     49e:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     4a1:	2c 33                	sub    $0x33,%al
     4a3:	32 3b                	xor    (%ebx),%bh
     4a5:	6d                   	insl   (%dx),%es:(%edi)
     4a6:	61                   	popa   
     4a7:	78 63                	js     50c <bootmain-0x27faf4>
     4a9:	65                   	gs
     4aa:	6c                   	insb   (%dx),%es:(%edi)
     4ab:	6c                   	insb   (%dx),%es:(%edi)
     4ac:	3a 28                	cmp    (%eax),%ch
     4ae:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     4b1:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     4b4:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     4b7:	32 3b                	xor    (%ebx),%bh
     4b9:	6c                   	insb   (%dx),%es:(%edi)
     4ba:	6f                   	outsl  %ds:(%esi),(%dx)
     4bb:	73 74                	jae    531 <bootmain-0x27facf>
     4bd:	73 69                	jae    528 <bootmain-0x27fad8>
     4bf:	7a 65                	jp     526 <bootmain-0x27fada>
     4c1:	3a 28                	cmp    (%eax),%ch
     4c3:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     4c6:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     4c9:	34 2c                	xor    $0x2c,%al
     4cb:	33 32                	xor    (%edx),%esi
     4cd:	3b 6c 6f 73          	cmp    0x73(%edi,%ebp,2),%ebp
     4d1:	74 73                	je     546 <bootmain-0x27faba>
     4d3:	3a 28                	cmp    (%eax),%ch
     4d5:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     4d8:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     4db:	36                   	ss
     4dc:	2c 33                	sub    $0x33,%al
     4de:	32 3b                	xor    (%ebx),%bh
     4e0:	63 65 6c             	arpl   %sp,0x6c(%ebp)
     4e3:	6c                   	insb   (%dx),%es:(%edi)
     4e4:	3a 28                	cmp    (%eax),%ch
     4e6:	34 2c                	xor    $0x2c,%al
     4e8:	34 29                	xor    $0x29,%al
     4ea:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     4ef:	2c 35                	sub    $0x35,%al
     4f1:	29 3d 72 28 34 2c    	sub    %edi,0x2c342872
     4f7:	35 29 3b 30 3b       	xor    $0x3b303b29,%eax
     4fc:	34 32                	xor    $0x32,%al
     4fe:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
     501:	36                   	ss
     502:	37                   	aaa    
     503:	32 39                	xor    (%ecx),%bh
     505:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
     50a:	34 30                	xor    $0x30,%al
     50c:	38 39                	cmp    %bh,(%ecx)
     50e:	3b 28                	cmp    (%eax),%ebp
     510:	34 2c                	xor    $0x2c,%al
     512:	32 29                	xor    (%ecx),%ch
     514:	2c 31                	sub    $0x31,%al
     516:	32 38                	xor    (%eax),%bh
     518:	2c 32                	sub    $0x32,%al
     51a:	36 31 37             	xor    %esi,%ss:(%edi)
     51d:	36 30 3b             	xor    %bh,%ss:(%ebx)
     520:	3b 00                	cmp    (%eax),%eax
     522:	4d                   	dec    %ebp
     523:	65                   	gs
     524:	6d                   	insl   (%dx),%es:(%edi)
     525:	6d                   	insl   (%dx),%es:(%edi)
     526:	61                   	popa   
     527:	6e                   	outsb  %ds:(%esi),(%dx)
     528:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     52c:	2c 36                	sub    $0x36,%al
     52e:	29 3d 28 34 2c 33    	sub    %edi,0x332c3428
     534:	29 00                	sub    %eax,(%eax)
     536:	53                   	push   %ebx
     537:	48                   	dec    %eax
     538:	45                   	inc    %ebp
     539:	45                   	inc    %ebp
     53a:	54                   	push   %esp
     53b:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     53f:	2c 37                	sub    $0x37,%al
     541:	29 3d 73 33 36 62    	sub    %edi,0x62363373
     547:	75 66                	jne    5af <bootmain-0x27fa51>
     549:	3a 28                	cmp    (%eax),%ch
     54b:	34 2c                	xor    $0x2c,%al
     54d:	38 29                	cmp    %ch,(%ecx)
     54f:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     554:	31 31                	xor    %esi,(%ecx)
     556:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     559:	2c 33                	sub    $0x33,%al
     55b:	32 3b                	xor    (%ebx),%bh
     55d:	62 78 73             	bound  %edi,0x73(%eax)
     560:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     567:	31 29                	xor    %ebp,(%ecx)
     569:	2c 33                	sub    $0x33,%al
     56b:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     56e:	32 3b                	xor    (%ebx),%bh
     570:	62 79 73             	bound  %edi,0x73(%ecx)
     573:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     57a:	31 29                	xor    %ebp,(%ecx)
     57c:	2c 36                	sub    $0x36,%al
     57e:	34 2c                	xor    $0x2c,%al
     580:	33 32                	xor    (%edx),%esi
     582:	3b 76 78             	cmp    0x78(%esi),%esi
     585:	30 3a                	xor    %bh,(%edx)
     587:	28 30                	sub    %dh,(%eax)
     589:	2c 31                	sub    $0x31,%al
     58b:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     58e:	36                   	ss
     58f:	2c 33                	sub    $0x33,%al
     591:	32 3b                	xor    (%ebx),%bh
     593:	76 79                	jbe    60e <bootmain-0x27f9f2>
     595:	30 3a                	xor    %bh,(%edx)
     597:	28 30                	sub    %dh,(%eax)
     599:	2c 31                	sub    $0x31,%al
     59b:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     59e:	32 38                	xor    (%eax),%bh
     5a0:	2c 33                	sub    $0x33,%al
     5a2:	32 3b                	xor    (%ebx),%bh
     5a4:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     5a7:	5f                   	pop    %edi
     5a8:	69 6e 76 3a 28 30 2c 	imul   $0x2c30283a,0x76(%esi),%ebp
     5af:	31 29                	xor    %ebp,(%ecx)
     5b1:	2c 31                	sub    $0x31,%al
     5b3:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
     5b7:	32 3b                	xor    (%ebx),%bh
     5b9:	68 65 69 67 68       	push   $0x68676965
     5be:	74 3a                	je     5fa <bootmain-0x27fa06>
     5c0:	28 30                	sub    %dh,(%eax)
     5c2:	2c 31                	sub    $0x31,%al
     5c4:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     5c7:	39 32                	cmp    %esi,(%edx)
     5c9:	2c 33                	sub    $0x33,%al
     5cb:	32 3b                	xor    (%ebx),%bh
     5cd:	66                   	data16
     5ce:	6c                   	insb   (%dx),%es:(%edi)
     5cf:	61                   	popa   
     5d0:	67 73 3a             	addr16 jae 60d <bootmain-0x27f9f3>
     5d3:	28 30                	sub    %dh,(%eax)
     5d5:	2c 31                	sub    $0x31,%al
     5d7:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
     5da:	32 34 2c             	xor    (%esp,%ebp,1),%dh
     5dd:	33 32                	xor    (%edx),%esi
     5df:	3b 63 74             	cmp    0x74(%ebx),%esp
     5e2:	6c                   	insb   (%dx),%es:(%edi)
     5e3:	3a 28                	cmp    (%eax),%ch
     5e5:	34 2c                	xor    $0x2c,%al
     5e7:	39 29                	cmp    %ebp,(%ecx)
     5e9:	3d 2a 28 34 2c       	cmp    $0x2c34282a,%eax
     5ee:	31 30                	xor    %esi,(%eax)
     5f0:	29 3d 78 73 53 48    	sub    %edi,0x48537378
     5f6:	54                   	push   %esp
     5f7:	43                   	inc    %ebx
     5f8:	54                   	push   %esp
     5f9:	4c                   	dec    %esp
     5fa:	3a 2c 32             	cmp    (%edx,%esi,1),%ch
     5fd:	35 36 2c 33 32       	xor    $0x32332c36,%eax
     602:	3b 3b                	cmp    (%ebx),%edi
     604:	00 53 48             	add    %dl,0x48(%ebx)
     607:	45                   	inc    %ebp
     608:	45                   	inc    %ebp
     609:	54                   	push   %esp
     60a:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     60e:	2c 31                	sub    $0x31,%al
     610:	31 29                	xor    %ebp,(%ecx)
     612:	3d 28 34 2c 37       	cmp    $0x372c3428,%eax
     617:	29 00                	sub    %eax,(%eax)
     619:	53                   	push   %ebx
     61a:	48                   	dec    %eax
     61b:	54                   	push   %esp
     61c:	43                   	inc    %ebx
     61d:	54                   	push   %esp
     61e:	4c                   	dec    %esp
     61f:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     623:	2c 31                	sub    $0x31,%al
     625:	30 29                	xor    %ch,(%ecx)
     627:	3d 73 31 30 32       	cmp    $0x32303173,%eax
     62c:	36 30 76 72          	xor    %dh,%ss:0x72(%esi)
     630:	61                   	popa   
     631:	6d                   	insl   (%dx),%es:(%edi)
     632:	3a 28                	cmp    (%eax),%ch
     634:	34 2c                	xor    $0x2c,%al
     636:	38 29                	cmp    %ch,(%ecx)
     638:	2c 30                	sub    $0x30,%al
     63a:	2c 33                	sub    $0x33,%al
     63c:	32 3b                	xor    (%ebx),%bh
     63e:	6d                   	insl   (%dx),%es:(%edi)
     63f:	61                   	popa   
     640:	70 3a                	jo     67c <bootmain-0x27f984>
     642:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
     645:	38 29                	cmp    %ch,(%ecx)
     647:	2c 33                	sub    $0x33,%al
     649:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     64c:	32 3b                	xor    (%ebx),%bh
     64e:	78 73                	js     6c3 <bootmain-0x27f93d>
     650:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     657:	31 29                	xor    %ebp,(%ecx)
     659:	2c 36                	sub    $0x36,%al
     65b:	34 2c                	xor    $0x2c,%al
     65d:	33 32                	xor    (%edx),%esi
     65f:	3b 79 73             	cmp    0x73(%ecx),%edi
     662:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     669:	31 29                	xor    %ebp,(%ecx)
     66b:	2c 39                	sub    $0x39,%al
     66d:	36                   	ss
     66e:	2c 33                	sub    $0x33,%al
     670:	32 3b                	xor    (%ebx),%bh
     672:	74 6f                	je     6e3 <bootmain-0x27f91d>
     674:	70 3a                	jo     6b0 <bootmain-0x27f950>
     676:	28 30                	sub    %dh,(%eax)
     678:	2c 31                	sub    $0x31,%al
     67a:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     67d:	32 38                	xor    (%eax),%bh
     67f:	2c 33                	sub    $0x33,%al
     681:	32 3b                	xor    (%ebx),%bh
     683:	73 68                	jae    6ed <bootmain-0x27f913>
     685:	65                   	gs
     686:	65                   	gs
     687:	74 3a                	je     6c3 <bootmain-0x27f93d>
     689:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
     68c:	31 32                	xor    %esi,(%edx)
     68e:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     694:	2c 35                	sub    $0x35,%al
     696:	29 3b                	sub    %edi,(%ebx)
     698:	30 3b                	xor    %bh,(%ebx)
     69a:	32 35 35 3b 28 34    	xor    0x34283b35,%dh
     6a0:	2c 31                	sub    $0x31,%al
     6a2:	31 29                	xor    %ebp,(%ecx)
     6a4:	2c 31                	sub    $0x31,%al
     6a6:	36 30 2c 37          	xor    %ch,%ss:(%edi,%esi,1)
     6aa:	33 37                	xor    (%edi),%esi
     6ac:	32 38                	xor    (%eax),%bh
     6ae:	3b 73 68             	cmp    0x68(%ebx),%esi
     6b1:	65                   	gs
     6b2:	65                   	gs
     6b3:	74 73                	je     728 <bootmain-0x27f8d8>
     6b5:	3a 28                	cmp    (%eax),%ch
     6b7:	34 2c                	xor    $0x2c,%al
     6b9:	31 33                	xor    %esi,(%ebx)
     6bb:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     6c1:	2c 35                	sub    $0x35,%al
     6c3:	29 3b                	sub    %edi,(%ebx)
     6c5:	30 3b                	xor    %bh,(%ebx)
     6c7:	32 35 35 3b 28 34    	xor    0x34283b35,%dh
     6cd:	2c 31                	sub    $0x31,%al
     6cf:	34 29                	xor    $0x29,%al
     6d1:	3d 2a 28 34 2c       	cmp    $0x2c34282a,%eax
     6d6:	31 31                	xor    %esi,(%ecx)
     6d8:	29 2c 37             	sub    %ebp,(%edi,%esi,1)
     6db:	33 38                	xor    (%eax),%edi
     6dd:	38 38                	cmp    %bh,(%eax)
     6df:	2c 38                	sub    $0x38,%al
     6e1:	31 39                	xor    %edi,(%ecx)
     6e3:	32 3b                	xor    (%ebx),%bh
     6e5:	3b 00                	cmp    (%eax),%eax
     6e7:	53                   	push   %ebx
     6e8:	48                   	dec    %eax
     6e9:	54                   	push   %esp
     6ea:	43                   	inc    %ebx
     6eb:	54                   	push   %esp
     6ec:	4c                   	dec    %esp
     6ed:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     6f1:	2c 31                	sub    $0x31,%al
     6f3:	35 29 3d 28 34       	xor    $0x34283d29,%eax
     6f8:	2c 31                	sub    $0x31,%al
     6fa:	30 29                	xor    %ch,(%ecx)
     6fc:	00 62 6f             	add    %ah,0x6f(%edx)
     6ff:	6f                   	outsl  %ds:(%esi),(%dx)
     700:	74 5f                	je     761 <bootmain-0x27f89f>
     702:	69 6e 66 6f 3a 54 28 	imul   $0x28543a6f,0x66(%esi),%ebp
     709:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
     70c:	29 3d 73 31 32 63    	sub    %edi,0x63323173
     712:	79 6c                	jns    780 <bootmain-0x27f880>
     714:	69 6e 64 65 72 3a 28 	imul   $0x283a7265,0x64(%esi),%ebp
     71b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     71e:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     721:	2c 38                	sub    $0x38,%al
     723:	3b 6c 65 64          	cmp    0x64(%ebp,%eiz,2),%ebp
     727:	3a 28                	cmp    (%eax),%ch
     729:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     72c:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
     72f:	2c 38                	sub    $0x38,%al
     731:	3b 63 6f             	cmp    0x6f(%ebx),%esp
     734:	6c                   	insb   (%dx),%es:(%edi)
     735:	6f                   	outsl  %ds:(%esi),(%dx)
     736:	72 5f                	jb     797 <bootmain-0x27f869>
     738:	6d                   	insl   (%dx),%es:(%edi)
     739:	6f                   	outsl  %ds:(%esi),(%dx)
     73a:	64 65 3a 28          	fs cmp %fs:%gs:(%eax),%ch
     73e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     741:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     744:	36                   	ss
     745:	2c 38                	sub    $0x38,%al
     747:	3b 72 65             	cmp    0x65(%edx),%esi
     74a:	73 65                	jae    7b1 <bootmain-0x27f84f>
     74c:	72 76                	jb     7c4 <bootmain-0x27f83c>
     74e:	65 64 3a 28          	gs cmp %fs:%gs:(%eax),%ch
     752:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     755:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
     758:	34 2c                	xor    $0x2c,%al
     75a:	38 3b                	cmp    %bh,(%ebx)
     75c:	78 73                	js     7d1 <bootmain-0x27f82f>
     75e:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     765:	38 29                	cmp    %ch,(%ecx)
     767:	2c 33                	sub    $0x33,%al
     769:	32 2c 31             	xor    (%ecx,%esi,1),%ch
     76c:	36 3b 79 73          	cmp    %ss:0x73(%ecx),%edi
     770:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     777:	38 29                	cmp    %ch,(%ecx)
     779:	2c 34                	sub    $0x34,%al
     77b:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     77e:	36 3b 76 72          	cmp    %ss:0x72(%esi),%esi
     782:	61                   	popa   
     783:	6d                   	insl   (%dx),%es:(%edi)
     784:	3a 28                	cmp    (%eax),%ch
     786:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     789:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
     78f:	32 29                	xor    (%ecx),%ch
     791:	2c 36                	sub    $0x36,%al
     793:	34 2c                	xor    $0x2c,%al
     795:	33 32                	xor    (%edx),%esi
     797:	3b 3b                	cmp    (%ebx),%edi
     799:	00 47 44             	add    %al,0x44(%edi)
     79c:	54                   	push   %esp
     79d:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     7a1:	2c 33                	sub    $0x33,%al
     7a3:	29 3d 73 38 6c 69    	sub    %edi,0x696c3873
     7a9:	6d                   	insl   (%dx),%es:(%edi)
     7aa:	69 74 5f 6c 6f 77 3a 	imul   $0x283a776f,0x6c(%edi,%ebx,2),%esi
     7b1:	28 
     7b2:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     7b5:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     7b8:	2c 31                	sub    $0x31,%al
     7ba:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     7be:	73 65                	jae    825 <bootmain-0x27f7db>
     7c0:	5f                   	pop    %edi
     7c1:	6c                   	insb   (%dx),%es:(%edi)
     7c2:	6f                   	outsl  %ds:(%esi),(%dx)
     7c3:	77 3a                	ja     7ff <bootmain-0x27f801>
     7c5:	28 30                	sub    %dh,(%eax)
     7c7:	2c 38                	sub    $0x38,%al
     7c9:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     7cc:	36                   	ss
     7cd:	2c 31                	sub    $0x31,%al
     7cf:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     7d3:	73 65                	jae    83a <bootmain-0x27f7c6>
     7d5:	5f                   	pop    %edi
     7d6:	6d                   	insl   (%dx),%es:(%edi)
     7d7:	69 64 3a 28 30 2c 32 	imul   $0x29322c30,0x28(%edx,%edi,1),%esp
     7de:	29 
     7df:	2c 33                	sub    $0x33,%al
     7e1:	32 2c 38             	xor    (%eax,%edi,1),%ch
     7e4:	3b 61 63             	cmp    0x63(%ecx),%esp
     7e7:	63 65 73             	arpl   %sp,0x73(%ebp)
     7ea:	73 5f                	jae    84b <bootmain-0x27f7b5>
     7ec:	72 69                	jb     857 <bootmain-0x27f7a9>
     7ee:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     7f4:	2c 32                	sub    $0x32,%al
     7f6:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     7f9:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     7fc:	3b 6c 69 6d          	cmp    0x6d(%ecx,%ebp,2),%ebp
     800:	69 74 5f 68 69 67 68 	imul   $0x3a686769,0x68(%edi,%ebx,2),%esi
     807:	3a 
     808:	28 30                	sub    %dh,(%eax)
     80a:	2c 32                	sub    $0x32,%al
     80c:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     80f:	38 2c 38             	cmp    %ch,(%eax,%edi,1)
     812:	3b 62 61             	cmp    0x61(%edx),%esp
     815:	73 65                	jae    87c <bootmain-0x27f784>
     817:	5f                   	pop    %edi
     818:	68 69 67 68 3a       	push   $0x3a686769
     81d:	28 30                	sub    %dh,(%eax)
     81f:	2c 32                	sub    $0x32,%al
     821:	29 2c 35 36 2c 38 3b 	sub    %ebp,0x3b382c36(,%esi,1)
     828:	3b 00                	cmp    (%eax),%eax
     82a:	49                   	dec    %ecx
     82b:	44                   	inc    %esp
     82c:	54                   	push   %esp
     82d:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     831:	2c 34                	sub    $0x34,%al
     833:	29 3d 73 38 6f 66    	sub    %edi,0x666f3873
     839:	66                   	data16
     83a:	73 65                	jae    8a1 <bootmain-0x27f75f>
     83c:	74 5f                	je     89d <bootmain-0x27f763>
     83e:	6c                   	insb   (%dx),%es:(%edi)
     83f:	6f                   	outsl  %ds:(%esi),(%dx)
     840:	77 3a                	ja     87c <bootmain-0x27f784>
     842:	28 30                	sub    %dh,(%eax)
     844:	2c 38                	sub    $0x38,%al
     846:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     849:	2c 31                	sub    $0x31,%al
     84b:	36 3b 73 65          	cmp    %ss:0x65(%ebx),%esi
     84f:	6c                   	insb   (%dx),%es:(%edi)
     850:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     855:	3a 28                	cmp    (%eax),%ch
     857:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     85a:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     85d:	36                   	ss
     85e:	2c 31                	sub    $0x31,%al
     860:	36 3b 64 77 5f       	cmp    %ss:0x5f(%edi,%esi,2),%esp
     865:	63 6f 75             	arpl   %bp,0x75(%edi)
     868:	6e                   	outsb  %ds:(%esi),(%dx)
     869:	74 3a                	je     8a5 <bootmain-0x27f75b>
     86b:	28 30                	sub    %dh,(%eax)
     86d:	2c 32                	sub    $0x32,%al
     86f:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     872:	32 2c 38             	xor    (%eax,%edi,1),%ch
     875:	3b 61 63             	cmp    0x63(%ecx),%esp
     878:	63 65 73             	arpl   %sp,0x73(%ebp)
     87b:	73 5f                	jae    8dc <bootmain-0x27f724>
     87d:	72 69                	jb     8e8 <bootmain-0x27f718>
     87f:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     885:	2c 32                	sub    $0x32,%al
     887:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     88a:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     88d:	3b 6f 66             	cmp    0x66(%edi),%ebp
     890:	66                   	data16
     891:	73 65                	jae    8f8 <bootmain-0x27f708>
     893:	74 5f                	je     8f4 <bootmain-0x27f70c>
     895:	68 69 67 68 3a       	push   $0x3a686769
     89a:	28 30                	sub    %dh,(%eax)
     89c:	2c 38                	sub    $0x38,%al
     89e:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     8a1:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     8a4:	36 3b 3b             	cmp    %ss:(%ebx),%edi
     8a7:	00 46 49             	add    %al,0x49(%esi)
     8aa:	46                   	inc    %esi
     8ab:	4f                   	dec    %edi
     8ac:	38 3a                	cmp    %bh,(%edx)
     8ae:	54                   	push   %esp
     8af:	28 31                	sub    %dh,(%ecx)
     8b1:	2c 35                	sub    $0x35,%al
     8b3:	29 3d 73 32 34 62    	sub    %edi,0x62343273
     8b9:	75 66                	jne    921 <bootmain-0x27f6df>
     8bb:	3a 28                	cmp    (%eax),%ch
     8bd:	34 2c                	xor    $0x2c,%al
     8bf:	38 29                	cmp    %ch,(%ecx)
     8c1:	2c 30                	sub    $0x30,%al
     8c3:	2c 33                	sub    $0x33,%al
     8c5:	32 3b                	xor    (%ebx),%bh
     8c7:	6e                   	outsb  %ds:(%esi),(%dx)
     8c8:	77 3a                	ja     904 <bootmain-0x27f6fc>
     8ca:	28 30                	sub    %dh,(%eax)
     8cc:	2c 31                	sub    $0x31,%al
     8ce:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     8d1:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     8d4:	32 3b                	xor    (%ebx),%bh
     8d6:	6e                   	outsb  %ds:(%esi),(%dx)
     8d7:	72 3a                	jb     913 <bootmain-0x27f6ed>
     8d9:	28 30                	sub    %dh,(%eax)
     8db:	2c 31                	sub    $0x31,%al
     8dd:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     8e0:	34 2c                	xor    $0x2c,%al
     8e2:	33 32                	xor    (%edx),%esi
     8e4:	3b 73 69             	cmp    0x69(%ebx),%esi
     8e7:	7a 65                	jp     94e <bootmain-0x27f6b2>
     8e9:	3a 28                	cmp    (%eax),%ch
     8eb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8ee:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     8f1:	36                   	ss
     8f2:	2c 33                	sub    $0x33,%al
     8f4:	32 3b                	xor    (%ebx),%bh
     8f6:	66                   	data16
     8f7:	72 65                	jb     95e <bootmain-0x27f6a2>
     8f9:	65 3a 28             	cmp    %gs:(%eax),%ch
     8fc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8ff:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     902:	32 38                	xor    (%eax),%bh
     904:	2c 33                	sub    $0x33,%al
     906:	32 3b                	xor    (%ebx),%bh
     908:	66                   	data16
     909:	6c                   	insb   (%dx),%es:(%edi)
     90a:	61                   	popa   
     90b:	67 73 3a             	addr16 jae 948 <bootmain-0x27f6b8>
     90e:	28 30                	sub    %dh,(%eax)
     910:	2c 31                	sub    $0x31,%al
     912:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     915:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
     919:	32 3b                	xor    (%ebx),%bh
     91b:	3b 00                	cmp    (%eax),%eax
     91d:	4d                   	dec    %ebp
     91e:	4f                   	dec    %edi
     91f:	55                   	push   %ebp
     920:	53                   	push   %ebx
     921:	45                   	inc    %ebp
     922:	5f                   	pop    %edi
     923:	44                   	inc    %esp
     924:	45                   	inc    %ebp
     925:	43                   	inc    %ebx
     926:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     92a:	2c 36                	sub    $0x36,%al
     92c:	29 3d 73 31 36 62    	sub    %edi,0x62363173
     932:	75 66                	jne    99a <bootmain-0x27f666>
     934:	3a 28                	cmp    (%eax),%ch
     936:	31 2c 37             	xor    %ebp,(%edi,%esi,1)
     939:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     93f:	2c 35                	sub    $0x35,%al
     941:	29 3b                	sub    %edi,(%ebx)
     943:	30 3b                	xor    %bh,(%ebx)
     945:	32 3b                	xor    (%ebx),%bh
     947:	28 30                	sub    %dh,(%eax)
     949:	2c 31                	sub    $0x31,%al
     94b:	31 29                	xor    %ebp,(%ecx)
     94d:	2c 30                	sub    $0x30,%al
     94f:	2c 32                	sub    $0x32,%al
     951:	34 3b                	xor    $0x3b,%al
     953:	70 68                	jo     9bd <bootmain-0x27f643>
     955:	61                   	popa   
     956:	73 65                	jae    9bd <bootmain-0x27f643>
     958:	3a 28                	cmp    (%eax),%ch
     95a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     95d:	31 29                	xor    %ebp,(%ecx)
     95f:	2c 32                	sub    $0x32,%al
     961:	34 2c                	xor    $0x2c,%al
     963:	38 3b                	cmp    %bh,(%ebx)
     965:	78 3a                	js     9a1 <bootmain-0x27f65f>
     967:	28 30                	sub    %dh,(%eax)
     969:	2c 31                	sub    $0x31,%al
     96b:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     96e:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     971:	32 3b                	xor    (%ebx),%bh
     973:	79 3a                	jns    9af <bootmain-0x27f651>
     975:	28 30                	sub    %dh,(%eax)
     977:	2c 31                	sub    $0x31,%al
     979:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     97c:	34 2c                	xor    $0x2c,%al
     97e:	33 32                	xor    (%edx),%esi
     980:	3b 62 75             	cmp    0x75(%edx),%esp
     983:	74 74                	je     9f9 <bootmain-0x27f607>
     985:	6f                   	outsl  %ds:(%esi),(%dx)
     986:	6e                   	outsb  %ds:(%esi),(%dx)
     987:	3a 28                	cmp    (%eax),%ch
     989:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     98c:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     98f:	36                   	ss
     990:	2c 33                	sub    $0x33,%al
     992:	32 3b                	xor    (%ebx),%bh
     994:	3b 00                	cmp    (%eax),%eax
     996:	62 6f 6f             	bound  %ebp,0x6f(%edi)
     999:	74 6d                	je     a08 <bootmain-0x27f5f8>
     99b:	61                   	popa   
     99c:	69 6e 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%esi),%ebp
     9a3:	31 38                	xor    %edi,(%eax)
     9a5:	29 00                	sub    %eax,(%eax)
     9a7:	6d                   	insl   (%dx),%es:(%edi)
     9a8:	6f                   	outsl  %ds:(%esi),(%dx)
     9a9:	75 73                	jne    a1e <bootmain-0x27f5e2>
     9ab:	65                   	gs
     9ac:	70 69                	jo     a17 <bootmain-0x27f5e9>
     9ae:	63 3a                	arpl   %di,(%edx)
     9b0:	28 30                	sub    %dh,(%eax)
     9b2:	2c 31                	sub    $0x31,%al
     9b4:	39 29                	cmp    %ebp,(%ecx)
     9b6:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9bb:	2c 35                	sub    $0x35,%al
     9bd:	29 3b                	sub    %edi,(%ebx)
     9bf:	30 3b                	xor    %bh,(%ebx)
     9c1:	32 35 35 3b 28 30    	xor    0x30283b35,%dh
     9c7:	2c 32                	sub    $0x32,%al
     9c9:	29 00                	sub    %eax,(%eax)
     9cb:	73 3a                	jae    a07 <bootmain-0x27f5f9>
     9cd:	28 30                	sub    %dh,(%eax)
     9cf:	2c 32                	sub    $0x32,%al
     9d1:	30 29                	xor    %ch,(%ecx)
     9d3:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9d8:	2c 35                	sub    $0x35,%al
     9da:	29 3b                	sub    %edi,(%ebx)
     9dc:	30 3b                	xor    %bh,(%ebx)
     9de:	33 39                	xor    (%ecx),%edi
     9e0:	3b 28                	cmp    (%eax),%ebp
     9e2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9e5:	31 29                	xor    %ebp,(%ecx)
     9e7:	00 6b 65             	add    %ch,0x65(%ebx)
     9ea:	79 62                	jns    a4e <bootmain-0x27f5b2>
     9ec:	75 66                	jne    a54 <bootmain-0x27f5ac>
     9ee:	3a 28                	cmp    (%eax),%ch
     9f0:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     9f3:	31 29                	xor    %ebp,(%ecx)
     9f5:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9fa:	2c 35                	sub    $0x35,%al
     9fc:	29 3b                	sub    %edi,(%ebx)
     9fe:	30 3b                	xor    %bh,(%ebx)
     a00:	33 31                	xor    (%ecx),%esi
     a02:	3b 28                	cmp    (%eax),%ebp
     a04:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a07:	31 29                	xor    %ebp,(%ecx)
     a09:	00 6d 6f             	add    %ch,0x6f(%ebp)
     a0c:	75 73                	jne    a81 <bootmain-0x27f57f>
     a0e:	65 62 75 66          	bound  %esi,%gs:0x66(%ebp)
     a12:	3a 28                	cmp    (%eax),%ch
     a14:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a17:	32 29                	xor    (%ecx),%ch
     a19:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     a1e:	2c 35                	sub    $0x35,%al
     a20:	29 3b                	sub    %edi,(%ebx)
     a22:	30 3b                	xor    %bh,(%ebx)
     a24:	31 32                	xor    %esi,(%edx)
     a26:	37                   	aaa    
     a27:	3b 28                	cmp    (%eax),%ebp
     a29:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a2c:	31 29                	xor    %ebp,(%ecx)
     a2e:	00 6d 64             	add    %ch,0x64(%ebp)
     a31:	65 63 3a             	arpl   %di,%gs:(%edx)
     a34:	28 31                	sub    %dh,(%ecx)
     a36:	2c 36                	sub    $0x36,%al
     a38:	29 00                	sub    %eax,(%eax)
     a3a:	6d                   	insl   (%dx),%es:(%edi)
     a3b:	65                   	gs
     a3c:	6d                   	insl   (%dx),%es:(%edi)
     a3d:	74 6f                	je     aae <bootmain-0x27f552>
     a3f:	74 61                	je     aa2 <bootmain-0x27f55e>
     a41:	6c                   	insb   (%dx),%es:(%edi)
     a42:	3a 72 28             	cmp    0x28(%edx),%dh
     a45:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     a48:	29 00                	sub    %eax,(%eax)
     a4a:	64                   	fs
     a4b:	65                   	gs
     a4c:	73 6b                	jae    ab9 <bootmain-0x27f547>
     a4e:	74 6f                	je     abf <bootmain-0x27f541>
     a50:	70 3a                	jo     a8c <bootmain-0x27f574>
     a52:	72 28                	jb     a7c <bootmain-0x27f584>
     a54:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     a57:	29 00                	sub    %eax,(%eax)
     a59:	41                   	inc    %ecx
     a5a:	53                   	push   %ebx
     a5b:	43                   	inc    %ebx
     a5c:	49                   	dec    %ecx
     a5d:	49                   	dec    %ecx
     a5e:	5f                   	pop    %edi
     a5f:	54                   	push   %esp
     a60:	61                   	popa   
     a61:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
     a65:	47                   	inc    %edi
     a66:	28 30                	sub    %dh,(%eax)
     a68:	2c 32                	sub    $0x32,%al
     a6a:	33 29                	xor    (%ecx),%ebp
     a6c:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     a71:	2c 35                	sub    $0x35,%al
     a73:	29 3b                	sub    %edi,(%ebx)
     a75:	30 3b                	xor    %bh,(%ebx)
     a77:	32 32                	xor    (%edx),%dh
     a79:	37                   	aaa    
     a7a:	39 3b                	cmp    %edi,(%ebx)
     a7c:	28 30                	sub    %dh,(%eax)
     a7e:	2c 39                	sub    $0x39,%al
     a80:	29 00                	sub    %eax,(%eax)
     a82:	46                   	inc    %esi
     a83:	6f                   	outsl  %ds:(%esi),(%dx)
     a84:	6e                   	outsb  %ds:(%esi),(%dx)
     a85:	74 38                	je     abf <bootmain-0x27f541>
     a87:	78 31                	js     aba <bootmain-0x27f546>
     a89:	36 3a 47 28          	cmp    %ss:0x28(%edi),%al
     a8d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a90:	34 29                	xor    $0x29,%al
     a92:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     a97:	2c 35                	sub    $0x35,%al
     a99:	29 3b                	sub    %edi,(%ebx)
     a9b:	30 3b                	xor    %bh,(%ebx)
     a9d:	32 30                	xor    (%eax),%dh
     a9f:	34 37                	xor    $0x37,%al
     aa1:	3b 28                	cmp    (%eax),%ebp
     aa3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     aa6:	31 29                	xor    %ebp,(%ecx)
     aa8:	00 73 63             	add    %dh,0x63(%ebx)
     aab:	72 65                	jb     b12 <bootmain-0x27f4ee>
     aad:	65 6e                	outsb  %gs:(%esi),(%dx)
     aaf:	2e 63 00             	arpl   %ax,%cs:(%eax)
     ab2:	63 6c 65 61          	arpl   %bp,0x61(%ebp,%eiz,2)
     ab6:	72 5f                	jb     b17 <bootmain-0x27f4e9>
     ab8:	73 63                	jae    b1d <bootmain-0x27f4e3>
     aba:	72 65                	jb     b21 <bootmain-0x27f4df>
     abc:	65 6e                	outsb  %gs:(%esi),(%dx)
     abe:	3a 46 28             	cmp    0x28(%esi),%al
     ac1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ac4:	38 29                	cmp    %ch,(%ecx)
     ac6:	00 63 6f             	add    %ah,0x6f(%ebx)
     ac9:	6c                   	insb   (%dx),%es:(%edi)
     aca:	6f                   	outsl  %ds:(%esi),(%dx)
     acb:	72 3a                	jb     b07 <bootmain-0x27f4f9>
     acd:	70 28                	jo     af7 <bootmain-0x27f509>
     acf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ad2:	29 00                	sub    %eax,(%eax)
     ad4:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
     ada:	31 29                	xor    %ebp,(%ecx)
     adc:	00 63 6f             	add    %ah,0x6f(%ebx)
     adf:	6c                   	insb   (%dx),%es:(%edi)
     ae0:	6f                   	outsl  %ds:(%esi),(%dx)
     ae1:	72 3a                	jb     b1d <bootmain-0x27f4e3>
     ae3:	72 28                	jb     b0d <bootmain-0x27f4f3>
     ae5:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     ae8:	29 00                	sub    %eax,(%eax)
     aea:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     aed:	6f                   	outsl  %ds:(%esi),(%dx)
     aee:	72 5f                	jb     b4f <bootmain-0x27f4b1>
     af0:	73 63                	jae    b55 <bootmain-0x27f4ab>
     af2:	72 65                	jb     b59 <bootmain-0x27f4a7>
     af4:	65 6e                	outsb  %gs:(%esi),(%dx)
     af6:	3a 46 28             	cmp    0x28(%esi),%al
     af9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     afc:	38 29                	cmp    %ch,(%ecx)
     afe:	00 73 65             	add    %dh,0x65(%ebx)
     b01:	74 5f                	je     b62 <bootmain-0x27f49e>
     b03:	70 61                	jo     b66 <bootmain-0x27f49a>
     b05:	6c                   	insb   (%dx),%es:(%edi)
     b06:	65                   	gs
     b07:	74 74                	je     b7d <bootmain-0x27f483>
     b09:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     b0d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b10:	38 29                	cmp    %ch,(%ecx)
     b12:	00 73 74             	add    %dh,0x74(%ebx)
     b15:	61                   	popa   
     b16:	72 74                	jb     b8c <bootmain-0x27f474>
     b18:	3a 70 28             	cmp    0x28(%eax),%dh
     b1b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b1e:	29 00                	sub    %eax,(%eax)
     b20:	65 6e                	outsb  %gs:(%esi),(%dx)
     b22:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
     b26:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b29:	29 00                	sub    %eax,(%eax)
     b2b:	72 67                	jb     b94 <bootmain-0x27f46c>
     b2d:	62 3a                	bound  %edi,(%edx)
     b2f:	70 28                	jo     b59 <bootmain-0x27f4a7>
     b31:	34 2c                	xor    $0x2c,%al
     b33:	38 29                	cmp    %ch,(%ecx)
     b35:	00 73 74             	add    %dh,0x74(%ebx)
     b38:	61                   	popa   
     b39:	72 74                	jb     baf <bootmain-0x27f451>
     b3b:	3a 72 28             	cmp    0x28(%edx),%dh
     b3e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b41:	29 00                	sub    %eax,(%eax)
     b43:	72 67                	jb     bac <bootmain-0x27f454>
     b45:	62 3a                	bound  %edi,(%edx)
     b47:	72 28                	jb     b71 <bootmain-0x27f48f>
     b49:	34 2c                	xor    $0x2c,%al
     b4b:	38 29                	cmp    %ch,(%ecx)
     b4d:	00 69 6e             	add    %ch,0x6e(%ecx)
     b50:	69 74 5f 70 61 6c 65 	imul   $0x74656c61,0x70(%edi,%ebx,2),%esi
     b57:	74 
     b58:	74 65                	je     bbf <bootmain-0x27f441>
     b5a:	3a 46 28             	cmp    0x28(%esi),%al
     b5d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b60:	38 29                	cmp    %ch,(%ecx)
     b62:	00 74 61 62          	add    %dh,0x62(%ecx,%eiz,2)
     b66:	6c                   	insb   (%dx),%es:(%edi)
     b67:	65                   	gs
     b68:	5f                   	pop    %edi
     b69:	72 67                	jb     bd2 <bootmain-0x27f42e>
     b6b:	62 3a                	bound  %edi,(%edx)
     b6d:	28 30                	sub    %dh,(%eax)
     b6f:	2c 31                	sub    $0x31,%al
     b71:	39 29                	cmp    %ebp,(%ecx)
     b73:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     b78:	2c 35                	sub    $0x35,%al
     b7a:	29 3b                	sub    %edi,(%ebx)
     b7c:	30 3b                	xor    %bh,(%ebx)
     b7e:	34 37                	xor    $0x37,%al
     b80:	3b 28                	cmp    (%eax),%ebp
     b82:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b85:	31 29                	xor    %ebp,(%ecx)
     b87:	00 62 6f             	add    %ah,0x6f(%edx)
     b8a:	78 66                	js     bf2 <bootmain-0x27f40e>
     b8c:	69 6c 6c 38 3a 46 28 	imul   $0x3028463a,0x38(%esp,%ebp,2),%ebp
     b93:	30 
     b94:	2c 31                	sub    $0x31,%al
     b96:	38 29                	cmp    %ch,(%ecx)
     b98:	00 76 72             	add    %dh,0x72(%esi)
     b9b:	61                   	popa   
     b9c:	6d                   	insl   (%dx),%es:(%edi)
     b9d:	3a 70 28             	cmp    0x28(%eax),%dh
     ba0:	34 2c                	xor    $0x2c,%al
     ba2:	38 29                	cmp    %ch,(%ecx)
     ba4:	00 78 73             	add    %bh,0x73(%eax)
     ba7:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     bae:	2c 31                	sub    $0x31,%al
     bb0:	29 00                	sub    %eax,(%eax)
     bb2:	78 30                	js     be4 <bootmain-0x27f41c>
     bb4:	3a 70 28             	cmp    0x28(%eax),%dh
     bb7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bba:	29 00                	sub    %eax,(%eax)
     bbc:	79 30                	jns    bee <bootmain-0x27f412>
     bbe:	3a 70 28             	cmp    0x28(%eax),%dh
     bc1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bc4:	29 00                	sub    %eax,(%eax)
     bc6:	78 31                	js     bf9 <bootmain-0x27f407>
     bc8:	3a 70 28             	cmp    0x28(%eax),%dh
     bcb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bce:	29 00                	sub    %eax,(%eax)
     bd0:	79 31                	jns    c03 <bootmain-0x27f3fd>
     bd2:	3a 70 28             	cmp    0x28(%eax),%dh
     bd5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bd8:	29 00                	sub    %eax,(%eax)
     bda:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     bdd:	6f                   	outsl  %ds:(%esi),(%dx)
     bde:	72 3a                	jb     c1a <bootmain-0x27f3e6>
     be0:	72 28                	jb     c0a <bootmain-0x27f3f6>
     be2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     be5:	31 29                	xor    %ebp,(%ecx)
     be7:	00 79 30             	add    %bh,0x30(%ecx)
     bea:	3a 72 28             	cmp    0x28(%edx),%dh
     bed:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bf0:	29 00                	sub    %eax,(%eax)
     bf2:	62 6f 78             	bound  %ebp,0x78(%edi)
     bf5:	66 69 6c 6c 3a 46 28 	imul   $0x2846,0x3a(%esp,%ebp,2),%bp
     bfc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bff:	38 29                	cmp    %ch,(%ecx)
     c01:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
     c05:	77 5f                	ja     c66 <bootmain-0x27f39a>
     c07:	77 69                	ja     c72 <bootmain-0x27f38e>
     c09:	6e                   	outsb  %ds:(%esi),(%dx)
     c0a:	5f                   	pop    %edi
     c0b:	62 75 66             	bound  %esi,0x66(%ebp)
     c0e:	3a 46 28             	cmp    0x28(%esi),%al
     c11:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c14:	38 29                	cmp    %ch,(%ecx)
     c16:	00 70 3a             	add    %dh,0x3a(%eax)
     c19:	70 28                	jo     c43 <bootmain-0x27f3bd>
     c1b:	34 2c                	xor    $0x2c,%al
     c1d:	38 29                	cmp    %ch,(%ecx)
     c1f:	00 70 3a             	add    %dh,0x3a(%eax)
     c22:	72 28                	jb     c4c <bootmain-0x27f3b4>
     c24:	34 2c                	xor    $0x2c,%al
     c26:	38 29                	cmp    %ch,(%ecx)
     c28:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
     c2c:	77 5f                	ja     c8d <bootmain-0x27f373>
     c2e:	77 69                	ja     c99 <bootmain-0x27f367>
     c30:	6e                   	outsb  %ds:(%esi),(%dx)
     c31:	64 6f                	outsl  %fs:(%esi),(%dx)
     c33:	77 3a                	ja     c6f <bootmain-0x27f391>
     c35:	46                   	inc    %esi
     c36:	28 30                	sub    %dh,(%eax)
     c38:	2c 31                	sub    $0x31,%al
     c3a:	38 29                	cmp    %ch,(%ecx)
     c3c:	00 69 6e             	add    %ch,0x6e(%ecx)
     c3f:	69 74 5f 73 63 72 65 	imul   $0x65657263,0x73(%edi,%ebx,2),%esi
     c46:	65 
     c47:	6e                   	outsb  %ds:(%esi),(%dx)
     c48:	3a 46 28             	cmp    0x28(%esi),%al
     c4b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c4e:	38 29                	cmp    %ch,(%ecx)
     c50:	00 62 6f             	add    %ah,0x6f(%edx)
     c53:	6f                   	outsl  %ds:(%esi),(%dx)
     c54:	74 70                	je     cc6 <bootmain-0x27f33a>
     c56:	3a 70 28             	cmp    0x28(%eax),%dh
     c59:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     c5c:	30 29                	xor    %ch,(%ecx)
     c5e:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     c63:	31 29                	xor    %ebp,(%ecx)
     c65:	00 62 6f             	add    %ah,0x6f(%edx)
     c68:	6f                   	outsl  %ds:(%esi),(%dx)
     c69:	74 70                	je     cdb <bootmain-0x27f325>
     c6b:	3a 72 28             	cmp    0x28(%edx),%dh
     c6e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     c71:	30 29                	xor    %ch,(%ecx)
     c73:	00 69 6e             	add    %ch,0x6e(%ecx)
     c76:	69 74 5f 6d 6f 75 73 	imul   $0x6573756f,0x6d(%edi,%ebx,2),%esi
     c7d:	65 
     c7e:	3a 46 28             	cmp    0x28(%esi),%al
     c81:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c84:	38 29                	cmp    %ch,(%ecx)
     c86:	00 6d 6f             	add    %ch,0x6f(%ebp)
     c89:	75 73                	jne    cfe <bootmain-0x27f302>
     c8b:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     c8f:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     c92:	29 00                	sub    %eax,(%eax)
     c94:	62 67 3a             	bound  %esp,0x3a(%edi)
     c97:	70 28                	jo     cc1 <bootmain-0x27f33f>
     c99:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c9c:	29 00                	sub    %eax,(%eax)
     c9e:	63 75 72             	arpl   %si,0x72(%ebp)
     ca1:	73 6f                	jae    d12 <bootmain-0x27f2ee>
     ca3:	72 3a                	jb     cdf <bootmain-0x27f321>
     ca5:	56                   	push   %esi
     ca6:	28 30                	sub    %dh,(%eax)
     ca8:	2c 32                	sub    $0x32,%al
     caa:	31 29                	xor    %ebp,(%ecx)
     cac:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     cb1:	2c 35                	sub    $0x35,%al
     cb3:	29 3b                	sub    %edi,(%ebx)
     cb5:	30 3b                	xor    %bh,(%ebx)
     cb7:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     cbd:	32 32                	xor    (%edx),%dh
     cbf:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     cc5:	2c 35                	sub    $0x35,%al
     cc7:	29 3b                	sub    %edi,(%ebx)
     cc9:	30 3b                	xor    %bh,(%ebx)
     ccb:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     cd1:	32 29                	xor    (%ecx),%ch
     cd3:	00 78 3a             	add    %bh,0x3a(%eax)
     cd6:	72 28                	jb     d00 <bootmain-0x27f300>
     cd8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cdb:	29 00                	sub    %eax,(%eax)
     cdd:	62 67 3a             	bound  %esp,0x3a(%edi)
     ce0:	72 28                	jb     d0a <bootmain-0x27f2f6>
     ce2:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     ce5:	29 00                	sub    %eax,(%eax)
     ce7:	64 69 73 70 6c 61 79 	imul   $0x5f79616c,%fs:0x70(%ebx),%esi
     cee:	5f 
     cef:	6d                   	insl   (%dx),%es:(%edi)
     cf0:	6f                   	outsl  %ds:(%esi),(%dx)
     cf1:	75 73                	jne    d66 <bootmain-0x27f29a>
     cf3:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     cf7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cfa:	38 29                	cmp    %ch,(%ecx)
     cfc:	00 76 72             	add    %dh,0x72(%esi)
     cff:	61                   	popa   
     d00:	6d                   	insl   (%dx),%es:(%edi)
     d01:	3a 70 28             	cmp    0x28(%eax),%dh
     d04:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     d07:	29 00                	sub    %eax,(%eax)
     d09:	70 78                	jo     d83 <bootmain-0x27f27d>
     d0b:	73 69                	jae    d76 <bootmain-0x27f28a>
     d0d:	7a 65                	jp     d74 <bootmain-0x27f28c>
     d0f:	3a 70 28             	cmp    0x28(%eax),%dh
     d12:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d15:	29 00                	sub    %eax,(%eax)
     d17:	70 79                	jo     d92 <bootmain-0x27f26e>
     d19:	73 69                	jae    d84 <bootmain-0x27f27c>
     d1b:	7a 65                	jp     d82 <bootmain-0x27f27e>
     d1d:	3a 70 28             	cmp    0x28(%eax),%dh
     d20:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d23:	29 00                	sub    %eax,(%eax)
     d25:	70 78                	jo     d9f <bootmain-0x27f261>
     d27:	30 3a                	xor    %bh,(%edx)
     d29:	70 28                	jo     d53 <bootmain-0x27f2ad>
     d2b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d2e:	29 00                	sub    %eax,(%eax)
     d30:	70 79                	jo     dab <bootmain-0x27f255>
     d32:	30 3a                	xor    %bh,(%edx)
     d34:	70 28                	jo     d5e <bootmain-0x27f2a2>
     d36:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d39:	29 00                	sub    %eax,(%eax)
     d3b:	62 75 66             	bound  %esi,0x66(%ebp)
     d3e:	3a 70 28             	cmp    0x28(%eax),%dh
     d41:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     d44:	29 00                	sub    %eax,(%eax)
     d46:	62 78 73             	bound  %edi,0x73(%eax)
     d49:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     d50:	2c 31                	sub    $0x31,%al
     d52:	29 00                	sub    %eax,(%eax)
     d54:	79 3a                	jns    d90 <bootmain-0x27f270>
     d56:	72 28                	jb     d80 <bootmain-0x27f280>
     d58:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d5b:	29 00                	sub    %eax,(%eax)
     d5d:	6d                   	insl   (%dx),%es:(%edi)
     d5e:	61                   	popa   
     d5f:	6b 65 5f 77          	imul   $0x77,0x5f(%ebp),%esp
     d63:	69 6e 64 6f 77 38 3a 	imul   $0x3a38776f,0x64(%esi),%ebp
     d6a:	46                   	inc    %esi
     d6b:	28 30                	sub    %dh,(%eax)
     d6d:	2c 31                	sub    $0x31,%al
     d6f:	38 29                	cmp    %ch,(%ecx)
     d71:	00 62 75             	add    %ah,0x75(%edx)
     d74:	66                   	data16
     d75:	3a 70 28             	cmp    0x28(%eax),%dh
     d78:	34 2c                	xor    $0x2c,%al
     d7a:	38 29                	cmp    %ch,(%ecx)
     d7c:	00 79 73             	add    %bh,0x73(%ecx)
     d7f:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     d86:	2c 31                	sub    $0x31,%al
     d88:	29 00                	sub    %eax,(%eax)
     d8a:	74 69                	je     df5 <bootmain-0x27f20b>
     d8c:	74 6c                	je     dfa <bootmain-0x27f206>
     d8e:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     d92:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     d95:	29 00                	sub    %eax,(%eax)
     d97:	63 6c 6f 73          	arpl   %bp,0x73(%edi,%ebp,2)
     d9b:	65 62 74 6e 3a       	bound  %esi,%gs:0x3a(%esi,%ebp,2)
     da0:	56                   	push   %esi
     da1:	28 30                	sub    %dh,(%eax)
     da3:	2c 32                	sub    $0x32,%al
     da5:	33 29                	xor    (%ecx),%ebp
     da7:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     dac:	2c 35                	sub    $0x35,%al
     dae:	29 3b                	sub    %edi,(%ebx)
     db0:	30 3b                	xor    %bh,(%ebx)
     db2:	31 33                	xor    %esi,(%ebx)
     db4:	3b 28                	cmp    (%eax),%ebp
     db6:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     db9:	32 29                	xor    (%ecx),%ch
     dbb:	00 62 75             	add    %ah,0x75(%edx)
     dbe:	66                   	data16
     dbf:	3a 72 28             	cmp    0x28(%edx),%dh
     dc2:	34 2c                	xor    $0x2c,%al
     dc4:	38 29                	cmp    %ch,(%ecx)
     dc6:	00 78 73             	add    %bh,0x73(%eax)
     dc9:	69 7a 65 3a 72 28 30 	imul   $0x3028723a,0x65(%edx),%edi
     dd0:	2c 31                	sub    $0x31,%al
     dd2:	29 00                	sub    %eax,(%eax)
     dd4:	66 6f                	outsw  %ds:(%esi),(%dx)
     dd6:	6e                   	outsb  %ds:(%esi),(%dx)
     dd7:	74 2e                	je     e07 <bootmain-0x27f1f9>
     dd9:	63 00                	arpl   %ax,(%eax)
     ddb:	70 72                	jo     e4f <bootmain-0x27f1b1>
     ddd:	69 6e 74 2e 63 00 69 	imul   $0x6900632e,0x74(%esi),%ebp
     de4:	74 6f                	je     e55 <bootmain-0x27f1ab>
     de6:	61                   	popa   
     de7:	3a 46 28             	cmp    0x28(%esi),%al
     dea:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ded:	38 29                	cmp    %ch,(%ecx)
     def:	00 76 61             	add    %dh,0x61(%esi)
     df2:	6c                   	insb   (%dx),%es:(%edi)
     df3:	75 65                	jne    e5a <bootmain-0x27f1a6>
     df5:	3a 70 28             	cmp    0x28(%eax),%dh
     df8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     dfb:	29 00                	sub    %eax,(%eax)
     dfd:	74 6d                	je     e6c <bootmain-0x27f194>
     dff:	70 5f                	jo     e60 <bootmain-0x27f1a0>
     e01:	62 75 66             	bound  %esi,0x66(%ebp)
     e04:	3a 28                	cmp    (%eax),%ch
     e06:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e09:	39 29                	cmp    %ebp,(%ecx)
     e0b:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     e10:	2c 35                	sub    $0x35,%al
     e12:	29 3b                	sub    %edi,(%ebx)
     e14:	30 3b                	xor    %bh,(%ebx)
     e16:	39 3b                	cmp    %edi,(%ebx)
     e18:	28 30                	sub    %dh,(%eax)
     e1a:	2c 31                	sub    $0x31,%al
     e1c:	31 29                	xor    %ebp,(%ecx)
     e1e:	00 76 61             	add    %dh,0x61(%esi)
     e21:	6c                   	insb   (%dx),%es:(%edi)
     e22:	75 65                	jne    e89 <bootmain-0x27f177>
     e24:	3a 72 28             	cmp    0x28(%edx),%dh
     e27:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e2a:	29 00                	sub    %eax,(%eax)
     e2c:	78 74                	js     ea2 <bootmain-0x27f15e>
     e2e:	6f                   	outsl  %ds:(%esi),(%dx)
     e2f:	61                   	popa   
     e30:	3a 46 28             	cmp    0x28(%esi),%al
     e33:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e36:	38 29                	cmp    %ch,(%ecx)
     e38:	00 76 61             	add    %dh,0x61(%esi)
     e3b:	6c                   	insb   (%dx),%es:(%edi)
     e3c:	75 65                	jne    ea3 <bootmain-0x27f15d>
     e3e:	3a 70 28             	cmp    0x28(%eax),%dh
     e41:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     e44:	29 00                	sub    %eax,(%eax)
     e46:	74 6d                	je     eb5 <bootmain-0x27f14b>
     e48:	70 5f                	jo     ea9 <bootmain-0x27f157>
     e4a:	62 75 66             	bound  %esi,0x66(%ebp)
     e4d:	3a 28                	cmp    (%eax),%ch
     e4f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     e52:	30 29                	xor    %ch,(%ecx)
     e54:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     e59:	2c 35                	sub    $0x35,%al
     e5b:	29 3b                	sub    %edi,(%ebx)
     e5d:	30 3b                	xor    %bh,(%ebx)
     e5f:	32 39                	xor    (%ecx),%bh
     e61:	3b 28                	cmp    (%eax),%ebp
     e63:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e66:	31 29                	xor    %ebp,(%ecx)
     e68:	00 73 70             	add    %dh,0x70(%ebx)
     e6b:	72 69                	jb     ed6 <bootmain-0x27f12a>
     e6d:	6e                   	outsb  %ds:(%esi),(%dx)
     e6e:	74 66                	je     ed6 <bootmain-0x27f12a>
     e70:	3a 46 28             	cmp    0x28(%esi),%al
     e73:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e76:	38 29                	cmp    %ch,(%ecx)
     e78:	00 73 74             	add    %dh,0x74(%ebx)
     e7b:	72 3a                	jb     eb7 <bootmain-0x27f149>
     e7d:	70 28                	jo     ea7 <bootmain-0x27f159>
     e7f:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     e82:	29 00                	sub    %eax,(%eax)
     e84:	66 6f                	outsw  %ds:(%esi),(%dx)
     e86:	72 6d                	jb     ef5 <bootmain-0x27f10b>
     e88:	61                   	popa   
     e89:	74 3a                	je     ec5 <bootmain-0x27f13b>
     e8b:	70 28                	jo     eb5 <bootmain-0x27f14b>
     e8d:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     e90:	29 00                	sub    %eax,(%eax)
     e92:	76 61                	jbe    ef5 <bootmain-0x27f10b>
     e94:	72 3a                	jb     ed0 <bootmain-0x27f130>
     e96:	72 28                	jb     ec0 <bootmain-0x27f140>
     e98:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     e9b:	31 29                	xor    %ebp,(%ecx)
     e9d:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     ea2:	31 29                	xor    %ebp,(%ecx)
     ea4:	00 62 75             	add    %ah,0x75(%edx)
     ea7:	66                   	data16
     ea8:	66                   	data16
     ea9:	65                   	gs
     eaa:	72 3a                	jb     ee6 <bootmain-0x27f11a>
     eac:	28 30                	sub    %dh,(%eax)
     eae:	2c 32                	sub    $0x32,%al
     eb0:	32 29                	xor    (%ecx),%ch
     eb2:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     eb7:	2c 35                	sub    $0x35,%al
     eb9:	29 3b                	sub    %edi,(%ebx)
     ebb:	30 3b                	xor    %bh,(%ebx)
     ebd:	39 3b                	cmp    %edi,(%ebx)
     ebf:	28 30                	sub    %dh,(%eax)
     ec1:	2c 32                	sub    $0x32,%al
     ec3:	29 00                	sub    %eax,(%eax)
     ec5:	73 74                	jae    f3b <bootmain-0x27f0c5>
     ec7:	72 3a                	jb     f03 <bootmain-0x27f0fd>
     ec9:	72 28                	jb     ef3 <bootmain-0x27f10d>
     ecb:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     ece:	29 00                	sub    %eax,(%eax)
     ed0:	70 75                	jo     f47 <bootmain-0x27f0b9>
     ed2:	74 66                	je     f3a <bootmain-0x27f0c6>
     ed4:	6f                   	outsl  %ds:(%esi),(%dx)
     ed5:	6e                   	outsb  %ds:(%esi),(%dx)
     ed6:	74 38                	je     f10 <bootmain-0x27f0f0>
     ed8:	3a 46 28             	cmp    0x28(%esi),%al
     edb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ede:	38 29                	cmp    %ch,(%ecx)
     ee0:	00 78 3a             	add    %bh,0x3a(%eax)
     ee3:	70 28                	jo     f0d <bootmain-0x27f0f3>
     ee5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ee8:	29 00                	sub    %eax,(%eax)
     eea:	79 3a                	jns    f26 <bootmain-0x27f0da>
     eec:	70 28                	jo     f16 <bootmain-0x27f0ea>
     eee:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ef1:	29 00                	sub    %eax,(%eax)
     ef3:	66 6f                	outsw  %ds:(%esi),(%dx)
     ef5:	6e                   	outsb  %ds:(%esi),(%dx)
     ef6:	74 3a                	je     f32 <bootmain-0x27f0ce>
     ef8:	70 28                	jo     f22 <bootmain-0x27f0de>
     efa:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     efd:	29 00                	sub    %eax,(%eax)
     eff:	72 6f                	jb     f70 <bootmain-0x27f090>
     f01:	77 3a                	ja     f3d <bootmain-0x27f0c3>
     f03:	72 28                	jb     f2d <bootmain-0x27f0d3>
     f05:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f08:	29 00                	sub    %eax,(%eax)
     f0a:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     f0d:	3a 72 28             	cmp    0x28(%edx),%dh
     f10:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f13:	29 00                	sub    %eax,(%eax)
     f15:	70 75                	jo     f8c <bootmain-0x27f074>
     f17:	74 73                	je     f8c <bootmain-0x27f074>
     f19:	38 3a                	cmp    %bh,(%edx)
     f1b:	46                   	inc    %esi
     f1c:	28 30                	sub    %dh,(%eax)
     f1e:	2c 31                	sub    $0x31,%al
     f20:	38 29                	cmp    %ch,(%ecx)
     f22:	00 66 6f             	add    %ah,0x6f(%esi)
     f25:	6e                   	outsb  %ds:(%esi),(%dx)
     f26:	74 3a                	je     f62 <bootmain-0x27f09e>
     f28:	70 28                	jo     f52 <bootmain-0x27f0ae>
     f2a:	34 2c                	xor    $0x2c,%al
     f2c:	38 29                	cmp    %ch,(%ecx)
     f2e:	00 70 72             	add    %dh,0x72(%eax)
     f31:	69 6e 74 64 65 62 75 	imul   $0x75626564,0x74(%esi),%ebp
     f38:	67 3a 46 28          	cmp    0x28(%bp),%al
     f3c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f3f:	38 29                	cmp    %ch,(%ecx)
     f41:	00 69 3a             	add    %ch,0x3a(%ecx)
     f44:	70 28                	jo     f6e <bootmain-0x27f092>
     f46:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     f49:	29 00                	sub    %eax,(%eax)
     f4b:	78 3a                	js     f87 <bootmain-0x27f079>
     f4d:	70 28                	jo     f77 <bootmain-0x27f089>
     f4f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     f52:	29 00                	sub    %eax,(%eax)
     f54:	66 6f                	outsw  %ds:(%esi),(%dx)
     f56:	6e                   	outsb  %ds:(%esi),(%dx)
     f57:	74 3a                	je     f93 <bootmain-0x27f06d>
     f59:	28 30                	sub    %dh,(%eax)
     f5b:	2c 32                	sub    $0x32,%al
     f5d:	33 29                	xor    (%ecx),%ebp
     f5f:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     f64:	2c 35                	sub    $0x35,%al
     f66:	29 3b                	sub    %edi,(%ebx)
     f68:	30 3b                	xor    %bh,(%ebx)
     f6a:	32 39                	xor    (%ecx),%bh
     f6c:	3b 28                	cmp    (%eax),%ebp
     f6e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     f71:	29 00                	sub    %eax,(%eax)
     f73:	70 75                	jo     fea <bootmain-0x27f016>
     f75:	74 66                	je     fdd <bootmain-0x27f023>
     f77:	6f                   	outsl  %ds:(%esi),(%dx)
     f78:	6e                   	outsb  %ds:(%esi),(%dx)
     f79:	74 31                	je     fac <bootmain-0x27f054>
     f7b:	36 3a 46 28          	cmp    %ss:0x28(%esi),%al
     f7f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f82:	38 29                	cmp    %ch,(%ecx)
     f84:	00 66 6f             	add    %ah,0x6f(%esi)
     f87:	6e                   	outsb  %ds:(%esi),(%dx)
     f88:	74 3a                	je     fc4 <bootmain-0x27f03c>
     f8a:	70 28                	jo     fb4 <bootmain-0x27f04c>
     f8c:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     f8f:	34 29                	xor    $0x29,%al
     f91:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     f96:	39 29                	cmp    %ebp,(%ecx)
     f98:	00 70 75             	add    %dh,0x75(%eax)
     f9b:	74 73                	je     1010 <bootmain-0x27eff0>
     f9d:	31 36                	xor    %esi,(%esi)
     f9f:	3a 46 28             	cmp    0x28(%esi),%al
     fa2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fa5:	38 29                	cmp    %ch,(%ecx)
     fa7:	00 69 64             	add    %ch,0x64(%ecx)
     faa:	74 67                	je     1013 <bootmain-0x27efed>
     fac:	64                   	fs
     fad:	74 2e                	je     fdd <bootmain-0x27f023>
     faf:	63 00                	arpl   %ax,(%eax)
     fb1:	73 65                	jae    1018 <bootmain-0x27efe8>
     fb3:	74 67                	je     101c <bootmain-0x27efe4>
     fb5:	64                   	fs
     fb6:	74 3a                	je     ff2 <bootmain-0x27f00e>
     fb8:	46                   	inc    %esi
     fb9:	28 30                	sub    %dh,(%eax)
     fbb:	2c 31                	sub    $0x31,%al
     fbd:	38 29                	cmp    %ch,(%ecx)
     fbf:	00 73 64             	add    %dh,0x64(%ebx)
     fc2:	3a 70 28             	cmp    0x28(%eax),%dh
     fc5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fc8:	39 29                	cmp    %ebp,(%ecx)
     fca:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     fcf:	33 29                	xor    (%ecx),%ebp
     fd1:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
     fd5:	69 74 3a 70 28 30 2c 	imul   $0x342c3028,0x70(%edx,%edi,1),%esi
     fdc:	34 
     fdd:	29 00                	sub    %eax,(%eax)
     fdf:	62 61 73             	bound  %esp,0x73(%ecx)
     fe2:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     fe6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fe9:	29 00                	sub    %eax,(%eax)
     feb:	61                   	popa   
     fec:	63 63 65             	arpl   %sp,0x65(%ebx)
     fef:	73 73                	jae    1064 <bootmain-0x27ef9c>
     ff1:	3a 70 28             	cmp    0x28(%eax),%dh
     ff4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ff7:	29 00                	sub    %eax,(%eax)
     ff9:	73 64                	jae    105f <bootmain-0x27efa1>
     ffb:	3a 72 28             	cmp    0x28(%edx),%dh
     ffe:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1001:	39 29                	cmp    %ebp,(%ecx)
    1003:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
    1007:	69 74 3a 72 28 30 2c 	imul   $0x342c3028,0x72(%edx,%edi,1),%esi
    100e:	34 
    100f:	29 00                	sub    %eax,(%eax)
    1011:	62 61 73             	bound  %esp,0x73(%ecx)
    1014:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
    1018:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    101b:	29 00                	sub    %eax,(%eax)
    101d:	61                   	popa   
    101e:	63 63 65             	arpl   %sp,0x65(%ebx)
    1021:	73 73                	jae    1096 <bootmain-0x27ef6a>
    1023:	3a 72 28             	cmp    0x28(%edx),%dh
    1026:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1029:	29 00                	sub    %eax,(%eax)
    102b:	73 65                	jae    1092 <bootmain-0x27ef6e>
    102d:	74 69                	je     1098 <bootmain-0x27ef68>
    102f:	64                   	fs
    1030:	74 3a                	je     106c <bootmain-0x27ef94>
    1032:	46                   	inc    %esi
    1033:	28 30                	sub    %dh,(%eax)
    1035:	2c 31                	sub    $0x31,%al
    1037:	38 29                	cmp    %ch,(%ecx)
    1039:	00 67 64             	add    %ah,0x64(%edi)
    103c:	3a 70 28             	cmp    0x28(%eax),%dh
    103f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1042:	30 29                	xor    %ch,(%ecx)
    1044:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    1049:	34 29                	xor    $0x29,%al
    104b:	00 6f 66             	add    %ch,0x66(%edi)
    104e:	66                   	data16
    104f:	73 65                	jae    10b6 <bootmain-0x27ef4a>
    1051:	74 3a                	je     108d <bootmain-0x27ef73>
    1053:	70 28                	jo     107d <bootmain-0x27ef83>
    1055:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1058:	29 00                	sub    %eax,(%eax)
    105a:	73 65                	jae    10c1 <bootmain-0x27ef3f>
    105c:	6c                   	insb   (%dx),%es:(%edi)
    105d:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
    1062:	3a 70 28             	cmp    0x28(%eax),%dh
    1065:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1068:	29 00                	sub    %eax,(%eax)
    106a:	67 64 3a 72 28       	cmp    %fs:0x28(%bp,%si),%dh
    106f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1072:	30 29                	xor    %ch,(%ecx)
    1074:	00 6f 66             	add    %ch,0x66(%edi)
    1077:	66                   	data16
    1078:	73 65                	jae    10df <bootmain-0x27ef21>
    107a:	74 3a                	je     10b6 <bootmain-0x27ef4a>
    107c:	72 28                	jb     10a6 <bootmain-0x27ef5a>
    107e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1081:	29 00                	sub    %eax,(%eax)
    1083:	73 65                	jae    10ea <bootmain-0x27ef16>
    1085:	6c                   	insb   (%dx),%es:(%edi)
    1086:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
    108b:	3a 72 28             	cmp    0x28(%edx),%dh
    108e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1091:	29 00                	sub    %eax,(%eax)
    1093:	69 6e 69 74 5f 67 64 	imul   $0x64675f74,0x69(%esi),%ebp
    109a:	74 69                	je     1105 <bootmain-0x27eefb>
    109c:	64                   	fs
    109d:	74 3a                	je     10d9 <bootmain-0x27ef27>
    109f:	46                   	inc    %esi
    10a0:	28 30                	sub    %dh,(%eax)
    10a2:	2c 31                	sub    $0x31,%al
    10a4:	38 29                	cmp    %ch,(%ecx)
    10a6:	00 69 6e             	add    %ch,0x6e(%ecx)
    10a9:	74 2e                	je     10d9 <bootmain-0x27ef27>
    10ab:	63 00                	arpl   %ax,(%eax)
    10ad:	69 6e 69 74 5f 70 69 	imul   $0x69705f74,0x69(%esi),%ebp
    10b4:	63 3a                	arpl   %di,(%edx)
    10b6:	46                   	inc    %esi
    10b7:	28 30                	sub    %dh,(%eax)
    10b9:	2c 31                	sub    $0x31,%al
    10bb:	38 29                	cmp    %ch,(%ecx)
    10bd:	00 69 6e             	add    %ch,0x6e(%ecx)
    10c0:	74 68                	je     112a <bootmain-0x27eed6>
    10c2:	61                   	popa   
    10c3:	6e                   	outsb  %ds:(%esi),(%dx)
    10c4:	64                   	fs
    10c5:	6c                   	insb   (%dx),%es:(%edi)
    10c6:	65                   	gs
    10c7:	72 32                	jb     10fb <bootmain-0x27ef05>
    10c9:	31 3a                	xor    %edi,(%edx)
    10cb:	46                   	inc    %esi
    10cc:	28 30                	sub    %dh,(%eax)
    10ce:	2c 31                	sub    $0x31,%al
    10d0:	38 29                	cmp    %ch,(%ecx)
    10d2:	00 65 73             	add    %ah,0x73(%ebp)
    10d5:	70 3a                	jo     1111 <bootmain-0x27eeef>
    10d7:	70 28                	jo     1101 <bootmain-0x27eeff>
    10d9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    10dc:	39 29                	cmp    %ebp,(%ecx)
    10de:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
    10e3:	31 29                	xor    %ebp,(%ecx)
    10e5:	00 69 6e             	add    %ch,0x6e(%ecx)
    10e8:	74 68                	je     1152 <bootmain-0x27eeae>
    10ea:	61                   	popa   
    10eb:	6e                   	outsb  %ds:(%esi),(%dx)
    10ec:	64                   	fs
    10ed:	6c                   	insb   (%dx),%es:(%edi)
    10ee:	65                   	gs
    10ef:	72 32                	jb     1123 <bootmain-0x27eedd>
    10f1:	63 3a                	arpl   %di,(%edx)
    10f3:	46                   	inc    %esi
    10f4:	28 30                	sub    %dh,(%eax)
    10f6:	2c 31                	sub    $0x31,%al
    10f8:	38 29                	cmp    %ch,(%ecx)
    10fa:	00 65 73             	add    %ah,0x73(%ebp)
    10fd:	70 3a                	jo     1139 <bootmain-0x27eec7>
    10ff:	70 28                	jo     1129 <bootmain-0x27eed7>
    1101:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1104:	39 29                	cmp    %ebp,(%ecx)
    1106:	00 77 61             	add    %dh,0x61(%edi)
    1109:	69 74 5f 4b 42 43 5f 	imul   $0x735f4342,0x4b(%edi,%ebx,2),%esi
    1110:	73 
    1111:	65 6e                	outsb  %gs:(%esi),(%dx)
    1113:	64                   	fs
    1114:	72 65                	jb     117b <bootmain-0x27ee85>
    1116:	61                   	popa   
    1117:	64                   	fs
    1118:	79 3a                	jns    1154 <bootmain-0x27eeac>
    111a:	46                   	inc    %esi
    111b:	28 30                	sub    %dh,(%eax)
    111d:	2c 31                	sub    $0x31,%al
    111f:	38 29                	cmp    %ch,(%ecx)
    1121:	00 69 6e             	add    %ch,0x6e(%ecx)
    1124:	69 74 5f 6b 65 79 62 	imul   $0x6f627965,0x6b(%edi,%ebx,2),%esi
    112b:	6f 
    112c:	61                   	popa   
    112d:	72 64                	jb     1193 <bootmain-0x27ee6d>
    112f:	3a 46 28             	cmp    0x28(%esi),%al
    1132:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1135:	38 29                	cmp    %ch,(%ecx)
    1137:	00 6b 65             	add    %ch,0x65(%ebx)
    113a:	79 66                	jns    11a2 <bootmain-0x27ee5e>
    113c:	69 66 6f 3a 47 28 31 	imul   $0x3128473a,0x6f(%esi),%esp
    1143:	2c 35                	sub    $0x35,%al
    1145:	29 00                	sub    %eax,(%eax)
    1147:	6d                   	insl   (%dx),%es:(%edi)
    1148:	6f                   	outsl  %ds:(%esi),(%dx)
    1149:	75 73                	jne    11be <bootmain-0x27ee42>
    114b:	65 66 69 66 6f 3a 47 	imul   $0x473a,%gs:0x6f(%esi),%sp
    1152:	28 31                	sub    %dh,(%ecx)
    1154:	2c 35                	sub    $0x35,%al
    1156:	29 00                	sub    %eax,(%eax)
    1158:	2f                   	das    
    1159:	74 6d                	je     11c8 <bootmain-0x27ee38>
    115b:	70 2f                	jo     118c <bootmain-0x27ee74>
    115d:	63 63 6b             	arpl   %sp,0x6b(%ebx)
    1160:	69 76 50 32 74 2e 73 	imul   $0x732e7432,0x50(%esi),%esi
    1167:	00 61 73             	add    %ah,0x73(%ecx)
    116a:	6d                   	insl   (%dx),%es:(%edi)
    116b:	69 6e 74 33 32 2e 53 	imul   $0x532e3233,0x74(%esi),%ebp
    1172:	00 66 69             	add    %ah,0x69(%esi)
    1175:	66 6f                	outsw  %ds:(%esi),(%dx)
    1177:	2e 63 00             	arpl   %ax,%cs:(%eax)
    117a:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    1180:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    1187:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    118a:	38 29                	cmp    %ch,(%ecx)
    118c:	00 66 69             	add    %ah,0x69(%esi)
    118f:	66 6f                	outsw  %ds:(%esi),(%dx)
    1191:	3a 70 28             	cmp    0x28(%eax),%dh
    1194:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1197:	39 29                	cmp    %ebp,(%ecx)
    1199:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    119e:	35 29 00 73 69       	xor    $0x69730029,%eax
    11a3:	7a 65                	jp     120a <bootmain-0x27edf6>
    11a5:	3a 70 28             	cmp    0x28(%eax),%dh
    11a8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11ab:	29 00                	sub    %eax,(%eax)
    11ad:	66 69 66 6f 3a 72    	imul   $0x723a,0x6f(%esi),%sp
    11b3:	28 30                	sub    %dh,(%eax)
    11b5:	2c 31                	sub    $0x31,%al
    11b7:	39 29                	cmp    %ebp,(%ecx)
    11b9:	00 73 69             	add    %dh,0x69(%ebx)
    11bc:	7a 65                	jp     1223 <bootmain-0x27eddd>
    11be:	3a 72 28             	cmp    0x28(%edx),%dh
    11c1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11c4:	29 00                	sub    %eax,(%eax)
    11c6:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    11cc:	77 72                	ja     1240 <bootmain-0x27edc0>
    11ce:	69 74 65 3a 46 28 30 	imul   $0x2c302846,0x3a(%ebp,%eiz,2),%esi
    11d5:	2c 
    11d6:	31 29                	xor    %ebp,(%ecx)
    11d8:	00 66 69             	add    %ah,0x69(%esi)
    11db:	66 6f                	outsw  %ds:(%esi),(%dx)
    11dd:	3a 70 28             	cmp    0x28(%eax),%dh
    11e0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11e3:	39 29                	cmp    %ebp,(%ecx)
    11e5:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
    11e9:	61                   	popa   
    11ea:	3a 70 28             	cmp    0x28(%eax),%dh
    11ed:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11f0:	29 00                	sub    %eax,(%eax)
    11f2:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    11f8:	72 65                	jb     125f <bootmain-0x27eda1>
    11fa:	61                   	popa   
    11fb:	64 3a 46 28          	cmp    %fs:0x28(%esi),%al
    11ff:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1202:	29 00                	sub    %eax,(%eax)
    1204:	64                   	fs
    1205:	61                   	popa   
    1206:	74 61                	je     1269 <bootmain-0x27ed97>
    1208:	3a 72 28             	cmp    0x28(%edx),%dh
    120b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    120e:	29 00                	sub    %eax,(%eax)
    1210:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    1216:	73 74                	jae    128c <bootmain-0x27ed74>
    1218:	61                   	popa   
    1219:	74 75                	je     1290 <bootmain-0x27ed70>
    121b:	73 3a                	jae    1257 <bootmain-0x27eda9>
    121d:	46                   	inc    %esi
    121e:	28 30                	sub    %dh,(%eax)
    1220:	2c 31                	sub    $0x31,%al
    1222:	29 00                	sub    %eax,(%eax)
    1224:	6d                   	insl   (%dx),%es:(%edi)
    1225:	6f                   	outsl  %ds:(%esi),(%dx)
    1226:	75 73                	jne    129b <bootmain-0x27ed65>
    1228:	65 2e 63 00          	gs arpl %ax,%cs:%gs:(%eax)
    122c:	65 6e                	outsb  %gs:(%esi),(%dx)
    122e:	61                   	popa   
    122f:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
    1233:	6d                   	insl   (%dx),%es:(%edi)
    1234:	6f                   	outsl  %ds:(%esi),(%dx)
    1235:	75 73                	jne    12aa <bootmain-0x27ed56>
    1237:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    123b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    123e:	38 29                	cmp    %ch,(%ecx)
    1240:	00 6d 64             	add    %ch,0x64(%ebp)
    1243:	65 63 3a             	arpl   %di,%gs:(%edx)
    1246:	70 28                	jo     1270 <bootmain-0x27ed90>
    1248:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    124b:	39 29                	cmp    %ebp,(%ecx)
    124d:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    1252:	36 29 00             	sub    %eax,%ss:(%eax)
    1255:	6d                   	insl   (%dx),%es:(%edi)
    1256:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
    125a:	72 28                	jb     1284 <bootmain-0x27ed7c>
    125c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    125f:	39 29                	cmp    %ebp,(%ecx)
    1261:	00 6d 6f             	add    %ch,0x6f(%ebp)
    1264:	75 73                	jne    12d9 <bootmain-0x27ed27>
    1266:	65                   	gs
    1267:	5f                   	pop    %edi
    1268:	64 65 63 6f 64       	fs arpl %bp,%fs:%gs:0x64(%edi)
    126d:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    1271:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1274:	29 00                	sub    %eax,(%eax)
    1276:	6d                   	insl   (%dx),%es:(%edi)
    1277:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
    127b:	70 28                	jo     12a5 <bootmain-0x27ed5b>
    127d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1280:	39 29                	cmp    %ebp,(%ecx)
    1282:	00 6d 6d             	add    %ch,0x6d(%ebp)
    1285:	2e 63 00             	arpl   %ax,%cs:(%eax)
    1288:	67                   	addr16
    1289:	65                   	gs
    128a:	74 6d                	je     12f9 <bootmain-0x27ed07>
    128c:	65                   	gs
    128d:	6d                   	insl   (%dx),%es:(%edi)
    128e:	6f                   	outsl  %ds:(%esi),(%dx)
    128f:	72 79                	jb     130a <bootmain-0x27ecf6>
    1291:	73 69                	jae    12fc <bootmain-0x27ed04>
    1293:	7a 65                	jp     12fa <bootmain-0x27ed06>
    1295:	3a 46 28             	cmp    0x28(%esi),%al
    1298:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    129b:	29 00                	sub    %eax,(%eax)
    129d:	73 74                	jae    1313 <bootmain-0x27eced>
    129f:	61                   	popa   
    12a0:	72 74                	jb     1316 <bootmain-0x27ecea>
    12a2:	3a 70 28             	cmp    0x28(%eax),%dh
    12a5:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12a8:	29 00                	sub    %eax,(%eax)
    12aa:	65 6e                	outsb  %gs:(%esi),(%dx)
    12ac:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
    12b0:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12b3:	29 00                	sub    %eax,(%eax)
    12b5:	6f                   	outsl  %ds:(%esi),(%dx)
    12b6:	6c                   	insb   (%dx),%es:(%edi)
    12b7:	64 3a 72 28          	cmp    %fs:0x28(%edx),%dh
    12bb:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12be:	29 00                	sub    %eax,(%eax)
    12c0:	70 3a                	jo     12fc <bootmain-0x27ed04>
    12c2:	72 28                	jb     12ec <bootmain-0x27ed14>
    12c4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    12c7:	39 29                	cmp    %ebp,(%ecx)
    12c9:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
    12ce:	34 29                	xor    $0x29,%al
    12d0:	00 73 74             	add    %dh,0x74(%ebx)
    12d3:	61                   	popa   
    12d4:	72 74                	jb     134a <bootmain-0x27ecb6>
    12d6:	3a 72 28             	cmp    0x28(%edx),%dh
    12d9:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12dc:	29 00                	sub    %eax,(%eax)
    12de:	6d                   	insl   (%dx),%es:(%edi)
    12df:	65                   	gs
    12e0:	6d                   	insl   (%dx),%es:(%edi)
    12e1:	74 65                	je     1348 <bootmain-0x27ecb8>
    12e3:	73 74                	jae    1359 <bootmain-0x27eca7>
    12e5:	3a 46 28             	cmp    0x28(%esi),%al
    12e8:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12eb:	29 00                	sub    %eax,(%eax)
    12ed:	66                   	data16
    12ee:	6c                   	insb   (%dx),%es:(%edi)
    12ef:	67 34 38             	addr16 xor $0x38,%al
    12f2:	36 3a 72 28          	cmp    %ss:0x28(%edx),%dh
    12f6:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    12f9:	29 00                	sub    %eax,(%eax)
    12fb:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
    1301:	34 29                	xor    $0x29,%al
    1303:	00 6d 65             	add    %ch,0x65(%ebp)
    1306:	6d                   	insl   (%dx),%es:(%edi)
    1307:	6d                   	insl   (%dx),%es:(%edi)
    1308:	61                   	popa   
    1309:	6e                   	outsb  %ds:(%esi),(%dx)
    130a:	5f                   	pop    %edi
    130b:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    1312:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1315:	38 29                	cmp    %ch,(%ecx)
    1317:	00 6d 61             	add    %ch,0x61(%ebp)
    131a:	6e                   	outsb  %ds:(%esi),(%dx)
    131b:	3a 70 28             	cmp    0x28(%eax),%dh
    131e:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1321:	30 29                	xor    %ch,(%ecx)
    1323:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    1328:	36 29 00             	sub    %eax,%ss:(%eax)
    132b:	6d                   	insl   (%dx),%es:(%edi)
    132c:	61                   	popa   
    132d:	6e                   	outsb  %ds:(%esi),(%dx)
    132e:	3a 72 28             	cmp    0x28(%edx),%dh
    1331:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1334:	30 29                	xor    %ch,(%ecx)
    1336:	00 6d 65             	add    %ch,0x65(%ebp)
    1339:	6d                   	insl   (%dx),%es:(%edi)
    133a:	6d                   	insl   (%dx),%es:(%edi)
    133b:	61                   	popa   
    133c:	6e                   	outsb  %ds:(%esi),(%dx)
    133d:	5f                   	pop    %edi
    133e:	61                   	popa   
    133f:	76 61                	jbe    13a2 <bootmain-0x27ec5e>
    1341:	69 6c 3a 46 28 30 2c 	imul   $0x342c3028,0x46(%edx,%edi,1),%ebp
    1348:	34 
    1349:	29 00                	sub    %eax,(%eax)
    134b:	6d                   	insl   (%dx),%es:(%edi)
    134c:	61                   	popa   
    134d:	6e                   	outsb  %ds:(%esi),(%dx)
    134e:	3a 70 28             	cmp    0x28(%eax),%dh
    1351:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1354:	30 29                	xor    %ch,(%ecx)
    1356:	00 66 72             	add    %ah,0x72(%esi)
    1359:	65                   	gs
    135a:	65                   	gs
    135b:	6d                   	insl   (%dx),%es:(%edi)
    135c:	65                   	gs
    135d:	6d                   	insl   (%dx),%es:(%edi)
    135e:	3a 72 28             	cmp    0x28(%edx),%dh
    1361:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1364:	29 00                	sub    %eax,(%eax)
    1366:	6d                   	insl   (%dx),%es:(%edi)
    1367:	65                   	gs
    1368:	6d                   	insl   (%dx),%es:(%edi)
    1369:	6d                   	insl   (%dx),%es:(%edi)
    136a:	61                   	popa   
    136b:	6e                   	outsb  %ds:(%esi),(%dx)
    136c:	5f                   	pop    %edi
    136d:	61                   	popa   
    136e:	6c                   	insb   (%dx),%es:(%edi)
    136f:	6c                   	insb   (%dx),%es:(%edi)
    1370:	6f                   	outsl  %ds:(%esi),(%dx)
    1371:	63 3a                	arpl   %di,(%edx)
    1373:	46                   	inc    %esi
    1374:	28 30                	sub    %dh,(%eax)
    1376:	2c 31                	sub    $0x31,%al
    1378:	29 00                	sub    %eax,(%eax)
    137a:	73 69                	jae    13e5 <bootmain-0x27ec1b>
    137c:	7a 65                	jp     13e3 <bootmain-0x27ec1d>
    137e:	3a 70 28             	cmp    0x28(%eax),%dh
    1381:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1384:	29 00                	sub    %eax,(%eax)
    1386:	61                   	popa   
    1387:	3a 72 28             	cmp    0x28(%edx),%dh
    138a:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    138d:	29 00                	sub    %eax,(%eax)
    138f:	6d                   	insl   (%dx),%es:(%edi)
    1390:	65                   	gs
    1391:	6d                   	insl   (%dx),%es:(%edi)
    1392:	6d                   	insl   (%dx),%es:(%edi)
    1393:	61                   	popa   
    1394:	6e                   	outsb  %ds:(%esi),(%dx)
    1395:	5f                   	pop    %edi
    1396:	61                   	popa   
    1397:	6c                   	insb   (%dx),%es:(%edi)
    1398:	6c                   	insb   (%dx),%es:(%edi)
    1399:	6f                   	outsl  %ds:(%esi),(%dx)
    139a:	63 5f 34             	arpl   %bx,0x34(%edi)
    139d:	4b                   	dec    %ebx
    139e:	3a 46 28             	cmp    0x28(%esi),%al
    13a1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    13a4:	29 00                	sub    %eax,(%eax)
    13a6:	6d                   	insl   (%dx),%es:(%edi)
    13a7:	65                   	gs
    13a8:	6d                   	insl   (%dx),%es:(%edi)
    13a9:	6d                   	insl   (%dx),%es:(%edi)
    13aa:	61                   	popa   
    13ab:	6e                   	outsb  %ds:(%esi),(%dx)
    13ac:	5f                   	pop    %edi
    13ad:	66                   	data16
    13ae:	72 65                	jb     1415 <bootmain-0x27ebeb>
    13b0:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    13b4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    13b7:	29 00                	sub    %eax,(%eax)
    13b9:	61                   	popa   
    13ba:	64                   	fs
    13bb:	64                   	fs
    13bc:	72 3a                	jb     13f8 <bootmain-0x27ec08>
    13be:	70 28                	jo     13e8 <bootmain-0x27ec18>
    13c0:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    13c3:	29 00                	sub    %eax,(%eax)
    13c5:	73 69                	jae    1430 <bootmain-0x27ebd0>
    13c7:	7a 65                	jp     142e <bootmain-0x27ebd2>
    13c9:	3a 72 28             	cmp    0x28(%edx),%dh
    13cc:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    13cf:	29 00                	sub    %eax,(%eax)
    13d1:	6d                   	insl   (%dx),%es:(%edi)
    13d2:	65                   	gs
    13d3:	6d                   	insl   (%dx),%es:(%edi)
    13d4:	6d                   	insl   (%dx),%es:(%edi)
    13d5:	61                   	popa   
    13d6:	6e                   	outsb  %ds:(%esi),(%dx)
    13d7:	5f                   	pop    %edi
    13d8:	66                   	data16
    13d9:	72 65                	jb     1440 <bootmain-0x27ebc0>
    13db:	65                   	gs
    13dc:	5f                   	pop    %edi
    13dd:	34 6b                	xor    $0x6b,%al
    13df:	3a 46 28             	cmp    0x28(%esi),%al
    13e2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    13e5:	29 00                	sub    %eax,(%eax)
    13e7:	61                   	popa   
    13e8:	64                   	fs
    13e9:	64                   	fs
    13ea:	72 3a                	jb     1426 <bootmain-0x27ebda>
    13ec:	72 28                	jb     1416 <bootmain-0x27ebea>
    13ee:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    13f1:	29 00                	sub    %eax,(%eax)
    13f3:	73 68                	jae    145d <bootmain-0x27eba3>
    13f5:	74 63                	je     145a <bootmain-0x27eba6>
    13f7:	74 6c                	je     1465 <bootmain-0x27eb9b>
    13f9:	5f                   	pop    %edi
    13fa:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    1401:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1404:	31 29                	xor    %ebp,(%ecx)
    1406:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    140b:	31 35 29 00 6d 65    	xor    %esi,0x656d0029
    1411:	6d                   	insl   (%dx),%es:(%edi)
    1412:	6d                   	insl   (%dx),%es:(%edi)
    1413:	61                   	popa   
    1414:	6e                   	outsb  %ds:(%esi),(%dx)
    1415:	3a 70 28             	cmp    0x28(%eax),%dh
    1418:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    141b:	30 29                	xor    %ch,(%ecx)
    141d:	00 76 72             	add    %dh,0x72(%esi)
    1420:	61                   	popa   
    1421:	6d                   	insl   (%dx),%es:(%edi)
    1422:	3a 70 28             	cmp    0x28(%eax),%dh
    1425:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    1428:	29 00                	sub    %eax,(%eax)
    142a:	63 74 6c 3a          	arpl   %si,0x3a(%esp,%ebp,2)
    142e:	72 28                	jb     1458 <bootmain-0x27eba8>
    1430:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1433:	31 29                	xor    %ebp,(%ecx)
    1435:	00 6d 65             	add    %ch,0x65(%ebp)
    1438:	6d                   	insl   (%dx),%es:(%edi)
    1439:	6d                   	insl   (%dx),%es:(%edi)
    143a:	61                   	popa   
    143b:	6e                   	outsb  %ds:(%esi),(%dx)
    143c:	3a 72 28             	cmp    0x28(%edx),%dh
    143f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1442:	30 29                	xor    %ch,(%ecx)
    1444:	00 76 72             	add    %dh,0x72(%esi)
    1447:	61                   	popa   
    1448:	6d                   	insl   (%dx),%es:(%edi)
    1449:	3a 72 28             	cmp    0x28(%edx),%dh
    144c:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    144f:	29 00                	sub    %eax,(%eax)
    1451:	73 68                	jae    14bb <bootmain-0x27eb45>
    1453:	65                   	gs
    1454:	65                   	gs
    1455:	74 5f                	je     14b6 <bootmain-0x27eb4a>
    1457:	61                   	popa   
    1458:	6c                   	insb   (%dx),%es:(%edi)
    1459:	6c                   	insb   (%dx),%es:(%edi)
    145a:	6f                   	outsl  %ds:(%esi),(%dx)
    145b:	63 3a                	arpl   %di,(%edx)
    145d:	46                   	inc    %esi
    145e:	28 31                	sub    %dh,(%ecx)
    1460:	2c 31                	sub    $0x31,%al
    1462:	34 29                	xor    $0x29,%al
    1464:	00 63 74             	add    %ah,0x74(%ebx)
    1467:	6c                   	insb   (%dx),%es:(%edi)
    1468:	3a 70 28             	cmp    0x28(%eax),%dh
    146b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    146e:	31 29                	xor    %ebp,(%ecx)
    1470:	00 73 68             	add    %dh,0x68(%ebx)
    1473:	74 3a                	je     14af <bootmain-0x27eb51>
    1475:	72 28                	jb     149f <bootmain-0x27eb61>
    1477:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
    147a:	34 29                	xor    $0x29,%al
    147c:	00 73 68             	add    %dh,0x68(%ebx)
    147f:	65                   	gs
    1480:	65                   	gs
    1481:	74 5f                	je     14e2 <bootmain-0x27eb1e>
    1483:	73 65                	jae    14ea <bootmain-0x27eb16>
    1485:	74 62                	je     14e9 <bootmain-0x27eb17>
    1487:	75 66                	jne    14ef <bootmain-0x27eb11>
    1489:	3a 46 28             	cmp    0x28(%esi),%al
    148c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    148f:	38 29                	cmp    %ch,(%ecx)
    1491:	00 73 68             	add    %dh,0x68(%ebx)
    1494:	74 3a                	je     14d0 <bootmain-0x27eb30>
    1496:	70 28                	jo     14c0 <bootmain-0x27eb40>
    1498:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
    149b:	34 29                	xor    $0x29,%al
    149d:	00 62 75             	add    %ah,0x75(%edx)
    14a0:	66                   	data16
    14a1:	3a 70 28             	cmp    0x28(%eax),%dh
    14a4:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    14a7:	29 00                	sub    %eax,(%eax)
    14a9:	63 6f 6c             	arpl   %bp,0x6c(%edi)
    14ac:	5f                   	pop    %edi
    14ad:	69 6e 76 3a 70 28 30 	imul   $0x3028703a,0x76(%esi),%ebp
    14b4:	2c 31                	sub    $0x31,%al
    14b6:	29 00                	sub    %eax,(%eax)
    14b8:	62 75 66             	bound  %esi,0x66(%ebp)
    14bb:	3a 72 28             	cmp    0x28(%edx),%dh
    14be:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    14c1:	29 00                	sub    %eax,(%eax)
    14c3:	79 73                	jns    1538 <bootmain-0x27eac8>
    14c5:	69 7a 65 3a 72 28 30 	imul   $0x3028723a,0x65(%edx),%edi
    14cc:	2c 31                	sub    $0x31,%al
    14ce:	29 00                	sub    %eax,(%eax)
    14d0:	63 6f 6c             	arpl   %bp,0x6c(%edi)
    14d3:	5f                   	pop    %edi
    14d4:	69 6e 76 3a 72 28 30 	imul   $0x3028723a,0x76(%esi),%ebp
    14db:	2c 31                	sub    $0x31,%al
    14dd:	29 00                	sub    %eax,(%eax)
    14df:	73 68                	jae    1549 <bootmain-0x27eab7>
    14e1:	65                   	gs
    14e2:	65                   	gs
    14e3:	74 5f                	je     1544 <bootmain-0x27eabc>
    14e5:	72 65                	jb     154c <bootmain-0x27eab4>
    14e7:	66                   	data16
    14e8:	72 65                	jb     154f <bootmain-0x27eab1>
    14ea:	73 68                	jae    1554 <bootmain-0x27eaac>
    14ec:	73 75                	jae    1563 <bootmain-0x27ea9d>
    14ee:	62 3a                	bound  %edi,(%edx)
    14f0:	46                   	inc    %esi
    14f1:	28 30                	sub    %dh,(%eax)
    14f3:	2c 31                	sub    $0x31,%al
    14f5:	38 29                	cmp    %ch,(%ecx)
    14f7:	00 76 78             	add    %dh,0x78(%esi)
    14fa:	30 3a                	xor    %bh,(%edx)
    14fc:	70 28                	jo     1526 <bootmain-0x27eada>
    14fe:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1501:	29 00                	sub    %eax,(%eax)
    1503:	76 79                	jbe    157e <bootmain-0x27ea82>
    1505:	30 3a                	xor    %bh,(%edx)
    1507:	70 28                	jo     1531 <bootmain-0x27eacf>
    1509:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    150c:	29 00                	sub    %eax,(%eax)
    150e:	76 78                	jbe    1588 <bootmain-0x27ea78>
    1510:	31 3a                	xor    %edi,(%edx)
    1512:	70 28                	jo     153c <bootmain-0x27eac4>
    1514:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1517:	29 00                	sub    %eax,(%eax)
    1519:	76 79                	jbe    1594 <bootmain-0x27ea6c>
    151b:	31 3a                	xor    %edi,(%edx)
    151d:	70 28                	jo     1547 <bootmain-0x27eab9>
    151f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1522:	29 00                	sub    %eax,(%eax)
    1524:	6c                   	insb   (%dx),%es:(%edi)
    1525:	61                   	popa   
    1526:	79 65                	jns    158d <bootmain-0x27ea73>
    1528:	72 3a                	jb     1564 <bootmain-0x27ea9c>
    152a:	70 28                	jo     1554 <bootmain-0x27eaac>
    152c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    152f:	29 00                	sub    %eax,(%eax)
    1531:	6c                   	insb   (%dx),%es:(%edi)
    1532:	61                   	popa   
    1533:	79 65                	jns    159a <bootmain-0x27ea66>
    1535:	72 65                	jb     159c <bootmain-0x27ea64>
    1537:	6e                   	outsb  %ds:(%esi),(%dx)
    1538:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
    153c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    153f:	29 00                	sub    %eax,(%eax)
    1541:	76 78                	jbe    15bb <bootmain-0x27ea45>
    1543:	31 3a                	xor    %edi,(%edx)
    1545:	72 28                	jb     156f <bootmain-0x27ea91>
    1547:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    154a:	29 00                	sub    %eax,(%eax)
    154c:	76 79                	jbe    15c7 <bootmain-0x27ea39>
    154e:	31 3a                	xor    %edi,(%edx)
    1550:	72 28                	jb     157a <bootmain-0x27ea86>
    1552:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1555:	29 00                	sub    %eax,(%eax)
    1557:	73 68                	jae    15c1 <bootmain-0x27ea3f>
    1559:	65                   	gs
    155a:	65                   	gs
    155b:	74 5f                	je     15bc <bootmain-0x27ea44>
    155d:	72 65                	jb     15c4 <bootmain-0x27ea3c>
    155f:	66                   	data16
    1560:	72 65                	jb     15c7 <bootmain-0x27ea39>
    1562:	73 68                	jae    15cc <bootmain-0x27ea34>
    1564:	3a 46 28             	cmp    0x28(%esi),%al
    1567:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    156a:	38 29                	cmp    %ch,(%ecx)
    156c:	00 62 78             	add    %ah,0x78(%edx)
    156f:	30 3a                	xor    %bh,(%edx)
    1571:	70 28                	jo     159b <bootmain-0x27ea65>
    1573:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1576:	29 00                	sub    %eax,(%eax)
    1578:	62 79 30             	bound  %edi,0x30(%ecx)
    157b:	3a 70 28             	cmp    0x28(%eax),%dh
    157e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1581:	29 00                	sub    %eax,(%eax)
    1583:	62 78 31             	bound  %edi,0x31(%eax)
    1586:	3a 70 28             	cmp    0x28(%eax),%dh
    1589:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    158c:	29 00                	sub    %eax,(%eax)
    158e:	62 79 31             	bound  %edi,0x31(%ecx)
    1591:	3a 70 28             	cmp    0x28(%eax),%dh
    1594:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1597:	29 00                	sub    %eax,(%eax)
    1599:	73 68                	jae    1603 <bootmain-0x27e9fd>
    159b:	65                   	gs
    159c:	65                   	gs
    159d:	74 5f                	je     15fe <bootmain-0x27ea02>
    159f:	72 65                	jb     1606 <bootmain-0x27e9fa>
    15a1:	66                   	data16
    15a2:	72 65                	jb     1609 <bootmain-0x27e9f7>
    15a4:	73 68                	jae    160e <bootmain-0x27e9f2>
    15a6:	6d                   	insl   (%dx),%es:(%edi)
    15a7:	61                   	popa   
    15a8:	70 3a                	jo     15e4 <bootmain-0x27ea1c>
    15aa:	46                   	inc    %esi
    15ab:	28 30                	sub    %dh,(%eax)
    15ad:	2c 31                	sub    $0x31,%al
    15af:	38 29                	cmp    %ch,(%ecx)
    15b1:	00 73 68             	add    %dh,0x68(%ebx)
    15b4:	65                   	gs
    15b5:	65                   	gs
    15b6:	74 5f                	je     1617 <bootmain-0x27e9e9>
    15b8:	75 70                	jne    162a <bootmain-0x27e9d6>
    15ba:	64 6f                	outsl  %fs:(%esi),(%dx)
    15bc:	77 6e                	ja     162c <bootmain-0x27e9d4>
    15be:	3a 46 28             	cmp    0x28(%esi),%al
    15c1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    15c4:	38 29                	cmp    %ch,(%ecx)
    15c6:	00 68 65             	add    %ch,0x65(%eax)
    15c9:	69 67 68 74 3a 70 28 	imul   $0x28703a74,0x68(%edi),%esp
    15d0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    15d3:	29 00                	sub    %eax,(%eax)
    15d5:	68 65 69 67 68       	push   $0x68676965
    15da:	74 3a                	je     1616 <bootmain-0x27e9ea>
    15dc:	72 28                	jb     1606 <bootmain-0x27e9fa>
    15de:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    15e1:	29 00                	sub    %eax,(%eax)
    15e3:	73 68                	jae    164d <bootmain-0x27e9b3>
    15e5:	65                   	gs
    15e6:	65                   	gs
    15e7:	74 5f                	je     1648 <bootmain-0x27e9b8>
    15e9:	66                   	data16
    15ea:	72 65                	jb     1651 <bootmain-0x27e9af>
    15ec:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    15f0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    15f3:	38 29                	cmp    %ch,(%ecx)
    15f5:	00 73 68             	add    %dh,0x68(%ebx)
    15f8:	65                   	gs
    15f9:	65                   	gs
    15fa:	74 5f                	je     165b <bootmain-0x27e9a5>
    15fc:	6d                   	insl   (%dx),%es:(%edi)
    15fd:	6f                   	outsl  %ds:(%esi),(%dx)
    15fe:	76 65                	jbe    1665 <bootmain-0x27e99b>
    1600:	3a 46 28             	cmp    0x28(%esi),%al
    1603:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1606:	38 29                	cmp    %ch,(%ecx)
    1608:	00 6f 6c             	add    %ch,0x6c(%edi)
    160b:	64                   	fs
    160c:	5f                   	pop    %edi
    160d:	76 78                	jbe    1687 <bootmain-0x27e979>
    160f:	30 3a                	xor    %bh,(%edx)
    1611:	72 28                	jb     163b <bootmain-0x27e9c5>
    1613:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1616:	29 00                	sub    %eax,(%eax)
    1618:	6f                   	outsl  %ds:(%esi),(%dx)
    1619:	6c                   	insb   (%dx),%es:(%edi)
    161a:	64                   	fs
    161b:	5f                   	pop    %edi
    161c:	76 79                	jbe    1697 <bootmain-0x27e969>
    161e:	30 3a                	xor    %bh,(%edx)
    1620:	72 28                	jb     164a <bootmain-0x27e9b6>
    1622:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1625:	29 00                	sub    %eax,(%eax)
    1627:	76 79                	jbe    16a2 <bootmain-0x27e95e>
    1629:	30 3a                	xor    %bh,(%edx)
    162b:	72 28                	jb     1655 <bootmain-0x27e9ab>
    162d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1630:	29 00                	sub    %eax,(%eax)
