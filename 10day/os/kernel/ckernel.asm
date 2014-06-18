
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
  28000e:	e8 fd 03 00 00       	call   280410 <clear_screen>
  init_screen((struct boot_info * )bootp);
  280013:	c7 04 24 f0 0f 00 00 	movl   $0xff0,(%esp)
  28001a:	e8 ff 07 00 00       	call   28081e <init_screen>
  init_palette();  //color table from 0 to 15
  28001f:	e8 55 04 00 00       	call   280479 <init_palette>
int mx,my;//mouse position
mx=30;
my=30;
//display mouse logo
char mousepic[16*16];     //mouse logo buffer
init_mouse(mousepic,99);	//7　means background color:white
  280024:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  28002a:	5b                   	pop    %ebx
  28002b:	5e                   	pop    %esi
  28002c:	6a 63                	push   $0x63
  28002e:	50                   	push   %eax
  28002f:	e8 09 08 00 00       	call   28083d <init_mouse>

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280034:	fa                   	cli    
//display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);
cli();

//set gdt idt
init_gdtidt();
  280035:	e8 06 0c 00 00       	call   280c40 <init_gdtidt>

//remap irq 0-15
init_pic();		//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
  28003a:	e8 61 0d 00 00       	call   280da0 <init_pic>
unsigned char s[40];		//sprintf buffer
unsigned char keybuf[32];	//keyfifo
unsigned char mousebuf[128];	//mousefifo
unsigned char data;		//temp variable to get fifo data
int count=0;
fifo8_init(&keyfifo ,32,keybuf);//keyfifo是一个global data defined in int.c
  28003f:	83 c4 0c             	add    $0xc,%esp
  280042:	8d 85 20 fe ff ff    	lea    -0x1e0(%ebp),%eax
  280048:	50                   	push   %eax
  280049:	6a 20                	push   $0x20
  28004b:	68 b8 37 28 00       	push   $0x2837b8
  280050:	e8 56 0e 00 00       	call   280eab <fifo8_init>
fifo8_init(&mousefifo,128,mousebuf);
  280055:	83 c4 0c             	add    $0xc,%esp
  280058:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  28005e:	50                   	push   %eax
  28005f:	68 80 00 00 00       	push   $0x80
  280064:	68 d0 37 28 00       	push   $0x2837d0
  280069:	e8 3d 0e 00 00       	call   280eab <fifo8_init>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  28006e:	ba 21 00 00 00       	mov    $0x21,%edx
  280073:	b0 f9                	mov    $0xf9,%al
  280075:	ee                   	out    %al,(%dx)
  280076:	b0 ef                	mov    $0xef,%al
  280078:	b2 a1                	mov    $0xa1,%dl
  28007a:	ee                   	out    %al,(%dx)
//enable keyboard and mouse
outb(PIC0_IMR, 0xf9);	//1111 1001  irq 1 2打开 因为keyboard是irq 1 /// enable pic slave and keyboard interrupt
outb(PIC1_IMR, 0xef);	//1110 1111  irq 12打开　mouse是irq 12  所以要把pic 1 pic 2的芯片中断响应位打开。 //enable mouse interrupt

//初始化　鼠标按键控制电路
init_keyboard();
  28007b:	e8 b6 0d 00 00       	call   280e36 <init_keyboard>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280080:	fb                   	sti    


//day8

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt
  280081:	8d 8d 10 fe ff ff    	lea    -0x1f0(%ebp),%ecx
  280087:	89 0c 24             	mov    %ecx,(%esp)
  28008a:	89 8d fc fd ff ff    	mov    %ecx,-0x204(%ebp)
  280090:	e8 c2 0e 00 00       	call   280f57 <enable_mouse>

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
  280095:	5f                   	pop    %edi
  280096:	58                   	pop    %eax
  280097:	6a ff                	push   $0xffffffff
  280099:	68 00 00 40 00       	push   $0x400000
  28009e:	e8 a5 0f 00 00       	call   281048 <memtest>
//mem=mem>>20;
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  2800a3:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
  2800aa:	89 c3                	mov    %eax,%ebx
//mem=mem>>20;
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  2800ac:	e8 e5 0f 00 00       	call   281096 <memman_init>
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
  2800b1:	83 c4 0c             	add    $0xc,%esp
  2800b4:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  2800ba:	50                   	push   %eax
  2800bb:	68 00 00 40 00       	push   $0x400000
  2800c0:	68 00 00 3c 00       	push   $0x3c0000
  2800c5:	e8 7e 10 00 00       	call   281148 <memman_free>
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *win=(unsigned char*)memman_alloc(memman,320*200);
draw_win_buf(win);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800ca:	c1 eb 14             	shr    $0x14,%ebx
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *win=(unsigned char*)memman_alloc(memman,320*200);
  2800cd:	58                   	pop    %eax
  2800ce:	5a                   	pop    %edx
  2800cf:	68 00 fa 00 00       	push   $0xfa00
  2800d4:	68 00 00 3c 00       	push   $0x3c0000
  2800d9:	e8 f6 0f 00 00       	call   2810d4 <memman_alloc>
draw_win_buf(win);
  2800de:	89 04 24             	mov    %eax,(%esp)
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *win=(unsigned char*)memman_alloc(memman,320*200);
  2800e1:	89 c6                	mov    %eax,%esi
draw_win_buf(win);
  2800e3:	e8 19 04 00 00       	call   280501 <draw_win_buf>
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800e8:	8b 3d 00 00 3c 00    	mov    0x3c0000,%edi
,memman_avail(memman)>>20,memman->cellnum);
  2800ee:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)
  2800f5:	e8 bf 0f 00 00       	call   2810b9 <memman_avail>
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
char *win=(unsigned char*)memman_alloc(memman,320*200);
draw_win_buf(win);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800fa:	89 3c 24             	mov    %edi,(%esp)
  2800fd:	c1 e8 14             	shr    $0x14,%eax
  280100:	50                   	push   %eax
  280101:	53                   	push   %ebx
  280102:	68 28 30 28 00       	push   $0x283028
  280107:	8d 85 40 fe ff ff    	lea    -0x1c0(%ebp),%eax
  28010d:	50                   	push   %eax
  28010e:	e8 77 08 00 00       	call   28098a <sprintf>
,memman_avail(memman)>>20,memman->cellnum);
puts8(win ,bootp->xsize,0,100,0,s);
  280113:	83 c4 18             	add    $0x18,%esp
  280116:	8d 85 40 fe ff ff    	lea    -0x1c0(%ebp),%eax
  28011c:	50                   	push   %eax
  28011d:	6a 00                	push   $0x0
  28011f:	6a 64                	push   $0x64
  280121:	6a 00                	push   $0x0
  280123:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  28012a:	50                   	push   %eax
  28012b:	56                   	push   %esi
  28012c:	e8 54 09 00 00       	call   280a85 <puts8>

SHTCTL *shtctl;
SHEET *sht_back,*sht_mouse;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
  280131:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
  280138:	83 c4 20             	add    $0x20,%esp
  28013b:	50                   	push   %eax
  28013c:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280143:	50                   	push   %eax
  280144:	ff 35 f8 0f 00 00    	pushl  0xff8
  28014a:	68 00 00 3c 00       	push   $0x3c0000
  28014f:	e8 f7 10 00 00       	call   28124b <shtctl_init>
  280154:	89 c3                	mov    %eax,%ebx
sht_back=sheet_alloc(shtctl);
  280156:	89 04 24             	mov    %eax,(%esp)
  280159:	e8 32 11 00 00       	call   281290 <sheet_alloc>
sht_mouse=sheet_alloc(shtctl);
  28015e:	89 1c 24             	mov    %ebx,(%esp)
puts8(win ,bootp->xsize,0,100,0,s);

SHTCTL *shtctl;
SHEET *sht_back,*sht_mouse;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
sht_back=sheet_alloc(shtctl);
  280161:	89 85 00 fe ff ff    	mov    %eax,-0x200(%ebp)
sht_mouse=sheet_alloc(shtctl);
  280167:	e8 24 11 00 00       	call   281290 <sheet_alloc>

sheet_setbuf(sht_back,win,320,200,99);
  28016c:	c7 04 24 63 00 00 00 	movl   $0x63,(%esp)
  280173:	68 c8 00 00 00       	push   $0xc8
  280178:	68 40 01 00 00       	push   $0x140
  28017d:	56                   	push   %esi
  28017e:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)

SHTCTL *shtctl;
SHEET *sht_back,*sht_mouse;
shtctl=shtctl_init(memman,bootp->vram,bootp->xsize,bootp->ysize);
sht_back=sheet_alloc(shtctl);
sht_mouse=sheet_alloc(shtctl);
  280184:	89 c7                	mov    %eax,%edi
  280186:	89 85 f8 fd ff ff    	mov    %eax,-0x208(%ebp)

sheet_setbuf(sht_back,win,320,200,99);
  28018c:	e8 34 11 00 00       	call   2812c5 <sheet_setbuf>
sheet_setbuf(sht_mouse,mousepic,16,16,99);
  280191:	83 c4 14             	add    $0x14,%esp
  280194:	6a 63                	push   $0x63
  280196:	6a 10                	push   $0x10
  280198:	6a 10                	push   $0x10
  28019a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  2801a0:	50                   	push   %eax
  2801a1:	57                   	push   %edi
  2801a2:	e8 1e 11 00 00       	call   2812c5 <sheet_setbuf>

sheet_move(shtctl,sht_back,0,0);
  2801a7:	83 c4 20             	add    $0x20,%esp
  2801aa:	6a 00                	push   $0x0
  2801ac:	6a 00                	push   $0x0
  2801ae:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)
  2801b4:	53                   	push   %ebx
  2801b5:	e8 16 13 00 00       	call   2814d0 <sheet_move>
mx=160;
my=100;
sheet_move(shtctl,sht_mouse,mx,my);
  2801ba:	6a 64                	push   $0x64
  2801bc:	68 a0 00 00 00       	push   $0xa0
  2801c1:	57                   	push   %edi
  2801c2:	53                   	push   %ebx
  2801c3:	e8 08 13 00 00       	call   2814d0 <sheet_move>
sheet_updown(shtctl,sht_back,0);
  2801c8:	83 c4 1c             	add    $0x1c,%esp
  2801cb:	6a 00                	push   $0x0
  2801cd:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)
  2801d3:	53                   	push   %ebx
  2801d4:	e8 b6 11 00 00       	call   28138f <sheet_updown>
sheet_updown(shtctl,sht_mouse,1);
  2801d9:	83 c4 0c             	add    $0xc,%esp
  2801dc:	6a 01                	push   $0x1
  2801de:	57                   	push   %edi

sheet_setbuf(sht_back,win,320,200,99);
sheet_setbuf(sht_mouse,mousepic,16,16,99);

sheet_move(shtctl,sht_back,0,0);
mx=160;
  2801df:	bf a0 00 00 00       	mov    $0xa0,%edi
my=100;
sheet_move(shtctl,sht_mouse,mx,my);
sheet_updown(shtctl,sht_back,0);
sheet_updown(shtctl,sht_mouse,1);
  2801e4:	53                   	push   %ebx
  2801e5:	e8 a5 11 00 00       	call   28138f <sheet_updown>
sheet_refresh(shtctl);
  2801ea:	89 1c 24             	mov    %ebx,(%esp)
  2801ed:	e8 94 12 00 00       	call   281486 <sheet_refresh>
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
      {
        data=fifo8_read(&mousefifo);
        sti();
        if(mouse_decode(&mdec,data))
  2801f2:	8b 8d fc fd ff ff    	mov    -0x204(%ebp),%ecx
              {
                case 1:s[1]='L';break;
                case 2:s[3]='R';break;
                case 4:s[2]='M';break;
              }
              sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
  2801f8:	8d 85 40 fe ff ff    	lea    -0x1c0(%ebp),%eax
mx=160;
my=100;
sheet_move(shtctl,sht_mouse,mx,my);
sheet_updown(shtctl,sht_back,0);
sheet_updown(shtctl,sht_mouse,1);
sheet_refresh(shtctl);
  2801fe:	83 c4 10             	add    $0x10,%esp
sheet_setbuf(sht_back,win,320,200,99);
sheet_setbuf(sht_mouse,mousepic,16,16,99);

sheet_move(shtctl,sht_back,0,0);
mx=160;
my=100;
  280201:	c7 85 04 fe ff ff 64 	movl   $0x64,-0x1fc(%ebp)
  280208:	00 00 00 
              {
                case 1:s[1]='L';break;
                case 2:s[3]='R';break;
                case 4:s[2]='M';break;
              }
              sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
  28020b:	89 85 fc fd ff ff    	mov    %eax,-0x204(%ebp)
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
      {
        data=fifo8_read(&mousefifo);
        sti();
        if(mouse_decode(&mdec,data))
  280211:	89 8d f0 fd ff ff    	mov    %ecx,-0x210(%ebp)

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280217:	fa                   	cli    

 while(1)
 {
   cli();//disable cpu interrupt

   if(fifo8_status(&keyfifo) +fifo8_status(&mousefifo) == 0)//no data in keyfifo and mousefifo
  280218:	83 ec 0c             	sub    $0xc,%esp
  28021b:	68 b8 37 28 00       	push   $0x2837b8
  280220:	e8 24 0d 00 00       	call   280f49 <fifo8_status>
  280225:	c7 04 24 d0 37 28 00 	movl   $0x2837d0,(%esp)
  28022c:	89 85 f4 fd ff ff    	mov    %eax,-0x20c(%ebp)
  280232:	e8 12 0d 00 00       	call   280f49 <fifo8_status>
  280237:	83 c4 10             	add    $0x10,%esp
  28023a:	03 85 f4 fd ff ff    	add    -0x20c(%ebp),%eax
  280240:	85 c0                	test   %eax,%eax
  280242:	75 04                	jne    280248 <bootmain+0x248>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280244:	fb                   	sti    

static __inline void
hlt(void)
{

	__asm __volatile("hlt");
  280245:	f4                   	hlt    
  280246:	eb cf                	jmp    280217 <bootmain+0x217>
    sti();
    hlt();
   }
   else
   {
      if(fifo8_status(&keyfifo) != 0)
  280248:	83 ec 0c             	sub    $0xc,%esp
  28024b:	68 b8 37 28 00       	push   $0x2837b8
  280250:	e8 f4 0c 00 00       	call   280f49 <fifo8_status>
  280255:	83 c4 10             	add    $0x10,%esp
  280258:	85 c0                	test   %eax,%eax
  28025a:	74 13                	je     28026f <bootmain+0x26f>
      {
        data=fifo8_read(&keyfifo);
  28025c:	83 ec 0c             	sub    $0xc,%esp
  28025f:	68 b8 37 28 00       	push   $0x2837b8
  280264:	e8 ab 0c 00 00       	call   280f14 <fifo8_read>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280269:	fb                   	sti    
  28026a:	e9 99 01 00 00       	jmp    280408 <bootmain+0x408>
        sti();
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
  28026f:	83 ec 0c             	sub    $0xc,%esp
  280272:	68 d0 37 28 00       	push   $0x2837d0
  280277:	e8 cd 0c 00 00       	call   280f49 <fifo8_status>
  28027c:	83 c4 10             	add    $0x10,%esp
  28027f:	85 c0                	test   %eax,%eax
  280281:	74 94                	je     280217 <bootmain+0x217>
      {
        data=fifo8_read(&mousefifo);
  280283:	83 ec 0c             	sub    $0xc,%esp
  280286:	68 d0 37 28 00       	push   $0x2837d0
  28028b:	e8 84 0c 00 00       	call   280f14 <fifo8_read>
  280290:	fb                   	sti    
        sti();
        if(mouse_decode(&mdec,data))
  280291:	5a                   	pop    %edx
  280292:	0f b6 c0             	movzbl %al,%eax
  280295:	59                   	pop    %ecx
  280296:	50                   	push   %eax
  280297:	ff b5 f0 fd ff ff    	pushl  -0x210(%ebp)
  28029d:	e8 de 0c 00 00       	call   280f80 <mouse_decode>
  2802a2:	83 c4 10             	add    $0x10,%esp
  2802a5:	85 c0                	test   %eax,%eax
  2802a7:	0f 84 6a ff ff ff    	je     280217 <bootmain+0x217>
        {
              //3个字节都得到了
              switch (mdec.button)
  2802ad:	8b 85 1c fe ff ff    	mov    -0x1e4(%ebp),%eax
  2802b3:	83 f8 02             	cmp    $0x2,%eax
  2802b6:	74 11                	je     2802c9 <bootmain+0x2c9>
  2802b8:	83 f8 04             	cmp    $0x4,%eax
  2802bb:	74 15                	je     2802d2 <bootmain+0x2d2>
  2802bd:	48                   	dec    %eax
  2802be:	75 19                	jne    2802d9 <bootmain+0x2d9>
              {
                case 1:s[1]='L';break;
  2802c0:	c6 85 41 fe ff ff 4c 	movb   $0x4c,-0x1bf(%ebp)
  2802c7:	eb 10                	jmp    2802d9 <bootmain+0x2d9>
                case 2:s[3]='R';break;
  2802c9:	c6 85 43 fe ff ff 52 	movb   $0x52,-0x1bd(%ebp)
  2802d0:	eb 07                	jmp    2802d9 <bootmain+0x2d9>
                case 4:s[2]='M';break;
  2802d2:	c6 85 42 fe ff ff 4d 	movb   $0x4d,-0x1be(%ebp)
              }
              sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
  2802d9:	ff b5 18 fe ff ff    	pushl  -0x1e8(%ebp)
  2802df:	ff b5 14 fe ff ff    	pushl  -0x1ec(%ebp)
  2802e5:	68 41 30 28 00       	push   $0x283041
  2802ea:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  2802f0:	e8 95 06 00 00       	call   28098a <sprintf>
              boxfill8(win,320,0,32,16,32+20*8-1,31);//一个黑色的小box
  2802f5:	83 c4 0c             	add    $0xc,%esp
  2802f8:	6a 1f                	push   $0x1f
  2802fa:	68 bf 00 00 00       	push   $0xbf
  2802ff:	6a 10                	push   $0x10
  280301:	6a 20                	push   $0x20
  280303:	6a 00                	push   $0x0
  280305:	68 40 01 00 00       	push   $0x140
  28030a:	56                   	push   %esi
  28030b:	e8 9a 01 00 00       	call   2804aa <boxfill8>
              puts8(win,bootp->xsize,32,16,7,s);//display e0
  280310:	83 c4 18             	add    $0x18,%esp
  280313:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  280319:	6a 07                	push   $0x7
  28031b:	6a 10                	push   $0x10
  28031d:	6a 20                	push   $0x20
  28031f:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280326:	50                   	push   %eax
  280327:	56                   	push   %esi
  280328:	e8 58 07 00 00       	call   280a85 <puts8>
              sheet_refresh(shtctl,sht_back,32,16,32+20*8-1,31);
  28032d:	83 c4 18             	add    $0x18,%esp
  280330:	6a 1f                	push   $0x1f
  280332:	68 bf 00 00 00       	push   $0xbf
  280337:	6a 10                	push   $0x10
  280339:	6a 20                	push   $0x20
  28033b:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)
  280341:	53                   	push   %ebx
  280342:	e8 3f 11 00 00       	call   281486 <sheet_refresh>
  280347:	83 c4 20             	add    $0x20,%esp
  28034a:	31 c0                	xor    %eax,%eax
  28034c:	89 fa                	mov    %edi,%edx
  28034e:	03 95 14 fe ff ff    	add    -0x1ec(%ebp),%edx
  280354:	0f 48 d0             	cmovs  %eax,%edx
  280357:	89 d7                	mov    %edx,%edi
  280359:	8b 95 04 fe ff ff    	mov    -0x1fc(%ebp),%edx
  28035f:	03 95 18 fe ff ff    	add    -0x1e8(%ebp),%edx
  280365:	0f 49 c2             	cmovns %edx,%eax
  280368:	89 c1                	mov    %eax,%ecx
              {
                my=0;
              }


              if(mx>bootp->xsize-16)
  28036a:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280371:	8d 50 f1             	lea    -0xf(%eax),%edx
              {
                mx=bootp->xsize-16;
  280374:	83 e8 10             	sub    $0x10,%eax
  280377:	39 fa                	cmp    %edi,%edx
  280379:	0f 4e f8             	cmovle %eax,%edi
              }

              if(my>bootp->ysize-16)
  28037c:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
  280383:	8d 50 f1             	lea    -0xf(%eax),%edx
              {
                my=bootp->ysize-16;
  280386:	83 e8 10             	sub    $0x10,%eax
  280389:	39 ca                	cmp    %ecx,%edx
  28038b:	0f 4f c1             	cmovg  %ecx,%eax
              }
              sprintf(s,"(%d, %d)",mx,my);
  28038e:	50                   	push   %eax
  28038f:	57                   	push   %edi
  280390:	68 4d 30 28 00       	push   $0x28304d
  280395:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
                mx=bootp->xsize-16;
              }

              if(my>bootp->ysize-16)
              {
                my=bootp->ysize-16;
  28039b:	89 85 04 fe ff ff    	mov    %eax,-0x1fc(%ebp)
              }
              sprintf(s,"(%d, %d)",mx,my);
  2803a1:	e8 e4 05 00 00       	call   28098a <sprintf>
              boxfill8(win,320,0,0,0,79,15);//坐标的背景色
  2803a6:	83 c4 0c             	add    $0xc,%esp
  2803a9:	6a 0f                	push   $0xf
  2803ab:	6a 4f                	push   $0x4f
  2803ad:	6a 00                	push   $0x0
  2803af:	6a 00                	push   $0x0
  2803b1:	6a 00                	push   $0x0
  2803b3:	68 40 01 00 00       	push   $0x140
  2803b8:	56                   	push   %esi
  2803b9:	e8 ec 00 00 00       	call   2804aa <boxfill8>
              puts8(win ,bootp->xsize,0,0,7,s);//显示坐标
  2803be:	83 c4 18             	add    $0x18,%esp
  2803c1:	ff b5 fc fd ff ff    	pushl  -0x204(%ebp)
  2803c7:	6a 07                	push   $0x7
  2803c9:	6a 00                	push   $0x0
  2803cb:	6a 00                	push   $0x0
  2803cd:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2803d4:	50                   	push   %eax
  2803d5:	56                   	push   %esi
  2803d6:	e8 aa 06 00 00       	call   280a85 <puts8>
              sheet_refresh(shtctl,sht_back,0,0,79,15);
  2803db:	83 c4 18             	add    $0x18,%esp
  2803de:	6a 0f                	push   $0xf
  2803e0:	6a 4f                	push   $0x4f
  2803e2:	6a 00                	push   $0x0
  2803e4:	6a 00                	push   $0x0
  2803e6:	ff b5 00 fe ff ff    	pushl  -0x200(%ebp)
  2803ec:	53                   	push   %ebx
  2803ed:	e8 94 10 00 00       	call   281486 <sheet_refresh>


              sheet_move(shtctl,sht_mouse,mx,my);
  2803f2:	83 c4 20             	add    $0x20,%esp
  2803f5:	ff b5 04 fe ff ff    	pushl  -0x1fc(%ebp)
  2803fb:	57                   	push   %edi
  2803fc:	ff b5 f8 fd ff ff    	pushl  -0x208(%ebp)
  280402:	53                   	push   %ebx
  280403:	e8 c8 10 00 00       	call   2814d0 <sheet_move>
  280408:	83 c4 10             	add    $0x10,%esp
  28040b:	e9 07 fe ff ff       	jmp    280217 <bootmain+0x217>

00280410 <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
  280410:	55                   	push   %ebp
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  280411:	b8 00 00 0a 00       	mov    $0xa0000,%eax
#include<header.h>

void clear_screen(char color) //15:pure white
{
  280416:	89 e5                	mov    %esp,%ebp
  280418:	8a 55 08             	mov    0x8(%ebp),%dl
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  28041b:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  28041d:	40                   	inc    %eax
  28041e:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280423:	75 f6                	jne    28041b <clear_screen+0xb>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280425:	5d                   	pop    %ebp
  280426:	c3                   	ret    

00280427 <color_screen>:

void color_screen(char color) //15:pure white
{
  280427:	55                   	push   %ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  280428:	b8 00 00 0a 00       	mov    $0xa0000,%eax

  }
}

void color_screen(char color) //15:pure white
{
  28042d:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  28042f:	88 00                	mov    %al,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  280431:	40                   	inc    %eax
  280432:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280437:	75 f6                	jne    28042f <color_screen+0x8>
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280439:	5d                   	pop    %ebp
  28043a:	c3                   	ret    

0028043b <set_palette>:
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  28043b:	55                   	push   %ebp
  28043c:	89 e5                	mov    %esp,%ebp
  28043e:	56                   	push   %esi
  28043f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  280442:	53                   	push   %ebx
  280443:	8b 5d 08             	mov    0x8(%ebp),%ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  280446:	9c                   	pushf  
  280447:	5e                   	pop    %esi

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280448:	fa                   	cli    
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280449:	ba c8 03 00 00       	mov    $0x3c8,%edx

  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  28044e:	0f b6 c3             	movzbl %bl,%eax
  280451:	ee                   	out    %al,(%dx)
  280452:	b2 c9                	mov    $0xc9,%dl
  for(i=start;i<=end;i++)
  280454:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  280457:	7f 1a                	jg     280473 <set_palette+0x38>
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
  280459:	8a 01                	mov    (%ecx),%al
  28045b:	c0 e8 02             	shr    $0x2,%al
  28045e:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+1)/4);
  28045f:	8a 41 01             	mov    0x1(%ecx),%al
  280462:	c0 e8 02             	shr    $0x2,%al
  280465:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+2)/4);
  280466:	8a 41 02             	mov    0x2(%ecx),%al
  280469:	c0 e8 02             	shr    $0x2,%al
  28046c:	ee                   	out    %al,(%dx)
    rgb=rgb+3;
  28046d:	83 c1 03             	add    $0x3,%ecx
  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  280470:	43                   	inc    %ebx
  280471:	eb e1                	jmp    280454 <set_palette+0x19>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  280473:	56                   	push   %esi
  280474:	9d                   	popf   
  }

write_eflags(eflag);  //恢复从前的cpsr
  return;

}
  280475:	5b                   	pop    %ebx
  280476:	5e                   	pop    %esi
  280477:	5d                   	pop    %ebp
  280478:	c3                   	ret    

00280479 <init_palette>:
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280479:	55                   	push   %ebp
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  28047a:	b9 0c 00 00 00       	mov    $0xc,%ecx
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  28047f:	89 e5                	mov    %esp,%ebp
  280481:	57                   	push   %edi
  280482:	56                   	push   %esi
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280483:	be f8 2e 28 00       	mov    $0x282ef8,%esi
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280488:	83 ec 30             	sub    $0x30,%esp
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  28048b:	8d 45 c8             	lea    -0x38(%ebp),%eax
//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  28048e:	8d 7d c8             	lea    -0x38(%ebp),%edi
  280491:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280493:	50                   	push   %eax
  280494:	68 ff 00 00 00       	push   $0xff
  280499:	6a 00                	push   $0x0
  28049b:	e8 9b ff ff ff       	call   28043b <set_palette>
  2804a0:	83 c4 0c             	add    $0xc,%esp
}
  2804a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  2804a6:	5e                   	pop    %esi
  2804a7:	5f                   	pop    %edi
  2804a8:	5d                   	pop    %ebp
  2804a9:	c3                   	ret    

002804aa <boxfill8>:
  return;

}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
  2804aa:	55                   	push   %ebp
  2804ab:	89 e5                	mov    %esp,%ebp
  2804ad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  2804b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  2804b3:	53                   	push   %ebx
  2804b4:	8a 5d 10             	mov    0x10(%ebp),%bl
  2804b7:	0f af c1             	imul   %ecx,%eax
  2804ba:	03 45 08             	add    0x8(%ebp),%eax
 int x,y;
 for(y=y0;y<=y1;y++)
  2804bd:	3b 4d 20             	cmp    0x20(%ebp),%ecx
  2804c0:	7f 14                	jg     2804d6 <boxfill8+0x2c>
  2804c2:	8b 55 14             	mov    0x14(%ebp),%edx
 {
   for(x=x0;x<=x1;x++)
  2804c5:	3b 55 1c             	cmp    0x1c(%ebp),%edx
  2804c8:	7f 06                	jg     2804d0 <boxfill8+0x26>
   {
      vram[y*xsize+x]=color;
  2804ca:	88 1c 10             	mov    %bl,(%eax,%edx,1)
void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
  2804cd:	42                   	inc    %edx
  2804ce:	eb f5                	jmp    2804c5 <boxfill8+0x1b>
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
  2804d0:	41                   	inc    %ecx
  2804d1:	03 45 0c             	add    0xc(%ebp),%eax
  2804d4:	eb e7                	jmp    2804bd <boxfill8+0x13>
   {
      vram[y*xsize+x]=color;
   }
 }

}
  2804d6:	5b                   	pop    %ebx
  2804d7:	5d                   	pop    %ebp
  2804d8:	c3                   	ret    

002804d9 <boxfill>:
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  2804d9:	55                   	push   %ebp
  2804da:	89 e5                	mov    %esp,%ebp
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
  2804dc:	ff 75 18             	pushl  0x18(%ebp)
  2804df:	ff 75 14             	pushl  0x14(%ebp)
  2804e2:	ff 75 10             	pushl  0x10(%ebp)
  2804e5:	ff 75 0c             	pushl  0xc(%ebp)
  2804e8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  2804ec:	50                   	push   %eax
  2804ed:	68 40 01 00 00       	push   $0x140
  2804f2:	68 00 00 0a 00       	push   $0xa0000
  2804f7:	e8 ae ff ff ff       	call   2804aa <boxfill8>
  2804fc:	83 c4 1c             	add    $0x1c,%esp
}
  2804ff:	c9                   	leave  
  280500:	c3                   	ret    

00280501 <draw_win_buf>:


void draw_win_buf(unsigned char *p)
{
  280501:	55                   	push   %ebp
  280502:	89 e5                	mov    %esp,%ebp
  280504:	53                   	push   %ebx
  280505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int x=320,y=200;
    //p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill8(p,320,7 ,0, 0   ,x-1,y-29);
  280508:	68 ab 00 00 00       	push   $0xab
  28050d:	68 3f 01 00 00       	push   $0x13f
  280512:	6a 00                	push   $0x0
  280514:	6a 00                	push   $0x0
  280516:	6a 07                	push   $0x7
  280518:	68 40 01 00 00       	push   $0x140
  28051d:	53                   	push   %ebx
  28051e:	e8 87 ff ff ff       	call   2804aa <boxfill8>
//task button
    boxfill8(p,320,8  ,0, y-28,x-1,y-28);
  280523:	68 ac 00 00 00       	push   $0xac
  280528:	68 3f 01 00 00       	push   $0x13f
  28052d:	68 ac 00 00 00       	push   $0xac
  280532:	6a 00                	push   $0x0
  280534:	6a 08                	push   $0x8
  280536:	68 40 01 00 00       	push   $0x140
  28053b:	53                   	push   %ebx
  28053c:	e8 69 ff ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,7  ,0, y-27,x-1,y-27);
  280541:	83 c4 38             	add    $0x38,%esp
  280544:	68 ad 00 00 00       	push   $0xad
  280549:	68 3f 01 00 00       	push   $0x13f
  28054e:	68 ad 00 00 00       	push   $0xad
  280553:	6a 00                	push   $0x0
  280555:	6a 07                	push   $0x7
  280557:	68 40 01 00 00       	push   $0x140
  28055c:	53                   	push   %ebx
  28055d:	e8 48 ff ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,8  ,0, y-26,x-1,y-1);
  280562:	68 c7 00 00 00       	push   $0xc7
  280567:	68 3f 01 00 00       	push   $0x13f
  28056c:	68 ae 00 00 00       	push   $0xae
  280571:	6a 00                	push   $0x0
  280573:	6a 08                	push   $0x8
  280575:	68 40 01 00 00       	push   $0x140
  28057a:	53                   	push   %ebx
  28057b:	e8 2a ff ff ff       	call   2804aa <boxfill8>


//left button
    boxfill8(p,320,7, 3,  y-24, 59,  y-24);
  280580:	83 c4 38             	add    $0x38,%esp
  280583:	68 b0 00 00 00       	push   $0xb0
  280588:	6a 3b                	push   $0x3b
  28058a:	68 b0 00 00 00       	push   $0xb0
  28058f:	6a 03                	push   $0x3
  280591:	6a 07                	push   $0x7
  280593:	68 40 01 00 00       	push   $0x140
  280598:	53                   	push   %ebx
  280599:	e8 0c ff ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,7, 2,  y-24, 2 ,  y-4);
  28059e:	68 c4 00 00 00       	push   $0xc4
  2805a3:	6a 02                	push   $0x2
  2805a5:	68 b0 00 00 00       	push   $0xb0
  2805aa:	6a 02                	push   $0x2
  2805ac:	6a 07                	push   $0x7
  2805ae:	68 40 01 00 00       	push   $0x140
  2805b3:	53                   	push   %ebx
  2805b4:	e8 f1 fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,15, 3,  y-4,  59,  y-4);
  2805b9:	83 c4 38             	add    $0x38,%esp
  2805bc:	68 c4 00 00 00       	push   $0xc4
  2805c1:	6a 3b                	push   $0x3b
  2805c3:	68 c4 00 00 00       	push   $0xc4
  2805c8:	6a 03                	push   $0x3
  2805ca:	6a 0f                	push   $0xf
  2805cc:	68 40 01 00 00       	push   $0x140
  2805d1:	53                   	push   %ebx
  2805d2:	e8 d3 fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,15, 59, y-23, 59,  y-5);
  2805d7:	68 c3 00 00 00       	push   $0xc3
  2805dc:	6a 3b                	push   $0x3b
  2805de:	68 b1 00 00 00       	push   $0xb1
  2805e3:	6a 3b                	push   $0x3b
  2805e5:	6a 0f                	push   $0xf
  2805e7:	68 40 01 00 00       	push   $0x140
  2805ec:	53                   	push   %ebx
  2805ed:	e8 b8 fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,0, 2,  y-3,  59,  y-3);
  2805f2:	83 c4 38             	add    $0x38,%esp
  2805f5:	68 c5 00 00 00       	push   $0xc5
  2805fa:	6a 3b                	push   $0x3b
  2805fc:	68 c5 00 00 00       	push   $0xc5
  280601:	6a 02                	push   $0x2
  280603:	6a 00                	push   $0x0
  280605:	68 40 01 00 00       	push   $0x140
  28060a:	53                   	push   %ebx
  28060b:	e8 9a fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,0, 60, y-24, 60,  y-3);
  280610:	68 c5 00 00 00       	push   $0xc5
  280615:	6a 3c                	push   $0x3c
  280617:	68 b0 00 00 00       	push   $0xb0
  28061c:	6a 3c                	push   $0x3c
  28061e:	6a 00                	push   $0x0
  280620:	68 40 01 00 00       	push   $0x140
  280625:	53                   	push   %ebx
  280626:	e8 7f fe ff ff       	call   2804aa <boxfill8>

//
//right button
    boxfill8(p,320,15, x-47, y-24,x-4,y-24);
  28062b:	83 c4 38             	add    $0x38,%esp
  28062e:	68 b0 00 00 00       	push   $0xb0
  280633:	68 3c 01 00 00       	push   $0x13c
  280638:	68 b0 00 00 00       	push   $0xb0
  28063d:	68 11 01 00 00       	push   $0x111
  280642:	6a 0f                	push   $0xf
  280644:	68 40 01 00 00       	push   $0x140
  280649:	53                   	push   %ebx
  28064a:	e8 5b fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,15, x-47, y-23,x-47,y-4);
  28064f:	68 c4 00 00 00       	push   $0xc4
  280654:	68 11 01 00 00       	push   $0x111
  280659:	68 b1 00 00 00       	push   $0xb1
  28065e:	68 11 01 00 00       	push   $0x111
  280663:	6a 0f                	push   $0xf
  280665:	68 40 01 00 00       	push   $0x140
  28066a:	53                   	push   %ebx
  28066b:	e8 3a fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,7, x-47, y-3,x-4,y-3);
  280670:	83 c4 38             	add    $0x38,%esp
  280673:	68 c5 00 00 00       	push   $0xc5
  280678:	68 3c 01 00 00       	push   $0x13c
  28067d:	68 c5 00 00 00       	push   $0xc5
  280682:	68 11 01 00 00       	push   $0x111
  280687:	6a 07                	push   $0x7
  280689:	68 40 01 00 00       	push   $0x140
  28068e:	53                   	push   %ebx
  28068f:	e8 16 fe ff ff       	call   2804aa <boxfill8>
    boxfill8(p,320,7, x-3, y-24,x-3,y-3);
  280694:	68 c5 00 00 00       	push   $0xc5
  280699:	68 3d 01 00 00       	push   $0x13d
  28069e:	68 b0 00 00 00       	push   $0xb0
  2806a3:	68 3d 01 00 00       	push   $0x13d
  2806a8:	6a 07                	push   $0x7
  2806aa:	68 40 01 00 00       	push   $0x140
  2806af:	53                   	push   %ebx
  2806b0:	e8 f5 fd ff ff       	call   2804aa <boxfill8>
  2806b5:	83 c4 38             	add    $0x38,%esp
}
  2806b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2806bb:	c9                   	leave  
  2806bc:	c3                   	ret    

002806bd <draw_window>:
void draw_window()
{
  2806bd:	55                   	push   %ebp
  2806be:	89 e5                	mov    %esp,%ebp
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
  2806c0:	68 ab 00 00 00       	push   $0xab
  2806c5:	68 3f 01 00 00       	push   $0x13f
  2806ca:	6a 00                	push   $0x0
  2806cc:	6a 00                	push   $0x0
  2806ce:	6a 07                	push   $0x7
  2806d0:	e8 04 fe ff ff       	call   2804d9 <boxfill>
//task button
    boxfill(8  ,0, y-28,x-1,y-28);
  2806d5:	68 ac 00 00 00       	push   $0xac
  2806da:	68 3f 01 00 00       	push   $0x13f
  2806df:	68 ac 00 00 00       	push   $0xac
  2806e4:	6a 00                	push   $0x0
  2806e6:	6a 08                	push   $0x8
  2806e8:	e8 ec fd ff ff       	call   2804d9 <boxfill>
    boxfill(7  ,0, y-27,x-1,y-27);
  2806ed:	83 c4 28             	add    $0x28,%esp
  2806f0:	68 ad 00 00 00       	push   $0xad
  2806f5:	68 3f 01 00 00       	push   $0x13f
  2806fa:	68 ad 00 00 00       	push   $0xad
  2806ff:	6a 00                	push   $0x0
  280701:	6a 07                	push   $0x7
  280703:	e8 d1 fd ff ff       	call   2804d9 <boxfill>
    boxfill(8  ,0, y-26,x-1,y-1);
  280708:	68 c7 00 00 00       	push   $0xc7
  28070d:	68 3f 01 00 00       	push   $0x13f
  280712:	68 ae 00 00 00       	push   $0xae
  280717:	6a 00                	push   $0x0
  280719:	6a 08                	push   $0x8
  28071b:	e8 b9 fd ff ff       	call   2804d9 <boxfill>


//left button
    boxfill(7, 3,  y-24, 59,  y-24);
  280720:	83 c4 28             	add    $0x28,%esp
  280723:	68 b0 00 00 00       	push   $0xb0
  280728:	6a 3b                	push   $0x3b
  28072a:	68 b0 00 00 00       	push   $0xb0
  28072f:	6a 03                	push   $0x3
  280731:	6a 07                	push   $0x7
  280733:	e8 a1 fd ff ff       	call   2804d9 <boxfill>
    boxfill(7, 2,  y-24, 2 ,  y-4);
  280738:	68 c4 00 00 00       	push   $0xc4
  28073d:	6a 02                	push   $0x2
  28073f:	68 b0 00 00 00       	push   $0xb0
  280744:	6a 02                	push   $0x2
  280746:	6a 07                	push   $0x7
  280748:	e8 8c fd ff ff       	call   2804d9 <boxfill>
    boxfill(15, 3,  y-4,  59,  y-4);
  28074d:	83 c4 28             	add    $0x28,%esp
  280750:	68 c4 00 00 00       	push   $0xc4
  280755:	6a 3b                	push   $0x3b
  280757:	68 c4 00 00 00       	push   $0xc4
  28075c:	6a 03                	push   $0x3
  28075e:	6a 0f                	push   $0xf
  280760:	e8 74 fd ff ff       	call   2804d9 <boxfill>
    boxfill(15, 59, y-23, 59,  y-5);
  280765:	68 c3 00 00 00       	push   $0xc3
  28076a:	6a 3b                	push   $0x3b
  28076c:	68 b1 00 00 00       	push   $0xb1
  280771:	6a 3b                	push   $0x3b
  280773:	6a 0f                	push   $0xf
  280775:	e8 5f fd ff ff       	call   2804d9 <boxfill>
    boxfill(0, 2,  y-3,  59,  y-3);
  28077a:	83 c4 28             	add    $0x28,%esp
  28077d:	68 c5 00 00 00       	push   $0xc5
  280782:	6a 3b                	push   $0x3b
  280784:	68 c5 00 00 00       	push   $0xc5
  280789:	6a 02                	push   $0x2
  28078b:	6a 00                	push   $0x0
  28078d:	e8 47 fd ff ff       	call   2804d9 <boxfill>
    boxfill(0, 60, y-24, 60,  y-3);
  280792:	68 c5 00 00 00       	push   $0xc5
  280797:	6a 3c                	push   $0x3c
  280799:	68 b0 00 00 00       	push   $0xb0
  28079e:	6a 3c                	push   $0x3c
  2807a0:	6a 00                	push   $0x0
  2807a2:	e8 32 fd ff ff       	call   2804d9 <boxfill>

//
//right button
    boxfill(15, x-47, y-24,x-4,y-24);
  2807a7:	83 c4 28             	add    $0x28,%esp
  2807aa:	68 b0 00 00 00       	push   $0xb0
  2807af:	68 3c 01 00 00       	push   $0x13c
  2807b4:	68 b0 00 00 00       	push   $0xb0
  2807b9:	68 11 01 00 00       	push   $0x111
  2807be:	6a 0f                	push   $0xf
  2807c0:	e8 14 fd ff ff       	call   2804d9 <boxfill>
    boxfill(15, x-47, y-23,x-47,y-4);
  2807c5:	68 c4 00 00 00       	push   $0xc4
  2807ca:	68 11 01 00 00       	push   $0x111
  2807cf:	68 b1 00 00 00       	push   $0xb1
  2807d4:	68 11 01 00 00       	push   $0x111
  2807d9:	6a 0f                	push   $0xf
  2807db:	e8 f9 fc ff ff       	call   2804d9 <boxfill>
    boxfill(7, x-47, y-3,x-4,y-3);
  2807e0:	83 c4 28             	add    $0x28,%esp
  2807e3:	68 c5 00 00 00       	push   $0xc5
  2807e8:	68 3c 01 00 00       	push   $0x13c
  2807ed:	68 c5 00 00 00       	push   $0xc5
  2807f2:	68 11 01 00 00       	push   $0x111
  2807f7:	6a 07                	push   $0x7
  2807f9:	e8 db fc ff ff       	call   2804d9 <boxfill>
    boxfill(7, x-3, y-24,x-3,y-3);
  2807fe:	68 c5 00 00 00       	push   $0xc5
  280803:	68 3d 01 00 00       	push   $0x13d
  280808:	68 b0 00 00 00       	push   $0xb0
  28080d:	68 3d 01 00 00       	push   $0x13d
  280812:	6a 07                	push   $0x7
  280814:	e8 c0 fc ff ff       	call   2804d9 <boxfill>
  280819:	83 c4 28             	add    $0x28,%esp
}
  28081c:	c9                   	leave  
  28081d:	c3                   	ret    

0028081e <init_screen>:


void init_screen(struct boot_info * bootp)
{
  28081e:	55                   	push   %ebp
  28081f:	89 e5                	mov    %esp,%ebp
  280821:	8b 45 08             	mov    0x8(%ebp),%eax
  bootp->vram=(char *)VRAM;
  280824:	c7 40 08 00 00 0a 00 	movl   $0xa0000,0x8(%eax)
  bootp->color_mode=8;
  28082b:	c6 40 02 08          	movb   $0x8,0x2(%eax)
  bootp->xsize=320;
  28082f:	66 c7 40 04 40 01    	movw   $0x140,0x4(%eax)
  bootp->ysize=200;
  280835:	66 c7 40 06 c8 00    	movw   $0xc8,0x6(%eax)

}
  28083b:	5d                   	pop    %ebp
  28083c:	c3                   	ret    

0028083d <init_mouse>:

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
  28083d:	55                   	push   %ebp
  28083e:	31 c9                	xor    %ecx,%ecx
  280840:	89 e5                	mov    %esp,%ebp
  280842:	8a 45 0c             	mov    0xc(%ebp),%al
  280845:	8b 55 08             	mov    0x8(%ebp),%edx
  280848:	56                   	push   %esi
  280849:	53                   	push   %ebx
  28084a:	89 c6                	mov    %eax,%esi
  28084c:	31 c0                	xor    %eax,%eax
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
  28084e:	8a 9c 01 28 2f 28 00 	mov    0x282f28(%ecx,%eax,1),%bl
  280855:	80 fb 2e             	cmp    $0x2e,%bl
  280858:	74 10                	je     28086a <init_mouse+0x2d>
  28085a:	80 fb 4f             	cmp    $0x4f,%bl
  28085d:	74 12                	je     280871 <init_mouse+0x34>
  28085f:	80 fb 2a             	cmp    $0x2a,%bl
  280862:	75 11                	jne    280875 <init_mouse+0x38>
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
  280864:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
  280868:	eb 0b                	jmp    280875 <init_mouse+0x38>
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
  28086a:	89 f3                	mov    %esi,%ebx
  28086c:	88 1c 02             	mov    %bl,(%edx,%eax,1)
  28086f:	eb 04                	jmp    280875 <init_mouse+0x38>
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside
  280871:	c6 04 02 02          	movb   $0x2,(%edx,%eax,1)
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
  280875:	40                   	inc    %eax
  280876:	83 f8 10             	cmp    $0x10,%eax
  280879:	75 d3                	jne    28084e <init_mouse+0x11>
  28087b:	83 c1 10             	add    $0x10,%ecx
  28087e:	83 c2 10             	add    $0x10,%edx
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
  280881:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  280887:	75 c3                	jne    28084c <init_mouse+0xf>

	  }

	}

}
  280889:	5b                   	pop    %ebx
  28088a:	5e                   	pop    %esi
  28088b:	5d                   	pop    %ebp
  28088c:	c3                   	ret    

0028088d <display_mouse>:

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  28088d:	55                   	push   %ebp
  28088e:	89 e5                	mov    %esp,%ebp
  280890:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280893:	56                   	push   %esi
  int x,y;
  for(y=0;y<pysize;y++)
  280894:	31 f6                	xor    %esi,%esi
	}

}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280896:	53                   	push   %ebx
  280897:	8b 5d 20             	mov    0x20(%ebp),%ebx
  28089a:	0f af 45 0c          	imul   0xc(%ebp),%eax
  28089e:	03 45 18             	add    0x18(%ebp),%eax
  2808a1:	03 45 08             	add    0x8(%ebp),%eax
  int x,y;
  for(y=0;y<pysize;y++)
  2808a4:	3b 75 14             	cmp    0x14(%ebp),%esi
  2808a7:	7d 19                	jge    2808c2 <display_mouse+0x35>
  2808a9:	31 d2                	xor    %edx,%edx
  {
    for(x=0;x<pxsize;x++)
  2808ab:	3b 55 10             	cmp    0x10(%ebp),%edx
  2808ae:	7d 09                	jge    2808b9 <display_mouse+0x2c>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
  2808b0:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  2808b3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
  2808b6:	42                   	inc    %edx
  2808b7:	eb f2                	jmp    2808ab <display_mouse+0x1e>
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  2808b9:	46                   	inc    %esi
  2808ba:	03 5d 24             	add    0x24(%ebp),%ebx
  2808bd:	03 45 0c             	add    0xc(%ebp),%eax
  2808c0:	eb e2                	jmp    2808a4 <display_mouse+0x17>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }

}
  2808c2:	5b                   	pop    %ebx
  2808c3:	5e                   	pop    %esi
  2808c4:	5d                   	pop    %ebp
  2808c5:	c3                   	ret    

002808c6 <itoa>:
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  2808c6:	55                   	push   %ebp
   unsigned char tmp_buf[10] = {0};
  2808c7:	31 c0                	xor    %eax,%eax
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  2808c9:	89 e5                	mov    %esp,%ebp
   unsigned char tmp_buf[10] = {0};
  2808cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  2808d0:	57                   	push   %edi
  2808d1:	56                   	push   %esi
  2808d2:	53                   	push   %ebx
  2808d3:	83 ec 10             	sub    $0x10,%esp
  2808d6:	8b 55 08             	mov    0x8(%ebp),%edx
   unsigned char tmp_buf[10] = {0};
  2808d9:	8d 7d ea             	lea    -0x16(%ebp),%edi
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,unsigned char *buf){
  2808dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   unsigned char tmp_buf[10] = {0};
  2808df:	f3 aa                	rep stos %al,%es:(%edi)
  2808e1:	8d 7d ea             	lea    -0x16(%ebp),%edi
    unsigned char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
  2808e4:	85 d2                	test   %edx,%edx
  2808e6:	79 06                	jns    2808ee <itoa+0x28>
    { /* neg num */
        *buf++ = '-';//得到负号
  2808e8:	c6 03 2d             	movb   $0x2d,(%ebx)
        value = ~value + 1; //将负数变为正数
  2808eb:	f7 da                	neg    %edx
void itoa(int value,unsigned char *buf){
   unsigned char tmp_buf[10] = {0};
    unsigned char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
  2808ed:	43                   	inc    %ebx
  2808ee:	89 f9                	mov    %edi,%ecx



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2808f0:	be 0a 00 00 00       	mov    $0xa,%esi
  2808f5:	89 d0                	mov    %edx,%eax
  2808f7:	41                   	inc    %ecx
  2808f8:	99                   	cltd   
  2808f9:	f7 fe                	idiv   %esi
  2808fb:	83 c2 30             	add    $0x30,%edx
        value /= 10;
    }while(value);
  2808fe:	85 c0                	test   %eax,%eax



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280900:	88 51 ff             	mov    %dl,-0x1(%ecx)
        value /= 10;
  280903:	89 c2                	mov    %eax,%edx
    }while(value);
  280905:	75 ee                	jne    2808f5 <itoa+0x2f>



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280907:	89 ce                	mov    %ecx,%esi
  280909:	89 d8                	mov    %ebx,%eax
        value /= 10;
    }while(value);


    while(tmp_buf != tbp)
  28090b:	39 f9                	cmp    %edi,%ecx
  28090d:	74 09                	je     280918 <itoa+0x52>
    {
      tbp--;
  28090f:	49                   	dec    %ecx
      *buf++ = *tbp;
  280910:	8a 11                	mov    (%ecx),%dl
  280912:	40                   	inc    %eax
  280913:	88 50 ff             	mov    %dl,-0x1(%eax)
  280916:	eb f3                	jmp    28090b <itoa+0x45>
  280918:	89 f0                	mov    %esi,%eax
  28091a:	29 c8                	sub    %ecx,%eax

    }
    *buf='\0';
  28091c:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)


}
  280920:	83 c4 10             	add    $0x10,%esp
  280923:	5b                   	pop    %ebx
  280924:	5e                   	pop    %esi
  280925:	5f                   	pop    %edi
  280926:	5d                   	pop    %ebp
  280927:	c3                   	ret    

00280928 <xtoa>:
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  280928:	55                   	push   %ebp
   unsigned char tmp_buf[30] = {0};
  280929:	31 c0                	xor    %eax,%eax
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  28092b:	89 e5                	mov    %esp,%ebp
   unsigned char tmp_buf[30] = {0};
  28092d:	b9 1e 00 00 00       	mov    $0x1e,%ecx
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,unsigned char *buf){
  280932:	57                   	push   %edi
  280933:	56                   	push   %esi
  280934:	53                   	push   %ebx
  280935:	83 ec 20             	sub    $0x20,%esp
  280938:	8b 55 0c             	mov    0xc(%ebp),%edx
   unsigned char tmp_buf[30] = {0};
  28093b:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  28093e:	f3 aa                	rep stos %al,%es:(%edi)
   unsigned char *tbp = tmp_buf;
  280940:	8d 45 d6             	lea    -0x2a(%ebp),%eax

    *buf++='0';
  280943:	c6 02 30             	movb   $0x30,(%edx)
    *buf++='x';
  280946:	8d 72 02             	lea    0x2(%edx),%esi
  280949:	c6 42 01 78          	movb   $0x78,0x1(%edx)

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  28094d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  280950:	40                   	inc    %eax
  280951:	83 e3 0f             	and    $0xf,%ebx


}
static  inline unsigned char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
  280954:	83 fb 0a             	cmp    $0xa,%ebx
  280957:	8d 4b 37             	lea    0x37(%ebx),%ecx
  28095a:	8d 7b 30             	lea    0x30(%ebx),%edi
  28095d:	0f 4c cf             	cmovl  %edi,%ecx
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280960:	c1 6d 08 04          	shrl   $0x4,0x8(%ebp)
static  inline unsigned char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
  280964:	88 48 ff             	mov    %cl,-0x1(%eax)
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280967:	75 e4                	jne    28094d <xtoa+0x25>
    *buf++='x';

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280969:	89 c3                	mov    %eax,%ebx
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);


    while(tmp_buf != tbp)
  28096b:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  28096e:	39 f8                	cmp    %edi,%eax
  280970:	74 09                	je     28097b <xtoa+0x53>
    {
      tbp--;
  280972:	48                   	dec    %eax
      *buf++ = *tbp;
  280973:	8a 08                	mov    (%eax),%cl
  280975:	46                   	inc    %esi
  280976:	88 4e ff             	mov    %cl,-0x1(%esi)
  280979:	eb f0                	jmp    28096b <xtoa+0x43>
  28097b:	29 c3                	sub    %eax,%ebx

    }
    *buf='\0';
  28097d:	c6 44 1a 02 00       	movb   $0x0,0x2(%edx,%ebx,1)


}
  280982:	83 c4 20             	add    $0x20,%esp
  280985:	5b                   	pop    %ebx
  280986:	5e                   	pop    %esi
  280987:	5f                   	pop    %edi
  280988:	5d                   	pop    %ebp
  280989:	c3                   	ret    

0028098a <sprintf>:



//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf( char *str, char *format ,...)
{
  28098a:	55                   	push   %ebp
  28098b:	89 e5                	mov    %esp,%ebp
  28098d:	57                   	push   %edi
  28098e:	56                   	push   %esi
  28098f:	53                   	push   %ebx
  280990:	83 ec 10             	sub    $0x10,%esp
  280993:	8b 5d 08             	mov    0x8(%ebp),%ebx

   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
  280996:	8d 75 10             	lea    0x10(%ebp),%esi
    char buffer[10];
    char *buf=buffer;
  while(*format)
  280999:	8b 7d 0c             	mov    0xc(%ebp),%edi
  28099c:	8a 07                	mov    (%edi),%al
  28099e:	84 c0                	test   %al,%al
  2809a0:	0f 84 83 00 00 00    	je     280a29 <sprintf+0x9f>
  2809a6:	8d 4f 01             	lea    0x1(%edi),%ecx
  {
      if(*format!='%')
  2809a9:	3c 25                	cmp    $0x25,%al
      {
	*str++=*format++;
  2809ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
    char buffer[10];
    char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
  2809ae:	74 05                	je     2809b5 <sprintf+0x2b>
      {
	*str++=*format++;
  2809b0:	88 03                	mov    %al,(%ebx)
  2809b2:	43                   	inc    %ebx
	continue;
  2809b3:	eb e4                	jmp    280999 <sprintf+0xf>
      }
      else
      {
	format++;
	switch (*format)
  2809b5:	8a 47 01             	mov    0x1(%edi),%al
  2809b8:	3c 73                	cmp    $0x73,%al
  2809ba:	74 46                	je     280a02 <sprintf+0x78>
  2809bc:	3c 78                	cmp    $0x78,%al
  2809be:	74 23                	je     2809e3 <sprintf+0x59>
  2809c0:	3c 64                	cmp    $0x64,%al
  2809c2:	75 53                	jne    280a17 <sprintf+0x8d>
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
  2809c4:	8d 45 ea             	lea    -0x16(%ebp),%eax
  2809c7:	50                   	push   %eax
  2809c8:	ff 36                	pushl  (%esi)
  2809ca:	e8 f7 fe ff ff       	call   2808c6 <itoa>
  2809cf:	59                   	pop    %ecx
  2809d0:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  2809d3:	58                   	pop    %eax
  2809d4:	89 d8                	mov    %ebx,%eax
  2809d6:	8a 19                	mov    (%ecx),%bl
  2809d8:	84 db                	test   %bl,%bl
  2809da:	74 3d                	je     280a19 <sprintf+0x8f>
  2809dc:	40                   	inc    %eax
  2809dd:	41                   	inc    %ecx
  2809de:	88 58 ff             	mov    %bl,-0x1(%eax)
  2809e1:	eb f3                	jmp    2809d6 <sprintf+0x4c>
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
  2809e3:	8d 45 ea             	lea    -0x16(%ebp),%eax
  2809e6:	50                   	push   %eax
  2809e7:	ff 36                	pushl  (%esi)
  2809e9:	e8 3a ff ff ff       	call   280928 <xtoa>
  2809ee:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  2809f1:	58                   	pop    %eax
  2809f2:	89 d8                	mov    %ebx,%eax
  2809f4:	5a                   	pop    %edx
  2809f5:	8a 19                	mov    (%ecx),%bl
  2809f7:	84 db                	test   %bl,%bl
  2809f9:	74 1e                	je     280a19 <sprintf+0x8f>
  2809fb:	40                   	inc    %eax
  2809fc:	41                   	inc    %ecx
  2809fd:	88 58 ff             	mov    %bl,-0x1(%eax)
  280a00:	eb f3                	jmp    2809f5 <sprintf+0x6b>
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
  280a02:	8b 16                	mov    (%esi),%edx
  280a04:	89 d8                	mov    %ebx,%eax
  280a06:	89 c1                	mov    %eax,%ecx
  280a08:	29 d9                	sub    %ebx,%ecx
  280a0a:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
  280a0d:	84 c9                	test   %cl,%cl
  280a0f:	74 08                	je     280a19 <sprintf+0x8f>
  280a11:	40                   	inc    %eax
  280a12:	88 48 ff             	mov    %cl,-0x1(%eax)
  280a15:	eb ef                	jmp    280a06 <sprintf+0x7c>
	continue;
      }
      else
      {
	format++;
	switch (*format)
  280a17:	89 d8                	mov    %ebx,%eax
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
	format++;
  280a19:	83 c7 02             	add    $0x2,%edi
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
  280a1c:	83 c6 04             	add    $0x4,%esi
	format++;
  280a1f:	89 7d 0c             	mov    %edi,0xc(%ebp)
  280a22:	89 c3                	mov    %eax,%ebx
  280a24:	e9 70 ff ff ff       	jmp    280999 <sprintf+0xf>

      }

  }
  *str='\0';
  280a29:	c6 03 00             	movb   $0x0,(%ebx)

}
  280a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280a2f:	5b                   	pop    %ebx
  280a30:	5e                   	pop    %esi
  280a31:	5f                   	pop    %edi
  280a32:	5d                   	pop    %ebp
  280a33:	c3                   	ret    

00280a34 <putfont8>:
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280a34:	55                   	push   %ebp
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280a35:	31 d2                	xor    %edx,%edx
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280a37:	89 e5                	mov    %esp,%ebp
  280a39:	57                   	push   %edi
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280a3a:	bf 80 00 00 00       	mov    $0x80,%edi
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280a3f:	56                   	push   %esi
  280a40:	53                   	push   %ebx
  280a41:	83 ec 01             	sub    $0x1,%esp
  280a44:	8a 45 18             	mov    0x18(%ebp),%al
  280a47:	88 45 f3             	mov    %al,-0xd(%ebp)
  280a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  280a4d:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280a51:	03 45 10             	add    0x10(%ebp),%eax
  280a54:	03 45 08             	add    0x8(%ebp),%eax
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280a57:	8b 75 1c             	mov    0x1c(%ebp),%esi
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280a5a:	31 c9                	xor    %ecx,%ecx
    {
      if(d&(0x80>>col))
  280a5c:	0f be 34 16          	movsbl (%esi,%edx,1),%esi
  280a60:	89 fb                	mov    %edi,%ebx
  280a62:	d3 fb                	sar    %cl,%ebx
  280a64:	85 f3                	test   %esi,%ebx
  280a66:	74 06                	je     280a6e <putfont8+0x3a>
      {
	vram[(y+row)*xsize+x+col]=color;
  280a68:	8a 5d f3             	mov    -0xd(%ebp),%bl
  280a6b:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280a6e:	41                   	inc    %ecx
  280a6f:	83 f9 08             	cmp    $0x8,%ecx
  280a72:	75 ec                	jne    280a60 <putfont8+0x2c>

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280a74:	42                   	inc    %edx
  280a75:	03 45 0c             	add    0xc(%ebp),%eax
  280a78:	83 fa 10             	cmp    $0x10,%edx
  280a7b:	75 da                	jne    280a57 <putfont8+0x23>
    }

  }
  return;

}
  280a7d:	83 c4 01             	add    $0x1,%esp
  280a80:	5b                   	pop    %ebx
  280a81:	5e                   	pop    %esi
  280a82:	5f                   	pop    %edi
  280a83:	5d                   	pop    %ebp
  280a84:	c3                   	ret    

00280a85 <puts8>:
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,unsigned char *font)//x=0 311 y=0 183
{
  280a85:	55                   	push   %ebp
  280a86:	89 e5                	mov    %esp,%ebp
  280a88:	57                   	push   %edi
  280a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  280a8c:	56                   	push   %esi
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280a8d:	0f be 75 18          	movsbl 0x18(%ebp),%esi
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,unsigned char *font)//x=0 311 y=0 183
{
  280a91:	53                   	push   %ebx
  280a92:	8b 5d 10             	mov    0x10(%ebp),%ebx

 while(*font)
  280a95:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280a98:	0f b6 00             	movzbl (%eax),%eax
  280a9b:	84 c0                	test   %al,%al
  280a9d:	74 42                	je     280ae1 <puts8+0x5c>
 {
    if(*font=='\n')
  280a9f:	3c 0a                	cmp    $0xa,%al
  280aa1:	75 05                	jne    280aa8 <puts8+0x23>
    {
      x=0;
      y=y+16;
  280aa3:	83 c7 10             	add    $0x10,%edi
  280aa6:	eb 32                	jmp    280ada <puts8+0x55>

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280aa8:	c1 e0 04             	shl    $0x4,%eax
  280aab:	05 28 15 28 00       	add    $0x281528,%eax
  280ab0:	50                   	push   %eax
  280ab1:	56                   	push   %esi
  280ab2:	57                   	push   %edi
  280ab3:	53                   	push   %ebx
    x+=8;
  280ab4:	83 c3 08             	add    $0x8,%ebx
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280ab7:	ff 75 0c             	pushl  0xc(%ebp)
  280aba:	ff 75 08             	pushl  0x8(%ebp)
  280abd:	e8 72 ff ff ff       	call   280a34 <putfont8>
    x+=8;
    if(x>312)
  280ac2:	83 c4 18             	add    $0x18,%esp
  280ac5:	81 fb 38 01 00 00    	cmp    $0x138,%ebx
  280acb:	7e 0f                	jle    280adc <puts8+0x57>
       {
	  x=0;
	  y+=16;
  280acd:	83 c7 10             	add    $0x10,%edi
	  if(y>183)
  280ad0:	81 ff b7 00 00 00    	cmp    $0xb7,%edi
  280ad6:	7e 02                	jle    280ada <puts8+0x55>
	  {
	    x=0;
	    y=0;
  280ad8:	31 ff                	xor    %edi,%edi
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
  280ada:	31 db                	xor    %ebx,%ebx

	  }
        }
    }

    font++;
  280adc:	ff 45 1c             	incl   0x1c(%ebp)
  280adf:	eb b4                	jmp    280a95 <puts8+0x10>
}

}
  280ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280ae4:	5b                   	pop    %ebx
  280ae5:	5e                   	pop    %esi
  280ae6:	5f                   	pop    %edi
  280ae7:	5d                   	pop    %ebp
  280ae8:	c3                   	ret    

00280ae9 <printdebug>:
#include<header.h>


void printdebug(unsigned int i,unsigned int x)
{
  280ae9:	55                   	push   %ebp
  280aea:	89 e5                	mov    %esp,%ebp
  280aec:	53                   	push   %ebx
  280aed:	83 ec 20             	sub    $0x20,%esp
char font[30];
sprintf(font,"Debug:var=%x" ,i);
  280af0:	ff 75 08             	pushl  0x8(%ebp)
  280af3:	8d 5d de             	lea    -0x22(%ebp),%ebx
  280af6:	68 56 30 28 00       	push   $0x283056
  280afb:	53                   	push   %ebx
  280afc:	e8 89 fe ff ff       	call   28098a <sprintf>
puts8((char *)VRAM ,320,x,150,1,font);
  280b01:	53                   	push   %ebx
  280b02:	6a 01                	push   $0x1
  280b04:	68 96 00 00 00       	push   $0x96
  280b09:	ff 75 0c             	pushl  0xc(%ebp)
  280b0c:	68 40 01 00 00       	push   $0x140
  280b11:	68 00 00 0a 00       	push   $0xa0000
  280b16:	e8 6a ff ff ff       	call   280a85 <puts8>
  280b1b:	83 c4 24             	add    $0x24,%esp

}
  280b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280b21:	c9                   	leave  
  280b22:	c3                   	ret    

00280b23 <putfont16>:

  }

}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  280b23:	55                   	push   %ebp
  280b24:	31 c9                	xor    %ecx,%ecx
  280b26:	89 e5                	mov    %esp,%ebp
  280b28:	57                   	push   %edi
  280b29:	56                   	push   %esi
  280b2a:	53                   	push   %ebx
  280b2b:	52                   	push   %edx
  280b2c:	8b 55 14             	mov    0x14(%ebp),%edx
  280b2f:	0f af 55 0c          	imul   0xc(%ebp),%edx
  280b33:	8b 45 10             	mov    0x10(%ebp),%eax
  280b36:	03 45 08             	add    0x8(%ebp),%eax
  280b39:	8a 5d 18             	mov    0x18(%ebp),%bl
  280b3c:	01 d0                	add    %edx,%eax
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280b3e:	31 d2                	xor    %edx,%edx
  280b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
  280b43:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  280b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280b49:	0f b7 bc 57 00 fa ff 	movzwl -0x600(%edi,%edx,2),%edi
  280b50:	ff 
  280b51:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280b54:	31 c0                	xor    %eax,%eax
    {
       if( (d&(1 << col) ))
  280b56:	0f a3 c7             	bt     %eax,%edi
  280b59:	73 03                	jae    280b5e <putfont16+0x3b>
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;
  280b5b:	88 1c 06             	mov    %bl,(%esi,%eax,1)
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280b5e:	40                   	inc    %eax
  280b5f:	83 f8 10             	cmp    $0x10,%eax
  280b62:	75 f2                	jne    280b56 <putfont16+0x33>
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280b64:	42                   	inc    %edx
  280b65:	03 4d 0c             	add    0xc(%ebp),%ecx
  280b68:	83 fa 18             	cmp    $0x18,%edx
  280b6b:	75 d6                	jne    280b43 <putfont16+0x20>
    }

  }
  return;

}
  280b6d:	58                   	pop    %eax
  280b6e:	5b                   	pop    %ebx
  280b6f:	5e                   	pop    %esi
  280b70:	5f                   	pop    %edi
  280b71:	5d                   	pop    %ebp
  280b72:	c3                   	ret    

00280b73 <puts16>:
  return;

}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  280b73:	55                   	push   %ebp
  280b74:	89 e5                	mov    %esp,%ebp
  280b76:	57                   	push   %edi
  280b77:	8b 7d 10             	mov    0x10(%ebp),%edi
  280b7a:	56                   	push   %esi
  280b7b:	8b 75 14             	mov    0x14(%ebp),%esi
  280b7e:	53                   	push   %ebx

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280b7f:	0f be 5d 18          	movsbl 0x18(%ebp),%ebx
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  280b83:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280b86:	0f be 00             	movsbl (%eax),%eax
  280b89:	84 c0                	test   %al,%al
  280b8b:	74 2d                	je     280bba <puts16+0x47>
  {
    if(*font=='\n')
  280b8d:	3c 0a                	cmp    $0xa,%al
  280b8f:	75 07                	jne    280b98 <puts16+0x25>
    {
      x=0;
      y=y+24;
  280b91:	83 c6 18             	add    $0x18,%esi
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
  280b94:	31 ff                	xor    %edi,%edi
  280b96:	eb 1d                	jmp    280bb5 <puts16+0x42>
      y=y+24;

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
  280b98:	6b c0 30             	imul   $0x30,%eax,%eax
  280b9b:	05 28 1d 28 00       	add    $0x281d28,%eax
	putfont16(vram ,xsize,x,y,color,pt);
  280ba0:	50                   	push   %eax
  280ba1:	53                   	push   %ebx
  280ba2:	56                   	push   %esi
  280ba3:	57                   	push   %edi
	x=x+16;
  280ba4:	83 c7 10             	add    $0x10,%edi

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280ba7:	ff 75 0c             	pushl  0xc(%ebp)
  280baa:	ff 75 08             	pushl  0x8(%ebp)
  280bad:	e8 71 ff ff ff       	call   280b23 <putfont16>
	x=x+16;
  280bb2:	83 c4 18             	add    $0x18,%esp


    }

     font++;
  280bb5:	ff 45 1c             	incl   0x1c(%ebp)
  280bb8:	eb c9                	jmp    280b83 <puts16+0x10>

  }

}
  280bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280bbd:	5b                   	pop    %ebx
  280bbe:	5e                   	pop    %esi
  280bbf:	5f                   	pop    %edi
  280bc0:	5d                   	pop    %ebp
  280bc1:	c3                   	ret    

00280bc2 <setgdt>:
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  280bc2:	55                   	push   %ebp
  280bc3:	89 e5                	mov    %esp,%ebp
  280bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  280bc8:	57                   	push   %edi
  280bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  280bcc:	56                   	push   %esi
  280bcd:	8b 7d 14             	mov    0x14(%ebp),%edi
  280bd0:	53                   	push   %ebx
  280bd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(limit>0xffff)
  280bd4:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
  280bda:	76 09                	jbe    280be5 <setgdt+0x23>
  {
    access|=0x8000;
  280bdc:	81 cf 00 80 00 00    	or     $0x8000,%edi
    limit /=0x1000;
  280be2:	c1 ea 0c             	shr    $0xc,%edx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  280be5:	89 de                	mov    %ebx,%esi
  280be7:	c1 fe 10             	sar    $0x10,%esi
  280bea:	89 f1                	mov    %esi,%ecx
  280bec:	88 48 04             	mov    %cl,0x4(%eax)
  sd->access_right=access&0xff;
  280bef:	89 f9                	mov    %edi,%ecx
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280bf1:	c1 ff 08             	sar    $0x8,%edi
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  280bf4:	88 48 05             	mov    %cl,0x5(%eax)
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280bf7:	89 f9                	mov    %edi,%ecx
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  280bf9:	66 89 10             	mov    %dx,(%eax)
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280bfc:	83 e1 f0             	and    $0xfffffff0,%ecx
  280bff:	c1 ea 10             	shr    $0x10,%edx
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  280c02:	66 89 58 02          	mov    %bx,0x2(%eax)
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280c06:	09 d1                	or     %edx,%ecx
  sd->base_high=(base>>24)&0xff;
  280c08:	c1 eb 18             	shr    $0x18,%ebx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280c0b:	88 48 06             	mov    %cl,0x6(%eax)
  sd->base_high=(base>>24)&0xff;
  280c0e:	88 58 07             	mov    %bl,0x7(%eax)

}
  280c11:	5b                   	pop    %ebx
  280c12:	5e                   	pop    %esi
  280c13:	5f                   	pop    %edi
  280c14:	5d                   	pop    %ebp
  280c15:	c3                   	ret    

00280c16 <setidt>:

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  280c16:	55                   	push   %ebp
  280c17:	89 e5                	mov    %esp,%ebp
  280c19:	8b 45 08             	mov    0x8(%ebp),%eax
  280c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  280c1f:	8b 55 14             	mov    0x14(%ebp),%edx
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280c22:	66 89 08             	mov    %cx,(%eax)
  gd->offset_high=(offset>>16)&0xffff;
  280c25:	c1 e9 10             	shr    $0x10,%ecx
  280c28:	66 89 48 06          	mov    %cx,0x6(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  280c2c:	8b 4d 10             	mov    0x10(%ebp),%ecx

  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280c2f:	88 50 05             	mov    %dl,0x5(%eax)
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  280c32:	66 89 48 02          	mov    %cx,0x2(%eax)

  gd->dw_count=(access>>8)&0xff;
  280c36:	89 d1                	mov    %edx,%ecx
  280c38:	c1 f9 08             	sar    $0x8,%ecx
  280c3b:	88 48 04             	mov    %cl,0x4(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的


}
  280c3e:	5d                   	pop    %ebp
  280c3f:	c3                   	ret    

00280c40 <init_gdtidt>:



void  init_gdtidt()
{
  280c40:	55                   	push   %ebp
  280c41:	89 e5                	mov    %esp,%ebp
  280c43:	53                   	push   %ebx
  280c44:	53                   	push   %ebx
  280c45:	bb 00 00 27 00       	mov    $0x270000,%ebx
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  280c4a:	6a 00                	push   $0x0
  280c4c:	6a 00                	push   $0x0
  280c4e:	6a 00                	push   $0x0
  280c50:	53                   	push   %ebx
  280c51:	83 c3 08             	add    $0x8,%ebx
  280c54:	e8 69 ff ff ff       	call   280bc2 <setgdt>
void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  280c59:	83 c4 10             	add    $0x10,%esp
  280c5c:	81 fb 00 00 28 00    	cmp    $0x280000,%ebx
  280c62:	75 e6                	jne    280c4a <init_gdtidt+0xa>
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  280c64:	68 92 40 00 00       	push   $0x4092
  280c69:	6a 00                	push   $0x0
  280c6b:	6a ff                	push   $0xffffffff
  280c6d:	68 08 00 27 00       	push   $0x270008
  280c72:	e8 4b ff ff ff       	call   280bc2 <setgdt>
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  280c77:	68 9a 40 00 00       	push   $0x409a
  280c7c:	6a 00                	push   $0x0
  280c7e:	68 ff ff 0f 00       	push   $0xfffff
  280c83:	68 10 00 27 00       	push   $0x270010
  280c88:	e8 35 ff ff ff       	call   280bc2 <setgdt>
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  280c8d:	83 c4 20             	add    $0x20,%esp
  280c90:	68 9a 40 00 00       	push   $0x409a
  280c95:	68 00 00 28 00       	push   $0x280000
  280c9a:	68 ff ff 0f 00       	push   $0xfffff
  280c9f:	68 18 00 27 00       	push   $0x270018
  280ca4:	e8 19 ff ff ff       	call   280bc2 <setgdt>

   load_gdtr(0xfff,0X00270000);//this is right
  280ca9:	5a                   	pop    %edx
  280caa:	59                   	pop    %ecx
  280cab:	68 00 00 27 00       	push   $0x270000
  280cb0:	68 ff 0f 00 00       	push   $0xfff
  280cb5:	e8 d1 01 00 00       	call   280e8b <load_gdtr>
  280cba:	83 c4 10             	add    $0x10,%esp
  280cbd:	31 c0                	xor    %eax,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280cbf:	66 c7 80 00 f8 26 00 	movw   $0x0,0x26f800(%eax)
  280cc6:	00 00 
  280cc8:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280ccb:	66 c7 80 fe f7 26 00 	movw   $0x0,0x26f7fe(%eax)
  280cd2:	00 00 

  //16位的selector决定了base address
  gd->selector=selector;
  280cd4:	66 c7 80 fa f7 26 00 	movw   $0x0,0x26f7fa(%eax)
  280cdb:	00 00 

  gd->dw_count=(access>>8)&0xff;
  280cdd:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280ce4:	c6 80 fd f7 26 00 00 	movb   $0x0,0x26f7fd(%eax)
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  280ceb:	3d 00 08 00 00       	cmp    $0x800,%eax
  280cf0:	75 cd                	jne    280cbf <init_gdtidt+0x7f>

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  280cf2:	ba 55 0e 28 00       	mov    $0x280e55,%edx
  280cf7:	66 31 c0             	xor    %ax,%ax
  280cfa:	c1 ea 10             	shr    $0x10,%edx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280cfd:	b9 55 0e 28 00       	mov    $0x280e55,%ecx
  280d02:	66 89 88 00 f8 26 00 	mov    %cx,0x26f800(%eax)
  280d09:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280d0c:	66 89 90 fe f7 26 00 	mov    %dx,0x26f7fe(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  280d13:	66 c7 80 fa f7 26 00 	movw   $0x18,0x26f7fa(%eax)
  280d1a:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280d1c:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280d23:	c6 80 fd f7 26 00 8e 	movb   $0x8e,0x26f7fd(%eax)
  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }

  for(i=0;i<256;i++)
  280d2a:	3d 00 08 00 00       	cmp    $0x800,%eax
  280d2f:	75 d1                	jne    280d02 <init_gdtidt+0xc2>
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  280d31:	b8 55 0e 00 00       	mov    $0xe55,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280d36:	66 a3 08 f9 26 00    	mov    %ax,0x26f908
  gd->offset_high=(offset>>16)&0xffff;
  280d3c:	c1 e8 10             	shr    $0x10,%eax
  280d3f:	66 a3 0e f9 26 00    	mov    %ax,0x26f90e
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  setidt(idt+0x2c,(int)asm_inthandler2c-0x280000,3*8,0x008e);//挂载mouse 　　interrupt service
  280d45:	b8 70 0e 00 00       	mov    $0xe70,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280d4a:	66 a3 60 f9 26 00    	mov    %ax,0x26f960
  gd->offset_high=(offset>>16)&0xffff;
  280d50:	c1 e8 10             	shr    $0x10,%eax
  280d53:	66 a3 66 f9 26 00    	mov    %ax,0x26f966

  //16位的selector决定了base address
  gd->selector=selector;
  280d59:	66 c7 05 0a f9 26 00 	movw   $0x18,0x26f90a
  280d60:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280d62:	c6 05 0c f9 26 00 00 	movb   $0x0,0x26f90c
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280d69:	c6 05 0d f9 26 00 8e 	movb   $0x8e,0x26f90d
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  280d70:	66 c7 05 62 f9 26 00 	movw   $0x18,0x26f962
  280d77:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280d79:	c6 05 64 f9 26 00 00 	movb   $0x0,0x26f964
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280d80:	c6 05 65 f9 26 00 8e 	movb   $0x8e,0x26f965

 // setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service
 // setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt serv
  //printdebug(asm_inthandler2c,0);

  load_idtr(0x7ff,0x0026f800);//this is right
  280d87:	50                   	push   %eax
  280d88:	50                   	push   %eax
  280d89:	68 00 f8 26 00       	push   $0x26f800
  280d8e:	68 ff 07 00 00       	push   $0x7ff
  280d93:	e8 03 01 00 00       	call   280e9b <load_idtr>
  280d98:	83 c4 10             	add    $0x10,%esp



  return;

}
  280d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280d9e:	c9                   	leave  
  280d9f:	c3                   	ret    

00280da0 <init_pic>:
#define PIC1_ICW4		0x00a1
*/

//remap irq0-irq15到int 0x20到int 0x2f
void init_pic()
{
  280da0:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280da1:	ba 21 00 00 00       	mov    $0x21,%edx
  280da6:	89 e5                	mov    %esp,%ebp
  280da8:	b0 ff                	mov    $0xff,%al
  280daa:	ee                   	out    %al,(%dx)
  280dab:	b2 a1                	mov    $0xa1,%dl
  280dad:	ee                   	out    %al,(%dx)
  280dae:	b0 11                	mov    $0x11,%al
  280db0:	b2 20                	mov    $0x20,%dl
  280db2:	ee                   	out    %al,(%dx)
  280db3:	b0 20                	mov    $0x20,%al
  280db5:	b2 21                	mov    $0x21,%dl
  280db7:	ee                   	out    %al,(%dx)
  280db8:	b0 04                	mov    $0x4,%al
  280dba:	ee                   	out    %al,(%dx)
  280dbb:	b0 01                	mov    $0x1,%al
  280dbd:	ee                   	out    %al,(%dx)
  280dbe:	b0 11                	mov    $0x11,%al
  280dc0:	b2 a0                	mov    $0xa0,%dl
  280dc2:	ee                   	out    %al,(%dx)
  280dc3:	b0 28                	mov    $0x28,%al
  280dc5:	b2 a1                	mov    $0xa1,%dl
  280dc7:	ee                   	out    %al,(%dx)
  280dc8:	b0 02                	mov    $0x2,%al
  280dca:	ee                   	out    %al,(%dx)
  280dcb:	b0 01                	mov    $0x1,%al
  280dcd:	ee                   	out    %al,(%dx)
  280dce:	b0 fb                	mov    $0xfb,%al
  280dd0:	b2 21                	mov    $0x21,%dl
  280dd2:	ee                   	out    %al,(%dx)
  280dd3:	b0 ff                	mov    $0xff,%al
  280dd5:	b2 a1                	mov    $0xa1,%dl
  280dd7:	ee                   	out    %al,(%dx)

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}
  280dd8:	5d                   	pop    %ebp
  280dd9:	c3                   	ret    

00280dda <inthandler21>:
struct FIFO8 keyfifo;//a global data
//上面是一个全局变量

//interrupt service procedure for keyboard  中断服务程序，读取按键的键值。
void inthandler21(int *esp)
{
  280dda:	55                   	push   %ebp
  280ddb:	ba 20 00 00 00       	mov    $0x20,%edx
  280de0:	89 e5                	mov    %esp,%ebp
  280de2:	b0 61                	mov    $0x61,%al
  280de4:	83 ec 10             	sub    $0x10,%esp
  280de7:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  280de8:	b2 60                	mov    $0x60,%dl
  280dea:	ec                   	in     (%dx),%al
  //struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  unsigned char data;
  outb(PIC0_OCW2,0X61);//0X61-->PIC0_OCW2 　告之pic0这个芯片，irq1中断(就是keyboard产生的中断)cpu已经处理，这样pic0才会响应　下一次的irq1中断
  //如果不告之pic0已经处理了这次中断，pico对已后的irq1中断就会响应了。这种cpu处理完了中断，对pic0的反馈机制是非常好的，不会漏掉任何数据。
  data=inb(PORT_KEYDAT);
  fifo8_write(&keyfifo,data);
  280deb:	0f b6 c0             	movzbl %al,%eax
  280dee:	50                   	push   %eax
  280def:	68 b8 37 28 00       	push   $0x2837b8
  280df4:	e8 dd 00 00 00       	call   280ed6 <fifo8_write>
  280df9:	83 c4 10             	add    $0x10,%esp
  //puts8((char *)binfo->vram ,binfo->xsize,0,0,7,s);

  //while(1)
  //io_halt();
  
}
  280dfc:	c9                   	leave  
  280dfd:	c3                   	ret    

00280dfe <inthandler2c>:
//中断处理程序不应该有大量的处理部分，应该得到数据后，马上回去，在主函数中处理信息才是对的，与５１中是一个道理。isr尽量短小。

//interrupt service for mouse 
struct FIFO8 mousefifo;
void inthandler2c(int *esp)//可以看到一运行enable_后就，就产生了中断，进入了这个中断服务函数。
{
  280dfe:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280dff:	ba a0 00 00 00       	mov    $0xa0,%edx
  280e04:	89 e5                	mov    %esp,%ebp
  280e06:	b0 64                	mov    $0x64,%al
  280e08:	83 ec 10             	sub    $0x10,%esp
  280e0b:	ee                   	out    %al,(%dx)
  280e0c:	b0 62                	mov    $0x62,%al
  280e0e:	b2 20                	mov    $0x20,%dl
  280e10:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  280e11:	b2 60                	mov    $0x60,%dl
  280e13:	ec                   	in     (%dx),%al
  
  unsigned char data;
  outb(PIC1_OCW2,0X64);//cpu tell pic1　that I got IRQ12 
  outb(PIC0_OCW2,0X62);//cpu tell pic0  that I got IRQ2
  data = inb(PORT_KEYDAT);
  fifo8_write(&mousefifo,data);
  280e14:	0f b6 c0             	movzbl %al,%eax
  280e17:	50                   	push   %eax
  280e18:	68 d0 37 28 00       	push   $0x2837d0
  280e1d:	e8 b4 00 00 00       	call   280ed6 <fifo8_write>
  280e22:	83 c4 10             	add    $0x10,%esp
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int2c(IRQ-12):PS2/mouse");

 // while(1)
 // hlt();
 */
}
  280e25:	c9                   	leave  
  280e26:	c3                   	ret    

00280e27 <wait_KBC_sendready>:
//for mouse and keyboard control circuit,鼠标，键盘控制电路的初始化。
//#define PORT_KEYDAT 		0X0060


void wait_KBC_sendready(void)				//send ready and wait keyboard control ready
{
  280e27:	55                   	push   %ebp
  280e28:	ba 64 00 00 00       	mov    $0x64,%edx
  280e2d:	89 e5                	mov    %esp,%ebp
  280e2f:	ec                   	in     (%dx),%al
  while(1)
  {
    /*等待按键控制电路准备完毕*/
    if( (inb(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0)	//读port 0x0064 看bit1是否是为０/if 0 ready ,if 1 not ready　
  280e30:	a8 02                	test   $0x2,%al
  280e32:	75 fb                	jne    280e2f <wait_KBC_sendready+0x8>
    {							//bit 1是０说明键盘控制电路是准备好的，可以接受cpu的指令了。
      break;
    }
  }
  
}
  280e34:	5d                   	pop    %ebp
  280e35:	c3                   	ret    

00280e36 <init_keyboard>:

void init_keyboard(void)
{
  280e36:	55                   	push   %ebp
  280e37:	89 e5                	mov    %esp,%ebp
  /*这里才是真正的初始化按键电路*/
  wait_KBC_sendready();				//wait ready
  280e39:	e8 e9 ff ff ff       	call   280e27 <wait_KBC_sendready>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280e3e:	ba 64 00 00 00       	mov    $0x64,%edx
  280e43:	b0 60                	mov    $0x60,%al
  280e45:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_WRITE_MODE);		//向port 0x0064写　0x60
  wait_KBC_sendready();				//保证能写入有效的数据到　port 0x0064
  280e46:	e8 dc ff ff ff       	call   280e27 <wait_KBC_sendready>
  280e4b:	ba 60 00 00 00       	mov    $0x60,%edx
  280e50:	b0 47                	mov    $0x47,%al
  280e52:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,KBC_MODE);			//向port 0x0060 写数据0x47
  return;
  
}
  280e53:	5d                   	pop    %ebp
  280e54:	c3                   	ret    

00280e55 <asm_inthandler21>:
.global load_idtr

.code32
#interrupt service about keyboad
asm_inthandler21:
  pushw %es
  280e55:	66 06                	pushw  %es
  pushw %ds
  280e57:	66 1e                	pushw  %ds
  pushal
  280e59:	60                   	pusha  
  movl %esp,%eax
  280e5a:	89 e0                	mov    %esp,%eax
  pushl %eax
  280e5c:	50                   	push   %eax
  movw %ss,%ax
  280e5d:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  280e60:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  280e62:	8e c0                	mov    %eax,%es
  call inthandler21
  280e64:	e8 71 ff ff ff       	call   280dda <inthandler21>
  
  popl %eax
  280e69:	58                   	pop    %eax
  popal
  280e6a:	61                   	popa   
  popw %ds
  280e6b:	66 1f                	popw   %ds
  popW %es
  280e6d:	66 07                	popw   %es
  iretl
  280e6f:	cf                   	iret   

00280e70 <asm_inthandler2c>:
  
#interrupt service about mouse
asm_inthandler2c:
  pushw %es
  280e70:	66 06                	pushw  %es
  pushw %ds
  280e72:	66 1e                	pushw  %ds
  pushal
  280e74:	60                   	pusha  
  movl %esp,%eax
  280e75:	89 e0                	mov    %esp,%eax
  pushl %eax
  280e77:	50                   	push   %eax
  movw %ss,%ax
  280e78:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  280e7b:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  280e7d:	8e c0                	mov    %eax,%es
  call inthandler2c
  280e7f:	e8 7a ff ff ff       	call   280dfe <inthandler2c>
  
  popl %eax
  280e84:	58                   	pop    %eax
  popal
  280e85:	61                   	popa   
  popw %ds
  280e86:	66 1f                	popw   %ds
  popW %es
  280e88:	66 07                	popw   %es
  iretl
  280e8a:	cf                   	iret   

00280e8b <load_gdtr>:
  #iret 与iretl有什么区别？？？
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  280e8b:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  280e90:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lgdt 6(%esp)
  280e95:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  ret
  280e9a:	c3                   	ret    

00280e9b <load_idtr>:


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  280e9b:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  280ea0:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lidt 6(%esp)
  280ea5:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  280eaa:	c3                   	ret    

00280eab <fifo8_init>:
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  280eab:	55                   	push   %ebp
  280eac:	89 e5                	mov    %esp,%ebp
  280eae:	8b 45 08             	mov    0x8(%ebp),%eax
  280eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  fifo->buf=buf;
  280eb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fifo->size=size;
  fifo->free=size;
  fifo->nr=0;
  280eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  fifo->size=size;
  280ebe:	89 50 0c             	mov    %edx,0xc(%eax)
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  280ec1:	89 08                	mov    %ecx,(%eax)
  fifo->size=size;
  fifo->free=size;
  280ec3:	89 50 10             	mov    %edx,0x10(%eax)
  fifo->nr=0;
  fifo->nw=0;
  280ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  fifo->flags=0;
  280ecd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  280ed4:	5d                   	pop    %ebp
  280ed5:	c3                   	ret    

00280ed6 <fifo8_write>:


#define FLAGS_OVERRUN 0X0001
//下面的函数是对fifo类型的变量，写入数据。
int fifo8_write(struct FIFO8 *fifo,unsigned char data)
{
  280ed6:	55                   	push   %ebp
  280ed7:	89 e5                	mov    %esp,%ebp
  280ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  280edc:	53                   	push   %ebx
  280edd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(fifo->free==0)//fifo is full ,no room for any data
  280ee0:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  280ee4:	75 09                	jne    280eef <fifo8_write+0x19>
  {
    fifo->flags|=FLAGS_OVERRUN;//if fifo->flags is TRUE, fifo已经满了，不能再写了。
  280ee6:	83 48 14 01          	orl    $0x1,0x14(%eax)
    return -1; //write error
  280eea:	83 c8 ff             	or     $0xffffffff,%eax
  280eed:	eb 22                	jmp    280f11 <fifo8_write+0x3b>
  }
  
  
 fifo->buf[fifo->nw]=data;
  280eef:	8b 50 04             	mov    0x4(%eax),%edx
  280ef2:	8b 08                	mov    (%eax),%ecx
  280ef4:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
 fifo->nw++;
  280ef7:	8b 48 04             	mov    0x4(%eax),%ecx
  280efa:	8d 51 01             	lea    0x1(%ecx),%edx
 if(fifo->nw==fifo->size)
  280efd:	3b 50 0c             	cmp    0xc(%eax),%edx
    return -1; //write error
  }
  
  
 fifo->buf[fifo->nw]=data;
 fifo->nw++;
  280f00:	89 50 04             	mov    %edx,0x4(%eax)
 if(fifo->nw==fifo->size)
  280f03:	75 07                	jne    280f0c <fifo8_write+0x36>
 {
  fifo->nw=0;  
  280f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 }
 fifo->free--;
  280f0c:	ff 48 10             	decl   0x10(%eax)
 return 0;//write sucessful
  280f0f:	31 c0                	xor    %eax,%eax
 
}
  280f11:	5b                   	pop    %ebx
  280f12:	5d                   	pop    %ebp
  280f13:	c3                   	ret    

00280f14 <fifo8_read>:
//只有写fifo 会有fifo full的情况，
//读fifo时，会有empty的情况。
int fifo8_read(struct FIFO8 *fifo)
{
  280f14:	55                   	push   %ebp
  280f15:	89 e5                	mov    %esp,%ebp
  280f17:	8b 55 08             	mov    0x8(%ebp),%edx
  280f1a:	57                   	push   %edi
  280f1b:	56                   	push   %esi
  280f1c:	53                   	push   %ebx
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  280f1d:	8b 5a 10             	mov    0x10(%edx),%ebx
  280f20:	8b 7a 0c             	mov    0xc(%edx),%edi
  280f23:	39 fb                	cmp    %edi,%ebx
  280f25:	74 1a                	je     280f41 <fifo8_read+0x2d>
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  280f27:	8b 72 08             	mov    0x8(%edx),%esi
  fifo->nr++;
  280f2a:	31 c9                	xor    %ecx,%ecx
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  280f2c:	8b 02                	mov    (%edx),%eax
  280f2e:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
  fifo->nr++;
  280f32:	46                   	inc    %esi
  280f33:	39 fe                	cmp    %edi,%esi
  280f35:	0f 45 ce             	cmovne %esi,%ecx
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  280f38:	43                   	inc    %ebx
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  fifo->nr++;
  280f39:	89 4a 08             	mov    %ecx,0x8(%edx)
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  280f3c:	89 5a 10             	mov    %ebx,0x10(%edx)
  
  return data;
  280f3f:	eb 03                	jmp    280f44 <fifo8_read+0x30>
int fifo8_read(struct FIFO8 *fifo)
{
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  280f41:	83 c8 ff             	or     $0xffffffff,%eax
  fifo->free++;
  
  return data;
  
  
}
  280f44:	5b                   	pop    %ebx
  280f45:	5e                   	pop    %esi
  280f46:	5f                   	pop    %edi
  280f47:	5d                   	pop    %ebp
  280f48:	c3                   	ret    

00280f49 <fifo8_status>:

int fifo8_status(struct FIFO8 *fifo)
{
  280f49:	55                   	push   %ebp
  280f4a:	89 e5                	mov    %esp,%ebp
  280f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  280f4f:	5d                   	pop    %ebp
  
}

int fifo8_status(struct FIFO8 *fifo)
{
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  280f50:	8b 42 0c             	mov    0xc(%edx),%eax
  280f53:	2b 42 10             	sub    0x10(%edx),%eax
  280f56:	c3                   	ret    

00280f57 <enable_mouse>:
#include<header.h>
//激活鼠标的指令　还是向键盘控制器发送指令
#define KEYCMD_SENDTO_MOUSE 	0XD4
#define MOUSECMD_ENABLE     	0XF4
void enable_mouse(struct MOUSE_DEC *mdec)
{
  280f57:	55                   	push   %ebp
  280f58:	89 e5                	mov    %esp,%ebp
  280f5a:	83 ec 08             	sub    $0x8,%esp
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  280f5d:	e8 c5 fe ff ff       	call   280e27 <wait_KBC_sendready>
  280f62:	ba 64 00 00 00       	mov    $0x64,%edx
  280f67:	b0 d4                	mov    $0xd4,%al
  280f69:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_SENDTO_MOUSE);//向port 0x0064　写　0XD4命令  下面的命令发给mouse
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  280f6a:	e8 b8 fe ff ff       	call   280e27 <wait_KBC_sendready>
  280f6f:	ba 60 00 00 00       	mov    $0x60,%edx
  280f74:	b0 f4                	mov    $0xf4,%al
  280f76:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,MOUSECMD_ENABLE); 	//向port 0x0060　写　0Xf4命令  给mouse发送enable命令
  
  mdec->phase=0;
  280f77:	8b 45 08             	mov    0x8(%ebp),%eax
  280f7a:	c6 40 03 00          	movb   $0x0,0x3(%eax)
  return ; 				//if sucessful ,will create an interrupt ,and return ０xfa(ACK),产生的这个0xfa是给cpu的答复信号
					//就算鼠标不动，也会产生这个中断，所以我们一调用enable_mouse，就会产生鼠标中断，必须有这个服务函数。  
}
  280f7e:	c9                   	leave  
  280f7f:	c3                   	ret    

00280f80 <mouse_decode>:


int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  280f80:	55                   	push   %ebp
  280f81:	89 e5                	mov    %esp,%ebp
  280f83:	8b 55 08             	mov    0x8(%ebp),%edx
  280f86:	53                   	push   %ebx
  280f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(mdec->phase==0)
  280f8a:	8a 42 03             	mov    0x3(%edx),%al
  280f8d:	84 c0                	test   %al,%al
  280f8f:	75 0d                	jne    280f9e <mouse_decode+0x1e>
    if(data==0xfa)
    {
      mdec->phase = 1;
      
    }   
    return 0;
  280f91:	31 c0                	xor    %eax,%eax

int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  if(mdec->phase==0)
  {
    if(data==0xfa)
  280f93:	80 f9 fa             	cmp    $0xfa,%cl
  280f96:	75 73                	jne    28100b <mouse_decode+0x8b>
    {
      mdec->phase = 1;
  280f98:	c6 42 03 01          	movb   $0x1,0x3(%edx)
  280f9c:	eb 6d                	jmp    28100b <mouse_decode+0x8b>
      
    }   
    return 0;
  }
  else if(mdec->phase==1) 
  280f9e:	3c 01                	cmp    $0x1,%al
  280fa0:	75 11                	jne    280fb3 <mouse_decode+0x33>
  {
    //鼠标的第一字节的数据
    if( (data & 0xc8) == 0x08 )//如果第一个字节的数据正确  ,只要第一个字节的数据是正确的，后面两个phase的数据就是关于左移 和右移的数据
  280fa2:	88 c8                	mov    %cl,%al
  280fa4:	83 e0 c8             	and    $0xffffffc8,%eax
  280fa7:	3c 08                	cmp    $0x8,%al
  280fa9:	75 5d                	jne    281008 <mouse_decode+0x88>
    {
    mdec->buf[0] = data;
  280fab:	88 0a                	mov    %cl,(%edx)
    mdec->phase  = 2;
  280fad:	c6 42 03 02          	movb   $0x2,0x3(%edx)
  280fb1:	eb 0b                	jmp    280fbe <mouse_decode+0x3e>
    return 0;
    }
  }
  else if(mdec->phase==2) 
  280fb3:	3c 02                	cmp    $0x2,%al
  280fb5:	75 0b                	jne    280fc2 <mouse_decode+0x42>
  {
    mdec->buf[1] = data;
  280fb7:	88 4a 01             	mov    %cl,0x1(%edx)
    mdec->phase  = 3;
  280fba:	c6 42 03 03          	movb   $0x3,0x3(%edx)
    return 0;
  280fbe:	31 c0                	xor    %eax,%eax
  280fc0:	eb 49                	jmp    28100b <mouse_decode+0x8b>
  }
  else if(mdec->phase==3) 
  280fc2:	3c 03                	cmp    $0x3,%al
  280fc4:	75 42                	jne    281008 <mouse_decode+0x88>
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280fc6:	8a 02                	mov    (%edx),%al
    mdec->phase  = 3;
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
  280fc8:	88 4a 02             	mov    %cl,0x2(%edx)
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  280fcb:	0f b6 c9             	movzbl %cl,%ecx
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
  280fce:	c6 42 03 01          	movb   $0x1,0x3(%edx)
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  280fd2:	89 4a 08             	mov    %ecx,0x8(%edx)
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280fd5:	89 c3                	mov    %eax,%ebx
  280fd7:	83 e3 07             	and    $0x7,%ebx
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  280fda:	a8 10                	test   $0x10,%al
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280fdc:	89 5a 0c             	mov    %ebx,0xc(%edx)
    mdec->x =mdec->buf[1];
  280fdf:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  280fe3:	89 5a 04             	mov    %ebx,0x4(%edx)
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  280fe6:	74 09                	je     280ff1 <mouse_decode+0x71>
    {
      mdec->x |=0xffffff00;//-x 根据buf[0]的bit4为1时，确定鼠标的移动方向是负方向。
  280fe8:	81 cb 00 ff ff ff    	or     $0xffffff00,%ebx
  280fee:	89 5a 04             	mov    %ebx,0x4(%edx)
    }
    if( (mdec->buf[0] & 0x20) != 0)//bit5为1时 2
  280ff1:	a8 20                	test   $0x20,%al
  280ff3:	74 09                	je     280ffe <mouse_decode+0x7e>
    {
      mdec->y |=0xffffff00;//-y
  280ff5:	81 c9 00 ff ff ff    	or     $0xffffff00,%ecx
  280ffb:	89 4a 08             	mov    %ecx,0x8(%edx)
    }
    
    mdec->y= - mdec->y;//鼠标的移动方向与屏幕的方向是相反的。
  280ffe:	f7 5a 08             	negl   0x8(%edx)


    return 1;
  281001:	b8 01 00 00 00       	mov    $0x1,%eax
  281006:	eb 03                	jmp    28100b <mouse_decode+0x8b>
  }
  //buf0中的数据非常的重要，低四位与左右按键有关，高四位与方向有关。
  //高四位0－1－2－3，低四位8 9(left) a(right) b(both) c(middle)
   return -1;
  281008:	83 c8 ff             	or     $0xffffffff,%eax
}
  28100b:	5b                   	pop    %ebx
  28100c:	5d                   	pop    %ebp
  28100d:	c3                   	ret    

0028100e <getmemorysize>:
#include<mm.h>

 //下面的程序只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
unsigned int getmemorysize(unsigned int start,unsigned int end)
{
  28100e:	55                   	push   %ebp
  28100f:	89 e5                	mov    %esp,%ebp
  281011:	8b 45 08             	mov    0x8(%ebp),%eax
  281014:	53                   	push   %ebx
 unsigned int old;


 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  281015:	3b 45 0c             	cmp    0xc(%ebp),%eax
  281018:	77 2b                	ja     281045 <getmemorysize+0x37>
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  28101a:	8b 90 00 08 00 00    	mov    0x800(%eax),%edx
  *p=pat0;
  281020:	c7 80 00 08 00 00 55 	movl   $0xaa55aa55,0x800(%eax)
  281027:	aa 55 aa 
  if(*p!=pat0)
  28102a:	8b 98 00 08 00 00    	mov    0x800(%eax),%ebx
  {
   *p=old;
  281030:	89 90 00 08 00 00    	mov    %edx,0x800(%eax)
 for(i=start;i<=end;i+=0x1000)
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  *p=pat0;
  if(*p!=pat0)
  281036:	81 fb 55 aa 55 aa    	cmp    $0xaa55aa55,%ebx
  28103c:	75 07                	jne    281045 <getmemorysize+0x37>
 unsigned int old;


 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  28103e:	05 00 10 00 00       	add    $0x1000,%eax
  281043:	eb d0                	jmp    281015 <getmemorysize+0x7>
 }
 return i;//i就是得到的memory size



}
  281045:	5b                   	pop    %ebx
  281046:	5d                   	pop    %ebp
  281047:	c3                   	ret    

00281048 <memtest>:

unsigned int memtest(unsigned int start,unsigned int end)
{
  281048:	55                   	push   %ebp
  281049:	89 e5                	mov    %esp,%ebp
  28104b:	53                   	push   %ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  28104c:	9c                   	pushf  
  28104d:	58                   	pop    %eax
 char flg486=0;
 unsigned int eflg,cr0,i;
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
  28104e:	0d 00 00 04 00       	or     $0x40000,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  281053:	50                   	push   %eax
  281054:	9d                   	popf   
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  281055:	9c                   	pushf  
  281056:	58                   	pop    %eax

}

unsigned int memtest(unsigned int start,unsigned int end)
{
 char flg486=0;
  281057:	31 db                	xor    %ebx,%ebx
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
  281059:	a9 00 00 04 00       	test   $0x40000,%eax
  28105e:	74 14                	je     281074 <memtest+0x2c>
 {
  flg486=1;
  eflg&=~EFLAGS_AC_BIT;
  281060:	25 ff ff fb ff       	and    $0xfffbffff,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  281065:	50                   	push   %eax
  281066:	9d                   	popf   

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  281067:	0f 20 c0             	mov    %cr0,%eax
  write_eflags(eflg);
 }
 if(flg486)
 {
  cr0=rcr0();
  cr0|=CR0_CACHE_DISABLE;
  28106a:	0d 00 00 00 60       	or     $0x60000000,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  28106f:	0f 22 c0             	mov    %eax,%cr0
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
 {
  flg486=1;
  281072:	b3 01                	mov    $0x1,%bl
  cr0|=CR0_CACHE_DISABLE;
  lcr0(cr0);
 }


i=getmemorysize(start,end);
  281074:	ff 75 0c             	pushl  0xc(%ebp)
  281077:	ff 75 08             	pushl  0x8(%ebp)
  28107a:	e8 8f ff ff ff       	call   28100e <getmemorysize>
//i=0x100000;

  if(flg486)
  28107f:	84 db                	test   %bl,%bl
  281081:	5a                   	pop    %edx
  281082:	59                   	pop    %ecx
  281083:	74 0c                	je     281091 <memtest+0x49>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  281085:	0f 20 c2             	mov    %cr0,%edx
  {
  cr0=rcr0();
  cr0&=~CR0_CACHE_DISABLE;
  281088:	81 e2 ff ff ff 9f    	and    $0x9fffffff,%edx
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  28108e:	0f 22 c2             	mov    %edx,%cr0
  lcr0(cr0);

  }

  return i;
}
  281091:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  281094:	c9                   	leave  
  281095:	c3                   	ret    

00281096 <memman_init>:


void memman_init(Memman * man)
{
  281096:	55                   	push   %ebp
  281097:	89 e5                	mov    %esp,%ebp
  281099:	8b 45 08             	mov    0x8(%ebp),%eax
 man->cellnum=0;
  28109c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 man->maxcell=0;
  2810a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 man->lostsize=0;
  2810a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
 man->losts=0;
  2810b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  2810b7:	5d                   	pop    %ebp
  2810b8:	c3                   	ret    

002810b9 <memman_avail>:
//get available memory
unsigned int memman_avail(Memman *man)
{
  2810b9:	55                   	push   %ebp
 unsigned int i;
 unsigned int freemem=0;
  2810ba:	31 c0                	xor    %eax,%eax
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  2810bc:	89 e5                	mov    %esp,%ebp
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  2810be:	31 d2                	xor    %edx,%edx
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  2810c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2810c3:	53                   	push   %ebx
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  2810c4:	8b 19                	mov    (%ecx),%ebx
  2810c6:	39 da                	cmp    %ebx,%edx
  2810c8:	74 07                	je     2810d1 <memman_avail+0x18>
 {
   freemem+=man->cell[i].size;
  2810ca:	03 44 d1 14          	add    0x14(%ecx,%edx,8),%eax
//get available memory
unsigned int memman_avail(Memman *man)
{
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  2810ce:	42                   	inc    %edx
  2810cf:	eb f5                	jmp    2810c6 <memman_avail+0xd>
 {
   freemem+=man->cell[i].size;
 }
 return freemem;
}
  2810d1:	5b                   	pop    %ebx
  2810d2:	5d                   	pop    %ebp
  2810d3:	c3                   	ret    

002810d4 <memman_alloc>:
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  2810d4:	55                   	push   %ebp
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  2810d5:	31 d2                	xor    %edx,%edx
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  2810d7:	89 e5                	mov    %esp,%ebp
  2810d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2810dc:	57                   	push   %edi
  2810dd:	56                   	push   %esi
  2810de:	53                   	push   %ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  2810df:	8b 39                	mov    (%ecx),%edi
  2810e1:	39 fa                	cmp    %edi,%edx
  2810e3:	74 43                	je     281128 <memman_alloc+0x54>
    {
        if(man->cell[i].size>size)
  2810e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  2810e8:	39 44 d1 14          	cmp    %eax,0x14(%ecx,%edx,8)
  2810ec:	76 37                	jbe    281125 <memman_alloc+0x51>
  2810ee:	8d 34 d1             	lea    (%ecx,%edx,8),%esi
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
  2810f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
  2810f4:	8b 46 10             	mov    0x10(%esi),%eax
            man->cell[i].address+=size;
  2810f7:	01 c3                	add    %eax,%ebx
  2810f9:	89 5e 10             	mov    %ebx,0x10(%esi)
            man->cell[i].size-=size;
  2810fc:	8b 5e 14             	mov    0x14(%esi),%ebx
  2810ff:	2b 5d 0c             	sub    0xc(%ebp),%ebx
            if(man->cell[i].size==0)
  281102:	85 db                	test   %ebx,%ebx
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
            man->cell[i].size-=size;
  281104:	89 5e 14             	mov    %ebx,0x14(%esi)
            if(man->cell[i].size==0)
  281107:	75 21                	jne    28112a <memman_alloc+0x56>
            {
                man->cellnum--;
  281109:	8d 5f ff             	lea    -0x1(%edi),%ebx
  28110c:	89 19                	mov    %ebx,(%ecx)
                for(;i<man->cellnum;i++)
  28110e:	39 da                	cmp    %ebx,%edx
  281110:	73 18                	jae    28112a <memman_alloc+0x56>
                {
                    man->cell[i]=man->cell[i+1];
  281112:	42                   	inc    %edx
  281113:	8b 74 d1 10          	mov    0x10(%ecx,%edx,8),%esi
  281117:	8b 7c d1 14          	mov    0x14(%ecx,%edx,8),%edi
  28111b:	89 74 d1 08          	mov    %esi,0x8(%ecx,%edx,8)
  28111f:	89 7c d1 0c          	mov    %edi,0xc(%ecx,%edx,8)
  281123:	eb e9                	jmp    28110e <memman_alloc+0x3a>
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  281125:	42                   	inc    %edx
  281126:	eb b9                	jmp    2810e1 <memman_alloc+0xd>
            }

            return a;
        }
    }
    return 0; //no memory can be used
  281128:	31 c0                	xor    %eax,%eax
}
  28112a:	5b                   	pop    %ebx
  28112b:	5e                   	pop    %esi
  28112c:	5f                   	pop    %edi
  28112d:	5d                   	pop    %ebp
  28112e:	c3                   	ret    

0028112f <memman_alloc_4K>:
 }
 return freemem;
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  28112f:	55                   	push   %ebp
  281130:	89 e5                	mov    %esp,%ebp
  size=(size+0xfff)&0xfffff000;
  281132:	8b 45 0c             	mov    0xc(%ebp),%eax
  281135:	05 ff 0f 00 00       	add    $0xfff,%eax
  28113a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return memman_alloc(man,size);
  28113f:	89 45 0c             	mov    %eax,0xc(%ebp)
}
  281142:	5d                   	pop    %ebp
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
  281143:	e9 8c ff ff ff       	jmp    2810d4 <memman_alloc>

00281148 <memman_free>:
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  281148:	55                   	push   %ebp
  int i,j;
  for (i=0;i<man->cellnum;i++)
  281149:	31 d2                	xor    %edx,%edx
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  28114b:	89 e5                	mov    %esp,%ebp
  28114d:	57                   	push   %edi
  28114e:	56                   	push   %esi
  28114f:	53                   	push   %ebx
  281150:	83 ec 08             	sub    $0x8,%esp
  281153:	8b 45 08             	mov    0x8(%ebp),%eax
  281156:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i,j;
  for (i=0;i<man->cellnum;i++)
  281159:	8b 18                	mov    (%eax),%ebx
  28115b:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  28115e:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  281161:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  281164:	74 09                	je     28116f <memman_free+0x27>
  {
    if(man->cell[i].address>addr)//这一步可以找到一个合适的i的地址范围
  281166:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  281169:	39 5c d0 10          	cmp    %ebx,0x10(%eax,%edx,8)
  28116d:	76 06                	jbe    281175 <memman_free+0x2d>
    }
  }

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  28116f:	85 d2                	test   %edx,%edx
  281171:	75 05                	jne    281178 <memman_free+0x30>
  281173:	eb 4c                	jmp    2811c1 <memman_free+0x79>
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  int i,j;
  for (i=0;i<man->cellnum;i++)
  281175:	42                   	inc    %edx
  281176:	eb e9                	jmp    281161 <memman_free+0x19>
  281178:	8d 5c d0 f8          	lea    -0x8(%eax,%edx,8),%ebx

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
  28117c:	8b 73 14             	mov    0x14(%ebx),%esi
  28117f:	8b 4b 10             	mov    0x10(%ebx),%ecx
  281182:	01 f1                	add    %esi,%ecx
  281184:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
  281187:	75 38                	jne    2811c1 <memman_free+0x79>
    {
        man->cell[i-1].size+=size;
  281189:	01 fe                	add    %edi,%esi
        if(i<man->cellnum)
  28118b:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
    {
        man->cell[i-1].size+=size;
  28118e:	89 73 14             	mov    %esi,0x14(%ebx)
        if(i<man->cellnum)
  281191:	73 49                	jae    2811dc <memman_free+0x94>
  281193:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
        {
            if(addr+size==man->cell[i].address)
  281196:	03 7d 0c             	add    0xc(%ebp),%edi
  281199:	3b 79 10             	cmp    0x10(%ecx),%edi
  28119c:	75 3e                	jne    2811dc <memman_free+0x94>
            {
                man->cell[i-1].size+=man->cell[i].size;
  28119e:	03 71 14             	add    0x14(%ecx),%esi
  2811a1:	89 73 14             	mov    %esi,0x14(%ebx)
                man->cellnum--;
  2811a4:	8b 75 f0             	mov    -0x10(%ebp),%esi
  2811a7:	4e                   	dec    %esi
  2811a8:	89 30                	mov    %esi,(%eax)

                for(;i<man->cellnum;i++)
  2811aa:	39 f2                	cmp    %esi,%edx
  2811ac:	73 2e                	jae    2811dc <memman_free+0x94>
                {
                man->cell[i]=man->cell[i+1];
  2811ae:	42                   	inc    %edx
  2811af:	8b 4c d0 10          	mov    0x10(%eax,%edx,8),%ecx
  2811b3:	8b 5c d0 14          	mov    0x14(%eax,%edx,8),%ebx
  2811b7:	89 4c d0 08          	mov    %ecx,0x8(%eax,%edx,8)
  2811bb:	89 5c d0 0c          	mov    %ebx,0xc(%eax,%edx,8)
  2811bf:	eb e9                	jmp    2811aa <memman_free+0x62>
     //printdebug(200,100);

  }

  //与后面的空间合并
  if(i<man->cellnum)
  2811c1:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  2811c4:	73 1a                	jae    2811e0 <memman_free+0x98>
  {
     if(addr+size==man->cell[i].address)
  2811c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  2811c9:	8d 1c d0             	lea    (%eax,%edx,8),%ebx
  2811cc:	01 fe                	add    %edi,%esi
  2811ce:	3b 73 10             	cmp    0x10(%ebx),%esi
  2811d1:	75 0d                	jne    2811e0 <memman_free+0x98>
     {
        man->cell[i].address=addr;
  2811d3:	8b 45 0c             	mov    0xc(%ebp),%eax
        man->cell[i].size+=size;
  2811d6:	01 7b 14             	add    %edi,0x14(%ebx)
  //与后面的空间合并
  if(i<man->cellnum)
  {
     if(addr+size==man->cell[i].address)
     {
        man->cell[i].address=addr;
  2811d9:	89 43 10             	mov    %eax,0x10(%ebx)
        man->cell[i].size+=size;

        return 0;
  2811dc:	31 c0                	xor    %eax,%eax
  2811de:	eb 4b                	jmp    28122b <memman_free+0xe3>
     }
  }

  if(man->cellnum<4090)
  2811e0:	81 7d f0 f9 0f 00 00 	cmpl   $0xff9,-0x10(%ebp)
  2811e7:	77 39                	ja     281222 <memman_free+0xda>
  {
        for(j=man->cellnum;j>i;j--)
  2811e9:	39 55 ec             	cmp    %edx,-0x14(%ebp)
  2811ec:	7e 18                	jle    281206 <memman_free+0xbe>
        {
            man->cell[j]=man->cell[j-1];
  2811ee:	ff 4d ec             	decl   -0x14(%ebp)
  2811f1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  2811f4:	8b 5c c8 10          	mov    0x10(%eax,%ecx,8),%ebx
  2811f8:	8b 74 c8 14          	mov    0x14(%eax,%ecx,8),%esi
  2811fc:	89 5c c8 18          	mov    %ebx,0x18(%eax,%ecx,8)
  281200:	89 74 c8 1c          	mov    %esi,0x1c(%eax,%ecx,8)
  281204:	eb e3                	jmp    2811e9 <memman_free+0xa1>
        }

        man->cellnum++;
  281206:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  281209:	41                   	inc    %ecx
        if(man->maxcell<man->cellnum)
  28120a:	39 48 04             	cmp    %ecx,0x4(%eax)
        for(j=man->cellnum;j>i;j--)
        {
            man->cell[j]=man->cell[j-1];
        }

        man->cellnum++;
  28120d:	89 08                	mov    %ecx,(%eax)
        if(man->maxcell<man->cellnum)
  28120f:	73 03                	jae    281214 <memman_free+0xcc>
        {
            man->maxcell=man->cellnum;
  281211:	89 48 04             	mov    %ecx,0x4(%eax)
  281214:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        }
        man->cell[i].address=addr;
  281217:	8b 55 0c             	mov    0xc(%ebp),%edx
        man->cell[i].size=size;
  28121a:	89 78 14             	mov    %edi,0x14(%eax)
        man->cellnum++;
        if(man->maxcell<man->cellnum)
        {
            man->maxcell=man->cellnum;
        }
        man->cell[i].address=addr;
  28121d:	89 50 10             	mov    %edx,0x10(%eax)
  281220:	eb ba                	jmp    2811dc <memman_free+0x94>
       // printdebug(man->cellnum,100);
        return 0;
  }


  man->losts++;
  281222:	ff 40 0c             	incl   0xc(%eax)
  man->lostsize+=size;
  281225:	01 78 08             	add    %edi,0x8(%eax)

  return  -1;
  281228:	83 c8 ff             	or     $0xffffffff,%eax
}
  28122b:	5a                   	pop    %edx
  28122c:	59                   	pop    %ecx
  28122d:	5b                   	pop    %ebx
  28122e:	5e                   	pop    %esi
  28122f:	5f                   	pop    %edi
  281230:	5d                   	pop    %ebp
  281231:	c3                   	ret    

00281232 <memman_free_4k>:
    return 0; //no memory can be used
}

//return -1 means free memory failure
int memman_free_4k(Memman *man,unsigned int addr,unsigned int size)
{
  281232:	55                   	push   %ebp
  281233:	89 e5                	mov    %esp,%ebp
  size=(size+0xfff)& 0xfffff000;
  281235:	8b 45 10             	mov    0x10(%ebp),%eax
  281238:	05 ff 0f 00 00       	add    $0xfff,%eax
  28123d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return memman_free(man,addr,size);
  281242:	89 45 10             	mov    %eax,0x10(%ebp)
}
  281245:	5d                   	pop    %ebp

//return -1 means free memory failure
int memman_free_4k(Memman *man,unsigned int addr,unsigned int size)
{
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
  281246:	e9 fd fe ff ff       	jmp    281148 <memman_free>

0028124b <shtctl_init>:

  return  -1;
}

SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize)
{
  28124b:	55                   	push   %ebp
  28124c:	89 e5                	mov    %esp,%ebp
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
  28124e:	68 00 30 00 00       	push   $0x3000
  281253:	ff 75 08             	pushl  0x8(%ebp)
  281256:	e8 79 fe ff ff       	call   2810d4 <memman_alloc>
SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize)
{
  SHTCTL *ctl;
  int i;
  ctl=(SHTCTL *)memman_alloc_4K(memman,sizeof(SHTCTL));
  if(ctl==0)
  28125b:	5a                   	pop    %edx
  28125c:	59                   	pop    %ecx
  28125d:	85 c0                	test   %eax,%eax
  28125f:	74 2d                	je     28128e <shtctl_init+0x43>
  return ctl;

  ctl->vram=vram;
  281261:	8b 55 0c             	mov    0xc(%ebp),%edx
  ctl->xsize=xsize;
  ctl->ysize=ysize;
  ctl->top=0;  //no sheet
  281264:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  int i;
  ctl=(SHTCTL *)memman_alloc_4K(memman,sizeof(SHTCTL));
  if(ctl==0)
  return ctl;

  ctl->vram=vram;
  28126b:	89 10                	mov    %edx,(%eax)
  ctl->xsize=xsize;
  28126d:	8b 55 10             	mov    0x10(%ebp),%edx
  281270:	89 50 04             	mov    %edx,0x4(%eax)
  ctl->ysize=ysize;
  281273:	8b 55 14             	mov    0x14(%ebp),%edx
  281276:	89 50 08             	mov    %edx,0x8(%eax)
  ctl->top=0;  //no sheet
  281279:	31 d2                	xor    %edx,%edx
  for(i=0;i<MAX_SHEETS;i++)
  {
    ctl->sheet[i].flags=0;
  28127b:	c7 44 10 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,1)
  281282:	00 
  281283:	83 c2 20             	add    $0x20,%edx

  ctl->vram=vram;
  ctl->xsize=xsize;
  ctl->ysize=ysize;
  ctl->top=0;  //no sheet
  for(i=0;i<MAX_SHEETS;i++)
  281286:	81 fa 00 20 00 00    	cmp    $0x2000,%edx
  28128c:	75 ed                	jne    28127b <shtctl_init+0x30>
  {
    ctl->sheet[i].flags=0;
  }
  return ctl;
}
  28128e:	c9                   	leave  
  28128f:	c3                   	ret    

00281290 <sheet_alloc>:

SHEET * sheet_alloc(SHTCTL * ctl)
{
  281290:	55                   	push   %ebp
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  281291:	31 c0                	xor    %eax,%eax
  }
  return ctl;
}

SHEET * sheet_alloc(SHTCTL * ctl)
{
  281293:	89 e5                	mov    %esp,%ebp
  281295:	8b 55 08             	mov    0x8(%ebp),%edx
  281298:	89 c1                	mov    %eax,%ecx
  28129a:	c1 e1 05             	shl    $0x5,%ecx
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  {
    if (ctl->sheet[i].flags==0)
  28129d:	83 7c 0a 2c 00       	cmpl   $0x0,0x2c(%edx,%ecx,1)
  2812a2:	75 14                	jne    2812b8 <sheet_alloc+0x28>
    {
        sht=&ctl->sheet[i];
  2812a4:	8d 44 0a 10          	lea    0x10(%edx,%ecx,1),%eax
        sht->flags=1;
  2812a8:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
        sht->height=-1;
  2812af:	c7 40 18 ff ff ff ff 	movl   $0xffffffff,0x18(%eax)
        return sht;
  2812b6:	eb 0b                	jmp    2812c3 <sheet_alloc+0x33>

SHEET * sheet_alloc(SHTCTL * ctl)
{
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  2812b8:	40                   	inc    %eax
  2812b9:	3d 00 01 00 00       	cmp    $0x100,%eax
  2812be:	75 d8                	jne    281298 <sheet_alloc+0x8>
        sht->flags=1;
        sht->height=-1;
        return sht;
    }
  }
  return 0;
  2812c0:	66 31 c0             	xor    %ax,%ax
}
  2812c3:	5d                   	pop    %ebp
  2812c4:	c3                   	ret    

002812c5 <sheet_setbuf>:



void sheet_setbuf(SHEET * sht,unsigned char *buf,int xsize,int ysize,int col_inv)
{
  2812c5:	55                   	push   %ebp
  2812c6:	89 e5                	mov    %esp,%ebp
  2812c8:	8b 45 08             	mov    0x8(%ebp),%eax
  sht->buf=buf;
  2812cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  2812ce:	89 10                	mov    %edx,(%eax)
  sht->bxsize=xsize;
  2812d0:	8b 55 10             	mov    0x10(%ebp),%edx
  2812d3:	89 50 04             	mov    %edx,0x4(%eax)
  sht->bysize=ysize;
  2812d6:	8b 55 14             	mov    0x14(%ebp),%edx
  2812d9:	89 50 08             	mov    %edx,0x8(%eax)
  sht->col_inv=col_inv;
  2812dc:	8b 55 18             	mov    0x18(%ebp),%edx
  2812df:	89 50 14             	mov    %edx,0x14(%eax)
  return ;
}
  2812e2:	5d                   	pop    %ebp
  2812e3:	c3                   	ret    

002812e4 <sheet_refreshsub>:
 return;
}


void sheet_refreshsub(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1)
{
  2812e4:	55                   	push   %ebp
  2812e5:	89 e5                	mov    %esp,%ebp
  2812e7:	57                   	push   %edi
unsigned char *buf,*vram=ctl->vram;
unsigned char c;


SHEET *sht;
for (h=0;h<ctl->top;h++)
  2812e8:	31 ff                	xor    %edi,%edi
 return;
}


void sheet_refreshsub(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1)
{
  2812ea:	56                   	push   %esi
  2812eb:	53                   	push   %ebx
  2812ec:	83 ec 14             	sub    $0x14,%esp
int h,bx,by,vx,vy;
unsigned char *buf,*vram=ctl->vram;
  2812ef:	8b 45 08             	mov    0x8(%ebp),%eax
  2812f2:	8b 00                	mov    (%eax),%eax
  2812f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
unsigned char c;


SHEET *sht;
for (h=0;h<ctl->top;h++)
  2812f7:	8b 45 08             	mov    0x8(%ebp),%eax
  2812fa:	3b 78 0c             	cmp    0xc(%eax),%edi
  2812fd:	0f 8d 84 00 00 00    	jge    281387 <sheet_refreshsub+0xa3>
{
  sht=ctl->sheets[h];
  281303:	8b 45 08             	mov    0x8(%ebp),%eax
  buf=sht->buf;
  for(by=0;by<sht->bysize;by++)
  281306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)


SHEET *sht;
for (h=0;h<ctl->top;h++)
{
  sht=ctl->sheets[h];
  28130d:	8b 84 b8 10 20 00 00 	mov    0x2010(%eax,%edi,4),%eax
  buf=sht->buf;
  281314:	8b 10                	mov    (%eax),%edx
  281316:	89 55 e0             	mov    %edx,-0x20(%ebp)
  for(by=0;by<sht->bysize;by++)
  281319:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  28131c:	3b 48 08             	cmp    0x8(%eax),%ecx
  28131f:	7d 60                	jge    281381 <sheet_refreshsub+0x9d>
  {
    vy=sht->vy0+by;
  281321:	8b 5d f0             	mov    -0x10(%ebp),%ebx
    for(bx=0;bx<sht->bxsize;bx++)
  281324:	31 c9                	xor    %ecx,%ecx
{
  sht=ctl->sheets[h];
  buf=sht->buf;
  for(by=0;by<sht->bysize;by++)
  {
    vy=sht->vy0+by;
  281326:	03 58 10             	add    0x10(%eax),%ebx
  281329:	89 5d ec             	mov    %ebx,-0x14(%ebp)
    for(bx=0;bx<sht->bxsize;bx++)
  28132c:	8b 58 04             	mov    0x4(%eax),%ebx
  28132f:	39 d9                	cmp    %ebx,%ecx
  281331:	7d 49                	jge    28137c <sheet_refreshsub+0x98>
    {
        vx=sht->vx0+bx;
  281333:	8b 70 0c             	mov    0xc(%eax),%esi
  281336:	01 ce                	add    %ecx,%esi
        if(vx0<=vx && vx <vx1 && vy>=vy0 && vy<vy1)
  281338:	39 75 0c             	cmp    %esi,0xc(%ebp)
  for(by=0;by<sht->bysize;by++)
  {
    vy=sht->vy0+by;
    for(bx=0;bx<sht->bxsize;bx++)
    {
        vx=sht->vx0+bx;
  28133b:	89 75 e8             	mov    %esi,-0x18(%ebp)
        if(vx0<=vx && vx <vx1 && vy>=vy0 && vy<vy1)
  28133e:	7f 39                	jg     281379 <sheet_refreshsub+0x95>
  281340:	3b 75 14             	cmp    0x14(%ebp),%esi
  281343:	7d 34                	jge    281379 <sheet_refreshsub+0x95>
  281345:	8b 75 ec             	mov    -0x14(%ebp),%esi
  281348:	3b 75 10             	cmp    0x10(%ebp),%esi
  28134b:	7c 2c                	jl     281379 <sheet_refreshsub+0x95>
  28134d:	3b 75 18             	cmp    0x18(%ebp),%esi
  281350:	7d 27                	jge    281379 <sheet_refreshsub+0x95>
        {
            c=buf[by*sht->bxsize+bx];
  281352:	8b 75 e0             	mov    -0x20(%ebp),%esi
  281355:	0f af 5d f0          	imul   -0x10(%ebp),%ebx
  281359:	01 ce                	add    %ecx,%esi
  28135b:	8a 14 1e             	mov    (%esi,%ebx,1),%dl
            if(c!=sht->col_inv)
  28135e:	0f b6 f2             	movzbl %dl,%esi
  281361:	3b 70 14             	cmp    0x14(%eax),%esi
  281364:	74 13                	je     281379 <sheet_refreshsub+0x95>
            {
                vram[vy*ctl->xsize+vx]=c;
  281366:	8b 5d 08             	mov    0x8(%ebp),%ebx
  281369:	8b 75 ec             	mov    -0x14(%ebp),%esi
  28136c:	0f af 73 04          	imul   0x4(%ebx),%esi
  281370:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  281373:	03 5d e4             	add    -0x1c(%ebp),%ebx
  281376:	88 14 33             	mov    %dl,(%ebx,%esi,1)
  sht=ctl->sheets[h];
  buf=sht->buf;
  for(by=0;by<sht->bysize;by++)
  {
    vy=sht->vy0+by;
    for(bx=0;bx<sht->bxsize;bx++)
  281379:	41                   	inc    %ecx
  28137a:	eb b0                	jmp    28132c <sheet_refreshsub+0x48>
SHEET *sht;
for (h=0;h<ctl->top;h++)
{
  sht=ctl->sheets[h];
  buf=sht->buf;
  for(by=0;by<sht->bysize;by++)
  28137c:	ff 45 f0             	incl   -0x10(%ebp)
  28137f:	eb 98                	jmp    281319 <sheet_refreshsub+0x35>
unsigned char *buf,*vram=ctl->vram;
unsigned char c;


SHEET *sht;
for (h=0;h<ctl->top;h++)
  281381:	47                   	inc    %edi
  281382:	e9 70 ff ff ff       	jmp    2812f7 <sheet_refreshsub+0x13>
    }
  }
}
return;

}
  281387:	83 c4 14             	add    $0x14,%esp
  28138a:	5b                   	pop    %ebx
  28138b:	5e                   	pop    %esi
  28138c:	5f                   	pop    %edi
  28138d:	5d                   	pop    %ebp
  28138e:	c3                   	ret    

0028138f <sheet_updown>:
  return ;
}


void sheet_updown(SHTCTL * ctl,SHEET * sht,int height)
{
  28138f:	55                   	push   %ebp
  281390:	89 e5                	mov    %esp,%ebp
  281392:	57                   	push   %edi
  281393:	56                   	push   %esi
  281394:	53                   	push   %ebx
  281395:	50                   	push   %eax
  281396:	8b 45 08             	mov    0x8(%ebp),%eax
  281399:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  28139c:	8b 7d 10             	mov    0x10(%ebp),%edi
 int h ,old=sht->height;
 if(height>ctl->top+1)
  28139f:	8b 58 0c             	mov    0xc(%eax),%ebx
}


void sheet_updown(SHTCTL * ctl,SHEET * sht,int height)
{
 int h ,old=sht->height;
  2813a2:	8b 51 18             	mov    0x18(%ecx),%edx
 if(height>ctl->top+1)
  2813a5:	8d 73 01             	lea    0x1(%ebx),%esi
  2813a8:	39 f7                	cmp    %esi,%edi
  2813aa:	0f 4f fe             	cmovg  %esi,%edi
  2813ad:	89 75 f0             	mov    %esi,-0x10(%ebp)
  2813b0:	83 ce ff             	or     $0xffffffff,%esi
  2813b3:	85 ff                	test   %edi,%edi
  2813b5:	0f 49 f7             	cmovns %edi,%esi
 {
  height=-1;
 }
 sht->height=height;

 if(old>height)
  2813b8:	39 f2                	cmp    %esi,%edx

 if(height<-1)
 {
  height=-1;
 }
 sht->height=height;
  2813ba:	89 71 18             	mov    %esi,0x18(%ecx)

 if(old>height)
  2813bd:	7e 4f                	jle    28140e <sheet_updown+0x7f>
 {
   if(height>=0)
  2813bf:	85 f6                	test   %esi,%esi
  2813c1:	78 25                	js     2813e8 <sheet_updown+0x59>
   {
        for(h=old;h>height;h--)
        {
            ctl->sheets[h]=ctl->sheets[h-1];
  2813c3:	8d 5a ff             	lea    -0x1(%edx),%ebx
  2813c6:	8b bc 98 10 20 00 00 	mov    0x2010(%eax,%ebx,4),%edi

 if(old>height)
 {
   if(height>=0)
   {
        for(h=old;h>height;h--)
  2813cd:	39 f3                	cmp    %esi,%ebx
        {
            ctl->sheets[h]=ctl->sheets[h-1];
  2813cf:	89 bc 98 14 20 00 00 	mov    %edi,0x2014(%eax,%ebx,4)
            ctl->sheets[h]->height=h;
  2813d6:	89 57 18             	mov    %edx,0x18(%edi)

 if(old>height)
 {
   if(height>=0)
   {
        for(h=old;h>height;h--)
  2813d9:	74 04                	je     2813df <sheet_updown+0x50>
  2813db:	89 da                	mov    %ebx,%edx
  2813dd:	eb e4                	jmp    2813c3 <sheet_updown+0x34>
        {
            ctl->sheets[h]=ctl->sheets[h-1];
            ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
  2813df:	89 8c 90 0c 20 00 00 	mov    %ecx,0x200c(%eax,%edx,4)
  2813e6:	eb 79                	jmp    281461 <sheet_updown+0xd2>
   }
   else
   {
        if(ctl->top>old)
  2813e8:	39 d3                	cmp    %edx,%ebx
  2813ea:	7f 06                	jg     2813f2 <sheet_updown+0x63>
                ctl->sheets[h]=ctl->sheets[h+1];
                ctl->sheets[h]->height=h;
            }

        }
        ctl->top--;
  2813ec:	4b                   	dec    %ebx
  2813ed:	89 58 0c             	mov    %ebx,0xc(%eax)
  2813f0:	eb 6f                	jmp    281461 <sheet_updown+0xd2>
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
            {
                ctl->sheets[h]=ctl->sheets[h+1];
  2813f2:	8d 72 01             	lea    0x1(%edx),%esi
  2813f5:	8b bc b0 10 20 00 00 	mov    0x2010(%eax,%esi,4),%edi
   }
   else
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
  2813fc:	39 de                	cmp    %ebx,%esi
            {
                ctl->sheets[h]=ctl->sheets[h+1];
  2813fe:	89 bc b0 0c 20 00 00 	mov    %edi,0x200c(%eax,%esi,4)
                ctl->sheets[h]->height=h;
  281405:	89 57 18             	mov    %edx,0x18(%edi)
   }
   else
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
  281408:	74 e2                	je     2813ec <sheet_updown+0x5d>
  28140a:	89 f2                	mov    %esi,%edx
  28140c:	eb e4                	jmp    2813f2 <sheet_updown+0x63>
        }
        ctl->top--;
   }
  sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize);
 }
 else if(old<height)
  28140e:	7d 6e                	jge    28147e <sheet_updown+0xef>
 {

    if(old>0)
  281410:	85 d2                	test   %edx,%edx
  281412:	7e 25                	jle    281439 <sheet_updown+0xaa>
    {

        for(h=old;h<height;h++)
        {
         ctl->sheets[h]=ctl->sheets[h+1];
  281414:	8d 5a 01             	lea    0x1(%edx),%ebx
  281417:	8b bc 98 10 20 00 00 	mov    0x2010(%eax,%ebx,4),%edi
 {

    if(old>0)
    {

        for(h=old;h<height;h++)
  28141e:	39 f3                	cmp    %esi,%ebx
        {
         ctl->sheets[h]=ctl->sheets[h+1];
  281420:	89 bc 98 0c 20 00 00 	mov    %edi,0x200c(%eax,%ebx,4)
         ctl->sheets[h]->height=h;
  281427:	89 57 18             	mov    %edx,0x18(%edi)
 {

    if(old>0)
    {

        for(h=old;h<height;h++)
  28142a:	74 04                	je     281430 <sheet_updown+0xa1>
  28142c:	89 da                	mov    %ebx,%edx
  28142e:	eb e4                	jmp    281414 <sheet_updown+0x85>
        {
         ctl->sheets[h]=ctl->sheets[h+1];
         ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
  281430:	89 8c 90 14 20 00 00 	mov    %ecx,0x2014(%eax,%edx,4)
  281437:	eb 28                	jmp    281461 <sheet_updown+0xd2>
    }
    else
    {

        for(h=ctl->top;h>=height;h--)
  281439:	39 f3                	cmp    %esi,%ebx
  28143b:	7c 17                	jl     281454 <sheet_updown+0xc5>
        {
            ctl->sheets[h+1]=ctl->sheets[h];
  28143d:	8b 94 98 10 20 00 00 	mov    0x2010(%eax,%ebx,4),%edx
  281444:	8d 7b 01             	lea    0x1(%ebx),%edi
  281447:	89 94 98 14 20 00 00 	mov    %edx,0x2014(%eax,%ebx,4)
        ctl->sheets[height]=sht;
    }
    else
    {

        for(h=ctl->top;h>=height;h--)
  28144e:	4b                   	dec    %ebx
  28144f:	89 7a 18             	mov    %edi,0x18(%edx)
  281452:	eb e5                	jmp    281439 <sheet_updown+0xaa>
        {
            ctl->sheets[h+1]=ctl->sheets[h];
            ctl->sheets[h+1]->height=h+1;
        }
        ctl->sheets[height]=sht;
        ctl->top++;
  281454:	8b 7d f0             	mov    -0x10(%ebp),%edi
        for(h=ctl->top;h>=height;h--)
        {
            ctl->sheets[h+1]=ctl->sheets[h];
            ctl->sheets[h+1]->height=h+1;
        }
        ctl->sheets[height]=sht;
  281457:	89 8c b0 10 20 00 00 	mov    %ecx,0x2010(%eax,%esi,4)
        ctl->top++;
  28145e:	89 78 0c             	mov    %edi,0xc(%eax)

    }
      sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize);
  281461:	8b 59 10             	mov    0x10(%ecx),%ebx
  281464:	8b 71 08             	mov    0x8(%ecx),%esi
  281467:	8b 51 0c             	mov    0xc(%ecx),%edx
  28146a:	01 de                	add    %ebx,%esi
  28146c:	56                   	push   %esi
  28146d:	8b 79 04             	mov    0x4(%ecx),%edi
  281470:	01 d7                	add    %edx,%edi
  281472:	57                   	push   %edi
  281473:	53                   	push   %ebx
  281474:	52                   	push   %edx
  281475:	50                   	push   %eax
  281476:	e8 69 fe ff ff       	call   2812e4 <sheet_refreshsub>
  28147b:	83 c4 14             	add    $0x14,%esp
 }

}
  28147e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  281481:	5b                   	pop    %ebx
  281482:	5e                   	pop    %esi
  281483:	5f                   	pop    %edi
  281484:	5d                   	pop    %ebp
  281485:	c3                   	ret    

00281486 <sheet_refresh>:

void sheet_refresh(SHTCTL *ctl,SHEET * sht,int bx0,int by0,int bx1,int by1)
{
  281486:	55                   	push   %ebp
  281487:	89 e5                	mov    %esp,%ebp
  281489:	57                   	push   %edi
  28148a:	56                   	push   %esi
  28148b:	53                   	push   %ebx
  28148c:	51                   	push   %ecx
  28148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  281490:	8b 5d 10             	mov    0x10(%ebp),%ebx
  281493:	8b 75 18             	mov    0x18(%ebp),%esi
  281496:	8b 7d 1c             	mov    0x1c(%ebp),%edi
if (sht->height>=0)
  281499:	83 78 18 00          	cmpl   $0x0,0x18(%eax)
 }

}

void sheet_refresh(SHTCTL *ctl,SHEET * sht,int bx0,int by0,int bx1,int by1)
{
  28149d:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  2814a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
if (sht->height>=0)
  2814a3:	78 25                	js     2814ca <sheet_refresh+0x44>
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
    sht->vx0+bx1,sht->vy0+by1);
  2814a5:	8b 50 10             	mov    0x10(%eax),%edx
  2814a8:	8b 40 0c             	mov    0xc(%eax),%eax
}

void sheet_refresh(SHTCTL *ctl,SHEET * sht,int bx0,int by0,int bx1,int by1)
{
if (sht->height>=0)
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
  2814ab:	01 d7                	add    %edx,%edi
  2814ad:	01 da                	add    %ebx,%edx
  2814af:	01 c6                	add    %eax,%esi
  2814b1:	03 45 f0             	add    -0x10(%ebp),%eax
  2814b4:	89 7d 18             	mov    %edi,0x18(%ebp)
  2814b7:	89 75 14             	mov    %esi,0x14(%ebp)
  2814ba:	89 55 10             	mov    %edx,0x10(%ebp)
  2814bd:	89 45 0c             	mov    %eax,0xc(%ebp)
    sht->vx0+bx1,sht->vy0+by1);
return ;
}
  2814c0:	5a                   	pop    %edx
  2814c1:	5b                   	pop    %ebx
  2814c2:	5e                   	pop    %esi
  2814c3:	5f                   	pop    %edi
  2814c4:	5d                   	pop    %ebp
}

void sheet_refresh(SHTCTL *ctl,SHEET * sht,int bx0,int by0,int bx1,int by1)
{
if (sht->height>=0)
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
  2814c5:	e9 1a fe ff ff       	jmp    2812e4 <sheet_refreshsub>
    sht->vx0+bx1,sht->vy0+by1);
return ;
}
  2814ca:	58                   	pop    %eax
  2814cb:	5b                   	pop    %ebx
  2814cc:	5e                   	pop    %esi
  2814cd:	5f                   	pop    %edi
  2814ce:	5d                   	pop    %ebp
  2814cf:	c3                   	ret    

002814d0 <sheet_move>:

void sheet_move(SHTCTL * ctl,SHEET * sht,int vx0,int vy0)
{
  2814d0:	55                   	push   %ebp
  2814d1:	89 e5                	mov    %esp,%ebp
  2814d3:	57                   	push   %edi
  2814d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  2814d7:	56                   	push   %esi
  2814d8:	8b 75 10             	mov    0x10(%ebp),%esi
  2814db:	53                   	push   %ebx
  2814dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 int old_vx0=sht->vx0;
 int old_vy0=sht->vy0;
 sht->vx0=vx0;
 sht->vy0=vy0;
 if(sht->height>=0)
  2814df:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
return ;
}

void sheet_move(SHTCTL * ctl,SHEET * sht,int vx0,int vy0)
{
 int old_vx0=sht->vx0;
  2814e3:	8b 43 0c             	mov    0xc(%ebx),%eax
 int old_vy0=sht->vy0;
  2814e6:	8b 53 10             	mov    0x10(%ebx),%edx
 sht->vx0=vx0;
  2814e9:	89 73 0c             	mov    %esi,0xc(%ebx)
 sht->vy0=vy0;
  2814ec:	89 7b 10             	mov    %edi,0x10(%ebx)
 if(sht->height>=0)
  2814ef:	78 2f                	js     281520 <sheet_move+0x50>
 {
    //sheet_refresh(ctl);
    sheet_refreshsub(ctl,old_vx0,old_vy0,old_vx0+sht->bxsize,old_vy0+sht->bysize);
  2814f1:	8b 4b 08             	mov    0x8(%ebx),%ecx
  2814f4:	01 d1                	add    %edx,%ecx
  2814f6:	51                   	push   %ecx
  2814f7:	8b 4b 04             	mov    0x4(%ebx),%ecx
  2814fa:	01 c1                	add    %eax,%ecx
  2814fc:	51                   	push   %ecx
  2814fd:	52                   	push   %edx
  2814fe:	50                   	push   %eax
  2814ff:	ff 75 08             	pushl  0x8(%ebp)
  281502:	e8 dd fd ff ff       	call   2812e4 <sheet_refreshsub>
    sheet_refreshsub(ctl,vx0,vy0,vx0+sht->bxsize,vy0+sht->bysize);
  281507:	8b 43 08             	mov    0x8(%ebx),%eax
  28150a:	01 f8                	add    %edi,%eax
  28150c:	50                   	push   %eax
  28150d:	8b 43 04             	mov    0x4(%ebx),%eax
  281510:	01 f0                	add    %esi,%eax
  281512:	50                   	push   %eax
  281513:	57                   	push   %edi
  281514:	56                   	push   %esi
  281515:	ff 75 08             	pushl  0x8(%ebp)
  281518:	e8 c7 fd ff ff       	call   2812e4 <sheet_refreshsub>
  28151d:	83 c4 28             	add    $0x28,%esp
 }
 return;
}
  281520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  281523:	5b                   	pop    %ebx
  281524:	5e                   	pop    %esi
  281525:	5f                   	pop    %edi
  281526:	5d                   	pop    %ebp
  281527:	c3                   	ret    

Disassembly of section .rodata:

00281528 <Font8x16>:
	...
  281738:	00 00                	add    %al,(%eax)
  28173a:	00 10                	add    %dl,(%eax)
  28173c:	10 10                	adc    %dl,(%eax)
  28173e:	10 10                	adc    %dl,(%eax)
  281740:	10 00                	adc    %al,(%eax)
  281742:	10 10                	adc    %dl,(%eax)
  281744:	00 00                	add    %al,(%eax)
  281746:	00 00                	add    %al,(%eax)
  281748:	00 00                	add    %al,(%eax)
  28174a:	00 24 24             	add    %ah,(%esp)
  28174d:	24 00                	and    $0x0,%al
	...
  28175b:	24 24                	and    $0x24,%al
  28175d:	7e 24                	jle    281783 <Font8x16+0x25b>
  28175f:	24 24                	and    $0x24,%al
  281761:	7e 24                	jle    281787 <Font8x16+0x25f>
  281763:	24 00                	and    $0x0,%al
  281765:	00 00                	add    %al,(%eax)
  281767:	00 00                	add    %al,(%eax)
  281769:	00 00                	add    %al,(%eax)
  28176b:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  28176f:	7c 12                	jl     281783 <Font8x16+0x25b>
  281771:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  281775:	00 00                	add    %al,(%eax)
  281777:	00 00                	add    %al,(%eax)
  281779:	00 00                	add    %al,(%eax)
  28177b:	00 62 64             	add    %ah,0x64(%edx)
  28177e:	08 10                	or     %dl,(%eax)
  281780:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  28178c:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  28178f:	50                   	push   %eax
  281790:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  281797:	00 00                	add    %al,(%eax)
  281799:	00 00                	add    %al,(%eax)
  28179b:	10 10                	adc    %dl,(%eax)
  28179d:	20 00                	and    %al,(%eax)
	...
  2817a7:	00 00                	add    %al,(%eax)
  2817a9:	00 08                	add    %cl,(%eax)
  2817ab:	10 20                	adc    %ah,(%eax)
  2817ad:	20 20                	and    %ah,(%eax)
  2817af:	20 20                	and    %ah,(%eax)
  2817b1:	20 20                	and    %ah,(%eax)
  2817b3:	10 08                	adc    %cl,(%eax)
  2817b5:	00 00                	add    %al,(%eax)
  2817b7:	00 00                	add    %al,(%eax)
  2817b9:	00 20                	add    %ah,(%eax)
  2817bb:	10 08                	adc    %cl,(%eax)
  2817bd:	08 08                	or     %cl,(%eax)
  2817bf:	08 08                	or     %cl,(%eax)
  2817c1:	08 08                	or     %cl,(%eax)
  2817c3:	10 20                	adc    %ah,(%eax)
	...
  2817cd:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  2817d1:	54                   	push   %esp
  2817d2:	10 00                	adc    %al,(%eax)
	...
  2817dc:	00 10                	add    %dl,(%eax)
  2817de:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  2817f2:	10 10                	adc    %dl,(%eax)
  2817f4:	20 00                	and    %al,(%eax)
	...
  2817fe:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  281812:	00 10                	add    %dl,(%eax)
	...
  28181c:	00 02                	add    %al,(%edx)
  28181e:	04 08                	add    $0x8,%al
  281820:	10 20                	adc    %ah,(%eax)
  281822:	40                   	inc    %eax
	...
  28182b:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  28182f:	54                   	push   %esp
  281830:	64                   	fs
  281831:	44                   	inc    %esp
  281832:	44                   	inc    %esp
  281833:	38 00                	cmp    %al,(%eax)
  281835:	00 00                	add    %al,(%eax)
  281837:	00 00                	add    %al,(%eax)
  281839:	00 00                	add    %al,(%eax)
  28183b:	10 30                	adc    %dh,(%eax)
  28183d:	10 10                	adc    %dl,(%eax)
  28183f:	10 10                	adc    %dl,(%eax)
  281841:	10 10                	adc    %dl,(%eax)
  281843:	38 00                	cmp    %al,(%eax)
  281845:	00 00                	add    %al,(%eax)
  281847:	00 00                	add    %al,(%eax)
  281849:	00 00                	add    %al,(%eax)
  28184b:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  28184f:	08 10                	or     %dl,(%eax)
  281851:	20 40 7c             	and    %al,0x7c(%eax)
  281854:	00 00                	add    %al,(%eax)
  281856:	00 00                	add    %al,(%eax)
  281858:	00 00                	add    %al,(%eax)
  28185a:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  28185e:	10 38                	adc    %bh,(%eax)
  281860:	04 04                	add    $0x4,%al
  281862:	04 78                	add    $0x78,%al
  281864:	00 00                	add    %al,(%eax)
  281866:	00 00                	add    %al,(%eax)
  281868:	00 00                	add    %al,(%eax)
  28186a:	00 08                	add    %cl,(%eax)
  28186c:	18 28                	sbb    %ch,(%eax)
  28186e:	48                   	dec    %eax
  28186f:	48                   	dec    %eax
  281870:	7c 08                	jl     28187a <Font8x16+0x352>
  281872:	08 08                	or     %cl,(%eax)
  281874:	00 00                	add    %al,(%eax)
  281876:	00 00                	add    %al,(%eax)
  281878:	00 00                	add    %al,(%eax)
  28187a:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  28187e:	40                   	inc    %eax
  28187f:	78 04                	js     281885 <Font8x16+0x35d>
  281881:	04 04                	add    $0x4,%al
  281883:	78 00                	js     281885 <Font8x16+0x35d>
  281885:	00 00                	add    %al,(%eax)
  281887:	00 00                	add    %al,(%eax)
  281889:	00 00                	add    %al,(%eax)
  28188b:	3c 40                	cmp    $0x40,%al
  28188d:	40                   	inc    %eax
  28188e:	40                   	inc    %eax
  28188f:	78 44                	js     2818d5 <Font8x16+0x3ad>
  281891:	44                   	inc    %esp
  281892:	44                   	inc    %esp
  281893:	38 00                	cmp    %al,(%eax)
  281895:	00 00                	add    %al,(%eax)
  281897:	00 00                	add    %al,(%eax)
  281899:	00 00                	add    %al,(%eax)
  28189b:	7c 04                	jl     2818a1 <Font8x16+0x379>
  28189d:	04 08                	add    $0x8,%al
  28189f:	10 20                	adc    %ah,(%eax)
  2818a1:	20 20                	and    %ah,(%eax)
  2818a3:	20 00                	and    %al,(%eax)
  2818a5:	00 00                	add    %al,(%eax)
  2818a7:	00 00                	add    %al,(%eax)
  2818a9:	00 00                	add    %al,(%eax)
  2818ab:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2818af:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2818b3:	38 00                	cmp    %al,(%eax)
  2818b5:	00 00                	add    %al,(%eax)
  2818b7:	00 00                	add    %al,(%eax)
  2818b9:	00 00                	add    %al,(%eax)
  2818bb:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  2818bf:	3c 04                	cmp    $0x4,%al
  2818c1:	04 04                	add    $0x4,%al
  2818c3:	38 00                	cmp    %al,(%eax)
	...
  2818cd:	00 00                	add    %al,(%eax)
  2818cf:	10 00                	adc    %al,(%eax)
  2818d1:	00 10                	add    %dl,(%eax)
	...
  2818df:	00 10                	add    %dl,(%eax)
  2818e1:	00 10                	add    %dl,(%eax)
  2818e3:	10 20                	adc    %ah,(%eax)
	...
  2818ed:	04 08                	add    $0x8,%al
  2818ef:	10 20                	adc    %ah,(%eax)
  2818f1:	10 08                	adc    %cl,(%eax)
  2818f3:	04 00                	add    $0x0,%al
	...
  2818fd:	00 00                	add    %al,(%eax)
  2818ff:	7c 00                	jl     281901 <Font8x16+0x3d9>
  281901:	7c 00                	jl     281903 <Font8x16+0x3db>
	...
  28190b:	00 00                	add    %al,(%eax)
  28190d:	20 10                	and    %dl,(%eax)
  28190f:	08 04 08             	or     %al,(%eax,%ecx,1)
  281912:	10 20                	adc    %ah,(%eax)
  281914:	00 00                	add    %al,(%eax)
  281916:	00 00                	add    %al,(%eax)
  281918:	00 00                	add    %al,(%eax)
  28191a:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  28191e:	08 10                	or     %dl,(%eax)
  281920:	10 00                	adc    %al,(%eax)
  281922:	10 10                	adc    %dl,(%eax)
	...
  28192c:	00 38                	add    %bh,(%eax)
  28192e:	44                   	inc    %esp
  28192f:	5c                   	pop    %esp
  281930:	54                   	push   %esp
  281931:	5c                   	pop    %esp
  281932:	40                   	inc    %eax
  281933:	3c 00                	cmp    $0x0,%al
  281935:	00 00                	add    %al,(%eax)
  281937:	00 00                	add    %al,(%eax)
  281939:	00 18                	add    %bl,(%eax)
  28193b:	24 42                	and    $0x42,%al
  28193d:	42                   	inc    %edx
  28193e:	42                   	inc    %edx
  28193f:	7e 42                	jle    281983 <Font8x16+0x45b>
  281941:	42                   	inc    %edx
  281942:	42                   	inc    %edx
  281943:	42                   	inc    %edx
  281944:	00 00                	add    %al,(%eax)
  281946:	00 00                	add    %al,(%eax)
  281948:	00 00                	add    %al,(%eax)
  28194a:	7c 42                	jl     28198e <Font8x16+0x466>
  28194c:	42                   	inc    %edx
  28194d:	42                   	inc    %edx
  28194e:	7c 42                	jl     281992 <Font8x16+0x46a>
  281950:	42                   	inc    %edx
  281951:	42                   	inc    %edx
  281952:	42                   	inc    %edx
  281953:	7c 00                	jl     281955 <Font8x16+0x42d>
  281955:	00 00                	add    %al,(%eax)
  281957:	00 00                	add    %al,(%eax)
  281959:	00 3c 42             	add    %bh,(%edx,%eax,2)
  28195c:	40                   	inc    %eax
  28195d:	40                   	inc    %eax
  28195e:	40                   	inc    %eax
  28195f:	40                   	inc    %eax
  281960:	40                   	inc    %eax
  281961:	40                   	inc    %eax
  281962:	42                   	inc    %edx
  281963:	3c 00                	cmp    $0x0,%al
  281965:	00 00                	add    %al,(%eax)
  281967:	00 00                	add    %al,(%eax)
  281969:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  28196d:	42                   	inc    %edx
  28196e:	42                   	inc    %edx
  28196f:	42                   	inc    %edx
  281970:	42                   	inc    %edx
  281971:	42                   	inc    %edx
  281972:	42                   	inc    %edx
  281973:	7c 00                	jl     281975 <Font8x16+0x44d>
  281975:	00 00                	add    %al,(%eax)
  281977:	00 00                	add    %al,(%eax)
  281979:	00 7e 40             	add    %bh,0x40(%esi)
  28197c:	40                   	inc    %eax
  28197d:	40                   	inc    %eax
  28197e:	78 40                	js     2819c0 <Font8x16+0x498>
  281980:	40                   	inc    %eax
  281981:	40                   	inc    %eax
  281982:	40                   	inc    %eax
  281983:	7e 00                	jle    281985 <Font8x16+0x45d>
  281985:	00 00                	add    %al,(%eax)
  281987:	00 00                	add    %al,(%eax)
  281989:	00 7e 40             	add    %bh,0x40(%esi)
  28198c:	40                   	inc    %eax
  28198d:	40                   	inc    %eax
  28198e:	78 40                	js     2819d0 <Font8x16+0x4a8>
  281990:	40                   	inc    %eax
  281991:	40                   	inc    %eax
  281992:	40                   	inc    %eax
  281993:	40                   	inc    %eax
  281994:	00 00                	add    %al,(%eax)
  281996:	00 00                	add    %al,(%eax)
  281998:	00 00                	add    %al,(%eax)
  28199a:	3c 42                	cmp    $0x42,%al
  28199c:	40                   	inc    %eax
  28199d:	40                   	inc    %eax
  28199e:	5e                   	pop    %esi
  28199f:	42                   	inc    %edx
  2819a0:	42                   	inc    %edx
  2819a1:	42                   	inc    %edx
  2819a2:	42                   	inc    %edx
  2819a3:	3c 00                	cmp    $0x0,%al
  2819a5:	00 00                	add    %al,(%eax)
  2819a7:	00 00                	add    %al,(%eax)
  2819a9:	00 42 42             	add    %al,0x42(%edx)
  2819ac:	42                   	inc    %edx
  2819ad:	42                   	inc    %edx
  2819ae:	7e 42                	jle    2819f2 <Font8x16+0x4ca>
  2819b0:	42                   	inc    %edx
  2819b1:	42                   	inc    %edx
  2819b2:	42                   	inc    %edx
  2819b3:	42                   	inc    %edx
  2819b4:	00 00                	add    %al,(%eax)
  2819b6:	00 00                	add    %al,(%eax)
  2819b8:	00 00                	add    %al,(%eax)
  2819ba:	38 10                	cmp    %dl,(%eax)
  2819bc:	10 10                	adc    %dl,(%eax)
  2819be:	10 10                	adc    %dl,(%eax)
  2819c0:	10 10                	adc    %dl,(%eax)
  2819c2:	10 38                	adc    %bh,(%eax)
  2819c4:	00 00                	add    %al,(%eax)
  2819c6:	00 00                	add    %al,(%eax)
  2819c8:	00 00                	add    %al,(%eax)
  2819ca:	1c 08                	sbb    $0x8,%al
  2819cc:	08 08                	or     %cl,(%eax)
  2819ce:	08 08                	or     %cl,(%eax)
  2819d0:	08 08                	or     %cl,(%eax)
  2819d2:	48                   	dec    %eax
  2819d3:	30 00                	xor    %al,(%eax)
  2819d5:	00 00                	add    %al,(%eax)
  2819d7:	00 00                	add    %al,(%eax)
  2819d9:	00 42 44             	add    %al,0x44(%edx)
  2819dc:	48                   	dec    %eax
  2819dd:	50                   	push   %eax
  2819de:	60                   	pusha  
  2819df:	60                   	pusha  
  2819e0:	50                   	push   %eax
  2819e1:	48                   	dec    %eax
  2819e2:	44                   	inc    %esp
  2819e3:	42                   	inc    %edx
  2819e4:	00 00                	add    %al,(%eax)
  2819e6:	00 00                	add    %al,(%eax)
  2819e8:	00 00                	add    %al,(%eax)
  2819ea:	40                   	inc    %eax
  2819eb:	40                   	inc    %eax
  2819ec:	40                   	inc    %eax
  2819ed:	40                   	inc    %eax
  2819ee:	40                   	inc    %eax
  2819ef:	40                   	inc    %eax
  2819f0:	40                   	inc    %eax
  2819f1:	40                   	inc    %eax
  2819f2:	40                   	inc    %eax
  2819f3:	7e 00                	jle    2819f5 <Font8x16+0x4cd>
  2819f5:	00 00                	add    %al,(%eax)
  2819f7:	00 00                	add    %al,(%eax)
  2819f9:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  2819ff:	aa                   	stos   %al,%es:(%edi)
  281a00:	92                   	xchg   %eax,%edx
  281a01:	92                   	xchg   %eax,%edx
  281a02:	82                   	(bad)  
  281a03:	82                   	(bad)  
  281a04:	00 00                	add    %al,(%eax)
  281a06:	00 00                	add    %al,(%eax)
  281a08:	00 00                	add    %al,(%eax)
  281a0a:	42                   	inc    %edx
  281a0b:	62 62 52             	bound  %esp,0x52(%edx)
  281a0e:	52                   	push   %edx
  281a0f:	4a                   	dec    %edx
  281a10:	4a                   	dec    %edx
  281a11:	46                   	inc    %esi
  281a12:	46                   	inc    %esi
  281a13:	42                   	inc    %edx
  281a14:	00 00                	add    %al,(%eax)
  281a16:	00 00                	add    %al,(%eax)
  281a18:	00 00                	add    %al,(%eax)
  281a1a:	3c 42                	cmp    $0x42,%al
  281a1c:	42                   	inc    %edx
  281a1d:	42                   	inc    %edx
  281a1e:	42                   	inc    %edx
  281a1f:	42                   	inc    %edx
  281a20:	42                   	inc    %edx
  281a21:	42                   	inc    %edx
  281a22:	42                   	inc    %edx
  281a23:	3c 00                	cmp    $0x0,%al
  281a25:	00 00                	add    %al,(%eax)
  281a27:	00 00                	add    %al,(%eax)
  281a29:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281a2d:	42                   	inc    %edx
  281a2e:	42                   	inc    %edx
  281a2f:	7c 40                	jl     281a71 <Font8x16+0x549>
  281a31:	40                   	inc    %eax
  281a32:	40                   	inc    %eax
  281a33:	40                   	inc    %eax
  281a34:	00 00                	add    %al,(%eax)
  281a36:	00 00                	add    %al,(%eax)
  281a38:	00 00                	add    %al,(%eax)
  281a3a:	3c 42                	cmp    $0x42,%al
  281a3c:	42                   	inc    %edx
  281a3d:	42                   	inc    %edx
  281a3e:	42                   	inc    %edx
  281a3f:	42                   	inc    %edx
  281a40:	42                   	inc    %edx
  281a41:	42                   	inc    %edx
  281a42:	4a                   	dec    %edx
  281a43:	3c 0e                	cmp    $0xe,%al
  281a45:	00 00                	add    %al,(%eax)
  281a47:	00 00                	add    %al,(%eax)
  281a49:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281a4d:	42                   	inc    %edx
  281a4e:	42                   	inc    %edx
  281a4f:	7c 50                	jl     281aa1 <Font8x16+0x579>
  281a51:	48                   	dec    %eax
  281a52:	44                   	inc    %esp
  281a53:	42                   	inc    %edx
  281a54:	00 00                	add    %al,(%eax)
  281a56:	00 00                	add    %al,(%eax)
  281a58:	00 00                	add    %al,(%eax)
  281a5a:	3c 42                	cmp    $0x42,%al
  281a5c:	40                   	inc    %eax
  281a5d:	40                   	inc    %eax
  281a5e:	3c 02                	cmp    $0x2,%al
  281a60:	02 02                	add    (%edx),%al
  281a62:	42                   	inc    %edx
  281a63:	3c 00                	cmp    $0x0,%al
  281a65:	00 00                	add    %al,(%eax)
  281a67:	00 00                	add    %al,(%eax)
  281a69:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  281a6d:	10 10                	adc    %dl,(%eax)
  281a6f:	10 10                	adc    %dl,(%eax)
  281a71:	10 10                	adc    %dl,(%eax)
  281a73:	10 00                	adc    %al,(%eax)
  281a75:	00 00                	add    %al,(%eax)
  281a77:	00 00                	add    %al,(%eax)
  281a79:	00 42 42             	add    %al,0x42(%edx)
  281a7c:	42                   	inc    %edx
  281a7d:	42                   	inc    %edx
  281a7e:	42                   	inc    %edx
  281a7f:	42                   	inc    %edx
  281a80:	42                   	inc    %edx
  281a81:	42                   	inc    %edx
  281a82:	42                   	inc    %edx
  281a83:	3c 00                	cmp    $0x0,%al
  281a85:	00 00                	add    %al,(%eax)
  281a87:	00 00                	add    %al,(%eax)
  281a89:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  281a8d:	44                   	inc    %esp
  281a8e:	28 28                	sub    %ch,(%eax)
  281a90:	28 10                	sub    %dl,(%eax)
  281a92:	10 10                	adc    %dl,(%eax)
  281a94:	00 00                	add    %al,(%eax)
  281a96:	00 00                	add    %al,(%eax)
  281a98:	00 00                	add    %al,(%eax)
  281a9a:	82                   	(bad)  
  281a9b:	82                   	(bad)  
  281a9c:	82                   	(bad)  
  281a9d:	82                   	(bad)  
  281a9e:	54                   	push   %esp
  281a9f:	54                   	push   %esp
  281aa0:	54                   	push   %esp
  281aa1:	28 28                	sub    %ch,(%eax)
  281aa3:	28 00                	sub    %al,(%eax)
  281aa5:	00 00                	add    %al,(%eax)
  281aa7:	00 00                	add    %al,(%eax)
  281aa9:	00 42 42             	add    %al,0x42(%edx)
  281aac:	24 18                	and    $0x18,%al
  281aae:	18 18                	sbb    %bl,(%eax)
  281ab0:	24 24                	and    $0x24,%al
  281ab2:	42                   	inc    %edx
  281ab3:	42                   	inc    %edx
  281ab4:	00 00                	add    %al,(%eax)
  281ab6:	00 00                	add    %al,(%eax)
  281ab8:	00 00                	add    %al,(%eax)
  281aba:	44                   	inc    %esp
  281abb:	44                   	inc    %esp
  281abc:	44                   	inc    %esp
  281abd:	44                   	inc    %esp
  281abe:	28 28                	sub    %ch,(%eax)
  281ac0:	10 10                	adc    %dl,(%eax)
  281ac2:	10 10                	adc    %dl,(%eax)
  281ac4:	00 00                	add    %al,(%eax)
  281ac6:	00 00                	add    %al,(%eax)
  281ac8:	00 00                	add    %al,(%eax)
  281aca:	7e 02                	jle    281ace <Font8x16+0x5a6>
  281acc:	02 04 08             	add    (%eax,%ecx,1),%al
  281acf:	10 20                	adc    %ah,(%eax)
  281ad1:	40                   	inc    %eax
  281ad2:	40                   	inc    %eax
  281ad3:	7e 00                	jle    281ad5 <Font8x16+0x5ad>
  281ad5:	00 00                	add    %al,(%eax)
  281ad7:	00 00                	add    %al,(%eax)
  281ad9:	00 38                	add    %bh,(%eax)
  281adb:	20 20                	and    %ah,(%eax)
  281add:	20 20                	and    %ah,(%eax)
  281adf:	20 20                	and    %ah,(%eax)
  281ae1:	20 20                	and    %ah,(%eax)
  281ae3:	38 00                	cmp    %al,(%eax)
	...
  281aed:	00 40 20             	add    %al,0x20(%eax)
  281af0:	10 08                	adc    %cl,(%eax)
  281af2:	04 02                	add    $0x2,%al
  281af4:	00 00                	add    %al,(%eax)
  281af6:	00 00                	add    %al,(%eax)
  281af8:	00 00                	add    %al,(%eax)
  281afa:	1c 04                	sbb    $0x4,%al
  281afc:	04 04                	add    $0x4,%al
  281afe:	04 04                	add    $0x4,%al
  281b00:	04 04                	add    $0x4,%al
  281b02:	04 1c                	add    $0x1c,%al
	...
  281b0c:	10 28                	adc    %ch,(%eax)
  281b0e:	44                   	inc    %esp
	...
  281b23:	00 ff                	add    %bh,%bh
  281b25:	00 00                	add    %al,(%eax)
  281b27:	00 00                	add    %al,(%eax)
  281b29:	00 00                	add    %al,(%eax)
  281b2b:	10 10                	adc    %dl,(%eax)
  281b2d:	08 00                	or     %al,(%eax)
	...
  281b3b:	00 00                	add    %al,(%eax)
  281b3d:	78 04                	js     281b43 <Font8x16+0x61b>
  281b3f:	3c 44                	cmp    $0x44,%al
  281b41:	44                   	inc    %esp
  281b42:	44                   	inc    %esp
  281b43:	3a 00                	cmp    (%eax),%al
  281b45:	00 00                	add    %al,(%eax)
  281b47:	00 00                	add    %al,(%eax)
  281b49:	00 40 40             	add    %al,0x40(%eax)
  281b4c:	40                   	inc    %eax
  281b4d:	5c                   	pop    %esp
  281b4e:	62 42 42             	bound  %eax,0x42(%edx)
  281b51:	42                   	inc    %edx
  281b52:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  281b56:	00 00                	add    %al,(%eax)
  281b58:	00 00                	add    %al,(%eax)
  281b5a:	00 00                	add    %al,(%eax)
  281b5c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281b5f:	40                   	inc    %eax
  281b60:	40                   	inc    %eax
  281b61:	40                   	inc    %eax
  281b62:	42                   	inc    %edx
  281b63:	3c 00                	cmp    $0x0,%al
  281b65:	00 00                	add    %al,(%eax)
  281b67:	00 00                	add    %al,(%eax)
  281b69:	00 02                	add    %al,(%edx)
  281b6b:	02 02                	add    (%edx),%al
  281b6d:	3a 46 42             	cmp    0x42(%esi),%al
  281b70:	42                   	inc    %edx
  281b71:	42                   	inc    %edx
  281b72:	46                   	inc    %esi
  281b73:	3a 00                	cmp    (%eax),%al
	...
  281b7d:	3c 42                	cmp    $0x42,%al
  281b7f:	42                   	inc    %edx
  281b80:	7e 40                	jle    281bc2 <Font8x16+0x69a>
  281b82:	42                   	inc    %edx
  281b83:	3c 00                	cmp    $0x0,%al
  281b85:	00 00                	add    %al,(%eax)
  281b87:	00 00                	add    %al,(%eax)
  281b89:	00 0e                	add    %cl,(%esi)
  281b8b:	10 10                	adc    %dl,(%eax)
  281b8d:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  281b90:	10 10                	adc    %dl,(%eax)
  281b92:	10 10                	adc    %dl,(%eax)
	...
  281b9c:	00 3e                	add    %bh,(%esi)
  281b9e:	42                   	inc    %edx
  281b9f:	42                   	inc    %edx
  281ba0:	42                   	inc    %edx
  281ba1:	42                   	inc    %edx
  281ba2:	3e 02 02             	add    %ds:(%edx),%al
  281ba5:	3c 00                	cmp    $0x0,%al
  281ba7:	00 00                	add    %al,(%eax)
  281ba9:	00 40 40             	add    %al,0x40(%eax)
  281bac:	40                   	inc    %eax
  281bad:	5c                   	pop    %esp
  281bae:	62 42 42             	bound  %eax,0x42(%edx)
  281bb1:	42                   	inc    %edx
  281bb2:	42                   	inc    %edx
  281bb3:	42                   	inc    %edx
  281bb4:	00 00                	add    %al,(%eax)
  281bb6:	00 00                	add    %al,(%eax)
  281bb8:	00 00                	add    %al,(%eax)
  281bba:	00 08                	add    %cl,(%eax)
  281bbc:	00 08                	add    %cl,(%eax)
  281bbe:	08 08                	or     %cl,(%eax)
  281bc0:	08 08                	or     %cl,(%eax)
  281bc2:	08 08                	or     %cl,(%eax)
  281bc4:	00 00                	add    %al,(%eax)
  281bc6:	00 00                	add    %al,(%eax)
  281bc8:	00 00                	add    %al,(%eax)
  281bca:	00 04 00             	add    %al,(%eax,%eax,1)
  281bcd:	04 04                	add    $0x4,%al
  281bcf:	04 04                	add    $0x4,%al
  281bd1:	04 04                	add    $0x4,%al
  281bd3:	04 44                	add    $0x44,%al
  281bd5:	38 00                	cmp    %al,(%eax)
  281bd7:	00 00                	add    %al,(%eax)
  281bd9:	00 40 40             	add    %al,0x40(%eax)
  281bdc:	40                   	inc    %eax
  281bdd:	42                   	inc    %edx
  281bde:	44                   	inc    %esp
  281bdf:	48                   	dec    %eax
  281be0:	50                   	push   %eax
  281be1:	68 44 42 00 00       	push   $0x4244
  281be6:	00 00                	add    %al,(%eax)
  281be8:	00 00                	add    %al,(%eax)
  281bea:	10 10                	adc    %dl,(%eax)
  281bec:	10 10                	adc    %dl,(%eax)
  281bee:	10 10                	adc    %dl,(%eax)
  281bf0:	10 10                	adc    %dl,(%eax)
  281bf2:	10 10                	adc    %dl,(%eax)
	...
  281bfc:	00 ec                	add    %ch,%ah
  281bfe:	92                   	xchg   %eax,%edx
  281bff:	92                   	xchg   %eax,%edx
  281c00:	92                   	xchg   %eax,%edx
  281c01:	92                   	xchg   %eax,%edx
  281c02:	92                   	xchg   %eax,%edx
  281c03:	92                   	xchg   %eax,%edx
	...
  281c0c:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281c10:	42                   	inc    %edx
  281c11:	42                   	inc    %edx
  281c12:	42                   	inc    %edx
  281c13:	42                   	inc    %edx
	...
  281c1c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281c1f:	42                   	inc    %edx
  281c20:	42                   	inc    %edx
  281c21:	42                   	inc    %edx
  281c22:	42                   	inc    %edx
  281c23:	3c 00                	cmp    $0x0,%al
	...
  281c2d:	5c                   	pop    %esp
  281c2e:	62 42 42             	bound  %eax,0x42(%edx)
  281c31:	42                   	inc    %edx
  281c32:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  281c36:	00 00                	add    %al,(%eax)
  281c38:	00 00                	add    %al,(%eax)
  281c3a:	00 00                	add    %al,(%eax)
  281c3c:	00 3a                	add    %bh,(%edx)
  281c3e:	46                   	inc    %esi
  281c3f:	42                   	inc    %edx
  281c40:	42                   	inc    %edx
  281c41:	42                   	inc    %edx
  281c42:	46                   	inc    %esi
  281c43:	3a 02                	cmp    (%edx),%al
  281c45:	02 00                	add    (%eax),%al
  281c47:	00 00                	add    %al,(%eax)
  281c49:	00 00                	add    %al,(%eax)
  281c4b:	00 00                	add    %al,(%eax)
  281c4d:	5c                   	pop    %esp
  281c4e:	62 40 40             	bound  %eax,0x40(%eax)
  281c51:	40                   	inc    %eax
  281c52:	40                   	inc    %eax
  281c53:	40                   	inc    %eax
	...
  281c5c:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281c5f:	40                   	inc    %eax
  281c60:	3c 02                	cmp    $0x2,%al
  281c62:	42                   	inc    %edx
  281c63:	3c 00                	cmp    $0x0,%al
  281c65:	00 00                	add    %al,(%eax)
  281c67:	00 00                	add    %al,(%eax)
  281c69:	00 00                	add    %al,(%eax)
  281c6b:	20 20                	and    %ah,(%eax)
  281c6d:	78 20                	js     281c8f <Font8x16+0x767>
  281c6f:	20 20                	and    %ah,(%eax)
  281c71:	20 22                	and    %ah,(%edx)
  281c73:	1c 00                	sbb    $0x0,%al
	...
  281c7d:	42                   	inc    %edx
  281c7e:	42                   	inc    %edx
  281c7f:	42                   	inc    %edx
  281c80:	42                   	inc    %edx
  281c81:	42                   	inc    %edx
  281c82:	42                   	inc    %edx
  281c83:	3e 00 00             	add    %al,%ds:(%eax)
  281c86:	00 00                	add    %al,(%eax)
  281c88:	00 00                	add    %al,(%eax)
  281c8a:	00 00                	add    %al,(%eax)
  281c8c:	00 42 42             	add    %al,0x42(%edx)
  281c8f:	42                   	inc    %edx
  281c90:	42                   	inc    %edx
  281c91:	42                   	inc    %edx
  281c92:	24 18                	and    $0x18,%al
	...
  281c9c:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  281ca2:	aa                   	stos   %al,%es:(%edi)
  281ca3:	44                   	inc    %esp
	...
  281cac:	00 42 42             	add    %al,0x42(%edx)
  281caf:	24 18                	and    $0x18,%al
  281cb1:	24 42                	and    $0x42,%al
  281cb3:	42                   	inc    %edx
	...
  281cbc:	00 42 42             	add    %al,0x42(%edx)
  281cbf:	42                   	inc    %edx
  281cc0:	42                   	inc    %edx
  281cc1:	42                   	inc    %edx
  281cc2:	3e 02 02             	add    %ds:(%edx),%al
  281cc5:	3c 00                	cmp    $0x0,%al
  281cc7:	00 00                	add    %al,(%eax)
  281cc9:	00 00                	add    %al,(%eax)
  281ccb:	00 00                	add    %al,(%eax)
  281ccd:	7e 02                	jle    281cd1 <Font8x16+0x7a9>
  281ccf:	04 18                	add    $0x18,%al
  281cd1:	20 40 7e             	and    %al,0x7e(%eax)
  281cd4:	00 00                	add    %al,(%eax)
  281cd6:	00 00                	add    %al,(%eax)
  281cd8:	00 00                	add    %al,(%eax)
  281cda:	08 10                	or     %dl,(%eax)
  281cdc:	10 10                	adc    %dl,(%eax)
  281cde:	20 40 20             	and    %al,0x20(%eax)
  281ce1:	10 10                	adc    %dl,(%eax)
  281ce3:	10 08                	adc    %cl,(%eax)
  281ce5:	00 00                	add    %al,(%eax)
  281ce7:	00 00                	add    %al,(%eax)
  281ce9:	10 10                	adc    %dl,(%eax)
  281ceb:	10 10                	adc    %dl,(%eax)
  281ced:	10 10                	adc    %dl,(%eax)
  281cef:	10 10                	adc    %dl,(%eax)
  281cf1:	10 10                	adc    %dl,(%eax)
  281cf3:	10 10                	adc    %dl,(%eax)
  281cf5:	10 10                	adc    %dl,(%eax)
  281cf7:	00 00                	add    %al,(%eax)
  281cf9:	00 20                	add    %ah,(%eax)
  281cfb:	10 10                	adc    %dl,(%eax)
  281cfd:	10 08                	adc    %cl,(%eax)
  281cff:	04 08                	add    $0x8,%al
  281d01:	10 10                	adc    %dl,(%eax)
  281d03:	10 20                	adc    %ah,(%eax)
	...
  281d0d:	00 22                	add    %ah,(%edx)
  281d0f:	54                   	push   %esp
  281d10:	88 00                	mov    %al,(%eax)
	...

00281d28 <ASCII_Table>:
	...
  281d58:	00 00                	add    %al,(%eax)
  281d5a:	80 01 80             	addb   $0x80,(%ecx)
  281d5d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281d63:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281d69:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281d6f:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  281d75:	00 00                	add    %al,(%eax)
  281d77:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281d89:	00 00                	add    %al,(%eax)
  281d8b:	00 cc                	add    %cl,%ah
  281d8d:	00 cc                	add    %cl,%ah
  281d8f:	00 cc                	add    %cl,%ah
  281d91:	00 cc                	add    %cl,%ah
  281d93:	00 cc                	add    %cl,%ah
  281d95:	00 cc                	add    %cl,%ah
	...
  281dc3:	00 60 0c             	add    %ah,0xc(%eax)
  281dc6:	60                   	pusha  
  281dc7:	0c 60                	or     $0x60,%al
  281dc9:	0c 30                	or     $0x30,%al
  281dcb:	06                   	push   %es
  281dcc:	30 06                	xor    %al,(%esi)
  281dce:	fe                   	(bad)  
  281dcf:	1f                   	pop    %ds
  281dd0:	fe                   	(bad)  
  281dd1:	1f                   	pop    %ds
  281dd2:	30 06                	xor    %al,(%esi)
  281dd4:	38 07                	cmp    %al,(%edi)
  281dd6:	18 03                	sbb    %al,(%ebx)
  281dd8:	fe                   	(bad)  
  281dd9:	1f                   	pop    %ds
  281dda:	fe                   	(bad)  
  281ddb:	1f                   	pop    %ds
  281ddc:	18 03                	sbb    %al,(%ebx)
  281dde:	18 03                	sbb    %al,(%ebx)
  281de0:	8c 01                	mov    %es,(%ecx)
  281de2:	8c 01                	mov    %es,(%ecx)
  281de4:	8c 01                	mov    %es,(%ecx)
  281de6:	00 00                	add    %al,(%eax)
  281de8:	00 00                	add    %al,(%eax)
  281dea:	80 00 e0             	addb   $0xe0,(%eax)
  281ded:	03 f8                	add    %eax,%edi
  281def:	0f 9c 0e             	setl   (%esi)
  281df2:	8c 1c 8c             	mov    %ds,(%esp,%ecx,4)
  281df5:	18 8c 00 98 00 f8 01 	sbb    %cl,0x1f80098(%eax,%eax,1)
  281dfc:	e0 07                	loopne 281e05 <ASCII_Table+0xdd>
  281dfe:	80 0e 80             	orb    $0x80,(%esi)
  281e01:	1c 8c                	sbb    $0x8c,%al
  281e03:	18 8c 18 9c 18 b8 0c 	sbb    %cl,0xcb8189c(%eax,%ebx,1)
  281e0a:	f0 0f e0 03          	lock pavgb (%ebx),%mm0
  281e0e:	80 00 80             	addb   $0x80,(%eax)
	...
  281e1d:	00 0e                	add    %cl,(%esi)
  281e1f:	18 1b                	sbb    %bl,(%ebx)
  281e21:	0c 11                	or     $0x11,%al
  281e23:	0c 11                	or     $0x11,%al
  281e25:	06                   	push   %es
  281e26:	11 06                	adc    %eax,(%esi)
  281e28:	11 03                	adc    %eax,(%ebx)
  281e2a:	11 03                	adc    %eax,(%ebx)
  281e2c:	9b                   	fwait
  281e2d:	01 8e 01 c0 38 c0    	add    %ecx,-0x3fc73fff(%esi)
  281e33:	6c                   	insb   (%dx),%es:(%edi)
  281e34:	60                   	pusha  
  281e35:	44                   	inc    %esp
  281e36:	60                   	pusha  
  281e37:	44                   	inc    %esp
  281e38:	30 44 30 44          	xor    %al,0x44(%eax,%esi,1)
  281e3c:	18 44 18 6c          	sbb    %al,0x6c(%eax,%ebx,1)
  281e40:	0c 38                	or     $0x38,%al
	...
  281e4a:	e0 01                	loopne 281e4d <ASCII_Table+0x125>
  281e4c:	f0 03 38             	lock add (%eax),%edi
  281e4f:	07                   	pop    %es
  281e50:	18 06                	sbb    %al,(%esi)
  281e52:	18 06                	sbb    %al,(%esi)
  281e54:	30 03                	xor    %al,(%ebx)
  281e56:	f0 01 f0             	lock add %esi,%eax
  281e59:	00 f8                	add    %bh,%al
  281e5b:	00 9c 31 0e 33 06 1e 	add    %bl,0x1e06330e(%ecx,%esi,1)
  281e62:	06                   	push   %es
  281e63:	1c 06                	sbb    $0x6,%al
  281e65:	1c 06                	sbb    $0x6,%al
  281e67:	3f                   	aas    
  281e68:	fc                   	cld    
  281e69:	73 f0                	jae    281e5b <ASCII_Table+0x133>
  281e6b:	21 00                	and    %eax,(%eax)
	...
  281e79:	00 00                	add    %al,(%eax)
  281e7b:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281e7e:	0c 00                	or     $0x0,%al
  281e80:	0c 00                	or     $0x0,%al
  281e82:	0c 00                	or     $0x0,%al
  281e84:	0c 00                	or     $0x0,%al
  281e86:	0c 00                	or     $0x0,%al
	...
  281ea8:	00 00                	add    %al,(%eax)
  281eaa:	00 02                	add    %al,(%edx)
  281eac:	00 03                	add    %al,(%ebx)
  281eae:	80 01 c0             	addb   $0xc0,(%ecx)
  281eb1:	00 c0                	add    %al,%al
  281eb3:	00 60 00             	add    %ah,0x0(%eax)
  281eb6:	60                   	pusha  
  281eb7:	00 30                	add    %dh,(%eax)
  281eb9:	00 30                	add    %dh,(%eax)
  281ebb:	00 30                	add    %dh,(%eax)
  281ebd:	00 30                	add    %dh,(%eax)
  281ebf:	00 30                	add    %dh,(%eax)
  281ec1:	00 30                	add    %dh,(%eax)
  281ec3:	00 30                	add    %dh,(%eax)
  281ec5:	00 30                	add    %dh,(%eax)
  281ec7:	00 60 00             	add    %ah,0x0(%eax)
  281eca:	60                   	pusha  
  281ecb:	00 c0                	add    %al,%al
  281ecd:	00 c0                	add    %al,%al
  281ecf:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  281ed5:	02 00                	add    (%eax),%al
  281ed7:	00 00                	add    %al,(%eax)
  281ed9:	00 20                	add    %ah,(%eax)
  281edb:	00 60 00             	add    %ah,0x0(%eax)
  281ede:	c0 00 80             	rolb   $0x80,(%eax)
  281ee1:	01 80 01 00 03 00    	add    %eax,0x30001(%eax)
  281ee7:	03 00                	add    (%eax),%eax
  281ee9:	06                   	push   %es
  281eea:	00 06                	add    %al,(%esi)
  281eec:	00 06                	add    %al,(%esi)
  281eee:	00 06                	add    %al,(%esi)
  281ef0:	00 06                	add    %al,(%esi)
  281ef2:	00 06                	add    %al,(%esi)
  281ef4:	00 06                	add    %al,(%esi)
  281ef6:	00 06                	add    %al,(%esi)
  281ef8:	00 03                	add    %al,(%ebx)
  281efa:	00 03                	add    %al,(%ebx)
  281efc:	80 01 80             	addb   $0x80,(%ecx)
  281eff:	01 c0                	add    %eax,%eax
  281f01:	00 60 00             	add    %ah,0x0(%eax)
  281f04:	20 00                	and    %al,(%eax)
	...
  281f12:	00 00                	add    %al,(%eax)
  281f14:	c0 00 c0             	rolb   $0xc0,(%eax)
  281f17:	00 d8                	add    %bl,%al
  281f19:	06                   	push   %es
  281f1a:	f8                   	clc    
  281f1b:	07                   	pop    %es
  281f1c:	e0 01                	loopne 281f1f <ASCII_Table+0x1f7>
  281f1e:	30 03                	xor    %al,(%ebx)
  281f20:	38 07                	cmp    %al,(%edi)
	...
  281f42:	00 00                	add    %al,(%eax)
  281f44:	80 01 80             	addb   $0x80,(%ecx)
  281f47:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f4d:	01 fc                	add    %edi,%esp
  281f4f:	3f                   	aas    
  281f50:	fc                   	cld    
  281f51:	3f                   	aas    
  281f52:	80 01 80             	addb   $0x80,(%ecx)
  281f55:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f5b:	01 00                	add    %eax,(%eax)
	...
  281f89:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281f8f:	01 00                	add    %eax,(%eax)
  281f91:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281faf:	00 e0                	add    %ah,%al
  281fb1:	07                   	pop    %es
  281fb2:	e0 07                	loopne 281fbb <ASCII_Table+0x293>
	...
  281fe8:	00 00                	add    %al,(%eax)
  281fea:	c0 00 c0             	rolb   $0xc0,(%eax)
	...
  281ff9:	00 00                	add    %al,(%eax)
  281ffb:	0c 00                	or     $0x0,%al
  281ffd:	0c 00                	or     $0x0,%al
  281fff:	06                   	push   %es
  282000:	00 06                	add    %al,(%esi)
  282002:	00 06                	add    %al,(%esi)
  282004:	00 03                	add    %al,(%ebx)
  282006:	00 03                	add    %al,(%ebx)
  282008:	00 03                	add    %al,(%ebx)
  28200a:	80 03 80             	addb   $0x80,(%ebx)
  28200d:	01 80 01 80 01 c0    	add    %eax,-0x3ffe7fff(%eax)
  282013:	00 c0                	add    %al,%al
  282015:	00 c0                	add    %al,%al
  282017:	00 60 00             	add    %ah,0x0(%eax)
  28201a:	60                   	pusha  
	...
  282027:	00 00                	add    %al,(%eax)
  282029:	00 e0                	add    %ah,%al
  28202b:	03 f0                	add    %eax,%esi
  28202d:	07                   	pop    %es
  28202e:	38 0e                	cmp    %cl,(%esi)
  282030:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  282033:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282036:	0c 18                	or     $0x18,%al
  282038:	0c 18                	or     $0x18,%al
  28203a:	0c 18                	or     $0x18,%al
  28203c:	0c 18                	or     $0x18,%al
  28203e:	0c 18                	or     $0x18,%al
  282040:	0c 18                	or     $0x18,%al
  282042:	0c 18                	or     $0x18,%al
  282044:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  282047:	0e                   	push   %cs
  282048:	f0 07                	lock pop %es
  28204a:	e0 03                	loopne 28204f <ASCII_Table+0x327>
	...
  282058:	00 00                	add    %al,(%eax)
  28205a:	00 01                	add    %al,(%ecx)
  28205c:	80 01 c0             	addb   $0xc0,(%ecx)
  28205f:	01 f0                	add    %esi,%eax
  282061:	01 98 01 88 01 80    	add    %ebx,-0x7ffe77ff(%eax)
  282067:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28206d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282073:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282079:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  282087:	00 00                	add    %al,(%eax)
  282089:	00 e0                	add    %ah,%al
  28208b:	03 f8                	add    %eax,%edi
  28208d:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  282091:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282094:	00 18                	add    %bl,(%eax)
  282096:	00 18                	add    %bl,(%eax)
  282098:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28209b:	06                   	push   %es
  28209c:	00 03                	add    %al,(%ebx)
  28209e:	80 01 c0             	addb   $0xc0,(%ecx)
  2820a1:	00 60 00             	add    %ah,0x0(%eax)
  2820a4:	30 00                	xor    %al,(%eax)
  2820a6:	18 00                	sbb    %al,(%eax)
  2820a8:	fc                   	cld    
  2820a9:	1f                   	pop    %ds
  2820aa:	fc                   	cld    
  2820ab:	1f                   	pop    %ds
	...
  2820b8:	00 00                	add    %al,(%eax)
  2820ba:	e0 01                	loopne 2820bd <ASCII_Table+0x395>
  2820bc:	f8                   	clc    
  2820bd:	07                   	pop    %es
  2820be:	18 0e                	sbb    %cl,(%esi)
  2820c0:	0c 0c                	or     $0xc,%al
  2820c2:	0c 0c                	or     $0xc,%al
  2820c4:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2820c7:	06                   	push   %es
  2820c8:	c0 03 c0             	rolb   $0xc0,(%ebx)
  2820cb:	07                   	pop    %es
  2820cc:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2820cf:	18 00                	sbb    %al,(%eax)
  2820d1:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2820d4:	0c 18                	or     $0x18,%al
  2820d6:	18 0c f8             	sbb    %cl,(%eax,%edi,8)
  2820d9:	07                   	pop    %es
  2820da:	e0 03                	loopne 2820df <ASCII_Table+0x3b7>
	...
  2820e8:	00 00                	add    %al,(%eax)
  2820ea:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2820ed:	0e                   	push   %cs
  2820ee:	00 0f                	add    %cl,(%edi)
  2820f0:	00 0f                	add    %cl,(%edi)
  2820f2:	80 0d c0 0c 60 0c 60 	orb    $0x60,0xc600cc0
  2820f9:	0c 30                	or     $0x30,%al
  2820fb:	0c 18                	or     $0x18,%al
  2820fd:	0c 0c                	or     $0xc,%al
  2820ff:	0c fc                	or     $0xfc,%al
  282101:	3f                   	aas    
  282102:	fc                   	cld    
  282103:	3f                   	aas    
  282104:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282107:	0c 00                	or     $0x0,%al
  282109:	0c 00                	or     $0x0,%al
  28210b:	0c 00                	or     $0x0,%al
	...
  282119:	00 f8                	add    %bh,%al
  28211b:	0f f8 0f             	psubb  (%edi),%mm1
  28211e:	18 00                	sbb    %al,(%eax)
  282120:	18 00                	sbb    %al,(%eax)
  282122:	0c 00                	or     $0x0,%al
  282124:	ec                   	in     (%dx),%al
  282125:	03 fc                	add    %esp,%edi
  282127:	07                   	pop    %es
  282128:	1c 0e                	sbb    $0xe,%al
  28212a:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28212d:	18 00                	sbb    %al,(%eax)
  28212f:	18 00                	sbb    %al,(%eax)
  282131:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282134:	1c 0c                	sbb    $0xc,%al
  282136:	18 0e                	sbb    %cl,(%esi)
  282138:	f8                   	clc    
  282139:	07                   	pop    %es
  28213a:	e0 03                	loopne 28213f <ASCII_Table+0x417>
	...
  282148:	00 00                	add    %al,(%eax)
  28214a:	c0 07 f0             	rolb   $0xf0,(%edi)
  28214d:	0f 38 1c 18          	pabsb  (%eax),%mm3
  282151:	18 18                	sbb    %bl,(%eax)
  282153:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282156:	cc                   	int3   
  282157:	03 ec                	add    %esp,%ebp
  282159:	0f 3c                	(bad)  
  28215b:	0e                   	push   %cs
  28215c:	1c 1c                	sbb    $0x1c,%al
  28215e:	0c 18                	or     $0x18,%al
  282160:	0c 18                	or     $0x18,%al
  282162:	0c 18                	or     $0x18,%al
  282164:	18 1c 38             	sbb    %bl,(%eax,%edi,1)
  282167:	0e                   	push   %cs
  282168:	f0 07                	lock pop %es
  28216a:	e0 03                	loopne 28216f <ASCII_Table+0x447>
	...
  282178:	00 00                	add    %al,(%eax)
  28217a:	fc                   	cld    
  28217b:	1f                   	pop    %ds
  28217c:	fc                   	cld    
  28217d:	1f                   	pop    %ds
  28217e:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282181:	06                   	push   %es
  282182:	00 06                	add    %al,(%esi)
  282184:	00 03                	add    %al,(%ebx)
  282186:	80 03 80             	addb   $0x80,(%ebx)
  282189:	01 c0                	add    %eax,%eax
  28218b:	01 c0                	add    %eax,%eax
  28218d:	00 e0                	add    %ah,%al
  28218f:	00 60 00             	add    %ah,0x0(%eax)
  282192:	60                   	pusha  
  282193:	00 70 00             	add    %dh,0x0(%eax)
  282196:	30 00                	xor    %al,(%eax)
  282198:	30 00                	xor    %al,(%eax)
  28219a:	30 00                	xor    %al,(%eax)
	...
  2821a8:	00 00                	add    %al,(%eax)
  2821aa:	e0 03                	loopne 2821af <ASCII_Table+0x487>
  2821ac:	f0 07                	lock pop %es
  2821ae:	38 0e                	cmp    %cl,(%esi)
  2821b0:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2821b3:	0c 18                	or     $0x18,%al
  2821b5:	0c 38                	or     $0x38,%al
  2821b7:	06                   	push   %es
  2821b8:	f0 07                	lock pop %es
  2821ba:	f0 07                	lock pop %es
  2821bc:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  2821bf:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2821c2:	0c 18                	or     $0x18,%al
  2821c4:	0c 18                	or     $0x18,%al
  2821c6:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  2821c9:	0f e0 03             	pavgb  (%ebx),%mm0
	...
  2821d8:	00 00                	add    %al,(%eax)
  2821da:	e0 03                	loopne 2821df <ASCII_Table+0x4b7>
  2821dc:	f0 07                	lock pop %es
  2821de:	38 0e                	cmp    %cl,(%esi)
  2821e0:	1c 0c                	sbb    $0xc,%al
  2821e2:	0c 18                	or     $0x18,%al
  2821e4:	0c 18                	or     $0x18,%al
  2821e6:	0c 18                	or     $0x18,%al
  2821e8:	1c 1c                	sbb    $0x1c,%al
  2821ea:	38 1e                	cmp    %bl,(%esi)
  2821ec:	f8                   	clc    
  2821ed:	1b e0                	sbb    %eax,%esp
  2821ef:	19 00                	sbb    %eax,(%eax)
  2821f1:	18 00                	sbb    %al,(%eax)
  2821f3:	0c 00                	or     $0x0,%al
  2821f5:	0c 1c                	or     $0x1c,%al
  2821f7:	0e                   	push   %cs
  2821f8:	f8                   	clc    
  2821f9:	07                   	pop    %es
  2821fa:	f0 01 00             	lock add %eax,(%eax)
	...
  282211:	00 00                	add    %al,(%eax)
  282213:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282225:	00 00                	add    %al,(%eax)
  282227:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282241:	00 00                	add    %al,(%eax)
  282243:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  282255:	00 00                	add    %al,(%eax)
  282257:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  28225d:	01 00                	add    %eax,(%eax)
  28225f:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  282279:	10 00                	adc    %al,(%eax)
  28227b:	1c 80                	sbb    $0x80,%al
  28227d:	0f e0 03             	pavgb  (%ebx),%mm0
  282280:	f8                   	clc    
  282281:	00 18                	add    %bl,(%eax)
  282283:	00 f8                	add    %bh,%al
  282285:	00 e0                	add    %ah,%al
  282287:	03 80 0f 00 1c 00    	add    0x1c000f(%eax),%eax
  28228d:	10 00                	adc    %al,(%eax)
	...
  2822a7:	00 f8                	add    %bh,%al
  2822a9:	1f                   	pop    %ds
  2822aa:	00 00                	add    %al,(%eax)
  2822ac:	00 00                	add    %al,(%eax)
  2822ae:	00 00                	add    %al,(%eax)
  2822b0:	f8                   	clc    
  2822b1:	1f                   	pop    %ds
	...
  2822d6:	00 00                	add    %al,(%eax)
  2822d8:	08 00                	or     %al,(%eax)
  2822da:	38 00                	cmp    %al,(%eax)
  2822dc:	f0 01 c0             	lock add %eax,%eax
  2822df:	07                   	pop    %es
  2822e0:	00 1f                	add    %bl,(%edi)
  2822e2:	00 18                	add    %bl,(%eax)
  2822e4:	00 1f                	add    %bl,(%edi)
  2822e6:	c0 07 f0             	rolb   $0xf0,(%edi)
  2822e9:	01 38                	add    %edi,(%eax)
  2822eb:	00 08                	add    %cl,(%eax)
	...
  2822f9:	00 e0                	add    %ah,%al
  2822fb:	03 f8                	add    %eax,%edi
  2822fd:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  282301:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282304:	00 18                	add    %bl,(%eax)
  282306:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282309:	06                   	push   %es
  28230a:	00 03                	add    %al,(%ebx)
  28230c:	80 01 c0             	addb   $0xc0,(%ecx)
  28230f:	00 c0                	add    %al,%al
  282311:	00 c0                	add    %al,%al
  282313:	00 00                	add    %al,(%eax)
  282315:	00 00                	add    %al,(%eax)
  282317:	00 c0                	add    %al,%al
  282319:	00 c0                	add    %al,%al
	...
  28232b:	00 e0                	add    %ah,%al
  28232d:	07                   	pop    %es
  28232e:	18 18                	sbb    %bl,(%eax)
  282330:	04 20                	add    $0x20,%al
  282332:	c2 29 22             	ret    $0x2229
  282335:	4a                   	dec    %edx
  282336:	11 44 09 44          	adc    %eax,0x44(%ecx,%ecx,1)
  28233a:	09 44 09 44          	or     %eax,0x44(%ecx,%ecx,1)
  28233e:	09 22                	or     %esp,(%edx)
  282340:	11 13                	adc    %edx,(%ebx)
  282342:	e2 0c                	loop   282350 <ASCII_Table+0x628>
  282344:	02 40 04             	add    0x4(%eax),%al
  282347:	20 18                	and    %bl,(%eax)
  282349:	18 e0                	sbb    %ah,%al
  28234b:	07                   	pop    %es
	...
  282358:	00 00                	add    %al,(%eax)
  28235a:	80 03 80             	addb   $0x80,(%ebx)
  28235d:	03 c0                	add    %eax,%eax
  28235f:	06                   	push   %es
  282360:	c0 06 c0             	rolb   $0xc0,(%esi)
  282363:	06                   	push   %es
  282364:	60                   	pusha  
  282365:	0c 60                	or     $0x60,%al
  282367:	0c 30                	or     $0x30,%al
  282369:	18 30                	sbb    %dh,(%eax)
  28236b:	18 30                	sbb    %dh,(%eax)
  28236d:	18 f8                	sbb    %bh,%al
  28236f:	3f                   	aas    
  282370:	f8                   	clc    
  282371:	3f                   	aas    
  282372:	1c 70                	sbb    $0x70,%al
  282374:	0c 60                	or     $0x60,%al
  282376:	0c 60                	or     $0x60,%al
  282378:	06                   	push   %es
  282379:	c0 06 c0             	rolb   $0xc0,(%esi)
	...
  282388:	00 00                	add    %al,(%eax)
  28238a:	fc                   	cld    
  28238b:	03 fc                	add    %esp,%edi
  28238d:	0f 0c                	(bad)  
  28238f:	0c 0c                	or     $0xc,%al
  282391:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282394:	0c 18                	or     $0x18,%al
  282396:	0c 0c                	or     $0xc,%al
  282398:	fc                   	cld    
  282399:	07                   	pop    %es
  28239a:	fc                   	cld    
  28239b:	0f 0c                	(bad)  
  28239d:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  2823a0:	0c 30                	or     $0x30,%al
  2823a2:	0c 30                	or     $0x30,%al
  2823a4:	0c 30                	or     $0x30,%al
  2823a6:	0c 18                	or     $0x18,%al
  2823a8:	fc                   	cld    
  2823a9:	1f                   	pop    %ds
  2823aa:	fc                   	cld    
  2823ab:	07                   	pop    %es
	...
  2823b8:	00 00                	add    %al,(%eax)
  2823ba:	c0 07 f0             	rolb   $0xf0,(%edi)
  2823bd:	1f                   	pop    %ds
  2823be:	38 38                	cmp    %bh,(%eax)
  2823c0:	1c 30                	sbb    $0x30,%al
  2823c2:	0c 70                	or     $0x70,%al
  2823c4:	06                   	push   %es
  2823c5:	60                   	pusha  
  2823c6:	06                   	push   %es
  2823c7:	00 06                	add    %al,(%esi)
  2823c9:	00 06                	add    %al,(%esi)
  2823cb:	00 06                	add    %al,(%esi)
  2823cd:	00 06                	add    %al,(%esi)
  2823cf:	00 06                	add    %al,(%esi)
  2823d1:	00 06                	add    %al,(%esi)
  2823d3:	60                   	pusha  
  2823d4:	0c 70                	or     $0x70,%al
  2823d6:	1c 30                	sbb    $0x30,%al
  2823d8:	f0 1f                	lock pop %ds
  2823da:	e0 07                	loopne 2823e3 <ASCII_Table+0x6bb>
	...
  2823e8:	00 00                	add    %al,(%eax)
  2823ea:	fe 03                	incb   (%ebx)
  2823ec:	fe 0f                	decb   (%edi)
  2823ee:	06                   	push   %es
  2823ef:	0e                   	push   %cs
  2823f0:	06                   	push   %es
  2823f1:	18 06                	sbb    %al,(%esi)
  2823f3:	18 06                	sbb    %al,(%esi)
  2823f5:	30 06                	xor    %al,(%esi)
  2823f7:	30 06                	xor    %al,(%esi)
  2823f9:	30 06                	xor    %al,(%esi)
  2823fb:	30 06                	xor    %al,(%esi)
  2823fd:	30 06                	xor    %al,(%esi)
  2823ff:	30 06                	xor    %al,(%esi)
  282401:	30 06                	xor    %al,(%esi)
  282403:	18 06                	sbb    %al,(%esi)
  282405:	18 06                	sbb    %al,(%esi)
  282407:	0e                   	push   %cs
  282408:	fe 0f                	decb   (%edi)
  28240a:	fe 03                	incb   (%ebx)
	...
  282418:	00 00                	add    %al,(%eax)
  28241a:	fc                   	cld    
  28241b:	3f                   	aas    
  28241c:	fc                   	cld    
  28241d:	3f                   	aas    
  28241e:	0c 00                	or     $0x0,%al
  282420:	0c 00                	or     $0x0,%al
  282422:	0c 00                	or     $0x0,%al
  282424:	0c 00                	or     $0x0,%al
  282426:	0c 00                	or     $0x0,%al
  282428:	fc                   	cld    
  282429:	1f                   	pop    %ds
  28242a:	fc                   	cld    
  28242b:	1f                   	pop    %ds
  28242c:	0c 00                	or     $0x0,%al
  28242e:	0c 00                	or     $0x0,%al
  282430:	0c 00                	or     $0x0,%al
  282432:	0c 00                	or     $0x0,%al
  282434:	0c 00                	or     $0x0,%al
  282436:	0c 00                	or     $0x0,%al
  282438:	fc                   	cld    
  282439:	3f                   	aas    
  28243a:	fc                   	cld    
  28243b:	3f                   	aas    
	...
  282448:	00 00                	add    %al,(%eax)
  28244a:	f8                   	clc    
  28244b:	3f                   	aas    
  28244c:	f8                   	clc    
  28244d:	3f                   	aas    
  28244e:	18 00                	sbb    %al,(%eax)
  282450:	18 00                	sbb    %al,(%eax)
  282452:	18 00                	sbb    %al,(%eax)
  282454:	18 00                	sbb    %al,(%eax)
  282456:	18 00                	sbb    %al,(%eax)
  282458:	f8                   	clc    
  282459:	1f                   	pop    %ds
  28245a:	f8                   	clc    
  28245b:	1f                   	pop    %ds
  28245c:	18 00                	sbb    %al,(%eax)
  28245e:	18 00                	sbb    %al,(%eax)
  282460:	18 00                	sbb    %al,(%eax)
  282462:	18 00                	sbb    %al,(%eax)
  282464:	18 00                	sbb    %al,(%eax)
  282466:	18 00                	sbb    %al,(%eax)
  282468:	18 00                	sbb    %al,(%eax)
  28246a:	18 00                	sbb    %al,(%eax)
	...
  282478:	00 00                	add    %al,(%eax)
  28247a:	e0 0f                	loopne 28248b <ASCII_Table+0x763>
  28247c:	f8                   	clc    
  28247d:	3f                   	aas    
  28247e:	3c 78                	cmp    $0x78,%al
  282480:	0e                   	push   %cs
  282481:	60                   	pusha  
  282482:	06                   	push   %es
  282483:	e0 07                	loopne 28248c <ASCII_Table+0x764>
  282485:	c0 03 00             	rolb   $0x0,(%ebx)
  282488:	03 00                	add    (%eax),%eax
  28248a:	03 fe                	add    %esi,%edi
  28248c:	03 fe                	add    %esi,%edi
  28248e:	03 c0                	add    %eax,%eax
  282490:	07                   	pop    %es
  282491:	c0 06 c0             	rolb   $0xc0,(%esi)
  282494:	0e                   	push   %cs
  282495:	c0 3c f0 f8          	sarb   $0xf8,(%eax,%esi,8)
  282499:	3f                   	aas    
  28249a:	e0 0f                	loopne 2824ab <ASCII_Table+0x783>
	...
  2824a8:	00 00                	add    %al,(%eax)
  2824aa:	0c 30                	or     $0x30,%al
  2824ac:	0c 30                	or     $0x30,%al
  2824ae:	0c 30                	or     $0x30,%al
  2824b0:	0c 30                	or     $0x30,%al
  2824b2:	0c 30                	or     $0x30,%al
  2824b4:	0c 30                	or     $0x30,%al
  2824b6:	0c 30                	or     $0x30,%al
  2824b8:	fc                   	cld    
  2824b9:	3f                   	aas    
  2824ba:	fc                   	cld    
  2824bb:	3f                   	aas    
  2824bc:	0c 30                	or     $0x30,%al
  2824be:	0c 30                	or     $0x30,%al
  2824c0:	0c 30                	or     $0x30,%al
  2824c2:	0c 30                	or     $0x30,%al
  2824c4:	0c 30                	or     $0x30,%al
  2824c6:	0c 30                	or     $0x30,%al
  2824c8:	0c 30                	or     $0x30,%al
  2824ca:	0c 30                	or     $0x30,%al
	...
  2824d8:	00 00                	add    %al,(%eax)
  2824da:	80 01 80             	addb   $0x80,(%ecx)
  2824dd:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2824e3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2824e9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2824ef:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2824f5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2824fb:	01 00                	add    %eax,(%eax)
	...
  282509:	00 00                	add    %al,(%eax)
  28250b:	06                   	push   %es
  28250c:	00 06                	add    %al,(%esi)
  28250e:	00 06                	add    %al,(%esi)
  282510:	00 06                	add    %al,(%esi)
  282512:	00 06                	add    %al,(%esi)
  282514:	00 06                	add    %al,(%esi)
  282516:	00 06                	add    %al,(%esi)
  282518:	00 06                	add    %al,(%esi)
  28251a:	00 06                	add    %al,(%esi)
  28251c:	00 06                	add    %al,(%esi)
  28251e:	00 06                	add    %al,(%esi)
  282520:	00 06                	add    %al,(%esi)
  282522:	18 06                	sbb    %al,(%esi)
  282524:	18 06                	sbb    %al,(%esi)
  282526:	38 07                	cmp    %al,(%edi)
  282528:	f0 03 e0             	lock add %eax,%esp
  28252b:	01 00                	add    %eax,(%eax)
	...
  282539:	00 06                	add    %al,(%esi)
  28253b:	30 06                	xor    %al,(%esi)
  28253d:	18 06                	sbb    %al,(%esi)
  28253f:	0c 06                	or     $0x6,%al
  282541:	06                   	push   %es
  282542:	06                   	push   %es
  282543:	03 86 01 c6 00 66    	add    0x6600c601(%esi),%eax
  282549:	00 76 00             	add    %dh,0x0(%esi)
  28254c:	de 00                	fiadd  (%eax)
  28254e:	8e 01                	mov    (%ecx),%es
  282550:	06                   	push   %es
  282551:	03 06                	add    (%esi),%eax
  282553:	06                   	push   %es
  282554:	06                   	push   %es
  282555:	0c 06                	or     $0x6,%al
  282557:	18 06                	sbb    %al,(%esi)
  282559:	30 06                	xor    %al,(%esi)
  28255b:	60                   	pusha  
	...
  282568:	00 00                	add    %al,(%eax)
  28256a:	18 00                	sbb    %al,(%eax)
  28256c:	18 00                	sbb    %al,(%eax)
  28256e:	18 00                	sbb    %al,(%eax)
  282570:	18 00                	sbb    %al,(%eax)
  282572:	18 00                	sbb    %al,(%eax)
  282574:	18 00                	sbb    %al,(%eax)
  282576:	18 00                	sbb    %al,(%eax)
  282578:	18 00                	sbb    %al,(%eax)
  28257a:	18 00                	sbb    %al,(%eax)
  28257c:	18 00                	sbb    %al,(%eax)
  28257e:	18 00                	sbb    %al,(%eax)
  282580:	18 00                	sbb    %al,(%eax)
  282582:	18 00                	sbb    %al,(%eax)
  282584:	18 00                	sbb    %al,(%eax)
  282586:	18 00                	sbb    %al,(%eax)
  282588:	f8                   	clc    
  282589:	1f                   	pop    %ds
  28258a:	f8                   	clc    
  28258b:	1f                   	pop    %ds
	...
  282598:	00 00                	add    %al,(%eax)
  28259a:	0e                   	push   %cs
  28259b:	e0 1e                	loopne 2825bb <ASCII_Table+0x893>
  28259d:	f0 1e                	lock push %ds
  28259f:	f0 1e                	lock push %ds
  2825a1:	f0 36 d8 36          	lock fdivs %ss:(%esi)
  2825a5:	d8 36                	fdivs  (%esi)
  2825a7:	d8 36                	fdivs  (%esi)
  2825a9:	d8 66 cc             	fsubs  -0x34(%esi)
  2825ac:	66                   	data16
  2825ad:	cc                   	int3   
  2825ae:	66                   	data16
  2825af:	cc                   	int3   
  2825b0:	c6 c6 c6             	mov    $0xc6,%dh
  2825b3:	c6 c6 c6             	mov    $0xc6,%dh
  2825b6:	c6 c6 86             	mov    $0x86,%dh
  2825b9:	c3                   	ret    
  2825ba:	86 c3                	xchg   %al,%bl
	...
  2825c8:	00 00                	add    %al,(%eax)
  2825ca:	0c 30                	or     $0x30,%al
  2825cc:	1c 30                	sbb    $0x30,%al
  2825ce:	3c 30                	cmp    $0x30,%al
  2825d0:	3c 30                	cmp    $0x30,%al
  2825d2:	6c                   	insb   (%dx),%es:(%edi)
  2825d3:	30 6c 30 cc          	xor    %ch,-0x34(%eax,%esi,1)
  2825d7:	30 cc                	xor    %cl,%ah
  2825d9:	30 8c 31 0c 33 0c 33 	xor    %cl,0x330c330c(%ecx,%esi,1)
  2825e0:	0c 36                	or     $0x36,%al
  2825e2:	0c 36                	or     $0x36,%al
  2825e4:	0c 3c                	or     $0x3c,%al
  2825e6:	0c 3c                	or     $0x3c,%al
  2825e8:	0c 38                	or     $0x38,%al
  2825ea:	0c 30                	or     $0x30,%al
	...
  2825f8:	00 00                	add    %al,(%eax)
  2825fa:	e0 07                	loopne 282603 <ASCII_Table+0x8db>
  2825fc:	f8                   	clc    
  2825fd:	1f                   	pop    %ds
  2825fe:	1c 38                	sbb    $0x38,%al
  282600:	0e                   	push   %cs
  282601:	70 06                	jo     282609 <ASCII_Table+0x8e1>
  282603:	60                   	pusha  
  282604:	03 c0                	add    %eax,%eax
  282606:	03 c0                	add    %eax,%eax
  282608:	03 c0                	add    %eax,%eax
  28260a:	03 c0                	add    %eax,%eax
  28260c:	03 c0                	add    %eax,%eax
  28260e:	03 c0                	add    %eax,%eax
  282610:	03 c0                	add    %eax,%eax
  282612:	06                   	push   %es
  282613:	60                   	pusha  
  282614:	0e                   	push   %cs
  282615:	70 1c                	jo     282633 <ASCII_Table+0x90b>
  282617:	38 f8                	cmp    %bh,%al
  282619:	1f                   	pop    %ds
  28261a:	e0 07                	loopne 282623 <ASCII_Table+0x8fb>
	...
  282628:	00 00                	add    %al,(%eax)
  28262a:	fc                   	cld    
  28262b:	0f fc 1f             	paddb  (%edi),%mm3
  28262e:	0c 38                	or     $0x38,%al
  282630:	0c 30                	or     $0x30,%al
  282632:	0c 30                	or     $0x30,%al
  282634:	0c 30                	or     $0x30,%al
  282636:	0c 30                	or     $0x30,%al
  282638:	0c 18                	or     $0x18,%al
  28263a:	fc                   	cld    
  28263b:	1f                   	pop    %ds
  28263c:	fc                   	cld    
  28263d:	07                   	pop    %es
  28263e:	0c 00                	or     $0x0,%al
  282640:	0c 00                	or     $0x0,%al
  282642:	0c 00                	or     $0x0,%al
  282644:	0c 00                	or     $0x0,%al
  282646:	0c 00                	or     $0x0,%al
  282648:	0c 00                	or     $0x0,%al
  28264a:	0c 00                	or     $0x0,%al
	...
  282658:	00 00                	add    %al,(%eax)
  28265a:	e0 07                	loopne 282663 <ASCII_Table+0x93b>
  28265c:	f8                   	clc    
  28265d:	1f                   	pop    %ds
  28265e:	1c 38                	sbb    $0x38,%al
  282660:	0e                   	push   %cs
  282661:	70 06                	jo     282669 <ASCII_Table+0x941>
  282663:	60                   	pusha  
  282664:	03 e0                	add    %eax,%esp
  282666:	03 c0                	add    %eax,%eax
  282668:	03 c0                	add    %eax,%eax
  28266a:	03 c0                	add    %eax,%eax
  28266c:	03 c0                	add    %eax,%eax
  28266e:	03 c0                	add    %eax,%eax
  282670:	07                   	pop    %es
  282671:	e0 06                	loopne 282679 <ASCII_Table+0x951>
  282673:	63 0e                	arpl   %cx,(%esi)
  282675:	3f                   	aas    
  282676:	1c 3c                	sbb    $0x3c,%al
  282678:	f8                   	clc    
  282679:	3f                   	aas    
  28267a:	e0 f7                	loopne 282673 <ASCII_Table+0x94b>
  28267c:	00 c0                	add    %al,%al
	...
  28268a:	fe 0f                	decb   (%edi)
  28268c:	fe                   	(bad)  
  28268d:	1f                   	pop    %ds
  28268e:	06                   	push   %es
  28268f:	38 06                	cmp    %al,(%esi)
  282691:	30 06                	xor    %al,(%esi)
  282693:	30 06                	xor    %al,(%esi)
  282695:	30 06                	xor    %al,(%esi)
  282697:	38 fe                	cmp    %bh,%dh
  282699:	1f                   	pop    %ds
  28269a:	fe 07                	incb   (%edi)
  28269c:	06                   	push   %es
  28269d:	03 06                	add    (%esi),%eax
  28269f:	06                   	push   %es
  2826a0:	06                   	push   %es
  2826a1:	0c 06                	or     $0x6,%al
  2826a3:	18 06                	sbb    %al,(%esi)
  2826a5:	18 06                	sbb    %al,(%esi)
  2826a7:	30 06                	xor    %al,(%esi)
  2826a9:	30 06                	xor    %al,(%esi)
  2826ab:	60                   	pusha  
	...
  2826b8:	00 00                	add    %al,(%eax)
  2826ba:	e0 03                	loopne 2826bf <ASCII_Table+0x997>
  2826bc:	f8                   	clc    
  2826bd:	0f 1c 0c 0c          	nopl   (%esp,%ecx,1)
  2826c1:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2826c4:	0c 00                	or     $0x0,%al
  2826c6:	1c 00                	sbb    $0x0,%al
  2826c8:	f8                   	clc    
  2826c9:	03 e0                	add    %eax,%esp
  2826cb:	0f 00 1e             	ltr    (%esi)
  2826ce:	00 38                	add    %bh,(%eax)
  2826d0:	06                   	push   %es
  2826d1:	30 06                	xor    %al,(%esi)
  2826d3:	30 0e                	xor    %cl,(%esi)
  2826d5:	30 1c 1c             	xor    %bl,(%esp,%ebx,1)
  2826d8:	f8                   	clc    
  2826d9:	0f e0 07             	pavgb  (%edi),%mm0
	...
  2826e8:	00 00                	add    %al,(%eax)
  2826ea:	fe                   	(bad)  
  2826eb:	7f fe                	jg     2826eb <ASCII_Table+0x9c3>
  2826ed:	7f 80                	jg     28266f <ASCII_Table+0x947>
  2826ef:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2826f5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2826fb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282701:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282707:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
	...
  282719:	00 0c 30             	add    %cl,(%eax,%esi,1)
  28271c:	0c 30                	or     $0x30,%al
  28271e:	0c 30                	or     $0x30,%al
  282720:	0c 30                	or     $0x30,%al
  282722:	0c 30                	or     $0x30,%al
  282724:	0c 30                	or     $0x30,%al
  282726:	0c 30                	or     $0x30,%al
  282728:	0c 30                	or     $0x30,%al
  28272a:	0c 30                	or     $0x30,%al
  28272c:	0c 30                	or     $0x30,%al
  28272e:	0c 30                	or     $0x30,%al
  282730:	0c 30                	or     $0x30,%al
  282732:	0c 30                	or     $0x30,%al
  282734:	0c 30                	or     $0x30,%al
  282736:	18 18                	sbb    %bl,(%eax)
  282738:	f8                   	clc    
  282739:	1f                   	pop    %ds
  28273a:	e0 07                	loopne 282743 <ASCII_Table+0xa1b>
	...
  282748:	00 00                	add    %al,(%eax)
  28274a:	03 60 06             	add    0x6(%eax),%esp
  28274d:	30 06                	xor    %al,(%esi)
  28274f:	30 06                	xor    %al,(%esi)
  282751:	30 0c 18             	xor    %cl,(%eax,%ebx,1)
  282754:	0c 18                	or     $0x18,%al
  282756:	0c 18                	or     $0x18,%al
  282758:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28275b:	0c 38                	or     $0x38,%al
  28275d:	0e                   	push   %cs
  28275e:	30 06                	xor    %al,(%esi)
  282760:	30 06                	xor    %al,(%esi)
  282762:	70 07                	jo     28276b <ASCII_Table+0xa43>
  282764:	60                   	pusha  
  282765:	03 60 03             	add    0x3(%eax),%esp
  282768:	c0 01 c0             	rolb   $0xc0,(%ecx)
  28276b:	01 00                	add    %eax,(%eax)
	...
  282779:	00 03                	add    %al,(%ebx)
  28277b:	60                   	pusha  
  28277c:	c3                   	ret    
  28277d:	61                   	popa   
  28277e:	c3                   	ret    
  28277f:	61                   	popa   
  282780:	c3                   	ret    
  282781:	61                   	popa   
  282782:	66 33 66 33          	xor    0x33(%esi),%sp
  282786:	66 33 66 33          	xor    0x33(%esi),%sp
  28278a:	66 33 66 33          	xor    0x33(%esi),%sp
  28278e:	6c                   	insb   (%dx),%es:(%edi)
  28278f:	1b 6c 1b 6c          	sbb    0x6c(%ebx,%ebx,1),%ebp
  282793:	1b 2c 1a             	sbb    (%edx,%ebx,1),%ebp
  282796:	3c 1e                	cmp    $0x1e,%al
  282798:	38 0e                	cmp    %cl,(%esi)
  28279a:	38 0e                	cmp    %cl,(%esi)
	...
  2827a8:	00 00                	add    %al,(%eax)
  2827aa:	0f e0 0c 70          	pavgb  (%eax,%esi,2),%mm1
  2827ae:	18 30                	sbb    %dh,(%eax)
  2827b0:	30 18                	xor    %bl,(%eax)
  2827b2:	70 0c                	jo     2827c0 <ASCII_Table+0xa98>
  2827b4:	60                   	pusha  
  2827b5:	0e                   	push   %cs
  2827b6:	c0 07 80             	rolb   $0x80,(%edi)
  2827b9:	03 80 03 c0 03 e0    	add    -0x1ffc3ffd(%eax),%eax
  2827bf:	06                   	push   %es
  2827c0:	70 0c                	jo     2827ce <ASCII_Table+0xaa6>
  2827c2:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  2827c5:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  2827c8:	0e                   	push   %cs
  2827c9:	60                   	pusha  
  2827ca:	07                   	pop    %es
  2827cb:	e0 00                	loopne 2827cd <ASCII_Table+0xaa5>
	...
  2827d9:	00 03                	add    %al,(%ebx)
  2827db:	c0 06 60             	rolb   $0x60,(%esi)
  2827de:	0c 30                	or     $0x30,%al
  2827e0:	1c 38                	sbb    $0x38,%al
  2827e2:	38 18                	cmp    %bl,(%eax)
  2827e4:	30 0c 60             	xor    %cl,(%eax,%eiz,2)
  2827e7:	06                   	push   %es
  2827e8:	e0 07                	loopne 2827f1 <ASCII_Table+0xac9>
  2827ea:	c0 03 80             	rolb   $0x80,(%ebx)
  2827ed:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2827f3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2827f9:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  282807:	00 00                	add    %al,(%eax)
  282809:	00 fc                	add    %bh,%ah
  28280b:	7f fc                	jg     282809 <ASCII_Table+0xae1>
  28280d:	7f 00                	jg     28280f <ASCII_Table+0xae7>
  28280f:	60                   	pusha  
  282810:	00 30                	add    %dh,(%eax)
  282812:	00 18                	add    %bl,(%eax)
  282814:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282817:	06                   	push   %es
  282818:	00 03                	add    %al,(%ebx)
  28281a:	80 01 c0             	addb   $0xc0,(%ecx)
  28281d:	00 60 00             	add    %ah,0x0(%eax)
  282820:	30 00                	xor    %al,(%eax)
  282822:	18 00                	sbb    %al,(%eax)
  282824:	0c 00                	or     $0x0,%al
  282826:	06                   	push   %es
  282827:	00 fe                	add    %bh,%dh
  282829:	7f fe                	jg     282829 <ASCII_Table+0xb01>
  28282b:	7f 00                	jg     28282d <ASCII_Table+0xb05>
	...
  282839:	00 e0                	add    %ah,%al
  28283b:	03 e0                	add    %eax,%esp
  28283d:	03 60 00             	add    0x0(%eax),%esp
  282840:	60                   	pusha  
  282841:	00 60 00             	add    %ah,0x0(%eax)
  282844:	60                   	pusha  
  282845:	00 60 00             	add    %ah,0x0(%eax)
  282848:	60                   	pusha  
  282849:	00 60 00             	add    %ah,0x0(%eax)
  28284c:	60                   	pusha  
  28284d:	00 60 00             	add    %ah,0x0(%eax)
  282850:	60                   	pusha  
  282851:	00 60 00             	add    %ah,0x0(%eax)
  282854:	60                   	pusha  
  282855:	00 60 00             	add    %ah,0x0(%eax)
  282858:	60                   	pusha  
  282859:	00 60 00             	add    %ah,0x0(%eax)
  28285c:	60                   	pusha  
  28285d:	00 60 00             	add    %ah,0x0(%eax)
  282860:	60                   	pusha  
  282861:	00 e0                	add    %ah,%al
  282863:	03 e0                	add    %eax,%esp
  282865:	03 00                	add    (%eax),%eax
  282867:	00 00                	add    %al,(%eax)
  282869:	00 30                	add    %dh,(%eax)
  28286b:	00 30                	add    %dh,(%eax)
  28286d:	00 60 00             	add    %ah,0x0(%eax)
  282870:	60                   	pusha  
  282871:	00 60 00             	add    %ah,0x0(%eax)
  282874:	c0 00 c0             	rolb   $0xc0,(%eax)
  282877:	00 c0                	add    %al,%al
  282879:	00 c0                	add    %al,%al
  28287b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282881:	01 00                	add    %eax,(%eax)
  282883:	03 00                	add    (%eax),%eax
  282885:	03 00                	add    (%eax),%eax
  282887:	03 00                	add    (%eax),%eax
  282889:	06                   	push   %es
  28288a:	00 06                	add    %al,(%esi)
	...
  282898:	00 00                	add    %al,(%eax)
  28289a:	e0 03                	loopne 28289f <ASCII_Table+0xb77>
  28289c:	e0 03                	loopne 2828a1 <ASCII_Table+0xb79>
  28289e:	00 03                	add    %al,(%ebx)
  2828a0:	00 03                	add    %al,(%ebx)
  2828a2:	00 03                	add    %al,(%ebx)
  2828a4:	00 03                	add    %al,(%ebx)
  2828a6:	00 03                	add    %al,(%ebx)
  2828a8:	00 03                	add    %al,(%ebx)
  2828aa:	00 03                	add    %al,(%ebx)
  2828ac:	00 03                	add    %al,(%ebx)
  2828ae:	00 03                	add    %al,(%ebx)
  2828b0:	00 03                	add    %al,(%ebx)
  2828b2:	00 03                	add    %al,(%ebx)
  2828b4:	00 03                	add    %al,(%ebx)
  2828b6:	00 03                	add    %al,(%ebx)
  2828b8:	00 03                	add    %al,(%ebx)
  2828ba:	00 03                	add    %al,(%ebx)
  2828bc:	00 03                	add    %al,(%ebx)
  2828be:	00 03                	add    %al,(%ebx)
  2828c0:	00 03                	add    %al,(%ebx)
  2828c2:	e0 03                	loopne 2828c7 <ASCII_Table+0xb9f>
  2828c4:	e0 03                	loopne 2828c9 <ASCII_Table+0xba1>
  2828c6:	00 00                	add    %al,(%eax)
  2828c8:	00 00                	add    %al,(%eax)
  2828ca:	00 00                	add    %al,(%eax)
  2828cc:	c0 01 c0             	rolb   $0xc0,(%ecx)
  2828cf:	01 60 03             	add    %esp,0x3(%eax)
  2828d2:	60                   	pusha  
  2828d3:	03 60 03             	add    0x3(%eax),%esp
  2828d6:	30 06                	xor    %al,(%esi)
  2828d8:	30 06                	xor    %al,(%esi)
  2828da:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2828dd:	0c 00                	or     $0x0,%al
	...
  282917:	00 00                	add    %al,(%eax)
  282919:	00 ff                	add    %bh,%bh
  28291b:	ff                   	(bad)  
  28291c:	ff                   	(bad)  
  28291d:	ff 00                	incl   (%eax)
	...
  282927:	00 00                	add    %al,(%eax)
  282929:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28292c:	0c 00                	or     $0x0,%al
  28292e:	0c 00                	or     $0x0,%al
  282930:	0c 00                	or     $0x0,%al
  282932:	0c 00                	or     $0x0,%al
  282934:	0c 00                	or     $0x0,%al
	...
  282962:	00 00                	add    %al,(%eax)
  282964:	f0 03 f8             	lock add %eax,%edi
  282967:	07                   	pop    %es
  282968:	1c 0c                	sbb    $0xc,%al
  28296a:	0c 0c                	or     $0xc,%al
  28296c:	00 0f                	add    %cl,(%edi)
  28296e:	f0 0f f8 0c 0c       	lock psubb (%esp,%ecx,1),%mm1
  282973:	0c 0c                	or     $0xc,%al
  282975:	0c 1c                	or     $0x1c,%al
  282977:	0f f8 0f             	psubb  (%edi),%mm1
  28297a:	f0 18 00             	lock sbb %al,(%eax)
	...
  282989:	00 18                	add    %bl,(%eax)
  28298b:	00 18                	add    %bl,(%eax)
  28298d:	00 18                	add    %bl,(%eax)
  28298f:	00 18                	add    %bl,(%eax)
  282991:	00 18                	add    %bl,(%eax)
  282993:	00 d8                	add    %bl,%al
  282995:	03 f8                	add    %eax,%edi
  282997:	0f 38 0c             	(bad)  
  28299a:	18 18                	sbb    %bl,(%eax)
  28299c:	18 18                	sbb    %bl,(%eax)
  28299e:	18 18                	sbb    %bl,(%eax)
  2829a0:	18 18                	sbb    %bl,(%eax)
  2829a2:	18 18                	sbb    %bl,(%eax)
  2829a4:	18 18                	sbb    %bl,(%eax)
  2829a6:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  2829a9:	0f d8 03             	psubusb (%ebx),%mm0
	...
  2829c4:	c0 03 f0             	rolb   $0xf0,(%ebx)
  2829c7:	07                   	pop    %es
  2829c8:	30 0e                	xor    %cl,(%esi)
  2829ca:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2829cd:	00 18                	add    %bl,(%eax)
  2829cf:	00 18                	add    %bl,(%eax)
  2829d1:	00 18                	add    %bl,(%eax)
  2829d3:	00 18                	add    %bl,(%eax)
  2829d5:	0c 30                	or     $0x30,%al
  2829d7:	0e                   	push   %cs
  2829d8:	f0 07                	lock pop %es
  2829da:	c0 03 00             	rolb   $0x0,(%ebx)
	...
  2829e9:	00 00                	add    %al,(%eax)
  2829eb:	18 00                	sbb    %al,(%eax)
  2829ed:	18 00                	sbb    %al,(%eax)
  2829ef:	18 00                	sbb    %al,(%eax)
  2829f1:	18 00                	sbb    %al,(%eax)
  2829f3:	18 c0                	sbb    %al,%al
  2829f5:	1b f0                	sbb    %eax,%esi
  2829f7:	1f                   	pop    %ds
  2829f8:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  2829fb:	18 18                	sbb    %bl,(%eax)
  2829fd:	18 18                	sbb    %bl,(%eax)
  2829ff:	18 18                	sbb    %bl,(%eax)
  282a01:	18 18                	sbb    %bl,(%eax)
  282a03:	18 18                	sbb    %bl,(%eax)
  282a05:	18 30                	sbb    %dh,(%eax)
  282a07:	1c f0                	sbb    $0xf0,%al
  282a09:	1f                   	pop    %ds
  282a0a:	c0 1b 00             	rcrb   $0x0,(%ebx)
	...
  282a21:	00 00                	add    %al,(%eax)
  282a23:	00 c0                	add    %al,%al
  282a25:	03 f0                	add    %eax,%esi
  282a27:	0f 30                	wrmsr  
  282a29:	0c 18                	or     $0x18,%al
  282a2b:	18 f8                	sbb    %bh,%al
  282a2d:	1f                   	pop    %ds
  282a2e:	f8                   	clc    
  282a2f:	1f                   	pop    %ds
  282a30:	18 00                	sbb    %al,(%eax)
  282a32:	18 00                	sbb    %al,(%eax)
  282a34:	38 18                	cmp    %bl,(%eax)
  282a36:	30 1c f0             	xor    %bl,(%eax,%esi,8)
  282a39:	0f c0 07             	xadd   %al,(%edi)
	...
  282a48:	00 00                	add    %al,(%eax)
  282a4a:	80 0f c0             	orb    $0xc0,(%edi)
  282a4d:	0f c0 00             	xadd   %al,(%eax)
  282a50:	c0 00 c0             	rolb   $0xc0,(%eax)
  282a53:	00 f0                	add    %dh,%al
  282a55:	07                   	pop    %es
  282a56:	f0 07                	lock pop %es
  282a58:	c0 00 c0             	rolb   $0xc0,(%eax)
  282a5b:	00 c0                	add    %al,%al
  282a5d:	00 c0                	add    %al,%al
  282a5f:	00 c0                	add    %al,%al
  282a61:	00 c0                	add    %al,%al
  282a63:	00 c0                	add    %al,%al
  282a65:	00 c0                	add    %al,%al
  282a67:	00 c0                	add    %al,%al
  282a69:	00 c0                	add    %al,%al
	...
  282a83:	00 e0                	add    %ah,%al
  282a85:	0d f8 0f 18 0e       	or     $0xe180ff8,%eax
  282a8a:	0c 0c                	or     $0xc,%al
  282a8c:	0c 0c                	or     $0xc,%al
  282a8e:	0c 0c                	or     $0xc,%al
  282a90:	0c 0c                	or     $0xc,%al
  282a92:	0c 0c                	or     $0xc,%al
  282a94:	0c 0c                	or     $0xc,%al
  282a96:	18 0e                	sbb    %cl,(%esi)
  282a98:	f8                   	clc    
  282a99:	0f e0 0d 00 0c 0c 0c 	pavgb  0xc0c0c00,%mm1
  282aa0:	1c 06                	sbb    $0x6,%al
  282aa2:	f8                   	clc    
  282aa3:	07                   	pop    %es
  282aa4:	f0 01 00             	lock add %eax,(%eax)
  282aa7:	00 00                	add    %al,(%eax)
  282aa9:	00 18                	add    %bl,(%eax)
  282aab:	00 18                	add    %bl,(%eax)
  282aad:	00 18                	add    %bl,(%eax)
  282aaf:	00 18                	add    %bl,(%eax)
  282ab1:	00 18                	add    %bl,(%eax)
  282ab3:	00 d8                	add    %bl,%al
  282ab5:	07                   	pop    %es
  282ab6:	f8                   	clc    
  282ab7:	0f 38 1c 18          	pabsb  (%eax),%mm3
  282abb:	18 18                	sbb    %bl,(%eax)
  282abd:	18 18                	sbb    %bl,(%eax)
  282abf:	18 18                	sbb    %bl,(%eax)
  282ac1:	18 18                	sbb    %bl,(%eax)
  282ac3:	18 18                	sbb    %bl,(%eax)
  282ac5:	18 18                	sbb    %bl,(%eax)
  282ac7:	18 18                	sbb    %bl,(%eax)
  282ac9:	18 18                	sbb    %bl,(%eax)
  282acb:	18 00                	sbb    %al,(%eax)
	...
  282ad9:	00 c0                	add    %al,%al
  282adb:	00 c0                	add    %al,%al
  282add:	00 00                	add    %al,(%eax)
  282adf:	00 00                	add    %al,(%eax)
  282ae1:	00 00                	add    %al,(%eax)
  282ae3:	00 c0                	add    %al,%al
  282ae5:	00 c0                	add    %al,%al
  282ae7:	00 c0                	add    %al,%al
  282ae9:	00 c0                	add    %al,%al
  282aeb:	00 c0                	add    %al,%al
  282aed:	00 c0                	add    %al,%al
  282aef:	00 c0                	add    %al,%al
  282af1:	00 c0                	add    %al,%al
  282af3:	00 c0                	add    %al,%al
  282af5:	00 c0                	add    %al,%al
  282af7:	00 c0                	add    %al,%al
  282af9:	00 c0                	add    %al,%al
	...
  282b07:	00 00                	add    %al,(%eax)
  282b09:	00 c0                	add    %al,%al
  282b0b:	00 c0                	add    %al,%al
  282b0d:	00 00                	add    %al,(%eax)
  282b0f:	00 00                	add    %al,(%eax)
  282b11:	00 00                	add    %al,(%eax)
  282b13:	00 c0                	add    %al,%al
  282b15:	00 c0                	add    %al,%al
  282b17:	00 c0                	add    %al,%al
  282b19:	00 c0                	add    %al,%al
  282b1b:	00 c0                	add    %al,%al
  282b1d:	00 c0                	add    %al,%al
  282b1f:	00 c0                	add    %al,%al
  282b21:	00 c0                	add    %al,%al
  282b23:	00 c0                	add    %al,%al
  282b25:	00 c0                	add    %al,%al
  282b27:	00 c0                	add    %al,%al
  282b29:	00 c0                	add    %al,%al
  282b2b:	00 c0                	add    %al,%al
  282b2d:	00 c0                	add    %al,%al
  282b2f:	00 c0                	add    %al,%al
  282b31:	00 f8                	add    %bh,%al
  282b33:	00 78 00             	add    %bh,0x0(%eax)
  282b36:	00 00                	add    %al,(%eax)
  282b38:	00 00                	add    %al,(%eax)
  282b3a:	0c 00                	or     $0x0,%al
  282b3c:	0c 00                	or     $0x0,%al
  282b3e:	0c 00                	or     $0x0,%al
  282b40:	0c 00                	or     $0x0,%al
  282b42:	0c 00                	or     $0x0,%al
  282b44:	0c 0c                	or     $0xc,%al
  282b46:	0c 06                	or     $0x6,%al
  282b48:	0c 03                	or     $0x3,%al
  282b4a:	8c 01                	mov    %es,(%ecx)
  282b4c:	cc                   	int3   
  282b4d:	00 6c 00 fc          	add    %ch,-0x4(%eax,%eax,1)
  282b51:	00 9c 01 8c 03 0c 03 	add    %bl,0x30c038c(%ecx,%eax,1)
  282b58:	0c 06                	or     $0x6,%al
  282b5a:	0c 0c                	or     $0xc,%al
	...
  282b68:	00 00                	add    %al,(%eax)
  282b6a:	c0 00 c0             	rolb   $0xc0,(%eax)
  282b6d:	00 c0                	add    %al,%al
  282b6f:	00 c0                	add    %al,%al
  282b71:	00 c0                	add    %al,%al
  282b73:	00 c0                	add    %al,%al
  282b75:	00 c0                	add    %al,%al
  282b77:	00 c0                	add    %al,%al
  282b79:	00 c0                	add    %al,%al
  282b7b:	00 c0                	add    %al,%al
  282b7d:	00 c0                	add    %al,%al
  282b7f:	00 c0                	add    %al,%al
  282b81:	00 c0                	add    %al,%al
  282b83:	00 c0                	add    %al,%al
  282b85:	00 c0                	add    %al,%al
  282b87:	00 c0                	add    %al,%al
  282b89:	00 c0                	add    %al,%al
	...
  282ba3:	00 7c 3c ff          	add    %bh,-0x1(%esp,%edi,1)
  282ba7:	7e c7                	jle    282b70 <ASCII_Table+0xe48>
  282ba9:	e3 83                	jecxz  282b2e <ASCII_Table+0xe06>
  282bab:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
  282bb2:	83 c1 83             	add    $0xffffff83,%ecx
  282bb5:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
	...
  282bd4:	98                   	cwtl   
  282bd5:	07                   	pop    %es
  282bd6:	f8                   	clc    
  282bd7:	0f 38 1c 18          	pabsb  (%eax),%mm3
  282bdb:	18 18                	sbb    %bl,(%eax)
  282bdd:	18 18                	sbb    %bl,(%eax)
  282bdf:	18 18                	sbb    %bl,(%eax)
  282be1:	18 18                	sbb    %bl,(%eax)
  282be3:	18 18                	sbb    %bl,(%eax)
  282be5:	18 18                	sbb    %bl,(%eax)
  282be7:	18 18                	sbb    %bl,(%eax)
  282be9:	18 18                	sbb    %bl,(%eax)
  282beb:	18 00                	sbb    %al,(%eax)
	...
  282c01:	00 00                	add    %al,(%eax)
  282c03:	00 c0                	add    %al,%al
  282c05:	03 f0                	add    %eax,%esi
  282c07:	0f 30                	wrmsr  
  282c09:	0c 18                	or     $0x18,%al
  282c0b:	18 18                	sbb    %bl,(%eax)
  282c0d:	18 18                	sbb    %bl,(%eax)
  282c0f:	18 18                	sbb    %bl,(%eax)
  282c11:	18 18                	sbb    %bl,(%eax)
  282c13:	18 18                	sbb    %bl,(%eax)
  282c15:	18 30                	sbb    %dh,(%eax)
  282c17:	0c f0                	or     $0xf0,%al
  282c19:	0f c0 03             	xadd   %al,(%ebx)
	...
  282c34:	d8 03                	fadds  (%ebx)
  282c36:	f8                   	clc    
  282c37:	0f 38 0c             	(bad)  
  282c3a:	18 18                	sbb    %bl,(%eax)
  282c3c:	18 18                	sbb    %bl,(%eax)
  282c3e:	18 18                	sbb    %bl,(%eax)
  282c40:	18 18                	sbb    %bl,(%eax)
  282c42:	18 18                	sbb    %bl,(%eax)
  282c44:	18 18                	sbb    %bl,(%eax)
  282c46:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  282c49:	0f d8 03             	psubusb (%ebx),%mm0
  282c4c:	18 00                	sbb    %al,(%eax)
  282c4e:	18 00                	sbb    %al,(%eax)
  282c50:	18 00                	sbb    %al,(%eax)
  282c52:	18 00                	sbb    %al,(%eax)
  282c54:	18 00                	sbb    %al,(%eax)
	...
  282c62:	00 00                	add    %al,(%eax)
  282c64:	c0 1b f0             	rcrb   $0xf0,(%ebx)
  282c67:	1f                   	pop    %ds
  282c68:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282c6b:	18 18                	sbb    %bl,(%eax)
  282c6d:	18 18                	sbb    %bl,(%eax)
  282c6f:	18 18                	sbb    %bl,(%eax)
  282c71:	18 18                	sbb    %bl,(%eax)
  282c73:	18 18                	sbb    %bl,(%eax)
  282c75:	18 30                	sbb    %dh,(%eax)
  282c77:	1c f0                	sbb    $0xf0,%al
  282c79:	1f                   	pop    %ds
  282c7a:	c0 1b 00             	rcrb   $0x0,(%ebx)
  282c7d:	18 00                	sbb    %al,(%eax)
  282c7f:	18 00                	sbb    %al,(%eax)
  282c81:	18 00                	sbb    %al,(%eax)
  282c83:	18 00                	sbb    %al,(%eax)
  282c85:	18 00                	sbb    %al,(%eax)
	...
  282c93:	00 b0 07 f0 03 70    	add    %dh,0x7003f007(%eax)
  282c99:	00 30                	add    %dh,(%eax)
  282c9b:	00 30                	add    %dh,(%eax)
  282c9d:	00 30                	add    %dh,(%eax)
  282c9f:	00 30                	add    %dh,(%eax)
  282ca1:	00 30                	add    %dh,(%eax)
  282ca3:	00 30                	add    %dh,(%eax)
  282ca5:	00 30                	add    %dh,(%eax)
  282ca7:	00 30                	add    %dh,(%eax)
  282ca9:	00 30                	add    %dh,(%eax)
	...
  282cc3:	00 e0                	add    %ah,%al
  282cc5:	03 f0                	add    %eax,%esi
  282cc7:	03 38                	add    (%eax),%edi
  282cc9:	0e                   	push   %cs
  282cca:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  282ccd:	00 f0                	add    %dh,%al
  282ccf:	03 c0                	add    %eax,%eax
  282cd1:	07                   	pop    %es
  282cd2:	00 0c 18             	add    %cl,(%eax,%ebx,1)
  282cd5:	0c 38                	or     $0x38,%al
  282cd7:	0e                   	push   %cs
  282cd8:	f0 07                	lock pop %es
  282cda:	e0 03                	loopne 282cdf <ASCII_Table+0xfb7>
	...
  282cec:	80 00 c0             	addb   $0xc0,(%eax)
  282cef:	00 c0                	add    %al,%al
  282cf1:	00 c0                	add    %al,%al
  282cf3:	00 f0                	add    %dh,%al
  282cf5:	07                   	pop    %es
  282cf6:	f0 07                	lock pop %es
  282cf8:	c0 00 c0             	rolb   $0xc0,(%eax)
  282cfb:	00 c0                	add    %al,%al
  282cfd:	00 c0                	add    %al,%al
  282cff:	00 c0                	add    %al,%al
  282d01:	00 c0                	add    %al,%al
  282d03:	00 c0                	add    %al,%al
  282d05:	00 c0                	add    %al,%al
  282d07:	00 c0                	add    %al,%al
  282d09:	07                   	pop    %es
  282d0a:	80 07 00             	addb   $0x0,(%edi)
	...
  282d21:	00 00                	add    %al,(%eax)
  282d23:	00 18                	add    %bl,(%eax)
  282d25:	18 18                	sbb    %bl,(%eax)
  282d27:	18 18                	sbb    %bl,(%eax)
  282d29:	18 18                	sbb    %bl,(%eax)
  282d2b:	18 18                	sbb    %bl,(%eax)
  282d2d:	18 18                	sbb    %bl,(%eax)
  282d2f:	18 18                	sbb    %bl,(%eax)
  282d31:	18 18                	sbb    %bl,(%eax)
  282d33:	18 18                	sbb    %bl,(%eax)
  282d35:	18 38                	sbb    %bh,(%eax)
  282d37:	1c f0                	sbb    $0xf0,%al
  282d39:	1f                   	pop    %ds
  282d3a:	e0 19                	loopne 282d55 <ASCII_Table+0x102d>
	...
  282d54:	0c 18                	or     $0x18,%al
  282d56:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282d59:	0c 18                	or     $0x18,%al
  282d5b:	0c 30                	or     $0x30,%al
  282d5d:	06                   	push   %es
  282d5e:	30 06                	xor    %al,(%esi)
  282d60:	30 06                	xor    %al,(%esi)
  282d62:	60                   	pusha  
  282d63:	03 60 03             	add    0x3(%eax),%esp
  282d66:	60                   	pusha  
  282d67:	03 c0                	add    %eax,%eax
  282d69:	01 c0                	add    %eax,%eax
  282d6b:	01 00                	add    %eax,(%eax)
	...
  282d81:	00 00                	add    %al,(%eax)
  282d83:	00 c1                	add    %al,%cl
  282d85:	41                   	inc    %ecx
  282d86:	c1 41 c3 61          	roll   $0x61,-0x3d(%ecx)
  282d8a:	63 63 63             	arpl   %sp,0x63(%ebx)
  282d8d:	63 63 63             	arpl   %sp,0x63(%ebx)
  282d90:	36                   	ss
  282d91:	36                   	ss
  282d92:	36                   	ss
  282d93:	36                   	ss
  282d94:	36                   	ss
  282d95:	36                   	ss
  282d96:	1c 1c                	sbb    $0x1c,%al
  282d98:	1c 1c                	sbb    $0x1c,%al
  282d9a:	1c 1c                	sbb    $0x1c,%al
	...
  282db4:	1c 38                	sbb    $0x38,%al
  282db6:	38 1c 30             	cmp    %bl,(%eax,%esi,1)
  282db9:	0c 60                	or     $0x60,%al
  282dbb:	06                   	push   %es
  282dbc:	60                   	pusha  
  282dbd:	03 60 03             	add    0x3(%eax),%esp
  282dc0:	60                   	pusha  
  282dc1:	03 60 03             	add    0x3(%eax),%esp
  282dc4:	60                   	pusha  
  282dc5:	06                   	push   %es
  282dc6:	30 0c 38             	xor    %cl,(%eax,%edi,1)
  282dc9:	1c 1c                	sbb    $0x1c,%al
  282dcb:	38 00                	cmp    %al,(%eax)
	...
  282de1:	00 00                	add    %al,(%eax)
  282de3:	00 18                	add    %bl,(%eax)
  282de5:	30 30                	xor    %dh,(%eax)
  282de7:	18 30                	sbb    %dh,(%eax)
  282de9:	18 70 18             	sbb    %dh,0x18(%eax)
  282dec:	60                   	pusha  
  282ded:	0c 60                	or     $0x60,%al
  282def:	0c e0                	or     $0xe0,%al
  282df1:	0c c0                	or     $0xc0,%al
  282df3:	06                   	push   %es
  282df4:	c0 06 80             	rolb   $0x80,(%esi)
  282df7:	03 80 03 80 03 80    	add    -0x7ffc7ffd(%eax),%eax
  282dfd:	01 80 01 c0 01 f0    	add    %eax,-0xffe3fff(%eax)
  282e03:	00 70 00             	add    %dh,0x0(%eax)
	...
  282e12:	00 00                	add    %al,(%eax)
  282e14:	fc                   	cld    
  282e15:	1f                   	pop    %ds
  282e16:	fc                   	cld    
  282e17:	1f                   	pop    %ds
  282e18:	00 0c 00             	add    %cl,(%eax,%eax,1)
  282e1b:	06                   	push   %es
  282e1c:	00 03                	add    %al,(%ebx)
  282e1e:	80 01 c0             	addb   $0xc0,(%ecx)
  282e21:	00 60 00             	add    %ah,0x0(%eax)
  282e24:	30 00                	xor    %al,(%eax)
  282e26:	18 00                	sbb    %al,(%eax)
  282e28:	fc                   	cld    
  282e29:	1f                   	pop    %ds
  282e2a:	fc                   	cld    
  282e2b:	1f                   	pop    %ds
	...
  282e38:	00 00                	add    %al,(%eax)
  282e3a:	00 03                	add    %al,(%ebx)
  282e3c:	80 01 c0             	addb   $0xc0,(%ecx)
  282e3f:	00 c0                	add    %al,%al
  282e41:	00 c0                	add    %al,%al
  282e43:	00 c0                	add    %al,%al
  282e45:	00 c0                	add    %al,%al
  282e47:	00 c0                	add    %al,%al
  282e49:	00 60 00             	add    %ah,0x0(%eax)
  282e4c:	60                   	pusha  
  282e4d:	00 30                	add    %dh,(%eax)
  282e4f:	00 60 00             	add    %ah,0x0(%eax)
  282e52:	40                   	inc    %eax
  282e53:	00 c0                	add    %al,%al
  282e55:	00 c0                	add    %al,%al
  282e57:	00 c0                	add    %al,%al
  282e59:	00 c0                	add    %al,%al
  282e5b:	00 c0                	add    %al,%al
  282e5d:	00 c0                	add    %al,%al
  282e5f:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  282e65:	00 00                	add    %al,(%eax)
  282e67:	00 00                	add    %al,(%eax)
  282e69:	00 80 01 80 01 80    	add    %al,-0x7ffe7fff(%eax)
  282e6f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e75:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e7b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e81:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e87:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e8d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282e93:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
  282e99:	00 60 00             	add    %ah,0x0(%eax)
  282e9c:	c0 00 c0             	rolb   $0xc0,(%eax)
  282e9f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282ea5:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  282eab:	03 00                	add    (%eax),%eax
  282ead:	03 00                	add    (%eax),%eax
  282eaf:	06                   	push   %es
  282eb0:	00 03                	add    %al,(%ebx)
  282eb2:	00 01                	add    %al,(%ecx)
  282eb4:	80 01 80             	addb   $0x80,(%ecx)
  282eb7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282ebd:	01 80 01 c0 00 60    	add    %eax,0x6000c001(%eax)
	...
  282ed7:	00 f0                	add    %dh,%al
  282ed9:	10 f8                	adc    %bh,%al
  282edb:	1f                   	pop    %ds
  282edc:	08 0f                	or     %cl,(%edi)
	...
  282efa:	00 ff                	add    %bh,%bh
  282efc:	00 00                	add    %al,(%eax)
  282efe:	00 ff                	add    %bh,%bh
  282f00:	00 ff                	add    %bh,%bh
  282f02:	ff 00                	incl   (%eax)
  282f04:	00 00                	add    %al,(%eax)
  282f06:	ff                   	(bad)  
  282f07:	ff 00                	incl   (%eax)
  282f09:	ff 00                	incl   (%eax)
  282f0b:	ff                   	(bad)  
  282f0c:	ff                   	(bad)  
  282f0d:	ff                   	(bad)  
  282f0e:	ff                   	(bad)  
  282f0f:	ff c6                	inc    %esi
  282f11:	c6 c6 84             	mov    $0x84,%dh
  282f14:	00 00                	add    %al,(%eax)
  282f16:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
  282f1d:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
  282f24:	84 84 84 84 2a 2a 2a 	test   %al,0x2a2a2a84(%esp,%eax,4)

00282f28 <cursor.1418>:
  282f28:	2a 2a                	sub    (%edx),%ch
  282f2a:	2a 2a                	sub    (%edx),%ch
  282f2c:	2a 2a                	sub    (%edx),%ch
  282f2e:	2a 2a                	sub    (%edx),%ch
  282f30:	2a 2a                	sub    (%edx),%ch
  282f32:	2a 2a                	sub    (%edx),%ch
  282f34:	2a 2a                	sub    (%edx),%ch
  282f36:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282f3b:	4f                   	dec    %edi
  282f3c:	4f                   	dec    %edi
  282f3d:	4f                   	dec    %edi
  282f3e:	4f                   	dec    %edi
  282f3f:	4f                   	dec    %edi
  282f40:	4f                   	dec    %edi
  282f41:	4f                   	dec    %edi
  282f42:	4f                   	dec    %edi
  282f43:	4f                   	dec    %edi
  282f44:	2a 2e                	sub    (%esi),%ch
  282f46:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282f4b:	4f                   	dec    %edi
  282f4c:	4f                   	dec    %edi
  282f4d:	4f                   	dec    %edi
  282f4e:	4f                   	dec    %edi
  282f4f:	4f                   	dec    %edi
  282f50:	4f                   	dec    %edi
  282f51:	4f                   	dec    %edi
  282f52:	4f                   	dec    %edi
  282f53:	2a 2e                	sub    (%esi),%ch
  282f55:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282f5b:	4f                   	dec    %edi
  282f5c:	4f                   	dec    %edi
  282f5d:	4f                   	dec    %edi
  282f5e:	4f                   	dec    %edi
  282f5f:	4f                   	dec    %edi
  282f60:	4f                   	dec    %edi
  282f61:	4f                   	dec    %edi
  282f62:	2a 2e                	sub    (%esi),%ch
  282f64:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282f6b:	4f                   	dec    %edi
  282f6c:	4f                   	dec    %edi
  282f6d:	4f                   	dec    %edi
  282f6e:	4f                   	dec    %edi
  282f6f:	4f                   	dec    %edi
  282f70:	4f                   	dec    %edi
  282f71:	2a 2e                	sub    (%esi),%ch
  282f73:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282f7a:	4f 
  282f7b:	4f                   	dec    %edi
  282f7c:	4f                   	dec    %edi
  282f7d:	4f                   	dec    %edi
  282f7e:	4f                   	dec    %edi
  282f7f:	4f                   	dec    %edi
  282f80:	2a 2e                	sub    (%esi),%ch
  282f82:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282f89:	4f 4f 
  282f8b:	4f                   	dec    %edi
  282f8c:	4f                   	dec    %edi
  282f8d:	4f                   	dec    %edi
  282f8e:	4f                   	dec    %edi
  282f8f:	4f                   	dec    %edi
  282f90:	2a 2e                	sub    (%esi),%ch
  282f92:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282f99:	4f 4f 
  282f9b:	4f                   	dec    %edi
  282f9c:	4f                   	dec    %edi
  282f9d:	4f                   	dec    %edi
  282f9e:	4f                   	dec    %edi
  282f9f:	4f                   	dec    %edi
  282fa0:	4f                   	dec    %edi
  282fa1:	2a 2e                	sub    (%esi),%ch
  282fa3:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282faa:	4f 
  282fab:	4f                   	dec    %edi
  282fac:	4f                   	dec    %edi
  282fad:	2a 2a                	sub    (%edx),%ch
  282faf:	4f                   	dec    %edi
  282fb0:	4f                   	dec    %edi
  282fb1:	4f                   	dec    %edi
  282fb2:	2a 2e                	sub    (%esi),%ch
  282fb4:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282fbb:	4f                   	dec    %edi
  282fbc:	2a 2e                	sub    (%esi),%ch
  282fbe:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  282fc2:	4f                   	dec    %edi
  282fc3:	2a 2e                	sub    (%esi),%ch
  282fc5:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282fcb:	2a 2e                	sub    (%esi),%ch
  282fcd:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282fd3:	4f                   	dec    %edi
  282fd4:	2a 2e                	sub    (%esi),%ch
  282fd6:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  282fdb:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282fe2:	4f 4f 
  282fe4:	4f                   	dec    %edi
  282fe5:	2a 2e                	sub    (%esi),%ch
  282fe7:	2e 2a 2a             	sub    %cs:(%edx),%ch
  282fea:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282ff1:	2e 2a 4f 4f 
  282ff5:	4f                   	dec    %edi
  282ff6:	2a 2e                	sub    (%esi),%ch
  282ff8:	2a 2e                	sub    (%esi),%ch
  282ffa:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  283001:	2e 2e 2a 4f 4f 
  283006:	4f                   	dec    %edi
  283007:	2a 2e                	sub    (%esi),%ch
  283009:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  283010:	2e 2e 2e 2e 2a 4f 4f 
  283017:	2a 2e                	sub    (%esi),%ch
  283019:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  283020:	2e 2e 2e 2e 2e 2a 2a 
  283027:	2a                   	.byte 0x2a

Disassembly of section .rodata.str1.1:

00283028 <.rodata.str1.1>:
  283028:	6d                   	insl   (%dx),%es:(%edi)
  283029:	65                   	gs
  28302a:	6d                   	insl   (%dx),%es:(%edi)
  28302b:	6f                   	outsl  %ds:(%esi),(%dx)
  28302c:	72 79                	jb     2830a7 <cursor.1418+0x17f>
  28302e:	3a 25 64 4d 42 2c    	cmp    0x2c424d64,%ah
  283034:	66                   	data16
  283035:	72 65                	jb     28309c <cursor.1418+0x174>
  283037:	65 3a 25 64 4d 42 2c 	cmp    %gs:0x2c424d64,%ah
  28303e:	25 64 00 5b 6c       	and    $0x6c5b0064,%eax
  283043:	6d                   	insl   (%dx),%es:(%edi)
  283044:	72 3a                	jb     283080 <cursor.1418+0x158>
  283046:	25 64 20 25 64       	and    $0x64252064,%eax
  28304b:	5d                   	pop    %ebp
  28304c:	00 28                	add    %ch,(%eax)
  28304e:	25 64 2c 20 25       	and    $0x25202c64,%eax
  283053:	64 29 00             	sub    %eax,%fs:(%eax)
  283056:	44                   	inc    %esp
  283057:	65 62 75 67          	bound  %esi,%gs:0x67(%ebp)
  28305b:	3a 76 61             	cmp    0x61(%esi),%dh
  28305e:	72 3d                	jb     28309d <cursor.1418+0x175>
  283060:	25                   	.byte 0x25
  283061:	78 00                	js     283063 <cursor.1418+0x13b>

Disassembly of section .eh_frame:

00283064 <.eh_frame>:
  283064:	14 00                	adc    $0x0,%al
  283066:	00 00                	add    %al,(%eax)
  283068:	00 00                	add    %al,(%eax)
  28306a:	00 00                	add    %al,(%eax)
  28306c:	01 7a 52             	add    %edi,0x52(%edx)
  28306f:	00 01                	add    %al,(%ecx)
  283071:	7c 08                	jl     28307b <cursor.1418+0x153>
  283073:	01 1b                	add    %ebx,(%ebx)
  283075:	0c 04                	or     $0x4,%al
  283077:	04 88                	add    $0x88,%al
  283079:	01 00                	add    %eax,(%eax)
  28307b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28307e:	00 00                	add    %al,(%eax)
  283080:	1c 00                	sbb    $0x0,%al
  283082:	00 00                	add    %al,(%eax)
  283084:	7c cf                	jl     283055 <cursor.1418+0x12d>
  283086:	ff                   	(bad)  
  283087:	ff 10                	call   *(%eax)
  283089:	04 00                	add    $0x0,%al
  28308b:	00 00                	add    %al,(%eax)
  28308d:	41                   	inc    %ecx
  28308e:	0e                   	push   %cs
  28308f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283095:	49                   	dec    %ecx
  283096:	87 03                	xchg   %eax,(%ebx)
  283098:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28309b:	05 1c 00 00 00       	add    $0x1c,%eax
  2830a0:	3c 00                	cmp    $0x0,%al
  2830a2:	00 00                	add    %al,(%eax)
  2830a4:	6c                   	insb   (%dx),%es:(%edi)
  2830a5:	d3 ff                	sar    %cl,%edi
  2830a7:	ff 17                	call   *(%edi)
  2830a9:	00 00                	add    %al,(%eax)
  2830ab:	00 00                	add    %al,(%eax)
  2830ad:	41                   	inc    %ecx
  2830ae:	0e                   	push   %cs
  2830af:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2830b5:	4e                   	dec    %esi
  2830b6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2830b9:	04 00                	add    $0x0,%al
  2830bb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2830be:	00 00                	add    %al,(%eax)
  2830c0:	5c                   	pop    %esp
  2830c1:	00 00                	add    %al,(%eax)
  2830c3:	00 63 d3             	add    %ah,-0x2d(%ebx)
  2830c6:	ff                   	(bad)  
  2830c7:	ff 14 00             	call   *(%eax,%eax,1)
  2830ca:	00 00                	add    %al,(%eax)
  2830cc:	00 41 0e             	add    %al,0xe(%ecx)
  2830cf:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2830d5:	4b                   	dec    %ebx
  2830d6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2830d9:	04 00                	add    $0x0,%al
  2830db:	00 24 00             	add    %ah,(%eax,%eax,1)
  2830de:	00 00                	add    %al,(%eax)
  2830e0:	7c 00                	jl     2830e2 <cursor.1418+0x1ba>
  2830e2:	00 00                	add    %al,(%eax)
  2830e4:	57                   	push   %edi
  2830e5:	d3 ff                	sar    %cl,%edi
  2830e7:	ff                   	(bad)  
  2830e8:	3e 00 00             	add    %al,%ds:(%eax)
  2830eb:	00 00                	add    %al,(%eax)
  2830ed:	41                   	inc    %ecx
  2830ee:	0e                   	push   %cs
  2830ef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2830f5:	45                   	inc    %ebp
  2830f6:	86 03                	xchg   %al,(%ebx)
  2830f8:	83 04 73 c3          	addl   $0xffffffc3,(%ebx,%esi,2)
  2830fc:	41                   	inc    %ecx
  2830fd:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  283101:	04 04                	add    $0x4,%al
  283103:	00 24 00             	add    %ah,(%eax,%eax,1)
  283106:	00 00                	add    %al,(%eax)
  283108:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  283109:	00 00                	add    %al,(%eax)
  28310b:	00 6d d3             	add    %ch,-0x2d(%ebp)
  28310e:	ff                   	(bad)  
  28310f:	ff 31                	pushl  (%ecx)
  283111:	00 00                	add    %al,(%eax)
  283113:	00 00                	add    %al,(%eax)
  283115:	41                   	inc    %ecx
  283116:	0e                   	push   %cs
  283117:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  28311d:	42                   	inc    %edx
  28311e:	87 03                	xchg   %eax,(%ebx)
  283120:	86 04 64             	xchg   %al,(%esp,%eiz,2)
  283123:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283127:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28312a:	04 00                	add    $0x0,%al
  28312c:	20 00                	and    %al,(%eax)
  28312e:	00 00                	add    %al,(%eax)
  283130:	cc                   	int3   
  283131:	00 00                	add    %al,(%eax)
  283133:	00 76 d3             	add    %dh,-0x2d(%esi)
  283136:	ff                   	(bad)  
  283137:	ff 2f                	ljmp   *(%edi)
  283139:	00 00                	add    %al,(%eax)
  28313b:	00 00                	add    %al,(%eax)
  28313d:	41                   	inc    %ecx
  28313e:	0e                   	push   %cs
  28313f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283145:	47                   	inc    %edi
  283146:	83 03 63             	addl   $0x63,(%ebx)
  283149:	c3                   	ret    
  28314a:	41                   	inc    %ecx
  28314b:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28314e:	04 00                	add    $0x0,%al
  283150:	1c 00                	sbb    $0x0,%al
  283152:	00 00                	add    %al,(%eax)
  283154:	f0 00 00             	lock add %al,(%eax)
  283157:	00 81 d3 ff ff 28    	add    %al,0x28ffffd3(%ecx)
  28315d:	00 00                	add    %al,(%eax)
  28315f:	00 00                	add    %al,(%eax)
  283161:	41                   	inc    %ecx
  283162:	0e                   	push   %cs
  283163:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283169:	64 c5 0c 04          	lds    %fs:(%esp,%eax,1),%ecx
  28316d:	04 00                	add    $0x0,%al
  28316f:	00 20                	add    %ah,(%eax)
  283171:	00 00                	add    %al,(%eax)
  283173:	00 10                	add    %dl,(%eax)
  283175:	01 00                	add    %eax,(%eax)
  283177:	00 89 d3 ff ff bc    	add    %cl,-0x4300002d(%ecx)
  28317d:	01 00                	add    %eax,(%eax)
  28317f:	00 00                	add    %al,(%eax)
  283181:	41                   	inc    %ecx
  283182:	0e                   	push   %cs
  283183:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283189:	41                   	inc    %ecx
  28318a:	83 03 03             	addl   $0x3,(%ebx)
  28318d:	b7 01                	mov    $0x1,%bh
  28318f:	c5 c3 0c             	(bad)  
  283192:	04 04                	add    $0x4,%al
  283194:	1c 00                	sbb    $0x0,%al
  283196:	00 00                	add    %al,(%eax)
  283198:	34 01                	xor    $0x1,%al
  28319a:	00 00                	add    %al,(%eax)
  28319c:	21 d5                	and    %edx,%ebp
  28319e:	ff                   	(bad)  
  28319f:	ff 61 01             	jmp    *0x1(%ecx)
  2831a2:	00 00                	add    %al,(%eax)
  2831a4:	00 41 0e             	add    %al,0xe(%ecx)
  2831a7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2831ad:	03 5d 01             	add    0x1(%ebp),%ebx
  2831b0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2831b3:	04 1c                	add    $0x1c,%al
  2831b5:	00 00                	add    %al,(%eax)
  2831b7:	00 54 01 00          	add    %dl,0x0(%ecx,%eax,1)
  2831bb:	00 62 d6             	add    %ah,-0x2a(%edx)
  2831be:	ff                   	(bad)  
  2831bf:	ff 1f                	lcall  *(%edi)
  2831c1:	00 00                	add    %al,(%eax)
  2831c3:	00 00                	add    %al,(%eax)
  2831c5:	41                   	inc    %ecx
  2831c6:	0e                   	push   %cs
  2831c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2831cd:	5b                   	pop    %ebx
  2831ce:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2831d1:	04 00                	add    $0x0,%al
  2831d3:	00 24 00             	add    %ah,(%eax,%eax,1)
  2831d6:	00 00                	add    %al,(%eax)
  2831d8:	74 01                	je     2831db <cursor.1418+0x2b3>
  2831da:	00 00                	add    %al,(%eax)
  2831dc:	61                   	popa   
  2831dd:	d6                   	(bad)  
  2831de:	ff                   	(bad)  
  2831df:	ff 50 00             	call   *0x0(%eax)
  2831e2:	00 00                	add    %al,(%eax)
  2831e4:	00 41 0e             	add    %al,0xe(%ecx)
  2831e7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2831ed:	48                   	dec    %eax
  2831ee:	86 03                	xchg   %al,(%ebx)
  2831f0:	83 04 02 40          	addl   $0x40,(%edx,%eax,1)
  2831f4:	c3                   	ret    
  2831f5:	41                   	inc    %ecx
  2831f6:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  2831fa:	04 04                	add    $0x4,%al
  2831fc:	24 00                	and    $0x0,%al
  2831fe:	00 00                	add    %al,(%eax)
  283200:	9c                   	pushf  
  283201:	01 00                	add    %eax,(%eax)
  283203:	00 89 d6 ff ff 39    	add    %cl,0x39ffffd6(%ecx)
  283209:	00 00                	add    %al,(%eax)
  28320b:	00 00                	add    %al,(%eax)
  28320d:	41                   	inc    %ecx
  28320e:	0e                   	push   %cs
  28320f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283215:	44                   	inc    %esp
  283216:	86 03                	xchg   %al,(%ebx)
  283218:	43                   	inc    %ebx
  283219:	83 04 6c c3          	addl   $0xffffffc3,(%esp,%ebp,2)
  28321d:	41                   	inc    %ecx
  28321e:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  283222:	04 04                	add    $0x4,%al
  283224:	28 00                	sub    %al,(%eax)
  283226:	00 00                	add    %al,(%eax)
  283228:	c4 01                	les    (%ecx),%eax
  28322a:	00 00                	add    %al,(%eax)
  28322c:	9a d6 ff ff 62 00 00 	lcall  $0x0,$0x62ffffd6
  283233:	00 00                	add    %al,(%eax)
  283235:	41                   	inc    %ecx
  283236:	0e                   	push   %cs
  283237:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  28323d:	4b                   	dec    %ebx
  28323e:	87 03                	xchg   %eax,(%ebx)
  283240:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283243:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  283248:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28324c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28324f:	04 28                	add    $0x28,%al
  283251:	00 00                	add    %al,(%eax)
  283253:	00 f0                	add    %dh,%al
  283255:	01 00                	add    %eax,(%eax)
  283257:	00 d0                	add    %dl,%al
  283259:	d6                   	(bad)  
  28325a:	ff                   	(bad)  
  28325b:	ff 62 00             	jmp    *0x0(%edx)
  28325e:	00 00                	add    %al,(%eax)
  283260:	00 41 0e             	add    %al,0xe(%ecx)
  283263:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283269:	4b                   	dec    %ebx
  28326a:	87 03                	xchg   %eax,(%ebx)
  28326c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28326f:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  283274:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283278:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28327b:	04 28                	add    $0x28,%al
  28327d:	00 00                	add    %al,(%eax)
  28327f:	00 1c 02             	add    %bl,(%edx,%eax,1)
  283282:	00 00                	add    %al,(%eax)
  283284:	06                   	push   %es
  283285:	d7                   	xlat   %ds:(%ebx)
  283286:	ff                   	(bad)  
  283287:	ff aa 00 00 00 00    	ljmp   *0x0(%edx)
  28328d:	41                   	inc    %ecx
  28328e:	0e                   	push   %cs
  28328f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283295:	46                   	inc    %esi
  283296:	87 03                	xchg   %eax,(%ebx)
  283298:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28329b:	05 02 9d c3 41       	add    $0x41c39d02,%eax
  2832a0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2832a4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2832a7:	04 28                	add    $0x28,%al
  2832a9:	00 00                	add    %al,(%eax)
  2832ab:	00 48 02             	add    %cl,0x2(%eax)
  2832ae:	00 00                	add    %al,(%eax)
  2832b0:	84 d7                	test   %dl,%bh
  2832b2:	ff                   	(bad)  
  2832b3:	ff 51 00             	call   *0x0(%ecx)
  2832b6:	00 00                	add    %al,(%eax)
  2832b8:	00 41 0e             	add    %al,0xe(%ecx)
  2832bb:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2832c1:	41                   	inc    %ecx
  2832c2:	87 03                	xchg   %eax,(%ebx)
  2832c4:	4a                   	dec    %edx
  2832c5:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2832c8:	05 7d c3 41 c6       	add    $0xc641c37d,%eax
  2832cd:	41                   	inc    %ecx
  2832ce:	c7 41 c5 0c 04 04 2c 	movl   $0x2c04040c,-0x3b(%ecx)
  2832d5:	00 00                	add    %al,(%eax)
  2832d7:	00 74 02 00          	add    %dh,0x0(%edx,%eax,1)
  2832db:	00 a9 d7 ff ff 64    	add    %ch,0x64ffffd7(%ecx)
  2832e1:	00 00                	add    %al,(%eax)
  2832e3:	00 00                	add    %al,(%eax)
  2832e5:	41                   	inc    %ecx
  2832e6:	0e                   	push   %cs
  2832e7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2832ed:	41                   	inc    %ecx
  2832ee:	87 03                	xchg   %eax,(%ebx)
  2832f0:	44                   	inc    %esp
  2832f1:	86 04 45 83 05 02 53 	xchg   %al,0x53020583(,%eax,2)
  2832f8:	c3                   	ret    
  2832f9:	41                   	inc    %ecx
  2832fa:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2832fe:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283301:	04 00                	add    $0x0,%al
  283303:	00 20                	add    %ah,(%eax)
  283305:	00 00                	add    %al,(%eax)
  283307:	00 a4 02 00 00 dd d7 	add    %ah,-0x28230000(%edx,%eax,1)
  28330e:	ff                   	(bad)  
  28330f:	ff                   	(bad)  
  283310:	3a 00                	cmp    (%eax),%al
  283312:	00 00                	add    %al,(%eax)
  283314:	00 41 0e             	add    %al,0xe(%ecx)
  283317:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28331d:	44                   	inc    %esp
  28331e:	83 03 72             	addl   $0x72,(%ebx)
  283321:	c5 c3 0c             	(bad)  
  283324:	04 04                	add    $0x4,%al
  283326:	00 00                	add    %al,(%eax)
  283328:	28 00                	sub    %al,(%eax)
  28332a:	00 00                	add    %al,(%eax)
  28332c:	c8 02 00 00          	enter  $0x2,$0x0
  283330:	f3 d7                	repz xlat %ds:(%ebx)
  283332:	ff                   	(bad)  
  283333:	ff 50 00             	call   *0x0(%eax)
  283336:	00 00                	add    %al,(%eax)
  283338:	00 41 0e             	add    %al,0xe(%ecx)
  28333b:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283341:	44                   	inc    %esp
  283342:	87 03                	xchg   %eax,(%ebx)
  283344:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283347:	05 02 43 c3 41       	add    $0x41c34302,%eax
  28334c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283350:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283353:	04 2c                	add    $0x2c,%al
  283355:	00 00                	add    %al,(%eax)
  283357:	00 f4                	add    %dh,%ah
  283359:	02 00                	add    (%eax),%al
  28335b:	00 17                	add    %dl,(%edi)
  28335d:	d8 ff                	fdivr  %st(7),%st
  28335f:	ff 4f 00             	decl   0x0(%edi)
  283362:	00 00                	add    %al,(%eax)
  283364:	00 41 0e             	add    %al,0xe(%ecx)
  283367:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28336d:	41                   	inc    %ecx
  28336e:	87 03                	xchg   %eax,(%ebx)
  283370:	44                   	inc    %esp
  283371:	86 04 44             	xchg   %al,(%esp,%eax,2)
  283374:	83 05 7f c3 41 c6 41 	addl   $0x41,0xc641c37f
  28337b:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  283382:	00 00                	add    %al,(%eax)
  283384:	2c 00                	sub    $0x0,%al
  283386:	00 00                	add    %al,(%eax)
  283388:	24 03                	and    $0x3,%al
  28338a:	00 00                	add    %al,(%eax)
  28338c:	36                   	ss
  28338d:	d8 ff                	fdivr  %st(7),%st
  28338f:	ff 54 00 00          	call   *0x0(%eax,%eax,1)
  283393:	00 00                	add    %al,(%eax)
  283395:	41                   	inc    %ecx
  283396:	0e                   	push   %cs
  283397:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28339d:	48                   	dec    %eax
  28339e:	87 03                	xchg   %eax,(%ebx)
  2833a0:	86 04 44             	xchg   %al,(%esp,%eax,2)
  2833a3:	83 05 02 41 c3 41 c6 	addl   $0xffffffc6,0x41c34102
  2833aa:	41                   	inc    %ecx
  2833ab:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  2833b2:	00 00                	add    %al,(%eax)
  2833b4:	1c 00                	sbb    $0x0,%al
  2833b6:	00 00                	add    %al,(%eax)
  2833b8:	54                   	push   %esp
  2833b9:	03 00                	add    (%eax),%eax
  2833bb:	00 5a d8             	add    %bl,-0x28(%edx)
  2833be:	ff                   	(bad)  
  2833bf:	ff 2a                	ljmp   *(%edx)
  2833c1:	00 00                	add    %al,(%eax)
  2833c3:	00 00                	add    %al,(%eax)
  2833c5:	41                   	inc    %ecx
  2833c6:	0e                   	push   %cs
  2833c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2833cd:	66 c5 0c 04          	lds    (%esp,%eax,1),%cx
  2833d1:	04 00                	add    $0x0,%al
  2833d3:	00 20                	add    %ah,(%eax)
  2833d5:	00 00                	add    %al,(%eax)
  2833d7:	00 74 03 00          	add    %dh,0x0(%ebx,%eax,1)
  2833db:	00 64 d8 ff          	add    %ah,-0x1(%eax,%ebx,8)
  2833df:	ff 60 01             	jmp    *0x1(%eax)
  2833e2:	00 00                	add    %al,(%eax)
  2833e4:	00 41 0e             	add    %al,0xe(%ecx)
  2833e7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2833ed:	41                   	inc    %ecx
  2833ee:	83 03 03             	addl   $0x3,(%ebx)
  2833f1:	5b                   	pop    %ebx
  2833f2:	01 c5                	add    %eax,%ebp
  2833f4:	c3                   	ret    
  2833f5:	0c 04                	or     $0x4,%al
  2833f7:	04 1c                	add    $0x1c,%al
  2833f9:	00 00                	add    %al,(%eax)
  2833fb:	00 98 03 00 00 a0    	add    %bl,-0x5ffffffd(%eax)
  283401:	d9 ff                	fcos   
  283403:	ff                   	(bad)  
  283404:	3a 00                	cmp    (%eax),%al
  283406:	00 00                	add    %al,(%eax)
  283408:	00 41 0e             	add    %al,0xe(%ecx)
  28340b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283411:	71 c5                	jno    2833d8 <cursor.1418+0x4b0>
  283413:	0c 04                	or     $0x4,%al
  283415:	04 00                	add    $0x0,%al
  283417:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28341a:	00 00                	add    %al,(%eax)
  28341c:	b8 03 00 00 ba       	mov    $0xba000003,%eax
  283421:	d9 ff                	fcos   
  283423:	ff 24 00             	jmp    *(%eax,%eax,1)
  283426:	00 00                	add    %al,(%eax)
  283428:	00 41 0e             	add    %al,0xe(%ecx)
  28342b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283431:	5b                   	pop    %ebx
  283432:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283435:	04 00                	add    $0x0,%al
  283437:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28343a:	00 00                	add    %al,(%eax)
  28343c:	d8 03                	fadds  (%ebx)
  28343e:	00 00                	add    %al,(%eax)
  283440:	be d9 ff ff 29       	mov    $0x29ffffd9,%esi
  283445:	00 00                	add    %al,(%eax)
  283447:	00 00                	add    %al,(%eax)
  283449:	41                   	inc    %ecx
  28344a:	0e                   	push   %cs
  28344b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283451:	60                   	pusha  
  283452:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283455:	04 00                	add    $0x0,%al
  283457:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28345a:	00 00                	add    %al,(%eax)
  28345c:	f8                   	clc    
  28345d:	03 00                	add    (%eax),%eax
  28345f:	00 c7                	add    %al,%bh
  283461:	d9 ff                	fcos   
  283463:	ff 0f                	decl   (%edi)
  283465:	00 00                	add    %al,(%eax)
  283467:	00 00                	add    %al,(%eax)
  283469:	41                   	inc    %ecx
  28346a:	0e                   	push   %cs
  28346b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  283471:	46                   	inc    %esi
  283472:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283475:	04 00                	add    $0x0,%al
  283477:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28347a:	00 00                	add    %al,(%eax)
  28347c:	18 04 00             	sbb    %al,(%eax,%eax,1)
  28347f:	00 b6 d9 ff ff 1f    	add    %dh,0x1fffffd9(%esi)
  283485:	00 00                	add    %al,(%eax)
  283487:	00 00                	add    %al,(%eax)
  283489:	41                   	inc    %ecx
  28348a:	0e                   	push   %cs
  28348b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283491:	5b                   	pop    %ebx
  283492:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283495:	04 00                	add    $0x0,%al
  283497:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28349a:	00 00                	add    %al,(%eax)
  28349c:	38 04 00             	cmp    %al,(%eax,%eax,1)
  28349f:	00 0b                	add    %cl,(%ebx)
  2834a1:	da ff                	(bad)  
  2834a3:	ff 2b                	ljmp   *(%ebx)
  2834a5:	00 00                	add    %al,(%eax)
  2834a7:	00 00                	add    %al,(%eax)
  2834a9:	41                   	inc    %ecx
  2834aa:	0e                   	push   %cs
  2834ab:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2834b1:	67 c5 0c             	lds    (%si),%ecx
  2834b4:	04 04                	add    $0x4,%al
  2834b6:	00 00                	add    %al,(%eax)
  2834b8:	20 00                	and    %al,(%eax)
  2834ba:	00 00                	add    %al,(%eax)
  2834bc:	58                   	pop    %eax
  2834bd:	04 00                	add    $0x0,%al
  2834bf:	00 16                	add    %dl,(%esi)
  2834c1:	da ff                	(bad)  
  2834c3:	ff                   	(bad)  
  2834c4:	3e 00 00             	add    %al,%ds:(%eax)
  2834c7:	00 00                	add    %al,(%eax)
  2834c9:	41                   	inc    %ecx
  2834ca:	0e                   	push   %cs
  2834cb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2834d1:	44                   	inc    %esp
  2834d2:	83 03 75             	addl   $0x75,(%ebx)
  2834d5:	c3                   	ret    
  2834d6:	41                   	inc    %ecx
  2834d7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2834da:	04 00                	add    $0x0,%al
  2834dc:	28 00                	sub    %al,(%eax)
  2834de:	00 00                	add    %al,(%eax)
  2834e0:	7c 04                	jl     2834e6 <cursor.1418+0x5be>
  2834e2:	00 00                	add    %al,(%eax)
  2834e4:	30 da                	xor    %bl,%dl
  2834e6:	ff                   	(bad)  
  2834e7:	ff 35 00 00 00 00    	pushl  0x0
  2834ed:	41                   	inc    %ecx
  2834ee:	0e                   	push   %cs
  2834ef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2834f5:	46                   	inc    %esi
  2834f6:	87 03                	xchg   %eax,(%ebx)
  2834f8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2834fb:	05 68 c3 41 c6       	add    $0xc641c368,%eax
  283500:	41                   	inc    %ecx
  283501:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  283508:	1c 00                	sbb    $0x0,%al
  28350a:	00 00                	add    %al,(%eax)
  28350c:	a8 04                	test   $0x4,%al
  28350e:	00 00                	add    %al,(%eax)
  283510:	39 da                	cmp    %ebx,%edx
  283512:	ff                   	(bad)  
  283513:	ff 0e                	decl   (%esi)
  283515:	00 00                	add    %al,(%eax)
  283517:	00 00                	add    %al,(%eax)
  283519:	41                   	inc    %ecx
  28351a:	0e                   	push   %cs
  28351b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283521:	44                   	inc    %esp
  283522:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283525:	04 00                	add    $0x0,%al
  283527:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28352a:	00 00                	add    %al,(%eax)
  28352c:	c8 04 00 00          	enter  $0x4,$0x0
  283530:	27                   	daa    
  283531:	da ff                	(bad)  
  283533:	ff 29                	ljmp   *(%ecx)
  283535:	00 00                	add    %al,(%eax)
  283537:	00 00                	add    %al,(%eax)
  283539:	41                   	inc    %ecx
  28353a:	0e                   	push   %cs
  28353b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283541:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
  283545:	04 00                	add    $0x0,%al
  283547:	00 20                	add    %ah,(%eax)
  283549:	00 00                	add    %al,(%eax)
  28354b:	00 e8                	add    %ch,%al
  28354d:	04 00                	add    $0x0,%al
  28354f:	00 30                	add    %dh,(%eax)
  283551:	da ff                	(bad)  
  283553:	ff 8e 00 00 00 00    	decl   0x0(%esi)
  283559:	41                   	inc    %ecx
  28355a:	0e                   	push   %cs
  28355b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283561:	44                   	inc    %esp
  283562:	83 03 02             	addl   $0x2,(%ebx)
  283565:	85 c3                	test   %eax,%ebx
  283567:	41                   	inc    %ecx
  283568:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28356b:	04 20                	add    $0x20,%al
  28356d:	00 00                	add    %al,(%eax)
  28356f:	00 0c 05 00 00 9a da 	add    %cl,-0x25660000(,%eax,1)
  283576:	ff                   	(bad)  
  283577:	ff                   	(bad)  
  283578:	3a 00                	cmp    (%eax),%al
  28357a:	00 00                	add    %al,(%eax)
  28357c:	00 41 0e             	add    %al,0xe(%ecx)
  28357f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283585:	44                   	inc    %esp
  283586:	83 03 71             	addl   $0x71,(%ebx)
  283589:	c3                   	ret    
  28358a:	41                   	inc    %ecx
  28358b:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28358e:	04 00                	add    $0x0,%al
  283590:	20 00                	and    %al,(%eax)
  283592:	00 00                	add    %al,(%eax)
  283594:	30 05 00 00 b0 da    	xor    %al,0xdab00000
  28359a:	ff                   	(bad)  
  28359b:	ff 4e 00             	decl   0x0(%esi)
  28359e:	00 00                	add    %al,(%eax)
  2835a0:	00 41 0e             	add    %al,0xe(%ecx)
  2835a3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2835a9:	41                   	inc    %ecx
  2835aa:	83 03 02             	addl   $0x2,(%ebx)
  2835ad:	49                   	dec    %ecx
  2835ae:	c5 c3 0c             	(bad)  
  2835b1:	04 04                	add    $0x4,%al
  2835b3:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2835b6:	00 00                	add    %al,(%eax)
  2835b8:	54                   	push   %esp
  2835b9:	05 00 00 da da       	add    $0xdada0000,%eax
  2835be:	ff                   	(bad)  
  2835bf:	ff 23                	jmp    *(%ebx)
  2835c1:	00 00                	add    %al,(%eax)
  2835c3:	00 00                	add    %al,(%eax)
  2835c5:	41                   	inc    %ecx
  2835c6:	0e                   	push   %cs
  2835c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2835cd:	5f                   	pop    %edi
  2835ce:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2835d1:	04 00                	add    $0x0,%al
  2835d3:	00 20                	add    %ah,(%eax)
  2835d5:	00 00                	add    %al,(%eax)
  2835d7:	00 74 05 00          	add    %dh,0x0(%ebp,%eax,1)
  2835db:	00 dd                	add    %bl,%ch
  2835dd:	da ff                	(bad)  
  2835df:	ff 1b                	lcall  *(%ebx)
  2835e1:	00 00                	add    %al,(%eax)
  2835e3:	00 00                	add    %al,(%eax)
  2835e5:	41                   	inc    %ecx
  2835e6:	0e                   	push   %cs
  2835e7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2835ed:	46                   	inc    %esi
  2835ee:	83 03 4e             	addl   $0x4e,(%ebx)
  2835f1:	c3                   	ret    
  2835f2:	41                   	inc    %ecx
  2835f3:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2835f6:	04 00                	add    $0x0,%al
  2835f8:	28 00                	sub    %al,(%eax)
  2835fa:	00 00                	add    %al,(%eax)
  2835fc:	98                   	cwtl   
  2835fd:	05 00 00 d4 da       	add    $0xdad40000,%eax
  283602:	ff                   	(bad)  
  283603:	ff 5b 00             	lcall  *0x0(%ebx)
  283606:	00 00                	add    %al,(%eax)
  283608:	00 41 0e             	add    %al,0xe(%ecx)
  28360b:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283611:	46                   	inc    %esi
  283612:	87 03                	xchg   %eax,(%ebx)
  283614:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283617:	05 02 4c c3 41       	add    $0x41c34c02,%eax
  28361c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283620:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283623:	04 1c                	add    $0x1c,%al
  283625:	00 00                	add    %al,(%eax)
  283627:	00 c4                	add    %al,%ah
  283629:	05 00 00 03 db       	add    $0xdb030000,%eax
  28362e:	ff                   	(bad)  
  28362f:	ff 19                	lcall  *(%ecx)
  283631:	00 00                	add    %al,(%eax)
  283633:	00 00                	add    %al,(%eax)
  283635:	41                   	inc    %ecx
  283636:	0e                   	push   %cs
  283637:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28363d:	51                   	push   %ecx
  28363e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283641:	04 00                	add    $0x0,%al
  283643:	00 28                	add    %ch,(%eax)
  283645:	00 00                	add    %al,(%eax)
  283647:	00 e4                	add    %ah,%ah
  283649:	05 00 00 fc da       	add    $0xdafc0000,%eax
  28364e:	ff                   	(bad)  
  28364f:	ff                   	(bad)  
  283650:	ea 00 00 00 00 41 0e 	ljmp   $0xe41,$0x0
  283657:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  28365d:	46                   	inc    %esi
  28365e:	87 03                	xchg   %eax,(%ebx)
  283660:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283663:	05 02 db c3 41       	add    $0x41c3db02,%eax
  283668:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28366c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28366f:	04 1c                	add    $0x1c,%al
  283671:	00 00                	add    %al,(%eax)
  283673:	00 10                	add    %dl,(%eax)
  283675:	06                   	push   %es
  283676:	00 00                	add    %al,(%eax)
  283678:	ba db ff ff 19       	mov    $0x19ffffdb,%edx
  28367d:	00 00                	add    %al,(%eax)
  28367f:	00 00                	add    %al,(%eax)
  283681:	41                   	inc    %ecx
  283682:	0e                   	push   %cs
  283683:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283689:	51                   	push   %ecx
  28368a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28368d:	04 00                	add    $0x0,%al
  28368f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283692:	00 00                	add    %al,(%eax)
  283694:	30 06                	xor    %al,(%esi)
  283696:	00 00                	add    %al,(%eax)
  283698:	b3 db                	mov    $0xdb,%bl
  28369a:	ff                   	(bad)  
  28369b:	ff 45 00             	incl   0x0(%ebp)
  28369e:	00 00                	add    %al,(%eax)
  2836a0:	00 41 0e             	add    %al,0xe(%ecx)
  2836a3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2836a9:	02 41 c5             	add    -0x3b(%ecx),%al
  2836ac:	0c 04                	or     $0x4,%al
  2836ae:	04 00                	add    $0x0,%al
  2836b0:	1c 00                	sbb    $0x0,%al
  2836b2:	00 00                	add    %al,(%eax)
  2836b4:	50                   	push   %eax
  2836b5:	06                   	push   %es
  2836b6:	00 00                	add    %al,(%eax)
  2836b8:	d8 db                	fcomp  %st(3)
  2836ba:	ff                   	(bad)  
  2836bb:	ff 35 00 00 00 00    	pushl  0x0
  2836c1:	41                   	inc    %ecx
  2836c2:	0e                   	push   %cs
  2836c3:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2836c9:	6f                   	outsl  %ds:(%esi),(%dx)
  2836ca:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2836cd:	04 00                	add    $0x0,%al
  2836cf:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2836d2:	00 00                	add    %al,(%eax)
  2836d4:	70 06                	jo     2836dc <cursor.1418+0x7b4>
  2836d6:	00 00                	add    %al,(%eax)
  2836d8:	ed                   	in     (%dx),%eax
  2836d9:	db ff                	(bad)  
  2836db:	ff 1f                	lcall  *(%edi)
  2836dd:	00 00                	add    %al,(%eax)
  2836df:	00 00                	add    %al,(%eax)
  2836e1:	41                   	inc    %ecx
  2836e2:	0e                   	push   %cs
  2836e3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2836e9:	5b                   	pop    %ebx
  2836ea:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2836ed:	04 00                	add    $0x0,%al
  2836ef:	00 2c 00             	add    %ch,(%eax,%eax,1)
  2836f2:	00 00                	add    %al,(%eax)
  2836f4:	90                   	nop
  2836f5:	06                   	push   %es
  2836f6:	00 00                	add    %al,(%eax)
  2836f8:	ec                   	in     (%dx),%al
  2836f9:	db ff                	(bad)  
  2836fb:	ff ab 00 00 00 00    	ljmp   *0x0(%ebx)
  283701:	41                   	inc    %ecx
  283702:	0e                   	push   %cs
  283703:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283709:	41                   	inc    %ecx
  28370a:	87 03                	xchg   %eax,(%ebx)
  28370c:	47                   	inc    %edi
  28370d:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283710:	05 02 9c c3 41       	add    $0x41c39c02,%eax
  283715:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283719:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28371c:	04 00                	add    $0x0,%al
  28371e:	00 00                	add    %al,(%eax)
  283720:	28 00                	sub    %al,(%eax)
  283722:	00 00                	add    %al,(%eax)
  283724:	c0 06 00             	rolb   $0x0,(%esi)
  283727:	00 67 dc             	add    %ah,-0x24(%edi)
  28372a:	ff                   	(bad)  
  28372b:	ff f7                	push   %edi
  28372d:	00 00                	add    %al,(%eax)
  28372f:	00 00                	add    %al,(%eax)
  283731:	41                   	inc    %ecx
  283732:	0e                   	push   %cs
  283733:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283739:	44                   	inc    %esp
  28373a:	87 03                	xchg   %eax,(%ebx)
  28373c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28373f:	05 02 ec c3 41       	add    $0x41c3ec02,%eax
  283744:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283748:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28374b:	04 38                	add    $0x38,%al
  28374d:	00 00                	add    %al,(%eax)
  28374f:	00 ec                	add    %ch,%ah
  283751:	06                   	push   %es
  283752:	00 00                	add    %al,(%eax)
  283754:	32 dd                	xor    %ch,%bl
  283756:	ff                   	(bad)  
  283757:	ff 4a 00             	decl   0x0(%edx)
  28375a:	00 00                	add    %al,(%eax)
  28375c:	00 41 0e             	add    %al,0xe(%ecx)
  28375f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283765:	44                   	inc    %esp
  283766:	87 03                	xchg   %eax,(%ebx)
  283768:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28376b:	05 75 0a c3 41       	add    $0x41c30a75,%eax
  283770:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283774:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283777:	04 45                	add    $0x45,%al
  283779:	0b 42 c3             	or     -0x3d(%edx),%eax
  28377c:	41                   	inc    %ecx
  28377d:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  283781:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283784:	04 00                	add    $0x0,%al
  283786:	00 00                	add    %al,(%eax)
  283788:	2c 00                	sub    $0x0,%al
  28378a:	00 00                	add    %al,(%eax)
  28378c:	28 07                	sub    %al,(%edi)
  28378e:	00 00                	add    %al,(%eax)
  283790:	40                   	inc    %eax
  283791:	dd ff                	(bad)  
  283793:	ff 58 00             	lcall  *0x0(%eax)
  283796:	00 00                	add    %al,(%eax)
  283798:	00 41 0e             	add    %al,0xe(%ecx)
  28379b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2837a1:	41                   	inc    %ecx
  2837a2:	87 03                	xchg   %eax,(%ebx)
  2837a4:	44                   	inc    %esp
  2837a5:	86 04 44             	xchg   %al,(%esp,%eax,2)
  2837a8:	83 05 02 48 c3 41 c6 	addl   $0xffffffc6,0x41c34802
  2837af:	41                   	inc    %ecx
  2837b0:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
	...

Disassembly of section .bss:

002837b8 <keyfifo>:
	...

002837d0 <mousefifo>:
	...

Disassembly of section .stab:

00000000 <.stab>:
       0:	01 00                	add    %eax,(%eax)
       2:	00 00                	add    %al,(%eax)
       4:	00 00                	add    %al,(%eax)
       6:	8c 05 97 15 00 00    	mov    %es,0x1597
       c:	01 00                	add    %eax,(%eax)
       e:	00 00                	add    %al,(%eax)
      10:	64 00 02             	add    %al,%fs:(%edx)
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
     1fb:	00 82 00 00 00 65    	add    %al,0x65000000(%edx)
     201:	97                   	xchg   %eax,%edi
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
     240:	e2 05                	loop   247 <bootmain-0x27fdb9>
     242:	00 00                	add    %al,(%eax)
     244:	80 00 00             	addb   $0x0,(%eax)
     247:	00 00                	add    %al,(%eax)
     249:	00 00                	add    %al,(%eax)
     24b:	00 f5                	add    %dh,%ch
     24d:	05 00 00 80 00       	add    $0x800000,%eax
     252:	00 00                	add    %al,(%eax)
     254:	00 00                	add    %al,(%eax)
     256:	00 00                	add    %al,(%eax)
     258:	af                   	scas   %es:(%edi),%eax
     259:	06                   	push   %es
     25a:	00 00                	add    %al,(%eax)
     25c:	80 00 00             	addb   $0x0,(%eax)
	...
     267:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     26d:	00 00                	add    %al,(%eax)
     26f:	00 c5                	add    %al,%ch
     271:	06                   	push   %es
     272:	00 00                	add    %al,(%eax)
     274:	80 00 00             	addb   $0x0,(%eax)
     277:	00 00                	add    %al,(%eax)
     279:	00 00                	add    %al,(%eax)
     27b:	00 62 07             	add    %ah,0x7(%edx)
     27e:	00 00                	add    %al,(%eax)
     280:	80 00 00             	addb   $0x0,(%eax)
     283:	00 00                	add    %al,(%eax)
     285:	00 00                	add    %al,(%eax)
     287:	00 f2                	add    %dh,%dl
     289:	07                   	pop    %es
     28a:	00 00                	add    %al,(%eax)
     28c:	80 00 00             	addb   $0x0,(%eax)
     28f:	00 00                	add    %al,(%eax)
     291:	00 00                	add    %al,(%eax)
     293:	00 70 08             	add    %dh,0x8(%eax)
     296:	00 00                	add    %al,(%eax)
     298:	80 00 00             	addb   $0x0,(%eax)
     29b:	00 00                	add    %al,(%eax)
     29d:	00 00                	add    %al,(%eax)
     29f:	00 e5                	add    %ah,%ch
     2a1:	08 00                	or     %al,(%eax)
     2a3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     2a9:	00 00                	add    %al,(%eax)
     2ab:	00 00                	add    %al,(%eax)
     2ad:	00 00                	add    %al,(%eax)
     2af:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     2b5:	00 00                	add    %al,(%eax)
     2b7:	00 5e 09             	add    %bl,0x9(%esi)
     2ba:	00 00                	add    %al,(%eax)
     2bc:	24 00                	and    $0x0,%al
     2be:	00 00                	add    %al,(%eax)
     2c0:	00 00                	add    %al,(%eax)
     2c2:	28 00                	sub    %al,(%eax)
     2c4:	00 00                	add    %al,(%eax)
     2c6:	00 00                	add    %al,(%eax)
     2c8:	44                   	inc    %esp
     2c9:	00 10                	add    %dl,(%eax)
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
     2f3:	00 00                	add    %al,(%eax)
     2f5:	00 00                	add    %al,(%eax)
     2f7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     2fb:	00 24 00             	add    %ah,(%eax,%eax,1)
     2fe:	00 00                	add    %al,(%eax)
     300:	ae                   	scas   %es:(%edi),%al
     301:	02 00                	add    (%eax),%al
     303:	00 84 00 00 00 34 00 	add    %al,0x340000(%eax,%eax,1)
     30a:	28 00                	sub    %al,(%eax)
     30c:	00 00                	add    %al,(%eax)
     30e:	00 00                	add    %al,(%eax)
     310:	44                   	inc    %esp
     311:	00 3e                	add    %bh,(%esi)
     313:	00 34 00             	add    %dh,(%eax,%eax,1)
     316:	00 00                	add    %al,(%eax)
     318:	01 00                	add    %eax,(%eax)
     31a:	00 00                	add    %al,(%eax)
     31c:	84 00                	test   %al,(%eax)
     31e:	00 00                	add    %al,(%eax)
     320:	35 00 28 00 00       	xor    $0x2800,%eax
     325:	00 00                	add    %al,(%eax)
     327:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
     32b:	00 35 00 00 00 00    	add    %dh,0x0
     331:	00 00                	add    %al,(%eax)
     333:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
     337:	00 3a                	add    %bh,(%edx)
     339:	00 00                	add    %al,(%eax)
     33b:	00 00                	add    %al,(%eax)
     33d:	00 00                	add    %al,(%eax)
     33f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
     343:	00 3f                	add    %bh,(%edi)
     345:	00 00                	add    %al,(%eax)
     347:	00 00                	add    %al,(%eax)
     349:	00 00                	add    %al,(%eax)
     34b:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
     34f:	00 55 00             	add    %dl,0x0(%ebp)
     352:	00 00                	add    %al,(%eax)
     354:	ae                   	scas   %es:(%edi),%al
     355:	02 00                	add    (%eax),%al
     357:	00 84 00 00 00 6e 00 	add    %al,0x6e0000(%eax,%eax,1)
     35e:	28 00                	sub    %al,(%eax)
     360:	00 00                	add    %al,(%eax)
     362:	00 00                	add    %al,(%eax)
     364:	44                   	inc    %esp
     365:	00 6c 00 6e          	add    %ch,0x6e(%eax,%eax,1)
     369:	00 00                	add    %al,(%eax)
     36b:	00 01                	add    %al,(%ecx)
     36d:	00 00                	add    %al,(%eax)
     36f:	00 84 00 00 00 7b 00 	add    %al,0x7b0000(%eax,%eax,1)
     376:	28 00                	sub    %al,(%eax)
     378:	00 00                	add    %al,(%eax)
     37a:	00 00                	add    %al,(%eax)
     37c:	44                   	inc    %esp
     37d:	00 36                	add    %dh,(%esi)
     37f:	00 7b 00             	add    %bh,0x0(%ebx)
     382:	00 00                	add    %al,(%eax)
     384:	ae                   	scas   %es:(%edi),%al
     385:	02 00                	add    (%eax),%al
     387:	00 84 00 00 00 80 00 	add    %al,0x800000(%eax,%eax,1)
     38e:	28 00                	sub    %al,(%eax)
     390:	00 00                	add    %al,(%eax)
     392:	00 00                	add    %al,(%eax)
     394:	44                   	inc    %esp
     395:	00 37                	add    %dh,(%edi)
     397:	00 80 00 00 00 01    	add    %al,0x1000000(%eax)
     39d:	00 00                	add    %al,(%eax)
     39f:	00 84 00 00 00 81 00 	add    %al,0x810000(%eax,%eax,1)
     3a6:	28 00                	sub    %al,(%eax)
     3a8:	00 00                	add    %al,(%eax)
     3aa:	00 00                	add    %al,(%eax)
     3ac:	44                   	inc    %esp
     3ad:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
     3b1:	00 00                	add    %al,(%eax)
     3b3:	00 00                	add    %al,(%eax)
     3b5:	00 00                	add    %al,(%eax)
     3b7:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
     3bb:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
     3c1:	00 00                	add    %al,(%eax)
     3c3:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
     3c7:	00 a3 00 00 00 00    	add    %ah,0x0(%ebx)
     3cd:	00 00                	add    %al,(%eax)
     3cf:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
     3d3:	00 aa 00 00 00 00    	add    %ch,0x0(%edx)
     3d9:	00 00                	add    %al,(%eax)
     3db:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
     3df:	00 ac 00 00 00 00 00 	add    %ch,0x0(%eax,%eax,1)
     3e6:	00 00                	add    %al,(%eax)
     3e8:	44                   	inc    %esp
     3e9:	00 4e 00             	add    %cl,0x0(%esi)
     3ec:	b1 00                	mov    $0x0,%cl
     3ee:	00 00                	add    %al,(%eax)
     3f0:	00 00                	add    %al,(%eax)
     3f2:	00 00                	add    %al,(%eax)
     3f4:	44                   	inc    %esp
     3f5:	00 53 00             	add    %dl,0x0(%ebx)
     3f8:	ca 00 00             	lret   $0x0
     3fb:	00 00                	add    %al,(%eax)
     3fd:	00 00                	add    %al,(%eax)
     3ff:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     403:	00 cd                	add    %cl,%ch
     405:	00 00                	add    %al,(%eax)
     407:	00 00                	add    %al,(%eax)
     409:	00 00                	add    %al,(%eax)
     40b:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     40f:	00 de                	add    %bl,%dh
     411:	00 00                	add    %al,(%eax)
     413:	00 00                	add    %al,(%eax)
     415:	00 00                	add    %al,(%eax)
     417:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     41b:	00 e1                	add    %ah,%cl
     41d:	00 00                	add    %al,(%eax)
     41f:	00 00                	add    %al,(%eax)
     421:	00 00                	add    %al,(%eax)
     423:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     427:	00 e3                	add    %ah,%bl
     429:	00 00                	add    %al,(%eax)
     42b:	00 00                	add    %al,(%eax)
     42d:	00 00                	add    %al,(%eax)
     42f:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
     433:	00 e8                	add    %ch,%al
     435:	00 00                	add    %al,(%eax)
     437:	00 00                	add    %al,(%eax)
     439:	00 00                	add    %al,(%eax)
     43b:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     43f:	00 ee                	add    %ch,%dh
     441:	00 00                	add    %al,(%eax)
     443:	00 00                	add    %al,(%eax)
     445:	00 00                	add    %al,(%eax)
     447:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
     44b:	00 fa                	add    %bh,%dl
     44d:	00 00                	add    %al,(%eax)
     44f:	00 00                	add    %al,(%eax)
     451:	00 00                	add    %al,(%eax)
     453:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
     457:	00 13                	add    %dl,(%ebx)
     459:	01 00                	add    %eax,(%eax)
     45b:	00 00                	add    %al,(%eax)
     45d:	00 00                	add    %al,(%eax)
     45f:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
     463:	00 31                	add    %dh,(%ecx)
     465:	01 00                	add    %eax,(%eax)
     467:	00 00                	add    %al,(%eax)
     469:	00 00                	add    %al,(%eax)
     46b:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
     46f:	00 56 01             	add    %dl,0x1(%esi)
     472:	00 00                	add    %al,(%eax)
     474:	00 00                	add    %al,(%eax)
     476:	00 00                	add    %al,(%eax)
     478:	44                   	inc    %esp
     479:	00 5b 00             	add    %bl,0x0(%ebx)
     47c:	5e                   	pop    %esi
     47d:	01 00                	add    %eax,(%eax)
     47f:	00 00                	add    %al,(%eax)
     481:	00 00                	add    %al,(%eax)
     483:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
     487:	00 61 01             	add    %ah,0x1(%ecx)
     48a:	00 00                	add    %al,(%eax)
     48c:	00 00                	add    %al,(%eax)
     48e:	00 00                	add    %al,(%eax)
     490:	44                   	inc    %esp
     491:	00 5b 00             	add    %bl,0x0(%ebx)
     494:	67 01 00             	add    %eax,(%bx,%si)
     497:	00 00                	add    %al,(%eax)
     499:	00 00                	add    %al,(%eax)
     49b:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
     49f:	00 6c 01 00          	add    %ch,0x0(%ecx,%eax,1)
     4a3:	00 00                	add    %al,(%eax)
     4a5:	00 00                	add    %al,(%eax)
     4a7:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     4ab:	00 84 01 00 00 00 00 	add    %al,0x0(%ecx,%eax,1)
     4b2:	00 00                	add    %al,(%eax)
     4b4:	44                   	inc    %esp
     4b5:	00 5d 00             	add    %bl,0x0(%ebp)
     4b8:	8c 01                	mov    %es,(%ecx)
     4ba:	00 00                	add    %al,(%eax)
     4bc:	00 00                	add    %al,(%eax)
     4be:	00 00                	add    %al,(%eax)
     4c0:	44                   	inc    %esp
     4c1:	00 5e 00             	add    %bl,0x0(%esi)
     4c4:	91                   	xchg   %eax,%ecx
     4c5:	01 00                	add    %eax,(%eax)
     4c7:	00 00                	add    %al,(%eax)
     4c9:	00 00                	add    %al,(%eax)
     4cb:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
     4cf:	00 a7 01 00 00 00    	add    %ah,0x1(%edi)
     4d5:	00 00                	add    %al,(%eax)
     4d7:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
     4db:	00 ba 01 00 00 00    	add    %bh,0x1(%edx)
     4e1:	00 00                	add    %al,(%eax)
     4e3:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
     4e7:	00 c8                	add    %cl,%al
     4e9:	01 00                	add    %eax,(%eax)
     4eb:	00 00                	add    %al,(%eax)
     4ed:	00 00                	add    %al,(%eax)
     4ef:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
     4f3:	00 d9                	add    %bl,%cl
     4f5:	01 00                	add    %eax,(%eax)
     4f7:	00 00                	add    %al,(%eax)
     4f9:	00 00                	add    %al,(%eax)
     4fb:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
     4ff:	00 df                	add    %bl,%bh
     501:	01 00                	add    %eax,(%eax)
     503:	00 00                	add    %al,(%eax)
     505:	00 00                	add    %al,(%eax)
     507:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
     50b:	00 e4                	add    %ah,%ah
     50d:	01 00                	add    %eax,(%eax)
     50f:	00 00                	add    %al,(%eax)
     511:	00 00                	add    %al,(%eax)
     513:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
     517:	00 ea                	add    %ch,%dl
     519:	01 00                	add    %eax,(%eax)
     51b:	00 00                	add    %al,(%eax)
     51d:	00 00                	add    %al,(%eax)
     51f:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
     523:	00 f2                	add    %dh,%dl
     525:	01 00                	add    %eax,(%eax)
     527:	00 00                	add    %al,(%eax)
     529:	00 00                	add    %al,(%eax)
     52b:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
     52f:	00 f8                	add    %bh,%al
     531:	01 00                	add    %eax,(%eax)
     533:	00 00                	add    %al,(%eax)
     535:	00 00                	add    %al,(%eax)
     537:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
     53b:	00 fe                	add    %bh,%dh
     53d:	01 00                	add    %eax,(%eax)
     53f:	00 00                	add    %al,(%eax)
     541:	00 00                	add    %al,(%eax)
     543:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
     547:	00 01                	add    %al,(%ecx)
     549:	02 00                	add    (%eax),%al
     54b:	00 00                	add    %al,(%eax)
     54d:	00 00                	add    %al,(%eax)
     54f:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
     553:	00 0b                	add    %cl,(%ebx)
     555:	02 00                	add    (%eax),%al
     557:	00 00                	add    %al,(%eax)
     559:	00 00                	add    %al,(%eax)
     55b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
     55f:	00 11                	add    %dl,(%ecx)
     561:	02 00                	add    (%eax),%al
     563:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     569:	00 00                	add    %al,(%eax)
     56b:	00 17                	add    %dl,(%edi)
     56d:	02 28                	add    (%eax),%ch
     56f:	00 00                	add    %al,(%eax)
     571:	00 00                	add    %al,(%eax)
     573:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
     577:	00 17                	add    %dl,(%edi)
     579:	02 00                	add    (%eax),%al
     57b:	00 01                	add    %al,(%ecx)
     57d:	00 00                	add    %al,(%eax)
     57f:	00 84 00 00 00 18 02 	add    %al,0x2180000(%eax,%eax,1)
     586:	28 00                	sub    %al,(%eax)
     588:	00 00                	add    %al,(%eax)
     58a:	00 00                	add    %al,(%eax)
     58c:	44                   	inc    %esp
     58d:	00 72 00             	add    %dh,0x0(%edx)
     590:	18 02                	sbb    %al,(%edx)
     592:	00 00                	add    %al,(%eax)
     594:	ae                   	scas   %es:(%edi),%al
     595:	02 00                	add    (%eax),%al
     597:	00 84 00 00 00 44 02 	add    %al,0x2440000(%eax,%eax,1)
     59e:	28 00                	sub    %al,(%eax)
     5a0:	00 00                	add    %al,(%eax)
     5a2:	00 00                	add    %al,(%eax)
     5a4:	44                   	inc    %esp
     5a5:	00 37                	add    %dh,(%edi)
     5a7:	00 44 02 00          	add    %al,0x0(%edx,%eax,1)
     5ab:	00 00                	add    %al,(%eax)
     5ad:	00 00                	add    %al,(%eax)
     5af:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
     5b3:	00 45 02             	add    %al,0x2(%ebp)
     5b6:	00 00                	add    %al,(%eax)
     5b8:	01 00                	add    %eax,(%eax)
     5ba:	00 00                	add    %al,(%eax)
     5bc:	84 00                	test   %al,(%eax)
     5be:	00 00                	add    %al,(%eax)
     5c0:	48                   	dec    %eax
     5c1:	02 28                	add    (%eax),%ch
     5c3:	00 00                	add    %al,(%eax)
     5c5:	00 00                	add    %al,(%eax)
     5c7:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
     5cb:	00 48 02             	add    %cl,0x2(%eax)
     5ce:	00 00                	add    %al,(%eax)
     5d0:	00 00                	add    %al,(%eax)
     5d2:	00 00                	add    %al,(%eax)
     5d4:	44                   	inc    %esp
     5d5:	00 7c 00 5c          	add    %bh,0x5c(%eax,%eax,1)
     5d9:	02 00                	add    (%eax),%al
     5db:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     5e1:	00 00                	add    %al,(%eax)
     5e3:	00 69 02             	add    %ch,0x2(%ecx)
     5e6:	28 00                	sub    %al,(%eax)
     5e8:	00 00                	add    %al,(%eax)
     5ea:	00 00                	add    %al,(%eax)
     5ec:	44                   	inc    %esp
     5ed:	00 37                	add    %dh,(%edi)
     5ef:	00 69 02             	add    %ch,0x2(%ecx)
     5f2:	00 00                	add    %al,(%eax)
     5f4:	01 00                	add    %eax,(%eax)
     5f6:	00 00                	add    %al,(%eax)
     5f8:	84 00                	test   %al,(%eax)
     5fa:	00 00                	add    %al,(%eax)
     5fc:	6f                   	outsl  %ds:(%esi),(%dx)
     5fd:	02 28                	add    (%eax),%ch
     5ff:	00 00                	add    %al,(%eax)
     601:	00 00                	add    %al,(%eax)
     603:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     607:	00 6f 02             	add    %ch,0x2(%edi)
     60a:	00 00                	add    %al,(%eax)
     60c:	00 00                	add    %al,(%eax)
     60e:	00 00                	add    %al,(%eax)
     610:	44                   	inc    %esp
     611:	00 81 00 83 02 00    	add    %al,0x28300(%ecx)
     617:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     61d:	00 00                	add    %al,(%eax)
     61f:	00 90 02 28 00 00    	add    %dl,0x2802(%eax)
     625:	00 00                	add    %al,(%eax)
     627:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     62b:	00 90 02 00 00 01    	add    %dl,0x1000002(%eax)
     631:	00 00                	add    %al,(%eax)
     633:	00 84 00 00 00 91 02 	add    %al,0x2910000(%eax,%eax,1)
     63a:	28 00                	sub    %al,(%eax)
     63c:	00 00                	add    %al,(%eax)
     63e:	00 00                	add    %al,(%eax)
     640:	44                   	inc    %esp
     641:	00 83 00 91 02 00    	add    %al,0x29100(%ebx)
     647:	00 00                	add    %al,(%eax)
     649:	00 00                	add    %al,(%eax)
     64b:	00 44 00 86          	add    %al,-0x7a(%eax,%eax,1)
     64f:	00 ad 02 00 00 00    	add    %ch,0x2(%ebp)
     655:	00 00                	add    %al,(%eax)
     657:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
     65b:	00 c0                	add    %al,%al
     65d:	02 00                	add    (%eax),%al
     65f:	00 00                	add    %al,(%eax)
     661:	00 00                	add    %al,(%eax)
     663:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     667:	00 c9                	add    %cl,%cl
     669:	02 00                	add    (%eax),%al
     66b:	00 00                	add    %al,(%eax)
     66d:	00 00                	add    %al,(%eax)
     66f:	00 44 00 8a          	add    %al,-0x76(%eax,%eax,1)
     673:	00 d2                	add    %dl,%dl
     675:	02 00                	add    (%eax),%al
     677:	00 00                	add    %al,(%eax)
     679:	00 00                	add    %al,(%eax)
     67b:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
     67f:	00 d9                	add    %bl,%cl
     681:	02 00                	add    (%eax),%al
     683:	00 00                	add    %al,(%eax)
     685:	00 00                	add    %al,(%eax)
     687:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
     68b:	00 f5                	add    %dh,%ch
     68d:	02 00                	add    (%eax),%al
     68f:	00 00                	add    %al,(%eax)
     691:	00 00                	add    %al,(%eax)
     693:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
     697:	00 10                	add    %dl,(%eax)
     699:	03 00                	add    (%eax),%eax
     69b:	00 00                	add    %al,(%eax)
     69d:	00 00                	add    %al,(%eax)
     69f:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
     6a3:	00 2d 03 00 00 00    	add    %ch,0x3
     6a9:	00 00                	add    %al,(%eax)
     6ab:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
     6af:	00 6a 03             	add    %ch,0x3(%edx)
     6b2:	00 00                	add    %al,(%eax)
     6b4:	00 00                	add    %al,(%eax)
     6b6:	00 00                	add    %al,(%eax)
     6b8:	44                   	inc    %esp
     6b9:	00 a1 00 74 03 00    	add    %ah,0x37400(%ecx)
     6bf:	00 00                	add    %al,(%eax)
     6c1:	00 00                	add    %al,(%eax)
     6c3:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
     6c7:	00 7c 03 00          	add    %bh,0x0(%ebx,%eax,1)
     6cb:	00 00                	add    %al,(%eax)
     6cd:	00 00                	add    %al,(%eax)
     6cf:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
     6d3:	00 86 03 00 00 00    	add    %al,0x3(%esi)
     6d9:	00 00                	add    %al,(%eax)
     6db:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
     6df:	00 8e 03 00 00 00    	add    %cl,0x3(%esi)
     6e5:	00 00                	add    %al,(%eax)
     6e7:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
     6eb:	00 9b 03 00 00 00    	add    %bl,0x3(%ebx)
     6f1:	00 00                	add    %al,(%eax)
     6f3:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
     6f7:	00 a1 03 00 00 00    	add    %ah,0x3(%ecx)
     6fd:	00 00                	add    %al,(%eax)
     6ff:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
     703:	00 a6 03 00 00 00    	add    %ah,0x3(%esi)
     709:	00 00                	add    %al,(%eax)
     70b:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
     70f:	00 be 03 00 00 00    	add    %bh,0x3(%esi)
     715:	00 00                	add    %al,(%eax)
     717:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
     71b:	00 db                	add    %bl,%bl
     71d:	03 00                	add    (%eax),%eax
     71f:	00 00                	add    %al,(%eax)
     721:	00 00                	add    %al,(%eax)
     723:	00 44 00 ae          	add    %al,-0x52(%eax,%eax,1)
     727:	00 f2                	add    %dh,%dl
     729:	03 00                	add    (%eax),%eax
     72b:	00 6f 09             	add    %ch,0x9(%edi)
     72e:	00 00                	add    %al,(%eax)
     730:	80 00 00             	addb   $0x0,(%eax)
     733:	00 f8                	add    %bh,%al
     735:	fe                   	(bad)  
     736:	ff                   	(bad)  
     737:	ff 93 09 00 00 80    	call   *-0x7ffffff7(%ebx)
     73d:	00 00                	add    %al,(%eax)
     73f:	00 50 fe             	add    %dl,-0x2(%eax)
     742:	ff                   	(bad)  
     743:	ff b0 09 00 00 80    	pushl  -0x7ffffff7(%eax)
     749:	00 00                	add    %al,(%eax)
     74b:	00 30                	add    %dh,(%eax)
     74d:	fe                   	(bad)  
     74e:	ff                   	(bad)  
     74f:	ff d2                	call   *%edx
     751:	09 00                	or     %eax,(%eax)
     753:	00 80 00 00 00 78    	add    %al,0x78000000(%eax)
     759:	fe                   	(bad)  
     75a:	ff                   	(bad)  
     75b:	ff f7                	push   %edi
     75d:	09 00                	or     %eax,(%eax)
     75f:	00 80 00 00 00 20    	add    %al,0x20000000(%eax)
     765:	fe                   	(bad)  
     766:	ff                   	(bad)  
     767:	ff 02                	incl   (%edx)
     769:	0a 00                	or     (%eax),%al
     76b:	00 40 00             	add    %al,0x0(%eax)
     76e:	00 00                	add    %al,(%eax)
     770:	03 00                	add    (%eax),%eax
     772:	00 00                	add    %al,(%eax)
     774:	12 0a                	adc    (%edx),%cl
     776:	00 00                	add    %al,(%eax)
     778:	40                   	inc    %eax
     779:	00 00                	add    %al,(%eax)
     77b:	00 06                	add    %al,(%esi)
     77d:	00 00                	add    %al,(%eax)
     77f:	00 1d 0a 00 00 40    	add    %bl,0x4000000a
     785:	00 00                	add    %al,(%eax)
     787:	00 03                	add    %al,(%ebx)
     789:	00 00                	add    %al,(%eax)
     78b:	00 00                	add    %al,(%eax)
     78d:	00 00                	add    %al,(%eax)
     78f:	00 c0                	add    %al,%al
	...
     799:	00 00                	add    %al,(%eax)
     79b:	00 e0                	add    %ah,%al
     79d:	00 00                	add    %al,(%eax)
     79f:	00 10                	add    %dl,(%eax)
     7a1:	04 00                	add    $0x0,%al
     7a3:	00 34 0a             	add    %dh,(%edx,%ecx,1)
     7a6:	00 00                	add    %al,(%eax)
     7a8:	20 00                	and    %al,(%eax)
     7aa:	00 00                	add    %al,(%eax)
     7ac:	00 00                	add    %al,(%eax)
     7ae:	00 00                	add    %al,(%eax)
     7b0:	5d                   	pop    %ebp
     7b1:	0a 00                	or     (%eax),%al
     7b3:	00 20                	add    %ah,(%eax)
	...
     7bd:	00 00                	add    %al,(%eax)
     7bf:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
     7c3:	00 10                	add    %dl,(%eax)
     7c5:	04 28                	add    $0x28,%al
     7c7:	00 84 0a 00 00 64 00 	add    %al,0x640000(%edx,%ecx,1)
     7ce:	02 00                	add    (%eax),%al
     7d0:	10 04 28             	adc    %al,(%eax,%ebp,1)
     7d3:	00 08                	add    %cl,(%eax)
     7d5:	00 00                	add    %al,(%eax)
     7d7:	00 3c 00             	add    %bh,(%eax,%eax,1)
     7da:	00 00                	add    %al,(%eax)
     7dc:	00 00                	add    %al,(%eax)
     7de:	00 00                	add    %al,(%eax)
     7e0:	17                   	pop    %ss
     7e1:	00 00                	add    %al,(%eax)
     7e3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     7e9:	00 00                	add    %al,(%eax)
     7eb:	00 41 00             	add    %al,0x0(%ecx)
     7ee:	00 00                	add    %al,(%eax)
     7f0:	80 00 00             	addb   $0x0,(%eax)
     7f3:	00 00                	add    %al,(%eax)
     7f5:	00 00                	add    %al,(%eax)
     7f7:	00 5b 00             	add    %bl,0x0(%ebx)
     7fa:	00 00                	add    %al,(%eax)
     7fc:	80 00 00             	addb   $0x0,(%eax)
     7ff:	00 00                	add    %al,(%eax)
     801:	00 00                	add    %al,(%eax)
     803:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     809:	00 00                	add    %al,(%eax)
     80b:	00 00                	add    %al,(%eax)
     80d:	00 00                	add    %al,(%eax)
     80f:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     815:	00 00                	add    %al,(%eax)
     817:	00 00                	add    %al,(%eax)
     819:	00 00                	add    %al,(%eax)
     81b:	00 e1                	add    %ah,%cl
     81d:	00 00                	add    %al,(%eax)
     81f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     825:	00 00                	add    %al,(%eax)
     827:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     82a:	00 00                	add    %al,(%eax)
     82c:	80 00 00             	addb   $0x0,(%eax)
     82f:	00 00                	add    %al,(%eax)
     831:	00 00                	add    %al,(%eax)
     833:	00 37                	add    %dh,(%edi)
     835:	01 00                	add    %eax,(%eax)
     837:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     83d:	00 00                	add    %al,(%eax)
     83f:	00 5d 01             	add    %bl,0x1(%ebp)
     842:	00 00                	add    %al,(%eax)
     844:	80 00 00             	addb   $0x0,(%eax)
     847:	00 00                	add    %al,(%eax)
     849:	00 00                	add    %al,(%eax)
     84b:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     851:	00 00                	add    %al,(%eax)
     853:	00 00                	add    %al,(%eax)
     855:	00 00                	add    %al,(%eax)
     857:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     85d:	00 00                	add    %al,(%eax)
     85f:	00 00                	add    %al,(%eax)
     861:	00 00                	add    %al,(%eax)
     863:	00 d2                	add    %dl,%dl
     865:	01 00                	add    %eax,(%eax)
     867:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     86d:	00 00                	add    %al,(%eax)
     86f:	00 ec                	add    %ch,%ah
     871:	01 00                	add    %eax,(%eax)
     873:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     879:	00 00                	add    %al,(%eax)
     87b:	00 07                	add    %al,(%edi)
     87d:	02 00                	add    (%eax),%al
     87f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     885:	00 00                	add    %al,(%eax)
     887:	00 28                	add    %ch,(%eax)
     889:	02 00                	add    (%eax),%al
     88b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     891:	00 00                	add    %al,(%eax)
     893:	00 47 02             	add    %al,0x2(%edi)
     896:	00 00                	add    %al,(%eax)
     898:	80 00 00             	addb   $0x0,(%eax)
     89b:	00 00                	add    %al,(%eax)
     89d:	00 00                	add    %al,(%eax)
     89f:	00 66 02             	add    %ah,0x2(%esi)
     8a2:	00 00                	add    %al,(%eax)
     8a4:	80 00 00             	addb   $0x0,(%eax)
     8a7:	00 00                	add    %al,(%eax)
     8a9:	00 00                	add    %al,(%eax)
     8ab:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     8b1:	00 00                	add    %al,(%eax)
     8b3:	00 00                	add    %al,(%eax)
     8b5:	00 00                	add    %al,(%eax)
     8b7:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     8bd:	00 00                	add    %al,(%eax)
     8bf:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
     8c5:	02 00                	add    (%eax),%al
     8c7:	00 c2                	add    %al,%dl
     8c9:	00 00                	add    %al,(%eax)
     8cb:	00 00                	add    %al,(%eax)
     8cd:	00 00                	add    %al,(%eax)
     8cf:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
     8d5:	00 00                	add    %al,(%eax)
     8d7:	00 37                	add    %dh,(%edi)
     8d9:	53                   	push   %ebx
     8da:	00 00                	add    %al,(%eax)
     8dc:	29 04 00             	sub    %eax,(%eax,%eax,1)
     8df:	00 c2                	add    %al,%dl
     8e1:	00 00                	add    %al,(%eax)
     8e3:	00 65 97             	add    %ah,-0x69(%ebp)
     8e6:	00 00                	add    %al,(%eax)
     8e8:	8d 0a                	lea    (%edx),%ecx
     8ea:	00 00                	add    %al,(%eax)
     8ec:	24 00                	and    $0x0,%al
     8ee:	00 00                	add    %al,(%eax)
     8f0:	10 04 28             	adc    %al,(%eax,%ebp,1)
     8f3:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
     8f9:	00 00                	add    %al,(%eax)
     8fb:	00 08                	add    %cl,(%eax)
     8fd:	00 00                	add    %al,(%eax)
     8ff:	00 00                	add    %al,(%eax)
     901:	00 00                	add    %al,(%eax)
     903:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
	...
     90f:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     913:	00 01                	add    %al,(%ecx)
     915:	00 00                	add    %al,(%eax)
     917:	00 00                	add    %al,(%eax)
     919:	00 00                	add    %al,(%eax)
     91b:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     91f:	00 06                	add    %al,(%esi)
     921:	00 00                	add    %al,(%eax)
     923:	00 00                	add    %al,(%eax)
     925:	00 00                	add    %al,(%eax)
     927:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     92b:	00 08                	add    %cl,(%eax)
     92d:	00 00                	add    %al,(%eax)
     92f:	00 00                	add    %al,(%eax)
     931:	00 00                	add    %al,(%eax)
     933:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
     937:	00 0b                	add    %cl,(%ebx)
     939:	00 00                	add    %al,(%eax)
     93b:	00 00                	add    %al,(%eax)
     93d:	00 00                	add    %al,(%eax)
     93f:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     943:	00 0d 00 00 00 00    	add    %cl,0x0
     949:	00 00                	add    %al,(%eax)
     94b:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
     94f:	00 15 00 00 00 af    	add    %dl,0xaf000000
     955:	0a 00                	or     (%eax),%al
     957:	00 40 00             	add    %al,0x0(%eax)
     95a:	00 00                	add    %al,(%eax)
     95c:	00 00                	add    %al,(%eax)
     95e:	00 00                	add    %al,(%eax)
     960:	b8 0a 00 00 40       	mov    $0x4000000a,%eax
     965:	00 00                	add    %al,(%eax)
     967:	00 02                	add    %al,(%edx)
     969:	00 00                	add    %al,(%eax)
     96b:	00 00                	add    %al,(%eax)
     96d:	00 00                	add    %al,(%eax)
     96f:	00 c0                	add    %al,%al
	...
     979:	00 00                	add    %al,(%eax)
     97b:	00 e0                	add    %ah,%al
     97d:	00 00                	add    %al,(%eax)
     97f:	00 17                	add    %dl,(%edi)
     981:	00 00                	add    %al,(%eax)
     983:	00 c5                	add    %al,%ch
     985:	0a 00                	or     (%eax),%al
     987:	00 24 00             	add    %ah,(%eax,%eax,1)
     98a:	00 00                	add    %al,(%eax)
     98c:	27                   	daa    
     98d:	04 28                	add    $0x28,%al
     98f:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
     995:	00 00                	add    %al,(%eax)
     997:	00 08                	add    %cl,(%eax)
     999:	00 00                	add    %al,(%eax)
     99b:	00 00                	add    %al,(%eax)
     99d:	00 00                	add    %al,(%eax)
     99f:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
	...
     9ab:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     9af:	00 01                	add    %al,(%ecx)
     9b1:	00 00                	add    %al,(%eax)
     9b3:	00 00                	add    %al,(%eax)
     9b5:	00 00                	add    %al,(%eax)
     9b7:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
     9bb:	00 06                	add    %al,(%esi)
     9bd:	00 00                	add    %al,(%eax)
     9bf:	00 00                	add    %al,(%eax)
     9c1:	00 00                	add    %al,(%eax)
     9c3:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     9c7:	00 08                	add    %cl,(%eax)
     9c9:	00 00                	add    %al,(%eax)
     9cb:	00 00                	add    %al,(%eax)
     9cd:	00 00                	add    %al,(%eax)
     9cf:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     9d3:	00 0a                	add    %cl,(%edx)
     9d5:	00 00                	add    %al,(%eax)
     9d7:	00 00                	add    %al,(%eax)
     9d9:	00 00                	add    %al,(%eax)
     9db:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     9df:	00 12                	add    %dl,(%edx)
     9e1:	00 00                	add    %al,(%eax)
     9e3:	00 af 0a 00 00 40    	add    %ch,0x4000000a(%edi)
	...
     9f1:	00 00                	add    %al,(%eax)
     9f3:	00 c0                	add    %al,%al
	...
     9fd:	00 00                	add    %al,(%eax)
     9ff:	00 e0                	add    %ah,%al
     a01:	00 00                	add    %al,(%eax)
     a03:	00 14 00             	add    %dl,(%eax,%eax,1)
     a06:	00 00                	add    %al,(%eax)
     a08:	da 0a                	fimull (%edx)
     a0a:	00 00                	add    %al,(%eax)
     a0c:	24 00                	and    $0x0,%al
     a0e:	00 00                	add    %al,(%eax)
     a10:	3b 04 28             	cmp    (%eax,%ebp,1),%eax
     a13:	00 ee                	add    %ch,%dh
     a15:	0a 00                	or     (%eax),%al
     a17:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     a1d:	00 00                	add    %al,(%eax)
     a1f:	00 fb                	add    %bh,%bl
     a21:	0a 00                	or     (%eax),%al
     a23:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
     a29:	00 00                	add    %al,(%eax)
     a2b:	00 06                	add    %al,(%esi)
     a2d:	0b 00                	or     (%eax),%eax
     a2f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     a35:	00 00                	add    %al,(%eax)
     a37:	00 00                	add    %al,(%eax)
     a39:	00 00                	add    %al,(%eax)
     a3b:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
	...
     a47:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     a4b:	00 08                	add    %cl,(%eax)
     a4d:	00 00                	add    %al,(%eax)
     a4f:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     a55:	00 00                	add    %al,(%eax)
     a57:	00 46 04             	add    %al,0x4(%esi)
     a5a:	28 00                	sub    %al,(%eax)
     a5c:	00 00                	add    %al,(%eax)
     a5e:	00 00                	add    %al,(%eax)
     a60:	44                   	inc    %esp
     a61:	00 3c 01             	add    %bh,(%ecx,%eax,1)
     a64:	0b 00                	or     (%eax),%eax
     a66:	00 00                	add    %al,(%eax)
     a68:	00 00                	add    %al,(%eax)
     a6a:	00 00                	add    %al,(%eax)
     a6c:	44                   	inc    %esp
     a6d:	00 3e                	add    %bh,(%esi)
     a6f:	00 0d 00 00 00 00    	add    %cl,0x0
     a75:	00 00                	add    %al,(%eax)
     a77:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     a7b:	00 0e                	add    %cl,(%esi)
     a7d:	00 00                	add    %al,(%eax)
     a7f:	00 84 0a 00 00 84 00 	add    %al,0x840000(%edx,%ecx,1)
     a86:	00 00                	add    %al,(%eax)
     a88:	4e                   	dec    %esi
     a89:	04 28                	add    $0x28,%al
     a8b:	00 00                	add    %al,(%eax)
     a8d:	00 00                	add    %al,(%eax)
     a8f:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
     a93:	00 13                	add    %dl,(%ebx)
     a95:	00 00                	add    %al,(%eax)
     a97:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     a9d:	00 00                	add    %al,(%eax)
     a9f:	00 51 04             	add    %dl,0x4(%ecx)
     aa2:	28 00                	sub    %al,(%eax)
     aa4:	00 00                	add    %al,(%eax)
     aa6:	00 00                	add    %al,(%eax)
     aa8:	44                   	inc    %esp
     aa9:	00 6c 00 16          	add    %ch,0x16(%eax,%eax,1)
     aad:	00 00                	add    %al,(%eax)
     aaf:	00 84 0a 00 00 84 00 	add    %al,0x840000(%edx,%ecx,1)
     ab6:	00 00                	add    %al,(%eax)
     ab8:	54                   	push   %esp
     ab9:	04 28                	add    $0x28,%al
     abb:	00 00                	add    %al,(%eax)
     abd:	00 00                	add    %al,(%eax)
     abf:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     ac3:	00 19                	add    %bl,(%ecx)
     ac5:	00 00                	add    %al,(%eax)
     ac7:	00 00                	add    %al,(%eax)
     ac9:	00 00                	add    %al,(%eax)
     acb:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
     acf:	00 1e                	add    %bl,(%esi)
     ad1:	00 00                	add    %al,(%eax)
     ad3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     ad9:	00 00                	add    %al,(%eax)
     adb:	00 5e 04             	add    %bl,0x4(%esi)
     ade:	28 00                	sub    %al,(%eax)
     ae0:	00 00                	add    %al,(%eax)
     ae2:	00 00                	add    %al,(%eax)
     ae4:	44                   	inc    %esp
     ae5:	00 6c 00 23          	add    %ch,0x23(%eax,%eax,1)
     ae9:	00 00                	add    %al,(%eax)
     aeb:	00 84 0a 00 00 84 00 	add    %al,0x840000(%edx,%ecx,1)
     af2:	00 00                	add    %al,(%eax)
     af4:	5f                   	pop    %edi
     af5:	04 28                	add    $0x28,%al
     af7:	00 00                	add    %al,(%eax)
     af9:	00 00                	add    %al,(%eax)
     afb:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
     aff:	00 24 00             	add    %ah,(%eax,%eax,1)
     b02:	00 00                	add    %al,(%eax)
     b04:	ae                   	scas   %es:(%edi),%al
     b05:	02 00                	add    (%eax),%al
     b07:	00 84 00 00 00 65 04 	add    %al,0x4650000(%eax,%eax,1)
     b0e:	28 00                	sub    %al,(%eax)
     b10:	00 00                	add    %al,(%eax)
     b12:	00 00                	add    %al,(%eax)
     b14:	44                   	inc    %esp
     b15:	00 6c 00 2a          	add    %ch,0x2a(%eax,%eax,1)
     b19:	00 00                	add    %al,(%eax)
     b1b:	00 84 0a 00 00 84 00 	add    %al,0x840000(%edx,%ecx,1)
     b22:	00 00                	add    %al,(%eax)
     b24:	66                   	data16
     b25:	04 28                	add    $0x28,%al
     b27:	00 00                	add    %al,(%eax)
     b29:	00 00                	add    %al,(%eax)
     b2b:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     b2f:	00 2b                	add    %ch,(%ebx)
     b31:	00 00                	add    %al,(%eax)
     b33:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
     b39:	00 00                	add    %al,(%eax)
     b3b:	00 6c 04 28          	add    %ch,0x28(%esp,%eax,1)
     b3f:	00 00                	add    %al,(%eax)
     b41:	00 00                	add    %al,(%eax)
     b43:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     b47:	00 31                	add    %dh,(%ecx)
     b49:	00 00                	add    %al,(%eax)
     b4b:	00 84 0a 00 00 84 00 	add    %al,0x840000(%edx,%ecx,1)
     b52:	00 00                	add    %al,(%eax)
     b54:	6d                   	insl   (%dx),%es:(%edi)
     b55:	04 28                	add    $0x28,%al
     b57:	00 00                	add    %al,(%eax)
     b59:	00 00                	add    %al,(%eax)
     b5b:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
     b5f:	00 32                	add    %dh,(%edx)
     b61:	00 00                	add    %al,(%eax)
     b63:	00 00                	add    %al,(%eax)
     b65:	00 00                	add    %al,(%eax)
     b67:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     b6b:	00 35 00 00 00 ae    	add    %dh,0xae000000
     b71:	02 00                	add    (%eax),%al
     b73:	00 84 00 00 00 73 04 	add    %al,0x4730000(%eax,%eax,1)
     b7a:	28 00                	sub    %al,(%eax)
     b7c:	00 00                	add    %al,(%eax)
     b7e:	00 00                	add    %al,(%eax)
     b80:	44                   	inc    %esp
     b81:	00 43 01             	add    %al,0x1(%ebx)
     b84:	38 00                	cmp    %al,(%eax)
     b86:	00 00                	add    %al,(%eax)
     b88:	84 0a                	test   %cl,(%edx)
     b8a:	00 00                	add    %al,(%eax)
     b8c:	84 00                	test   %al,(%eax)
     b8e:	00 00                	add    %al,(%eax)
     b90:	75 04                	jne    b96 <bootmain-0x27f46a>
     b92:	28 00                	sub    %al,(%eax)
     b94:	00 00                	add    %al,(%eax)
     b96:	00 00                	add    %al,(%eax)
     b98:	44                   	inc    %esp
     b99:	00 4b 00             	add    %cl,0x0(%ebx)
     b9c:	3a 00                	cmp    (%eax),%al
     b9e:	00 00                	add    %al,(%eax)
     ba0:	11 0b                	adc    %ecx,(%ebx)
     ba2:	00 00                	add    %al,(%eax)
     ba4:	40                   	inc    %eax
     ba5:	00 00                	add    %al,(%eax)
     ba7:	00 03                	add    %al,(%ebx)
     ba9:	00 00                	add    %al,(%eax)
     bab:	00 1e                	add    %bl,(%esi)
     bad:	0b 00                	or     (%eax),%eax
     baf:	00 40 00             	add    %al,0x0(%eax)
     bb2:	00 00                	add    %al,(%eax)
     bb4:	01 00                	add    %eax,(%eax)
     bb6:	00 00                	add    %al,(%eax)
     bb8:	29 0b                	sub    %ecx,(%ebx)
     bba:	00 00                	add    %al,(%eax)
     bbc:	24 00                	and    $0x0,%al
     bbe:	00 00                	add    %al,(%eax)
     bc0:	79 04                	jns    bc6 <bootmain-0x27f43a>
     bc2:	28 00                	sub    %al,(%eax)
     bc4:	00 00                	add    %al,(%eax)
     bc6:	00 00                	add    %al,(%eax)
     bc8:	44                   	inc    %esp
     bc9:	00 1b                	add    %bl,(%ebx)
	...
     bd3:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     bd7:	00 01                	add    %al,(%ecx)
     bd9:	00 00                	add    %al,(%eax)
     bdb:	00 00                	add    %al,(%eax)
     bdd:	00 00                	add    %al,(%eax)
     bdf:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     be3:	00 06                	add    %al,(%esi)
     be5:	00 00                	add    %al,(%eax)
     be7:	00 00                	add    %al,(%eax)
     be9:	00 00                	add    %al,(%eax)
     beb:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     bef:	00 0a                	add    %cl,(%edx)
     bf1:	00 00                	add    %al,(%eax)
     bf3:	00 00                	add    %al,(%eax)
     bf5:	00 00                	add    %al,(%eax)
     bf7:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     bfb:	00 0f                	add    %cl,(%edi)
     bfd:	00 00                	add    %al,(%eax)
     bff:	00 00                	add    %al,(%eax)
     c01:	00 00                	add    %al,(%eax)
     c03:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     c07:	00 12                	add    %dl,(%edx)
     c09:	00 00                	add    %al,(%eax)
     c0b:	00 00                	add    %al,(%eax)
     c0d:	00 00                	add    %al,(%eax)
     c0f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     c13:	00 15 00 00 00 00    	add    %dl,0x0
     c19:	00 00                	add    %al,(%eax)
     c1b:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     c1f:	00 1a                	add    %bl,(%edx)
     c21:	00 00                	add    %al,(%eax)
     c23:	00 00                	add    %al,(%eax)
     c25:	00 00                	add    %al,(%eax)
     c27:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
     c2b:	00 2a                	add    %ch,(%edx)
     c2d:	00 00                	add    %al,(%eax)
     c2f:	00 3e                	add    %bh,(%esi)
     c31:	0b 00                	or     (%eax),%eax
     c33:	00 80 00 00 00 d0    	add    %al,-0x30000000(%eax)
     c39:	ff                   	(bad)  
     c3a:	ff                   	(bad)  
     c3b:	ff 00                	incl   (%eax)
     c3d:	00 00                	add    %al,(%eax)
     c3f:	00 c0                	add    %al,%al
	...
     c49:	00 00                	add    %al,(%eax)
     c4b:	00 e0                	add    %ah,%al
     c4d:	00 00                	add    %al,(%eax)
     c4f:	00 31                	add    %dh,(%ecx)
     c51:	00 00                	add    %al,(%eax)
     c53:	00 63 0b             	add    %ah,0xb(%ebx)
     c56:	00 00                	add    %al,(%eax)
     c58:	24 00                	and    $0x0,%al
     c5a:	00 00                	add    %al,(%eax)
     c5c:	aa                   	stos   %al,%es:(%edi)
     c5d:	04 28                	add    $0x28,%al
     c5f:	00 74 0b 00          	add    %dh,0x0(%ebx,%ecx,1)
     c63:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     c69:	00 00                	add    %al,(%eax)
     c6b:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
     c71:	00 00                	add    %al,(%eax)
     c73:	00 0c 00             	add    %cl,(%eax,%eax,1)
     c76:	00 00                	add    %al,(%eax)
     c78:	a2 0a 00 00 a0       	mov    %al,0xa000000a
     c7d:	00 00                	add    %al,(%eax)
     c7f:	00 10                	add    %dl,(%eax)
     c81:	00 00                	add    %al,(%eax)
     c83:	00 8d 0b 00 00 a0    	add    %cl,-0x5ffffff5(%ebp)
     c89:	00 00                	add    %al,(%eax)
     c8b:	00 14 00             	add    %dl,(%eax,%eax,1)
     c8e:	00 00                	add    %al,(%eax)
     c90:	97                   	xchg   %eax,%edi
     c91:	0b 00                	or     (%eax),%eax
     c93:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     c99:	00 00                	add    %al,(%eax)
     c9b:	00 a1 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ecx)
     ca1:	00 00                	add    %al,(%eax)
     ca3:	00 1c 00             	add    %bl,(%eax,%eax,1)
     ca6:	00 00                	add    %al,(%eax)
     ca8:	ab                   	stos   %eax,%es:(%edi)
     ca9:	0b 00                	or     (%eax),%eax
     cab:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     cb1:	00 00                	add    %al,(%eax)
     cb3:	00 00                	add    %al,(%eax)
     cb5:	00 00                	add    %al,(%eax)
     cb7:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
	...
     cc3:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     cc7:	00 0a                	add    %cl,(%edx)
     cc9:	00 00                	add    %al,(%eax)
     ccb:	00 00                	add    %al,(%eax)
     ccd:	00 00                	add    %al,(%eax)
     ccf:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     cd3:	00 13                	add    %dl,(%ebx)
     cd5:	00 00                	add    %al,(%eax)
     cd7:	00 00                	add    %al,(%eax)
     cd9:	00 00                	add    %al,(%eax)
     cdb:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     cdf:	00 18                	add    %bl,(%eax)
     ce1:	00 00                	add    %al,(%eax)
     ce3:	00 00                	add    %al,(%eax)
     ce5:	00 00                	add    %al,(%eax)
     ce7:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     ceb:	00 1b                	add    %bl,(%ebx)
     ced:	00 00                	add    %al,(%eax)
     cef:	00 00                	add    %al,(%eax)
     cf1:	00 00                	add    %al,(%eax)
     cf3:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     cf7:	00 20                	add    %ah,(%eax)
     cf9:	00 00                	add    %al,(%eax)
     cfb:	00 00                	add    %al,(%eax)
     cfd:	00 00                	add    %al,(%eax)
     cff:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     d03:	00 23                	add    %ah,(%ebx)
     d05:	00 00                	add    %al,(%eax)
     d07:	00 00                	add    %al,(%eax)
     d09:	00 00                	add    %al,(%eax)
     d0b:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     d0f:	00 26                	add    %ah,(%esi)
     d11:	00 00                	add    %al,(%eax)
     d13:	00 00                	add    %al,(%eax)
     d15:	00 00                	add    %al,(%eax)
     d17:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
     d1b:	00 2c 00             	add    %ch,(%eax,%eax,1)
     d1e:	00 00                	add    %al,(%eax)
     d20:	b5 0b                	mov    $0xb,%ch
     d22:	00 00                	add    %al,(%eax)
     d24:	40                   	inc    %eax
     d25:	00 00                	add    %al,(%eax)
     d27:	00 03                	add    %al,(%ebx)
     d29:	00 00                	add    %al,(%eax)
     d2b:	00 c3                	add    %al,%bl
     d2d:	0b 00                	or     (%eax),%eax
     d2f:	00 40 00             	add    %al,0x0(%eax)
     d32:	00 00                	add    %al,(%eax)
     d34:	01 00                	add    %eax,(%eax)
     d36:	00 00                	add    %al,(%eax)
     d38:	cd 0b                	int    $0xb
     d3a:	00 00                	add    %al,(%eax)
     d3c:	24 00                	and    $0x0,%al
     d3e:	00 00                	add    %al,(%eax)
     d40:	d9 04 28             	flds   (%eax,%ebp,1)
     d43:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
     d49:	00 00                	add    %al,(%eax)
     d4b:	00 08                	add    %cl,(%eax)
     d4d:	00 00                	add    %al,(%eax)
     d4f:	00 8d 0b 00 00 a0    	add    %cl,-0x5ffffff5(%ebp)
     d55:	00 00                	add    %al,(%eax)
     d57:	00 0c 00             	add    %cl,(%eax,%eax,1)
     d5a:	00 00                	add    %al,(%eax)
     d5c:	97                   	xchg   %eax,%edi
     d5d:	0b 00                	or     (%eax),%eax
     d5f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     d65:	00 00                	add    %al,(%eax)
     d67:	00 a1 0b 00 00 a0    	add    %ah,-0x5ffffff5(%ecx)
     d6d:	00 00                	add    %al,(%eax)
     d6f:	00 14 00             	add    %dl,(%eax,%eax,1)
     d72:	00 00                	add    %al,(%eax)
     d74:	ab                   	stos   %eax,%es:(%edi)
     d75:	0b 00                	or     (%eax),%eax
     d77:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     d7d:	00 00                	add    %al,(%eax)
     d7f:	00 00                	add    %al,(%eax)
     d81:	00 00                	add    %al,(%eax)
     d83:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
     d8f:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     d93:	00 03                	add    %al,(%ebx)
     d95:	00 00                	add    %al,(%eax)
     d97:	00 00                	add    %al,(%eax)
     d99:	00 00                	add    %al,(%eax)
     d9b:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     d9f:	00 26                	add    %ah,(%esi)
     da1:	00 00                	add    %al,(%eax)
     da3:	00 dd                	add    %bl,%ch
     da5:	0b 00                	or     (%eax),%eax
     da7:	00 24 00             	add    %ah,(%eax,%eax,1)
     daa:	00 00                	add    %al,(%eax)
     dac:	01 05 28 00 f2 0b    	add    %eax,0xbf20028
     db2:	00 00                	add    %al,(%eax)
     db4:	a0 00 00 00 08       	mov    0x8000000,%al
     db9:	00 00                	add    %al,(%eax)
     dbb:	00 00                	add    %al,(%eax)
     dbd:	00 00                	add    %al,(%eax)
     dbf:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
	...
     dcb:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
     dcf:	00 04 00             	add    %al,(%eax,%eax,1)
     dd2:	00 00                	add    %al,(%eax)
     dd4:	00 00                	add    %al,(%eax)
     dd6:	00 00                	add    %al,(%eax)
     dd8:	44                   	inc    %esp
     dd9:	00 67 00             	add    %ah,0x0(%edi)
     ddc:	07                   	pop    %es
     ddd:	00 00                	add    %al,(%eax)
     ddf:	00 00                	add    %al,(%eax)
     de1:	00 00                	add    %al,(%eax)
     de3:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
     de7:	00 22                	add    %ah,(%edx)
     de9:	00 00                	add    %al,(%eax)
     deb:	00 00                	add    %al,(%eax)
     ded:	00 00                	add    %al,(%eax)
     def:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
     df3:	00 40 00             	add    %al,0x0(%eax)
     df6:	00 00                	add    %al,(%eax)
     df8:	00 00                	add    %al,(%eax)
     dfa:	00 00                	add    %al,(%eax)
     dfc:	44                   	inc    %esp
     dfd:	00 6b 00             	add    %ch,0x0(%ebx)
     e00:	61                   	popa   
     e01:	00 00                	add    %al,(%eax)
     e03:	00 00                	add    %al,(%eax)
     e05:	00 00                	add    %al,(%eax)
     e07:	00 44 00 6f          	add    %al,0x6f(%eax,%eax,1)
     e0b:	00 7f 00             	add    %bh,0x0(%edi)
     e0e:	00 00                	add    %al,(%eax)
     e10:	00 00                	add    %al,(%eax)
     e12:	00 00                	add    %al,(%eax)
     e14:	44                   	inc    %esp
     e15:	00 70 00             	add    %dh,0x0(%eax)
     e18:	9d                   	popf   
     e19:	00 00                	add    %al,(%eax)
     e1b:	00 00                	add    %al,(%eax)
     e1d:	00 00                	add    %al,(%eax)
     e1f:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     e23:	00 b8 00 00 00 00    	add    %bh,0x0(%eax)
     e29:	00 00                	add    %al,(%eax)
     e2b:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     e2f:	00 d6                	add    %dl,%dh
     e31:	00 00                	add    %al,(%eax)
     e33:	00 00                	add    %al,(%eax)
     e35:	00 00                	add    %al,(%eax)
     e37:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     e3b:	00 f1                	add    %dh,%cl
     e3d:	00 00                	add    %al,(%eax)
     e3f:	00 00                	add    %al,(%eax)
     e41:	00 00                	add    %al,(%eax)
     e43:	00 44 00 74          	add    %al,0x74(%eax,%eax,1)
     e47:	00 0f                	add    %cl,(%edi)
     e49:	01 00                	add    %eax,(%eax)
     e4b:	00 00                	add    %al,(%eax)
     e4d:	00 00                	add    %al,(%eax)
     e4f:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     e53:	00 2a                	add    %ch,(%edx)
     e55:	01 00                	add    %eax,(%eax)
     e57:	00 00                	add    %al,(%eax)
     e59:	00 00                	add    %al,(%eax)
     e5b:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
     e5f:	00 4e 01             	add    %cl,0x1(%esi)
     e62:	00 00                	add    %al,(%eax)
     e64:	00 00                	add    %al,(%eax)
     e66:	00 00                	add    %al,(%eax)
     e68:	44                   	inc    %esp
     e69:	00 7a 00             	add    %bh,0x0(%edx)
     e6c:	6f                   	outsl  %ds:(%esi),(%dx)
     e6d:	01 00                	add    %eax,(%eax)
     e6f:	00 00                	add    %al,(%eax)
     e71:	00 00                	add    %al,(%eax)
     e73:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
     e77:	00 93 01 00 00 00    	add    %dl,0x1(%ebx)
     e7d:	00 00                	add    %al,(%eax)
     e7f:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
     e83:	00 b7 01 00 00 fb    	add    %dh,-0x4ffffff(%edi)
     e89:	0b 00                	or     (%eax),%eax
     e8b:	00 40 00             	add    %al,0x0(%eax)
     e8e:	00 00                	add    %al,(%eax)
     e90:	03 00                	add    (%eax),%eax
     e92:	00 00                	add    %al,(%eax)
     e94:	04 0c                	add    $0xc,%al
     e96:	00 00                	add    %al,(%eax)
     e98:	24 00                	and    $0x0,%al
     e9a:	00 00                	add    %al,(%eax)
     e9c:	bd 06 28 00 00       	mov    $0x2806,%ebp
     ea1:	00 00                	add    %al,(%eax)
     ea3:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
	...
     eaf:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
     eb3:	00 03                	add    %al,(%ebx)
     eb5:	00 00                	add    %al,(%eax)
     eb7:	00 00                	add    %al,(%eax)
     eb9:	00 00                	add    %al,(%eax)
     ebb:	00 44 00 87          	add    %al,-0x79(%eax,%eax,1)
     ebf:	00 18                	add    %bl,(%eax)
     ec1:	00 00                	add    %al,(%eax)
     ec3:	00 00                	add    %al,(%eax)
     ec5:	00 00                	add    %al,(%eax)
     ec7:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
     ecb:	00 30                	add    %dh,(%eax)
     ecd:	00 00                	add    %al,(%eax)
     ecf:	00 00                	add    %al,(%eax)
     ed1:	00 00                	add    %al,(%eax)
     ed3:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     ed7:	00 4b 00             	add    %cl,0x0(%ebx)
     eda:	00 00                	add    %al,(%eax)
     edc:	00 00                	add    %al,(%eax)
     ede:	00 00                	add    %al,(%eax)
     ee0:	44                   	inc    %esp
     ee1:	00 8d 00 63 00 00    	add    %cl,0x6300(%ebp)
     ee7:	00 00                	add    %al,(%eax)
     ee9:	00 00                	add    %al,(%eax)
     eeb:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
     eef:	00 7b 00             	add    %bh,0x0(%ebx)
     ef2:	00 00                	add    %al,(%eax)
     ef4:	00 00                	add    %al,(%eax)
     ef6:	00 00                	add    %al,(%eax)
     ef8:	44                   	inc    %esp
     ef9:	00 8f 00 90 00 00    	add    %cl,0x9000(%edi)
     eff:	00 00                	add    %al,(%eax)
     f01:	00 00                	add    %al,(%eax)
     f03:	00 44 00 90          	add    %al,-0x70(%eax,%eax,1)
     f07:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
     f0d:	00 00                	add    %al,(%eax)
     f0f:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
     f13:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     f19:	00 00                	add    %al,(%eax)
     f1b:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
     f1f:	00 d5                	add    %dl,%ch
     f21:	00 00                	add    %al,(%eax)
     f23:	00 00                	add    %al,(%eax)
     f25:	00 00                	add    %al,(%eax)
     f27:	00 44 00 96          	add    %al,-0x6a(%eax,%eax,1)
     f2b:	00 ea                	add    %ch,%dl
     f2d:	00 00                	add    %al,(%eax)
     f2f:	00 00                	add    %al,(%eax)
     f31:	00 00                	add    %al,(%eax)
     f33:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
     f37:	00 08                	add    %cl,(%eax)
     f39:	01 00                	add    %eax,(%eax)
     f3b:	00 00                	add    %al,(%eax)
     f3d:	00 00                	add    %al,(%eax)
     f3f:	00 44 00 98          	add    %al,-0x68(%eax,%eax,1)
     f43:	00 23                	add    %ah,(%ebx)
     f45:	01 00                	add    %eax,(%eax)
     f47:	00 00                	add    %al,(%eax)
     f49:	00 00                	add    %al,(%eax)
     f4b:	00 44 00 99          	add    %al,-0x67(%eax,%eax,1)
     f4f:	00 41 01             	add    %al,0x1(%ecx)
     f52:	00 00                	add    %al,(%eax)
     f54:	00 00                	add    %al,(%eax)
     f56:	00 00                	add    %al,(%eax)
     f58:	44                   	inc    %esp
     f59:	00 9a 00 5f 01 00    	add    %bl,0x15f00(%edx)
     f5f:	00 18                	add    %bl,(%eax)
     f61:	0c 00                	or     $0x0,%al
     f63:	00 24 00             	add    %ah,(%eax,%eax,1)
     f66:	00 00                	add    %al,(%eax)
     f68:	1e                   	push   %ds
     f69:	08 28                	or     %ch,(%eax)
     f6b:	00 2c 0c             	add    %ch,(%esp,%ecx,1)
     f6e:	00 00                	add    %al,(%eax)
     f70:	a0 00 00 00 08       	mov    0x8000000,%al
     f75:	00 00                	add    %al,(%eax)
     f77:	00 00                	add    %al,(%eax)
     f79:	00 00                	add    %al,(%eax)
     f7b:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
	...
     f87:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
     f8b:	00 03                	add    %al,(%ebx)
     f8d:	00 00                	add    %al,(%eax)
     f8f:	00 00                	add    %al,(%eax)
     f91:	00 00                	add    %al,(%eax)
     f93:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
     f97:	00 06                	add    %al,(%esi)
     f99:	00 00                	add    %al,(%eax)
     f9b:	00 00                	add    %al,(%eax)
     f9d:	00 00                	add    %al,(%eax)
     f9f:	00 44 00 a0          	add    %al,-0x60(%eax,%eax,1)
     fa3:	00 0d 00 00 00 00    	add    %cl,0x0
     fa9:	00 00                	add    %al,(%eax)
     fab:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
     faf:	00 11                	add    %dl,(%ecx)
     fb1:	00 00                	add    %al,(%eax)
     fb3:	00 00                	add    %al,(%eax)
     fb5:	00 00                	add    %al,(%eax)
     fb7:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
     fbb:	00 17                	add    %dl,(%edi)
     fbd:	00 00                	add    %al,(%eax)
     fbf:	00 00                	add    %al,(%eax)
     fc1:	00 00                	add    %al,(%eax)
     fc3:	00 44 00 a4          	add    %al,-0x5c(%eax,%eax,1)
     fc7:	00 1d 00 00 00 41    	add    %bl,0x41000000
     fcd:	0c 00                	or     $0x0,%al
     fcf:	00 40 00             	add    %al,0x0(%eax)
     fd2:	00 00                	add    %al,(%eax)
     fd4:	00 00                	add    %al,(%eax)
     fd6:	00 00                	add    %al,(%eax)
     fd8:	4f                   	dec    %edi
     fd9:	0c 00                	or     $0x0,%al
     fdb:	00 24 00             	add    %ah,(%eax,%eax,1)
     fde:	00 00                	add    %al,(%eax)
     fe0:	3d 08 28 00 62       	cmp    $0x62002808,%eax
     fe5:	0c 00                	or     $0x0,%al
     fe7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     fed:	00 00                	add    %al,(%eax)
     fef:	00 6f 0c             	add    %ch,0xc(%edi)
     ff2:	00 00                	add    %al,(%eax)
     ff4:	a0 00 00 00 0c       	mov    0xc000000,%al
     ff9:	00 00                	add    %al,(%eax)
     ffb:	00 00                	add    %al,(%eax)
     ffd:	00 00                	add    %al,(%eax)
     fff:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
	...
    100b:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    100f:	00 0d 00 00 00 00    	add    %cl,0x0
    1015:	00 00                	add    %al,(%eax)
    1017:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    101b:	00 0f                	add    %cl,(%edi)
    101d:	00 00                	add    %al,(%eax)
    101f:	00 00                	add    %al,(%eax)
    1021:	00 00                	add    %al,(%eax)
    1023:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
    1027:	00 11                	add    %dl,(%ecx)
    1029:	00 00                	add    %al,(%eax)
    102b:	00 00                	add    %al,(%eax)
    102d:	00 00                	add    %al,(%eax)
    102f:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
    1033:	00 27                	add    %ah,(%edi)
    1035:	00 00                	add    %al,(%eax)
    1037:	00 00                	add    %al,(%eax)
    1039:	00 00                	add    %al,(%eax)
    103b:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    103f:	00 2d 00 00 00 00    	add    %ch,0x0
    1045:	00 00                	add    %al,(%eax)
    1047:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
    104b:	00 34 00             	add    %dh,(%eax,%eax,1)
    104e:	00 00                	add    %al,(%eax)
    1050:	00 00                	add    %al,(%eax)
    1052:	00 00                	add    %al,(%eax)
    1054:	44                   	inc    %esp
    1055:	00 c2                	add    %al,%dl
    1057:	00 38                	add    %bh,(%eax)
    1059:	00 00                	add    %al,(%eax)
    105b:	00 00                	add    %al,(%eax)
    105d:	00 00                	add    %al,(%eax)
    105f:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    1063:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1067:	00 00                	add    %al,(%eax)
    1069:	00 00                	add    %al,(%eax)
    106b:	00 44 00 d0          	add    %al,-0x30(%eax,%eax,1)
    106f:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1073:	00 79 0c             	add    %bh,0xc(%ecx)
    1076:	00 00                	add    %al,(%eax)
    1078:	26 00 00             	add    %al,%es:(%eax)
    107b:	00 28                	add    %ch,(%eax)
    107d:	2f                   	das    
    107e:	28 00                	sub    %al,(%eax)
    1080:	af                   	scas   %es:(%edi),%eax
    1081:	0c 00                	or     $0x0,%al
    1083:	00 40 00             	add    %al,0x0(%eax)
    1086:	00 00                	add    %al,(%eax)
    1088:	00 00                	add    %al,(%eax)
    108a:	00 00                	add    %al,(%eax)
    108c:	b8 0c 00 00 40       	mov    $0x4000000c,%eax
    1091:	00 00                	add    %al,(%eax)
    1093:	00 06                	add    %al,(%esi)
    1095:	00 00                	add    %al,(%eax)
    1097:	00 00                	add    %al,(%eax)
    1099:	00 00                	add    %al,(%eax)
    109b:	00 c0                	add    %al,%al
	...
    10a5:	00 00                	add    %al,(%eax)
    10a7:	00 e0                	add    %ah,%al
    10a9:	00 00                	add    %al,(%eax)
    10ab:	00 50 00             	add    %dl,0x0(%eax)
    10ae:	00 00                	add    %al,(%eax)
    10b0:	c2 0c 00             	ret    $0xc
    10b3:	00 24 00             	add    %ah,(%eax,%eax,1)
    10b6:	00 00                	add    %al,(%eax)
    10b8:	8d 08                	lea    (%eax),%ecx
    10ba:	28 00                	sub    %al,(%eax)
    10bc:	d8 0c 00             	fmuls  (%eax,%eax,1)
    10bf:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    10c5:	00 00                	add    %al,(%eax)
    10c7:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    10cd:	00 00                	add    %al,(%eax)
    10cf:	00 0c 00             	add    %cl,(%eax,%eax,1)
    10d2:	00 00                	add    %al,(%eax)
    10d4:	e4 0c                	in     $0xc,%al
    10d6:	00 00                	add    %al,(%eax)
    10d8:	a0 00 00 00 10       	mov    0x10000000,%al
    10dd:	00 00                	add    %al,(%eax)
    10df:	00 f2                	add    %dh,%dl
    10e1:	0c 00                	or     $0x0,%al
    10e3:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    10e9:	00 00                	add    %al,(%eax)
    10eb:	00 00                	add    %al,(%eax)
    10ed:	0d 00 00 a0 00       	or     $0xa00000,%eax
    10f2:	00 00                	add    %al,(%eax)
    10f4:	18 00                	sbb    %al,(%eax)
    10f6:	00 00                	add    %al,(%eax)
    10f8:	0b 0d 00 00 a0 00    	or     0xa00000,%ecx
    10fe:	00 00                	add    %al,(%eax)
    1100:	1c 00                	sbb    $0x0,%al
    1102:	00 00                	add    %al,(%eax)
    1104:	16                   	push   %ss
    1105:	0d 00 00 a0 00       	or     $0xa00000,%eax
    110a:	00 00                	add    %al,(%eax)
    110c:	20 00                	and    %al,(%eax)
    110e:	00 00                	add    %al,(%eax)
    1110:	21 0d 00 00 a0 00    	and    %ecx,0xa00000
    1116:	00 00                	add    %al,(%eax)
    1118:	24 00                	and    $0x0,%al
    111a:	00 00                	add    %al,(%eax)
    111c:	00 00                	add    %al,(%eax)
    111e:	00 00                	add    %al,(%eax)
    1120:	44                   	inc    %esp
    1121:	00 d3                	add    %dl,%bl
	...
    112b:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    112f:	00 07                	add    %al,(%edi)
    1131:	00 00                	add    %al,(%eax)
    1133:	00 00                	add    %al,(%eax)
    1135:	00 00                	add    %al,(%eax)
    1137:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    113b:	00 09                	add    %cl,(%ecx)
    113d:	00 00                	add    %al,(%eax)
    113f:	00 00                	add    %al,(%eax)
    1141:	00 00                	add    %al,(%eax)
    1143:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    1147:	00 17                	add    %dl,(%edi)
    1149:	00 00                	add    %al,(%eax)
    114b:	00 00                	add    %al,(%eax)
    114d:	00 00                	add    %al,(%eax)
    114f:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    1153:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1156:	00 00                	add    %al,(%eax)
    1158:	00 00                	add    %al,(%eax)
    115a:	00 00                	add    %al,(%eax)
    115c:	44                   	inc    %esp
    115d:	00 d7                	add    %dl,%bh
    115f:	00 1e                	add    %bl,(%esi)
    1161:	00 00                	add    %al,(%eax)
    1163:	00 00                	add    %al,(%eax)
    1165:	00 00                	add    %al,(%eax)
    1167:	00 44 00 d9          	add    %al,-0x27(%eax,%eax,1)
    116b:	00 23                	add    %ah,(%ebx)
    116d:	00 00                	add    %al,(%eax)
    116f:	00 00                	add    %al,(%eax)
    1171:	00 00                	add    %al,(%eax)
    1173:	00 44 00 d7          	add    %al,-0x29(%eax,%eax,1)
    1177:	00 29                	add    %ch,(%ecx)
    1179:	00 00                	add    %al,(%eax)
    117b:	00 00                	add    %al,(%eax)
    117d:	00 00                	add    %al,(%eax)
    117f:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    1183:	00 2c 00             	add    %ch,(%eax,%eax,1)
    1186:	00 00                	add    %al,(%eax)
    1188:	00 00                	add    %al,(%eax)
    118a:	00 00                	add    %al,(%eax)
    118c:	44                   	inc    %esp
    118d:	00 dd                	add    %bl,%ch
    118f:	00 35 00 00 00 af    	add    %dh,0xaf000000
    1195:	0c 00                	or     $0x0,%al
    1197:	00 40 00             	add    %al,0x0(%eax)
    119a:	00 00                	add    %al,(%eax)
    119c:	02 00                	add    (%eax),%al
    119e:	00 00                	add    %al,(%eax)
    11a0:	2f                   	das    
    11a1:	0d 00 00 40 00       	or     $0x400000,%eax
    11a6:	00 00                	add    %al,(%eax)
    11a8:	06                   	push   %es
    11a9:	00 00                	add    %al,(%eax)
    11ab:	00 00                	add    %al,(%eax)
    11ad:	00 00                	add    %al,(%eax)
    11af:	00 c0                	add    %al,%al
	...
    11b9:	00 00                	add    %al,(%eax)
    11bb:	00 e0                	add    %ah,%al
    11bd:	00 00                	add    %al,(%eax)
    11bf:	00 39                	add    %bh,(%ecx)
    11c1:	00 00                	add    %al,(%eax)
    11c3:	00 00                	add    %al,(%eax)
    11c5:	00 00                	add    %al,(%eax)
    11c7:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    11cb:	00 c6                	add    %al,%dh
    11cd:	08 28                	or     %ch,(%eax)
    11cf:	00 38                	add    %bh,(%eax)
    11d1:	0d 00 00 64 00       	or     $0x640000,%eax
    11d6:	02 00                	add    (%eax),%al
    11d8:	c6                   	(bad)  
    11d9:	08 28                	or     %ch,(%eax)
    11db:	00 08                	add    %cl,(%eax)
    11dd:	00 00                	add    %al,(%eax)
    11df:	00 3c 00             	add    %bh,(%eax,%eax,1)
    11e2:	00 00                	add    %al,(%eax)
    11e4:	00 00                	add    %al,(%eax)
    11e6:	00 00                	add    %al,(%eax)
    11e8:	17                   	pop    %ss
    11e9:	00 00                	add    %al,(%eax)
    11eb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    11f1:	00 00                	add    %al,(%eax)
    11f3:	00 41 00             	add    %al,0x0(%ecx)
    11f6:	00 00                	add    %al,(%eax)
    11f8:	80 00 00             	addb   $0x0,(%eax)
    11fb:	00 00                	add    %al,(%eax)
    11fd:	00 00                	add    %al,(%eax)
    11ff:	00 5b 00             	add    %bl,0x0(%ebx)
    1202:	00 00                	add    %al,(%eax)
    1204:	80 00 00             	addb   $0x0,(%eax)
    1207:	00 00                	add    %al,(%eax)
    1209:	00 00                	add    %al,(%eax)
    120b:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1211:	00 00                	add    %al,(%eax)
    1213:	00 00                	add    %al,(%eax)
    1215:	00 00                	add    %al,(%eax)
    1217:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    121d:	00 00                	add    %al,(%eax)
    121f:	00 00                	add    %al,(%eax)
    1221:	00 00                	add    %al,(%eax)
    1223:	00 e1                	add    %ah,%cl
    1225:	00 00                	add    %al,(%eax)
    1227:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    122d:	00 00                	add    %al,(%eax)
    122f:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1232:	00 00                	add    %al,(%eax)
    1234:	80 00 00             	addb   $0x0,(%eax)
    1237:	00 00                	add    %al,(%eax)
    1239:	00 00                	add    %al,(%eax)
    123b:	00 37                	add    %dh,(%edi)
    123d:	01 00                	add    %eax,(%eax)
    123f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1245:	00 00                	add    %al,(%eax)
    1247:	00 5d 01             	add    %bl,0x1(%ebp)
    124a:	00 00                	add    %al,(%eax)
    124c:	80 00 00             	addb   $0x0,(%eax)
    124f:	00 00                	add    %al,(%eax)
    1251:	00 00                	add    %al,(%eax)
    1253:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1259:	00 00                	add    %al,(%eax)
    125b:	00 00                	add    %al,(%eax)
    125d:	00 00                	add    %al,(%eax)
    125f:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1265:	00 00                	add    %al,(%eax)
    1267:	00 00                	add    %al,(%eax)
    1269:	00 00                	add    %al,(%eax)
    126b:	00 d2                	add    %dl,%dl
    126d:	01 00                	add    %eax,(%eax)
    126f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1275:	00 00                	add    %al,(%eax)
    1277:	00 ec                	add    %ch,%ah
    1279:	01 00                	add    %eax,(%eax)
    127b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1281:	00 00                	add    %al,(%eax)
    1283:	00 07                	add    %al,(%edi)
    1285:	02 00                	add    (%eax),%al
    1287:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    128d:	00 00                	add    %al,(%eax)
    128f:	00 28                	add    %ch,(%eax)
    1291:	02 00                	add    (%eax),%al
    1293:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1299:	00 00                	add    %al,(%eax)
    129b:	00 47 02             	add    %al,0x2(%edi)
    129e:	00 00                	add    %al,(%eax)
    12a0:	80 00 00             	addb   $0x0,(%eax)
    12a3:	00 00                	add    %al,(%eax)
    12a5:	00 00                	add    %al,(%eax)
    12a7:	00 66 02             	add    %ah,0x2(%esi)
    12aa:	00 00                	add    %al,(%eax)
    12ac:	80 00 00             	addb   $0x0,(%eax)
    12af:	00 00                	add    %al,(%eax)
    12b1:	00 00                	add    %al,(%eax)
    12b3:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    12b9:	00 00                	add    %al,(%eax)
    12bb:	00 00                	add    %al,(%eax)
    12bd:	00 00                	add    %al,(%eax)
    12bf:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    12c5:	00 00                	add    %al,(%eax)
    12c7:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    12cd:	02 00                	add    (%eax),%al
    12cf:	00 c2                	add    %al,%dl
    12d1:	00 00                	add    %al,(%eax)
    12d3:	00 00                	add    %al,(%eax)
    12d5:	00 00                	add    %al,(%eax)
    12d7:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    12dd:	00 00                	add    %al,(%eax)
    12df:	00 37                	add    %dh,(%edi)
    12e1:	53                   	push   %ebx
    12e2:	00 00                	add    %al,(%eax)
    12e4:	29 04 00             	sub    %eax,(%eax,%eax,1)
    12e7:	00 c2                	add    %al,%dl
    12e9:	00 00                	add    %al,(%eax)
    12eb:	00 65 97             	add    %ah,-0x69(%ebp)
    12ee:	00 00                	add    %al,(%eax)
    12f0:	00 00                	add    %al,(%eax)
    12f2:	00 00                	add    %al,(%eax)
    12f4:	64 00 00             	add    %al,%fs:(%eax)
    12f7:	00 c6                	add    %al,%dh
    12f9:	08 28                	or     %ch,(%eax)
    12fb:	00 3f                	add    %bh,(%edi)
    12fd:	0d 00 00 64 00       	or     $0x640000,%eax
    1302:	02 00                	add    (%eax),%al
    1304:	c6                   	(bad)  
    1305:	08 28                	or     %ch,(%eax)
    1307:	00 08                	add    %cl,(%eax)
    1309:	00 00                	add    %al,(%eax)
    130b:	00 3c 00             	add    %bh,(%eax,%eax,1)
    130e:	00 00                	add    %al,(%eax)
    1310:	00 00                	add    %al,(%eax)
    1312:	00 00                	add    %al,(%eax)
    1314:	17                   	pop    %ss
    1315:	00 00                	add    %al,(%eax)
    1317:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    131d:	00 00                	add    %al,(%eax)
    131f:	00 41 00             	add    %al,0x0(%ecx)
    1322:	00 00                	add    %al,(%eax)
    1324:	80 00 00             	addb   $0x0,(%eax)
    1327:	00 00                	add    %al,(%eax)
    1329:	00 00                	add    %al,(%eax)
    132b:	00 5b 00             	add    %bl,0x0(%ebx)
    132e:	00 00                	add    %al,(%eax)
    1330:	80 00 00             	addb   $0x0,(%eax)
    1333:	00 00                	add    %al,(%eax)
    1335:	00 00                	add    %al,(%eax)
    1337:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    133d:	00 00                	add    %al,(%eax)
    133f:	00 00                	add    %al,(%eax)
    1341:	00 00                	add    %al,(%eax)
    1343:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1349:	00 00                	add    %al,(%eax)
    134b:	00 00                	add    %al,(%eax)
    134d:	00 00                	add    %al,(%eax)
    134f:	00 e1                	add    %ah,%cl
    1351:	00 00                	add    %al,(%eax)
    1353:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1359:	00 00                	add    %al,(%eax)
    135b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    135e:	00 00                	add    %al,(%eax)
    1360:	80 00 00             	addb   $0x0,(%eax)
    1363:	00 00                	add    %al,(%eax)
    1365:	00 00                	add    %al,(%eax)
    1367:	00 37                	add    %dh,(%edi)
    1369:	01 00                	add    %eax,(%eax)
    136b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1371:	00 00                	add    %al,(%eax)
    1373:	00 5d 01             	add    %bl,0x1(%ebp)
    1376:	00 00                	add    %al,(%eax)
    1378:	80 00 00             	addb   $0x0,(%eax)
    137b:	00 00                	add    %al,(%eax)
    137d:	00 00                	add    %al,(%eax)
    137f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1385:	00 00                	add    %al,(%eax)
    1387:	00 00                	add    %al,(%eax)
    1389:	00 00                	add    %al,(%eax)
    138b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1391:	00 00                	add    %al,(%eax)
    1393:	00 00                	add    %al,(%eax)
    1395:	00 00                	add    %al,(%eax)
    1397:	00 d2                	add    %dl,%dl
    1399:	01 00                	add    %eax,(%eax)
    139b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    13a1:	00 00                	add    %al,(%eax)
    13a3:	00 ec                	add    %ch,%ah
    13a5:	01 00                	add    %eax,(%eax)
    13a7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    13ad:	00 00                	add    %al,(%eax)
    13af:	00 07                	add    %al,(%edi)
    13b1:	02 00                	add    (%eax),%al
    13b3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    13b9:	00 00                	add    %al,(%eax)
    13bb:	00 28                	add    %ch,(%eax)
    13bd:	02 00                	add    (%eax),%al
    13bf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    13c5:	00 00                	add    %al,(%eax)
    13c7:	00 47 02             	add    %al,0x2(%edi)
    13ca:	00 00                	add    %al,(%eax)
    13cc:	80 00 00             	addb   $0x0,(%eax)
    13cf:	00 00                	add    %al,(%eax)
    13d1:	00 00                	add    %al,(%eax)
    13d3:	00 66 02             	add    %ah,0x2(%esi)
    13d6:	00 00                	add    %al,(%eax)
    13d8:	80 00 00             	addb   $0x0,(%eax)
    13db:	00 00                	add    %al,(%eax)
    13dd:	00 00                	add    %al,(%eax)
    13df:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    13e5:	00 00                	add    %al,(%eax)
    13e7:	00 00                	add    %al,(%eax)
    13e9:	00 00                	add    %al,(%eax)
    13eb:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    13f1:	00 00                	add    %al,(%eax)
    13f3:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    13f9:	02 00                	add    (%eax),%al
    13fb:	00 c2                	add    %al,%dl
    13fd:	00 00                	add    %al,(%eax)
    13ff:	00 00                	add    %al,(%eax)
    1401:	00 00                	add    %al,(%eax)
    1403:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    1409:	00 00                	add    %al,(%eax)
    140b:	00 37                	add    %dh,(%edi)
    140d:	53                   	push   %ebx
    140e:	00 00                	add    %al,(%eax)
    1410:	29 04 00             	sub    %eax,(%eax,%eax,1)
    1413:	00 c2                	add    %al,%dl
    1415:	00 00                	add    %al,(%eax)
    1417:	00 65 97             	add    %ah,-0x69(%ebp)
    141a:	00 00                	add    %al,(%eax)
    141c:	47                   	inc    %edi
    141d:	0d 00 00 24 00       	or     $0x240000,%eax
    1422:	00 00                	add    %al,(%eax)
    1424:	c6                   	(bad)  
    1425:	08 28                	or     %ch,(%eax)
    1427:	00 54 0d 00          	add    %dl,0x0(%ebp,%ecx,1)
    142b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1431:	00 00                	add    %al,(%eax)
    1433:	00 61 0d             	add    %ah,0xd(%ecx)
    1436:	00 00                	add    %al,(%eax)
    1438:	a0 00 00 00 0c       	mov    0xc000000,%al
    143d:	00 00                	add    %al,(%eax)
    143f:	00 00                	add    %al,(%eax)
    1441:	00 00                	add    %al,(%eax)
    1443:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
	...
    144f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1453:	00 01                	add    %al,(%ecx)
    1455:	00 00                	add    %al,(%eax)
    1457:	00 00                	add    %al,(%eax)
    1459:	00 00                	add    %al,(%eax)
    145b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    145f:	00 03                	add    %al,(%ebx)
    1461:	00 00                	add    %al,(%eax)
    1463:	00 00                	add    %al,(%eax)
    1465:	00 00                	add    %al,(%eax)
    1467:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    146b:	00 05 00 00 00 00    	add    %al,0x0
    1471:	00 00                	add    %al,(%eax)
    1473:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1477:	00 0a                	add    %cl,(%edx)
    1479:	00 00                	add    %al,(%eax)
    147b:	00 00                	add    %al,(%eax)
    147d:	00 00                	add    %al,(%eax)
    147f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1483:	00 10                	add    %dl,(%eax)
    1485:	00 00                	add    %al,(%eax)
    1487:	00 00                	add    %al,(%eax)
    1489:	00 00                	add    %al,(%eax)
    148b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    148f:	00 13                	add    %dl,(%ebx)
    1491:	00 00                	add    %al,(%eax)
    1493:	00 00                	add    %al,(%eax)
    1495:	00 00                	add    %al,(%eax)
    1497:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    149b:	00 16                	add    %dl,(%esi)
    149d:	00 00                	add    %al,(%eax)
    149f:	00 00                	add    %al,(%eax)
    14a1:	00 00                	add    %al,(%eax)
    14a3:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    14a7:	00 19                	add    %bl,(%ecx)
    14a9:	00 00                	add    %al,(%eax)
    14ab:	00 00                	add    %al,(%eax)
    14ad:	00 00                	add    %al,(%eax)
    14af:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    14b3:	00 1e                	add    %bl,(%esi)
    14b5:	00 00                	add    %al,(%eax)
    14b7:	00 00                	add    %al,(%eax)
    14b9:	00 00                	add    %al,(%eax)
    14bb:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    14bf:	00 22                	add    %ah,(%edx)
    14c1:	00 00                	add    %al,(%eax)
    14c3:	00 00                	add    %al,(%eax)
    14c5:	00 00                	add    %al,(%eax)
    14c7:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    14cb:	00 25 00 00 00 00    	add    %ah,0x0
    14d1:	00 00                	add    %al,(%eax)
    14d3:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    14d7:	00 27                	add    %ah,(%edi)
    14d9:	00 00                	add    %al,(%eax)
    14db:	00 00                	add    %al,(%eax)
    14dd:	00 00                	add    %al,(%eax)
    14df:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    14e3:	00 28                	add    %ch,(%eax)
    14e5:	00 00                	add    %al,(%eax)
    14e7:	00 00                	add    %al,(%eax)
    14e9:	00 00                	add    %al,(%eax)
    14eb:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    14ef:	00 2a                	add    %ch,(%edx)
    14f1:	00 00                	add    %al,(%eax)
    14f3:	00 00                	add    %al,(%eax)
    14f5:	00 00                	add    %al,(%eax)
    14f7:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    14fb:	00 38                	add    %bh,(%eax)
    14fd:	00 00                	add    %al,(%eax)
    14ff:	00 00                	add    %al,(%eax)
    1501:	00 00                	add    %al,(%eax)
    1503:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1507:	00 3a                	add    %bh,(%edx)
    1509:	00 00                	add    %al,(%eax)
    150b:	00 00                	add    %al,(%eax)
    150d:	00 00                	add    %al,(%eax)
    150f:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1513:	00 3d 00 00 00 00    	add    %bh,0x0
    1519:	00 00                	add    %al,(%eax)
    151b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    151f:	00 3f                	add    %bh,(%edi)
    1521:	00 00                	add    %al,(%eax)
    1523:	00 00                	add    %al,(%eax)
    1525:	00 00                	add    %al,(%eax)
    1527:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    152b:	00 41 00             	add    %al,0x0(%ecx)
    152e:	00 00                	add    %al,(%eax)
    1530:	00 00                	add    %al,(%eax)
    1532:	00 00                	add    %al,(%eax)
    1534:	44                   	inc    %esp
    1535:	00 1e                	add    %bl,(%esi)
    1537:	00 45 00             	add    %al,0x0(%ebp)
    153a:	00 00                	add    %al,(%eax)
    153c:	00 00                	add    %al,(%eax)
    153e:	00 00                	add    %al,(%eax)
    1540:	44                   	inc    %esp
    1541:	00 20                	add    %ah,(%eax)
    1543:	00 49 00             	add    %cl,0x0(%ecx)
    1546:	00 00                	add    %al,(%eax)
    1548:	00 00                	add    %al,(%eax)
    154a:	00 00                	add    %al,(%eax)
    154c:	44                   	inc    %esp
    154d:	00 21                	add    %ah,(%ecx)
    154f:	00 4a 00             	add    %cl,0x0(%edx)
    1552:	00 00                	add    %al,(%eax)
    1554:	00 00                	add    %al,(%eax)
    1556:	00 00                	add    %al,(%eax)
    1558:	44                   	inc    %esp
    1559:	00 24 00             	add    %ah,(%eax,%eax,1)
    155c:	56                   	push   %esi
    155d:	00 00                	add    %al,(%eax)
    155f:	00 00                	add    %al,(%eax)
    1561:	00 00                	add    %al,(%eax)
    1563:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    1567:	00 5a 00             	add    %bl,0x0(%edx)
    156a:	00 00                	add    %al,(%eax)
    156c:	6c                   	insb   (%dx),%es:(%edi)
    156d:	0d 00 00 80 00       	or     $0x800000,%eax
    1572:	00 00                	add    %al,(%eax)
    1574:	f6 ff                	idiv   %bh
    1576:	ff                   	(bad)  
    1577:	ff 8e 0d 00 00 40    	decl   0x4000000d(%esi)
    157d:	00 00                	add    %al,(%eax)
    157f:	00 02                	add    %al,(%edx)
    1581:	00 00                	add    %al,(%eax)
    1583:	00 9b 0d 00 00 40    	add    %bl,0x4000000d(%ebx)
    1589:	00 00                	add    %al,(%eax)
    158b:	00 03                	add    %al,(%ebx)
    158d:	00 00                	add    %al,(%eax)
    158f:	00 00                	add    %al,(%eax)
    1591:	00 00                	add    %al,(%eax)
    1593:	00 c0                	add    %al,%al
	...
    159d:	00 00                	add    %al,(%eax)
    159f:	00 e0                	add    %ah,%al
    15a1:	00 00                	add    %al,(%eax)
    15a3:	00 62 00             	add    %ah,0x0(%edx)
    15a6:	00 00                	add    %al,(%eax)
    15a8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    15a9:	0d 00 00 24 00       	or     $0x240000,%eax
    15ae:	00 00                	add    %al,(%eax)
    15b0:	28 09                	sub    %cl,(%ecx)
    15b2:	28 00                	sub    %al,(%eax)
    15b4:	b3 0d                	mov    $0xd,%bl
    15b6:	00 00                	add    %al,(%eax)
    15b8:	a0 00 00 00 08       	mov    0x8000000,%al
    15bd:	00 00                	add    %al,(%eax)
    15bf:	00 61 0d             	add    %ah,0xd(%ecx)
    15c2:	00 00                	add    %al,(%eax)
    15c4:	a0 00 00 00 0c       	mov    0xc000000,%al
    15c9:	00 00                	add    %al,(%eax)
    15cb:	00 00                	add    %al,(%eax)
    15cd:	00 00                	add    %al,(%eax)
    15cf:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
	...
    15db:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    15df:	00 01                	add    %al,(%ecx)
    15e1:	00 00                	add    %al,(%eax)
    15e3:	00 00                	add    %al,(%eax)
    15e5:	00 00                	add    %al,(%eax)
    15e7:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    15eb:	00 03                	add    %al,(%ebx)
    15ed:	00 00                	add    %al,(%eax)
    15ef:	00 00                	add    %al,(%eax)
    15f1:	00 00                	add    %al,(%eax)
    15f3:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    15f7:	00 05 00 00 00 00    	add    %al,0x0
    15fd:	00 00                	add    %al,(%eax)
    15ff:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    1603:	00 0a                	add    %cl,(%edx)
    1605:	00 00                	add    %al,(%eax)
    1607:	00 00                	add    %al,(%eax)
    1609:	00 00                	add    %al,(%eax)
    160b:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    160f:	00 10                	add    %dl,(%eax)
    1611:	00 00                	add    %al,(%eax)
    1613:	00 00                	add    %al,(%eax)
    1615:	00 00                	add    %al,(%eax)
    1617:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    161b:	00 13                	add    %dl,(%ebx)
    161d:	00 00                	add    %al,(%eax)
    161f:	00 00                	add    %al,(%eax)
    1621:	00 00                	add    %al,(%eax)
    1623:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    1627:	00 18                	add    %bl,(%eax)
    1629:	00 00                	add    %al,(%eax)
    162b:	00 00                	add    %al,(%eax)
    162d:	00 00                	add    %al,(%eax)
    162f:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    1633:	00 1b                	add    %bl,(%ebx)
    1635:	00 00                	add    %al,(%eax)
    1637:	00 00                	add    %al,(%eax)
    1639:	00 00                	add    %al,(%eax)
    163b:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    163f:	00 1e                	add    %bl,(%esi)
    1641:	00 00                	add    %al,(%eax)
    1643:	00 00                	add    %al,(%eax)
    1645:	00 00                	add    %al,(%eax)
    1647:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    164b:	00 25 00 00 00 00    	add    %ah,0x0
    1651:	00 00                	add    %al,(%eax)
    1653:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    1657:	00 2c 00             	add    %ch,(%eax,%eax,1)
    165a:	00 00                	add    %al,(%eax)
    165c:	00 00                	add    %al,(%eax)
    165e:	00 00                	add    %al,(%eax)
    1660:	44                   	inc    %esp
    1661:	00 3e                	add    %bh,(%esi)
    1663:	00 38                	add    %bh,(%eax)
    1665:	00 00                	add    %al,(%eax)
    1667:	00 00                	add    %al,(%eax)
    1669:	00 00                	add    %al,(%eax)
    166b:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    166f:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1672:	00 00                	add    %al,(%eax)
    1674:	00 00                	add    %al,(%eax)
    1676:	00 00                	add    %al,(%eax)
    1678:	44                   	inc    %esp
    1679:	00 3e                	add    %bh,(%esi)
    167b:	00 3f                	add    %bh,(%edi)
    167d:	00 00                	add    %al,(%eax)
    167f:	00 00                	add    %al,(%eax)
    1681:	00 00                	add    %al,(%eax)
    1683:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    1687:	00 41 00             	add    %al,0x0(%ecx)
    168a:	00 00                	add    %al,(%eax)
    168c:	00 00                	add    %al,(%eax)
    168e:	00 00                	add    %al,(%eax)
    1690:	44                   	inc    %esp
    1691:	00 41 00             	add    %al,0x0(%ecx)
    1694:	43                   	inc    %ebx
    1695:	00 00                	add    %al,(%eax)
    1697:	00 00                	add    %al,(%eax)
    1699:	00 00                	add    %al,(%eax)
    169b:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    169f:	00 4a 00             	add    %cl,0x0(%edx)
    16a2:	00 00                	add    %al,(%eax)
    16a4:	00 00                	add    %al,(%eax)
    16a6:	00 00                	add    %al,(%eax)
    16a8:	44                   	inc    %esp
    16a9:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    16ad:	00 00                	add    %al,(%eax)
    16af:	00 00                	add    %al,(%eax)
    16b1:	00 00                	add    %al,(%eax)
    16b3:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    16b7:	00 55 00             	add    %dl,0x0(%ebp)
    16ba:	00 00                	add    %al,(%eax)
    16bc:	00 00                	add    %al,(%eax)
    16be:	00 00                	add    %al,(%eax)
    16c0:	44                   	inc    %esp
    16c1:	00 4a 00             	add    %cl,0x0(%edx)
    16c4:	5a                   	pop    %edx
    16c5:	00 00                	add    %al,(%eax)
    16c7:	00 c0                	add    %al,%al
    16c9:	0d 00 00 80 00       	or     $0x800000,%eax
    16ce:	00 00                	add    %al,(%eax)
    16d0:	e2 ff                	loop   16d1 <bootmain-0x27e92f>
    16d2:	ff                   	(bad)  
    16d3:	ff 9b 0d 00 00 40    	lcall  *0x4000000d(%ebx)
    16d9:	00 00                	add    %al,(%eax)
    16db:	00 02                	add    %al,(%edx)
    16dd:	00 00                	add    %al,(%eax)
    16df:	00 00                	add    %al,(%eax)
    16e1:	00 00                	add    %al,(%eax)
    16e3:	00 c0                	add    %al,%al
    16e5:	00 00                	add    %al,(%eax)
    16e7:	00 00                	add    %al,(%eax)
    16e9:	00 00                	add    %al,(%eax)
    16eb:	00 8e 0d 00 00 40    	add    %cl,0x4000000d(%esi)
    16f1:	00 00                	add    %al,(%eax)
    16f3:	00 01                	add    %al,(%ecx)
    16f5:	00 00                	add    %al,(%eax)
    16f7:	00 00                	add    %al,(%eax)
    16f9:	00 00                	add    %al,(%eax)
    16fb:	00 c0                	add    %al,%al
    16fd:	00 00                	add    %al,(%eax)
    16ff:	00 2c 00             	add    %ch,(%eax,%eax,1)
    1702:	00 00                	add    %al,(%eax)
    1704:	00 00                	add    %al,(%eax)
    1706:	00 00                	add    %al,(%eax)
    1708:	e0 00                	loopne 170a <bootmain-0x27e8f6>
    170a:	00 00                	add    %al,(%eax)
    170c:	38 00                	cmp    %al,(%eax)
    170e:	00 00                	add    %al,(%eax)
    1710:	8e 0d 00 00 40 00    	mov    0x400000,%cs
    1716:	00 00                	add    %al,(%eax)
    1718:	01 00                	add    %eax,(%eax)
    171a:	00 00                	add    %al,(%eax)
    171c:	00 00                	add    %al,(%eax)
    171e:	00 00                	add    %al,(%eax)
    1720:	c0 00 00             	rolb   $0x0,(%eax)
    1723:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1726:	00 00                	add    %al,(%eax)
    1728:	00 00                	add    %al,(%eax)
    172a:	00 00                	add    %al,(%eax)
    172c:	e0 00                	loopne 172e <bootmain-0x27e8d2>
    172e:	00 00                	add    %al,(%eax)
    1730:	3f                   	aas    
    1731:	00 00                	add    %al,(%eax)
    1733:	00 00                	add    %al,(%eax)
    1735:	00 00                	add    %al,(%eax)
    1737:	00 e0                	add    %ah,%al
    1739:	00 00                	add    %al,(%eax)
    173b:	00 62 00             	add    %ah,0x0(%edx)
    173e:	00 00                	add    %al,(%eax)
    1740:	e3 0d                	jecxz  174f <bootmain-0x27e8b1>
    1742:	00 00                	add    %al,(%eax)
    1744:	24 00                	and    $0x0,%al
    1746:	00 00                	add    %al,(%eax)
    1748:	8a 09                	mov    (%ecx),%cl
    174a:	28 00                	sub    %al,(%eax)
    174c:	f3 0d 00 00 a0 00    	repz or $0xa00000,%eax
    1752:	00 00                	add    %al,(%eax)
    1754:	08 00                	or     %al,(%eax)
    1756:	00 00                	add    %al,(%eax)
    1758:	fe 0d 00 00 a0 00    	decb   0xa00000
    175e:	00 00                	add    %al,(%eax)
    1760:	0c 00                	or     $0x0,%al
    1762:	00 00                	add    %al,(%eax)
    1764:	00 00                	add    %al,(%eax)
    1766:	00 00                	add    %al,(%eax)
    1768:	44                   	inc    %esp
    1769:	00 51 00             	add    %dl,0x0(%ecx)
	...
    1774:	44                   	inc    %esp
    1775:	00 51 00             	add    %dl,0x0(%ecx)
    1778:	09 00                	or     %eax,(%eax)
    177a:	00 00                	add    %al,(%eax)
    177c:	00 00                	add    %al,(%eax)
    177e:	00 00                	add    %al,(%eax)
    1780:	44                   	inc    %esp
    1781:	00 53 00             	add    %dl,0x0(%ebx)
    1784:	0c 00                	or     $0x0,%al
    1786:	00 00                	add    %al,(%eax)
    1788:	00 00                	add    %al,(%eax)
    178a:	00 00                	add    %al,(%eax)
    178c:	44                   	inc    %esp
    178d:	00 56 00             	add    %dl,0x0(%esi)
    1790:	0f 00 00             	sldt   (%eax)
    1793:	00 00                	add    %al,(%eax)
    1795:	00 00                	add    %al,(%eax)
    1797:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    179b:	00 1f                	add    %bl,(%edi)
    179d:	00 00                	add    %al,(%eax)
    179f:	00 00                	add    %al,(%eax)
    17a1:	00 00                	add    %al,(%eax)
    17a3:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    17a7:	00 21                	add    %ah,(%ecx)
    17a9:	00 00                	add    %al,(%eax)
    17ab:	00 00                	add    %al,(%eax)
    17ad:	00 00                	add    %al,(%eax)
    17af:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    17b3:	00 24 00             	add    %ah,(%eax,%eax,1)
    17b6:	00 00                	add    %al,(%eax)
    17b8:	00 00                	add    %al,(%eax)
    17ba:	00 00                	add    %al,(%eax)
    17bc:	44                   	inc    %esp
    17bd:	00 5a 00             	add    %bl,0x0(%edx)
    17c0:	26 00 00             	add    %al,%es:(%eax)
    17c3:	00 00                	add    %al,(%eax)
    17c5:	00 00                	add    %al,(%eax)
    17c7:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    17cb:	00 29                	add    %ch,(%ecx)
    17cd:	00 00                	add    %al,(%eax)
    17cf:	00 00                	add    %al,(%eax)
    17d1:	00 00                	add    %al,(%eax)
    17d3:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    17d7:	00 2b                	add    %ch,(%ebx)
    17d9:	00 00                	add    %al,(%eax)
    17db:	00 00                	add    %al,(%eax)
    17dd:	00 00                	add    %al,(%eax)
    17df:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    17e3:	00 3a                	add    %bh,(%edx)
    17e5:	00 00                	add    %al,(%eax)
    17e7:	00 00                	add    %al,(%eax)
    17e9:	00 00                	add    %al,(%eax)
    17eb:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    17ef:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    17f3:	00 00                	add    %al,(%eax)
    17f5:	00 00                	add    %al,(%eax)
    17f7:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    17fb:	00 52 00             	add    %dl,0x0(%edx)
    17fe:	00 00                	add    %al,(%eax)
    1800:	00 00                	add    %al,(%eax)
    1802:	00 00                	add    %al,(%eax)
    1804:	44                   	inc    %esp
    1805:	00 63 00             	add    %ah,0x0(%ebx)
    1808:	59                   	pop    %ecx
    1809:	00 00                	add    %al,(%eax)
    180b:	00 00                	add    %al,(%eax)
    180d:	00 00                	add    %al,(%eax)
    180f:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    1813:	00 6b 00             	add    %ch,0x0(%ebx)
    1816:	00 00                	add    %al,(%eax)
    1818:	00 00                	add    %al,(%eax)
    181a:	00 00                	add    %al,(%eax)
    181c:	44                   	inc    %esp
    181d:	00 63 00             	add    %ah,0x0(%ebx)
    1820:	71 00                	jno    1822 <bootmain-0x27e7de>
    1822:	00 00                	add    %al,(%eax)
    1824:	00 00                	add    %al,(%eax)
    1826:	00 00                	add    %al,(%eax)
    1828:	44                   	inc    %esp
    1829:	00 64 00 78          	add    %ah,0x78(%eax,%eax,1)
    182d:	00 00                	add    %al,(%eax)
    182f:	00 00                	add    %al,(%eax)
    1831:	00 00                	add    %al,(%eax)
    1833:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1837:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    183d:	00 00                	add    %al,(%eax)
    183f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1843:	00 87 00 00 00 00    	add    %al,0x0(%edi)
    1849:	00 00                	add    %al,(%eax)
    184b:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    184f:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
    1855:	00 00                	add    %al,(%eax)
    1857:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    185b:	00 8f 00 00 00 00    	add    %cl,0x0(%edi)
    1861:	00 00                	add    %al,(%eax)
    1863:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    1867:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
    186d:	00 00                	add    %al,(%eax)
    186f:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    1873:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
    1879:	00 00                	add    %al,(%eax)
    187b:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    187f:	00 9f 00 00 00 00    	add    %bl,0x0(%edi)
    1885:	00 00                	add    %al,(%eax)
    1887:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
    188b:	00 a2 00 00 00 0c    	add    %ah,0xc000000(%edx)
    1891:	0e                   	push   %cs
    1892:	00 00                	add    %al,(%eax)
    1894:	40                   	inc    %eax
    1895:	00 00                	add    %al,(%eax)
    1897:	00 06                	add    %al,(%esi)
    1899:	00 00                	add    %al,(%eax)
    189b:	00 1f                	add    %bl,(%edi)
    189d:	0e                   	push   %cs
    189e:	00 00                	add    %al,(%eax)
    18a0:	80 00 00             	addb   $0x0,(%eax)
    18a3:	00 f6                	add    %dh,%dh
    18a5:	ff                   	(bad)  
    18a6:	ff                   	(bad)  
    18a7:	ff                   	(bad)  
    18a8:	3f                   	aas    
    18a9:	0e                   	push   %cs
    18aa:	00 00                	add    %al,(%eax)
    18ac:	40                   	inc    %eax
    18ad:	00 00                	add    %al,(%eax)
    18af:	00 03                	add    %al,(%ebx)
    18b1:	00 00                	add    %al,(%eax)
    18b3:	00 00                	add    %al,(%eax)
    18b5:	00 00                	add    %al,(%eax)
    18b7:	00 c0                	add    %al,%al
	...
    18c1:	00 00                	add    %al,(%eax)
    18c3:	00 e0                	add    %ah,%al
    18c5:	00 00                	add    %al,(%eax)
    18c7:	00 aa 00 00 00 4a    	add    %ch,0x4a000000(%edx)
    18cd:	0e                   	push   %cs
    18ce:	00 00                	add    %al,(%eax)
    18d0:	24 00                	and    $0x0,%al
    18d2:	00 00                	add    %al,(%eax)
    18d4:	34 0a                	xor    $0xa,%al
    18d6:	28 00                	sub    %al,(%eax)
    18d8:	d8 0c 00             	fmuls  (%eax,%eax,1)
    18db:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    18e1:	00 00                	add    %al,(%eax)
    18e3:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    18e9:	00 00                	add    %al,(%eax)
    18eb:	00 0c 00             	add    %cl,(%eax,%eax,1)
    18ee:	00 00                	add    %al,(%eax)
    18f0:	5b                   	pop    %ebx
    18f1:	0e                   	push   %cs
    18f2:	00 00                	add    %al,(%eax)
    18f4:	a0 00 00 00 10       	mov    0x10000000,%al
    18f9:	00 00                	add    %al,(%eax)
    18fb:	00 64 0e 00          	add    %ah,0x0(%esi,%ecx,1)
    18ff:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1905:	00 00                	add    %al,(%eax)
    1907:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
    190d:	00 00                	add    %al,(%eax)
    190f:	00 18                	add    %bl,(%eax)
    1911:	00 00                	add    %al,(%eax)
    1913:	00 6d 0e             	add    %ch,0xe(%ebp)
    1916:	00 00                	add    %al,(%eax)
    1918:	a0 00 00 00 1c       	mov    0x1c000000,%al
    191d:	00 00                	add    %al,(%eax)
    191f:	00 00                	add    %al,(%eax)
    1921:	00 00                	add    %al,(%eax)
    1923:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
	...
    192f:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1933:	00 01                	add    %al,(%ecx)
    1935:	00 00                	add    %al,(%eax)
    1937:	00 00                	add    %al,(%eax)
    1939:	00 00                	add    %al,(%eax)
    193b:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    193f:	00 03                	add    %al,(%ebx)
    1941:	00 00                	add    %al,(%eax)
    1943:	00 00                	add    %al,(%eax)
    1945:	00 00                	add    %al,(%eax)
    1947:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    194b:	00 06                	add    %al,(%esi)
    194d:	00 00                	add    %al,(%eax)
    194f:	00 00                	add    %al,(%eax)
    1951:	00 00                	add    %al,(%eax)
    1953:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1957:	00 0b                	add    %cl,(%ebx)
    1959:	00 00                	add    %al,(%eax)
    195b:	00 00                	add    %al,(%eax)
    195d:	00 00                	add    %al,(%eax)
    195f:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1963:	00 10                	add    %dl,(%eax)
    1965:	00 00                	add    %al,(%eax)
    1967:	00 00                	add    %al,(%eax)
    1969:	00 00                	add    %al,(%eax)
    196b:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    196f:	00 23                	add    %ah,(%ebx)
    1971:	00 00                	add    %al,(%eax)
    1973:	00 00                	add    %al,(%eax)
    1975:	00 00                	add    %al,(%eax)
    1977:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    197b:	00 26                	add    %ah,(%esi)
    197d:	00 00                	add    %al,(%eax)
    197f:	00 00                	add    %al,(%eax)
    1981:	00 00                	add    %al,(%eax)
    1983:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1987:	00 28                	add    %ch,(%eax)
    1989:	00 00                	add    %al,(%eax)
    198b:	00 00                	add    %al,(%eax)
    198d:	00 00                	add    %al,(%eax)
    198f:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    1993:	00 34 00             	add    %dh,(%eax,%eax,1)
    1996:	00 00                	add    %al,(%eax)
    1998:	00 00                	add    %al,(%eax)
    199a:	00 00                	add    %al,(%eax)
    199c:	44                   	inc    %esp
    199d:	00 9a 00 3a 00 00    	add    %bl,0x3a00(%edx)
    19a3:	00 00                	add    %al,(%eax)
    19a5:	00 00                	add    %al,(%eax)
    19a7:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    19ab:	00 40 00             	add    %al,0x0(%eax)
    19ae:	00 00                	add    %al,(%eax)
    19b0:	00 00                	add    %al,(%eax)
    19b2:	00 00                	add    %al,(%eax)
    19b4:	44                   	inc    %esp
    19b5:	00 aa 00 49 00 00    	add    %ch,0x4900(%edx)
    19bb:	00 79 0e             	add    %bh,0xe(%ecx)
    19be:	00 00                	add    %al,(%eax)
    19c0:	40                   	inc    %eax
    19c1:	00 00                	add    %al,(%eax)
    19c3:	00 02                	add    %al,(%edx)
    19c5:	00 00                	add    %al,(%eax)
    19c7:	00 84 0e 00 00 40 00 	add    %al,0x400000(%esi,%ecx,1)
    19ce:	00 00                	add    %al,(%eax)
    19d0:	01 00                	add    %eax,(%eax)
    19d2:	00 00                	add    %al,(%eax)
    19d4:	00 00                	add    %al,(%eax)
    19d6:	00 00                	add    %al,(%eax)
    19d8:	c0 00 00             	rolb   $0x0,(%eax)
	...
    19e3:	00 e0                	add    %ah,%al
    19e5:	00 00                	add    %al,(%eax)
    19e7:	00 51 00             	add    %dl,0x0(%ecx)
    19ea:	00 00                	add    %al,(%eax)
    19ec:	8f                   	(bad)  
    19ed:	0e                   	push   %cs
    19ee:	00 00                	add    %al,(%eax)
    19f0:	24 00                	and    $0x0,%al
    19f2:	00 00                	add    %al,(%eax)
    19f4:	85 0a                	test   %ecx,(%edx)
    19f6:	28 00                	sub    %al,(%eax)
    19f8:	d8 0c 00             	fmuls  (%eax,%eax,1)
    19fb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1a01:	00 00                	add    %al,(%eax)
    1a03:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    1a09:	00 00                	add    %al,(%eax)
    1a0b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1a0e:	00 00                	add    %al,(%eax)
    1a10:	5b                   	pop    %ebx
    1a11:	0e                   	push   %cs
    1a12:	00 00                	add    %al,(%eax)
    1a14:	a0 00 00 00 10       	mov    0x10000000,%al
    1a19:	00 00                	add    %al,(%eax)
    1a1b:	00 64 0e 00          	add    %ah,0x0(%esi,%ecx,1)
    1a1f:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1a25:	00 00                	add    %al,(%eax)
    1a27:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
    1a2d:	00 00                	add    %al,(%eax)
    1a2f:	00 18                	add    %bl,(%eax)
    1a31:	00 00                	add    %al,(%eax)
    1a33:	00 9d 0e 00 00 a0    	add    %bl,-0x5ffffff2(%ebp)
    1a39:	00 00                	add    %al,(%eax)
    1a3b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1a3e:	00 00                	add    %al,(%eax)
    1a40:	00 00                	add    %al,(%eax)
    1a42:	00 00                	add    %al,(%eax)
    1a44:	44                   	inc    %esp
    1a45:	00 73 00             	add    %dh,0x0(%ebx)
	...
    1a50:	44                   	inc    %esp
    1a51:	00 7f 00             	add    %bh,0x0(%edi)
    1a54:	08 00                	or     %al,(%eax)
    1a56:	00 00                	add    %al,(%eax)
    1a58:	00 00                	add    %al,(%eax)
    1a5a:	00 00                	add    %al,(%eax)
    1a5c:	44                   	inc    %esp
    1a5d:	00 73 00             	add    %dh,0x0(%ebx)
    1a60:	0c 00                	or     $0x0,%al
    1a62:	00 00                	add    %al,(%eax)
    1a64:	00 00                	add    %al,(%eax)
    1a66:	00 00                	add    %al,(%eax)
    1a68:	44                   	inc    %esp
    1a69:	00 73 00             	add    %dh,0x0(%ebx)
    1a6c:	0d 00 00 00 00       	or     $0x0,%eax
    1a71:	00 00                	add    %al,(%eax)
    1a73:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    1a77:	00 10                	add    %dl,(%eax)
    1a79:	00 00                	add    %al,(%eax)
    1a7b:	00 00                	add    %al,(%eax)
    1a7d:	00 00                	add    %al,(%eax)
    1a7f:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    1a83:	00 1a                	add    %bl,(%edx)
    1a85:	00 00                	add    %al,(%eax)
    1a87:	00 00                	add    %al,(%eax)
    1a89:	00 00                	add    %al,(%eax)
    1a8b:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
    1a8f:	00 1e                	add    %bl,(%esi)
    1a91:	00 00                	add    %al,(%eax)
    1a93:	00 00                	add    %al,(%eax)
    1a95:	00 00                	add    %al,(%eax)
    1a97:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1a9b:	00 23                	add    %ah,(%ebx)
    1a9d:	00 00                	add    %al,(%eax)
    1a9f:	00 00                	add    %al,(%eax)
    1aa1:	00 00                	add    %al,(%eax)
    1aa3:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    1aa7:	00 2f                	add    %ch,(%edi)
    1aa9:	00 00                	add    %al,(%eax)
    1aab:	00 00                	add    %al,(%eax)
    1aad:	00 00                	add    %al,(%eax)
    1aaf:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1ab3:	00 32                	add    %dh,(%edx)
    1ab5:	00 00                	add    %al,(%eax)
    1ab7:	00 00                	add    %al,(%eax)
    1ab9:	00 00                	add    %al,(%eax)
    1abb:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    1abf:	00 3d 00 00 00 00    	add    %bh,0x0
    1ac5:	00 00                	add    %al,(%eax)
    1ac7:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
    1acb:	00 48 00             	add    %cl,0x0(%eax)
    1ace:	00 00                	add    %al,(%eax)
    1ad0:	00 00                	add    %al,(%eax)
    1ad2:	00 00                	add    %al,(%eax)
    1ad4:	44                   	inc    %esp
    1ad5:	00 85 00 4b 00 00    	add    %al,0x4b00(%ebp)
    1adb:	00 00                	add    %al,(%eax)
    1add:	00 00                	add    %al,(%eax)
    1adf:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    1ae3:	00 53 00             	add    %dl,0x0(%ebx)
    1ae6:	00 00                	add    %al,(%eax)
    1ae8:	00 00                	add    %al,(%eax)
    1aea:	00 00                	add    %al,(%eax)
    1aec:	44                   	inc    %esp
    1aed:	00 87 00 55 00 00    	add    %al,0x5500(%edi)
    1af3:	00 00                	add    %al,(%eax)
    1af5:	00 00                	add    %al,(%eax)
    1af7:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
    1afb:	00 57 00             	add    %dl,0x0(%edi)
    1afe:	00 00                	add    %al,(%eax)
    1b00:	00 00                	add    %al,(%eax)
    1b02:	00 00                	add    %al,(%eax)
    1b04:	44                   	inc    %esp
    1b05:	00 91 00 5c 00 00    	add    %dl,0x5c00(%ecx)
    1b0b:	00 af 0c 00 00 40    	add    %ch,0x4000000c(%edi)
    1b11:	00 00                	add    %al,(%eax)
    1b13:	00 03                	add    %al,(%ebx)
    1b15:	00 00                	add    %al,(%eax)
    1b17:	00 2f                	add    %ch,(%edi)
    1b19:	0d 00 00 40 00       	or     $0x400000,%eax
    1b1e:	00 00                	add    %al,(%eax)
    1b20:	07                   	pop    %es
    1b21:	00 00                	add    %al,(%eax)
    1b23:	00 a9 0e 00 00 24    	add    %ch,0x2400000e(%ecx)
    1b29:	00 00                	add    %al,(%eax)
    1b2b:	00 e9                	add    %ch,%cl
    1b2d:	0a 28                	or     (%eax),%ch
    1b2f:	00 bc 0e 00 00 a0 00 	add    %bh,0xa00000(%esi,%ecx,1)
    1b36:	00 00                	add    %al,(%eax)
    1b38:	08 00                	or     %al,(%eax)
    1b3a:	00 00                	add    %al,(%eax)
    1b3c:	c5 0e                	lds    (%esi),%ecx
    1b3e:	00 00                	add    %al,(%eax)
    1b40:	a0 00 00 00 0c       	mov    0xc000000,%al
    1b45:	00 00                	add    %al,(%eax)
    1b47:	00 00                	add    %al,(%eax)
    1b49:	00 00                	add    %al,(%eax)
    1b4b:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    1b57:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1b5b:	00 07                	add    %al,(%edi)
    1b5d:	00 00                	add    %al,(%eax)
    1b5f:	00 00                	add    %al,(%eax)
    1b61:	00 00                	add    %al,(%eax)
    1b63:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1b67:	00 18                	add    %bl,(%eax)
    1b69:	00 00                	add    %al,(%eax)
    1b6b:	00 00                	add    %al,(%eax)
    1b6d:	00 00                	add    %al,(%eax)
    1b6f:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1b73:	00 35 00 00 00 ce    	add    %dh,0xce000000
    1b79:	0e                   	push   %cs
    1b7a:	00 00                	add    %al,(%eax)
    1b7c:	80 00 00             	addb   $0x0,(%eax)
    1b7f:	00 e2                	add    %ah,%dl
    1b81:	ff                   	(bad)  
    1b82:	ff                   	(bad)  
    1b83:	ff 00                	incl   (%eax)
    1b85:	00 00                	add    %al,(%eax)
    1b87:	00 c0                	add    %al,%al
	...
    1b91:	00 00                	add    %al,(%eax)
    1b93:	00 e0                	add    %ah,%al
    1b95:	00 00                	add    %al,(%eax)
    1b97:	00 3a                	add    %bh,(%edx)
    1b99:	00 00                	add    %al,(%eax)
    1b9b:	00 ed                	add    %ch,%ch
    1b9d:	0e                   	push   %cs
    1b9e:	00 00                	add    %al,(%eax)
    1ba0:	24 00                	and    $0x0,%al
    1ba2:	00 00                	add    %al,(%eax)
    1ba4:	23 0b                	and    (%ebx),%ecx
    1ba6:	28 00                	sub    %al,(%eax)
    1ba8:	d8 0c 00             	fmuls  (%eax,%eax,1)
    1bab:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1bb1:	00 00                	add    %al,(%eax)
    1bb3:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    1bb9:	00 00                	add    %al,(%eax)
    1bbb:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1bbe:	00 00                	add    %al,(%eax)
    1bc0:	5b                   	pop    %ebx
    1bc1:	0e                   	push   %cs
    1bc2:	00 00                	add    %al,(%eax)
    1bc4:	a0 00 00 00 10       	mov    0x10000000,%al
    1bc9:	00 00                	add    %al,(%eax)
    1bcb:	00 64 0e 00          	add    %ah,0x0(%esi,%ecx,1)
    1bcf:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1bd5:	00 00                	add    %al,(%eax)
    1bd7:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
    1bdd:	00 00                	add    %al,(%eax)
    1bdf:	00 18                	add    %bl,(%eax)
    1be1:	00 00                	add    %al,(%eax)
    1be3:	00 ff                	add    %bh,%bh
    1be5:	0e                   	push   %cs
    1be6:	00 00                	add    %al,(%eax)
    1be8:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1bed:	00 00                	add    %al,(%eax)
    1bef:	00 00                	add    %al,(%eax)
    1bf1:	00 00                	add    %al,(%eax)
    1bf3:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
	...
    1bff:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    1c03:	00 10                	add    %dl,(%eax)
    1c05:	00 00                	add    %al,(%eax)
    1c07:	00 00                	add    %al,(%eax)
    1c09:	00 00                	add    %al,(%eax)
    1c0b:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    1c0f:	00 1b                	add    %bl,(%ebx)
    1c11:	00 00                	add    %al,(%eax)
    1c13:	00 00                	add    %al,(%eax)
    1c15:	00 00                	add    %al,(%eax)
    1c17:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    1c1b:	00 20                	add    %ah,(%eax)
    1c1d:	00 00                	add    %al,(%eax)
    1c1f:	00 00                	add    %al,(%eax)
    1c21:	00 00                	add    %al,(%eax)
    1c23:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1c27:	00 31                	add    %dh,(%ecx)
    1c29:	00 00                	add    %al,(%eax)
    1c2b:	00 00                	add    %al,(%eax)
    1c2d:	00 00                	add    %al,(%eax)
    1c2f:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    1c33:	00 33                	add    %dh,(%ebx)
    1c35:	00 00                	add    %al,(%eax)
    1c37:	00 00                	add    %al,(%eax)
    1c39:	00 00                	add    %al,(%eax)
    1c3b:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    1c3f:	00 38                	add    %bh,(%eax)
    1c41:	00 00                	add    %al,(%eax)
    1c43:	00 00                	add    %al,(%eax)
    1c45:	00 00                	add    %al,(%eax)
    1c47:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1c4b:	00 3b                	add    %bh,(%ebx)
    1c4d:	00 00                	add    %al,(%eax)
    1c4f:	00 00                	add    %al,(%eax)
    1c51:	00 00                	add    %al,(%eax)
    1c53:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    1c57:	00 41 00             	add    %al,0x0(%ecx)
    1c5a:	00 00                	add    %al,(%eax)
    1c5c:	00 00                	add    %al,(%eax)
    1c5e:	00 00                	add    %al,(%eax)
    1c60:	44                   	inc    %esp
    1c61:	00 de                	add    %bl,%dh
    1c63:	00 4a 00             	add    %cl,0x0(%edx)
    1c66:	00 00                	add    %al,(%eax)
    1c68:	79 0e                	jns    1c78 <bootmain-0x27e388>
    1c6a:	00 00                	add    %al,(%eax)
    1c6c:	40                   	inc    %eax
    1c6d:	00 00                	add    %al,(%eax)
    1c6f:	00 02                	add    %al,(%edx)
    1c71:	00 00                	add    %al,(%eax)
    1c73:	00 84 0e 00 00 40 00 	add    %al,0x400000(%esi,%ecx,1)
    1c7a:	00 00                	add    %al,(%eax)
    1c7c:	00 00                	add    %al,(%eax)
    1c7e:	00 00                	add    %al,(%eax)
    1c80:	b8 0a 00 00 40       	mov    $0x4000000a,%eax
    1c85:	00 00                	add    %al,(%eax)
    1c87:	00 03                	add    %al,(%ebx)
    1c89:	00 00                	add    %al,(%eax)
    1c8b:	00 00                	add    %al,(%eax)
    1c8d:	00 00                	add    %al,(%eax)
    1c8f:	00 c0                	add    %al,%al
	...
    1c99:	00 00                	add    %al,(%eax)
    1c9b:	00 e0                	add    %ah,%al
    1c9d:	00 00                	add    %al,(%eax)
    1c9f:	00 50 00             	add    %dl,0x0(%eax)
    1ca2:	00 00                	add    %al,(%eax)
    1ca4:	13 0f                	adc    (%edi),%ecx
    1ca6:	00 00                	add    %al,(%eax)
    1ca8:	24 00                	and    $0x0,%al
    1caa:	00 00                	add    %al,(%eax)
    1cac:	73 0b                	jae    1cb9 <bootmain-0x27e347>
    1cae:	28 00                	sub    %al,(%eax)
    1cb0:	d8 0c 00             	fmuls  (%eax,%eax,1)
    1cb3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1cb9:	00 00                	add    %al,(%eax)
    1cbb:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    1cc1:	00 00                	add    %al,(%eax)
    1cc3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1cc6:	00 00                	add    %al,(%eax)
    1cc8:	5b                   	pop    %ebx
    1cc9:	0e                   	push   %cs
    1cca:	00 00                	add    %al,(%eax)
    1ccc:	a0 00 00 00 10       	mov    0x10000000,%al
    1cd1:	00 00                	add    %al,(%eax)
    1cd3:	00 64 0e 00          	add    %ah,0x0(%esi,%ecx,1)
    1cd7:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1cdd:	00 00                	add    %al,(%eax)
    1cdf:	00 a2 0a 00 00 a0    	add    %ah,-0x5ffffff6(%edx)
    1ce5:	00 00                	add    %al,(%eax)
    1ce7:	00 18                	add    %bl,(%eax)
    1ce9:	00 00                	add    %al,(%eax)
    1ceb:	00 6d 0e             	add    %ch,0xe(%ebp)
    1cee:	00 00                	add    %al,(%eax)
    1cf0:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1cf5:	00 00                	add    %al,(%eax)
    1cf7:	00 00                	add    %al,(%eax)
    1cf9:	00 00                	add    %al,(%eax)
    1cfb:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
	...
    1d07:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1d0b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1d0e:	00 00                	add    %al,(%eax)
    1d10:	00 00                	add    %al,(%eax)
    1d12:	00 00                	add    %al,(%eax)
    1d14:	44                   	inc    %esp
    1d15:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    1d1b:	00 00                	add    %al,(%eax)
    1d1d:	00 00                	add    %al,(%eax)
    1d1f:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    1d23:	00 1a                	add    %bl,(%edx)
    1d25:	00 00                	add    %al,(%eax)
    1d27:	00 00                	add    %al,(%eax)
    1d29:	00 00                	add    %al,(%eax)
    1d2b:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
    1d2f:	00 1e                	add    %bl,(%esi)
    1d31:	00 00                	add    %al,(%eax)
    1d33:	00 00                	add    %al,(%eax)
    1d35:	00 00                	add    %al,(%eax)
    1d37:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    1d3b:	00 21                	add    %ah,(%ecx)
    1d3d:	00 00                	add    %al,(%eax)
    1d3f:	00 00                	add    %al,(%eax)
    1d41:	00 00                	add    %al,(%eax)
    1d43:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    1d47:	00 25 00 00 00 00    	add    %ah,0x0
    1d4d:	00 00                	add    %al,(%eax)
    1d4f:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1d53:	00 2d 00 00 00 00    	add    %ch,0x0
    1d59:	00 00                	add    %al,(%eax)
    1d5b:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    1d5f:	00 31                	add    %dh,(%ecx)
    1d61:	00 00                	add    %al,(%eax)
    1d63:	00 00                	add    %al,(%eax)
    1d65:	00 00                	add    %al,(%eax)
    1d67:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1d6b:	00 34 00             	add    %dh,(%eax,%eax,1)
    1d6e:	00 00                	add    %al,(%eax)
    1d70:	00 00                	add    %al,(%eax)
    1d72:	00 00                	add    %al,(%eax)
    1d74:	44                   	inc    %esp
    1d75:	00 bb 00 3f 00 00    	add    %bh,0x3f00(%ebx)
    1d7b:	00 00                	add    %al,(%eax)
    1d7d:	00 00                	add    %al,(%eax)
    1d7f:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    1d83:	00 42 00             	add    %al,0x0(%edx)
    1d86:	00 00                	add    %al,(%eax)
    1d88:	00 00                	add    %al,(%eax)
    1d8a:	00 00                	add    %al,(%eax)
    1d8c:	44                   	inc    %esp
    1d8d:	00 c4                	add    %al,%ah
    1d8f:	00 47 00             	add    %al,0x0(%edi)
    1d92:	00 00                	add    %al,(%eax)
    1d94:	af                   	scas   %es:(%edi),%eax
    1d95:	0c 00                	or     $0x0,%al
    1d97:	00 40 00             	add    %al,0x0(%eax)
    1d9a:	00 00                	add    %al,(%eax)
    1d9c:	07                   	pop    %es
    1d9d:	00 00                	add    %al,(%eax)
    1d9f:	00 2f                	add    %ch,(%edi)
    1da1:	0d 00 00 40 00       	or     $0x400000,%eax
    1da6:	00 00                	add    %al,(%eax)
    1da8:	06                   	push   %es
    1da9:	00 00                	add    %al,(%eax)
    1dab:	00 00                	add    %al,(%eax)
    1dad:	00 00                	add    %al,(%eax)
    1daf:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    1db3:	00 c2                	add    %al,%dl
    1db5:	0b 28                	or     (%eax),%ebp
    1db7:	00 22                	add    %ah,(%edx)
    1db9:	0f 00 00             	sldt   (%eax)
    1dbc:	64 00 02             	add    %al,%fs:(%edx)
    1dbf:	00 c2                	add    %al,%dl
    1dc1:	0b 28                	or     (%eax),%ebp
    1dc3:	00 08                	add    %cl,(%eax)
    1dc5:	00 00                	add    %al,(%eax)
    1dc7:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1dca:	00 00                	add    %al,(%eax)
    1dcc:	00 00                	add    %al,(%eax)
    1dce:	00 00                	add    %al,(%eax)
    1dd0:	17                   	pop    %ss
    1dd1:	00 00                	add    %al,(%eax)
    1dd3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dd9:	00 00                	add    %al,(%eax)
    1ddb:	00 41 00             	add    %al,0x0(%ecx)
    1dde:	00 00                	add    %al,(%eax)
    1de0:	80 00 00             	addb   $0x0,(%eax)
    1de3:	00 00                	add    %al,(%eax)
    1de5:	00 00                	add    %al,(%eax)
    1de7:	00 5b 00             	add    %bl,0x0(%ebx)
    1dea:	00 00                	add    %al,(%eax)
    1dec:	80 00 00             	addb   $0x0,(%eax)
    1def:	00 00                	add    %al,(%eax)
    1df1:	00 00                	add    %al,(%eax)
    1df3:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1df9:	00 00                	add    %al,(%eax)
    1dfb:	00 00                	add    %al,(%eax)
    1dfd:	00 00                	add    %al,(%eax)
    1dff:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1e05:	00 00                	add    %al,(%eax)
    1e07:	00 00                	add    %al,(%eax)
    1e09:	00 00                	add    %al,(%eax)
    1e0b:	00 e1                	add    %ah,%cl
    1e0d:	00 00                	add    %al,(%eax)
    1e0f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e15:	00 00                	add    %al,(%eax)
    1e17:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1e1a:	00 00                	add    %al,(%eax)
    1e1c:	80 00 00             	addb   $0x0,(%eax)
    1e1f:	00 00                	add    %al,(%eax)
    1e21:	00 00                	add    %al,(%eax)
    1e23:	00 37                	add    %dh,(%edi)
    1e25:	01 00                	add    %eax,(%eax)
    1e27:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e2d:	00 00                	add    %al,(%eax)
    1e2f:	00 5d 01             	add    %bl,0x1(%ebp)
    1e32:	00 00                	add    %al,(%eax)
    1e34:	80 00 00             	addb   $0x0,(%eax)
    1e37:	00 00                	add    %al,(%eax)
    1e39:	00 00                	add    %al,(%eax)
    1e3b:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1e41:	00 00                	add    %al,(%eax)
    1e43:	00 00                	add    %al,(%eax)
    1e45:	00 00                	add    %al,(%eax)
    1e47:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1e4d:	00 00                	add    %al,(%eax)
    1e4f:	00 00                	add    %al,(%eax)
    1e51:	00 00                	add    %al,(%eax)
    1e53:	00 d2                	add    %dl,%dl
    1e55:	01 00                	add    %eax,(%eax)
    1e57:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e5d:	00 00                	add    %al,(%eax)
    1e5f:	00 ec                	add    %ch,%ah
    1e61:	01 00                	add    %eax,(%eax)
    1e63:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e69:	00 00                	add    %al,(%eax)
    1e6b:	00 07                	add    %al,(%edi)
    1e6d:	02 00                	add    (%eax),%al
    1e6f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e75:	00 00                	add    %al,(%eax)
    1e77:	00 28                	add    %ch,(%eax)
    1e79:	02 00                	add    (%eax),%al
    1e7b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1e81:	00 00                	add    %al,(%eax)
    1e83:	00 47 02             	add    %al,0x2(%edi)
    1e86:	00 00                	add    %al,(%eax)
    1e88:	80 00 00             	addb   $0x0,(%eax)
    1e8b:	00 00                	add    %al,(%eax)
    1e8d:	00 00                	add    %al,(%eax)
    1e8f:	00 66 02             	add    %ah,0x2(%esi)
    1e92:	00 00                	add    %al,(%eax)
    1e94:	80 00 00             	addb   $0x0,(%eax)
    1e97:	00 00                	add    %al,(%eax)
    1e99:	00 00                	add    %al,(%eax)
    1e9b:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1ea1:	00 00                	add    %al,(%eax)
    1ea3:	00 00                	add    %al,(%eax)
    1ea5:	00 00                	add    %al,(%eax)
    1ea7:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1ead:	00 00                	add    %al,(%eax)
    1eaf:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    1eb5:	02 00                	add    (%eax),%al
    1eb7:	00 c2                	add    %al,%dl
    1eb9:	00 00                	add    %al,(%eax)
    1ebb:	00 00                	add    %al,(%eax)
    1ebd:	00 00                	add    %al,(%eax)
    1ebf:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    1ec5:	00 00                	add    %al,(%eax)
    1ec7:	00 37                	add    %dh,(%edi)
    1ec9:	53                   	push   %ebx
    1eca:	00 00                	add    %al,(%eax)
    1ecc:	29 04 00             	sub    %eax,(%eax,%eax,1)
    1ecf:	00 c2                	add    %al,%dl
    1ed1:	00 00                	add    %al,(%eax)
    1ed3:	00 65 97             	add    %ah,-0x69(%ebp)
    1ed6:	00 00                	add    %al,(%eax)
    1ed8:	2b 0f                	sub    (%edi),%ecx
    1eda:	00 00                	add    %al,(%eax)
    1edc:	24 00                	and    $0x0,%al
    1ede:	00 00                	add    %al,(%eax)
    1ee0:	c2 0b 28             	ret    $0x280b
    1ee3:	00 3a                	add    %bh,(%edx)
    1ee5:	0f 00 00             	sldt   (%eax)
    1ee8:	a0 00 00 00 08       	mov    0x8000000,%al
    1eed:	00 00                	add    %al,(%eax)
    1eef:	00 4c 0f 00          	add    %cl,0x0(%edi,%ecx,1)
    1ef3:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1ef9:	00 00                	add    %al,(%eax)
    1efb:	00 59 0f             	add    %bl,0xf(%ecx)
    1efe:	00 00                	add    %al,(%eax)
    1f00:	a0 00 00 00 10       	mov    0x10000000,%al
    1f05:	00 00                	add    %al,(%eax)
    1f07:	00 65 0f             	add    %ah,0xf(%ebp)
    1f0a:	00 00                	add    %al,(%eax)
    1f0c:	a0 00 00 00 14       	mov    0x14000000,%al
    1f11:	00 00                	add    %al,(%eax)
    1f13:	00 00                	add    %al,(%eax)
    1f15:	00 00                	add    %al,(%eax)
    1f17:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
	...
    1f23:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1f27:	00 0f                	add    %cl,(%edi)
    1f29:	00 00                	add    %al,(%eax)
    1f2b:	00 00                	add    %al,(%eax)
    1f2d:	00 00                	add    %al,(%eax)
    1f2f:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1f33:	00 12                	add    %dl,(%edx)
    1f35:	00 00                	add    %al,(%eax)
    1f37:	00 00                	add    %al,(%eax)
    1f39:	00 00                	add    %al,(%eax)
    1f3b:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1f3f:	00 1a                	add    %bl,(%edx)
    1f41:	00 00                	add    %al,(%eax)
    1f43:	00 00                	add    %al,(%eax)
    1f45:	00 00                	add    %al,(%eax)
    1f47:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    1f4b:	00 20                	add    %ah,(%eax)
    1f4d:	00 00                	add    %al,(%eax)
    1f4f:	00 00                	add    %al,(%eax)
    1f51:	00 00                	add    %al,(%eax)
    1f53:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    1f57:	00 23                	add    %ah,(%ebx)
    1f59:	00 00                	add    %al,(%eax)
    1f5b:	00 00                	add    %al,(%eax)
    1f5d:	00 00                	add    %al,(%eax)
    1f5f:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1f63:	00 2d 00 00 00 00    	add    %ch,0x0
    1f69:	00 00                	add    %al,(%eax)
    1f6b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1f6f:	00 2f                	add    %ch,(%edi)
    1f71:	00 00                	add    %al,(%eax)
    1f73:	00 00                	add    %al,(%eax)
    1f75:	00 00                	add    %al,(%eax)
    1f77:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1f7b:	00 32                	add    %dh,(%edx)
    1f7d:	00 00                	add    %al,(%eax)
    1f7f:	00 00                	add    %al,(%eax)
    1f81:	00 00                	add    %al,(%eax)
    1f83:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1f87:	00 35 00 00 00 00    	add    %dh,0x0
    1f8d:	00 00                	add    %al,(%eax)
    1f8f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1f93:	00 37                	add    %dh,(%edi)
    1f95:	00 00                	add    %al,(%eax)
    1f97:	00 00                	add    %al,(%eax)
    1f99:	00 00                	add    %al,(%eax)
    1f9b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1f9f:	00 3a                	add    %bh,(%edx)
    1fa1:	00 00                	add    %al,(%eax)
    1fa3:	00 00                	add    %al,(%eax)
    1fa5:	00 00                	add    %al,(%eax)
    1fa7:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1fab:	00 40 00             	add    %al,0x0(%eax)
    1fae:	00 00                	add    %al,(%eax)
    1fb0:	00 00                	add    %al,(%eax)
    1fb2:	00 00                	add    %al,(%eax)
    1fb4:	44                   	inc    %esp
    1fb5:	00 11                	add    %dl,(%ecx)
    1fb7:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1fbb:	00 00                	add    %al,(%eax)
    1fbd:	00 00                	add    %al,(%eax)
    1fbf:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1fc3:	00 46 00             	add    %al,0x0(%esi)
    1fc6:	00 00                	add    %al,(%eax)
    1fc8:	00 00                	add    %al,(%eax)
    1fca:	00 00                	add    %al,(%eax)
    1fcc:	44                   	inc    %esp
    1fcd:	00 11                	add    %dl,(%ecx)
    1fcf:	00 49 00             	add    %cl,0x0(%ecx)
    1fd2:	00 00                	add    %al,(%eax)
    1fd4:	00 00                	add    %al,(%eax)
    1fd6:	00 00                	add    %al,(%eax)
    1fd8:	44                   	inc    %esp
    1fd9:	00 12                	add    %dl,(%edx)
    1fdb:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1fdf:	00 00                	add    %al,(%eax)
    1fe1:	00 00                	add    %al,(%eax)
    1fe3:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1fe7:	00 4f 00             	add    %cl,0x0(%edi)
    1fea:	00 00                	add    %al,(%eax)
    1fec:	73 0f                	jae    1ffd <bootmain-0x27e003>
    1fee:	00 00                	add    %al,(%eax)
    1ff0:	40                   	inc    %eax
    1ff1:	00 00                	add    %al,(%eax)
    1ff3:	00 00                	add    %al,(%eax)
    1ff5:	00 00                	add    %al,(%eax)
    1ff7:	00 7e 0f             	add    %bh,0xf(%esi)
    1ffa:	00 00                	add    %al,(%eax)
    1ffc:	40                   	inc    %eax
    1ffd:	00 00                	add    %al,(%eax)
    1fff:	00 02                	add    %al,(%edx)
    2001:	00 00                	add    %al,(%eax)
    2003:	00 8b 0f 00 00 40    	add    %cl,0x4000000f(%ebx)
    2009:	00 00                	add    %al,(%eax)
    200b:	00 03                	add    %al,(%ebx)
    200d:	00 00                	add    %al,(%eax)
    200f:	00 97 0f 00 00 40    	add    %dl,0x4000000f(%edi)
    2015:	00 00                	add    %al,(%eax)
    2017:	00 07                	add    %al,(%edi)
    2019:	00 00                	add    %al,(%eax)
    201b:	00 a5 0f 00 00 24    	add    %ah,0x2400000f(%ebp)
    2021:	00 00                	add    %al,(%eax)
    2023:	00 16                	add    %dl,(%esi)
    2025:	0c 28                	or     $0x28,%al
    2027:	00 b4 0f 00 00 a0 00 	add    %dh,0xa00000(%edi,%ecx,1)
    202e:	00 00                	add    %al,(%eax)
    2030:	08 00                	or     %al,(%eax)
    2032:	00 00                	add    %al,(%eax)
    2034:	c6                   	(bad)  
    2035:	0f 00 00             	sldt   (%eax)
    2038:	a0 00 00 00 0c       	mov    0xc000000,%al
    203d:	00 00                	add    %al,(%eax)
    203f:	00 d4                	add    %dl,%ah
    2041:	0f 00 00             	sldt   (%eax)
    2044:	a0 00 00 00 10       	mov    0x10000000,%al
    2049:	00 00                	add    %al,(%eax)
    204b:	00 65 0f             	add    %ah,0xf(%ebp)
    204e:	00 00                	add    %al,(%eax)
    2050:	a0 00 00 00 14       	mov    0x14000000,%al
    2055:	00 00                	add    %al,(%eax)
    2057:	00 00                	add    %al,(%eax)
    2059:	00 00                	add    %al,(%eax)
    205b:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
	...
    2067:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    206b:	00 03                	add    %al,(%ebx)
    206d:	00 00                	add    %al,(%eax)
    206f:	00 00                	add    %al,(%eax)
    2071:	00 00                	add    %al,(%eax)
    2073:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    2077:	00 0c 00             	add    %cl,(%eax,%eax,1)
    207a:	00 00                	add    %al,(%eax)
    207c:	00 00                	add    %al,(%eax)
    207e:	00 00                	add    %al,(%eax)
    2080:	44                   	inc    %esp
    2081:	00 1a                	add    %bl,(%edx)
    2083:	00 0f                	add    %cl,(%edi)
    2085:	00 00                	add    %al,(%eax)
    2087:	00 00                	add    %al,(%eax)
    2089:	00 00                	add    %al,(%eax)
    208b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    208f:	00 16                	add    %dl,(%esi)
    2091:	00 00                	add    %al,(%eax)
    2093:	00 00                	add    %al,(%eax)
    2095:	00 00                	add    %al,(%eax)
    2097:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    209b:	00 19                	add    %bl,(%ecx)
    209d:	00 00                	add    %al,(%eax)
    209f:	00 00                	add    %al,(%eax)
    20a1:	00 00                	add    %al,(%eax)
    20a3:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    20a7:	00 1c 00             	add    %bl,(%eax,%eax,1)
    20aa:	00 00                	add    %al,(%eax)
    20ac:	00 00                	add    %al,(%eax)
    20ae:	00 00                	add    %al,(%eax)
    20b0:	44                   	inc    %esp
    20b1:	00 1f                	add    %bl,(%edi)
    20b3:	00 20                	add    %ah,(%eax)
    20b5:	00 00                	add    %al,(%eax)
    20b7:	00 00                	add    %al,(%eax)
    20b9:	00 00                	add    %al,(%eax)
    20bb:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    20bf:	00 28                	add    %ch,(%eax)
    20c1:	00 00                	add    %al,(%eax)
    20c3:	00 e4                	add    %ah,%ah
    20c5:	0f 00 00             	sldt   (%eax)
    20c8:	40                   	inc    %eax
    20c9:	00 00                	add    %al,(%eax)
    20cb:	00 00                	add    %al,(%eax)
    20cd:	00 00                	add    %al,(%eax)
    20cf:	00 ef                	add    %ch,%bh
    20d1:	0f 00 00             	sldt   (%eax)
    20d4:	40                   	inc    %eax
    20d5:	00 00                	add    %al,(%eax)
    20d7:	00 01                	add    %al,(%ecx)
    20d9:	00 00                	add    %al,(%eax)
    20db:	00 fd                	add    %bh,%ch
    20dd:	0f 00 00             	sldt   (%eax)
    20e0:	40                   	inc    %eax
    20e1:	00 00                	add    %al,(%eax)
    20e3:	00 01                	add    %al,(%ecx)
    20e5:	00 00                	add    %al,(%eax)
    20e7:	00 97 0f 00 00 40    	add    %dl,0x4000000f(%edi)
    20ed:	00 00                	add    %al,(%eax)
    20ef:	00 02                	add    %al,(%edx)
    20f1:	00 00                	add    %al,(%eax)
    20f3:	00 0d 10 00 00 24    	add    %cl,0x24000010
    20f9:	00 00                	add    %al,(%eax)
    20fb:	00 40 0c             	add    %al,0xc(%eax)
    20fe:	28 00                	sub    %al,(%eax)
    2100:	00 00                	add    %al,(%eax)
    2102:	00 00                	add    %al,(%eax)
    2104:	44                   	inc    %esp
    2105:	00 28                	add    %ch,(%eax)
	...
    210f:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    2113:	00 05 00 00 00 00    	add    %al,0x0
    2119:	00 00                	add    %al,(%eax)
    211b:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    211f:	00 0a                	add    %cl,(%edx)
    2121:	00 00                	add    %al,(%eax)
    2123:	00 00                	add    %al,(%eax)
    2125:	00 00                	add    %al,(%eax)
    2127:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    212b:	00 19                	add    %bl,(%ecx)
    212d:	00 00                	add    %al,(%eax)
    212f:	00 00                	add    %al,(%eax)
    2131:	00 00                	add    %al,(%eax)
    2133:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    2137:	00 24 00             	add    %ah,(%eax,%eax,1)
    213a:	00 00                	add    %al,(%eax)
    213c:	00 00                	add    %al,(%eax)
    213e:	00 00                	add    %al,(%eax)
    2140:	44                   	inc    %esp
    2141:	00 31                	add    %dh,(%ecx)
    2143:	00 37                	add    %dh,(%edi)
    2145:	00 00                	add    %al,(%eax)
    2147:	00 00                	add    %al,(%eax)
    2149:	00 00                	add    %al,(%eax)
    214b:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    214f:	00 4d 00             	add    %cl,0x0(%ebp)
    2152:	00 00                	add    %al,(%eax)
    2154:	00 00                	add    %al,(%eax)
    2156:	00 00                	add    %al,(%eax)
    2158:	44                   	inc    %esp
    2159:	00 34 00             	add    %dh,(%eax,%eax,1)
    215c:	69 00 00 00 00 00    	imul   $0x0,(%eax),%eax
    2162:	00 00                	add    %al,(%eax)
    2164:	44                   	inc    %esp
    2165:	00 19                	add    %bl,(%ecx)
    2167:	00 7f 00             	add    %bh,0x0(%edi)
    216a:	00 00                	add    %al,(%eax)
    216c:	00 00                	add    %al,(%eax)
    216e:	00 00                	add    %al,(%eax)
    2170:	44                   	inc    %esp
    2171:	00 1a                	add    %bl,(%edx)
    2173:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    2179:	00 00                	add    %al,(%eax)
    217b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    217f:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    2186:	00 00                	add    %al,(%eax)
    2188:	44                   	inc    %esp
    2189:	00 1f                	add    %bl,(%edi)
    218b:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
    2191:	00 00                	add    %al,(%eax)
    2193:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2197:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
    219e:	00 00                	add    %al,(%eax)
    21a0:	44                   	inc    %esp
    21a1:	00 36                	add    %dh,(%esi)
    21a3:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    21a9:	00 00                	add    %al,(%eax)
    21ab:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    21af:	00 b2 00 00 00 00    	add    %dh,0x0(%edx)
    21b5:	00 00                	add    %al,(%eax)
    21b7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    21bb:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
    21c1:	00 00                	add    %al,(%eax)
    21c3:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    21c7:	00 c2                	add    %al,%dl
    21c9:	00 00                	add    %al,(%eax)
    21cb:	00 00                	add    %al,(%eax)
    21cd:	00 00                	add    %al,(%eax)
    21cf:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    21d3:	00 cc                	add    %cl,%ah
    21d5:	00 00                	add    %al,(%eax)
    21d7:	00 00                	add    %al,(%eax)
    21d9:	00 00                	add    %al,(%eax)
    21db:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    21df:	00 d3                	add    %dl,%bl
    21e1:	00 00                	add    %al,(%eax)
    21e3:	00 00                	add    %al,(%eax)
    21e5:	00 00                	add    %al,(%eax)
    21e7:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    21eb:	00 dc                	add    %bl,%ah
    21ed:	00 00                	add    %al,(%eax)
    21ef:	00 00                	add    %al,(%eax)
    21f1:	00 00                	add    %al,(%eax)
    21f3:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    21f7:	00 e3                	add    %ah,%bl
    21f9:	00 00                	add    %al,(%eax)
    21fb:	00 00                	add    %al,(%eax)
    21fd:	00 00                	add    %al,(%eax)
    21ff:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    2203:	00 ea                	add    %ch,%dl
    2205:	00 00                	add    %al,(%eax)
    2207:	00 00                	add    %al,(%eax)
    2209:	00 00                	add    %al,(%eax)
    220b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    220f:	00 f1                	add    %dh,%cl
    2211:	00 00                	add    %al,(%eax)
    2213:	00 00                	add    %al,(%eax)
    2215:	00 00                	add    %al,(%eax)
    2217:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    221b:	00 f6                	add    %dh,%dh
    221d:	00 00                	add    %al,(%eax)
    221f:	00 00                	add    %al,(%eax)
    2221:	00 00                	add    %al,(%eax)
    2223:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    2227:	00 fc                	add    %bh,%ah
    2229:	00 00                	add    %al,(%eax)
    222b:	00 00                	add    %al,(%eax)
    222d:	00 00                	add    %al,(%eax)
    222f:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    2233:	00 05 01 00 00 00    	add    %al,0x1
    2239:	00 00                	add    %al,(%eax)
    223b:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    223f:	00 0a                	add    %cl,(%edx)
    2241:	01 00                	add    %eax,(%eax)
    2243:	00 00                	add    %al,(%eax)
    2245:	00 00                	add    %al,(%eax)
    2247:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    224b:	00 10                	add    %dl,(%eax)
    224d:	01 00                	add    %eax,(%eax)
    224f:	00 00                	add    %al,(%eax)
    2251:	00 00                	add    %al,(%eax)
    2253:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    2257:	00 19                	add    %bl,(%ecx)
    2259:	01 00                	add    %eax,(%eax)
    225b:	00 00                	add    %al,(%eax)
    225d:	00 00                	add    %al,(%eax)
    225f:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2263:	00 22                	add    %ah,(%edx)
    2265:	01 00                	add    %eax,(%eax)
    2267:	00 00                	add    %al,(%eax)
    2269:	00 00                	add    %al,(%eax)
    226b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    226f:	00 29                	add    %ch,(%ecx)
    2271:	01 00                	add    %eax,(%eax)
    2273:	00 00                	add    %al,(%eax)
    2275:	00 00                	add    %al,(%eax)
    2277:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    227b:	00 30                	add    %dh,(%eax)
    227d:	01 00                	add    %eax,(%eax)
    227f:	00 00                	add    %al,(%eax)
    2281:	00 00                	add    %al,(%eax)
    2283:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2287:	00 39                	add    %bh,(%ecx)
    2289:	01 00                	add    %eax,(%eax)
    228b:	00 00                	add    %al,(%eax)
    228d:	00 00                	add    %al,(%eax)
    228f:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2293:	00 40 01             	add    %al,0x1(%eax)
    2296:	00 00                	add    %al,(%eax)
    2298:	00 00                	add    %al,(%eax)
    229a:	00 00                	add    %al,(%eax)
    229c:	44                   	inc    %esp
    229d:	00 47 00             	add    %al,0x0(%edi)
    22a0:	47                   	inc    %edi
    22a1:	01 00                	add    %eax,(%eax)
    22a3:	00 00                	add    %al,(%eax)
    22a5:	00 00                	add    %al,(%eax)
    22a7:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
    22ab:	00 5b 01             	add    %bl,0x1(%ebx)
    22ae:	00 00                	add    %al,(%eax)
    22b0:	00 00                	add    %al,(%eax)
    22b2:	00 00                	add    %al,(%eax)
    22b4:	64 00 00             	add    %al,%fs:(%eax)
    22b7:	00 a0 0d 28 00 21    	add    %ah,0x2100280d(%eax)
    22bd:	10 00                	adc    %al,(%eax)
    22bf:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    22c3:	00 a0 0d 28 00 08    	add    %ah,0x800280d(%eax)
    22c9:	00 00                	add    %al,(%eax)
    22cb:	00 3c 00             	add    %bh,(%eax,%eax,1)
    22ce:	00 00                	add    %al,(%eax)
    22d0:	00 00                	add    %al,(%eax)
    22d2:	00 00                	add    %al,(%eax)
    22d4:	17                   	pop    %ss
    22d5:	00 00                	add    %al,(%eax)
    22d7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    22dd:	00 00                	add    %al,(%eax)
    22df:	00 41 00             	add    %al,0x0(%ecx)
    22e2:	00 00                	add    %al,(%eax)
    22e4:	80 00 00             	addb   $0x0,(%eax)
    22e7:	00 00                	add    %al,(%eax)
    22e9:	00 00                	add    %al,(%eax)
    22eb:	00 5b 00             	add    %bl,0x0(%ebx)
    22ee:	00 00                	add    %al,(%eax)
    22f0:	80 00 00             	addb   $0x0,(%eax)
    22f3:	00 00                	add    %al,(%eax)
    22f5:	00 00                	add    %al,(%eax)
    22f7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    22fd:	00 00                	add    %al,(%eax)
    22ff:	00 00                	add    %al,(%eax)
    2301:	00 00                	add    %al,(%eax)
    2303:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2309:	00 00                	add    %al,(%eax)
    230b:	00 00                	add    %al,(%eax)
    230d:	00 00                	add    %al,(%eax)
    230f:	00 e1                	add    %ah,%cl
    2311:	00 00                	add    %al,(%eax)
    2313:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2319:	00 00                	add    %al,(%eax)
    231b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    231e:	00 00                	add    %al,(%eax)
    2320:	80 00 00             	addb   $0x0,(%eax)
    2323:	00 00                	add    %al,(%eax)
    2325:	00 00                	add    %al,(%eax)
    2327:	00 37                	add    %dh,(%edi)
    2329:	01 00                	add    %eax,(%eax)
    232b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2331:	00 00                	add    %al,(%eax)
    2333:	00 5d 01             	add    %bl,0x1(%ebp)
    2336:	00 00                	add    %al,(%eax)
    2338:	80 00 00             	addb   $0x0,(%eax)
    233b:	00 00                	add    %al,(%eax)
    233d:	00 00                	add    %al,(%eax)
    233f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2345:	00 00                	add    %al,(%eax)
    2347:	00 00                	add    %al,(%eax)
    2349:	00 00                	add    %al,(%eax)
    234b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2351:	00 00                	add    %al,(%eax)
    2353:	00 00                	add    %al,(%eax)
    2355:	00 00                	add    %al,(%eax)
    2357:	00 d2                	add    %dl,%dl
    2359:	01 00                	add    %eax,(%eax)
    235b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2361:	00 00                	add    %al,(%eax)
    2363:	00 ec                	add    %ch,%ah
    2365:	01 00                	add    %eax,(%eax)
    2367:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    236d:	00 00                	add    %al,(%eax)
    236f:	00 07                	add    %al,(%edi)
    2371:	02 00                	add    (%eax),%al
    2373:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2379:	00 00                	add    %al,(%eax)
    237b:	00 28                	add    %ch,(%eax)
    237d:	02 00                	add    (%eax),%al
    237f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2385:	00 00                	add    %al,(%eax)
    2387:	00 47 02             	add    %al,0x2(%edi)
    238a:	00 00                	add    %al,(%eax)
    238c:	80 00 00             	addb   $0x0,(%eax)
    238f:	00 00                	add    %al,(%eax)
    2391:	00 00                	add    %al,(%eax)
    2393:	00 66 02             	add    %ah,0x2(%esi)
    2396:	00 00                	add    %al,(%eax)
    2398:	80 00 00             	addb   $0x0,(%eax)
    239b:	00 00                	add    %al,(%eax)
    239d:	00 00                	add    %al,(%eax)
    239f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    23a5:	00 00                	add    %al,(%eax)
    23a7:	00 00                	add    %al,(%eax)
    23a9:	00 00                	add    %al,(%eax)
    23ab:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    23b1:	00 00                	add    %al,(%eax)
    23b3:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    23b9:	02 00                	add    (%eax),%al
    23bb:	00 c2                	add    %al,%dl
    23bd:	00 00                	add    %al,(%eax)
    23bf:	00 00                	add    %al,(%eax)
    23c1:	00 00                	add    %al,(%eax)
    23c3:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    23c9:	00 00                	add    %al,(%eax)
    23cb:	00 37                	add    %dh,(%edi)
    23cd:	53                   	push   %ebx
    23ce:	00 00                	add    %al,(%eax)
    23d0:	29 04 00             	sub    %eax,(%eax,%eax,1)
    23d3:	00 c2                	add    %al,%dl
    23d5:	00 00                	add    %al,(%eax)
    23d7:	00 65 97             	add    %ah,-0x69(%ebp)
    23da:	00 00                	add    %al,(%eax)
    23dc:	27                   	daa    
    23dd:	10 00                	adc    %al,(%eax)
    23df:	00 24 00             	add    %ah,(%eax,%eax,1)
    23e2:	00 00                	add    %al,(%eax)
    23e4:	a0 0d 28 00 00       	mov    0x280d,%al
    23e9:	00 00                	add    %al,(%eax)
    23eb:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    23ef:	00 00                	add    %al,(%eax)
    23f1:	00 00                	add    %al,(%eax)
    23f3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    23f9:	00 00                	add    %al,(%eax)
    23fb:	00 a1 0d 28 00 00    	add    %ah,0x280d(%ecx)
    2401:	00 00                	add    %al,(%eax)
    2403:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    2407:	00 01                	add    %al,(%ecx)
    2409:	00 00                	add    %al,(%eax)
    240b:	00 21                	add    %ah,(%ecx)
    240d:	10 00                	adc    %al,(%eax)
    240f:	00 84 00 00 00 a6 0d 	add    %al,0xda60000(%eax,%eax,1)
    2416:	28 00                	sub    %al,(%eax)
    2418:	00 00                	add    %al,(%eax)
    241a:	00 00                	add    %al,(%eax)
    241c:	44                   	inc    %esp
    241d:	00 17                	add    %dl,(%edi)
    241f:	00 06                	add    %al,(%esi)
    2421:	00 00                	add    %al,(%eax)
    2423:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2429:	00 00                	add    %al,(%eax)
    242b:	00 a8 0d 28 00 00    	add    %ch,0x280d(%eax)
    2431:	00 00                	add    %al,(%eax)
    2433:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    2437:	00 08                	add    %cl,(%eax)
    2439:	00 00                	add    %al,(%eax)
    243b:	00 21                	add    %ah,(%ecx)
    243d:	10 00                	adc    %al,(%eax)
    243f:	00 84 00 00 00 d8 0d 	add    %al,0xdd80000(%eax,%eax,1)
    2446:	28 00                	sub    %al,(%eax)
    2448:	00 00                	add    %al,(%eax)
    244a:	00 00                	add    %al,(%eax)
    244c:	44                   	inc    %esp
    244d:	00 5d 00             	add    %bl,0x0(%ebp)
    2450:	38 00                	cmp    %al,(%eax)
    2452:	00 00                	add    %al,(%eax)
    2454:	38 10                	cmp    %dl,(%eax)
    2456:	00 00                	add    %al,(%eax)
    2458:	24 00                	and    $0x0,%al
    245a:	00 00                	add    %al,(%eax)
    245c:	da 0d 28 00 4d 10    	fimull 0x104d0028
    2462:	00 00                	add    %al,(%eax)
    2464:	a0 00 00 00 08       	mov    0x8000000,%al
    2469:	00 00                	add    %al,(%eax)
    246b:	00 00                	add    %al,(%eax)
    246d:	00 00                	add    %al,(%eax)
    246f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    2473:	00 00                	add    %al,(%eax)
    2475:	00 00                	add    %al,(%eax)
    2477:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    247d:	00 00                	add    %al,(%eax)
    247f:	00 db                	add    %bl,%bl
    2481:	0d 28 00 00 00       	or     $0x28,%eax
    2486:	00 00                	add    %al,(%eax)
    2488:	44                   	inc    %esp
    2489:	00 6c 00 01          	add    %ch,0x1(%eax,%eax,1)
    248d:	00 00                	add    %al,(%eax)
    248f:	00 21                	add    %ah,(%ecx)
    2491:	10 00                	adc    %al,(%eax)
    2493:	00 84 00 00 00 e0 0d 	add    %al,0xde00000(%eax,%eax,1)
    249a:	28 00                	sub    %al,(%eax)
    249c:	00 00                	add    %al,(%eax)
    249e:	00 00                	add    %al,(%eax)
    24a0:	44                   	inc    %esp
    24a1:	00 64 00 06          	add    %ah,0x6(%eax,%eax,1)
    24a5:	00 00                	add    %al,(%eax)
    24a7:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    24ad:	00 00                	add    %al,(%eax)
    24af:	00 e2                	add    %ah,%dl
    24b1:	0d 28 00 00 00       	or     $0x28,%eax
    24b6:	00 00                	add    %al,(%eax)
    24b8:	44                   	inc    %esp
    24b9:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    24bd:	00 00                	add    %al,(%eax)
    24bf:	00 21                	add    %ah,(%ecx)
    24c1:	10 00                	adc    %al,(%eax)
    24c3:	00 84 00 00 00 e4 0d 	add    %al,0xde40000(%eax,%eax,1)
    24ca:	28 00                	sub    %al,(%eax)
    24cc:	00 00                	add    %al,(%eax)
    24ce:	00 00                	add    %al,(%eax)
    24d0:	44                   	inc    %esp
    24d1:	00 64 00 0a          	add    %ah,0xa(%eax,%eax,1)
    24d5:	00 00                	add    %al,(%eax)
    24d7:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    24dd:	00 00                	add    %al,(%eax)
    24df:	00 e7                	add    %ah,%bh
    24e1:	0d 28 00 00 00       	or     $0x28,%eax
    24e6:	00 00                	add    %al,(%eax)
    24e8:	44                   	inc    %esp
    24e9:	00 6c 00 0d          	add    %ch,0xd(%eax,%eax,1)
    24ed:	00 00                	add    %al,(%eax)
    24ef:	00 00                	add    %al,(%eax)
    24f1:	00 00                	add    %al,(%eax)
    24f3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    24f7:	00 0e                	add    %cl,(%esi)
    24f9:	00 00                	add    %al,(%eax)
    24fb:	00 21                	add    %ah,(%ecx)
    24fd:	10 00                	adc    %al,(%eax)
    24ff:	00 84 00 00 00 eb 0d 	add    %al,0xdeb0000(%eax,%eax,1)
    2506:	28 00                	sub    %al,(%eax)
    2508:	00 00                	add    %al,(%eax)
    250a:	00 00                	add    %al,(%eax)
    250c:	44                   	inc    %esp
    250d:	00 6a 00             	add    %ch,0x0(%edx)
    2510:	11 00                	adc    %eax,(%eax)
    2512:	00 00                	add    %al,(%eax)
    2514:	00 00                	add    %al,(%eax)
    2516:	00 00                	add    %al,(%eax)
    2518:	44                   	inc    %esp
    2519:	00 7c 00 22          	add    %bh,0x22(%eax,%eax,1)
    251d:	00 00                	add    %al,(%eax)
    251f:	00 60 10             	add    %ah,0x10(%eax)
    2522:	00 00                	add    %al,(%eax)
    2524:	24 00                	and    $0x0,%al
    2526:	00 00                	add    %al,(%eax)
    2528:	fe 0d 28 00 75 10    	decb   0x10750028
    252e:	00 00                	add    %al,(%eax)
    2530:	a0 00 00 00 08       	mov    0x8000000,%al
    2535:	00 00                	add    %al,(%eax)
    2537:	00 00                	add    %al,(%eax)
    2539:	00 00                	add    %al,(%eax)
    253b:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
    253f:	00 00                	add    %al,(%eax)
    2541:	00 00                	add    %al,(%eax)
    2543:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2549:	00 00                	add    %al,(%eax)
    254b:	00 ff                	add    %bh,%bh
    254d:	0d 28 00 00 00       	or     $0x28,%eax
    2552:	00 00                	add    %al,(%eax)
    2554:	44                   	inc    %esp
    2555:	00 6c 00 01          	add    %ch,0x1(%eax,%eax,1)
    2559:	00 00                	add    %al,(%eax)
    255b:	00 21                	add    %ah,(%ecx)
    255d:	10 00                	adc    %al,(%eax)
    255f:	00 84 00 00 00 04 0e 	add    %al,0xe040000(%eax,%eax,1)
    2566:	28 00                	sub    %al,(%eax)
    2568:	00 00                	add    %al,(%eax)
    256a:	00 00                	add    %al,(%eax)
    256c:	44                   	inc    %esp
    256d:	00 82 00 06 00 00    	add    %al,0x600(%edx)
    2573:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2579:	00 00                	add    %al,(%eax)
    257b:	00 06                	add    %al,(%esi)
    257d:	0e                   	push   %cs
    257e:	28 00                	sub    %al,(%eax)
    2580:	00 00                	add    %al,(%eax)
    2582:	00 00                	add    %al,(%eax)
    2584:	44                   	inc    %esp
    2585:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    2589:	00 00                	add    %al,(%eax)
    258b:	00 21                	add    %ah,(%ecx)
    258d:	10 00                	adc    %al,(%eax)
    258f:	00 84 00 00 00 08 0e 	add    %al,0xe080000(%eax,%eax,1)
    2596:	28 00                	sub    %al,(%eax)
    2598:	00 00                	add    %al,(%eax)
    259a:	00 00                	add    %al,(%eax)
    259c:	44                   	inc    %esp
    259d:	00 82 00 0a 00 00    	add    %al,0xa00(%edx)
    25a3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    25a9:	00 00                	add    %al,(%eax)
    25ab:	00 0b                	add    %cl,(%ebx)
    25ad:	0e                   	push   %cs
    25ae:	28 00                	sub    %al,(%eax)
    25b0:	00 00                	add    %al,(%eax)
    25b2:	00 00                	add    %al,(%eax)
    25b4:	44                   	inc    %esp
    25b5:	00 6c 00 0d          	add    %ch,0xd(%eax,%eax,1)
    25b9:	00 00                	add    %al,(%eax)
    25bb:	00 00                	add    %al,(%eax)
    25bd:	00 00                	add    %al,(%eax)
    25bf:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    25c3:	00 13                	add    %dl,(%ebx)
    25c5:	00 00                	add    %al,(%eax)
    25c7:	00 21                	add    %ah,(%ecx)
    25c9:	10 00                	adc    %al,(%eax)
    25cb:	00 84 00 00 00 14 0e 	add    %al,0xe140000(%eax,%eax,1)
    25d2:	28 00                	sub    %al,(%eax)
    25d4:	00 00                	add    %al,(%eax)
    25d6:	00 00                	add    %al,(%eax)
    25d8:	44                   	inc    %esp
    25d9:	00 88 00 16 00 00    	add    %cl,0x1600(%eax)
    25df:	00 00                	add    %al,(%eax)
    25e1:	00 00                	add    %al,(%eax)
    25e3:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    25e7:	00 27                	add    %ah,(%edi)
    25e9:	00 00                	add    %al,(%eax)
    25eb:	00 81 10 00 00 24    	add    %al,0x24000010(%ecx)
    25f1:	00 00                	add    %al,(%eax)
    25f3:	00 27                	add    %ah,(%edi)
    25f5:	0e                   	push   %cs
    25f6:	28 00                	sub    %al,(%eax)
    25f8:	00 00                	add    %al,(%eax)
    25fa:	00 00                	add    %al,(%eax)
    25fc:	44                   	inc    %esp
    25fd:	00 9e 00 00 00 00    	add    %bl,0x0(%esi)
    2603:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2609:	00 00                	add    %al,(%eax)
    260b:	00 28                	add    %ch,(%eax)
    260d:	0e                   	push   %cs
    260e:	28 00                	sub    %al,(%eax)
    2610:	00 00                	add    %al,(%eax)
    2612:	00 00                	add    %al,(%eax)
    2614:	44                   	inc    %esp
    2615:	00 52 00             	add    %dl,0x0(%edx)
    2618:	01 00                	add    %eax,(%eax)
    261a:	00 00                	add    %al,(%eax)
    261c:	21 10                	and    %edx,(%eax)
    261e:	00 00                	add    %al,(%eax)
    2620:	84 00                	test   %al,(%eax)
    2622:	00 00                	add    %al,(%eax)
    2624:	2d 0e 28 00 00       	sub    $0x280e,%eax
    2629:	00 00                	add    %al,(%eax)
    262b:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    262f:	00 06                	add    %al,(%esi)
    2631:	00 00                	add    %al,(%eax)
    2633:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2639:	00 00                	add    %al,(%eax)
    263b:	00 2f                	add    %ch,(%edi)
    263d:	0e                   	push   %cs
    263e:	28 00                	sub    %al,(%eax)
    2640:	00 00                	add    %al,(%eax)
    2642:	00 00                	add    %al,(%eax)
    2644:	44                   	inc    %esp
    2645:	00 52 00             	add    %dl,0x0(%edx)
    2648:	08 00                	or     %al,(%eax)
    264a:	00 00                	add    %al,(%eax)
    264c:	21 10                	and    %edx,(%eax)
    264e:	00 00                	add    %al,(%eax)
    2650:	84 00                	test   %al,(%eax)
    2652:	00 00                	add    %al,(%eax)
    2654:	30 0e                	xor    %cl,(%esi)
    2656:	28 00                	sub    %al,(%eax)
    2658:	00 00                	add    %al,(%eax)
    265a:	00 00                	add    %al,(%eax)
    265c:	44                   	inc    %esp
    265d:	00 a2 00 09 00 00    	add    %ah,0x900(%edx)
    2663:	00 00                	add    %al,(%eax)
    2665:	00 00                	add    %al,(%eax)
    2667:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    266b:	00 0d 00 00 00 9c    	add    %cl,0x9c000000
    2671:	10 00                	adc    %al,(%eax)
    2673:	00 24 00             	add    %ah,(%eax,%eax,1)
    2676:	00 00                	add    %al,(%eax)
    2678:	36                   	ss
    2679:	0e                   	push   %cs
    267a:	28 00                	sub    %al,(%eax)
    267c:	00 00                	add    %al,(%eax)
    267e:	00 00                	add    %al,(%eax)
    2680:	44                   	inc    %esp
    2681:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    2687:	00 00                	add    %al,(%eax)
    2689:	00 00                	add    %al,(%eax)
    268b:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    268f:	00 03                	add    %al,(%ebx)
    2691:	00 00                	add    %al,(%eax)
    2693:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2699:	00 00                	add    %al,(%eax)
    269b:	00 3e                	add    %bh,(%esi)
    269d:	0e                   	push   %cs
    269e:	28 00                	sub    %al,(%eax)
    26a0:	00 00                	add    %al,(%eax)
    26a2:	00 00                	add    %al,(%eax)
    26a4:	44                   	inc    %esp
    26a5:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    26a9:	00 00                	add    %al,(%eax)
    26ab:	00 21                	add    %ah,(%ecx)
    26ad:	10 00                	adc    %al,(%eax)
    26af:	00 84 00 00 00 46 0e 	add    %al,0xe460000(%eax,%eax,1)
    26b6:	28 00                	sub    %al,(%eax)
    26b8:	00 00                	add    %al,(%eax)
    26ba:	00 00                	add    %al,(%eax)
    26bc:	44                   	inc    %esp
    26bd:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    26c3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    26c9:	00 00                	add    %al,(%eax)
    26cb:	00 4b 0e             	add    %cl,0xe(%ebx)
    26ce:	28 00                	sub    %al,(%eax)
    26d0:	00 00                	add    %al,(%eax)
    26d2:	00 00                	add    %al,(%eax)
    26d4:	44                   	inc    %esp
    26d5:	00 6c 00 15          	add    %ch,0x15(%eax,%eax,1)
    26d9:	00 00                	add    %al,(%eax)
    26db:	00 21                	add    %ah,(%ecx)
    26dd:	10 00                	adc    %al,(%eax)
    26df:	00 84 00 00 00 53 0e 	add    %al,0xe530000(%eax,%eax,1)
    26e6:	28 00                	sub    %al,(%eax)
    26e8:	00 00                	add    %al,(%eax)
    26ea:	00 00                	add    %al,(%eax)
    26ec:	44                   	inc    %esp
    26ed:	00 b3 00 1d 00 00    	add    %dh,0x1d00(%ebx)
    26f3:	00 b2 10 00 00 20    	add    %dh,0x20000010(%edx)
    26f9:	00 00                	add    %al,(%eax)
    26fb:	00 00                	add    %al,(%eax)
    26fd:	00 00                	add    %al,(%eax)
    26ff:	00 c1                	add    %al,%cl
    2701:	10 00                	adc    %al,(%eax)
    2703:	00 20                	add    %ah,(%eax)
	...
    270d:	00 00                	add    %al,(%eax)
    270f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    2713:	00 55 0e             	add    %dl,0xe(%ebp)
    2716:	28 00                	sub    %al,(%eax)
    2718:	d2 10                	rclb   %cl,(%eax)
    271a:	00 00                	add    %al,(%eax)
    271c:	64 00 00             	add    %al,%fs:(%eax)
    271f:	00 55 0e             	add    %dl,0xe(%ebp)
    2722:	28 00                	sub    %al,(%eax)
    2724:	e2 10                	loop   2736 <bootmain-0x27d8ca>
    2726:	00 00                	add    %al,(%eax)
    2728:	84 00                	test   %al,(%eax)
    272a:	00 00                	add    %al,(%eax)
    272c:	55                   	push   %ebp
    272d:	0e                   	push   %cs
    272e:	28 00                	sub    %al,(%eax)
    2730:	00 00                	add    %al,(%eax)
    2732:	00 00                	add    %al,(%eax)
    2734:	44                   	inc    %esp
    2735:	00 09                	add    %cl,(%ecx)
    2737:	00 55 0e             	add    %dl,0xe(%ebp)
    273a:	28 00                	sub    %al,(%eax)
    273c:	00 00                	add    %al,(%eax)
    273e:	00 00                	add    %al,(%eax)
    2740:	44                   	inc    %esp
    2741:	00 0a                	add    %cl,(%edx)
    2743:	00 57 0e             	add    %dl,0xe(%edi)
    2746:	28 00                	sub    %al,(%eax)
    2748:	00 00                	add    %al,(%eax)
    274a:	00 00                	add    %al,(%eax)
    274c:	44                   	inc    %esp
    274d:	00 0b                	add    %cl,(%ebx)
    274f:	00 59 0e             	add    %bl,0xe(%ecx)
    2752:	28 00                	sub    %al,(%eax)
    2754:	00 00                	add    %al,(%eax)
    2756:	00 00                	add    %al,(%eax)
    2758:	44                   	inc    %esp
    2759:	00 0c 00             	add    %cl,(%eax,%eax,1)
    275c:	5a                   	pop    %edx
    275d:	0e                   	push   %cs
    275e:	28 00                	sub    %al,(%eax)
    2760:	00 00                	add    %al,(%eax)
    2762:	00 00                	add    %al,(%eax)
    2764:	44                   	inc    %esp
    2765:	00 0d 00 5c 0e 28    	add    %cl,0x280e5c00
    276b:	00 00                	add    %al,(%eax)
    276d:	00 00                	add    %al,(%eax)
    276f:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    2773:	00 5d 0e             	add    %bl,0xe(%ebp)
    2776:	28 00                	sub    %al,(%eax)
    2778:	00 00                	add    %al,(%eax)
    277a:	00 00                	add    %al,(%eax)
    277c:	44                   	inc    %esp
    277d:	00 0f                	add    %cl,(%edi)
    277f:	00 60 0e             	add    %ah,0xe(%eax)
    2782:	28 00                	sub    %al,(%eax)
    2784:	00 00                	add    %al,(%eax)
    2786:	00 00                	add    %al,(%eax)
    2788:	44                   	inc    %esp
    2789:	00 10                	add    %dl,(%eax)
    278b:	00 62 0e             	add    %ah,0xe(%edx)
    278e:	28 00                	sub    %al,(%eax)
    2790:	00 00                	add    %al,(%eax)
    2792:	00 00                	add    %al,(%eax)
    2794:	44                   	inc    %esp
    2795:	00 11                	add    %dl,(%ecx)
    2797:	00 64 0e 28          	add    %ah,0x28(%esi,%ecx,1)
    279b:	00 00                	add    %al,(%eax)
    279d:	00 00                	add    %al,(%eax)
    279f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    27a3:	00 69 0e             	add    %ch,0xe(%ecx)
    27a6:	28 00                	sub    %al,(%eax)
    27a8:	00 00                	add    %al,(%eax)
    27aa:	00 00                	add    %al,(%eax)
    27ac:	44                   	inc    %esp
    27ad:	00 14 00             	add    %dl,(%eax,%eax,1)
    27b0:	6a 0e                	push   $0xe
    27b2:	28 00                	sub    %al,(%eax)
    27b4:	00 00                	add    %al,(%eax)
    27b6:	00 00                	add    %al,(%eax)
    27b8:	44                   	inc    %esp
    27b9:	00 15 00 6b 0e 28    	add    %dl,0x280e6b00
    27bf:	00 00                	add    %al,(%eax)
    27c1:	00 00                	add    %al,(%eax)
    27c3:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    27c7:	00 6d 0e             	add    %ch,0xe(%ebp)
    27ca:	28 00                	sub    %al,(%eax)
    27cc:	00 00                	add    %al,(%eax)
    27ce:	00 00                	add    %al,(%eax)
    27d0:	44                   	inc    %esp
    27d1:	00 17                	add    %dl,(%edi)
    27d3:	00 6f 0e             	add    %ch,0xe(%edi)
    27d6:	28 00                	sub    %al,(%eax)
    27d8:	00 00                	add    %al,(%eax)
    27da:	00 00                	add    %al,(%eax)
    27dc:	44                   	inc    %esp
    27dd:	00 1b                	add    %bl,(%ebx)
    27df:	00 70 0e             	add    %dh,0xe(%eax)
    27e2:	28 00                	sub    %al,(%eax)
    27e4:	00 00                	add    %al,(%eax)
    27e6:	00 00                	add    %al,(%eax)
    27e8:	44                   	inc    %esp
    27e9:	00 1c 00             	add    %bl,(%eax,%eax,1)
    27ec:	72 0e                	jb     27fc <bootmain-0x27d804>
    27ee:	28 00                	sub    %al,(%eax)
    27f0:	00 00                	add    %al,(%eax)
    27f2:	00 00                	add    %al,(%eax)
    27f4:	44                   	inc    %esp
    27f5:	00 1d 00 74 0e 28    	add    %bl,0x280e7400
    27fb:	00 00                	add    %al,(%eax)
    27fd:	00 00                	add    %al,(%eax)
    27ff:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2803:	00 75 0e             	add    %dh,0xe(%ebp)
    2806:	28 00                	sub    %al,(%eax)
    2808:	00 00                	add    %al,(%eax)
    280a:	00 00                	add    %al,(%eax)
    280c:	44                   	inc    %esp
    280d:	00 1f                	add    %bl,(%edi)
    280f:	00 77 0e             	add    %dh,0xe(%edi)
    2812:	28 00                	sub    %al,(%eax)
    2814:	00 00                	add    %al,(%eax)
    2816:	00 00                	add    %al,(%eax)
    2818:	44                   	inc    %esp
    2819:	00 20                	add    %ah,(%eax)
    281b:	00 78 0e             	add    %bh,0xe(%eax)
    281e:	28 00                	sub    %al,(%eax)
    2820:	00 00                	add    %al,(%eax)
    2822:	00 00                	add    %al,(%eax)
    2824:	44                   	inc    %esp
    2825:	00 21                	add    %ah,(%ecx)
    2827:	00 7b 0e             	add    %bh,0xe(%ebx)
    282a:	28 00                	sub    %al,(%eax)
    282c:	00 00                	add    %al,(%eax)
    282e:	00 00                	add    %al,(%eax)
    2830:	44                   	inc    %esp
    2831:	00 22                	add    %ah,(%edx)
    2833:	00 7d 0e             	add    %bh,0xe(%ebp)
    2836:	28 00                	sub    %al,(%eax)
    2838:	00 00                	add    %al,(%eax)
    283a:	00 00                	add    %al,(%eax)
    283c:	44                   	inc    %esp
    283d:	00 23                	add    %ah,(%ebx)
    283f:	00 7f 0e             	add    %bh,0xe(%edi)
    2842:	28 00                	sub    %al,(%eax)
    2844:	00 00                	add    %al,(%eax)
    2846:	00 00                	add    %al,(%eax)
    2848:	44                   	inc    %esp
    2849:	00 25 00 84 0e 28    	add    %ah,0x280e8400
    284f:	00 00                	add    %al,(%eax)
    2851:	00 00                	add    %al,(%eax)
    2853:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
    2857:	00 85 0e 28 00 00    	add    %al,0x280e(%ebp)
    285d:	00 00                	add    %al,(%eax)
    285f:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    2863:	00 86 0e 28 00 00    	add    %al,0x280e(%esi)
    2869:	00 00                	add    %al,(%eax)
    286b:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    286f:	00 88 0e 28 00 00    	add    %cl,0x280e(%eax)
    2875:	00 00                	add    %al,(%eax)
    2877:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    287b:	00 8a 0e 28 00 00    	add    %cl,0x280e(%edx)
    2881:	00 00                	add    %al,(%eax)
    2883:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    2887:	00 8b 0e 28 00 00    	add    %cl,0x280e(%ebx)
    288d:	00 00                	add    %al,(%eax)
    288f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    2893:	00 90 0e 28 00 00    	add    %dl,0x280e(%eax)
    2899:	00 00                	add    %al,(%eax)
    289b:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    289f:	00 95 0e 28 00 00    	add    %dl,0x280e(%ebp)
    28a5:	00 00                	add    %al,(%eax)
    28a7:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    28ab:	00 9a 0e 28 00 00    	add    %bl,0x280e(%edx)
    28b1:	00 00                	add    %al,(%eax)
    28b3:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    28b7:	00 9b 0e 28 00 00    	add    %bl,0x280e(%ebx)
    28bd:	00 00                	add    %al,(%eax)
    28bf:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    28c3:	00 a0 0e 28 00 00    	add    %ah,0x280e(%eax)
    28c9:	00 00                	add    %al,(%eax)
    28cb:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    28cf:	00 a5 0e 28 00 00    	add    %ah,0x280e(%ebp)
    28d5:	00 00                	add    %al,(%eax)
    28d7:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    28db:	00 aa 0e 28 00 ed    	add    %ch,-0x12ffd7f2(%edx)
    28e1:	10 00                	adc    %al,(%eax)
    28e3:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    28e7:	00 ab 0e 28 00 08    	add    %ch,0x800280e(%ebx)
    28ed:	00 00                	add    %al,(%eax)
    28ef:	00 3c 00             	add    %bh,(%eax,%eax,1)
    28f2:	00 00                	add    %al,(%eax)
    28f4:	00 00                	add    %al,(%eax)
    28f6:	00 00                	add    %al,(%eax)
    28f8:	17                   	pop    %ss
    28f9:	00 00                	add    %al,(%eax)
    28fb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2901:	00 00                	add    %al,(%eax)
    2903:	00 41 00             	add    %al,0x0(%ecx)
    2906:	00 00                	add    %al,(%eax)
    2908:	80 00 00             	addb   $0x0,(%eax)
    290b:	00 00                	add    %al,(%eax)
    290d:	00 00                	add    %al,(%eax)
    290f:	00 5b 00             	add    %bl,0x0(%ebx)
    2912:	00 00                	add    %al,(%eax)
    2914:	80 00 00             	addb   $0x0,(%eax)
    2917:	00 00                	add    %al,(%eax)
    2919:	00 00                	add    %al,(%eax)
    291b:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2921:	00 00                	add    %al,(%eax)
    2923:	00 00                	add    %al,(%eax)
    2925:	00 00                	add    %al,(%eax)
    2927:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    292d:	00 00                	add    %al,(%eax)
    292f:	00 00                	add    %al,(%eax)
    2931:	00 00                	add    %al,(%eax)
    2933:	00 e1                	add    %ah,%cl
    2935:	00 00                	add    %al,(%eax)
    2937:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    293d:	00 00                	add    %al,(%eax)
    293f:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2942:	00 00                	add    %al,(%eax)
    2944:	80 00 00             	addb   $0x0,(%eax)
    2947:	00 00                	add    %al,(%eax)
    2949:	00 00                	add    %al,(%eax)
    294b:	00 37                	add    %dh,(%edi)
    294d:	01 00                	add    %eax,(%eax)
    294f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2955:	00 00                	add    %al,(%eax)
    2957:	00 5d 01             	add    %bl,0x1(%ebp)
    295a:	00 00                	add    %al,(%eax)
    295c:	80 00 00             	addb   $0x0,(%eax)
    295f:	00 00                	add    %al,(%eax)
    2961:	00 00                	add    %al,(%eax)
    2963:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2969:	00 00                	add    %al,(%eax)
    296b:	00 00                	add    %al,(%eax)
    296d:	00 00                	add    %al,(%eax)
    296f:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2975:	00 00                	add    %al,(%eax)
    2977:	00 00                	add    %al,(%eax)
    2979:	00 00                	add    %al,(%eax)
    297b:	00 d2                	add    %dl,%dl
    297d:	01 00                	add    %eax,(%eax)
    297f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2985:	00 00                	add    %al,(%eax)
    2987:	00 ec                	add    %ch,%ah
    2989:	01 00                	add    %eax,(%eax)
    298b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2991:	00 00                	add    %al,(%eax)
    2993:	00 07                	add    %al,(%edi)
    2995:	02 00                	add    (%eax),%al
    2997:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    299d:	00 00                	add    %al,(%eax)
    299f:	00 28                	add    %ch,(%eax)
    29a1:	02 00                	add    (%eax),%al
    29a3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    29a9:	00 00                	add    %al,(%eax)
    29ab:	00 47 02             	add    %al,0x2(%edi)
    29ae:	00 00                	add    %al,(%eax)
    29b0:	80 00 00             	addb   $0x0,(%eax)
    29b3:	00 00                	add    %al,(%eax)
    29b5:	00 00                	add    %al,(%eax)
    29b7:	00 66 02             	add    %ah,0x2(%esi)
    29ba:	00 00                	add    %al,(%eax)
    29bc:	80 00 00             	addb   $0x0,(%eax)
    29bf:	00 00                	add    %al,(%eax)
    29c1:	00 00                	add    %al,(%eax)
    29c3:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    29c9:	00 00                	add    %al,(%eax)
    29cb:	00 00                	add    %al,(%eax)
    29cd:	00 00                	add    %al,(%eax)
    29cf:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    29d5:	00 00                	add    %al,(%eax)
    29d7:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    29dd:	02 00                	add    (%eax),%al
    29df:	00 c2                	add    %al,%dl
    29e1:	00 00                	add    %al,(%eax)
    29e3:	00 00                	add    %al,(%eax)
    29e5:	00 00                	add    %al,(%eax)
    29e7:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    29ed:	00 00                	add    %al,(%eax)
    29ef:	00 37                	add    %dh,(%edi)
    29f1:	53                   	push   %ebx
    29f2:	00 00                	add    %al,(%eax)
    29f4:	29 04 00             	sub    %eax,(%eax,%eax,1)
    29f7:	00 c2                	add    %al,%dl
    29f9:	00 00                	add    %al,(%eax)
    29fb:	00 65 97             	add    %ah,-0x69(%ebp)
    29fe:	00 00                	add    %al,(%eax)
    2a00:	f4                   	hlt    
    2a01:	10 00                	adc    %al,(%eax)
    2a03:	00 24 00             	add    %ah,(%eax,%eax,1)
    2a06:	00 00                	add    %al,(%eax)
    2a08:	ab                   	stos   %eax,%es:(%edi)
    2a09:	0e                   	push   %cs
    2a0a:	28 00                	sub    %al,(%eax)
    2a0c:	07                   	pop    %es
    2a0d:	11 00                	adc    %eax,(%eax)
    2a0f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2a15:	00 00                	add    %al,(%eax)
    2a17:	00 1b                	add    %bl,(%ebx)
    2a19:	11 00                	adc    %eax,(%eax)
    2a1b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    2a21:	00 00                	add    %al,(%eax)
    2a23:	00 61 0d             	add    %ah,0xd(%ecx)
    2a26:	00 00                	add    %al,(%eax)
    2a28:	a0 00 00 00 10       	mov    0x10000000,%al
    2a2d:	00 00                	add    %al,(%eax)
    2a2f:	00 00                	add    %al,(%eax)
    2a31:	00 00                	add    %al,(%eax)
    2a33:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    2a3f:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
    2a43:	00 03                	add    %al,(%ebx)
    2a45:	00 00                	add    %al,(%eax)
    2a47:	00 00                	add    %al,(%eax)
    2a49:	00 00                	add    %al,(%eax)
    2a4b:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2a4f:	00 09                	add    %cl,(%ecx)
    2a51:	00 00                	add    %al,(%eax)
    2a53:	00 00                	add    %al,(%eax)
    2a55:	00 00                	add    %al,(%eax)
    2a57:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
    2a5b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2a5e:	00 00                	add    %al,(%eax)
    2a60:	00 00                	add    %al,(%eax)
    2a62:	00 00                	add    %al,(%eax)
    2a64:	44                   	inc    %esp
    2a65:	00 07                	add    %al,(%edi)
    2a67:	00 13                	add    %dl,(%ebx)
    2a69:	00 00                	add    %al,(%eax)
    2a6b:	00 00                	add    %al,(%eax)
    2a6d:	00 00                	add    %al,(%eax)
    2a6f:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2a73:	00 16                	add    %dl,(%esi)
    2a75:	00 00                	add    %al,(%eax)
    2a77:	00 00                	add    %al,(%eax)
    2a79:	00 00                	add    %al,(%eax)
    2a7b:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    2a7f:	00 18                	add    %bl,(%eax)
    2a81:	00 00                	add    %al,(%eax)
    2a83:	00 00                	add    %al,(%eax)
    2a85:	00 00                	add    %al,(%eax)
    2a87:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    2a8b:	00 1b                	add    %bl,(%ebx)
    2a8d:	00 00                	add    %al,(%eax)
    2a8f:	00 00                	add    %al,(%eax)
    2a91:	00 00                	add    %al,(%eax)
    2a93:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    2a97:	00 22                	add    %ah,(%edx)
    2a99:	00 00                	add    %al,(%eax)
    2a9b:	00 00                	add    %al,(%eax)
    2a9d:	00 00                	add    %al,(%eax)
    2a9f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    2aa3:	00 29                	add    %ch,(%ecx)
    2aa5:	00 00                	add    %al,(%eax)
    2aa7:	00 27                	add    %ah,(%edi)
    2aa9:	11 00                	adc    %eax,(%eax)
    2aab:	00 40 00             	add    %al,0x0(%eax)
    2aae:	00 00                	add    %al,(%eax)
    2ab0:	00 00                	add    %al,(%eax)
    2ab2:	00 00                	add    %al,(%eax)
    2ab4:	34 11                	xor    $0x11,%al
    2ab6:	00 00                	add    %al,(%eax)
    2ab8:	40                   	inc    %eax
    2ab9:	00 00                	add    %al,(%eax)
    2abb:	00 02                	add    %al,(%edx)
    2abd:	00 00                	add    %al,(%eax)
    2abf:	00 9b 0d 00 00 40    	add    %bl,0x4000000d(%ebx)
    2ac5:	00 00                	add    %al,(%eax)
    2ac7:	00 01                	add    %al,(%ecx)
    2ac9:	00 00                	add    %al,(%eax)
    2acb:	00 40 11             	add    %al,0x11(%eax)
    2ace:	00 00                	add    %al,(%eax)
    2ad0:	24 00                	and    $0x0,%al
    2ad2:	00 00                	add    %al,(%eax)
    2ad4:	d6                   	(bad)  
    2ad5:	0e                   	push   %cs
    2ad6:	28 00                	sub    %al,(%eax)
    2ad8:	53                   	push   %ebx
    2ad9:	11 00                	adc    %eax,(%eax)
    2adb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2ae1:	00 00                	add    %al,(%eax)
    2ae3:	00 60 11             	add    %ah,0x11(%eax)
    2ae6:	00 00                	add    %al,(%eax)
    2ae8:	a0 00 00 00 0c       	mov    0xc000000,%al
    2aed:	00 00                	add    %al,(%eax)
    2aef:	00 00                	add    %al,(%eax)
    2af1:	00 00                	add    %al,(%eax)
    2af3:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
	...
    2aff:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    2b03:	00 07                	add    %al,(%edi)
    2b05:	00 00                	add    %al,(%eax)
    2b07:	00 00                	add    %al,(%eax)
    2b09:	00 00                	add    %al,(%eax)
    2b0b:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2b0f:	00 0a                	add    %cl,(%edx)
    2b11:	00 00                	add    %al,(%eax)
    2b13:	00 00                	add    %al,(%eax)
    2b15:	00 00                	add    %al,(%eax)
    2b17:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    2b1b:	00 10                	add    %dl,(%eax)
    2b1d:	00 00                	add    %al,(%eax)
    2b1f:	00 00                	add    %al,(%eax)
    2b21:	00 00                	add    %al,(%eax)
    2b23:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    2b27:	00 14 00             	add    %dl,(%eax,%eax,1)
    2b2a:	00 00                	add    %al,(%eax)
    2b2c:	00 00                	add    %al,(%eax)
    2b2e:	00 00                	add    %al,(%eax)
    2b30:	44                   	inc    %esp
    2b31:	00 1a                	add    %bl,(%edx)
    2b33:	00 19                	add    %bl,(%ecx)
    2b35:	00 00                	add    %al,(%eax)
    2b37:	00 00                	add    %al,(%eax)
    2b39:	00 00                	add    %al,(%eax)
    2b3b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2b3f:	00 21                	add    %ah,(%ecx)
    2b41:	00 00                	add    %al,(%eax)
    2b43:	00 00                	add    %al,(%eax)
    2b45:	00 00                	add    %al,(%eax)
    2b47:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2b4b:	00 27                	add    %ah,(%edi)
    2b4d:	00 00                	add    %al,(%eax)
    2b4f:	00 00                	add    %al,(%eax)
    2b51:	00 00                	add    %al,(%eax)
    2b53:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2b57:	00 2a                	add    %ch,(%edx)
    2b59:	00 00                	add    %al,(%eax)
    2b5b:	00 00                	add    %al,(%eax)
    2b5d:	00 00                	add    %al,(%eax)
    2b5f:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2b63:	00 2d 00 00 00 00    	add    %ch,0x0
    2b69:	00 00                	add    %al,(%eax)
    2b6b:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2b6f:	00 2f                	add    %ch,(%edi)
    2b71:	00 00                	add    %al,(%eax)
    2b73:	00 00                	add    %al,(%eax)
    2b75:	00 00                	add    %al,(%eax)
    2b77:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2b7b:	00 36                	add    %dh,(%esi)
    2b7d:	00 00                	add    %al,(%eax)
    2b7f:	00 00                	add    %al,(%eax)
    2b81:	00 00                	add    %al,(%eax)
    2b83:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    2b87:	00 39                	add    %bh,(%ecx)
    2b89:	00 00                	add    %al,(%eax)
    2b8b:	00 00                	add    %al,(%eax)
    2b8d:	00 00                	add    %al,(%eax)
    2b8f:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2b93:	00 3b                	add    %bh,(%ebx)
    2b95:	00 00                	add    %al,(%eax)
    2b97:	00 27                	add    %ah,(%edi)
    2b99:	11 00                	adc    %eax,(%eax)
    2b9b:	00 40 00             	add    %al,0x0(%eax)
    2b9e:	00 00                	add    %al,(%eax)
    2ba0:	00 00                	add    %al,(%eax)
    2ba2:	00 00                	add    %al,(%eax)
    2ba4:	6c                   	insb   (%dx),%es:(%edi)
    2ba5:	11 00                	adc    %eax,(%eax)
    2ba7:	00 24 00             	add    %ah,(%eax,%eax,1)
    2baa:	00 00                	add    %al,(%eax)
    2bac:	14 0f                	adc    $0xf,%al
    2bae:	28 00                	sub    %al,(%eax)
    2bb0:	53                   	push   %ebx
    2bb1:	11 00                	adc    %eax,(%eax)
    2bb3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2bb9:	00 00                	add    %al,(%eax)
    2bbb:	00 00                	add    %al,(%eax)
    2bbd:	00 00                	add    %al,(%eax)
    2bbf:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
	...
    2bcb:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    2bcf:	00 09                	add    %cl,(%ecx)
    2bd1:	00 00                	add    %al,(%eax)
    2bd3:	00 00                	add    %al,(%eax)
    2bd5:	00 00                	add    %al,(%eax)
    2bd7:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2bdb:	00 13                	add    %dl,(%ebx)
    2bdd:	00 00                	add    %al,(%eax)
    2bdf:	00 00                	add    %al,(%eax)
    2be1:	00 00                	add    %al,(%eax)
    2be3:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    2be7:	00 16                	add    %dl,(%esi)
    2be9:	00 00                	add    %al,(%eax)
    2beb:	00 00                	add    %al,(%eax)
    2bed:	00 00                	add    %al,(%eax)
    2bef:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2bf3:	00 18                	add    %bl,(%eax)
    2bf5:	00 00                	add    %al,(%eax)
    2bf7:	00 00                	add    %al,(%eax)
    2bf9:	00 00                	add    %al,(%eax)
    2bfb:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    2bff:	00 1e                	add    %bl,(%esi)
    2c01:	00 00                	add    %al,(%eax)
    2c03:	00 00                	add    %al,(%eax)
    2c05:	00 00                	add    %al,(%eax)
    2c07:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2c0b:	00 24 00             	add    %ah,(%eax,%eax,1)
    2c0e:	00 00                	add    %al,(%eax)
    2c10:	00 00                	add    %al,(%eax)
    2c12:	00 00                	add    %al,(%eax)
    2c14:	44                   	inc    %esp
    2c15:	00 2f                	add    %ch,(%edi)
    2c17:	00 25 00 00 00 00    	add    %ah,0x0
    2c1d:	00 00                	add    %al,(%eax)
    2c1f:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2c23:	00 28                	add    %ch,(%eax)
    2c25:	00 00                	add    %al,(%eax)
    2c27:	00 00                	add    %al,(%eax)
    2c29:	00 00                	add    %al,(%eax)
    2c2b:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    2c2f:	00 2b                	add    %ch,(%ebx)
    2c31:	00 00                	add    %al,(%eax)
    2c33:	00 00                	add    %al,(%eax)
    2c35:	00 00                	add    %al,(%eax)
    2c37:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    2c3b:	00 2d 00 00 00 00    	add    %ch,0x0
    2c41:	00 00                	add    %al,(%eax)
    2c43:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
    2c47:	00 30                	add    %dh,(%eax)
    2c49:	00 00                	add    %al,(%eax)
    2c4b:	00 7e 11             	add    %bh,0x11(%esi)
    2c4e:	00 00                	add    %al,(%eax)
    2c50:	40                   	inc    %eax
    2c51:	00 00                	add    %al,(%eax)
    2c53:	00 00                	add    %al,(%eax)
    2c55:	00 00                	add    %al,(%eax)
    2c57:	00 27                	add    %ah,(%edi)
    2c59:	11 00                	adc    %eax,(%eax)
    2c5b:	00 40 00             	add    %al,0x0(%eax)
    2c5e:	00 00                	add    %al,(%eax)
    2c60:	02 00                	add    (%eax),%al
    2c62:	00 00                	add    %al,(%eax)
    2c64:	00 00                	add    %al,(%eax)
    2c66:	00 00                	add    %al,(%eax)
    2c68:	c0 00 00             	rolb   $0x0,(%eax)
	...
    2c73:	00 e0                	add    %ah,%al
    2c75:	00 00                	add    %al,(%eax)
    2c77:	00 35 00 00 00 8a    	add    %dh,0x8a000000
    2c7d:	11 00                	adc    %eax,(%eax)
    2c7f:	00 24 00             	add    %ah,(%eax,%eax,1)
    2c82:	00 00                	add    %al,(%eax)
    2c84:	49                   	dec    %ecx
    2c85:	0f 28 00             	movaps (%eax),%xmm0
    2c88:	53                   	push   %ebx
    2c89:	11 00                	adc    %eax,(%eax)
    2c8b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2c91:	00 00                	add    %al,(%eax)
    2c93:	00 00                	add    %al,(%eax)
    2c95:	00 00                	add    %al,(%eax)
    2c97:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
	...
    2ca3:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    2ca7:	00 03                	add    %al,(%ebx)
    2ca9:	00 00                	add    %al,(%eax)
    2cab:	00 00                	add    %al,(%eax)
    2cad:	00 00                	add    %al,(%eax)
    2caf:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2cb3:	00 06                	add    %al,(%esi)
    2cb5:	00 00                	add    %al,(%eax)
    2cb7:	00 00                	add    %al,(%eax)
    2cb9:	00 00                	add    %al,(%eax)
    2cbb:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
    2cbf:	00 07                	add    %al,(%edi)
    2cc1:	00 00                	add    %al,(%eax)
    2cc3:	00 00                	add    %al,(%eax)
    2cc5:	00 00                	add    %al,(%eax)
    2cc7:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2ccb:	00 0d 00 00 00 27    	add    %cl,0x27000000
    2cd1:	11 00                	adc    %eax,(%eax)
    2cd3:	00 40 00             	add    %al,0x0(%eax)
    2cd6:	00 00                	add    %al,(%eax)
    2cd8:	02 00                	add    (%eax),%al
    2cda:	00 00                	add    %al,(%eax)
    2cdc:	00 00                	add    %al,(%eax)
    2cde:	00 00                	add    %al,(%eax)
    2ce0:	64 00 00             	add    %al,%fs:(%eax)
    2ce3:	00 57 0f             	add    %dl,0xf(%edi)
    2ce6:	28 00                	sub    %al,(%eax)
    2ce8:	9e                   	sahf   
    2ce9:	11 00                	adc    %eax,(%eax)
    2ceb:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    2cef:	00 57 0f             	add    %dl,0xf(%edi)
    2cf2:	28 00                	sub    %al,(%eax)
    2cf4:	08 00                	or     %al,(%eax)
    2cf6:	00 00                	add    %al,(%eax)
    2cf8:	3c 00                	cmp    $0x0,%al
    2cfa:	00 00                	add    %al,(%eax)
    2cfc:	00 00                	add    %al,(%eax)
    2cfe:	00 00                	add    %al,(%eax)
    2d00:	17                   	pop    %ss
    2d01:	00 00                	add    %al,(%eax)
    2d03:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2d09:	00 00                	add    %al,(%eax)
    2d0b:	00 41 00             	add    %al,0x0(%ecx)
    2d0e:	00 00                	add    %al,(%eax)
    2d10:	80 00 00             	addb   $0x0,(%eax)
    2d13:	00 00                	add    %al,(%eax)
    2d15:	00 00                	add    %al,(%eax)
    2d17:	00 5b 00             	add    %bl,0x0(%ebx)
    2d1a:	00 00                	add    %al,(%eax)
    2d1c:	80 00 00             	addb   $0x0,(%eax)
    2d1f:	00 00                	add    %al,(%eax)
    2d21:	00 00                	add    %al,(%eax)
    2d23:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2d29:	00 00                	add    %al,(%eax)
    2d2b:	00 00                	add    %al,(%eax)
    2d2d:	00 00                	add    %al,(%eax)
    2d2f:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2d35:	00 00                	add    %al,(%eax)
    2d37:	00 00                	add    %al,(%eax)
    2d39:	00 00                	add    %al,(%eax)
    2d3b:	00 e1                	add    %ah,%cl
    2d3d:	00 00                	add    %al,(%eax)
    2d3f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2d45:	00 00                	add    %al,(%eax)
    2d47:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2d4a:	00 00                	add    %al,(%eax)
    2d4c:	80 00 00             	addb   $0x0,(%eax)
    2d4f:	00 00                	add    %al,(%eax)
    2d51:	00 00                	add    %al,(%eax)
    2d53:	00 37                	add    %dh,(%edi)
    2d55:	01 00                	add    %eax,(%eax)
    2d57:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2d5d:	00 00                	add    %al,(%eax)
    2d5f:	00 5d 01             	add    %bl,0x1(%ebp)
    2d62:	00 00                	add    %al,(%eax)
    2d64:	80 00 00             	addb   $0x0,(%eax)
    2d67:	00 00                	add    %al,(%eax)
    2d69:	00 00                	add    %al,(%eax)
    2d6b:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2d71:	00 00                	add    %al,(%eax)
    2d73:	00 00                	add    %al,(%eax)
    2d75:	00 00                	add    %al,(%eax)
    2d77:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2d7d:	00 00                	add    %al,(%eax)
    2d7f:	00 00                	add    %al,(%eax)
    2d81:	00 00                	add    %al,(%eax)
    2d83:	00 d2                	add    %dl,%dl
    2d85:	01 00                	add    %eax,(%eax)
    2d87:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2d8d:	00 00                	add    %al,(%eax)
    2d8f:	00 ec                	add    %ch,%ah
    2d91:	01 00                	add    %eax,(%eax)
    2d93:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2d99:	00 00                	add    %al,(%eax)
    2d9b:	00 07                	add    %al,(%edi)
    2d9d:	02 00                	add    (%eax),%al
    2d9f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2da5:	00 00                	add    %al,(%eax)
    2da7:	00 28                	add    %ch,(%eax)
    2da9:	02 00                	add    (%eax),%al
    2dab:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2db1:	00 00                	add    %al,(%eax)
    2db3:	00 47 02             	add    %al,0x2(%edi)
    2db6:	00 00                	add    %al,(%eax)
    2db8:	80 00 00             	addb   $0x0,(%eax)
    2dbb:	00 00                	add    %al,(%eax)
    2dbd:	00 00                	add    %al,(%eax)
    2dbf:	00 66 02             	add    %ah,0x2(%esi)
    2dc2:	00 00                	add    %al,(%eax)
    2dc4:	80 00 00             	addb   $0x0,(%eax)
    2dc7:	00 00                	add    %al,(%eax)
    2dc9:	00 00                	add    %al,(%eax)
    2dcb:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2dd1:	00 00                	add    %al,(%eax)
    2dd3:	00 00                	add    %al,(%eax)
    2dd5:	00 00                	add    %al,(%eax)
    2dd7:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    2ddd:	00 00                	add    %al,(%eax)
    2ddf:	00 89 a7 00 00 ae    	add    %cl,-0x51ffff59(%ecx)
    2de5:	02 00                	add    (%eax),%al
    2de7:	00 c2                	add    %al,%dl
    2de9:	00 00                	add    %al,(%eax)
    2deb:	00 00                	add    %al,(%eax)
    2ded:	00 00                	add    %al,(%eax)
    2def:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    2df5:	00 00                	add    %al,(%eax)
    2df7:	00 37                	add    %dh,(%edi)
    2df9:	53                   	push   %ebx
    2dfa:	00 00                	add    %al,(%eax)
    2dfc:	29 04 00             	sub    %eax,(%eax,%eax,1)
    2dff:	00 c2                	add    %al,%dl
    2e01:	00 00                	add    %al,(%eax)
    2e03:	00 65 97             	add    %ah,-0x69(%ebp)
    2e06:	00 00                	add    %al,(%eax)
    2e08:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    2e09:	11 00                	adc    %eax,(%eax)
    2e0b:	00 24 00             	add    %ah,(%eax,%eax,1)
    2e0e:	00 00                	add    %al,(%eax)
    2e10:	57                   	push   %edi
    2e11:	0f 28 00             	movaps (%eax),%xmm0
    2e14:	bb 11 00 00 a0       	mov    $0xa0000011,%ebx
    2e19:	00 00                	add    %al,(%eax)
    2e1b:	00 08                	add    %cl,(%eax)
    2e1d:	00 00                	add    %al,(%eax)
    2e1f:	00 00                	add    %al,(%eax)
    2e21:	00 00                	add    %al,(%eax)
    2e23:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
	...
    2e2f:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    2e33:	00 06                	add    %al,(%esi)
    2e35:	00 00                	add    %al,(%eax)
    2e37:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2e3d:	00 00                	add    %al,(%eax)
    2e3f:	00 62 0f             	add    %ah,0xf(%edx)
    2e42:	28 00                	sub    %al,(%eax)
    2e44:	00 00                	add    %al,(%eax)
    2e46:	00 00                	add    %al,(%eax)
    2e48:	44                   	inc    %esp
    2e49:	00 6c 00 0b          	add    %ch,0xb(%eax,%eax,1)
    2e4d:	00 00                	add    %al,(%eax)
    2e4f:	00 9e 11 00 00 84    	add    %bl,-0x7bffffef(%esi)
    2e55:	00 00                	add    %al,(%eax)
    2e57:	00 6a 0f             	add    %ch,0xf(%edx)
    2e5a:	28 00                	sub    %al,(%eax)
    2e5c:	00 00                	add    %al,(%eax)
    2e5e:	00 00                	add    %al,(%eax)
    2e60:	44                   	inc    %esp
    2e61:	00 09                	add    %cl,(%ecx)
    2e63:	00 13                	add    %dl,(%ebx)
    2e65:	00 00                	add    %al,(%eax)
    2e67:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    2e6d:	00 00                	add    %al,(%eax)
    2e6f:	00 6f 0f             	add    %ch,0xf(%edi)
    2e72:	28 00                	sub    %al,(%eax)
    2e74:	00 00                	add    %al,(%eax)
    2e76:	00 00                	add    %al,(%eax)
    2e78:	44                   	inc    %esp
    2e79:	00 6c 00 18          	add    %ch,0x18(%eax,%eax,1)
    2e7d:	00 00                	add    %al,(%eax)
    2e7f:	00 9e 11 00 00 84    	add    %bl,-0x7bffffef(%esi)
    2e85:	00 00                	add    %al,(%eax)
    2e87:	00 77 0f             	add    %dh,0xf(%edi)
    2e8a:	28 00                	sub    %al,(%eax)
    2e8c:	00 00                	add    %al,(%eax)
    2e8e:	00 00                	add    %al,(%eax)
    2e90:	44                   	inc    %esp
    2e91:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2e94:	20 00                	and    %al,(%eax)
    2e96:	00 00                	add    %al,(%eax)
    2e98:	00 00                	add    %al,(%eax)
    2e9a:	00 00                	add    %al,(%eax)
    2e9c:	44                   	inc    %esp
    2e9d:	00 0f                	add    %cl,(%edi)
    2e9f:	00 27                	add    %ah,(%edi)
    2ea1:	00 00                	add    %al,(%eax)
    2ea3:	00 cf                	add    %cl,%bh
    2ea5:	11 00                	adc    %eax,(%eax)
    2ea7:	00 40 00             	add    %al,0x0(%eax)
    2eaa:	00 00                	add    %al,(%eax)
    2eac:	00 00                	add    %al,(%eax)
    2eae:	00 00                	add    %al,(%eax)
    2eb0:	dc 11                	fcoml  (%ecx)
    2eb2:	00 00                	add    %al,(%eax)
    2eb4:	24 00                	and    $0x0,%al
    2eb6:	00 00                	add    %al,(%eax)
    2eb8:	80 0f 28             	orb    $0x28,(%edi)
    2ebb:	00 f0                	add    %dh,%al
    2ebd:	11 00                	adc    %eax,(%eax)
    2ebf:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    2ec5:	00 00                	add    %al,(%eax)
    2ec7:	00 60 11             	add    %ah,0x11(%eax)
    2eca:	00 00                	add    %al,(%eax)
    2ecc:	a0 00 00 00 0c       	mov    0xc000000,%al
    2ed1:	00 00                	add    %al,(%eax)
    2ed3:	00 00                	add    %al,(%eax)
    2ed5:	00 00                	add    %al,(%eax)
    2ed7:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
	...
    2ee3:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2ee7:	00 07                	add    %al,(%edi)
    2ee9:	00 00                	add    %al,(%eax)
    2eeb:	00 00                	add    %al,(%eax)
    2eed:	00 00                	add    %al,(%eax)
    2eef:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    2ef3:	00 0a                	add    %cl,(%edx)
    2ef5:	00 00                	add    %al,(%eax)
    2ef7:	00 00                	add    %al,(%eax)
    2ef9:	00 00                	add    %al,(%eax)
    2efb:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2eff:	00 11                	add    %dl,(%ecx)
    2f01:	00 00                	add    %al,(%eax)
    2f03:	00 00                	add    %al,(%eax)
    2f05:	00 00                	add    %al,(%eax)
    2f07:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    2f0b:	00 13                	add    %dl,(%ebx)
    2f0d:	00 00                	add    %al,(%eax)
    2f0f:	00 00                	add    %al,(%eax)
    2f11:	00 00                	add    %al,(%eax)
    2f13:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    2f17:	00 18                	add    %bl,(%eax)
    2f19:	00 00                	add    %al,(%eax)
    2f1b:	00 00                	add    %al,(%eax)
    2f1d:	00 00                	add    %al,(%eax)
    2f1f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    2f23:	00 1e                	add    %bl,(%esi)
    2f25:	00 00                	add    %al,(%eax)
    2f27:	00 00                	add    %al,(%eax)
    2f29:	00 00                	add    %al,(%eax)
    2f2b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2f2f:	00 22                	add    %ah,(%edx)
    2f31:	00 00                	add    %al,(%eax)
    2f33:	00 00                	add    %al,(%eax)
    2f35:	00 00                	add    %al,(%eax)
    2f37:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    2f3b:	00 2b                	add    %ch,(%ebx)
    2f3d:	00 00                	add    %al,(%eax)
    2f3f:	00 00                	add    %al,(%eax)
    2f41:	00 00                	add    %al,(%eax)
    2f43:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2f47:	00 2d 00 00 00 00    	add    %ch,0x0
    2f4d:	00 00                	add    %al,(%eax)
    2f4f:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    2f53:	00 33                	add    %dh,(%ebx)
    2f55:	00 00                	add    %al,(%eax)
    2f57:	00 00                	add    %al,(%eax)
    2f59:	00 00                	add    %al,(%eax)
    2f5b:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    2f5f:	00 37                	add    %dh,(%edi)
    2f61:	00 00                	add    %al,(%eax)
    2f63:	00 00                	add    %al,(%eax)
    2f65:	00 00                	add    %al,(%eax)
    2f67:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    2f6b:	00 3a                	add    %bh,(%edx)
    2f6d:	00 00                	add    %al,(%eax)
    2f6f:	00 00                	add    %al,(%eax)
    2f71:	00 00                	add    %al,(%eax)
    2f73:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    2f77:	00 3e                	add    %bh,(%esi)
    2f79:	00 00                	add    %al,(%eax)
    2f7b:	00 00                	add    %al,(%eax)
    2f7d:	00 00                	add    %al,(%eax)
    2f7f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    2f83:	00 42 00             	add    %al,0x0(%edx)
    2f86:	00 00                	add    %al,(%eax)
    2f88:	00 00                	add    %al,(%eax)
    2f8a:	00 00                	add    %al,(%eax)
    2f8c:	44                   	inc    %esp
    2f8d:	00 33                	add    %dh,(%ebx)
    2f8f:	00 46 00             	add    %al,0x0(%esi)
    2f92:	00 00                	add    %al,(%eax)
    2f94:	00 00                	add    %al,(%eax)
    2f96:	00 00                	add    %al,(%eax)
    2f98:	44                   	inc    %esp
    2f99:	00 2f                	add    %ch,(%edi)
    2f9b:	00 48 00             	add    %cl,0x0(%eax)
    2f9e:	00 00                	add    %al,(%eax)
    2fa0:	00 00                	add    %al,(%eax)
    2fa2:	00 00                	add    %al,(%eax)
    2fa4:	44                   	inc    %esp
    2fa5:	00 35 00 4b 00 00    	add    %dh,0x4b00
    2fab:	00 00                	add    %al,(%eax)
    2fad:	00 00                	add    %al,(%eax)
    2faf:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    2fb3:	00 4e 00             	add    %cl,0x0(%esi)
    2fb6:	00 00                	add    %al,(%eax)
    2fb8:	00 00                	add    %al,(%eax)
    2fba:	00 00                	add    %al,(%eax)
    2fbc:	44                   	inc    %esp
    2fbd:	00 35 00 52 00 00    	add    %dh,0x5200
    2fc3:	00 00                	add    %al,(%eax)
    2fc5:	00 00                	add    %al,(%eax)
    2fc7:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    2fcb:	00 55 00             	add    %dl,0x0(%ebp)
    2fce:	00 00                	add    %al,(%eax)
    2fd0:	00 00                	add    %al,(%eax)
    2fd2:	00 00                	add    %al,(%eax)
    2fd4:	44                   	inc    %esp
    2fd5:	00 38                	add    %bh,(%eax)
    2fd7:	00 5a 00             	add    %bl,0x0(%edx)
    2fda:	00 00                	add    %al,(%eax)
    2fdc:	00 00                	add    %al,(%eax)
    2fde:	00 00                	add    %al,(%eax)
    2fe0:	44                   	inc    %esp
    2fe1:	00 33                	add    %dh,(%ebx)
    2fe3:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    2fe7:	00 00                	add    %al,(%eax)
    2fe9:	00 00                	add    %al,(%eax)
    2feb:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2fef:	00 5f 00             	add    %bl,0x0(%edi)
    2ff2:	00 00                	add    %al,(%eax)
    2ff4:	00 00                	add    %al,(%eax)
    2ff6:	00 00                	add    %al,(%eax)
    2ff8:	44                   	inc    %esp
    2ff9:	00 38                	add    %bh,(%eax)
    2ffb:	00 66 00             	add    %ah,0x0(%esi)
    2ffe:	00 00                	add    %al,(%eax)
    3000:	00 00                	add    %al,(%eax)
    3002:	00 00                	add    %al,(%eax)
    3004:	44                   	inc    %esp
    3005:	00 3a                	add    %bh,(%edx)
    3007:	00 68 00             	add    %ch,0x0(%eax)
    300a:	00 00                	add    %al,(%eax)
    300c:	00 00                	add    %al,(%eax)
    300e:	00 00                	add    %al,(%eax)
    3010:	44                   	inc    %esp
    3011:	00 3c 00             	add    %bh,(%eax,%eax,1)
    3014:	71 00                	jno    3016 <bootmain-0x27cfea>
    3016:	00 00                	add    %al,(%eax)
    3018:	00 00                	add    %al,(%eax)
    301a:	00 00                	add    %al,(%eax)
    301c:	44                   	inc    %esp
    301d:	00 3e                	add    %bh,(%esi)
    301f:	00 75 00             	add    %dh,0x0(%ebp)
    3022:	00 00                	add    %al,(%eax)
    3024:	00 00                	add    %al,(%eax)
    3026:	00 00                	add    %al,(%eax)
    3028:	44                   	inc    %esp
    3029:	00 41 00             	add    %al,0x0(%ecx)
    302c:	7e 00                	jle    302e <bootmain-0x27cfd2>
    302e:	00 00                	add    %al,(%eax)
    3030:	00 00                	add    %al,(%eax)
    3032:	00 00                	add    %al,(%eax)
    3034:	44                   	inc    %esp
    3035:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    3039:	00 00                	add    %al,(%eax)
    303b:	00 00                	add    %al,(%eax)
    303d:	00 00                	add    %al,(%eax)
    303f:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    3043:	00 88 00 00 00 00    	add    %cl,0x0(%eax)
    3049:	00 00                	add    %al,(%eax)
    304b:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    304f:	00 8b 00 00 00 cf    	add    %cl,-0x31000000(%ebx)
    3055:	11 00                	adc    %eax,(%eax)
    3057:	00 40 00             	add    %al,0x0(%eax)
    305a:	00 00                	add    %al,(%eax)
    305c:	02 00                	add    (%eax),%al
    305e:	00 00                	add    %al,(%eax)
    3060:	00 00                	add    %al,(%eax)
    3062:	00 00                	add    %al,(%eax)
    3064:	64 00 00             	add    %al,%fs:(%eax)
    3067:	00 0e                	add    %cl,(%esi)
    3069:	10 28                	adc    %ch,(%eax)
    306b:	00 fd                	add    %bh,%ch
    306d:	11 00                	adc    %eax,(%eax)
    306f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    3073:	00 0e                	add    %cl,(%esi)
    3075:	10 28                	adc    %ch,(%eax)
    3077:	00 08                	add    %cl,(%eax)
    3079:	00 00                	add    %al,(%eax)
    307b:	00 3c 00             	add    %bh,(%eax,%eax,1)
    307e:	00 00                	add    %al,(%eax)
    3080:	00 00                	add    %al,(%eax)
    3082:	00 00                	add    %al,(%eax)
    3084:	17                   	pop    %ss
    3085:	00 00                	add    %al,(%eax)
    3087:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    308d:	00 00                	add    %al,(%eax)
    308f:	00 41 00             	add    %al,0x0(%ecx)
    3092:	00 00                	add    %al,(%eax)
    3094:	80 00 00             	addb   $0x0,(%eax)
    3097:	00 00                	add    %al,(%eax)
    3099:	00 00                	add    %al,(%eax)
    309b:	00 5b 00             	add    %bl,0x0(%ebx)
    309e:	00 00                	add    %al,(%eax)
    30a0:	80 00 00             	addb   $0x0,(%eax)
    30a3:	00 00                	add    %al,(%eax)
    30a5:	00 00                	add    %al,(%eax)
    30a7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    30ad:	00 00                	add    %al,(%eax)
    30af:	00 00                	add    %al,(%eax)
    30b1:	00 00                	add    %al,(%eax)
    30b3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    30b9:	00 00                	add    %al,(%eax)
    30bb:	00 00                	add    %al,(%eax)
    30bd:	00 00                	add    %al,(%eax)
    30bf:	00 e1                	add    %ah,%cl
    30c1:	00 00                	add    %al,(%eax)
    30c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    30c9:	00 00                	add    %al,(%eax)
    30cb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    30ce:	00 00                	add    %al,(%eax)
    30d0:	80 00 00             	addb   $0x0,(%eax)
    30d3:	00 00                	add    %al,(%eax)
    30d5:	00 00                	add    %al,(%eax)
    30d7:	00 37                	add    %dh,(%edi)
    30d9:	01 00                	add    %eax,(%eax)
    30db:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    30e1:	00 00                	add    %al,(%eax)
    30e3:	00 5d 01             	add    %bl,0x1(%ebp)
    30e6:	00 00                	add    %al,(%eax)
    30e8:	80 00 00             	addb   $0x0,(%eax)
    30eb:	00 00                	add    %al,(%eax)
    30ed:	00 00                	add    %al,(%eax)
    30ef:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    30f5:	00 00                	add    %al,(%eax)
    30f7:	00 00                	add    %al,(%eax)
    30f9:	00 00                	add    %al,(%eax)
    30fb:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    3101:	00 00                	add    %al,(%eax)
    3103:	00 00                	add    %al,(%eax)
    3105:	00 00                	add    %al,(%eax)
    3107:	00 d2                	add    %dl,%dl
    3109:	01 00                	add    %eax,(%eax)
    310b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3111:	00 00                	add    %al,(%eax)
    3113:	00 ec                	add    %ch,%ah
    3115:	01 00                	add    %eax,(%eax)
    3117:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    311d:	00 00                	add    %al,(%eax)
    311f:	00 07                	add    %al,(%edi)
    3121:	02 00                	add    (%eax),%al
    3123:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3129:	00 00                	add    %al,(%eax)
    312b:	00 28                	add    %ch,(%eax)
    312d:	02 00                	add    (%eax),%al
    312f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    3135:	00 00                	add    %al,(%eax)
    3137:	00 47 02             	add    %al,0x2(%edi)
    313a:	00 00                	add    %al,(%eax)
    313c:	80 00 00             	addb   $0x0,(%eax)
    313f:	00 00                	add    %al,(%eax)
    3141:	00 00                	add    %al,(%eax)
    3143:	00 66 02             	add    %ah,0x2(%esi)
    3146:	00 00                	add    %al,(%eax)
    3148:	80 00 00             	addb   $0x0,(%eax)
    314b:	00 00                	add    %al,(%eax)
    314d:	00 00                	add    %al,(%eax)
    314f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    3155:	00 00                	add    %al,(%eax)
    3157:	00 00                	add    %al,(%eax)
    3159:	00 00                	add    %al,(%eax)
    315b:	00 29                	add    %ch,(%ecx)
    315d:	04 00                	add    $0x0,%al
    315f:	00 c2                	add    %al,%dl
    3161:	00 00                	add    %al,(%eax)
    3163:	00 65 97             	add    %ah,-0x69(%ebp)
    3166:	00 00                	add    %al,(%eax)
    3168:	ae                   	scas   %es:(%edi),%al
    3169:	02 00                	add    (%eax),%al
    316b:	00 c2                	add    %al,%dl
    316d:	00 00                	add    %al,(%eax)
    316f:	00 00                	add    %al,(%eax)
    3171:	00 00                	add    %al,(%eax)
    3173:	00 be 02 00 00 c2    	add    %bh,-0x3dfffffe(%esi)
    3179:	00 00                	add    %al,(%eax)
    317b:	00 37                	add    %dh,(%edi)
    317d:	53                   	push   %ebx
    317e:	00 00                	add    %al,(%eax)
    3180:	02 12                	add    (%edx),%dl
    3182:	00 00                	add    %al,(%eax)
    3184:	24 00                	and    $0x0,%al
    3186:	00 00                	add    %al,(%eax)
    3188:	0e                   	push   %cs
    3189:	10 28                	adc    %ch,(%eax)
    318b:	00 17                	add    %dl,(%edi)
    318d:	12 00                	adc    (%eax),%al
    318f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3195:	00 00                	add    %al,(%eax)
    3197:	00 24 12             	add    %ah,(%edx,%edx,1)
    319a:	00 00                	add    %al,(%eax)
    319c:	a0 00 00 00 0c       	mov    0xc000000,%al
    31a1:	00 00                	add    %al,(%eax)
    31a3:	00 00                	add    %al,(%eax)
    31a5:	00 00                	add    %al,(%eax)
    31a7:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    31b3:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    31b7:	00 07                	add    %al,(%edi)
    31b9:	00 00                	add    %al,(%eax)
    31bb:	00 00                	add    %al,(%eax)
    31bd:	00 00                	add    %al,(%eax)
    31bf:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    31c3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    31c6:	00 00                	add    %al,(%eax)
    31c8:	00 00                	add    %al,(%eax)
    31ca:	00 00                	add    %al,(%eax)
    31cc:	44                   	inc    %esp
    31cd:	00 11                	add    %dl,(%ecx)
    31cf:	00 12                	add    %dl,(%edx)
    31d1:	00 00                	add    %al,(%eax)
    31d3:	00 00                	add    %al,(%eax)
    31d5:	00 00                	add    %al,(%eax)
    31d7:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    31db:	00 1c 00             	add    %bl,(%eax,%eax,1)
    31de:	00 00                	add    %al,(%eax)
    31e0:	00 00                	add    %al,(%eax)
    31e2:	00 00                	add    %al,(%eax)
    31e4:	44                   	inc    %esp
    31e5:	00 14 00             	add    %dl,(%eax,%eax,1)
    31e8:	22 00                	and    (%eax),%al
    31ea:	00 00                	add    %al,(%eax)
    31ec:	00 00                	add    %al,(%eax)
    31ee:	00 00                	add    %al,(%eax)
    31f0:	44                   	inc    %esp
    31f1:	00 12                	add    %dl,(%edx)
    31f3:	00 28                	add    %ch,(%eax)
    31f5:	00 00                	add    %al,(%eax)
    31f7:	00 00                	add    %al,(%eax)
    31f9:	00 00                	add    %al,(%eax)
    31fb:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    31ff:	00 30                	add    %dh,(%eax)
    3201:	00 00                	add    %al,(%eax)
    3203:	00 00                	add    %al,(%eax)
    3205:	00 00                	add    %al,(%eax)
    3207:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    320b:	00 37                	add    %dh,(%edi)
    320d:	00 00                	add    %al,(%eax)
    320f:	00 2f                	add    %ch,(%edi)
    3211:	12 00                	adc    (%eax),%al
    3213:	00 40 00             	add    %al,0x0(%eax)
    3216:	00 00                	add    %al,(%eax)
    3218:	02 00                	add    (%eax),%al
    321a:	00 00                	add    %al,(%eax)
    321c:	3a 12                	cmp    (%edx),%dl
    321e:	00 00                	add    %al,(%eax)
    3220:	40                   	inc    %eax
    3221:	00 00                	add    %al,(%eax)
    3223:	00 01                	add    %al,(%ecx)
    3225:	00 00                	add    %al,(%eax)
    3227:	00 4b 12             	add    %cl,0x12(%ebx)
    322a:	00 00                	add    %al,(%eax)
    322c:	40                   	inc    %eax
	...
    3235:	00 00                	add    %al,(%eax)
    3237:	00 c0                	add    %al,%al
	...
    3241:	00 00                	add    %al,(%eax)
    3243:	00 e0                	add    %ah,%al
    3245:	00 00                	add    %al,(%eax)
    3247:	00 3a                	add    %bh,(%edx)
    3249:	00 00                	add    %al,(%eax)
    324b:	00 58 12             	add    %bl,0x12(%eax)
    324e:	00 00                	add    %al,(%eax)
    3250:	24 00                	and    $0x0,%al
    3252:	00 00                	add    %al,(%eax)
    3254:	48                   	dec    %eax
    3255:	10 28                	adc    %ch,(%eax)
    3257:	00 17                	add    %dl,(%edi)
    3259:	12 00                	adc    (%eax),%al
    325b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3261:	00 00                	add    %al,(%eax)
    3263:	00 24 12             	add    %ah,(%edx,%edx,1)
    3266:	00 00                	add    %al,(%eax)
    3268:	a0 00 00 00 0c       	mov    0xc000000,%al
    326d:	00 00                	add    %al,(%eax)
    326f:	00 00                	add    %al,(%eax)
    3271:	00 00                	add    %al,(%eax)
    3273:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    3277:	00 00                	add    %al,(%eax)
    3279:	00 00                	add    %al,(%eax)
    327b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3281:	00 00                	add    %al,(%eax)
    3283:	00 4c 10 28          	add    %cl,0x28(%eax,%edx,1)
    3287:	00 00                	add    %al,(%eax)
    3289:	00 00                	add    %al,(%eax)
    328b:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    328f:	01 04 00             	add    %eax,(%eax,%eax,1)
    3292:	00 00                	add    %al,(%eax)
    3294:	fd                   	std    
    3295:	11 00                	adc    %eax,(%eax)
    3297:	00 84 00 00 00 4e 10 	add    %al,0x104e0000(%eax,%eax,1)
    329e:	28 00                	sub    %al,(%eax)
    32a0:	00 00                	add    %al,(%eax)
    32a2:	00 00                	add    %al,(%eax)
    32a4:	44                   	inc    %esp
    32a5:	00 25 00 06 00 00    	add    %ah,0x600
    32ab:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    32b1:	00 00                	add    %al,(%eax)
    32b3:	00 53 10             	add    %dl,0x10(%ebx)
    32b6:	28 00                	sub    %al,(%eax)
    32b8:	00 00                	add    %al,(%eax)
    32ba:	00 00                	add    %al,(%eax)
    32bc:	44                   	inc    %esp
    32bd:	00 43 01             	add    %al,0x1(%ebx)
    32c0:	0b 00                	or     (%eax),%eax
    32c2:	00 00                	add    %al,(%eax)
    32c4:	00 00                	add    %al,(%eax)
    32c6:	00 00                	add    %al,(%eax)
    32c8:	44                   	inc    %esp
    32c9:	00 3c 01             	add    %bh,(%ecx,%eax,1)
    32cc:	0d 00 00 00 fd       	or     $0xfd000000,%eax
    32d1:	11 00                	adc    %eax,(%eax)
    32d3:	00 84 00 00 00 57 10 	add    %al,0x10570000(%eax,%eax,1)
    32da:	28 00                	sub    %al,(%eax)
    32dc:	00 00                	add    %al,(%eax)
    32de:	00 00                	add    %al,(%eax)
    32e0:	44                   	inc    %esp
    32e1:	00 22                	add    %ah,(%edx)
    32e3:	00 0f                	add    %cl,(%edi)
    32e5:	00 00                	add    %al,(%eax)
    32e7:	00 00                	add    %al,(%eax)
    32e9:	00 00                	add    %al,(%eax)
    32eb:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    32ef:	00 11                	add    %dl,(%ecx)
    32f1:	00 00                	add    %al,(%eax)
    32f3:	00 00                	add    %al,(%eax)
    32f5:	00 00                	add    %al,(%eax)
    32f7:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    32fb:	00 18                	add    %bl,(%eax)
    32fd:	00 00                	add    %al,(%eax)
    32ff:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3305:	00 00                	add    %al,(%eax)
    3307:	00 65 10             	add    %ah,0x10(%ebp)
    330a:	28 00                	sub    %al,(%eax)
    330c:	00 00                	add    %al,(%eax)
    330e:	00 00                	add    %al,(%eax)
    3310:	44                   	inc    %esp
    3311:	00 43 01             	add    %al,0x1(%ebx)
    3314:	1d 00 00 00 00       	sbb    $0x0,%eax
    3319:	00 00                	add    %al,(%eax)
    331b:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
    331f:	00 1f                	add    %bl,(%edi)
    3321:	00 00                	add    %al,(%eax)
    3323:	00 fd                	add    %bh,%ch
    3325:	11 00                	adc    %eax,(%eax)
    3327:	00 84 00 00 00 6a 10 	add    %al,0x106a0000(%eax,%eax,1)
    332e:	28 00                	sub    %al,(%eax)
    3330:	00 00                	add    %al,(%eax)
    3332:	00 00                	add    %al,(%eax)
    3334:	44                   	inc    %esp
    3335:	00 32                	add    %dh,(%edx)
    3337:	00 22                	add    %ah,(%edx)
    3339:	00 00                	add    %al,(%eax)
    333b:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3341:	00 00                	add    %al,(%eax)
    3343:	00 6f 10             	add    %ch,0x10(%edi)
    3346:	28 00                	sub    %al,(%eax)
    3348:	00 00                	add    %al,(%eax)
    334a:	00 00                	add    %al,(%eax)
    334c:	44                   	inc    %esp
    334d:	00 d5                	add    %dl,%ch
    334f:	00 27                	add    %ah,(%edi)
    3351:	00 00                	add    %al,(%eax)
    3353:	00 fd                	add    %bh,%ch
    3355:	11 00                	adc    %eax,(%eax)
    3357:	00 84 00 00 00 72 10 	add    %al,0x10720000(%eax,%eax,1)
    335e:	28 00                	sub    %al,(%eax)
    3360:	00 00                	add    %al,(%eax)
    3362:	00 00                	add    %al,(%eax)
    3364:	44                   	inc    %esp
    3365:	00 2b                	add    %ch,(%ebx)
    3367:	00 2a                	add    %ch,(%edx)
    3369:	00 00                	add    %al,(%eax)
    336b:	00 00                	add    %al,(%eax)
    336d:	00 00                	add    %al,(%eax)
    336f:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
    3373:	00 2c 00             	add    %ch,(%eax,%eax,1)
    3376:	00 00                	add    %al,(%eax)
    3378:	00 00                	add    %al,(%eax)
    337a:	00 00                	add    %al,(%eax)
    337c:	44                   	inc    %esp
    337d:	00 3a                	add    %bh,(%edx)
    337f:	00 37                	add    %dh,(%edi)
    3381:	00 00                	add    %al,(%eax)
    3383:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    3389:	00 00                	add    %al,(%eax)
    338b:	00 85 10 28 00 00    	add    %al,0x2810(%ebp)
    3391:	00 00                	add    %al,(%eax)
    3393:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
    3397:	00 3d 00 00 00 fd    	add    %bh,0xfd000000
    339d:	11 00                	adc    %eax,(%eax)
    339f:	00 84 00 00 00 88 10 	add    %al,0x10880000(%eax,%eax,1)
    33a6:	28 00                	sub    %al,(%eax)
    33a8:	00 00                	add    %al,(%eax)
    33aa:	00 00                	add    %al,(%eax)
    33ac:	44                   	inc    %esp
    33ad:	00 3d 00 40 00 00    	add    %bh,0x4000
    33b3:	00 ae 02 00 00 84    	add    %ch,-0x7bfffffe(%esi)
    33b9:	00 00                	add    %al,(%eax)
    33bb:	00 8e 10 28 00 00    	add    %cl,0x2810(%esi)
    33c1:	00 00                	add    %al,(%eax)
    33c3:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    33c7:	00 46 00             	add    %al,0x0(%esi)
    33ca:	00 00                	add    %al,(%eax)
    33cc:	fd                   	std    
    33cd:	11 00                	adc    %eax,(%eax)
    33cf:	00 84 00 00 00 91 10 	add    %al,0x10910000(%eax,%eax,1)
    33d6:	28 00                	sub    %al,(%eax)
    33d8:	00 00                	add    %al,(%eax)
    33da:	00 00                	add    %al,(%eax)
    33dc:	44                   	inc    %esp
    33dd:	00 43 00             	add    %al,0x0(%ebx)
    33e0:	49                   	dec    %ecx
    33e1:	00 00                	add    %al,(%eax)
    33e3:	00 67 12             	add    %ah,0x12(%edi)
    33e6:	00 00                	add    %al,(%eax)
    33e8:	40                   	inc    %eax
    33e9:	00 00                	add    %al,(%eax)
    33eb:	00 03                	add    %al,(%ebx)
    33ed:	00 00                	add    %al,(%eax)
    33ef:	00 75 12             	add    %dh,0x12(%ebp)
    33f2:	00 00                	add    %al,(%eax)
    33f4:	40                   	inc    %eax
	...
    33fd:	00 00                	add    %al,(%eax)
    33ff:	00 c0                	add    %al,%al
	...
    3409:	00 00                	add    %al,(%eax)
    340b:	00 e0                	add    %ah,%al
    340d:	00 00                	add    %al,(%eax)
    340f:	00 4e 00             	add    %cl,0x0(%esi)
    3412:	00 00                	add    %al,(%eax)
    3414:	7e 12                	jle    3428 <bootmain-0x27cbd8>
    3416:	00 00                	add    %al,(%eax)
    3418:	24 00                	and    $0x0,%al
    341a:	00 00                	add    %al,(%eax)
    341c:	96                   	xchg   %eax,%esi
    341d:	10 28                	adc    %ch,(%eax)
    341f:	00 92 12 00 00 a0    	add    %dl,-0x5fffffee(%edx)
    3425:	00 00                	add    %al,(%eax)
    3427:	00 08                	add    %cl,(%eax)
    3429:	00 00                	add    %al,(%eax)
    342b:	00 00                	add    %al,(%eax)
    342d:	00 00                	add    %al,(%eax)
    342f:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
	...
    343b:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    343f:	00 03                	add    %al,(%ebx)
    3441:	00 00                	add    %al,(%eax)
    3443:	00 00                	add    %al,(%eax)
    3445:	00 00                	add    %al,(%eax)
    3447:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    344b:	00 06                	add    %al,(%esi)
    344d:	00 00                	add    %al,(%eax)
    344f:	00 00                	add    %al,(%eax)
    3451:	00 00                	add    %al,(%eax)
    3453:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    3457:	00 0c 00             	add    %cl,(%eax,%eax,1)
    345a:	00 00                	add    %al,(%eax)
    345c:	00 00                	add    %al,(%eax)
    345e:	00 00                	add    %al,(%eax)
    3460:	44                   	inc    %esp
    3461:	00 4a 00             	add    %cl,0x0(%edx)
    3464:	13 00                	adc    (%eax),%eax
    3466:	00 00                	add    %al,(%eax)
    3468:	00 00                	add    %al,(%eax)
    346a:	00 00                	add    %al,(%eax)
    346c:	44                   	inc    %esp
    346d:	00 4b 00             	add    %cl,0x0(%ebx)
    3470:	1a 00                	sbb    (%eax),%al
    3472:	00 00                	add    %al,(%eax)
    3474:	00 00                	add    %al,(%eax)
    3476:	00 00                	add    %al,(%eax)
    3478:	44                   	inc    %esp
    3479:	00 4c 00 21          	add    %cl,0x21(%eax,%eax,1)
    347d:	00 00                	add    %al,(%eax)
    347f:	00 a5 12 00 00 40    	add    %ah,0x40000012(%ebp)
    3485:	00 00                	add    %al,(%eax)
    3487:	00 00                	add    %al,(%eax)
    3489:	00 00                	add    %al,(%eax)
    348b:	00 b1 12 00 00 24    	add    %dh,0x24000012(%ecx)
    3491:	00 00                	add    %al,(%eax)
    3493:	00 b9 10 28 00 c5    	add    %bh,-0x3affd7f0(%ecx)
    3499:	12 00                	adc    (%eax),%al
    349b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    34a1:	00 00                	add    %al,(%eax)
    34a3:	00 00                	add    %al,(%eax)
    34a5:	00 00                	add    %al,(%eax)
    34a7:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
	...
    34b3:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    34b7:	00 01                	add    %al,(%ecx)
    34b9:	00 00                	add    %al,(%eax)
    34bb:	00 00                	add    %al,(%eax)
    34bd:	00 00                	add    %al,(%eax)
    34bf:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    34c3:	00 03                	add    %al,(%ebx)
    34c5:	00 00                	add    %al,(%eax)
    34c7:	00 00                	add    %al,(%eax)
    34c9:	00 00                	add    %al,(%eax)
    34cb:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    34cf:	00 05 00 00 00 00    	add    %al,0x0
    34d5:	00 00                	add    %al,(%eax)
    34d7:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    34db:	00 07                	add    %al,(%edi)
    34dd:	00 00                	add    %al,(%eax)
    34df:	00 00                	add    %al,(%eax)
    34e1:	00 00                	add    %al,(%eax)
    34e3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    34e7:	00 0b                	add    %cl,(%ebx)
    34e9:	00 00                	add    %al,(%eax)
    34eb:	00 00                	add    %al,(%eax)
    34ed:	00 00                	add    %al,(%eax)
    34ef:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    34f3:	00 0d 00 00 00 00    	add    %cl,0x0
    34f9:	00 00                	add    %al,(%eax)
    34fb:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
    34ff:	00 11                	add    %dl,(%ecx)
    3501:	00 00                	add    %al,(%eax)
    3503:	00 00                	add    %al,(%eax)
    3505:	00 00                	add    %al,(%eax)
    3507:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    350b:	00 15 00 00 00 00    	add    %dl,0x0
    3511:	00 00                	add    %al,(%eax)
    3513:	00 44 00 57          	add    %al,0x57(%eax,%eax,1)
    3517:	00 18                	add    %bl,(%eax)
    3519:	00 00                	add    %al,(%eax)
    351b:	00 75 12             	add    %dh,0x12(%ebp)
    351e:	00 00                	add    %al,(%eax)
    3520:	40                   	inc    %eax
    3521:	00 00                	add    %al,(%eax)
    3523:	00 02                	add    %al,(%edx)
    3525:	00 00                	add    %al,(%eax)
    3527:	00 d1                	add    %dl,%cl
    3529:	12 00                	adc    (%eax),%al
    352b:	00 40 00             	add    %al,0x0(%eax)
    352e:	00 00                	add    %al,(%eax)
    3530:	00 00                	add    %al,(%eax)
    3532:	00 00                	add    %al,(%eax)
    3534:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    3535:	12 00                	adc    (%eax),%al
    3537:	00 40 00             	add    %al,0x0(%eax)
    353a:	00 00                	add    %al,(%eax)
    353c:	01 00                	add    %eax,(%eax)
    353e:	00 00                	add    %al,(%eax)
    3540:	00 00                	add    %al,(%eax)
    3542:	00 00                	add    %al,(%eax)
    3544:	c0 00 00             	rolb   $0x0,(%eax)
	...
    354f:	00 e0                	add    %ah,%al
    3551:	00 00                	add    %al,(%eax)
    3553:	00 1b                	add    %bl,(%ebx)
    3555:	00 00                	add    %al,(%eax)
    3557:	00 e0                	add    %ah,%al
    3559:	12 00                	adc    (%eax),%al
    355b:	00 24 00             	add    %ah,(%eax,%eax,1)
    355e:	00 00                	add    %al,(%eax)
    3560:	d4 10                	aam    $0x10
    3562:	28 00                	sub    %al,(%eax)
    3564:	c5 12                	lds    (%edx),%edx
    3566:	00 00                	add    %al,(%eax)
    3568:	a0 00 00 00 08       	mov    0x8000000,%al
    356d:	00 00                	add    %al,(%eax)
    356f:	00 f4                	add    %dh,%ah
    3571:	12 00                	adc    (%eax),%al
    3573:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3579:	00 00                	add    %al,(%eax)
    357b:	00 00                	add    %al,(%eax)
    357d:	00 00                	add    %al,(%eax)
    357f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
	...
    358b:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    358f:	00 01                	add    %al,(%ecx)
    3591:	00 00                	add    %al,(%eax)
    3593:	00 00                	add    %al,(%eax)
    3595:	00 00                	add    %al,(%eax)
    3597:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    359b:	00 03                	add    %al,(%ebx)
    359d:	00 00                	add    %al,(%eax)
    359f:	00 00                	add    %al,(%eax)
    35a1:	00 00                	add    %al,(%eax)
    35a3:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    35a7:	00 0b                	add    %cl,(%ebx)
    35a9:	00 00                	add    %al,(%eax)
    35ab:	00 00                	add    %al,(%eax)
    35ad:	00 00                	add    %al,(%eax)
    35af:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    35b3:	00 0d 00 00 00 00    	add    %cl,0x0
    35b9:	00 00                	add    %al,(%eax)
    35bb:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    35bf:	00 11                	add    %dl,(%ecx)
    35c1:	00 00                	add    %al,(%eax)
    35c3:	00 00                	add    %al,(%eax)
    35c5:	00 00                	add    %al,(%eax)
    35c7:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    35cb:	00 1d 00 00 00 00    	add    %bl,0x0
    35d1:	00 00                	add    %al,(%eax)
    35d3:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    35d7:	00 20                	add    %ah,(%eax)
    35d9:	00 00                	add    %al,(%eax)
    35db:	00 00                	add    %al,(%eax)
    35dd:	00 00                	add    %al,(%eax)
    35df:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    35e3:	00 23                	add    %ah,(%ebx)
    35e5:	00 00                	add    %al,(%eax)
    35e7:	00 00                	add    %al,(%eax)
    35e9:	00 00                	add    %al,(%eax)
    35eb:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    35ef:	00 28                	add    %ch,(%eax)
    35f1:	00 00                	add    %al,(%eax)
    35f3:	00 00                	add    %al,(%eax)
    35f5:	00 00                	add    %al,(%eax)
    35f7:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    35fb:	00 2e                	add    %ch,(%esi)
    35fd:	00 00                	add    %al,(%eax)
    35ff:	00 00                	add    %al,(%eax)
    3601:	00 00                	add    %al,(%eax)
    3603:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    3607:	00 30                	add    %dh,(%eax)
    3609:	00 00                	add    %al,(%eax)
    360b:	00 00                	add    %al,(%eax)
    360d:	00 00                	add    %al,(%eax)
    360f:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    3613:	00 33                	add    %dh,(%ebx)
    3615:	00 00                	add    %al,(%eax)
    3617:	00 00                	add    %al,(%eax)
    3619:	00 00                	add    %al,(%eax)
    361b:	00 44 00 6b          	add    %al,0x6b(%eax,%eax,1)
    361f:	00 35 00 00 00 00    	add    %dh,0x0
    3625:	00 00                	add    %al,(%eax)
    3627:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    362b:	00 3a                	add    %bh,(%edx)
    362d:	00 00                	add    %al,(%eax)
    362f:	00 00                	add    %al,(%eax)
    3631:	00 00                	add    %al,(%eax)
    3633:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    3637:	00 3e                	add    %bh,(%esi)
    3639:	00 00                	add    %al,(%eax)
    363b:	00 00                	add    %al,(%eax)
    363d:	00 00                	add    %al,(%eax)
    363f:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    3643:	00 51 00             	add    %dl,0x0(%ecx)
    3646:	00 00                	add    %al,(%eax)
    3648:	00 00                	add    %al,(%eax)
    364a:	00 00                	add    %al,(%eax)
    364c:	44                   	inc    %esp
    364d:	00 76 00             	add    %dh,0x0(%esi)
    3650:	54                   	push   %esp
    3651:	00 00                	add    %al,(%eax)
    3653:	00 00                	add    %al,(%eax)
    3655:	00 00                	add    %al,(%eax)
    3657:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    365b:	00 56 00             	add    %dl,0x0(%esi)
    365e:	00 00                	add    %al,(%eax)
    3660:	00 13                	add    %dl,(%ebx)
    3662:	00 00                	add    %al,(%eax)
    3664:	40                   	inc    %eax
    3665:	00 00                	add    %al,(%eax)
    3667:	00 00                	add    %al,(%eax)
    3669:	00 00                	add    %al,(%eax)
    366b:	00 a5 12 00 00 40    	add    %ah,0x40000012(%ebp)
    3671:	00 00                	add    %al,(%eax)
    3673:	00 01                	add    %al,(%ecx)
    3675:	00 00                	add    %al,(%eax)
    3677:	00 00                	add    %al,(%eax)
    3679:	00 00                	add    %al,(%eax)
    367b:	00 c0                	add    %al,%al
	...
    3685:	00 00                	add    %al,(%eax)
    3687:	00 e0                	add    %ah,%al
    3689:	00 00                	add    %al,(%eax)
    368b:	00 5b 00             	add    %bl,0x0(%ebx)
    368e:	00 00                	add    %al,(%eax)
    3690:	09 13                	or     %edx,(%ebx)
    3692:	00 00                	add    %al,(%eax)
    3694:	24 00                	and    $0x0,%al
    3696:	00 00                	add    %al,(%eax)
    3698:	2f                   	das    
    3699:	11 28                	adc    %ebp,(%eax)
    369b:	00 c5                	add    %al,%ch
    369d:	12 00                	adc    (%eax),%al
    369f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    36a5:	00 00                	add    %al,(%eax)
    36a7:	00 f4                	add    %dh,%ah
    36a9:	12 00                	adc    (%eax),%al
    36ab:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    36b1:	00 00                	add    %al,(%eax)
    36b3:	00 00                	add    %al,(%eax)
    36b5:	00 00                	add    %al,(%eax)
    36b7:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
    36c3:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    36c7:	00 03                	add    %al,(%ebx)
    36c9:	00 00                	add    %al,(%eax)
    36cb:	00 00                	add    %al,(%eax)
    36cd:	00 00                	add    %al,(%eax)
    36cf:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    36d3:	00 10                	add    %dl,(%eax)
    36d5:	00 00                	add    %al,(%eax)
    36d7:	00 00                	add    %al,(%eax)
    36d9:	00 00                	add    %al,(%eax)
    36db:	00 44 00 5d          	add    %al,0x5d(%eax,%eax,1)
    36df:	00 13                	add    %dl,(%ebx)
    36e1:	00 00                	add    %al,(%eax)
    36e3:	00 00                	add    %al,(%eax)
    36e5:	00 00                	add    %al,(%eax)
    36e7:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    36eb:	00 14 00             	add    %dl,(%eax,%eax,1)
    36ee:	00 00                	add    %al,(%eax)
    36f0:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    36f1:	12 00                	adc    (%eax),%al
    36f3:	00 40 00             	add    %al,0x0(%eax)
    36f6:	00 00                	add    %al,(%eax)
    36f8:	00 00                	add    %al,(%eax)
    36fa:	00 00                	add    %al,(%eax)
    36fc:	20 13                	and    %dl,(%ebx)
    36fe:	00 00                	add    %al,(%eax)
    3700:	24 00                	and    $0x0,%al
    3702:	00 00                	add    %al,(%eax)
    3704:	48                   	dec    %eax
    3705:	11 28                	adc    %ebp,(%eax)
    3707:	00 c5                	add    %al,%ch
    3709:	12 00                	adc    (%eax),%al
    370b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3711:	00 00                	add    %al,(%eax)
    3713:	00 33                	add    %dh,(%ebx)
    3715:	13 00                	adc    (%eax),%eax
    3717:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    371d:	00 00                	add    %al,(%eax)
    371f:	00 f4                	add    %dh,%ah
    3721:	12 00                	adc    (%eax),%al
    3723:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    3729:	00 00                	add    %al,(%eax)
    372b:	00 00                	add    %al,(%eax)
    372d:	00 00                	add    %al,(%eax)
    372f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
	...
    373b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    373f:	00 01                	add    %al,(%ecx)
    3741:	00 00                	add    %al,(%eax)
    3743:	00 00                	add    %al,(%eax)
    3745:	00 00                	add    %al,(%eax)
    3747:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    374b:	00 03                	add    %al,(%ebx)
    374d:	00 00                	add    %al,(%eax)
    374f:	00 00                	add    %al,(%eax)
    3751:	00 00                	add    %al,(%eax)
    3753:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    3757:	00 0b                	add    %cl,(%ebx)
    3759:	00 00                	add    %al,(%eax)
    375b:	00 00                	add    %al,(%eax)
    375d:	00 00                	add    %al,(%eax)
    375f:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3763:	00 11                	add    %dl,(%ecx)
    3765:	00 00                	add    %al,(%eax)
    3767:	00 00                	add    %al,(%eax)
    3769:	00 00                	add    %al,(%eax)
    376b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    376f:	00 19                	add    %bl,(%ecx)
    3771:	00 00                	add    %al,(%eax)
    3773:	00 00                	add    %al,(%eax)
    3775:	00 00                	add    %al,(%eax)
    3777:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
    377b:	00 1e                	add    %bl,(%esi)
    377d:	00 00                	add    %al,(%eax)
    377f:	00 00                	add    %al,(%eax)
    3781:	00 00                	add    %al,(%eax)
    3783:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
    3787:	00 27                	add    %ah,(%edi)
    3789:	00 00                	add    %al,(%eax)
    378b:	00 00                	add    %al,(%eax)
    378d:	00 00                	add    %al,(%eax)
    378f:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3793:	00 2d 00 00 00 00    	add    %ch,0x0
    3799:	00 00                	add    %al,(%eax)
    379b:	00 44 00 8f          	add    %al,-0x71(%eax,%eax,1)
    379f:	00 34 00             	add    %dh,(%eax,%eax,1)
    37a2:	00 00                	add    %al,(%eax)
    37a4:	00 00                	add    %al,(%eax)
    37a6:	00 00                	add    %al,(%eax)
    37a8:	44                   	inc    %esp
    37a9:	00 91 00 41 00 00    	add    %dl,0x4100(%ecx)
    37af:	00 00                	add    %al,(%eax)
    37b1:	00 00                	add    %al,(%eax)
    37b3:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    37b7:	00 43 00             	add    %al,0x0(%ebx)
    37ba:	00 00                	add    %al,(%eax)
    37bc:	00 00                	add    %al,(%eax)
    37be:	00 00                	add    %al,(%eax)
    37c0:	44                   	inc    %esp
    37c1:	00 91 00 46 00 00    	add    %dl,0x4600(%ecx)
    37c7:	00 00                	add    %al,(%eax)
    37c9:	00 00                	add    %al,(%eax)
    37cb:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    37cf:	00 49 00             	add    %cl,0x0(%ecx)
    37d2:	00 00                	add    %al,(%eax)
    37d4:	00 00                	add    %al,(%eax)
    37d6:	00 00                	add    %al,(%eax)
    37d8:	44                   	inc    %esp
    37d9:	00 94 00 4e 00 00 00 	add    %dl,0x4e(%eax,%eax,1)
    37e0:	00 00                	add    %al,(%eax)
    37e2:	00 00                	add    %al,(%eax)
    37e4:	44                   	inc    %esp
    37e5:	00 96 00 56 00 00    	add    %dl,0x5600(%esi)
    37eb:	00 00                	add    %al,(%eax)
    37ed:	00 00                	add    %al,(%eax)
    37ef:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    37f3:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    37f7:	00 00                	add    %al,(%eax)
    37f9:	00 00                	add    %al,(%eax)
    37fb:	00 44 00 99          	add    %al,-0x67(%eax,%eax,1)
    37ff:	00 62 00             	add    %ah,0x0(%edx)
    3802:	00 00                	add    %al,(%eax)
    3804:	00 00                	add    %al,(%eax)
    3806:	00 00                	add    %al,(%eax)
    3808:	44                   	inc    %esp
    3809:	00 9b 00 66 00 00    	add    %bl,0x6600(%ebx)
    380f:	00 00                	add    %al,(%eax)
    3811:	00 00                	add    %al,(%eax)
    3813:	00 44 00 a6          	add    %al,-0x5a(%eax,%eax,1)
    3817:	00 79 00             	add    %bh,0x0(%ecx)
    381a:	00 00                	add    %al,(%eax)
    381c:	00 00                	add    %al,(%eax)
    381e:	00 00                	add    %al,(%eax)
    3820:	44                   	inc    %esp
    3821:	00 a8 00 7e 00 00    	add    %ch,0x7e00(%eax)
    3827:	00 00                	add    %al,(%eax)
    3829:	00 00                	add    %al,(%eax)
    382b:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
    382f:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    3835:	00 00                	add    %al,(%eax)
    3837:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
    383b:	00 8e 00 00 00 00    	add    %cl,0x0(%esi)
    3841:	00 00                	add    %al,(%eax)
    3843:	00 44 00 aa          	add    %al,-0x56(%eax,%eax,1)
    3847:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
    384d:	00 00                	add    %al,(%eax)
    384f:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    3853:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    385a:	00 00                	add    %al,(%eax)
    385c:	44                   	inc    %esp
    385d:	00 b1 00 98 00 00    	add    %dh,0x9800(%ecx)
    3863:	00 00                	add    %al,(%eax)
    3865:	00 00                	add    %al,(%eax)
    3867:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    386b:	00 a1 00 00 00 00    	add    %ah,0x0(%ecx)
    3871:	00 00                	add    %al,(%eax)
    3873:	00 44 00 b5          	add    %al,-0x4b(%eax,%eax,1)
    3877:	00 a6 00 00 00 00    	add    %ah,0x0(%esi)
    387d:	00 00                	add    %al,(%eax)
    387f:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
    3883:	00 be 00 00 00 00    	add    %bh,0x0(%esi)
    3889:	00 00                	add    %al,(%eax)
    388b:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    388f:	00 c2                	add    %al,%dl
    3891:	00 00                	add    %al,(%eax)
    3893:	00 00                	add    %al,(%eax)
    3895:	00 00                	add    %al,(%eax)
    3897:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
    389b:	00 c5                	add    %al,%ch
    389d:	00 00                	add    %al,(%eax)
    389f:	00 00                	add    %al,(%eax)
    38a1:	00 00                	add    %al,(%eax)
    38a3:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    38a7:	00 c7                	add    %al,%bh
    38a9:	00 00                	add    %al,(%eax)
    38ab:	00 00                	add    %al,(%eax)
    38ad:	00 00                	add    %al,(%eax)
    38af:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    38b3:	00 c9                	add    %cl,%cl
    38b5:	00 00                	add    %al,(%eax)
    38b7:	00 00                	add    %al,(%eax)
    38b9:	00 00                	add    %al,(%eax)
    38bb:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
    38bf:	00 cf                	add    %cl,%bh
    38c1:	00 00                	add    %al,(%eax)
    38c3:	00 00                	add    %al,(%eax)
    38c5:	00 00                	add    %al,(%eax)
    38c7:	00 44 00 be          	add    %al,-0x42(%eax,%eax,1)
    38cb:	00 d2                	add    %dl,%dl
    38cd:	00 00                	add    %al,(%eax)
    38cf:	00 00                	add    %al,(%eax)
    38d1:	00 00                	add    %al,(%eax)
    38d3:	00 44 00 bd          	add    %al,-0x43(%eax,%eax,1)
    38d7:	00 d5                	add    %dl,%ch
    38d9:	00 00                	add    %al,(%eax)
    38db:	00 00                	add    %al,(%eax)
    38dd:	00 00                	add    %al,(%eax)
    38df:	00 44 00 c4          	add    %al,-0x3c(%eax,%eax,1)
    38e3:	00 da                	add    %bl,%dl
    38e5:	00 00                	add    %al,(%eax)
    38e7:	00 00                	add    %al,(%eax)
    38e9:	00 00                	add    %al,(%eax)
    38eb:	00 44 00 c5          	add    %al,-0x3b(%eax,%eax,1)
    38ef:	00 dd                	add    %bl,%ch
    38f1:	00 00                	add    %al,(%eax)
    38f3:	00 00                	add    %al,(%eax)
    38f5:	00 00                	add    %al,(%eax)
    38f7:	00 44 00 c7          	add    %al,-0x39(%eax,%eax,1)
    38fb:	00 e0                	add    %ah,%al
    38fd:	00 00                	add    %al,(%eax)
    38ff:	00 00                	add    %al,(%eax)
    3901:	00 00                	add    %al,(%eax)
    3903:	00 44 00 c8          	add    %al,-0x38(%eax,%eax,1)
    3907:	00 e3                	add    %ah,%bl
    3909:	00 00                	add    %al,(%eax)
    390b:	00 a5 12 00 00 40    	add    %ah,0x40000012(%ebp)
    3911:	00 00                	add    %al,(%eax)
    3913:	00 00                	add    %al,(%eax)
    3915:	00 00                	add    %al,(%eax)
    3917:	00 3f                	add    %bh,(%edi)
    3919:	13 00                	adc    (%eax),%eax
    391b:	00 40 00             	add    %al,0x0(%eax)
    391e:	00 00                	add    %al,(%eax)
    3920:	07                   	pop    %es
    3921:	00 00                	add    %al,(%eax)
    3923:	00 4b 13             	add    %cl,0x13(%ebx)
    3926:	00 00                	add    %al,(%eax)
    3928:	24 00                	and    $0x0,%al
    392a:	00 00                	add    %al,(%eax)
    392c:	32 12                	xor    (%edx),%dl
    392e:	28 00                	sub    %al,(%eax)
    3930:	c5 12                	lds    (%edx),%edx
    3932:	00 00                	add    %al,(%eax)
    3934:	a0 00 00 00 08       	mov    0x8000000,%al
    3939:	00 00                	add    %al,(%eax)
    393b:	00 33                	add    %dh,(%ebx)
    393d:	13 00                	adc    (%eax),%eax
    393f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3945:	00 00                	add    %al,(%eax)
    3947:	00 f4                	add    %dh,%ah
    3949:	12 00                	adc    (%eax),%al
    394b:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    3951:	00 00                	add    %al,(%eax)
    3953:	00 00                	add    %al,(%eax)
    3955:	00 00                	add    %al,(%eax)
    3957:	00 44 00 7b          	add    %al,0x7b(%eax,%eax,1)
	...
    3963:	00 44 00 7c          	add    %al,0x7c(%eax,%eax,1)
    3967:	00 03                	add    %al,(%ebx)
    3969:	00 00                	add    %al,(%eax)
    396b:	00 00                	add    %al,(%eax)
    396d:	00 00                	add    %al,(%eax)
    396f:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    3973:	00 10                	add    %dl,(%eax)
    3975:	00 00                	add    %al,(%eax)
    3977:	00 00                	add    %al,(%eax)
    3979:	00 00                	add    %al,(%eax)
    397b:	00 44 00 7e          	add    %al,0x7e(%eax,%eax,1)
    397f:	00 13                	add    %dl,(%ebx)
    3981:	00 00                	add    %al,(%eax)
    3983:	00 00                	add    %al,(%eax)
    3985:	00 00                	add    %al,(%eax)
    3987:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
    398b:	00 14 00             	add    %dl,(%eax,%eax,1)
    398e:	00 00                	add    %al,(%eax)
    3990:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    3991:	12 00                	adc    (%eax),%al
    3993:	00 40 00             	add    %al,0x0(%eax)
    3996:	00 00                	add    %al,(%eax)
    3998:	00 00                	add    %al,(%eax)
    399a:	00 00                	add    %al,(%eax)
    399c:	61                   	popa   
    399d:	13 00                	adc    (%eax),%eax
    399f:	00 40 00             	add    %al,0x0(%eax)
    39a2:	00 00                	add    %al,(%eax)
    39a4:	00 00                	add    %al,(%eax)
    39a6:	00 00                	add    %al,(%eax)
    39a8:	6d                   	insl   (%dx),%es:(%edi)
    39a9:	13 00                	adc    (%eax),%eax
    39ab:	00 24 00             	add    %ah,(%eax,%eax,1)
    39ae:	00 00                	add    %al,(%eax)
    39b0:	4b                   	dec    %ebx
    39b1:	12 28                	adc    (%eax),%ch
    39b3:	00 89 13 00 00 a0    	add    %cl,-0x5fffffed(%ecx)
    39b9:	00 00                	add    %al,(%eax)
    39bb:	00 08                	add    %cl,(%eax)
    39bd:	00 00                	add    %al,(%eax)
    39bf:	00 98 13 00 00 a0    	add    %bl,-0x5fffffed(%eax)
    39c5:	00 00                	add    %al,(%eax)
    39c7:	00 0c 00             	add    %cl,(%eax,%eax,1)
    39ca:	00 00                	add    %al,(%eax)
    39cc:	80 0b 00             	orb    $0x0,(%ebx)
    39cf:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    39d5:	00 00                	add    %al,(%eax)
    39d7:	00 a4 13 00 00 a0 00 	add    %ah,0xa00000(%ebx,%edx,1)
    39de:	00 00                	add    %al,(%eax)
    39e0:	14 00                	adc    $0x0,%al
    39e2:	00 00                	add    %al,(%eax)
    39e4:	00 00                	add    %al,(%eax)
    39e6:	00 00                	add    %al,(%eax)
    39e8:	44                   	inc    %esp
    39e9:	00 cb                	add    %cl,%bl
	...
    39f3:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    39f7:	00 03                	add    %al,(%ebx)
    39f9:	00 00                	add    %al,(%eax)
    39fb:	00 00                	add    %al,(%eax)
    39fd:	00 00                	add    %al,(%eax)
    39ff:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    3a03:	00 10                	add    %dl,(%eax)
    3a05:	00 00                	add    %al,(%eax)
    3a07:	00 00                	add    %al,(%eax)
    3a09:	00 00                	add    %al,(%eax)
    3a0b:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    3a0f:	00 16                	add    %dl,(%esi)
    3a11:	00 00                	add    %al,(%eax)
    3a13:	00 00                	add    %al,(%eax)
    3a15:	00 00                	add    %al,(%eax)
    3a17:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    3a1b:	00 19                	add    %bl,(%ecx)
    3a1d:	00 00                	add    %al,(%eax)
    3a1f:	00 00                	add    %al,(%eax)
    3a21:	00 00                	add    %al,(%eax)
    3a23:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    3a27:	00 20                	add    %ah,(%eax)
    3a29:	00 00                	add    %al,(%eax)
    3a2b:	00 00                	add    %al,(%eax)
    3a2d:	00 00                	add    %al,(%eax)
    3a2f:	00 44 00 d3          	add    %al,-0x2d(%eax,%eax,1)
    3a33:	00 22                	add    %ah,(%edx)
    3a35:	00 00                	add    %al,(%eax)
    3a37:	00 00                	add    %al,(%eax)
    3a39:	00 00                	add    %al,(%eax)
    3a3b:	00 44 00 d4          	add    %al,-0x2c(%eax,%eax,1)
    3a3f:	00 28                	add    %ch,(%eax)
    3a41:	00 00                	add    %al,(%eax)
    3a43:	00 00                	add    %al,(%eax)
    3a45:	00 00                	add    %al,(%eax)
    3a47:	00 44 00 d5          	add    %al,-0x2b(%eax,%eax,1)
    3a4b:	00 2e                	add    %ch,(%esi)
    3a4d:	00 00                	add    %al,(%eax)
    3a4f:	00 00                	add    %al,(%eax)
    3a51:	00 00                	add    %al,(%eax)
    3a53:	00 44 00 d8          	add    %al,-0x28(%eax,%eax,1)
    3a57:	00 30                	add    %dh,(%eax)
    3a59:	00 00                	add    %al,(%eax)
    3a5b:	00 00                	add    %al,(%eax)
    3a5d:	00 00                	add    %al,(%eax)
    3a5f:	00 44 00 d6          	add    %al,-0x2a(%eax,%eax,1)
    3a63:	00 3b                	add    %bh,(%ebx)
    3a65:	00 00                	add    %al,(%eax)
    3a67:	00 00                	add    %al,(%eax)
    3a69:	00 00                	add    %al,(%eax)
    3a6b:	00 44 00 db          	add    %al,-0x25(%eax,%eax,1)
    3a6f:	00 43 00             	add    %al,0x0(%ebx)
    3a72:	00 00                	add    %al,(%eax)
    3a74:	b1 13                	mov    $0x13,%cl
    3a76:	00 00                	add    %al,(%eax)
    3a78:	40                   	inc    %eax
    3a79:	00 00                	add    %al,(%eax)
    3a7b:	00 00                	add    %al,(%eax)
    3a7d:	00 00                	add    %al,(%eax)
    3a7f:	00 bd 13 00 00 40    	add    %bh,0x40000013(%ebp)
    3a85:	00 00                	add    %al,(%eax)
    3a87:	00 02                	add    %al,(%edx)
    3a89:	00 00                	add    %al,(%eax)
    3a8b:	00 c9                	add    %cl,%cl
    3a8d:	13 00                	adc    (%eax),%eax
    3a8f:	00 40 00             	add    %al,0x0(%eax)
    3a92:	00 00                	add    %al,(%eax)
    3a94:	02 00                	add    (%eax),%al
    3a96:	00 00                	add    %al,(%eax)
    3a98:	d6                   	(bad)  
    3a99:	13 00                	adc    (%eax),%eax
    3a9b:	00 40 00             	add    %al,0x0(%eax)
    3a9e:	00 00                	add    %al,(%eax)
    3aa0:	02 00                	add    (%eax),%al
    3aa2:	00 00                	add    %al,(%eax)
    3aa4:	00 00                	add    %al,(%eax)
    3aa6:	00 00                	add    %al,(%eax)
    3aa8:	c0 00 00             	rolb   $0x0,(%eax)
	...
    3ab3:	00 e0                	add    %ah,%al
    3ab5:	00 00                	add    %al,(%eax)
    3ab7:	00 45 00             	add    %al,0x0(%ebp)
    3aba:	00 00                	add    %al,(%eax)
    3abc:	e3 13                	jecxz  3ad1 <bootmain-0x27c52f>
    3abe:	00 00                	add    %al,(%eax)
    3ac0:	24 00                	and    $0x0,%al
    3ac2:	00 00                	add    %al,(%eax)
    3ac4:	90                   	nop
    3ac5:	12 28                	adc    (%eax),%ch
    3ac7:	00 f7                	add    %dh,%bh
    3ac9:	13 00                	adc    (%eax),%eax
    3acb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3ad1:	00 00                	add    %al,(%eax)
    3ad3:	00 00                	add    %al,(%eax)
    3ad5:	00 00                	add    %al,(%eax)
    3ad7:	00 44 00 de          	add    %al,-0x22(%eax,%eax,1)
	...
    3ae3:	00 44 00 e1          	add    %al,-0x1f(%eax,%eax,1)
    3ae7:	00 01                	add    %al,(%ecx)
    3ae9:	00 00                	add    %al,(%eax)
    3aeb:	00 00                	add    %al,(%eax)
    3aed:	00 00                	add    %al,(%eax)
    3aef:	00 44 00 de          	add    %al,-0x22(%eax,%eax,1)
    3af3:	00 03                	add    %al,(%ebx)
    3af5:	00 00                	add    %al,(%eax)
    3af7:	00 00                	add    %al,(%eax)
    3af9:	00 00                	add    %al,(%eax)
    3afb:	00 44 00 de          	add    %al,-0x22(%eax,%eax,1)
    3aff:	00 05 00 00 00 00    	add    %al,0x0
    3b05:	00 00                	add    %al,(%eax)
    3b07:	00 44 00 e3          	add    %al,-0x1d(%eax,%eax,1)
    3b0b:	00 0d 00 00 00 00    	add    %cl,0x0
    3b11:	00 00                	add    %al,(%eax)
    3b13:	00 44 00 e5          	add    %al,-0x1b(%eax,%eax,1)
    3b17:	00 14 00             	add    %dl,(%eax,%eax,1)
    3b1a:	00 00                	add    %al,(%eax)
    3b1c:	00 00                	add    %al,(%eax)
    3b1e:	00 00                	add    %al,(%eax)
    3b20:	44                   	inc    %esp
    3b21:	00 e6                	add    %ah,%dh
    3b23:	00 18                	add    %bl,(%eax)
    3b25:	00 00                	add    %al,(%eax)
    3b27:	00 00                	add    %al,(%eax)
    3b29:	00 00                	add    %al,(%eax)
    3b2b:	00 44 00 e7          	add    %al,-0x19(%eax,%eax,1)
    3b2f:	00 1f                	add    %bl,(%edi)
    3b31:	00 00                	add    %al,(%eax)
    3b33:	00 00                	add    %al,(%eax)
    3b35:	00 00                	add    %al,(%eax)
    3b37:	00 44 00 e8          	add    %al,-0x18(%eax,%eax,1)
    3b3b:	00 26                	add    %ah,(%esi)
    3b3d:	00 00                	add    %al,(%eax)
    3b3f:	00 00                	add    %al,(%eax)
    3b41:	00 00                	add    %al,(%eax)
    3b43:	00 44 00 e1          	add    %al,-0x1f(%eax,%eax,1)
    3b47:	00 28                	add    %ch,(%eax)
    3b49:	00 00                	add    %al,(%eax)
    3b4b:	00 00                	add    %al,(%eax)
    3b4d:	00 00                	add    %al,(%eax)
    3b4f:	00 44 00 eb          	add    %al,-0x15(%eax,%eax,1)
    3b53:	00 30                	add    %dh,(%eax)
    3b55:	00 00                	add    %al,(%eax)
    3b57:	00 00                	add    %al,(%eax)
    3b59:	00 00                	add    %al,(%eax)
    3b5b:	00 44 00 ec          	add    %al,-0x14(%eax,%eax,1)
    3b5f:	00 33                	add    %dh,(%ebx)
    3b61:	00 00                	add    %al,(%eax)
    3b63:	00 03                	add    %al,(%ebx)
    3b65:	14 00                	adc    $0x0,%al
    3b67:	00 40 00             	add    %al,0x0(%eax)
    3b6a:	00 00                	add    %al,(%eax)
    3b6c:	00 00                	add    %al,(%eax)
    3b6e:	00 00                	add    %al,(%eax)
    3b70:	af                   	scas   %es:(%edi),%eax
    3b71:	0a 00                	or     (%eax),%al
    3b73:	00 40 00             	add    %al,0x0(%eax)
    3b76:	00 00                	add    %al,(%eax)
    3b78:	00 00                	add    %al,(%eax)
    3b7a:	00 00                	add    %al,(%eax)
    3b7c:	b1 13                	mov    $0x13,%cl
    3b7e:	00 00                	add    %al,(%eax)
    3b80:	40                   	inc    %eax
    3b81:	00 00                	add    %al,(%eax)
    3b83:	00 02                	add    %al,(%edx)
    3b85:	00 00                	add    %al,(%eax)
    3b87:	00 00                	add    %al,(%eax)
    3b89:	00 00                	add    %al,(%eax)
    3b8b:	00 c0                	add    %al,%al
	...
    3b95:	00 00                	add    %al,(%eax)
    3b97:	00 e0                	add    %ah,%al
    3b99:	00 00                	add    %al,(%eax)
    3b9b:	00 35 00 00 00 0f    	add    %dh,0xf000000
    3ba1:	14 00                	adc    $0x0,%al
    3ba3:	00 24 00             	add    %ah,(%eax,%eax,1)
    3ba6:	00 00                	add    %al,(%eax)
    3ba8:	c5 12                	lds    (%edx),%edx
    3baa:	28 00                	sub    %al,(%eax)
    3bac:	24 14                	and    $0x14,%al
    3bae:	00 00                	add    %al,(%eax)
    3bb0:	a0 00 00 00 08       	mov    0x8000000,%al
    3bb5:	00 00                	add    %al,(%eax)
    3bb7:	00 30                	add    %dh,(%eax)
    3bb9:	14 00                	adc    $0x0,%al
    3bbb:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    3bc1:	00 00                	add    %al,(%eax)
    3bc3:	00 80 0b 00 00 a0    	add    %al,-0x5ffffff5(%eax)
    3bc9:	00 00                	add    %al,(%eax)
    3bcb:	00 10                	add    %dl,(%eax)
    3bcd:	00 00                	add    %al,(%eax)
    3bcf:	00 a4 13 00 00 a0 00 	add    %ah,0xa00000(%ebx,%edx,1)
    3bd6:	00 00                	add    %al,(%eax)
    3bd8:	14 00                	adc    $0x0,%al
    3bda:	00 00                	add    %al,(%eax)
    3bdc:	3b 14 00             	cmp    (%eax,%eax,1),%edx
    3bdf:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    3be5:	00 00                	add    %al,(%eax)
    3be7:	00 00                	add    %al,(%eax)
    3be9:	00 00                	add    %al,(%eax)
    3beb:	00 44 00 f1          	add    %al,-0xf(%eax,%eax,1)
	...
    3bf7:	00 44 00 f1          	add    %al,-0xf(%eax,%eax,1)
    3bfb:	00 03                	add    %al,(%ebx)
    3bfd:	00 00                	add    %al,(%eax)
    3bff:	00 00                	add    %al,(%eax)
    3c01:	00 00                	add    %al,(%eax)
    3c03:	00 44 00 f2          	add    %al,-0xe(%eax,%eax,1)
    3c07:	00 06                	add    %al,(%esi)
    3c09:	00 00                	add    %al,(%eax)
    3c0b:	00 00                	add    %al,(%eax)
    3c0d:	00 00                	add    %al,(%eax)
    3c0f:	00 44 00 f3          	add    %al,-0xd(%eax,%eax,1)
    3c13:	00 0b                	add    %cl,(%ebx)
    3c15:	00 00                	add    %al,(%eax)
    3c17:	00 00                	add    %al,(%eax)
    3c19:	00 00                	add    %al,(%eax)
    3c1b:	00 44 00 f4          	add    %al,-0xc(%eax,%eax,1)
    3c1f:	00 11                	add    %dl,(%ecx)
    3c21:	00 00                	add    %al,(%eax)
    3c23:	00 00                	add    %al,(%eax)
    3c25:	00 00                	add    %al,(%eax)
    3c27:	00 44 00 f5          	add    %al,-0xb(%eax,%eax,1)
    3c2b:	00 17                	add    %dl,(%edi)
    3c2d:	00 00                	add    %al,(%eax)
    3c2f:	00 00                	add    %al,(%eax)
    3c31:	00 00                	add    %al,(%eax)
    3c33:	00 44 00 f7          	add    %al,-0x9(%eax,%eax,1)
    3c37:	00 1d 00 00 00 03    	add    %bl,0x3000000
    3c3d:	14 00                	adc    $0x0,%al
    3c3f:	00 40 00             	add    %al,0x0(%eax)
    3c42:	00 00                	add    %al,(%eax)
    3c44:	00 00                	add    %al,(%eax)
    3c46:	00 00                	add    %al,(%eax)
    3c48:	4a                   	dec    %edx
    3c49:	14 00                	adc    $0x0,%al
    3c4b:	00 40 00             	add    %al,0x0(%eax)
    3c4e:	00 00                	add    %al,(%eax)
    3c50:	02 00                	add    (%eax),%al
    3c52:	00 00                	add    %al,(%eax)
    3c54:	c9                   	leave  
    3c55:	13 00                	adc    (%eax),%eax
    3c57:	00 40 00             	add    %al,0x0(%eax)
    3c5a:	00 00                	add    %al,(%eax)
    3c5c:	02 00                	add    (%eax),%al
    3c5e:	00 00                	add    %al,(%eax)
    3c60:	d6                   	(bad)  
    3c61:	13 00                	adc    (%eax),%eax
    3c63:	00 40 00             	add    %al,0x0(%eax)
    3c66:	00 00                	add    %al,(%eax)
    3c68:	02 00                	add    (%eax),%al
    3c6a:	00 00                	add    %al,(%eax)
    3c6c:	55                   	push   %ebp
    3c6d:	14 00                	adc    $0x0,%al
    3c6f:	00 40 00             	add    %al,0x0(%eax)
    3c72:	00 00                	add    %al,(%eax)
    3c74:	02 00                	add    (%eax),%al
    3c76:	00 00                	add    %al,(%eax)
    3c78:	64                   	fs
    3c79:	14 00                	adc    $0x0,%al
    3c7b:	00 24 00             	add    %ah,(%eax,%eax,1)
    3c7e:	00 00                	add    %al,(%eax)
    3c80:	e4 12                	in     $0x12,%al
    3c82:	28 00                	sub    %al,(%eax)
    3c84:	f7 13                	notl   (%ebx)
    3c86:	00 00                	add    %al,(%eax)
    3c88:	a0 00 00 00 08       	mov    0x8000000,%al
    3c8d:	00 00                	add    %al,(%eax)
    3c8f:	00 7d 14             	add    %bh,0x14(%ebp)
    3c92:	00 00                	add    %al,(%eax)
    3c94:	a0 00 00 00 0c       	mov    0xc000000,%al
    3c99:	00 00                	add    %al,(%eax)
    3c9b:	00 88 14 00 00 a0    	add    %cl,-0x5fffffec(%eax)
    3ca1:	00 00                	add    %al,(%eax)
    3ca3:	00 10                	add    %dl,(%eax)
    3ca5:	00 00                	add    %al,(%eax)
    3ca7:	00 93 14 00 00 a0    	add    %dl,-0x5fffffec(%ebx)
    3cad:	00 00                	add    %al,(%eax)
    3caf:	00 14 00             	add    %dl,(%eax,%eax,1)
    3cb2:	00 00                	add    %al,(%eax)
    3cb4:	9e                   	sahf   
    3cb5:	14 00                	adc    $0x0,%al
    3cb7:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    3cbd:	00 00                	add    %al,(%eax)
    3cbf:	00 00                	add    %al,(%eax)
    3cc1:	00 00                	add    %al,(%eax)
    3cc3:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
    3cc7:	01 00                	add    %eax,(%eax)
    3cc9:	00 00                	add    %al,(%eax)
    3ccb:	00 00                	add    %al,(%eax)
    3ccd:	00 00                	add    %al,(%eax)
    3ccf:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    3cd3:	01 04 00             	add    %eax,(%eax,%eax,1)
    3cd6:	00 00                	add    %al,(%eax)
    3cd8:	00 00                	add    %al,(%eax)
    3cda:	00 00                	add    %al,(%eax)
    3cdc:	44                   	inc    %esp
    3cdd:	00 59 01             	add    %bl,0x1(%ecx)
    3ce0:	06                   	push   %es
    3ce1:	00 00                	add    %al,(%eax)
    3ce3:	00 00                	add    %al,(%eax)
    3ce5:	00 00                	add    %al,(%eax)
    3ce7:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    3ceb:	01 0b                	add    %ecx,(%ebx)
    3ced:	00 00                	add    %al,(%eax)
    3cef:	00 00                	add    %al,(%eax)
    3cf1:	00 00                	add    %al,(%eax)
    3cf3:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    3cf7:	01 13                	add    %edx,(%ebx)
    3cf9:	00 00                	add    %al,(%eax)
    3cfb:	00 00                	add    %al,(%eax)
    3cfd:	00 00                	add    %al,(%eax)
    3cff:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    3d03:	01 1f                	add    %ebx,(%edi)
    3d05:	00 00                	add    %al,(%eax)
    3d07:	00 00                	add    %al,(%eax)
    3d09:	00 00                	add    %al,(%eax)
    3d0b:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    3d0f:	01 22                	add    %esp,(%edx)
    3d11:	00 00                	add    %al,(%eax)
    3d13:	00 00                	add    %al,(%eax)
    3d15:	00 00                	add    %al,(%eax)
    3d17:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    3d1b:	01 29                	add    %ebp,(%ecx)
    3d1d:	00 00                	add    %al,(%eax)
    3d1f:	00 00                	add    %al,(%eax)
    3d21:	00 00                	add    %al,(%eax)
    3d23:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    3d27:	01 30                	add    %esi,(%eax)
    3d29:	00 00                	add    %al,(%eax)
    3d2b:	00 00                	add    %al,(%eax)
    3d2d:	00 00                	add    %al,(%eax)
    3d2f:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    3d33:	01 35 00 00 00 00    	add    %esi,0x0
    3d39:	00 00                	add    %al,(%eax)
    3d3b:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    3d3f:	01 3d 00 00 00 00    	add    %edi,0x0
    3d45:	00 00                	add    %al,(%eax)
    3d47:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    3d4b:	01 40 00             	add    %eax,0x0(%eax)
    3d4e:	00 00                	add    %al,(%eax)
    3d50:	00 00                	add    %al,(%eax)
    3d52:	00 00                	add    %al,(%eax)
    3d54:	44                   	inc    %esp
    3d55:	00 66 01             	add    %ah,0x1(%esi)
    3d58:	42                   	inc    %edx
    3d59:	00 00                	add    %al,(%eax)
    3d5b:	00 00                	add    %al,(%eax)
    3d5d:	00 00                	add    %al,(%eax)
    3d5f:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    3d63:	01 48 00             	add    %ecx,0x0(%eax)
    3d66:	00 00                	add    %al,(%eax)
    3d68:	00 00                	add    %al,(%eax)
    3d6a:	00 00                	add    %al,(%eax)
    3d6c:	44                   	inc    %esp
    3d6d:	00 69 01             	add    %ch,0x1(%ecx)
    3d70:	4f                   	dec    %edi
    3d71:	00 00                	add    %al,(%eax)
    3d73:	00 00                	add    %al,(%eax)
    3d75:	00 00                	add    %al,(%eax)
    3d77:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
    3d7b:	01 54 00 00          	add    %edx,0x0(%eax,%eax,1)
    3d7f:	00 00                	add    %al,(%eax)
    3d81:	00 00                	add    %al,(%eax)
    3d83:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    3d87:	01 57 00             	add    %edx,0x0(%edi)
    3d8a:	00 00                	add    %al,(%eax)
    3d8c:	00 00                	add    %al,(%eax)
    3d8e:	00 00                	add    %al,(%eax)
    3d90:	44                   	inc    %esp
    3d91:	00 6a 01             	add    %ch,0x1(%edx)
    3d94:	5a                   	pop    %edx
    3d95:	00 00                	add    %al,(%eax)
    3d97:	00 00                	add    %al,(%eax)
    3d99:	00 00                	add    %al,(%eax)
    3d9b:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
    3d9f:	01 61 00             	add    %esp,0x0(%ecx)
    3da2:	00 00                	add    %al,(%eax)
    3da4:	00 00                	add    %al,(%eax)
    3da6:	00 00                	add    %al,(%eax)
    3da8:	44                   	inc    %esp
    3da9:	00 6c 01 6e          	add    %ch,0x6e(%ecx,%eax,1)
    3dad:	00 00                	add    %al,(%eax)
    3daf:	00 00                	add    %al,(%eax)
    3db1:	00 00                	add    %al,(%eax)
    3db3:	00 44 00 6d          	add    %al,0x6d(%eax,%eax,1)
    3db7:	01 7a 00             	add    %edi,0x0(%edx)
    3dba:	00 00                	add    %al,(%eax)
    3dbc:	00 00                	add    %al,(%eax)
    3dbe:	00 00                	add    %al,(%eax)
    3dc0:	44                   	inc    %esp
    3dc1:	00 6f 01             	add    %ch,0x1(%edi)
    3dc4:	82                   	(bad)  
    3dc5:	00 00                	add    %al,(%eax)
    3dc7:	00 00                	add    %al,(%eax)
    3dc9:	00 00                	add    %al,(%eax)
    3dcb:	00 44 00 67          	add    %al,0x67(%eax,%eax,1)
    3dcf:	01 95 00 00 00 00    	add    %edx,0x0(%ebp)
    3dd5:	00 00                	add    %al,(%eax)
    3dd7:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    3ddb:	01 98 00 00 00 00    	add    %ebx,0x0(%eax)
    3de1:	00 00                	add    %al,(%eax)
    3de3:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    3de7:	01 9d 00 00 00 00    	add    %ebx,0x0(%ebp)
    3ded:	00 00                	add    %al,(%eax)
    3def:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    3df3:	01 a3 00 00 00 a9    	add    %esp,-0x57000000(%ebx)
    3df9:	14 00                	adc    $0x0,%al
    3dfb:	00 40 00             	add    %al,0x0(%eax)
    3dfe:	00 00                	add    %al,(%eax)
    3e00:	07                   	pop    %es
    3e01:	00 00                	add    %al,(%eax)
    3e03:	00 b2 14 00 00 40    	add    %dh,0x40000014(%edx)
    3e09:	00 00                	add    %al,(%eax)
    3e0b:	00 01                	add    %al,(%ecx)
    3e0d:	00 00                	add    %al,(%eax)
    3e0f:	00 03                	add    %al,(%ebx)
    3e11:	14 00                	adc    $0x0,%al
    3e13:	00 40 00             	add    %al,0x0(%eax)
	...
    3e1e:	00 00                	add    %al,(%eax)
    3e20:	c0 00 00             	rolb   $0x0,(%eax)
	...
    3e2b:	00 e0                	add    %ah,%al
    3e2d:	00 00                	add    %al,(%eax)
    3e2f:	00 ab 00 00 00 bc    	add    %ch,-0x44000000(%ebx)
    3e35:	14 00                	adc    $0x0,%al
    3e37:	00 24 00             	add    %ah,(%eax,%eax,1)
    3e3a:	00 00                	add    %al,(%eax)
    3e3c:	8f                   	(bad)  
    3e3d:	13 28                	adc    (%eax),%ebp
    3e3f:	00 f7                	add    %dh,%bh
    3e41:	13 00                	adc    (%eax),%eax
    3e43:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3e49:	00 00                	add    %al,(%eax)
    3e4b:	00 24 14             	add    %ah,(%esp,%edx,1)
    3e4e:	00 00                	add    %al,(%eax)
    3e50:	a0 00 00 00 0c       	mov    0xc000000,%al
    3e55:	00 00                	add    %al,(%eax)
    3e57:	00 d1                	add    %dl,%cl
    3e59:	14 00                	adc    $0x0,%al
    3e5b:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    3e61:	00 00                	add    %al,(%eax)
    3e63:	00 00                	add    %al,(%eax)
    3e65:	00 00                	add    %al,(%eax)
    3e67:	00 44 00 fb          	add    %al,-0x5(%eax,%eax,1)
	...
    3e73:	00 44 00 fb          	add    %al,-0x5(%eax,%eax,1)
    3e77:	00 07                	add    %al,(%edi)
    3e79:	00 00                	add    %al,(%eax)
    3e7b:	00 00                	add    %al,(%eax)
    3e7d:	00 00                	add    %al,(%eax)
    3e7f:	00 44 00 fd          	add    %al,-0x3(%eax,%eax,1)
    3e83:	00 10                	add    %dl,(%eax)
    3e85:	00 00                	add    %al,(%eax)
    3e87:	00 00                	add    %al,(%eax)
    3e89:	00 00                	add    %al,(%eax)
    3e8b:	00 44 00 fc          	add    %al,-0x4(%eax,%eax,1)
    3e8f:	00 13                	add    %dl,(%ebx)
    3e91:	00 00                	add    %al,(%eax)
    3e93:	00 00                	add    %al,(%eax)
    3e95:	00 00                	add    %al,(%eax)
    3e97:	00 44 00 fd          	add    %al,-0x3(%eax,%eax,1)
    3e9b:	00 16                	add    %dl,(%esi)
    3e9d:	00 00                	add    %al,(%eax)
    3e9f:	00 00                	add    %al,(%eax)
    3ea1:	00 00                	add    %al,(%eax)
    3ea3:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    3ea7:	01 29                	add    %ebp,(%ecx)
    3ea9:	00 00                	add    %al,(%eax)
    3eab:	00 00                	add    %al,(%eax)
    3ead:	00 00                	add    %al,(%eax)
    3eaf:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    3eb3:	01 2b                	add    %ebp,(%ebx)
    3eb5:	00 00                	add    %al,(%eax)
    3eb7:	00 00                	add    %al,(%eax)
    3eb9:	00 00                	add    %al,(%eax)
    3ebb:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    3ebf:	01 2e                	add    %ebp,(%esi)
    3ec1:	00 00                	add    %al,(%eax)
    3ec3:	00 00                	add    %al,(%eax)
    3ec5:	00 00                	add    %al,(%eax)
    3ec7:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    3ecb:	01 30                	add    %esi,(%eax)
    3ecd:	00 00                	add    %al,(%eax)
    3ecf:	00 00                	add    %al,(%eax)
    3ed1:	00 00                	add    %al,(%eax)
    3ed3:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    3ed7:	01 34 00             	add    %esi,(%eax,%eax,1)
    3eda:	00 00                	add    %al,(%eax)
    3edc:	00 00                	add    %al,(%eax)
    3ede:	00 00                	add    %al,(%eax)
    3ee0:	44                   	inc    %esp
    3ee1:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    3ee4:	3e 00 00             	add    %al,%ds:(%eax)
    3ee7:	00 00                	add    %al,(%eax)
    3ee9:	00 00                	add    %al,(%eax)
    3eeb:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    3eef:	01 40 00             	add    %eax,0x0(%eax)
    3ef2:	00 00                	add    %al,(%eax)
    3ef4:	00 00                	add    %al,(%eax)
    3ef6:	00 00                	add    %al,(%eax)
    3ef8:	44                   	inc    %esp
    3ef9:	00 0f                	add    %cl,(%edi)
    3efb:	01 47 00             	add    %eax,0x0(%edi)
    3efe:	00 00                	add    %al,(%eax)
    3f00:	00 00                	add    %al,(%eax)
    3f02:	00 00                	add    %al,(%eax)
    3f04:	44                   	inc    %esp
    3f05:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    3f08:	4a                   	dec    %edx
    3f09:	00 00                	add    %al,(%eax)
    3f0b:	00 00                	add    %al,(%eax)
    3f0d:	00 00                	add    %al,(%eax)
    3f0f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    3f13:	01 4c 00 00          	add    %ecx,0x0(%eax,%eax,1)
    3f17:	00 00                	add    %al,(%eax)
    3f19:	00 00                	add    %al,(%eax)
    3f1b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    3f1f:	01 50 00             	add    %edx,0x0(%eax)
    3f22:	00 00                	add    %al,(%eax)
    3f24:	00 00                	add    %al,(%eax)
    3f26:	00 00                	add    %al,(%eax)
    3f28:	44                   	inc    %esp
    3f29:	00 15 01 59 00 00    	add    %dl,0x5901
    3f2f:	00 00                	add    %al,(%eax)
    3f31:	00 00                	add    %al,(%eax)
    3f33:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    3f37:	01 5d 00             	add    %ebx,0x0(%ebp)
    3f3a:	00 00                	add    %al,(%eax)
    3f3c:	00 00                	add    %al,(%eax)
    3f3e:	00 00                	add    %al,(%eax)
    3f40:	44                   	inc    %esp
    3f41:	00 19                	add    %bl,(%ecx)
    3f43:	01 63 00             	add    %esp,0x0(%ebx)
    3f46:	00 00                	add    %al,(%eax)
    3f48:	00 00                	add    %al,(%eax)
    3f4a:	00 00                	add    %al,(%eax)
    3f4c:	44                   	inc    %esp
    3f4d:	00 17                	add    %dl,(%edi)
    3f4f:	01 6d 00             	add    %ebp,0x0(%ebp)
    3f52:	00 00                	add    %al,(%eax)
    3f54:	00 00                	add    %al,(%eax)
    3f56:	00 00                	add    %al,(%eax)
    3f58:	44                   	inc    %esp
    3f59:	00 19                	add    %bl,(%ecx)
    3f5b:	01 6f 00             	add    %ebp,0x0(%edi)
    3f5e:	00 00                	add    %al,(%eax)
    3f60:	00 00                	add    %al,(%eax)
    3f62:	00 00                	add    %al,(%eax)
    3f64:	44                   	inc    %esp
    3f65:	00 1a                	add    %bl,(%edx)
    3f67:	01 76 00             	add    %esi,0x0(%esi)
    3f6a:	00 00                	add    %al,(%eax)
    3f6c:	00 00                	add    %al,(%eax)
    3f6e:	00 00                	add    %al,(%eax)
    3f70:	44                   	inc    %esp
    3f71:	00 17                	add    %dl,(%edi)
    3f73:	01 79 00             	add    %edi,0x0(%ecx)
    3f76:	00 00                	add    %al,(%eax)
    3f78:	00 00                	add    %al,(%eax)
    3f7a:	00 00                	add    %al,(%eax)
    3f7c:	44                   	inc    %esp
    3f7d:	00 17                	add    %dl,(%edi)
    3f7f:	01 7b 00             	add    %edi,0x0(%ebx)
    3f82:	00 00                	add    %al,(%eax)
    3f84:	00 00                	add    %al,(%eax)
    3f86:	00 00                	add    %al,(%eax)
    3f88:	44                   	inc    %esp
    3f89:	00 22                	add    %ah,(%edx)
    3f8b:	01 7f 00             	add    %edi,0x0(%edi)
    3f8e:	00 00                	add    %al,(%eax)
    3f90:	00 00                	add    %al,(%eax)
    3f92:	00 00                	add    %al,(%eax)
    3f94:	44                   	inc    %esp
    3f95:	00 25 01 81 00 00    	add    %ah,0x8101
    3f9b:	00 00                	add    %al,(%eax)
    3f9d:	00 00                	add    %al,(%eax)
    3f9f:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    3fa3:	01 85 00 00 00 00    	add    %eax,0x0(%ebp)
    3fa9:	00 00                	add    %al,(%eax)
    3fab:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    3faf:	01 8f 00 00 00 00    	add    %ecx,0x0(%edi)
    3fb5:	00 00                	add    %al,(%eax)
    3fb7:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    3fbb:	01 91 00 00 00 00    	add    %edx,0x0(%ecx)
    3fc1:	00 00                	add    %al,(%eax)
    3fc3:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    3fc7:	01 98 00 00 00 00    	add    %ebx,0x0(%eax)
    3fcd:	00 00                	add    %al,(%eax)
    3fcf:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    3fd3:	01 9b 00 00 00 00    	add    %ebx,0x0(%ebx)
    3fd9:	00 00                	add    %al,(%eax)
    3fdb:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    3fdf:	01 9d 00 00 00 00    	add    %ebx,0x0(%ebp)
    3fe5:	00 00                	add    %al,(%eax)
    3fe7:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    3feb:	01 a1 00 00 00 00    	add    %esp,0x0(%ecx)
    3ff1:	00 00                	add    %al,(%eax)
    3ff3:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    3ff7:	01 aa 00 00 00 00    	add    %ebp,0x0(%edx)
    3ffd:	00 00                	add    %al,(%eax)
    3fff:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    4003:	01 ae 00 00 00 00    	add    %ebp,0x0(%esi)
    4009:	00 00                	add    %al,(%eax)
    400b:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    400f:	01 bf 00 00 00 00    	add    %edi,0x0(%edi)
    4015:	00 00                	add    %al,(%eax)
    4017:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
    401b:	01 c5                	add    %eax,%ebp
    401d:	00 00                	add    %al,(%eax)
    401f:	00 00                	add    %al,(%eax)
    4021:	00 00                	add    %al,(%eax)
    4023:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
    4027:	01 c8                	add    %ecx,%eax
    4029:	00 00                	add    %al,(%eax)
    402b:	00 00                	add    %al,(%eax)
    402d:	00 00                	add    %al,(%eax)
    402f:	00 44 00 38          	add    %al,0x38(%eax,%eax,1)
    4033:	01 cf                	add    %ecx,%edi
    4035:	00 00                	add    %al,(%eax)
    4037:	00 00                	add    %al,(%eax)
    4039:	00 00                	add    %al,(%eax)
    403b:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    403f:	01 d2                	add    %edx,%edx
    4041:	00 00                	add    %al,(%eax)
    4043:	00 00                	add    %al,(%eax)
    4045:	00 00                	add    %al,(%eax)
    4047:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    404b:	01 ef                	add    %ebp,%edi
    404d:	00 00                	add    %al,(%eax)
    404f:	00 b1 13 00 00 40    	add    %dh,0x40000013(%ecx)
    4055:	00 00                	add    %al,(%eax)
    4057:	00 00                	add    %al,(%eax)
    4059:	00 00                	add    %al,(%eax)
    405b:	00 03                	add    %al,(%ebx)
    405d:	14 00                	adc    $0x0,%al
    405f:	00 40 00             	add    %al,0x0(%eax)
    4062:	00 00                	add    %al,(%eax)
    4064:	01 00                	add    %eax,(%eax)
    4066:	00 00                	add    %al,(%eax)
    4068:	df 14 00             	fist   (%eax,%eax,1)
    406b:	00 40 00             	add    %al,0x0(%eax)
    406e:	00 00                	add    %al,(%eax)
    4070:	07                   	pop    %es
    4071:	00 00                	add    %al,(%eax)
    4073:	00 ed                	add    %ch,%ch
    4075:	14 00                	adc    $0x0,%al
    4077:	00 24 00             	add    %ah,(%eax,%eax,1)
    407a:	00 00                	add    %al,(%eax)
    407c:	86 14 28             	xchg   %dl,(%eax,%ebp,1)
    407f:	00 f7                	add    %dh,%bh
    4081:	13 00                	adc    (%eax),%eax
    4083:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    4089:	00 00                	add    %al,(%eax)
    408b:	00 24 14             	add    %ah,(%esp,%edx,1)
    408e:	00 00                	add    %al,(%eax)
    4090:	a0 00 00 00 0c       	mov    0xc000000,%al
    4095:	00 00                	add    %al,(%eax)
    4097:	00 03                	add    %al,(%ebx)
    4099:	15 00 00 a0 00       	adc    $0xa00000,%eax
    409e:	00 00                	add    %al,(%eax)
    40a0:	10 00                	adc    %al,(%eax)
    40a2:	00 00                	add    %al,(%eax)
    40a4:	0e                   	push   %cs
    40a5:	15 00 00 a0 00       	adc    $0xa00000,%eax
    40aa:	00 00                	add    %al,(%eax)
    40ac:	14 00                	adc    $0x0,%al
    40ae:	00 00                	add    %al,(%eax)
    40b0:	19 15 00 00 a0 00    	sbb    %edx,0xa00000
    40b6:	00 00                	add    %al,(%eax)
    40b8:	18 00                	sbb    %al,(%eax)
    40ba:	00 00                	add    %al,(%eax)
    40bc:	24 15                	and    $0x15,%al
    40be:	00 00                	add    %al,(%eax)
    40c0:	a0 00 00 00 1c       	mov    0x1c000000,%al
    40c5:	00 00                	add    %al,(%eax)
    40c7:	00 00                	add    %al,(%eax)
    40c9:	00 00                	add    %al,(%eax)
    40cb:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    40cf:	01 00                	add    %eax,(%eax)
    40d1:	00 00                	add    %al,(%eax)
    40d3:	00 00                	add    %al,(%eax)
    40d5:	00 00                	add    %al,(%eax)
    40d7:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    40db:	01 07                	add    %eax,(%edi)
    40dd:	00 00                	add    %al,(%eax)
    40df:	00 00                	add    %al,(%eax)
    40e1:	00 00                	add    %al,(%eax)
    40e3:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
    40e7:	01 13                	add    %edx,(%ebx)
    40e9:	00 00                	add    %al,(%eax)
    40eb:	00 00                	add    %al,(%eax)
    40ed:	00 00                	add    %al,(%eax)
    40ef:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    40f3:	01 17                	add    %edx,(%edi)
    40f5:	00 00                	add    %al,(%eax)
    40f7:	00 00                	add    %al,(%eax)
    40f9:	00 00                	add    %al,(%eax)
    40fb:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
    40ff:	01 1d 00 00 00 00    	add    %ebx,0x0
    4105:	00 00                	add    %al,(%eax)
    4107:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
    410b:	01 1f                	add    %ebx,(%edi)
    410d:	00 00                	add    %al,(%eax)
    410f:	00 00                	add    %al,(%eax)
    4111:	00 00                	add    %al,(%eax)
    4113:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    4117:	01 25 00 00 00 00    	add    %esp,0x0
    411d:	00 00                	add    %al,(%eax)
    411f:	00 44 00 46          	add    %al,0x46(%eax,%eax,1)
    4123:	01 3a                	add    %edi,(%edx)
    4125:	00 00                	add    %al,(%eax)
    4127:	00 00                	add    %al,(%eax)
    4129:	00 00                	add    %al,(%eax)
    412b:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    412f:	01 3f                	add    %edi,(%edi)
    4131:	00 00                	add    %al,(%eax)
    4133:	00 00                	add    %al,(%eax)
    4135:	00 00                	add    %al,(%eax)
    4137:	00 44 00 46          	add    %al,0x46(%eax,%eax,1)
    413b:	01 44 00 00          	add    %eax,0x0(%eax,%eax,1)
    413f:	00 b1 13 00 00 40    	add    %dh,0x40000013(%ecx)
    4145:	00 00                	add    %al,(%eax)
    4147:	00 01                	add    %al,(%ecx)
    4149:	00 00                	add    %al,(%eax)
    414b:	00 03                	add    %al,(%ebx)
    414d:	14 00                	adc    $0x0,%al
    414f:	00 40 00             	add    %al,0x0(%eax)
    4152:	00 00                	add    %al,(%eax)
    4154:	00 00                	add    %al,(%eax)
    4156:	00 00                	add    %al,(%eax)
    4158:	2f                   	das    
    4159:	15 00 00 40 00       	adc    $0x400000,%eax
    415e:	00 00                	add    %al,(%eax)
    4160:	03 00                	add    (%eax),%eax
    4162:	00 00                	add    %al,(%eax)
    4164:	3a 15 00 00 40 00    	cmp    0x400000,%dl
    416a:	00 00                	add    %al,(%eax)
    416c:	06                   	push   %es
    416d:	00 00                	add    %al,(%eax)
    416f:	00 45 15             	add    %al,0x15(%ebp)
    4172:	00 00                	add    %al,(%eax)
    4174:	40                   	inc    %eax
    4175:	00 00                	add    %al,(%eax)
    4177:	00 07                	add    %al,(%edi)
    4179:	00 00                	add    %al,(%eax)
    417b:	00 50 15             	add    %dl,0x15(%eax)
    417e:	00 00                	add    %al,(%eax)
    4180:	24 00                	and    $0x0,%al
    4182:	00 00                	add    %al,(%eax)
    4184:	d0 14 28             	rclb   (%eax,%ebp,1)
    4187:	00 f7                	add    %dh,%bh
    4189:	13 00                	adc    (%eax),%eax
    418b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    4191:	00 00                	add    %al,(%eax)
    4193:	00 24 14             	add    %ah,(%esp,%edx,1)
    4196:	00 00                	add    %al,(%eax)
    4198:	a0 00 00 00 0c       	mov    0xc000000,%al
    419d:	00 00                	add    %al,(%eax)
    419f:	00 7d 14             	add    %bh,0x14(%ebp)
    41a2:	00 00                	add    %al,(%eax)
    41a4:	a0 00 00 00 10       	mov    0x10000000,%al
    41a9:	00 00                	add    %al,(%eax)
    41ab:	00 88 14 00 00 a0    	add    %cl,-0x5fffffec(%eax)
    41b1:	00 00                	add    %al,(%eax)
    41b3:	00 14 00             	add    %dl,(%eax,%eax,1)
    41b6:	00 00                	add    %al,(%eax)
    41b8:	00 00                	add    %al,(%eax)
    41ba:	00 00                	add    %al,(%eax)
    41bc:	44                   	inc    %esp
    41bd:	00 49 01             	add    %cl,0x1(%ecx)
	...
    41c8:	44                   	inc    %esp
    41c9:	00 49 01             	add    %cl,0x1(%ecx)
    41cc:	0c 00                	or     $0x0,%al
    41ce:	00 00                	add    %al,(%eax)
    41d0:	00 00                	add    %al,(%eax)
    41d2:	00 00                	add    %al,(%eax)
    41d4:	44                   	inc    %esp
    41d5:	00 4e 01             	add    %cl,0x1(%esi)
    41d8:	0f 00 00             	sldt   (%eax)
    41db:	00 00                	add    %al,(%eax)
    41dd:	00 00                	add    %al,(%eax)
    41df:	00 44 00 4a          	add    %al,0x4a(%eax,%eax,1)
    41e3:	01 13                	add    %edx,(%ebx)
    41e5:	00 00                	add    %al,(%eax)
    41e7:	00 00                	add    %al,(%eax)
    41e9:	00 00                	add    %al,(%eax)
    41eb:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    41ef:	01 16                	add    %edx,(%esi)
    41f1:	00 00                	add    %al,(%eax)
    41f3:	00 00                	add    %al,(%eax)
    41f5:	00 00                	add    %al,(%eax)
    41f7:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
    41fb:	01 19                	add    %ebx,(%ecx)
    41fd:	00 00                	add    %al,(%eax)
    41ff:	00 00                	add    %al,(%eax)
    4201:	00 00                	add    %al,(%eax)
    4203:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
    4207:	01 1c 00             	add    %ebx,(%eax,%eax,1)
    420a:	00 00                	add    %al,(%eax)
    420c:	00 00                	add    %al,(%eax)
    420e:	00 00                	add    %al,(%eax)
    4210:	44                   	inc    %esp
    4211:	00 4e 01             	add    %cl,0x1(%esi)
    4214:	1f                   	pop    %ds
    4215:	00 00                	add    %al,(%eax)
    4217:	00 00                	add    %al,(%eax)
    4219:	00 00                	add    %al,(%eax)
    421b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    421f:	01 21                	add    %esp,(%ecx)
    4221:	00 00                	add    %al,(%eax)
    4223:	00 00                	add    %al,(%eax)
    4225:	00 00                	add    %al,(%eax)
    4227:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    422b:	01 37                	add    %esi,(%edi)
    422d:	00 00                	add    %al,(%eax)
    422f:	00 00                	add    %al,(%eax)
    4231:	00 00                	add    %al,(%eax)
    4233:	00 44 00 55          	add    %al,0x55(%eax,%eax,1)
    4237:	01 50 00             	add    %edx,0x0(%eax)
    423a:	00 00                	add    %al,(%eax)
    423c:	63 15 00 00 40 00    	arpl   %dx,0x400000
    4242:	00 00                	add    %al,(%eax)
    4244:	00 00                	add    %al,(%eax)
    4246:	00 00                	add    %al,(%eax)
    4248:	72 15                	jb     425f <bootmain-0x27bda1>
    424a:	00 00                	add    %al,(%eax)
    424c:	40                   	inc    %eax
    424d:	00 00                	add    %al,(%eax)
    424f:	00 02                	add    %al,(%edx)
    4251:	00 00                	add    %al,(%eax)
    4253:	00 03                	add    %al,(%ebx)
    4255:	14 00                	adc    $0x0,%al
    4257:	00 40 00             	add    %al,0x0(%eax)
    425a:	00 00                	add    %al,(%eax)
    425c:	03 00                	add    (%eax),%eax
    425e:	00 00                	add    %al,(%eax)
    4260:	81 15 00 00 40 00 00 	adcl   $0x60000,0x400000
    4267:	00 06 00 
    426a:	00 00                	add    %al,(%eax)
    426c:	8c 15 00 00 40 00    	mov    %ss,0x400000
    4272:	00 00                	add    %al,(%eax)
    4274:	07                   	pop    %es
    4275:	00 00                	add    %al,(%eax)
    4277:	00 00                	add    %al,(%eax)
    4279:	00 00                	add    %al,(%eax)
    427b:	00 c0                	add    %al,%al
	...
    4285:	00 00                	add    %al,(%eax)
    4287:	00 e0                	add    %ah,%al
    4289:	00 00                	add    %al,(%eax)
    428b:	00 58 00             	add    %bl,0x0(%eax)
    428e:	00 00                	add    %al,(%eax)
    4290:	00 00                	add    %al,(%eax)
    4292:	00 00                	add    %al,(%eax)
    4294:	64 00 00             	add    %al,%fs:(%eax)
    4297:	00 28                	add    %ch,(%eax)
    4299:	15                   	.byte 0x15
    429a:	28 00                	sub    %al,(%eax)

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
     541:	29 3d 73 33 32 62    	sub    %edi,0x62323373
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
     5df:	3b 3b                	cmp    (%ebx),%edi
     5e1:	00 53 48             	add    %dl,0x48(%ebx)
     5e4:	45                   	inc    %ebp
     5e5:	45                   	inc    %ebp
     5e6:	54                   	push   %esp
     5e7:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     5eb:	2c 39                	sub    $0x39,%al
     5ed:	29 3d 28 34 2c 37    	sub    %edi,0x372c3428
     5f3:	29 00                	sub    %eax,(%eax)
     5f5:	53                   	push   %ebx
     5f6:	48                   	dec    %eax
     5f7:	54                   	push   %esp
     5f8:	43                   	inc    %ebx
     5f9:	54                   	push   %esp
     5fa:	4c                   	dec    %esp
     5fb:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     5ff:	2c 31                	sub    $0x31,%al
     601:	30 29                	xor    %ch,(%ecx)
     603:	3d 73 39 32 33       	cmp    $0x33323973,%eax
     608:	32 76 72             	xor    0x72(%esi),%dh
     60b:	61                   	popa   
     60c:	6d                   	insl   (%dx),%es:(%edi)
     60d:	3a 28                	cmp    (%eax),%ch
     60f:	34 2c                	xor    $0x2c,%al
     611:	38 29                	cmp    %ch,(%ecx)
     613:	2c 30                	sub    $0x30,%al
     615:	2c 33                	sub    $0x33,%al
     617:	32 3b                	xor    (%ebx),%bh
     619:	78 73                	js     68e <bootmain-0x27f972>
     61b:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     622:	31 29                	xor    %ebp,(%ecx)
     624:	2c 33                	sub    $0x33,%al
     626:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     629:	32 3b                	xor    (%ebx),%bh
     62b:	79 73                	jns    6a0 <bootmain-0x27f960>
     62d:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     634:	31 29                	xor    %ebp,(%ecx)
     636:	2c 36                	sub    $0x36,%al
     638:	34 2c                	xor    $0x2c,%al
     63a:	33 32                	xor    (%edx),%esi
     63c:	3b 74 6f 70          	cmp    0x70(%edi,%ebp,2),%esi
     640:	3a 28                	cmp    (%eax),%ch
     642:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     645:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     648:	36                   	ss
     649:	2c 33                	sub    $0x33,%al
     64b:	32 3b                	xor    (%ebx),%bh
     64d:	73 68                	jae    6b7 <bootmain-0x27f949>
     64f:	65                   	gs
     650:	65                   	gs
     651:	74 3a                	je     68d <bootmain-0x27f973>
     653:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
     656:	31 31                	xor    %esi,(%ecx)
     658:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     65e:	2c 35                	sub    $0x35,%al
     660:	29 3b                	sub    %edi,(%ebx)
     662:	30 3b                	xor    %bh,(%ebx)
     664:	32 35 35 3b 28 34    	xor    0x34283b35,%dh
     66a:	2c 39                	sub    $0x39,%al
     66c:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     66f:	32 38                	xor    (%eax),%bh
     671:	2c 36                	sub    $0x36,%al
     673:	35 35 33 36 3b       	xor    $0x3b363335,%eax
     678:	73 68                	jae    6e2 <bootmain-0x27f91e>
     67a:	65                   	gs
     67b:	65                   	gs
     67c:	74 73                	je     6f1 <bootmain-0x27f90f>
     67e:	3a 28                	cmp    (%eax),%ch
     680:	34 2c                	xor    $0x2c,%al
     682:	31 32                	xor    %esi,(%edx)
     684:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     68a:	2c 35                	sub    $0x35,%al
     68c:	29 3b                	sub    %edi,(%ebx)
     68e:	30 3b                	xor    %bh,(%ebx)
     690:	32 35 35 3b 28 34    	xor    0x34283b35,%dh
     696:	2c 31                	sub    $0x31,%al
     698:	33 29                	xor    (%ecx),%ebp
     69a:	3d 2a 28 34 2c       	cmp    $0x2c34282a,%eax
     69f:	39 29                	cmp    %ebp,(%ecx)
     6a1:	2c 36                	sub    $0x36,%al
     6a3:	35 36 36 34 2c       	xor    $0x2c343636,%eax
     6a8:	38 31                	cmp    %dh,(%ecx)
     6aa:	39 32                	cmp    %esi,(%edx)
     6ac:	3b 3b                	cmp    (%ebx),%edi
     6ae:	00 53 48             	add    %dl,0x48(%ebx)
     6b1:	54                   	push   %esp
     6b2:	43                   	inc    %ebx
     6b3:	54                   	push   %esp
     6b4:	4c                   	dec    %esp
     6b5:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     6b9:	2c 31                	sub    $0x31,%al
     6bb:	34 29                	xor    $0x29,%al
     6bd:	3d 28 34 2c 31       	cmp    $0x312c3428,%eax
     6c2:	30 29                	xor    %ch,(%ecx)
     6c4:	00 62 6f             	add    %ah,0x6f(%edx)
     6c7:	6f                   	outsl  %ds:(%esi),(%dx)
     6c8:	74 5f                	je     729 <bootmain-0x27f8d7>
     6ca:	69 6e 66 6f 3a 54 28 	imul   $0x28543a6f,0x66(%esi),%ebp
     6d1:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
     6d4:	29 3d 73 31 32 63    	sub    %edi,0x63323173
     6da:	79 6c                	jns    748 <bootmain-0x27f8b8>
     6dc:	69 6e 64 65 72 3a 28 	imul   $0x283a7265,0x64(%esi),%ebp
     6e3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     6e6:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     6e9:	2c 38                	sub    $0x38,%al
     6eb:	3b 6c 65 64          	cmp    0x64(%ebp,%eiz,2),%ebp
     6ef:	3a 28                	cmp    (%eax),%ch
     6f1:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     6f4:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
     6f7:	2c 38                	sub    $0x38,%al
     6f9:	3b 63 6f             	cmp    0x6f(%ebx),%esp
     6fc:	6c                   	insb   (%dx),%es:(%edi)
     6fd:	6f                   	outsl  %ds:(%esi),(%dx)
     6fe:	72 5f                	jb     75f <bootmain-0x27f8a1>
     700:	6d                   	insl   (%dx),%es:(%edi)
     701:	6f                   	outsl  %ds:(%esi),(%dx)
     702:	64 65 3a 28          	fs cmp %fs:%gs:(%eax),%ch
     706:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     709:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     70c:	36                   	ss
     70d:	2c 38                	sub    $0x38,%al
     70f:	3b 72 65             	cmp    0x65(%edx),%esi
     712:	73 65                	jae    779 <bootmain-0x27f887>
     714:	72 76                	jb     78c <bootmain-0x27f874>
     716:	65 64 3a 28          	gs cmp %fs:%gs:(%eax),%ch
     71a:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     71d:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
     720:	34 2c                	xor    $0x2c,%al
     722:	38 3b                	cmp    %bh,(%ebx)
     724:	78 73                	js     799 <bootmain-0x27f867>
     726:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     72d:	38 29                	cmp    %ch,(%ecx)
     72f:	2c 33                	sub    $0x33,%al
     731:	32 2c 31             	xor    (%ecx,%esi,1),%ch
     734:	36 3b 79 73          	cmp    %ss:0x73(%ecx),%edi
     738:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     73f:	38 29                	cmp    %ch,(%ecx)
     741:	2c 34                	sub    $0x34,%al
     743:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     746:	36 3b 76 72          	cmp    %ss:0x72(%esi),%esi
     74a:	61                   	popa   
     74b:	6d                   	insl   (%dx),%es:(%edi)
     74c:	3a 28                	cmp    (%eax),%ch
     74e:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     751:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
     757:	32 29                	xor    (%ecx),%ch
     759:	2c 36                	sub    $0x36,%al
     75b:	34 2c                	xor    $0x2c,%al
     75d:	33 32                	xor    (%edx),%esi
     75f:	3b 3b                	cmp    (%ebx),%edi
     761:	00 47 44             	add    %al,0x44(%edi)
     764:	54                   	push   %esp
     765:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     769:	2c 33                	sub    $0x33,%al
     76b:	29 3d 73 38 6c 69    	sub    %edi,0x696c3873
     771:	6d                   	insl   (%dx),%es:(%edi)
     772:	69 74 5f 6c 6f 77 3a 	imul   $0x283a776f,0x6c(%edi,%ebx,2),%esi
     779:	28 
     77a:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     77d:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     780:	2c 31                	sub    $0x31,%al
     782:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     786:	73 65                	jae    7ed <bootmain-0x27f813>
     788:	5f                   	pop    %edi
     789:	6c                   	insb   (%dx),%es:(%edi)
     78a:	6f                   	outsl  %ds:(%esi),(%dx)
     78b:	77 3a                	ja     7c7 <bootmain-0x27f839>
     78d:	28 30                	sub    %dh,(%eax)
     78f:	2c 38                	sub    $0x38,%al
     791:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     794:	36                   	ss
     795:	2c 31                	sub    $0x31,%al
     797:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     79b:	73 65                	jae    802 <bootmain-0x27f7fe>
     79d:	5f                   	pop    %edi
     79e:	6d                   	insl   (%dx),%es:(%edi)
     79f:	69 64 3a 28 30 2c 32 	imul   $0x29322c30,0x28(%edx,%edi,1),%esp
     7a6:	29 
     7a7:	2c 33                	sub    $0x33,%al
     7a9:	32 2c 38             	xor    (%eax,%edi,1),%ch
     7ac:	3b 61 63             	cmp    0x63(%ecx),%esp
     7af:	63 65 73             	arpl   %sp,0x73(%ebp)
     7b2:	73 5f                	jae    813 <bootmain-0x27f7ed>
     7b4:	72 69                	jb     81f <bootmain-0x27f7e1>
     7b6:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     7bc:	2c 32                	sub    $0x32,%al
     7be:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     7c1:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     7c4:	3b 6c 69 6d          	cmp    0x6d(%ecx,%ebp,2),%ebp
     7c8:	69 74 5f 68 69 67 68 	imul   $0x3a686769,0x68(%edi,%ebx,2),%esi
     7cf:	3a 
     7d0:	28 30                	sub    %dh,(%eax)
     7d2:	2c 32                	sub    $0x32,%al
     7d4:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     7d7:	38 2c 38             	cmp    %ch,(%eax,%edi,1)
     7da:	3b 62 61             	cmp    0x61(%edx),%esp
     7dd:	73 65                	jae    844 <bootmain-0x27f7bc>
     7df:	5f                   	pop    %edi
     7e0:	68 69 67 68 3a       	push   $0x3a686769
     7e5:	28 30                	sub    %dh,(%eax)
     7e7:	2c 32                	sub    $0x32,%al
     7e9:	29 2c 35 36 2c 38 3b 	sub    %ebp,0x3b382c36(,%esi,1)
     7f0:	3b 00                	cmp    (%eax),%eax
     7f2:	49                   	dec    %ecx
     7f3:	44                   	inc    %esp
     7f4:	54                   	push   %esp
     7f5:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     7f9:	2c 34                	sub    $0x34,%al
     7fb:	29 3d 73 38 6f 66    	sub    %edi,0x666f3873
     801:	66                   	data16
     802:	73 65                	jae    869 <bootmain-0x27f797>
     804:	74 5f                	je     865 <bootmain-0x27f79b>
     806:	6c                   	insb   (%dx),%es:(%edi)
     807:	6f                   	outsl  %ds:(%esi),(%dx)
     808:	77 3a                	ja     844 <bootmain-0x27f7bc>
     80a:	28 30                	sub    %dh,(%eax)
     80c:	2c 38                	sub    $0x38,%al
     80e:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     811:	2c 31                	sub    $0x31,%al
     813:	36 3b 73 65          	cmp    %ss:0x65(%ebx),%esi
     817:	6c                   	insb   (%dx),%es:(%edi)
     818:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     81d:	3a 28                	cmp    (%eax),%ch
     81f:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     822:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     825:	36                   	ss
     826:	2c 31                	sub    $0x31,%al
     828:	36 3b 64 77 5f       	cmp    %ss:0x5f(%edi,%esi,2),%esp
     82d:	63 6f 75             	arpl   %bp,0x75(%edi)
     830:	6e                   	outsb  %ds:(%esi),(%dx)
     831:	74 3a                	je     86d <bootmain-0x27f793>
     833:	28 30                	sub    %dh,(%eax)
     835:	2c 32                	sub    $0x32,%al
     837:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     83a:	32 2c 38             	xor    (%eax,%edi,1),%ch
     83d:	3b 61 63             	cmp    0x63(%ecx),%esp
     840:	63 65 73             	arpl   %sp,0x73(%ebp)
     843:	73 5f                	jae    8a4 <bootmain-0x27f75c>
     845:	72 69                	jb     8b0 <bootmain-0x27f750>
     847:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     84d:	2c 32                	sub    $0x32,%al
     84f:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     852:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     855:	3b 6f 66             	cmp    0x66(%edi),%ebp
     858:	66                   	data16
     859:	73 65                	jae    8c0 <bootmain-0x27f740>
     85b:	74 5f                	je     8bc <bootmain-0x27f744>
     85d:	68 69 67 68 3a       	push   $0x3a686769
     862:	28 30                	sub    %dh,(%eax)
     864:	2c 38                	sub    $0x38,%al
     866:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     869:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     86c:	36 3b 3b             	cmp    %ss:(%ebx),%edi
     86f:	00 46 49             	add    %al,0x49(%esi)
     872:	46                   	inc    %esi
     873:	4f                   	dec    %edi
     874:	38 3a                	cmp    %bh,(%edx)
     876:	54                   	push   %esp
     877:	28 31                	sub    %dh,(%ecx)
     879:	2c 35                	sub    $0x35,%al
     87b:	29 3d 73 32 34 62    	sub    %edi,0x62343273
     881:	75 66                	jne    8e9 <bootmain-0x27f717>
     883:	3a 28                	cmp    (%eax),%ch
     885:	34 2c                	xor    $0x2c,%al
     887:	38 29                	cmp    %ch,(%ecx)
     889:	2c 30                	sub    $0x30,%al
     88b:	2c 33                	sub    $0x33,%al
     88d:	32 3b                	xor    (%ebx),%bh
     88f:	6e                   	outsb  %ds:(%esi),(%dx)
     890:	77 3a                	ja     8cc <bootmain-0x27f734>
     892:	28 30                	sub    %dh,(%eax)
     894:	2c 31                	sub    $0x31,%al
     896:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     899:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     89c:	32 3b                	xor    (%ebx),%bh
     89e:	6e                   	outsb  %ds:(%esi),(%dx)
     89f:	72 3a                	jb     8db <bootmain-0x27f725>
     8a1:	28 30                	sub    %dh,(%eax)
     8a3:	2c 31                	sub    $0x31,%al
     8a5:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     8a8:	34 2c                	xor    $0x2c,%al
     8aa:	33 32                	xor    (%edx),%esi
     8ac:	3b 73 69             	cmp    0x69(%ebx),%esi
     8af:	7a 65                	jp     916 <bootmain-0x27f6ea>
     8b1:	3a 28                	cmp    (%eax),%ch
     8b3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8b6:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     8b9:	36                   	ss
     8ba:	2c 33                	sub    $0x33,%al
     8bc:	32 3b                	xor    (%ebx),%bh
     8be:	66                   	data16
     8bf:	72 65                	jb     926 <bootmain-0x27f6da>
     8c1:	65 3a 28             	cmp    %gs:(%eax),%ch
     8c4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8c7:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     8ca:	32 38                	xor    (%eax),%bh
     8cc:	2c 33                	sub    $0x33,%al
     8ce:	32 3b                	xor    (%ebx),%bh
     8d0:	66                   	data16
     8d1:	6c                   	insb   (%dx),%es:(%edi)
     8d2:	61                   	popa   
     8d3:	67 73 3a             	addr16 jae 910 <bootmain-0x27f6f0>
     8d6:	28 30                	sub    %dh,(%eax)
     8d8:	2c 31                	sub    $0x31,%al
     8da:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     8dd:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
     8e1:	32 3b                	xor    (%ebx),%bh
     8e3:	3b 00                	cmp    (%eax),%eax
     8e5:	4d                   	dec    %ebp
     8e6:	4f                   	dec    %edi
     8e7:	55                   	push   %ebp
     8e8:	53                   	push   %ebx
     8e9:	45                   	inc    %ebp
     8ea:	5f                   	pop    %edi
     8eb:	44                   	inc    %esp
     8ec:	45                   	inc    %ebp
     8ed:	43                   	inc    %ebx
     8ee:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     8f2:	2c 36                	sub    $0x36,%al
     8f4:	29 3d 73 31 36 62    	sub    %edi,0x62363173
     8fa:	75 66                	jne    962 <bootmain-0x27f69e>
     8fc:	3a 28                	cmp    (%eax),%ch
     8fe:	31 2c 37             	xor    %ebp,(%edi,%esi,1)
     901:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     907:	2c 35                	sub    $0x35,%al
     909:	29 3b                	sub    %edi,(%ebx)
     90b:	30 3b                	xor    %bh,(%ebx)
     90d:	32 3b                	xor    (%ebx),%bh
     90f:	28 30                	sub    %dh,(%eax)
     911:	2c 31                	sub    $0x31,%al
     913:	31 29                	xor    %ebp,(%ecx)
     915:	2c 30                	sub    $0x30,%al
     917:	2c 32                	sub    $0x32,%al
     919:	34 3b                	xor    $0x3b,%al
     91b:	70 68                	jo     985 <bootmain-0x27f67b>
     91d:	61                   	popa   
     91e:	73 65                	jae    985 <bootmain-0x27f67b>
     920:	3a 28                	cmp    (%eax),%ch
     922:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     925:	31 29                	xor    %ebp,(%ecx)
     927:	2c 32                	sub    $0x32,%al
     929:	34 2c                	xor    $0x2c,%al
     92b:	38 3b                	cmp    %bh,(%ebx)
     92d:	78 3a                	js     969 <bootmain-0x27f697>
     92f:	28 30                	sub    %dh,(%eax)
     931:	2c 31                	sub    $0x31,%al
     933:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     936:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     939:	32 3b                	xor    (%ebx),%bh
     93b:	79 3a                	jns    977 <bootmain-0x27f689>
     93d:	28 30                	sub    %dh,(%eax)
     93f:	2c 31                	sub    $0x31,%al
     941:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     944:	34 2c                	xor    $0x2c,%al
     946:	33 32                	xor    (%edx),%esi
     948:	3b 62 75             	cmp    0x75(%edx),%esp
     94b:	74 74                	je     9c1 <bootmain-0x27f63f>
     94d:	6f                   	outsl  %ds:(%esi),(%dx)
     94e:	6e                   	outsb  %ds:(%esi),(%dx)
     94f:	3a 28                	cmp    (%eax),%ch
     951:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     954:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     957:	36                   	ss
     958:	2c 33                	sub    $0x33,%al
     95a:	32 3b                	xor    (%ebx),%bh
     95c:	3b 00                	cmp    (%eax),%eax
     95e:	62 6f 6f             	bound  %ebp,0x6f(%edi)
     961:	74 6d                	je     9d0 <bootmain-0x27f630>
     963:	61                   	popa   
     964:	69 6e 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%esi),%ebp
     96b:	31 38                	xor    %edi,(%eax)
     96d:	29 00                	sub    %eax,(%eax)
     96f:	6d                   	insl   (%dx),%es:(%edi)
     970:	6f                   	outsl  %ds:(%esi),(%dx)
     971:	75 73                	jne    9e6 <bootmain-0x27f61a>
     973:	65                   	gs
     974:	70 69                	jo     9df <bootmain-0x27f621>
     976:	63 3a                	arpl   %di,(%edx)
     978:	28 30                	sub    %dh,(%eax)
     97a:	2c 31                	sub    $0x31,%al
     97c:	39 29                	cmp    %ebp,(%ecx)
     97e:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     983:	2c 35                	sub    $0x35,%al
     985:	29 3b                	sub    %edi,(%ebx)
     987:	30 3b                	xor    %bh,(%ebx)
     989:	32 35 35 3b 28 30    	xor    0x30283b35,%dh
     98f:	2c 32                	sub    $0x32,%al
     991:	29 00                	sub    %eax,(%eax)
     993:	73 3a                	jae    9cf <bootmain-0x27f631>
     995:	28 30                	sub    %dh,(%eax)
     997:	2c 32                	sub    $0x32,%al
     999:	30 29                	xor    %ch,(%ecx)
     99b:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9a0:	2c 35                	sub    $0x35,%al
     9a2:	29 3b                	sub    %edi,(%ebx)
     9a4:	30 3b                	xor    %bh,(%ebx)
     9a6:	33 39                	xor    (%ecx),%edi
     9a8:	3b 28                	cmp    (%eax),%ebp
     9aa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9ad:	31 29                	xor    %ebp,(%ecx)
     9af:	00 6b 65             	add    %ch,0x65(%ebx)
     9b2:	79 62                	jns    a16 <bootmain-0x27f5ea>
     9b4:	75 66                	jne    a1c <bootmain-0x27f5e4>
     9b6:	3a 28                	cmp    (%eax),%ch
     9b8:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     9bb:	31 29                	xor    %ebp,(%ecx)
     9bd:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9c2:	2c 35                	sub    $0x35,%al
     9c4:	29 3b                	sub    %edi,(%ebx)
     9c6:	30 3b                	xor    %bh,(%ebx)
     9c8:	33 31                	xor    (%ecx),%esi
     9ca:	3b 28                	cmp    (%eax),%ebp
     9cc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9cf:	31 29                	xor    %ebp,(%ecx)
     9d1:	00 6d 6f             	add    %ch,0x6f(%ebp)
     9d4:	75 73                	jne    a49 <bootmain-0x27f5b7>
     9d6:	65 62 75 66          	bound  %esi,%gs:0x66(%ebp)
     9da:	3a 28                	cmp    (%eax),%ch
     9dc:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     9df:	32 29                	xor    (%ecx),%ch
     9e1:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     9e6:	2c 35                	sub    $0x35,%al
     9e8:	29 3b                	sub    %edi,(%ebx)
     9ea:	30 3b                	xor    %bh,(%ebx)
     9ec:	31 32                	xor    %esi,(%edx)
     9ee:	37                   	aaa    
     9ef:	3b 28                	cmp    (%eax),%ebp
     9f1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9f4:	31 29                	xor    %ebp,(%ecx)
     9f6:	00 6d 64             	add    %ch,0x64(%ebp)
     9f9:	65 63 3a             	arpl   %di,%gs:(%edx)
     9fc:	28 31                	sub    %dh,(%ecx)
     9fe:	2c 36                	sub    $0x36,%al
     a00:	29 00                	sub    %eax,(%eax)
     a02:	6d                   	insl   (%dx),%es:(%edi)
     a03:	65                   	gs
     a04:	6d                   	insl   (%dx),%es:(%edi)
     a05:	74 6f                	je     a76 <bootmain-0x27f58a>
     a07:	74 61                	je     a6a <bootmain-0x27f596>
     a09:	6c                   	insb   (%dx),%es:(%edi)
     a0a:	3a 72 28             	cmp    0x28(%edx),%dh
     a0d:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     a10:	29 00                	sub    %eax,(%eax)
     a12:	77 69                	ja     a7d <bootmain-0x27f583>
     a14:	6e                   	outsb  %ds:(%esi),(%dx)
     a15:	3a 72 28             	cmp    0x28(%edx),%dh
     a18:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     a1b:	29 00                	sub    %eax,(%eax)
     a1d:	73 68                	jae    a87 <bootmain-0x27f579>
     a1f:	74 63                	je     a84 <bootmain-0x27f57c>
     a21:	74 6c                	je     a8f <bootmain-0x27f571>
     a23:	3a 72 28             	cmp    0x28(%edx),%dh
     a26:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a29:	33 29                	xor    (%ecx),%ebp
     a2b:	3d 2a 28 34 2c       	cmp    $0x2c34282a,%eax
     a30:	31 34 29             	xor    %esi,(%ecx,%ebp,1)
     a33:	00 41 53             	add    %al,0x53(%ecx)
     a36:	43                   	inc    %ebx
     a37:	49                   	dec    %ecx
     a38:	49                   	dec    %ecx
     a39:	5f                   	pop    %edi
     a3a:	54                   	push   %esp
     a3b:	61                   	popa   
     a3c:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
     a40:	47                   	inc    %edi
     a41:	28 30                	sub    %dh,(%eax)
     a43:	2c 32                	sub    $0x32,%al
     a45:	34 29                	xor    $0x29,%al
     a47:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     a4c:	2c 35                	sub    $0x35,%al
     a4e:	29 3b                	sub    %edi,(%ebx)
     a50:	30 3b                	xor    %bh,(%ebx)
     a52:	32 32                	xor    (%edx),%dh
     a54:	37                   	aaa    
     a55:	39 3b                	cmp    %edi,(%ebx)
     a57:	28 30                	sub    %dh,(%eax)
     a59:	2c 39                	sub    $0x39,%al
     a5b:	29 00                	sub    %eax,(%eax)
     a5d:	46                   	inc    %esi
     a5e:	6f                   	outsl  %ds:(%esi),(%dx)
     a5f:	6e                   	outsb  %ds:(%esi),(%dx)
     a60:	74 38                	je     a9a <bootmain-0x27f566>
     a62:	78 31                	js     a95 <bootmain-0x27f56b>
     a64:	36 3a 47 28          	cmp    %ss:0x28(%edi),%al
     a68:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a6b:	35 29 3d 61 72       	xor    $0x72613d29,%eax
     a70:	28 34 2c             	sub    %dh,(%esp,%ebp,1)
     a73:	35 29 3b 30 3b       	xor    $0x3b303b29,%eax
     a78:	32 30                	xor    (%eax),%dh
     a7a:	34 37                	xor    $0x37,%al
     a7c:	3b 28                	cmp    (%eax),%ebp
     a7e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a81:	31 29                	xor    %ebp,(%ecx)
     a83:	00 73 63             	add    %dh,0x63(%ebx)
     a86:	72 65                	jb     aed <bootmain-0x27f513>
     a88:	65 6e                	outsb  %gs:(%esi),(%dx)
     a8a:	2e 63 00             	arpl   %ax,%cs:(%eax)
     a8d:	63 6c 65 61          	arpl   %bp,0x61(%ebp,%eiz,2)
     a91:	72 5f                	jb     af2 <bootmain-0x27f50e>
     a93:	73 63                	jae    af8 <bootmain-0x27f508>
     a95:	72 65                	jb     afc <bootmain-0x27f504>
     a97:	65 6e                	outsb  %gs:(%esi),(%dx)
     a99:	3a 46 28             	cmp    0x28(%esi),%al
     a9c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a9f:	38 29                	cmp    %ch,(%ecx)
     aa1:	00 63 6f             	add    %ah,0x6f(%ebx)
     aa4:	6c                   	insb   (%dx),%es:(%edi)
     aa5:	6f                   	outsl  %ds:(%esi),(%dx)
     aa6:	72 3a                	jb     ae2 <bootmain-0x27f51e>
     aa8:	70 28                	jo     ad2 <bootmain-0x27f52e>
     aaa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     aad:	29 00                	sub    %eax,(%eax)
     aaf:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
     ab5:	31 29                	xor    %ebp,(%ecx)
     ab7:	00 63 6f             	add    %ah,0x6f(%ebx)
     aba:	6c                   	insb   (%dx),%es:(%edi)
     abb:	6f                   	outsl  %ds:(%esi),(%dx)
     abc:	72 3a                	jb     af8 <bootmain-0x27f508>
     abe:	72 28                	jb     ae8 <bootmain-0x27f518>
     ac0:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     ac3:	29 00                	sub    %eax,(%eax)
     ac5:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     ac8:	6f                   	outsl  %ds:(%esi),(%dx)
     ac9:	72 5f                	jb     b2a <bootmain-0x27f4d6>
     acb:	73 63                	jae    b30 <bootmain-0x27f4d0>
     acd:	72 65                	jb     b34 <bootmain-0x27f4cc>
     acf:	65 6e                	outsb  %gs:(%esi),(%dx)
     ad1:	3a 46 28             	cmp    0x28(%esi),%al
     ad4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ad7:	38 29                	cmp    %ch,(%ecx)
     ad9:	00 73 65             	add    %dh,0x65(%ebx)
     adc:	74 5f                	je     b3d <bootmain-0x27f4c3>
     ade:	70 61                	jo     b41 <bootmain-0x27f4bf>
     ae0:	6c                   	insb   (%dx),%es:(%edi)
     ae1:	65                   	gs
     ae2:	74 74                	je     b58 <bootmain-0x27f4a8>
     ae4:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     ae8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     aeb:	38 29                	cmp    %ch,(%ecx)
     aed:	00 73 74             	add    %dh,0x74(%ebx)
     af0:	61                   	popa   
     af1:	72 74                	jb     b67 <bootmain-0x27f499>
     af3:	3a 70 28             	cmp    0x28(%eax),%dh
     af6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     af9:	29 00                	sub    %eax,(%eax)
     afb:	65 6e                	outsb  %gs:(%esi),(%dx)
     afd:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
     b01:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b04:	29 00                	sub    %eax,(%eax)
     b06:	72 67                	jb     b6f <bootmain-0x27f491>
     b08:	62 3a                	bound  %edi,(%edx)
     b0a:	70 28                	jo     b34 <bootmain-0x27f4cc>
     b0c:	34 2c                	xor    $0x2c,%al
     b0e:	38 29                	cmp    %ch,(%ecx)
     b10:	00 73 74             	add    %dh,0x74(%ebx)
     b13:	61                   	popa   
     b14:	72 74                	jb     b8a <bootmain-0x27f476>
     b16:	3a 72 28             	cmp    0x28(%edx),%dh
     b19:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b1c:	29 00                	sub    %eax,(%eax)
     b1e:	72 67                	jb     b87 <bootmain-0x27f479>
     b20:	62 3a                	bound  %edi,(%edx)
     b22:	72 28                	jb     b4c <bootmain-0x27f4b4>
     b24:	34 2c                	xor    $0x2c,%al
     b26:	38 29                	cmp    %ch,(%ecx)
     b28:	00 69 6e             	add    %ch,0x6e(%ecx)
     b2b:	69 74 5f 70 61 6c 65 	imul   $0x74656c61,0x70(%edi,%ebx,2),%esi
     b32:	74 
     b33:	74 65                	je     b9a <bootmain-0x27f466>
     b35:	3a 46 28             	cmp    0x28(%esi),%al
     b38:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b3b:	38 29                	cmp    %ch,(%ecx)
     b3d:	00 74 61 62          	add    %dh,0x62(%ecx,%eiz,2)
     b41:	6c                   	insb   (%dx),%es:(%edi)
     b42:	65                   	gs
     b43:	5f                   	pop    %edi
     b44:	72 67                	jb     bad <bootmain-0x27f453>
     b46:	62 3a                	bound  %edi,(%edx)
     b48:	28 30                	sub    %dh,(%eax)
     b4a:	2c 31                	sub    $0x31,%al
     b4c:	39 29                	cmp    %ebp,(%ecx)
     b4e:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     b53:	2c 35                	sub    $0x35,%al
     b55:	29 3b                	sub    %edi,(%ebx)
     b57:	30 3b                	xor    %bh,(%ebx)
     b59:	34 37                	xor    $0x37,%al
     b5b:	3b 28                	cmp    (%eax),%ebp
     b5d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b60:	31 29                	xor    %ebp,(%ecx)
     b62:	00 62 6f             	add    %ah,0x6f(%edx)
     b65:	78 66                	js     bcd <bootmain-0x27f433>
     b67:	69 6c 6c 38 3a 46 28 	imul   $0x3028463a,0x38(%esp,%ebp,2),%ebp
     b6e:	30 
     b6f:	2c 31                	sub    $0x31,%al
     b71:	38 29                	cmp    %ch,(%ecx)
     b73:	00 76 72             	add    %dh,0x72(%esi)
     b76:	61                   	popa   
     b77:	6d                   	insl   (%dx),%es:(%edi)
     b78:	3a 70 28             	cmp    0x28(%eax),%dh
     b7b:	34 2c                	xor    $0x2c,%al
     b7d:	38 29                	cmp    %ch,(%ecx)
     b7f:	00 78 73             	add    %bh,0x73(%eax)
     b82:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     b89:	2c 31                	sub    $0x31,%al
     b8b:	29 00                	sub    %eax,(%eax)
     b8d:	78 30                	js     bbf <bootmain-0x27f441>
     b8f:	3a 70 28             	cmp    0x28(%eax),%dh
     b92:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b95:	29 00                	sub    %eax,(%eax)
     b97:	79 30                	jns    bc9 <bootmain-0x27f437>
     b99:	3a 70 28             	cmp    0x28(%eax),%dh
     b9c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b9f:	29 00                	sub    %eax,(%eax)
     ba1:	78 31                	js     bd4 <bootmain-0x27f42c>
     ba3:	3a 70 28             	cmp    0x28(%eax),%dh
     ba6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ba9:	29 00                	sub    %eax,(%eax)
     bab:	79 31                	jns    bde <bootmain-0x27f422>
     bad:	3a 70 28             	cmp    0x28(%eax),%dh
     bb0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bb3:	29 00                	sub    %eax,(%eax)
     bb5:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     bb8:	6f                   	outsl  %ds:(%esi),(%dx)
     bb9:	72 3a                	jb     bf5 <bootmain-0x27f40b>
     bbb:	72 28                	jb     be5 <bootmain-0x27f41b>
     bbd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bc0:	31 29                	xor    %ebp,(%ecx)
     bc2:	00 79 30             	add    %bh,0x30(%ecx)
     bc5:	3a 72 28             	cmp    0x28(%edx),%dh
     bc8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bcb:	29 00                	sub    %eax,(%eax)
     bcd:	62 6f 78             	bound  %ebp,0x78(%edi)
     bd0:	66 69 6c 6c 3a 46 28 	imul   $0x2846,0x3a(%esp,%ebp,2),%bp
     bd7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bda:	38 29                	cmp    %ch,(%ecx)
     bdc:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
     be0:	77 5f                	ja     c41 <bootmain-0x27f3bf>
     be2:	77 69                	ja     c4d <bootmain-0x27f3b3>
     be4:	6e                   	outsb  %ds:(%esi),(%dx)
     be5:	5f                   	pop    %edi
     be6:	62 75 66             	bound  %esi,0x66(%ebp)
     be9:	3a 46 28             	cmp    0x28(%esi),%al
     bec:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bef:	38 29                	cmp    %ch,(%ecx)
     bf1:	00 70 3a             	add    %dh,0x3a(%eax)
     bf4:	70 28                	jo     c1e <bootmain-0x27f3e2>
     bf6:	34 2c                	xor    $0x2c,%al
     bf8:	38 29                	cmp    %ch,(%ecx)
     bfa:	00 70 3a             	add    %dh,0x3a(%eax)
     bfd:	72 28                	jb     c27 <bootmain-0x27f3d9>
     bff:	34 2c                	xor    $0x2c,%al
     c01:	38 29                	cmp    %ch,(%ecx)
     c03:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
     c07:	77 5f                	ja     c68 <bootmain-0x27f398>
     c09:	77 69                	ja     c74 <bootmain-0x27f38c>
     c0b:	6e                   	outsb  %ds:(%esi),(%dx)
     c0c:	64 6f                	outsl  %fs:(%esi),(%dx)
     c0e:	77 3a                	ja     c4a <bootmain-0x27f3b6>
     c10:	46                   	inc    %esi
     c11:	28 30                	sub    %dh,(%eax)
     c13:	2c 31                	sub    $0x31,%al
     c15:	38 29                	cmp    %ch,(%ecx)
     c17:	00 69 6e             	add    %ch,0x6e(%ecx)
     c1a:	69 74 5f 73 63 72 65 	imul   $0x65657263,0x73(%edi,%ebx,2),%esi
     c21:	65 
     c22:	6e                   	outsb  %ds:(%esi),(%dx)
     c23:	3a 46 28             	cmp    0x28(%esi),%al
     c26:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c29:	38 29                	cmp    %ch,(%ecx)
     c2b:	00 62 6f             	add    %ah,0x6f(%edx)
     c2e:	6f                   	outsl  %ds:(%esi),(%dx)
     c2f:	74 70                	je     ca1 <bootmain-0x27f35f>
     c31:	3a 70 28             	cmp    0x28(%eax),%dh
     c34:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     c37:	30 29                	xor    %ch,(%ecx)
     c39:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     c3e:	31 29                	xor    %ebp,(%ecx)
     c40:	00 62 6f             	add    %ah,0x6f(%edx)
     c43:	6f                   	outsl  %ds:(%esi),(%dx)
     c44:	74 70                	je     cb6 <bootmain-0x27f34a>
     c46:	3a 72 28             	cmp    0x28(%edx),%dh
     c49:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     c4c:	30 29                	xor    %ch,(%ecx)
     c4e:	00 69 6e             	add    %ch,0x6e(%ecx)
     c51:	69 74 5f 6d 6f 75 73 	imul   $0x6573756f,0x6d(%edi,%ebx,2),%esi
     c58:	65 
     c59:	3a 46 28             	cmp    0x28(%esi),%al
     c5c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c5f:	38 29                	cmp    %ch,(%ecx)
     c61:	00 6d 6f             	add    %ch,0x6f(%ebp)
     c64:	75 73                	jne    cd9 <bootmain-0x27f327>
     c66:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     c6a:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     c6d:	29 00                	sub    %eax,(%eax)
     c6f:	62 67 3a             	bound  %esp,0x3a(%edi)
     c72:	70 28                	jo     c9c <bootmain-0x27f364>
     c74:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c77:	29 00                	sub    %eax,(%eax)
     c79:	63 75 72             	arpl   %si,0x72(%ebp)
     c7c:	73 6f                	jae    ced <bootmain-0x27f313>
     c7e:	72 3a                	jb     cba <bootmain-0x27f346>
     c80:	56                   	push   %esi
     c81:	28 30                	sub    %dh,(%eax)
     c83:	2c 32                	sub    $0x32,%al
     c85:	31 29                	xor    %ebp,(%ecx)
     c87:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     c8c:	2c 35                	sub    $0x35,%al
     c8e:	29 3b                	sub    %edi,(%ebx)
     c90:	30 3b                	xor    %bh,(%ebx)
     c92:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     c98:	32 32                	xor    (%edx),%dh
     c9a:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     ca0:	2c 35                	sub    $0x35,%al
     ca2:	29 3b                	sub    %edi,(%ebx)
     ca4:	30 3b                	xor    %bh,(%ebx)
     ca6:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     cac:	32 29                	xor    (%ecx),%ch
     cae:	00 78 3a             	add    %bh,0x3a(%eax)
     cb1:	72 28                	jb     cdb <bootmain-0x27f325>
     cb3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cb6:	29 00                	sub    %eax,(%eax)
     cb8:	62 67 3a             	bound  %esp,0x3a(%edi)
     cbb:	72 28                	jb     ce5 <bootmain-0x27f31b>
     cbd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     cc0:	29 00                	sub    %eax,(%eax)
     cc2:	64 69 73 70 6c 61 79 	imul   $0x5f79616c,%fs:0x70(%ebx),%esi
     cc9:	5f 
     cca:	6d                   	insl   (%dx),%es:(%edi)
     ccb:	6f                   	outsl  %ds:(%esi),(%dx)
     ccc:	75 73                	jne    d41 <bootmain-0x27f2bf>
     cce:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     cd2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cd5:	38 29                	cmp    %ch,(%ecx)
     cd7:	00 76 72             	add    %dh,0x72(%esi)
     cda:	61                   	popa   
     cdb:	6d                   	insl   (%dx),%es:(%edi)
     cdc:	3a 70 28             	cmp    0x28(%eax),%dh
     cdf:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     ce2:	29 00                	sub    %eax,(%eax)
     ce4:	70 78                	jo     d5e <bootmain-0x27f2a2>
     ce6:	73 69                	jae    d51 <bootmain-0x27f2af>
     ce8:	7a 65                	jp     d4f <bootmain-0x27f2b1>
     cea:	3a 70 28             	cmp    0x28(%eax),%dh
     ced:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cf0:	29 00                	sub    %eax,(%eax)
     cf2:	70 79                	jo     d6d <bootmain-0x27f293>
     cf4:	73 69                	jae    d5f <bootmain-0x27f2a1>
     cf6:	7a 65                	jp     d5d <bootmain-0x27f2a3>
     cf8:	3a 70 28             	cmp    0x28(%eax),%dh
     cfb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cfe:	29 00                	sub    %eax,(%eax)
     d00:	70 78                	jo     d7a <bootmain-0x27f286>
     d02:	30 3a                	xor    %bh,(%edx)
     d04:	70 28                	jo     d2e <bootmain-0x27f2d2>
     d06:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d09:	29 00                	sub    %eax,(%eax)
     d0b:	70 79                	jo     d86 <bootmain-0x27f27a>
     d0d:	30 3a                	xor    %bh,(%edx)
     d0f:	70 28                	jo     d39 <bootmain-0x27f2c7>
     d11:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d14:	29 00                	sub    %eax,(%eax)
     d16:	62 75 66             	bound  %esi,0x66(%ebp)
     d19:	3a 70 28             	cmp    0x28(%eax),%dh
     d1c:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     d1f:	29 00                	sub    %eax,(%eax)
     d21:	62 78 73             	bound  %edi,0x73(%eax)
     d24:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     d2b:	2c 31                	sub    $0x31,%al
     d2d:	29 00                	sub    %eax,(%eax)
     d2f:	79 3a                	jns    d6b <bootmain-0x27f295>
     d31:	72 28                	jb     d5b <bootmain-0x27f2a5>
     d33:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d36:	29 00                	sub    %eax,(%eax)
     d38:	66 6f                	outsw  %ds:(%esi),(%dx)
     d3a:	6e                   	outsb  %ds:(%esi),(%dx)
     d3b:	74 2e                	je     d6b <bootmain-0x27f295>
     d3d:	63 00                	arpl   %ax,(%eax)
     d3f:	70 72                	jo     db3 <bootmain-0x27f24d>
     d41:	69 6e 74 2e 63 00 69 	imul   $0x6900632e,0x74(%esi),%ebp
     d48:	74 6f                	je     db9 <bootmain-0x27f247>
     d4a:	61                   	popa   
     d4b:	3a 46 28             	cmp    0x28(%esi),%al
     d4e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d51:	38 29                	cmp    %ch,(%ecx)
     d53:	00 76 61             	add    %dh,0x61(%esi)
     d56:	6c                   	insb   (%dx),%es:(%edi)
     d57:	75 65                	jne    dbe <bootmain-0x27f242>
     d59:	3a 70 28             	cmp    0x28(%eax),%dh
     d5c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d5f:	29 00                	sub    %eax,(%eax)
     d61:	62 75 66             	bound  %esi,0x66(%ebp)
     d64:	3a 70 28             	cmp    0x28(%eax),%dh
     d67:	34 2c                	xor    $0x2c,%al
     d69:	38 29                	cmp    %ch,(%ecx)
     d6b:	00 74 6d 70          	add    %dh,0x70(%ebp,%ebp,2)
     d6f:	5f                   	pop    %edi
     d70:	62 75 66             	bound  %esi,0x66(%ebp)
     d73:	3a 28                	cmp    (%eax),%ch
     d75:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d78:	39 29                	cmp    %ebp,(%ecx)
     d7a:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     d7f:	2c 35                	sub    $0x35,%al
     d81:	29 3b                	sub    %edi,(%ebx)
     d83:	30 3b                	xor    %bh,(%ebx)
     d85:	39 3b                	cmp    %edi,(%ebx)
     d87:	28 30                	sub    %dh,(%eax)
     d89:	2c 31                	sub    $0x31,%al
     d8b:	31 29                	xor    %ebp,(%ecx)
     d8d:	00 76 61             	add    %dh,0x61(%esi)
     d90:	6c                   	insb   (%dx),%es:(%edi)
     d91:	75 65                	jne    df8 <bootmain-0x27f208>
     d93:	3a 72 28             	cmp    0x28(%edx),%dh
     d96:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d99:	29 00                	sub    %eax,(%eax)
     d9b:	62 75 66             	bound  %esi,0x66(%ebp)
     d9e:	3a 72 28             	cmp    0x28(%edx),%dh
     da1:	34 2c                	xor    $0x2c,%al
     da3:	38 29                	cmp    %ch,(%ecx)
     da5:	00 78 74             	add    %bh,0x74(%eax)
     da8:	6f                   	outsl  %ds:(%esi),(%dx)
     da9:	61                   	popa   
     daa:	3a 46 28             	cmp    0x28(%esi),%al
     dad:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     db0:	38 29                	cmp    %ch,(%ecx)
     db2:	00 76 61             	add    %dh,0x61(%esi)
     db5:	6c                   	insb   (%dx),%es:(%edi)
     db6:	75 65                	jne    e1d <bootmain-0x27f1e3>
     db8:	3a 70 28             	cmp    0x28(%eax),%dh
     dbb:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     dbe:	29 00                	sub    %eax,(%eax)
     dc0:	74 6d                	je     e2f <bootmain-0x27f1d1>
     dc2:	70 5f                	jo     e23 <bootmain-0x27f1dd>
     dc4:	62 75 66             	bound  %esi,0x66(%ebp)
     dc7:	3a 28                	cmp    (%eax),%ch
     dc9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     dcc:	30 29                	xor    %ch,(%ecx)
     dce:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     dd3:	2c 35                	sub    $0x35,%al
     dd5:	29 3b                	sub    %edi,(%ebx)
     dd7:	30 3b                	xor    %bh,(%ebx)
     dd9:	32 39                	xor    (%ecx),%bh
     ddb:	3b 28                	cmp    (%eax),%ebp
     ddd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     de0:	31 29                	xor    %ebp,(%ecx)
     de2:	00 73 70             	add    %dh,0x70(%ebx)
     de5:	72 69                	jb     e50 <bootmain-0x27f1b0>
     de7:	6e                   	outsb  %ds:(%esi),(%dx)
     de8:	74 66                	je     e50 <bootmain-0x27f1b0>
     dea:	3a 46 28             	cmp    0x28(%esi),%al
     ded:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     df0:	38 29                	cmp    %ch,(%ecx)
     df2:	00 73 74             	add    %dh,0x74(%ebx)
     df5:	72 3a                	jb     e31 <bootmain-0x27f1cf>
     df7:	70 28                	jo     e21 <bootmain-0x27f1df>
     df9:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     dfc:	29 00                	sub    %eax,(%eax)
     dfe:	66 6f                	outsw  %ds:(%esi),(%dx)
     e00:	72 6d                	jb     e6f <bootmain-0x27f191>
     e02:	61                   	popa   
     e03:	74 3a                	je     e3f <bootmain-0x27f1c1>
     e05:	70 28                	jo     e2f <bootmain-0x27f1d1>
     e07:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     e0a:	29 00                	sub    %eax,(%eax)
     e0c:	76 61                	jbe    e6f <bootmain-0x27f191>
     e0e:	72 3a                	jb     e4a <bootmain-0x27f1b6>
     e10:	72 28                	jb     e3a <bootmain-0x27f1c6>
     e12:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     e15:	31 29                	xor    %ebp,(%ecx)
     e17:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     e1c:	31 29                	xor    %ebp,(%ecx)
     e1e:	00 62 75             	add    %ah,0x75(%edx)
     e21:	66                   	data16
     e22:	66                   	data16
     e23:	65                   	gs
     e24:	72 3a                	jb     e60 <bootmain-0x27f1a0>
     e26:	28 30                	sub    %dh,(%eax)
     e28:	2c 32                	sub    $0x32,%al
     e2a:	32 29                	xor    (%ecx),%ch
     e2c:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     e31:	2c 35                	sub    $0x35,%al
     e33:	29 3b                	sub    %edi,(%ebx)
     e35:	30 3b                	xor    %bh,(%ebx)
     e37:	39 3b                	cmp    %edi,(%ebx)
     e39:	28 30                	sub    %dh,(%eax)
     e3b:	2c 32                	sub    $0x32,%al
     e3d:	29 00                	sub    %eax,(%eax)
     e3f:	73 74                	jae    eb5 <bootmain-0x27f14b>
     e41:	72 3a                	jb     e7d <bootmain-0x27f183>
     e43:	72 28                	jb     e6d <bootmain-0x27f193>
     e45:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     e48:	29 00                	sub    %eax,(%eax)
     e4a:	70 75                	jo     ec1 <bootmain-0x27f13f>
     e4c:	74 66                	je     eb4 <bootmain-0x27f14c>
     e4e:	6f                   	outsl  %ds:(%esi),(%dx)
     e4f:	6e                   	outsb  %ds:(%esi),(%dx)
     e50:	74 38                	je     e8a <bootmain-0x27f176>
     e52:	3a 46 28             	cmp    0x28(%esi),%al
     e55:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e58:	38 29                	cmp    %ch,(%ecx)
     e5a:	00 78 3a             	add    %bh,0x3a(%eax)
     e5d:	70 28                	jo     e87 <bootmain-0x27f179>
     e5f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e62:	29 00                	sub    %eax,(%eax)
     e64:	79 3a                	jns    ea0 <bootmain-0x27f160>
     e66:	70 28                	jo     e90 <bootmain-0x27f170>
     e68:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e6b:	29 00                	sub    %eax,(%eax)
     e6d:	66 6f                	outsw  %ds:(%esi),(%dx)
     e6f:	6e                   	outsb  %ds:(%esi),(%dx)
     e70:	74 3a                	je     eac <bootmain-0x27f154>
     e72:	70 28                	jo     e9c <bootmain-0x27f164>
     e74:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     e77:	29 00                	sub    %eax,(%eax)
     e79:	72 6f                	jb     eea <bootmain-0x27f116>
     e7b:	77 3a                	ja     eb7 <bootmain-0x27f149>
     e7d:	72 28                	jb     ea7 <bootmain-0x27f159>
     e7f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e82:	29 00                	sub    %eax,(%eax)
     e84:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     e87:	3a 72 28             	cmp    0x28(%edx),%dh
     e8a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e8d:	29 00                	sub    %eax,(%eax)
     e8f:	70 75                	jo     f06 <bootmain-0x27f0fa>
     e91:	74 73                	je     f06 <bootmain-0x27f0fa>
     e93:	38 3a                	cmp    %bh,(%edx)
     e95:	46                   	inc    %esi
     e96:	28 30                	sub    %dh,(%eax)
     e98:	2c 31                	sub    $0x31,%al
     e9a:	38 29                	cmp    %ch,(%ecx)
     e9c:	00 66 6f             	add    %ah,0x6f(%esi)
     e9f:	6e                   	outsb  %ds:(%esi),(%dx)
     ea0:	74 3a                	je     edc <bootmain-0x27f124>
     ea2:	70 28                	jo     ecc <bootmain-0x27f134>
     ea4:	34 2c                	xor    $0x2c,%al
     ea6:	38 29                	cmp    %ch,(%ecx)
     ea8:	00 70 72             	add    %dh,0x72(%eax)
     eab:	69 6e 74 64 65 62 75 	imul   $0x75626564,0x74(%esi),%ebp
     eb2:	67 3a 46 28          	cmp    0x28(%bp),%al
     eb6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     eb9:	38 29                	cmp    %ch,(%ecx)
     ebb:	00 69 3a             	add    %ch,0x3a(%ecx)
     ebe:	70 28                	jo     ee8 <bootmain-0x27f118>
     ec0:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     ec3:	29 00                	sub    %eax,(%eax)
     ec5:	78 3a                	js     f01 <bootmain-0x27f0ff>
     ec7:	70 28                	jo     ef1 <bootmain-0x27f10f>
     ec9:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     ecc:	29 00                	sub    %eax,(%eax)
     ece:	66 6f                	outsw  %ds:(%esi),(%dx)
     ed0:	6e                   	outsb  %ds:(%esi),(%dx)
     ed1:	74 3a                	je     f0d <bootmain-0x27f0f3>
     ed3:	28 30                	sub    %dh,(%eax)
     ed5:	2c 32                	sub    $0x32,%al
     ed7:	33 29                	xor    (%ecx),%ebp
     ed9:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     ede:	2c 35                	sub    $0x35,%al
     ee0:	29 3b                	sub    %edi,(%ebx)
     ee2:	30 3b                	xor    %bh,(%ebx)
     ee4:	32 39                	xor    (%ecx),%bh
     ee6:	3b 28                	cmp    (%eax),%ebp
     ee8:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     eeb:	29 00                	sub    %eax,(%eax)
     eed:	70 75                	jo     f64 <bootmain-0x27f09c>
     eef:	74 66                	je     f57 <bootmain-0x27f0a9>
     ef1:	6f                   	outsl  %ds:(%esi),(%dx)
     ef2:	6e                   	outsb  %ds:(%esi),(%dx)
     ef3:	74 31                	je     f26 <bootmain-0x27f0da>
     ef5:	36 3a 46 28          	cmp    %ss:0x28(%esi),%al
     ef9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     efc:	38 29                	cmp    %ch,(%ecx)
     efe:	00 66 6f             	add    %ah,0x6f(%esi)
     f01:	6e                   	outsb  %ds:(%esi),(%dx)
     f02:	74 3a                	je     f3e <bootmain-0x27f0c2>
     f04:	70 28                	jo     f2e <bootmain-0x27f0d2>
     f06:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     f09:	34 29                	xor    $0x29,%al
     f0b:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     f10:	39 29                	cmp    %ebp,(%ecx)
     f12:	00 70 75             	add    %dh,0x75(%eax)
     f15:	74 73                	je     f8a <bootmain-0x27f076>
     f17:	31 36                	xor    %esi,(%esi)
     f19:	3a 46 28             	cmp    0x28(%esi),%al
     f1c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f1f:	38 29                	cmp    %ch,(%ecx)
     f21:	00 69 64             	add    %ch,0x64(%ecx)
     f24:	74 67                	je     f8d <bootmain-0x27f073>
     f26:	64                   	fs
     f27:	74 2e                	je     f57 <bootmain-0x27f0a9>
     f29:	63 00                	arpl   %ax,(%eax)
     f2b:	73 65                	jae    f92 <bootmain-0x27f06e>
     f2d:	74 67                	je     f96 <bootmain-0x27f06a>
     f2f:	64                   	fs
     f30:	74 3a                	je     f6c <bootmain-0x27f094>
     f32:	46                   	inc    %esi
     f33:	28 30                	sub    %dh,(%eax)
     f35:	2c 31                	sub    $0x31,%al
     f37:	38 29                	cmp    %ch,(%ecx)
     f39:	00 73 64             	add    %dh,0x64(%ebx)
     f3c:	3a 70 28             	cmp    0x28(%eax),%dh
     f3f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f42:	39 29                	cmp    %ebp,(%ecx)
     f44:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     f49:	33 29                	xor    (%ecx),%ebp
     f4b:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
     f4f:	69 74 3a 70 28 30 2c 	imul   $0x342c3028,0x70(%edx,%edi,1),%esi
     f56:	34 
     f57:	29 00                	sub    %eax,(%eax)
     f59:	62 61 73             	bound  %esp,0x73(%ecx)
     f5c:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     f60:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f63:	29 00                	sub    %eax,(%eax)
     f65:	61                   	popa   
     f66:	63 63 65             	arpl   %sp,0x65(%ebx)
     f69:	73 73                	jae    fde <bootmain-0x27f022>
     f6b:	3a 70 28             	cmp    0x28(%eax),%dh
     f6e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f71:	29 00                	sub    %eax,(%eax)
     f73:	73 64                	jae    fd9 <bootmain-0x27f027>
     f75:	3a 72 28             	cmp    0x28(%edx),%dh
     f78:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f7b:	39 29                	cmp    %ebp,(%ecx)
     f7d:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
     f81:	69 74 3a 72 28 30 2c 	imul   $0x342c3028,0x72(%edx,%edi,1),%esi
     f88:	34 
     f89:	29 00                	sub    %eax,(%eax)
     f8b:	62 61 73             	bound  %esp,0x73(%ecx)
     f8e:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
     f92:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f95:	29 00                	sub    %eax,(%eax)
     f97:	61                   	popa   
     f98:	63 63 65             	arpl   %sp,0x65(%ebx)
     f9b:	73 73                	jae    1010 <bootmain-0x27eff0>
     f9d:	3a 72 28             	cmp    0x28(%edx),%dh
     fa0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fa3:	29 00                	sub    %eax,(%eax)
     fa5:	73 65                	jae    100c <bootmain-0x27eff4>
     fa7:	74 69                	je     1012 <bootmain-0x27efee>
     fa9:	64                   	fs
     faa:	74 3a                	je     fe6 <bootmain-0x27f01a>
     fac:	46                   	inc    %esi
     fad:	28 30                	sub    %dh,(%eax)
     faf:	2c 31                	sub    $0x31,%al
     fb1:	38 29                	cmp    %ch,(%ecx)
     fb3:	00 67 64             	add    %ah,0x64(%edi)
     fb6:	3a 70 28             	cmp    0x28(%eax),%dh
     fb9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     fbc:	30 29                	xor    %ch,(%ecx)
     fbe:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     fc3:	34 29                	xor    $0x29,%al
     fc5:	00 6f 66             	add    %ch,0x66(%edi)
     fc8:	66                   	data16
     fc9:	73 65                	jae    1030 <bootmain-0x27efd0>
     fcb:	74 3a                	je     1007 <bootmain-0x27eff9>
     fcd:	70 28                	jo     ff7 <bootmain-0x27f009>
     fcf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fd2:	29 00                	sub    %eax,(%eax)
     fd4:	73 65                	jae    103b <bootmain-0x27efc5>
     fd6:	6c                   	insb   (%dx),%es:(%edi)
     fd7:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     fdc:	3a 70 28             	cmp    0x28(%eax),%dh
     fdf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fe2:	29 00                	sub    %eax,(%eax)
     fe4:	67 64 3a 72 28       	cmp    %fs:0x28(%bp,%si),%dh
     fe9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     fec:	30 29                	xor    %ch,(%ecx)
     fee:	00 6f 66             	add    %ch,0x66(%edi)
     ff1:	66                   	data16
     ff2:	73 65                	jae    1059 <bootmain-0x27efa7>
     ff4:	74 3a                	je     1030 <bootmain-0x27efd0>
     ff6:	72 28                	jb     1020 <bootmain-0x27efe0>
     ff8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ffb:	29 00                	sub    %eax,(%eax)
     ffd:	73 65                	jae    1064 <bootmain-0x27ef9c>
     fff:	6c                   	insb   (%dx),%es:(%edi)
    1000:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
    1005:	3a 72 28             	cmp    0x28(%edx),%dh
    1008:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    100b:	29 00                	sub    %eax,(%eax)
    100d:	69 6e 69 74 5f 67 64 	imul   $0x64675f74,0x69(%esi),%ebp
    1014:	74 69                	je     107f <bootmain-0x27ef81>
    1016:	64                   	fs
    1017:	74 3a                	je     1053 <bootmain-0x27efad>
    1019:	46                   	inc    %esi
    101a:	28 30                	sub    %dh,(%eax)
    101c:	2c 31                	sub    $0x31,%al
    101e:	38 29                	cmp    %ch,(%ecx)
    1020:	00 69 6e             	add    %ch,0x6e(%ecx)
    1023:	74 2e                	je     1053 <bootmain-0x27efad>
    1025:	63 00                	arpl   %ax,(%eax)
    1027:	69 6e 69 74 5f 70 69 	imul   $0x69705f74,0x69(%esi),%ebp
    102e:	63 3a                	arpl   %di,(%edx)
    1030:	46                   	inc    %esi
    1031:	28 30                	sub    %dh,(%eax)
    1033:	2c 31                	sub    $0x31,%al
    1035:	38 29                	cmp    %ch,(%ecx)
    1037:	00 69 6e             	add    %ch,0x6e(%ecx)
    103a:	74 68                	je     10a4 <bootmain-0x27ef5c>
    103c:	61                   	popa   
    103d:	6e                   	outsb  %ds:(%esi),(%dx)
    103e:	64                   	fs
    103f:	6c                   	insb   (%dx),%es:(%edi)
    1040:	65                   	gs
    1041:	72 32                	jb     1075 <bootmain-0x27ef8b>
    1043:	31 3a                	xor    %edi,(%edx)
    1045:	46                   	inc    %esi
    1046:	28 30                	sub    %dh,(%eax)
    1048:	2c 31                	sub    $0x31,%al
    104a:	38 29                	cmp    %ch,(%ecx)
    104c:	00 65 73             	add    %ah,0x73(%ebp)
    104f:	70 3a                	jo     108b <bootmain-0x27ef75>
    1051:	70 28                	jo     107b <bootmain-0x27ef85>
    1053:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1056:	39 29                	cmp    %ebp,(%ecx)
    1058:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
    105d:	31 29                	xor    %ebp,(%ecx)
    105f:	00 69 6e             	add    %ch,0x6e(%ecx)
    1062:	74 68                	je     10cc <bootmain-0x27ef34>
    1064:	61                   	popa   
    1065:	6e                   	outsb  %ds:(%esi),(%dx)
    1066:	64                   	fs
    1067:	6c                   	insb   (%dx),%es:(%edi)
    1068:	65                   	gs
    1069:	72 32                	jb     109d <bootmain-0x27ef63>
    106b:	63 3a                	arpl   %di,(%edx)
    106d:	46                   	inc    %esi
    106e:	28 30                	sub    %dh,(%eax)
    1070:	2c 31                	sub    $0x31,%al
    1072:	38 29                	cmp    %ch,(%ecx)
    1074:	00 65 73             	add    %ah,0x73(%ebp)
    1077:	70 3a                	jo     10b3 <bootmain-0x27ef4d>
    1079:	70 28                	jo     10a3 <bootmain-0x27ef5d>
    107b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    107e:	39 29                	cmp    %ebp,(%ecx)
    1080:	00 77 61             	add    %dh,0x61(%edi)
    1083:	69 74 5f 4b 42 43 5f 	imul   $0x735f4342,0x4b(%edi,%ebx,2),%esi
    108a:	73 
    108b:	65 6e                	outsb  %gs:(%esi),(%dx)
    108d:	64                   	fs
    108e:	72 65                	jb     10f5 <bootmain-0x27ef0b>
    1090:	61                   	popa   
    1091:	64                   	fs
    1092:	79 3a                	jns    10ce <bootmain-0x27ef32>
    1094:	46                   	inc    %esi
    1095:	28 30                	sub    %dh,(%eax)
    1097:	2c 31                	sub    $0x31,%al
    1099:	38 29                	cmp    %ch,(%ecx)
    109b:	00 69 6e             	add    %ch,0x6e(%ecx)
    109e:	69 74 5f 6b 65 79 62 	imul   $0x6f627965,0x6b(%edi,%ebx,2),%esi
    10a5:	6f 
    10a6:	61                   	popa   
    10a7:	72 64                	jb     110d <bootmain-0x27eef3>
    10a9:	3a 46 28             	cmp    0x28(%esi),%al
    10ac:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    10af:	38 29                	cmp    %ch,(%ecx)
    10b1:	00 6b 65             	add    %ch,0x65(%ebx)
    10b4:	79 66                	jns    111c <bootmain-0x27eee4>
    10b6:	69 66 6f 3a 47 28 31 	imul   $0x3128473a,0x6f(%esi),%esp
    10bd:	2c 35                	sub    $0x35,%al
    10bf:	29 00                	sub    %eax,(%eax)
    10c1:	6d                   	insl   (%dx),%es:(%edi)
    10c2:	6f                   	outsl  %ds:(%esi),(%dx)
    10c3:	75 73                	jne    1138 <bootmain-0x27eec8>
    10c5:	65 66 69 66 6f 3a 47 	imul   $0x473a,%gs:0x6f(%esi),%sp
    10cc:	28 31                	sub    %dh,(%ecx)
    10ce:	2c 35                	sub    $0x35,%al
    10d0:	29 00                	sub    %eax,(%eax)
    10d2:	2f                   	das    
    10d3:	74 6d                	je     1142 <bootmain-0x27eebe>
    10d5:	70 2f                	jo     1106 <bootmain-0x27eefa>
    10d7:	63 63 4f             	arpl   %sp,0x4f(%ebx)
    10da:	6c                   	insb   (%dx),%es:(%edi)
    10db:	77 31                	ja     110e <bootmain-0x27eef2>
    10dd:	4f                   	dec    %edi
    10de:	61                   	popa   
    10df:	2e 73 00             	jae,pn 10e2 <bootmain-0x27ef1e>
    10e2:	61                   	popa   
    10e3:	73 6d                	jae    1152 <bootmain-0x27eeae>
    10e5:	69 6e 74 33 32 2e 53 	imul   $0x532e3233,0x74(%esi),%ebp
    10ec:	00 66 69             	add    %ah,0x69(%esi)
    10ef:	66 6f                	outsw  %ds:(%esi),(%dx)
    10f1:	2e 63 00             	arpl   %ax,%cs:(%eax)
    10f4:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    10fa:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    1101:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1104:	38 29                	cmp    %ch,(%ecx)
    1106:	00 66 69             	add    %ah,0x69(%esi)
    1109:	66 6f                	outsw  %ds:(%esi),(%dx)
    110b:	3a 70 28             	cmp    0x28(%eax),%dh
    110e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1111:	39 29                	cmp    %ebp,(%ecx)
    1113:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    1118:	35 29 00 73 69       	xor    $0x69730029,%eax
    111d:	7a 65                	jp     1184 <bootmain-0x27ee7c>
    111f:	3a 70 28             	cmp    0x28(%eax),%dh
    1122:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1125:	29 00                	sub    %eax,(%eax)
    1127:	66 69 66 6f 3a 72    	imul   $0x723a,0x6f(%esi),%sp
    112d:	28 30                	sub    %dh,(%eax)
    112f:	2c 31                	sub    $0x31,%al
    1131:	39 29                	cmp    %ebp,(%ecx)
    1133:	00 73 69             	add    %dh,0x69(%ebx)
    1136:	7a 65                	jp     119d <bootmain-0x27ee63>
    1138:	3a 72 28             	cmp    0x28(%edx),%dh
    113b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    113e:	29 00                	sub    %eax,(%eax)
    1140:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    1146:	77 72                	ja     11ba <bootmain-0x27ee46>
    1148:	69 74 65 3a 46 28 30 	imul   $0x2c302846,0x3a(%ebp,%eiz,2),%esi
    114f:	2c 
    1150:	31 29                	xor    %ebp,(%ecx)
    1152:	00 66 69             	add    %ah,0x69(%esi)
    1155:	66 6f                	outsw  %ds:(%esi),(%dx)
    1157:	3a 70 28             	cmp    0x28(%eax),%dh
    115a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    115d:	39 29                	cmp    %ebp,(%ecx)
    115f:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
    1163:	61                   	popa   
    1164:	3a 70 28             	cmp    0x28(%eax),%dh
    1167:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    116a:	29 00                	sub    %eax,(%eax)
    116c:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    1172:	72 65                	jb     11d9 <bootmain-0x27ee27>
    1174:	61                   	popa   
    1175:	64 3a 46 28          	cmp    %fs:0x28(%esi),%al
    1179:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    117c:	29 00                	sub    %eax,(%eax)
    117e:	64                   	fs
    117f:	61                   	popa   
    1180:	74 61                	je     11e3 <bootmain-0x27ee1d>
    1182:	3a 72 28             	cmp    0x28(%edx),%dh
    1185:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1188:	29 00                	sub    %eax,(%eax)
    118a:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
    1190:	73 74                	jae    1206 <bootmain-0x27edfa>
    1192:	61                   	popa   
    1193:	74 75                	je     120a <bootmain-0x27edf6>
    1195:	73 3a                	jae    11d1 <bootmain-0x27ee2f>
    1197:	46                   	inc    %esi
    1198:	28 30                	sub    %dh,(%eax)
    119a:	2c 31                	sub    $0x31,%al
    119c:	29 00                	sub    %eax,(%eax)
    119e:	6d                   	insl   (%dx),%es:(%edi)
    119f:	6f                   	outsl  %ds:(%esi),(%dx)
    11a0:	75 73                	jne    1215 <bootmain-0x27edeb>
    11a2:	65 2e 63 00          	gs arpl %ax,%cs:%gs:(%eax)
    11a6:	65 6e                	outsb  %gs:(%esi),(%dx)
    11a8:	61                   	popa   
    11a9:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
    11ad:	6d                   	insl   (%dx),%es:(%edi)
    11ae:	6f                   	outsl  %ds:(%esi),(%dx)
    11af:	75 73                	jne    1224 <bootmain-0x27eddc>
    11b1:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    11b5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11b8:	38 29                	cmp    %ch,(%ecx)
    11ba:	00 6d 64             	add    %ch,0x64(%ebp)
    11bd:	65 63 3a             	arpl   %di,%gs:(%edx)
    11c0:	70 28                	jo     11ea <bootmain-0x27ee16>
    11c2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11c5:	39 29                	cmp    %ebp,(%ecx)
    11c7:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    11cc:	36 29 00             	sub    %eax,%ss:(%eax)
    11cf:	6d                   	insl   (%dx),%es:(%edi)
    11d0:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
    11d4:	72 28                	jb     11fe <bootmain-0x27ee02>
    11d6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11d9:	39 29                	cmp    %ebp,(%ecx)
    11db:	00 6d 6f             	add    %ch,0x6f(%ebp)
    11de:	75 73                	jne    1253 <bootmain-0x27edad>
    11e0:	65                   	gs
    11e1:	5f                   	pop    %edi
    11e2:	64 65 63 6f 64       	fs arpl %bp,%fs:%gs:0x64(%edi)
    11e7:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    11eb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11ee:	29 00                	sub    %eax,(%eax)
    11f0:	6d                   	insl   (%dx),%es:(%edi)
    11f1:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
    11f5:	70 28                	jo     121f <bootmain-0x27ede1>
    11f7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    11fa:	39 29                	cmp    %ebp,(%ecx)
    11fc:	00 6d 6d             	add    %ch,0x6d(%ebp)
    11ff:	2e 63 00             	arpl   %ax,%cs:(%eax)
    1202:	67                   	addr16
    1203:	65                   	gs
    1204:	74 6d                	je     1273 <bootmain-0x27ed8d>
    1206:	65                   	gs
    1207:	6d                   	insl   (%dx),%es:(%edi)
    1208:	6f                   	outsl  %ds:(%esi),(%dx)
    1209:	72 79                	jb     1284 <bootmain-0x27ed7c>
    120b:	73 69                	jae    1276 <bootmain-0x27ed8a>
    120d:	7a 65                	jp     1274 <bootmain-0x27ed8c>
    120f:	3a 46 28             	cmp    0x28(%esi),%al
    1212:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1215:	29 00                	sub    %eax,(%eax)
    1217:	73 74                	jae    128d <bootmain-0x27ed73>
    1219:	61                   	popa   
    121a:	72 74                	jb     1290 <bootmain-0x27ed70>
    121c:	3a 70 28             	cmp    0x28(%eax),%dh
    121f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1222:	29 00                	sub    %eax,(%eax)
    1224:	65 6e                	outsb  %gs:(%esi),(%dx)
    1226:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
    122a:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    122d:	29 00                	sub    %eax,(%eax)
    122f:	6f                   	outsl  %ds:(%esi),(%dx)
    1230:	6c                   	insb   (%dx),%es:(%edi)
    1231:	64 3a 72 28          	cmp    %fs:0x28(%edx),%dh
    1235:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1238:	29 00                	sub    %eax,(%eax)
    123a:	70 3a                	jo     1276 <bootmain-0x27ed8a>
    123c:	72 28                	jb     1266 <bootmain-0x27ed9a>
    123e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1241:	39 29                	cmp    %ebp,(%ecx)
    1243:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
    1248:	34 29                	xor    $0x29,%al
    124a:	00 73 74             	add    %dh,0x74(%ebx)
    124d:	61                   	popa   
    124e:	72 74                	jb     12c4 <bootmain-0x27ed3c>
    1250:	3a 72 28             	cmp    0x28(%edx),%dh
    1253:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1256:	29 00                	sub    %eax,(%eax)
    1258:	6d                   	insl   (%dx),%es:(%edi)
    1259:	65                   	gs
    125a:	6d                   	insl   (%dx),%es:(%edi)
    125b:	74 65                	je     12c2 <bootmain-0x27ed3e>
    125d:	73 74                	jae    12d3 <bootmain-0x27ed2d>
    125f:	3a 46 28             	cmp    0x28(%esi),%al
    1262:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1265:	29 00                	sub    %eax,(%eax)
    1267:	66                   	data16
    1268:	6c                   	insb   (%dx),%es:(%edi)
    1269:	67 34 38             	addr16 xor $0x38,%al
    126c:	36 3a 72 28          	cmp    %ss:0x28(%edx),%dh
    1270:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1273:	29 00                	sub    %eax,(%eax)
    1275:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
    127b:	34 29                	xor    $0x29,%al
    127d:	00 6d 65             	add    %ch,0x65(%ebp)
    1280:	6d                   	insl   (%dx),%es:(%edi)
    1281:	6d                   	insl   (%dx),%es:(%edi)
    1282:	61                   	popa   
    1283:	6e                   	outsb  %ds:(%esi),(%dx)
    1284:	5f                   	pop    %edi
    1285:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    128c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    128f:	38 29                	cmp    %ch,(%ecx)
    1291:	00 6d 61             	add    %ch,0x61(%ebp)
    1294:	6e                   	outsb  %ds:(%esi),(%dx)
    1295:	3a 70 28             	cmp    0x28(%eax),%dh
    1298:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    129b:	30 29                	xor    %ch,(%ecx)
    129d:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    12a2:	36 29 00             	sub    %eax,%ss:(%eax)
    12a5:	6d                   	insl   (%dx),%es:(%edi)
    12a6:	61                   	popa   
    12a7:	6e                   	outsb  %ds:(%esi),(%dx)
    12a8:	3a 72 28             	cmp    0x28(%edx),%dh
    12ab:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    12ae:	30 29                	xor    %ch,(%ecx)
    12b0:	00 6d 65             	add    %ch,0x65(%ebp)
    12b3:	6d                   	insl   (%dx),%es:(%edi)
    12b4:	6d                   	insl   (%dx),%es:(%edi)
    12b5:	61                   	popa   
    12b6:	6e                   	outsb  %ds:(%esi),(%dx)
    12b7:	5f                   	pop    %edi
    12b8:	61                   	popa   
    12b9:	76 61                	jbe    131c <bootmain-0x27ece4>
    12bb:	69 6c 3a 46 28 30 2c 	imul   $0x342c3028,0x46(%edx,%edi,1),%ebp
    12c2:	34 
    12c3:	29 00                	sub    %eax,(%eax)
    12c5:	6d                   	insl   (%dx),%es:(%edi)
    12c6:	61                   	popa   
    12c7:	6e                   	outsb  %ds:(%esi),(%dx)
    12c8:	3a 70 28             	cmp    0x28(%eax),%dh
    12cb:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    12ce:	30 29                	xor    %ch,(%ecx)
    12d0:	00 66 72             	add    %ah,0x72(%esi)
    12d3:	65                   	gs
    12d4:	65                   	gs
    12d5:	6d                   	insl   (%dx),%es:(%edi)
    12d6:	65                   	gs
    12d7:	6d                   	insl   (%dx),%es:(%edi)
    12d8:	3a 72 28             	cmp    0x28(%edx),%dh
    12db:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12de:	29 00                	sub    %eax,(%eax)
    12e0:	6d                   	insl   (%dx),%es:(%edi)
    12e1:	65                   	gs
    12e2:	6d                   	insl   (%dx),%es:(%edi)
    12e3:	6d                   	insl   (%dx),%es:(%edi)
    12e4:	61                   	popa   
    12e5:	6e                   	outsb  %ds:(%esi),(%dx)
    12e6:	5f                   	pop    %edi
    12e7:	61                   	popa   
    12e8:	6c                   	insb   (%dx),%es:(%edi)
    12e9:	6c                   	insb   (%dx),%es:(%edi)
    12ea:	6f                   	outsl  %ds:(%esi),(%dx)
    12eb:	63 3a                	arpl   %di,(%edx)
    12ed:	46                   	inc    %esi
    12ee:	28 30                	sub    %dh,(%eax)
    12f0:	2c 31                	sub    $0x31,%al
    12f2:	29 00                	sub    %eax,(%eax)
    12f4:	73 69                	jae    135f <bootmain-0x27eca1>
    12f6:	7a 65                	jp     135d <bootmain-0x27eca3>
    12f8:	3a 70 28             	cmp    0x28(%eax),%dh
    12fb:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    12fe:	29 00                	sub    %eax,(%eax)
    1300:	61                   	popa   
    1301:	3a 72 28             	cmp    0x28(%edx),%dh
    1304:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1307:	29 00                	sub    %eax,(%eax)
    1309:	6d                   	insl   (%dx),%es:(%edi)
    130a:	65                   	gs
    130b:	6d                   	insl   (%dx),%es:(%edi)
    130c:	6d                   	insl   (%dx),%es:(%edi)
    130d:	61                   	popa   
    130e:	6e                   	outsb  %ds:(%esi),(%dx)
    130f:	5f                   	pop    %edi
    1310:	61                   	popa   
    1311:	6c                   	insb   (%dx),%es:(%edi)
    1312:	6c                   	insb   (%dx),%es:(%edi)
    1313:	6f                   	outsl  %ds:(%esi),(%dx)
    1314:	63 5f 34             	arpl   %bx,0x34(%edi)
    1317:	4b                   	dec    %ebx
    1318:	3a 46 28             	cmp    0x28(%esi),%al
    131b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    131e:	29 00                	sub    %eax,(%eax)
    1320:	6d                   	insl   (%dx),%es:(%edi)
    1321:	65                   	gs
    1322:	6d                   	insl   (%dx),%es:(%edi)
    1323:	6d                   	insl   (%dx),%es:(%edi)
    1324:	61                   	popa   
    1325:	6e                   	outsb  %ds:(%esi),(%dx)
    1326:	5f                   	pop    %edi
    1327:	66                   	data16
    1328:	72 65                	jb     138f <bootmain-0x27ec71>
    132a:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    132e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1331:	29 00                	sub    %eax,(%eax)
    1333:	61                   	popa   
    1334:	64                   	fs
    1335:	64                   	fs
    1336:	72 3a                	jb     1372 <bootmain-0x27ec8e>
    1338:	70 28                	jo     1362 <bootmain-0x27ec9e>
    133a:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    133d:	29 00                	sub    %eax,(%eax)
    133f:	73 69                	jae    13aa <bootmain-0x27ec56>
    1341:	7a 65                	jp     13a8 <bootmain-0x27ec58>
    1343:	3a 72 28             	cmp    0x28(%edx),%dh
    1346:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1349:	29 00                	sub    %eax,(%eax)
    134b:	6d                   	insl   (%dx),%es:(%edi)
    134c:	65                   	gs
    134d:	6d                   	insl   (%dx),%es:(%edi)
    134e:	6d                   	insl   (%dx),%es:(%edi)
    134f:	61                   	popa   
    1350:	6e                   	outsb  %ds:(%esi),(%dx)
    1351:	5f                   	pop    %edi
    1352:	66                   	data16
    1353:	72 65                	jb     13ba <bootmain-0x27ec46>
    1355:	65                   	gs
    1356:	5f                   	pop    %edi
    1357:	34 6b                	xor    $0x6b,%al
    1359:	3a 46 28             	cmp    0x28(%esi),%al
    135c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    135f:	29 00                	sub    %eax,(%eax)
    1361:	61                   	popa   
    1362:	64                   	fs
    1363:	64                   	fs
    1364:	72 3a                	jb     13a0 <bootmain-0x27ec60>
    1366:	72 28                	jb     1390 <bootmain-0x27ec70>
    1368:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    136b:	29 00                	sub    %eax,(%eax)
    136d:	73 68                	jae    13d7 <bootmain-0x27ec29>
    136f:	74 63                	je     13d4 <bootmain-0x27ec2c>
    1371:	74 6c                	je     13df <bootmain-0x27ec21>
    1373:	5f                   	pop    %edi
    1374:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    137b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    137e:	31 29                	xor    %ebp,(%ecx)
    1380:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    1385:	31 34 29             	xor    %esi,(%ecx,%ebp,1)
    1388:	00 6d 65             	add    %ch,0x65(%ebp)
    138b:	6d                   	insl   (%dx),%es:(%edi)
    138c:	6d                   	insl   (%dx),%es:(%edi)
    138d:	61                   	popa   
    138e:	6e                   	outsb  %ds:(%esi),(%dx)
    138f:	3a 70 28             	cmp    0x28(%eax),%dh
    1392:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1395:	30 29                	xor    %ch,(%ecx)
    1397:	00 76 72             	add    %dh,0x72(%esi)
    139a:	61                   	popa   
    139b:	6d                   	insl   (%dx),%es:(%edi)
    139c:	3a 70 28             	cmp    0x28(%eax),%dh
    139f:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    13a2:	29 00                	sub    %eax,(%eax)
    13a4:	79 73                	jns    1419 <bootmain-0x27ebe7>
    13a6:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
    13ad:	2c 31                	sub    $0x31,%al
    13af:	29 00                	sub    %eax,(%eax)
    13b1:	63 74 6c 3a          	arpl   %si,0x3a(%esp,%ebp,2)
    13b5:	72 28                	jb     13df <bootmain-0x27ec21>
    13b7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    13ba:	31 29                	xor    %ebp,(%ecx)
    13bc:	00 76 72             	add    %dh,0x72(%esi)
    13bf:	61                   	popa   
    13c0:	6d                   	insl   (%dx),%es:(%edi)
    13c1:	3a 72 28             	cmp    0x28(%edx),%dh
    13c4:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    13c7:	29 00                	sub    %eax,(%eax)
    13c9:	78 73                	js     143e <bootmain-0x27ebc2>
    13cb:	69 7a 65 3a 72 28 30 	imul   $0x3028723a,0x65(%edx),%edi
    13d2:	2c 31                	sub    $0x31,%al
    13d4:	29 00                	sub    %eax,(%eax)
    13d6:	79 73                	jns    144b <bootmain-0x27ebb5>
    13d8:	69 7a 65 3a 72 28 30 	imul   $0x3028723a,0x65(%edx),%edi
    13df:	2c 31                	sub    $0x31,%al
    13e1:	29 00                	sub    %eax,(%eax)
    13e3:	73 68                	jae    144d <bootmain-0x27ebb3>
    13e5:	65                   	gs
    13e6:	65                   	gs
    13e7:	74 5f                	je     1448 <bootmain-0x27ebb8>
    13e9:	61                   	popa   
    13ea:	6c                   	insb   (%dx),%es:(%edi)
    13eb:	6c                   	insb   (%dx),%es:(%edi)
    13ec:	6f                   	outsl  %ds:(%esi),(%dx)
    13ed:	63 3a                	arpl   %di,(%edx)
    13ef:	46                   	inc    %esi
    13f0:	28 31                	sub    %dh,(%ecx)
    13f2:	2c 31                	sub    $0x31,%al
    13f4:	33 29                	xor    (%ecx),%ebp
    13f6:	00 63 74             	add    %ah,0x74(%ebx)
    13f9:	6c                   	insb   (%dx),%es:(%edi)
    13fa:	3a 70 28             	cmp    0x28(%eax),%dh
    13fd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1400:	31 29                	xor    %ebp,(%ecx)
    1402:	00 73 68             	add    %dh,0x68(%ebx)
    1405:	74 3a                	je     1441 <bootmain-0x27ebbf>
    1407:	72 28                	jb     1431 <bootmain-0x27ebcf>
    1409:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
    140c:	33 29                	xor    (%ecx),%ebp
    140e:	00 73 68             	add    %dh,0x68(%ebx)
    1411:	65                   	gs
    1412:	65                   	gs
    1413:	74 5f                	je     1474 <bootmain-0x27eb8c>
    1415:	73 65                	jae    147c <bootmain-0x27eb84>
    1417:	74 62                	je     147b <bootmain-0x27eb85>
    1419:	75 66                	jne    1481 <bootmain-0x27eb7f>
    141b:	3a 46 28             	cmp    0x28(%esi),%al
    141e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1421:	38 29                	cmp    %ch,(%ecx)
    1423:	00 73 68             	add    %dh,0x68(%ebx)
    1426:	74 3a                	je     1462 <bootmain-0x27eb9e>
    1428:	70 28                	jo     1452 <bootmain-0x27ebae>
    142a:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
    142d:	33 29                	xor    (%ecx),%ebp
    142f:	00 62 75             	add    %ah,0x75(%edx)
    1432:	66                   	data16
    1433:	3a 70 28             	cmp    0x28(%eax),%dh
    1436:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    1439:	29 00                	sub    %eax,(%eax)
    143b:	63 6f 6c             	arpl   %bp,0x6c(%edi)
    143e:	5f                   	pop    %edi
    143f:	69 6e 76 3a 70 28 30 	imul   $0x3028703a,0x76(%esi),%ebp
    1446:	2c 31                	sub    $0x31,%al
    1448:	29 00                	sub    %eax,(%eax)
    144a:	62 75 66             	bound  %esi,0x66(%ebp)
    144d:	3a 72 28             	cmp    0x28(%edx),%dh
    1450:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
    1453:	29 00                	sub    %eax,(%eax)
    1455:	63 6f 6c             	arpl   %bp,0x6c(%edi)
    1458:	5f                   	pop    %edi
    1459:	69 6e 76 3a 72 28 30 	imul   $0x3028723a,0x76(%esi),%ebp
    1460:	2c 31                	sub    $0x31,%al
    1462:	29 00                	sub    %eax,(%eax)
    1464:	73 68                	jae    14ce <bootmain-0x27eb32>
    1466:	65                   	gs
    1467:	65                   	gs
    1468:	74 5f                	je     14c9 <bootmain-0x27eb37>
    146a:	72 65                	jb     14d1 <bootmain-0x27eb2f>
    146c:	66                   	data16
    146d:	72 65                	jb     14d4 <bootmain-0x27eb2c>
    146f:	73 68                	jae    14d9 <bootmain-0x27eb27>
    1471:	73 75                	jae    14e8 <bootmain-0x27eb18>
    1473:	62 3a                	bound  %edi,(%edx)
    1475:	46                   	inc    %esi
    1476:	28 30                	sub    %dh,(%eax)
    1478:	2c 31                	sub    $0x31,%al
    147a:	38 29                	cmp    %ch,(%ecx)
    147c:	00 76 78             	add    %dh,0x78(%esi)
    147f:	30 3a                	xor    %bh,(%edx)
    1481:	70 28                	jo     14ab <bootmain-0x27eb55>
    1483:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1486:	29 00                	sub    %eax,(%eax)
    1488:	76 79                	jbe    1503 <bootmain-0x27eafd>
    148a:	30 3a                	xor    %bh,(%edx)
    148c:	70 28                	jo     14b6 <bootmain-0x27eb4a>
    148e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1491:	29 00                	sub    %eax,(%eax)
    1493:	76 78                	jbe    150d <bootmain-0x27eaf3>
    1495:	31 3a                	xor    %edi,(%edx)
    1497:	70 28                	jo     14c1 <bootmain-0x27eb3f>
    1499:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    149c:	29 00                	sub    %eax,(%eax)
    149e:	76 79                	jbe    1519 <bootmain-0x27eae7>
    14a0:	31 3a                	xor    %edi,(%edx)
    14a2:	70 28                	jo     14cc <bootmain-0x27eb34>
    14a4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    14a7:	29 00                	sub    %eax,(%eax)
    14a9:	68 3a 72 28 30       	push   $0x3028723a
    14ae:	2c 31                	sub    $0x31,%al
    14b0:	29 00                	sub    %eax,(%eax)
    14b2:	62 78 3a             	bound  %edi,0x3a(%eax)
    14b5:	72 28                	jb     14df <bootmain-0x27eb21>
    14b7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    14ba:	29 00                	sub    %eax,(%eax)
    14bc:	73 68                	jae    1526 <bootmain-0x27eada>
    14be:	65                   	gs
    14bf:	65                   	gs
    14c0:	74 5f                	je     1521 <bootmain-0x27eadf>
    14c2:	75 70                	jne    1534 <bootmain-0x27eacc>
    14c4:	64 6f                	outsl  %fs:(%esi),(%dx)
    14c6:	77 6e                	ja     1536 <bootmain-0x27eaca>
    14c8:	3a 46 28             	cmp    0x28(%esi),%al
    14cb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    14ce:	38 29                	cmp    %ch,(%ecx)
    14d0:	00 68 65             	add    %ch,0x65(%eax)
    14d3:	69 67 68 74 3a 70 28 	imul   $0x28703a74,0x68(%edi),%esp
    14da:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    14dd:	29 00                	sub    %eax,(%eax)
    14df:	68 65 69 67 68       	push   $0x68676965
    14e4:	74 3a                	je     1520 <bootmain-0x27eae0>
    14e6:	72 28                	jb     1510 <bootmain-0x27eaf0>
    14e8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    14eb:	29 00                	sub    %eax,(%eax)
    14ed:	73 68                	jae    1557 <bootmain-0x27eaa9>
    14ef:	65                   	gs
    14f0:	65                   	gs
    14f1:	74 5f                	je     1552 <bootmain-0x27eaae>
    14f3:	72 65                	jb     155a <bootmain-0x27eaa6>
    14f5:	66                   	data16
    14f6:	72 65                	jb     155d <bootmain-0x27eaa3>
    14f8:	73 68                	jae    1562 <bootmain-0x27ea9e>
    14fa:	3a 46 28             	cmp    0x28(%esi),%al
    14fd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1500:	38 29                	cmp    %ch,(%ecx)
    1502:	00 62 78             	add    %ah,0x78(%edx)
    1505:	30 3a                	xor    %bh,(%edx)
    1507:	70 28                	jo     1531 <bootmain-0x27eacf>
    1509:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    150c:	29 00                	sub    %eax,(%eax)
    150e:	62 79 30             	bound  %edi,0x30(%ecx)
    1511:	3a 70 28             	cmp    0x28(%eax),%dh
    1514:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1517:	29 00                	sub    %eax,(%eax)
    1519:	62 78 31             	bound  %edi,0x31(%eax)
    151c:	3a 70 28             	cmp    0x28(%eax),%dh
    151f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1522:	29 00                	sub    %eax,(%eax)
    1524:	62 79 31             	bound  %edi,0x31(%ecx)
    1527:	3a 70 28             	cmp    0x28(%eax),%dh
    152a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    152d:	29 00                	sub    %eax,(%eax)
    152f:	62 79 30             	bound  %edi,0x30(%ecx)
    1532:	3a 72 28             	cmp    0x28(%edx),%dh
    1535:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1538:	29 00                	sub    %eax,(%eax)
    153a:	62 78 31             	bound  %edi,0x31(%eax)
    153d:	3a 72 28             	cmp    0x28(%edx),%dh
    1540:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1543:	29 00                	sub    %eax,(%eax)
    1545:	62 79 31             	bound  %edi,0x31(%ecx)
    1548:	3a 72 28             	cmp    0x28(%edx),%dh
    154b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    154e:	29 00                	sub    %eax,(%eax)
    1550:	73 68                	jae    15ba <bootmain-0x27ea46>
    1552:	65                   	gs
    1553:	65                   	gs
    1554:	74 5f                	je     15b5 <bootmain-0x27ea4b>
    1556:	6d                   	insl   (%dx),%es:(%edi)
    1557:	6f                   	outsl  %ds:(%esi),(%dx)
    1558:	76 65                	jbe    15bf <bootmain-0x27ea41>
    155a:	3a 46 28             	cmp    0x28(%esi),%al
    155d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1560:	38 29                	cmp    %ch,(%ecx)
    1562:	00 6f 6c             	add    %ch,0x6c(%edi)
    1565:	64                   	fs
    1566:	5f                   	pop    %edi
    1567:	76 78                	jbe    15e1 <bootmain-0x27ea1f>
    1569:	30 3a                	xor    %bh,(%edx)
    156b:	72 28                	jb     1595 <bootmain-0x27ea6b>
    156d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1570:	29 00                	sub    %eax,(%eax)
    1572:	6f                   	outsl  %ds:(%esi),(%dx)
    1573:	6c                   	insb   (%dx),%es:(%edi)
    1574:	64                   	fs
    1575:	5f                   	pop    %edi
    1576:	76 79                	jbe    15f1 <bootmain-0x27ea0f>
    1578:	30 3a                	xor    %bh,(%edx)
    157a:	72 28                	jb     15a4 <bootmain-0x27ea5c>
    157c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    157f:	29 00                	sub    %eax,(%eax)
    1581:	76 78                	jbe    15fb <bootmain-0x27ea05>
    1583:	30 3a                	xor    %bh,(%edx)
    1585:	72 28                	jb     15af <bootmain-0x27ea51>
    1587:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    158a:	29 00                	sub    %eax,(%eax)
    158c:	76 79                	jbe    1607 <bootmain-0x27e9f9>
    158e:	30 3a                	xor    %bh,(%edx)
    1590:	72 28                	jb     15ba <bootmain-0x27ea46>
    1592:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1595:	29 00                	sub    %eax,(%eax)
