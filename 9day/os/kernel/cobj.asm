
cobj.out:     file format elf32-i386


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
  280006:	81 ec 08 02 00 00    	sub    $0x208,%esp

struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
  clear_screen(40);   	//red
  28000c:	6a 28                	push   $0x28
  28000e:	e8 4a 03 00 00       	call   28035d <clear_screen>
  init_screen((struct boot_info * )bootp);
  280013:	c7 04 24 f0 0f 00 00 	movl   $0xff0,(%esp)
  28001a:	e8 90 05 00 00       	call   2805af <init_screen>
  init_palette();  //color table from 0 to 15
  28001f:	e8 a2 03 00 00       	call   2803c6 <init_palette>
  draw_window();
  280024:	e8 25 04 00 00       	call   28044e <draw_window>
int mx,my;//mouse position
mx=30;
my=30;
//display mouse logo
char mousepic[16*16];     //mouse logo buffer
init_mouse(mousepic,7);	//7　means background color:white
  280029:	59                   	pop    %ecx
  28002a:	5b                   	pop    %ebx
  28002b:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  280031:	6a 07                	push   $0x7
  280033:	53                   	push   %ebx
  280034:	e8 95 05 00 00       	call   2805ce <init_mouse>
display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);
  280039:	6a 10                	push   $0x10
  28003b:	53                   	push   %ebx
  28003c:	6a 1e                	push   $0x1e
  28003e:	6a 1e                	push   $0x1e
  280040:	6a 10                	push   $0x10
  280042:	6a 10                	push   $0x10
  280044:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  28004b:	50                   	push   %eax
  28004c:	ff 35 f8 0f 00 00    	pushl  0xff8
  280052:	e8 c7 05 00 00       	call   28061e <display_mouse>

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280057:	fa                   	cli    
cli();

//set gdt idt
init_gdtidt();
  280058:	83 c4 30             	add    $0x30,%esp
  28005b:	e8 71 09 00 00       	call   2809d1 <init_gdtidt>

//remap irq 0-15
init_pic();		//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
  280060:	e8 cc 0a 00 00       	call   280b31 <init_pic>
unsigned char s[40];		//sprintf buffer
unsigned char keybuf[32];	//keyfifo
unsigned char mousebuf[128];	//mousefifo
unsigned char data;		//temp variable to get fifo data
int count=0;
fifo8_init(&keyfifo ,32,keybuf);//keyfifo是一个global data defined in int.c
  280065:	8d 85 20 fe ff ff    	lea    -0x1e0(%ebp),%eax
  28006b:	56                   	push   %esi
  28006c:	50                   	push   %eax
  28006d:	6a 20                	push   $0x20
  28006f:	68 bc 30 28 00       	push   $0x2830bc
  280074:	e8 c3 0b 00 00       	call   280c3c <fifo8_init>
fifo8_init(&mousefifo,128,mousebuf);
  280079:	83 c4 0c             	add    $0xc,%esp
  28007c:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  280082:	50                   	push   %eax
  280083:	68 80 00 00 00       	push   $0x80
  280088:	68 d4 30 28 00       	push   $0x2830d4
  28008d:	e8 aa 0b 00 00       	call   280c3c <fifo8_init>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280092:	ba 21 00 00 00       	mov    $0x21,%edx
  280097:	b0 f9                	mov    $0xf9,%al
  280099:	ee                   	out    %al,(%dx)
  28009a:	b0 ef                	mov    $0xef,%al
  28009c:	b2 a1                	mov    $0xa1,%dl
  28009e:	ee                   	out    %al,(%dx)
//enable keyboard and mouse
outb(PIC0_IMR, 0xf9);	//1111 1001  irq 1 2打开 因为keyboard是irq 1 /// enable pic slave and keyboard interrupt
outb(PIC1_IMR, 0xef);	//1110 1111  irq 12打开　mouse是irq 12  所以要把pic 1 pic 2的芯片中断响应位打开。 //enable mouse interrupt

//初始化　鼠标按键控制电路
init_keyboard();
  28009f:	e8 23 0b 00 00       	call   280bc7 <init_keyboard>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  2800a4:	fb                   	sti    


//day8

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt
  2800a5:	8d 85 10 fe ff ff    	lea    -0x1f0(%ebp),%eax
  2800ab:	89 04 24             	mov    %eax,(%esp)
  2800ae:	e8 35 0c 00 00       	call   280ce8 <enable_mouse>

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
  2800b3:	5f                   	pop    %edi
  2800b4:	58                   	pop    %eax
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800b5:	8d bd 40 fe ff ff    	lea    -0x1c0(%ebp),%edi

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
  2800bb:	6a ff                	push   $0xffffffff
  2800bd:	68 00 00 40 00       	push   $0x400000
  2800c2:	e8 12 0d 00 00       	call   280dd9 <memtest>
//mem=mem>>20;
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  2800c7:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)

struct MOUSE_DEC mdec;
enable_mouse(&mdec); //这里会产生一个mouse interrupt

unsigned int memtotal;
memtotal=memtest(0x400000,0xffffffff);
  2800ce:	89 c3                	mov    %eax,%ebx
//mem=mem>>20;
//sprintf(s,"memory:%dMbytes",mem);
//puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
Memman * memman=(Memman *)0x3c0000;
memman_init(memman);
  2800d0:	e8 52 0d 00 00       	call   280e27 <memman_init>
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
  2800d5:	83 c4 0c             	add    $0xc,%esp
  2800d8:	8d 83 00 00 c0 ff    	lea    -0x400000(%ebx),%eax
  2800de:	50                   	push   %eax
  2800df:	68 00 00 40 00       	push   $0x400000
  2800e4:	68 00 00 3c 00       	push   $0x3c0000
  2800e9:	e8 d2 0d 00 00       	call   280ec0 <memman_free>
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  2800ee:	8b 35 00 00 3c 00    	mov    0x3c0000,%esi
  2800f4:	c1 eb 14             	shr    $0x14,%ebx
,memman_avail(memman)>>20,memman->cellnum);
  2800f7:	c7 04 24 00 00 3c 00 	movl   $0x3c0000,(%esp)
  2800fe:	e8 47 0d 00 00       	call   280e4a <memman_avail>
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  280103:	89 34 24             	mov    %esi,(%esp)
  init_palette();  //color table from 0 to 15
  draw_window();

int mx,my;//mouse position
mx=30;
my=30;
  280106:	be 1e 00 00 00       	mov    $0x1e,%esi
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  28010b:	c1 e8 14             	shr    $0x14,%eax
  28010e:	50                   	push   %eax
  28010f:	53                   	push   %ebx
  init_screen((struct boot_info * )bootp);
  init_palette();  //color table from 0 to 15
  draw_window();

int mx,my;//mouse position
mx=30;
  280110:	bb 1e 00 00 00       	mov    $0x1e,%ebx
memman_init(memman);
//memman_free(memman,0x1000,0x9e000);
memman_free(memman,0x400000,memtotal-0x400000);
//memman_free(memman,0x600000,0x400000);
//memman_free(memman,0xb00000,0x400000);
sprintf(s,"memory:%dMB,free:%dMB,%d",memtotal>>20
  280115:	68 ac 2a 28 00       	push   $0x282aac
  28011a:	57                   	push   %edi
  28011b:	e8 fb 05 00 00       	call   28071b <sprintf>
,memman_avail(memman)>>20,memman->cellnum);
puts8((char *)bootp->vram ,bootp->xsize,0,100,0,s);
  280120:	83 c4 18             	add    $0x18,%esp
  280123:	57                   	push   %edi
  280124:	6a 00                	push   $0x0
  280126:	6a 64                	push   $0x64
  280128:	6a 00                	push   $0x0
  28012a:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280131:	50                   	push   %eax
  280132:	ff 35 f8 0f 00 00    	pushl  0xff8
  280138:	e8 d9 06 00 00       	call   280816 <puts8>
  28013d:	83 c4 20             	add    $0x20,%esp

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280140:	fa                   	cli    

 while(1)
 {
   cli();//disable cpu interrupt

   if(fifo8_status(&keyfifo) +fifo8_status(&mousefifo) == 0)//no data in keyfifo and mousefifo
  280141:	83 ec 0c             	sub    $0xc,%esp
  280144:	68 bc 30 28 00       	push   $0x2830bc
  280149:	e8 8c 0b 00 00       	call   280cda <fifo8_status>
  28014e:	c7 04 24 d4 30 28 00 	movl   $0x2830d4,(%esp)
  280155:	89 85 04 fe ff ff    	mov    %eax,-0x1fc(%ebp)
  28015b:	e8 7a 0b 00 00       	call   280cda <fifo8_status>
  280160:	83 c4 10             	add    $0x10,%esp
  280163:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  280169:	85 c0                	test   %eax,%eax
  28016b:	75 04                	jne    280171 <bootmain+0x171>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  28016d:	fb                   	sti    

static __inline void
hlt(void)
{

	__asm __volatile("hlt");
  28016e:	f4                   	hlt    
  28016f:	eb cf                	jmp    280140 <bootmain+0x140>
    sti();
    hlt();
   }
   else
   {
      if(fifo8_status(&keyfifo) != 0)
  280171:	83 ec 0c             	sub    $0xc,%esp
  280174:	68 bc 30 28 00       	push   $0x2830bc
  280179:	e8 5c 0b 00 00       	call   280cda <fifo8_status>
  28017e:	83 c4 10             	add    $0x10,%esp
  280181:	85 c0                	test   %eax,%eax
  280183:	74 63                	je     2801e8 <bootmain+0x1e8>
      {

	data=fifo8_read(&keyfifo);
  280185:	83 ec 0c             	sub    $0xc,%esp
  280188:	68 bc 30 28 00       	push   $0x2830bc
  28018d:	e8 13 0b 00 00       	call   280ca5 <fifo8_read>
  280192:	89 85 04 fe ff ff    	mov    %eax,-0x1fc(%ebp)

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280198:	fb                   	sti    
	sti();

	boxfill(0,0,0,13*8-1,15);//一个黑色的小box
  280199:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  2801a0:	6a 67                	push   $0x67
  2801a2:	6a 00                	push   $0x0
  2801a4:	6a 00                	push   $0x0
  2801a6:	6a 00                	push   $0x0
  2801a8:	e8 79 02 00 00       	call   280426 <boxfill>
	sprintf(s,"%d key:%x",count,data);
  2801ad:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  2801b3:	83 c4 20             	add    $0x20,%esp
  2801b6:	0f b6 c0             	movzbl %al,%eax
  2801b9:	50                   	push   %eax
  2801ba:	6a 00                	push   $0x0
  2801bc:	68 c5 2a 28 00       	push   $0x282ac5
  2801c1:	57                   	push   %edi
  2801c2:	e8 54 05 00 00       	call   28071b <sprintf>
	puts8((char *)bootp->vram ,bootp->xsize,0,0,7,s);//display e0
  2801c7:	58                   	pop    %eax
  2801c8:	5a                   	pop    %edx
  2801c9:	57                   	push   %edi
  2801ca:	6a 07                	push   $0x7
  2801cc:	6a 00                	push   $0x0
  2801ce:	6a 00                	push   $0x0
  2801d0:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2801d7:	50                   	push   %eax
  2801d8:	ff 35 f8 0f 00 00    	pushl  0xff8
  2801de:	e8 33 06 00 00       	call   280816 <puts8>
  2801e3:	e9 6d 01 00 00       	jmp    280355 <bootmain+0x355>
	// hlt();//这个hlt()和上面的count变量是观察右ctrl发生了几次中断。
      }
      else if(fifo8_status(&mousefifo) != 0)//we have mouse interrupt data to process
  2801e8:	83 ec 0c             	sub    $0xc,%esp
  2801eb:	68 d4 30 28 00       	push   $0x2830d4
  2801f0:	e8 e5 0a 00 00       	call   280cda <fifo8_status>
  2801f5:	83 c4 10             	add    $0x10,%esp
  2801f8:	85 c0                	test   %eax,%eax
  2801fa:	0f 84 40 ff ff ff    	je     280140 <bootmain+0x140>
      {
	data=fifo8_read(&mousefifo);
  280200:	83 ec 0c             	sub    $0xc,%esp
  280203:	68 d4 30 28 00       	push   $0x2830d4
  280208:	e8 98 0a 00 00       	call   280ca5 <fifo8_read>
  28020d:	fb                   	sti    
	sti();

	if(mouse_decode(&mdec,data))
  28020e:	5a                   	pop    %edx
  28020f:	0f b6 c0             	movzbl %al,%eax
  280212:	59                   	pop    %ecx
  280213:	50                   	push   %eax
  280214:	8d 85 10 fe ff ff    	lea    -0x1f0(%ebp),%eax
  28021a:	50                   	push   %eax
  28021b:	e8 f1 0a 00 00       	call   280d11 <mouse_decode>
  280220:	83 c4 10             	add    $0x10,%esp
  280223:	85 c0                	test   %eax,%eax
  280225:	0f 84 15 ff ff ff    	je     280140 <bootmain+0x140>
	{
	      //3个字节都得到了
	      sprintf(s,"[lmr:%d %d]",mdec.x,mdec.y);
  28022b:	ff b5 18 fe ff ff    	pushl  -0x1e8(%ebp)
  280231:	ff b5 14 fe ff ff    	pushl  -0x1ec(%ebp)
  280237:	68 cf 2a 28 00       	push   $0x282acf
  28023c:	57                   	push   %edi
  28023d:	e8 d9 04 00 00       	call   28071b <sprintf>
	      switch (mdec.button)
  280242:	8b 85 1c fe ff ff    	mov    -0x1e4(%ebp),%eax
  280248:	83 c4 10             	add    $0x10,%esp
  28024b:	83 f8 02             	cmp    $0x2,%eax
  28024e:	74 11                	je     280261 <bootmain+0x261>
  280250:	83 f8 04             	cmp    $0x4,%eax
  280253:	74 15                	je     28026a <bootmain+0x26a>
  280255:	48                   	dec    %eax
  280256:	75 19                	jne    280271 <bootmain+0x271>
	      {
		case 1:s[1]='L';break;
  280258:	c6 85 41 fe ff ff 4c 	movb   $0x4c,-0x1bf(%ebp)
  28025f:	eb 10                	jmp    280271 <bootmain+0x271>
		case 2:s[3]='R';break;
  280261:	c6 85 43 fe ff ff 52 	movb   $0x52,-0x1bd(%ebp)
  280268:	eb 07                	jmp    280271 <bootmain+0x271>
		case 4:s[2]='M';break;
  28026a:	c6 85 42 fe ff ff 4d 	movb   $0x4d,-0x1be(%ebp)

	      }
	      boxfill(0,32,16,32+20*8-1,31);//一个黑色的小box
  280271:	83 ec 0c             	sub    $0xc,%esp
  280274:	6a 1f                	push   $0x1f
  280276:	68 bf 00 00 00       	push   $0xbf
  28027b:	6a 10                	push   $0x10
  28027d:	6a 20                	push   $0x20
  28027f:	6a 00                	push   $0x0
  280281:	e8 a0 01 00 00       	call   280426 <boxfill>
	      puts8((char *)bootp->vram ,bootp->xsize,32,16,7,s);//display e0
  280286:	83 c4 18             	add    $0x18,%esp
  280289:	57                   	push   %edi
  28028a:	6a 07                	push   $0x7
  28028c:	6a 10                	push   $0x10
  28028e:	6a 20                	push   $0x20
  280290:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280297:	50                   	push   %eax
  280298:	ff 35 f8 0f 00 00    	pushl  0xff8
  28029e:	e8 73 05 00 00       	call   280816 <puts8>
    #define white 7
	      boxfill(white,mx,my,mx+15,my+15);//用背景色把鼠标原来的color填充，这样不会看到鼠标移动的path
  2802a3:	83 c4 14             	add    $0x14,%esp
  2802a6:	8d 46 0f             	lea    0xf(%esi),%eax
  2802a9:	50                   	push   %eax
  2802aa:	8d 43 0f             	lea    0xf(%ebx),%eax
  2802ad:	50                   	push   %eax
  2802ae:	56                   	push   %esi
  2802af:	53                   	push   %ebx
  2802b0:	6a 07                	push   $0x7
  2802b2:	e8 6f 01 00 00       	call   280426 <boxfill>
  2802b7:	83 c4 20             	add    $0x20,%esp
  2802ba:	31 c0                	xor    %eax,%eax
  2802bc:	03 9d 14 fe ff ff    	add    -0x1ec(%ebp),%ebx
  2802c2:	0f 48 d8             	cmovs  %eax,%ebx
  2802c5:	03 b5 18 fe ff ff    	add    -0x1e8(%ebp),%esi
  2802cb:	0f 48 f0             	cmovs  %eax,%esi
	      {
		my=0;
	      }


	      if(mx>bootp->xsize-16)
  2802ce:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2802d5:	8d 50 f1             	lea    -0xf(%eax),%edx
	      {
		mx=bootp->xsize-16;
  2802d8:	83 e8 10             	sub    $0x10,%eax
  2802db:	39 da                	cmp    %ebx,%edx
  2802dd:	0f 4e d8             	cmovle %eax,%ebx
	      }

	      if(my>bootp->ysize-16)
  2802e0:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
  2802e7:	8d 50 f1             	lea    -0xf(%eax),%edx
	      {
		my=bootp->ysize-16;
  2802ea:	83 e8 10             	sub    $0x10,%eax
  2802ed:	39 f2                	cmp    %esi,%edx
  2802ef:	0f 4e f0             	cmovle %eax,%esi
	      }
	      sprintf(s,"(%d, %d)",mx,my);
  2802f2:	56                   	push   %esi
  2802f3:	53                   	push   %ebx
  2802f4:	68 db 2a 28 00       	push   $0x282adb
  2802f9:	57                   	push   %edi
  2802fa:	e8 1c 04 00 00       	call   28071b <sprintf>
	      boxfill(0,0,0,79,15);//坐标的背景色
  2802ff:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  280306:	6a 4f                	push   $0x4f
  280308:	6a 00                	push   $0x0
  28030a:	6a 00                	push   $0x0
  28030c:	6a 00                	push   $0x0
  28030e:	e8 13 01 00 00       	call   280426 <boxfill>
	      puts8((char *)bootp->vram ,bootp->xsize,0,0,7,s);//显示坐标
  280313:	83 c4 18             	add    $0x18,%esp
  280316:	57                   	push   %edi
  280317:	6a 07                	push   $0x7
  280319:	6a 00                	push   $0x0
  28031b:	6a 00                	push   $0x0
  28031d:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280324:	50                   	push   %eax
  280325:	ff 35 f8 0f 00 00    	pushl  0xff8
  28032b:	e8 e6 04 00 00       	call   280816 <puts8>


	      display_mouse(bootp->vram,bootp->xsize,16,16,mx,my,mousepic,16);//根据新的mx,my重绘屏幕鼠标指针
  280330:	83 c4 20             	add    $0x20,%esp
  280333:	6a 10                	push   $0x10
  280335:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  28033b:	50                   	push   %eax
  28033c:	56                   	push   %esi
  28033d:	53                   	push   %ebx
  28033e:	6a 10                	push   $0x10
  280340:	6a 10                	push   $0x10
  280342:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  280349:	50                   	push   %eax
  28034a:	ff 35 f8 0f 00 00    	pushl  0xff8
  280350:	e8 c9 02 00 00       	call   28061e <display_mouse>
  280355:	83 c4 20             	add    $0x20,%esp
  280358:	e9 e3 fd ff ff       	jmp    280140 <bootmain+0x140>

0028035d <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
  28035d:	55                   	push   %ebp
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  28035e:	b8 00 00 0a 00       	mov    $0xa0000,%eax
#include<header.h>

void clear_screen(char color) //15:pure white
{
  280363:	89 e5                	mov    %esp,%ebp
  280365:	8a 55 08             	mov    0x8(%ebp),%dl
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  280368:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  28036a:	40                   	inc    %eax
  28036b:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280370:	75 f6                	jne    280368 <clear_screen+0xb>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280372:	5d                   	pop    %ebp
  280373:	c3                   	ret    

00280374 <color_screen>:

void color_screen(char color) //15:pure white
{
  280374:	55                   	push   %ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  280375:	b8 00 00 0a 00       	mov    $0xa0000,%eax

  }
}

void color_screen(char color) //15:pure white
{
  28037a:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  28037c:	88 00                	mov    %al,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  28037e:	40                   	inc    %eax
  28037f:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  280384:	75 f6                	jne    28037c <color_screen+0x8>
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  280386:	5d                   	pop    %ebp
  280387:	c3                   	ret    

00280388 <set_palette>:
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  280388:	55                   	push   %ebp
  280389:	89 e5                	mov    %esp,%ebp
  28038b:	56                   	push   %esi
  28038c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  28038f:	53                   	push   %ebx
  280390:	8b 5d 08             	mov    0x8(%ebp),%ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  280393:	9c                   	pushf  
  280394:	5e                   	pop    %esi

static __inline void
cli(void)
{

	__asm __volatile("cli");
  280395:	fa                   	cli    
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280396:	ba c8 03 00 00       	mov    $0x3c8,%edx

  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  28039b:	0f b6 c3             	movzbl %bl,%eax
  28039e:	ee                   	out    %al,(%dx)
  28039f:	b2 c9                	mov    $0xc9,%dl
  for(i=start;i<=end;i++)
  2803a1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  2803a4:	7f 1a                	jg     2803c0 <set_palette+0x38>
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
  2803a6:	8a 01                	mov    (%ecx),%al
  2803a8:	c0 e8 02             	shr    $0x2,%al
  2803ab:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+1)/4);
  2803ac:	8a 41 01             	mov    0x1(%ecx),%al
  2803af:	c0 e8 02             	shr    $0x2,%al
  2803b2:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+2)/4);
  2803b3:	8a 41 02             	mov    0x2(%ecx),%al
  2803b6:	c0 e8 02             	shr    $0x2,%al
  2803b9:	ee                   	out    %al,(%dx)
    rgb=rgb+3;
  2803ba:	83 c1 03             	add    $0x3,%ecx
  cli(); // disable interrupt
  //为什么写port 0x03c8

  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  2803bd:	43                   	inc    %ebx
  2803be:	eb e1                	jmp    2803a1 <set_palette+0x19>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  2803c0:	56                   	push   %esi
  2803c1:	9d                   	popf   
  }

write_eflags(eflag);  //恢复从前的cpsr
  return;

}
  2803c2:	5b                   	pop    %ebx
  2803c3:	5e                   	pop    %esi
  2803c4:	5d                   	pop    %ebp
  2803c5:	c3                   	ret    

002803c6 <init_palette>:
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  2803c6:	55                   	push   %ebp
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  2803c7:	b9 0c 00 00 00       	mov    $0xc,%ecx
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  2803cc:	89 e5                	mov    %esp,%ebp
  2803ce:	57                   	push   %edi
  2803cf:	56                   	push   %esi
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  2803d0:	be 7c 29 28 00       	mov    $0x28297c,%esi
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  2803d5:	83 ec 30             	sub    $0x30,%esp
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  2803d8:	8d 45 c8             	lea    -0x38(%ebp),%eax
//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  2803db:	8d 7d c8             	lea    -0x38(%ebp),%edi
  2803de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  2803e0:	50                   	push   %eax
  2803e1:	68 ff 00 00 00       	push   $0xff
  2803e6:	6a 00                	push   $0x0
  2803e8:	e8 9b ff ff ff       	call   280388 <set_palette>
  2803ed:	83 c4 0c             	add    $0xc,%esp
}
  2803f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  2803f3:	5e                   	pop    %esi
  2803f4:	5f                   	pop    %edi
  2803f5:	5d                   	pop    %ebp
  2803f6:	c3                   	ret    

002803f7 <boxfill8>:
  return;

}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
  2803f7:	55                   	push   %ebp
  2803f8:	89 e5                	mov    %esp,%ebp
  2803fa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  2803fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  280400:	53                   	push   %ebx
  280401:	8a 5d 10             	mov    0x10(%ebp),%bl
  280404:	0f af c1             	imul   %ecx,%eax
  280407:	03 45 08             	add    0x8(%ebp),%eax
 int x,y;
 for(y=y0;y<=y1;y++)
  28040a:	3b 4d 20             	cmp    0x20(%ebp),%ecx
  28040d:	7f 14                	jg     280423 <boxfill8+0x2c>
  28040f:	8b 55 14             	mov    0x14(%ebp),%edx
 {
   for(x=x0;x<=x1;x++)
  280412:	3b 55 1c             	cmp    0x1c(%ebp),%edx
  280415:	7f 06                	jg     28041d <boxfill8+0x26>
   {
      vram[y*xsize+x]=color;
  280417:	88 1c 10             	mov    %bl,(%eax,%edx,1)
void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
  28041a:	42                   	inc    %edx
  28041b:	eb f5                	jmp    280412 <boxfill8+0x1b>
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
  28041d:	41                   	inc    %ecx
  28041e:	03 45 0c             	add    0xc(%ebp),%eax
  280421:	eb e7                	jmp    28040a <boxfill8+0x13>
   {
      vram[y*xsize+x]=color;
   }
 }

}
  280423:	5b                   	pop    %ebx
  280424:	5d                   	pop    %ebp
  280425:	c3                   	ret    

00280426 <boxfill>:
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  280426:	55                   	push   %ebp
  280427:	89 e5                	mov    %esp,%ebp
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
  280429:	ff 75 18             	pushl  0x18(%ebp)
  28042c:	ff 75 14             	pushl  0x14(%ebp)
  28042f:	ff 75 10             	pushl  0x10(%ebp)
  280432:	ff 75 0c             	pushl  0xc(%ebp)
  280435:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  280439:	50                   	push   %eax
  28043a:	68 40 01 00 00       	push   $0x140
  28043f:	68 00 00 0a 00       	push   $0xa0000
  280444:	e8 ae ff ff ff       	call   2803f7 <boxfill8>
  280449:	83 c4 1c             	add    $0x1c,%esp
}
  28044c:	c9                   	leave  
  28044d:	c3                   	ret    

0028044e <draw_window>:

void draw_window()
{
  28044e:	55                   	push   %ebp
  28044f:	89 e5                	mov    %esp,%ebp
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);

    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
  280451:	68 ab 00 00 00       	push   $0xab
  280456:	68 3f 01 00 00       	push   $0x13f
  28045b:	6a 00                	push   $0x0
  28045d:	6a 00                	push   $0x0
  28045f:	6a 07                	push   $0x7
  280461:	e8 c0 ff ff ff       	call   280426 <boxfill>
//task button
    boxfill(8  ,0, y-28,x-1,y-28);
  280466:	68 ac 00 00 00       	push   $0xac
  28046b:	68 3f 01 00 00       	push   $0x13f
  280470:	68 ac 00 00 00       	push   $0xac
  280475:	6a 00                	push   $0x0
  280477:	6a 08                	push   $0x8
  280479:	e8 a8 ff ff ff       	call   280426 <boxfill>
    boxfill(7  ,0, y-27,x-1,y-27);
  28047e:	83 c4 28             	add    $0x28,%esp
  280481:	68 ad 00 00 00       	push   $0xad
  280486:	68 3f 01 00 00       	push   $0x13f
  28048b:	68 ad 00 00 00       	push   $0xad
  280490:	6a 00                	push   $0x0
  280492:	6a 07                	push   $0x7
  280494:	e8 8d ff ff ff       	call   280426 <boxfill>
    boxfill(8  ,0, y-26,x-1,y-1);
  280499:	68 c7 00 00 00       	push   $0xc7
  28049e:	68 3f 01 00 00       	push   $0x13f
  2804a3:	68 ae 00 00 00       	push   $0xae
  2804a8:	6a 00                	push   $0x0
  2804aa:	6a 08                	push   $0x8
  2804ac:	e8 75 ff ff ff       	call   280426 <boxfill>


//left button
    boxfill(7, 3,  y-24, 59,  y-24);
  2804b1:	83 c4 28             	add    $0x28,%esp
  2804b4:	68 b0 00 00 00       	push   $0xb0
  2804b9:	6a 3b                	push   $0x3b
  2804bb:	68 b0 00 00 00       	push   $0xb0
  2804c0:	6a 03                	push   $0x3
  2804c2:	6a 07                	push   $0x7
  2804c4:	e8 5d ff ff ff       	call   280426 <boxfill>
    boxfill(7, 2,  y-24, 2 ,  y-4);
  2804c9:	68 c4 00 00 00       	push   $0xc4
  2804ce:	6a 02                	push   $0x2
  2804d0:	68 b0 00 00 00       	push   $0xb0
  2804d5:	6a 02                	push   $0x2
  2804d7:	6a 07                	push   $0x7
  2804d9:	e8 48 ff ff ff       	call   280426 <boxfill>
    boxfill(15, 3,  y-4,  59,  y-4);
  2804de:	83 c4 28             	add    $0x28,%esp
  2804e1:	68 c4 00 00 00       	push   $0xc4
  2804e6:	6a 3b                	push   $0x3b
  2804e8:	68 c4 00 00 00       	push   $0xc4
  2804ed:	6a 03                	push   $0x3
  2804ef:	6a 0f                	push   $0xf
  2804f1:	e8 30 ff ff ff       	call   280426 <boxfill>
    boxfill(15, 59, y-23, 59,  y-5);
  2804f6:	68 c3 00 00 00       	push   $0xc3
  2804fb:	6a 3b                	push   $0x3b
  2804fd:	68 b1 00 00 00       	push   $0xb1
  280502:	6a 3b                	push   $0x3b
  280504:	6a 0f                	push   $0xf
  280506:	e8 1b ff ff ff       	call   280426 <boxfill>
    boxfill(0, 2,  y-3,  59,  y-3);
  28050b:	83 c4 28             	add    $0x28,%esp
  28050e:	68 c5 00 00 00       	push   $0xc5
  280513:	6a 3b                	push   $0x3b
  280515:	68 c5 00 00 00       	push   $0xc5
  28051a:	6a 02                	push   $0x2
  28051c:	6a 00                	push   $0x0
  28051e:	e8 03 ff ff ff       	call   280426 <boxfill>
    boxfill(0, 60, y-24, 60,  y-3);
  280523:	68 c5 00 00 00       	push   $0xc5
  280528:	6a 3c                	push   $0x3c
  28052a:	68 b0 00 00 00       	push   $0xb0
  28052f:	6a 3c                	push   $0x3c
  280531:	6a 00                	push   $0x0
  280533:	e8 ee fe ff ff       	call   280426 <boxfill>

//
//right button
    boxfill(15, x-47, y-24,x-4,y-24);
  280538:	83 c4 28             	add    $0x28,%esp
  28053b:	68 b0 00 00 00       	push   $0xb0
  280540:	68 3c 01 00 00       	push   $0x13c
  280545:	68 b0 00 00 00       	push   $0xb0
  28054a:	68 11 01 00 00       	push   $0x111
  28054f:	6a 0f                	push   $0xf
  280551:	e8 d0 fe ff ff       	call   280426 <boxfill>
    boxfill(15, x-47, y-23,x-47,y-4);
  280556:	68 c4 00 00 00       	push   $0xc4
  28055b:	68 11 01 00 00       	push   $0x111
  280560:	68 b1 00 00 00       	push   $0xb1
  280565:	68 11 01 00 00       	push   $0x111
  28056a:	6a 0f                	push   $0xf
  28056c:	e8 b5 fe ff ff       	call   280426 <boxfill>
    boxfill(7, x-47, y-3,x-4,y-3);
  280571:	83 c4 28             	add    $0x28,%esp
  280574:	68 c5 00 00 00       	push   $0xc5
  280579:	68 3c 01 00 00       	push   $0x13c
  28057e:	68 c5 00 00 00       	push   $0xc5
  280583:	68 11 01 00 00       	push   $0x111
  280588:	6a 07                	push   $0x7
  28058a:	e8 97 fe ff ff       	call   280426 <boxfill>
    boxfill(7, x-3, y-24,x-3,y-3);
  28058f:	68 c5 00 00 00       	push   $0xc5
  280594:	68 3d 01 00 00       	push   $0x13d
  280599:	68 b0 00 00 00       	push   $0xb0
  28059e:	68 3d 01 00 00       	push   $0x13d
  2805a3:	6a 07                	push   $0x7
  2805a5:	e8 7c fe ff ff       	call   280426 <boxfill>
  2805aa:	83 c4 28             	add    $0x28,%esp
}
  2805ad:	c9                   	leave  
  2805ae:	c3                   	ret    

002805af <init_screen>:


void init_screen(struct boot_info * bootp)
{
  2805af:	55                   	push   %ebp
  2805b0:	89 e5                	mov    %esp,%ebp
  2805b2:	8b 45 08             	mov    0x8(%ebp),%eax
  bootp->vram=(char *)VRAM;
  2805b5:	c7 40 08 00 00 0a 00 	movl   $0xa0000,0x8(%eax)
  bootp->color_mode=8;
  2805bc:	c6 40 02 08          	movb   $0x8,0x2(%eax)
  bootp->xsize=320;
  2805c0:	66 c7 40 04 40 01    	movw   $0x140,0x4(%eax)
  bootp->ysize=200;
  2805c6:	66 c7 40 06 c8 00    	movw   $0xc8,0x6(%eax)

}
  2805cc:	5d                   	pop    %ebp
  2805cd:	c3                   	ret    

002805ce <init_mouse>:

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
  2805ce:	55                   	push   %ebp
  2805cf:	31 c9                	xor    %ecx,%ecx
  2805d1:	89 e5                	mov    %esp,%ebp
  2805d3:	8a 45 0c             	mov    0xc(%ebp),%al
  2805d6:	8b 55 08             	mov    0x8(%ebp),%edx
  2805d9:	56                   	push   %esi
  2805da:	53                   	push   %ebx
  2805db:	89 c6                	mov    %eax,%esi
  2805dd:	31 c0                	xor    %eax,%eax
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
  2805df:	8a 9c 01 ac 29 28 00 	mov    0x2829ac(%ecx,%eax,1),%bl
  2805e6:	80 fb 2e             	cmp    $0x2e,%bl
  2805e9:	74 10                	je     2805fb <init_mouse+0x2d>
  2805eb:	80 fb 4f             	cmp    $0x4f,%bl
  2805ee:	74 12                	je     280602 <init_mouse+0x34>
  2805f0:	80 fb 2a             	cmp    $0x2a,%bl
  2805f3:	75 11                	jne    280606 <init_mouse+0x38>
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
  2805f5:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
  2805f9:	eb 0b                	jmp    280606 <init_mouse+0x38>
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
  2805fb:	89 f3                	mov    %esi,%ebx
  2805fd:	88 1c 02             	mov    %bl,(%edx,%eax,1)
  280600:	eb 04                	jmp    280606 <init_mouse+0x38>
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside
  280602:	c6 04 02 02          	movb   $0x2,(%edx,%eax,1)
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
  280606:	40                   	inc    %eax
  280607:	83 f8 10             	cmp    $0x10,%eax
  28060a:	75 d3                	jne    2805df <init_mouse+0x11>
  28060c:	83 c1 10             	add    $0x10,%ecx
  28060f:	83 c2 10             	add    $0x10,%edx
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
  280612:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  280618:	75 c3                	jne    2805dd <init_mouse+0xf>

	  }

	}

}
  28061a:	5b                   	pop    %ebx
  28061b:	5e                   	pop    %esi
  28061c:	5d                   	pop    %ebp
  28061d:	c3                   	ret    

0028061e <display_mouse>:

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  28061e:	55                   	push   %ebp
  28061f:	89 e5                	mov    %esp,%ebp
  280621:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280624:	56                   	push   %esi
  int x,y;
  for(y=0;y<pysize;y++)
  280625:	31 f6                	xor    %esi,%esi
	}

}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280627:	53                   	push   %ebx
  280628:	8b 5d 20             	mov    0x20(%ebp),%ebx
  28062b:	0f af 45 0c          	imul   0xc(%ebp),%eax
  28062f:	03 45 18             	add    0x18(%ebp),%eax
  280632:	03 45 08             	add    0x8(%ebp),%eax
  int x,y;
  for(y=0;y<pysize;y++)
  280635:	3b 75 14             	cmp    0x14(%ebp),%esi
  280638:	7d 19                	jge    280653 <display_mouse+0x35>
  28063a:	31 d2                	xor    %edx,%edx
  {
    for(x=0;x<pxsize;x++)
  28063c:	3b 55 10             	cmp    0x10(%ebp),%edx
  28063f:	7d 09                	jge    28064a <display_mouse+0x2c>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
  280641:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  280644:	88 0c 10             	mov    %cl,(%eax,%edx,1)
void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
  280647:	42                   	inc    %edx
  280648:	eb f2                	jmp    28063c <display_mouse+0x1e>
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  28064a:	46                   	inc    %esi
  28064b:	03 5d 24             	add    0x24(%ebp),%ebx
  28064e:	03 45 0c             	add    0xc(%ebp),%eax
  280651:	eb e2                	jmp    280635 <display_mouse+0x17>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }

}
  280653:	5b                   	pop    %ebx
  280654:	5e                   	pop    %esi
  280655:	5d                   	pop    %ebp
  280656:	c3                   	ret    

00280657 <itoa>:
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  280657:	55                   	push   %ebp
    char tmp_buf[10] = {0};
  280658:	31 c0                	xor    %eax,%eax
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  28065a:	89 e5                	mov    %esp,%ebp
    char tmp_buf[10] = {0};
  28065c:	b9 0a 00 00 00       	mov    $0xa,%ecx
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  280661:	57                   	push   %edi
  280662:	56                   	push   %esi
  280663:	53                   	push   %ebx
  280664:	83 ec 10             	sub    $0x10,%esp
  280667:	8b 55 08             	mov    0x8(%ebp),%edx
    char tmp_buf[10] = {0};
  28066a:	8d 7d ea             	lea    -0x16(%ebp),%edi
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  28066d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    char tmp_buf[10] = {0};
  280670:	f3 aa                	rep stos %al,%es:(%edi)
  280672:	8d 7d ea             	lea    -0x16(%ebp),%edi
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
  280675:	85 d2                	test   %edx,%edx
  280677:	79 06                	jns    28067f <itoa+0x28>
    { /* neg num */
        *buf++ = '-';//得到负号
  280679:	c6 03 2d             	movb   $0x2d,(%ebx)
        value = ~value + 1; //将负数变为正数
  28067c:	f7 da                	neg    %edx
void itoa(int value,char *buf){
    char tmp_buf[10] = {0};
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
  28067e:	43                   	inc    %ebx
  28067f:	89 f9                	mov    %edi,%ecx



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280681:	be 0a 00 00 00       	mov    $0xa,%esi
  280686:	89 d0                	mov    %edx,%eax
  280688:	41                   	inc    %ecx
  280689:	99                   	cltd   
  28068a:	f7 fe                	idiv   %esi
  28068c:	83 c2 30             	add    $0x30,%edx
        value /= 10;
    }while(value);
  28068f:	85 c0                	test   %eax,%eax



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280691:	88 51 ff             	mov    %dl,-0x1(%ecx)
        value /= 10;
  280694:	89 c2                	mov    %eax,%edx
    }while(value);
  280696:	75 ee                	jne    280686 <itoa+0x2f>



    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  280698:	89 ce                	mov    %ecx,%esi
  28069a:	89 d8                	mov    %ebx,%eax
        value /= 10;
    }while(value);


    while(tmp_buf != tbp)
  28069c:	39 f9                	cmp    %edi,%ecx
  28069e:	74 09                	je     2806a9 <itoa+0x52>
    {
      tbp--;
  2806a0:	49                   	dec    %ecx
      *buf++ = *tbp;
  2806a1:	8a 11                	mov    (%ecx),%dl
  2806a3:	40                   	inc    %eax
  2806a4:	88 50 ff             	mov    %dl,-0x1(%eax)
  2806a7:	eb f3                	jmp    28069c <itoa+0x45>
  2806a9:	89 f0                	mov    %esi,%eax
  2806ab:	29 c8                	sub    %ecx,%eax

    }
    *buf='\0';
  2806ad:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)


}
  2806b1:	83 c4 10             	add    $0x10,%esp
  2806b4:	5b                   	pop    %ebx
  2806b5:	5e                   	pop    %esi
  2806b6:	5f                   	pop    %edi
  2806b7:	5d                   	pop    %ebp
  2806b8:	c3                   	ret    

002806b9 <xtoa>:
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2806b9:	55                   	push   %ebp
    char tmp_buf[30] = {0};
  2806ba:	31 c0                	xor    %eax,%eax
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2806bc:	89 e5                	mov    %esp,%ebp
    char tmp_buf[30] = {0};
  2806be:	b9 1e 00 00 00       	mov    $0x1e,%ecx
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2806c3:	57                   	push   %edi
  2806c4:	56                   	push   %esi
  2806c5:	53                   	push   %ebx
  2806c6:	83 ec 20             	sub    $0x20,%esp
  2806c9:	8b 55 0c             	mov    0xc(%ebp),%edx
    char tmp_buf[30] = {0};
  2806cc:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  2806cf:	f3 aa                	rep stos %al,%es:(%edi)
    char *tbp = tmp_buf;
  2806d1:	8d 45 d6             	lea    -0x2a(%ebp),%eax

    *buf++='0';
  2806d4:	c6 02 30             	movb   $0x30,(%edx)
    *buf++='x';
  2806d7:	8d 72 02             	lea    0x2(%edx),%esi
  2806da:	c6 42 01 78          	movb   $0x78,0x1(%edx)

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  2806de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  2806e1:	40                   	inc    %eax
  2806e2:	83 e3 0f             	and    $0xf,%ebx


}
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
  2806e5:	83 fb 0a             	cmp    $0xa,%ebx
  2806e8:	8d 4b 37             	lea    0x37(%ebx),%ecx
  2806eb:	8d 7b 30             	lea    0x30(%ebx),%edi
  2806ee:	0f 4c cf             	cmovl  %edi,%ecx
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  2806f1:	c1 6d 08 04          	shrl   $0x4,0x8(%ebp)
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
  2806f5:	88 48 ff             	mov    %cl,-0x1(%eax)
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);

        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  2806f8:	75 e4                	jne    2806de <xtoa+0x25>
    *buf++='x';

    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  2806fa:	89 c3                	mov    %eax,%ebx
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);


    while(tmp_buf != tbp)
  2806fc:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  2806ff:	39 f8                	cmp    %edi,%eax
  280701:	74 09                	je     28070c <xtoa+0x53>
    {
      tbp--;
  280703:	48                   	dec    %eax
      *buf++ = *tbp;
  280704:	8a 08                	mov    (%eax),%cl
  280706:	46                   	inc    %esi
  280707:	88 4e ff             	mov    %cl,-0x1(%esi)
  28070a:	eb f0                	jmp    2806fc <xtoa+0x43>
  28070c:	29 c3                	sub    %eax,%ebx

    }
    *buf='\0';
  28070e:	c6 44 1a 02 00       	movb   $0x0,0x2(%edx,%ebx,1)


}
  280713:	83 c4 20             	add    $0x20,%esp
  280716:	5b                   	pop    %ebx
  280717:	5e                   	pop    %esi
  280718:	5f                   	pop    %edi
  280719:	5d                   	pop    %ebp
  28071a:	c3                   	ret    

0028071b <sprintf>:



//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf(char *str,char *format ,...)
{
  28071b:	55                   	push   %ebp
  28071c:	89 e5                	mov    %esp,%ebp
  28071e:	57                   	push   %edi
  28071f:	56                   	push   %esi
  280720:	53                   	push   %ebx
  280721:	83 ec 10             	sub    $0x10,%esp
  280724:	8b 5d 08             	mov    0x8(%ebp),%ebx

   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
  280727:	8d 75 10             	lea    0x10(%ebp),%esi
   char buffer[10];
   char *buf=buffer;
  while(*format)
  28072a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  28072d:	8a 07                	mov    (%edi),%al
  28072f:	84 c0                	test   %al,%al
  280731:	0f 84 83 00 00 00    	je     2807ba <sprintf+0x9f>
  280737:	8d 4f 01             	lea    0x1(%edi),%ecx
  {
      if(*format!='%')
  28073a:	3c 25                	cmp    $0x25,%al
      {
	*str++=*format++;
  28073c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
   char buffer[10];
   char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
  28073f:	74 05                	je     280746 <sprintf+0x2b>
      {
	*str++=*format++;
  280741:	88 03                	mov    %al,(%ebx)
  280743:	43                   	inc    %ebx
	continue;
  280744:	eb e4                	jmp    28072a <sprintf+0xf>
      }
      else
      {
	format++;
	switch (*format)
  280746:	8a 47 01             	mov    0x1(%edi),%al
  280749:	3c 73                	cmp    $0x73,%al
  28074b:	74 46                	je     280793 <sprintf+0x78>
  28074d:	3c 78                	cmp    $0x78,%al
  28074f:	74 23                	je     280774 <sprintf+0x59>
  280751:	3c 64                	cmp    $0x64,%al
  280753:	75 53                	jne    2807a8 <sprintf+0x8d>
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
  280755:	8d 45 ea             	lea    -0x16(%ebp),%eax
  280758:	50                   	push   %eax
  280759:	ff 36                	pushl  (%esi)
  28075b:	e8 f7 fe ff ff       	call   280657 <itoa>
  280760:	59                   	pop    %ecx
  280761:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  280764:	58                   	pop    %eax
  280765:	89 d8                	mov    %ebx,%eax
  280767:	8a 19                	mov    (%ecx),%bl
  280769:	84 db                	test   %bl,%bl
  28076b:	74 3d                	je     2807aa <sprintf+0x8f>
  28076d:	40                   	inc    %eax
  28076e:	41                   	inc    %ecx
  28076f:	88 58 ff             	mov    %bl,-0x1(%eax)
  280772:	eb f3                	jmp    280767 <sprintf+0x4c>
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
  280774:	8d 45 ea             	lea    -0x16(%ebp),%eax
  280777:	50                   	push   %eax
  280778:	ff 36                	pushl  (%esi)
  28077a:	e8 3a ff ff ff       	call   2806b9 <xtoa>
  28077f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  280782:	58                   	pop    %eax
  280783:	89 d8                	mov    %ebx,%eax
  280785:	5a                   	pop    %edx
  280786:	8a 19                	mov    (%ecx),%bl
  280788:	84 db                	test   %bl,%bl
  28078a:	74 1e                	je     2807aa <sprintf+0x8f>
  28078c:	40                   	inc    %eax
  28078d:	41                   	inc    %ecx
  28078e:	88 58 ff             	mov    %bl,-0x1(%eax)
  280791:	eb f3                	jmp    280786 <sprintf+0x6b>
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
  280793:	8b 16                	mov    (%esi),%edx
  280795:	89 d8                	mov    %ebx,%eax
  280797:	89 c1                	mov    %eax,%ecx
  280799:	29 d9                	sub    %ebx,%ecx
  28079b:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
  28079e:	84 c9                	test   %cl,%cl
  2807a0:	74 08                	je     2807aa <sprintf+0x8f>
  2807a2:	40                   	inc    %eax
  2807a3:	88 48 ff             	mov    %cl,-0x1(%eax)
  2807a6:	eb ef                	jmp    280797 <sprintf+0x7c>
	continue;
      }
      else
      {
	format++;
	switch (*format)
  2807a8:	89 d8                	mov    %ebx,%eax
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
	format++;
  2807aa:	83 c7 02             	add    $0x2,%edi
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;

	}
	buf=buffer;
	var++;
  2807ad:	83 c6 04             	add    $0x4,%esi
	format++;
  2807b0:	89 7d 0c             	mov    %edi,0xc(%ebp)
  2807b3:	89 c3                	mov    %eax,%ebx
  2807b5:	e9 70 ff ff ff       	jmp    28072a <sprintf+0xf>

      }

  }
  *str='\0';
  2807ba:	c6 03 00             	movb   $0x0,(%ebx)

}
  2807bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  2807c0:	5b                   	pop    %ebx
  2807c1:	5e                   	pop    %esi
  2807c2:	5f                   	pop    %edi
  2807c3:	5d                   	pop    %ebp
  2807c4:	c3                   	ret    

002807c5 <putfont8>:
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  2807c5:	55                   	push   %ebp
  int row,col;
  char d;
  for(row=0;row<16;row++)
  2807c6:	31 d2                	xor    %edx,%edx
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  2807c8:	89 e5                	mov    %esp,%ebp
  2807ca:	57                   	push   %edi
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  2807cb:	bf 80 00 00 00       	mov    $0x80,%edi
}

}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  2807d0:	56                   	push   %esi
  2807d1:	53                   	push   %ebx
  2807d2:	83 ec 01             	sub    $0x1,%esp
  2807d5:	8a 45 18             	mov    0x18(%ebp),%al
  2807d8:	88 45 f3             	mov    %al,-0xd(%ebp)
  2807db:	8b 45 14             	mov    0x14(%ebp),%eax
  2807de:	0f af 45 0c          	imul   0xc(%ebp),%eax
  2807e2:	03 45 10             	add    0x10(%ebp),%eax
  2807e5:	03 45 08             	add    0x8(%ebp),%eax
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  2807e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  2807eb:	31 c9                	xor    %ecx,%ecx
    {
      if(d&(0x80>>col))
  2807ed:	0f be 34 16          	movsbl (%esi,%edx,1),%esi
  2807f1:	89 fb                	mov    %edi,%ebx
  2807f3:	d3 fb                	sar    %cl,%ebx
  2807f5:	85 f3                	test   %esi,%ebx
  2807f7:	74 06                	je     2807ff <putfont8+0x3a>
      {
	vram[(y+row)*xsize+x+col]=color;
  2807f9:	8a 5d f3             	mov    -0xd(%ebp),%bl
  2807fc:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  2807ff:	41                   	inc    %ecx
  280800:	83 f9 08             	cmp    $0x8,%ecx
  280803:	75 ec                	jne    2807f1 <putfont8+0x2c>

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280805:	42                   	inc    %edx
  280806:	03 45 0c             	add    0xc(%ebp),%eax
  280809:	83 fa 10             	cmp    $0x10,%edx
  28080c:	75 da                	jne    2807e8 <putfont8+0x23>
    }

  }
  return;

}
  28080e:	83 c4 01             	add    $0x1,%esp
  280811:	5b                   	pop    %ebx
  280812:	5e                   	pop    %esi
  280813:	5f                   	pop    %edi
  280814:	5d                   	pop    %ebp
  280815:	c3                   	ret    

00280816 <puts8>:
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280816:	55                   	push   %ebp
  280817:	89 e5                	mov    %esp,%ebp
  280819:	57                   	push   %edi
  28081a:	8b 7d 14             	mov    0x14(%ebp),%edi
  28081d:	56                   	push   %esi
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  28081e:	0f be 75 18          	movsbl 0x18(%ebp),%esi
  *str='\0';

}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280822:	53                   	push   %ebx
  280823:	8b 5d 10             	mov    0x10(%ebp),%ebx

 while(*font)
  280826:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280829:	0f be 00             	movsbl (%eax),%eax
  28082c:	84 c0                	test   %al,%al
  28082e:	74 42                	je     280872 <puts8+0x5c>
 {
    if(*font=='\n')
  280830:	3c 0a                	cmp    $0xa,%al
  280832:	75 05                	jne    280839 <puts8+0x23>
    {
      x=0;
      y=y+16;
  280834:	83 c7 10             	add    $0x10,%edi
  280837:	eb 32                	jmp    28086b <puts8+0x55>

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280839:	c1 e0 04             	shl    $0x4,%eax
  28083c:	05 ac 0f 28 00       	add    $0x280fac,%eax
  280841:	50                   	push   %eax
  280842:	56                   	push   %esi
  280843:	57                   	push   %edi
  280844:	53                   	push   %ebx
    x+=8;
  280845:	83 c3 08             	add    $0x8,%ebx
      y=y+16;

    }
    else
    {
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280848:	ff 75 0c             	pushl  0xc(%ebp)
  28084b:	ff 75 08             	pushl  0x8(%ebp)
  28084e:	e8 72 ff ff ff       	call   2807c5 <putfont8>
    x+=8;
    if(x>312)
  280853:	83 c4 18             	add    $0x18,%esp
  280856:	81 fb 38 01 00 00    	cmp    $0x138,%ebx
  28085c:	7e 0f                	jle    28086d <puts8+0x57>
       {
	  x=0;
	  y+=16;
  28085e:	83 c7 10             	add    $0x10,%edi
	  if(y>183)
  280861:	81 ff b7 00 00 00    	cmp    $0xb7,%edi
  280867:	7e 02                	jle    28086b <puts8+0x55>
	  {
	    x=0;
	    y=0;
  280869:	31 ff                	xor    %edi,%edi
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
  28086b:	31 db                	xor    %ebx,%ebx

	  }
        }
    }

    font++;
  28086d:	ff 45 1c             	incl   0x1c(%ebp)
  280870:	eb b4                	jmp    280826 <puts8+0x10>
}

}
  280872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280875:	5b                   	pop    %ebx
  280876:	5e                   	pop    %esi
  280877:	5f                   	pop    %edi
  280878:	5d                   	pop    %ebp
  280879:	c3                   	ret    

0028087a <printdebug>:
#include<header.h>


void printdebug(unsigned int i,unsigned int x)
{
  28087a:	55                   	push   %ebp
  28087b:	89 e5                	mov    %esp,%ebp
  28087d:	53                   	push   %ebx
  28087e:	83 ec 20             	sub    $0x20,%esp
char font[30];
sprintf(font,"Debug:var=%x" ,i);
  280881:	ff 75 08             	pushl  0x8(%ebp)
  280884:	8d 5d de             	lea    -0x22(%ebp),%ebx
  280887:	68 e4 2a 28 00       	push   $0x282ae4
  28088c:	53                   	push   %ebx
  28088d:	e8 89 fe ff ff       	call   28071b <sprintf>
puts8((char *)VRAM ,320,x,150,1,font);
  280892:	53                   	push   %ebx
  280893:	6a 01                	push   $0x1
  280895:	68 96 00 00 00       	push   $0x96
  28089a:	ff 75 0c             	pushl  0xc(%ebp)
  28089d:	68 40 01 00 00       	push   $0x140
  2808a2:	68 00 00 0a 00       	push   $0xa0000
  2808a7:	e8 6a ff ff ff       	call   280816 <puts8>
  2808ac:	83 c4 24             	add    $0x24,%esp

}
  2808af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2808b2:	c9                   	leave  
  2808b3:	c3                   	ret    

002808b4 <putfont16>:

  }

}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  2808b4:	55                   	push   %ebp
  2808b5:	31 c9                	xor    %ecx,%ecx
  2808b7:	89 e5                	mov    %esp,%ebp
  2808b9:	57                   	push   %edi
  2808ba:	56                   	push   %esi
  2808bb:	53                   	push   %ebx
  2808bc:	52                   	push   %edx
  2808bd:	8b 55 14             	mov    0x14(%ebp),%edx
  2808c0:	0f af 55 0c          	imul   0xc(%ebp),%edx
  2808c4:	8b 45 10             	mov    0x10(%ebp),%eax
  2808c7:	03 45 08             	add    0x8(%ebp),%eax
  2808ca:	8a 5d 18             	mov    0x18(%ebp),%bl
  2808cd:	01 d0                	add    %edx,%eax
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  2808cf:	31 d2                	xor    %edx,%edx
  2808d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
  2808d4:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  2808d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2808da:	0f b7 bc 57 00 fa ff 	movzwl -0x600(%edi,%edx,2),%edi
  2808e1:	ff 
  2808e2:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  2808e5:	31 c0                	xor    %eax,%eax
    {
       if( (d&(1 << col) ))
  2808e7:	0f a3 c7             	bt     %eax,%edi
  2808ea:	73 03                	jae    2808ef <putfont16+0x3b>
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;
  2808ec:	88 1c 06             	mov    %bl,(%esi,%eax,1)
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  2808ef:	40                   	inc    %eax
  2808f0:	83 f8 10             	cmp    $0x10,%eax
  2808f3:	75 f2                	jne    2808e7 <putfont16+0x33>
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  2808f5:	42                   	inc    %edx
  2808f6:	03 4d 0c             	add    0xc(%ebp),%ecx
  2808f9:	83 fa 18             	cmp    $0x18,%edx
  2808fc:	75 d6                	jne    2808d4 <putfont16+0x20>
    }

  }
  return;

}
  2808fe:	58                   	pop    %eax
  2808ff:	5b                   	pop    %ebx
  280900:	5e                   	pop    %esi
  280901:	5f                   	pop    %edi
  280902:	5d                   	pop    %ebp
  280903:	c3                   	ret    

00280904 <puts16>:
  return;

}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  280904:	55                   	push   %ebp
  280905:	89 e5                	mov    %esp,%ebp
  280907:	57                   	push   %edi
  280908:	8b 7d 10             	mov    0x10(%ebp),%edi
  28090b:	56                   	push   %esi
  28090c:	8b 75 14             	mov    0x14(%ebp),%esi
  28090f:	53                   	push   %ebx

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280910:	0f be 5d 18          	movsbl 0x18(%ebp),%ebx
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  280914:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280917:	0f be 00             	movsbl (%eax),%eax
  28091a:	84 c0                	test   %al,%al
  28091c:	74 2d                	je     28094b <puts16+0x47>
  {
    if(*font=='\n')
  28091e:	3c 0a                	cmp    $0xa,%al
  280920:	75 07                	jne    280929 <puts16+0x25>
    {
      x=0;
      y=y+24;
  280922:	83 c6 18             	add    $0x18,%esi
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
  280925:	31 ff                	xor    %edi,%edi
  280927:	eb 1d                	jmp    280946 <puts16+0x42>
      y=y+24;

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
  280929:	6b c0 30             	imul   $0x30,%eax,%eax
  28092c:	05 ac 17 28 00       	add    $0x2817ac,%eax
	putfont16(vram ,xsize,x,y,color,pt);
  280931:	50                   	push   %eax
  280932:	53                   	push   %ebx
  280933:	56                   	push   %esi
  280934:	57                   	push   %edi
	x=x+16;
  280935:	83 c7 10             	add    $0x10,%edi

    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280938:	ff 75 0c             	pushl  0xc(%ebp)
  28093b:	ff 75 08             	pushl  0x8(%ebp)
  28093e:	e8 71 ff ff ff       	call   2808b4 <putfont16>
	x=x+16;
  280943:	83 c4 18             	add    $0x18,%esp


    }

     font++;
  280946:	ff 45 1c             	incl   0x1c(%ebp)
  280949:	eb c9                	jmp    280914 <puts16+0x10>

  }

}
  28094b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  28094e:	5b                   	pop    %ebx
  28094f:	5e                   	pop    %esi
  280950:	5f                   	pop    %edi
  280951:	5d                   	pop    %ebp
  280952:	c3                   	ret    

00280953 <setgdt>:
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  280953:	55                   	push   %ebp
  280954:	89 e5                	mov    %esp,%ebp
  280956:	8b 55 0c             	mov    0xc(%ebp),%edx
  280959:	57                   	push   %edi
  28095a:	8b 45 08             	mov    0x8(%ebp),%eax
  28095d:	56                   	push   %esi
  28095e:	8b 7d 14             	mov    0x14(%ebp),%edi
  280961:	53                   	push   %ebx
  280962:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(limit>0xffff)
  280965:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
  28096b:	76 09                	jbe    280976 <setgdt+0x23>
  {
    access|=0x8000;
  28096d:	81 cf 00 80 00 00    	or     $0x8000,%edi
    limit /=0x1000;
  280973:	c1 ea 0c             	shr    $0xc,%edx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  280976:	89 de                	mov    %ebx,%esi
  280978:	c1 fe 10             	sar    $0x10,%esi
  28097b:	89 f1                	mov    %esi,%ecx
  28097d:	88 48 04             	mov    %cl,0x4(%eax)
  sd->access_right=access&0xff;
  280980:	89 f9                	mov    %edi,%ecx
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280982:	c1 ff 08             	sar    $0x8,%edi
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  280985:	88 48 05             	mov    %cl,0x5(%eax)
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280988:	89 f9                	mov    %edi,%ecx
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  28098a:	66 89 10             	mov    %dx,(%eax)
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  28098d:	83 e1 f0             	and    $0xfffffff0,%ecx
  280990:	c1 ea 10             	shr    $0x10,%edx
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  280993:	66 89 58 02          	mov    %bx,0x2(%eax)
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  280997:	09 d1                	or     %edx,%ecx
  sd->base_high=(base>>24)&0xff;
  280999:	c1 eb 18             	shr    $0x18,%ebx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  28099c:	88 48 06             	mov    %cl,0x6(%eax)
  sd->base_high=(base>>24)&0xff;
  28099f:	88 58 07             	mov    %bl,0x7(%eax)

}
  2809a2:	5b                   	pop    %ebx
  2809a3:	5e                   	pop    %esi
  2809a4:	5f                   	pop    %edi
  2809a5:	5d                   	pop    %ebp
  2809a6:	c3                   	ret    

002809a7 <setidt>:

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  2809a7:	55                   	push   %ebp
  2809a8:	89 e5                	mov    %esp,%ebp
  2809aa:	8b 45 08             	mov    0x8(%ebp),%eax
  2809ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  2809b0:	8b 55 14             	mov    0x14(%ebp),%edx
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2809b3:	66 89 08             	mov    %cx,(%eax)
  gd->offset_high=(offset>>16)&0xffff;
  2809b6:	c1 e9 10             	shr    $0x10,%ecx
  2809b9:	66 89 48 06          	mov    %cx,0x6(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  2809bd:	8b 4d 10             	mov    0x10(%ebp),%ecx

  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2809c0:	88 50 05             	mov    %dl,0x5(%eax)
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  2809c3:	66 89 48 02          	mov    %cx,0x2(%eax)

  gd->dw_count=(access>>8)&0xff;
  2809c7:	89 d1                	mov    %edx,%ecx
  2809c9:	c1 f9 08             	sar    $0x8,%ecx
  2809cc:	88 48 04             	mov    %cl,0x4(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的


}
  2809cf:	5d                   	pop    %ebp
  2809d0:	c3                   	ret    

002809d1 <init_gdtidt>:



void  init_gdtidt()
{
  2809d1:	55                   	push   %ebp
  2809d2:	89 e5                	mov    %esp,%ebp
  2809d4:	53                   	push   %ebx
  2809d5:	53                   	push   %ebx
  2809d6:	bb 00 00 27 00       	mov    $0x270000,%ebx
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  2809db:	6a 00                	push   $0x0
  2809dd:	6a 00                	push   $0x0
  2809df:	6a 00                	push   $0x0
  2809e1:	53                   	push   %ebx
  2809e2:	83 c3 08             	add    $0x8,%ebx
  2809e5:	e8 69 ff ff ff       	call   280953 <setgdt>
void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  2809ea:	83 c4 10             	add    $0x10,%esp
  2809ed:	81 fb 00 00 28 00    	cmp    $0x280000,%ebx
  2809f3:	75 e6                	jne    2809db <init_gdtidt+0xa>
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  2809f5:	68 92 40 00 00       	push   $0x4092
  2809fa:	6a 00                	push   $0x0
  2809fc:	6a ff                	push   $0xffffffff
  2809fe:	68 08 00 27 00       	push   $0x270008
  280a03:	e8 4b ff ff ff       	call   280953 <setgdt>
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  280a08:	68 9a 40 00 00       	push   $0x409a
  280a0d:	6a 00                	push   $0x0
  280a0f:	68 ff ff 0f 00       	push   $0xfffff
  280a14:	68 10 00 27 00       	push   $0x270010
  280a19:	e8 35 ff ff ff       	call   280953 <setgdt>
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  280a1e:	83 c4 20             	add    $0x20,%esp
  280a21:	68 9a 40 00 00       	push   $0x409a
  280a26:	68 00 00 28 00       	push   $0x280000
  280a2b:	68 ff ff 0f 00       	push   $0xfffff
  280a30:	68 18 00 27 00       	push   $0x270018
  280a35:	e8 19 ff ff ff       	call   280953 <setgdt>

   load_gdtr(0xfff,0X00270000);//this is right
  280a3a:	5a                   	pop    %edx
  280a3b:	59                   	pop    %ecx
  280a3c:	68 00 00 27 00       	push   $0x270000
  280a41:	68 ff 0f 00 00       	push   $0xfff
  280a46:	e8 d1 01 00 00       	call   280c1c <load_gdtr>
  280a4b:	83 c4 10             	add    $0x10,%esp
  280a4e:	31 c0                	xor    %eax,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280a50:	66 c7 80 00 f8 26 00 	movw   $0x0,0x26f800(%eax)
  280a57:	00 00 
  280a59:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280a5c:	66 c7 80 fe f7 26 00 	movw   $0x0,0x26f7fe(%eax)
  280a63:	00 00 

  //16位的selector决定了base address
  gd->selector=selector;
  280a65:	66 c7 80 fa f7 26 00 	movw   $0x0,0x26f7fa(%eax)
  280a6c:	00 00 

  gd->dw_count=(access>>8)&0xff;
  280a6e:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280a75:	c6 80 fd f7 26 00 00 	movb   $0x0,0x26f7fd(%eax)
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  280a7c:	3d 00 08 00 00       	cmp    $0x800,%eax
  280a81:	75 cd                	jne    280a50 <init_gdtidt+0x7f>

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  280a83:	ba e6 0b 28 00       	mov    $0x280be6,%edx
  280a88:	66 31 c0             	xor    %ax,%ax
  280a8b:	c1 ea 10             	shr    $0x10,%edx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280a8e:	b9 e6 0b 28 00       	mov    $0x280be6,%ecx
  280a93:	66 89 88 00 f8 26 00 	mov    %cx,0x26f800(%eax)
  280a9a:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280a9d:	66 89 90 fe f7 26 00 	mov    %dx,0x26f7fe(%eax)

  //16位的selector决定了base address
  gd->selector=selector;
  280aa4:	66 c7 80 fa f7 26 00 	movw   $0x18,0x26f7fa(%eax)
  280aab:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280aad:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280ab4:	c6 80 fd f7 26 00 8e 	movb   $0x8e,0x26f7fd(%eax)
  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }

  for(i=0;i<256;i++)
  280abb:	3d 00 08 00 00       	cmp    $0x800,%eax
  280ac0:	75 d1                	jne    280a93 <init_gdtidt+0xc2>
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  280ac2:	b8 e6 0b 00 00       	mov    $0xbe6,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280ac7:	66 a3 08 f9 26 00    	mov    %ax,0x26f908
  gd->offset_high=(offset>>16)&0xffff;
  280acd:	c1 e8 10             	shr    $0x10,%eax
  280ad0:	66 a3 0e f9 26 00    	mov    %ax,0x26f90e
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//挂载keyboard interrupt service
  setidt(idt+0x2c,(int)asm_inthandler2c-0x280000,3*8,0x008e);//挂载mouse 　　interrupt service
  280ad6:	b8 01 0c 00 00       	mov    $0xc01,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280adb:	66 a3 60 f9 26 00    	mov    %ax,0x26f960
  gd->offset_high=(offset>>16)&0xffff;
  280ae1:	c1 e8 10             	shr    $0x10,%eax
  280ae4:	66 a3 66 f9 26 00    	mov    %ax,0x26f966

  //16位的selector决定了base address
  gd->selector=selector;
  280aea:	66 c7 05 0a f9 26 00 	movw   $0x18,0x26f90a
  280af1:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280af3:	c6 05 0c f9 26 00 00 	movb   $0x0,0x26f90c
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280afa:	c6 05 0d f9 26 00 8e 	movb   $0x8e,0x26f90d
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;

  //16位的selector决定了base address
  gd->selector=selector;
  280b01:	66 c7 05 62 f9 26 00 	movw   $0x18,0x26f962
  280b08:	18 00 

  gd->dw_count=(access>>8)&0xff;
  280b0a:	c6 05 64 f9 26 00 00 	movb   $0x0,0x26f964
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280b11:	c6 05 65 f9 26 00 8e 	movb   $0x8e,0x26f965

 // setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//挂载keyboard interrupt service
 // setidt(idt+0x2c,(int)asm_inthandler2c,2*8,0x008e);//挂载mouse 　　interrupt serv
  //printdebug(asm_inthandler2c,0);

  load_idtr(0x7ff,0x0026f800);//this is right
  280b18:	50                   	push   %eax
  280b19:	50                   	push   %eax
  280b1a:	68 00 f8 26 00       	push   $0x26f800
  280b1f:	68 ff 07 00 00       	push   $0x7ff
  280b24:	e8 03 01 00 00       	call   280c2c <load_idtr>
  280b29:	83 c4 10             	add    $0x10,%esp



  return;

}
  280b2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280b2f:	c9                   	leave  
  280b30:	c3                   	ret    

00280b31 <init_pic>:
#define PIC1_ICW4		0x00a1
*/

//remap irq0-irq15到int 0x20到int 0x2f
void init_pic()
{
  280b31:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280b32:	ba 21 00 00 00       	mov    $0x21,%edx
  280b37:	89 e5                	mov    %esp,%ebp
  280b39:	b0 ff                	mov    $0xff,%al
  280b3b:	ee                   	out    %al,(%dx)
  280b3c:	b2 a1                	mov    $0xa1,%dl
  280b3e:	ee                   	out    %al,(%dx)
  280b3f:	b0 11                	mov    $0x11,%al
  280b41:	b2 20                	mov    $0x20,%dl
  280b43:	ee                   	out    %al,(%dx)
  280b44:	b0 20                	mov    $0x20,%al
  280b46:	b2 21                	mov    $0x21,%dl
  280b48:	ee                   	out    %al,(%dx)
  280b49:	b0 04                	mov    $0x4,%al
  280b4b:	ee                   	out    %al,(%dx)
  280b4c:	b0 01                	mov    $0x1,%al
  280b4e:	ee                   	out    %al,(%dx)
  280b4f:	b0 11                	mov    $0x11,%al
  280b51:	b2 a0                	mov    $0xa0,%dl
  280b53:	ee                   	out    %al,(%dx)
  280b54:	b0 28                	mov    $0x28,%al
  280b56:	b2 a1                	mov    $0xa1,%dl
  280b58:	ee                   	out    %al,(%dx)
  280b59:	b0 02                	mov    $0x2,%al
  280b5b:	ee                   	out    %al,(%dx)
  280b5c:	b0 01                	mov    $0x1,%al
  280b5e:	ee                   	out    %al,(%dx)
  280b5f:	b0 fb                	mov    $0xfb,%al
  280b61:	b2 21                	mov    $0x21,%dl
  280b63:	ee                   	out    %al,(%dx)
  280b64:	b0 ff                	mov    $0xff,%al
  280b66:	b2 a1                	mov    $0xa1,%dl
  280b68:	ee                   	out    %al,(%dx)

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}
  280b69:	5d                   	pop    %ebp
  280b6a:	c3                   	ret    

00280b6b <inthandler21>:
struct FIFO8 keyfifo;//a global data
//上面是一个全局变量

//interrupt service procedure for keyboard  中断服务程序，读取按键的键值。
void inthandler21(int *esp)
{
  280b6b:	55                   	push   %ebp
  280b6c:	ba 20 00 00 00       	mov    $0x20,%edx
  280b71:	89 e5                	mov    %esp,%ebp
  280b73:	b0 61                	mov    $0x61,%al
  280b75:	83 ec 10             	sub    $0x10,%esp
  280b78:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  280b79:	b2 60                	mov    $0x60,%dl
  280b7b:	ec                   	in     (%dx),%al
  //struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  unsigned char data;
  outb(PIC0_OCW2,0X61);//0X61-->PIC0_OCW2 　告之pic0这个芯片，irq1中断(就是keyboard产生的中断)cpu已经处理，这样pic0才会响应　下一次的irq1中断
  //如果不告之pic0已经处理了这次中断，pico对已后的irq1中断就会响应了。这种cpu处理完了中断，对pic0的反馈机制是非常好的，不会漏掉任何数据。
  data=inb(PORT_KEYDAT);
  fifo8_write(&keyfifo,data);
  280b7c:	0f b6 c0             	movzbl %al,%eax
  280b7f:	50                   	push   %eax
  280b80:	68 bc 30 28 00       	push   $0x2830bc
  280b85:	e8 dd 00 00 00       	call   280c67 <fifo8_write>
  280b8a:	83 c4 10             	add    $0x10,%esp
  //puts8((char *)binfo->vram ,binfo->xsize,0,0,7,s);

  //while(1)
  //io_halt();
  
}
  280b8d:	c9                   	leave  
  280b8e:	c3                   	ret    

00280b8f <inthandler2c>:
//中断处理程序不应该有大量的处理部分，应该得到数据后，马上回去，在主函数中处理信息才是对的，与５１中是一个道理。isr尽量短小。

//interrupt service for mouse 
struct FIFO8 mousefifo;
void inthandler2c(int *esp)//可以看到一运行enable_后就，就产生了中断，进入了这个中断服务函数。
{
  280b8f:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280b90:	ba a0 00 00 00       	mov    $0xa0,%edx
  280b95:	89 e5                	mov    %esp,%ebp
  280b97:	b0 64                	mov    $0x64,%al
  280b99:	83 ec 10             	sub    $0x10,%esp
  280b9c:	ee                   	out    %al,(%dx)
  280b9d:	b0 62                	mov    $0x62,%al
  280b9f:	b2 20                	mov    $0x20,%dl
  280ba1:	ee                   	out    %al,(%dx)
static __inline uint8_t
inb(int port)
{
  //read a byte from port
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  280ba2:	b2 60                	mov    $0x60,%dl
  280ba4:	ec                   	in     (%dx),%al
  
  unsigned char data;
  outb(PIC1_OCW2,0X64);//cpu tell pic1　that I got IRQ12 
  outb(PIC0_OCW2,0X62);//cpu tell pic0  that I got IRQ2
  data = inb(PORT_KEYDAT);
  fifo8_write(&mousefifo,data);
  280ba5:	0f b6 c0             	movzbl %al,%eax
  280ba8:	50                   	push   %eax
  280ba9:	68 d4 30 28 00       	push   $0x2830d4
  280bae:	e8 b4 00 00 00       	call   280c67 <fifo8_write>
  280bb3:	83 c4 10             	add    $0x10,%esp
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int2c(IRQ-12):PS2/mouse");

 // while(1)
 // hlt();
 */
}
  280bb6:	c9                   	leave  
  280bb7:	c3                   	ret    

00280bb8 <wait_KBC_sendready>:
//for mouse and keyboard control circuit,鼠标，键盘控制电路的初始化。
//#define PORT_KEYDAT 		0X0060


void wait_KBC_sendready(void)				//send ready and wait keyboard control ready
{
  280bb8:	55                   	push   %ebp
  280bb9:	ba 64 00 00 00       	mov    $0x64,%edx
  280bbe:	89 e5                	mov    %esp,%ebp
  280bc0:	ec                   	in     (%dx),%al
  while(1)
  {
    /*等待按键控制电路准备完毕*/
    if( (inb(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0)	//读port 0x0064 看bit1是否是为０/if 0 ready ,if 1 not ready　
  280bc1:	a8 02                	test   $0x2,%al
  280bc3:	75 fb                	jne    280bc0 <wait_KBC_sendready+0x8>
    {							//bit 1是０说明键盘控制电路是准备好的，可以接受cpu的指令了。
      break;
    }
  }
  
}
  280bc5:	5d                   	pop    %ebp
  280bc6:	c3                   	ret    

00280bc7 <init_keyboard>:

void init_keyboard(void)
{
  280bc7:	55                   	push   %ebp
  280bc8:	89 e5                	mov    %esp,%ebp
  /*这里才是真正的初始化按键电路*/
  wait_KBC_sendready();				//wait ready
  280bca:	e8 e9 ff ff ff       	call   280bb8 <wait_KBC_sendready>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280bcf:	ba 64 00 00 00       	mov    $0x64,%edx
  280bd4:	b0 60                	mov    $0x60,%al
  280bd6:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_WRITE_MODE);		//向port 0x0064写　0x60
  wait_KBC_sendready();				//保证能写入有效的数据到　port 0x0064
  280bd7:	e8 dc ff ff ff       	call   280bb8 <wait_KBC_sendready>
  280bdc:	ba 60 00 00 00       	mov    $0x60,%edx
  280be1:	b0 47                	mov    $0x47,%al
  280be3:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,KBC_MODE);			//向port 0x0060 写数据0x47
  return;
  
}
  280be4:	5d                   	pop    %ebp
  280be5:	c3                   	ret    

00280be6 <asm_inthandler21>:
.global load_idtr

.code32
#interrupt service about keyboad
asm_inthandler21:
  pushw %es
  280be6:	66 06                	pushw  %es
  pushw %ds
  280be8:	66 1e                	pushw  %ds
  pushal
  280bea:	60                   	pusha  
  movl %esp,%eax
  280beb:	89 e0                	mov    %esp,%eax
  pushl %eax
  280bed:	50                   	push   %eax
  movw %ss,%ax
  280bee:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  280bf1:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  280bf3:	8e c0                	mov    %eax,%es
  call inthandler21
  280bf5:	e8 71 ff ff ff       	call   280b6b <inthandler21>
  
  popl %eax
  280bfa:	58                   	pop    %eax
  popal
  280bfb:	61                   	popa   
  popw %ds
  280bfc:	66 1f                	popw   %ds
  popW %es
  280bfe:	66 07                	popw   %es
  iretl
  280c00:	cf                   	iret   

00280c01 <asm_inthandler2c>:
  
#interrupt service about mouse
asm_inthandler2c:
  pushw %es
  280c01:	66 06                	pushw  %es
  pushw %ds
  280c03:	66 1e                	pushw  %ds
  pushal
  280c05:	60                   	pusha  
  movl %esp,%eax
  280c06:	89 e0                	mov    %esp,%eax
  pushl %eax
  280c08:	50                   	push   %eax
  movw %ss,%ax
  280c09:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  280c0c:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  280c0e:	8e c0                	mov    %eax,%es
  call inthandler2c
  280c10:	e8 7a ff ff ff       	call   280b8f <inthandler2c>
  
  popl %eax
  280c15:	58                   	pop    %eax
  popal
  280c16:	61                   	popa   
  popw %ds
  280c17:	66 1f                	popw   %ds
  popW %es
  280c19:	66 07                	popw   %es
  iretl
  280c1b:	cf                   	iret   

00280c1c <load_gdtr>:
  #iret 与iretl有什么区别？？？
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  280c1c:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  280c21:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lgdt 6(%esp)
  280c26:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  ret
  280c2b:	c3                   	ret    

00280c2c <load_idtr>:


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  280c2c:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  280c31:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lidt 6(%esp)
  280c36:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  280c3b:	c3                   	ret    

00280c3c <fifo8_init>:
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  280c3c:	55                   	push   %ebp
  280c3d:	89 e5                	mov    %esp,%ebp
  280c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  280c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  fifo->buf=buf;
  280c45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fifo->size=size;
  fifo->free=size;
  fifo->nr=0;
  280c48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  fifo->size=size;
  280c4f:	89 50 0c             	mov    %edx,0xc(%eax)
#include<header.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  280c52:	89 08                	mov    %ecx,(%eax)
  fifo->size=size;
  fifo->free=size;
  280c54:	89 50 10             	mov    %edx,0x10(%eax)
  fifo->nr=0;
  fifo->nw=0;
  280c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  fifo->flags=0;
  280c5e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  280c65:	5d                   	pop    %ebp
  280c66:	c3                   	ret    

00280c67 <fifo8_write>:


#define FLAGS_OVERRUN 0X0001
//下面的函数是对fifo类型的变量，写入数据。
int fifo8_write(struct FIFO8 *fifo,unsigned char data)
{
  280c67:	55                   	push   %ebp
  280c68:	89 e5                	mov    %esp,%ebp
  280c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  280c6d:	53                   	push   %ebx
  280c6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(fifo->free==0)//fifo is full ,no room for any data
  280c71:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  280c75:	75 09                	jne    280c80 <fifo8_write+0x19>
  {
    fifo->flags|=FLAGS_OVERRUN;//if fifo->flags is TRUE, fifo已经满了，不能再写了。
  280c77:	83 48 14 01          	orl    $0x1,0x14(%eax)
    return -1; //write error
  280c7b:	83 c8 ff             	or     $0xffffffff,%eax
  280c7e:	eb 22                	jmp    280ca2 <fifo8_write+0x3b>
  }
  
  
 fifo->buf[fifo->nw]=data;
  280c80:	8b 50 04             	mov    0x4(%eax),%edx
  280c83:	8b 08                	mov    (%eax),%ecx
  280c85:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
 fifo->nw++;
  280c88:	8b 48 04             	mov    0x4(%eax),%ecx
  280c8b:	8d 51 01             	lea    0x1(%ecx),%edx
 if(fifo->nw==fifo->size)
  280c8e:	3b 50 0c             	cmp    0xc(%eax),%edx
    return -1; //write error
  }
  
  
 fifo->buf[fifo->nw]=data;
 fifo->nw++;
  280c91:	89 50 04             	mov    %edx,0x4(%eax)
 if(fifo->nw==fifo->size)
  280c94:	75 07                	jne    280c9d <fifo8_write+0x36>
 {
  fifo->nw=0;  
  280c96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 }
 fifo->free--;
  280c9d:	ff 48 10             	decl   0x10(%eax)
 return 0;//write sucessful
  280ca0:	31 c0                	xor    %eax,%eax
 
}
  280ca2:	5b                   	pop    %ebx
  280ca3:	5d                   	pop    %ebp
  280ca4:	c3                   	ret    

00280ca5 <fifo8_read>:
//只有写fifo 会有fifo full的情况，
//读fifo时，会有empty的情况。
int fifo8_read(struct FIFO8 *fifo)
{
  280ca5:	55                   	push   %ebp
  280ca6:	89 e5                	mov    %esp,%ebp
  280ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  280cab:	57                   	push   %edi
  280cac:	56                   	push   %esi
  280cad:	53                   	push   %ebx
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  280cae:	8b 5a 10             	mov    0x10(%edx),%ebx
  280cb1:	8b 7a 0c             	mov    0xc(%edx),%edi
  280cb4:	39 fb                	cmp    %edi,%ebx
  280cb6:	74 1a                	je     280cd2 <fifo8_read+0x2d>
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  280cb8:	8b 72 08             	mov    0x8(%edx),%esi
  fifo->nr++;
  280cbb:	31 c9                	xor    %ecx,%ecx
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  280cbd:	8b 02                	mov    (%edx),%eax
  280cbf:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
  fifo->nr++;
  280cc3:	46                   	inc    %esi
  280cc4:	39 fe                	cmp    %edi,%esi
  280cc6:	0f 45 ce             	cmovne %esi,%ecx
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  280cc9:	43                   	inc    %ebx
  {
    return -1;
  }
  
  data=fifo->buf[fifo->nr];
  fifo->nr++;
  280cca:	89 4a 08             	mov    %ecx,0x8(%edx)
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;
  280ccd:	89 5a 10             	mov    %ebx,0x10(%edx)
  
  return data;
  280cd0:	eb 03                	jmp    280cd5 <fifo8_read+0x30>
int fifo8_read(struct FIFO8 *fifo)
{
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  280cd2:	83 c8 ff             	or     $0xffffffff,%eax
  fifo->free++;
  
  return data;
  
  
}
  280cd5:	5b                   	pop    %ebx
  280cd6:	5e                   	pop    %esi
  280cd7:	5f                   	pop    %edi
  280cd8:	5d                   	pop    %ebp
  280cd9:	c3                   	ret    

00280cda <fifo8_status>:

int fifo8_status(struct FIFO8 *fifo)
{
  280cda:	55                   	push   %ebp
  280cdb:	89 e5                	mov    %esp,%ebp
  280cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  280ce0:	5d                   	pop    %ebp
  
}

int fifo8_status(struct FIFO8 *fifo)
{
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
  280ce1:	8b 42 0c             	mov    0xc(%edx),%eax
  280ce4:	2b 42 10             	sub    0x10(%edx),%eax
  280ce7:	c3                   	ret    

00280ce8 <enable_mouse>:
#include<header.h>
//激活鼠标的指令　还是向键盘控制器发送指令
#define KEYCMD_SENDTO_MOUSE 	0XD4
#define MOUSECMD_ENABLE     	0XF4
void enable_mouse(struct MOUSE_DEC *mdec)
{
  280ce8:	55                   	push   %ebp
  280ce9:	89 e5                	mov    %esp,%ebp
  280ceb:	83 ec 08             	sub    $0x8,%esp
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  280cee:	e8 c5 fe ff ff       	call   280bb8 <wait_KBC_sendready>
  280cf3:	ba 64 00 00 00       	mov    $0x64,%edx
  280cf8:	b0 d4                	mov    $0xd4,%al
  280cfa:	ee                   	out    %al,(%dx)
  outb(PORT_KEYCMD,KEYCMD_SENDTO_MOUSE);//向port 0x0064　写　0XD4命令  下面的命令发给mouse
  wait_KBC_sendready();			//等待port 0x0060,0x0064可用
  280cfb:	e8 b8 fe ff ff       	call   280bb8 <wait_KBC_sendready>
  280d00:	ba 60 00 00 00       	mov    $0x60,%edx
  280d05:	b0 f4                	mov    $0xf4,%al
  280d07:	ee                   	out    %al,(%dx)
  outb(PORT_KEYDAT,MOUSECMD_ENABLE); 	//向port 0x0060　写　0Xf4命令  给mouse发送enable命令
  
  mdec->phase=0;
  280d08:	8b 45 08             	mov    0x8(%ebp),%eax
  280d0b:	c6 40 03 00          	movb   $0x0,0x3(%eax)
  return ; 				//if sucessful ,will create an interrupt ,and return ０xfa(ACK),产生的这个0xfa是给cpu的答复信号
					//就算鼠标不动，也会产生这个中断，所以我们一调用enable_mouse，就会产生鼠标中断，必须有这个服务函数。  
}
  280d0f:	c9                   	leave  
  280d10:	c3                   	ret    

00280d11 <mouse_decode>:


int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  280d11:	55                   	push   %ebp
  280d12:	89 e5                	mov    %esp,%ebp
  280d14:	8b 55 08             	mov    0x8(%ebp),%edx
  280d17:	53                   	push   %ebx
  280d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(mdec->phase==0)
  280d1b:	8a 42 03             	mov    0x3(%edx),%al
  280d1e:	84 c0                	test   %al,%al
  280d20:	75 0d                	jne    280d2f <mouse_decode+0x1e>
    if(data==0xfa)
    {
      mdec->phase = 1;
      
    }   
    return 0;
  280d22:	31 c0                	xor    %eax,%eax

int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data)
{
  if(mdec->phase==0)
  {
    if(data==0xfa)
  280d24:	80 f9 fa             	cmp    $0xfa,%cl
  280d27:	75 73                	jne    280d9c <mouse_decode+0x8b>
    {
      mdec->phase = 1;
  280d29:	c6 42 03 01          	movb   $0x1,0x3(%edx)
  280d2d:	eb 6d                	jmp    280d9c <mouse_decode+0x8b>
      
    }   
    return 0;
  }
  else if(mdec->phase==1) 
  280d2f:	3c 01                	cmp    $0x1,%al
  280d31:	75 11                	jne    280d44 <mouse_decode+0x33>
  {
    //鼠标的第一字节的数据
    if( (data & 0xc8) == 0x08 )//如果第一个字节的数据正确  ,只要第一个字节的数据是正确的，后面两个phase的数据就是关于左移 和右移的数据
  280d33:	88 c8                	mov    %cl,%al
  280d35:	83 e0 c8             	and    $0xffffffc8,%eax
  280d38:	3c 08                	cmp    $0x8,%al
  280d3a:	75 5d                	jne    280d99 <mouse_decode+0x88>
    {
    mdec->buf[0] = data;
  280d3c:	88 0a                	mov    %cl,(%edx)
    mdec->phase  = 2;
  280d3e:	c6 42 03 02          	movb   $0x2,0x3(%edx)
  280d42:	eb 0b                	jmp    280d4f <mouse_decode+0x3e>
    return 0;
    }
  }
  else if(mdec->phase==2) 
  280d44:	3c 02                	cmp    $0x2,%al
  280d46:	75 0b                	jne    280d53 <mouse_decode+0x42>
  {
    mdec->buf[1] = data;
  280d48:	88 4a 01             	mov    %cl,0x1(%edx)
    mdec->phase  = 3;
  280d4b:	c6 42 03 03          	movb   $0x3,0x3(%edx)
    return 0;
  280d4f:	31 c0                	xor    %eax,%eax
  280d51:	eb 49                	jmp    280d9c <mouse_decode+0x8b>
  }
  else if(mdec->phase==3) 
  280d53:	3c 03                	cmp    $0x3,%al
  280d55:	75 42                	jne    280d99 <mouse_decode+0x88>
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280d57:	8a 02                	mov    (%edx),%al
    mdec->phase  = 3;
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
  280d59:	88 4a 02             	mov    %cl,0x2(%edx)
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  280d5c:	0f b6 c9             	movzbl %cl,%ecx
    return 0;
  }
  else if(mdec->phase==3) 
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
  280d5f:	c6 42 03 01          	movb   $0x1,0x3(%edx)
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
  280d63:	89 4a 08             	mov    %ecx,0x8(%edx)
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280d66:	89 c3                	mov    %eax,%ebx
  280d68:	83 e3 07             	and    $0x7,%ebx
    mdec->x =mdec->buf[1];
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  280d6b:	a8 10                	test   $0x10,%al
  {
    mdec->buf[2] = data;
    mdec->phase  = 1;
    
    
    mdec->button =mdec->buf[0] & 0x07;//0x07=0000 0111  没有按键时为8（1000）左按键是9(1001)，右按键是10(1010) 从buf0解读出lrbutton是否按下，left=1,right=2;
  280d6d:	89 5a 0c             	mov    %ebx,0xc(%edx)
    mdec->x =mdec->buf[1];
  280d70:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  280d74:	89 5a 04             	mov    %ebx,0x4(%edx)
    mdec->y =mdec->buf[2];
    
    //why do this 
    if( (mdec->buf[0] & 0x10) != 0)//bit4为1时 1
  280d77:	74 09                	je     280d82 <mouse_decode+0x71>
    {
      mdec->x |=0xffffff00;//-x 根据buf[0]的bit4为1时，确定鼠标的移动方向是负方向。
  280d79:	81 cb 00 ff ff ff    	or     $0xffffff00,%ebx
  280d7f:	89 5a 04             	mov    %ebx,0x4(%edx)
    }
    if( (mdec->buf[0] & 0x20) != 0)//bit5为1时 2
  280d82:	a8 20                	test   $0x20,%al
  280d84:	74 09                	je     280d8f <mouse_decode+0x7e>
    {
      mdec->y |=0xffffff00;//-y
  280d86:	81 c9 00 ff ff ff    	or     $0xffffff00,%ecx
  280d8c:	89 4a 08             	mov    %ecx,0x8(%edx)
    }
    
    mdec->y= - mdec->y;//鼠标的移动方向与屏幕的方向是相反的。
  280d8f:	f7 5a 08             	negl   0x8(%edx)


    return 1;
  280d92:	b8 01 00 00 00       	mov    $0x1,%eax
  280d97:	eb 03                	jmp    280d9c <mouse_decode+0x8b>
  }
  //buf0中的数据非常的重要，低四位与左右按键有关，高四位与方向有关。
  //高四位0－1－2－3，低四位8 9(left) a(right) b(both) c(middle)
   return -1;
  280d99:	83 c8 ff             	or     $0xffffffff,%eax
}
  280d9c:	5b                   	pop    %ebx
  280d9d:	5d                   	pop    %ebp
  280d9e:	c3                   	ret    

00280d9f <getmemorysize>:
#include<mm.h>


unsigned int getmemorysize(unsigned int start,unsigned int end)
{
  280d9f:	55                   	push   %ebp
  280da0:	89 e5                	mov    %esp,%ebp
  280da2:	8b 45 08             	mov    0x8(%ebp),%eax
  280da5:	53                   	push   %ebx
 unsigned int old;

 //下面的程度只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  280da6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  280da9:	77 2b                	ja     280dd6 <getmemorysize+0x37>
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  280dab:	8b 90 00 08 00 00    	mov    0x800(%eax),%edx
  *p=pat0;
  280db1:	c7 80 00 08 00 00 55 	movl   $0xaa55aa55,0x800(%eax)
  280db8:	aa 55 aa 
  if(*p!=pat0)
  280dbb:	8b 98 00 08 00 00    	mov    0x800(%eax),%ebx
  {
   *p=old;
  280dc1:	89 90 00 08 00 00    	mov    %edx,0x800(%eax)
 for(i=start;i<=end;i+=0x1000)
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  *p=pat0;
  if(*p!=pat0)
  280dc7:	81 fb 55 aa 55 aa    	cmp    $0xaa55aa55,%ebx
  280dcd:	75 07                	jne    280dd6 <getmemorysize+0x37>
 unsigned int old;

 //下面的程度只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
  280dcf:	05 00 10 00 00       	add    $0x1000,%eax
  280dd4:	eb d0                	jmp    280da6 <getmemorysize+0x7>
 }
 return i;//i就是得到的memory size



}
  280dd6:	5b                   	pop    %ebx
  280dd7:	5d                   	pop    %ebp
  280dd8:	c3                   	ret    

00280dd9 <memtest>:

unsigned int memtest(unsigned int start,unsigned int end)
{
  280dd9:	55                   	push   %ebp
  280dda:	89 e5                	mov    %esp,%ebp
  280ddc:	53                   	push   %ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  280ddd:	9c                   	pushf  
  280dde:	58                   	pop    %eax
 char flg486=0;
 unsigned int eflg,cr0,i;
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
  280ddf:	0d 00 00 04 00       	or     $0x40000,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  280de4:	50                   	push   %eax
  280de5:	9d                   	popf   
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  280de6:	9c                   	pushf  
  280de7:	58                   	pop    %eax

}

unsigned int memtest(unsigned int start,unsigned int end)
{
 char flg486=0;
  280de8:	31 db                	xor    %ebx,%ebx
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
  280dea:	a9 00 00 04 00       	test   $0x40000,%eax
  280def:	74 14                	je     280e05 <memtest+0x2c>
 {
  flg486=1;
  eflg&=~EFLAGS_AC_BIT;
  280df1:	25 ff ff fb ff       	and    $0xfffbffff,%eax
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  280df6:	50                   	push   %eax
  280df7:	9d                   	popf   

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  280df8:	0f 20 c0             	mov    %cr0,%eax
  write_eflags(eflg);
 }
 if(flg486)
 {
  cr0=rcr0();
  cr0|=CR0_CACHE_DISABLE;
  280dfb:	0d 00 00 00 60       	or     $0x60000000,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  280e00:	0f 22 c0             	mov    %eax,%cr0
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
 {
  flg486=1;
  280e03:	b3 01                	mov    $0x1,%bl
  cr0|=CR0_CACHE_DISABLE;
  lcr0(cr0);
 }


i=getmemorysize(start,end);
  280e05:	ff 75 0c             	pushl  0xc(%ebp)
  280e08:	ff 75 08             	pushl  0x8(%ebp)
  280e0b:	e8 8f ff ff ff       	call   280d9f <getmemorysize>
//i=0x100000;

  if(flg486)
  280e10:	84 db                	test   %bl,%bl
  280e12:	5a                   	pop    %edx
  280e13:	59                   	pop    %ecx
  280e14:	74 0c                	je     280e22 <memtest+0x49>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  280e16:	0f 20 c2             	mov    %cr0,%edx
  {
  cr0=rcr0();
  cr0&=~CR0_CACHE_DISABLE;
  280e19:	81 e2 ff ff ff 9f    	and    $0x9fffffff,%edx
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  280e1f:	0f 22 c2             	mov    %edx,%cr0
  lcr0(cr0);

  }

  return i;
}
  280e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280e25:	c9                   	leave  
  280e26:	c3                   	ret    

00280e27 <memman_init>:


void memman_init(Memman * man)
{
  280e27:	55                   	push   %ebp
  280e28:	89 e5                	mov    %esp,%ebp
  280e2a:	8b 45 08             	mov    0x8(%ebp),%eax
 man->cellnum=0;
  280e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 man->maxcell=0;
  280e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 man->lostsize=0;
  280e3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
 man->losts=0;
  280e41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  280e48:	5d                   	pop    %ebp
  280e49:	c3                   	ret    

00280e4a <memman_avail>:
//get available memory
unsigned int memman_avail(Memman *man)
{
  280e4a:	55                   	push   %ebp
 unsigned int i;
 unsigned int freemem=0;
  280e4b:	31 c0                	xor    %eax,%eax
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  280e4d:	89 e5                	mov    %esp,%ebp
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  280e4f:	31 d2                	xor    %edx,%edx
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
  280e51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  280e54:	53                   	push   %ebx
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  280e55:	8b 19                	mov    (%ecx),%ebx
  280e57:	39 da                	cmp    %ebx,%edx
  280e59:	74 07                	je     280e62 <memman_avail+0x18>
 {
   freemem+=man->cell[i].size;
  280e5b:	03 44 d1 14          	add    0x14(%ecx,%edx,8),%eax
//get available memory
unsigned int memman_avail(Memman *man)
{
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
  280e5f:	42                   	inc    %edx
  280e60:	eb f5                	jmp    280e57 <memman_avail+0xd>
 {
   freemem+=man->cell[i].size;
 }
 return freemem;
}
  280e62:	5b                   	pop    %ebx
  280e63:	5d                   	pop    %ebp
  280e64:	c3                   	ret    

00280e65 <memman_alloc>:
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  280e65:	55                   	push   %ebp
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  280e66:	31 d2                	xor    %edx,%edx
 }
 return freemem;
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
  280e68:	89 e5                	mov    %esp,%ebp
  280e6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  280e6d:	57                   	push   %edi
  280e6e:	56                   	push   %esi
  280e6f:	53                   	push   %ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  280e70:	8b 39                	mov    (%ecx),%edi
  280e72:	39 fa                	cmp    %edi,%edx
  280e74:	74 43                	je     280eb9 <memman_alloc+0x54>
    {
        if(man->cell[i].size>size)
  280e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  280e79:	39 44 d1 14          	cmp    %eax,0x14(%ecx,%edx,8)
  280e7d:	76 37                	jbe    280eb6 <memman_alloc+0x51>
  280e7f:	8d 34 d1             	lea    (%ecx,%edx,8),%esi
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
  280e82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
  280e85:	8b 46 10             	mov    0x10(%esi),%eax
            man->cell[i].address+=size;
  280e88:	01 c3                	add    %eax,%ebx
  280e8a:	89 5e 10             	mov    %ebx,0x10(%esi)
            man->cell[i].size-=size;
  280e8d:	8b 5e 14             	mov    0x14(%esi),%ebx
  280e90:	2b 5d 0c             	sub    0xc(%ebp),%ebx
            if(man->cell[i].size==0)
  280e93:	85 db                	test   %ebx,%ebx
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
            man->cell[i].size-=size;
  280e95:	89 5e 14             	mov    %ebx,0x14(%esi)
            if(man->cell[i].size==0)
  280e98:	75 21                	jne    280ebb <memman_alloc+0x56>
            {
                man->cellnum--;
  280e9a:	8d 5f ff             	lea    -0x1(%edi),%ebx
  280e9d:	89 19                	mov    %ebx,(%ecx)
                for(;i<man->cellnum;i++)
  280e9f:	39 da                	cmp    %ebx,%edx
  280ea1:	73 18                	jae    280ebb <memman_alloc+0x56>
                {
                    man->cell[i]=man->cell[i+1];
  280ea3:	42                   	inc    %edx
  280ea4:	8b 74 d1 10          	mov    0x10(%ecx,%edx,8),%esi
  280ea8:	8b 7c d1 14          	mov    0x14(%ecx,%edx,8),%edi
  280eac:	89 74 d1 08          	mov    %esi,0x8(%ecx,%edx,8)
  280eb0:	89 7c d1 0c          	mov    %edi,0xc(%ecx,%edx,8)
  280eb4:	eb e9                	jmp    280e9f <memman_alloc+0x3a>
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
  280eb6:	42                   	inc    %edx
  280eb7:	eb b9                	jmp    280e72 <memman_alloc+0xd>
            }

            return a;
        }
    }
    return 0; //no memory can be used
  280eb9:	31 c0                	xor    %eax,%eax
}
  280ebb:	5b                   	pop    %ebx
  280ebc:	5e                   	pop    %esi
  280ebd:	5f                   	pop    %edi
  280ebe:	5d                   	pop    %ebp
  280ebf:	c3                   	ret    

00280ec0 <memman_free>:

//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  280ec0:	55                   	push   %ebp
  int i,j;
  for (i=0;i<man->cellnum;i++)
  280ec1:	31 d2                	xor    %edx,%edx
    return 0; //no memory can be used
}

//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  280ec3:	89 e5                	mov    %esp,%ebp
  280ec5:	57                   	push   %edi
  280ec6:	56                   	push   %esi
  280ec7:	53                   	push   %ebx
  280ec8:	83 ec 08             	sub    $0x8,%esp
  280ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  280ece:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i,j;
  for (i=0;i<man->cellnum;i++)
  280ed1:	8b 18                	mov    (%eax),%ebx
  280ed3:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  280ed6:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  280ed9:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  280edc:	74 09                	je     280ee7 <memman_free+0x27>
  {
    if(man->cell[i].address>addr)//这一步可以找到一个合适的i的地址范围
  280ede:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  280ee1:	39 5c d0 10          	cmp    %ebx,0x10(%eax,%edx,8)
  280ee5:	76 06                	jbe    280eed <memman_free+0x2d>
    }
  }

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  280ee7:	85 d2                	test   %edx,%edx
  280ee9:	75 05                	jne    280ef0 <memman_free+0x30>
  280eeb:	eb 4c                	jmp    280f39 <memman_free+0x79>

//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  int i,j;
  for (i=0;i<man->cellnum;i++)
  280eed:	42                   	inc    %edx
  280eee:	eb e9                	jmp    280ed9 <memman_free+0x19>
  280ef0:	8d 5c d0 f8          	lea    -0x8(%eax,%edx,8),%ebx

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
  280ef4:	8b 73 14             	mov    0x14(%ebx),%esi
  280ef7:	8b 4b 10             	mov    0x10(%ebx),%ecx
  280efa:	01 f1                	add    %esi,%ecx
  280efc:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
  280eff:	75 38                	jne    280f39 <memman_free+0x79>
    {
        man->cell[i-1].size+=size;
  280f01:	01 fe                	add    %edi,%esi
        if(i<man->cellnum)
  280f03:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
    {
        man->cell[i-1].size+=size;
  280f06:	89 73 14             	mov    %esi,0x14(%ebx)
        if(i<man->cellnum)
  280f09:	73 49                	jae    280f54 <memman_free+0x94>
  280f0b:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
        {
            if(addr+size==man->cell[i].address)
  280f0e:	03 7d 0c             	add    0xc(%ebp),%edi
  280f11:	3b 79 10             	cmp    0x10(%ecx),%edi
  280f14:	75 3e                	jne    280f54 <memman_free+0x94>
            {
                man->cell[i-1].size+=man->cell[i].size;
  280f16:	03 71 14             	add    0x14(%ecx),%esi
  280f19:	89 73 14             	mov    %esi,0x14(%ebx)
                man->cellnum--;
  280f1c:	8b 75 f0             	mov    -0x10(%ebp),%esi
  280f1f:	4e                   	dec    %esi
  280f20:	89 30                	mov    %esi,(%eax)

                for(;i<man->cellnum;i++)
  280f22:	39 f2                	cmp    %esi,%edx
  280f24:	73 2e                	jae    280f54 <memman_free+0x94>
                {
                man->cell[i]=man->cell[i+1];
  280f26:	42                   	inc    %edx
  280f27:	8b 4c d0 10          	mov    0x10(%eax,%edx,8),%ecx
  280f2b:	8b 5c d0 14          	mov    0x14(%eax,%edx,8),%ebx
  280f2f:	89 4c d0 08          	mov    %ecx,0x8(%eax,%edx,8)
  280f33:	89 5c d0 0c          	mov    %ebx,0xc(%eax,%edx,8)
  280f37:	eb e9                	jmp    280f22 <memman_free+0x62>
     //printdebug(200,100);

  }

  //与后面的空间合并
  if(i<man->cellnum)
  280f39:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  280f3c:	73 1a                	jae    280f58 <memman_free+0x98>
  {
     if(addr+size==man->cell[i].address)
  280f3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  280f41:	8d 1c d0             	lea    (%eax,%edx,8),%ebx
  280f44:	01 fe                	add    %edi,%esi
  280f46:	3b 73 10             	cmp    0x10(%ebx),%esi
  280f49:	75 0d                	jne    280f58 <memman_free+0x98>
     {
        man->cell[i].address=addr;
  280f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
        man->cell[i].size+=size;
  280f4e:	01 7b 14             	add    %edi,0x14(%ebx)
  //与后面的空间合并
  if(i<man->cellnum)
  {
     if(addr+size==man->cell[i].address)
     {
        man->cell[i].address=addr;
  280f51:	89 43 10             	mov    %eax,0x10(%ebx)
        man->cell[i].size+=size;

        return 0;
  280f54:	31 c0                	xor    %eax,%eax
  280f56:	eb 4b                	jmp    280fa3 <memman_free+0xe3>
     }
  }

  if(man->cellnum<4090)
  280f58:	81 7d f0 f9 0f 00 00 	cmpl   $0xff9,-0x10(%ebp)
  280f5f:	77 39                	ja     280f9a <memman_free+0xda>
  {
        for(j=man->cellnum;j>i;j--)
  280f61:	39 55 ec             	cmp    %edx,-0x14(%ebp)
  280f64:	7e 18                	jle    280f7e <memman_free+0xbe>
        {
            man->cell[j]=man->cell[j-1];
  280f66:	ff 4d ec             	decl   -0x14(%ebp)
  280f69:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  280f6c:	8b 5c c8 10          	mov    0x10(%eax,%ecx,8),%ebx
  280f70:	8b 74 c8 14          	mov    0x14(%eax,%ecx,8),%esi
  280f74:	89 5c c8 18          	mov    %ebx,0x18(%eax,%ecx,8)
  280f78:	89 74 c8 1c          	mov    %esi,0x1c(%eax,%ecx,8)
  280f7c:	eb e3                	jmp    280f61 <memman_free+0xa1>
        }

        man->cellnum++;
  280f7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  280f81:	41                   	inc    %ecx
        if(man->maxcell<man->cellnum)
  280f82:	39 48 04             	cmp    %ecx,0x4(%eax)
        for(j=man->cellnum;j>i;j--)
        {
            man->cell[j]=man->cell[j-1];
        }

        man->cellnum++;
  280f85:	89 08                	mov    %ecx,(%eax)
        if(man->maxcell<man->cellnum)
  280f87:	73 03                	jae    280f8c <memman_free+0xcc>
        {
            man->maxcell=man->cellnum;
  280f89:	89 48 04             	mov    %ecx,0x4(%eax)
  280f8c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        }
        man->cell[i].address=addr;
  280f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
        man->cell[i].size=size;
  280f92:	89 78 14             	mov    %edi,0x14(%eax)
        man->cellnum++;
        if(man->maxcell<man->cellnum)
        {
            man->maxcell=man->cellnum;
        }
        man->cell[i].address=addr;
  280f95:	89 50 10             	mov    %edx,0x10(%eax)
  280f98:	eb ba                	jmp    280f54 <memman_free+0x94>
       // printdebug(man->cellnum,100);
        return 0;
  }


  man->losts++;
  280f9a:	ff 40 0c             	incl   0xc(%eax)
  man->lostsize+=size;
  280f9d:	01 78 08             	add    %edi,0x8(%eax)

  return  -1;
  280fa0:	83 c8 ff             	or     $0xffffffff,%eax





}
  280fa3:	5a                   	pop    %edx
  280fa4:	59                   	pop    %ecx
  280fa5:	5b                   	pop    %ebx
  280fa6:	5e                   	pop    %esi
  280fa7:	5f                   	pop    %edi
  280fa8:	5d                   	pop    %ebp
  280fa9:	c3                   	ret    

Disassembly of section .rodata:

00280fac <Font8x16>:
	...
  2811bc:	00 00                	add    %al,(%eax)
  2811be:	00 10                	add    %dl,(%eax)
  2811c0:	10 10                	adc    %dl,(%eax)
  2811c2:	10 10                	adc    %dl,(%eax)
  2811c4:	10 00                	adc    %al,(%eax)
  2811c6:	10 10                	adc    %dl,(%eax)
  2811c8:	00 00                	add    %al,(%eax)
  2811ca:	00 00                	add    %al,(%eax)
  2811cc:	00 00                	add    %al,(%eax)
  2811ce:	00 24 24             	add    %ah,(%esp)
  2811d1:	24 00                	and    $0x0,%al
	...
  2811df:	24 24                	and    $0x24,%al
  2811e1:	7e 24                	jle    281207 <Font8x16+0x25b>
  2811e3:	24 24                	and    $0x24,%al
  2811e5:	7e 24                	jle    28120b <Font8x16+0x25f>
  2811e7:	24 00                	and    $0x0,%al
  2811e9:	00 00                	add    %al,(%eax)
  2811eb:	00 00                	add    %al,(%eax)
  2811ed:	00 00                	add    %al,(%eax)
  2811ef:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  2811f3:	7c 12                	jl     281207 <Font8x16+0x25b>
  2811f5:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  2811f9:	00 00                	add    %al,(%eax)
  2811fb:	00 00                	add    %al,(%eax)
  2811fd:	00 00                	add    %al,(%eax)
  2811ff:	00 62 64             	add    %ah,0x64(%edx)
  281202:	08 10                	or     %dl,(%eax)
  281204:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  281210:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  281213:	50                   	push   %eax
  281214:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  28121b:	00 00                	add    %al,(%eax)
  28121d:	00 00                	add    %al,(%eax)
  28121f:	10 10                	adc    %dl,(%eax)
  281221:	20 00                	and    %al,(%eax)
	...
  28122b:	00 00                	add    %al,(%eax)
  28122d:	00 08                	add    %cl,(%eax)
  28122f:	10 20                	adc    %ah,(%eax)
  281231:	20 20                	and    %ah,(%eax)
  281233:	20 20                	and    %ah,(%eax)
  281235:	20 20                	and    %ah,(%eax)
  281237:	10 08                	adc    %cl,(%eax)
  281239:	00 00                	add    %al,(%eax)
  28123b:	00 00                	add    %al,(%eax)
  28123d:	00 20                	add    %ah,(%eax)
  28123f:	10 08                	adc    %cl,(%eax)
  281241:	08 08                	or     %cl,(%eax)
  281243:	08 08                	or     %cl,(%eax)
  281245:	08 08                	or     %cl,(%eax)
  281247:	10 20                	adc    %ah,(%eax)
	...
  281251:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  281255:	54                   	push   %esp
  281256:	10 00                	adc    %al,(%eax)
	...
  281260:	00 10                	add    %dl,(%eax)
  281262:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  281276:	10 10                	adc    %dl,(%eax)
  281278:	20 00                	and    %al,(%eax)
	...
  281282:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  281296:	00 10                	add    %dl,(%eax)
	...
  2812a0:	00 02                	add    %al,(%edx)
  2812a2:	04 08                	add    $0x8,%al
  2812a4:	10 20                	adc    %ah,(%eax)
  2812a6:	40                   	inc    %eax
	...
  2812af:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  2812b3:	54                   	push   %esp
  2812b4:	64                   	fs
  2812b5:	44                   	inc    %esp
  2812b6:	44                   	inc    %esp
  2812b7:	38 00                	cmp    %al,(%eax)
  2812b9:	00 00                	add    %al,(%eax)
  2812bb:	00 00                	add    %al,(%eax)
  2812bd:	00 00                	add    %al,(%eax)
  2812bf:	10 30                	adc    %dh,(%eax)
  2812c1:	10 10                	adc    %dl,(%eax)
  2812c3:	10 10                	adc    %dl,(%eax)
  2812c5:	10 10                	adc    %dl,(%eax)
  2812c7:	38 00                	cmp    %al,(%eax)
  2812c9:	00 00                	add    %al,(%eax)
  2812cb:	00 00                	add    %al,(%eax)
  2812cd:	00 00                	add    %al,(%eax)
  2812cf:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  2812d3:	08 10                	or     %dl,(%eax)
  2812d5:	20 40 7c             	and    %al,0x7c(%eax)
  2812d8:	00 00                	add    %al,(%eax)
  2812da:	00 00                	add    %al,(%eax)
  2812dc:	00 00                	add    %al,(%eax)
  2812de:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  2812e2:	10 38                	adc    %bh,(%eax)
  2812e4:	04 04                	add    $0x4,%al
  2812e6:	04 78                	add    $0x78,%al
  2812e8:	00 00                	add    %al,(%eax)
  2812ea:	00 00                	add    %al,(%eax)
  2812ec:	00 00                	add    %al,(%eax)
  2812ee:	00 08                	add    %cl,(%eax)
  2812f0:	18 28                	sbb    %ch,(%eax)
  2812f2:	48                   	dec    %eax
  2812f3:	48                   	dec    %eax
  2812f4:	7c 08                	jl     2812fe <Font8x16+0x352>
  2812f6:	08 08                	or     %cl,(%eax)
  2812f8:	00 00                	add    %al,(%eax)
  2812fa:	00 00                	add    %al,(%eax)
  2812fc:	00 00                	add    %al,(%eax)
  2812fe:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  281302:	40                   	inc    %eax
  281303:	78 04                	js     281309 <Font8x16+0x35d>
  281305:	04 04                	add    $0x4,%al
  281307:	78 00                	js     281309 <Font8x16+0x35d>
  281309:	00 00                	add    %al,(%eax)
  28130b:	00 00                	add    %al,(%eax)
  28130d:	00 00                	add    %al,(%eax)
  28130f:	3c 40                	cmp    $0x40,%al
  281311:	40                   	inc    %eax
  281312:	40                   	inc    %eax
  281313:	78 44                	js     281359 <Font8x16+0x3ad>
  281315:	44                   	inc    %esp
  281316:	44                   	inc    %esp
  281317:	38 00                	cmp    %al,(%eax)
  281319:	00 00                	add    %al,(%eax)
  28131b:	00 00                	add    %al,(%eax)
  28131d:	00 00                	add    %al,(%eax)
  28131f:	7c 04                	jl     281325 <Font8x16+0x379>
  281321:	04 08                	add    $0x8,%al
  281323:	10 20                	adc    %ah,(%eax)
  281325:	20 20                	and    %ah,(%eax)
  281327:	20 00                	and    %al,(%eax)
  281329:	00 00                	add    %al,(%eax)
  28132b:	00 00                	add    %al,(%eax)
  28132d:	00 00                	add    %al,(%eax)
  28132f:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281333:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281337:	38 00                	cmp    %al,(%eax)
  281339:	00 00                	add    %al,(%eax)
  28133b:	00 00                	add    %al,(%eax)
  28133d:	00 00                	add    %al,(%eax)
  28133f:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  281343:	3c 04                	cmp    $0x4,%al
  281345:	04 04                	add    $0x4,%al
  281347:	38 00                	cmp    %al,(%eax)
	...
  281351:	00 00                	add    %al,(%eax)
  281353:	10 00                	adc    %al,(%eax)
  281355:	00 10                	add    %dl,(%eax)
	...
  281363:	00 10                	add    %dl,(%eax)
  281365:	00 10                	add    %dl,(%eax)
  281367:	10 20                	adc    %ah,(%eax)
	...
  281371:	04 08                	add    $0x8,%al
  281373:	10 20                	adc    %ah,(%eax)
  281375:	10 08                	adc    %cl,(%eax)
  281377:	04 00                	add    $0x0,%al
	...
  281381:	00 00                	add    %al,(%eax)
  281383:	7c 00                	jl     281385 <Font8x16+0x3d9>
  281385:	7c 00                	jl     281387 <Font8x16+0x3db>
	...
  28138f:	00 00                	add    %al,(%eax)
  281391:	20 10                	and    %dl,(%eax)
  281393:	08 04 08             	or     %al,(%eax,%ecx,1)
  281396:	10 20                	adc    %ah,(%eax)
  281398:	00 00                	add    %al,(%eax)
  28139a:	00 00                	add    %al,(%eax)
  28139c:	00 00                	add    %al,(%eax)
  28139e:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  2813a2:	08 10                	or     %dl,(%eax)
  2813a4:	10 00                	adc    %al,(%eax)
  2813a6:	10 10                	adc    %dl,(%eax)
	...
  2813b0:	00 38                	add    %bh,(%eax)
  2813b2:	44                   	inc    %esp
  2813b3:	5c                   	pop    %esp
  2813b4:	54                   	push   %esp
  2813b5:	5c                   	pop    %esp
  2813b6:	40                   	inc    %eax
  2813b7:	3c 00                	cmp    $0x0,%al
  2813b9:	00 00                	add    %al,(%eax)
  2813bb:	00 00                	add    %al,(%eax)
  2813bd:	00 18                	add    %bl,(%eax)
  2813bf:	24 42                	and    $0x42,%al
  2813c1:	42                   	inc    %edx
  2813c2:	42                   	inc    %edx
  2813c3:	7e 42                	jle    281407 <Font8x16+0x45b>
  2813c5:	42                   	inc    %edx
  2813c6:	42                   	inc    %edx
  2813c7:	42                   	inc    %edx
  2813c8:	00 00                	add    %al,(%eax)
  2813ca:	00 00                	add    %al,(%eax)
  2813cc:	00 00                	add    %al,(%eax)
  2813ce:	7c 42                	jl     281412 <Font8x16+0x466>
  2813d0:	42                   	inc    %edx
  2813d1:	42                   	inc    %edx
  2813d2:	7c 42                	jl     281416 <Font8x16+0x46a>
  2813d4:	42                   	inc    %edx
  2813d5:	42                   	inc    %edx
  2813d6:	42                   	inc    %edx
  2813d7:	7c 00                	jl     2813d9 <Font8x16+0x42d>
  2813d9:	00 00                	add    %al,(%eax)
  2813db:	00 00                	add    %al,(%eax)
  2813dd:	00 3c 42             	add    %bh,(%edx,%eax,2)
  2813e0:	40                   	inc    %eax
  2813e1:	40                   	inc    %eax
  2813e2:	40                   	inc    %eax
  2813e3:	40                   	inc    %eax
  2813e4:	40                   	inc    %eax
  2813e5:	40                   	inc    %eax
  2813e6:	42                   	inc    %edx
  2813e7:	3c 00                	cmp    $0x0,%al
  2813e9:	00 00                	add    %al,(%eax)
  2813eb:	00 00                	add    %al,(%eax)
  2813ed:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  2813f1:	42                   	inc    %edx
  2813f2:	42                   	inc    %edx
  2813f3:	42                   	inc    %edx
  2813f4:	42                   	inc    %edx
  2813f5:	42                   	inc    %edx
  2813f6:	42                   	inc    %edx
  2813f7:	7c 00                	jl     2813f9 <Font8x16+0x44d>
  2813f9:	00 00                	add    %al,(%eax)
  2813fb:	00 00                	add    %al,(%eax)
  2813fd:	00 7e 40             	add    %bh,0x40(%esi)
  281400:	40                   	inc    %eax
  281401:	40                   	inc    %eax
  281402:	78 40                	js     281444 <Font8x16+0x498>
  281404:	40                   	inc    %eax
  281405:	40                   	inc    %eax
  281406:	40                   	inc    %eax
  281407:	7e 00                	jle    281409 <Font8x16+0x45d>
  281409:	00 00                	add    %al,(%eax)
  28140b:	00 00                	add    %al,(%eax)
  28140d:	00 7e 40             	add    %bh,0x40(%esi)
  281410:	40                   	inc    %eax
  281411:	40                   	inc    %eax
  281412:	78 40                	js     281454 <Font8x16+0x4a8>
  281414:	40                   	inc    %eax
  281415:	40                   	inc    %eax
  281416:	40                   	inc    %eax
  281417:	40                   	inc    %eax
  281418:	00 00                	add    %al,(%eax)
  28141a:	00 00                	add    %al,(%eax)
  28141c:	00 00                	add    %al,(%eax)
  28141e:	3c 42                	cmp    $0x42,%al
  281420:	40                   	inc    %eax
  281421:	40                   	inc    %eax
  281422:	5e                   	pop    %esi
  281423:	42                   	inc    %edx
  281424:	42                   	inc    %edx
  281425:	42                   	inc    %edx
  281426:	42                   	inc    %edx
  281427:	3c 00                	cmp    $0x0,%al
  281429:	00 00                	add    %al,(%eax)
  28142b:	00 00                	add    %al,(%eax)
  28142d:	00 42 42             	add    %al,0x42(%edx)
  281430:	42                   	inc    %edx
  281431:	42                   	inc    %edx
  281432:	7e 42                	jle    281476 <Font8x16+0x4ca>
  281434:	42                   	inc    %edx
  281435:	42                   	inc    %edx
  281436:	42                   	inc    %edx
  281437:	42                   	inc    %edx
  281438:	00 00                	add    %al,(%eax)
  28143a:	00 00                	add    %al,(%eax)
  28143c:	00 00                	add    %al,(%eax)
  28143e:	38 10                	cmp    %dl,(%eax)
  281440:	10 10                	adc    %dl,(%eax)
  281442:	10 10                	adc    %dl,(%eax)
  281444:	10 10                	adc    %dl,(%eax)
  281446:	10 38                	adc    %bh,(%eax)
  281448:	00 00                	add    %al,(%eax)
  28144a:	00 00                	add    %al,(%eax)
  28144c:	00 00                	add    %al,(%eax)
  28144e:	1c 08                	sbb    $0x8,%al
  281450:	08 08                	or     %cl,(%eax)
  281452:	08 08                	or     %cl,(%eax)
  281454:	08 08                	or     %cl,(%eax)
  281456:	48                   	dec    %eax
  281457:	30 00                	xor    %al,(%eax)
  281459:	00 00                	add    %al,(%eax)
  28145b:	00 00                	add    %al,(%eax)
  28145d:	00 42 44             	add    %al,0x44(%edx)
  281460:	48                   	dec    %eax
  281461:	50                   	push   %eax
  281462:	60                   	pusha  
  281463:	60                   	pusha  
  281464:	50                   	push   %eax
  281465:	48                   	dec    %eax
  281466:	44                   	inc    %esp
  281467:	42                   	inc    %edx
  281468:	00 00                	add    %al,(%eax)
  28146a:	00 00                	add    %al,(%eax)
  28146c:	00 00                	add    %al,(%eax)
  28146e:	40                   	inc    %eax
  28146f:	40                   	inc    %eax
  281470:	40                   	inc    %eax
  281471:	40                   	inc    %eax
  281472:	40                   	inc    %eax
  281473:	40                   	inc    %eax
  281474:	40                   	inc    %eax
  281475:	40                   	inc    %eax
  281476:	40                   	inc    %eax
  281477:	7e 00                	jle    281479 <Font8x16+0x4cd>
  281479:	00 00                	add    %al,(%eax)
  28147b:	00 00                	add    %al,(%eax)
  28147d:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  281483:	aa                   	stos   %al,%es:(%edi)
  281484:	92                   	xchg   %eax,%edx
  281485:	92                   	xchg   %eax,%edx
  281486:	82                   	(bad)  
  281487:	82                   	(bad)  
  281488:	00 00                	add    %al,(%eax)
  28148a:	00 00                	add    %al,(%eax)
  28148c:	00 00                	add    %al,(%eax)
  28148e:	42                   	inc    %edx
  28148f:	62 62 52             	bound  %esp,0x52(%edx)
  281492:	52                   	push   %edx
  281493:	4a                   	dec    %edx
  281494:	4a                   	dec    %edx
  281495:	46                   	inc    %esi
  281496:	46                   	inc    %esi
  281497:	42                   	inc    %edx
  281498:	00 00                	add    %al,(%eax)
  28149a:	00 00                	add    %al,(%eax)
  28149c:	00 00                	add    %al,(%eax)
  28149e:	3c 42                	cmp    $0x42,%al
  2814a0:	42                   	inc    %edx
  2814a1:	42                   	inc    %edx
  2814a2:	42                   	inc    %edx
  2814a3:	42                   	inc    %edx
  2814a4:	42                   	inc    %edx
  2814a5:	42                   	inc    %edx
  2814a6:	42                   	inc    %edx
  2814a7:	3c 00                	cmp    $0x0,%al
  2814a9:	00 00                	add    %al,(%eax)
  2814ab:	00 00                	add    %al,(%eax)
  2814ad:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  2814b1:	42                   	inc    %edx
  2814b2:	42                   	inc    %edx
  2814b3:	7c 40                	jl     2814f5 <Font8x16+0x549>
  2814b5:	40                   	inc    %eax
  2814b6:	40                   	inc    %eax
  2814b7:	40                   	inc    %eax
  2814b8:	00 00                	add    %al,(%eax)
  2814ba:	00 00                	add    %al,(%eax)
  2814bc:	00 00                	add    %al,(%eax)
  2814be:	3c 42                	cmp    $0x42,%al
  2814c0:	42                   	inc    %edx
  2814c1:	42                   	inc    %edx
  2814c2:	42                   	inc    %edx
  2814c3:	42                   	inc    %edx
  2814c4:	42                   	inc    %edx
  2814c5:	42                   	inc    %edx
  2814c6:	4a                   	dec    %edx
  2814c7:	3c 0e                	cmp    $0xe,%al
  2814c9:	00 00                	add    %al,(%eax)
  2814cb:	00 00                	add    %al,(%eax)
  2814cd:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  2814d1:	42                   	inc    %edx
  2814d2:	42                   	inc    %edx
  2814d3:	7c 50                	jl     281525 <Font8x16+0x579>
  2814d5:	48                   	dec    %eax
  2814d6:	44                   	inc    %esp
  2814d7:	42                   	inc    %edx
  2814d8:	00 00                	add    %al,(%eax)
  2814da:	00 00                	add    %al,(%eax)
  2814dc:	00 00                	add    %al,(%eax)
  2814de:	3c 42                	cmp    $0x42,%al
  2814e0:	40                   	inc    %eax
  2814e1:	40                   	inc    %eax
  2814e2:	3c 02                	cmp    $0x2,%al
  2814e4:	02 02                	add    (%edx),%al
  2814e6:	42                   	inc    %edx
  2814e7:	3c 00                	cmp    $0x0,%al
  2814e9:	00 00                	add    %al,(%eax)
  2814eb:	00 00                	add    %al,(%eax)
  2814ed:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  2814f1:	10 10                	adc    %dl,(%eax)
  2814f3:	10 10                	adc    %dl,(%eax)
  2814f5:	10 10                	adc    %dl,(%eax)
  2814f7:	10 00                	adc    %al,(%eax)
  2814f9:	00 00                	add    %al,(%eax)
  2814fb:	00 00                	add    %al,(%eax)
  2814fd:	00 42 42             	add    %al,0x42(%edx)
  281500:	42                   	inc    %edx
  281501:	42                   	inc    %edx
  281502:	42                   	inc    %edx
  281503:	42                   	inc    %edx
  281504:	42                   	inc    %edx
  281505:	42                   	inc    %edx
  281506:	42                   	inc    %edx
  281507:	3c 00                	cmp    $0x0,%al
  281509:	00 00                	add    %al,(%eax)
  28150b:	00 00                	add    %al,(%eax)
  28150d:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  281511:	44                   	inc    %esp
  281512:	28 28                	sub    %ch,(%eax)
  281514:	28 10                	sub    %dl,(%eax)
  281516:	10 10                	adc    %dl,(%eax)
  281518:	00 00                	add    %al,(%eax)
  28151a:	00 00                	add    %al,(%eax)
  28151c:	00 00                	add    %al,(%eax)
  28151e:	82                   	(bad)  
  28151f:	82                   	(bad)  
  281520:	82                   	(bad)  
  281521:	82                   	(bad)  
  281522:	54                   	push   %esp
  281523:	54                   	push   %esp
  281524:	54                   	push   %esp
  281525:	28 28                	sub    %ch,(%eax)
  281527:	28 00                	sub    %al,(%eax)
  281529:	00 00                	add    %al,(%eax)
  28152b:	00 00                	add    %al,(%eax)
  28152d:	00 42 42             	add    %al,0x42(%edx)
  281530:	24 18                	and    $0x18,%al
  281532:	18 18                	sbb    %bl,(%eax)
  281534:	24 24                	and    $0x24,%al
  281536:	42                   	inc    %edx
  281537:	42                   	inc    %edx
  281538:	00 00                	add    %al,(%eax)
  28153a:	00 00                	add    %al,(%eax)
  28153c:	00 00                	add    %al,(%eax)
  28153e:	44                   	inc    %esp
  28153f:	44                   	inc    %esp
  281540:	44                   	inc    %esp
  281541:	44                   	inc    %esp
  281542:	28 28                	sub    %ch,(%eax)
  281544:	10 10                	adc    %dl,(%eax)
  281546:	10 10                	adc    %dl,(%eax)
  281548:	00 00                	add    %al,(%eax)
  28154a:	00 00                	add    %al,(%eax)
  28154c:	00 00                	add    %al,(%eax)
  28154e:	7e 02                	jle    281552 <Font8x16+0x5a6>
  281550:	02 04 08             	add    (%eax,%ecx,1),%al
  281553:	10 20                	adc    %ah,(%eax)
  281555:	40                   	inc    %eax
  281556:	40                   	inc    %eax
  281557:	7e 00                	jle    281559 <Font8x16+0x5ad>
  281559:	00 00                	add    %al,(%eax)
  28155b:	00 00                	add    %al,(%eax)
  28155d:	00 38                	add    %bh,(%eax)
  28155f:	20 20                	and    %ah,(%eax)
  281561:	20 20                	and    %ah,(%eax)
  281563:	20 20                	and    %ah,(%eax)
  281565:	20 20                	and    %ah,(%eax)
  281567:	38 00                	cmp    %al,(%eax)
	...
  281571:	00 40 20             	add    %al,0x20(%eax)
  281574:	10 08                	adc    %cl,(%eax)
  281576:	04 02                	add    $0x2,%al
  281578:	00 00                	add    %al,(%eax)
  28157a:	00 00                	add    %al,(%eax)
  28157c:	00 00                	add    %al,(%eax)
  28157e:	1c 04                	sbb    $0x4,%al
  281580:	04 04                	add    $0x4,%al
  281582:	04 04                	add    $0x4,%al
  281584:	04 04                	add    $0x4,%al
  281586:	04 1c                	add    $0x1c,%al
	...
  281590:	10 28                	adc    %ch,(%eax)
  281592:	44                   	inc    %esp
	...
  2815a7:	00 ff                	add    %bh,%bh
  2815a9:	00 00                	add    %al,(%eax)
  2815ab:	00 00                	add    %al,(%eax)
  2815ad:	00 00                	add    %al,(%eax)
  2815af:	10 10                	adc    %dl,(%eax)
  2815b1:	08 00                	or     %al,(%eax)
	...
  2815bf:	00 00                	add    %al,(%eax)
  2815c1:	78 04                	js     2815c7 <Font8x16+0x61b>
  2815c3:	3c 44                	cmp    $0x44,%al
  2815c5:	44                   	inc    %esp
  2815c6:	44                   	inc    %esp
  2815c7:	3a 00                	cmp    (%eax),%al
  2815c9:	00 00                	add    %al,(%eax)
  2815cb:	00 00                	add    %al,(%eax)
  2815cd:	00 40 40             	add    %al,0x40(%eax)
  2815d0:	40                   	inc    %eax
  2815d1:	5c                   	pop    %esp
  2815d2:	62 42 42             	bound  %eax,0x42(%edx)
  2815d5:	42                   	inc    %edx
  2815d6:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  2815da:	00 00                	add    %al,(%eax)
  2815dc:	00 00                	add    %al,(%eax)
  2815de:	00 00                	add    %al,(%eax)
  2815e0:	00 3c 42             	add    %bh,(%edx,%eax,2)
  2815e3:	40                   	inc    %eax
  2815e4:	40                   	inc    %eax
  2815e5:	40                   	inc    %eax
  2815e6:	42                   	inc    %edx
  2815e7:	3c 00                	cmp    $0x0,%al
  2815e9:	00 00                	add    %al,(%eax)
  2815eb:	00 00                	add    %al,(%eax)
  2815ed:	00 02                	add    %al,(%edx)
  2815ef:	02 02                	add    (%edx),%al
  2815f1:	3a 46 42             	cmp    0x42(%esi),%al
  2815f4:	42                   	inc    %edx
  2815f5:	42                   	inc    %edx
  2815f6:	46                   	inc    %esi
  2815f7:	3a 00                	cmp    (%eax),%al
	...
  281601:	3c 42                	cmp    $0x42,%al
  281603:	42                   	inc    %edx
  281604:	7e 40                	jle    281646 <Font8x16+0x69a>
  281606:	42                   	inc    %edx
  281607:	3c 00                	cmp    $0x0,%al
  281609:	00 00                	add    %al,(%eax)
  28160b:	00 00                	add    %al,(%eax)
  28160d:	00 0e                	add    %cl,(%esi)
  28160f:	10 10                	adc    %dl,(%eax)
  281611:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  281614:	10 10                	adc    %dl,(%eax)
  281616:	10 10                	adc    %dl,(%eax)
	...
  281620:	00 3e                	add    %bh,(%esi)
  281622:	42                   	inc    %edx
  281623:	42                   	inc    %edx
  281624:	42                   	inc    %edx
  281625:	42                   	inc    %edx
  281626:	3e 02 02             	add    %ds:(%edx),%al
  281629:	3c 00                	cmp    $0x0,%al
  28162b:	00 00                	add    %al,(%eax)
  28162d:	00 40 40             	add    %al,0x40(%eax)
  281630:	40                   	inc    %eax
  281631:	5c                   	pop    %esp
  281632:	62 42 42             	bound  %eax,0x42(%edx)
  281635:	42                   	inc    %edx
  281636:	42                   	inc    %edx
  281637:	42                   	inc    %edx
  281638:	00 00                	add    %al,(%eax)
  28163a:	00 00                	add    %al,(%eax)
  28163c:	00 00                	add    %al,(%eax)
  28163e:	00 08                	add    %cl,(%eax)
  281640:	00 08                	add    %cl,(%eax)
  281642:	08 08                	or     %cl,(%eax)
  281644:	08 08                	or     %cl,(%eax)
  281646:	08 08                	or     %cl,(%eax)
  281648:	00 00                	add    %al,(%eax)
  28164a:	00 00                	add    %al,(%eax)
  28164c:	00 00                	add    %al,(%eax)
  28164e:	00 04 00             	add    %al,(%eax,%eax,1)
  281651:	04 04                	add    $0x4,%al
  281653:	04 04                	add    $0x4,%al
  281655:	04 04                	add    $0x4,%al
  281657:	04 44                	add    $0x44,%al
  281659:	38 00                	cmp    %al,(%eax)
  28165b:	00 00                	add    %al,(%eax)
  28165d:	00 40 40             	add    %al,0x40(%eax)
  281660:	40                   	inc    %eax
  281661:	42                   	inc    %edx
  281662:	44                   	inc    %esp
  281663:	48                   	dec    %eax
  281664:	50                   	push   %eax
  281665:	68 44 42 00 00       	push   $0x4244
  28166a:	00 00                	add    %al,(%eax)
  28166c:	00 00                	add    %al,(%eax)
  28166e:	10 10                	adc    %dl,(%eax)
  281670:	10 10                	adc    %dl,(%eax)
  281672:	10 10                	adc    %dl,(%eax)
  281674:	10 10                	adc    %dl,(%eax)
  281676:	10 10                	adc    %dl,(%eax)
	...
  281680:	00 ec                	add    %ch,%ah
  281682:	92                   	xchg   %eax,%edx
  281683:	92                   	xchg   %eax,%edx
  281684:	92                   	xchg   %eax,%edx
  281685:	92                   	xchg   %eax,%edx
  281686:	92                   	xchg   %eax,%edx
  281687:	92                   	xchg   %eax,%edx
	...
  281690:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  281694:	42                   	inc    %edx
  281695:	42                   	inc    %edx
  281696:	42                   	inc    %edx
  281697:	42                   	inc    %edx
	...
  2816a0:	00 3c 42             	add    %bh,(%edx,%eax,2)
  2816a3:	42                   	inc    %edx
  2816a4:	42                   	inc    %edx
  2816a5:	42                   	inc    %edx
  2816a6:	42                   	inc    %edx
  2816a7:	3c 00                	cmp    $0x0,%al
	...
  2816b1:	5c                   	pop    %esp
  2816b2:	62 42 42             	bound  %eax,0x42(%edx)
  2816b5:	42                   	inc    %edx
  2816b6:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  2816ba:	00 00                	add    %al,(%eax)
  2816bc:	00 00                	add    %al,(%eax)
  2816be:	00 00                	add    %al,(%eax)
  2816c0:	00 3a                	add    %bh,(%edx)
  2816c2:	46                   	inc    %esi
  2816c3:	42                   	inc    %edx
  2816c4:	42                   	inc    %edx
  2816c5:	42                   	inc    %edx
  2816c6:	46                   	inc    %esi
  2816c7:	3a 02                	cmp    (%edx),%al
  2816c9:	02 00                	add    (%eax),%al
  2816cb:	00 00                	add    %al,(%eax)
  2816cd:	00 00                	add    %al,(%eax)
  2816cf:	00 00                	add    %al,(%eax)
  2816d1:	5c                   	pop    %esp
  2816d2:	62 40 40             	bound  %eax,0x40(%eax)
  2816d5:	40                   	inc    %eax
  2816d6:	40                   	inc    %eax
  2816d7:	40                   	inc    %eax
	...
  2816e0:	00 3c 42             	add    %bh,(%edx,%eax,2)
  2816e3:	40                   	inc    %eax
  2816e4:	3c 02                	cmp    $0x2,%al
  2816e6:	42                   	inc    %edx
  2816e7:	3c 00                	cmp    $0x0,%al
  2816e9:	00 00                	add    %al,(%eax)
  2816eb:	00 00                	add    %al,(%eax)
  2816ed:	00 00                	add    %al,(%eax)
  2816ef:	20 20                	and    %ah,(%eax)
  2816f1:	78 20                	js     281713 <Font8x16+0x767>
  2816f3:	20 20                	and    %ah,(%eax)
  2816f5:	20 22                	and    %ah,(%edx)
  2816f7:	1c 00                	sbb    $0x0,%al
	...
  281701:	42                   	inc    %edx
  281702:	42                   	inc    %edx
  281703:	42                   	inc    %edx
  281704:	42                   	inc    %edx
  281705:	42                   	inc    %edx
  281706:	42                   	inc    %edx
  281707:	3e 00 00             	add    %al,%ds:(%eax)
  28170a:	00 00                	add    %al,(%eax)
  28170c:	00 00                	add    %al,(%eax)
  28170e:	00 00                	add    %al,(%eax)
  281710:	00 42 42             	add    %al,0x42(%edx)
  281713:	42                   	inc    %edx
  281714:	42                   	inc    %edx
  281715:	42                   	inc    %edx
  281716:	24 18                	and    $0x18,%al
	...
  281720:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  281726:	aa                   	stos   %al,%es:(%edi)
  281727:	44                   	inc    %esp
	...
  281730:	00 42 42             	add    %al,0x42(%edx)
  281733:	24 18                	and    $0x18,%al
  281735:	24 42                	and    $0x42,%al
  281737:	42                   	inc    %edx
	...
  281740:	00 42 42             	add    %al,0x42(%edx)
  281743:	42                   	inc    %edx
  281744:	42                   	inc    %edx
  281745:	42                   	inc    %edx
  281746:	3e 02 02             	add    %ds:(%edx),%al
  281749:	3c 00                	cmp    $0x0,%al
  28174b:	00 00                	add    %al,(%eax)
  28174d:	00 00                	add    %al,(%eax)
  28174f:	00 00                	add    %al,(%eax)
  281751:	7e 02                	jle    281755 <Font8x16+0x7a9>
  281753:	04 18                	add    $0x18,%al
  281755:	20 40 7e             	and    %al,0x7e(%eax)
  281758:	00 00                	add    %al,(%eax)
  28175a:	00 00                	add    %al,(%eax)
  28175c:	00 00                	add    %al,(%eax)
  28175e:	08 10                	or     %dl,(%eax)
  281760:	10 10                	adc    %dl,(%eax)
  281762:	20 40 20             	and    %al,0x20(%eax)
  281765:	10 10                	adc    %dl,(%eax)
  281767:	10 08                	adc    %cl,(%eax)
  281769:	00 00                	add    %al,(%eax)
  28176b:	00 00                	add    %al,(%eax)
  28176d:	10 10                	adc    %dl,(%eax)
  28176f:	10 10                	adc    %dl,(%eax)
  281771:	10 10                	adc    %dl,(%eax)
  281773:	10 10                	adc    %dl,(%eax)
  281775:	10 10                	adc    %dl,(%eax)
  281777:	10 10                	adc    %dl,(%eax)
  281779:	10 10                	adc    %dl,(%eax)
  28177b:	00 00                	add    %al,(%eax)
  28177d:	00 20                	add    %ah,(%eax)
  28177f:	10 10                	adc    %dl,(%eax)
  281781:	10 08                	adc    %cl,(%eax)
  281783:	04 08                	add    $0x8,%al
  281785:	10 10                	adc    %dl,(%eax)
  281787:	10 20                	adc    %ah,(%eax)
	...
  281791:	00 22                	add    %ah,(%edx)
  281793:	54                   	push   %esp
  281794:	88 00                	mov    %al,(%eax)
	...

002817ac <ASCII_Table>:
	...
  2817dc:	00 00                	add    %al,(%eax)
  2817de:	80 01 80             	addb   $0x80,(%ecx)
  2817e1:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2817e7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2817ed:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2817f3:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  2817f9:	00 00                	add    %al,(%eax)
  2817fb:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  28180d:	00 00                	add    %al,(%eax)
  28180f:	00 cc                	add    %cl,%ah
  281811:	00 cc                	add    %cl,%ah
  281813:	00 cc                	add    %cl,%ah
  281815:	00 cc                	add    %cl,%ah
  281817:	00 cc                	add    %cl,%ah
  281819:	00 cc                	add    %cl,%ah
	...
  281847:	00 60 0c             	add    %ah,0xc(%eax)
  28184a:	60                   	pusha  
  28184b:	0c 60                	or     $0x60,%al
  28184d:	0c 30                	or     $0x30,%al
  28184f:	06                   	push   %es
  281850:	30 06                	xor    %al,(%esi)
  281852:	fe                   	(bad)  
  281853:	1f                   	pop    %ds
  281854:	fe                   	(bad)  
  281855:	1f                   	pop    %ds
  281856:	30 06                	xor    %al,(%esi)
  281858:	38 07                	cmp    %al,(%edi)
  28185a:	18 03                	sbb    %al,(%ebx)
  28185c:	fe                   	(bad)  
  28185d:	1f                   	pop    %ds
  28185e:	fe                   	(bad)  
  28185f:	1f                   	pop    %ds
  281860:	18 03                	sbb    %al,(%ebx)
  281862:	18 03                	sbb    %al,(%ebx)
  281864:	8c 01                	mov    %es,(%ecx)
  281866:	8c 01                	mov    %es,(%ecx)
  281868:	8c 01                	mov    %es,(%ecx)
  28186a:	00 00                	add    %al,(%eax)
  28186c:	00 00                	add    %al,(%eax)
  28186e:	80 00 e0             	addb   $0xe0,(%eax)
  281871:	03 f8                	add    %eax,%edi
  281873:	0f 9c 0e             	setl   (%esi)
  281876:	8c 1c 8c             	mov    %ds,(%esp,%ecx,4)
  281879:	18 8c 00 98 00 f8 01 	sbb    %cl,0x1f80098(%eax,%eax,1)
  281880:	e0 07                	loopne 281889 <ASCII_Table+0xdd>
  281882:	80 0e 80             	orb    $0x80,(%esi)
  281885:	1c 8c                	sbb    $0x8c,%al
  281887:	18 8c 18 9c 18 b8 0c 	sbb    %cl,0xcb8189c(%eax,%ebx,1)
  28188e:	f0 0f e0 03          	lock pavgb (%ebx),%mm0
  281892:	80 00 80             	addb   $0x80,(%eax)
	...
  2818a1:	00 0e                	add    %cl,(%esi)
  2818a3:	18 1b                	sbb    %bl,(%ebx)
  2818a5:	0c 11                	or     $0x11,%al
  2818a7:	0c 11                	or     $0x11,%al
  2818a9:	06                   	push   %es
  2818aa:	11 06                	adc    %eax,(%esi)
  2818ac:	11 03                	adc    %eax,(%ebx)
  2818ae:	11 03                	adc    %eax,(%ebx)
  2818b0:	9b                   	fwait
  2818b1:	01 8e 01 c0 38 c0    	add    %ecx,-0x3fc73fff(%esi)
  2818b7:	6c                   	insb   (%dx),%es:(%edi)
  2818b8:	60                   	pusha  
  2818b9:	44                   	inc    %esp
  2818ba:	60                   	pusha  
  2818bb:	44                   	inc    %esp
  2818bc:	30 44 30 44          	xor    %al,0x44(%eax,%esi,1)
  2818c0:	18 44 18 6c          	sbb    %al,0x6c(%eax,%ebx,1)
  2818c4:	0c 38                	or     $0x38,%al
	...
  2818ce:	e0 01                	loopne 2818d1 <ASCII_Table+0x125>
  2818d0:	f0 03 38             	lock add (%eax),%edi
  2818d3:	07                   	pop    %es
  2818d4:	18 06                	sbb    %al,(%esi)
  2818d6:	18 06                	sbb    %al,(%esi)
  2818d8:	30 03                	xor    %al,(%ebx)
  2818da:	f0 01 f0             	lock add %esi,%eax
  2818dd:	00 f8                	add    %bh,%al
  2818df:	00 9c 31 0e 33 06 1e 	add    %bl,0x1e06330e(%ecx,%esi,1)
  2818e6:	06                   	push   %es
  2818e7:	1c 06                	sbb    $0x6,%al
  2818e9:	1c 06                	sbb    $0x6,%al
  2818eb:	3f                   	aas    
  2818ec:	fc                   	cld    
  2818ed:	73 f0                	jae    2818df <ASCII_Table+0x133>
  2818ef:	21 00                	and    %eax,(%eax)
	...
  2818fd:	00 00                	add    %al,(%eax)
  2818ff:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281902:	0c 00                	or     $0x0,%al
  281904:	0c 00                	or     $0x0,%al
  281906:	0c 00                	or     $0x0,%al
  281908:	0c 00                	or     $0x0,%al
  28190a:	0c 00                	or     $0x0,%al
	...
  28192c:	00 00                	add    %al,(%eax)
  28192e:	00 02                	add    %al,(%edx)
  281930:	00 03                	add    %al,(%ebx)
  281932:	80 01 c0             	addb   $0xc0,(%ecx)
  281935:	00 c0                	add    %al,%al
  281937:	00 60 00             	add    %ah,0x0(%eax)
  28193a:	60                   	pusha  
  28193b:	00 30                	add    %dh,(%eax)
  28193d:	00 30                	add    %dh,(%eax)
  28193f:	00 30                	add    %dh,(%eax)
  281941:	00 30                	add    %dh,(%eax)
  281943:	00 30                	add    %dh,(%eax)
  281945:	00 30                	add    %dh,(%eax)
  281947:	00 30                	add    %dh,(%eax)
  281949:	00 30                	add    %dh,(%eax)
  28194b:	00 60 00             	add    %ah,0x0(%eax)
  28194e:	60                   	pusha  
  28194f:	00 c0                	add    %al,%al
  281951:	00 c0                	add    %al,%al
  281953:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  281959:	02 00                	add    (%eax),%al
  28195b:	00 00                	add    %al,(%eax)
  28195d:	00 20                	add    %ah,(%eax)
  28195f:	00 60 00             	add    %ah,0x0(%eax)
  281962:	c0 00 80             	rolb   $0x80,(%eax)
  281965:	01 80 01 00 03 00    	add    %eax,0x30001(%eax)
  28196b:	03 00                	add    (%eax),%eax
  28196d:	06                   	push   %es
  28196e:	00 06                	add    %al,(%esi)
  281970:	00 06                	add    %al,(%esi)
  281972:	00 06                	add    %al,(%esi)
  281974:	00 06                	add    %al,(%esi)
  281976:	00 06                	add    %al,(%esi)
  281978:	00 06                	add    %al,(%esi)
  28197a:	00 06                	add    %al,(%esi)
  28197c:	00 03                	add    %al,(%ebx)
  28197e:	00 03                	add    %al,(%ebx)
  281980:	80 01 80             	addb   $0x80,(%ecx)
  281983:	01 c0                	add    %eax,%eax
  281985:	00 60 00             	add    %ah,0x0(%eax)
  281988:	20 00                	and    %al,(%eax)
	...
  281996:	00 00                	add    %al,(%eax)
  281998:	c0 00 c0             	rolb   $0xc0,(%eax)
  28199b:	00 d8                	add    %bl,%al
  28199d:	06                   	push   %es
  28199e:	f8                   	clc    
  28199f:	07                   	pop    %es
  2819a0:	e0 01                	loopne 2819a3 <ASCII_Table+0x1f7>
  2819a2:	30 03                	xor    %al,(%ebx)
  2819a4:	38 07                	cmp    %al,(%edi)
	...
  2819c6:	00 00                	add    %al,(%eax)
  2819c8:	80 01 80             	addb   $0x80,(%ecx)
  2819cb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2819d1:	01 fc                	add    %edi,%esp
  2819d3:	3f                   	aas    
  2819d4:	fc                   	cld    
  2819d5:	3f                   	aas    
  2819d6:	80 01 80             	addb   $0x80,(%ecx)
  2819d9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2819df:	01 00                	add    %eax,(%eax)
	...
  281a0d:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281a13:	01 00                	add    %eax,(%eax)
  281a15:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281a33:	00 e0                	add    %ah,%al
  281a35:	07                   	pop    %es
  281a36:	e0 07                	loopne 281a3f <ASCII_Table+0x293>
	...
  281a6c:	00 00                	add    %al,(%eax)
  281a6e:	c0 00 c0             	rolb   $0xc0,(%eax)
	...
  281a7d:	00 00                	add    %al,(%eax)
  281a7f:	0c 00                	or     $0x0,%al
  281a81:	0c 00                	or     $0x0,%al
  281a83:	06                   	push   %es
  281a84:	00 06                	add    %al,(%esi)
  281a86:	00 06                	add    %al,(%esi)
  281a88:	00 03                	add    %al,(%ebx)
  281a8a:	00 03                	add    %al,(%ebx)
  281a8c:	00 03                	add    %al,(%ebx)
  281a8e:	80 03 80             	addb   $0x80,(%ebx)
  281a91:	01 80 01 80 01 c0    	add    %eax,-0x3ffe7fff(%eax)
  281a97:	00 c0                	add    %al,%al
  281a99:	00 c0                	add    %al,%al
  281a9b:	00 60 00             	add    %ah,0x0(%eax)
  281a9e:	60                   	pusha  
	...
  281aab:	00 00                	add    %al,(%eax)
  281aad:	00 e0                	add    %ah,%al
  281aaf:	03 f0                	add    %eax,%esi
  281ab1:	07                   	pop    %es
  281ab2:	38 0e                	cmp    %cl,(%esi)
  281ab4:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  281ab7:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281aba:	0c 18                	or     $0x18,%al
  281abc:	0c 18                	or     $0x18,%al
  281abe:	0c 18                	or     $0x18,%al
  281ac0:	0c 18                	or     $0x18,%al
  281ac2:	0c 18                	or     $0x18,%al
  281ac4:	0c 18                	or     $0x18,%al
  281ac6:	0c 18                	or     $0x18,%al
  281ac8:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  281acb:	0e                   	push   %cs
  281acc:	f0 07                	lock pop %es
  281ace:	e0 03                	loopne 281ad3 <ASCII_Table+0x327>
	...
  281adc:	00 00                	add    %al,(%eax)
  281ade:	00 01                	add    %al,(%ecx)
  281ae0:	80 01 c0             	addb   $0xc0,(%ecx)
  281ae3:	01 f0                	add    %esi,%eax
  281ae5:	01 98 01 88 01 80    	add    %ebx,-0x7ffe77ff(%eax)
  281aeb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281af1:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281af7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281afd:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  281b0b:	00 00                	add    %al,(%eax)
  281b0d:	00 e0                	add    %ah,%al
  281b0f:	03 f8                	add    %eax,%edi
  281b11:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  281b15:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281b18:	00 18                	add    %bl,(%eax)
  281b1a:	00 18                	add    %bl,(%eax)
  281b1c:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281b1f:	06                   	push   %es
  281b20:	00 03                	add    %al,(%ebx)
  281b22:	80 01 c0             	addb   $0xc0,(%ecx)
  281b25:	00 60 00             	add    %ah,0x0(%eax)
  281b28:	30 00                	xor    %al,(%eax)
  281b2a:	18 00                	sbb    %al,(%eax)
  281b2c:	fc                   	cld    
  281b2d:	1f                   	pop    %ds
  281b2e:	fc                   	cld    
  281b2f:	1f                   	pop    %ds
	...
  281b3c:	00 00                	add    %al,(%eax)
  281b3e:	e0 01                	loopne 281b41 <ASCII_Table+0x395>
  281b40:	f8                   	clc    
  281b41:	07                   	pop    %es
  281b42:	18 0e                	sbb    %cl,(%esi)
  281b44:	0c 0c                	or     $0xc,%al
  281b46:	0c 0c                	or     $0xc,%al
  281b48:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281b4b:	06                   	push   %es
  281b4c:	c0 03 c0             	rolb   $0xc0,(%ebx)
  281b4f:	07                   	pop    %es
  281b50:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281b53:	18 00                	sbb    %al,(%eax)
  281b55:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281b58:	0c 18                	or     $0x18,%al
  281b5a:	18 0c f8             	sbb    %cl,(%eax,%edi,8)
  281b5d:	07                   	pop    %es
  281b5e:	e0 03                	loopne 281b63 <ASCII_Table+0x3b7>
	...
  281b6c:	00 00                	add    %al,(%eax)
  281b6e:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281b71:	0e                   	push   %cs
  281b72:	00 0f                	add    %cl,(%edi)
  281b74:	00 0f                	add    %cl,(%edi)
  281b76:	80 0d c0 0c 60 0c 60 	orb    $0x60,0xc600cc0
  281b7d:	0c 30                	or     $0x30,%al
  281b7f:	0c 18                	or     $0x18,%al
  281b81:	0c 0c                	or     $0xc,%al
  281b83:	0c fc                	or     $0xfc,%al
  281b85:	3f                   	aas    
  281b86:	fc                   	cld    
  281b87:	3f                   	aas    
  281b88:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281b8b:	0c 00                	or     $0x0,%al
  281b8d:	0c 00                	or     $0x0,%al
  281b8f:	0c 00                	or     $0x0,%al
	...
  281b9d:	00 f8                	add    %bh,%al
  281b9f:	0f f8 0f             	psubb  (%edi),%mm1
  281ba2:	18 00                	sbb    %al,(%eax)
  281ba4:	18 00                	sbb    %al,(%eax)
  281ba6:	0c 00                	or     $0x0,%al
  281ba8:	ec                   	in     (%dx),%al
  281ba9:	03 fc                	add    %esp,%edi
  281bab:	07                   	pop    %es
  281bac:	1c 0e                	sbb    $0xe,%al
  281bae:	00 1c 00             	add    %bl,(%eax,%eax,1)
  281bb1:	18 00                	sbb    %al,(%eax)
  281bb3:	18 00                	sbb    %al,(%eax)
  281bb5:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281bb8:	1c 0c                	sbb    $0xc,%al
  281bba:	18 0e                	sbb    %cl,(%esi)
  281bbc:	f8                   	clc    
  281bbd:	07                   	pop    %es
  281bbe:	e0 03                	loopne 281bc3 <ASCII_Table+0x417>
	...
  281bcc:	00 00                	add    %al,(%eax)
  281bce:	c0 07 f0             	rolb   $0xf0,(%edi)
  281bd1:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281bd5:	18 18                	sbb    %bl,(%eax)
  281bd7:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281bda:	cc                   	int3   
  281bdb:	03 ec                	add    %esp,%ebp
  281bdd:	0f 3c                	(bad)  
  281bdf:	0e                   	push   %cs
  281be0:	1c 1c                	sbb    $0x1c,%al
  281be2:	0c 18                	or     $0x18,%al
  281be4:	0c 18                	or     $0x18,%al
  281be6:	0c 18                	or     $0x18,%al
  281be8:	18 1c 38             	sbb    %bl,(%eax,%edi,1)
  281beb:	0e                   	push   %cs
  281bec:	f0 07                	lock pop %es
  281bee:	e0 03                	loopne 281bf3 <ASCII_Table+0x447>
	...
  281bfc:	00 00                	add    %al,(%eax)
  281bfe:	fc                   	cld    
  281bff:	1f                   	pop    %ds
  281c00:	fc                   	cld    
  281c01:	1f                   	pop    %ds
  281c02:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281c05:	06                   	push   %es
  281c06:	00 06                	add    %al,(%esi)
  281c08:	00 03                	add    %al,(%ebx)
  281c0a:	80 03 80             	addb   $0x80,(%ebx)
  281c0d:	01 c0                	add    %eax,%eax
  281c0f:	01 c0                	add    %eax,%eax
  281c11:	00 e0                	add    %ah,%al
  281c13:	00 60 00             	add    %ah,0x0(%eax)
  281c16:	60                   	pusha  
  281c17:	00 70 00             	add    %dh,0x0(%eax)
  281c1a:	30 00                	xor    %al,(%eax)
  281c1c:	30 00                	xor    %al,(%eax)
  281c1e:	30 00                	xor    %al,(%eax)
	...
  281c2c:	00 00                	add    %al,(%eax)
  281c2e:	e0 03                	loopne 281c33 <ASCII_Table+0x487>
  281c30:	f0 07                	lock pop %es
  281c32:	38 0e                	cmp    %cl,(%esi)
  281c34:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281c37:	0c 18                	or     $0x18,%al
  281c39:	0c 38                	or     $0x38,%al
  281c3b:	06                   	push   %es
  281c3c:	f0 07                	lock pop %es
  281c3e:	f0 07                	lock pop %es
  281c40:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  281c43:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281c46:	0c 18                	or     $0x18,%al
  281c48:	0c 18                	or     $0x18,%al
  281c4a:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  281c4d:	0f e0 03             	pavgb  (%ebx),%mm0
	...
  281c5c:	00 00                	add    %al,(%eax)
  281c5e:	e0 03                	loopne 281c63 <ASCII_Table+0x4b7>
  281c60:	f0 07                	lock pop %es
  281c62:	38 0e                	cmp    %cl,(%esi)
  281c64:	1c 0c                	sbb    $0xc,%al
  281c66:	0c 18                	or     $0x18,%al
  281c68:	0c 18                	or     $0x18,%al
  281c6a:	0c 18                	or     $0x18,%al
  281c6c:	1c 1c                	sbb    $0x1c,%al
  281c6e:	38 1e                	cmp    %bl,(%esi)
  281c70:	f8                   	clc    
  281c71:	1b e0                	sbb    %eax,%esp
  281c73:	19 00                	sbb    %eax,(%eax)
  281c75:	18 00                	sbb    %al,(%eax)
  281c77:	0c 00                	or     $0x0,%al
  281c79:	0c 1c                	or     $0x1c,%al
  281c7b:	0e                   	push   %cs
  281c7c:	f8                   	clc    
  281c7d:	07                   	pop    %es
  281c7e:	f0 01 00             	lock add %eax,(%eax)
	...
  281c95:	00 00                	add    %al,(%eax)
  281c97:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281ca9:	00 00                	add    %al,(%eax)
  281cab:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281cc5:	00 00                	add    %al,(%eax)
  281cc7:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281cd9:	00 00                	add    %al,(%eax)
  281cdb:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281ce1:	01 00                	add    %eax,(%eax)
  281ce3:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281cfd:	10 00                	adc    %al,(%eax)
  281cff:	1c 80                	sbb    $0x80,%al
  281d01:	0f e0 03             	pavgb  (%ebx),%mm0
  281d04:	f8                   	clc    
  281d05:	00 18                	add    %bl,(%eax)
  281d07:	00 f8                	add    %bh,%al
  281d09:	00 e0                	add    %ah,%al
  281d0b:	03 80 0f 00 1c 00    	add    0x1c000f(%eax),%eax
  281d11:	10 00                	adc    %al,(%eax)
	...
  281d2b:	00 f8                	add    %bh,%al
  281d2d:	1f                   	pop    %ds
  281d2e:	00 00                	add    %al,(%eax)
  281d30:	00 00                	add    %al,(%eax)
  281d32:	00 00                	add    %al,(%eax)
  281d34:	f8                   	clc    
  281d35:	1f                   	pop    %ds
	...
  281d5a:	00 00                	add    %al,(%eax)
  281d5c:	08 00                	or     %al,(%eax)
  281d5e:	38 00                	cmp    %al,(%eax)
  281d60:	f0 01 c0             	lock add %eax,%eax
  281d63:	07                   	pop    %es
  281d64:	00 1f                	add    %bl,(%edi)
  281d66:	00 18                	add    %bl,(%eax)
  281d68:	00 1f                	add    %bl,(%edi)
  281d6a:	c0 07 f0             	rolb   $0xf0,(%edi)
  281d6d:	01 38                	add    %edi,(%eax)
  281d6f:	00 08                	add    %cl,(%eax)
	...
  281d7d:	00 e0                	add    %ah,%al
  281d7f:	03 f8                	add    %eax,%edi
  281d81:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  281d85:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281d88:	00 18                	add    %bl,(%eax)
  281d8a:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281d8d:	06                   	push   %es
  281d8e:	00 03                	add    %al,(%ebx)
  281d90:	80 01 c0             	addb   $0xc0,(%ecx)
  281d93:	00 c0                	add    %al,%al
  281d95:	00 c0                	add    %al,%al
  281d97:	00 00                	add    %al,(%eax)
  281d99:	00 00                	add    %al,(%eax)
  281d9b:	00 c0                	add    %al,%al
  281d9d:	00 c0                	add    %al,%al
	...
  281daf:	00 e0                	add    %ah,%al
  281db1:	07                   	pop    %es
  281db2:	18 18                	sbb    %bl,(%eax)
  281db4:	04 20                	add    $0x20,%al
  281db6:	c2 29 22             	ret    $0x2229
  281db9:	4a                   	dec    %edx
  281dba:	11 44 09 44          	adc    %eax,0x44(%ecx,%ecx,1)
  281dbe:	09 44 09 44          	or     %eax,0x44(%ecx,%ecx,1)
  281dc2:	09 22                	or     %esp,(%edx)
  281dc4:	11 13                	adc    %edx,(%ebx)
  281dc6:	e2 0c                	loop   281dd4 <ASCII_Table+0x628>
  281dc8:	02 40 04             	add    0x4(%eax),%al
  281dcb:	20 18                	and    %bl,(%eax)
  281dcd:	18 e0                	sbb    %ah,%al
  281dcf:	07                   	pop    %es
	...
  281ddc:	00 00                	add    %al,(%eax)
  281dde:	80 03 80             	addb   $0x80,(%ebx)
  281de1:	03 c0                	add    %eax,%eax
  281de3:	06                   	push   %es
  281de4:	c0 06 c0             	rolb   $0xc0,(%esi)
  281de7:	06                   	push   %es
  281de8:	60                   	pusha  
  281de9:	0c 60                	or     $0x60,%al
  281deb:	0c 30                	or     $0x30,%al
  281ded:	18 30                	sbb    %dh,(%eax)
  281def:	18 30                	sbb    %dh,(%eax)
  281df1:	18 f8                	sbb    %bh,%al
  281df3:	3f                   	aas    
  281df4:	f8                   	clc    
  281df5:	3f                   	aas    
  281df6:	1c 70                	sbb    $0x70,%al
  281df8:	0c 60                	or     $0x60,%al
  281dfa:	0c 60                	or     $0x60,%al
  281dfc:	06                   	push   %es
  281dfd:	c0 06 c0             	rolb   $0xc0,(%esi)
	...
  281e0c:	00 00                	add    %al,(%eax)
  281e0e:	fc                   	cld    
  281e0f:	03 fc                	add    %esp,%edi
  281e11:	0f 0c                	(bad)  
  281e13:	0c 0c                	or     $0xc,%al
  281e15:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281e18:	0c 18                	or     $0x18,%al
  281e1a:	0c 0c                	or     $0xc,%al
  281e1c:	fc                   	cld    
  281e1d:	07                   	pop    %es
  281e1e:	fc                   	cld    
  281e1f:	0f 0c                	(bad)  
  281e21:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  281e24:	0c 30                	or     $0x30,%al
  281e26:	0c 30                	or     $0x30,%al
  281e28:	0c 30                	or     $0x30,%al
  281e2a:	0c 18                	or     $0x18,%al
  281e2c:	fc                   	cld    
  281e2d:	1f                   	pop    %ds
  281e2e:	fc                   	cld    
  281e2f:	07                   	pop    %es
	...
  281e3c:	00 00                	add    %al,(%eax)
  281e3e:	c0 07 f0             	rolb   $0xf0,(%edi)
  281e41:	1f                   	pop    %ds
  281e42:	38 38                	cmp    %bh,(%eax)
  281e44:	1c 30                	sbb    $0x30,%al
  281e46:	0c 70                	or     $0x70,%al
  281e48:	06                   	push   %es
  281e49:	60                   	pusha  
  281e4a:	06                   	push   %es
  281e4b:	00 06                	add    %al,(%esi)
  281e4d:	00 06                	add    %al,(%esi)
  281e4f:	00 06                	add    %al,(%esi)
  281e51:	00 06                	add    %al,(%esi)
  281e53:	00 06                	add    %al,(%esi)
  281e55:	00 06                	add    %al,(%esi)
  281e57:	60                   	pusha  
  281e58:	0c 70                	or     $0x70,%al
  281e5a:	1c 30                	sbb    $0x30,%al
  281e5c:	f0 1f                	lock pop %ds
  281e5e:	e0 07                	loopne 281e67 <ASCII_Table+0x6bb>
	...
  281e6c:	00 00                	add    %al,(%eax)
  281e6e:	fe 03                	incb   (%ebx)
  281e70:	fe 0f                	decb   (%edi)
  281e72:	06                   	push   %es
  281e73:	0e                   	push   %cs
  281e74:	06                   	push   %es
  281e75:	18 06                	sbb    %al,(%esi)
  281e77:	18 06                	sbb    %al,(%esi)
  281e79:	30 06                	xor    %al,(%esi)
  281e7b:	30 06                	xor    %al,(%esi)
  281e7d:	30 06                	xor    %al,(%esi)
  281e7f:	30 06                	xor    %al,(%esi)
  281e81:	30 06                	xor    %al,(%esi)
  281e83:	30 06                	xor    %al,(%esi)
  281e85:	30 06                	xor    %al,(%esi)
  281e87:	18 06                	sbb    %al,(%esi)
  281e89:	18 06                	sbb    %al,(%esi)
  281e8b:	0e                   	push   %cs
  281e8c:	fe 0f                	decb   (%edi)
  281e8e:	fe 03                	incb   (%ebx)
	...
  281e9c:	00 00                	add    %al,(%eax)
  281e9e:	fc                   	cld    
  281e9f:	3f                   	aas    
  281ea0:	fc                   	cld    
  281ea1:	3f                   	aas    
  281ea2:	0c 00                	or     $0x0,%al
  281ea4:	0c 00                	or     $0x0,%al
  281ea6:	0c 00                	or     $0x0,%al
  281ea8:	0c 00                	or     $0x0,%al
  281eaa:	0c 00                	or     $0x0,%al
  281eac:	fc                   	cld    
  281ead:	1f                   	pop    %ds
  281eae:	fc                   	cld    
  281eaf:	1f                   	pop    %ds
  281eb0:	0c 00                	or     $0x0,%al
  281eb2:	0c 00                	or     $0x0,%al
  281eb4:	0c 00                	or     $0x0,%al
  281eb6:	0c 00                	or     $0x0,%al
  281eb8:	0c 00                	or     $0x0,%al
  281eba:	0c 00                	or     $0x0,%al
  281ebc:	fc                   	cld    
  281ebd:	3f                   	aas    
  281ebe:	fc                   	cld    
  281ebf:	3f                   	aas    
	...
  281ecc:	00 00                	add    %al,(%eax)
  281ece:	f8                   	clc    
  281ecf:	3f                   	aas    
  281ed0:	f8                   	clc    
  281ed1:	3f                   	aas    
  281ed2:	18 00                	sbb    %al,(%eax)
  281ed4:	18 00                	sbb    %al,(%eax)
  281ed6:	18 00                	sbb    %al,(%eax)
  281ed8:	18 00                	sbb    %al,(%eax)
  281eda:	18 00                	sbb    %al,(%eax)
  281edc:	f8                   	clc    
  281edd:	1f                   	pop    %ds
  281ede:	f8                   	clc    
  281edf:	1f                   	pop    %ds
  281ee0:	18 00                	sbb    %al,(%eax)
  281ee2:	18 00                	sbb    %al,(%eax)
  281ee4:	18 00                	sbb    %al,(%eax)
  281ee6:	18 00                	sbb    %al,(%eax)
  281ee8:	18 00                	sbb    %al,(%eax)
  281eea:	18 00                	sbb    %al,(%eax)
  281eec:	18 00                	sbb    %al,(%eax)
  281eee:	18 00                	sbb    %al,(%eax)
	...
  281efc:	00 00                	add    %al,(%eax)
  281efe:	e0 0f                	loopne 281f0f <ASCII_Table+0x763>
  281f00:	f8                   	clc    
  281f01:	3f                   	aas    
  281f02:	3c 78                	cmp    $0x78,%al
  281f04:	0e                   	push   %cs
  281f05:	60                   	pusha  
  281f06:	06                   	push   %es
  281f07:	e0 07                	loopne 281f10 <ASCII_Table+0x764>
  281f09:	c0 03 00             	rolb   $0x0,(%ebx)
  281f0c:	03 00                	add    (%eax),%eax
  281f0e:	03 fe                	add    %esi,%edi
  281f10:	03 fe                	add    %esi,%edi
  281f12:	03 c0                	add    %eax,%eax
  281f14:	07                   	pop    %es
  281f15:	c0 06 c0             	rolb   $0xc0,(%esi)
  281f18:	0e                   	push   %cs
  281f19:	c0 3c f0 f8          	sarb   $0xf8,(%eax,%esi,8)
  281f1d:	3f                   	aas    
  281f1e:	e0 0f                	loopne 281f2f <ASCII_Table+0x783>
	...
  281f2c:	00 00                	add    %al,(%eax)
  281f2e:	0c 30                	or     $0x30,%al
  281f30:	0c 30                	or     $0x30,%al
  281f32:	0c 30                	or     $0x30,%al
  281f34:	0c 30                	or     $0x30,%al
  281f36:	0c 30                	or     $0x30,%al
  281f38:	0c 30                	or     $0x30,%al
  281f3a:	0c 30                	or     $0x30,%al
  281f3c:	fc                   	cld    
  281f3d:	3f                   	aas    
  281f3e:	fc                   	cld    
  281f3f:	3f                   	aas    
  281f40:	0c 30                	or     $0x30,%al
  281f42:	0c 30                	or     $0x30,%al
  281f44:	0c 30                	or     $0x30,%al
  281f46:	0c 30                	or     $0x30,%al
  281f48:	0c 30                	or     $0x30,%al
  281f4a:	0c 30                	or     $0x30,%al
  281f4c:	0c 30                	or     $0x30,%al
  281f4e:	0c 30                	or     $0x30,%al
	...
  281f5c:	00 00                	add    %al,(%eax)
  281f5e:	80 01 80             	addb   $0x80,(%ecx)
  281f61:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f67:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f6d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f73:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f79:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281f7f:	01 00                	add    %eax,(%eax)
	...
  281f8d:	00 00                	add    %al,(%eax)
  281f8f:	06                   	push   %es
  281f90:	00 06                	add    %al,(%esi)
  281f92:	00 06                	add    %al,(%esi)
  281f94:	00 06                	add    %al,(%esi)
  281f96:	00 06                	add    %al,(%esi)
  281f98:	00 06                	add    %al,(%esi)
  281f9a:	00 06                	add    %al,(%esi)
  281f9c:	00 06                	add    %al,(%esi)
  281f9e:	00 06                	add    %al,(%esi)
  281fa0:	00 06                	add    %al,(%esi)
  281fa2:	00 06                	add    %al,(%esi)
  281fa4:	00 06                	add    %al,(%esi)
  281fa6:	18 06                	sbb    %al,(%esi)
  281fa8:	18 06                	sbb    %al,(%esi)
  281faa:	38 07                	cmp    %al,(%edi)
  281fac:	f0 03 e0             	lock add %eax,%esp
  281faf:	01 00                	add    %eax,(%eax)
	...
  281fbd:	00 06                	add    %al,(%esi)
  281fbf:	30 06                	xor    %al,(%esi)
  281fc1:	18 06                	sbb    %al,(%esi)
  281fc3:	0c 06                	or     $0x6,%al
  281fc5:	06                   	push   %es
  281fc6:	06                   	push   %es
  281fc7:	03 86 01 c6 00 66    	add    0x6600c601(%esi),%eax
  281fcd:	00 76 00             	add    %dh,0x0(%esi)
  281fd0:	de 00                	fiadd  (%eax)
  281fd2:	8e 01                	mov    (%ecx),%es
  281fd4:	06                   	push   %es
  281fd5:	03 06                	add    (%esi),%eax
  281fd7:	06                   	push   %es
  281fd8:	06                   	push   %es
  281fd9:	0c 06                	or     $0x6,%al
  281fdb:	18 06                	sbb    %al,(%esi)
  281fdd:	30 06                	xor    %al,(%esi)
  281fdf:	60                   	pusha  
	...
  281fec:	00 00                	add    %al,(%eax)
  281fee:	18 00                	sbb    %al,(%eax)
  281ff0:	18 00                	sbb    %al,(%eax)
  281ff2:	18 00                	sbb    %al,(%eax)
  281ff4:	18 00                	sbb    %al,(%eax)
  281ff6:	18 00                	sbb    %al,(%eax)
  281ff8:	18 00                	sbb    %al,(%eax)
  281ffa:	18 00                	sbb    %al,(%eax)
  281ffc:	18 00                	sbb    %al,(%eax)
  281ffe:	18 00                	sbb    %al,(%eax)
  282000:	18 00                	sbb    %al,(%eax)
  282002:	18 00                	sbb    %al,(%eax)
  282004:	18 00                	sbb    %al,(%eax)
  282006:	18 00                	sbb    %al,(%eax)
  282008:	18 00                	sbb    %al,(%eax)
  28200a:	18 00                	sbb    %al,(%eax)
  28200c:	f8                   	clc    
  28200d:	1f                   	pop    %ds
  28200e:	f8                   	clc    
  28200f:	1f                   	pop    %ds
	...
  28201c:	00 00                	add    %al,(%eax)
  28201e:	0e                   	push   %cs
  28201f:	e0 1e                	loopne 28203f <ASCII_Table+0x893>
  282021:	f0 1e                	lock push %ds
  282023:	f0 1e                	lock push %ds
  282025:	f0 36 d8 36          	lock fdivs %ss:(%esi)
  282029:	d8 36                	fdivs  (%esi)
  28202b:	d8 36                	fdivs  (%esi)
  28202d:	d8 66 cc             	fsubs  -0x34(%esi)
  282030:	66                   	data16
  282031:	cc                   	int3   
  282032:	66                   	data16
  282033:	cc                   	int3   
  282034:	c6 c6 c6             	mov    $0xc6,%dh
  282037:	c6 c6 c6             	mov    $0xc6,%dh
  28203a:	c6 c6 86             	mov    $0x86,%dh
  28203d:	c3                   	ret    
  28203e:	86 c3                	xchg   %al,%bl
	...
  28204c:	00 00                	add    %al,(%eax)
  28204e:	0c 30                	or     $0x30,%al
  282050:	1c 30                	sbb    $0x30,%al
  282052:	3c 30                	cmp    $0x30,%al
  282054:	3c 30                	cmp    $0x30,%al
  282056:	6c                   	insb   (%dx),%es:(%edi)
  282057:	30 6c 30 cc          	xor    %ch,-0x34(%eax,%esi,1)
  28205b:	30 cc                	xor    %cl,%ah
  28205d:	30 8c 31 0c 33 0c 33 	xor    %cl,0x330c330c(%ecx,%esi,1)
  282064:	0c 36                	or     $0x36,%al
  282066:	0c 36                	or     $0x36,%al
  282068:	0c 3c                	or     $0x3c,%al
  28206a:	0c 3c                	or     $0x3c,%al
  28206c:	0c 38                	or     $0x38,%al
  28206e:	0c 30                	or     $0x30,%al
	...
  28207c:	00 00                	add    %al,(%eax)
  28207e:	e0 07                	loopne 282087 <ASCII_Table+0x8db>
  282080:	f8                   	clc    
  282081:	1f                   	pop    %ds
  282082:	1c 38                	sbb    $0x38,%al
  282084:	0e                   	push   %cs
  282085:	70 06                	jo     28208d <ASCII_Table+0x8e1>
  282087:	60                   	pusha  
  282088:	03 c0                	add    %eax,%eax
  28208a:	03 c0                	add    %eax,%eax
  28208c:	03 c0                	add    %eax,%eax
  28208e:	03 c0                	add    %eax,%eax
  282090:	03 c0                	add    %eax,%eax
  282092:	03 c0                	add    %eax,%eax
  282094:	03 c0                	add    %eax,%eax
  282096:	06                   	push   %es
  282097:	60                   	pusha  
  282098:	0e                   	push   %cs
  282099:	70 1c                	jo     2820b7 <ASCII_Table+0x90b>
  28209b:	38 f8                	cmp    %bh,%al
  28209d:	1f                   	pop    %ds
  28209e:	e0 07                	loopne 2820a7 <ASCII_Table+0x8fb>
	...
  2820ac:	00 00                	add    %al,(%eax)
  2820ae:	fc                   	cld    
  2820af:	0f fc 1f             	paddb  (%edi),%mm3
  2820b2:	0c 38                	or     $0x38,%al
  2820b4:	0c 30                	or     $0x30,%al
  2820b6:	0c 30                	or     $0x30,%al
  2820b8:	0c 30                	or     $0x30,%al
  2820ba:	0c 30                	or     $0x30,%al
  2820bc:	0c 18                	or     $0x18,%al
  2820be:	fc                   	cld    
  2820bf:	1f                   	pop    %ds
  2820c0:	fc                   	cld    
  2820c1:	07                   	pop    %es
  2820c2:	0c 00                	or     $0x0,%al
  2820c4:	0c 00                	or     $0x0,%al
  2820c6:	0c 00                	or     $0x0,%al
  2820c8:	0c 00                	or     $0x0,%al
  2820ca:	0c 00                	or     $0x0,%al
  2820cc:	0c 00                	or     $0x0,%al
  2820ce:	0c 00                	or     $0x0,%al
	...
  2820dc:	00 00                	add    %al,(%eax)
  2820de:	e0 07                	loopne 2820e7 <ASCII_Table+0x93b>
  2820e0:	f8                   	clc    
  2820e1:	1f                   	pop    %ds
  2820e2:	1c 38                	sbb    $0x38,%al
  2820e4:	0e                   	push   %cs
  2820e5:	70 06                	jo     2820ed <ASCII_Table+0x941>
  2820e7:	60                   	pusha  
  2820e8:	03 e0                	add    %eax,%esp
  2820ea:	03 c0                	add    %eax,%eax
  2820ec:	03 c0                	add    %eax,%eax
  2820ee:	03 c0                	add    %eax,%eax
  2820f0:	03 c0                	add    %eax,%eax
  2820f2:	03 c0                	add    %eax,%eax
  2820f4:	07                   	pop    %es
  2820f5:	e0 06                	loopne 2820fd <ASCII_Table+0x951>
  2820f7:	63 0e                	arpl   %cx,(%esi)
  2820f9:	3f                   	aas    
  2820fa:	1c 3c                	sbb    $0x3c,%al
  2820fc:	f8                   	clc    
  2820fd:	3f                   	aas    
  2820fe:	e0 f7                	loopne 2820f7 <ASCII_Table+0x94b>
  282100:	00 c0                	add    %al,%al
	...
  28210e:	fe 0f                	decb   (%edi)
  282110:	fe                   	(bad)  
  282111:	1f                   	pop    %ds
  282112:	06                   	push   %es
  282113:	38 06                	cmp    %al,(%esi)
  282115:	30 06                	xor    %al,(%esi)
  282117:	30 06                	xor    %al,(%esi)
  282119:	30 06                	xor    %al,(%esi)
  28211b:	38 fe                	cmp    %bh,%dh
  28211d:	1f                   	pop    %ds
  28211e:	fe 07                	incb   (%edi)
  282120:	06                   	push   %es
  282121:	03 06                	add    (%esi),%eax
  282123:	06                   	push   %es
  282124:	06                   	push   %es
  282125:	0c 06                	or     $0x6,%al
  282127:	18 06                	sbb    %al,(%esi)
  282129:	18 06                	sbb    %al,(%esi)
  28212b:	30 06                	xor    %al,(%esi)
  28212d:	30 06                	xor    %al,(%esi)
  28212f:	60                   	pusha  
	...
  28213c:	00 00                	add    %al,(%eax)
  28213e:	e0 03                	loopne 282143 <ASCII_Table+0x997>
  282140:	f8                   	clc    
  282141:	0f 1c 0c 0c          	nopl   (%esp,%ecx,1)
  282145:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282148:	0c 00                	or     $0x0,%al
  28214a:	1c 00                	sbb    $0x0,%al
  28214c:	f8                   	clc    
  28214d:	03 e0                	add    %eax,%esp
  28214f:	0f 00 1e             	ltr    (%esi)
  282152:	00 38                	add    %bh,(%eax)
  282154:	06                   	push   %es
  282155:	30 06                	xor    %al,(%esi)
  282157:	30 0e                	xor    %cl,(%esi)
  282159:	30 1c 1c             	xor    %bl,(%esp,%ebx,1)
  28215c:	f8                   	clc    
  28215d:	0f e0 07             	pavgb  (%edi),%mm0
	...
  28216c:	00 00                	add    %al,(%eax)
  28216e:	fe                   	(bad)  
  28216f:	7f fe                	jg     28216f <ASCII_Table+0x9c3>
  282171:	7f 80                	jg     2820f3 <ASCII_Table+0x947>
  282173:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282179:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28217f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282185:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28218b:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
	...
  28219d:	00 0c 30             	add    %cl,(%eax,%esi,1)
  2821a0:	0c 30                	or     $0x30,%al
  2821a2:	0c 30                	or     $0x30,%al
  2821a4:	0c 30                	or     $0x30,%al
  2821a6:	0c 30                	or     $0x30,%al
  2821a8:	0c 30                	or     $0x30,%al
  2821aa:	0c 30                	or     $0x30,%al
  2821ac:	0c 30                	or     $0x30,%al
  2821ae:	0c 30                	or     $0x30,%al
  2821b0:	0c 30                	or     $0x30,%al
  2821b2:	0c 30                	or     $0x30,%al
  2821b4:	0c 30                	or     $0x30,%al
  2821b6:	0c 30                	or     $0x30,%al
  2821b8:	0c 30                	or     $0x30,%al
  2821ba:	18 18                	sbb    %bl,(%eax)
  2821bc:	f8                   	clc    
  2821bd:	1f                   	pop    %ds
  2821be:	e0 07                	loopne 2821c7 <ASCII_Table+0xa1b>
	...
  2821cc:	00 00                	add    %al,(%eax)
  2821ce:	03 60 06             	add    0x6(%eax),%esp
  2821d1:	30 06                	xor    %al,(%esi)
  2821d3:	30 06                	xor    %al,(%esi)
  2821d5:	30 0c 18             	xor    %cl,(%eax,%ebx,1)
  2821d8:	0c 18                	or     $0x18,%al
  2821da:	0c 18                	or     $0x18,%al
  2821dc:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2821df:	0c 38                	or     $0x38,%al
  2821e1:	0e                   	push   %cs
  2821e2:	30 06                	xor    %al,(%esi)
  2821e4:	30 06                	xor    %al,(%esi)
  2821e6:	70 07                	jo     2821ef <ASCII_Table+0xa43>
  2821e8:	60                   	pusha  
  2821e9:	03 60 03             	add    0x3(%eax),%esp
  2821ec:	c0 01 c0             	rolb   $0xc0,(%ecx)
  2821ef:	01 00                	add    %eax,(%eax)
	...
  2821fd:	00 03                	add    %al,(%ebx)
  2821ff:	60                   	pusha  
  282200:	c3                   	ret    
  282201:	61                   	popa   
  282202:	c3                   	ret    
  282203:	61                   	popa   
  282204:	c3                   	ret    
  282205:	61                   	popa   
  282206:	66 33 66 33          	xor    0x33(%esi),%sp
  28220a:	66 33 66 33          	xor    0x33(%esi),%sp
  28220e:	66 33 66 33          	xor    0x33(%esi),%sp
  282212:	6c                   	insb   (%dx),%es:(%edi)
  282213:	1b 6c 1b 6c          	sbb    0x6c(%ebx,%ebx,1),%ebp
  282217:	1b 2c 1a             	sbb    (%edx,%ebx,1),%ebp
  28221a:	3c 1e                	cmp    $0x1e,%al
  28221c:	38 0e                	cmp    %cl,(%esi)
  28221e:	38 0e                	cmp    %cl,(%esi)
	...
  28222c:	00 00                	add    %al,(%eax)
  28222e:	0f e0 0c 70          	pavgb  (%eax,%esi,2),%mm1
  282232:	18 30                	sbb    %dh,(%eax)
  282234:	30 18                	xor    %bl,(%eax)
  282236:	70 0c                	jo     282244 <ASCII_Table+0xa98>
  282238:	60                   	pusha  
  282239:	0e                   	push   %cs
  28223a:	c0 07 80             	rolb   $0x80,(%edi)
  28223d:	03 80 03 c0 03 e0    	add    -0x1ffc3ffd(%eax),%eax
  282243:	06                   	push   %es
  282244:	70 0c                	jo     282252 <ASCII_Table+0xaa6>
  282246:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282249:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  28224c:	0e                   	push   %cs
  28224d:	60                   	pusha  
  28224e:	07                   	pop    %es
  28224f:	e0 00                	loopne 282251 <ASCII_Table+0xaa5>
	...
  28225d:	00 03                	add    %al,(%ebx)
  28225f:	c0 06 60             	rolb   $0x60,(%esi)
  282262:	0c 30                	or     $0x30,%al
  282264:	1c 38                	sbb    $0x38,%al
  282266:	38 18                	cmp    %bl,(%eax)
  282268:	30 0c 60             	xor    %cl,(%eax,%eiz,2)
  28226b:	06                   	push   %es
  28226c:	e0 07                	loopne 282275 <ASCII_Table+0xac9>
  28226e:	c0 03 80             	rolb   $0x80,(%ebx)
  282271:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282277:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28227d:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  28228b:	00 00                	add    %al,(%eax)
  28228d:	00 fc                	add    %bh,%ah
  28228f:	7f fc                	jg     28228d <ASCII_Table+0xae1>
  282291:	7f 00                	jg     282293 <ASCII_Table+0xae7>
  282293:	60                   	pusha  
  282294:	00 30                	add    %dh,(%eax)
  282296:	00 18                	add    %bl,(%eax)
  282298:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28229b:	06                   	push   %es
  28229c:	00 03                	add    %al,(%ebx)
  28229e:	80 01 c0             	addb   $0xc0,(%ecx)
  2822a1:	00 60 00             	add    %ah,0x0(%eax)
  2822a4:	30 00                	xor    %al,(%eax)
  2822a6:	18 00                	sbb    %al,(%eax)
  2822a8:	0c 00                	or     $0x0,%al
  2822aa:	06                   	push   %es
  2822ab:	00 fe                	add    %bh,%dh
  2822ad:	7f fe                	jg     2822ad <ASCII_Table+0xb01>
  2822af:	7f 00                	jg     2822b1 <ASCII_Table+0xb05>
	...
  2822bd:	00 e0                	add    %ah,%al
  2822bf:	03 e0                	add    %eax,%esp
  2822c1:	03 60 00             	add    0x0(%eax),%esp
  2822c4:	60                   	pusha  
  2822c5:	00 60 00             	add    %ah,0x0(%eax)
  2822c8:	60                   	pusha  
  2822c9:	00 60 00             	add    %ah,0x0(%eax)
  2822cc:	60                   	pusha  
  2822cd:	00 60 00             	add    %ah,0x0(%eax)
  2822d0:	60                   	pusha  
  2822d1:	00 60 00             	add    %ah,0x0(%eax)
  2822d4:	60                   	pusha  
  2822d5:	00 60 00             	add    %ah,0x0(%eax)
  2822d8:	60                   	pusha  
  2822d9:	00 60 00             	add    %ah,0x0(%eax)
  2822dc:	60                   	pusha  
  2822dd:	00 60 00             	add    %ah,0x0(%eax)
  2822e0:	60                   	pusha  
  2822e1:	00 60 00             	add    %ah,0x0(%eax)
  2822e4:	60                   	pusha  
  2822e5:	00 e0                	add    %ah,%al
  2822e7:	03 e0                	add    %eax,%esp
  2822e9:	03 00                	add    (%eax),%eax
  2822eb:	00 00                	add    %al,(%eax)
  2822ed:	00 30                	add    %dh,(%eax)
  2822ef:	00 30                	add    %dh,(%eax)
  2822f1:	00 60 00             	add    %ah,0x0(%eax)
  2822f4:	60                   	pusha  
  2822f5:	00 60 00             	add    %ah,0x0(%eax)
  2822f8:	c0 00 c0             	rolb   $0xc0,(%eax)
  2822fb:	00 c0                	add    %al,%al
  2822fd:	00 c0                	add    %al,%al
  2822ff:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282305:	01 00                	add    %eax,(%eax)
  282307:	03 00                	add    (%eax),%eax
  282309:	03 00                	add    (%eax),%eax
  28230b:	03 00                	add    (%eax),%eax
  28230d:	06                   	push   %es
  28230e:	00 06                	add    %al,(%esi)
	...
  28231c:	00 00                	add    %al,(%eax)
  28231e:	e0 03                	loopne 282323 <ASCII_Table+0xb77>
  282320:	e0 03                	loopne 282325 <ASCII_Table+0xb79>
  282322:	00 03                	add    %al,(%ebx)
  282324:	00 03                	add    %al,(%ebx)
  282326:	00 03                	add    %al,(%ebx)
  282328:	00 03                	add    %al,(%ebx)
  28232a:	00 03                	add    %al,(%ebx)
  28232c:	00 03                	add    %al,(%ebx)
  28232e:	00 03                	add    %al,(%ebx)
  282330:	00 03                	add    %al,(%ebx)
  282332:	00 03                	add    %al,(%ebx)
  282334:	00 03                	add    %al,(%ebx)
  282336:	00 03                	add    %al,(%ebx)
  282338:	00 03                	add    %al,(%ebx)
  28233a:	00 03                	add    %al,(%ebx)
  28233c:	00 03                	add    %al,(%ebx)
  28233e:	00 03                	add    %al,(%ebx)
  282340:	00 03                	add    %al,(%ebx)
  282342:	00 03                	add    %al,(%ebx)
  282344:	00 03                	add    %al,(%ebx)
  282346:	e0 03                	loopne 28234b <ASCII_Table+0xb9f>
  282348:	e0 03                	loopne 28234d <ASCII_Table+0xba1>
  28234a:	00 00                	add    %al,(%eax)
  28234c:	00 00                	add    %al,(%eax)
  28234e:	00 00                	add    %al,(%eax)
  282350:	c0 01 c0             	rolb   $0xc0,(%ecx)
  282353:	01 60 03             	add    %esp,0x3(%eax)
  282356:	60                   	pusha  
  282357:	03 60 03             	add    0x3(%eax),%esp
  28235a:	30 06                	xor    %al,(%esi)
  28235c:	30 06                	xor    %al,(%esi)
  28235e:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282361:	0c 00                	or     $0x0,%al
	...
  28239b:	00 00                	add    %al,(%eax)
  28239d:	00 ff                	add    %bh,%bh
  28239f:	ff                   	(bad)  
  2823a0:	ff                   	(bad)  
  2823a1:	ff 00                	incl   (%eax)
	...
  2823ab:	00 00                	add    %al,(%eax)
  2823ad:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2823b0:	0c 00                	or     $0x0,%al
  2823b2:	0c 00                	or     $0x0,%al
  2823b4:	0c 00                	or     $0x0,%al
  2823b6:	0c 00                	or     $0x0,%al
  2823b8:	0c 00                	or     $0x0,%al
	...
  2823e6:	00 00                	add    %al,(%eax)
  2823e8:	f0 03 f8             	lock add %eax,%edi
  2823eb:	07                   	pop    %es
  2823ec:	1c 0c                	sbb    $0xc,%al
  2823ee:	0c 0c                	or     $0xc,%al
  2823f0:	00 0f                	add    %cl,(%edi)
  2823f2:	f0 0f f8 0c 0c       	lock psubb (%esp,%ecx,1),%mm1
  2823f7:	0c 0c                	or     $0xc,%al
  2823f9:	0c 1c                	or     $0x1c,%al
  2823fb:	0f f8 0f             	psubb  (%edi),%mm1
  2823fe:	f0 18 00             	lock sbb %al,(%eax)
	...
  28240d:	00 18                	add    %bl,(%eax)
  28240f:	00 18                	add    %bl,(%eax)
  282411:	00 18                	add    %bl,(%eax)
  282413:	00 18                	add    %bl,(%eax)
  282415:	00 18                	add    %bl,(%eax)
  282417:	00 d8                	add    %bl,%al
  282419:	03 f8                	add    %eax,%edi
  28241b:	0f 38 0c             	(bad)  
  28241e:	18 18                	sbb    %bl,(%eax)
  282420:	18 18                	sbb    %bl,(%eax)
  282422:	18 18                	sbb    %bl,(%eax)
  282424:	18 18                	sbb    %bl,(%eax)
  282426:	18 18                	sbb    %bl,(%eax)
  282428:	18 18                	sbb    %bl,(%eax)
  28242a:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  28242d:	0f d8 03             	psubusb (%ebx),%mm0
	...
  282448:	c0 03 f0             	rolb   $0xf0,(%ebx)
  28244b:	07                   	pop    %es
  28244c:	30 0e                	xor    %cl,(%esi)
  28244e:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282451:	00 18                	add    %bl,(%eax)
  282453:	00 18                	add    %bl,(%eax)
  282455:	00 18                	add    %bl,(%eax)
  282457:	00 18                	add    %bl,(%eax)
  282459:	0c 30                	or     $0x30,%al
  28245b:	0e                   	push   %cs
  28245c:	f0 07                	lock pop %es
  28245e:	c0 03 00             	rolb   $0x0,(%ebx)
	...
  28246d:	00 00                	add    %al,(%eax)
  28246f:	18 00                	sbb    %al,(%eax)
  282471:	18 00                	sbb    %al,(%eax)
  282473:	18 00                	sbb    %al,(%eax)
  282475:	18 00                	sbb    %al,(%eax)
  282477:	18 c0                	sbb    %al,%al
  282479:	1b f0                	sbb    %eax,%esi
  28247b:	1f                   	pop    %ds
  28247c:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  28247f:	18 18                	sbb    %bl,(%eax)
  282481:	18 18                	sbb    %bl,(%eax)
  282483:	18 18                	sbb    %bl,(%eax)
  282485:	18 18                	sbb    %bl,(%eax)
  282487:	18 18                	sbb    %bl,(%eax)
  282489:	18 30                	sbb    %dh,(%eax)
  28248b:	1c f0                	sbb    $0xf0,%al
  28248d:	1f                   	pop    %ds
  28248e:	c0 1b 00             	rcrb   $0x0,(%ebx)
	...
  2824a5:	00 00                	add    %al,(%eax)
  2824a7:	00 c0                	add    %al,%al
  2824a9:	03 f0                	add    %eax,%esi
  2824ab:	0f 30                	wrmsr  
  2824ad:	0c 18                	or     $0x18,%al
  2824af:	18 f8                	sbb    %bh,%al
  2824b1:	1f                   	pop    %ds
  2824b2:	f8                   	clc    
  2824b3:	1f                   	pop    %ds
  2824b4:	18 00                	sbb    %al,(%eax)
  2824b6:	18 00                	sbb    %al,(%eax)
  2824b8:	38 18                	cmp    %bl,(%eax)
  2824ba:	30 1c f0             	xor    %bl,(%eax,%esi,8)
  2824bd:	0f c0 07             	xadd   %al,(%edi)
	...
  2824cc:	00 00                	add    %al,(%eax)
  2824ce:	80 0f c0             	orb    $0xc0,(%edi)
  2824d1:	0f c0 00             	xadd   %al,(%eax)
  2824d4:	c0 00 c0             	rolb   $0xc0,(%eax)
  2824d7:	00 f0                	add    %dh,%al
  2824d9:	07                   	pop    %es
  2824da:	f0 07                	lock pop %es
  2824dc:	c0 00 c0             	rolb   $0xc0,(%eax)
  2824df:	00 c0                	add    %al,%al
  2824e1:	00 c0                	add    %al,%al
  2824e3:	00 c0                	add    %al,%al
  2824e5:	00 c0                	add    %al,%al
  2824e7:	00 c0                	add    %al,%al
  2824e9:	00 c0                	add    %al,%al
  2824eb:	00 c0                	add    %al,%al
  2824ed:	00 c0                	add    %al,%al
	...
  282507:	00 e0                	add    %ah,%al
  282509:	0d f8 0f 18 0e       	or     $0xe180ff8,%eax
  28250e:	0c 0c                	or     $0xc,%al
  282510:	0c 0c                	or     $0xc,%al
  282512:	0c 0c                	or     $0xc,%al
  282514:	0c 0c                	or     $0xc,%al
  282516:	0c 0c                	or     $0xc,%al
  282518:	0c 0c                	or     $0xc,%al
  28251a:	18 0e                	sbb    %cl,(%esi)
  28251c:	f8                   	clc    
  28251d:	0f e0 0d 00 0c 0c 0c 	pavgb  0xc0c0c00,%mm1
  282524:	1c 06                	sbb    $0x6,%al
  282526:	f8                   	clc    
  282527:	07                   	pop    %es
  282528:	f0 01 00             	lock add %eax,(%eax)
  28252b:	00 00                	add    %al,(%eax)
  28252d:	00 18                	add    %bl,(%eax)
  28252f:	00 18                	add    %bl,(%eax)
  282531:	00 18                	add    %bl,(%eax)
  282533:	00 18                	add    %bl,(%eax)
  282535:	00 18                	add    %bl,(%eax)
  282537:	00 d8                	add    %bl,%al
  282539:	07                   	pop    %es
  28253a:	f8                   	clc    
  28253b:	0f 38 1c 18          	pabsb  (%eax),%mm3
  28253f:	18 18                	sbb    %bl,(%eax)
  282541:	18 18                	sbb    %bl,(%eax)
  282543:	18 18                	sbb    %bl,(%eax)
  282545:	18 18                	sbb    %bl,(%eax)
  282547:	18 18                	sbb    %bl,(%eax)
  282549:	18 18                	sbb    %bl,(%eax)
  28254b:	18 18                	sbb    %bl,(%eax)
  28254d:	18 18                	sbb    %bl,(%eax)
  28254f:	18 00                	sbb    %al,(%eax)
	...
  28255d:	00 c0                	add    %al,%al
  28255f:	00 c0                	add    %al,%al
  282561:	00 00                	add    %al,(%eax)
  282563:	00 00                	add    %al,(%eax)
  282565:	00 00                	add    %al,(%eax)
  282567:	00 c0                	add    %al,%al
  282569:	00 c0                	add    %al,%al
  28256b:	00 c0                	add    %al,%al
  28256d:	00 c0                	add    %al,%al
  28256f:	00 c0                	add    %al,%al
  282571:	00 c0                	add    %al,%al
  282573:	00 c0                	add    %al,%al
  282575:	00 c0                	add    %al,%al
  282577:	00 c0                	add    %al,%al
  282579:	00 c0                	add    %al,%al
  28257b:	00 c0                	add    %al,%al
  28257d:	00 c0                	add    %al,%al
	...
  28258b:	00 00                	add    %al,(%eax)
  28258d:	00 c0                	add    %al,%al
  28258f:	00 c0                	add    %al,%al
  282591:	00 00                	add    %al,(%eax)
  282593:	00 00                	add    %al,(%eax)
  282595:	00 00                	add    %al,(%eax)
  282597:	00 c0                	add    %al,%al
  282599:	00 c0                	add    %al,%al
  28259b:	00 c0                	add    %al,%al
  28259d:	00 c0                	add    %al,%al
  28259f:	00 c0                	add    %al,%al
  2825a1:	00 c0                	add    %al,%al
  2825a3:	00 c0                	add    %al,%al
  2825a5:	00 c0                	add    %al,%al
  2825a7:	00 c0                	add    %al,%al
  2825a9:	00 c0                	add    %al,%al
  2825ab:	00 c0                	add    %al,%al
  2825ad:	00 c0                	add    %al,%al
  2825af:	00 c0                	add    %al,%al
  2825b1:	00 c0                	add    %al,%al
  2825b3:	00 c0                	add    %al,%al
  2825b5:	00 f8                	add    %bh,%al
  2825b7:	00 78 00             	add    %bh,0x0(%eax)
  2825ba:	00 00                	add    %al,(%eax)
  2825bc:	00 00                	add    %al,(%eax)
  2825be:	0c 00                	or     $0x0,%al
  2825c0:	0c 00                	or     $0x0,%al
  2825c2:	0c 00                	or     $0x0,%al
  2825c4:	0c 00                	or     $0x0,%al
  2825c6:	0c 00                	or     $0x0,%al
  2825c8:	0c 0c                	or     $0xc,%al
  2825ca:	0c 06                	or     $0x6,%al
  2825cc:	0c 03                	or     $0x3,%al
  2825ce:	8c 01                	mov    %es,(%ecx)
  2825d0:	cc                   	int3   
  2825d1:	00 6c 00 fc          	add    %ch,-0x4(%eax,%eax,1)
  2825d5:	00 9c 01 8c 03 0c 03 	add    %bl,0x30c038c(%ecx,%eax,1)
  2825dc:	0c 06                	or     $0x6,%al
  2825de:	0c 0c                	or     $0xc,%al
	...
  2825ec:	00 00                	add    %al,(%eax)
  2825ee:	c0 00 c0             	rolb   $0xc0,(%eax)
  2825f1:	00 c0                	add    %al,%al
  2825f3:	00 c0                	add    %al,%al
  2825f5:	00 c0                	add    %al,%al
  2825f7:	00 c0                	add    %al,%al
  2825f9:	00 c0                	add    %al,%al
  2825fb:	00 c0                	add    %al,%al
  2825fd:	00 c0                	add    %al,%al
  2825ff:	00 c0                	add    %al,%al
  282601:	00 c0                	add    %al,%al
  282603:	00 c0                	add    %al,%al
  282605:	00 c0                	add    %al,%al
  282607:	00 c0                	add    %al,%al
  282609:	00 c0                	add    %al,%al
  28260b:	00 c0                	add    %al,%al
  28260d:	00 c0                	add    %al,%al
	...
  282627:	00 7c 3c ff          	add    %bh,-0x1(%esp,%edi,1)
  28262b:	7e c7                	jle    2825f4 <ASCII_Table+0xe48>
  28262d:	e3 83                	jecxz  2825b2 <ASCII_Table+0xe06>
  28262f:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
  282636:	83 c1 83             	add    $0xffffff83,%ecx
  282639:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
	...
  282658:	98                   	cwtl   
  282659:	07                   	pop    %es
  28265a:	f8                   	clc    
  28265b:	0f 38 1c 18          	pabsb  (%eax),%mm3
  28265f:	18 18                	sbb    %bl,(%eax)
  282661:	18 18                	sbb    %bl,(%eax)
  282663:	18 18                	sbb    %bl,(%eax)
  282665:	18 18                	sbb    %bl,(%eax)
  282667:	18 18                	sbb    %bl,(%eax)
  282669:	18 18                	sbb    %bl,(%eax)
  28266b:	18 18                	sbb    %bl,(%eax)
  28266d:	18 18                	sbb    %bl,(%eax)
  28266f:	18 00                	sbb    %al,(%eax)
	...
  282685:	00 00                	add    %al,(%eax)
  282687:	00 c0                	add    %al,%al
  282689:	03 f0                	add    %eax,%esi
  28268b:	0f 30                	wrmsr  
  28268d:	0c 18                	or     $0x18,%al
  28268f:	18 18                	sbb    %bl,(%eax)
  282691:	18 18                	sbb    %bl,(%eax)
  282693:	18 18                	sbb    %bl,(%eax)
  282695:	18 18                	sbb    %bl,(%eax)
  282697:	18 18                	sbb    %bl,(%eax)
  282699:	18 30                	sbb    %dh,(%eax)
  28269b:	0c f0                	or     $0xf0,%al
  28269d:	0f c0 03             	xadd   %al,(%ebx)
	...
  2826b8:	d8 03                	fadds  (%ebx)
  2826ba:	f8                   	clc    
  2826bb:	0f 38 0c             	(bad)  
  2826be:	18 18                	sbb    %bl,(%eax)
  2826c0:	18 18                	sbb    %bl,(%eax)
  2826c2:	18 18                	sbb    %bl,(%eax)
  2826c4:	18 18                	sbb    %bl,(%eax)
  2826c6:	18 18                	sbb    %bl,(%eax)
  2826c8:	18 18                	sbb    %bl,(%eax)
  2826ca:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  2826cd:	0f d8 03             	psubusb (%ebx),%mm0
  2826d0:	18 00                	sbb    %al,(%eax)
  2826d2:	18 00                	sbb    %al,(%eax)
  2826d4:	18 00                	sbb    %al,(%eax)
  2826d6:	18 00                	sbb    %al,(%eax)
  2826d8:	18 00                	sbb    %al,(%eax)
	...
  2826e6:	00 00                	add    %al,(%eax)
  2826e8:	c0 1b f0             	rcrb   $0xf0,(%ebx)
  2826eb:	1f                   	pop    %ds
  2826ec:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  2826ef:	18 18                	sbb    %bl,(%eax)
  2826f1:	18 18                	sbb    %bl,(%eax)
  2826f3:	18 18                	sbb    %bl,(%eax)
  2826f5:	18 18                	sbb    %bl,(%eax)
  2826f7:	18 18                	sbb    %bl,(%eax)
  2826f9:	18 30                	sbb    %dh,(%eax)
  2826fb:	1c f0                	sbb    $0xf0,%al
  2826fd:	1f                   	pop    %ds
  2826fe:	c0 1b 00             	rcrb   $0x0,(%ebx)
  282701:	18 00                	sbb    %al,(%eax)
  282703:	18 00                	sbb    %al,(%eax)
  282705:	18 00                	sbb    %al,(%eax)
  282707:	18 00                	sbb    %al,(%eax)
  282709:	18 00                	sbb    %al,(%eax)
	...
  282717:	00 b0 07 f0 03 70    	add    %dh,0x7003f007(%eax)
  28271d:	00 30                	add    %dh,(%eax)
  28271f:	00 30                	add    %dh,(%eax)
  282721:	00 30                	add    %dh,(%eax)
  282723:	00 30                	add    %dh,(%eax)
  282725:	00 30                	add    %dh,(%eax)
  282727:	00 30                	add    %dh,(%eax)
  282729:	00 30                	add    %dh,(%eax)
  28272b:	00 30                	add    %dh,(%eax)
  28272d:	00 30                	add    %dh,(%eax)
	...
  282747:	00 e0                	add    %ah,%al
  282749:	03 f0                	add    %eax,%esi
  28274b:	03 38                	add    (%eax),%edi
  28274d:	0e                   	push   %cs
  28274e:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  282751:	00 f0                	add    %dh,%al
  282753:	03 c0                	add    %eax,%eax
  282755:	07                   	pop    %es
  282756:	00 0c 18             	add    %cl,(%eax,%ebx,1)
  282759:	0c 38                	or     $0x38,%al
  28275b:	0e                   	push   %cs
  28275c:	f0 07                	lock pop %es
  28275e:	e0 03                	loopne 282763 <ASCII_Table+0xfb7>
	...
  282770:	80 00 c0             	addb   $0xc0,(%eax)
  282773:	00 c0                	add    %al,%al
  282775:	00 c0                	add    %al,%al
  282777:	00 f0                	add    %dh,%al
  282779:	07                   	pop    %es
  28277a:	f0 07                	lock pop %es
  28277c:	c0 00 c0             	rolb   $0xc0,(%eax)
  28277f:	00 c0                	add    %al,%al
  282781:	00 c0                	add    %al,%al
  282783:	00 c0                	add    %al,%al
  282785:	00 c0                	add    %al,%al
  282787:	00 c0                	add    %al,%al
  282789:	00 c0                	add    %al,%al
  28278b:	00 c0                	add    %al,%al
  28278d:	07                   	pop    %es
  28278e:	80 07 00             	addb   $0x0,(%edi)
	...
  2827a5:	00 00                	add    %al,(%eax)
  2827a7:	00 18                	add    %bl,(%eax)
  2827a9:	18 18                	sbb    %bl,(%eax)
  2827ab:	18 18                	sbb    %bl,(%eax)
  2827ad:	18 18                	sbb    %bl,(%eax)
  2827af:	18 18                	sbb    %bl,(%eax)
  2827b1:	18 18                	sbb    %bl,(%eax)
  2827b3:	18 18                	sbb    %bl,(%eax)
  2827b5:	18 18                	sbb    %bl,(%eax)
  2827b7:	18 18                	sbb    %bl,(%eax)
  2827b9:	18 38                	sbb    %bh,(%eax)
  2827bb:	1c f0                	sbb    $0xf0,%al
  2827bd:	1f                   	pop    %ds
  2827be:	e0 19                	loopne 2827d9 <ASCII_Table+0x102d>
	...
  2827d8:	0c 18                	or     $0x18,%al
  2827da:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2827dd:	0c 18                	or     $0x18,%al
  2827df:	0c 30                	or     $0x30,%al
  2827e1:	06                   	push   %es
  2827e2:	30 06                	xor    %al,(%esi)
  2827e4:	30 06                	xor    %al,(%esi)
  2827e6:	60                   	pusha  
  2827e7:	03 60 03             	add    0x3(%eax),%esp
  2827ea:	60                   	pusha  
  2827eb:	03 c0                	add    %eax,%eax
  2827ed:	01 c0                	add    %eax,%eax
  2827ef:	01 00                	add    %eax,(%eax)
	...
  282805:	00 00                	add    %al,(%eax)
  282807:	00 c1                	add    %al,%cl
  282809:	41                   	inc    %ecx
  28280a:	c1 41 c3 61          	roll   $0x61,-0x3d(%ecx)
  28280e:	63 63 63             	arpl   %sp,0x63(%ebx)
  282811:	63 63 63             	arpl   %sp,0x63(%ebx)
  282814:	36                   	ss
  282815:	36                   	ss
  282816:	36                   	ss
  282817:	36                   	ss
  282818:	36                   	ss
  282819:	36                   	ss
  28281a:	1c 1c                	sbb    $0x1c,%al
  28281c:	1c 1c                	sbb    $0x1c,%al
  28281e:	1c 1c                	sbb    $0x1c,%al
	...
  282838:	1c 38                	sbb    $0x38,%al
  28283a:	38 1c 30             	cmp    %bl,(%eax,%esi,1)
  28283d:	0c 60                	or     $0x60,%al
  28283f:	06                   	push   %es
  282840:	60                   	pusha  
  282841:	03 60 03             	add    0x3(%eax),%esp
  282844:	60                   	pusha  
  282845:	03 60 03             	add    0x3(%eax),%esp
  282848:	60                   	pusha  
  282849:	06                   	push   %es
  28284a:	30 0c 38             	xor    %cl,(%eax,%edi,1)
  28284d:	1c 1c                	sbb    $0x1c,%al
  28284f:	38 00                	cmp    %al,(%eax)
	...
  282865:	00 00                	add    %al,(%eax)
  282867:	00 18                	add    %bl,(%eax)
  282869:	30 30                	xor    %dh,(%eax)
  28286b:	18 30                	sbb    %dh,(%eax)
  28286d:	18 70 18             	sbb    %dh,0x18(%eax)
  282870:	60                   	pusha  
  282871:	0c 60                	or     $0x60,%al
  282873:	0c e0                	or     $0xe0,%al
  282875:	0c c0                	or     $0xc0,%al
  282877:	06                   	push   %es
  282878:	c0 06 80             	rolb   $0x80,(%esi)
  28287b:	03 80 03 80 03 80    	add    -0x7ffc7ffd(%eax),%eax
  282881:	01 80 01 c0 01 f0    	add    %eax,-0xffe3fff(%eax)
  282887:	00 70 00             	add    %dh,0x0(%eax)
	...
  282896:	00 00                	add    %al,(%eax)
  282898:	fc                   	cld    
  282899:	1f                   	pop    %ds
  28289a:	fc                   	cld    
  28289b:	1f                   	pop    %ds
  28289c:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28289f:	06                   	push   %es
  2828a0:	00 03                	add    %al,(%ebx)
  2828a2:	80 01 c0             	addb   $0xc0,(%ecx)
  2828a5:	00 60 00             	add    %ah,0x0(%eax)
  2828a8:	30 00                	xor    %al,(%eax)
  2828aa:	18 00                	sbb    %al,(%eax)
  2828ac:	fc                   	cld    
  2828ad:	1f                   	pop    %ds
  2828ae:	fc                   	cld    
  2828af:	1f                   	pop    %ds
	...
  2828bc:	00 00                	add    %al,(%eax)
  2828be:	00 03                	add    %al,(%ebx)
  2828c0:	80 01 c0             	addb   $0xc0,(%ecx)
  2828c3:	00 c0                	add    %al,%al
  2828c5:	00 c0                	add    %al,%al
  2828c7:	00 c0                	add    %al,%al
  2828c9:	00 c0                	add    %al,%al
  2828cb:	00 c0                	add    %al,%al
  2828cd:	00 60 00             	add    %ah,0x0(%eax)
  2828d0:	60                   	pusha  
  2828d1:	00 30                	add    %dh,(%eax)
  2828d3:	00 60 00             	add    %ah,0x0(%eax)
  2828d6:	40                   	inc    %eax
  2828d7:	00 c0                	add    %al,%al
  2828d9:	00 c0                	add    %al,%al
  2828db:	00 c0                	add    %al,%al
  2828dd:	00 c0                	add    %al,%al
  2828df:	00 c0                	add    %al,%al
  2828e1:	00 c0                	add    %al,%al
  2828e3:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  2828e9:	00 00                	add    %al,(%eax)
  2828eb:	00 00                	add    %al,(%eax)
  2828ed:	00 80 01 80 01 80    	add    %al,-0x7ffe7fff(%eax)
  2828f3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2828f9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2828ff:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282905:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28290b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282911:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282917:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
  28291d:	00 60 00             	add    %ah,0x0(%eax)
  282920:	c0 00 c0             	rolb   $0xc0,(%eax)
  282923:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282929:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  28292f:	03 00                	add    (%eax),%eax
  282931:	03 00                	add    (%eax),%eax
  282933:	06                   	push   %es
  282934:	00 03                	add    %al,(%ebx)
  282936:	00 01                	add    %al,(%ecx)
  282938:	80 01 80             	addb   $0x80,(%ecx)
  28293b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282941:	01 80 01 c0 00 60    	add    %eax,0x6000c001(%eax)
	...
  28295b:	00 f0                	add    %dh,%al
  28295d:	10 f8                	adc    %bh,%al
  28295f:	1f                   	pop    %ds
  282960:	08 0f                	or     %cl,(%edi)
	...
  28297e:	00 ff                	add    %bh,%bh
  282980:	00 00                	add    %al,(%eax)
  282982:	00 ff                	add    %bh,%bh
  282984:	00 ff                	add    %bh,%bh
  282986:	ff 00                	incl   (%eax)
  282988:	00 00                	add    %al,(%eax)
  28298a:	ff                   	(bad)  
  28298b:	ff 00                	incl   (%eax)
  28298d:	ff 00                	incl   (%eax)
  28298f:	ff                   	(bad)  
  282990:	ff                   	(bad)  
  282991:	ff                   	(bad)  
  282992:	ff                   	(bad)  
  282993:	ff c6                	inc    %esi
  282995:	c6 c6 84             	mov    $0x84,%dh
  282998:	00 00                	add    %al,(%eax)
  28299a:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
  2829a1:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
  2829a8:	84 84 84 84 2a 2a 2a 	test   %al,0x2a2a2a84(%esp,%eax,4)

002829ac <cursor.1395>:
  2829ac:	2a 2a                	sub    (%edx),%ch
  2829ae:	2a 2a                	sub    (%edx),%ch
  2829b0:	2a 2a                	sub    (%edx),%ch
  2829b2:	2a 2a                	sub    (%edx),%ch
  2829b4:	2a 2a                	sub    (%edx),%ch
  2829b6:	2a 2a                	sub    (%edx),%ch
  2829b8:	2a 2a                	sub    (%edx),%ch
  2829ba:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  2829bf:	4f                   	dec    %edi
  2829c0:	4f                   	dec    %edi
  2829c1:	4f                   	dec    %edi
  2829c2:	4f                   	dec    %edi
  2829c3:	4f                   	dec    %edi
  2829c4:	4f                   	dec    %edi
  2829c5:	4f                   	dec    %edi
  2829c6:	4f                   	dec    %edi
  2829c7:	4f                   	dec    %edi
  2829c8:	2a 2e                	sub    (%esi),%ch
  2829ca:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  2829cf:	4f                   	dec    %edi
  2829d0:	4f                   	dec    %edi
  2829d1:	4f                   	dec    %edi
  2829d2:	4f                   	dec    %edi
  2829d3:	4f                   	dec    %edi
  2829d4:	4f                   	dec    %edi
  2829d5:	4f                   	dec    %edi
  2829d6:	4f                   	dec    %edi
  2829d7:	2a 2e                	sub    (%esi),%ch
  2829d9:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  2829df:	4f                   	dec    %edi
  2829e0:	4f                   	dec    %edi
  2829e1:	4f                   	dec    %edi
  2829e2:	4f                   	dec    %edi
  2829e3:	4f                   	dec    %edi
  2829e4:	4f                   	dec    %edi
  2829e5:	4f                   	dec    %edi
  2829e6:	2a 2e                	sub    (%esi),%ch
  2829e8:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  2829ef:	4f                   	dec    %edi
  2829f0:	4f                   	dec    %edi
  2829f1:	4f                   	dec    %edi
  2829f2:	4f                   	dec    %edi
  2829f3:	4f                   	dec    %edi
  2829f4:	4f                   	dec    %edi
  2829f5:	2a 2e                	sub    (%esi),%ch
  2829f7:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  2829fe:	4f 
  2829ff:	4f                   	dec    %edi
  282a00:	4f                   	dec    %edi
  282a01:	4f                   	dec    %edi
  282a02:	4f                   	dec    %edi
  282a03:	4f                   	dec    %edi
  282a04:	2a 2e                	sub    (%esi),%ch
  282a06:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a0d:	4f 4f 
  282a0f:	4f                   	dec    %edi
  282a10:	4f                   	dec    %edi
  282a11:	4f                   	dec    %edi
  282a12:	4f                   	dec    %edi
  282a13:	4f                   	dec    %edi
  282a14:	2a 2e                	sub    (%esi),%ch
  282a16:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a1d:	4f 4f 
  282a1f:	4f                   	dec    %edi
  282a20:	4f                   	dec    %edi
  282a21:	4f                   	dec    %edi
  282a22:	4f                   	dec    %edi
  282a23:	4f                   	dec    %edi
  282a24:	4f                   	dec    %edi
  282a25:	2a 2e                	sub    (%esi),%ch
  282a27:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a2e:	4f 
  282a2f:	4f                   	dec    %edi
  282a30:	4f                   	dec    %edi
  282a31:	2a 2a                	sub    (%edx),%ch
  282a33:	4f                   	dec    %edi
  282a34:	4f                   	dec    %edi
  282a35:	4f                   	dec    %edi
  282a36:	2a 2e                	sub    (%esi),%ch
  282a38:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282a3f:	4f                   	dec    %edi
  282a40:	2a 2e                	sub    (%esi),%ch
  282a42:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  282a46:	4f                   	dec    %edi
  282a47:	2a 2e                	sub    (%esi),%ch
  282a49:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282a4f:	2a 2e                	sub    (%esi),%ch
  282a51:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282a57:	4f                   	dec    %edi
  282a58:	2a 2e                	sub    (%esi),%ch
  282a5a:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  282a5f:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a66:	4f 4f 
  282a68:	4f                   	dec    %edi
  282a69:	2a 2e                	sub    (%esi),%ch
  282a6b:	2e 2a 2a             	sub    %cs:(%edx),%ch
  282a6e:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a75:	2e 2a 4f 4f 
  282a79:	4f                   	dec    %edi
  282a7a:	2a 2e                	sub    (%esi),%ch
  282a7c:	2a 2e                	sub    (%esi),%ch
  282a7e:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a85:	2e 2e 2a 4f 4f 
  282a8a:	4f                   	dec    %edi
  282a8b:	2a 2e                	sub    (%esi),%ch
  282a8d:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282a94:	2e 2e 2e 2e 2a 4f 4f 
  282a9b:	2a 2e                	sub    (%esi),%ch
  282a9d:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  282aa4:	2e 2e 2e 2e 2e 2a 2a 
  282aab:	2a                   	.byte 0x2a

Disassembly of section .rodata.str1.1:

00282aac <.rodata.str1.1>:
  282aac:	6d                   	insl   (%dx),%es:(%edi)
  282aad:	65                   	gs
  282aae:	6d                   	insl   (%dx),%es:(%edi)
  282aaf:	6f                   	outsl  %ds:(%esi),(%dx)
  282ab0:	72 79                	jb     282b2b <cursor.1395+0x17f>
  282ab2:	3a 25 64 4d 42 2c    	cmp    0x2c424d64,%ah
  282ab8:	66                   	data16
  282ab9:	72 65                	jb     282b20 <cursor.1395+0x174>
  282abb:	65 3a 25 64 4d 42 2c 	cmp    %gs:0x2c424d64,%ah
  282ac2:	25 64 00 25 64       	and    $0x64250064,%eax
  282ac7:	20 6b 65             	and    %ch,0x65(%ebx)
  282aca:	79 3a                	jns    282b06 <cursor.1395+0x15a>
  282acc:	25 78 00 5b 6c       	and    $0x6c5b0078,%eax
  282ad1:	6d                   	insl   (%dx),%es:(%edi)
  282ad2:	72 3a                	jb     282b0e <cursor.1395+0x162>
  282ad4:	25 64 20 25 64       	and    $0x64252064,%eax
  282ad9:	5d                   	pop    %ebp
  282ada:	00 28                	add    %ch,(%eax)
  282adc:	25 64 2c 20 25       	and    $0x25202c64,%eax
  282ae1:	64 29 00             	sub    %eax,%fs:(%eax)
  282ae4:	44                   	inc    %esp
  282ae5:	65 62 75 67          	bound  %esi,%gs:0x67(%ebp)
  282ae9:	3a 76 61             	cmp    0x61(%esi),%dh
  282aec:	72 3d                	jb     282b2b <cursor.1395+0x17f>
  282aee:	25                   	.byte 0x25
  282aef:	78 00                	js     282af1 <cursor.1395+0x145>

Disassembly of section .eh_frame:

00282af4 <.eh_frame>:
  282af4:	14 00                	adc    $0x0,%al
  282af6:	00 00                	add    %al,(%eax)
  282af8:	00 00                	add    %al,(%eax)
  282afa:	00 00                	add    %al,(%eax)
  282afc:	01 7a 52             	add    %edi,0x52(%edx)
  282aff:	00 01                	add    %al,(%ecx)
  282b01:	7c 08                	jl     282b0b <cursor.1395+0x15f>
  282b03:	01 1b                	add    %ebx,(%ebx)
  282b05:	0c 04                	or     $0x4,%al
  282b07:	04 88                	add    $0x88,%al
  282b09:	01 00                	add    %eax,(%eax)
  282b0b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282b0e:	00 00                	add    %al,(%eax)
  282b10:	1c 00                	sbb    $0x0,%al
  282b12:	00 00                	add    %al,(%eax)
  282b14:	ec                   	in     (%dx),%al
  282b15:	d4 ff                	aam    $0xff
  282b17:	ff 5d 03             	lcall  *0x3(%ebp)
  282b1a:	00 00                	add    %al,(%eax)
  282b1c:	00 41 0e             	add    %al,0xe(%ecx)
  282b1f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282b25:	49                   	dec    %ecx
  282b26:	87 03                	xchg   %eax,(%ebx)
  282b28:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282b2b:	05 1c 00 00 00       	add    $0x1c,%eax
  282b30:	3c 00                	cmp    $0x0,%al
  282b32:	00 00                	add    %al,(%eax)
  282b34:	29 d8                	sub    %ebx,%eax
  282b36:	ff                   	(bad)  
  282b37:	ff 17                	call   *(%edi)
  282b39:	00 00                	add    %al,(%eax)
  282b3b:	00 00                	add    %al,(%eax)
  282b3d:	41                   	inc    %ecx
  282b3e:	0e                   	push   %cs
  282b3f:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282b45:	4e                   	dec    %esi
  282b46:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282b49:	04 00                	add    $0x0,%al
  282b4b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282b4e:	00 00                	add    %al,(%eax)
  282b50:	5c                   	pop    %esp
  282b51:	00 00                	add    %al,(%eax)
  282b53:	00 20                	add    %ah,(%eax)
  282b55:	d8 ff                	fdivr  %st(7),%st
  282b57:	ff 14 00             	call   *(%eax,%eax,1)
  282b5a:	00 00                	add    %al,(%eax)
  282b5c:	00 41 0e             	add    %al,0xe(%ecx)
  282b5f:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282b65:	4b                   	dec    %ebx
  282b66:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282b69:	04 00                	add    $0x0,%al
  282b6b:	00 24 00             	add    %ah,(%eax,%eax,1)
  282b6e:	00 00                	add    %al,(%eax)
  282b70:	7c 00                	jl     282b72 <cursor.1395+0x1c6>
  282b72:	00 00                	add    %al,(%eax)
  282b74:	14 d8                	adc    $0xd8,%al
  282b76:	ff                   	(bad)  
  282b77:	ff                   	(bad)  
  282b78:	3e 00 00             	add    %al,%ds:(%eax)
  282b7b:	00 00                	add    %al,(%eax)
  282b7d:	41                   	inc    %ecx
  282b7e:	0e                   	push   %cs
  282b7f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282b85:	45                   	inc    %ebp
  282b86:	86 03                	xchg   %al,(%ebx)
  282b88:	83 04 73 c3          	addl   $0xffffffc3,(%ebx,%esi,2)
  282b8c:	41                   	inc    %ecx
  282b8d:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282b91:	04 04                	add    $0x4,%al
  282b93:	00 24 00             	add    %ah,(%eax,%eax,1)
  282b96:	00 00                	add    %al,(%eax)
  282b98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  282b99:	00 00                	add    %al,(%eax)
  282b9b:	00 2a                	add    %ch,(%edx)
  282b9d:	d8 ff                	fdivr  %st(7),%st
  282b9f:	ff 31                	pushl  (%ecx)
  282ba1:	00 00                	add    %al,(%eax)
  282ba3:	00 00                	add    %al,(%eax)
  282ba5:	41                   	inc    %ecx
  282ba6:	0e                   	push   %cs
  282ba7:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282bad:	42                   	inc    %edx
  282bae:	87 03                	xchg   %eax,(%ebx)
  282bb0:	86 04 64             	xchg   %al,(%esp,%eiz,2)
  282bb3:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282bb7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282bba:	04 00                	add    $0x0,%al
  282bbc:	20 00                	and    %al,(%eax)
  282bbe:	00 00                	add    %al,(%eax)
  282bc0:	cc                   	int3   
  282bc1:	00 00                	add    %al,(%eax)
  282bc3:	00 33                	add    %dh,(%ebx)
  282bc5:	d8 ff                	fdivr  %st(7),%st
  282bc7:	ff 2f                	ljmp   *(%edi)
  282bc9:	00 00                	add    %al,(%eax)
  282bcb:	00 00                	add    %al,(%eax)
  282bcd:	41                   	inc    %ecx
  282bce:	0e                   	push   %cs
  282bcf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282bd5:	47                   	inc    %edi
  282bd6:	83 03 63             	addl   $0x63,(%ebx)
  282bd9:	c3                   	ret    
  282bda:	41                   	inc    %ecx
  282bdb:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282bde:	04 00                	add    $0x0,%al
  282be0:	1c 00                	sbb    $0x0,%al
  282be2:	00 00                	add    %al,(%eax)
  282be4:	f0 00 00             	lock add %al,(%eax)
  282be7:	00 3e                	add    %bh,(%esi)
  282be9:	d8 ff                	fdivr  %st(7),%st
  282beb:	ff 28                	ljmp   *(%eax)
  282bed:	00 00                	add    %al,(%eax)
  282bef:	00 00                	add    %al,(%eax)
  282bf1:	41                   	inc    %ecx
  282bf2:	0e                   	push   %cs
  282bf3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282bf9:	64 c5 0c 04          	lds    %fs:(%esp,%eax,1),%ecx
  282bfd:	04 00                	add    $0x0,%al
  282bff:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282c02:	00 00                	add    %al,(%eax)
  282c04:	10 01                	adc    %al,(%ecx)
  282c06:	00 00                	add    %al,(%eax)
  282c08:	46                   	inc    %esi
  282c09:	d8 ff                	fdivr  %st(7),%st
  282c0b:	ff 61 01             	jmp    *0x1(%ecx)
  282c0e:	00 00                	add    %al,(%eax)
  282c10:	00 41 0e             	add    %al,0xe(%ecx)
  282c13:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282c19:	03 5d 01             	add    0x1(%ebp),%ebx
  282c1c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282c1f:	04 1c                	add    $0x1c,%al
  282c21:	00 00                	add    %al,(%eax)
  282c23:	00 30                	add    %dh,(%eax)
  282c25:	01 00                	add    %eax,(%eax)
  282c27:	00 87 d9 ff ff 1f    	add    %al,0x1fffffd9(%edi)
  282c2d:	00 00                	add    %al,(%eax)
  282c2f:	00 00                	add    %al,(%eax)
  282c31:	41                   	inc    %ecx
  282c32:	0e                   	push   %cs
  282c33:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282c39:	5b                   	pop    %ebx
  282c3a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282c3d:	04 00                	add    $0x0,%al
  282c3f:	00 24 00             	add    %ah,(%eax,%eax,1)
  282c42:	00 00                	add    %al,(%eax)
  282c44:	50                   	push   %eax
  282c45:	01 00                	add    %eax,(%eax)
  282c47:	00 86 d9 ff ff 50    	add    %al,0x50ffffd9(%esi)
  282c4d:	00 00                	add    %al,(%eax)
  282c4f:	00 00                	add    %al,(%eax)
  282c51:	41                   	inc    %ecx
  282c52:	0e                   	push   %cs
  282c53:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282c59:	48                   	dec    %eax
  282c5a:	86 03                	xchg   %al,(%ebx)
  282c5c:	83 04 02 40          	addl   $0x40,(%edx,%eax,1)
  282c60:	c3                   	ret    
  282c61:	41                   	inc    %ecx
  282c62:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282c66:	04 04                	add    $0x4,%al
  282c68:	24 00                	and    $0x0,%al
  282c6a:	00 00                	add    %al,(%eax)
  282c6c:	78 01                	js     282c6f <cursor.1395+0x2c3>
  282c6e:	00 00                	add    %al,(%eax)
  282c70:	ae                   	scas   %es:(%edi),%al
  282c71:	d9 ff                	fcos   
  282c73:	ff                   	(bad)  
  282c74:	39 00                	cmp    %eax,(%eax)
  282c76:	00 00                	add    %al,(%eax)
  282c78:	00 41 0e             	add    %al,0xe(%ecx)
  282c7b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282c81:	44                   	inc    %esp
  282c82:	86 03                	xchg   %al,(%ebx)
  282c84:	43                   	inc    %ebx
  282c85:	83 04 6c c3          	addl   $0xffffffc3,(%esp,%ebp,2)
  282c89:	41                   	inc    %ecx
  282c8a:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282c8e:	04 04                	add    $0x4,%al
  282c90:	28 00                	sub    %al,(%eax)
  282c92:	00 00                	add    %al,(%eax)
  282c94:	a0 01 00 00 bf       	mov    0xbf000001,%al
  282c99:	d9 ff                	fcos   
  282c9b:	ff 62 00             	jmp    *0x0(%edx)
  282c9e:	00 00                	add    %al,(%eax)
  282ca0:	00 41 0e             	add    %al,0xe(%ecx)
  282ca3:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282ca9:	4b                   	dec    %ebx
  282caa:	87 03                	xchg   %eax,(%ebx)
  282cac:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282caf:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  282cb4:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282cb8:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282cbb:	04 28                	add    $0x28,%al
  282cbd:	00 00                	add    %al,(%eax)
  282cbf:	00 cc                	add    %cl,%ah
  282cc1:	01 00                	add    %eax,(%eax)
  282cc3:	00 f5                	add    %dh,%ch
  282cc5:	d9 ff                	fcos   
  282cc7:	ff 62 00             	jmp    *0x0(%edx)
  282cca:	00 00                	add    %al,(%eax)
  282ccc:	00 41 0e             	add    %al,0xe(%ecx)
  282ccf:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282cd5:	4b                   	dec    %ebx
  282cd6:	87 03                	xchg   %eax,(%ebx)
  282cd8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282cdb:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  282ce0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282ce4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282ce7:	04 28                	add    $0x28,%al
  282ce9:	00 00                	add    %al,(%eax)
  282ceb:	00 f8                	add    %bh,%al
  282ced:	01 00                	add    %eax,(%eax)
  282cef:	00 2b                	add    %ch,(%ebx)
  282cf1:	da ff                	(bad)  
  282cf3:	ff aa 00 00 00 00    	ljmp   *0x0(%edx)
  282cf9:	41                   	inc    %ecx
  282cfa:	0e                   	push   %cs
  282cfb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282d01:	46                   	inc    %esi
  282d02:	87 03                	xchg   %eax,(%ebx)
  282d04:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282d07:	05 02 9d c3 41       	add    $0x41c39d02,%eax
  282d0c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282d10:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282d13:	04 28                	add    $0x28,%al
  282d15:	00 00                	add    %al,(%eax)
  282d17:	00 24 02             	add    %ah,(%edx,%eax,1)
  282d1a:	00 00                	add    %al,(%eax)
  282d1c:	a9 da ff ff 51       	test   $0x51ffffda,%eax
  282d21:	00 00                	add    %al,(%eax)
  282d23:	00 00                	add    %al,(%eax)
  282d25:	41                   	inc    %ecx
  282d26:	0e                   	push   %cs
  282d27:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282d2d:	41                   	inc    %ecx
  282d2e:	87 03                	xchg   %eax,(%ebx)
  282d30:	4a                   	dec    %edx
  282d31:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282d34:	05 7d c3 41 c6       	add    $0xc641c37d,%eax
  282d39:	41                   	inc    %ecx
  282d3a:	c7 41 c5 0c 04 04 2c 	movl   $0x2c04040c,-0x3b(%ecx)
  282d41:	00 00                	add    %al,(%eax)
  282d43:	00 50 02             	add    %dl,0x2(%eax)
  282d46:	00 00                	add    %al,(%eax)
  282d48:	ce                   	into   
  282d49:	da ff                	(bad)  
  282d4b:	ff 64 00 00          	jmp    *0x0(%eax,%eax,1)
  282d4f:	00 00                	add    %al,(%eax)
  282d51:	41                   	inc    %ecx
  282d52:	0e                   	push   %cs
  282d53:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282d59:	41                   	inc    %ecx
  282d5a:	87 03                	xchg   %eax,(%ebx)
  282d5c:	44                   	inc    %esp
  282d5d:	86 04 45 83 05 02 53 	xchg   %al,0x53020583(,%eax,2)
  282d64:	c3                   	ret    
  282d65:	41                   	inc    %ecx
  282d66:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282d6a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282d6d:	04 00                	add    $0x0,%al
  282d6f:	00 20                	add    %ah,(%eax)
  282d71:	00 00                	add    %al,(%eax)
  282d73:	00 80 02 00 00 02    	add    %al,0x2000002(%eax)
  282d79:	db ff                	(bad)  
  282d7b:	ff                   	(bad)  
  282d7c:	3a 00                	cmp    (%eax),%al
  282d7e:	00 00                	add    %al,(%eax)
  282d80:	00 41 0e             	add    %al,0xe(%ecx)
  282d83:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282d89:	44                   	inc    %esp
  282d8a:	83 03 72             	addl   $0x72,(%ebx)
  282d8d:	c5 c3 0c             	(bad)  
  282d90:	04 04                	add    $0x4,%al
  282d92:	00 00                	add    %al,(%eax)
  282d94:	28 00                	sub    %al,(%eax)
  282d96:	00 00                	add    %al,(%eax)
  282d98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  282d99:	02 00                	add    (%eax),%al
  282d9b:	00 18                	add    %bl,(%eax)
  282d9d:	db ff                	(bad)  
  282d9f:	ff 50 00             	call   *0x0(%eax)
  282da2:	00 00                	add    %al,(%eax)
  282da4:	00 41 0e             	add    %al,0xe(%ecx)
  282da7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282dad:	44                   	inc    %esp
  282dae:	87 03                	xchg   %eax,(%ebx)
  282db0:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282db3:	05 02 43 c3 41       	add    $0x41c34302,%eax
  282db8:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282dbc:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282dbf:	04 2c                	add    $0x2c,%al
  282dc1:	00 00                	add    %al,(%eax)
  282dc3:	00 d0                	add    %dl,%al
  282dc5:	02 00                	add    (%eax),%al
  282dc7:	00 3c db             	add    %bh,(%ebx,%ebx,8)
  282dca:	ff                   	(bad)  
  282dcb:	ff 4f 00             	decl   0x0(%edi)
  282dce:	00 00                	add    %al,(%eax)
  282dd0:	00 41 0e             	add    %al,0xe(%ecx)
  282dd3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282dd9:	41                   	inc    %ecx
  282dda:	87 03                	xchg   %eax,(%ebx)
  282ddc:	44                   	inc    %esp
  282ddd:	86 04 44             	xchg   %al,(%esp,%eax,2)
  282de0:	83 05 7f c3 41 c6 41 	addl   $0x41,0xc641c37f
  282de7:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  282dee:	00 00                	add    %al,(%eax)
  282df0:	2c 00                	sub    $0x0,%al
  282df2:	00 00                	add    %al,(%eax)
  282df4:	00 03                	add    %al,(%ebx)
  282df6:	00 00                	add    %al,(%eax)
  282df8:	5b                   	pop    %ebx
  282df9:	db ff                	(bad)  
  282dfb:	ff 54 00 00          	call   *0x0(%eax,%eax,1)
  282dff:	00 00                	add    %al,(%eax)
  282e01:	41                   	inc    %ecx
  282e02:	0e                   	push   %cs
  282e03:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282e09:	48                   	dec    %eax
  282e0a:	87 03                	xchg   %eax,(%ebx)
  282e0c:	86 04 44             	xchg   %al,(%esp,%eax,2)
  282e0f:	83 05 02 41 c3 41 c6 	addl   $0xffffffc6,0x41c34102
  282e16:	41                   	inc    %ecx
  282e17:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  282e1e:	00 00                	add    %al,(%eax)
  282e20:	1c 00                	sbb    $0x0,%al
  282e22:	00 00                	add    %al,(%eax)
  282e24:	30 03                	xor    %al,(%ebx)
  282e26:	00 00                	add    %al,(%eax)
  282e28:	7f db                	jg     282e05 <cursor.1395+0x459>
  282e2a:	ff                   	(bad)  
  282e2b:	ff 2a                	ljmp   *(%edx)
  282e2d:	00 00                	add    %al,(%eax)
  282e2f:	00 00                	add    %al,(%eax)
  282e31:	41                   	inc    %ecx
  282e32:	0e                   	push   %cs
  282e33:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282e39:	66 c5 0c 04          	lds    (%esp,%eax,1),%cx
  282e3d:	04 00                	add    $0x0,%al
  282e3f:	00 20                	add    %ah,(%eax)
  282e41:	00 00                	add    %al,(%eax)
  282e43:	00 50 03             	add    %dl,0x3(%eax)
  282e46:	00 00                	add    %al,(%eax)
  282e48:	89 db                	mov    %ebx,%ebx
  282e4a:	ff                   	(bad)  
  282e4b:	ff 60 01             	jmp    *0x1(%eax)
  282e4e:	00 00                	add    %al,(%eax)
  282e50:	00 41 0e             	add    %al,0xe(%ecx)
  282e53:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282e59:	41                   	inc    %ecx
  282e5a:	83 03 03             	addl   $0x3,(%ebx)
  282e5d:	5b                   	pop    %ebx
  282e5e:	01 c5                	add    %eax,%ebp
  282e60:	c3                   	ret    
  282e61:	0c 04                	or     $0x4,%al
  282e63:	04 1c                	add    $0x1c,%al
  282e65:	00 00                	add    %al,(%eax)
  282e67:	00 74 03 00          	add    %dh,0x0(%ebx,%eax,1)
  282e6b:	00 c5                	add    %al,%ch
  282e6d:	dc ff                	fdivr  %st,%st(7)
  282e6f:	ff                   	(bad)  
  282e70:	3a 00                	cmp    (%eax),%al
  282e72:	00 00                	add    %al,(%eax)
  282e74:	00 41 0e             	add    %al,0xe(%ecx)
  282e77:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282e7d:	71 c5                	jno    282e44 <cursor.1395+0x498>
  282e7f:	0c 04                	or     $0x4,%al
  282e81:	04 00                	add    $0x0,%al
  282e83:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282e86:	00 00                	add    %al,(%eax)
  282e88:	94                   	xchg   %eax,%esp
  282e89:	03 00                	add    (%eax),%eax
  282e8b:	00 df                	add    %bl,%bh
  282e8d:	dc ff                	fdivr  %st,%st(7)
  282e8f:	ff 24 00             	jmp    *(%eax,%eax,1)
  282e92:	00 00                	add    %al,(%eax)
  282e94:	00 41 0e             	add    %al,0xe(%ecx)
  282e97:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282e9d:	5b                   	pop    %ebx
  282e9e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282ea1:	04 00                	add    $0x0,%al
  282ea3:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282ea6:	00 00                	add    %al,(%eax)
  282ea8:	b4 03                	mov    $0x3,%ah
  282eaa:	00 00                	add    %al,(%eax)
  282eac:	e3 dc                	jecxz  282e8a <cursor.1395+0x4de>
  282eae:	ff                   	(bad)  
  282eaf:	ff 29                	ljmp   *(%ecx)
  282eb1:	00 00                	add    %al,(%eax)
  282eb3:	00 00                	add    %al,(%eax)
  282eb5:	41                   	inc    %ecx
  282eb6:	0e                   	push   %cs
  282eb7:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282ebd:	60                   	pusha  
  282ebe:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282ec1:	04 00                	add    $0x0,%al
  282ec3:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282ec6:	00 00                	add    %al,(%eax)
  282ec8:	d4 03                	aam    $0x3
  282eca:	00 00                	add    %al,(%eax)
  282ecc:	ec                   	in     (%dx),%al
  282ecd:	dc ff                	fdivr  %st,%st(7)
  282ecf:	ff 0f                	decl   (%edi)
  282ed1:	00 00                	add    %al,(%eax)
  282ed3:	00 00                	add    %al,(%eax)
  282ed5:	41                   	inc    %ecx
  282ed6:	0e                   	push   %cs
  282ed7:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282edd:	46                   	inc    %esi
  282ede:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282ee1:	04 00                	add    $0x0,%al
  282ee3:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282ee6:	00 00                	add    %al,(%eax)
  282ee8:	f4                   	hlt    
  282ee9:	03 00                	add    (%eax),%eax
  282eeb:	00 db                	add    %bl,%bl
  282eed:	dc ff                	fdivr  %st,%st(7)
  282eef:	ff 1f                	lcall  *(%edi)
  282ef1:	00 00                	add    %al,(%eax)
  282ef3:	00 00                	add    %al,(%eax)
  282ef5:	41                   	inc    %ecx
  282ef6:	0e                   	push   %cs
  282ef7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282efd:	5b                   	pop    %ebx
  282efe:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282f01:	04 00                	add    $0x0,%al
  282f03:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282f06:	00 00                	add    %al,(%eax)
  282f08:	14 04                	adc    $0x4,%al
  282f0a:	00 00                	add    %al,(%eax)
  282f0c:	30 dd                	xor    %bl,%ch
  282f0e:	ff                   	(bad)  
  282f0f:	ff 2b                	ljmp   *(%ebx)
  282f11:	00 00                	add    %al,(%eax)
  282f13:	00 00                	add    %al,(%eax)
  282f15:	41                   	inc    %ecx
  282f16:	0e                   	push   %cs
  282f17:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282f1d:	67 c5 0c             	lds    (%si),%ecx
  282f20:	04 04                	add    $0x4,%al
  282f22:	00 00                	add    %al,(%eax)
  282f24:	20 00                	and    %al,(%eax)
  282f26:	00 00                	add    %al,(%eax)
  282f28:	34 04                	xor    $0x4,%al
  282f2a:	00 00                	add    %al,(%eax)
  282f2c:	3b dd                	cmp    %ebp,%ebx
  282f2e:	ff                   	(bad)  
  282f2f:	ff                   	(bad)  
  282f30:	3e 00 00             	add    %al,%ds:(%eax)
  282f33:	00 00                	add    %al,(%eax)
  282f35:	41                   	inc    %ecx
  282f36:	0e                   	push   %cs
  282f37:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282f3d:	44                   	inc    %esp
  282f3e:	83 03 75             	addl   $0x75,(%ebx)
  282f41:	c3                   	ret    
  282f42:	41                   	inc    %ecx
  282f43:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282f46:	04 00                	add    $0x0,%al
  282f48:	28 00                	sub    %al,(%eax)
  282f4a:	00 00                	add    %al,(%eax)
  282f4c:	58                   	pop    %eax
  282f4d:	04 00                	add    $0x0,%al
  282f4f:	00 55 dd             	add    %dl,-0x23(%ebp)
  282f52:	ff                   	(bad)  
  282f53:	ff 35 00 00 00 00    	pushl  0x0
  282f59:	41                   	inc    %ecx
  282f5a:	0e                   	push   %cs
  282f5b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282f61:	46                   	inc    %esi
  282f62:	87 03                	xchg   %eax,(%ebx)
  282f64:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282f67:	05 68 c3 41 c6       	add    $0xc641c368,%eax
  282f6c:	41                   	inc    %ecx
  282f6d:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  282f74:	1c 00                	sbb    $0x0,%al
  282f76:	00 00                	add    %al,(%eax)
  282f78:	84 04 00             	test   %al,(%eax,%eax,1)
  282f7b:	00 5e dd             	add    %bl,-0x23(%esi)
  282f7e:	ff                   	(bad)  
  282f7f:	ff 0e                	decl   (%esi)
  282f81:	00 00                	add    %al,(%eax)
  282f83:	00 00                	add    %al,(%eax)
  282f85:	41                   	inc    %ecx
  282f86:	0e                   	push   %cs
  282f87:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282f8d:	44                   	inc    %esp
  282f8e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282f91:	04 00                	add    $0x0,%al
  282f93:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282f96:	00 00                	add    %al,(%eax)
  282f98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  282f99:	04 00                	add    $0x0,%al
  282f9b:	00 4c dd ff          	add    %cl,-0x1(%ebp,%ebx,8)
  282f9f:	ff 29                	ljmp   *(%ecx)
  282fa1:	00 00                	add    %al,(%eax)
  282fa3:	00 00                	add    %al,(%eax)
  282fa5:	41                   	inc    %ecx
  282fa6:	0e                   	push   %cs
  282fa7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282fad:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
  282fb1:	04 00                	add    $0x0,%al
  282fb3:	00 20                	add    %ah,(%eax)
  282fb5:	00 00                	add    %al,(%eax)
  282fb7:	00 c4                	add    %al,%ah
  282fb9:	04 00                	add    $0x0,%al
  282fbb:	00 55 dd             	add    %dl,-0x23(%ebp)
  282fbe:	ff                   	(bad)  
  282fbf:	ff 8e 00 00 00 00    	decl   0x0(%esi)
  282fc5:	41                   	inc    %ecx
  282fc6:	0e                   	push   %cs
  282fc7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282fcd:	44                   	inc    %esp
  282fce:	83 03 02             	addl   $0x2,(%ebx)
  282fd1:	85 c3                	test   %eax,%ebx
  282fd3:	41                   	inc    %ecx
  282fd4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282fd7:	04 20                	add    $0x20,%al
  282fd9:	00 00                	add    %al,(%eax)
  282fdb:	00 e8                	add    %ch,%al
  282fdd:	04 00                	add    $0x0,%al
  282fdf:	00 bf dd ff ff 3a    	add    %bh,0x3affffdd(%edi)
  282fe5:	00 00                	add    %al,(%eax)
  282fe7:	00 00                	add    %al,(%eax)
  282fe9:	41                   	inc    %ecx
  282fea:	0e                   	push   %cs
  282feb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282ff1:	44                   	inc    %esp
  282ff2:	83 03 71             	addl   $0x71,(%ebx)
  282ff5:	c3                   	ret    
  282ff6:	41                   	inc    %ecx
  282ff7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282ffa:	04 00                	add    $0x0,%al
  282ffc:	20 00                	and    %al,(%eax)
  282ffe:	00 00                	add    %al,(%eax)
  283000:	0c 05                	or     $0x5,%al
  283002:	00 00                	add    %al,(%eax)
  283004:	d5 dd                	aad    $0xdd
  283006:	ff                   	(bad)  
  283007:	ff 4e 00             	decl   0x0(%esi)
  28300a:	00 00                	add    %al,(%eax)
  28300c:	00 41 0e             	add    %al,0xe(%ecx)
  28300f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283015:	41                   	inc    %ecx
  283016:	83 03 02             	addl   $0x2,(%ebx)
  283019:	49                   	dec    %ecx
  28301a:	c5 c3 0c             	(bad)  
  28301d:	04 04                	add    $0x4,%al
  28301f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  283022:	00 00                	add    %al,(%eax)
  283024:	30 05 00 00 ff dd    	xor    %al,0xddff0000
  28302a:	ff                   	(bad)  
  28302b:	ff 23                	jmp    *(%ebx)
  28302d:	00 00                	add    %al,(%eax)
  28302f:	00 00                	add    %al,(%eax)
  283031:	41                   	inc    %ecx
  283032:	0e                   	push   %cs
  283033:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  283039:	5f                   	pop    %edi
  28303a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28303d:	04 00                	add    $0x0,%al
  28303f:	00 20                	add    %ah,(%eax)
  283041:	00 00                	add    %al,(%eax)
  283043:	00 50 05             	add    %dl,0x5(%eax)
  283046:	00 00                	add    %al,(%eax)
  283048:	02 de                	add    %dh,%bl
  28304a:	ff                   	(bad)  
  28304b:	ff 1b                	lcall  *(%ebx)
  28304d:	00 00                	add    %al,(%eax)
  28304f:	00 00                	add    %al,(%eax)
  283051:	41                   	inc    %ecx
  283052:	0e                   	push   %cs
  283053:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  283059:	46                   	inc    %esi
  28305a:	83 03 4e             	addl   $0x4e,(%ebx)
  28305d:	c3                   	ret    
  28305e:	41                   	inc    %ecx
  28305f:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  283062:	04 00                	add    $0x0,%al
  283064:	28 00                	sub    %al,(%eax)
  283066:	00 00                	add    %al,(%eax)
  283068:	74 05                	je     28306f <cursor.1395+0x6c3>
  28306a:	00 00                	add    %al,(%eax)
  28306c:	f9                   	stc    
  28306d:	dd ff                	(bad)  
  28306f:	ff 5b 00             	lcall  *0x0(%ebx)
  283072:	00 00                	add    %al,(%eax)
  283074:	00 41 0e             	add    %al,0xe(%ecx)
  283077:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  28307d:	46                   	inc    %esi
  28307e:	87 03                	xchg   %eax,(%ebx)
  283080:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  283083:	05 02 4c c3 41       	add    $0x41c34c02,%eax
  283088:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28308c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28308f:	04 28                	add    $0x28,%al
  283091:	00 00                	add    %al,(%eax)
  283093:	00 a0 05 00 00 28    	add    %ah,0x28000005(%eax)
  283099:	de ff                	fdivrp %st,%st(7)
  28309b:	ff                   	(bad)  
  28309c:	ea 00 00 00 00 41 0e 	ljmp   $0xe41,$0x0
  2830a3:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2830a9:	46                   	inc    %esi
  2830aa:	87 03                	xchg   %eax,(%ebx)
  2830ac:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2830af:	05 02 db c3 41       	add    $0x41c3db02,%eax
  2830b4:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2830b8:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2830bb:	04                   	.byte 0x4

Disassembly of section .bss:

002830bc <keyfifo>:
	...

002830d4 <mousefifo>:
	...

Disassembly of section .stab:

00000000 <.stab>:
       0:	01 00                	add    %eax,(%eax)
       2:	00 00                	add    %al,(%eax)
       4:	00 00                	add    %al,(%eax)
       6:	8d 04 1c             	lea    (%esp,%ebx,1),%eax
       9:	11 00                	adc    %eax,(%eax)
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
     103:	00 cf                	add    %cl,%bh
     105:	a8 00                	test   $0x0,%al
     107:	00 a6 02 00 00 82    	add    %ah,-0x7dfffffe(%esi)
     10d:	00 00                	add    %al,(%eax)
     10f:	00 00                	add    %al,(%eax)
     111:	00 00                	add    %al,(%eax)
     113:	00 ae 02 00 00 82    	add    %ch,-0x7dfffffe(%esi)
     119:	00 00                	add    %al,(%eax)
     11b:	00 37                	add    %dh,(%edi)
     11d:	53                   	push   %ebx
     11e:	00 00                	add    %al,(%eax)
     120:	b8 02 00 00 80       	mov    $0x80000002,%eax
     125:	00 00                	add    %al,(%eax)
     127:	00 00                	add    %al,(%eax)
     129:	00 00                	add    %al,(%eax)
     12b:	00 ca                	add    %cl,%dl
     12d:	02 00                	add    (%eax),%al
     12f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     135:	00 00                	add    %al,(%eax)
     137:	00 df                	add    %bl,%bh
     139:	02 00                	add    (%eax),%al
     13b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     141:	00 00                	add    %al,(%eax)
     143:	00 f5                	add    %dh,%ch
     145:	02 00                	add    (%eax),%al
     147:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     14d:	00 00                	add    %al,(%eax)
     14f:	00 0a                	add    %cl,(%edx)
     151:	03 00                	add    (%eax),%eax
     153:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     159:	00 00                	add    %al,(%eax)
     15b:	00 20                	add    %ah,(%eax)
     15d:	03 00                	add    (%eax),%eax
     15f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     165:	00 00                	add    %al,(%eax)
     167:	00 35 03 00 00 80    	add    %dh,0x80000003
     16d:	00 00                	add    %al,(%eax)
     16f:	00 00                	add    %al,(%eax)
     171:	00 00                	add    %al,(%eax)
     173:	00 4b 03             	add    %cl,0x3(%ebx)
     176:	00 00                	add    %al,(%eax)
     178:	80 00 00             	addb   $0x0,(%eax)
     17b:	00 00                	add    %al,(%eax)
     17d:	00 00                	add    %al,(%eax)
     17f:	00 60 03             	add    %ah,0x3(%eax)
     182:	00 00                	add    %al,(%eax)
     184:	80 00 00             	addb   $0x0,(%eax)
     187:	00 00                	add    %al,(%eax)
     189:	00 00                	add    %al,(%eax)
     18b:	00 76 03             	add    %dh,0x3(%esi)
     18e:	00 00                	add    %al,(%eax)
     190:	80 00 00             	addb   $0x0,(%eax)
     193:	00 00                	add    %al,(%eax)
     195:	00 00                	add    %al,(%eax)
     197:	00 8d 03 00 00 80    	add    %cl,-0x7ffffffd(%ebp)
     19d:	00 00                	add    %al,(%eax)
     19f:	00 00                	add    %al,(%eax)
     1a1:	00 00                	add    %al,(%eax)
     1a3:	00 a5 03 00 00 80    	add    %ah,-0x7ffffffd(%ebp)
     1a9:	00 00                	add    %al,(%eax)
     1ab:	00 00                	add    %al,(%eax)
     1ad:	00 00                	add    %al,(%eax)
     1af:	00 be 03 00 00 80    	add    %bh,-0x7ffffffd(%esi)
     1b5:	00 00                	add    %al,(%eax)
     1b7:	00 00                	add    %al,(%eax)
     1b9:	00 00                	add    %al,(%eax)
     1bb:	00 d2                	add    %dl,%dl
     1bd:	03 00                	add    (%eax),%eax
     1bf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1c5:	00 00                	add    %al,(%eax)
     1c7:	00 e7                	add    %ah,%bh
     1c9:	03 00                	add    (%eax),%eax
     1cb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1d1:	00 00                	add    %al,(%eax)
     1d3:	00 fd                	add    %bh,%ch
     1d5:	03 00                	add    (%eax),%eax
     1d7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     1dd:	00 00                	add    %al,(%eax)
     1df:	00 00                	add    %al,(%eax)
     1e1:	00 00                	add    %al,(%eax)
     1e3:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     1e9:	00 00                	add    %al,(%eax)
     1eb:	00 00                	add    %al,(%eax)
     1ed:	00 00                	add    %al,(%eax)
     1ef:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     1f5:	00 00                	add    %al,(%eax)
     1f7:	00 11                	add    %dl,(%ecx)
     1f9:	04 00                	add    $0x0,%al
     1fb:	00 82 00 00 00 c8    	add    %al,-0x38000000(%edx)
     201:	3c 00                	cmp    $0x0,%al
     203:	00 18                	add    %bl,(%eax)
     205:	04 00                	add    $0x0,%al
     207:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     20d:	00 00                	add    %al,(%eax)
     20f:	00 4c 04 00          	add    %cl,0x0(%esp,%eax,1)
     213:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     219:	00 00                	add    %al,(%eax)
     21b:	00 5e 04             	add    %bl,0x4(%esi)
     21e:	00 00                	add    %al,(%eax)
     220:	80 00 00             	addb   $0x0,(%eax)
     223:	00 00                	add    %al,(%eax)
     225:	00 00                	add    %al,(%eax)
     227:	00 02                	add    %al,(%edx)
     229:	05 00 00 80 00       	add    $0x800000,%eax
	...
     236:	00 00                	add    %al,(%eax)
     238:	a2 00 00 00 00       	mov    %al,0x0
     23d:	00 00                	add    %al,(%eax)
     23f:	00 16                	add    %dl,(%esi)
     241:	05 00 00 80 00       	add    $0x800000,%eax
     246:	00 00                	add    %al,(%eax)
     248:	00 00                	add    %al,(%eax)
     24a:	00 00                	add    %al,(%eax)
     24c:	b3 05                	mov    $0x5,%bl
     24e:	00 00                	add    %al,(%eax)
     250:	80 00 00             	addb   $0x0,(%eax)
     253:	00 00                	add    %al,(%eax)
     255:	00 00                	add    %al,(%eax)
     257:	00 43 06             	add    %al,0x6(%ebx)
     25a:	00 00                	add    %al,(%eax)
     25c:	80 00 00             	addb   $0x0,(%eax)
     25f:	00 00                	add    %al,(%eax)
     261:	00 00                	add    %al,(%eax)
     263:	00 c1                	add    %al,%cl
     265:	06                   	push   %es
     266:	00 00                	add    %al,(%eax)
     268:	80 00 00             	addb   $0x0,(%eax)
     26b:	00 00                	add    %al,(%eax)
     26d:	00 00                	add    %al,(%eax)
     26f:	00 3e                	add    %bh,(%esi)
     271:	07                   	pop    %es
     272:	00 00                	add    %al,(%eax)
     274:	80 00 00             	addb   $0x0,(%eax)
	...
     27f:	00 a2 00 00 00 00    	add    %ah,0x0(%edx)
     285:	00 00                	add    %al,(%eax)
     287:	00 b7 07 00 00 24    	add    %dh,0x24000007(%edi)
     28d:	00 00                	add    %al,(%eax)
     28f:	00 00                	add    %al,(%eax)
     291:	00 28                	add    %ch,(%eax)
     293:	00 00                	add    %al,(%eax)
     295:	00 00                	add    %al,(%eax)
     297:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
	...
     2a3:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     2a7:	00 0c 00             	add    %cl,(%eax,%eax,1)
     2aa:	00 00                	add    %al,(%eax)
     2ac:	00 00                	add    %al,(%eax)
     2ae:	00 00                	add    %al,(%eax)
     2b0:	44                   	inc    %esp
     2b1:	00 14 00             	add    %dl,(%eax,%eax,1)
     2b4:	13 00                	adc    (%eax),%eax
     2b6:	00 00                	add    %al,(%eax)
     2b8:	00 00                	add    %al,(%eax)
     2ba:	00 00                	add    %al,(%eax)
     2bc:	44                   	inc    %esp
     2bd:	00 15 00 1f 00 00    	add    %dl,0x1f00
     2c3:	00 00                	add    %al,(%eax)
     2c5:	00 00                	add    %al,(%eax)
     2c7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     2cb:	00 24 00             	add    %ah,(%eax,%eax,1)
     2ce:	00 00                	add    %al,(%eax)
     2d0:	00 00                	add    %al,(%eax)
     2d2:	00 00                	add    %al,(%eax)
     2d4:	44                   	inc    %esp
     2d5:	00 1d 00 29 00 00    	add    %bl,0x2900
     2db:	00 00                	add    %al,(%eax)
     2dd:	00 00                	add    %al,(%eax)
     2df:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
     2e3:	00 39                	add    %bh,(%ecx)
     2e5:	00 00                	add    %al,(%eax)
     2e7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     2ed:	00 00                	add    %al,(%eax)
     2ef:	00 57 00             	add    %dl,0x0(%edi)
     2f2:	28 00                	sub    %al,(%eax)
     2f4:	00 00                	add    %al,(%eax)
     2f6:	00 00                	add    %al,(%eax)
     2f8:	44                   	inc    %esp
     2f9:	00 3e                	add    %bh,(%esi)
     2fb:	00 57 00             	add    %dl,0x0(%edi)
     2fe:	00 00                	add    %al,(%eax)
     300:	01 00                	add    %eax,(%eax)
     302:	00 00                	add    %al,(%eax)
     304:	84 00                	test   %al,(%eax)
     306:	00 00                	add    %al,(%eax)
     308:	58                   	pop    %eax
     309:	00 28                	add    %ch,(%eax)
     30b:	00 00                	add    %al,(%eax)
     30d:	00 00                	add    %al,(%eax)
     30f:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
     313:	00 58 00             	add    %bl,0x0(%eax)
     316:	00 00                	add    %al,(%eax)
     318:	00 00                	add    %al,(%eax)
     31a:	00 00                	add    %al,(%eax)
     31c:	44                   	inc    %esp
     31d:	00 25 00 60 00 00    	add    %ah,0x6000
     323:	00 00                	add    %al,(%eax)
     325:	00 00                	add    %al,(%eax)
     327:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
     32b:	00 65 00             	add    %ah,0x0(%ebp)
     32e:	00 00                	add    %al,(%eax)
     330:	00 00                	add    %al,(%eax)
     332:	00 00                	add    %al,(%eax)
     334:	44                   	inc    %esp
     335:	00 2e                	add    %ch,(%esi)
     337:	00 79 00             	add    %bh,0x0(%ecx)
     33a:	00 00                	add    %al,(%eax)
     33c:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     33d:	02 00                	add    (%eax),%al
     33f:	00 84 00 00 00 92 00 	add    %al,0x920000(%eax,%eax,1)
     346:	28 00                	sub    %al,(%eax)
     348:	00 00                	add    %al,(%eax)
     34a:	00 00                	add    %al,(%eax)
     34c:	44                   	inc    %esp
     34d:	00 6c 00 92          	add    %ch,-0x6e(%eax,%eax,1)
     351:	00 00                	add    %al,(%eax)
     353:	00 01                	add    %al,(%ecx)
     355:	00 00                	add    %al,(%eax)
     357:	00 84 00 00 00 9f 00 	add    %al,0x9f0000(%eax,%eax,1)
     35e:	28 00                	sub    %al,(%eax)
     360:	00 00                	add    %al,(%eax)
     362:	00 00                	add    %al,(%eax)
     364:	44                   	inc    %esp
     365:	00 36                	add    %dh,(%esi)
     367:	00 9f 00 00 00 a6    	add    %bl,-0x5a000000(%edi)
     36d:	02 00                	add    (%eax),%al
     36f:	00 84 00 00 00 a4 00 	add    %al,0xa40000(%eax,%eax,1)
     376:	28 00                	sub    %al,(%eax)
     378:	00 00                	add    %al,(%eax)
     37a:	00 00                	add    %al,(%eax)
     37c:	44                   	inc    %esp
     37d:	00 37                	add    %dh,(%edi)
     37f:	00 a4 00 00 00 01 00 	add    %ah,0x10000(%eax,%eax,1)
     386:	00 00                	add    %al,(%eax)
     388:	84 00                	test   %al,(%eax)
     38a:	00 00                	add    %al,(%eax)
     38c:	a5                   	movsl  %ds:(%esi),%es:(%edi)
     38d:	00 28                	add    %ch,(%eax)
     38f:	00 00                	add    %al,(%eax)
     391:	00 00                	add    %al,(%eax)
     393:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     397:	00 a5 00 00 00 00    	add    %ah,0x0(%ebp)
     39d:	00 00                	add    %al,(%eax)
     39f:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
     3a3:	00 b3 00 00 00 00    	add    %dh,0x0(%ebx)
     3a9:	00 00                	add    %al,(%eax)
     3ab:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     3af:	00 b5 00 00 00 00    	add    %dh,0x0(%ebp)
     3b5:	00 00                	add    %al,(%eax)
     3b7:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
     3bb:	00 bb 00 00 00 00    	add    %bh,0x0(%ebx)
     3c1:	00 00                	add    %al,(%eax)
     3c3:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
     3c7:	00 c7                	add    %al,%bh
     3c9:	00 00                	add    %al,(%eax)
     3cb:	00 00                	add    %al,(%eax)
     3cd:	00 00                	add    %al,(%eax)
     3cf:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
     3d3:	00 ce                	add    %cl,%dh
     3d5:	00 00                	add    %al,(%eax)
     3d7:	00 00                	add    %al,(%eax)
     3d9:	00 00                	add    %al,(%eax)
     3db:	00 44 00 4c          	add    %al,0x4c(%eax,%eax,1)
     3df:	00 d0                	add    %dl,%al
     3e1:	00 00                	add    %al,(%eax)
     3e3:	00 00                	add    %al,(%eax)
     3e5:	00 00                	add    %al,(%eax)
     3e7:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     3eb:	00 d5                	add    %dl,%ch
     3ed:	00 00                	add    %al,(%eax)
     3ef:	00 00                	add    %al,(%eax)
     3f1:	00 00                	add    %al,(%eax)
     3f3:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     3f7:	00 ee                	add    %ch,%dh
     3f9:	00 00                	add    %al,(%eax)
     3fb:	00 00                	add    %al,(%eax)
     3fd:	00 00                	add    %al,(%eax)
     3ff:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     403:	00 f7                	add    %dh,%bh
     405:	00 00                	add    %al,(%eax)
     407:	00 00                	add    %al,(%eax)
     409:	00 00                	add    %al,(%eax)
     40b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     40f:	00 03                	add    %al,(%ebx)
     411:	01 00                	add    %eax,(%eax)
     413:	00 00                	add    %al,(%eax)
     415:	00 00                	add    %al,(%eax)
     417:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
     41b:	00 06                	add    %al,(%esi)
     41d:	01 00                	add    %eax,(%eax)
     41f:	00 00                	add    %al,(%eax)
     421:	00 00                	add    %al,(%eax)
     423:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     427:	00 0b                	add    %cl,(%ebx)
     429:	01 00                	add    %eax,(%eax)
     42b:	00 00                	add    %al,(%eax)
     42d:	00 00                	add    %al,(%eax)
     42f:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     433:	00 10                	add    %dl,(%eax)
     435:	01 00                	add    %eax,(%eax)
     437:	00 00                	add    %al,(%eax)
     439:	00 00                	add    %al,(%eax)
     43b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
     43f:	00 15 01 00 00 00    	add    %dl,0x1
     445:	00 00                	add    %al,(%eax)
     447:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
     44b:	00 20                	add    %ah,(%eax)
     44d:	01 00                	add    %eax,(%eax)
     44f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     455:	00 00                	add    %al,(%eax)
     457:	00 40 01             	add    %al,0x1(%eax)
     45a:	28 00                	sub    %al,(%eax)
     45c:	00 00                	add    %al,(%eax)
     45e:	00 00                	add    %al,(%eax)
     460:	44                   	inc    %esp
     461:	00 3e                	add    %bh,(%esi)
     463:	00 40 01             	add    %al,0x1(%eax)
     466:	00 00                	add    %al,(%eax)
     468:	01 00                	add    %eax,(%eax)
     46a:	00 00                	add    %al,(%eax)
     46c:	84 00                	test   %al,(%eax)
     46e:	00 00                	add    %al,(%eax)
     470:	41                   	inc    %ecx
     471:	01 28                	add    %ebp,(%eax)
     473:	00 00                	add    %al,(%eax)
     475:	00 00                	add    %al,(%eax)
     477:	00 44 00 59          	add    %al,0x59(%eax,%eax,1)
     47b:	00 41 01             	add    %al,0x1(%ecx)
     47e:	00 00                	add    %al,(%eax)
     480:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     481:	02 00                	add    (%eax),%al
     483:	00 84 00 00 00 6d 01 	add    %al,0x16d0000(%eax,%eax,1)
     48a:	28 00                	sub    %al,(%eax)
     48c:	00 00                	add    %al,(%eax)
     48e:	00 00                	add    %al,(%eax)
     490:	44                   	inc    %esp
     491:	00 37                	add    %dh,(%edi)
     493:	00 6d 01             	add    %ch,0x1(%ebp)
     496:	00 00                	add    %al,(%eax)
     498:	00 00                	add    %al,(%eax)
     49a:	00 00                	add    %al,(%eax)
     49c:	44                   	inc    %esp
     49d:	00 45 00             	add    %al,0x0(%ebp)
     4a0:	6e                   	outsb  %ds:(%esi),(%dx)
     4a1:	01 00                	add    %eax,(%eax)
     4a3:	00 01                	add    %al,(%ecx)
     4a5:	00 00                	add    %al,(%eax)
     4a7:	00 84 00 00 00 71 01 	add    %al,0x1710000(%eax,%eax,1)
     4ae:	28 00                	sub    %al,(%eax)
     4b0:	00 00                	add    %al,(%eax)
     4b2:	00 00                	add    %al,(%eax)
     4b4:	44                   	inc    %esp
     4b5:	00 61 00             	add    %ah,0x0(%ecx)
     4b8:	71 01                	jno    4bb <bootmain-0x27fb45>
     4ba:	00 00                	add    %al,(%eax)
     4bc:	00 00                	add    %al,(%eax)
     4be:	00 00                	add    %al,(%eax)
     4c0:	44                   	inc    %esp
     4c1:	00 64 00 85          	add    %ah,-0x7b(%eax,%eax,1)
     4c5:	01 00                	add    %eax,(%eax)
     4c7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     4cd:	00 00                	add    %al,(%eax)
     4cf:	00 98 01 28 00 00    	add    %bl,0x2801(%eax)
     4d5:	00 00                	add    %al,(%eax)
     4d7:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     4db:	00 98 01 00 00 01    	add    %bl,0x1000001(%eax)
     4e1:	00 00                	add    %al,(%eax)
     4e3:	00 84 00 00 00 99 01 	add    %al,0x1990000(%eax,%eax,1)
     4ea:	28 00                	sub    %al,(%eax)
     4ec:	00 00                	add    %al,(%eax)
     4ee:	00 00                	add    %al,(%eax)
     4f0:	44                   	inc    %esp
     4f1:	00 67 00             	add    %ah,0x0(%edi)
     4f4:	99                   	cltd   
     4f5:	01 00                	add    %eax,(%eax)
     4f7:	00 00                	add    %al,(%eax)
     4f9:	00 00                	add    %al,(%eax)
     4fb:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
     4ff:	00 ad 01 00 00 00    	add    %ch,0x1(%ebp)
     505:	00 00                	add    %al,(%eax)
     507:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
     50b:	00 c7                	add    %al,%bh
     50d:	01 00                	add    %eax,(%eax)
     50f:	00 00                	add    %al,(%eax)
     511:	00 00                	add    %al,(%eax)
     513:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     517:	00 e8                	add    %ch,%al
     519:	01 00                	add    %eax,(%eax)
     51b:	00 00                	add    %al,(%eax)
     51d:	00 00                	add    %al,(%eax)
     51f:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
     523:	00 00                	add    %al,(%eax)
     525:	02 00                	add    (%eax),%al
     527:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     52d:	00 00                	add    %al,(%eax)
     52f:	00 0d 02 28 00 00    	add    %cl,0x2802
     535:	00 00                	add    %al,(%eax)
     537:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     53b:	00 0d 02 00 00 01    	add    %cl,0x1000002
     541:	00 00                	add    %al,(%eax)
     543:	00 84 00 00 00 0e 02 	add    %al,0x20e0000(%eax,%eax,1)
     54a:	28 00                	sub    %al,(%eax)
     54c:	00 00                	add    %al,(%eax)
     54e:	00 00                	add    %al,(%eax)
     550:	44                   	inc    %esp
     551:	00 71 00             	add    %dh,0x0(%ecx)
     554:	0e                   	push   %cs
     555:	02 00                	add    (%eax),%al
     557:	00 00                	add    %al,(%eax)
     559:	00 00                	add    %al,(%eax)
     55b:	00 44 00 74          	add    %al,0x74(%eax,%eax,1)
     55f:	00 2b                	add    %ch,(%ebx)
     561:	02 00                	add    (%eax),%al
     563:	00 00                	add    %al,(%eax)
     565:	00 00                	add    %al,(%eax)
     567:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
     56b:	00 42 02             	add    %al,0x2(%edx)
     56e:	00 00                	add    %al,(%eax)
     570:	00 00                	add    %al,(%eax)
     572:	00 00                	add    %al,(%eax)
     574:	44                   	inc    %esp
     575:	00 77 00             	add    %dh,0x0(%edi)
     578:	58                   	pop    %eax
     579:	02 00                	add    (%eax),%al
     57b:	00 00                	add    %al,(%eax)
     57d:	00 00                	add    %al,(%eax)
     57f:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     583:	00 61 02             	add    %ah,0x2(%ecx)
     586:	00 00                	add    %al,(%eax)
     588:	00 00                	add    %al,(%eax)
     58a:	00 00                	add    %al,(%eax)
     58c:	44                   	inc    %esp
     58d:	00 79 00             	add    %bh,0x0(%ecx)
     590:	6a 02                	push   $0x2
     592:	00 00                	add    %al,(%eax)
     594:	00 00                	add    %al,(%eax)
     596:	00 00                	add    %al,(%eax)
     598:	44                   	inc    %esp
     599:	00 7c 00 71          	add    %bh,0x71(%eax,%eax,1)
     59d:	02 00                	add    (%eax),%al
     59f:	00 00                	add    %al,(%eax)
     5a1:	00 00                	add    %al,(%eax)
     5a3:	00 44 00 7d          	add    %al,0x7d(%eax,%eax,1)
     5a7:	00 86 02 00 00 00    	add    %al,0x2(%esi)
     5ad:	00 00                	add    %al,(%eax)
     5af:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     5b3:	00 a3 02 00 00 00    	add    %ah,0x2(%ebx)
     5b9:	00 00                	add    %al,(%eax)
     5bb:	00 44 00 8c          	add    %al,-0x74(%eax,%eax,1)
     5bf:	00 ce                	add    %cl,%dh
     5c1:	02 00                	add    (%eax),%al
     5c3:	00 00                	add    %al,(%eax)
     5c5:	00 00                	add    %al,(%eax)
     5c7:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
     5cb:	00 d8                	add    %bl,%al
     5cd:	02 00                	add    (%eax),%al
     5cf:	00 00                	add    %al,(%eax)
     5d1:	00 00                	add    %al,(%eax)
     5d3:	00 44 00 91          	add    %al,-0x6f(%eax,%eax,1)
     5d7:	00 e0                	add    %ah,%al
     5d9:	02 00                	add    (%eax),%al
     5db:	00 00                	add    %al,(%eax)
     5dd:	00 00                	add    %al,(%eax)
     5df:	00 44 00 93          	add    %al,-0x6d(%eax,%eax,1)
     5e3:	00 ea                	add    %ch,%dl
     5e5:	02 00                	add    (%eax),%al
     5e7:	00 00                	add    %al,(%eax)
     5e9:	00 00                	add    %al,(%eax)
     5eb:	00 44 00 95          	add    %al,-0x6b(%eax,%eax,1)
     5ef:	00 f2                	add    %dh,%dl
     5f1:	02 00                	add    (%eax),%al
     5f3:	00 00                	add    %al,(%eax)
     5f5:	00 00                	add    %al,(%eax)
     5f7:	00 44 00 96          	add    %al,-0x6a(%eax,%eax,1)
     5fb:	00 ff                	add    %bh,%bh
     5fd:	02 00                	add    (%eax),%al
     5ff:	00 00                	add    %al,(%eax)
     601:	00 00                	add    %al,(%eax)
     603:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
     607:	00 13                	add    %dl,(%ebx)
     609:	03 00                	add    (%eax),%eax
     60b:	00 00                	add    %al,(%eax)
     60d:	00 00                	add    %al,(%eax)
     60f:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
     613:	00 30                	add    %dh,(%eax)
     615:	03 00                	add    (%eax),%eax
     617:	00 c8                	add    %cl,%al
     619:	07                   	pop    %es
     61a:	00 00                	add    %al,(%eax)
     61c:	80 00 00             	addb   $0x0,(%eax)
     61f:	00 f8                	add    %bh,%al
     621:	fe                   	(bad)  
     622:	ff                   	(bad)  
     623:	ff                   	(bad)  
     624:	ec                   	in     (%dx),%al
     625:	07                   	pop    %es
     626:	00 00                	add    %al,(%eax)
     628:	80 00 00             	addb   $0x0,(%eax)
     62b:	00 50 fe             	add    %dl,-0x2(%eax)
     62e:	ff                   	(bad)  
     62f:	ff 09                	decl   (%ecx)
     631:	08 00                	or     %al,(%eax)
     633:	00 80 00 00 00 30    	add    %al,0x30000000(%eax)
     639:	fe                   	(bad)  
     63a:	ff                   	(bad)  
     63b:	ff 2b                	ljmp   *(%ebx)
     63d:	08 00                	or     %al,(%eax)
     63f:	00 80 00 00 00 78    	add    %al,0x78000000(%eax)
     645:	fe                   	(bad)  
     646:	ff                   	(bad)  
     647:	ff 50 08             	call   *0x8(%eax)
     64a:	00 00                	add    %al,(%eax)
     64c:	80 00 00             	addb   $0x0,(%eax)
     64f:	00 20                	add    %ah,(%eax)
     651:	fe                   	(bad)  
     652:	ff                   	(bad)  
     653:	ff 5b 08             	lcall  *0x8(%ebx)
     656:	00 00                	add    %al,(%eax)
     658:	40                   	inc    %eax
     659:	00 00                	add    %al,(%eax)
     65b:	00 03                	add    %al,(%ebx)
     65d:	00 00                	add    %al,(%eax)
     65f:	00 00                	add    %al,(%eax)
     661:	00 00                	add    %al,(%eax)
     663:	00 c0                	add    %al,%al
	...
     66d:	00 00                	add    %al,(%eax)
     66f:	00 e0                	add    %ah,%al
     671:	00 00                	add    %al,(%eax)
     673:	00 5d 03             	add    %bl,0x3(%ebp)
     676:	00 00                	add    %al,(%eax)
     678:	6b 08 00             	imul   $0x0,(%eax),%ecx
     67b:	00 20                	add    %ah,(%eax)
     67d:	00 00                	add    %al,(%eax)
     67f:	00 00                	add    %al,(%eax)
     681:	00 00                	add    %al,(%eax)
     683:	00 94 08 00 00 20 00 	add    %dl,0x200000(%eax,%ecx,1)
	...
     692:	00 00                	add    %al,(%eax)
     694:	64 00 00             	add    %al,%fs:(%eax)
     697:	00 5d 03             	add    %bl,0x3(%ebp)
     69a:	28 00                	sub    %al,(%eax)
     69c:	bb 08 00 00 64       	mov    $0x64000008,%ebx
     6a1:	00 02                	add    %al,(%edx)
     6a3:	00 5d 03             	add    %bl,0x3(%ebp)
     6a6:	28 00                	sub    %al,(%eax)
     6a8:	08 00                	or     %al,(%eax)
     6aa:	00 00                	add    %al,(%eax)
     6ac:	3c 00                	cmp    $0x0,%al
     6ae:	00 00                	add    %al,(%eax)
     6b0:	00 00                	add    %al,(%eax)
     6b2:	00 00                	add    %al,(%eax)
     6b4:	17                   	pop    %ss
     6b5:	00 00                	add    %al,(%eax)
     6b7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     6bd:	00 00                	add    %al,(%eax)
     6bf:	00 41 00             	add    %al,0x0(%ecx)
     6c2:	00 00                	add    %al,(%eax)
     6c4:	80 00 00             	addb   $0x0,(%eax)
     6c7:	00 00                	add    %al,(%eax)
     6c9:	00 00                	add    %al,(%eax)
     6cb:	00 5b 00             	add    %bl,0x0(%ebx)
     6ce:	00 00                	add    %al,(%eax)
     6d0:	80 00 00             	addb   $0x0,(%eax)
     6d3:	00 00                	add    %al,(%eax)
     6d5:	00 00                	add    %al,(%eax)
     6d7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     6dd:	00 00                	add    %al,(%eax)
     6df:	00 00                	add    %al,(%eax)
     6e1:	00 00                	add    %al,(%eax)
     6e3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     6e9:	00 00                	add    %al,(%eax)
     6eb:	00 00                	add    %al,(%eax)
     6ed:	00 00                	add    %al,(%eax)
     6ef:	00 e1                	add    %ah,%cl
     6f1:	00 00                	add    %al,(%eax)
     6f3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     6f9:	00 00                	add    %al,(%eax)
     6fb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     6fe:	00 00                	add    %al,(%eax)
     700:	80 00 00             	addb   $0x0,(%eax)
     703:	00 00                	add    %al,(%eax)
     705:	00 00                	add    %al,(%eax)
     707:	00 37                	add    %dh,(%edi)
     709:	01 00                	add    %eax,(%eax)
     70b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     711:	00 00                	add    %al,(%eax)
     713:	00 5d 01             	add    %bl,0x1(%ebp)
     716:	00 00                	add    %al,(%eax)
     718:	80 00 00             	addb   $0x0,(%eax)
     71b:	00 00                	add    %al,(%eax)
     71d:	00 00                	add    %al,(%eax)
     71f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     725:	00 00                	add    %al,(%eax)
     727:	00 00                	add    %al,(%eax)
     729:	00 00                	add    %al,(%eax)
     72b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     731:	00 00                	add    %al,(%eax)
     733:	00 00                	add    %al,(%eax)
     735:	00 00                	add    %al,(%eax)
     737:	00 d2                	add    %dl,%dl
     739:	01 00                	add    %eax,(%eax)
     73b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     741:	00 00                	add    %al,(%eax)
     743:	00 ec                	add    %ch,%ah
     745:	01 00                	add    %eax,(%eax)
     747:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     74d:	00 00                	add    %al,(%eax)
     74f:	00 07                	add    %al,(%edi)
     751:	02 00                	add    (%eax),%al
     753:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     759:	00 00                	add    %al,(%eax)
     75b:	00 28                	add    %ch,(%eax)
     75d:	02 00                	add    (%eax),%al
     75f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     765:	00 00                	add    %al,(%eax)
     767:	00 47 02             	add    %al,0x2(%edi)
     76a:	00 00                	add    %al,(%eax)
     76c:	80 00 00             	addb   $0x0,(%eax)
     76f:	00 00                	add    %al,(%eax)
     771:	00 00                	add    %al,(%eax)
     773:	00 66 02             	add    %ah,0x2(%esi)
     776:	00 00                	add    %al,(%eax)
     778:	80 00 00             	addb   $0x0,(%eax)
     77b:	00 00                	add    %al,(%eax)
     77d:	00 00                	add    %al,(%eax)
     77f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     785:	00 00                	add    %al,(%eax)
     787:	00 00                	add    %al,(%eax)
     789:	00 00                	add    %al,(%eax)
     78b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     791:	00 00                	add    %al,(%eax)
     793:	00 cf                	add    %cl,%bh
     795:	a8 00                	test   $0x0,%al
     797:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
     79d:	00 00                	add    %al,(%eax)
     79f:	00 00                	add    %al,(%eax)
     7a1:	00 00                	add    %al,(%eax)
     7a3:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     7a9:	00 00                	add    %al,(%eax)
     7ab:	00 37                	add    %dh,(%edi)
     7ad:	53                   	push   %ebx
     7ae:	00 00                	add    %al,(%eax)
     7b0:	11 04 00             	adc    %eax,(%eax,%eax,1)
     7b3:	00 c2                	add    %al,%dl
     7b5:	00 00                	add    %al,(%eax)
     7b7:	00 c8                	add    %cl,%al
     7b9:	3c 00                	cmp    $0x0,%al
     7bb:	00 c4                	add    %al,%ah
     7bd:	08 00                	or     %al,(%eax)
     7bf:	00 24 00             	add    %ah,(%eax,%eax,1)
     7c2:	00 00                	add    %al,(%eax)
     7c4:	5d                   	pop    %ebp
     7c5:	03 28                	add    (%eax),%ebp
     7c7:	00 d9                	add    %bl,%cl
     7c9:	08 00                	or     %al,(%eax)
     7cb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     7d1:	00 00                	add    %al,(%eax)
     7d3:	00 00                	add    %al,(%eax)
     7d5:	00 00                	add    %al,(%eax)
     7d7:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
	...
     7e3:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     7e7:	00 01                	add    %al,(%ecx)
     7e9:	00 00                	add    %al,(%eax)
     7eb:	00 00                	add    %al,(%eax)
     7ed:	00 00                	add    %al,(%eax)
     7ef:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     7f3:	00 06                	add    %al,(%esi)
     7f5:	00 00                	add    %al,(%eax)
     7f7:	00 00                	add    %al,(%eax)
     7f9:	00 00                	add    %al,(%eax)
     7fb:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     7ff:	00 08                	add    %cl,(%eax)
     801:	00 00                	add    %al,(%eax)
     803:	00 00                	add    %al,(%eax)
     805:	00 00                	add    %al,(%eax)
     807:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
     80b:	00 0b                	add    %cl,(%ebx)
     80d:	00 00                	add    %al,(%eax)
     80f:	00 00                	add    %al,(%eax)
     811:	00 00                	add    %al,(%eax)
     813:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     817:	00 0d 00 00 00 00    	add    %cl,0x0
     81d:	00 00                	add    %al,(%eax)
     81f:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
     823:	00 15 00 00 00 e6    	add    %dl,0xe6000000
     829:	08 00                	or     %al,(%eax)
     82b:	00 40 00             	add    %al,0x0(%eax)
     82e:	00 00                	add    %al,(%eax)
     830:	00 00                	add    %al,(%eax)
     832:	00 00                	add    %al,(%eax)
     834:	ef                   	out    %eax,(%dx)
     835:	08 00                	or     %al,(%eax)
     837:	00 40 00             	add    %al,0x0(%eax)
     83a:	00 00                	add    %al,(%eax)
     83c:	02 00                	add    (%eax),%al
     83e:	00 00                	add    %al,(%eax)
     840:	00 00                	add    %al,(%eax)
     842:	00 00                	add    %al,(%eax)
     844:	c0 00 00             	rolb   $0x0,(%eax)
	...
     84f:	00 e0                	add    %ah,%al
     851:	00 00                	add    %al,(%eax)
     853:	00 17                	add    %dl,(%edi)
     855:	00 00                	add    %al,(%eax)
     857:	00 fc                	add    %bh,%ah
     859:	08 00                	or     %al,(%eax)
     85b:	00 24 00             	add    %ah,(%eax,%eax,1)
     85e:	00 00                	add    %al,(%eax)
     860:	74 03                	je     865 <bootmain-0x27f79b>
     862:	28 00                	sub    %al,(%eax)
     864:	d9 08                	(bad)  (%eax)
     866:	00 00                	add    %al,(%eax)
     868:	a0 00 00 00 08       	mov    0x8000000,%al
     86d:	00 00                	add    %al,(%eax)
     86f:	00 00                	add    %al,(%eax)
     871:	00 00                	add    %al,(%eax)
     873:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
	...
     87f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     883:	00 01                	add    %al,(%ecx)
     885:	00 00                	add    %al,(%eax)
     887:	00 00                	add    %al,(%eax)
     889:	00 00                	add    %al,(%eax)
     88b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
     88f:	00 06                	add    %al,(%esi)
     891:	00 00                	add    %al,(%eax)
     893:	00 00                	add    %al,(%eax)
     895:	00 00                	add    %al,(%eax)
     897:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     89b:	00 08                	add    %cl,(%eax)
     89d:	00 00                	add    %al,(%eax)
     89f:	00 00                	add    %al,(%eax)
     8a1:	00 00                	add    %al,(%eax)
     8a3:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     8a7:	00 0a                	add    %cl,(%edx)
     8a9:	00 00                	add    %al,(%eax)
     8ab:	00 00                	add    %al,(%eax)
     8ad:	00 00                	add    %al,(%eax)
     8af:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     8b3:	00 12                	add    %dl,(%edx)
     8b5:	00 00                	add    %al,(%eax)
     8b7:	00 e6                	add    %ah,%dh
     8b9:	08 00                	or     %al,(%eax)
     8bb:	00 40 00             	add    %al,0x0(%eax)
	...
     8c6:	00 00                	add    %al,(%eax)
     8c8:	c0 00 00             	rolb   $0x0,(%eax)
	...
     8d3:	00 e0                	add    %ah,%al
     8d5:	00 00                	add    %al,(%eax)
     8d7:	00 14 00             	add    %dl,(%eax,%eax,1)
     8da:	00 00                	add    %al,(%eax)
     8dc:	11 09                	adc    %ecx,(%ecx)
     8de:	00 00                	add    %al,(%eax)
     8e0:	24 00                	and    $0x0,%al
     8e2:	00 00                	add    %al,(%eax)
     8e4:	88 03                	mov    %al,(%ebx)
     8e6:	28 00                	sub    %al,(%eax)
     8e8:	25 09 00 00 a0       	and    $0xa0000009,%eax
     8ed:	00 00                	add    %al,(%eax)
     8ef:	00 08                	add    %cl,(%eax)
     8f1:	00 00                	add    %al,(%eax)
     8f3:	00 32                	add    %dh,(%edx)
     8f5:	09 00                	or     %eax,(%eax)
     8f7:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
     8fd:	00 00                	add    %al,(%eax)
     8ff:	00 3d 09 00 00 a0    	add    %bh,0xa0000009
     905:	00 00                	add    %al,(%eax)
     907:	00 10                	add    %dl,(%eax)
     909:	00 00                	add    %al,(%eax)
     90b:	00 00                	add    %al,(%eax)
     90d:	00 00                	add    %al,(%eax)
     90f:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
	...
     91b:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     91f:	00 08                	add    %cl,(%eax)
     921:	00 00                	add    %al,(%eax)
     923:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     929:	00 00                	add    %al,(%eax)
     92b:	00 93 03 28 00 00    	add    %dl,0x2803(%ebx)
     931:	00 00                	add    %al,(%eax)
     933:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
     937:	01 0b                	add    %ecx,(%ebx)
     939:	00 00                	add    %al,(%eax)
     93b:	00 00                	add    %al,(%eax)
     93d:	00 00                	add    %al,(%eax)
     93f:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
     943:	00 0d 00 00 00 00    	add    %cl,0x0
     949:	00 00                	add    %al,(%eax)
     94b:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     94f:	00 0e                	add    %cl,(%esi)
     951:	00 00                	add    %al,(%eax)
     953:	00 bb 08 00 00 84    	add    %bh,-0x7bfffff8(%ebx)
     959:	00 00                	add    %al,(%eax)
     95b:	00 9b 03 28 00 00    	add    %bl,0x2803(%ebx)
     961:	00 00                	add    %al,(%eax)
     963:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
     967:	00 13                	add    %dl,(%ebx)
     969:	00 00                	add    %al,(%eax)
     96b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     971:	00 00                	add    %al,(%eax)
     973:	00 9e 03 28 00 00    	add    %bl,0x2803(%esi)
     979:	00 00                	add    %al,(%eax)
     97b:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     97f:	00 16                	add    %dl,(%esi)
     981:	00 00                	add    %al,(%eax)
     983:	00 bb 08 00 00 84    	add    %bh,-0x7bfffff8(%ebx)
     989:	00 00                	add    %al,(%eax)
     98b:	00 a1 03 28 00 00    	add    %ah,0x2803(%ecx)
     991:	00 00                	add    %al,(%eax)
     993:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     997:	00 19                	add    %bl,(%ecx)
     999:	00 00                	add    %al,(%eax)
     99b:	00 00                	add    %al,(%eax)
     99d:	00 00                	add    %al,(%eax)
     99f:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
     9a3:	00 1e                	add    %bl,(%esi)
     9a5:	00 00                	add    %al,(%eax)
     9a7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     9ad:	00 00                	add    %al,(%eax)
     9af:	00 ab 03 28 00 00    	add    %ch,0x2803(%ebx)
     9b5:	00 00                	add    %al,(%eax)
     9b7:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     9bb:	00 23                	add    %ah,(%ebx)
     9bd:	00 00                	add    %al,(%eax)
     9bf:	00 bb 08 00 00 84    	add    %bh,-0x7bfffff8(%ebx)
     9c5:	00 00                	add    %al,(%eax)
     9c7:	00 ac 03 28 00 00 00 	add    %ch,0x28(%ebx,%eax,1)
     9ce:	00 00                	add    %al,(%eax)
     9d0:	44                   	inc    %esp
     9d1:	00 43 00             	add    %al,0x0(%ebx)
     9d4:	24 00                	and    $0x0,%al
     9d6:	00 00                	add    %al,(%eax)
     9d8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     9d9:	02 00                	add    (%eax),%al
     9db:	00 84 00 00 00 b2 03 	add    %al,0x3b20000(%eax,%eax,1)
     9e2:	28 00                	sub    %al,(%eax)
     9e4:	00 00                	add    %al,(%eax)
     9e6:	00 00                	add    %al,(%eax)
     9e8:	44                   	inc    %esp
     9e9:	00 6c 00 2a          	add    %ch,0x2a(%eax,%eax,1)
     9ed:	00 00                	add    %al,(%eax)
     9ef:	00 bb 08 00 00 84    	add    %bh,-0x7bfffff8(%ebx)
     9f5:	00 00                	add    %al,(%eax)
     9f7:	00 b3 03 28 00 00    	add    %dh,0x2803(%ebx)
     9fd:	00 00                	add    %al,(%eax)
     9ff:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     a03:	00 2b                	add    %ch,(%ebx)
     a05:	00 00                	add    %al,(%eax)
     a07:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     a0d:	00 00                	add    %al,(%eax)
     a0f:	00 b9 03 28 00 00    	add    %bh,0x2803(%ecx)
     a15:	00 00                	add    %al,(%eax)
     a17:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
     a1b:	00 31                	add    %dh,(%ecx)
     a1d:	00 00                	add    %al,(%eax)
     a1f:	00 bb 08 00 00 84    	add    %bh,-0x7bfffff8(%ebx)
     a25:	00 00                	add    %al,(%eax)
     a27:	00 ba 03 28 00 00    	add    %bh,0x2803(%edx)
     a2d:	00 00                	add    %al,(%eax)
     a2f:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
     a33:	00 32                	add    %dh,(%edx)
     a35:	00 00                	add    %al,(%eax)
     a37:	00 00                	add    %al,(%eax)
     a39:	00 00                	add    %al,(%eax)
     a3b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     a3f:	00 35 00 00 00 a6    	add    %dh,0xa6000000
     a45:	02 00                	add    (%eax),%al
     a47:	00 84 00 00 00 c0 03 	add    %al,0x3c00000(%eax,%eax,1)
     a4e:	28 00                	sub    %al,(%eax)
     a50:	00 00                	add    %al,(%eax)
     a52:	00 00                	add    %al,(%eax)
     a54:	44                   	inc    %esp
     a55:	00 43 01             	add    %al,0x1(%ebx)
     a58:	38 00                	cmp    %al,(%eax)
     a5a:	00 00                	add    %al,(%eax)
     a5c:	bb 08 00 00 84       	mov    $0x84000008,%ebx
     a61:	00 00                	add    %al,(%eax)
     a63:	00 c2                	add    %al,%dl
     a65:	03 28                	add    (%eax),%ebp
     a67:	00 00                	add    %al,(%eax)
     a69:	00 00                	add    %al,(%eax)
     a6b:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
     a6f:	00 3a                	add    %bh,(%edx)
     a71:	00 00                	add    %al,(%eax)
     a73:	00 48 09             	add    %cl,0x9(%eax)
     a76:	00 00                	add    %al,(%eax)
     a78:	40                   	inc    %eax
     a79:	00 00                	add    %al,(%eax)
     a7b:	00 03                	add    %al,(%ebx)
     a7d:	00 00                	add    %al,(%eax)
     a7f:	00 55 09             	add    %dl,0x9(%ebp)
     a82:	00 00                	add    %al,(%eax)
     a84:	40                   	inc    %eax
     a85:	00 00                	add    %al,(%eax)
     a87:	00 01                	add    %al,(%ecx)
     a89:	00 00                	add    %al,(%eax)
     a8b:	00 60 09             	add    %ah,0x9(%eax)
     a8e:	00 00                	add    %al,(%eax)
     a90:	24 00                	and    $0x0,%al
     a92:	00 00                	add    %al,(%eax)
     a94:	c6 03 28             	movb   $0x28,(%ebx)
     a97:	00 00                	add    %al,(%eax)
     a99:	00 00                	add    %al,(%eax)
     a9b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
	...
     aa7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     aab:	00 01                	add    %al,(%ecx)
     aad:	00 00                	add    %al,(%eax)
     aaf:	00 00                	add    %al,(%eax)
     ab1:	00 00                	add    %al,(%eax)
     ab3:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     ab7:	00 06                	add    %al,(%esi)
     ab9:	00 00                	add    %al,(%eax)
     abb:	00 00                	add    %al,(%eax)
     abd:	00 00                	add    %al,(%eax)
     abf:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     ac3:	00 0a                	add    %cl,(%edx)
     ac5:	00 00                	add    %al,(%eax)
     ac7:	00 00                	add    %al,(%eax)
     ac9:	00 00                	add    %al,(%eax)
     acb:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     acf:	00 0f                	add    %cl,(%edi)
     ad1:	00 00                	add    %al,(%eax)
     ad3:	00 00                	add    %al,(%eax)
     ad5:	00 00                	add    %al,(%eax)
     ad7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     adb:	00 12                	add    %dl,(%edx)
     add:	00 00                	add    %al,(%eax)
     adf:	00 00                	add    %al,(%eax)
     ae1:	00 00                	add    %al,(%eax)
     ae3:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     ae7:	00 15 00 00 00 00    	add    %dl,0x0
     aed:	00 00                	add    %al,(%eax)
     aef:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     af3:	00 1a                	add    %bl,(%edx)
     af5:	00 00                	add    %al,(%eax)
     af7:	00 00                	add    %al,(%eax)
     af9:	00 00                	add    %al,(%eax)
     afb:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
     aff:	00 2a                	add    %ch,(%edx)
     b01:	00 00                	add    %al,(%eax)
     b03:	00 75 09             	add    %dh,0x9(%ebp)
     b06:	00 00                	add    %al,(%eax)
     b08:	80 00 00             	addb   $0x0,(%eax)
     b0b:	00 d0                	add    %dl,%al
     b0d:	ff                   	(bad)  
     b0e:	ff                   	(bad)  
     b0f:	ff 00                	incl   (%eax)
     b11:	00 00                	add    %al,(%eax)
     b13:	00 c0                	add    %al,%al
	...
     b1d:	00 00                	add    %al,(%eax)
     b1f:	00 e0                	add    %ah,%al
     b21:	00 00                	add    %al,(%eax)
     b23:	00 31                	add    %dh,(%ecx)
     b25:	00 00                	add    %al,(%eax)
     b27:	00 9a 09 00 00 24    	add    %bl,0x24000009(%edx)
     b2d:	00 00                	add    %al,(%eax)
     b2f:	00 f7                	add    %dh,%bh
     b31:	03 28                	add    (%eax),%ebp
     b33:	00 ab 09 00 00 a0    	add    %ch,-0x5ffffff7(%ebx)
     b39:	00 00                	add    %al,(%eax)
     b3b:	00 08                	add    %cl,(%eax)
     b3d:	00 00                	add    %al,(%eax)
     b3f:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
     b45:	00 00                	add    %al,(%eax)
     b47:	00 0c 00             	add    %cl,(%eax,%eax,1)
     b4a:	00 00                	add    %al,(%eax)
     b4c:	d9 08                	(bad)  (%eax)
     b4e:	00 00                	add    %al,(%eax)
     b50:	a0 00 00 00 10       	mov    0x10000000,%al
     b55:	00 00                	add    %al,(%eax)
     b57:	00 c4                	add    %al,%ah
     b59:	09 00                	or     %eax,(%eax)
     b5b:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     b61:	00 00                	add    %al,(%eax)
     b63:	00 ce                	add    %cl,%dh
     b65:	09 00                	or     %eax,(%eax)
     b67:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     b6d:	00 00                	add    %al,(%eax)
     b6f:	00 d8                	add    %bl,%al
     b71:	09 00                	or     %eax,(%eax)
     b73:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
     b79:	00 00                	add    %al,(%eax)
     b7b:	00 e2                	add    %ah,%dl
     b7d:	09 00                	or     %eax,(%eax)
     b7f:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     b85:	00 00                	add    %al,(%eax)
     b87:	00 00                	add    %al,(%eax)
     b89:	00 00                	add    %al,(%eax)
     b8b:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
	...
     b97:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     b9b:	00 0a                	add    %cl,(%edx)
     b9d:	00 00                	add    %al,(%eax)
     b9f:	00 00                	add    %al,(%eax)
     ba1:	00 00                	add    %al,(%eax)
     ba3:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     ba7:	00 13                	add    %dl,(%ebx)
     ba9:	00 00                	add    %al,(%eax)
     bab:	00 00                	add    %al,(%eax)
     bad:	00 00                	add    %al,(%eax)
     baf:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     bb3:	00 18                	add    %bl,(%eax)
     bb5:	00 00                	add    %al,(%eax)
     bb7:	00 00                	add    %al,(%eax)
     bb9:	00 00                	add    %al,(%eax)
     bbb:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     bbf:	00 1b                	add    %bl,(%ebx)
     bc1:	00 00                	add    %al,(%eax)
     bc3:	00 00                	add    %al,(%eax)
     bc5:	00 00                	add    %al,(%eax)
     bc7:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     bcb:	00 20                	add    %ah,(%eax)
     bcd:	00 00                	add    %al,(%eax)
     bcf:	00 00                	add    %al,(%eax)
     bd1:	00 00                	add    %al,(%eax)
     bd3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     bd7:	00 23                	add    %ah,(%ebx)
     bd9:	00 00                	add    %al,(%eax)
     bdb:	00 00                	add    %al,(%eax)
     bdd:	00 00                	add    %al,(%eax)
     bdf:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     be3:	00 26                	add    %ah,(%esi)
     be5:	00 00                	add    %al,(%eax)
     be7:	00 00                	add    %al,(%eax)
     be9:	00 00                	add    %al,(%eax)
     beb:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
     bef:	00 2c 00             	add    %ch,(%eax,%eax,1)
     bf2:	00 00                	add    %al,(%eax)
     bf4:	ec                   	in     (%dx),%al
     bf5:	09 00                	or     %eax,(%eax)
     bf7:	00 40 00             	add    %al,0x0(%eax)
     bfa:	00 00                	add    %al,(%eax)
     bfc:	03 00                	add    (%eax),%eax
     bfe:	00 00                	add    %al,(%eax)
     c00:	fa                   	cli    
     c01:	09 00                	or     %eax,(%eax)
     c03:	00 40 00             	add    %al,0x0(%eax)
     c06:	00 00                	add    %al,(%eax)
     c08:	01 00                	add    %eax,(%eax)
     c0a:	00 00                	add    %al,(%eax)
     c0c:	04 0a                	add    $0xa,%al
     c0e:	00 00                	add    %al,(%eax)
     c10:	24 00                	and    $0x0,%al
     c12:	00 00                	add    %al,(%eax)
     c14:	26                   	es
     c15:	04 28                	add    $0x28,%al
     c17:	00 d9                	add    %bl,%cl
     c19:	08 00                	or     %al,(%eax)
     c1b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     c21:	00 00                	add    %al,(%eax)
     c23:	00 c4                	add    %al,%ah
     c25:	09 00                	or     %eax,(%eax)
     c27:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
     c2d:	00 00                	add    %al,(%eax)
     c2f:	00 ce                	add    %cl,%dh
     c31:	09 00                	or     %eax,(%eax)
     c33:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     c39:	00 00                	add    %al,(%eax)
     c3b:	00 d8                	add    %bl,%al
     c3d:	09 00                	or     %eax,(%eax)
     c3f:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     c45:	00 00                	add    %al,(%eax)
     c47:	00 e2                	add    %ah,%dl
     c49:	09 00                	or     %eax,(%eax)
     c4b:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     c51:	00 00                	add    %al,(%eax)
     c53:	00 00                	add    %al,(%eax)
     c55:	00 00                	add    %al,(%eax)
     c57:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
     c63:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     c67:	00 03                	add    %al,(%ebx)
     c69:	00 00                	add    %al,(%eax)
     c6b:	00 00                	add    %al,(%eax)
     c6d:	00 00                	add    %al,(%eax)
     c6f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     c73:	00 26                	add    %ah,(%esi)
     c75:	00 00                	add    %al,(%eax)
     c77:	00 14 0a             	add    %dl,(%edx,%ecx,1)
     c7a:	00 00                	add    %al,(%eax)
     c7c:	24 00                	and    $0x0,%al
     c7e:	00 00                	add    %al,(%eax)
     c80:	4e                   	dec    %esi
     c81:	04 28                	add    $0x28,%al
     c83:	00 00                	add    %al,(%eax)
     c85:	00 00                	add    %al,(%eax)
     c87:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
	...
     c93:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
     c97:	00 03                	add    %al,(%ebx)
     c99:	00 00                	add    %al,(%eax)
     c9b:	00 00                	add    %al,(%eax)
     c9d:	00 00                	add    %al,(%eax)
     c9f:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
     ca3:	00 18                	add    %bl,(%eax)
     ca5:	00 00                	add    %al,(%eax)
     ca7:	00 00                	add    %al,(%eax)
     ca9:	00 00                	add    %al,(%eax)
     cab:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
     caf:	00 30                	add    %dh,(%eax)
     cb1:	00 00                	add    %al,(%eax)
     cb3:	00 00                	add    %al,(%eax)
     cb5:	00 00                	add    %al,(%eax)
     cb7:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
     cbb:	00 4b 00             	add    %cl,0x0(%ebx)
     cbe:	00 00                	add    %al,(%eax)
     cc0:	00 00                	add    %al,(%eax)
     cc2:	00 00                	add    %al,(%eax)
     cc4:	44                   	inc    %esp
     cc5:	00 6e 00             	add    %ch,0x0(%esi)
     cc8:	63 00                	arpl   %ax,(%eax)
     cca:	00 00                	add    %al,(%eax)
     ccc:	00 00                	add    %al,(%eax)
     cce:	00 00                	add    %al,(%eax)
     cd0:	44                   	inc    %esp
     cd1:	00 6f 00             	add    %ch,0x0(%edi)
     cd4:	7b 00                	jnp    cd6 <bootmain-0x27f32a>
     cd6:	00 00                	add    %al,(%eax)
     cd8:	00 00                	add    %al,(%eax)
     cda:	00 00                	add    %al,(%eax)
     cdc:	44                   	inc    %esp
     cdd:	00 70 00             	add    %dh,0x0(%eax)
     ce0:	90                   	nop
     ce1:	00 00                	add    %al,(%eax)
     ce3:	00 00                	add    %al,(%eax)
     ce5:	00 00                	add    %al,(%eax)
     ce7:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     ceb:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
     cf1:	00 00                	add    %al,(%eax)
     cf3:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     cf7:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     cfd:	00 00                	add    %al,(%eax)
     cff:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     d03:	00 d5                	add    %dl,%ch
     d05:	00 00                	add    %al,(%eax)
     d07:	00 00                	add    %al,(%eax)
     d09:	00 00                	add    %al,(%eax)
     d0b:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
     d0f:	00 ea                	add    %ch,%dl
     d11:	00 00                	add    %al,(%eax)
     d13:	00 00                	add    %al,(%eax)
     d15:	00 00                	add    %al,(%eax)
     d17:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     d1b:	00 08                	add    %cl,(%eax)
     d1d:	01 00                	add    %eax,(%eax)
     d1f:	00 00                	add    %al,(%eax)
     d21:	00 00                	add    %al,(%eax)
     d23:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
     d27:	00 23                	add    %ah,(%ebx)
     d29:	01 00                	add    %eax,(%eax)
     d2b:	00 00                	add    %al,(%eax)
     d2d:	00 00                	add    %al,(%eax)
     d2f:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
     d33:	00 41 01             	add    %al,0x1(%ecx)
     d36:	00 00                	add    %al,(%eax)
     d38:	00 00                	add    %al,(%eax)
     d3a:	00 00                	add    %al,(%eax)
     d3c:	44                   	inc    %esp
     d3d:	00 7b 00             	add    %bh,0x0(%ebx)
     d40:	5f                   	pop    %edi
     d41:	01 00                	add    %eax,(%eax)
     d43:	00 28                	add    %ch,(%eax)
     d45:	0a 00                	or     (%eax),%al
     d47:	00 24 00             	add    %ah,(%eax,%eax,1)
     d4a:	00 00                	add    %al,(%eax)
     d4c:	af                   	scas   %es:(%edi),%eax
     d4d:	05 28 00 3c 0a       	add    $0xa3c0028,%eax
     d52:	00 00                	add    %al,(%eax)
     d54:	a0 00 00 00 08       	mov    0x8000000,%al
     d59:	00 00                	add    %al,(%eax)
     d5b:	00 00                	add    %al,(%eax)
     d5d:	00 00                	add    %al,(%eax)
     d5f:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
	...
     d6b:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     d6f:	00 03                	add    %al,(%ebx)
     d71:	00 00                	add    %al,(%eax)
     d73:	00 00                	add    %al,(%eax)
     d75:	00 00                	add    %al,(%eax)
     d77:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
     d7b:	00 06                	add    %al,(%esi)
     d7d:	00 00                	add    %al,(%eax)
     d7f:	00 00                	add    %al,(%eax)
     d81:	00 00                	add    %al,(%eax)
     d83:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
     d87:	00 0d 00 00 00 00    	add    %cl,0x0
     d8d:	00 00                	add    %al,(%eax)
     d8f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
     d93:	00 11                	add    %dl,(%ecx)
     d95:	00 00                	add    %al,(%eax)
     d97:	00 00                	add    %al,(%eax)
     d99:	00 00                	add    %al,(%eax)
     d9b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
     d9f:	00 17                	add    %dl,(%edi)
     da1:	00 00                	add    %al,(%eax)
     da3:	00 00                	add    %al,(%eax)
     da5:	00 00                	add    %al,(%eax)
     da7:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
     dab:	00 1d 00 00 00 51    	add    %bl,0x51000000
     db1:	0a 00                	or     (%eax),%al
     db3:	00 40 00             	add    %al,0x0(%eax)
     db6:	00 00                	add    %al,(%eax)
     db8:	00 00                	add    %al,(%eax)
     dba:	00 00                	add    %al,(%eax)
     dbc:	5f                   	pop    %edi
     dbd:	0a 00                	or     (%eax),%al
     dbf:	00 24 00             	add    %ah,(%eax,%eax,1)
     dc2:	00 00                	add    %al,(%eax)
     dc4:	ce                   	into   
     dc5:	05 28 00 72 0a       	add    $0xa720028,%eax
     dca:	00 00                	add    %al,(%eax)
     dcc:	a0 00 00 00 08       	mov    0x8000000,%al
     dd1:	00 00                	add    %al,(%eax)
     dd3:	00 7f 0a             	add    %bh,0xa(%edi)
     dd6:	00 00                	add    %al,(%eax)
     dd8:	a0 00 00 00 0c       	mov    0xc000000,%al
     ddd:	00 00                	add    %al,(%eax)
     ddf:	00 00                	add    %al,(%eax)
     de1:	00 00                	add    %al,(%eax)
     de3:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
	...
     def:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     df3:	00 0d 00 00 00 00    	add    %cl,0x0
     df9:	00 00                	add    %al,(%eax)
     dfb:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     dff:	00 0f                	add    %cl,(%edi)
     e01:	00 00                	add    %al,(%eax)
     e03:	00 00                	add    %al,(%eax)
     e05:	00 00                	add    %al,(%eax)
     e07:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
     e0b:	00 11                	add    %dl,(%ecx)
     e0d:	00 00                	add    %al,(%eax)
     e0f:	00 00                	add    %al,(%eax)
     e11:	00 00                	add    %al,(%eax)
     e13:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
     e17:	00 27                	add    %ah,(%edi)
     e19:	00 00                	add    %al,(%eax)
     e1b:	00 00                	add    %al,(%eax)
     e1d:	00 00                	add    %al,(%eax)
     e1f:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
     e23:	00 2d 00 00 00 00    	add    %ch,0x0
     e29:	00 00                	add    %al,(%eax)
     e2b:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
     e2f:	00 34 00             	add    %dh,(%eax,%eax,1)
     e32:	00 00                	add    %al,(%eax)
     e34:	00 00                	add    %al,(%eax)
     e36:	00 00                	add    %al,(%eax)
     e38:	44                   	inc    %esp
     e39:	00 a3 00 38 00 00    	add    %ah,0x3800(%ebx)
     e3f:	00 00                	add    %al,(%eax)
     e41:	00 00                	add    %al,(%eax)
     e43:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
     e47:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
     e4b:	00 00                	add    %al,(%eax)
     e4d:	00 00                	add    %al,(%eax)
     e4f:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
     e53:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
     e57:	00 89 0a 00 00 26    	add    %cl,0x2600000a(%ecx)
     e5d:	00 00                	add    %al,(%eax)
     e5f:	00 ac 29 28 00 bf 0a 	add    %ch,0xabf0028(%ecx,%ebp,1)
     e66:	00 00                	add    %al,(%eax)
     e68:	40                   	inc    %eax
     e69:	00 00                	add    %al,(%eax)
     e6b:	00 00                	add    %al,(%eax)
     e6d:	00 00                	add    %al,(%eax)
     e6f:	00 c8                	add    %cl,%al
     e71:	0a 00                	or     (%eax),%al
     e73:	00 40 00             	add    %al,0x0(%eax)
     e76:	00 00                	add    %al,(%eax)
     e78:	06                   	push   %es
     e79:	00 00                	add    %al,(%eax)
     e7b:	00 00                	add    %al,(%eax)
     e7d:	00 00                	add    %al,(%eax)
     e7f:	00 c0                	add    %al,%al
	...
     e89:	00 00                	add    %al,(%eax)
     e8b:	00 e0                	add    %ah,%al
     e8d:	00 00                	add    %al,(%eax)
     e8f:	00 50 00             	add    %dl,0x0(%eax)
     e92:	00 00                	add    %al,(%eax)
     e94:	d2 0a                	rorb   %cl,(%edx)
     e96:	00 00                	add    %al,(%eax)
     e98:	24 00                	and    $0x0,%al
     e9a:	00 00                	add    %al,(%eax)
     e9c:	1e                   	push   %ds
     e9d:	06                   	push   %es
     e9e:	28 00                	sub    %al,(%eax)
     ea0:	e8 0a 00 00 a0       	call   a0000eaf <mousefifo+0x9fd7dddb>
     ea5:	00 00                	add    %al,(%eax)
     ea7:	00 08                	add    %cl,(%eax)
     ea9:	00 00                	add    %al,(%eax)
     eab:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
     eb1:	00 00                	add    %al,(%eax)
     eb3:	00 0c 00             	add    %cl,(%eax,%eax,1)
     eb6:	00 00                	add    %al,(%eax)
     eb8:	f4                   	hlt    
     eb9:	0a 00                	or     (%eax),%al
     ebb:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
     ec1:	00 00                	add    %al,(%eax)
     ec3:	00 02                	add    %al,(%edx)
     ec5:	0b 00                	or     (%eax),%eax
     ec7:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     ecd:	00 00                	add    %al,(%eax)
     ecf:	00 10                	add    %dl,(%eax)
     ed1:	0b 00                	or     (%eax),%eax
     ed3:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     ed9:	00 00                	add    %al,(%eax)
     edb:	00 1b                	add    %bl,(%ebx)
     edd:	0b 00                	or     (%eax),%eax
     edf:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
     ee5:	00 00                	add    %al,(%eax)
     ee7:	00 26                	add    %ah,(%esi)
     ee9:	0b 00                	or     (%eax),%eax
     eeb:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     ef1:	00 00                	add    %al,(%eax)
     ef3:	00 31                	add    %dh,(%ecx)
     ef5:	0b 00                	or     (%eax),%eax
     ef7:	00 a0 00 00 00 24    	add    %ah,0x24000000(%eax)
     efd:	00 00                	add    %al,(%eax)
     eff:	00 00                	add    %al,(%eax)
     f01:	00 00                	add    %al,(%eax)
     f03:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
	...
     f0f:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     f13:	00 07                	add    %al,(%edi)
     f15:	00 00                	add    %al,(%eax)
     f17:	00 00                	add    %al,(%eax)
     f19:	00 00                	add    %al,(%eax)
     f1b:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
     f1f:	00 09                	add    %cl,(%ecx)
     f21:	00 00                	add    %al,(%eax)
     f23:	00 00                	add    %al,(%eax)
     f25:	00 00                	add    %al,(%eax)
     f27:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     f2b:	00 17                	add    %dl,(%edi)
     f2d:	00 00                	add    %al,(%eax)
     f2f:	00 00                	add    %al,(%eax)
     f31:	00 00                	add    %al,(%eax)
     f33:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     f37:	00 1c 00             	add    %bl,(%eax,%eax,1)
     f3a:	00 00                	add    %al,(%eax)
     f3c:	00 00                	add    %al,(%eax)
     f3e:	00 00                	add    %al,(%eax)
     f40:	44                   	inc    %esp
     f41:	00 b8 00 1e 00 00    	add    %bh,0x1e00(%eax)
     f47:	00 00                	add    %al,(%eax)
     f49:	00 00                	add    %al,(%eax)
     f4b:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
     f4f:	00 23                	add    %ah,(%ebx)
     f51:	00 00                	add    %al,(%eax)
     f53:	00 00                	add    %al,(%eax)
     f55:	00 00                	add    %al,(%eax)
     f57:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
     f5b:	00 29                	add    %ch,(%ecx)
     f5d:	00 00                	add    %al,(%eax)
     f5f:	00 00                	add    %al,(%eax)
     f61:	00 00                	add    %al,(%eax)
     f63:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     f67:	00 2c 00             	add    %ch,(%eax,%eax,1)
     f6a:	00 00                	add    %al,(%eax)
     f6c:	00 00                	add    %al,(%eax)
     f6e:	00 00                	add    %al,(%eax)
     f70:	44                   	inc    %esp
     f71:	00 be 00 35 00 00    	add    %bh,0x3500(%esi)
     f77:	00 bf 0a 00 00 40    	add    %bh,0x4000000a(%edi)
     f7d:	00 00                	add    %al,(%eax)
     f7f:	00 02                	add    %al,(%edx)
     f81:	00 00                	add    %al,(%eax)
     f83:	00 3f                	add    %bh,(%edi)
     f85:	0b 00                	or     (%eax),%eax
     f87:	00 40 00             	add    %al,0x0(%eax)
     f8a:	00 00                	add    %al,(%eax)
     f8c:	06                   	push   %es
     f8d:	00 00                	add    %al,(%eax)
     f8f:	00 00                	add    %al,(%eax)
     f91:	00 00                	add    %al,(%eax)
     f93:	00 c0                	add    %al,%al
	...
     f9d:	00 00                	add    %al,(%eax)
     f9f:	00 e0                	add    %ah,%al
     fa1:	00 00                	add    %al,(%eax)
     fa3:	00 39                	add    %bh,(%ecx)
     fa5:	00 00                	add    %al,(%eax)
     fa7:	00 00                	add    %al,(%eax)
     fa9:	00 00                	add    %al,(%eax)
     fab:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
     faf:	00 57 06             	add    %dl,0x6(%edi)
     fb2:	28 00                	sub    %al,(%eax)
     fb4:	48                   	dec    %eax
     fb5:	0b 00                	or     (%eax),%eax
     fb7:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
     fbb:	00 57 06             	add    %dl,0x6(%edi)
     fbe:	28 00                	sub    %al,(%eax)
     fc0:	08 00                	or     %al,(%eax)
     fc2:	00 00                	add    %al,(%eax)
     fc4:	3c 00                	cmp    $0x0,%al
     fc6:	00 00                	add    %al,(%eax)
     fc8:	00 00                	add    %al,(%eax)
     fca:	00 00                	add    %al,(%eax)
     fcc:	17                   	pop    %ss
     fcd:	00 00                	add    %al,(%eax)
     fcf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     fd5:	00 00                	add    %al,(%eax)
     fd7:	00 41 00             	add    %al,0x0(%ecx)
     fda:	00 00                	add    %al,(%eax)
     fdc:	80 00 00             	addb   $0x0,(%eax)
     fdf:	00 00                	add    %al,(%eax)
     fe1:	00 00                	add    %al,(%eax)
     fe3:	00 5b 00             	add    %bl,0x0(%ebx)
     fe6:	00 00                	add    %al,(%eax)
     fe8:	80 00 00             	addb   $0x0,(%eax)
     feb:	00 00                	add    %al,(%eax)
     fed:	00 00                	add    %al,(%eax)
     fef:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     ff5:	00 00                	add    %al,(%eax)
     ff7:	00 00                	add    %al,(%eax)
     ff9:	00 00                	add    %al,(%eax)
     ffb:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1001:	00 00                	add    %al,(%eax)
    1003:	00 00                	add    %al,(%eax)
    1005:	00 00                	add    %al,(%eax)
    1007:	00 e1                	add    %ah,%cl
    1009:	00 00                	add    %al,(%eax)
    100b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1011:	00 00                	add    %al,(%eax)
    1013:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1016:	00 00                	add    %al,(%eax)
    1018:	80 00 00             	addb   $0x0,(%eax)
    101b:	00 00                	add    %al,(%eax)
    101d:	00 00                	add    %al,(%eax)
    101f:	00 37                	add    %dh,(%edi)
    1021:	01 00                	add    %eax,(%eax)
    1023:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1029:	00 00                	add    %al,(%eax)
    102b:	00 5d 01             	add    %bl,0x1(%ebp)
    102e:	00 00                	add    %al,(%eax)
    1030:	80 00 00             	addb   $0x0,(%eax)
    1033:	00 00                	add    %al,(%eax)
    1035:	00 00                	add    %al,(%eax)
    1037:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    103d:	00 00                	add    %al,(%eax)
    103f:	00 00                	add    %al,(%eax)
    1041:	00 00                	add    %al,(%eax)
    1043:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1049:	00 00                	add    %al,(%eax)
    104b:	00 00                	add    %al,(%eax)
    104d:	00 00                	add    %al,(%eax)
    104f:	00 d2                	add    %dl,%dl
    1051:	01 00                	add    %eax,(%eax)
    1053:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1059:	00 00                	add    %al,(%eax)
    105b:	00 ec                	add    %ch,%ah
    105d:	01 00                	add    %eax,(%eax)
    105f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1065:	00 00                	add    %al,(%eax)
    1067:	00 07                	add    %al,(%edi)
    1069:	02 00                	add    (%eax),%al
    106b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1071:	00 00                	add    %al,(%eax)
    1073:	00 28                	add    %ch,(%eax)
    1075:	02 00                	add    (%eax),%al
    1077:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    107d:	00 00                	add    %al,(%eax)
    107f:	00 47 02             	add    %al,0x2(%edi)
    1082:	00 00                	add    %al,(%eax)
    1084:	80 00 00             	addb   $0x0,(%eax)
    1087:	00 00                	add    %al,(%eax)
    1089:	00 00                	add    %al,(%eax)
    108b:	00 66 02             	add    %ah,0x2(%esi)
    108e:	00 00                	add    %al,(%eax)
    1090:	80 00 00             	addb   $0x0,(%eax)
    1093:	00 00                	add    %al,(%eax)
    1095:	00 00                	add    %al,(%eax)
    1097:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    109d:	00 00                	add    %al,(%eax)
    109f:	00 00                	add    %al,(%eax)
    10a1:	00 00                	add    %al,(%eax)
    10a3:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    10a9:	00 00                	add    %al,(%eax)
    10ab:	00 cf                	add    %cl,%bh
    10ad:	a8 00                	test   $0x0,%al
    10af:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    10b5:	00 00                	add    %al,(%eax)
    10b7:	00 00                	add    %al,(%eax)
    10b9:	00 00                	add    %al,(%eax)
    10bb:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    10c1:	00 00                	add    %al,(%eax)
    10c3:	00 37                	add    %dh,(%edi)
    10c5:	53                   	push   %ebx
    10c6:	00 00                	add    %al,(%eax)
    10c8:	11 04 00             	adc    %eax,(%eax,%eax,1)
    10cb:	00 c2                	add    %al,%dl
    10cd:	00 00                	add    %al,(%eax)
    10cf:	00 c8                	add    %cl,%al
    10d1:	3c 00                	cmp    $0x0,%al
    10d3:	00 00                	add    %al,(%eax)
    10d5:	00 00                	add    %al,(%eax)
    10d7:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    10db:	00 57 06             	add    %dl,0x6(%edi)
    10de:	28 00                	sub    %al,(%eax)
    10e0:	4f                   	dec    %edi
    10e1:	0b 00                	or     (%eax),%eax
    10e3:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    10e7:	00 57 06             	add    %dl,0x6(%edi)
    10ea:	28 00                	sub    %al,(%eax)
    10ec:	08 00                	or     %al,(%eax)
    10ee:	00 00                	add    %al,(%eax)
    10f0:	3c 00                	cmp    $0x0,%al
    10f2:	00 00                	add    %al,(%eax)
    10f4:	00 00                	add    %al,(%eax)
    10f6:	00 00                	add    %al,(%eax)
    10f8:	17                   	pop    %ss
    10f9:	00 00                	add    %al,(%eax)
    10fb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1101:	00 00                	add    %al,(%eax)
    1103:	00 41 00             	add    %al,0x0(%ecx)
    1106:	00 00                	add    %al,(%eax)
    1108:	80 00 00             	addb   $0x0,(%eax)
    110b:	00 00                	add    %al,(%eax)
    110d:	00 00                	add    %al,(%eax)
    110f:	00 5b 00             	add    %bl,0x0(%ebx)
    1112:	00 00                	add    %al,(%eax)
    1114:	80 00 00             	addb   $0x0,(%eax)
    1117:	00 00                	add    %al,(%eax)
    1119:	00 00                	add    %al,(%eax)
    111b:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1121:	00 00                	add    %al,(%eax)
    1123:	00 00                	add    %al,(%eax)
    1125:	00 00                	add    %al,(%eax)
    1127:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    112d:	00 00                	add    %al,(%eax)
    112f:	00 00                	add    %al,(%eax)
    1131:	00 00                	add    %al,(%eax)
    1133:	00 e1                	add    %ah,%cl
    1135:	00 00                	add    %al,(%eax)
    1137:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    113d:	00 00                	add    %al,(%eax)
    113f:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1142:	00 00                	add    %al,(%eax)
    1144:	80 00 00             	addb   $0x0,(%eax)
    1147:	00 00                	add    %al,(%eax)
    1149:	00 00                	add    %al,(%eax)
    114b:	00 37                	add    %dh,(%edi)
    114d:	01 00                	add    %eax,(%eax)
    114f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1155:	00 00                	add    %al,(%eax)
    1157:	00 5d 01             	add    %bl,0x1(%ebp)
    115a:	00 00                	add    %al,(%eax)
    115c:	80 00 00             	addb   $0x0,(%eax)
    115f:	00 00                	add    %al,(%eax)
    1161:	00 00                	add    %al,(%eax)
    1163:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1169:	00 00                	add    %al,(%eax)
    116b:	00 00                	add    %al,(%eax)
    116d:	00 00                	add    %al,(%eax)
    116f:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1175:	00 00                	add    %al,(%eax)
    1177:	00 00                	add    %al,(%eax)
    1179:	00 00                	add    %al,(%eax)
    117b:	00 d2                	add    %dl,%dl
    117d:	01 00                	add    %eax,(%eax)
    117f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1185:	00 00                	add    %al,(%eax)
    1187:	00 ec                	add    %ch,%ah
    1189:	01 00                	add    %eax,(%eax)
    118b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1191:	00 00                	add    %al,(%eax)
    1193:	00 07                	add    %al,(%edi)
    1195:	02 00                	add    (%eax),%al
    1197:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    119d:	00 00                	add    %al,(%eax)
    119f:	00 28                	add    %ch,(%eax)
    11a1:	02 00                	add    (%eax),%al
    11a3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    11a9:	00 00                	add    %al,(%eax)
    11ab:	00 47 02             	add    %al,0x2(%edi)
    11ae:	00 00                	add    %al,(%eax)
    11b0:	80 00 00             	addb   $0x0,(%eax)
    11b3:	00 00                	add    %al,(%eax)
    11b5:	00 00                	add    %al,(%eax)
    11b7:	00 66 02             	add    %ah,0x2(%esi)
    11ba:	00 00                	add    %al,(%eax)
    11bc:	80 00 00             	addb   $0x0,(%eax)
    11bf:	00 00                	add    %al,(%eax)
    11c1:	00 00                	add    %al,(%eax)
    11c3:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    11c9:	00 00                	add    %al,(%eax)
    11cb:	00 00                	add    %al,(%eax)
    11cd:	00 00                	add    %al,(%eax)
    11cf:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    11d5:	00 00                	add    %al,(%eax)
    11d7:	00 cf                	add    %cl,%bh
    11d9:	a8 00                	test   $0x0,%al
    11db:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    11e1:	00 00                	add    %al,(%eax)
    11e3:	00 00                	add    %al,(%eax)
    11e5:	00 00                	add    %al,(%eax)
    11e7:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    11ed:	00 00                	add    %al,(%eax)
    11ef:	00 37                	add    %dh,(%edi)
    11f1:	53                   	push   %ebx
    11f2:	00 00                	add    %al,(%eax)
    11f4:	11 04 00             	adc    %eax,(%eax,%eax,1)
    11f7:	00 c2                	add    %al,%dl
    11f9:	00 00                	add    %al,(%eax)
    11fb:	00 c8                	add    %cl,%al
    11fd:	3c 00                	cmp    $0x0,%al
    11ff:	00 57 0b             	add    %dl,0xb(%edi)
    1202:	00 00                	add    %al,(%eax)
    1204:	24 00                	and    $0x0,%al
    1206:	00 00                	add    %al,(%eax)
    1208:	57                   	push   %edi
    1209:	06                   	push   %es
    120a:	28 00                	sub    %al,(%eax)
    120c:	64 0b 00             	or     %fs:(%eax),%eax
    120f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1215:	00 00                	add    %al,(%eax)
    1217:	00 26                	add    %ah,(%esi)
    1219:	0b 00                	or     (%eax),%eax
    121b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1221:	00 00                	add    %al,(%eax)
    1223:	00 00                	add    %al,(%eax)
    1225:	00 00                	add    %al,(%eax)
    1227:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
	...
    1233:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1237:	00 01                	add    %al,(%ecx)
    1239:	00 00                	add    %al,(%eax)
    123b:	00 00                	add    %al,(%eax)
    123d:	00 00                	add    %al,(%eax)
    123f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1243:	00 03                	add    %al,(%ebx)
    1245:	00 00                	add    %al,(%eax)
    1247:	00 00                	add    %al,(%eax)
    1249:	00 00                	add    %al,(%eax)
    124b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    124f:	00 05 00 00 00 00    	add    %al,0x0
    1255:	00 00                	add    %al,(%eax)
    1257:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    125b:	00 0a                	add    %cl,(%edx)
    125d:	00 00                	add    %al,(%eax)
    125f:	00 00                	add    %al,(%eax)
    1261:	00 00                	add    %al,(%eax)
    1263:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1267:	00 10                	add    %dl,(%eax)
    1269:	00 00                	add    %al,(%eax)
    126b:	00 00                	add    %al,(%eax)
    126d:	00 00                	add    %al,(%eax)
    126f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1273:	00 13                	add    %dl,(%ebx)
    1275:	00 00                	add    %al,(%eax)
    1277:	00 00                	add    %al,(%eax)
    1279:	00 00                	add    %al,(%eax)
    127b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    127f:	00 16                	add    %dl,(%esi)
    1281:	00 00                	add    %al,(%eax)
    1283:	00 00                	add    %al,(%eax)
    1285:	00 00                	add    %al,(%eax)
    1287:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    128b:	00 19                	add    %bl,(%ecx)
    128d:	00 00                	add    %al,(%eax)
    128f:	00 00                	add    %al,(%eax)
    1291:	00 00                	add    %al,(%eax)
    1293:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    1297:	00 1e                	add    %bl,(%esi)
    1299:	00 00                	add    %al,(%eax)
    129b:	00 00                	add    %al,(%eax)
    129d:	00 00                	add    %al,(%eax)
    129f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    12a3:	00 22                	add    %ah,(%edx)
    12a5:	00 00                	add    %al,(%eax)
    12a7:	00 00                	add    %al,(%eax)
    12a9:	00 00                	add    %al,(%eax)
    12ab:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    12af:	00 25 00 00 00 00    	add    %ah,0x0
    12b5:	00 00                	add    %al,(%eax)
    12b7:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    12bb:	00 27                	add    %ah,(%edi)
    12bd:	00 00                	add    %al,(%eax)
    12bf:	00 00                	add    %al,(%eax)
    12c1:	00 00                	add    %al,(%eax)
    12c3:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    12c7:	00 28                	add    %ch,(%eax)
    12c9:	00 00                	add    %al,(%eax)
    12cb:	00 00                	add    %al,(%eax)
    12cd:	00 00                	add    %al,(%eax)
    12cf:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    12d3:	00 2a                	add    %ch,(%edx)
    12d5:	00 00                	add    %al,(%eax)
    12d7:	00 00                	add    %al,(%eax)
    12d9:	00 00                	add    %al,(%eax)
    12db:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    12df:	00 38                	add    %bh,(%eax)
    12e1:	00 00                	add    %al,(%eax)
    12e3:	00 00                	add    %al,(%eax)
    12e5:	00 00                	add    %al,(%eax)
    12e7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    12eb:	00 3a                	add    %bh,(%edx)
    12ed:	00 00                	add    %al,(%eax)
    12ef:	00 00                	add    %al,(%eax)
    12f1:	00 00                	add    %al,(%eax)
    12f3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    12f7:	00 3d 00 00 00 00    	add    %bh,0x0
    12fd:	00 00                	add    %al,(%eax)
    12ff:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    1303:	00 3f                	add    %bh,(%edi)
    1305:	00 00                	add    %al,(%eax)
    1307:	00 00                	add    %al,(%eax)
    1309:	00 00                	add    %al,(%eax)
    130b:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    130f:	00 41 00             	add    %al,0x0(%ecx)
    1312:	00 00                	add    %al,(%eax)
    1314:	00 00                	add    %al,(%eax)
    1316:	00 00                	add    %al,(%eax)
    1318:	44                   	inc    %esp
    1319:	00 1e                	add    %bl,(%esi)
    131b:	00 45 00             	add    %al,0x0(%ebp)
    131e:	00 00                	add    %al,(%eax)
    1320:	00 00                	add    %al,(%eax)
    1322:	00 00                	add    %al,(%eax)
    1324:	44                   	inc    %esp
    1325:	00 20                	add    %ah,(%eax)
    1327:	00 49 00             	add    %cl,0x0(%ecx)
    132a:	00 00                	add    %al,(%eax)
    132c:	00 00                	add    %al,(%eax)
    132e:	00 00                	add    %al,(%eax)
    1330:	44                   	inc    %esp
    1331:	00 21                	add    %ah,(%ecx)
    1333:	00 4a 00             	add    %cl,0x0(%edx)
    1336:	00 00                	add    %al,(%eax)
    1338:	00 00                	add    %al,(%eax)
    133a:	00 00                	add    %al,(%eax)
    133c:	44                   	inc    %esp
    133d:	00 24 00             	add    %ah,(%eax,%eax,1)
    1340:	56                   	push   %esi
    1341:	00 00                	add    %al,(%eax)
    1343:	00 00                	add    %al,(%eax)
    1345:	00 00                	add    %al,(%eax)
    1347:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    134b:	00 5a 00             	add    %bl,0x0(%edx)
    134e:	00 00                	add    %al,(%eax)
    1350:	71 0b                	jno    135d <bootmain-0x27eca3>
    1352:	00 00                	add    %al,(%eax)
    1354:	80 00 00             	addb   $0x0,(%eax)
    1357:	00 f6                	add    %dh,%dh
    1359:	ff                   	(bad)  
    135a:	ff                   	(bad)  
    135b:	ff 92 0b 00 00 40    	call   *0x4000000b(%edx)
    1361:	00 00                	add    %al,(%eax)
    1363:	00 02                	add    %al,(%edx)
    1365:	00 00                	add    %al,(%eax)
    1367:	00 9f 0b 00 00 40    	add    %bl,0x4000000b(%edi)
    136d:	00 00                	add    %al,(%eax)
    136f:	00 03                	add    %al,(%ebx)
    1371:	00 00                	add    %al,(%eax)
    1373:	00 00                	add    %al,(%eax)
    1375:	00 00                	add    %al,(%eax)
    1377:	00 c0                	add    %al,%al
	...
    1381:	00 00                	add    %al,(%eax)
    1383:	00 e0                	add    %ah,%al
    1385:	00 00                	add    %al,(%eax)
    1387:	00 62 00             	add    %ah,0x0(%edx)
    138a:	00 00                	add    %al,(%eax)
    138c:	aa                   	stos   %al,%es:(%edi)
    138d:	0b 00                	or     (%eax),%eax
    138f:	00 24 00             	add    %ah,(%eax,%eax,1)
    1392:	00 00                	add    %al,(%eax)
    1394:	b9 06 28 00 b7       	mov    $0xb7002806,%ecx
    1399:	0b 00                	or     (%eax),%eax
    139b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    13a1:	00 00                	add    %al,(%eax)
    13a3:	00 26                	add    %ah,(%esi)
    13a5:	0b 00                	or     (%eax),%eax
    13a7:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    13ad:	00 00                	add    %al,(%eax)
    13af:	00 00                	add    %al,(%eax)
    13b1:	00 00                	add    %al,(%eax)
    13b3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
	...
    13bf:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    13c3:	00 01                	add    %al,(%ecx)
    13c5:	00 00                	add    %al,(%eax)
    13c7:	00 00                	add    %al,(%eax)
    13c9:	00 00                	add    %al,(%eax)
    13cb:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    13cf:	00 03                	add    %al,(%ebx)
    13d1:	00 00                	add    %al,(%eax)
    13d3:	00 00                	add    %al,(%eax)
    13d5:	00 00                	add    %al,(%eax)
    13d7:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    13db:	00 05 00 00 00 00    	add    %al,0x0
    13e1:	00 00                	add    %al,(%eax)
    13e3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    13e7:	00 0a                	add    %cl,(%edx)
    13e9:	00 00                	add    %al,(%eax)
    13eb:	00 00                	add    %al,(%eax)
    13ed:	00 00                	add    %al,(%eax)
    13ef:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    13f3:	00 10                	add    %dl,(%eax)
    13f5:	00 00                	add    %al,(%eax)
    13f7:	00 00                	add    %al,(%eax)
    13f9:	00 00                	add    %al,(%eax)
    13fb:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    13ff:	00 13                	add    %dl,(%ebx)
    1401:	00 00                	add    %al,(%eax)
    1403:	00 00                	add    %al,(%eax)
    1405:	00 00                	add    %al,(%eax)
    1407:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    140b:	00 18                	add    %bl,(%eax)
    140d:	00 00                	add    %al,(%eax)
    140f:	00 00                	add    %al,(%eax)
    1411:	00 00                	add    %al,(%eax)
    1413:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    1417:	00 1b                	add    %bl,(%ebx)
    1419:	00 00                	add    %al,(%eax)
    141b:	00 00                	add    %al,(%eax)
    141d:	00 00                	add    %al,(%eax)
    141f:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    1423:	00 1e                	add    %bl,(%esi)
    1425:	00 00                	add    %al,(%eax)
    1427:	00 00                	add    %al,(%eax)
    1429:	00 00                	add    %al,(%eax)
    142b:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    142f:	00 25 00 00 00 00    	add    %ah,0x0
    1435:	00 00                	add    %al,(%eax)
    1437:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    143b:	00 2c 00             	add    %ch,(%eax,%eax,1)
    143e:	00 00                	add    %al,(%eax)
    1440:	00 00                	add    %al,(%eax)
    1442:	00 00                	add    %al,(%eax)
    1444:	44                   	inc    %esp
    1445:	00 3e                	add    %bh,(%esi)
    1447:	00 38                	add    %bh,(%eax)
    1449:	00 00                	add    %al,(%eax)
    144b:	00 00                	add    %al,(%eax)
    144d:	00 00                	add    %al,(%eax)
    144f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    1453:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1456:	00 00                	add    %al,(%eax)
    1458:	00 00                	add    %al,(%eax)
    145a:	00 00                	add    %al,(%eax)
    145c:	44                   	inc    %esp
    145d:	00 3e                	add    %bh,(%esi)
    145f:	00 3f                	add    %bh,(%edi)
    1461:	00 00                	add    %al,(%eax)
    1463:	00 00                	add    %al,(%eax)
    1465:	00 00                	add    %al,(%eax)
    1467:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    146b:	00 41 00             	add    %al,0x0(%ecx)
    146e:	00 00                	add    %al,(%eax)
    1470:	00 00                	add    %al,(%eax)
    1472:	00 00                	add    %al,(%eax)
    1474:	44                   	inc    %esp
    1475:	00 41 00             	add    %al,0x0(%ecx)
    1478:	43                   	inc    %ebx
    1479:	00 00                	add    %al,(%eax)
    147b:	00 00                	add    %al,(%eax)
    147d:	00 00                	add    %al,(%eax)
    147f:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    1483:	00 4a 00             	add    %cl,0x0(%edx)
    1486:	00 00                	add    %al,(%eax)
    1488:	00 00                	add    %al,(%eax)
    148a:	00 00                	add    %al,(%eax)
    148c:	44                   	inc    %esp
    148d:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    1491:	00 00                	add    %al,(%eax)
    1493:	00 00                	add    %al,(%eax)
    1495:	00 00                	add    %al,(%eax)
    1497:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    149b:	00 55 00             	add    %dl,0x0(%ebp)
    149e:	00 00                	add    %al,(%eax)
    14a0:	00 00                	add    %al,(%eax)
    14a2:	00 00                	add    %al,(%eax)
    14a4:	44                   	inc    %esp
    14a5:	00 4a 00             	add    %cl,0x0(%edx)
    14a8:	5a                   	pop    %edx
    14a9:	00 00                	add    %al,(%eax)
    14ab:	00 c4                	add    %al,%ah
    14ad:	0b 00                	or     (%eax),%eax
    14af:	00 80 00 00 00 e2    	add    %al,-0x1e000000(%eax)
    14b5:	ff                   	(bad)  
    14b6:	ff                   	(bad)  
    14b7:	ff 9f 0b 00 00 40    	lcall  *0x4000000b(%edi)
    14bd:	00 00                	add    %al,(%eax)
    14bf:	00 02                	add    %al,(%edx)
    14c1:	00 00                	add    %al,(%eax)
    14c3:	00 00                	add    %al,(%eax)
    14c5:	00 00                	add    %al,(%eax)
    14c7:	00 c0                	add    %al,%al
    14c9:	00 00                	add    %al,(%eax)
    14cb:	00 00                	add    %al,(%eax)
    14cd:	00 00                	add    %al,(%eax)
    14cf:	00 92 0b 00 00 40    	add    %dl,0x4000000b(%edx)
    14d5:	00 00                	add    %al,(%eax)
    14d7:	00 01                	add    %al,(%ecx)
    14d9:	00 00                	add    %al,(%eax)
    14db:	00 00                	add    %al,(%eax)
    14dd:	00 00                	add    %al,(%eax)
    14df:	00 c0                	add    %al,%al
    14e1:	00 00                	add    %al,(%eax)
    14e3:	00 2c 00             	add    %ch,(%eax,%eax,1)
    14e6:	00 00                	add    %al,(%eax)
    14e8:	00 00                	add    %al,(%eax)
    14ea:	00 00                	add    %al,(%eax)
    14ec:	e0 00                	loopne 14ee <bootmain-0x27eb12>
    14ee:	00 00                	add    %al,(%eax)
    14f0:	38 00                	cmp    %al,(%eax)
    14f2:	00 00                	add    %al,(%eax)
    14f4:	92                   	xchg   %eax,%edx
    14f5:	0b 00                	or     (%eax),%eax
    14f7:	00 40 00             	add    %al,0x0(%eax)
    14fa:	00 00                	add    %al,(%eax)
    14fc:	01 00                	add    %eax,(%eax)
    14fe:	00 00                	add    %al,(%eax)
    1500:	00 00                	add    %al,(%eax)
    1502:	00 00                	add    %al,(%eax)
    1504:	c0 00 00             	rolb   $0x0,(%eax)
    1507:	00 3c 00             	add    %bh,(%eax,%eax,1)
    150a:	00 00                	add    %al,(%eax)
    150c:	00 00                	add    %al,(%eax)
    150e:	00 00                	add    %al,(%eax)
    1510:	e0 00                	loopne 1512 <bootmain-0x27eaee>
    1512:	00 00                	add    %al,(%eax)
    1514:	3f                   	aas    
    1515:	00 00                	add    %al,(%eax)
    1517:	00 00                	add    %al,(%eax)
    1519:	00 00                	add    %al,(%eax)
    151b:	00 e0                	add    %ah,%al
    151d:	00 00                	add    %al,(%eax)
    151f:	00 62 00             	add    %ah,0x0(%edx)
    1522:	00 00                	add    %al,(%eax)
    1524:	e6 0b                	out    %al,$0xb
    1526:	00 00                	add    %al,(%eax)
    1528:	24 00                	and    $0x0,%al
    152a:	00 00                	add    %al,(%eax)
    152c:	1b 07                	sbb    (%edi),%eax
    152e:	28 00                	sub    %al,(%eax)
    1530:	f6                   	(bad)  
    1531:	0b 00                	or     (%eax),%eax
    1533:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1539:	00 00                	add    %al,(%eax)
    153b:	00 01                	add    %al,(%ecx)
    153d:	0c 00                	or     $0x0,%al
    153f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1545:	00 00                	add    %al,(%eax)
    1547:	00 00                	add    %al,(%eax)
    1549:	00 00                	add    %al,(%eax)
    154b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
	...
    1557:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    155b:	00 09                	add    %cl,(%ecx)
    155d:	00 00                	add    %al,(%eax)
    155f:	00 00                	add    %al,(%eax)
    1561:	00 00                	add    %al,(%eax)
    1563:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
    1567:	00 0c 00             	add    %cl,(%eax,%eax,1)
    156a:	00 00                	add    %al,(%eax)
    156c:	00 00                	add    %al,(%eax)
    156e:	00 00                	add    %al,(%eax)
    1570:	44                   	inc    %esp
    1571:	00 56 00             	add    %dl,0x0(%esi)
    1574:	0f 00 00             	sldt   (%eax)
    1577:	00 00                	add    %al,(%eax)
    1579:	00 00                	add    %al,(%eax)
    157b:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    157f:	00 1f                	add    %bl,(%edi)
    1581:	00 00                	add    %al,(%eax)
    1583:	00 00                	add    %al,(%eax)
    1585:	00 00                	add    %al,(%eax)
    1587:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    158b:	00 21                	add    %ah,(%ecx)
    158d:	00 00                	add    %al,(%eax)
    158f:	00 00                	add    %al,(%eax)
    1591:	00 00                	add    %al,(%eax)
    1593:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    1597:	00 24 00             	add    %ah,(%eax,%eax,1)
    159a:	00 00                	add    %al,(%eax)
    159c:	00 00                	add    %al,(%eax)
    159e:	00 00                	add    %al,(%eax)
    15a0:	44                   	inc    %esp
    15a1:	00 5a 00             	add    %bl,0x0(%edx)
    15a4:	26 00 00             	add    %al,%es:(%eax)
    15a7:	00 00                	add    %al,(%eax)
    15a9:	00 00                	add    %al,(%eax)
    15ab:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    15af:	00 29                	add    %ch,(%ecx)
    15b1:	00 00                	add    %al,(%eax)
    15b3:	00 00                	add    %al,(%eax)
    15b5:	00 00                	add    %al,(%eax)
    15b7:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    15bb:	00 2b                	add    %ch,(%ebx)
    15bd:	00 00                	add    %al,(%eax)
    15bf:	00 00                	add    %al,(%eax)
    15c1:	00 00                	add    %al,(%eax)
    15c3:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    15c7:	00 3a                	add    %bh,(%edx)
    15c9:	00 00                	add    %al,(%eax)
    15cb:	00 00                	add    %al,(%eax)
    15cd:	00 00                	add    %al,(%eax)
    15cf:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    15d3:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    15d7:	00 00                	add    %al,(%eax)
    15d9:	00 00                	add    %al,(%eax)
    15db:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    15df:	00 52 00             	add    %dl,0x0(%edx)
    15e2:	00 00                	add    %al,(%eax)
    15e4:	00 00                	add    %al,(%eax)
    15e6:	00 00                	add    %al,(%eax)
    15e8:	44                   	inc    %esp
    15e9:	00 63 00             	add    %ah,0x0(%ebx)
    15ec:	59                   	pop    %ecx
    15ed:	00 00                	add    %al,(%eax)
    15ef:	00 00                	add    %al,(%eax)
    15f1:	00 00                	add    %al,(%eax)
    15f3:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    15f7:	00 6b 00             	add    %ch,0x0(%ebx)
    15fa:	00 00                	add    %al,(%eax)
    15fc:	00 00                	add    %al,(%eax)
    15fe:	00 00                	add    %al,(%eax)
    1600:	44                   	inc    %esp
    1601:	00 63 00             	add    %ah,0x0(%ebx)
    1604:	71 00                	jno    1606 <bootmain-0x27e9fa>
    1606:	00 00                	add    %al,(%eax)
    1608:	00 00                	add    %al,(%eax)
    160a:	00 00                	add    %al,(%eax)
    160c:	44                   	inc    %esp
    160d:	00 64 00 78          	add    %ah,0x78(%eax,%eax,1)
    1611:	00 00                	add    %al,(%eax)
    1613:	00 00                	add    %al,(%eax)
    1615:	00 00                	add    %al,(%eax)
    1617:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    161b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1621:	00 00                	add    %al,(%eax)
    1623:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1627:	00 87 00 00 00 00    	add    %al,0x0(%edi)
    162d:	00 00                	add    %al,(%eax)
    162f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    1633:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
    1639:	00 00                	add    %al,(%eax)
    163b:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    163f:	00 8f 00 00 00 00    	add    %cl,0x0(%edi)
    1645:	00 00                	add    %al,(%eax)
    1647:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    164b:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
    1651:	00 00                	add    %al,(%eax)
    1653:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    1657:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
    165d:	00 00                	add    %al,(%eax)
    165f:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    1663:	00 9f 00 00 00 00    	add    %bl,0x0(%edi)
    1669:	00 00                	add    %al,(%eax)
    166b:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
    166f:	00 a2 00 00 00 0f    	add    %ah,0xf000000(%edx)
    1675:	0c 00                	or     $0x0,%al
    1677:	00 40 00             	add    %al,0x0(%eax)
    167a:	00 00                	add    %al,(%eax)
    167c:	06                   	push   %es
    167d:	00 00                	add    %al,(%eax)
    167f:	00 22                	add    %ah,(%edx)
    1681:	0c 00                	or     $0x0,%al
    1683:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
    1689:	ff                   	(bad)  
    168a:	ff                   	(bad)  
    168b:	ff 30                	pushl  (%eax)
    168d:	0c 00                	or     $0x0,%al
    168f:	00 40 00             	add    %al,0x0(%eax)
    1692:	00 00                	add    %al,(%eax)
    1694:	03 00                	add    (%eax),%eax
    1696:	00 00                	add    %al,(%eax)
    1698:	00 00                	add    %al,(%eax)
    169a:	00 00                	add    %al,(%eax)
    169c:	c0 00 00             	rolb   $0x0,(%eax)
	...
    16a7:	00 e0                	add    %ah,%al
    16a9:	00 00                	add    %al,(%eax)
    16ab:	00 aa 00 00 00 3b    	add    %ch,0x3b000000(%edx)
    16b1:	0c 00                	or     $0x0,%al
    16b3:	00 24 00             	add    %ah,(%eax,%eax,1)
    16b6:	00 00                	add    %al,(%eax)
    16b8:	c5 07                	lds    (%edi),%eax
    16ba:	28 00                	sub    %al,(%eax)
    16bc:	e8 0a 00 00 a0       	call   a00016cb <mousefifo+0x9fd7e5f7>
    16c1:	00 00                	add    %al,(%eax)
    16c3:	00 08                	add    %cl,(%eax)
    16c5:	00 00                	add    %al,(%eax)
    16c7:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
    16cd:	00 00                	add    %al,(%eax)
    16cf:	00 0c 00             	add    %cl,(%eax,%eax,1)
    16d2:	00 00                	add    %al,(%eax)
    16d4:	4c                   	dec    %esp
    16d5:	0c 00                	or     $0x0,%al
    16d7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    16dd:	00 00                	add    %al,(%eax)
    16df:	00 55 0c             	add    %dl,0xc(%ebp)
    16e2:	00 00                	add    %al,(%eax)
    16e4:	a0 00 00 00 14       	mov    0x14000000,%al
    16e9:	00 00                	add    %al,(%eax)
    16eb:	00 d9                	add    %bl,%cl
    16ed:	08 00                	or     %al,(%eax)
    16ef:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    16f5:	00 00                	add    %al,(%eax)
    16f7:	00 5e 0c             	add    %bl,0xc(%esi)
    16fa:	00 00                	add    %al,(%eax)
    16fc:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1701:	00 00                	add    %al,(%eax)
    1703:	00 00                	add    %al,(%eax)
    1705:	00 00                	add    %al,(%eax)
    1707:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
	...
    1713:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1717:	00 01                	add    %al,(%ecx)
    1719:	00 00                	add    %al,(%eax)
    171b:	00 00                	add    %al,(%eax)
    171d:	00 00                	add    %al,(%eax)
    171f:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1723:	00 03                	add    %al,(%ebx)
    1725:	00 00                	add    %al,(%eax)
    1727:	00 00                	add    %al,(%eax)
    1729:	00 00                	add    %al,(%eax)
    172b:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    172f:	00 06                	add    %al,(%esi)
    1731:	00 00                	add    %al,(%eax)
    1733:	00 00                	add    %al,(%eax)
    1735:	00 00                	add    %al,(%eax)
    1737:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    173b:	00 0b                	add    %cl,(%ebx)
    173d:	00 00                	add    %al,(%eax)
    173f:	00 00                	add    %al,(%eax)
    1741:	00 00                	add    %al,(%eax)
    1743:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1747:	00 10                	add    %dl,(%eax)
    1749:	00 00                	add    %al,(%eax)
    174b:	00 00                	add    %al,(%eax)
    174d:	00 00                	add    %al,(%eax)
    174f:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1753:	00 23                	add    %ah,(%ebx)
    1755:	00 00                	add    %al,(%eax)
    1757:	00 00                	add    %al,(%eax)
    1759:	00 00                	add    %al,(%eax)
    175b:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    175f:	00 26                	add    %ah,(%esi)
    1761:	00 00                	add    %al,(%eax)
    1763:	00 00                	add    %al,(%eax)
    1765:	00 00                	add    %al,(%eax)
    1767:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    176b:	00 28                	add    %ch,(%eax)
    176d:	00 00                	add    %al,(%eax)
    176f:	00 00                	add    %al,(%eax)
    1771:	00 00                	add    %al,(%eax)
    1773:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    1777:	00 34 00             	add    %dh,(%eax,%eax,1)
    177a:	00 00                	add    %al,(%eax)
    177c:	00 00                	add    %al,(%eax)
    177e:	00 00                	add    %al,(%eax)
    1780:	44                   	inc    %esp
    1781:	00 9a 00 3a 00 00    	add    %bl,0x3a00(%edx)
    1787:	00 00                	add    %al,(%eax)
    1789:	00 00                	add    %al,(%eax)
    178b:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    178f:	00 40 00             	add    %al,0x0(%eax)
    1792:	00 00                	add    %al,(%eax)
    1794:	00 00                	add    %al,(%eax)
    1796:	00 00                	add    %al,(%eax)
    1798:	44                   	inc    %esp
    1799:	00 aa 00 49 00 00    	add    %ch,0x4900(%edx)
    179f:	00 6a 0c             	add    %ch,0xc(%edx)
    17a2:	00 00                	add    %al,(%eax)
    17a4:	40                   	inc    %eax
    17a5:	00 00                	add    %al,(%eax)
    17a7:	00 02                	add    %al,(%edx)
    17a9:	00 00                	add    %al,(%eax)
    17ab:	00 75 0c             	add    %dh,0xc(%ebp)
    17ae:	00 00                	add    %al,(%eax)
    17b0:	40                   	inc    %eax
    17b1:	00 00                	add    %al,(%eax)
    17b3:	00 01                	add    %al,(%ecx)
    17b5:	00 00                	add    %al,(%eax)
    17b7:	00 00                	add    %al,(%eax)
    17b9:	00 00                	add    %al,(%eax)
    17bb:	00 c0                	add    %al,%al
	...
    17c5:	00 00                	add    %al,(%eax)
    17c7:	00 e0                	add    %ah,%al
    17c9:	00 00                	add    %al,(%eax)
    17cb:	00 51 00             	add    %dl,0x0(%ecx)
    17ce:	00 00                	add    %al,(%eax)
    17d0:	80 0c 00 00          	orb    $0x0,(%eax,%eax,1)
    17d4:	24 00                	and    $0x0,%al
    17d6:	00 00                	add    %al,(%eax)
    17d8:	16                   	push   %ss
    17d9:	08 28                	or     %ch,(%eax)
    17db:	00 e8                	add    %ch,%al
    17dd:	0a 00                	or     (%eax),%al
    17df:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    17e5:	00 00                	add    %al,(%eax)
    17e7:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
    17ed:	00 00                	add    %al,(%eax)
    17ef:	00 0c 00             	add    %cl,(%eax,%eax,1)
    17f2:	00 00                	add    %al,(%eax)
    17f4:	4c                   	dec    %esp
    17f5:	0c 00                	or     $0x0,%al
    17f7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    17fd:	00 00                	add    %al,(%eax)
    17ff:	00 55 0c             	add    %dl,0xc(%ebp)
    1802:	00 00                	add    %al,(%eax)
    1804:	a0 00 00 00 14       	mov    0x14000000,%al
    1809:	00 00                	add    %al,(%eax)
    180b:	00 d9                	add    %bl,%cl
    180d:	08 00                	or     %al,(%eax)
    180f:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1815:	00 00                	add    %al,(%eax)
    1817:	00 5e 0c             	add    %bl,0xc(%esi)
    181a:	00 00                	add    %al,(%eax)
    181c:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1821:	00 00                	add    %al,(%eax)
    1823:	00 00                	add    %al,(%eax)
    1825:	00 00                	add    %al,(%eax)
    1827:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
	...
    1833:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1837:	00 08                	add    %cl,(%eax)
    1839:	00 00                	add    %al,(%eax)
    183b:	00 00                	add    %al,(%eax)
    183d:	00 00                	add    %al,(%eax)
    183f:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
    1843:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1846:	00 00                	add    %al,(%eax)
    1848:	00 00                	add    %al,(%eax)
    184a:	00 00                	add    %al,(%eax)
    184c:	44                   	inc    %esp
    184d:	00 73 00             	add    %dh,0x0(%ebx)
    1850:	0d 00 00 00 00       	or     $0x0,%eax
    1855:	00 00                	add    %al,(%eax)
    1857:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    185b:	00 10                	add    %dl,(%eax)
    185d:	00 00                	add    %al,(%eax)
    185f:	00 00                	add    %al,(%eax)
    1861:	00 00                	add    %al,(%eax)
    1863:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    1867:	00 1a                	add    %bl,(%edx)
    1869:	00 00                	add    %al,(%eax)
    186b:	00 00                	add    %al,(%eax)
    186d:	00 00                	add    %al,(%eax)
    186f:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
    1873:	00 1e                	add    %bl,(%esi)
    1875:	00 00                	add    %al,(%eax)
    1877:	00 00                	add    %al,(%eax)
    1879:	00 00                	add    %al,(%eax)
    187b:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    187f:	00 23                	add    %ah,(%ebx)
    1881:	00 00                	add    %al,(%eax)
    1883:	00 00                	add    %al,(%eax)
    1885:	00 00                	add    %al,(%eax)
    1887:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    188b:	00 2f                	add    %ch,(%edi)
    188d:	00 00                	add    %al,(%eax)
    188f:	00 00                	add    %al,(%eax)
    1891:	00 00                	add    %al,(%eax)
    1893:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1897:	00 32                	add    %dh,(%edx)
    1899:	00 00                	add    %al,(%eax)
    189b:	00 00                	add    %al,(%eax)
    189d:	00 00                	add    %al,(%eax)
    189f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    18a3:	00 3d 00 00 00 00    	add    %bh,0x0
    18a9:	00 00                	add    %al,(%eax)
    18ab:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
    18af:	00 48 00             	add    %cl,0x0(%eax)
    18b2:	00 00                	add    %al,(%eax)
    18b4:	00 00                	add    %al,(%eax)
    18b6:	00 00                	add    %al,(%eax)
    18b8:	44                   	inc    %esp
    18b9:	00 85 00 4b 00 00    	add    %al,0x4b00(%ebp)
    18bf:	00 00                	add    %al,(%eax)
    18c1:	00 00                	add    %al,(%eax)
    18c3:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    18c7:	00 53 00             	add    %dl,0x0(%ebx)
    18ca:	00 00                	add    %al,(%eax)
    18cc:	00 00                	add    %al,(%eax)
    18ce:	00 00                	add    %al,(%eax)
    18d0:	44                   	inc    %esp
    18d1:	00 87 00 55 00 00    	add    %al,0x5500(%edi)
    18d7:	00 00                	add    %al,(%eax)
    18d9:	00 00                	add    %al,(%eax)
    18db:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
    18df:	00 57 00             	add    %dl,0x0(%edi)
    18e2:	00 00                	add    %al,(%eax)
    18e4:	00 00                	add    %al,(%eax)
    18e6:	00 00                	add    %al,(%eax)
    18e8:	44                   	inc    %esp
    18e9:	00 91 00 5c 00 00    	add    %dl,0x5c00(%ecx)
    18ef:	00 bf 0a 00 00 40    	add    %bh,0x4000000a(%edi)
    18f5:	00 00                	add    %al,(%eax)
    18f7:	00 03                	add    %al,(%ebx)
    18f9:	00 00                	add    %al,(%eax)
    18fb:	00 3f                	add    %bh,(%edi)
    18fd:	0b 00                	or     (%eax),%eax
    18ff:	00 40 00             	add    %al,0x0(%eax)
    1902:	00 00                	add    %al,(%eax)
    1904:	07                   	pop    %es
    1905:	00 00                	add    %al,(%eax)
    1907:	00 8e 0c 00 00 24    	add    %cl,0x2400000c(%esi)
    190d:	00 00                	add    %al,(%eax)
    190f:	00 7a 08             	add    %bh,0x8(%edx)
    1912:	28 00                	sub    %al,(%eax)
    1914:	a1 0c 00 00 a0       	mov    0xa000000c,%eax
    1919:	00 00                	add    %al,(%eax)
    191b:	00 08                	add    %cl,(%eax)
    191d:	00 00                	add    %al,(%eax)
    191f:	00 aa 0c 00 00 a0    	add    %ch,-0x5ffffff4(%edx)
    1925:	00 00                	add    %al,(%eax)
    1927:	00 0c 00             	add    %cl,(%eax,%eax,1)
    192a:	00 00                	add    %al,(%eax)
    192c:	00 00                	add    %al,(%eax)
    192e:	00 00                	add    %al,(%eax)
    1930:	44                   	inc    %esp
    1931:	00 05 00 00 00 00    	add    %al,0x0
    1937:	00 00                	add    %al,(%eax)
    1939:	00 00                	add    %al,(%eax)
    193b:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    193f:	00 07                	add    %al,(%edi)
    1941:	00 00                	add    %al,(%eax)
    1943:	00 00                	add    %al,(%eax)
    1945:	00 00                	add    %al,(%eax)
    1947:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    194b:	00 18                	add    %bl,(%eax)
    194d:	00 00                	add    %al,(%eax)
    194f:	00 00                	add    %al,(%eax)
    1951:	00 00                	add    %al,(%eax)
    1953:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1957:	00 35 00 00 00 b3    	add    %dh,0xb3000000
    195d:	0c 00                	or     $0x0,%al
    195f:	00 80 00 00 00 e2    	add    %al,-0x1e000000(%eax)
    1965:	ff                   	(bad)  
    1966:	ff                   	(bad)  
    1967:	ff 00                	incl   (%eax)
    1969:	00 00                	add    %al,(%eax)
    196b:	00 c0                	add    %al,%al
	...
    1975:	00 00                	add    %al,(%eax)
    1977:	00 e0                	add    %ah,%al
    1979:	00 00                	add    %al,(%eax)
    197b:	00 3a                	add    %bh,(%edx)
    197d:	00 00                	add    %al,(%eax)
    197f:	00 bf 0c 00 00 24    	add    %bh,0x2400000c(%edi)
    1985:	00 00                	add    %al,(%eax)
    1987:	00 b4 08 28 00 e8 0a 	add    %dh,0xae80028(%eax,%ecx,1)
    198e:	00 00                	add    %al,(%eax)
    1990:	a0 00 00 00 08       	mov    0x8000000,%al
    1995:	00 00                	add    %al,(%eax)
    1997:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
    199d:	00 00                	add    %al,(%eax)
    199f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    19a2:	00 00                	add    %al,(%eax)
    19a4:	4c                   	dec    %esp
    19a5:	0c 00                	or     $0x0,%al
    19a7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    19ad:	00 00                	add    %al,(%eax)
    19af:	00 55 0c             	add    %dl,0xc(%ebp)
    19b2:	00 00                	add    %al,(%eax)
    19b4:	a0 00 00 00 14       	mov    0x14000000,%al
    19b9:	00 00                	add    %al,(%eax)
    19bb:	00 d9                	add    %bl,%cl
    19bd:	08 00                	or     %al,(%eax)
    19bf:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    19c5:	00 00                	add    %al,(%eax)
    19c7:	00 d1                	add    %dl,%cl
    19c9:	0c 00                	or     $0x0,%al
    19cb:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    19d1:	00 00                	add    %al,(%eax)
    19d3:	00 00                	add    %al,(%eax)
    19d5:	00 00                	add    %al,(%eax)
    19d7:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
	...
    19e3:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    19e7:	00 10                	add    %dl,(%eax)
    19e9:	00 00                	add    %al,(%eax)
    19eb:	00 00                	add    %al,(%eax)
    19ed:	00 00                	add    %al,(%eax)
    19ef:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    19f3:	00 1b                	add    %bl,(%ebx)
    19f5:	00 00                	add    %al,(%eax)
    19f7:	00 00                	add    %al,(%eax)
    19f9:	00 00                	add    %al,(%eax)
    19fb:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    19ff:	00 20                	add    %ah,(%eax)
    1a01:	00 00                	add    %al,(%eax)
    1a03:	00 00                	add    %al,(%eax)
    1a05:	00 00                	add    %al,(%eax)
    1a07:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1a0b:	00 31                	add    %dh,(%ecx)
    1a0d:	00 00                	add    %al,(%eax)
    1a0f:	00 00                	add    %al,(%eax)
    1a11:	00 00                	add    %al,(%eax)
    1a13:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    1a17:	00 33                	add    %dh,(%ebx)
    1a19:	00 00                	add    %al,(%eax)
    1a1b:	00 00                	add    %al,(%eax)
    1a1d:	00 00                	add    %al,(%eax)
    1a1f:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    1a23:	00 38                	add    %bh,(%eax)
    1a25:	00 00                	add    %al,(%eax)
    1a27:	00 00                	add    %al,(%eax)
    1a29:	00 00                	add    %al,(%eax)
    1a2b:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    1a2f:	00 3b                	add    %bh,(%ebx)
    1a31:	00 00                	add    %al,(%eax)
    1a33:	00 00                	add    %al,(%eax)
    1a35:	00 00                	add    %al,(%eax)
    1a37:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    1a3b:	00 41 00             	add    %al,0x0(%ecx)
    1a3e:	00 00                	add    %al,(%eax)
    1a40:	00 00                	add    %al,(%eax)
    1a42:	00 00                	add    %al,(%eax)
    1a44:	44                   	inc    %esp
    1a45:	00 de                	add    %bl,%dh
    1a47:	00 4a 00             	add    %cl,0x0(%edx)
    1a4a:	00 00                	add    %al,(%eax)
    1a4c:	6a 0c                	push   $0xc
    1a4e:	00 00                	add    %al,(%eax)
    1a50:	40                   	inc    %eax
    1a51:	00 00                	add    %al,(%eax)
    1a53:	00 02                	add    %al,(%edx)
    1a55:	00 00                	add    %al,(%eax)
    1a57:	00 75 0c             	add    %dh,0xc(%ebp)
    1a5a:	00 00                	add    %al,(%eax)
    1a5c:	40                   	inc    %eax
    1a5d:	00 00                	add    %al,(%eax)
    1a5f:	00 00                	add    %al,(%eax)
    1a61:	00 00                	add    %al,(%eax)
    1a63:	00 ef                	add    %ch,%bh
    1a65:	08 00                	or     %al,(%eax)
    1a67:	00 40 00             	add    %al,0x0(%eax)
    1a6a:	00 00                	add    %al,(%eax)
    1a6c:	03 00                	add    (%eax),%eax
    1a6e:	00 00                	add    %al,(%eax)
    1a70:	00 00                	add    %al,(%eax)
    1a72:	00 00                	add    %al,(%eax)
    1a74:	c0 00 00             	rolb   $0x0,(%eax)
	...
    1a7f:	00 e0                	add    %ah,%al
    1a81:	00 00                	add    %al,(%eax)
    1a83:	00 50 00             	add    %dl,0x0(%eax)
    1a86:	00 00                	add    %al,(%eax)
    1a88:	e5 0c                	in     $0xc,%eax
    1a8a:	00 00                	add    %al,(%eax)
    1a8c:	24 00                	and    $0x0,%al
    1a8e:	00 00                	add    %al,(%eax)
    1a90:	04 09                	add    $0x9,%al
    1a92:	28 00                	sub    %al,(%eax)
    1a94:	e8 0a 00 00 a0       	call   a0001aa3 <mousefifo+0x9fd7e9cf>
    1a99:	00 00                	add    %al,(%eax)
    1a9b:	00 08                	add    %cl,(%eax)
    1a9d:	00 00                	add    %al,(%eax)
    1a9f:	00 b7 09 00 00 a0    	add    %dh,-0x5ffffff7(%edi)
    1aa5:	00 00                	add    %al,(%eax)
    1aa7:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1aaa:	00 00                	add    %al,(%eax)
    1aac:	4c                   	dec    %esp
    1aad:	0c 00                	or     $0x0,%al
    1aaf:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1ab5:	00 00                	add    %al,(%eax)
    1ab7:	00 55 0c             	add    %dl,0xc(%ebp)
    1aba:	00 00                	add    %al,(%eax)
    1abc:	a0 00 00 00 14       	mov    0x14000000,%al
    1ac1:	00 00                	add    %al,(%eax)
    1ac3:	00 d9                	add    %bl,%cl
    1ac5:	08 00                	or     %al,(%eax)
    1ac7:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
    1acd:	00 00                	add    %al,(%eax)
    1acf:	00 5e 0c             	add    %bl,0xc(%esi)
    1ad2:	00 00                	add    %al,(%eax)
    1ad4:	a0 00 00 00 1c       	mov    0x1c000000,%al
    1ad9:	00 00                	add    %al,(%eax)
    1adb:	00 00                	add    %al,(%eax)
    1add:	00 00                	add    %al,(%eax)
    1adf:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
	...
    1aeb:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1aef:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1af2:	00 00                	add    %al,(%eax)
    1af4:	00 00                	add    %al,(%eax)
    1af6:	00 00                	add    %al,(%eax)
    1af8:	44                   	inc    %esp
    1af9:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    1aff:	00 00                	add    %al,(%eax)
    1b01:	00 00                	add    %al,(%eax)
    1b03:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    1b07:	00 1a                	add    %bl,(%edx)
    1b09:	00 00                	add    %al,(%eax)
    1b0b:	00 00                	add    %al,(%eax)
    1b0d:	00 00                	add    %al,(%eax)
    1b0f:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
    1b13:	00 1e                	add    %bl,(%esi)
    1b15:	00 00                	add    %al,(%eax)
    1b17:	00 00                	add    %al,(%eax)
    1b19:	00 00                	add    %al,(%eax)
    1b1b:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    1b1f:	00 21                	add    %ah,(%ecx)
    1b21:	00 00                	add    %al,(%eax)
    1b23:	00 00                	add    %al,(%eax)
    1b25:	00 00                	add    %al,(%eax)
    1b27:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    1b2b:	00 25 00 00 00 00    	add    %ah,0x0
    1b31:	00 00                	add    %al,(%eax)
    1b33:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1b37:	00 2d 00 00 00 00    	add    %ch,0x0
    1b3d:	00 00                	add    %al,(%eax)
    1b3f:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    1b43:	00 31                	add    %dh,(%ecx)
    1b45:	00 00                	add    %al,(%eax)
    1b47:	00 00                	add    %al,(%eax)
    1b49:	00 00                	add    %al,(%eax)
    1b4b:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1b4f:	00 34 00             	add    %dh,(%eax,%eax,1)
    1b52:	00 00                	add    %al,(%eax)
    1b54:	00 00                	add    %al,(%eax)
    1b56:	00 00                	add    %al,(%eax)
    1b58:	44                   	inc    %esp
    1b59:	00 bb 00 3f 00 00    	add    %bh,0x3f00(%ebx)
    1b5f:	00 00                	add    %al,(%eax)
    1b61:	00 00                	add    %al,(%eax)
    1b63:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    1b67:	00 42 00             	add    %al,0x0(%edx)
    1b6a:	00 00                	add    %al,(%eax)
    1b6c:	00 00                	add    %al,(%eax)
    1b6e:	00 00                	add    %al,(%eax)
    1b70:	44                   	inc    %esp
    1b71:	00 c4                	add    %al,%ah
    1b73:	00 47 00             	add    %al,0x0(%edi)
    1b76:	00 00                	add    %al,(%eax)
    1b78:	bf 0a 00 00 40       	mov    $0x4000000a,%edi
    1b7d:	00 00                	add    %al,(%eax)
    1b7f:	00 07                	add    %al,(%edi)
    1b81:	00 00                	add    %al,(%eax)
    1b83:	00 3f                	add    %bh,(%edi)
    1b85:	0b 00                	or     (%eax),%eax
    1b87:	00 40 00             	add    %al,0x0(%eax)
    1b8a:	00 00                	add    %al,(%eax)
    1b8c:	06                   	push   %es
    1b8d:	00 00                	add    %al,(%eax)
    1b8f:	00 00                	add    %al,(%eax)
    1b91:	00 00                	add    %al,(%eax)
    1b93:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    1b97:	00 53 09             	add    %dl,0x9(%ebx)
    1b9a:	28 00                	sub    %al,(%eax)
    1b9c:	f4                   	hlt    
    1b9d:	0c 00                	or     $0x0,%al
    1b9f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    1ba3:	00 53 09             	add    %dl,0x9(%ebx)
    1ba6:	28 00                	sub    %al,(%eax)
    1ba8:	08 00                	or     %al,(%eax)
    1baa:	00 00                	add    %al,(%eax)
    1bac:	3c 00                	cmp    $0x0,%al
    1bae:	00 00                	add    %al,(%eax)
    1bb0:	00 00                	add    %al,(%eax)
    1bb2:	00 00                	add    %al,(%eax)
    1bb4:	17                   	pop    %ss
    1bb5:	00 00                	add    %al,(%eax)
    1bb7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1bbd:	00 00                	add    %al,(%eax)
    1bbf:	00 41 00             	add    %al,0x0(%ecx)
    1bc2:	00 00                	add    %al,(%eax)
    1bc4:	80 00 00             	addb   $0x0,(%eax)
    1bc7:	00 00                	add    %al,(%eax)
    1bc9:	00 00                	add    %al,(%eax)
    1bcb:	00 5b 00             	add    %bl,0x0(%ebx)
    1bce:	00 00                	add    %al,(%eax)
    1bd0:	80 00 00             	addb   $0x0,(%eax)
    1bd3:	00 00                	add    %al,(%eax)
    1bd5:	00 00                	add    %al,(%eax)
    1bd7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1bdd:	00 00                	add    %al,(%eax)
    1bdf:	00 00                	add    %al,(%eax)
    1be1:	00 00                	add    %al,(%eax)
    1be3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1be9:	00 00                	add    %al,(%eax)
    1beb:	00 00                	add    %al,(%eax)
    1bed:	00 00                	add    %al,(%eax)
    1bef:	00 e1                	add    %ah,%cl
    1bf1:	00 00                	add    %al,(%eax)
    1bf3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1bf9:	00 00                	add    %al,(%eax)
    1bfb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1bfe:	00 00                	add    %al,(%eax)
    1c00:	80 00 00             	addb   $0x0,(%eax)
    1c03:	00 00                	add    %al,(%eax)
    1c05:	00 00                	add    %al,(%eax)
    1c07:	00 37                	add    %dh,(%edi)
    1c09:	01 00                	add    %eax,(%eax)
    1c0b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1c11:	00 00                	add    %al,(%eax)
    1c13:	00 5d 01             	add    %bl,0x1(%ebp)
    1c16:	00 00                	add    %al,(%eax)
    1c18:	80 00 00             	addb   $0x0,(%eax)
    1c1b:	00 00                	add    %al,(%eax)
    1c1d:	00 00                	add    %al,(%eax)
    1c1f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1c25:	00 00                	add    %al,(%eax)
    1c27:	00 00                	add    %al,(%eax)
    1c29:	00 00                	add    %al,(%eax)
    1c2b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1c31:	00 00                	add    %al,(%eax)
    1c33:	00 00                	add    %al,(%eax)
    1c35:	00 00                	add    %al,(%eax)
    1c37:	00 d2                	add    %dl,%dl
    1c39:	01 00                	add    %eax,(%eax)
    1c3b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1c41:	00 00                	add    %al,(%eax)
    1c43:	00 ec                	add    %ch,%ah
    1c45:	01 00                	add    %eax,(%eax)
    1c47:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1c4d:	00 00                	add    %al,(%eax)
    1c4f:	00 07                	add    %al,(%edi)
    1c51:	02 00                	add    (%eax),%al
    1c53:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1c59:	00 00                	add    %al,(%eax)
    1c5b:	00 28                	add    %ch,(%eax)
    1c5d:	02 00                	add    (%eax),%al
    1c5f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1c65:	00 00                	add    %al,(%eax)
    1c67:	00 47 02             	add    %al,0x2(%edi)
    1c6a:	00 00                	add    %al,(%eax)
    1c6c:	80 00 00             	addb   $0x0,(%eax)
    1c6f:	00 00                	add    %al,(%eax)
    1c71:	00 00                	add    %al,(%eax)
    1c73:	00 66 02             	add    %ah,0x2(%esi)
    1c76:	00 00                	add    %al,(%eax)
    1c78:	80 00 00             	addb   $0x0,(%eax)
    1c7b:	00 00                	add    %al,(%eax)
    1c7d:	00 00                	add    %al,(%eax)
    1c7f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1c85:	00 00                	add    %al,(%eax)
    1c87:	00 00                	add    %al,(%eax)
    1c89:	00 00                	add    %al,(%eax)
    1c8b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1c91:	00 00                	add    %al,(%eax)
    1c93:	00 cf                	add    %cl,%bh
    1c95:	a8 00                	test   $0x0,%al
    1c97:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    1c9d:	00 00                	add    %al,(%eax)
    1c9f:	00 00                	add    %al,(%eax)
    1ca1:	00 00                	add    %al,(%eax)
    1ca3:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    1ca9:	00 00                	add    %al,(%eax)
    1cab:	00 37                	add    %dh,(%edi)
    1cad:	53                   	push   %ebx
    1cae:	00 00                	add    %al,(%eax)
    1cb0:	11 04 00             	adc    %eax,(%eax,%eax,1)
    1cb3:	00 c2                	add    %al,%dl
    1cb5:	00 00                	add    %al,(%eax)
    1cb7:	00 c8                	add    %cl,%al
    1cb9:	3c 00                	cmp    $0x0,%al
    1cbb:	00 fd                	add    %bh,%ch
    1cbd:	0c 00                	or     $0x0,%al
    1cbf:	00 24 00             	add    %ah,(%eax,%eax,1)
    1cc2:	00 00                	add    %al,(%eax)
    1cc4:	53                   	push   %ebx
    1cc5:	09 28                	or     %ebp,(%eax)
    1cc7:	00 0c 0d 00 00 a0 00 	add    %cl,0xa00000(,%ecx,1)
    1cce:	00 00                	add    %al,(%eax)
    1cd0:	08 00                	or     %al,(%eax)
    1cd2:	00 00                	add    %al,(%eax)
    1cd4:	1e                   	push   %ds
    1cd5:	0d 00 00 a0 00       	or     $0xa00000,%eax
    1cda:	00 00                	add    %al,(%eax)
    1cdc:	0c 00                	or     $0x0,%al
    1cde:	00 00                	add    %al,(%eax)
    1ce0:	2b 0d 00 00 a0 00    	sub    0xa00000,%ecx
    1ce6:	00 00                	add    %al,(%eax)
    1ce8:	10 00                	adc    %al,(%eax)
    1cea:	00 00                	add    %al,(%eax)
    1cec:	37                   	aaa    
    1ced:	0d 00 00 a0 00       	or     $0xa00000,%eax
    1cf2:	00 00                	add    %al,(%eax)
    1cf4:	14 00                	adc    $0x0,%al
    1cf6:	00 00                	add    %al,(%eax)
    1cf8:	00 00                	add    %al,(%eax)
    1cfa:	00 00                	add    %al,(%eax)
    1cfc:	44                   	inc    %esp
    1cfd:	00 07                	add    %al,(%edi)
	...
    1d07:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1d0b:	00 0f                	add    %cl,(%edi)
    1d0d:	00 00                	add    %al,(%eax)
    1d0f:	00 00                	add    %al,(%eax)
    1d11:	00 00                	add    %al,(%eax)
    1d13:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1d17:	00 12                	add    %dl,(%edx)
    1d19:	00 00                	add    %al,(%eax)
    1d1b:	00 00                	add    %al,(%eax)
    1d1d:	00 00                	add    %al,(%eax)
    1d1f:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1d23:	00 1a                	add    %bl,(%edx)
    1d25:	00 00                	add    %al,(%eax)
    1d27:	00 00                	add    %al,(%eax)
    1d29:	00 00                	add    %al,(%eax)
    1d2b:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    1d2f:	00 20                	add    %ah,(%eax)
    1d31:	00 00                	add    %al,(%eax)
    1d33:	00 00                	add    %al,(%eax)
    1d35:	00 00                	add    %al,(%eax)
    1d37:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    1d3b:	00 23                	add    %ah,(%ebx)
    1d3d:	00 00                	add    %al,(%eax)
    1d3f:	00 00                	add    %al,(%eax)
    1d41:	00 00                	add    %al,(%eax)
    1d43:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1d47:	00 2d 00 00 00 00    	add    %ch,0x0
    1d4d:	00 00                	add    %al,(%eax)
    1d4f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1d53:	00 2f                	add    %ch,(%edi)
    1d55:	00 00                	add    %al,(%eax)
    1d57:	00 00                	add    %al,(%eax)
    1d59:	00 00                	add    %al,(%eax)
    1d5b:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1d5f:	00 32                	add    %dh,(%edx)
    1d61:	00 00                	add    %al,(%eax)
    1d63:	00 00                	add    %al,(%eax)
    1d65:	00 00                	add    %al,(%eax)
    1d67:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1d6b:	00 35 00 00 00 00    	add    %dh,0x0
    1d71:	00 00                	add    %al,(%eax)
    1d73:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1d77:	00 37                	add    %dh,(%edi)
    1d79:	00 00                	add    %al,(%eax)
    1d7b:	00 00                	add    %al,(%eax)
    1d7d:	00 00                	add    %al,(%eax)
    1d7f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1d83:	00 3a                	add    %bh,(%edx)
    1d85:	00 00                	add    %al,(%eax)
    1d87:	00 00                	add    %al,(%eax)
    1d89:	00 00                	add    %al,(%eax)
    1d8b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1d8f:	00 40 00             	add    %al,0x0(%eax)
    1d92:	00 00                	add    %al,(%eax)
    1d94:	00 00                	add    %al,(%eax)
    1d96:	00 00                	add    %al,(%eax)
    1d98:	44                   	inc    %esp
    1d99:	00 11                	add    %dl,(%ecx)
    1d9b:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1d9f:	00 00                	add    %al,(%eax)
    1da1:	00 00                	add    %al,(%eax)
    1da3:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1da7:	00 46 00             	add    %al,0x0(%esi)
    1daa:	00 00                	add    %al,(%eax)
    1dac:	00 00                	add    %al,(%eax)
    1dae:	00 00                	add    %al,(%eax)
    1db0:	44                   	inc    %esp
    1db1:	00 11                	add    %dl,(%ecx)
    1db3:	00 49 00             	add    %cl,0x0(%ecx)
    1db6:	00 00                	add    %al,(%eax)
    1db8:	00 00                	add    %al,(%eax)
    1dba:	00 00                	add    %al,(%eax)
    1dbc:	44                   	inc    %esp
    1dbd:	00 12                	add    %dl,(%edx)
    1dbf:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1dc3:	00 00                	add    %al,(%eax)
    1dc5:	00 00                	add    %al,(%eax)
    1dc7:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1dcb:	00 4f 00             	add    %cl,0x0(%edi)
    1dce:	00 00                	add    %al,(%eax)
    1dd0:	45                   	inc    %ebp
    1dd1:	0d 00 00 40 00       	or     $0x400000,%eax
    1dd6:	00 00                	add    %al,(%eax)
    1dd8:	00 00                	add    %al,(%eax)
    1dda:	00 00                	add    %al,(%eax)
    1ddc:	50                   	push   %eax
    1ddd:	0d 00 00 40 00       	or     $0x400000,%eax
    1de2:	00 00                	add    %al,(%eax)
    1de4:	02 00                	add    (%eax),%al
    1de6:	00 00                	add    %al,(%eax)
    1de8:	5d                   	pop    %ebp
    1de9:	0d 00 00 40 00       	or     $0x400000,%eax
    1dee:	00 00                	add    %al,(%eax)
    1df0:	03 00                	add    (%eax),%eax
    1df2:	00 00                	add    %al,(%eax)
    1df4:	69 0d 00 00 40 00 00 	imul   $0x70000,0x400000,%ecx
    1dfb:	00 07 00 
    1dfe:	00 00                	add    %al,(%eax)
    1e00:	77 0d                	ja     1e0f <bootmain-0x27e1f1>
    1e02:	00 00                	add    %al,(%eax)
    1e04:	24 00                	and    $0x0,%al
    1e06:	00 00                	add    %al,(%eax)
    1e08:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    1e09:	09 28                	or     %ebp,(%eax)
    1e0b:	00 86 0d 00 00 a0    	add    %al,-0x5ffffff3(%esi)
    1e11:	00 00                	add    %al,(%eax)
    1e13:	00 08                	add    %cl,(%eax)
    1e15:	00 00                	add    %al,(%eax)
    1e17:	00 98 0d 00 00 a0    	add    %bl,-0x5ffffff3(%eax)
    1e1d:	00 00                	add    %al,(%eax)
    1e1f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1e22:	00 00                	add    %al,(%eax)
    1e24:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    1e25:	0d 00 00 a0 00       	or     $0xa00000,%eax
    1e2a:	00 00                	add    %al,(%eax)
    1e2c:	10 00                	adc    %al,(%eax)
    1e2e:	00 00                	add    %al,(%eax)
    1e30:	37                   	aaa    
    1e31:	0d 00 00 a0 00       	or     $0xa00000,%eax
    1e36:	00 00                	add    %al,(%eax)
    1e38:	14 00                	adc    $0x0,%al
    1e3a:	00 00                	add    %al,(%eax)
    1e3c:	00 00                	add    %al,(%eax)
    1e3e:	00 00                	add    %al,(%eax)
    1e40:	44                   	inc    %esp
    1e41:	00 17                	add    %dl,(%edi)
	...
    1e4b:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1e4f:	00 03                	add    %al,(%ebx)
    1e51:	00 00                	add    %al,(%eax)
    1e53:	00 00                	add    %al,(%eax)
    1e55:	00 00                	add    %al,(%eax)
    1e57:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1e5b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1e5e:	00 00                	add    %al,(%eax)
    1e60:	00 00                	add    %al,(%eax)
    1e62:	00 00                	add    %al,(%eax)
    1e64:	44                   	inc    %esp
    1e65:	00 1a                	add    %bl,(%edx)
    1e67:	00 0f                	add    %cl,(%edi)
    1e69:	00 00                	add    %al,(%eax)
    1e6b:	00 00                	add    %al,(%eax)
    1e6d:	00 00                	add    %al,(%eax)
    1e6f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1e73:	00 16                	add    %dl,(%esi)
    1e75:	00 00                	add    %al,(%eax)
    1e77:	00 00                	add    %al,(%eax)
    1e79:	00 00                	add    %al,(%eax)
    1e7b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1e7f:	00 19                	add    %bl,(%ecx)
    1e81:	00 00                	add    %al,(%eax)
    1e83:	00 00                	add    %al,(%eax)
    1e85:	00 00                	add    %al,(%eax)
    1e87:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1e8b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1e8e:	00 00                	add    %al,(%eax)
    1e90:	00 00                	add    %al,(%eax)
    1e92:	00 00                	add    %al,(%eax)
    1e94:	44                   	inc    %esp
    1e95:	00 1f                	add    %bl,(%edi)
    1e97:	00 20                	add    %ah,(%eax)
    1e99:	00 00                	add    %al,(%eax)
    1e9b:	00 00                	add    %al,(%eax)
    1e9d:	00 00                	add    %al,(%eax)
    1e9f:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    1ea3:	00 28                	add    %ch,(%eax)
    1ea5:	00 00                	add    %al,(%eax)
    1ea7:	00 b6 0d 00 00 40    	add    %dh,0x4000000d(%esi)
    1ead:	00 00                	add    %al,(%eax)
    1eaf:	00 00                	add    %al,(%eax)
    1eb1:	00 00                	add    %al,(%eax)
    1eb3:	00 c1                	add    %al,%cl
    1eb5:	0d 00 00 40 00       	or     $0x400000,%eax
    1eba:	00 00                	add    %al,(%eax)
    1ebc:	01 00                	add    %eax,(%eax)
    1ebe:	00 00                	add    %al,(%eax)
    1ec0:	cf                   	iret   
    1ec1:	0d 00 00 40 00       	or     $0x400000,%eax
    1ec6:	00 00                	add    %al,(%eax)
    1ec8:	01 00                	add    %eax,(%eax)
    1eca:	00 00                	add    %al,(%eax)
    1ecc:	69 0d 00 00 40 00 00 	imul   $0x20000,0x400000,%ecx
    1ed3:	00 02 00 
    1ed6:	00 00                	add    %al,(%eax)
    1ed8:	df 0d 00 00 24 00    	fisttp 0x240000
    1ede:	00 00                	add    %al,(%eax)
    1ee0:	d1 09                	rorl   (%ecx)
    1ee2:	28 00                	sub    %al,(%eax)
    1ee4:	00 00                	add    %al,(%eax)
    1ee6:	00 00                	add    %al,(%eax)
    1ee8:	44                   	inc    %esp
    1ee9:	00 28                	add    %ch,(%eax)
	...
    1ef3:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    1ef7:	00 05 00 00 00 00    	add    %al,0x0
    1efd:	00 00                	add    %al,(%eax)
    1eff:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    1f03:	00 0a                	add    %cl,(%edx)
    1f05:	00 00                	add    %al,(%eax)
    1f07:	00 00                	add    %al,(%eax)
    1f09:	00 00                	add    %al,(%eax)
    1f0b:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    1f0f:	00 19                	add    %bl,(%ecx)
    1f11:	00 00                	add    %al,(%eax)
    1f13:	00 00                	add    %al,(%eax)
    1f15:	00 00                	add    %al,(%eax)
    1f17:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    1f1b:	00 24 00             	add    %ah,(%eax,%eax,1)
    1f1e:	00 00                	add    %al,(%eax)
    1f20:	00 00                	add    %al,(%eax)
    1f22:	00 00                	add    %al,(%eax)
    1f24:	44                   	inc    %esp
    1f25:	00 31                	add    %dh,(%ecx)
    1f27:	00 37                	add    %dh,(%edi)
    1f29:	00 00                	add    %al,(%eax)
    1f2b:	00 00                	add    %al,(%eax)
    1f2d:	00 00                	add    %al,(%eax)
    1f2f:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    1f33:	00 4d 00             	add    %cl,0x0(%ebp)
    1f36:	00 00                	add    %al,(%eax)
    1f38:	00 00                	add    %al,(%eax)
    1f3a:	00 00                	add    %al,(%eax)
    1f3c:	44                   	inc    %esp
    1f3d:	00 34 00             	add    %dh,(%eax,%eax,1)
    1f40:	69 00 00 00 00 00    	imul   $0x0,(%eax),%eax
    1f46:	00 00                	add    %al,(%eax)
    1f48:	44                   	inc    %esp
    1f49:	00 19                	add    %bl,(%ecx)
    1f4b:	00 7f 00             	add    %bh,0x0(%edi)
    1f4e:	00 00                	add    %al,(%eax)
    1f50:	00 00                	add    %al,(%eax)
    1f52:	00 00                	add    %al,(%eax)
    1f54:	44                   	inc    %esp
    1f55:	00 1a                	add    %bl,(%edx)
    1f57:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    1f5d:	00 00                	add    %al,(%eax)
    1f5f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1f63:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    1f6a:	00 00                	add    %al,(%eax)
    1f6c:	44                   	inc    %esp
    1f6d:	00 1f                	add    %bl,(%edi)
    1f6f:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
    1f75:	00 00                	add    %al,(%eax)
    1f77:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1f7b:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
    1f82:	00 00                	add    %al,(%eax)
    1f84:	44                   	inc    %esp
    1f85:	00 36                	add    %dh,(%esi)
    1f87:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    1f8d:	00 00                	add    %al,(%eax)
    1f8f:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1f93:	00 b2 00 00 00 00    	add    %dh,0x0(%edx)
    1f99:	00 00                	add    %al,(%eax)
    1f9b:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1f9f:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
    1fa5:	00 00                	add    %al,(%eax)
    1fa7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1fab:	00 c2                	add    %al,%dl
    1fad:	00 00                	add    %al,(%eax)
    1faf:	00 00                	add    %al,(%eax)
    1fb1:	00 00                	add    %al,(%eax)
    1fb3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1fb7:	00 cc                	add    %cl,%ah
    1fb9:	00 00                	add    %al,(%eax)
    1fbb:	00 00                	add    %al,(%eax)
    1fbd:	00 00                	add    %al,(%eax)
    1fbf:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1fc3:	00 d3                	add    %dl,%bl
    1fc5:	00 00                	add    %al,(%eax)
    1fc7:	00 00                	add    %al,(%eax)
    1fc9:	00 00                	add    %al,(%eax)
    1fcb:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1fcf:	00 dc                	add    %bl,%ah
    1fd1:	00 00                	add    %al,(%eax)
    1fd3:	00 00                	add    %al,(%eax)
    1fd5:	00 00                	add    %al,(%eax)
    1fd7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1fdb:	00 e3                	add    %ah,%bl
    1fdd:	00 00                	add    %al,(%eax)
    1fdf:	00 00                	add    %al,(%eax)
    1fe1:	00 00                	add    %al,(%eax)
    1fe3:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    1fe7:	00 ea                	add    %ch,%dl
    1fe9:	00 00                	add    %al,(%eax)
    1feb:	00 00                	add    %al,(%eax)
    1fed:	00 00                	add    %al,(%eax)
    1fef:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    1ff3:	00 f1                	add    %dh,%cl
    1ff5:	00 00                	add    %al,(%eax)
    1ff7:	00 00                	add    %al,(%eax)
    1ff9:	00 00                	add    %al,(%eax)
    1ffb:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1fff:	00 f6                	add    %dh,%dh
    2001:	00 00                	add    %al,(%eax)
    2003:	00 00                	add    %al,(%eax)
    2005:	00 00                	add    %al,(%eax)
    2007:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    200b:	00 fc                	add    %bh,%ah
    200d:	00 00                	add    %al,(%eax)
    200f:	00 00                	add    %al,(%eax)
    2011:	00 00                	add    %al,(%eax)
    2013:	00 44 00 41          	add    %al,0x41(%eax,%eax,1)
    2017:	00 05 01 00 00 00    	add    %al,0x1
    201d:	00 00                	add    %al,(%eax)
    201f:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    2023:	00 0a                	add    %cl,(%edx)
    2025:	01 00                	add    %eax,(%eax)
    2027:	00 00                	add    %al,(%eax)
    2029:	00 00                	add    %al,(%eax)
    202b:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    202f:	00 10                	add    %dl,(%eax)
    2031:	01 00                	add    %eax,(%eax)
    2033:	00 00                	add    %al,(%eax)
    2035:	00 00                	add    %al,(%eax)
    2037:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    203b:	00 19                	add    %bl,(%ecx)
    203d:	01 00                	add    %eax,(%eax)
    203f:	00 00                	add    %al,(%eax)
    2041:	00 00                	add    %al,(%eax)
    2043:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    2047:	00 22                	add    %ah,(%edx)
    2049:	01 00                	add    %eax,(%eax)
    204b:	00 00                	add    %al,(%eax)
    204d:	00 00                	add    %al,(%eax)
    204f:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2053:	00 29                	add    %ch,(%ecx)
    2055:	01 00                	add    %eax,(%eax)
    2057:	00 00                	add    %al,(%eax)
    2059:	00 00                	add    %al,(%eax)
    205b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    205f:	00 30                	add    %dh,(%eax)
    2061:	01 00                	add    %eax,(%eax)
    2063:	00 00                	add    %al,(%eax)
    2065:	00 00                	add    %al,(%eax)
    2067:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    206b:	00 39                	add    %bh,(%ecx)
    206d:	01 00                	add    %eax,(%eax)
    206f:	00 00                	add    %al,(%eax)
    2071:	00 00                	add    %al,(%eax)
    2073:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2077:	00 40 01             	add    %al,0x1(%eax)
    207a:	00 00                	add    %al,(%eax)
    207c:	00 00                	add    %al,(%eax)
    207e:	00 00                	add    %al,(%eax)
    2080:	44                   	inc    %esp
    2081:	00 47 00             	add    %al,0x0(%edi)
    2084:	47                   	inc    %edi
    2085:	01 00                	add    %eax,(%eax)
    2087:	00 00                	add    %al,(%eax)
    2089:	00 00                	add    %al,(%eax)
    208b:	00 44 00 4d          	add    %al,0x4d(%eax,%eax,1)
    208f:	00 5b 01             	add    %bl,0x1(%ebx)
    2092:	00 00                	add    %al,(%eax)
    2094:	00 00                	add    %al,(%eax)
    2096:	00 00                	add    %al,(%eax)
    2098:	64 00 00             	add    %al,%fs:(%eax)
    209b:	00 31                	add    %dh,(%ecx)
    209d:	0b 28                	or     (%eax),%ebp
    209f:	00 f3                	add    %dh,%bl
    20a1:	0d 00 00 64 00       	or     $0x640000,%eax
    20a6:	02 00                	add    (%eax),%al
    20a8:	31 0b                	xor    %ecx,(%ebx)
    20aa:	28 00                	sub    %al,(%eax)
    20ac:	08 00                	or     %al,(%eax)
    20ae:	00 00                	add    %al,(%eax)
    20b0:	3c 00                	cmp    $0x0,%al
    20b2:	00 00                	add    %al,(%eax)
    20b4:	00 00                	add    %al,(%eax)
    20b6:	00 00                	add    %al,(%eax)
    20b8:	17                   	pop    %ss
    20b9:	00 00                	add    %al,(%eax)
    20bb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    20c1:	00 00                	add    %al,(%eax)
    20c3:	00 41 00             	add    %al,0x0(%ecx)
    20c6:	00 00                	add    %al,(%eax)
    20c8:	80 00 00             	addb   $0x0,(%eax)
    20cb:	00 00                	add    %al,(%eax)
    20cd:	00 00                	add    %al,(%eax)
    20cf:	00 5b 00             	add    %bl,0x0(%ebx)
    20d2:	00 00                	add    %al,(%eax)
    20d4:	80 00 00             	addb   $0x0,(%eax)
    20d7:	00 00                	add    %al,(%eax)
    20d9:	00 00                	add    %al,(%eax)
    20db:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    20e1:	00 00                	add    %al,(%eax)
    20e3:	00 00                	add    %al,(%eax)
    20e5:	00 00                	add    %al,(%eax)
    20e7:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    20ed:	00 00                	add    %al,(%eax)
    20ef:	00 00                	add    %al,(%eax)
    20f1:	00 00                	add    %al,(%eax)
    20f3:	00 e1                	add    %ah,%cl
    20f5:	00 00                	add    %al,(%eax)
    20f7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    20fd:	00 00                	add    %al,(%eax)
    20ff:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2102:	00 00                	add    %al,(%eax)
    2104:	80 00 00             	addb   $0x0,(%eax)
    2107:	00 00                	add    %al,(%eax)
    2109:	00 00                	add    %al,(%eax)
    210b:	00 37                	add    %dh,(%edi)
    210d:	01 00                	add    %eax,(%eax)
    210f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2115:	00 00                	add    %al,(%eax)
    2117:	00 5d 01             	add    %bl,0x1(%ebp)
    211a:	00 00                	add    %al,(%eax)
    211c:	80 00 00             	addb   $0x0,(%eax)
    211f:	00 00                	add    %al,(%eax)
    2121:	00 00                	add    %al,(%eax)
    2123:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2129:	00 00                	add    %al,(%eax)
    212b:	00 00                	add    %al,(%eax)
    212d:	00 00                	add    %al,(%eax)
    212f:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2135:	00 00                	add    %al,(%eax)
    2137:	00 00                	add    %al,(%eax)
    2139:	00 00                	add    %al,(%eax)
    213b:	00 d2                	add    %dl,%dl
    213d:	01 00                	add    %eax,(%eax)
    213f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2145:	00 00                	add    %al,(%eax)
    2147:	00 ec                	add    %ch,%ah
    2149:	01 00                	add    %eax,(%eax)
    214b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2151:	00 00                	add    %al,(%eax)
    2153:	00 07                	add    %al,(%edi)
    2155:	02 00                	add    (%eax),%al
    2157:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    215d:	00 00                	add    %al,(%eax)
    215f:	00 28                	add    %ch,(%eax)
    2161:	02 00                	add    (%eax),%al
    2163:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2169:	00 00                	add    %al,(%eax)
    216b:	00 47 02             	add    %al,0x2(%edi)
    216e:	00 00                	add    %al,(%eax)
    2170:	80 00 00             	addb   $0x0,(%eax)
    2173:	00 00                	add    %al,(%eax)
    2175:	00 00                	add    %al,(%eax)
    2177:	00 66 02             	add    %ah,0x2(%esi)
    217a:	00 00                	add    %al,(%eax)
    217c:	80 00 00             	addb   $0x0,(%eax)
    217f:	00 00                	add    %al,(%eax)
    2181:	00 00                	add    %al,(%eax)
    2183:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2189:	00 00                	add    %al,(%eax)
    218b:	00 00                	add    %al,(%eax)
    218d:	00 00                	add    %al,(%eax)
    218f:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    2195:	00 00                	add    %al,(%eax)
    2197:	00 cf                	add    %cl,%bh
    2199:	a8 00                	test   $0x0,%al
    219b:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    21a1:	00 00                	add    %al,(%eax)
    21a3:	00 00                	add    %al,(%eax)
    21a5:	00 00                	add    %al,(%eax)
    21a7:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    21ad:	00 00                	add    %al,(%eax)
    21af:	00 37                	add    %dh,(%edi)
    21b1:	53                   	push   %ebx
    21b2:	00 00                	add    %al,(%eax)
    21b4:	11 04 00             	adc    %eax,(%eax,%eax,1)
    21b7:	00 c2                	add    %al,%dl
    21b9:	00 00                	add    %al,(%eax)
    21bb:	00 c8                	add    %cl,%al
    21bd:	3c 00                	cmp    $0x0,%al
    21bf:	00 f9                	add    %bh,%cl
    21c1:	0d 00 00 24 00       	or     $0x240000,%eax
    21c6:	00 00                	add    %al,(%eax)
    21c8:	31 0b                	xor    %ecx,(%ebx)
    21ca:	28 00                	sub    %al,(%eax)
    21cc:	00 00                	add    %al,(%eax)
    21ce:	00 00                	add    %al,(%eax)
    21d0:	44                   	inc    %esp
    21d1:	00 17                	add    %dl,(%edi)
    21d3:	00 00                	add    %al,(%eax)
    21d5:	00 00                	add    %al,(%eax)
    21d7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    21dd:	00 00                	add    %al,(%eax)
    21df:	00 32                	add    %dh,(%edx)
    21e1:	0b 28                	or     (%eax),%ebp
    21e3:	00 00                	add    %al,(%eax)
    21e5:	00 00                	add    %al,(%eax)
    21e7:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    21eb:	00 01                	add    %al,(%ecx)
    21ed:	00 00                	add    %al,(%eax)
    21ef:	00 f3                	add    %dh,%bl
    21f1:	0d 00 00 84 00       	or     $0x840000,%eax
    21f6:	00 00                	add    %al,(%eax)
    21f8:	37                   	aaa    
    21f9:	0b 28                	or     (%eax),%ebp
    21fb:	00 00                	add    %al,(%eax)
    21fd:	00 00                	add    %al,(%eax)
    21ff:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    2203:	00 06                	add    %al,(%esi)
    2205:	00 00                	add    %al,(%eax)
    2207:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    220d:	00 00                	add    %al,(%eax)
    220f:	00 39                	add    %bh,(%ecx)
    2211:	0b 28                	or     (%eax),%ebp
    2213:	00 00                	add    %al,(%eax)
    2215:	00 00                	add    %al,(%eax)
    2217:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    221b:	00 08                	add    %cl,(%eax)
    221d:	00 00                	add    %al,(%eax)
    221f:	00 f3                	add    %dh,%bl
    2221:	0d 00 00 84 00       	or     $0x840000,%eax
    2226:	00 00                	add    %al,(%eax)
    2228:	69 0b 28 00 00 00    	imul   $0x28,(%ebx),%ecx
    222e:	00 00                	add    %al,(%eax)
    2230:	44                   	inc    %esp
    2231:	00 5d 00             	add    %bl,0x0(%ebp)
    2234:	38 00                	cmp    %al,(%eax)
    2236:	00 00                	add    %al,(%eax)
    2238:	0a 0e                	or     (%esi),%cl
    223a:	00 00                	add    %al,(%eax)
    223c:	24 00                	and    $0x0,%al
    223e:	00 00                	add    %al,(%eax)
    2240:	6b 0b 28             	imul   $0x28,(%ebx),%ecx
    2243:	00 1f                	add    %bl,(%edi)
    2245:	0e                   	push   %cs
    2246:	00 00                	add    %al,(%eax)
    2248:	a0 00 00 00 08       	mov    0x8000000,%al
    224d:	00 00                	add    %al,(%eax)
    224f:	00 00                	add    %al,(%eax)
    2251:	00 00                	add    %al,(%eax)
    2253:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    2257:	00 00                	add    %al,(%eax)
    2259:	00 00                	add    %al,(%eax)
    225b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    2261:	00 00                	add    %al,(%eax)
    2263:	00 6c 0b 28          	add    %ch,0x28(%ebx,%ecx,1)
    2267:	00 00                	add    %al,(%eax)
    2269:	00 00                	add    %al,(%eax)
    226b:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    226f:	00 01                	add    %al,(%ecx)
    2271:	00 00                	add    %al,(%eax)
    2273:	00 f3                	add    %dh,%bl
    2275:	0d 00 00 84 00       	or     $0x840000,%eax
    227a:	00 00                	add    %al,(%eax)
    227c:	71 0b                	jno    2289 <bootmain-0x27dd77>
    227e:	28 00                	sub    %al,(%eax)
    2280:	00 00                	add    %al,(%eax)
    2282:	00 00                	add    %al,(%eax)
    2284:	44                   	inc    %esp
    2285:	00 64 00 06          	add    %ah,0x6(%eax,%eax,1)
    2289:	00 00                	add    %al,(%eax)
    228b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    2291:	00 00                	add    %al,(%eax)
    2293:	00 73 0b             	add    %dh,0xb(%ebx)
    2296:	28 00                	sub    %al,(%eax)
    2298:	00 00                	add    %al,(%eax)
    229a:	00 00                	add    %al,(%eax)
    229c:	44                   	inc    %esp
    229d:	00 6c 00 08          	add    %ch,0x8(%eax,%eax,1)
    22a1:	00 00                	add    %al,(%eax)
    22a3:	00 f3                	add    %dh,%bl
    22a5:	0d 00 00 84 00       	or     $0x840000,%eax
    22aa:	00 00                	add    %al,(%eax)
    22ac:	75 0b                	jne    22b9 <bootmain-0x27dd47>
    22ae:	28 00                	sub    %al,(%eax)
    22b0:	00 00                	add    %al,(%eax)
    22b2:	00 00                	add    %al,(%eax)
    22b4:	44                   	inc    %esp
    22b5:	00 64 00 0a          	add    %ah,0xa(%eax,%eax,1)
    22b9:	00 00                	add    %al,(%eax)
    22bb:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    22c1:	00 00                	add    %al,(%eax)
    22c3:	00 78 0b             	add    %bh,0xb(%eax)
    22c6:	28 00                	sub    %al,(%eax)
    22c8:	00 00                	add    %al,(%eax)
    22ca:	00 00                	add    %al,(%eax)
    22cc:	44                   	inc    %esp
    22cd:	00 6c 00 0d          	add    %ch,0xd(%eax,%eax,1)
    22d1:	00 00                	add    %al,(%eax)
    22d3:	00 00                	add    %al,(%eax)
    22d5:	00 00                	add    %al,(%eax)
    22d7:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    22db:	00 0e                	add    %cl,(%esi)
    22dd:	00 00                	add    %al,(%eax)
    22df:	00 f3                	add    %dh,%bl
    22e1:	0d 00 00 84 00       	or     $0x840000,%eax
    22e6:	00 00                	add    %al,(%eax)
    22e8:	7c 0b                	jl     22f5 <bootmain-0x27dd0b>
    22ea:	28 00                	sub    %al,(%eax)
    22ec:	00 00                	add    %al,(%eax)
    22ee:	00 00                	add    %al,(%eax)
    22f0:	44                   	inc    %esp
    22f1:	00 6a 00             	add    %ch,0x0(%edx)
    22f4:	11 00                	adc    %eax,(%eax)
    22f6:	00 00                	add    %al,(%eax)
    22f8:	00 00                	add    %al,(%eax)
    22fa:	00 00                	add    %al,(%eax)
    22fc:	44                   	inc    %esp
    22fd:	00 7c 00 22          	add    %bh,0x22(%eax,%eax,1)
    2301:	00 00                	add    %al,(%eax)
    2303:	00 32                	add    %dh,(%edx)
    2305:	0e                   	push   %cs
    2306:	00 00                	add    %al,(%eax)
    2308:	24 00                	and    $0x0,%al
    230a:	00 00                	add    %al,(%eax)
    230c:	8f                   	(bad)  
    230d:	0b 28                	or     (%eax),%ebp
    230f:	00 47 0e             	add    %al,0xe(%edi)
    2312:	00 00                	add    %al,(%eax)
    2314:	a0 00 00 00 08       	mov    0x8000000,%al
    2319:	00 00                	add    %al,(%eax)
    231b:	00 00                	add    %al,(%eax)
    231d:	00 00                	add    %al,(%eax)
    231f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
    2323:	00 00                	add    %al,(%eax)
    2325:	00 00                	add    %al,(%eax)
    2327:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    232d:	00 00                	add    %al,(%eax)
    232f:	00 90 0b 28 00 00    	add    %dl,0x280b(%eax)
    2335:	00 00                	add    %al,(%eax)
    2337:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    233b:	00 01                	add    %al,(%ecx)
    233d:	00 00                	add    %al,(%eax)
    233f:	00 f3                	add    %dh,%bl
    2341:	0d 00 00 84 00       	or     $0x840000,%eax
    2346:	00 00                	add    %al,(%eax)
    2348:	95                   	xchg   %eax,%ebp
    2349:	0b 28                	or     (%eax),%ebp
    234b:	00 00                	add    %al,(%eax)
    234d:	00 00                	add    %al,(%eax)
    234f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
    2353:	00 06                	add    %al,(%esi)
    2355:	00 00                	add    %al,(%eax)
    2357:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    235d:	00 00                	add    %al,(%eax)
    235f:	00 97 0b 28 00 00    	add    %dl,0x280b(%edi)
    2365:	00 00                	add    %al,(%eax)
    2367:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    236b:	00 08                	add    %cl,(%eax)
    236d:	00 00                	add    %al,(%eax)
    236f:	00 f3                	add    %dh,%bl
    2371:	0d 00 00 84 00       	or     $0x840000,%eax
    2376:	00 00                	add    %al,(%eax)
    2378:	99                   	cltd   
    2379:	0b 28                	or     (%eax),%ebp
    237b:	00 00                	add    %al,(%eax)
    237d:	00 00                	add    %al,(%eax)
    237f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
    2383:	00 0a                	add    %cl,(%edx)
    2385:	00 00                	add    %al,(%eax)
    2387:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    238d:	00 00                	add    %al,(%eax)
    238f:	00 9c 0b 28 00 00 00 	add    %bl,0x28(%ebx,%ecx,1)
    2396:	00 00                	add    %al,(%eax)
    2398:	44                   	inc    %esp
    2399:	00 6c 00 0d          	add    %ch,0xd(%eax,%eax,1)
    239d:	00 00                	add    %al,(%eax)
    239f:	00 00                	add    %al,(%eax)
    23a1:	00 00                	add    %al,(%eax)
    23a3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    23a7:	00 13                	add    %dl,(%ebx)
    23a9:	00 00                	add    %al,(%eax)
    23ab:	00 f3                	add    %dh,%bl
    23ad:	0d 00 00 84 00       	or     $0x840000,%eax
    23b2:	00 00                	add    %al,(%eax)
    23b4:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    23b5:	0b 28                	or     (%eax),%ebp
    23b7:	00 00                	add    %al,(%eax)
    23b9:	00 00                	add    %al,(%eax)
    23bb:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    23bf:	00 16                	add    %dl,(%esi)
    23c1:	00 00                	add    %al,(%eax)
    23c3:	00 00                	add    %al,(%eax)
    23c5:	00 00                	add    %al,(%eax)
    23c7:	00 44 00 92          	add    %al,-0x6e(%eax,%eax,1)
    23cb:	00 27                	add    %ah,(%edi)
    23cd:	00 00                	add    %al,(%eax)
    23cf:	00 53 0e             	add    %dl,0xe(%ebx)
    23d2:	00 00                	add    %al,(%eax)
    23d4:	24 00                	and    $0x0,%al
    23d6:	00 00                	add    %al,(%eax)
    23d8:	b8 0b 28 00 00       	mov    $0x280b,%eax
    23dd:	00 00                	add    %al,(%eax)
    23df:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    23e3:	00 00                	add    %al,(%eax)
    23e5:	00 00                	add    %al,(%eax)
    23e7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    23ed:	00 00                	add    %al,(%eax)
    23ef:	00 b9 0b 28 00 00    	add    %bh,0x280b(%ecx)
    23f5:	00 00                	add    %al,(%eax)
    23f7:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    23fb:	00 01                	add    %al,(%ecx)
    23fd:	00 00                	add    %al,(%eax)
    23ff:	00 f3                	add    %dh,%bl
    2401:	0d 00 00 84 00       	or     $0x840000,%eax
    2406:	00 00                	add    %al,(%eax)
    2408:	be 0b 28 00 00       	mov    $0x280b,%esi
    240d:	00 00                	add    %al,(%eax)
    240f:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    2413:	00 06                	add    %al,(%esi)
    2415:	00 00                	add    %al,(%eax)
    2417:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    241d:	00 00                	add    %al,(%eax)
    241f:	00 c0                	add    %al,%al
    2421:	0b 28                	or     (%eax),%ebp
    2423:	00 00                	add    %al,(%eax)
    2425:	00 00                	add    %al,(%eax)
    2427:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    242b:	00 08                	add    %cl,(%eax)
    242d:	00 00                	add    %al,(%eax)
    242f:	00 f3                	add    %dh,%bl
    2431:	0d 00 00 84 00       	or     $0x840000,%eax
    2436:	00 00                	add    %al,(%eax)
    2438:	c1 0b 28             	rorl   $0x28,(%ebx)
    243b:	00 00                	add    %al,(%eax)
    243d:	00 00                	add    %al,(%eax)
    243f:	00 44 00 a2          	add    %al,-0x5e(%eax,%eax,1)
    2443:	00 09                	add    %cl,(%ecx)
    2445:	00 00                	add    %al,(%eax)
    2447:	00 00                	add    %al,(%eax)
    2449:	00 00                	add    %al,(%eax)
    244b:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
    244f:	00 0d 00 00 00 6e    	add    %cl,0x6e000000
    2455:	0e                   	push   %cs
    2456:	00 00                	add    %al,(%eax)
    2458:	24 00                	and    $0x0,%al
    245a:	00 00                	add    %al,(%eax)
    245c:	c7                   	(bad)  
    245d:	0b 28                	or     (%eax),%ebp
    245f:	00 00                	add    %al,(%eax)
    2461:	00 00                	add    %al,(%eax)
    2463:	00 44 00 ab          	add    %al,-0x55(%eax,%eax,1)
	...
    246f:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    2473:	00 03                	add    %al,(%ebx)
    2475:	00 00                	add    %al,(%eax)
    2477:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    247d:	00 00                	add    %al,(%eax)
    247f:	00 cf                	add    %cl,%bh
    2481:	0b 28                	or     (%eax),%ebp
    2483:	00 00                	add    %al,(%eax)
    2485:	00 00                	add    %al,(%eax)
    2487:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    248b:	00 08                	add    %cl,(%eax)
    248d:	00 00                	add    %al,(%eax)
    248f:	00 f3                	add    %dh,%bl
    2491:	0d 00 00 84 00       	or     $0x840000,%eax
    2496:	00 00                	add    %al,(%eax)
    2498:	d7                   	xlat   %ds:(%ebx)
    2499:	0b 28                	or     (%eax),%ebp
    249b:	00 00                	add    %al,(%eax)
    249d:	00 00                	add    %al,(%eax)
    249f:	00 44 00 af          	add    %al,-0x51(%eax,%eax,1)
    24a3:	00 10                	add    %dl,(%eax)
    24a5:	00 00                	add    %al,(%eax)
    24a7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    24ad:	00 00                	add    %al,(%eax)
    24af:	00 dc                	add    %bl,%ah
    24b1:	0b 28                	or     (%eax),%ebp
    24b3:	00 00                	add    %al,(%eax)
    24b5:	00 00                	add    %al,(%eax)
    24b7:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    24bb:	00 15 00 00 00 f3    	add    %dl,0xf3000000
    24c1:	0d 00 00 84 00       	or     $0x840000,%eax
    24c6:	00 00                	add    %al,(%eax)
    24c8:	e4 0b                	in     $0xb,%al
    24ca:	28 00                	sub    %al,(%eax)
    24cc:	00 00                	add    %al,(%eax)
    24ce:	00 00                	add    %al,(%eax)
    24d0:	44                   	inc    %esp
    24d1:	00 b3 00 1d 00 00    	add    %dh,0x1d00(%ebx)
    24d7:	00 84 0e 00 00 20 00 	add    %al,0x200000(%esi,%ecx,1)
    24de:	00 00                	add    %al,(%eax)
    24e0:	00 00                	add    %al,(%eax)
    24e2:	00 00                	add    %al,(%eax)
    24e4:	93                   	xchg   %eax,%ebx
    24e5:	0e                   	push   %cs
    24e6:	00 00                	add    %al,(%eax)
    24e8:	20 00                	and    %al,(%eax)
	...
    24f2:	00 00                	add    %al,(%eax)
    24f4:	64 00 00             	add    %al,%fs:(%eax)
    24f7:	00 e6                	add    %ah,%dh
    24f9:	0b 28                	or     (%eax),%ebp
    24fb:	00 a4 0e 00 00 64 00 	add    %ah,0x640000(%esi,%ecx,1)
    2502:	00 00                	add    %al,(%eax)
    2504:	e6 0b                	out    %al,$0xb
    2506:	28 00                	sub    %al,(%eax)
    2508:	b4 0e                	mov    $0xe,%ah
    250a:	00 00                	add    %al,(%eax)
    250c:	84 00                	test   %al,(%eax)
    250e:	00 00                	add    %al,(%eax)
    2510:	e6 0b                	out    %al,$0xb
    2512:	28 00                	sub    %al,(%eax)
    2514:	00 00                	add    %al,(%eax)
    2516:	00 00                	add    %al,(%eax)
    2518:	44                   	inc    %esp
    2519:	00 09                	add    %cl,(%ecx)
    251b:	00 e6                	add    %ah,%dh
    251d:	0b 28                	or     (%eax),%ebp
    251f:	00 00                	add    %al,(%eax)
    2521:	00 00                	add    %al,(%eax)
    2523:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    2527:	00 e8                	add    %ch,%al
    2529:	0b 28                	or     (%eax),%ebp
    252b:	00 00                	add    %al,(%eax)
    252d:	00 00                	add    %al,(%eax)
    252f:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    2533:	00 ea                	add    %ch,%dl
    2535:	0b 28                	or     (%eax),%ebp
    2537:	00 00                	add    %al,(%eax)
    2539:	00 00                	add    %al,(%eax)
    253b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    253f:	00 eb                	add    %ch,%bl
    2541:	0b 28                	or     (%eax),%ebp
    2543:	00 00                	add    %al,(%eax)
    2545:	00 00                	add    %al,(%eax)
    2547:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    254b:	00 ed                	add    %ch,%ch
    254d:	0b 28                	or     (%eax),%ebp
    254f:	00 00                	add    %al,(%eax)
    2551:	00 00                	add    %al,(%eax)
    2553:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    2557:	00 ee                	add    %ch,%dh
    2559:	0b 28                	or     (%eax),%ebp
    255b:	00 00                	add    %al,(%eax)
    255d:	00 00                	add    %al,(%eax)
    255f:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    2563:	00 f1                	add    %dh,%cl
    2565:	0b 28                	or     (%eax),%ebp
    2567:	00 00                	add    %al,(%eax)
    2569:	00 00                	add    %al,(%eax)
    256b:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    256f:	00 f3                	add    %dh,%bl
    2571:	0b 28                	or     (%eax),%ebp
    2573:	00 00                	add    %al,(%eax)
    2575:	00 00                	add    %al,(%eax)
    2577:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    257b:	00 f5                	add    %dh,%ch
    257d:	0b 28                	or     (%eax),%ebp
    257f:	00 00                	add    %al,(%eax)
    2581:	00 00                	add    %al,(%eax)
    2583:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2587:	00 fa                	add    %bh,%dl
    2589:	0b 28                	or     (%eax),%ebp
    258b:	00 00                	add    %al,(%eax)
    258d:	00 00                	add    %al,(%eax)
    258f:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    2593:	00 fb                	add    %bh,%bl
    2595:	0b 28                	or     (%eax),%ebp
    2597:	00 00                	add    %al,(%eax)
    2599:	00 00                	add    %al,(%eax)
    259b:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    259f:	00 fc                	add    %bh,%ah
    25a1:	0b 28                	or     (%eax),%ebp
    25a3:	00 00                	add    %al,(%eax)
    25a5:	00 00                	add    %al,(%eax)
    25a7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    25ab:	00 fe                	add    %bh,%dh
    25ad:	0b 28                	or     (%eax),%ebp
    25af:	00 00                	add    %al,(%eax)
    25b1:	00 00                	add    %al,(%eax)
    25b3:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    25b7:	00 00                	add    %al,(%eax)
    25b9:	0c 28                	or     $0x28,%al
    25bb:	00 00                	add    %al,(%eax)
    25bd:	00 00                	add    %al,(%eax)
    25bf:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    25c3:	00 01                	add    %al,(%ecx)
    25c5:	0c 28                	or     $0x28,%al
    25c7:	00 00                	add    %al,(%eax)
    25c9:	00 00                	add    %al,(%eax)
    25cb:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    25cf:	00 03                	add    %al,(%ebx)
    25d1:	0c 28                	or     $0x28,%al
    25d3:	00 00                	add    %al,(%eax)
    25d5:	00 00                	add    %al,(%eax)
    25d7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    25db:	00 05 0c 28 00 00    	add    %al,0x280c
    25e1:	00 00                	add    %al,(%eax)
    25e3:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    25e7:	00 06                	add    %al,(%esi)
    25e9:	0c 28                	or     $0x28,%al
    25eb:	00 00                	add    %al,(%eax)
    25ed:	00 00                	add    %al,(%eax)
    25ef:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    25f3:	00 08                	add    %cl,(%eax)
    25f5:	0c 28                	or     $0x28,%al
    25f7:	00 00                	add    %al,(%eax)
    25f9:	00 00                	add    %al,(%eax)
    25fb:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    25ff:	00 09                	add    %cl,(%ecx)
    2601:	0c 28                	or     $0x28,%al
    2603:	00 00                	add    %al,(%eax)
    2605:	00 00                	add    %al,(%eax)
    2607:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    260b:	00 0c 0c             	add    %cl,(%esp,%ecx,1)
    260e:	28 00                	sub    %al,(%eax)
    2610:	00 00                	add    %al,(%eax)
    2612:	00 00                	add    %al,(%eax)
    2614:	44                   	inc    %esp
    2615:	00 22                	add    %ah,(%edx)
    2617:	00 0e                	add    %cl,(%esi)
    2619:	0c 28                	or     $0x28,%al
    261b:	00 00                	add    %al,(%eax)
    261d:	00 00                	add    %al,(%eax)
    261f:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2623:	00 10                	add    %dl,(%eax)
    2625:	0c 28                	or     $0x28,%al
    2627:	00 00                	add    %al,(%eax)
    2629:	00 00                	add    %al,(%eax)
    262b:	00 44 00 25          	add    %al,0x25(%eax,%eax,1)
    262f:	00 15 0c 28 00 00    	add    %dl,0x280c
    2635:	00 00                	add    %al,(%eax)
    2637:	00 44 00 26          	add    %al,0x26(%eax,%eax,1)
    263b:	00 16                	add    %dl,(%esi)
    263d:	0c 28                	or     $0x28,%al
    263f:	00 00                	add    %al,(%eax)
    2641:	00 00                	add    %al,(%eax)
    2643:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    2647:	00 17                	add    %dl,(%edi)
    2649:	0c 28                	or     $0x28,%al
    264b:	00 00                	add    %al,(%eax)
    264d:	00 00                	add    %al,(%eax)
    264f:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    2653:	00 19                	add    %bl,(%ecx)
    2655:	0c 28                	or     $0x28,%al
    2657:	00 00                	add    %al,(%eax)
    2659:	00 00                	add    %al,(%eax)
    265b:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    265f:	00 1b                	add    %bl,(%ebx)
    2661:	0c 28                	or     $0x28,%al
    2663:	00 00                	add    %al,(%eax)
    2665:	00 00                	add    %al,(%eax)
    2667:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    266b:	00 1c 0c             	add    %bl,(%esp,%ecx,1)
    266e:	28 00                	sub    %al,(%eax)
    2670:	00 00                	add    %al,(%eax)
    2672:	00 00                	add    %al,(%eax)
    2674:	44                   	inc    %esp
    2675:	00 2d 00 21 0c 28    	add    %ch,0x280c2100
    267b:	00 00                	add    %al,(%eax)
    267d:	00 00                	add    %al,(%eax)
    267f:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    2683:	00 26                	add    %ah,(%esi)
    2685:	0c 28                	or     $0x28,%al
    2687:	00 00                	add    %al,(%eax)
    2689:	00 00                	add    %al,(%eax)
    268b:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    268f:	00 2b                	add    %ch,(%ebx)
    2691:	0c 28                	or     $0x28,%al
    2693:	00 00                	add    %al,(%eax)
    2695:	00 00                	add    %al,(%eax)
    2697:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    269b:	00 2c 0c             	add    %ch,(%esp,%ecx,1)
    269e:	28 00                	sub    %al,(%eax)
    26a0:	00 00                	add    %al,(%eax)
    26a2:	00 00                	add    %al,(%eax)
    26a4:	44                   	inc    %esp
    26a5:	00 34 00             	add    %dh,(%eax,%eax,1)
    26a8:	31 0c 28             	xor    %ecx,(%eax,%ebp,1)
    26ab:	00 00                	add    %al,(%eax)
    26ad:	00 00                	add    %al,(%eax)
    26af:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    26b3:	00 36                	add    %dh,(%esi)
    26b5:	0c 28                	or     $0x28,%al
    26b7:	00 00                	add    %al,(%eax)
    26b9:	00 00                	add    %al,(%eax)
    26bb:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    26bf:	00 3b                	add    %bh,(%ebx)
    26c1:	0c 28                	or     $0x28,%al
    26c3:	00 bf 0e 00 00 64    	add    %bh,0x6400000e(%edi)
    26c9:	00 02                	add    %al,(%edx)
    26cb:	00 3c 0c             	add    %bh,(%esp,%ecx,1)
    26ce:	28 00                	sub    %al,(%eax)
    26d0:	08 00                	or     %al,(%eax)
    26d2:	00 00                	add    %al,(%eax)
    26d4:	3c 00                	cmp    $0x0,%al
    26d6:	00 00                	add    %al,(%eax)
    26d8:	00 00                	add    %al,(%eax)
    26da:	00 00                	add    %al,(%eax)
    26dc:	17                   	pop    %ss
    26dd:	00 00                	add    %al,(%eax)
    26df:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    26e5:	00 00                	add    %al,(%eax)
    26e7:	00 41 00             	add    %al,0x0(%ecx)
    26ea:	00 00                	add    %al,(%eax)
    26ec:	80 00 00             	addb   $0x0,(%eax)
    26ef:	00 00                	add    %al,(%eax)
    26f1:	00 00                	add    %al,(%eax)
    26f3:	00 5b 00             	add    %bl,0x0(%ebx)
    26f6:	00 00                	add    %al,(%eax)
    26f8:	80 00 00             	addb   $0x0,(%eax)
    26fb:	00 00                	add    %al,(%eax)
    26fd:	00 00                	add    %al,(%eax)
    26ff:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2705:	00 00                	add    %al,(%eax)
    2707:	00 00                	add    %al,(%eax)
    2709:	00 00                	add    %al,(%eax)
    270b:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2711:	00 00                	add    %al,(%eax)
    2713:	00 00                	add    %al,(%eax)
    2715:	00 00                	add    %al,(%eax)
    2717:	00 e1                	add    %ah,%cl
    2719:	00 00                	add    %al,(%eax)
    271b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2721:	00 00                	add    %al,(%eax)
    2723:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2726:	00 00                	add    %al,(%eax)
    2728:	80 00 00             	addb   $0x0,(%eax)
    272b:	00 00                	add    %al,(%eax)
    272d:	00 00                	add    %al,(%eax)
    272f:	00 37                	add    %dh,(%edi)
    2731:	01 00                	add    %eax,(%eax)
    2733:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2739:	00 00                	add    %al,(%eax)
    273b:	00 5d 01             	add    %bl,0x1(%ebp)
    273e:	00 00                	add    %al,(%eax)
    2740:	80 00 00             	addb   $0x0,(%eax)
    2743:	00 00                	add    %al,(%eax)
    2745:	00 00                	add    %al,(%eax)
    2747:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    274d:	00 00                	add    %al,(%eax)
    274f:	00 00                	add    %al,(%eax)
    2751:	00 00                	add    %al,(%eax)
    2753:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2759:	00 00                	add    %al,(%eax)
    275b:	00 00                	add    %al,(%eax)
    275d:	00 00                	add    %al,(%eax)
    275f:	00 d2                	add    %dl,%dl
    2761:	01 00                	add    %eax,(%eax)
    2763:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2769:	00 00                	add    %al,(%eax)
    276b:	00 ec                	add    %ch,%ah
    276d:	01 00                	add    %eax,(%eax)
    276f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2775:	00 00                	add    %al,(%eax)
    2777:	00 07                	add    %al,(%edi)
    2779:	02 00                	add    (%eax),%al
    277b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2781:	00 00                	add    %al,(%eax)
    2783:	00 28                	add    %ch,(%eax)
    2785:	02 00                	add    (%eax),%al
    2787:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    278d:	00 00                	add    %al,(%eax)
    278f:	00 47 02             	add    %al,0x2(%edi)
    2792:	00 00                	add    %al,(%eax)
    2794:	80 00 00             	addb   $0x0,(%eax)
    2797:	00 00                	add    %al,(%eax)
    2799:	00 00                	add    %al,(%eax)
    279b:	00 66 02             	add    %ah,0x2(%esi)
    279e:	00 00                	add    %al,(%eax)
    27a0:	80 00 00             	addb   $0x0,(%eax)
    27a3:	00 00                	add    %al,(%eax)
    27a5:	00 00                	add    %al,(%eax)
    27a7:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    27ad:	00 00                	add    %al,(%eax)
    27af:	00 00                	add    %al,(%eax)
    27b1:	00 00                	add    %al,(%eax)
    27b3:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    27b9:	00 00                	add    %al,(%eax)
    27bb:	00 cf                	add    %cl,%bh
    27bd:	a8 00                	test   $0x0,%al
    27bf:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    27c5:	00 00                	add    %al,(%eax)
    27c7:	00 00                	add    %al,(%eax)
    27c9:	00 00                	add    %al,(%eax)
    27cb:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    27d1:	00 00                	add    %al,(%eax)
    27d3:	00 37                	add    %dh,(%edi)
    27d5:	53                   	push   %ebx
    27d6:	00 00                	add    %al,(%eax)
    27d8:	11 04 00             	adc    %eax,(%eax,%eax,1)
    27db:	00 c2                	add    %al,%dl
    27dd:	00 00                	add    %al,(%eax)
    27df:	00 c8                	add    %cl,%al
    27e1:	3c 00                	cmp    $0x0,%al
    27e3:	00 c6                	add    %al,%dh
    27e5:	0e                   	push   %cs
    27e6:	00 00                	add    %al,(%eax)
    27e8:	24 00                	and    $0x0,%al
    27ea:	00 00                	add    %al,(%eax)
    27ec:	3c 0c                	cmp    $0xc,%al
    27ee:	28 00                	sub    %al,(%eax)
    27f0:	d9 0e                	(bad)  (%esi)
    27f2:	00 00                	add    %al,(%eax)
    27f4:	a0 00 00 00 08       	mov    0x8000000,%al
    27f9:	00 00                	add    %al,(%eax)
    27fb:	00 ed                	add    %ch,%ch
    27fd:	0e                   	push   %cs
    27fe:	00 00                	add    %al,(%eax)
    2800:	a0 00 00 00 0c       	mov    0xc000000,%al
    2805:	00 00                	add    %al,(%eax)
    2807:	00 f9                	add    %bh,%cl
    2809:	0e                   	push   %cs
    280a:	00 00                	add    %al,(%eax)
    280c:	a0 00 00 00 10       	mov    0x10000000,%al
    2811:	00 00                	add    %al,(%eax)
    2813:	00 00                	add    %al,(%eax)
    2815:	00 00                	add    %al,(%eax)
    2817:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    2823:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
    2827:	00 03                	add    %al,(%ebx)
    2829:	00 00                	add    %al,(%eax)
    282b:	00 00                	add    %al,(%eax)
    282d:	00 00                	add    %al,(%eax)
    282f:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2833:	00 09                	add    %cl,(%ecx)
    2835:	00 00                	add    %al,(%eax)
    2837:	00 00                	add    %al,(%eax)
    2839:	00 00                	add    %al,(%eax)
    283b:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
    283f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2842:	00 00                	add    %al,(%eax)
    2844:	00 00                	add    %al,(%eax)
    2846:	00 00                	add    %al,(%eax)
    2848:	44                   	inc    %esp
    2849:	00 07                	add    %al,(%edi)
    284b:	00 13                	add    %dl,(%ebx)
    284d:	00 00                	add    %al,(%eax)
    284f:	00 00                	add    %al,(%eax)
    2851:	00 00                	add    %al,(%eax)
    2853:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
    2857:	00 16                	add    %dl,(%esi)
    2859:	00 00                	add    %al,(%eax)
    285b:	00 00                	add    %al,(%eax)
    285d:	00 00                	add    %al,(%eax)
    285f:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    2863:	00 18                	add    %bl,(%eax)
    2865:	00 00                	add    %al,(%eax)
    2867:	00 00                	add    %al,(%eax)
    2869:	00 00                	add    %al,(%eax)
    286b:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    286f:	00 1b                	add    %bl,(%ebx)
    2871:	00 00                	add    %al,(%eax)
    2873:	00 00                	add    %al,(%eax)
    2875:	00 00                	add    %al,(%eax)
    2877:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    287b:	00 22                	add    %ah,(%edx)
    287d:	00 00                	add    %al,(%eax)
    287f:	00 00                	add    %al,(%eax)
    2881:	00 00                	add    %al,(%eax)
    2883:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    2887:	00 29                	add    %ch,(%ecx)
    2889:	00 00                	add    %al,(%eax)
    288b:	00 04 0f             	add    %al,(%edi,%ecx,1)
    288e:	00 00                	add    %al,(%eax)
    2890:	40                   	inc    %eax
    2891:	00 00                	add    %al,(%eax)
    2893:	00 00                	add    %al,(%eax)
    2895:	00 00                	add    %al,(%eax)
    2897:	00 11                	add    %dl,(%ecx)
    2899:	0f 00 00             	sldt   (%eax)
    289c:	40                   	inc    %eax
    289d:	00 00                	add    %al,(%eax)
    289f:	00 02                	add    %al,(%edx)
    28a1:	00 00                	add    %al,(%eax)
    28a3:	00 1d 0f 00 00 40    	add    %bl,0x4000000f
    28a9:	00 00                	add    %al,(%eax)
    28ab:	00 01                	add    %al,(%ecx)
    28ad:	00 00                	add    %al,(%eax)
    28af:	00 28                	add    %ch,(%eax)
    28b1:	0f 00 00             	sldt   (%eax)
    28b4:	24 00                	and    $0x0,%al
    28b6:	00 00                	add    %al,(%eax)
    28b8:	67 0c 28             	addr16 or $0x28,%al
    28bb:	00 3b                	add    %bh,(%ebx)
    28bd:	0f 00 00             	sldt   (%eax)
    28c0:	a0 00 00 00 08       	mov    0x8000000,%al
    28c5:	00 00                	add    %al,(%eax)
    28c7:	00 48 0f             	add    %cl,0xf(%eax)
    28ca:	00 00                	add    %al,(%eax)
    28cc:	a0 00 00 00 0c       	mov    0xc000000,%al
    28d1:	00 00                	add    %al,(%eax)
    28d3:	00 00                	add    %al,(%eax)
    28d5:	00 00                	add    %al,(%eax)
    28d7:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
	...
    28e3:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    28e7:	00 07                	add    %al,(%edi)
    28e9:	00 00                	add    %al,(%eax)
    28eb:	00 00                	add    %al,(%eax)
    28ed:	00 00                	add    %al,(%eax)
    28ef:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    28f3:	00 0a                	add    %cl,(%edx)
    28f5:	00 00                	add    %al,(%eax)
    28f7:	00 00                	add    %al,(%eax)
    28f9:	00 00                	add    %al,(%eax)
    28fb:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
    28ff:	00 10                	add    %dl,(%eax)
    2901:	00 00                	add    %al,(%eax)
    2903:	00 00                	add    %al,(%eax)
    2905:	00 00                	add    %al,(%eax)
    2907:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    290b:	00 14 00             	add    %dl,(%eax,%eax,1)
    290e:	00 00                	add    %al,(%eax)
    2910:	00 00                	add    %al,(%eax)
    2912:	00 00                	add    %al,(%eax)
    2914:	44                   	inc    %esp
    2915:	00 1a                	add    %bl,(%edx)
    2917:	00 19                	add    %bl,(%ecx)
    2919:	00 00                	add    %al,(%eax)
    291b:	00 00                	add    %al,(%eax)
    291d:	00 00                	add    %al,(%eax)
    291f:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2923:	00 21                	add    %ah,(%ecx)
    2925:	00 00                	add    %al,(%eax)
    2927:	00 00                	add    %al,(%eax)
    2929:	00 00                	add    %al,(%eax)
    292b:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    292f:	00 27                	add    %ah,(%edi)
    2931:	00 00                	add    %al,(%eax)
    2933:	00 00                	add    %al,(%eax)
    2935:	00 00                	add    %al,(%eax)
    2937:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    293b:	00 2a                	add    %ch,(%edx)
    293d:	00 00                	add    %al,(%eax)
    293f:	00 00                	add    %al,(%eax)
    2941:	00 00                	add    %al,(%eax)
    2943:	00 44 00 1c          	add    %al,0x1c(%eax,%eax,1)
    2947:	00 2d 00 00 00 00    	add    %ch,0x0
    294d:	00 00                	add    %al,(%eax)
    294f:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2953:	00 2f                	add    %ch,(%edi)
    2955:	00 00                	add    %al,(%eax)
    2957:	00 00                	add    %al,(%eax)
    2959:	00 00                	add    %al,(%eax)
    295b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    295f:	00 36                	add    %dh,(%esi)
    2961:	00 00                	add    %al,(%eax)
    2963:	00 00                	add    %al,(%eax)
    2965:	00 00                	add    %al,(%eax)
    2967:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    296b:	00 39                	add    %bh,(%ecx)
    296d:	00 00                	add    %al,(%eax)
    296f:	00 00                	add    %al,(%eax)
    2971:	00 00                	add    %al,(%eax)
    2973:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2977:	00 3b                	add    %bh,(%ebx)
    2979:	00 00                	add    %al,(%eax)
    297b:	00 04 0f             	add    %al,(%edi,%ecx,1)
    297e:	00 00                	add    %al,(%eax)
    2980:	40                   	inc    %eax
    2981:	00 00                	add    %al,(%eax)
    2983:	00 00                	add    %al,(%eax)
    2985:	00 00                	add    %al,(%eax)
    2987:	00 54 0f 00          	add    %dl,0x0(%edi,%ecx,1)
    298b:	00 24 00             	add    %ah,(%eax,%eax,1)
    298e:	00 00                	add    %al,(%eax)
    2990:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    2991:	0c 28                	or     $0x28,%al
    2993:	00 3b                	add    %bh,(%ebx)
    2995:	0f 00 00             	sldt   (%eax)
    2998:	a0 00 00 00 08       	mov    0x8000000,%al
    299d:	00 00                	add    %al,(%eax)
    299f:	00 00                	add    %al,(%eax)
    29a1:	00 00                	add    %al,(%eax)
    29a3:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
	...
    29af:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    29b3:	00 09                	add    %cl,(%ecx)
    29b5:	00 00                	add    %al,(%eax)
    29b7:	00 00                	add    %al,(%eax)
    29b9:	00 00                	add    %al,(%eax)
    29bb:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    29bf:	00 13                	add    %dl,(%ebx)
    29c1:	00 00                	add    %al,(%eax)
    29c3:	00 00                	add    %al,(%eax)
    29c5:	00 00                	add    %al,(%eax)
    29c7:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    29cb:	00 16                	add    %dl,(%esi)
    29cd:	00 00                	add    %al,(%eax)
    29cf:	00 00                	add    %al,(%eax)
    29d1:	00 00                	add    %al,(%eax)
    29d3:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    29d7:	00 18                	add    %bl,(%eax)
    29d9:	00 00                	add    %al,(%eax)
    29db:	00 00                	add    %al,(%eax)
    29dd:	00 00                	add    %al,(%eax)
    29df:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
    29e3:	00 1e                	add    %bl,(%esi)
    29e5:	00 00                	add    %al,(%eax)
    29e7:	00 00                	add    %al,(%eax)
    29e9:	00 00                	add    %al,(%eax)
    29eb:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    29ef:	00 24 00             	add    %ah,(%eax,%eax,1)
    29f2:	00 00                	add    %al,(%eax)
    29f4:	00 00                	add    %al,(%eax)
    29f6:	00 00                	add    %al,(%eax)
    29f8:	44                   	inc    %esp
    29f9:	00 2f                	add    %ch,(%edi)
    29fb:	00 25 00 00 00 00    	add    %ah,0x0
    2a01:	00 00                	add    %al,(%eax)
    2a03:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2a07:	00 28                	add    %ch,(%eax)
    2a09:	00 00                	add    %al,(%eax)
    2a0b:	00 00                	add    %al,(%eax)
    2a0d:	00 00                	add    %al,(%eax)
    2a0f:	00 44 00 36          	add    %al,0x36(%eax,%eax,1)
    2a13:	00 2b                	add    %ch,(%ebx)
    2a15:	00 00                	add    %al,(%eax)
    2a17:	00 00                	add    %al,(%eax)
    2a19:	00 00                	add    %al,(%eax)
    2a1b:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    2a1f:	00 2d 00 00 00 00    	add    %ch,0x0
    2a25:	00 00                	add    %al,(%eax)
    2a27:	00 44 00 39          	add    %al,0x39(%eax,%eax,1)
    2a2b:	00 30                	add    %dh,(%eax)
    2a2d:	00 00                	add    %al,(%eax)
    2a2f:	00 66 0f             	add    %ah,0xf(%esi)
    2a32:	00 00                	add    %al,(%eax)
    2a34:	40                   	inc    %eax
    2a35:	00 00                	add    %al,(%eax)
    2a37:	00 00                	add    %al,(%eax)
    2a39:	00 00                	add    %al,(%eax)
    2a3b:	00 04 0f             	add    %al,(%edi,%ecx,1)
    2a3e:	00 00                	add    %al,(%eax)
    2a40:	40                   	inc    %eax
    2a41:	00 00                	add    %al,(%eax)
    2a43:	00 02                	add    %al,(%edx)
    2a45:	00 00                	add    %al,(%eax)
    2a47:	00 00                	add    %al,(%eax)
    2a49:	00 00                	add    %al,(%eax)
    2a4b:	00 c0                	add    %al,%al
	...
    2a55:	00 00                	add    %al,(%eax)
    2a57:	00 e0                	add    %ah,%al
    2a59:	00 00                	add    %al,(%eax)
    2a5b:	00 35 00 00 00 72    	add    %dh,0x72000000
    2a61:	0f 00 00             	sldt   (%eax)
    2a64:	24 00                	and    $0x0,%al
    2a66:	00 00                	add    %al,(%eax)
    2a68:	da 0c 28             	fimull (%eax,%ebp,1)
    2a6b:	00 3b                	add    %bh,(%ebx)
    2a6d:	0f 00 00             	sldt   (%eax)
    2a70:	a0 00 00 00 08       	mov    0x8000000,%al
    2a75:	00 00                	add    %al,(%eax)
    2a77:	00 00                	add    %al,(%eax)
    2a79:	00 00                	add    %al,(%eax)
    2a7b:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
	...
    2a87:	00 44 00 3c          	add    %al,0x3c(%eax,%eax,1)
    2a8b:	00 03                	add    %al,(%ebx)
    2a8d:	00 00                	add    %al,(%eax)
    2a8f:	00 00                	add    %al,(%eax)
    2a91:	00 00                	add    %al,(%eax)
    2a93:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2a97:	00 06                	add    %al,(%esi)
    2a99:	00 00                	add    %al,(%eax)
    2a9b:	00 00                	add    %al,(%eax)
    2a9d:	00 00                	add    %al,(%eax)
    2a9f:	00 44 00 3d          	add    %al,0x3d(%eax,%eax,1)
    2aa3:	00 07                	add    %al,(%edi)
    2aa5:	00 00                	add    %al,(%eax)
    2aa7:	00 00                	add    %al,(%eax)
    2aa9:	00 00                	add    %al,(%eax)
    2aab:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
    2aaf:	00 0d 00 00 00 04    	add    %cl,0x4000000
    2ab5:	0f 00 00             	sldt   (%eax)
    2ab8:	40                   	inc    %eax
    2ab9:	00 00                	add    %al,(%eax)
    2abb:	00 02                	add    %al,(%edx)
    2abd:	00 00                	add    %al,(%eax)
    2abf:	00 00                	add    %al,(%eax)
    2ac1:	00 00                	add    %al,(%eax)
    2ac3:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    2ac7:	00 e8                	add    %ch,%al
    2ac9:	0c 28                	or     $0x28,%al
    2acb:	00 86 0f 00 00 64    	add    %al,0x6400000f(%esi)
    2ad1:	00 02                	add    %al,(%edx)
    2ad3:	00 e8                	add    %ch,%al
    2ad5:	0c 28                	or     $0x28,%al
    2ad7:	00 08                	add    %cl,(%eax)
    2ad9:	00 00                	add    %al,(%eax)
    2adb:	00 3c 00             	add    %bh,(%eax,%eax,1)
    2ade:	00 00                	add    %al,(%eax)
    2ae0:	00 00                	add    %al,(%eax)
    2ae2:	00 00                	add    %al,(%eax)
    2ae4:	17                   	pop    %ss
    2ae5:	00 00                	add    %al,(%eax)
    2ae7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2aed:	00 00                	add    %al,(%eax)
    2aef:	00 41 00             	add    %al,0x0(%ecx)
    2af2:	00 00                	add    %al,(%eax)
    2af4:	80 00 00             	addb   $0x0,(%eax)
    2af7:	00 00                	add    %al,(%eax)
    2af9:	00 00                	add    %al,(%eax)
    2afb:	00 5b 00             	add    %bl,0x0(%ebx)
    2afe:	00 00                	add    %al,(%eax)
    2b00:	80 00 00             	addb   $0x0,(%eax)
    2b03:	00 00                	add    %al,(%eax)
    2b05:	00 00                	add    %al,(%eax)
    2b07:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2b0d:	00 00                	add    %al,(%eax)
    2b0f:	00 00                	add    %al,(%eax)
    2b11:	00 00                	add    %al,(%eax)
    2b13:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2b19:	00 00                	add    %al,(%eax)
    2b1b:	00 00                	add    %al,(%eax)
    2b1d:	00 00                	add    %al,(%eax)
    2b1f:	00 e1                	add    %ah,%cl
    2b21:	00 00                	add    %al,(%eax)
    2b23:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b29:	00 00                	add    %al,(%eax)
    2b2b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2b2e:	00 00                	add    %al,(%eax)
    2b30:	80 00 00             	addb   $0x0,(%eax)
    2b33:	00 00                	add    %al,(%eax)
    2b35:	00 00                	add    %al,(%eax)
    2b37:	00 37                	add    %dh,(%edi)
    2b39:	01 00                	add    %eax,(%eax)
    2b3b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b41:	00 00                	add    %al,(%eax)
    2b43:	00 5d 01             	add    %bl,0x1(%ebp)
    2b46:	00 00                	add    %al,(%eax)
    2b48:	80 00 00             	addb   $0x0,(%eax)
    2b4b:	00 00                	add    %al,(%eax)
    2b4d:	00 00                	add    %al,(%eax)
    2b4f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2b55:	00 00                	add    %al,(%eax)
    2b57:	00 00                	add    %al,(%eax)
    2b59:	00 00                	add    %al,(%eax)
    2b5b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2b61:	00 00                	add    %al,(%eax)
    2b63:	00 00                	add    %al,(%eax)
    2b65:	00 00                	add    %al,(%eax)
    2b67:	00 d2                	add    %dl,%dl
    2b69:	01 00                	add    %eax,(%eax)
    2b6b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b71:	00 00                	add    %al,(%eax)
    2b73:	00 ec                	add    %ch,%ah
    2b75:	01 00                	add    %eax,(%eax)
    2b77:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b7d:	00 00                	add    %al,(%eax)
    2b7f:	00 07                	add    %al,(%edi)
    2b81:	02 00                	add    (%eax),%al
    2b83:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b89:	00 00                	add    %al,(%eax)
    2b8b:	00 28                	add    %ch,(%eax)
    2b8d:	02 00                	add    (%eax),%al
    2b8f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2b95:	00 00                	add    %al,(%eax)
    2b97:	00 47 02             	add    %al,0x2(%edi)
    2b9a:	00 00                	add    %al,(%eax)
    2b9c:	80 00 00             	addb   $0x0,(%eax)
    2b9f:	00 00                	add    %al,(%eax)
    2ba1:	00 00                	add    %al,(%eax)
    2ba3:	00 66 02             	add    %ah,0x2(%esi)
    2ba6:	00 00                	add    %al,(%eax)
    2ba8:	80 00 00             	addb   $0x0,(%eax)
    2bab:	00 00                	add    %al,(%eax)
    2bad:	00 00                	add    %al,(%eax)
    2baf:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2bb5:	00 00                	add    %al,(%eax)
    2bb7:	00 00                	add    %al,(%eax)
    2bb9:	00 00                	add    %al,(%eax)
    2bbb:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    2bc1:	00 00                	add    %al,(%eax)
    2bc3:	00 cf                	add    %cl,%bh
    2bc5:	a8 00                	test   $0x0,%al
    2bc7:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    2bcd:	00 00                	add    %al,(%eax)
    2bcf:	00 00                	add    %al,(%eax)
    2bd1:	00 00                	add    %al,(%eax)
    2bd3:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    2bd9:	00 00                	add    %al,(%eax)
    2bdb:	00 37                	add    %dh,(%edi)
    2bdd:	53                   	push   %ebx
    2bde:	00 00                	add    %al,(%eax)
    2be0:	11 04 00             	adc    %eax,(%eax,%eax,1)
    2be3:	00 c2                	add    %al,%dl
    2be5:	00 00                	add    %al,(%eax)
    2be7:	00 c8                	add    %cl,%al
    2be9:	3c 00                	cmp    $0x0,%al
    2beb:	00 8e 0f 00 00 24    	add    %cl,0x2400000f(%esi)
    2bf1:	00 00                	add    %al,(%eax)
    2bf3:	00 e8                	add    %ch,%al
    2bf5:	0c 28                	or     $0x28,%al
    2bf7:	00 a3 0f 00 00 a0    	add    %ah,-0x5ffffff1(%ebx)
    2bfd:	00 00                	add    %al,(%eax)
    2bff:	00 08                	add    %cl,(%eax)
    2c01:	00 00                	add    %al,(%eax)
    2c03:	00 00                	add    %al,(%eax)
    2c05:	00 00                	add    %al,(%eax)
    2c07:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
	...
    2c13:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    2c17:	00 06                	add    %al,(%esi)
    2c19:	00 00                	add    %al,(%eax)
    2c1b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    2c21:	00 00                	add    %al,(%eax)
    2c23:	00 f3                	add    %dh,%bl
    2c25:	0c 28                	or     $0x28,%al
    2c27:	00 00                	add    %al,(%eax)
    2c29:	00 00                	add    %al,(%eax)
    2c2b:	00 44 00 6c          	add    %al,0x6c(%eax,%eax,1)
    2c2f:	00 0b                	add    %cl,(%ebx)
    2c31:	00 00                	add    %al,(%eax)
    2c33:	00 86 0f 00 00 84    	add    %al,-0x7bfffff1(%esi)
    2c39:	00 00                	add    %al,(%eax)
    2c3b:	00 fb                	add    %bh,%bl
    2c3d:	0c 28                	or     $0x28,%al
    2c3f:	00 00                	add    %al,(%eax)
    2c41:	00 00                	add    %al,(%eax)
    2c43:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
    2c47:	00 13                	add    %dl,(%ebx)
    2c49:	00 00                	add    %al,(%eax)
    2c4b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    2c51:	00 00                	add    %al,(%eax)
    2c53:	00 00                	add    %al,(%eax)
    2c55:	0d 28 00 00 00       	or     $0x28,%eax
    2c5a:	00 00                	add    %al,(%eax)
    2c5c:	44                   	inc    %esp
    2c5d:	00 6c 00 18          	add    %ch,0x18(%eax,%eax,1)
    2c61:	00 00                	add    %al,(%eax)
    2c63:	00 86 0f 00 00 84    	add    %al,-0x7bfffff1(%esi)
    2c69:	00 00                	add    %al,(%eax)
    2c6b:	00 08                	add    %cl,(%eax)
    2c6d:	0d 28 00 00 00       	or     $0x28,%eax
    2c72:	00 00                	add    %al,(%eax)
    2c74:	44                   	inc    %esp
    2c75:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2c78:	20 00                	and    %al,(%eax)
    2c7a:	00 00                	add    %al,(%eax)
    2c7c:	00 00                	add    %al,(%eax)
    2c7e:	00 00                	add    %al,(%eax)
    2c80:	44                   	inc    %esp
    2c81:	00 0f                	add    %cl,(%edi)
    2c83:	00 27                	add    %ah,(%edi)
    2c85:	00 00                	add    %al,(%eax)
    2c87:	00 b7 0f 00 00 40    	add    %dh,0x4000000f(%edi)
    2c8d:	00 00                	add    %al,(%eax)
    2c8f:	00 00                	add    %al,(%eax)
    2c91:	00 00                	add    %al,(%eax)
    2c93:	00 c4                	add    %al,%ah
    2c95:	0f 00 00             	sldt   (%eax)
    2c98:	24 00                	and    $0x0,%al
    2c9a:	00 00                	add    %al,(%eax)
    2c9c:	11 0d 28 00 d8 0f    	adc    %ecx,0xfd80028
    2ca2:	00 00                	add    %al,(%eax)
    2ca4:	a0 00 00 00 08       	mov    0x8000000,%al
    2ca9:	00 00                	add    %al,(%eax)
    2cab:	00 48 0f             	add    %cl,0xf(%eax)
    2cae:	00 00                	add    %al,(%eax)
    2cb0:	a0 00 00 00 0c       	mov    0xc000000,%al
    2cb5:	00 00                	add    %al,(%eax)
    2cb7:	00 00                	add    %al,(%eax)
    2cb9:	00 00                	add    %al,(%eax)
    2cbb:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
	...
    2cc7:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    2ccb:	00 07                	add    %al,(%edi)
    2ccd:	00 00                	add    %al,(%eax)
    2ccf:	00 00                	add    %al,(%eax)
    2cd1:	00 00                	add    %al,(%eax)
    2cd3:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    2cd7:	00 0a                	add    %cl,(%edx)
    2cd9:	00 00                	add    %al,(%eax)
    2cdb:	00 00                	add    %al,(%eax)
    2cdd:	00 00                	add    %al,(%eax)
    2cdf:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
    2ce3:	00 11                	add    %dl,(%ecx)
    2ce5:	00 00                	add    %al,(%eax)
    2ce7:	00 00                	add    %al,(%eax)
    2ce9:	00 00                	add    %al,(%eax)
    2ceb:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    2cef:	00 13                	add    %dl,(%ebx)
    2cf1:	00 00                	add    %al,(%eax)
    2cf3:	00 00                	add    %al,(%eax)
    2cf5:	00 00                	add    %al,(%eax)
    2cf7:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    2cfb:	00 18                	add    %bl,(%eax)
    2cfd:	00 00                	add    %al,(%eax)
    2cff:	00 00                	add    %al,(%eax)
    2d01:	00 00                	add    %al,(%eax)
    2d03:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    2d07:	00 1e                	add    %bl,(%esi)
    2d09:	00 00                	add    %al,(%eax)
    2d0b:	00 00                	add    %al,(%eax)
    2d0d:	00 00                	add    %al,(%eax)
    2d0f:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2d13:	00 22                	add    %ah,(%edx)
    2d15:	00 00                	add    %al,(%eax)
    2d17:	00 00                	add    %al,(%eax)
    2d19:	00 00                	add    %al,(%eax)
    2d1b:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    2d1f:	00 2b                	add    %ch,(%ebx)
    2d21:	00 00                	add    %al,(%eax)
    2d23:	00 00                	add    %al,(%eax)
    2d25:	00 00                	add    %al,(%eax)
    2d27:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    2d2b:	00 2d 00 00 00 00    	add    %ch,0x0
    2d31:	00 00                	add    %al,(%eax)
    2d33:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    2d37:	00 33                	add    %dh,(%ebx)
    2d39:	00 00                	add    %al,(%eax)
    2d3b:	00 00                	add    %al,(%eax)
    2d3d:	00 00                	add    %al,(%eax)
    2d3f:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    2d43:	00 37                	add    %dh,(%edi)
    2d45:	00 00                	add    %al,(%eax)
    2d47:	00 00                	add    %al,(%eax)
    2d49:	00 00                	add    %al,(%eax)
    2d4b:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    2d4f:	00 3a                	add    %bh,(%edx)
    2d51:	00 00                	add    %al,(%eax)
    2d53:	00 00                	add    %al,(%eax)
    2d55:	00 00                	add    %al,(%eax)
    2d57:	00 44 00 2b          	add    %al,0x2b(%eax,%eax,1)
    2d5b:	00 3e                	add    %bh,(%esi)
    2d5d:	00 00                	add    %al,(%eax)
    2d5f:	00 00                	add    %al,(%eax)
    2d61:	00 00                	add    %al,(%eax)
    2d63:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    2d67:	00 42 00             	add    %al,0x0(%edx)
    2d6a:	00 00                	add    %al,(%eax)
    2d6c:	00 00                	add    %al,(%eax)
    2d6e:	00 00                	add    %al,(%eax)
    2d70:	44                   	inc    %esp
    2d71:	00 33                	add    %dh,(%ebx)
    2d73:	00 46 00             	add    %al,0x0(%esi)
    2d76:	00 00                	add    %al,(%eax)
    2d78:	00 00                	add    %al,(%eax)
    2d7a:	00 00                	add    %al,(%eax)
    2d7c:	44                   	inc    %esp
    2d7d:	00 2f                	add    %ch,(%edi)
    2d7f:	00 48 00             	add    %cl,0x0(%eax)
    2d82:	00 00                	add    %al,(%eax)
    2d84:	00 00                	add    %al,(%eax)
    2d86:	00 00                	add    %al,(%eax)
    2d88:	44                   	inc    %esp
    2d89:	00 35 00 4b 00 00    	add    %dh,0x4b00
    2d8f:	00 00                	add    %al,(%eax)
    2d91:	00 00                	add    %al,(%eax)
    2d93:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    2d97:	00 4e 00             	add    %cl,0x0(%esi)
    2d9a:	00 00                	add    %al,(%eax)
    2d9c:	00 00                	add    %al,(%eax)
    2d9e:	00 00                	add    %al,(%eax)
    2da0:	44                   	inc    %esp
    2da1:	00 35 00 52 00 00    	add    %dh,0x5200
    2da7:	00 00                	add    %al,(%eax)
    2da9:	00 00                	add    %al,(%eax)
    2dab:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
    2daf:	00 55 00             	add    %dl,0x0(%ebp)
    2db2:	00 00                	add    %al,(%eax)
    2db4:	00 00                	add    %al,(%eax)
    2db6:	00 00                	add    %al,(%eax)
    2db8:	44                   	inc    %esp
    2db9:	00 38                	add    %bh,(%eax)
    2dbb:	00 5a 00             	add    %bl,0x0(%edx)
    2dbe:	00 00                	add    %al,(%eax)
    2dc0:	00 00                	add    %al,(%eax)
    2dc2:	00 00                	add    %al,(%eax)
    2dc4:	44                   	inc    %esp
    2dc5:	00 33                	add    %dh,(%ebx)
    2dc7:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    2dcb:	00 00                	add    %al,(%eax)
    2dcd:	00 00                	add    %al,(%eax)
    2dcf:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    2dd3:	00 5f 00             	add    %bl,0x0(%edi)
    2dd6:	00 00                	add    %al,(%eax)
    2dd8:	00 00                	add    %al,(%eax)
    2dda:	00 00                	add    %al,(%eax)
    2ddc:	44                   	inc    %esp
    2ddd:	00 38                	add    %bh,(%eax)
    2ddf:	00 66 00             	add    %ah,0x0(%esi)
    2de2:	00 00                	add    %al,(%eax)
    2de4:	00 00                	add    %al,(%eax)
    2de6:	00 00                	add    %al,(%eax)
    2de8:	44                   	inc    %esp
    2de9:	00 3a                	add    %bh,(%edx)
    2deb:	00 68 00             	add    %ch,0x0(%eax)
    2dee:	00 00                	add    %al,(%eax)
    2df0:	00 00                	add    %al,(%eax)
    2df2:	00 00                	add    %al,(%eax)
    2df4:	44                   	inc    %esp
    2df5:	00 3c 00             	add    %bh,(%eax,%eax,1)
    2df8:	71 00                	jno    2dfa <bootmain-0x27d206>
    2dfa:	00 00                	add    %al,(%eax)
    2dfc:	00 00                	add    %al,(%eax)
    2dfe:	00 00                	add    %al,(%eax)
    2e00:	44                   	inc    %esp
    2e01:	00 3e                	add    %bh,(%esi)
    2e03:	00 75 00             	add    %dh,0x0(%ebp)
    2e06:	00 00                	add    %al,(%eax)
    2e08:	00 00                	add    %al,(%eax)
    2e0a:	00 00                	add    %al,(%eax)
    2e0c:	44                   	inc    %esp
    2e0d:	00 41 00             	add    %al,0x0(%ecx)
    2e10:	7e 00                	jle    2e12 <bootmain-0x27d1ee>
    2e12:	00 00                	add    %al,(%eax)
    2e14:	00 00                	add    %al,(%eax)
    2e16:	00 00                	add    %al,(%eax)
    2e18:	44                   	inc    %esp
    2e19:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    2e1d:	00 00                	add    %al,(%eax)
    2e1f:	00 00                	add    %al,(%eax)
    2e21:	00 00                	add    %al,(%eax)
    2e23:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    2e27:	00 88 00 00 00 00    	add    %cl,0x0(%eax)
    2e2d:	00 00                	add    %al,(%eax)
    2e2f:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    2e33:	00 8b 00 00 00 b7    	add    %cl,-0x49000000(%ebx)
    2e39:	0f 00 00             	sldt   (%eax)
    2e3c:	40                   	inc    %eax
    2e3d:	00 00                	add    %al,(%eax)
    2e3f:	00 02                	add    %al,(%edx)
    2e41:	00 00                	add    %al,(%eax)
    2e43:	00 00                	add    %al,(%eax)
    2e45:	00 00                	add    %al,(%eax)
    2e47:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    2e4b:	00 9f 0d 28 00 e5    	add    %bl,-0x1affd7f3(%edi)
    2e51:	0f 00 00             	sldt   (%eax)
    2e54:	64 00 02             	add    %al,%fs:(%edx)
    2e57:	00 9f 0d 28 00 08    	add    %bl,0x800280d(%edi)
    2e5d:	00 00                	add    %al,(%eax)
    2e5f:	00 3c 00             	add    %bh,(%eax,%eax,1)
    2e62:	00 00                	add    %al,(%eax)
    2e64:	00 00                	add    %al,(%eax)
    2e66:	00 00                	add    %al,(%eax)
    2e68:	17                   	pop    %ss
    2e69:	00 00                	add    %al,(%eax)
    2e6b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2e71:	00 00                	add    %al,(%eax)
    2e73:	00 41 00             	add    %al,0x0(%ecx)
    2e76:	00 00                	add    %al,(%eax)
    2e78:	80 00 00             	addb   $0x0,(%eax)
    2e7b:	00 00                	add    %al,(%eax)
    2e7d:	00 00                	add    %al,(%eax)
    2e7f:	00 5b 00             	add    %bl,0x0(%ebx)
    2e82:	00 00                	add    %al,(%eax)
    2e84:	80 00 00             	addb   $0x0,(%eax)
    2e87:	00 00                	add    %al,(%eax)
    2e89:	00 00                	add    %al,(%eax)
    2e8b:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    2e91:	00 00                	add    %al,(%eax)
    2e93:	00 00                	add    %al,(%eax)
    2e95:	00 00                	add    %al,(%eax)
    2e97:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    2e9d:	00 00                	add    %al,(%eax)
    2e9f:	00 00                	add    %al,(%eax)
    2ea1:	00 00                	add    %al,(%eax)
    2ea3:	00 e1                	add    %ah,%cl
    2ea5:	00 00                	add    %al,(%eax)
    2ea7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2ead:	00 00                	add    %al,(%eax)
    2eaf:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    2eb2:	00 00                	add    %al,(%eax)
    2eb4:	80 00 00             	addb   $0x0,(%eax)
    2eb7:	00 00                	add    %al,(%eax)
    2eb9:	00 00                	add    %al,(%eax)
    2ebb:	00 37                	add    %dh,(%edi)
    2ebd:	01 00                	add    %eax,(%eax)
    2ebf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2ec5:	00 00                	add    %al,(%eax)
    2ec7:	00 5d 01             	add    %bl,0x1(%ebp)
    2eca:	00 00                	add    %al,(%eax)
    2ecc:	80 00 00             	addb   $0x0,(%eax)
    2ecf:	00 00                	add    %al,(%eax)
    2ed1:	00 00                	add    %al,(%eax)
    2ed3:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    2ed9:	00 00                	add    %al,(%eax)
    2edb:	00 00                	add    %al,(%eax)
    2edd:	00 00                	add    %al,(%eax)
    2edf:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    2ee5:	00 00                	add    %al,(%eax)
    2ee7:	00 00                	add    %al,(%eax)
    2ee9:	00 00                	add    %al,(%eax)
    2eeb:	00 d2                	add    %dl,%dl
    2eed:	01 00                	add    %eax,(%eax)
    2eef:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2ef5:	00 00                	add    %al,(%eax)
    2ef7:	00 ec                	add    %ch,%ah
    2ef9:	01 00                	add    %eax,(%eax)
    2efb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2f01:	00 00                	add    %al,(%eax)
    2f03:	00 07                	add    %al,(%edi)
    2f05:	02 00                	add    (%eax),%al
    2f07:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2f0d:	00 00                	add    %al,(%eax)
    2f0f:	00 28                	add    %ch,(%eax)
    2f11:	02 00                	add    (%eax),%al
    2f13:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    2f19:	00 00                	add    %al,(%eax)
    2f1b:	00 47 02             	add    %al,0x2(%edi)
    2f1e:	00 00                	add    %al,(%eax)
    2f20:	80 00 00             	addb   $0x0,(%eax)
    2f23:	00 00                	add    %al,(%eax)
    2f25:	00 00                	add    %al,(%eax)
    2f27:	00 66 02             	add    %ah,0x2(%esi)
    2f2a:	00 00                	add    %al,(%eax)
    2f2c:	80 00 00             	addb   $0x0,(%eax)
    2f2f:	00 00                	add    %al,(%eax)
    2f31:	00 00                	add    %al,(%eax)
    2f33:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    2f39:	00 00                	add    %al,(%eax)
    2f3b:	00 00                	add    %al,(%eax)
    2f3d:	00 00                	add    %al,(%eax)
    2f3f:	00 11                	add    %dl,(%ecx)
    2f41:	04 00                	add    $0x0,%al
    2f43:	00 c2                	add    %al,%dl
    2f45:	00 00                	add    %al,(%eax)
    2f47:	00 c8                	add    %cl,%al
    2f49:	3c 00                	cmp    $0x0,%al
    2f4b:	00 a6 02 00 00 c2    	add    %ah,-0x3dfffffe(%esi)
    2f51:	00 00                	add    %al,(%eax)
    2f53:	00 00                	add    %al,(%eax)
    2f55:	00 00                	add    %al,(%eax)
    2f57:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    2f5d:	00 00                	add    %al,(%eax)
    2f5f:	00 37                	add    %dh,(%edi)
    2f61:	53                   	push   %ebx
    2f62:	00 00                	add    %al,(%eax)
    2f64:	ea 0f 00 00 24 00 00 	ljmp   $0x0,$0x2400000f
    2f6b:	00 9f 0d 28 00 ff    	add    %bl,-0xffd7f3(%edi)
    2f71:	0f 00 00             	sldt   (%eax)
    2f74:	a0 00 00 00 08       	mov    0x8000000,%al
    2f79:	00 00                	add    %al,(%eax)
    2f7b:	00 0c 10             	add    %cl,(%eax,%edx,1)
    2f7e:	00 00                	add    %al,(%eax)
    2f80:	a0 00 00 00 0c       	mov    0xc000000,%al
    2f85:	00 00                	add    %al,(%eax)
    2f87:	00 00                	add    %al,(%eax)
    2f89:	00 00                	add    %al,(%eax)
    2f8b:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    2f97:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    2f9b:	00 07                	add    %al,(%edi)
    2f9d:	00 00                	add    %al,(%eax)
    2f9f:	00 00                	add    %al,(%eax)
    2fa1:	00 00                	add    %al,(%eax)
    2fa3:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    2fa7:	00 0c 00             	add    %cl,(%eax,%eax,1)
    2faa:	00 00                	add    %al,(%eax)
    2fac:	00 00                	add    %al,(%eax)
    2fae:	00 00                	add    %al,(%eax)
    2fb0:	44                   	inc    %esp
    2fb1:	00 11                	add    %dl,(%ecx)
    2fb3:	00 12                	add    %dl,(%edx)
    2fb5:	00 00                	add    %al,(%eax)
    2fb7:	00 00                	add    %al,(%eax)
    2fb9:	00 00                	add    %al,(%eax)
    2fbb:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    2fbf:	00 1c 00             	add    %bl,(%eax,%eax,1)
    2fc2:	00 00                	add    %al,(%eax)
    2fc4:	00 00                	add    %al,(%eax)
    2fc6:	00 00                	add    %al,(%eax)
    2fc8:	44                   	inc    %esp
    2fc9:	00 14 00             	add    %dl,(%eax,%eax,1)
    2fcc:	22 00                	and    (%eax),%al
    2fce:	00 00                	add    %al,(%eax)
    2fd0:	00 00                	add    %al,(%eax)
    2fd2:	00 00                	add    %al,(%eax)
    2fd4:	44                   	inc    %esp
    2fd5:	00 12                	add    %dl,(%edx)
    2fd7:	00 28                	add    %ch,(%eax)
    2fd9:	00 00                	add    %al,(%eax)
    2fdb:	00 00                	add    %al,(%eax)
    2fdd:	00 00                	add    %al,(%eax)
    2fdf:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    2fe3:	00 30                	add    %dh,(%eax)
    2fe5:	00 00                	add    %al,(%eax)
    2fe7:	00 00                	add    %al,(%eax)
    2fe9:	00 00                	add    %al,(%eax)
    2feb:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    2fef:	00 37                	add    %dh,(%edi)
    2ff1:	00 00                	add    %al,(%eax)
    2ff3:	00 17                	add    %dl,(%edi)
    2ff5:	10 00                	adc    %al,(%eax)
    2ff7:	00 40 00             	add    %al,0x0(%eax)
    2ffa:	00 00                	add    %al,(%eax)
    2ffc:	02 00                	add    (%eax),%al
    2ffe:	00 00                	add    %al,(%eax)
    3000:	22 10                	and    (%eax),%dl
    3002:	00 00                	add    %al,(%eax)
    3004:	40                   	inc    %eax
    3005:	00 00                	add    %al,(%eax)
    3007:	00 01                	add    %al,(%ecx)
    3009:	00 00                	add    %al,(%eax)
    300b:	00 33                	add    %dh,(%ebx)
    300d:	10 00                	adc    %al,(%eax)
    300f:	00 40 00             	add    %al,0x0(%eax)
	...
    301a:	00 00                	add    %al,(%eax)
    301c:	c0 00 00             	rolb   $0x0,(%eax)
	...
    3027:	00 e0                	add    %ah,%al
    3029:	00 00                	add    %al,(%eax)
    302b:	00 3a                	add    %bh,(%edx)
    302d:	00 00                	add    %al,(%eax)
    302f:	00 40 10             	add    %al,0x10(%eax)
    3032:	00 00                	add    %al,(%eax)
    3034:	24 00                	and    $0x0,%al
    3036:	00 00                	add    %al,(%eax)
    3038:	d9 0d 28 00 ff 0f    	(bad)  0xfff0028
    303e:	00 00                	add    %al,(%eax)
    3040:	a0 00 00 00 08       	mov    0x8000000,%al
    3045:	00 00                	add    %al,(%eax)
    3047:	00 0c 10             	add    %cl,(%eax,%edx,1)
    304a:	00 00                	add    %al,(%eax)
    304c:	a0 00 00 00 0c       	mov    0xc000000,%al
    3051:	00 00                	add    %al,(%eax)
    3053:	00 00                	add    %al,(%eax)
    3055:	00 00                	add    %al,(%eax)
    3057:	00 44 00 21          	add    %al,0x21(%eax,%eax,1)
    305b:	00 00                	add    %al,(%eax)
    305d:	00 00                	add    %al,(%eax)
    305f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    3065:	00 00                	add    %al,(%eax)
    3067:	00 dd                	add    %bl,%ch
    3069:	0d 28 00 00 00       	or     $0x28,%eax
    306e:	00 00                	add    %al,(%eax)
    3070:	44                   	inc    %esp
    3071:	00 3c 01             	add    %bh,(%ecx,%eax,1)
    3074:	04 00                	add    $0x0,%al
    3076:	00 00                	add    %al,(%eax)
    3078:	e5 0f                	in     $0xf,%eax
    307a:	00 00                	add    %al,(%eax)
    307c:	84 00                	test   %al,(%eax)
    307e:	00 00                	add    %al,(%eax)
    3080:	df 0d 28 00 00 00    	fisttp 0x28
    3086:	00 00                	add    %al,(%eax)
    3088:	44                   	inc    %esp
    3089:	00 25 00 06 00 00    	add    %ah,0x600
    308f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    3095:	00 00                	add    %al,(%eax)
    3097:	00 e4                	add    %ah,%ah
    3099:	0d 28 00 00 00       	or     $0x28,%eax
    309e:	00 00                	add    %al,(%eax)
    30a0:	44                   	inc    %esp
    30a1:	00 43 01             	add    %al,0x1(%ebx)
    30a4:	0b 00                	or     (%eax),%eax
    30a6:	00 00                	add    %al,(%eax)
    30a8:	00 00                	add    %al,(%eax)
    30aa:	00 00                	add    %al,(%eax)
    30ac:	44                   	inc    %esp
    30ad:	00 3c 01             	add    %bh,(%ecx,%eax,1)
    30b0:	0d 00 00 00 e5       	or     $0xe5000000,%eax
    30b5:	0f 00 00             	sldt   (%eax)
    30b8:	84 00                	test   %al,(%eax)
    30ba:	00 00                	add    %al,(%eax)
    30bc:	e8 0d 28 00 00       	call   58ce <bootmain-0x27a732>
    30c1:	00 00                	add    %al,(%eax)
    30c3:	00 44 00 22          	add    %al,0x22(%eax,%eax,1)
    30c7:	00 0f                	add    %cl,(%edi)
    30c9:	00 00                	add    %al,(%eax)
    30cb:	00 00                	add    %al,(%eax)
    30cd:	00 00                	add    %al,(%eax)
    30cf:	00 44 00 29          	add    %al,0x29(%eax,%eax,1)
    30d3:	00 11                	add    %dl,(%ecx)
    30d5:	00 00                	add    %al,(%eax)
    30d7:	00 00                	add    %al,(%eax)
    30d9:	00 00                	add    %al,(%eax)
    30db:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    30df:	00 18                	add    %bl,(%eax)
    30e1:	00 00                	add    %al,(%eax)
    30e3:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    30e9:	00 00                	add    %al,(%eax)
    30eb:	00 f6                	add    %dh,%dh
    30ed:	0d 28 00 00 00       	or     $0x28,%eax
    30f2:	00 00                	add    %al,(%eax)
    30f4:	44                   	inc    %esp
    30f5:	00 43 01             	add    %al,0x1(%ebx)
    30f8:	1d 00 00 00 00       	sbb    $0x0,%eax
    30fd:	00 00                	add    %al,(%eax)
    30ff:	00 44 00 dc          	add    %al,-0x24(%eax,%eax,1)
    3103:	00 1f                	add    %bl,(%edi)
    3105:	00 00                	add    %al,(%eax)
    3107:	00 e5                	add    %ah,%ch
    3109:	0f 00 00             	sldt   (%eax)
    310c:	84 00                	test   %al,(%eax)
    310e:	00 00                	add    %al,(%eax)
    3110:	fb                   	sti    
    3111:	0d 28 00 00 00       	or     $0x28,%eax
    3116:	00 00                	add    %al,(%eax)
    3118:	44                   	inc    %esp
    3119:	00 32                	add    %dh,(%edx)
    311b:	00 22                	add    %ah,(%edx)
    311d:	00 00                	add    %al,(%eax)
    311f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    3125:	00 00                	add    %al,(%eax)
    3127:	00 00                	add    %al,(%eax)
    3129:	0e                   	push   %cs
    312a:	28 00                	sub    %al,(%eax)
    312c:	00 00                	add    %al,(%eax)
    312e:	00 00                	add    %al,(%eax)
    3130:	44                   	inc    %esp
    3131:	00 d5                	add    %dl,%ch
    3133:	00 27                	add    %ah,(%edi)
    3135:	00 00                	add    %al,(%eax)
    3137:	00 e5                	add    %ah,%ch
    3139:	0f 00 00             	sldt   (%eax)
    313c:	84 00                	test   %al,(%eax)
    313e:	00 00                	add    %al,(%eax)
    3140:	03 0e                	add    (%esi),%ecx
    3142:	28 00                	sub    %al,(%eax)
    3144:	00 00                	add    %al,(%eax)
    3146:	00 00                	add    %al,(%eax)
    3148:	44                   	inc    %esp
    3149:	00 2b                	add    %ch,(%ebx)
    314b:	00 2a                	add    %ch,(%edx)
    314d:	00 00                	add    %al,(%eax)
    314f:	00 00                	add    %al,(%eax)
    3151:	00 00                	add    %al,(%eax)
    3153:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
    3157:	00 2c 00             	add    %ch,(%eax,%eax,1)
    315a:	00 00                	add    %al,(%eax)
    315c:	00 00                	add    %al,(%eax)
    315e:	00 00                	add    %al,(%eax)
    3160:	44                   	inc    %esp
    3161:	00 3a                	add    %bh,(%edx)
    3163:	00 37                	add    %dh,(%edi)
    3165:	00 00                	add    %al,(%eax)
    3167:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    316d:	00 00                	add    %al,(%eax)
    316f:	00 16                	add    %dl,(%esi)
    3171:	0e                   	push   %cs
    3172:	28 00                	sub    %al,(%eax)
    3174:	00 00                	add    %al,(%eax)
    3176:	00 00                	add    %al,(%eax)
    3178:	44                   	inc    %esp
    3179:	00 dc                	add    %bl,%ah
    317b:	00 3d 00 00 00 e5    	add    %bh,0xe5000000
    3181:	0f 00 00             	sldt   (%eax)
    3184:	84 00                	test   %al,(%eax)
    3186:	00 00                	add    %al,(%eax)
    3188:	19 0e                	sbb    %ecx,(%esi)
    318a:	28 00                	sub    %al,(%eax)
    318c:	00 00                	add    %al,(%eax)
    318e:	00 00                	add    %al,(%eax)
    3190:	44                   	inc    %esp
    3191:	00 3d 00 40 00 00    	add    %bh,0x4000
    3197:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    319d:	00 00                	add    %al,(%eax)
    319f:	00 1f                	add    %bl,(%edi)
    31a1:	0e                   	push   %cs
    31a2:	28 00                	sub    %al,(%eax)
    31a4:	00 00                	add    %al,(%eax)
    31a6:	00 00                	add    %al,(%eax)
    31a8:	44                   	inc    %esp
    31a9:	00 d5                	add    %dl,%ch
    31ab:	00 46 00             	add    %al,0x0(%esi)
    31ae:	00 00                	add    %al,(%eax)
    31b0:	e5 0f                	in     $0xf,%eax
    31b2:	00 00                	add    %al,(%eax)
    31b4:	84 00                	test   %al,(%eax)
    31b6:	00 00                	add    %al,(%eax)
    31b8:	22 0e                	and    (%esi),%cl
    31ba:	28 00                	sub    %al,(%eax)
    31bc:	00 00                	add    %al,(%eax)
    31be:	00 00                	add    %al,(%eax)
    31c0:	44                   	inc    %esp
    31c1:	00 43 00             	add    %al,0x0(%ebx)
    31c4:	49                   	dec    %ecx
    31c5:	00 00                	add    %al,(%eax)
    31c7:	00 4f 10             	add    %cl,0x10(%edi)
    31ca:	00 00                	add    %al,(%eax)
    31cc:	40                   	inc    %eax
    31cd:	00 00                	add    %al,(%eax)
    31cf:	00 03                	add    %al,(%ebx)
    31d1:	00 00                	add    %al,(%eax)
    31d3:	00 5d 10             	add    %bl,0x10(%ebp)
    31d6:	00 00                	add    %al,(%eax)
    31d8:	40                   	inc    %eax
	...
    31e1:	00 00                	add    %al,(%eax)
    31e3:	00 c0                	add    %al,%al
	...
    31ed:	00 00                	add    %al,(%eax)
    31ef:	00 e0                	add    %ah,%al
    31f1:	00 00                	add    %al,(%eax)
    31f3:	00 4e 00             	add    %cl,0x0(%esi)
    31f6:	00 00                	add    %al,(%eax)
    31f8:	66                   	data16
    31f9:	10 00                	adc    %al,(%eax)
    31fb:	00 24 00             	add    %ah,(%eax,%eax,1)
    31fe:	00 00                	add    %al,(%eax)
    3200:	27                   	daa    
    3201:	0e                   	push   %cs
    3202:	28 00                	sub    %al,(%eax)
    3204:	7a 10                	jp     3216 <bootmain-0x27cdea>
    3206:	00 00                	add    %al,(%eax)
    3208:	a0 00 00 00 08       	mov    0x8000000,%al
    320d:	00 00                	add    %al,(%eax)
    320f:	00 00                	add    %al,(%eax)
    3211:	00 00                	add    %al,(%eax)
    3213:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
	...
    321f:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    3223:	00 03                	add    %al,(%ebx)
    3225:	00 00                	add    %al,(%eax)
    3227:	00 00                	add    %al,(%eax)
    3229:	00 00                	add    %al,(%eax)
    322b:	00 44 00 48          	add    %al,0x48(%eax,%eax,1)
    322f:	00 06                	add    %al,(%esi)
    3231:	00 00                	add    %al,(%eax)
    3233:	00 00                	add    %al,(%eax)
    3235:	00 00                	add    %al,(%eax)
    3237:	00 44 00 49          	add    %al,0x49(%eax,%eax,1)
    323b:	00 0c 00             	add    %cl,(%eax,%eax,1)
    323e:	00 00                	add    %al,(%eax)
    3240:	00 00                	add    %al,(%eax)
    3242:	00 00                	add    %al,(%eax)
    3244:	44                   	inc    %esp
    3245:	00 4a 00             	add    %cl,0x0(%edx)
    3248:	13 00                	adc    (%eax),%eax
    324a:	00 00                	add    %al,(%eax)
    324c:	00 00                	add    %al,(%eax)
    324e:	00 00                	add    %al,(%eax)
    3250:	44                   	inc    %esp
    3251:	00 4b 00             	add    %cl,0x0(%ebx)
    3254:	1a 00                	sbb    (%eax),%al
    3256:	00 00                	add    %al,(%eax)
    3258:	00 00                	add    %al,(%eax)
    325a:	00 00                	add    %al,(%eax)
    325c:	44                   	inc    %esp
    325d:	00 4c 00 21          	add    %cl,0x21(%eax,%eax,1)
    3261:	00 00                	add    %al,(%eax)
    3263:	00 8d 10 00 00 40    	add    %cl,0x40000010(%ebp)
    3269:	00 00                	add    %al,(%eax)
    326b:	00 00                	add    %al,(%eax)
    326d:	00 00                	add    %al,(%eax)
    326f:	00 99 10 00 00 24    	add    %bl,0x24000010(%ecx)
    3275:	00 00                	add    %al,(%eax)
    3277:	00 4a 0e             	add    %cl,0xe(%edx)
    327a:	28 00                	sub    %al,(%eax)
    327c:	ad                   	lods   %ds:(%esi),%eax
    327d:	10 00                	adc    %al,(%eax)
    327f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3285:	00 00                	add    %al,(%eax)
    3287:	00 00                	add    %al,(%eax)
    3289:	00 00                	add    %al,(%eax)
    328b:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
	...
    3297:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    329b:	00 01                	add    %al,(%ecx)
    329d:	00 00                	add    %al,(%eax)
    329f:	00 00                	add    %al,(%eax)
    32a1:	00 00                	add    %al,(%eax)
    32a3:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    32a7:	00 03                	add    %al,(%ebx)
    32a9:	00 00                	add    %al,(%eax)
    32ab:	00 00                	add    %al,(%eax)
    32ad:	00 00                	add    %al,(%eax)
    32af:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    32b3:	00 05 00 00 00 00    	add    %al,0x0
    32b9:	00 00                	add    %al,(%eax)
    32bb:	00 44 00 4f          	add    %al,0x4f(%eax,%eax,1)
    32bf:	00 07                	add    %al,(%edi)
    32c1:	00 00                	add    %al,(%eax)
    32c3:	00 00                	add    %al,(%eax)
    32c5:	00 00                	add    %al,(%eax)
    32c7:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    32cb:	00 0b                	add    %cl,(%ebx)
    32cd:	00 00                	add    %al,(%eax)
    32cf:	00 00                	add    %al,(%eax)
    32d1:	00 00                	add    %al,(%eax)
    32d3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    32d7:	00 0d 00 00 00 00    	add    %cl,0x0
    32dd:	00 00                	add    %al,(%eax)
    32df:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
    32e3:	00 11                	add    %dl,(%ecx)
    32e5:	00 00                	add    %al,(%eax)
    32e7:	00 00                	add    %al,(%eax)
    32e9:	00 00                	add    %al,(%eax)
    32eb:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
    32ef:	00 15 00 00 00 00    	add    %dl,0x0
    32f5:	00 00                	add    %al,(%eax)
    32f7:	00 44 00 57          	add    %al,0x57(%eax,%eax,1)
    32fb:	00 18                	add    %bl,(%eax)
    32fd:	00 00                	add    %al,(%eax)
    32ff:	00 5d 10             	add    %bl,0x10(%ebp)
    3302:	00 00                	add    %al,(%eax)
    3304:	40                   	inc    %eax
    3305:	00 00                	add    %al,(%eax)
    3307:	00 02                	add    %al,(%edx)
    3309:	00 00                	add    %al,(%eax)
    330b:	00 b9 10 00 00 40    	add    %bh,0x40000010(%ecx)
    3311:	00 00                	add    %al,(%eax)
    3313:	00 00                	add    %al,(%eax)
    3315:	00 00                	add    %al,(%eax)
    3317:	00 8d 10 00 00 40    	add    %cl,0x40000010(%ebp)
    331d:	00 00                	add    %al,(%eax)
    331f:	00 01                	add    %al,(%ecx)
    3321:	00 00                	add    %al,(%eax)
    3323:	00 00                	add    %al,(%eax)
    3325:	00 00                	add    %al,(%eax)
    3327:	00 c0                	add    %al,%al
	...
    3331:	00 00                	add    %al,(%eax)
    3333:	00 e0                	add    %ah,%al
    3335:	00 00                	add    %al,(%eax)
    3337:	00 1b                	add    %bl,(%ebx)
    3339:	00 00                	add    %al,(%eax)
    333b:	00 c8                	add    %cl,%al
    333d:	10 00                	adc    %al,(%eax)
    333f:	00 24 00             	add    %ah,(%eax,%eax,1)
    3342:	00 00                	add    %al,(%eax)
    3344:	65                   	gs
    3345:	0e                   	push   %cs
    3346:	28 00                	sub    %al,(%eax)
    3348:	ad                   	lods   %ds:(%esi),%eax
    3349:	10 00                	adc    %al,(%eax)
    334b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    3351:	00 00                	add    %al,(%eax)
    3353:	00 dc                	add    %bl,%ah
    3355:	10 00                	adc    %al,(%eax)
    3357:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    335d:	00 00                	add    %al,(%eax)
    335f:	00 00                	add    %al,(%eax)
    3361:	00 00                	add    %al,(%eax)
    3363:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
    336f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    3373:	00 01                	add    %al,(%ecx)
    3375:	00 00                	add    %al,(%eax)
    3377:	00 00                	add    %al,(%eax)
    3379:	00 00                	add    %al,(%eax)
    337b:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    337f:	00 03                	add    %al,(%ebx)
    3381:	00 00                	add    %al,(%eax)
    3383:	00 00                	add    %al,(%eax)
    3385:	00 00                	add    %al,(%eax)
    3387:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    338b:	00 0b                	add    %cl,(%ebx)
    338d:	00 00                	add    %al,(%eax)
    338f:	00 00                	add    %al,(%eax)
    3391:	00 00                	add    %al,(%eax)
    3393:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    3397:	00 0d 00 00 00 00    	add    %cl,0x0
    339d:	00 00                	add    %al,(%eax)
    339f:	00 44 00 5e          	add    %al,0x5e(%eax,%eax,1)
    33a3:	00 11                	add    %dl,(%ecx)
    33a5:	00 00                	add    %al,(%eax)
    33a7:	00 00                	add    %al,(%eax)
    33a9:	00 00                	add    %al,(%eax)
    33ab:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
    33af:	00 1d 00 00 00 00    	add    %bl,0x0
    33b5:	00 00                	add    %al,(%eax)
    33b7:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    33bb:	00 20                	add    %ah,(%eax)
    33bd:	00 00                	add    %al,(%eax)
    33bf:	00 00                	add    %al,(%eax)
    33c1:	00 00                	add    %al,(%eax)
    33c3:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
    33c7:	00 23                	add    %ah,(%ebx)
    33c9:	00 00                	add    %al,(%eax)
    33cb:	00 00                	add    %al,(%eax)
    33cd:	00 00                	add    %al,(%eax)
    33cf:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    33d3:	00 28                	add    %ch,(%eax)
    33d5:	00 00                	add    %al,(%eax)
    33d7:	00 00                	add    %al,(%eax)
    33d9:	00 00                	add    %al,(%eax)
    33db:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    33df:	00 2e                	add    %ch,(%esi)
    33e1:	00 00                	add    %al,(%eax)
    33e3:	00 00                	add    %al,(%eax)
    33e5:	00 00                	add    %al,(%eax)
    33e7:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    33eb:	00 30                	add    %dh,(%eax)
    33ed:	00 00                	add    %al,(%eax)
    33ef:	00 00                	add    %al,(%eax)
    33f1:	00 00                	add    %al,(%eax)
    33f3:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    33f7:	00 33                	add    %dh,(%ebx)
    33f9:	00 00                	add    %al,(%eax)
    33fb:	00 00                	add    %al,(%eax)
    33fd:	00 00                	add    %al,(%eax)
    33ff:	00 44 00 65          	add    %al,0x65(%eax,%eax,1)
    3403:	00 35 00 00 00 00    	add    %dh,0x0
    3409:	00 00                	add    %al,(%eax)
    340b:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    340f:	00 3a                	add    %bh,(%edx)
    3411:	00 00                	add    %al,(%eax)
    3413:	00 00                	add    %al,(%eax)
    3415:	00 00                	add    %al,(%eax)
    3417:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    341b:	00 3e                	add    %bh,(%esi)
    341d:	00 00                	add    %al,(%eax)
    341f:	00 00                	add    %al,(%eax)
    3421:	00 00                	add    %al,(%eax)
    3423:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
    3427:	00 51 00             	add    %dl,0x0(%ecx)
    342a:	00 00                	add    %al,(%eax)
    342c:	00 00                	add    %al,(%eax)
    342e:	00 00                	add    %al,(%eax)
    3430:	44                   	inc    %esp
    3431:	00 70 00             	add    %dh,0x0(%eax)
    3434:	54                   	push   %esp
    3435:	00 00                	add    %al,(%eax)
    3437:	00 00                	add    %al,(%eax)
    3439:	00 00                	add    %al,(%eax)
    343b:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
    343f:	00 56 00             	add    %dl,0x0(%esi)
    3442:	00 00                	add    %al,(%eax)
    3444:	e8 10 00 00 40       	call   40003459 <mousefifo+0x3fd80385>
    3449:	00 00                	add    %al,(%eax)
    344b:	00 00                	add    %al,(%eax)
    344d:	00 00                	add    %al,(%eax)
    344f:	00 8d 10 00 00 40    	add    %cl,0x40000010(%ebp)
    3455:	00 00                	add    %al,(%eax)
    3457:	00 01                	add    %al,(%ecx)
    3459:	00 00                	add    %al,(%eax)
    345b:	00 00                	add    %al,(%eax)
    345d:	00 00                	add    %al,(%eax)
    345f:	00 c0                	add    %al,%al
	...
    3469:	00 00                	add    %al,(%eax)
    346b:	00 e0                	add    %ah,%al
    346d:	00 00                	add    %al,(%eax)
    346f:	00 5b 00             	add    %bl,0x0(%ebx)
    3472:	00 00                	add    %al,(%eax)
    3474:	f1                   	icebp  
    3475:	10 00                	adc    %al,(%eax)
    3477:	00 24 00             	add    %ah,(%eax,%eax,1)
    347a:	00 00                	add    %al,(%eax)
    347c:	c0 0e 28             	rorb   $0x28,(%esi)
    347f:	00 ad 10 00 00 a0    	add    %ch,-0x5ffffff0(%ebp)
    3485:	00 00                	add    %al,(%eax)
    3487:	00 08                	add    %cl,(%eax)
    3489:	00 00                	add    %al,(%eax)
    348b:	00 04 11             	add    %al,(%ecx,%edx,1)
    348e:	00 00                	add    %al,(%eax)
    3490:	a0 00 00 00 0c       	mov    0xc000000,%al
    3495:	00 00                	add    %al,(%eax)
    3497:	00 dc                	add    %bl,%ah
    3499:	10 00                	adc    %al,(%eax)
    349b:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    34a1:	00 00                	add    %al,(%eax)
    34a3:	00 00                	add    %al,(%eax)
    34a5:	00 00                	add    %al,(%eax)
    34a7:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
	...
    34b3:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    34b7:	00 01                	add    %al,(%ecx)
    34b9:	00 00                	add    %al,(%eax)
    34bb:	00 00                	add    %al,(%eax)
    34bd:	00 00                	add    %al,(%eax)
    34bf:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    34c3:	00 03                	add    %al,(%ebx)
    34c5:	00 00                	add    %al,(%eax)
    34c7:	00 00                	add    %al,(%eax)
    34c9:	00 00                	add    %al,(%eax)
    34cb:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    34cf:	00 0b                	add    %cl,(%ebx)
    34d1:	00 00                	add    %al,(%eax)
    34d3:	00 00                	add    %al,(%eax)
    34d5:	00 00                	add    %al,(%eax)
    34d7:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    34db:	00 11                	add    %dl,(%ecx)
    34dd:	00 00                	add    %al,(%eax)
    34df:	00 00                	add    %al,(%eax)
    34e1:	00 00                	add    %al,(%eax)
    34e3:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    34e7:	00 19                	add    %bl,(%ecx)
    34e9:	00 00                	add    %al,(%eax)
    34eb:	00 00                	add    %al,(%eax)
    34ed:	00 00                	add    %al,(%eax)
    34ef:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
    34f3:	00 1e                	add    %bl,(%esi)
    34f5:	00 00                	add    %al,(%eax)
    34f7:	00 00                	add    %al,(%eax)
    34f9:	00 00                	add    %al,(%eax)
    34fb:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    34ff:	00 27                	add    %ah,(%edi)
    3501:	00 00                	add    %al,(%eax)
    3503:	00 00                	add    %al,(%eax)
    3505:	00 00                	add    %al,(%eax)
    3507:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    350b:	00 2d 00 00 00 00    	add    %ch,0x0
    3511:	00 00                	add    %al,(%eax)
    3513:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
    3517:	00 34 00             	add    %dh,(%eax,%eax,1)
    351a:	00 00                	add    %al,(%eax)
    351c:	00 00                	add    %al,(%eax)
    351e:	00 00                	add    %al,(%eax)
    3520:	44                   	inc    %esp
    3521:	00 85 00 41 00 00    	add    %al,0x4100(%ebp)
    3527:	00 00                	add    %al,(%eax)
    3529:	00 00                	add    %al,(%eax)
    352b:	00 44 00 86          	add    %al,-0x7a(%eax,%eax,1)
    352f:	00 43 00             	add    %al,0x0(%ebx)
    3532:	00 00                	add    %al,(%eax)
    3534:	00 00                	add    %al,(%eax)
    3536:	00 00                	add    %al,(%eax)
    3538:	44                   	inc    %esp
    3539:	00 85 00 46 00 00    	add    %al,0x4600(%ebp)
    353f:	00 00                	add    %al,(%eax)
    3541:	00 00                	add    %al,(%eax)
    3543:	00 44 00 86          	add    %al,-0x7a(%eax,%eax,1)
    3547:	00 49 00             	add    %cl,0x0(%ecx)
    354a:	00 00                	add    %al,(%eax)
    354c:	00 00                	add    %al,(%eax)
    354e:	00 00                	add    %al,(%eax)
    3550:	44                   	inc    %esp
    3551:	00 88 00 4e 00 00    	add    %cl,0x4e00(%eax)
    3557:	00 00                	add    %al,(%eax)
    3559:	00 00                	add    %al,(%eax)
    355b:	00 44 00 8a          	add    %al,-0x76(%eax,%eax,1)
    355f:	00 56 00             	add    %dl,0x0(%esi)
    3562:	00 00                	add    %al,(%eax)
    3564:	00 00                	add    %al,(%eax)
    3566:	00 00                	add    %al,(%eax)
    3568:	44                   	inc    %esp
    3569:	00 8b 00 5c 00 00    	add    %cl,0x5c00(%ebx)
    356f:	00 00                	add    %al,(%eax)
    3571:	00 00                	add    %al,(%eax)
    3573:	00 44 00 8d          	add    %al,-0x73(%eax,%eax,1)
    3577:	00 62 00             	add    %ah,0x0(%edx)
    357a:	00 00                	add    %al,(%eax)
    357c:	00 00                	add    %al,(%eax)
    357e:	00 00                	add    %al,(%eax)
    3580:	44                   	inc    %esp
    3581:	00 8f 00 66 00 00    	add    %cl,0x6600(%edi)
    3587:	00 00                	add    %al,(%eax)
    3589:	00 00                	add    %al,(%eax)
    358b:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    358f:	00 79 00             	add    %bh,0x0(%ecx)
    3592:	00 00                	add    %al,(%eax)
    3594:	00 00                	add    %al,(%eax)
    3596:	00 00                	add    %al,(%eax)
    3598:	44                   	inc    %esp
    3599:	00 9c 00 7e 00 00 00 	add    %bl,0x7e(%eax,%eax,1)
    35a0:	00 00                	add    %al,(%eax)
    35a2:	00 00                	add    %al,(%eax)
    35a4:	44                   	inc    %esp
    35a5:	00 9e 00 8b 00 00    	add    %bl,0x8b00(%esi)
    35ab:	00 00                	add    %al,(%eax)
    35ad:	00 00                	add    %al,(%eax)
    35af:	00 44 00 9f          	add    %al,-0x61(%eax,%eax,1)
    35b3:	00 8e 00 00 00 00    	add    %cl,0x0(%esi)
    35b9:	00 00                	add    %al,(%eax)
    35bb:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    35bf:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
    35c5:	00 00                	add    %al,(%eax)
    35c7:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
    35cb:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    35d2:	00 00                	add    %al,(%eax)
    35d4:	44                   	inc    %esp
    35d5:	00 a5 00 98 00 00    	add    %ah,0x9800(%ebp)
    35db:	00 00                	add    %al,(%eax)
    35dd:	00 00                	add    %al,(%eax)
    35df:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
    35e3:	00 a1 00 00 00 00    	add    %ah,0x0(%ecx)
    35e9:	00 00                	add    %al,(%eax)
    35eb:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
    35ef:	00 a6 00 00 00 00    	add    %ah,0x0(%esi)
    35f5:	00 00                	add    %al,(%eax)
    35f7:	00 44 00 ac          	add    %al,-0x54(%eax,%eax,1)
    35fb:	00 be 00 00 00 00    	add    %bh,0x0(%esi)
    3601:	00 00                	add    %al,(%eax)
    3603:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    3607:	00 c2                	add    %al,%dl
    3609:	00 00                	add    %al,(%eax)
    360b:	00 00                	add    %al,(%eax)
    360d:	00 00                	add    %al,(%eax)
    360f:	00 44 00 ac          	add    %al,-0x54(%eax,%eax,1)
    3613:	00 c5                	add    %al,%ch
    3615:	00 00                	add    %al,(%eax)
    3617:	00 00                	add    %al,(%eax)
    3619:	00 00                	add    %al,(%eax)
    361b:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
    361f:	00 c7                	add    %al,%bh
    3621:	00 00                	add    %al,(%eax)
    3623:	00 00                	add    %al,(%eax)
    3625:	00 00                	add    %al,(%eax)
    3627:	00 44 00 af          	add    %al,-0x51(%eax,%eax,1)
    362b:	00 c9                	add    %cl,%cl
    362d:	00 00                	add    %al,(%eax)
    362f:	00 00                	add    %al,(%eax)
    3631:	00 00                	add    %al,(%eax)
    3633:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    3637:	00 cf                	add    %cl,%bh
    3639:	00 00                	add    %al,(%eax)
    363b:	00 00                	add    %al,(%eax)
    363d:	00 00                	add    %al,(%eax)
    363f:	00 44 00 b2          	add    %al,-0x4e(%eax,%eax,1)
    3643:	00 d2                	add    %dl,%dl
    3645:	00 00                	add    %al,(%eax)
    3647:	00 00                	add    %al,(%eax)
    3649:	00 00                	add    %al,(%eax)
    364b:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    364f:	00 d5                	add    %dl,%ch
    3651:	00 00                	add    %al,(%eax)
    3653:	00 00                	add    %al,(%eax)
    3655:	00 00                	add    %al,(%eax)
    3657:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
    365b:	00 da                	add    %bl,%dl
    365d:	00 00                	add    %al,(%eax)
    365f:	00 00                	add    %al,(%eax)
    3661:	00 00                	add    %al,(%eax)
    3663:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    3667:	00 dd                	add    %bl,%ch
    3669:	00 00                	add    %al,(%eax)
    366b:	00 00                	add    %al,(%eax)
    366d:	00 00                	add    %al,(%eax)
    366f:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    3673:	00 e0                	add    %ah,%al
    3675:	00 00                	add    %al,(%eax)
    3677:	00 00                	add    %al,(%eax)
    3679:	00 00                	add    %al,(%eax)
    367b:	00 44 00 c1          	add    %al,-0x3f(%eax,%eax,1)
    367f:	00 e3                	add    %ah,%bl
    3681:	00 00                	add    %al,(%eax)
    3683:	00 8d 10 00 00 40    	add    %cl,0x40000010(%ebp)
    3689:	00 00                	add    %al,(%eax)
    368b:	00 00                	add    %al,(%eax)
    368d:	00 00                	add    %al,(%eax)
    368f:	00 10                	add    %dl,(%eax)
    3691:	11 00                	adc    %eax,(%eax)
    3693:	00 40 00             	add    %al,0x0(%eax)
    3696:	00 00                	add    %al,(%eax)
    3698:	07                   	pop    %es
    3699:	00 00                	add    %al,(%eax)
    369b:	00 00                	add    %al,(%eax)
    369d:	00 00                	add    %al,(%eax)
    369f:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    36a3:	00                   	.byte 0x0
    36a4:	aa                   	stos   %al,%es:(%edi)
    36a5:	0f 28 00             	movaps (%eax),%xmm0

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
     29d:	68 65 61 64 65       	push   $0x65646165
     2a2:	72 2e                	jb     2d2 <bootmain-0x27fd2e>
     2a4:	68 00 2e 2f 78       	push   $0x782f2e00
     2a9:	38 36                	cmp    %dh,(%esi)
     2ab:	2e                   	cs
     2ac:	68 00 2e 2f 74       	push   $0x742f2e00
     2b1:	79 70                	jns    323 <bootmain-0x27fcdd>
     2b3:	65                   	gs
     2b4:	73 2e                	jae    2e4 <bootmain-0x27fd1c>
     2b6:	68 00 62 6f 6f       	push   $0x6f6f6200
     2bb:	6c                   	insb   (%dx),%es:(%edi)
     2bc:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     2c0:	2c 31                	sub    $0x31,%al
     2c2:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     2c8:	29 00                	sub    %eax,(%eax)
     2ca:	69 6e 74 38 5f 74 3a 	imul   $0x3a745f38,0x74(%esi),%ebp
     2d1:	74 28                	je     2fb <bootmain-0x27fd05>
     2d3:	33 2c 32             	xor    (%edx,%esi,1),%ebp
     2d6:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     2dc:	30 29                	xor    %ch,(%ecx)
     2de:	00 75 69             	add    %dh,0x69(%ebp)
     2e1:	6e                   	outsb  %ds:(%esi),(%dx)
     2e2:	74 38                	je     31c <bootmain-0x27fce4>
     2e4:	5f                   	pop    %edi
     2e5:	74 3a                	je     321 <bootmain-0x27fcdf>
     2e7:	74 28                	je     311 <bootmain-0x27fcef>
     2e9:	33 2c 33             	xor    (%ebx,%esi,1),%ebp
     2ec:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     2f2:	31 29                	xor    %ebp,(%ecx)
     2f4:	00 69 6e             	add    %ch,0x6e(%ecx)
     2f7:	74 31                	je     32a <bootmain-0x27fcd6>
     2f9:	36                   	ss
     2fa:	5f                   	pop    %edi
     2fb:	74 3a                	je     337 <bootmain-0x27fcc9>
     2fd:	74 28                	je     327 <bootmain-0x27fcd9>
     2ff:	33 2c 34             	xor    (%esp,%esi,1),%ebp
     302:	29 3d 28 30 2c 38    	sub    %edi,0x382c3028
     308:	29 00                	sub    %eax,(%eax)
     30a:	75 69                	jne    375 <bootmain-0x27fc8b>
     30c:	6e                   	outsb  %ds:(%esi),(%dx)
     30d:	74 31                	je     340 <bootmain-0x27fcc0>
     30f:	36                   	ss
     310:	5f                   	pop    %edi
     311:	74 3a                	je     34d <bootmain-0x27fcb3>
     313:	74 28                	je     33d <bootmain-0x27fcc3>
     315:	33 2c 35 29 3d 28 30 	xor    0x30283d29(,%esi,1),%ebp
     31c:	2c 39                	sub    $0x39,%al
     31e:	29 00                	sub    %eax,(%eax)
     320:	69 6e 74 33 32 5f 74 	imul   $0x745f3233,0x74(%esi),%ebp
     327:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     32b:	2c 36                	sub    $0x36,%al
     32d:	29 3d 28 30 2c 31    	sub    %edi,0x312c3028
     333:	29 00                	sub    %eax,(%eax)
     335:	75 69                	jne    3a0 <bootmain-0x27fc60>
     337:	6e                   	outsb  %ds:(%esi),(%dx)
     338:	74 33                	je     36d <bootmain-0x27fc93>
     33a:	32 5f 74             	xor    0x74(%edi),%bl
     33d:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     341:	2c 37                	sub    $0x37,%al
     343:	29 3d 28 30 2c 34    	sub    %edi,0x342c3028
     349:	29 00                	sub    %eax,(%eax)
     34b:	69 6e 74 36 34 5f 74 	imul   $0x745f3436,0x74(%esi),%ebp
     352:	3a 74 28 33          	cmp    0x33(%eax,%ebp,1),%dh
     356:	2c 38                	sub    $0x38,%al
     358:	29 3d 28 30 2c 36    	sub    %edi,0x362c3028
     35e:	29 00                	sub    %eax,(%eax)
     360:	75 69                	jne    3cb <bootmain-0x27fc35>
     362:	6e                   	outsb  %ds:(%esi),(%dx)
     363:	74 36                	je     39b <bootmain-0x27fc65>
     365:	34 5f                	xor    $0x5f,%al
     367:	74 3a                	je     3a3 <bootmain-0x27fc5d>
     369:	74 28                	je     393 <bootmain-0x27fc6d>
     36b:	33 2c 39             	xor    (%ecx,%edi,1),%ebp
     36e:	29 3d 28 30 2c 37    	sub    %edi,0x372c3028
     374:	29 00                	sub    %eax,(%eax)
     376:	69 6e 74 70 74 72 5f 	imul   $0x5f727470,0x74(%esi),%ebp
     37d:	74 3a                	je     3b9 <bootmain-0x27fc47>
     37f:	74 28                	je     3a9 <bootmain-0x27fc57>
     381:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     384:	30 29                	xor    %ch,(%ecx)
     386:	3d 28 33 2c 36       	cmp    $0x362c3328,%eax
     38b:	29 00                	sub    %eax,(%eax)
     38d:	75 69                	jne    3f8 <bootmain-0x27fc08>
     38f:	6e                   	outsb  %ds:(%esi),(%dx)
     390:	74 70                	je     402 <bootmain-0x27fbfe>
     392:	74 72                	je     406 <bootmain-0x27fbfa>
     394:	5f                   	pop    %edi
     395:	74 3a                	je     3d1 <bootmain-0x27fc2f>
     397:	74 28                	je     3c1 <bootmain-0x27fc3f>
     399:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     39c:	31 29                	xor    %ebp,(%ecx)
     39e:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3a3:	29 00                	sub    %eax,(%eax)
     3a5:	70 68                	jo     40f <bootmain-0x27fbf1>
     3a7:	79 73                	jns    41c <bootmain-0x27fbe4>
     3a9:	61                   	popa   
     3aa:	64                   	fs
     3ab:	64                   	fs
     3ac:	72 5f                	jb     40d <bootmain-0x27fbf3>
     3ae:	74 3a                	je     3ea <bootmain-0x27fc16>
     3b0:	74 28                	je     3da <bootmain-0x27fc26>
     3b2:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3b5:	32 29                	xor    (%ecx),%ch
     3b7:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3bc:	29 00                	sub    %eax,(%eax)
     3be:	70 70                	jo     430 <bootmain-0x27fbd0>
     3c0:	6e                   	outsb  %ds:(%esi),(%dx)
     3c1:	5f                   	pop    %edi
     3c2:	74 3a                	je     3fe <bootmain-0x27fc02>
     3c4:	74 28                	je     3ee <bootmain-0x27fc12>
     3c6:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3c9:	33 29                	xor    (%ecx),%ebp
     3cb:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3d0:	29 00                	sub    %eax,(%eax)
     3d2:	73 69                	jae    43d <bootmain-0x27fbc3>
     3d4:	7a 65                	jp     43b <bootmain-0x27fbc5>
     3d6:	5f                   	pop    %edi
     3d7:	74 3a                	je     413 <bootmain-0x27fbed>
     3d9:	74 28                	je     403 <bootmain-0x27fbfd>
     3db:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     3de:	34 29                	xor    $0x29,%al
     3e0:	3d 28 33 2c 37       	cmp    $0x372c3328,%eax
     3e5:	29 00                	sub    %eax,(%eax)
     3e7:	73 73                	jae    45c <bootmain-0x27fba4>
     3e9:	69 7a 65 5f 74 3a 74 	imul   $0x743a745f,0x65(%edx),%edi
     3f0:	28 33                	sub    %dh,(%ebx)
     3f2:	2c 31                	sub    $0x31,%al
     3f4:	35 29 3d 28 33       	xor    $0x33283d29,%eax
     3f9:	2c 36                	sub    $0x36,%al
     3fb:	29 00                	sub    %eax,(%eax)
     3fd:	6f                   	outsl  %ds:(%esi),(%dx)
     3fe:	66 66 5f             	data32 pop %di
     401:	74 3a                	je     43d <bootmain-0x27fbc3>
     403:	74 28                	je     42d <bootmain-0x27fbd3>
     405:	33 2c 31             	xor    (%ecx,%esi,1),%ebp
     408:	36 29 3d 28 33 2c 36 	sub    %edi,%ss:0x362c3328
     40f:	29 00                	sub    %eax,(%eax)
     411:	2e                   	cs
     412:	2f                   	das    
     413:	6d                   	insl   (%dx),%es:(%edi)
     414:	6d                   	insl   (%dx),%es:(%edi)
     415:	2e                   	cs
     416:	68 00 43 65 6c       	push   $0x6c654300
     41b:	6c                   	insb   (%dx),%es:(%edi)
     41c:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     420:	2c 31                	sub    $0x31,%al
     422:	29 3d 73 38 61 64    	sub    %edi,0x64613873
     428:	64                   	fs
     429:	72 65                	jb     490 <bootmain-0x27fb70>
     42b:	73 73                	jae    4a0 <bootmain-0x27fb60>
     42d:	3a 28                	cmp    (%eax),%ch
     42f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     432:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     435:	2c 33                	sub    $0x33,%al
     437:	32 3b                	xor    (%ebx),%bh
     439:	73 69                	jae    4a4 <bootmain-0x27fb5c>
     43b:	7a 65                	jp     4a2 <bootmain-0x27fb5e>
     43d:	3a 28                	cmp    (%eax),%ch
     43f:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     442:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     445:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     448:	32 3b                	xor    (%ebx),%bh
     44a:	3b 00                	cmp    (%eax),%eax
     44c:	43                   	inc    %ebx
     44d:	65                   	gs
     44e:	6c                   	insb   (%dx),%es:(%edi)
     44f:	6c                   	insb   (%dx),%es:(%edi)
     450:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     454:	2c 32                	sub    $0x32,%al
     456:	29 3d 28 34 2c 31    	sub    %edi,0x312c3428
     45c:	29 00                	sub    %eax,(%eax)
     45e:	4d                   	dec    %ebp
     45f:	65                   	gs
     460:	6d                   	insl   (%dx),%es:(%edi)
     461:	6d                   	insl   (%dx),%es:(%edi)
     462:	61                   	popa   
     463:	6e                   	outsb  %ds:(%esi),(%dx)
     464:	3a 54 28 34          	cmp    0x34(%eax,%ebp,1),%dl
     468:	2c 33                	sub    $0x33,%al
     46a:	29 3d 73 33 32 37    	sub    %edi,0x37323373
     470:	33 36                	xor    (%esi),%esi
     472:	63 65 6c             	arpl   %sp,0x6c(%ebp)
     475:	6c                   	insb   (%dx),%es:(%edi)
     476:	6e                   	outsb  %ds:(%esi),(%dx)
     477:	75 6d                	jne    4e6 <bootmain-0x27fb1a>
     479:	3a 28                	cmp    (%eax),%ch
     47b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     47e:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     481:	2c 33                	sub    $0x33,%al
     483:	32 3b                	xor    (%ebx),%bh
     485:	6d                   	insl   (%dx),%es:(%edi)
     486:	61                   	popa   
     487:	78 63                	js     4ec <bootmain-0x27fb14>
     489:	65                   	gs
     48a:	6c                   	insb   (%dx),%es:(%edi)
     48b:	6c                   	insb   (%dx),%es:(%edi)
     48c:	3a 28                	cmp    (%eax),%ch
     48e:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     491:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     494:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     497:	32 3b                	xor    (%ebx),%bh
     499:	6c                   	insb   (%dx),%es:(%edi)
     49a:	6f                   	outsl  %ds:(%esi),(%dx)
     49b:	73 74                	jae    511 <bootmain-0x27faef>
     49d:	73 69                	jae    508 <bootmain-0x27faf8>
     49f:	7a 65                	jp     506 <bootmain-0x27fafa>
     4a1:	3a 28                	cmp    (%eax),%ch
     4a3:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     4a6:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     4a9:	34 2c                	xor    $0x2c,%al
     4ab:	33 32                	xor    (%edx),%esi
     4ad:	3b 6c 6f 73          	cmp    0x73(%edi,%ebp,2),%ebp
     4b1:	74 73                	je     526 <bootmain-0x27fada>
     4b3:	3a 28                	cmp    (%eax),%ch
     4b5:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     4b8:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     4bb:	36                   	ss
     4bc:	2c 33                	sub    $0x33,%al
     4be:	32 3b                	xor    (%ebx),%bh
     4c0:	63 65 6c             	arpl   %sp,0x6c(%ebp)
     4c3:	6c                   	insb   (%dx),%es:(%edi)
     4c4:	3a 28                	cmp    (%eax),%ch
     4c6:	34 2c                	xor    $0x2c,%al
     4c8:	34 29                	xor    $0x29,%al
     4ca:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     4cf:	2c 35                	sub    $0x35,%al
     4d1:	29 3d 72 28 34 2c    	sub    %edi,0x2c342872
     4d7:	35 29 3b 30 3b       	xor    $0x3b303b29,%eax
     4dc:	34 32                	xor    $0x32,%al
     4de:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
     4e1:	36                   	ss
     4e2:	37                   	aaa    
     4e3:	32 39                	xor    (%ecx),%bh
     4e5:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
     4ea:	34 30                	xor    $0x30,%al
     4ec:	38 39                	cmp    %bh,(%ecx)
     4ee:	3b 28                	cmp    (%eax),%ebp
     4f0:	34 2c                	xor    $0x2c,%al
     4f2:	32 29                	xor    (%ecx),%ch
     4f4:	2c 31                	sub    $0x31,%al
     4f6:	32 38                	xor    (%eax),%bh
     4f8:	2c 32                	sub    $0x32,%al
     4fa:	36 31 37             	xor    %esi,%ss:(%edi)
     4fd:	36 30 3b             	xor    %bh,%ss:(%ebx)
     500:	3b 00                	cmp    (%eax),%eax
     502:	4d                   	dec    %ebp
     503:	65                   	gs
     504:	6d                   	insl   (%dx),%es:(%edi)
     505:	6d                   	insl   (%dx),%es:(%edi)
     506:	61                   	popa   
     507:	6e                   	outsb  %ds:(%esi),(%dx)
     508:	3a 74 28 34          	cmp    0x34(%eax,%ebp,1),%dh
     50c:	2c 36                	sub    $0x36,%al
     50e:	29 3d 28 34 2c 33    	sub    %edi,0x332c3428
     514:	29 00                	sub    %eax,(%eax)
     516:	62 6f 6f             	bound  %ebp,0x6f(%edi)
     519:	74 5f                	je     57a <bootmain-0x27fa86>
     51b:	69 6e 66 6f 3a 54 28 	imul   $0x28543a6f,0x66(%esi),%ebp
     522:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
     525:	29 3d 73 31 32 63    	sub    %edi,0x63323173
     52b:	79 6c                	jns    599 <bootmain-0x27fa67>
     52d:	69 6e 64 65 72 3a 28 	imul   $0x283a7265,0x64(%esi),%ebp
     534:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     537:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     53a:	2c 38                	sub    $0x38,%al
     53c:	3b 6c 65 64          	cmp    0x64(%ebp,%eiz,2),%ebp
     540:	3a 28                	cmp    (%eax),%ch
     542:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     545:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
     548:	2c 38                	sub    $0x38,%al
     54a:	3b 63 6f             	cmp    0x6f(%ebx),%esp
     54d:	6c                   	insb   (%dx),%es:(%edi)
     54e:	6f                   	outsl  %ds:(%esi),(%dx)
     54f:	72 5f                	jb     5b0 <bootmain-0x27fa50>
     551:	6d                   	insl   (%dx),%es:(%edi)
     552:	6f                   	outsl  %ds:(%esi),(%dx)
     553:	64 65 3a 28          	fs cmp %fs:%gs:(%eax),%ch
     557:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     55a:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     55d:	36                   	ss
     55e:	2c 38                	sub    $0x38,%al
     560:	3b 72 65             	cmp    0x65(%edx),%esi
     563:	73 65                	jae    5ca <bootmain-0x27fa36>
     565:	72 76                	jb     5dd <bootmain-0x27fa23>
     567:	65 64 3a 28          	gs cmp %fs:%gs:(%eax),%ch
     56b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     56e:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
     571:	34 2c                	xor    $0x2c,%al
     573:	38 3b                	cmp    %bh,(%ebx)
     575:	78 73                	js     5ea <bootmain-0x27fa16>
     577:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     57e:	38 29                	cmp    %ch,(%ecx)
     580:	2c 33                	sub    $0x33,%al
     582:	32 2c 31             	xor    (%ecx,%esi,1),%ch
     585:	36 3b 79 73          	cmp    %ss:0x73(%ecx),%edi
     589:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
     590:	38 29                	cmp    %ch,(%ecx)
     592:	2c 34                	sub    $0x34,%al
     594:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     597:	36 3b 76 72          	cmp    %ss:0x72(%esi),%esi
     59b:	61                   	popa   
     59c:	6d                   	insl   (%dx),%es:(%edi)
     59d:	3a 28                	cmp    (%eax),%ch
     59f:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     5a2:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
     5a8:	32 29                	xor    (%ecx),%ch
     5aa:	2c 36                	sub    $0x36,%al
     5ac:	34 2c                	xor    $0x2c,%al
     5ae:	33 32                	xor    (%edx),%esi
     5b0:	3b 3b                	cmp    (%ebx),%edi
     5b2:	00 47 44             	add    %al,0x44(%edi)
     5b5:	54                   	push   %esp
     5b6:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     5ba:	2c 33                	sub    $0x33,%al
     5bc:	29 3d 73 38 6c 69    	sub    %edi,0x696c3873
     5c2:	6d                   	insl   (%dx),%es:(%edi)
     5c3:	69 74 5f 6c 6f 77 3a 	imul   $0x283a776f,0x6c(%edi,%ebx,2),%esi
     5ca:	28 
     5cb:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     5ce:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     5d1:	2c 31                	sub    $0x31,%al
     5d3:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     5d7:	73 65                	jae    63e <bootmain-0x27f9c2>
     5d9:	5f                   	pop    %edi
     5da:	6c                   	insb   (%dx),%es:(%edi)
     5db:	6f                   	outsl  %ds:(%esi),(%dx)
     5dc:	77 3a                	ja     618 <bootmain-0x27f9e8>
     5de:	28 30                	sub    %dh,(%eax)
     5e0:	2c 38                	sub    $0x38,%al
     5e2:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     5e5:	36                   	ss
     5e6:	2c 31                	sub    $0x31,%al
     5e8:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
     5ec:	73 65                	jae    653 <bootmain-0x27f9ad>
     5ee:	5f                   	pop    %edi
     5ef:	6d                   	insl   (%dx),%es:(%edi)
     5f0:	69 64 3a 28 30 2c 32 	imul   $0x29322c30,0x28(%edx,%edi,1),%esp
     5f7:	29 
     5f8:	2c 33                	sub    $0x33,%al
     5fa:	32 2c 38             	xor    (%eax,%edi,1),%ch
     5fd:	3b 61 63             	cmp    0x63(%ecx),%esp
     600:	63 65 73             	arpl   %sp,0x73(%ebp)
     603:	73 5f                	jae    664 <bootmain-0x27f99c>
     605:	72 69                	jb     670 <bootmain-0x27f990>
     607:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     60d:	2c 32                	sub    $0x32,%al
     60f:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     612:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     615:	3b 6c 69 6d          	cmp    0x6d(%ecx,%ebp,2),%ebp
     619:	69 74 5f 68 69 67 68 	imul   $0x3a686769,0x68(%edi,%ebx,2),%esi
     620:	3a 
     621:	28 30                	sub    %dh,(%eax)
     623:	2c 32                	sub    $0x32,%al
     625:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     628:	38 2c 38             	cmp    %ch,(%eax,%edi,1)
     62b:	3b 62 61             	cmp    0x61(%edx),%esp
     62e:	73 65                	jae    695 <bootmain-0x27f96b>
     630:	5f                   	pop    %edi
     631:	68 69 67 68 3a       	push   $0x3a686769
     636:	28 30                	sub    %dh,(%eax)
     638:	2c 32                	sub    $0x32,%al
     63a:	29 2c 35 36 2c 38 3b 	sub    %ebp,0x3b382c36(,%esi,1)
     641:	3b 00                	cmp    (%eax),%eax
     643:	49                   	dec    %ecx
     644:	44                   	inc    %esp
     645:	54                   	push   %esp
     646:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     64a:	2c 34                	sub    $0x34,%al
     64c:	29 3d 73 38 6f 66    	sub    %edi,0x666f3873
     652:	66                   	data16
     653:	73 65                	jae    6ba <bootmain-0x27f946>
     655:	74 5f                	je     6b6 <bootmain-0x27f94a>
     657:	6c                   	insb   (%dx),%es:(%edi)
     658:	6f                   	outsl  %ds:(%esi),(%dx)
     659:	77 3a                	ja     695 <bootmain-0x27f96b>
     65b:	28 30                	sub    %dh,(%eax)
     65d:	2c 38                	sub    $0x38,%al
     65f:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     662:	2c 31                	sub    $0x31,%al
     664:	36 3b 73 65          	cmp    %ss:0x65(%ebx),%esi
     668:	6c                   	insb   (%dx),%es:(%edi)
     669:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     66e:	3a 28                	cmp    (%eax),%ch
     670:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     673:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     676:	36                   	ss
     677:	2c 31                	sub    $0x31,%al
     679:	36 3b 64 77 5f       	cmp    %ss:0x5f(%edi,%esi,2),%esp
     67e:	63 6f 75             	arpl   %bp,0x75(%edi)
     681:	6e                   	outsb  %ds:(%esi),(%dx)
     682:	74 3a                	je     6be <bootmain-0x27f942>
     684:	28 30                	sub    %dh,(%eax)
     686:	2c 32                	sub    $0x32,%al
     688:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     68b:	32 2c 38             	xor    (%eax,%edi,1),%ch
     68e:	3b 61 63             	cmp    0x63(%ecx),%esp
     691:	63 65 73             	arpl   %sp,0x73(%ebp)
     694:	73 5f                	jae    6f5 <bootmain-0x27f90b>
     696:	72 69                	jb     701 <bootmain-0x27f8ff>
     698:	67 68 74 3a 28 30    	addr16 push $0x30283a74
     69e:	2c 32                	sub    $0x32,%al
     6a0:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     6a3:	30 2c 38             	xor    %ch,(%eax,%edi,1)
     6a6:	3b 6f 66             	cmp    0x66(%edi),%ebp
     6a9:	66                   	data16
     6aa:	73 65                	jae    711 <bootmain-0x27f8ef>
     6ac:	74 5f                	je     70d <bootmain-0x27f8f3>
     6ae:	68 69 67 68 3a       	push   $0x3a686769
     6b3:	28 30                	sub    %dh,(%eax)
     6b5:	2c 38                	sub    $0x38,%al
     6b7:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
     6ba:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
     6bd:	36 3b 3b             	cmp    %ss:(%ebx),%edi
     6c0:	00 46 49             	add    %al,0x49(%esi)
     6c3:	46                   	inc    %esi
     6c4:	4f                   	dec    %edi
     6c5:	38 3a                	cmp    %bh,(%edx)
     6c7:	54                   	push   %esp
     6c8:	28 31                	sub    %dh,(%ecx)
     6ca:	2c 35                	sub    $0x35,%al
     6cc:	29 3d 73 32 34 62    	sub    %edi,0x62343273
     6d2:	75 66                	jne    73a <bootmain-0x27f8c6>
     6d4:	3a 28                	cmp    (%eax),%ch
     6d6:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     6d9:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
     6df:	31 31                	xor    %esi,(%ecx)
     6e1:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
     6e4:	2c 33                	sub    $0x33,%al
     6e6:	32 3b                	xor    (%ebx),%bh
     6e8:	6e                   	outsb  %ds:(%esi),(%dx)
     6e9:	77 3a                	ja     725 <bootmain-0x27f8db>
     6eb:	28 30                	sub    %dh,(%eax)
     6ed:	2c 31                	sub    $0x31,%al
     6ef:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     6f2:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     6f5:	32 3b                	xor    (%ebx),%bh
     6f7:	6e                   	outsb  %ds:(%esi),(%dx)
     6f8:	72 3a                	jb     734 <bootmain-0x27f8cc>
     6fa:	28 30                	sub    %dh,(%eax)
     6fc:	2c 31                	sub    $0x31,%al
     6fe:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     701:	34 2c                	xor    $0x2c,%al
     703:	33 32                	xor    (%edx),%esi
     705:	3b 73 69             	cmp    0x69(%ebx),%esi
     708:	7a 65                	jp     76f <bootmain-0x27f891>
     70a:	3a 28                	cmp    (%eax),%ch
     70c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     70f:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     712:	36                   	ss
     713:	2c 33                	sub    $0x33,%al
     715:	32 3b                	xor    (%ebx),%bh
     717:	66                   	data16
     718:	72 65                	jb     77f <bootmain-0x27f881>
     71a:	65 3a 28             	cmp    %gs:(%eax),%ch
     71d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     720:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     723:	32 38                	xor    (%eax),%bh
     725:	2c 33                	sub    $0x33,%al
     727:	32 3b                	xor    (%ebx),%bh
     729:	66                   	data16
     72a:	6c                   	insb   (%dx),%es:(%edi)
     72b:	61                   	popa   
     72c:	67 73 3a             	addr16 jae 769 <bootmain-0x27f897>
     72f:	28 30                	sub    %dh,(%eax)
     731:	2c 31                	sub    $0x31,%al
     733:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
     736:	36 30 2c 33          	xor    %ch,%ss:(%ebx,%esi,1)
     73a:	32 3b                	xor    (%ebx),%bh
     73c:	3b 00                	cmp    (%eax),%eax
     73e:	4d                   	dec    %ebp
     73f:	4f                   	dec    %edi
     740:	55                   	push   %ebp
     741:	53                   	push   %ebx
     742:	45                   	inc    %ebp
     743:	5f                   	pop    %edi
     744:	44                   	inc    %esp
     745:	45                   	inc    %ebp
     746:	43                   	inc    %ebx
     747:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
     74b:	2c 37                	sub    $0x37,%al
     74d:	29 3d 73 31 36 62    	sub    %edi,0x62363173
     753:	75 66                	jne    7bb <bootmain-0x27f845>
     755:	3a 28                	cmp    (%eax),%ch
     757:	31 2c 38             	xor    %ebp,(%eax,%edi,1)
     75a:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     760:	2c 35                	sub    $0x35,%al
     762:	29 3b                	sub    %edi,(%ebx)
     764:	30 3b                	xor    %bh,(%ebx)
     766:	32 3b                	xor    (%ebx),%bh
     768:	28 30                	sub    %dh,(%eax)
     76a:	2c 31                	sub    $0x31,%al
     76c:	31 29                	xor    %ebp,(%ecx)
     76e:	2c 30                	sub    $0x30,%al
     770:	2c 32                	sub    $0x32,%al
     772:	34 3b                	xor    $0x3b,%al
     774:	70 68                	jo     7de <bootmain-0x27f822>
     776:	61                   	popa   
     777:	73 65                	jae    7de <bootmain-0x27f822>
     779:	3a 28                	cmp    (%eax),%ch
     77b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     77e:	31 29                	xor    %ebp,(%ecx)
     780:	2c 32                	sub    $0x32,%al
     782:	34 2c                	xor    $0x2c,%al
     784:	38 3b                	cmp    %bh,(%ebx)
     786:	78 3a                	js     7c2 <bootmain-0x27f83e>
     788:	28 30                	sub    %dh,(%eax)
     78a:	2c 31                	sub    $0x31,%al
     78c:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
     78f:	32 2c 33             	xor    (%ebx,%esi,1),%ch
     792:	32 3b                	xor    (%ebx),%bh
     794:	79 3a                	jns    7d0 <bootmain-0x27f830>
     796:	28 30                	sub    %dh,(%eax)
     798:	2c 31                	sub    $0x31,%al
     79a:	29 2c 36             	sub    %ebp,(%esi,%esi,1)
     79d:	34 2c                	xor    $0x2c,%al
     79f:	33 32                	xor    (%edx),%esi
     7a1:	3b 62 75             	cmp    0x75(%edx),%esp
     7a4:	74 74                	je     81a <bootmain-0x27f7e6>
     7a6:	6f                   	outsl  %ds:(%esi),(%dx)
     7a7:	6e                   	outsb  %ds:(%esi),(%dx)
     7a8:	3a 28                	cmp    (%eax),%ch
     7aa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     7ad:	29 2c 39             	sub    %ebp,(%ecx,%edi,1)
     7b0:	36                   	ss
     7b1:	2c 33                	sub    $0x33,%al
     7b3:	32 3b                	xor    (%ebx),%bh
     7b5:	3b 00                	cmp    (%eax),%eax
     7b7:	62 6f 6f             	bound  %ebp,0x6f(%edi)
     7ba:	74 6d                	je     829 <bootmain-0x27f7d7>
     7bc:	61                   	popa   
     7bd:	69 6e 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%esi),%ebp
     7c4:	31 38                	xor    %edi,(%eax)
     7c6:	29 00                	sub    %eax,(%eax)
     7c8:	6d                   	insl   (%dx),%es:(%edi)
     7c9:	6f                   	outsl  %ds:(%esi),(%dx)
     7ca:	75 73                	jne    83f <bootmain-0x27f7c1>
     7cc:	65                   	gs
     7cd:	70 69                	jo     838 <bootmain-0x27f7c8>
     7cf:	63 3a                	arpl   %di,(%edx)
     7d1:	28 30                	sub    %dh,(%eax)
     7d3:	2c 31                	sub    $0x31,%al
     7d5:	39 29                	cmp    %ebp,(%ecx)
     7d7:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     7dc:	2c 35                	sub    $0x35,%al
     7de:	29 3b                	sub    %edi,(%ebx)
     7e0:	30 3b                	xor    %bh,(%ebx)
     7e2:	32 35 35 3b 28 30    	xor    0x30283b35,%dh
     7e8:	2c 32                	sub    $0x32,%al
     7ea:	29 00                	sub    %eax,(%eax)
     7ec:	73 3a                	jae    828 <bootmain-0x27f7d8>
     7ee:	28 30                	sub    %dh,(%eax)
     7f0:	2c 32                	sub    $0x32,%al
     7f2:	30 29                	xor    %ch,(%ecx)
     7f4:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     7f9:	2c 35                	sub    $0x35,%al
     7fb:	29 3b                	sub    %edi,(%ebx)
     7fd:	30 3b                	xor    %bh,(%ebx)
     7ff:	33 39                	xor    (%ecx),%edi
     801:	3b 28                	cmp    (%eax),%ebp
     803:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     806:	31 29                	xor    %ebp,(%ecx)
     808:	00 6b 65             	add    %ch,0x65(%ebx)
     80b:	79 62                	jns    86f <bootmain-0x27f791>
     80d:	75 66                	jne    875 <bootmain-0x27f78b>
     80f:	3a 28                	cmp    (%eax),%ch
     811:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     814:	31 29                	xor    %ebp,(%ecx)
     816:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     81b:	2c 35                	sub    $0x35,%al
     81d:	29 3b                	sub    %edi,(%ebx)
     81f:	30 3b                	xor    %bh,(%ebx)
     821:	33 31                	xor    (%ecx),%esi
     823:	3b 28                	cmp    (%eax),%ebp
     825:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     828:	31 29                	xor    %ebp,(%ecx)
     82a:	00 6d 6f             	add    %ch,0x6f(%ebp)
     82d:	75 73                	jne    8a2 <bootmain-0x27f75e>
     82f:	65 62 75 66          	bound  %esi,%gs:0x66(%ebp)
     833:	3a 28                	cmp    (%eax),%ch
     835:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     838:	32 29                	xor    (%ecx),%ch
     83a:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     83f:	2c 35                	sub    $0x35,%al
     841:	29 3b                	sub    %edi,(%ebx)
     843:	30 3b                	xor    %bh,(%ebx)
     845:	31 32                	xor    %esi,(%edx)
     847:	37                   	aaa    
     848:	3b 28                	cmp    (%eax),%ebp
     84a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     84d:	31 29                	xor    %ebp,(%ecx)
     84f:	00 6d 64             	add    %ch,0x64(%ebp)
     852:	65 63 3a             	arpl   %di,%gs:(%edx)
     855:	28 31                	sub    %dh,(%ecx)
     857:	2c 37                	sub    $0x37,%al
     859:	29 00                	sub    %eax,(%eax)
     85b:	6d                   	insl   (%dx),%es:(%edi)
     85c:	65                   	gs
     85d:	6d                   	insl   (%dx),%es:(%edi)
     85e:	74 6f                	je     8cf <bootmain-0x27f731>
     860:	74 61                	je     8c3 <bootmain-0x27f73d>
     862:	6c                   	insb   (%dx),%es:(%edi)
     863:	3a 72 28             	cmp    0x28(%edx),%dh
     866:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     869:	29 00                	sub    %eax,(%eax)
     86b:	41                   	inc    %ecx
     86c:	53                   	push   %ebx
     86d:	43                   	inc    %ebx
     86e:	49                   	dec    %ecx
     86f:	49                   	dec    %ecx
     870:	5f                   	pop    %edi
     871:	54                   	push   %esp
     872:	61                   	popa   
     873:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
     877:	47                   	inc    %edi
     878:	28 30                	sub    %dh,(%eax)
     87a:	2c 32                	sub    $0x32,%al
     87c:	33 29                	xor    (%ecx),%ebp
     87e:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     883:	2c 35                	sub    $0x35,%al
     885:	29 3b                	sub    %edi,(%ebx)
     887:	30 3b                	xor    %bh,(%ebx)
     889:	32 32                	xor    (%edx),%dh
     88b:	37                   	aaa    
     88c:	39 3b                	cmp    %edi,(%ebx)
     88e:	28 30                	sub    %dh,(%eax)
     890:	2c 39                	sub    $0x39,%al
     892:	29 00                	sub    %eax,(%eax)
     894:	46                   	inc    %esi
     895:	6f                   	outsl  %ds:(%esi),(%dx)
     896:	6e                   	outsb  %ds:(%esi),(%dx)
     897:	74 38                	je     8d1 <bootmain-0x27f72f>
     899:	78 31                	js     8cc <bootmain-0x27f734>
     89b:	36 3a 47 28          	cmp    %ss:0x28(%edi),%al
     89f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     8a2:	34 29                	xor    $0x29,%al
     8a4:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     8a9:	2c 35                	sub    $0x35,%al
     8ab:	29 3b                	sub    %edi,(%ebx)
     8ad:	30 3b                	xor    %bh,(%ebx)
     8af:	32 30                	xor    (%eax),%dh
     8b1:	34 37                	xor    $0x37,%al
     8b3:	3b 28                	cmp    (%eax),%ebp
     8b5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8b8:	31 29                	xor    %ebp,(%ecx)
     8ba:	00 73 63             	add    %dh,0x63(%ebx)
     8bd:	72 65                	jb     924 <bootmain-0x27f6dc>
     8bf:	65 6e                	outsb  %gs:(%esi),(%dx)
     8c1:	2e 63 00             	arpl   %ax,%cs:(%eax)
     8c4:	63 6c 65 61          	arpl   %bp,0x61(%ebp,%eiz,2)
     8c8:	72 5f                	jb     929 <bootmain-0x27f6d7>
     8ca:	73 63                	jae    92f <bootmain-0x27f6d1>
     8cc:	72 65                	jb     933 <bootmain-0x27f6cd>
     8ce:	65 6e                	outsb  %gs:(%esi),(%dx)
     8d0:	3a 46 28             	cmp    0x28(%esi),%al
     8d3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8d6:	38 29                	cmp    %ch,(%ecx)
     8d8:	00 63 6f             	add    %ah,0x6f(%ebx)
     8db:	6c                   	insb   (%dx),%es:(%edi)
     8dc:	6f                   	outsl  %ds:(%esi),(%dx)
     8dd:	72 3a                	jb     919 <bootmain-0x27f6e7>
     8df:	70 28                	jo     909 <bootmain-0x27f6f7>
     8e1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     8e4:	29 00                	sub    %eax,(%eax)
     8e6:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
     8ec:	31 29                	xor    %ebp,(%ecx)
     8ee:	00 63 6f             	add    %ah,0x6f(%ebx)
     8f1:	6c                   	insb   (%dx),%es:(%edi)
     8f2:	6f                   	outsl  %ds:(%esi),(%dx)
     8f3:	72 3a                	jb     92f <bootmain-0x27f6d1>
     8f5:	72 28                	jb     91f <bootmain-0x27f6e1>
     8f7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     8fa:	29 00                	sub    %eax,(%eax)
     8fc:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     8ff:	6f                   	outsl  %ds:(%esi),(%dx)
     900:	72 5f                	jb     961 <bootmain-0x27f69f>
     902:	73 63                	jae    967 <bootmain-0x27f699>
     904:	72 65                	jb     96b <bootmain-0x27f695>
     906:	65 6e                	outsb  %gs:(%esi),(%dx)
     908:	3a 46 28             	cmp    0x28(%esi),%al
     90b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     90e:	38 29                	cmp    %ch,(%ecx)
     910:	00 73 65             	add    %dh,0x65(%ebx)
     913:	74 5f                	je     974 <bootmain-0x27f68c>
     915:	70 61                	jo     978 <bootmain-0x27f688>
     917:	6c                   	insb   (%dx),%es:(%edi)
     918:	65                   	gs
     919:	74 74                	je     98f <bootmain-0x27f671>
     91b:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     91f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     922:	38 29                	cmp    %ch,(%ecx)
     924:	00 73 74             	add    %dh,0x74(%ebx)
     927:	61                   	popa   
     928:	72 74                	jb     99e <bootmain-0x27f662>
     92a:	3a 70 28             	cmp    0x28(%eax),%dh
     92d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     930:	29 00                	sub    %eax,(%eax)
     932:	65 6e                	outsb  %gs:(%esi),(%dx)
     934:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
     938:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     93b:	29 00                	sub    %eax,(%eax)
     93d:	72 67                	jb     9a6 <bootmain-0x27f65a>
     93f:	62 3a                	bound  %edi,(%edx)
     941:	70 28                	jo     96b <bootmain-0x27f695>
     943:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     946:	29 00                	sub    %eax,(%eax)
     948:	73 74                	jae    9be <bootmain-0x27f642>
     94a:	61                   	popa   
     94b:	72 74                	jb     9c1 <bootmain-0x27f63f>
     94d:	3a 72 28             	cmp    0x28(%edx),%dh
     950:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     953:	29 00                	sub    %eax,(%eax)
     955:	72 67                	jb     9be <bootmain-0x27f642>
     957:	62 3a                	bound  %edi,(%edx)
     959:	72 28                	jb     983 <bootmain-0x27f67d>
     95b:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     95e:	29 00                	sub    %eax,(%eax)
     960:	69 6e 69 74 5f 70 61 	imul   $0x61705f74,0x69(%esi),%ebp
     967:	6c                   	insb   (%dx),%es:(%edi)
     968:	65                   	gs
     969:	74 74                	je     9df <bootmain-0x27f621>
     96b:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     96f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     972:	38 29                	cmp    %ch,(%ecx)
     974:	00 74 61 62          	add    %dh,0x62(%ecx,%eiz,2)
     978:	6c                   	insb   (%dx),%es:(%edi)
     979:	65                   	gs
     97a:	5f                   	pop    %edi
     97b:	72 67                	jb     9e4 <bootmain-0x27f61c>
     97d:	62 3a                	bound  %edi,(%edx)
     97f:	28 30                	sub    %dh,(%eax)
     981:	2c 31                	sub    $0x31,%al
     983:	39 29                	cmp    %ebp,(%ecx)
     985:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     98a:	2c 35                	sub    $0x35,%al
     98c:	29 3b                	sub    %edi,(%ebx)
     98e:	30 3b                	xor    %bh,(%ebx)
     990:	34 37                	xor    $0x37,%al
     992:	3b 28                	cmp    (%eax),%ebp
     994:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     997:	31 29                	xor    %ebp,(%ecx)
     999:	00 62 6f             	add    %ah,0x6f(%edx)
     99c:	78 66                	js     a04 <bootmain-0x27f5fc>
     99e:	69 6c 6c 38 3a 46 28 	imul   $0x3028463a,0x38(%esp,%ebp,2),%ebp
     9a5:	30 
     9a6:	2c 31                	sub    $0x31,%al
     9a8:	38 29                	cmp    %ch,(%ecx)
     9aa:	00 76 72             	add    %dh,0x72(%esi)
     9ad:	61                   	popa   
     9ae:	6d                   	insl   (%dx),%es:(%edi)
     9af:	3a 70 28             	cmp    0x28(%eax),%dh
     9b2:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     9b5:	29 00                	sub    %eax,(%eax)
     9b7:	78 73                	js     a2c <bootmain-0x27f5d4>
     9b9:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     9c0:	2c 31                	sub    $0x31,%al
     9c2:	29 00                	sub    %eax,(%eax)
     9c4:	78 30                	js     9f6 <bootmain-0x27f60a>
     9c6:	3a 70 28             	cmp    0x28(%eax),%dh
     9c9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9cc:	29 00                	sub    %eax,(%eax)
     9ce:	79 30                	jns    a00 <bootmain-0x27f600>
     9d0:	3a 70 28             	cmp    0x28(%eax),%dh
     9d3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9d6:	29 00                	sub    %eax,(%eax)
     9d8:	78 31                	js     a0b <bootmain-0x27f5f5>
     9da:	3a 70 28             	cmp    0x28(%eax),%dh
     9dd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9e0:	29 00                	sub    %eax,(%eax)
     9e2:	79 31                	jns    a15 <bootmain-0x27f5eb>
     9e4:	3a 70 28             	cmp    0x28(%eax),%dh
     9e7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9ea:	29 00                	sub    %eax,(%eax)
     9ec:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     9ef:	6f                   	outsl  %ds:(%esi),(%dx)
     9f0:	72 3a                	jb     a2c <bootmain-0x27f5d4>
     9f2:	72 28                	jb     a1c <bootmain-0x27f5e4>
     9f4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     9f7:	31 29                	xor    %ebp,(%ecx)
     9f9:	00 79 30             	add    %bh,0x30(%ecx)
     9fc:	3a 72 28             	cmp    0x28(%edx),%dh
     9ff:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a02:	29 00                	sub    %eax,(%eax)
     a04:	62 6f 78             	bound  %ebp,0x78(%edi)
     a07:	66 69 6c 6c 3a 46 28 	imul   $0x2846,0x3a(%esp,%ebp,2),%bp
     a0e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a11:	38 29                	cmp    %ch,(%ecx)
     a13:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
     a17:	77 5f                	ja     a78 <bootmain-0x27f588>
     a19:	77 69                	ja     a84 <bootmain-0x27f57c>
     a1b:	6e                   	outsb  %ds:(%esi),(%dx)
     a1c:	64 6f                	outsl  %fs:(%esi),(%dx)
     a1e:	77 3a                	ja     a5a <bootmain-0x27f5a6>
     a20:	46                   	inc    %esi
     a21:	28 30                	sub    %dh,(%eax)
     a23:	2c 31                	sub    $0x31,%al
     a25:	38 29                	cmp    %ch,(%ecx)
     a27:	00 69 6e             	add    %ch,0x6e(%ecx)
     a2a:	69 74 5f 73 63 72 65 	imul   $0x65657263,0x73(%edi,%ebx,2),%esi
     a31:	65 
     a32:	6e                   	outsb  %ds:(%esi),(%dx)
     a33:	3a 46 28             	cmp    0x28(%esi),%al
     a36:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a39:	38 29                	cmp    %ch,(%ecx)
     a3b:	00 62 6f             	add    %ah,0x6f(%edx)
     a3e:	6f                   	outsl  %ds:(%esi),(%dx)
     a3f:	74 70                	je     ab1 <bootmain-0x27f54f>
     a41:	3a 70 28             	cmp    0x28(%eax),%dh
     a44:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a47:	30 29                	xor    %ch,(%ecx)
     a49:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     a4e:	31 29                	xor    %ebp,(%ecx)
     a50:	00 62 6f             	add    %ah,0x6f(%edx)
     a53:	6f                   	outsl  %ds:(%esi),(%dx)
     a54:	74 70                	je     ac6 <bootmain-0x27f53a>
     a56:	3a 72 28             	cmp    0x28(%edx),%dh
     a59:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     a5c:	30 29                	xor    %ch,(%ecx)
     a5e:	00 69 6e             	add    %ch,0x6e(%ecx)
     a61:	69 74 5f 6d 6f 75 73 	imul   $0x6573756f,0x6d(%edi,%ebx,2),%esi
     a68:	65 
     a69:	3a 46 28             	cmp    0x28(%esi),%al
     a6c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a6f:	38 29                	cmp    %ch,(%ecx)
     a71:	00 6d 6f             	add    %ch,0x6f(%ebp)
     a74:	75 73                	jne    ae9 <bootmain-0x27f517>
     a76:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     a7a:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     a7d:	29 00                	sub    %eax,(%eax)
     a7f:	62 67 3a             	bound  %esp,0x3a(%edi)
     a82:	70 28                	jo     aac <bootmain-0x27f554>
     a84:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     a87:	29 00                	sub    %eax,(%eax)
     a89:	63 75 72             	arpl   %si,0x72(%ebp)
     a8c:	73 6f                	jae    afd <bootmain-0x27f503>
     a8e:	72 3a                	jb     aca <bootmain-0x27f536>
     a90:	56                   	push   %esi
     a91:	28 30                	sub    %dh,(%eax)
     a93:	2c 32                	sub    $0x32,%al
     a95:	31 29                	xor    %ebp,(%ecx)
     a97:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     a9c:	2c 35                	sub    $0x35,%al
     a9e:	29 3b                	sub    %edi,(%ebx)
     aa0:	30 3b                	xor    %bh,(%ebx)
     aa2:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     aa8:	32 32                	xor    (%edx),%dh
     aaa:	29 3d 61 72 28 34    	sub    %edi,0x34287261
     ab0:	2c 35                	sub    $0x35,%al
     ab2:	29 3b                	sub    %edi,(%ebx)
     ab4:	30 3b                	xor    %bh,(%ebx)
     ab6:	31 35 3b 28 30 2c    	xor    %esi,0x2c30283b
     abc:	32 29                	xor    (%ecx),%ch
     abe:	00 78 3a             	add    %bh,0x3a(%eax)
     ac1:	72 28                	jb     aeb <bootmain-0x27f515>
     ac3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ac6:	29 00                	sub    %eax,(%eax)
     ac8:	62 67 3a             	bound  %esp,0x3a(%edi)
     acb:	72 28                	jb     af5 <bootmain-0x27f50b>
     acd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     ad0:	29 00                	sub    %eax,(%eax)
     ad2:	64 69 73 70 6c 61 79 	imul   $0x5f79616c,%fs:0x70(%ebx),%esi
     ad9:	5f 
     ada:	6d                   	insl   (%dx),%es:(%edi)
     adb:	6f                   	outsl  %ds:(%esi),(%dx)
     adc:	75 73                	jne    b51 <bootmain-0x27f4af>
     ade:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     ae2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ae5:	38 29                	cmp    %ch,(%ecx)
     ae7:	00 76 72             	add    %dh,0x72(%esi)
     aea:	61                   	popa   
     aeb:	6d                   	insl   (%dx),%es:(%edi)
     aec:	3a 70 28             	cmp    0x28(%eax),%dh
     aef:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     af2:	29 00                	sub    %eax,(%eax)
     af4:	70 78                	jo     b6e <bootmain-0x27f492>
     af6:	73 69                	jae    b61 <bootmain-0x27f49f>
     af8:	7a 65                	jp     b5f <bootmain-0x27f4a1>
     afa:	3a 70 28             	cmp    0x28(%eax),%dh
     afd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b00:	29 00                	sub    %eax,(%eax)
     b02:	70 79                	jo     b7d <bootmain-0x27f483>
     b04:	73 69                	jae    b6f <bootmain-0x27f491>
     b06:	7a 65                	jp     b6d <bootmain-0x27f493>
     b08:	3a 70 28             	cmp    0x28(%eax),%dh
     b0b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b0e:	29 00                	sub    %eax,(%eax)
     b10:	70 78                	jo     b8a <bootmain-0x27f476>
     b12:	30 3a                	xor    %bh,(%edx)
     b14:	70 28                	jo     b3e <bootmain-0x27f4c2>
     b16:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b19:	29 00                	sub    %eax,(%eax)
     b1b:	70 79                	jo     b96 <bootmain-0x27f46a>
     b1d:	30 3a                	xor    %bh,(%edx)
     b1f:	70 28                	jo     b49 <bootmain-0x27f4b7>
     b21:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b24:	29 00                	sub    %eax,(%eax)
     b26:	62 75 66             	bound  %esi,0x66(%ebp)
     b29:	3a 70 28             	cmp    0x28(%eax),%dh
     b2c:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     b2f:	29 00                	sub    %eax,(%eax)
     b31:	62 78 73             	bound  %edi,0x73(%eax)
     b34:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
     b3b:	2c 31                	sub    $0x31,%al
     b3d:	29 00                	sub    %eax,(%eax)
     b3f:	79 3a                	jns    b7b <bootmain-0x27f485>
     b41:	72 28                	jb     b6b <bootmain-0x27f495>
     b43:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b46:	29 00                	sub    %eax,(%eax)
     b48:	66 6f                	outsw  %ds:(%esi),(%dx)
     b4a:	6e                   	outsb  %ds:(%esi),(%dx)
     b4b:	74 2e                	je     b7b <bootmain-0x27f485>
     b4d:	63 00                	arpl   %ax,(%eax)
     b4f:	70 72                	jo     bc3 <bootmain-0x27f43d>
     b51:	69 6e 74 2e 63 00 69 	imul   $0x6900632e,0x74(%esi),%ebp
     b58:	74 6f                	je     bc9 <bootmain-0x27f437>
     b5a:	61                   	popa   
     b5b:	3a 46 28             	cmp    0x28(%esi),%al
     b5e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b61:	38 29                	cmp    %ch,(%ecx)
     b63:	00 76 61             	add    %dh,0x61(%esi)
     b66:	6c                   	insb   (%dx),%es:(%edi)
     b67:	75 65                	jne    bce <bootmain-0x27f432>
     b69:	3a 70 28             	cmp    0x28(%eax),%dh
     b6c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b6f:	29 00                	sub    %eax,(%eax)
     b71:	74 6d                	je     be0 <bootmain-0x27f420>
     b73:	70 5f                	jo     bd4 <bootmain-0x27f42c>
     b75:	62 75 66             	bound  %esi,0x66(%ebp)
     b78:	3a 28                	cmp    (%eax),%ch
     b7a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b7d:	39 29                	cmp    %ebp,(%ecx)
     b7f:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     b84:	2c 35                	sub    $0x35,%al
     b86:	29 3b                	sub    %edi,(%ebx)
     b88:	30 3b                	xor    %bh,(%ebx)
     b8a:	39 3b                	cmp    %edi,(%ebx)
     b8c:	28 30                	sub    %dh,(%eax)
     b8e:	2c 32                	sub    $0x32,%al
     b90:	29 00                	sub    %eax,(%eax)
     b92:	76 61                	jbe    bf5 <bootmain-0x27f40b>
     b94:	6c                   	insb   (%dx),%es:(%edi)
     b95:	75 65                	jne    bfc <bootmain-0x27f404>
     b97:	3a 72 28             	cmp    0x28(%edx),%dh
     b9a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     b9d:	29 00                	sub    %eax,(%eax)
     b9f:	62 75 66             	bound  %esi,0x66(%ebp)
     ba2:	3a 72 28             	cmp    0x28(%edx),%dh
     ba5:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     ba8:	29 00                	sub    %eax,(%eax)
     baa:	78 74                	js     c20 <bootmain-0x27f3e0>
     bac:	6f                   	outsl  %ds:(%esi),(%dx)
     bad:	61                   	popa   
     bae:	3a 46 28             	cmp    0x28(%esi),%al
     bb1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bb4:	38 29                	cmp    %ch,(%ecx)
     bb6:	00 76 61             	add    %dh,0x61(%esi)
     bb9:	6c                   	insb   (%dx),%es:(%edi)
     bba:	75 65                	jne    c21 <bootmain-0x27f3df>
     bbc:	3a 70 28             	cmp    0x28(%eax),%dh
     bbf:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     bc2:	29 00                	sub    %eax,(%eax)
     bc4:	74 6d                	je     c33 <bootmain-0x27f3cd>
     bc6:	70 5f                	jo     c27 <bootmain-0x27f3d9>
     bc8:	62 75 66             	bound  %esi,0x66(%ebp)
     bcb:	3a 28                	cmp    (%eax),%ch
     bcd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     bd0:	30 29                	xor    %ch,(%ecx)
     bd2:	3d 61 72 28 34       	cmp    $0x34287261,%eax
     bd7:	2c 35                	sub    $0x35,%al
     bd9:	29 3b                	sub    %edi,(%ebx)
     bdb:	30 3b                	xor    %bh,(%ebx)
     bdd:	32 39                	xor    (%ecx),%bh
     bdf:	3b 28                	cmp    (%eax),%ebp
     be1:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     be4:	29 00                	sub    %eax,(%eax)
     be6:	73 70                	jae    c58 <bootmain-0x27f3a8>
     be8:	72 69                	jb     c53 <bootmain-0x27f3ad>
     bea:	6e                   	outsb  %ds:(%esi),(%dx)
     beb:	74 66                	je     c53 <bootmain-0x27f3ad>
     bed:	3a 46 28             	cmp    0x28(%esi),%al
     bf0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     bf3:	38 29                	cmp    %ch,(%ecx)
     bf5:	00 73 74             	add    %dh,0x74(%ebx)
     bf8:	72 3a                	jb     c34 <bootmain-0x27f3cc>
     bfa:	70 28                	jo     c24 <bootmain-0x27f3dc>
     bfc:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     bff:	29 00                	sub    %eax,(%eax)
     c01:	66 6f                	outsw  %ds:(%esi),(%dx)
     c03:	72 6d                	jb     c72 <bootmain-0x27f38e>
     c05:	61                   	popa   
     c06:	74 3a                	je     c42 <bootmain-0x27f3be>
     c08:	70 28                	jo     c32 <bootmain-0x27f3ce>
     c0a:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     c0d:	29 00                	sub    %eax,(%eax)
     c0f:	76 61                	jbe    c72 <bootmain-0x27f38e>
     c11:	72 3a                	jb     c4d <bootmain-0x27f3b3>
     c13:	72 28                	jb     c3d <bootmain-0x27f3c3>
     c15:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     c18:	31 29                	xor    %ebp,(%ecx)
     c1a:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     c1f:	31 29                	xor    %ebp,(%ecx)
     c21:	00 62 75             	add    %ah,0x75(%edx)
     c24:	66                   	data16
     c25:	66                   	data16
     c26:	65                   	gs
     c27:	72 3a                	jb     c63 <bootmain-0x27f39d>
     c29:	28 30                	sub    %dh,(%eax)
     c2b:	2c 31                	sub    $0x31,%al
     c2d:	39 29                	cmp    %ebp,(%ecx)
     c2f:	00 73 74             	add    %dh,0x74(%ebx)
     c32:	72 3a                	jb     c6e <bootmain-0x27f392>
     c34:	72 28                	jb     c5e <bootmain-0x27f3a2>
     c36:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     c39:	29 00                	sub    %eax,(%eax)
     c3b:	70 75                	jo     cb2 <bootmain-0x27f34e>
     c3d:	74 66                	je     ca5 <bootmain-0x27f35b>
     c3f:	6f                   	outsl  %ds:(%esi),(%dx)
     c40:	6e                   	outsb  %ds:(%esi),(%dx)
     c41:	74 38                	je     c7b <bootmain-0x27f385>
     c43:	3a 46 28             	cmp    0x28(%esi),%al
     c46:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c49:	38 29                	cmp    %ch,(%ecx)
     c4b:	00 78 3a             	add    %bh,0x3a(%eax)
     c4e:	70 28                	jo     c78 <bootmain-0x27f388>
     c50:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c53:	29 00                	sub    %eax,(%eax)
     c55:	79 3a                	jns    c91 <bootmain-0x27f36f>
     c57:	70 28                	jo     c81 <bootmain-0x27f37f>
     c59:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c5c:	29 00                	sub    %eax,(%eax)
     c5e:	66 6f                	outsw  %ds:(%esi),(%dx)
     c60:	6e                   	outsb  %ds:(%esi),(%dx)
     c61:	74 3a                	je     c9d <bootmain-0x27f363>
     c63:	70 28                	jo     c8d <bootmain-0x27f373>
     c65:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
     c68:	29 00                	sub    %eax,(%eax)
     c6a:	72 6f                	jb     cdb <bootmain-0x27f325>
     c6c:	77 3a                	ja     ca8 <bootmain-0x27f358>
     c6e:	72 28                	jb     c98 <bootmain-0x27f368>
     c70:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c73:	29 00                	sub    %eax,(%eax)
     c75:	63 6f 6c             	arpl   %bp,0x6c(%edi)
     c78:	3a 72 28             	cmp    0x28(%edx),%dh
     c7b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c7e:	29 00                	sub    %eax,(%eax)
     c80:	70 75                	jo     cf7 <bootmain-0x27f309>
     c82:	74 73                	je     cf7 <bootmain-0x27f309>
     c84:	38 3a                	cmp    %bh,(%edx)
     c86:	46                   	inc    %esi
     c87:	28 30                	sub    %dh,(%eax)
     c89:	2c 31                	sub    $0x31,%al
     c8b:	38 29                	cmp    %ch,(%ecx)
     c8d:	00 70 72             	add    %dh,0x72(%eax)
     c90:	69 6e 74 64 65 62 75 	imul   $0x75626564,0x74(%esi),%ebp
     c97:	67 3a 46 28          	cmp    0x28(%bp),%al
     c9b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     c9e:	38 29                	cmp    %ch,(%ecx)
     ca0:	00 69 3a             	add    %ch,0x3a(%ecx)
     ca3:	70 28                	jo     ccd <bootmain-0x27f333>
     ca5:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     ca8:	29 00                	sub    %eax,(%eax)
     caa:	78 3a                	js     ce6 <bootmain-0x27f31a>
     cac:	70 28                	jo     cd6 <bootmain-0x27f32a>
     cae:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     cb1:	29 00                	sub    %eax,(%eax)
     cb3:	66 6f                	outsw  %ds:(%esi),(%dx)
     cb5:	6e                   	outsb  %ds:(%esi),(%dx)
     cb6:	74 3a                	je     cf2 <bootmain-0x27f30e>
     cb8:	28 30                	sub    %dh,(%eax)
     cba:	2c 32                	sub    $0x32,%al
     cbc:	30 29                	xor    %ch,(%ecx)
     cbe:	00 70 75             	add    %dh,0x75(%eax)
     cc1:	74 66                	je     d29 <bootmain-0x27f2d7>
     cc3:	6f                   	outsl  %ds:(%esi),(%dx)
     cc4:	6e                   	outsb  %ds:(%esi),(%dx)
     cc5:	74 31                	je     cf8 <bootmain-0x27f308>
     cc7:	36 3a 46 28          	cmp    %ss:0x28(%esi),%al
     ccb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cce:	38 29                	cmp    %ch,(%ecx)
     cd0:	00 66 6f             	add    %ah,0x6f(%esi)
     cd3:	6e                   	outsb  %ds:(%esi),(%dx)
     cd4:	74 3a                	je     d10 <bootmain-0x27f2f0>
     cd6:	70 28                	jo     d00 <bootmain-0x27f300>
     cd8:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     cdb:	32 29                	xor    (%ecx),%ch
     cdd:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     ce2:	39 29                	cmp    %ebp,(%ecx)
     ce4:	00 70 75             	add    %dh,0x75(%eax)
     ce7:	74 73                	je     d5c <bootmain-0x27f2a4>
     ce9:	31 36                	xor    %esi,(%esi)
     ceb:	3a 46 28             	cmp    0x28(%esi),%al
     cee:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     cf1:	38 29                	cmp    %ch,(%ecx)
     cf3:	00 69 64             	add    %ch,0x64(%ecx)
     cf6:	74 67                	je     d5f <bootmain-0x27f2a1>
     cf8:	64                   	fs
     cf9:	74 2e                	je     d29 <bootmain-0x27f2d7>
     cfb:	63 00                	arpl   %ax,(%eax)
     cfd:	73 65                	jae    d64 <bootmain-0x27f29c>
     cff:	74 67                	je     d68 <bootmain-0x27f298>
     d01:	64                   	fs
     d02:	74 3a                	je     d3e <bootmain-0x27f2c2>
     d04:	46                   	inc    %esi
     d05:	28 30                	sub    %dh,(%eax)
     d07:	2c 31                	sub    $0x31,%al
     d09:	38 29                	cmp    %ch,(%ecx)
     d0b:	00 73 64             	add    %dh,0x64(%ebx)
     d0e:	3a 70 28             	cmp    0x28(%eax),%dh
     d11:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d14:	39 29                	cmp    %ebp,(%ecx)
     d16:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     d1b:	33 29                	xor    (%ecx),%ebp
     d1d:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
     d21:	69 74 3a 70 28 30 2c 	imul   $0x342c3028,0x70(%edx,%edi,1),%esi
     d28:	34 
     d29:	29 00                	sub    %eax,(%eax)
     d2b:	62 61 73             	bound  %esp,0x73(%ecx)
     d2e:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
     d32:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d35:	29 00                	sub    %eax,(%eax)
     d37:	61                   	popa   
     d38:	63 63 65             	arpl   %sp,0x65(%ebx)
     d3b:	73 73                	jae    db0 <bootmain-0x27f250>
     d3d:	3a 70 28             	cmp    0x28(%eax),%dh
     d40:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d43:	29 00                	sub    %eax,(%eax)
     d45:	73 64                	jae    dab <bootmain-0x27f255>
     d47:	3a 72 28             	cmp    0x28(%edx),%dh
     d4a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d4d:	39 29                	cmp    %ebp,(%ecx)
     d4f:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
     d53:	69 74 3a 72 28 30 2c 	imul   $0x342c3028,0x72(%edx,%edi,1),%esi
     d5a:	34 
     d5b:	29 00                	sub    %eax,(%eax)
     d5d:	62 61 73             	bound  %esp,0x73(%ecx)
     d60:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
     d64:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d67:	29 00                	sub    %eax,(%eax)
     d69:	61                   	popa   
     d6a:	63 63 65             	arpl   %sp,0x65(%ebx)
     d6d:	73 73                	jae    de2 <bootmain-0x27f21e>
     d6f:	3a 72 28             	cmp    0x28(%edx),%dh
     d72:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     d75:	29 00                	sub    %eax,(%eax)
     d77:	73 65                	jae    dde <bootmain-0x27f222>
     d79:	74 69                	je     de4 <bootmain-0x27f21c>
     d7b:	64                   	fs
     d7c:	74 3a                	je     db8 <bootmain-0x27f248>
     d7e:	46                   	inc    %esi
     d7f:	28 30                	sub    %dh,(%eax)
     d81:	2c 31                	sub    $0x31,%al
     d83:	38 29                	cmp    %ch,(%ecx)
     d85:	00 67 64             	add    %ah,0x64(%edi)
     d88:	3a 70 28             	cmp    0x28(%eax),%dh
     d8b:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     d8e:	30 29                	xor    %ch,(%ecx)
     d90:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     d95:	34 29                	xor    $0x29,%al
     d97:	00 6f 66             	add    %ch,0x66(%edi)
     d9a:	66                   	data16
     d9b:	73 65                	jae    e02 <bootmain-0x27f1fe>
     d9d:	74 3a                	je     dd9 <bootmain-0x27f227>
     d9f:	70 28                	jo     dc9 <bootmain-0x27f237>
     da1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     da4:	29 00                	sub    %eax,(%eax)
     da6:	73 65                	jae    e0d <bootmain-0x27f1f3>
     da8:	6c                   	insb   (%dx),%es:(%edi)
     da9:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     dae:	3a 70 28             	cmp    0x28(%eax),%dh
     db1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     db4:	29 00                	sub    %eax,(%eax)
     db6:	67 64 3a 72 28       	cmp    %fs:0x28(%bp,%si),%dh
     dbb:	30 2c 32             	xor    %ch,(%edx,%esi,1)
     dbe:	30 29                	xor    %ch,(%ecx)
     dc0:	00 6f 66             	add    %ch,0x66(%edi)
     dc3:	66                   	data16
     dc4:	73 65                	jae    e2b <bootmain-0x27f1d5>
     dc6:	74 3a                	je     e02 <bootmain-0x27f1fe>
     dc8:	72 28                	jb     df2 <bootmain-0x27f20e>
     dca:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     dcd:	29 00                	sub    %eax,(%eax)
     dcf:	73 65                	jae    e36 <bootmain-0x27f1ca>
     dd1:	6c                   	insb   (%dx),%es:(%edi)
     dd2:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
     dd7:	3a 72 28             	cmp    0x28(%edx),%dh
     dda:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ddd:	29 00                	sub    %eax,(%eax)
     ddf:	69 6e 69 74 5f 67 64 	imul   $0x64675f74,0x69(%esi),%ebp
     de6:	74 69                	je     e51 <bootmain-0x27f1af>
     de8:	64                   	fs
     de9:	74 3a                	je     e25 <bootmain-0x27f1db>
     deb:	46                   	inc    %esi
     dec:	28 30                	sub    %dh,(%eax)
     dee:	2c 31                	sub    $0x31,%al
     df0:	38 29                	cmp    %ch,(%ecx)
     df2:	00 69 6e             	add    %ch,0x6e(%ecx)
     df5:	74 2e                	je     e25 <bootmain-0x27f1db>
     df7:	63 00                	arpl   %ax,(%eax)
     df9:	69 6e 69 74 5f 70 69 	imul   $0x69705f74,0x69(%esi),%ebp
     e00:	63 3a                	arpl   %di,(%edx)
     e02:	46                   	inc    %esi
     e03:	28 30                	sub    %dh,(%eax)
     e05:	2c 31                	sub    $0x31,%al
     e07:	38 29                	cmp    %ch,(%ecx)
     e09:	00 69 6e             	add    %ch,0x6e(%ecx)
     e0c:	74 68                	je     e76 <bootmain-0x27f18a>
     e0e:	61                   	popa   
     e0f:	6e                   	outsb  %ds:(%esi),(%dx)
     e10:	64                   	fs
     e11:	6c                   	insb   (%dx),%es:(%edi)
     e12:	65                   	gs
     e13:	72 32                	jb     e47 <bootmain-0x27f1b9>
     e15:	31 3a                	xor    %edi,(%edx)
     e17:	46                   	inc    %esi
     e18:	28 30                	sub    %dh,(%eax)
     e1a:	2c 31                	sub    $0x31,%al
     e1c:	38 29                	cmp    %ch,(%ecx)
     e1e:	00 65 73             	add    %ah,0x73(%ebp)
     e21:	70 3a                	jo     e5d <bootmain-0x27f1a3>
     e23:	70 28                	jo     e4d <bootmain-0x27f1b3>
     e25:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e28:	39 29                	cmp    %ebp,(%ecx)
     e2a:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
     e2f:	31 29                	xor    %ebp,(%ecx)
     e31:	00 69 6e             	add    %ch,0x6e(%ecx)
     e34:	74 68                	je     e9e <bootmain-0x27f162>
     e36:	61                   	popa   
     e37:	6e                   	outsb  %ds:(%esi),(%dx)
     e38:	64                   	fs
     e39:	6c                   	insb   (%dx),%es:(%edi)
     e3a:	65                   	gs
     e3b:	72 32                	jb     e6f <bootmain-0x27f191>
     e3d:	63 3a                	arpl   %di,(%edx)
     e3f:	46                   	inc    %esi
     e40:	28 30                	sub    %dh,(%eax)
     e42:	2c 31                	sub    $0x31,%al
     e44:	38 29                	cmp    %ch,(%ecx)
     e46:	00 65 73             	add    %ah,0x73(%ebp)
     e49:	70 3a                	jo     e85 <bootmain-0x27f17b>
     e4b:	70 28                	jo     e75 <bootmain-0x27f18b>
     e4d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e50:	39 29                	cmp    %ebp,(%ecx)
     e52:	00 77 61             	add    %dh,0x61(%edi)
     e55:	69 74 5f 4b 42 43 5f 	imul   $0x735f4342,0x4b(%edi,%ebx,2),%esi
     e5c:	73 
     e5d:	65 6e                	outsb  %gs:(%esi),(%dx)
     e5f:	64                   	fs
     e60:	72 65                	jb     ec7 <bootmain-0x27f139>
     e62:	61                   	popa   
     e63:	64                   	fs
     e64:	79 3a                	jns    ea0 <bootmain-0x27f160>
     e66:	46                   	inc    %esi
     e67:	28 30                	sub    %dh,(%eax)
     e69:	2c 31                	sub    $0x31,%al
     e6b:	38 29                	cmp    %ch,(%ecx)
     e6d:	00 69 6e             	add    %ch,0x6e(%ecx)
     e70:	69 74 5f 6b 65 79 62 	imul   $0x6f627965,0x6b(%edi,%ebx,2),%esi
     e77:	6f 
     e78:	61                   	popa   
     e79:	72 64                	jb     edf <bootmain-0x27f121>
     e7b:	3a 46 28             	cmp    0x28(%esi),%al
     e7e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     e81:	38 29                	cmp    %ch,(%ecx)
     e83:	00 6b 65             	add    %ch,0x65(%ebx)
     e86:	79 66                	jns    eee <bootmain-0x27f112>
     e88:	69 66 6f 3a 47 28 31 	imul   $0x3128473a,0x6f(%esi),%esp
     e8f:	2c 35                	sub    $0x35,%al
     e91:	29 00                	sub    %eax,(%eax)
     e93:	6d                   	insl   (%dx),%es:(%edi)
     e94:	6f                   	outsl  %ds:(%esi),(%dx)
     e95:	75 73                	jne    f0a <bootmain-0x27f0f6>
     e97:	65 66 69 66 6f 3a 47 	imul   $0x473a,%gs:0x6f(%esi),%sp
     e9e:	28 31                	sub    %dh,(%ecx)
     ea0:	2c 35                	sub    $0x35,%al
     ea2:	29 00                	sub    %eax,(%eax)
     ea4:	2f                   	das    
     ea5:	74 6d                	je     f14 <bootmain-0x27f0ec>
     ea7:	70 2f                	jo     ed8 <bootmain-0x27f128>
     ea9:	63 63 6e             	arpl   %sp,0x6e(%ebx)
     eac:	64                   	fs
     ead:	4d                   	dec    %ebp
     eae:	78 72                	js     f22 <bootmain-0x27f0de>
     eb0:	67 2e 73 00          	addr16 jae,pn eb4 <bootmain-0x27f14c>
     eb4:	61                   	popa   
     eb5:	73 6d                	jae    f24 <bootmain-0x27f0dc>
     eb7:	69 6e 74 33 32 2e 53 	imul   $0x532e3233,0x74(%esi),%ebp
     ebe:	00 66 69             	add    %ah,0x69(%esi)
     ec1:	66 6f                	outsw  %ds:(%esi),(%dx)
     ec3:	2e 63 00             	arpl   %ax,%cs:(%eax)
     ec6:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
     ecc:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
     ed3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ed6:	38 29                	cmp    %ch,(%ecx)
     ed8:	00 66 69             	add    %ah,0x69(%esi)
     edb:	66 6f                	outsw  %ds:(%esi),(%dx)
     edd:	3a 70 28             	cmp    0x28(%eax),%dh
     ee0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ee3:	39 29                	cmp    %ebp,(%ecx)
     ee5:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     eea:	35 29 00 73 69       	xor    $0x69730029,%eax
     eef:	7a 65                	jp     f56 <bootmain-0x27f0aa>
     ef1:	3a 70 28             	cmp    0x28(%eax),%dh
     ef4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     ef7:	29 00                	sub    %eax,(%eax)
     ef9:	62 75 66             	bound  %esi,0x66(%ebp)
     efc:	3a 70 28             	cmp    0x28(%eax),%dh
     eff:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     f02:	29 00                	sub    %eax,(%eax)
     f04:	66 69 66 6f 3a 72    	imul   $0x723a,0x6f(%esi),%sp
     f0a:	28 30                	sub    %dh,(%eax)
     f0c:	2c 31                	sub    $0x31,%al
     f0e:	39 29                	cmp    %ebp,(%ecx)
     f10:	00 73 69             	add    %dh,0x69(%ebx)
     f13:	7a 65                	jp     f7a <bootmain-0x27f086>
     f15:	3a 72 28             	cmp    0x28(%edx),%dh
     f18:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f1b:	29 00                	sub    %eax,(%eax)
     f1d:	62 75 66             	bound  %esi,0x66(%ebp)
     f20:	3a 72 28             	cmp    0x28(%edx),%dh
     f23:	31 2c 36             	xor    %ebp,(%esi,%esi,1)
     f26:	29 00                	sub    %eax,(%eax)
     f28:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
     f2e:	77 72                	ja     fa2 <bootmain-0x27f05e>
     f30:	69 74 65 3a 46 28 30 	imul   $0x2c302846,0x3a(%ebp,%eiz,2),%esi
     f37:	2c 
     f38:	31 29                	xor    %ebp,(%ecx)
     f3a:	00 66 69             	add    %ah,0x69(%esi)
     f3d:	66 6f                	outsw  %ds:(%esi),(%dx)
     f3f:	3a 70 28             	cmp    0x28(%eax),%dh
     f42:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f45:	39 29                	cmp    %ebp,(%ecx)
     f47:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
     f4b:	61                   	popa   
     f4c:	3a 70 28             	cmp    0x28(%eax),%dh
     f4f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f52:	29 00                	sub    %eax,(%eax)
     f54:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
     f5a:	72 65                	jb     fc1 <bootmain-0x27f03f>
     f5c:	61                   	popa   
     f5d:	64 3a 46 28          	cmp    %fs:0x28(%esi),%al
     f61:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f64:	29 00                	sub    %eax,(%eax)
     f66:	64                   	fs
     f67:	61                   	popa   
     f68:	74 61                	je     fcb <bootmain-0x27f035>
     f6a:	3a 72 28             	cmp    0x28(%edx),%dh
     f6d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     f70:	29 00                	sub    %eax,(%eax)
     f72:	66 69 66 6f 38 5f    	imul   $0x5f38,0x6f(%esi),%sp
     f78:	73 74                	jae    fee <bootmain-0x27f012>
     f7a:	61                   	popa   
     f7b:	74 75                	je     ff2 <bootmain-0x27f00e>
     f7d:	73 3a                	jae    fb9 <bootmain-0x27f047>
     f7f:	46                   	inc    %esi
     f80:	28 30                	sub    %dh,(%eax)
     f82:	2c 31                	sub    $0x31,%al
     f84:	29 00                	sub    %eax,(%eax)
     f86:	6d                   	insl   (%dx),%es:(%edi)
     f87:	6f                   	outsl  %ds:(%esi),(%dx)
     f88:	75 73                	jne    ffd <bootmain-0x27f003>
     f8a:	65 2e 63 00          	gs arpl %ax,%cs:%gs:(%eax)
     f8e:	65 6e                	outsb  %gs:(%esi),(%dx)
     f90:	61                   	popa   
     f91:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
     f95:	6d                   	insl   (%dx),%es:(%edi)
     f96:	6f                   	outsl  %ds:(%esi),(%dx)
     f97:	75 73                	jne    100c <bootmain-0x27eff4>
     f99:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     f9d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fa0:	38 29                	cmp    %ch,(%ecx)
     fa2:	00 6d 64             	add    %ch,0x64(%ebp)
     fa5:	65 63 3a             	arpl   %di,%gs:(%edx)
     fa8:	70 28                	jo     fd2 <bootmain-0x27f02e>
     faa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fad:	39 29                	cmp    %ebp,(%ecx)
     faf:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
     fb4:	37                   	aaa    
     fb5:	29 00                	sub    %eax,(%eax)
     fb7:	6d                   	insl   (%dx),%es:(%edi)
     fb8:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
     fbc:	72 28                	jb     fe6 <bootmain-0x27f01a>
     fbe:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fc1:	39 29                	cmp    %ebp,(%ecx)
     fc3:	00 6d 6f             	add    %ch,0x6f(%ebp)
     fc6:	75 73                	jne    103b <bootmain-0x27efc5>
     fc8:	65                   	gs
     fc9:	5f                   	pop    %edi
     fca:	64 65 63 6f 64       	fs arpl %bp,%fs:%gs:0x64(%edi)
     fcf:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
     fd3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fd6:	29 00                	sub    %eax,(%eax)
     fd8:	6d                   	insl   (%dx),%es:(%edi)
     fd9:	64 65 63 3a          	fs arpl %di,%fs:%gs:(%edx)
     fdd:	70 28                	jo     1007 <bootmain-0x27eff9>
     fdf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
     fe2:	39 29                	cmp    %ebp,(%ecx)
     fe4:	00 6d 6d             	add    %ch,0x6d(%ebp)
     fe7:	2e 63 00             	arpl   %ax,%cs:(%eax)
     fea:	67                   	addr16
     feb:	65                   	gs
     fec:	74 6d                	je     105b <bootmain-0x27efa5>
     fee:	65                   	gs
     fef:	6d                   	insl   (%dx),%es:(%edi)
     ff0:	6f                   	outsl  %ds:(%esi),(%dx)
     ff1:	72 79                	jb     106c <bootmain-0x27ef94>
     ff3:	73 69                	jae    105e <bootmain-0x27efa2>
     ff5:	7a 65                	jp     105c <bootmain-0x27efa4>
     ff7:	3a 46 28             	cmp    0x28(%esi),%al
     ffa:	30 2c 34             	xor    %ch,(%esp,%esi,1)
     ffd:	29 00                	sub    %eax,(%eax)
     fff:	73 74                	jae    1075 <bootmain-0x27ef8b>
    1001:	61                   	popa   
    1002:	72 74                	jb     1078 <bootmain-0x27ef88>
    1004:	3a 70 28             	cmp    0x28(%eax),%dh
    1007:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    100a:	29 00                	sub    %eax,(%eax)
    100c:	65 6e                	outsb  %gs:(%esi),(%dx)
    100e:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
    1012:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1015:	29 00                	sub    %eax,(%eax)
    1017:	6f                   	outsl  %ds:(%esi),(%dx)
    1018:	6c                   	insb   (%dx),%es:(%edi)
    1019:	64 3a 72 28          	cmp    %fs:0x28(%edx),%dh
    101d:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    1020:	29 00                	sub    %eax,(%eax)
    1022:	70 3a                	jo     105e <bootmain-0x27efa2>
    1024:	72 28                	jb     104e <bootmain-0x27efb2>
    1026:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1029:	39 29                	cmp    %ebp,(%ecx)
    102b:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
    1030:	34 29                	xor    $0x29,%al
    1032:	00 73 74             	add    %dh,0x74(%ebx)
    1035:	61                   	popa   
    1036:	72 74                	jb     10ac <bootmain-0x27ef54>
    1038:	3a 72 28             	cmp    0x28(%edx),%dh
    103b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    103e:	29 00                	sub    %eax,(%eax)
    1040:	6d                   	insl   (%dx),%es:(%edi)
    1041:	65                   	gs
    1042:	6d                   	insl   (%dx),%es:(%edi)
    1043:	74 65                	je     10aa <bootmain-0x27ef56>
    1045:	73 74                	jae    10bb <bootmain-0x27ef45>
    1047:	3a 46 28             	cmp    0x28(%esi),%al
    104a:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    104d:	29 00                	sub    %eax,(%eax)
    104f:	66                   	data16
    1050:	6c                   	insb   (%dx),%es:(%edi)
    1051:	67 34 38             	addr16 xor $0x38,%al
    1054:	36 3a 72 28          	cmp    %ss:0x28(%edx),%dh
    1058:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    105b:	29 00                	sub    %eax,(%eax)
    105d:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
    1063:	34 29                	xor    $0x29,%al
    1065:	00 6d 65             	add    %ch,0x65(%ebp)
    1068:	6d                   	insl   (%dx),%es:(%edi)
    1069:	6d                   	insl   (%dx),%es:(%edi)
    106a:	61                   	popa   
    106b:	6e                   	outsb  %ds:(%esi),(%dx)
    106c:	5f                   	pop    %edi
    106d:	69 6e 69 74 3a 46 28 	imul   $0x28463a74,0x69(%esi),%ebp
    1074:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1077:	38 29                	cmp    %ch,(%ecx)
    1079:	00 6d 61             	add    %ch,0x61(%ebp)
    107c:	6e                   	outsb  %ds:(%esi),(%dx)
    107d:	3a 70 28             	cmp    0x28(%eax),%dh
    1080:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1083:	30 29                	xor    %ch,(%ecx)
    1085:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
    108a:	36 29 00             	sub    %eax,%ss:(%eax)
    108d:	6d                   	insl   (%dx),%es:(%edi)
    108e:	61                   	popa   
    108f:	6e                   	outsb  %ds:(%esi),(%dx)
    1090:	3a 72 28             	cmp    0x28(%edx),%dh
    1093:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    1096:	30 29                	xor    %ch,(%ecx)
    1098:	00 6d 65             	add    %ch,0x65(%ebp)
    109b:	6d                   	insl   (%dx),%es:(%edi)
    109c:	6d                   	insl   (%dx),%es:(%edi)
    109d:	61                   	popa   
    109e:	6e                   	outsb  %ds:(%esi),(%dx)
    109f:	5f                   	pop    %edi
    10a0:	61                   	popa   
    10a1:	76 61                	jbe    1104 <bootmain-0x27eefc>
    10a3:	69 6c 3a 46 28 30 2c 	imul   $0x342c3028,0x46(%edx,%edi,1),%ebp
    10aa:	34 
    10ab:	29 00                	sub    %eax,(%eax)
    10ad:	6d                   	insl   (%dx),%es:(%edi)
    10ae:	61                   	popa   
    10af:	6e                   	outsb  %ds:(%esi),(%dx)
    10b0:	3a 70 28             	cmp    0x28(%eax),%dh
    10b3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
    10b6:	30 29                	xor    %ch,(%ecx)
    10b8:	00 66 72             	add    %ah,0x72(%esi)
    10bb:	65                   	gs
    10bc:	65                   	gs
    10bd:	6d                   	insl   (%dx),%es:(%edi)
    10be:	65                   	gs
    10bf:	6d                   	insl   (%dx),%es:(%edi)
    10c0:	3a 72 28             	cmp    0x28(%edx),%dh
    10c3:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    10c6:	29 00                	sub    %eax,(%eax)
    10c8:	6d                   	insl   (%dx),%es:(%edi)
    10c9:	65                   	gs
    10ca:	6d                   	insl   (%dx),%es:(%edi)
    10cb:	6d                   	insl   (%dx),%es:(%edi)
    10cc:	61                   	popa   
    10cd:	6e                   	outsb  %ds:(%esi),(%dx)
    10ce:	5f                   	pop    %edi
    10cf:	61                   	popa   
    10d0:	6c                   	insb   (%dx),%es:(%edi)
    10d1:	6c                   	insb   (%dx),%es:(%edi)
    10d2:	6f                   	outsl  %ds:(%esi),(%dx)
    10d3:	63 3a                	arpl   %di,(%edx)
    10d5:	46                   	inc    %esi
    10d6:	28 30                	sub    %dh,(%eax)
    10d8:	2c 31                	sub    $0x31,%al
    10da:	29 00                	sub    %eax,(%eax)
    10dc:	73 69                	jae    1147 <bootmain-0x27eeb9>
    10de:	7a 65                	jp     1145 <bootmain-0x27eebb>
    10e0:	3a 70 28             	cmp    0x28(%eax),%dh
    10e3:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    10e6:	29 00                	sub    %eax,(%eax)
    10e8:	61                   	popa   
    10e9:	3a 72 28             	cmp    0x28(%edx),%dh
    10ec:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    10ef:	29 00                	sub    %eax,(%eax)
    10f1:	6d                   	insl   (%dx),%es:(%edi)
    10f2:	65                   	gs
    10f3:	6d                   	insl   (%dx),%es:(%edi)
    10f4:	6d                   	insl   (%dx),%es:(%edi)
    10f5:	61                   	popa   
    10f6:	6e                   	outsb  %ds:(%esi),(%dx)
    10f7:	5f                   	pop    %edi
    10f8:	66                   	data16
    10f9:	72 65                	jb     1160 <bootmain-0x27eea0>
    10fb:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
    10ff:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
    1102:	29 00                	sub    %eax,(%eax)
    1104:	61                   	popa   
    1105:	64                   	fs
    1106:	64                   	fs
    1107:	72 3a                	jb     1143 <bootmain-0x27eebd>
    1109:	70 28                	jo     1133 <bootmain-0x27eecd>
    110b:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    110e:	29 00                	sub    %eax,(%eax)
    1110:	73 69                	jae    117b <bootmain-0x27ee85>
    1112:	7a 65                	jp     1179 <bootmain-0x27ee87>
    1114:	3a 72 28             	cmp    0x28(%edx),%dh
    1117:	30 2c 34             	xor    %ch,(%esp,%esi,1)
    111a:	29 00                	sub    %eax,(%eax)
