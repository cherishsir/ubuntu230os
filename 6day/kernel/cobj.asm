
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
  280003:	53                   	push   %ebx
  280004:	81 ec 10 01 00 00    	sub    $0x110,%esp
static char font[40];	//sprintf buffer
int i=124567;		//sprintf variable i for test
char mousepic[256];     //mouse logo buffer
struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
  clear_screen(40);   	//read
  28000a:	6a 28                	push   $0x28
  28000c:	e8 85 00 00 00       	call   280096 <clear_screen>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280011:	fb                   	sti    
 	
  sti();		//enable cpu interrupt
  init_screen((struct boot_info * )bootp);
  280012:	c7 04 24 f0 0f 00 00 	movl   $0xff0,(%esp)




//display mouse logo
init_mouse(mousepic,7);//7　means background color:white
  280019:	8d 9d f8 fe ff ff    	lea    -0x108(%ebp),%ebx
char mousepic[256];     //mouse logo buffer
struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
  clear_screen(40);   	//read
 	
  sti();		//enable cpu interrupt
  init_screen((struct boot_info * )bootp);
  28001f:	e8 c4 02 00 00       	call   2802e8 <init_screen>
  init_palette();  //color table from 0 to 15
  280024:	e8 d6 00 00 00       	call   2800ff <init_palette>

  draw_window();  
  280029:	e8 59 01 00 00       	call   280187 <draw_window>




//display mouse logo
init_mouse(mousepic,7);//7　means background color:white
  28002e:	58                   	pop    %eax
  28002f:	5a                   	pop    %edx
  280030:	6a 07                	push   $0x7
  280032:	53                   	push   %ebx
  280033:	e8 cf 02 00 00       	call   280307 <init_mouse>
display_mouse(bootp->vram,bootp->xsize,16,16,60,60,mousepic,16);
  280038:	6a 10                	push   $0x10
  28003a:	53                   	push   %ebx
  28003b:	6a 3c                	push   $0x3c
  28003d:	6a 3c                	push   $0x3c
  28003f:	6a 10                	push   $0x10
  280041:	6a 10                	push   $0x10
  280043:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  28004a:	50                   	push   %eax
  28004b:	ff 35 f8 0f 00 00    	pushl  0xff8
  280051:	e8 01 03 00 00       	call   280357 <display_mouse>
init_gdtidt();
  280056:	83 c4 30             	add    $0x30,%esp
  280059:	e8 ac 06 00 00       	call   28070a <init_gdtidt>
init_pic();//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
  28005e:	e8 dc 07 00 00       	call   28083f <init_pic>
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280063:	ba 21 00 00 00       	mov    $0x21,%edx
  280068:	b0 f9                	mov    $0xf9,%al
  28006a:	ee                   	out    %al,(%dx)
  28006b:	b0 ef                	mov    $0xef,%al
  28006d:	b2 a1                	mov    $0xa1,%dl
  28006f:	ee                   	out    %al,(%dx)
//int addr=inthandler21;
//printdebug(addr,0);

//打印出int0x21处的idt值，主要看offset是否与　asm_inthandler21一样（看反汇编，可以看到地址）
int * addr=(int *)(0x0026f800+8*0x21);
printdebug(*(addr),0);
  280070:	51                   	push   %ecx
  280071:	51                   	push   %ecx
  280072:	6a 00                	push   $0x0
  280074:	ff 35 08 f9 26 00    	pushl  0x26f908
  28007a:	e8 34 05 00 00       	call   2805b3 <printdebug>
printdebug(*(addr+1),160);
  28007f:	5b                   	pop    %ebx
  280080:	58                   	pop    %eax
  280081:	68 a0 00 00 00       	push   $0xa0
  280086:	ff 35 0c f9 26 00    	pushl  0x26f90c
  28008c:	e8 22 05 00 00       	call   2805b3 <printdebug>
  280091:	83 c4 10             	add    $0x10,%esp
  280094:	eb fe                	jmp    280094 <bootmain+0x94>

00280096 <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
  280096:	55                   	push   %ebp
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  280097:	b8 00 00 0a 00       	mov    $0xa0000,%eax
#include<header.h>

void clear_screen(char color) //15:pure white
{
  28009c:	89 e5                	mov    %esp,%ebp
  28009e:	8a 55 08             	mov    0x8(%ebp),%dl
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  2800a1:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  2800a3:	40                   	inc    %eax
  2800a4:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  2800a9:	75 f6                	jne    2800a1 <clear_screen+0xb>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  2800ab:	5d                   	pop    %ebp
  2800ac:	c3                   	ret    

002800ad <color_screen>:

void color_screen(char color) //15:pure white
{
  2800ad:	55                   	push   %ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  2800ae:	b8 00 00 0a 00       	mov    $0xa0000,%eax

  }
}

void color_screen(char color) //15:pure white
{
  2800b3:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  2800b5:	88 00                	mov    %al,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  2800b7:	40                   	inc    %eax
  2800b8:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  2800bd:	75 f6                	jne    2800b5 <color_screen+0x8>
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  2800bf:	5d                   	pop    %ebp
  2800c0:	c3                   	ret    

002800c1 <set_palette>:
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  2800c1:	55                   	push   %ebp
  2800c2:	89 e5                	mov    %esp,%ebp
  2800c4:	56                   	push   %esi
  2800c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  2800c8:	53                   	push   %ebx
  2800c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  2800cc:	9c                   	pushf  
  2800cd:	5e                   	pop    %esi
  int i,eflag;
  eflag=read_eflags();   //记录从前的cpsr值
 
  io_cli(); // disable interrupt
  2800ce:	fa                   	cli    
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  2800cf:	ba c8 03 00 00       	mov    $0x3c8,%edx
  //为什么写port 0x03c8
  
  //rgb=rgb+;
  outb(0x03c8,start);
  2800d4:	0f b6 c3             	movzbl %bl,%eax
  2800d7:	ee                   	out    %al,(%dx)
  2800d8:	b2 c9                	mov    $0xc9,%dl
  for(i=start;i<=end;i++)
  2800da:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  2800dd:	7f 1a                	jg     2800f9 <set_palette+0x38>
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
  2800df:	8a 01                	mov    (%ecx),%al
  2800e1:	c0 e8 02             	shr    $0x2,%al
  2800e4:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+1)/4);   
  2800e5:	8a 41 01             	mov    0x1(%ecx),%al
  2800e8:	c0 e8 02             	shr    $0x2,%al
  2800eb:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+2)/4);   
  2800ec:	8a 41 02             	mov    0x2(%ecx),%al
  2800ef:	c0 e8 02             	shr    $0x2,%al
  2800f2:	ee                   	out    %al,(%dx)
    rgb=rgb+3;
  2800f3:	83 c1 03             	add    $0x3,%ecx
  io_cli(); // disable interrupt
  //为什么写port 0x03c8
  
  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  2800f6:	43                   	inc    %ebx
  2800f7:	eb e1                	jmp    2800da <set_palette+0x19>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  2800f9:	56                   	push   %esi
  2800fa:	9d                   	popf   
  }
  
write_eflags(eflag);  //恢复从前的cpsr
  return;
  
}
  2800fb:	5b                   	pop    %ebx
  2800fc:	5e                   	pop    %esi
  2800fd:	5d                   	pop    %ebp
  2800fe:	c3                   	ret    

002800ff <init_palette>:
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  2800ff:	55                   	push   %ebp
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280100:	b9 0c 00 00 00       	mov    $0xc,%ecx
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280105:	89 e5                	mov    %esp,%ebp
  280107:	57                   	push   %edi
  280108:	56                   	push   %esi
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280109:	be c4 22 28 00       	mov    $0x2822c4,%esi
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  28010e:	83 ec 30             	sub    $0x30,%esp
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280111:	8d 45 c8             	lea    -0x38(%ebp),%eax
//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280114:	8d 7d c8             	lea    -0x38(%ebp),%edi
  280117:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280119:	50                   	push   %eax
  28011a:	68 ff 00 00 00       	push   $0xff
  28011f:	6a 00                	push   $0x0
  280121:	e8 9b ff ff ff       	call   2800c1 <set_palette>
  280126:	83 c4 0c             	add    $0xc,%esp
}
  280129:	8d 65 f8             	lea    -0x8(%ebp),%esp
  28012c:	5e                   	pop    %esi
  28012d:	5f                   	pop    %edi
  28012e:	5d                   	pop    %ebp
  28012f:	c3                   	ret    

00280130 <boxfill8>:
  return;
  
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
  280130:	55                   	push   %ebp
  280131:	89 e5                	mov    %esp,%ebp
  280133:	8b 4d 18             	mov    0x18(%ebp),%ecx
  280136:	8b 45 0c             	mov    0xc(%ebp),%eax
  280139:	53                   	push   %ebx
  28013a:	8a 5d 10             	mov    0x10(%ebp),%bl
  28013d:	0f af c1             	imul   %ecx,%eax
  280140:	03 45 08             	add    0x8(%ebp),%eax
 int x,y;
 for(y=y0;y<=y1;y++)
  280143:	3b 4d 20             	cmp    0x20(%ebp),%ecx
  280146:	7f 14                	jg     28015c <boxfill8+0x2c>
  280148:	8b 55 14             	mov    0x14(%ebp),%edx
 {
   for(x=x0;x<=x1;x++)
  28014b:	3b 55 1c             	cmp    0x1c(%ebp),%edx
  28014e:	7f 06                	jg     280156 <boxfill8+0x26>
   {
      vram[y*xsize+x]=color;
  280150:	88 1c 10             	mov    %bl,(%eax,%edx,1)
void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
  280153:	42                   	inc    %edx
  280154:	eb f5                	jmp    28014b <boxfill8+0x1b>
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
  280156:	41                   	inc    %ecx
  280157:	03 45 0c             	add    0xc(%ebp),%eax
  28015a:	eb e7                	jmp    280143 <boxfill8+0x13>
   {
      vram[y*xsize+x]=color;
   }
 }
   
}
  28015c:	5b                   	pop    %ebx
  28015d:	5d                   	pop    %ebp
  28015e:	c3                   	ret    

0028015f <boxfill>:
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  28015f:	55                   	push   %ebp
  280160:	89 e5                	mov    %esp,%ebp
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
  280162:	ff 75 18             	pushl  0x18(%ebp)
  280165:	ff 75 14             	pushl  0x14(%ebp)
  280168:	ff 75 10             	pushl  0x10(%ebp)
  28016b:	ff 75 0c             	pushl  0xc(%ebp)
  28016e:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  280172:	50                   	push   %eax
  280173:	68 40 01 00 00       	push   $0x140
  280178:	68 00 00 0a 00       	push   $0xa0000
  28017d:	e8 ae ff ff ff       	call   280130 <boxfill8>
  280182:	83 c4 1c             	add    $0x1c,%esp
}
  280185:	c9                   	leave  
  280186:	c3                   	ret    

00280187 <draw_window>:

void draw_window()
{ 
  280187:	55                   	push   %ebp
  280188:	89 e5                	mov    %esp,%ebp
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);
    
    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
  28018a:	68 ab 00 00 00       	push   $0xab
  28018f:	68 3f 01 00 00       	push   $0x13f
  280194:	6a 00                	push   $0x0
  280196:	6a 00                	push   $0x0
  280198:	6a 07                	push   $0x7
  28019a:	e8 c0 ff ff ff       	call   28015f <boxfill>
//task button    
    boxfill(8  ,0, y-28,x-1,y-28);
  28019f:	68 ac 00 00 00       	push   $0xac
  2801a4:	68 3f 01 00 00       	push   $0x13f
  2801a9:	68 ac 00 00 00       	push   $0xac
  2801ae:	6a 00                	push   $0x0
  2801b0:	6a 08                	push   $0x8
  2801b2:	e8 a8 ff ff ff       	call   28015f <boxfill>
    boxfill(7  ,0, y-27,x-1,y-27);
  2801b7:	83 c4 28             	add    $0x28,%esp
  2801ba:	68 ad 00 00 00       	push   $0xad
  2801bf:	68 3f 01 00 00       	push   $0x13f
  2801c4:	68 ad 00 00 00       	push   $0xad
  2801c9:	6a 00                	push   $0x0
  2801cb:	6a 07                	push   $0x7
  2801cd:	e8 8d ff ff ff       	call   28015f <boxfill>
    boxfill(8  ,0, y-26,x-1,y-1);
  2801d2:	68 c7 00 00 00       	push   $0xc7
  2801d7:	68 3f 01 00 00       	push   $0x13f
  2801dc:	68 ae 00 00 00       	push   $0xae
  2801e1:	6a 00                	push   $0x0
  2801e3:	6a 08                	push   $0x8
  2801e5:	e8 75 ff ff ff       	call   28015f <boxfill>
    
    
//left button    
    boxfill(7, 3,  y-24, 59,  y-24);
  2801ea:	83 c4 28             	add    $0x28,%esp
  2801ed:	68 b0 00 00 00       	push   $0xb0
  2801f2:	6a 3b                	push   $0x3b
  2801f4:	68 b0 00 00 00       	push   $0xb0
  2801f9:	6a 03                	push   $0x3
  2801fb:	6a 07                	push   $0x7
  2801fd:	e8 5d ff ff ff       	call   28015f <boxfill>
    boxfill(7, 2,  y-24, 2 ,  y-4);  
  280202:	68 c4 00 00 00       	push   $0xc4
  280207:	6a 02                	push   $0x2
  280209:	68 b0 00 00 00       	push   $0xb0
  28020e:	6a 02                	push   $0x2
  280210:	6a 07                	push   $0x7
  280212:	e8 48 ff ff ff       	call   28015f <boxfill>
    boxfill(15, 3,  y-4,  59,  y-4);
  280217:	83 c4 28             	add    $0x28,%esp
  28021a:	68 c4 00 00 00       	push   $0xc4
  28021f:	6a 3b                	push   $0x3b
  280221:	68 c4 00 00 00       	push   $0xc4
  280226:	6a 03                	push   $0x3
  280228:	6a 0f                	push   $0xf
  28022a:	e8 30 ff ff ff       	call   28015f <boxfill>
    boxfill(15, 59, y-23, 59,  y-5);
  28022f:	68 c3 00 00 00       	push   $0xc3
  280234:	6a 3b                	push   $0x3b
  280236:	68 b1 00 00 00       	push   $0xb1
  28023b:	6a 3b                	push   $0x3b
  28023d:	6a 0f                	push   $0xf
  28023f:	e8 1b ff ff ff       	call   28015f <boxfill>
    boxfill(0, 2,  y-3,  59,  y-3);
  280244:	83 c4 28             	add    $0x28,%esp
  280247:	68 c5 00 00 00       	push   $0xc5
  28024c:	6a 3b                	push   $0x3b
  28024e:	68 c5 00 00 00       	push   $0xc5
  280253:	6a 02                	push   $0x2
  280255:	6a 00                	push   $0x0
  280257:	e8 03 ff ff ff       	call   28015f <boxfill>
    boxfill(0, 60, y-24, 60,  y-3);  
  28025c:	68 c5 00 00 00       	push   $0xc5
  280261:	6a 3c                	push   $0x3c
  280263:	68 b0 00 00 00       	push   $0xb0
  280268:	6a 3c                	push   $0x3c
  28026a:	6a 00                	push   $0x0
  28026c:	e8 ee fe ff ff       	call   28015f <boxfill>

// 
//right button    
    boxfill(15, x-47, y-24,x-4,y-24);
  280271:	83 c4 28             	add    $0x28,%esp
  280274:	68 b0 00 00 00       	push   $0xb0
  280279:	68 3c 01 00 00       	push   $0x13c
  28027e:	68 b0 00 00 00       	push   $0xb0
  280283:	68 11 01 00 00       	push   $0x111
  280288:	6a 0f                	push   $0xf
  28028a:	e8 d0 fe ff ff       	call   28015f <boxfill>
    boxfill(15, x-47, y-23,x-47,y-4);  
  28028f:	68 c4 00 00 00       	push   $0xc4
  280294:	68 11 01 00 00       	push   $0x111
  280299:	68 b1 00 00 00       	push   $0xb1
  28029e:	68 11 01 00 00       	push   $0x111
  2802a3:	6a 0f                	push   $0xf
  2802a5:	e8 b5 fe ff ff       	call   28015f <boxfill>
    boxfill(7, x-47, y-3,x-4,y-3);
  2802aa:	83 c4 28             	add    $0x28,%esp
  2802ad:	68 c5 00 00 00       	push   $0xc5
  2802b2:	68 3c 01 00 00       	push   $0x13c
  2802b7:	68 c5 00 00 00       	push   $0xc5
  2802bc:	68 11 01 00 00       	push   $0x111
  2802c1:	6a 07                	push   $0x7
  2802c3:	e8 97 fe ff ff       	call   28015f <boxfill>
    boxfill(7, x-3, y-24,x-3,y-3);
  2802c8:	68 c5 00 00 00       	push   $0xc5
  2802cd:	68 3d 01 00 00       	push   $0x13d
  2802d2:	68 b0 00 00 00       	push   $0xb0
  2802d7:	68 3d 01 00 00       	push   $0x13d
  2802dc:	6a 07                	push   $0x7
  2802de:	e8 7c fe ff ff       	call   28015f <boxfill>
  2802e3:	83 c4 28             	add    $0x28,%esp
}
  2802e6:	c9                   	leave  
  2802e7:	c3                   	ret    

002802e8 <init_screen>:


void init_screen(struct boot_info * bootp)
{
  2802e8:	55                   	push   %ebp
  2802e9:	89 e5                	mov    %esp,%ebp
  2802eb:	8b 45 08             	mov    0x8(%ebp),%eax
  bootp->vram=(char *)VRAM;
  2802ee:	c7 40 08 00 00 0a 00 	movl   $0xa0000,0x8(%eax)
  bootp->color_mode=8;
  2802f5:	c6 40 02 08          	movb   $0x8,0x2(%eax)
  bootp->xsize=320;
  2802f9:	66 c7 40 04 40 01    	movw   $0x140,0x4(%eax)
  bootp->ysize=200;
  2802ff:	66 c7 40 06 c8 00    	movw   $0xc8,0x6(%eax)
  
}
  280305:	5d                   	pop    %ebp
  280306:	c3                   	ret    

00280307 <init_mouse>:

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
  280307:	55                   	push   %ebp
  280308:	31 c9                	xor    %ecx,%ecx
  28030a:	89 e5                	mov    %esp,%ebp
  28030c:	8a 45 0c             	mov    0xc(%ebp),%al
  28030f:	8b 55 08             	mov    0x8(%ebp),%edx
  280312:	56                   	push   %esi
  280313:	53                   	push   %ebx
  280314:	89 c6                	mov    %eax,%esi
  280316:	31 c0                	xor    %eax,%eax
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
  280318:	8a 9c 01 f4 22 28 00 	mov    0x2822f4(%ecx,%eax,1),%bl
  28031f:	80 fb 2e             	cmp    $0x2e,%bl
  280322:	74 10                	je     280334 <init_mouse+0x2d>
  280324:	80 fb 4f             	cmp    $0x4f,%bl
  280327:	74 12                	je     28033b <init_mouse+0x34>
  280329:	80 fb 2a             	cmp    $0x2a,%bl
  28032c:	75 11                	jne    28033f <init_mouse+0x38>
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
  28032e:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
  280332:	eb 0b                	jmp    28033f <init_mouse+0x38>
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
  280334:	89 f3                	mov    %esi,%ebx
  280336:	88 1c 02             	mov    %bl,(%edx,%eax,1)
  280339:	eb 04                	jmp    28033f <init_mouse+0x38>
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside
  28033b:	c6 04 02 02          	movb   $0x2,(%edx,%eax,1)
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
  28033f:	40                   	inc    %eax
  280340:	83 f8 10             	cmp    $0x10,%eax
  280343:	75 d3                	jne    280318 <init_mouse+0x11>
  280345:	83 c1 10             	add    $0x10,%ecx
  280348:	83 c2 10             	add    $0x10,%edx
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
  28034b:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  280351:	75 c3                	jne    280316 <init_mouse+0xf>
	    
	  }
	  
	}
  
}
  280353:	5b                   	pop    %ebx
  280354:	5e                   	pop    %esi
  280355:	5d                   	pop    %ebp
  280356:	c3                   	ret    

00280357 <display_mouse>:

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280357:	55                   	push   %ebp
  280358:	89 e5                	mov    %esp,%ebp
  28035a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  28035d:	56                   	push   %esi
  int x,y;
  for(y=0;y<pysize;y++)
  28035e:	31 f6                	xor    %esi,%esi
	}
  
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280360:	53                   	push   %ebx
  280361:	8b 5d 20             	mov    0x20(%ebp),%ebx
  280364:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280368:	03 45 18             	add    0x18(%ebp),%eax
  28036b:	03 45 08             	add    0x8(%ebp),%eax
  int x,y;
  for(y=0;y<pysize;y++)
  28036e:	3b 75 14             	cmp    0x14(%ebp),%esi
  280371:	7d 19                	jge    28038c <display_mouse+0x35>
  280373:	31 d2                	xor    %edx,%edx
  {
    for(x=0;x<pxsize;x++)
  280375:	3b 55 10             	cmp    0x10(%ebp),%edx
  280378:	7d 09                	jge    280383 <display_mouse+0x2c>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
  28037a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  28037d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
  280380:	42                   	inc    %edx
  280381:	eb f2                	jmp    280375 <display_mouse+0x1e>
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  280383:	46                   	inc    %esi
  280384:	03 5d 24             	add    0x24(%ebp),%ebx
  280387:	03 45 0c             	add    0xc(%ebp),%eax
  28038a:	eb e2                	jmp    28036e <display_mouse+0x17>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }
  
}
  28038c:	5b                   	pop    %ebx
  28038d:	5e                   	pop    %esi
  28038e:	5d                   	pop    %ebp
  28038f:	c3                   	ret    

00280390 <itoa>:
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  280390:	55                   	push   %ebp
    char tmp_buf[10] = {0};
  280391:	31 c0                	xor    %eax,%eax
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  280393:	89 e5                	mov    %esp,%ebp
    char tmp_buf[10] = {0};
  280395:	b9 0a 00 00 00       	mov    $0xa,%ecx
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  28039a:	57                   	push   %edi
  28039b:	56                   	push   %esi
  28039c:	53                   	push   %ebx
  28039d:	83 ec 10             	sub    $0x10,%esp
  2803a0:	8b 55 08             	mov    0x8(%ebp),%edx
    char tmp_buf[10] = {0};
  2803a3:	8d 7d ea             	lea    -0x16(%ebp),%edi
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  2803a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    char tmp_buf[10] = {0};
  2803a9:	f3 aa                	rep stos %al,%es:(%edi)
  2803ab:	8d 7d ea             	lea    -0x16(%ebp),%edi
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
  2803ae:	85 d2                	test   %edx,%edx
  2803b0:	79 06                	jns    2803b8 <itoa+0x28>
    { /* neg num */
        *buf++ = '-';//得到负号
  2803b2:	c6 03 2d             	movb   $0x2d,(%ebx)
        value = ~value + 1; //将负数变为正数
  2803b5:	f7 da                	neg    %edx
void itoa(int value,char *buf){
    char tmp_buf[10] = {0};
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
  2803b7:	43                   	inc    %ebx
  2803b8:	89 f9                	mov    %edi,%ecx
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803ba:	be 0a 00 00 00       	mov    $0xa,%esi
  2803bf:	89 d0                	mov    %edx,%eax
  2803c1:	41                   	inc    %ecx
  2803c2:	99                   	cltd   
  2803c3:	f7 fe                	idiv   %esi
  2803c5:	83 c2 30             	add    $0x30,%edx
        value /= 10;
    }while(value);
  2803c8:	85 c0                	test   %eax,%eax
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803ca:	88 51 ff             	mov    %dl,-0x1(%ecx)
        value /= 10;
  2803cd:	89 c2                	mov    %eax,%edx
    }while(value);
  2803cf:	75 ee                	jne    2803bf <itoa+0x2f>
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803d1:	89 ce                	mov    %ecx,%esi
  2803d3:	89 d8                	mov    %ebx,%eax
        value /= 10;
    }while(value);
    
    
    while(tmp_buf != tbp)
  2803d5:	39 f9                	cmp    %edi,%ecx
  2803d7:	74 09                	je     2803e2 <itoa+0x52>
    {
      tbp--;
  2803d9:	49                   	dec    %ecx
      *buf++ = *tbp;
  2803da:	8a 11                	mov    (%ecx),%dl
  2803dc:	40                   	inc    %eax
  2803dd:	88 50 ff             	mov    %dl,-0x1(%eax)
  2803e0:	eb f3                	jmp    2803d5 <itoa+0x45>
  2803e2:	89 f0                	mov    %esi,%eax
  2803e4:	29 c8                	sub    %ecx,%eax

    }
    *buf='\0';
  2803e6:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)
    
    
}
  2803ea:	83 c4 10             	add    $0x10,%esp
  2803ed:	5b                   	pop    %ebx
  2803ee:	5e                   	pop    %esi
  2803ef:	5f                   	pop    %edi
  2803f0:	5d                   	pop    %ebp
  2803f1:	c3                   	ret    

002803f2 <xtoa>:
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2803f2:	55                   	push   %ebp
    char tmp_buf[30] = {0};
  2803f3:	31 c0                	xor    %eax,%eax
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2803f5:	89 e5                	mov    %esp,%ebp
    char tmp_buf[30] = {0};
  2803f7:	b9 1e 00 00 00       	mov    $0x1e,%ecx
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2803fc:	57                   	push   %edi
  2803fd:	56                   	push   %esi
  2803fe:	53                   	push   %ebx
  2803ff:	83 ec 20             	sub    $0x20,%esp
  280402:	8b 55 0c             	mov    0xc(%ebp),%edx
    char tmp_buf[30] = {0};
  280405:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280408:	f3 aa                	rep stos %al,%es:(%edi)
    char *tbp = tmp_buf;
  28040a:	8d 45 d6             	lea    -0x2a(%ebp),%eax

    *buf++='0';
  28040d:	c6 02 30             	movb   $0x30,(%edx)
    *buf++='x';
  280410:	8d 72 02             	lea    0x2(%edx),%esi
  280413:	c6 42 01 78          	movb   $0x78,0x1(%edx)
  
    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  28041a:	40                   	inc    %eax
  28041b:	83 e3 0f             	and    $0xf,%ebx
    
    
}
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
  28041e:	83 fb 0a             	cmp    $0xa,%ebx
  280421:	8d 4b 37             	lea    0x37(%ebx),%ecx
  280424:	8d 7b 30             	lea    0x30(%ebx),%edi
  280427:	0f 4c cf             	cmovl  %edi,%ecx
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
        
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  28042a:	c1 6d 08 04          	shrl   $0x4,0x8(%ebp)
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
  28042e:	88 48 ff             	mov    %cl,-0x1(%eax)
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
        
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280431:	75 e4                	jne    280417 <xtoa+0x25>
    *buf++='x';
  
    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280433:	89 c3                	mov    %eax,%ebx
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
    
    
    while(tmp_buf != tbp)
  280435:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280438:	39 f8                	cmp    %edi,%eax
  28043a:	74 09                	je     280445 <xtoa+0x53>
    {
      tbp--;
  28043c:	48                   	dec    %eax
      *buf++ = *tbp;
  28043d:	8a 08                	mov    (%eax),%cl
  28043f:	46                   	inc    %esi
  280440:	88 4e ff             	mov    %cl,-0x1(%esi)
  280443:	eb f0                	jmp    280435 <xtoa+0x43>
  280445:	29 c3                	sub    %eax,%ebx

    }
    *buf='\0';
  280447:	c6 44 1a 02 00       	movb   $0x0,0x2(%edx,%ebx,1)
    
    
}
  28044c:	83 c4 20             	add    $0x20,%esp
  28044f:	5b                   	pop    %ebx
  280450:	5e                   	pop    %esi
  280451:	5f                   	pop    %edi
  280452:	5d                   	pop    %ebp
  280453:	c3                   	ret    

00280454 <sprintf>:



//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf(char *str,char *format ,...)
{
  280454:	55                   	push   %ebp
  280455:	89 e5                	mov    %esp,%ebp
  280457:	57                   	push   %edi
  280458:	56                   	push   %esi
  280459:	53                   	push   %ebx
  28045a:	83 ec 10             	sub    $0x10,%esp
  28045d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
  280460:	8d 75 10             	lea    0x10(%ebp),%esi
   char buffer[10];
   char *buf=buffer;
  while(*format)
  280463:	8b 7d 0c             	mov    0xc(%ebp),%edi
  280466:	8a 07                	mov    (%edi),%al
  280468:	84 c0                	test   %al,%al
  28046a:	0f 84 83 00 00 00    	je     2804f3 <sprintf+0x9f>
  280470:	8d 4f 01             	lea    0x1(%edi),%ecx
  {
      if(*format!='%')
  280473:	3c 25                	cmp    $0x25,%al
      {
	*str++=*format++;
  280475:	89 4d 0c             	mov    %ecx,0xc(%ebp)
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
   char buffer[10];
   char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
  280478:	74 05                	je     28047f <sprintf+0x2b>
      {
	*str++=*format++;
  28047a:	88 03                	mov    %al,(%ebx)
  28047c:	43                   	inc    %ebx
	continue;
  28047d:	eb e4                	jmp    280463 <sprintf+0xf>
      }
      else
      {
	format++;
	switch (*format)
  28047f:	8a 47 01             	mov    0x1(%edi),%al
  280482:	3c 73                	cmp    $0x73,%al
  280484:	74 46                	je     2804cc <sprintf+0x78>
  280486:	3c 78                	cmp    $0x78,%al
  280488:	74 23                	je     2804ad <sprintf+0x59>
  28048a:	3c 64                	cmp    $0x64,%al
  28048c:	75 53                	jne    2804e1 <sprintf+0x8d>
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
  28048e:	8d 45 ea             	lea    -0x16(%ebp),%eax
  280491:	50                   	push   %eax
  280492:	ff 36                	pushl  (%esi)
  280494:	e8 f7 fe ff ff       	call   280390 <itoa>
  280499:	59                   	pop    %ecx
  28049a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  28049d:	58                   	pop    %eax
  28049e:	89 d8                	mov    %ebx,%eax
  2804a0:	8a 19                	mov    (%ecx),%bl
  2804a2:	84 db                	test   %bl,%bl
  2804a4:	74 3d                	je     2804e3 <sprintf+0x8f>
  2804a6:	40                   	inc    %eax
  2804a7:	41                   	inc    %ecx
  2804a8:	88 58 ff             	mov    %bl,-0x1(%eax)
  2804ab:	eb f3                	jmp    2804a0 <sprintf+0x4c>
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
  2804ad:	8d 45 ea             	lea    -0x16(%ebp),%eax
  2804b0:	50                   	push   %eax
  2804b1:	ff 36                	pushl  (%esi)
  2804b3:	e8 3a ff ff ff       	call   2803f2 <xtoa>
  2804b8:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  2804bb:	58                   	pop    %eax
  2804bc:	89 d8                	mov    %ebx,%eax
  2804be:	5a                   	pop    %edx
  2804bf:	8a 19                	mov    (%ecx),%bl
  2804c1:	84 db                	test   %bl,%bl
  2804c3:	74 1e                	je     2804e3 <sprintf+0x8f>
  2804c5:	40                   	inc    %eax
  2804c6:	41                   	inc    %ecx
  2804c7:	88 58 ff             	mov    %bl,-0x1(%eax)
  2804ca:	eb f3                	jmp    2804bf <sprintf+0x6b>
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
  2804cc:	8b 16                	mov    (%esi),%edx
  2804ce:	89 d8                	mov    %ebx,%eax
  2804d0:	89 c1                	mov    %eax,%ecx
  2804d2:	29 d9                	sub    %ebx,%ecx
  2804d4:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
  2804d7:	84 c9                	test   %cl,%cl
  2804d9:	74 08                	je     2804e3 <sprintf+0x8f>
  2804db:	40                   	inc    %eax
  2804dc:	88 48 ff             	mov    %cl,-0x1(%eax)
  2804df:	eb ef                	jmp    2804d0 <sprintf+0x7c>
	continue;
      }
      else
      {
	format++;
	switch (*format)
  2804e1:	89 d8                	mov    %ebx,%eax
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
	  
	}
	buf=buffer;
	var++;
	format++;
  2804e3:	83 c7 02             	add    $0x2,%edi
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
	  
	}
	buf=buffer;
	var++;
  2804e6:	83 c6 04             	add    $0x4,%esi
	format++;
  2804e9:	89 7d 0c             	mov    %edi,0xc(%ebp)
  2804ec:	89 c3                	mov    %eax,%ebx
  2804ee:	e9 70 ff ff ff       	jmp    280463 <sprintf+0xf>
	
      }
    
  }
  *str='\0';
  2804f3:	c6 03 00             	movb   $0x0,(%ebx)
  
}
  2804f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  2804f9:	5b                   	pop    %ebx
  2804fa:	5e                   	pop    %esi
  2804fb:	5f                   	pop    %edi
  2804fc:	5d                   	pop    %ebp
  2804fd:	c3                   	ret    

002804fe <putfont8>:
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  2804fe:	55                   	push   %ebp
  int row,col;
  char d;
  for(row=0;row<16;row++)
  2804ff:	31 d2                	xor    %edx,%edx
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280501:	89 e5                	mov    %esp,%ebp
  280503:	57                   	push   %edi
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280504:	bf 80 00 00 00       	mov    $0x80,%edi
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280509:	56                   	push   %esi
  28050a:	53                   	push   %ebx
  28050b:	83 ec 01             	sub    $0x1,%esp
  28050e:	8a 45 18             	mov    0x18(%ebp),%al
  280511:	88 45 f3             	mov    %al,-0xd(%ebp)
  280514:	8b 45 14             	mov    0x14(%ebp),%eax
  280517:	0f af 45 0c          	imul   0xc(%ebp),%eax
  28051b:	03 45 10             	add    0x10(%ebp),%eax
  28051e:	03 45 08             	add    0x8(%ebp),%eax
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  280521:	8b 75 1c             	mov    0x1c(%ebp),%esi
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280524:	31 c9                	xor    %ecx,%ecx
    {
      if(d&(0x80>>col))
  280526:	0f be 34 16          	movsbl (%esi,%edx,1),%esi
  28052a:	89 fb                	mov    %edi,%ebx
  28052c:	d3 fb                	sar    %cl,%ebx
  28052e:	85 f3                	test   %esi,%ebx
  280530:	74 06                	je     280538 <putfont8+0x3a>
      {
	vram[(y+row)*xsize+x+col]=color;
  280532:	8a 5d f3             	mov    -0xd(%ebp),%bl
  280535:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280538:	41                   	inc    %ecx
  280539:	83 f9 08             	cmp    $0x8,%ecx
  28053c:	75 ec                	jne    28052a <putfont8+0x2c>

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  28053e:	42                   	inc    %edx
  28053f:	03 45 0c             	add    0xc(%ebp),%eax
  280542:	83 fa 10             	cmp    $0x10,%edx
  280545:	75 da                	jne    280521 <putfont8+0x23>
    }
    
  }
  return;
  
}
  280547:	83 c4 01             	add    $0x1,%esp
  28054a:	5b                   	pop    %ebx
  28054b:	5e                   	pop    %esi
  28054c:	5f                   	pop    %edi
  28054d:	5d                   	pop    %ebp
  28054e:	c3                   	ret    

0028054f <puts8>:
  *str='\0';
  
}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  28054f:	55                   	push   %ebp
  280550:	89 e5                	mov    %esp,%ebp
  280552:	57                   	push   %edi
  280553:	8b 7d 14             	mov    0x14(%ebp),%edi
  280556:	56                   	push   %esi
      y=y+16;
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280557:	0f be 75 18          	movsbl 0x18(%ebp),%esi
  *str='\0';
  
}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  28055b:	53                   	push   %ebx
  28055c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  
 while(*font)
  28055f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280562:	0f be 00             	movsbl (%eax),%eax
  280565:	84 c0                	test   %al,%al
  280567:	74 42                	je     2805ab <puts8+0x5c>
 {
    if(*font=='\n')
  280569:	3c 0a                	cmp    $0xa,%al
  28056b:	75 05                	jne    280572 <puts8+0x23>
    {
      x=0;
      y=y+16;
  28056d:	83 c7 10             	add    $0x10,%edi
  280570:	eb 32                	jmp    2805a4 <puts8+0x55>
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280572:	c1 e0 04             	shl    $0x4,%eax
  280575:	05 f4 08 28 00       	add    $0x2808f4,%eax
  28057a:	50                   	push   %eax
  28057b:	56                   	push   %esi
  28057c:	57                   	push   %edi
  28057d:	53                   	push   %ebx
    x+=8;
  28057e:	83 c3 08             	add    $0x8,%ebx
      y=y+16;
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280581:	ff 75 0c             	pushl  0xc(%ebp)
  280584:	ff 75 08             	pushl  0x8(%ebp)
  280587:	e8 72 ff ff ff       	call   2804fe <putfont8>
    x+=8;
    if(x>312)
  28058c:	83 c4 18             	add    $0x18,%esp
  28058f:	81 fb 38 01 00 00    	cmp    $0x138,%ebx
  280595:	7e 0f                	jle    2805a6 <puts8+0x57>
       {
	  x=0;
	  y+=16;
  280597:	83 c7 10             	add    $0x10,%edi
	  if(y>183)
  28059a:	81 ff b7 00 00 00    	cmp    $0xb7,%edi
  2805a0:	7e 02                	jle    2805a4 <puts8+0x55>
	  {
	    x=0;
	    y=0;
  2805a2:	31 ff                	xor    %edi,%edi
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
  2805a4:	31 db                	xor    %ebx,%ebx
	    
	  }
        }    
    }
    
    font++;
  2805a6:	ff 45 1c             	incl   0x1c(%ebp)
  2805a9:	eb b4                	jmp    28055f <puts8+0x10>
}
  
}
  2805ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  2805ae:	5b                   	pop    %ebx
  2805af:	5e                   	pop    %esi
  2805b0:	5f                   	pop    %edi
  2805b1:	5d                   	pop    %ebp
  2805b2:	c3                   	ret    

002805b3 <printdebug>:
#include<header.h>


void printdebug(int i,int x)
{
  2805b3:	55                   	push   %ebp
  2805b4:	89 e5                	mov    %esp,%ebp
  2805b6:	53                   	push   %ebx
  2805b7:	83 ec 20             	sub    $0x20,%esp
char font[30];
sprintf(font,"Debug:var=%x" ,i);
  2805ba:	ff 75 08             	pushl  0x8(%ebp)
  2805bd:	8d 5d de             	lea    -0x22(%ebp),%ebx
  2805c0:	68 9c 27 28 00       	push   $0x28279c
  2805c5:	53                   	push   %ebx
  2805c6:	e8 89 fe ff ff       	call   280454 <sprintf>
puts8((char *)VRAM ,320,x,150,1,font);
  2805cb:	53                   	push   %ebx
  2805cc:	6a 01                	push   $0x1
  2805ce:	68 96 00 00 00       	push   $0x96
  2805d3:	ff 75 0c             	pushl  0xc(%ebp)
  2805d6:	68 40 01 00 00       	push   $0x140
  2805db:	68 00 00 0a 00       	push   $0xa0000
  2805e0:	e8 6a ff ff ff       	call   28054f <puts8>
  2805e5:	83 c4 24             	add    $0x24,%esp

}
  2805e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2805eb:	c9                   	leave  
  2805ec:	c3                   	ret    

002805ed <putfont16>:
      
  }
  
}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  2805ed:	55                   	push   %ebp
  2805ee:	31 c9                	xor    %ecx,%ecx
  2805f0:	89 e5                	mov    %esp,%ebp
  2805f2:	57                   	push   %edi
  2805f3:	56                   	push   %esi
  2805f4:	53                   	push   %ebx
  2805f5:	52                   	push   %edx
  2805f6:	8b 55 14             	mov    0x14(%ebp),%edx
  2805f9:	0f af 55 0c          	imul   0xc(%ebp),%edx
  2805fd:	8b 45 10             	mov    0x10(%ebp),%eax
  280600:	03 45 08             	add    0x8(%ebp),%eax
  280603:	8a 5d 18             	mov    0x18(%ebp),%bl
  280606:	01 d0                	add    %edx,%eax
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280608:	31 d2                	xor    %edx,%edx
  28060a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
  28060d:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  280610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  280613:	0f b7 bc 57 00 fa ff 	movzwl -0x600(%edi,%edx,2),%edi
  28061a:	ff 
  28061b:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  28061e:	31 c0                	xor    %eax,%eax
    {
       if( (d&(1 << col) ))
  280620:	0f a3 c7             	bt     %eax,%edi
  280623:	73 03                	jae    280628 <putfont16+0x3b>
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;
  280625:	88 1c 06             	mov    %bl,(%esi,%eax,1)
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280628:	40                   	inc    %eax
  280629:	83 f8 10             	cmp    $0x10,%eax
  28062c:	75 f2                	jne    280620 <putfont16+0x33>
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  28062e:	42                   	inc    %edx
  28062f:	03 4d 0c             	add    0xc(%ebp),%ecx
  280632:	83 fa 18             	cmp    $0x18,%edx
  280635:	75 d6                	jne    28060d <putfont16+0x20>
    }
    
  }
  return;
  
}
  280637:	58                   	pop    %eax
  280638:	5b                   	pop    %ebx
  280639:	5e                   	pop    %esi
  28063a:	5f                   	pop    %edi
  28063b:	5d                   	pop    %ebp
  28063c:	c3                   	ret    

0028063d <puts16>:
  return;
  
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  28063d:	55                   	push   %ebp
  28063e:	89 e5                	mov    %esp,%ebp
  280640:	57                   	push   %edi
  280641:	8b 7d 10             	mov    0x10(%ebp),%edi
  280644:	56                   	push   %esi
  280645:	8b 75 14             	mov    0x14(%ebp),%esi
  280648:	53                   	push   %ebx
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280649:	0f be 5d 18          	movsbl 0x18(%ebp),%ebx
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  28064d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280650:	0f be 00             	movsbl (%eax),%eax
  280653:	84 c0                	test   %al,%al
  280655:	74 2d                	je     280684 <puts16+0x47>
  {
    if(*font=='\n')
  280657:	3c 0a                	cmp    $0xa,%al
  280659:	75 07                	jne    280662 <puts16+0x25>
    {
      x=0;
      y=y+24;
  28065b:	83 c6 18             	add    $0x18,%esi
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
  28065e:	31 ff                	xor    %edi,%edi
  280660:	eb 1d                	jmp    28067f <puts16+0x42>
      y=y+24;
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
  280662:	6b c0 30             	imul   $0x30,%eax,%eax
  280665:	05 f4 10 28 00       	add    $0x2810f4,%eax
	putfont16(vram ,xsize,x,y,color,pt);
  28066a:	50                   	push   %eax
  28066b:	53                   	push   %ebx
  28066c:	56                   	push   %esi
  28066d:	57                   	push   %edi
	x=x+16;
  28066e:	83 c7 10             	add    $0x10,%edi
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280671:	ff 75 0c             	pushl  0xc(%ebp)
  280674:	ff 75 08             	pushl  0x8(%ebp)
  280677:	e8 71 ff ff ff       	call   2805ed <putfont16>
	x=x+16;
  28067c:	83 c4 18             	add    $0x18,%esp
	   
	   
    }
    
     font++;
  28067f:	ff 45 1c             	incl   0x1c(%ebp)
  280682:	eb c9                	jmp    28064d <puts16+0x10>
      
  }
  
}
  280684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280687:	5b                   	pop    %ebx
  280688:	5e                   	pop    %esi
  280689:	5f                   	pop    %edi
  28068a:	5d                   	pop    %ebp
  28068b:	c3                   	ret    

0028068c <setgdt>:
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  28068c:	55                   	push   %ebp
  28068d:	89 e5                	mov    %esp,%ebp
  28068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  280692:	57                   	push   %edi
  280693:	8b 45 08             	mov    0x8(%ebp),%eax
  280696:	56                   	push   %esi
  280697:	8b 7d 14             	mov    0x14(%ebp),%edi
  28069a:	53                   	push   %ebx
  28069b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(limit>0xffff)
  28069e:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
  2806a4:	76 09                	jbe    2806af <setgdt+0x23>
  {
    access|=0x8000;
  2806a6:	81 cf 00 80 00 00    	or     $0x8000,%edi
    limit /=0x1000;
  2806ac:	c1 ea 0c             	shr    $0xc,%edx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  2806af:	89 de                	mov    %ebx,%esi
  2806b1:	c1 fe 10             	sar    $0x10,%esi
  2806b4:	89 f1                	mov    %esi,%ecx
  2806b6:	88 48 04             	mov    %cl,0x4(%eax)
  sd->access_right=access&0xff;
  2806b9:	89 f9                	mov    %edi,%ecx
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806bb:	c1 ff 08             	sar    $0x8,%edi
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  2806be:	88 48 05             	mov    %cl,0x5(%eax)
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806c1:	89 f9                	mov    %edi,%ecx
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  2806c3:	66 89 10             	mov    %dx,(%eax)
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806c6:	83 e1 f0             	and    $0xfffffff0,%ecx
  2806c9:	c1 ea 10             	shr    $0x10,%edx
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  2806cc:	66 89 58 02          	mov    %bx,0x2(%eax)
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806d0:	09 d1                	or     %edx,%ecx
  sd->base_high=(base>>24)&0xff;
  2806d2:	c1 eb 18             	shr    $0x18,%ebx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806d5:	88 48 06             	mov    %cl,0x6(%eax)
  sd->base_high=(base>>24)&0xff;
  2806d8:	88 58 07             	mov    %bl,0x7(%eax)
  
}
  2806db:	5b                   	pop    %ebx
  2806dc:	5e                   	pop    %esi
  2806dd:	5f                   	pop    %edi
  2806de:	5d                   	pop    %ebp
  2806df:	c3                   	ret    

002806e0 <setidt>:

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  2806e0:	55                   	push   %ebp
  2806e1:	89 e5                	mov    %esp,%ebp
  2806e3:	8b 45 08             	mov    0x8(%ebp),%eax
  2806e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  2806e9:	8b 55 14             	mov    0x14(%ebp),%edx
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2806ec:	66 89 08             	mov    %cx,(%eax)
  gd->offset_high=(offset>>16)&0xffff;
  2806ef:	c1 e9 10             	shr    $0x10,%ecx
  2806f2:	66 89 48 06          	mov    %cx,0x6(%eax)
  
  //16位的selector决定了base address
  gd->selector=selector;
  2806f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  
  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2806f9:	88 50 05             	mov    %dl,0x5(%eax)
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  
  //16位的selector决定了base address
  gd->selector=selector;
  2806fc:	66 89 48 02          	mov    %cx,0x2(%eax)
  
  gd->dw_count=(access>>8)&0xff;
  280700:	89 d1                	mov    %edx,%ecx
  280702:	c1 f9 08             	sar    $0x8,%ecx
  280705:	88 48 04             	mov    %cl,0x4(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  
  
}
  280708:	5d                   	pop    %ebp
  280709:	c3                   	ret    

0028070a <init_gdtidt>:



void  init_gdtidt()
{
  28070a:	55                   	push   %ebp
  28070b:	89 e5                	mov    %esp,%ebp
  28070d:	53                   	push   %ebx
  28070e:	53                   	push   %ebx
  28070f:	bb 00 00 27 00       	mov    $0x270000,%ebx
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  280714:	6a 00                	push   $0x0
  280716:	6a 00                	push   $0x0
  280718:	6a 00                	push   $0x0
  28071a:	53                   	push   %ebx
  28071b:	83 c3 08             	add    $0x8,%ebx
  28071e:	e8 69 ff ff ff       	call   28068c <setgdt>
void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  280723:	83 c4 10             	add    $0x10,%esp
  280726:	81 fb 00 00 28 00    	cmp    $0x280000,%ebx
  28072c:	75 e6                	jne    280714 <init_gdtidt+0xa>
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  28072e:	68 92 40 00 00       	push   $0x4092
  280733:	6a 00                	push   $0x0
  280735:	6a ff                	push   $0xffffffff
  280737:	68 08 00 27 00       	push   $0x270008
  28073c:	e8 4b ff ff ff       	call   28068c <setgdt>
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  280741:	68 9a 40 00 00       	push   $0x409a
  280746:	6a 00                	push   $0x0
  280748:	68 ff ff 0f 00       	push   $0xfffff
  28074d:	68 10 00 27 00       	push   $0x270010
  280752:	e8 35 ff ff ff       	call   28068c <setgdt>
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  280757:	83 c4 20             	add    $0x20,%esp
  28075a:	68 9a 40 00 00       	push   $0x409a
  28075f:	68 00 00 28 00       	push   $0x280000
  280764:	68 ff ff 0f 00       	push   $0xfffff
  280769:	68 18 00 27 00       	push   $0x270018
  28076e:	e8 19 ff ff ff       	call   28068c <setgdt>

   load_gdtr(0xfff,0X00270000);//this is right
  280773:	5a                   	pop    %edx
  280774:	59                   	pop    %ecx
  280775:	68 00 00 27 00       	push   $0x270000
  28077a:	68 ff 0f 00 00       	push   $0xfff
  28077f:	e8 4f 01 00 00       	call   2808d3 <load_gdtr>
  280784:	83 c4 10             	add    $0x10,%esp
  280787:	31 c0                	xor    %eax,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280789:	66 c7 80 00 f8 26 00 	movw   $0x0,0x26f800(%eax)
  280790:	00 00 
  280792:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  280795:	66 c7 80 fe f7 26 00 	movw   $0x0,0x26f7fe(%eax)
  28079c:	00 00 
  
  //16位的selector决定了base address
  gd->selector=selector;
  28079e:	66 c7 80 fa f7 26 00 	movw   $0x0,0x26f7fa(%eax)
  2807a5:	00 00 
  
  gd->dw_count=(access>>8)&0xff;
  2807a7:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2807ae:	c6 80 fd f7 26 00 00 	movb   $0x0,0x26f7fd(%eax)
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  2807b5:	3d 00 08 00 00       	cmp    $0x800,%eax
  2807ba:	75 cd                	jne    280789 <init_gdtidt+0x7f>

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  2807bc:	ba b8 08 28 00       	mov    $0x2808b8,%edx
  2807c1:	66 31 c0             	xor    %ax,%ax
  2807c4:	c1 ea 10             	shr    $0x10,%edx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2807c7:	b9 b8 08 28 00       	mov    $0x2808b8,%ecx
  2807cc:	66 89 88 00 f8 26 00 	mov    %cx,0x26f800(%eax)
  2807d3:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  2807d6:	66 89 90 fe f7 26 00 	mov    %dx,0x26f7fe(%eax)
  
  //16位的selector决定了base address
  gd->selector=selector;
  2807dd:	66 c7 80 fa f7 26 00 	movw   $0x18,0x26f7fa(%eax)
  2807e4:	18 00 
  
  gd->dw_count=(access>>8)&0xff;
  2807e6:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2807ed:	c6 80 fd f7 26 00 8e 	movb   $0x8e,0x26f7fd(%eax)
  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }
  
  for(i=0;i<256;i++)
  2807f4:	3d 00 08 00 00       	cmp    $0x800,%eax
  2807f9:	75 d1                	jne    2807cc <init_gdtidt+0xc2>
  {
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
    
  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
  2807fb:	b8 b8 08 00 00       	mov    $0x8b8,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280800:	66 a3 08 f9 26 00    	mov    %ax,0x26f908
  gd->offset_high=(offset>>16)&0xffff;
  280806:	c1 e8 10             	shr    $0x10,%eax
  280809:	66 a3 0e f9 26 00    	mov    %ax,0x26f90e
  
  //16位的selector决定了base address
  gd->selector=selector;
  28080f:	66 c7 05 0a f9 26 00 	movw   $0x18,0x26f90a
  280816:	18 00 
  
  gd->dw_count=(access>>8)&0xff;
  280818:	c6 05 0c f9 26 00 00 	movb   $0x0,0x26f90c
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  28081f:	c6 05 0d f9 26 00 8e 	movb   $0x8e,0x26f90d
      setidt(idt+i,(int)asm_inthandler21,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
    
  }
  setidt(idt+0x21,(int)asm_inthandler21-0x280000,3*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  load_idtr(0x7ff,0x0026f800);//this is right
  280826:	50                   	push   %eax
  280827:	50                   	push   %eax
  280828:	68 00 f8 26 00       	push   $0x26f800
  28082d:	68 ff 07 00 00       	push   $0x7ff
  280832:	e8 ac 00 00 00       	call   2808e3 <load_idtr>
  280837:	83 c4 10             	add    $0x10,%esp

  return;

}
  28083a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  28083d:	c9                   	leave  
  28083e:	c3                   	ret    

0028083f <init_pic>:
#define PIC1_ICW4		0x00a1
*/


void init_pic()
{
  28083f:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  280840:	ba 21 00 00 00       	mov    $0x21,%edx
  280845:	89 e5                	mov    %esp,%ebp
  280847:	b0 ff                	mov    $0xff,%al
  280849:	ee                   	out    %al,(%dx)
  28084a:	b2 a1                	mov    $0xa1,%dl
  28084c:	ee                   	out    %al,(%dx)
  28084d:	b0 11                	mov    $0x11,%al
  28084f:	b2 20                	mov    $0x20,%dl
  280851:	ee                   	out    %al,(%dx)
  280852:	b0 20                	mov    $0x20,%al
  280854:	b2 21                	mov    $0x21,%dl
  280856:	ee                   	out    %al,(%dx)
  280857:	b0 04                	mov    $0x4,%al
  280859:	ee                   	out    %al,(%dx)
  28085a:	b0 01                	mov    $0x1,%al
  28085c:	ee                   	out    %al,(%dx)
  28085d:	b0 11                	mov    $0x11,%al
  28085f:	b2 a0                	mov    $0xa0,%dl
  280861:	ee                   	out    %al,(%dx)
  280862:	b0 28                	mov    $0x28,%al
  280864:	b2 a1                	mov    $0xa1,%dl
  280866:	ee                   	out    %al,(%dx)
  280867:	b0 02                	mov    $0x2,%al
  280869:	ee                   	out    %al,(%dx)
  28086a:	b0 01                	mov    $0x1,%al
  28086c:	ee                   	out    %al,(%dx)
  28086d:	b0 fb                	mov    $0xfb,%al
  28086f:	b2 21                	mov    $0x21,%dl
  280871:	ee                   	out    %al,(%dx)
  280872:	b0 ff                	mov    $0xff,%al
  280874:	b2 a1                	mov    $0xa1,%dl
  280876:	ee                   	out    %al,(%dx)

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}
  280877:	5d                   	pop    %ebp
  280878:	c3                   	ret    

00280879 <inthandler21>:

//interrupt service procedure for keyboard
void inthandler21(int *esp)
{
  280879:	55                   	push   %ebp
  28087a:	89 e5                	mov    %esp,%ebp
  28087c:	83 ec 14             	sub    $0x14,%esp
  struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  boxfill(0,0,0,32*8-1,15);//一个黑色的小box
  28087f:	6a 0f                	push   $0xf
  280881:	68 ff 00 00 00       	push   $0xff
  280886:	6a 00                	push   $0x0
  280888:	6a 00                	push   $0x0
  28088a:	6a 00                	push   $0x0
  28088c:	e8 ce f8 ff ff       	call   28015f <boxfill>
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int 21(IRQ-1):PS/2 keyboard");
  280891:	83 c4 18             	add    $0x18,%esp
  280894:	68 a9 27 28 00       	push   $0x2827a9
  280899:	6a 07                	push   $0x7
  28089b:	6a 00                	push   $0x0
  28089d:	6a 00                	push   $0x0
  28089f:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2808a6:	50                   	push   %eax
  2808a7:	ff 35 f8 0f 00 00    	pushl  0xff8
  2808ad:	e8 9d fc ff ff       	call   28054f <puts8>
  2808b2:	83 c4 20             	add    $0x20,%esp
  while(1)
  io_halt();
  2808b5:	f4                   	hlt    
  2808b6:	eb fd                	jmp    2808b5 <inthandler21+0x3c>

002808b8 <asm_inthandler21>:
.global asm_inthandler21
.global load_gdtr 
.global load_idtr
.code32
asm_inthandler21:
  pushw %es
  2808b8:	66 06                	pushw  %es
  pushw %ds
  2808ba:	66 1e                	pushw  %ds
  pushal
  2808bc:	60                   	pusha  
  movl %esp,%eax
  2808bd:	89 e0                	mov    %esp,%eax
  pushl %eax
  2808bf:	50                   	push   %eax
  movw %ss,%ax
  2808c0:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  2808c3:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  2808c5:	8e c0                	mov    %eax,%es
  call inthandler21
  2808c7:	e8 ad ff ff ff       	call   280879 <inthandler21>
  
  popl %eax
  2808cc:	58                   	pop    %eax
  popal
  2808cd:	61                   	popa   
  popw %ds
  2808ce:	66 1f                	popw   %ds
  popW %es
  2808d0:	66 07                	popw   %es
  iret
  2808d2:	cf                   	iret   

002808d3 <load_gdtr>:
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2808d3:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2808d8:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lgdt 6(%esp)
  2808dd:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  ret
  2808e2:	c3                   	ret    

002808e3 <load_idtr>:


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2808e3:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2808e8:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lidt 6(%esp)
  2808ed:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  2808f2:	c3                   	ret    

Disassembly of section .rodata:

002808f4 <Font8x16>:
	...
  280b04:	00 00                	add    %al,(%eax)
  280b06:	00 10                	add    %dl,(%eax)
  280b08:	10 10                	adc    %dl,(%eax)
  280b0a:	10 10                	adc    %dl,(%eax)
  280b0c:	10 00                	adc    %al,(%eax)
  280b0e:	10 10                	adc    %dl,(%eax)
  280b10:	00 00                	add    %al,(%eax)
  280b12:	00 00                	add    %al,(%eax)
  280b14:	00 00                	add    %al,(%eax)
  280b16:	00 24 24             	add    %ah,(%esp)
  280b19:	24 00                	and    $0x0,%al
	...
  280b27:	24 24                	and    $0x24,%al
  280b29:	7e 24                	jle    280b4f <Font8x16+0x25b>
  280b2b:	24 24                	and    $0x24,%al
  280b2d:	7e 24                	jle    280b53 <Font8x16+0x25f>
  280b2f:	24 00                	and    $0x0,%al
  280b31:	00 00                	add    %al,(%eax)
  280b33:	00 00                	add    %al,(%eax)
  280b35:	00 00                	add    %al,(%eax)
  280b37:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  280b3b:	7c 12                	jl     280b4f <Font8x16+0x25b>
  280b3d:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  280b41:	00 00                	add    %al,(%eax)
  280b43:	00 00                	add    %al,(%eax)
  280b45:	00 00                	add    %al,(%eax)
  280b47:	00 62 64             	add    %ah,0x64(%edx)
  280b4a:	08 10                	or     %dl,(%eax)
  280b4c:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  280b58:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  280b5b:	50                   	push   %eax
  280b5c:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  280b63:	00 00                	add    %al,(%eax)
  280b65:	00 00                	add    %al,(%eax)
  280b67:	10 10                	adc    %dl,(%eax)
  280b69:	20 00                	and    %al,(%eax)
	...
  280b73:	00 00                	add    %al,(%eax)
  280b75:	00 08                	add    %cl,(%eax)
  280b77:	10 20                	adc    %ah,(%eax)
  280b79:	20 20                	and    %ah,(%eax)
  280b7b:	20 20                	and    %ah,(%eax)
  280b7d:	20 20                	and    %ah,(%eax)
  280b7f:	10 08                	adc    %cl,(%eax)
  280b81:	00 00                	add    %al,(%eax)
  280b83:	00 00                	add    %al,(%eax)
  280b85:	00 20                	add    %ah,(%eax)
  280b87:	10 08                	adc    %cl,(%eax)
  280b89:	08 08                	or     %cl,(%eax)
  280b8b:	08 08                	or     %cl,(%eax)
  280b8d:	08 08                	or     %cl,(%eax)
  280b8f:	10 20                	adc    %ah,(%eax)
	...
  280b99:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  280b9d:	54                   	push   %esp
  280b9e:	10 00                	adc    %al,(%eax)
	...
  280ba8:	00 10                	add    %dl,(%eax)
  280baa:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  280bbe:	10 10                	adc    %dl,(%eax)
  280bc0:	20 00                	and    %al,(%eax)
	...
  280bca:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  280bde:	00 10                	add    %dl,(%eax)
	...
  280be8:	00 02                	add    %al,(%edx)
  280bea:	04 08                	add    $0x8,%al
  280bec:	10 20                	adc    %ah,(%eax)
  280bee:	40                   	inc    %eax
	...
  280bf7:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  280bfb:	54                   	push   %esp
  280bfc:	64                   	fs
  280bfd:	44                   	inc    %esp
  280bfe:	44                   	inc    %esp
  280bff:	38 00                	cmp    %al,(%eax)
  280c01:	00 00                	add    %al,(%eax)
  280c03:	00 00                	add    %al,(%eax)
  280c05:	00 00                	add    %al,(%eax)
  280c07:	10 30                	adc    %dh,(%eax)
  280c09:	10 10                	adc    %dl,(%eax)
  280c0b:	10 10                	adc    %dl,(%eax)
  280c0d:	10 10                	adc    %dl,(%eax)
  280c0f:	38 00                	cmp    %al,(%eax)
  280c11:	00 00                	add    %al,(%eax)
  280c13:	00 00                	add    %al,(%eax)
  280c15:	00 00                	add    %al,(%eax)
  280c17:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  280c1b:	08 10                	or     %dl,(%eax)
  280c1d:	20 40 7c             	and    %al,0x7c(%eax)
  280c20:	00 00                	add    %al,(%eax)
  280c22:	00 00                	add    %al,(%eax)
  280c24:	00 00                	add    %al,(%eax)
  280c26:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  280c2a:	10 38                	adc    %bh,(%eax)
  280c2c:	04 04                	add    $0x4,%al
  280c2e:	04 78                	add    $0x78,%al
  280c30:	00 00                	add    %al,(%eax)
  280c32:	00 00                	add    %al,(%eax)
  280c34:	00 00                	add    %al,(%eax)
  280c36:	00 08                	add    %cl,(%eax)
  280c38:	18 28                	sbb    %ch,(%eax)
  280c3a:	48                   	dec    %eax
  280c3b:	48                   	dec    %eax
  280c3c:	7c 08                	jl     280c46 <Font8x16+0x352>
  280c3e:	08 08                	or     %cl,(%eax)
  280c40:	00 00                	add    %al,(%eax)
  280c42:	00 00                	add    %al,(%eax)
  280c44:	00 00                	add    %al,(%eax)
  280c46:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  280c4a:	40                   	inc    %eax
  280c4b:	78 04                	js     280c51 <Font8x16+0x35d>
  280c4d:	04 04                	add    $0x4,%al
  280c4f:	78 00                	js     280c51 <Font8x16+0x35d>
  280c51:	00 00                	add    %al,(%eax)
  280c53:	00 00                	add    %al,(%eax)
  280c55:	00 00                	add    %al,(%eax)
  280c57:	3c 40                	cmp    $0x40,%al
  280c59:	40                   	inc    %eax
  280c5a:	40                   	inc    %eax
  280c5b:	78 44                	js     280ca1 <Font8x16+0x3ad>
  280c5d:	44                   	inc    %esp
  280c5e:	44                   	inc    %esp
  280c5f:	38 00                	cmp    %al,(%eax)
  280c61:	00 00                	add    %al,(%eax)
  280c63:	00 00                	add    %al,(%eax)
  280c65:	00 00                	add    %al,(%eax)
  280c67:	7c 04                	jl     280c6d <Font8x16+0x379>
  280c69:	04 08                	add    $0x8,%al
  280c6b:	10 20                	adc    %ah,(%eax)
  280c6d:	20 20                	and    %ah,(%eax)
  280c6f:	20 00                	and    %al,(%eax)
  280c71:	00 00                	add    %al,(%eax)
  280c73:	00 00                	add    %al,(%eax)
  280c75:	00 00                	add    %al,(%eax)
  280c77:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c7b:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c7f:	38 00                	cmp    %al,(%eax)
  280c81:	00 00                	add    %al,(%eax)
  280c83:	00 00                	add    %al,(%eax)
  280c85:	00 00                	add    %al,(%eax)
  280c87:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c8b:	3c 04                	cmp    $0x4,%al
  280c8d:	04 04                	add    $0x4,%al
  280c8f:	38 00                	cmp    %al,(%eax)
	...
  280c99:	00 00                	add    %al,(%eax)
  280c9b:	10 00                	adc    %al,(%eax)
  280c9d:	00 10                	add    %dl,(%eax)
	...
  280cab:	00 10                	add    %dl,(%eax)
  280cad:	00 10                	add    %dl,(%eax)
  280caf:	10 20                	adc    %ah,(%eax)
	...
  280cb9:	04 08                	add    $0x8,%al
  280cbb:	10 20                	adc    %ah,(%eax)
  280cbd:	10 08                	adc    %cl,(%eax)
  280cbf:	04 00                	add    $0x0,%al
	...
  280cc9:	00 00                	add    %al,(%eax)
  280ccb:	7c 00                	jl     280ccd <Font8x16+0x3d9>
  280ccd:	7c 00                	jl     280ccf <Font8x16+0x3db>
	...
  280cd7:	00 00                	add    %al,(%eax)
  280cd9:	20 10                	and    %dl,(%eax)
  280cdb:	08 04 08             	or     %al,(%eax,%ecx,1)
  280cde:	10 20                	adc    %ah,(%eax)
  280ce0:	00 00                	add    %al,(%eax)
  280ce2:	00 00                	add    %al,(%eax)
  280ce4:	00 00                	add    %al,(%eax)
  280ce6:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  280cea:	08 10                	or     %dl,(%eax)
  280cec:	10 00                	adc    %al,(%eax)
  280cee:	10 10                	adc    %dl,(%eax)
	...
  280cf8:	00 38                	add    %bh,(%eax)
  280cfa:	44                   	inc    %esp
  280cfb:	5c                   	pop    %esp
  280cfc:	54                   	push   %esp
  280cfd:	5c                   	pop    %esp
  280cfe:	40                   	inc    %eax
  280cff:	3c 00                	cmp    $0x0,%al
  280d01:	00 00                	add    %al,(%eax)
  280d03:	00 00                	add    %al,(%eax)
  280d05:	00 18                	add    %bl,(%eax)
  280d07:	24 42                	and    $0x42,%al
  280d09:	42                   	inc    %edx
  280d0a:	42                   	inc    %edx
  280d0b:	7e 42                	jle    280d4f <Font8x16+0x45b>
  280d0d:	42                   	inc    %edx
  280d0e:	42                   	inc    %edx
  280d0f:	42                   	inc    %edx
  280d10:	00 00                	add    %al,(%eax)
  280d12:	00 00                	add    %al,(%eax)
  280d14:	00 00                	add    %al,(%eax)
  280d16:	7c 42                	jl     280d5a <Font8x16+0x466>
  280d18:	42                   	inc    %edx
  280d19:	42                   	inc    %edx
  280d1a:	7c 42                	jl     280d5e <Font8x16+0x46a>
  280d1c:	42                   	inc    %edx
  280d1d:	42                   	inc    %edx
  280d1e:	42                   	inc    %edx
  280d1f:	7c 00                	jl     280d21 <Font8x16+0x42d>
  280d21:	00 00                	add    %al,(%eax)
  280d23:	00 00                	add    %al,(%eax)
  280d25:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280d28:	40                   	inc    %eax
  280d29:	40                   	inc    %eax
  280d2a:	40                   	inc    %eax
  280d2b:	40                   	inc    %eax
  280d2c:	40                   	inc    %eax
  280d2d:	40                   	inc    %eax
  280d2e:	42                   	inc    %edx
  280d2f:	3c 00                	cmp    $0x0,%al
  280d31:	00 00                	add    %al,(%eax)
  280d33:	00 00                	add    %al,(%eax)
  280d35:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280d39:	42                   	inc    %edx
  280d3a:	42                   	inc    %edx
  280d3b:	42                   	inc    %edx
  280d3c:	42                   	inc    %edx
  280d3d:	42                   	inc    %edx
  280d3e:	42                   	inc    %edx
  280d3f:	7c 00                	jl     280d41 <Font8x16+0x44d>
  280d41:	00 00                	add    %al,(%eax)
  280d43:	00 00                	add    %al,(%eax)
  280d45:	00 7e 40             	add    %bh,0x40(%esi)
  280d48:	40                   	inc    %eax
  280d49:	40                   	inc    %eax
  280d4a:	78 40                	js     280d8c <Font8x16+0x498>
  280d4c:	40                   	inc    %eax
  280d4d:	40                   	inc    %eax
  280d4e:	40                   	inc    %eax
  280d4f:	7e 00                	jle    280d51 <Font8x16+0x45d>
  280d51:	00 00                	add    %al,(%eax)
  280d53:	00 00                	add    %al,(%eax)
  280d55:	00 7e 40             	add    %bh,0x40(%esi)
  280d58:	40                   	inc    %eax
  280d59:	40                   	inc    %eax
  280d5a:	78 40                	js     280d9c <Font8x16+0x4a8>
  280d5c:	40                   	inc    %eax
  280d5d:	40                   	inc    %eax
  280d5e:	40                   	inc    %eax
  280d5f:	40                   	inc    %eax
  280d60:	00 00                	add    %al,(%eax)
  280d62:	00 00                	add    %al,(%eax)
  280d64:	00 00                	add    %al,(%eax)
  280d66:	3c 42                	cmp    $0x42,%al
  280d68:	40                   	inc    %eax
  280d69:	40                   	inc    %eax
  280d6a:	5e                   	pop    %esi
  280d6b:	42                   	inc    %edx
  280d6c:	42                   	inc    %edx
  280d6d:	42                   	inc    %edx
  280d6e:	42                   	inc    %edx
  280d6f:	3c 00                	cmp    $0x0,%al
  280d71:	00 00                	add    %al,(%eax)
  280d73:	00 00                	add    %al,(%eax)
  280d75:	00 42 42             	add    %al,0x42(%edx)
  280d78:	42                   	inc    %edx
  280d79:	42                   	inc    %edx
  280d7a:	7e 42                	jle    280dbe <Font8x16+0x4ca>
  280d7c:	42                   	inc    %edx
  280d7d:	42                   	inc    %edx
  280d7e:	42                   	inc    %edx
  280d7f:	42                   	inc    %edx
  280d80:	00 00                	add    %al,(%eax)
  280d82:	00 00                	add    %al,(%eax)
  280d84:	00 00                	add    %al,(%eax)
  280d86:	38 10                	cmp    %dl,(%eax)
  280d88:	10 10                	adc    %dl,(%eax)
  280d8a:	10 10                	adc    %dl,(%eax)
  280d8c:	10 10                	adc    %dl,(%eax)
  280d8e:	10 38                	adc    %bh,(%eax)
  280d90:	00 00                	add    %al,(%eax)
  280d92:	00 00                	add    %al,(%eax)
  280d94:	00 00                	add    %al,(%eax)
  280d96:	1c 08                	sbb    $0x8,%al
  280d98:	08 08                	or     %cl,(%eax)
  280d9a:	08 08                	or     %cl,(%eax)
  280d9c:	08 08                	or     %cl,(%eax)
  280d9e:	48                   	dec    %eax
  280d9f:	30 00                	xor    %al,(%eax)
  280da1:	00 00                	add    %al,(%eax)
  280da3:	00 00                	add    %al,(%eax)
  280da5:	00 42 44             	add    %al,0x44(%edx)
  280da8:	48                   	dec    %eax
  280da9:	50                   	push   %eax
  280daa:	60                   	pusha  
  280dab:	60                   	pusha  
  280dac:	50                   	push   %eax
  280dad:	48                   	dec    %eax
  280dae:	44                   	inc    %esp
  280daf:	42                   	inc    %edx
  280db0:	00 00                	add    %al,(%eax)
  280db2:	00 00                	add    %al,(%eax)
  280db4:	00 00                	add    %al,(%eax)
  280db6:	40                   	inc    %eax
  280db7:	40                   	inc    %eax
  280db8:	40                   	inc    %eax
  280db9:	40                   	inc    %eax
  280dba:	40                   	inc    %eax
  280dbb:	40                   	inc    %eax
  280dbc:	40                   	inc    %eax
  280dbd:	40                   	inc    %eax
  280dbe:	40                   	inc    %eax
  280dbf:	7e 00                	jle    280dc1 <Font8x16+0x4cd>
  280dc1:	00 00                	add    %al,(%eax)
  280dc3:	00 00                	add    %al,(%eax)
  280dc5:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  280dcb:	aa                   	stos   %al,%es:(%edi)
  280dcc:	92                   	xchg   %eax,%edx
  280dcd:	92                   	xchg   %eax,%edx
  280dce:	82                   	(bad)  
  280dcf:	82                   	(bad)  
  280dd0:	00 00                	add    %al,(%eax)
  280dd2:	00 00                	add    %al,(%eax)
  280dd4:	00 00                	add    %al,(%eax)
  280dd6:	42                   	inc    %edx
  280dd7:	62 62 52             	bound  %esp,0x52(%edx)
  280dda:	52                   	push   %edx
  280ddb:	4a                   	dec    %edx
  280ddc:	4a                   	dec    %edx
  280ddd:	46                   	inc    %esi
  280dde:	46                   	inc    %esi
  280ddf:	42                   	inc    %edx
  280de0:	00 00                	add    %al,(%eax)
  280de2:	00 00                	add    %al,(%eax)
  280de4:	00 00                	add    %al,(%eax)
  280de6:	3c 42                	cmp    $0x42,%al
  280de8:	42                   	inc    %edx
  280de9:	42                   	inc    %edx
  280dea:	42                   	inc    %edx
  280deb:	42                   	inc    %edx
  280dec:	42                   	inc    %edx
  280ded:	42                   	inc    %edx
  280dee:	42                   	inc    %edx
  280def:	3c 00                	cmp    $0x0,%al
  280df1:	00 00                	add    %al,(%eax)
  280df3:	00 00                	add    %al,(%eax)
  280df5:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280df9:	42                   	inc    %edx
  280dfa:	42                   	inc    %edx
  280dfb:	7c 40                	jl     280e3d <Font8x16+0x549>
  280dfd:	40                   	inc    %eax
  280dfe:	40                   	inc    %eax
  280dff:	40                   	inc    %eax
  280e00:	00 00                	add    %al,(%eax)
  280e02:	00 00                	add    %al,(%eax)
  280e04:	00 00                	add    %al,(%eax)
  280e06:	3c 42                	cmp    $0x42,%al
  280e08:	42                   	inc    %edx
  280e09:	42                   	inc    %edx
  280e0a:	42                   	inc    %edx
  280e0b:	42                   	inc    %edx
  280e0c:	42                   	inc    %edx
  280e0d:	42                   	inc    %edx
  280e0e:	4a                   	dec    %edx
  280e0f:	3c 0e                	cmp    $0xe,%al
  280e11:	00 00                	add    %al,(%eax)
  280e13:	00 00                	add    %al,(%eax)
  280e15:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280e19:	42                   	inc    %edx
  280e1a:	42                   	inc    %edx
  280e1b:	7c 50                	jl     280e6d <Font8x16+0x579>
  280e1d:	48                   	dec    %eax
  280e1e:	44                   	inc    %esp
  280e1f:	42                   	inc    %edx
  280e20:	00 00                	add    %al,(%eax)
  280e22:	00 00                	add    %al,(%eax)
  280e24:	00 00                	add    %al,(%eax)
  280e26:	3c 42                	cmp    $0x42,%al
  280e28:	40                   	inc    %eax
  280e29:	40                   	inc    %eax
  280e2a:	3c 02                	cmp    $0x2,%al
  280e2c:	02 02                	add    (%edx),%al
  280e2e:	42                   	inc    %edx
  280e2f:	3c 00                	cmp    $0x0,%al
  280e31:	00 00                	add    %al,(%eax)
  280e33:	00 00                	add    %al,(%eax)
  280e35:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  280e39:	10 10                	adc    %dl,(%eax)
  280e3b:	10 10                	adc    %dl,(%eax)
  280e3d:	10 10                	adc    %dl,(%eax)
  280e3f:	10 00                	adc    %al,(%eax)
  280e41:	00 00                	add    %al,(%eax)
  280e43:	00 00                	add    %al,(%eax)
  280e45:	00 42 42             	add    %al,0x42(%edx)
  280e48:	42                   	inc    %edx
  280e49:	42                   	inc    %edx
  280e4a:	42                   	inc    %edx
  280e4b:	42                   	inc    %edx
  280e4c:	42                   	inc    %edx
  280e4d:	42                   	inc    %edx
  280e4e:	42                   	inc    %edx
  280e4f:	3c 00                	cmp    $0x0,%al
  280e51:	00 00                	add    %al,(%eax)
  280e53:	00 00                	add    %al,(%eax)
  280e55:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  280e59:	44                   	inc    %esp
  280e5a:	28 28                	sub    %ch,(%eax)
  280e5c:	28 10                	sub    %dl,(%eax)
  280e5e:	10 10                	adc    %dl,(%eax)
  280e60:	00 00                	add    %al,(%eax)
  280e62:	00 00                	add    %al,(%eax)
  280e64:	00 00                	add    %al,(%eax)
  280e66:	82                   	(bad)  
  280e67:	82                   	(bad)  
  280e68:	82                   	(bad)  
  280e69:	82                   	(bad)  
  280e6a:	54                   	push   %esp
  280e6b:	54                   	push   %esp
  280e6c:	54                   	push   %esp
  280e6d:	28 28                	sub    %ch,(%eax)
  280e6f:	28 00                	sub    %al,(%eax)
  280e71:	00 00                	add    %al,(%eax)
  280e73:	00 00                	add    %al,(%eax)
  280e75:	00 42 42             	add    %al,0x42(%edx)
  280e78:	24 18                	and    $0x18,%al
  280e7a:	18 18                	sbb    %bl,(%eax)
  280e7c:	24 24                	and    $0x24,%al
  280e7e:	42                   	inc    %edx
  280e7f:	42                   	inc    %edx
  280e80:	00 00                	add    %al,(%eax)
  280e82:	00 00                	add    %al,(%eax)
  280e84:	00 00                	add    %al,(%eax)
  280e86:	44                   	inc    %esp
  280e87:	44                   	inc    %esp
  280e88:	44                   	inc    %esp
  280e89:	44                   	inc    %esp
  280e8a:	28 28                	sub    %ch,(%eax)
  280e8c:	10 10                	adc    %dl,(%eax)
  280e8e:	10 10                	adc    %dl,(%eax)
  280e90:	00 00                	add    %al,(%eax)
  280e92:	00 00                	add    %al,(%eax)
  280e94:	00 00                	add    %al,(%eax)
  280e96:	7e 02                	jle    280e9a <Font8x16+0x5a6>
  280e98:	02 04 08             	add    (%eax,%ecx,1),%al
  280e9b:	10 20                	adc    %ah,(%eax)
  280e9d:	40                   	inc    %eax
  280e9e:	40                   	inc    %eax
  280e9f:	7e 00                	jle    280ea1 <Font8x16+0x5ad>
  280ea1:	00 00                	add    %al,(%eax)
  280ea3:	00 00                	add    %al,(%eax)
  280ea5:	00 38                	add    %bh,(%eax)
  280ea7:	20 20                	and    %ah,(%eax)
  280ea9:	20 20                	and    %ah,(%eax)
  280eab:	20 20                	and    %ah,(%eax)
  280ead:	20 20                	and    %ah,(%eax)
  280eaf:	38 00                	cmp    %al,(%eax)
	...
  280eb9:	00 40 20             	add    %al,0x20(%eax)
  280ebc:	10 08                	adc    %cl,(%eax)
  280ebe:	04 02                	add    $0x2,%al
  280ec0:	00 00                	add    %al,(%eax)
  280ec2:	00 00                	add    %al,(%eax)
  280ec4:	00 00                	add    %al,(%eax)
  280ec6:	1c 04                	sbb    $0x4,%al
  280ec8:	04 04                	add    $0x4,%al
  280eca:	04 04                	add    $0x4,%al
  280ecc:	04 04                	add    $0x4,%al
  280ece:	04 1c                	add    $0x1c,%al
	...
  280ed8:	10 28                	adc    %ch,(%eax)
  280eda:	44                   	inc    %esp
	...
  280eef:	00 ff                	add    %bh,%bh
  280ef1:	00 00                	add    %al,(%eax)
  280ef3:	00 00                	add    %al,(%eax)
  280ef5:	00 00                	add    %al,(%eax)
  280ef7:	10 10                	adc    %dl,(%eax)
  280ef9:	08 00                	or     %al,(%eax)
	...
  280f07:	00 00                	add    %al,(%eax)
  280f09:	78 04                	js     280f0f <Font8x16+0x61b>
  280f0b:	3c 44                	cmp    $0x44,%al
  280f0d:	44                   	inc    %esp
  280f0e:	44                   	inc    %esp
  280f0f:	3a 00                	cmp    (%eax),%al
  280f11:	00 00                	add    %al,(%eax)
  280f13:	00 00                	add    %al,(%eax)
  280f15:	00 40 40             	add    %al,0x40(%eax)
  280f18:	40                   	inc    %eax
  280f19:	5c                   	pop    %esp
  280f1a:	62 42 42             	bound  %eax,0x42(%edx)
  280f1d:	42                   	inc    %edx
  280f1e:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  280f22:	00 00                	add    %al,(%eax)
  280f24:	00 00                	add    %al,(%eax)
  280f26:	00 00                	add    %al,(%eax)
  280f28:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280f2b:	40                   	inc    %eax
  280f2c:	40                   	inc    %eax
  280f2d:	40                   	inc    %eax
  280f2e:	42                   	inc    %edx
  280f2f:	3c 00                	cmp    $0x0,%al
  280f31:	00 00                	add    %al,(%eax)
  280f33:	00 00                	add    %al,(%eax)
  280f35:	00 02                	add    %al,(%edx)
  280f37:	02 02                	add    (%edx),%al
  280f39:	3a 46 42             	cmp    0x42(%esi),%al
  280f3c:	42                   	inc    %edx
  280f3d:	42                   	inc    %edx
  280f3e:	46                   	inc    %esi
  280f3f:	3a 00                	cmp    (%eax),%al
	...
  280f49:	3c 42                	cmp    $0x42,%al
  280f4b:	42                   	inc    %edx
  280f4c:	7e 40                	jle    280f8e <Font8x16+0x69a>
  280f4e:	42                   	inc    %edx
  280f4f:	3c 00                	cmp    $0x0,%al
  280f51:	00 00                	add    %al,(%eax)
  280f53:	00 00                	add    %al,(%eax)
  280f55:	00 0e                	add    %cl,(%esi)
  280f57:	10 10                	adc    %dl,(%eax)
  280f59:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  280f5c:	10 10                	adc    %dl,(%eax)
  280f5e:	10 10                	adc    %dl,(%eax)
	...
  280f68:	00 3e                	add    %bh,(%esi)
  280f6a:	42                   	inc    %edx
  280f6b:	42                   	inc    %edx
  280f6c:	42                   	inc    %edx
  280f6d:	42                   	inc    %edx
  280f6e:	3e 02 02             	add    %ds:(%edx),%al
  280f71:	3c 00                	cmp    $0x0,%al
  280f73:	00 00                	add    %al,(%eax)
  280f75:	00 40 40             	add    %al,0x40(%eax)
  280f78:	40                   	inc    %eax
  280f79:	5c                   	pop    %esp
  280f7a:	62 42 42             	bound  %eax,0x42(%edx)
  280f7d:	42                   	inc    %edx
  280f7e:	42                   	inc    %edx
  280f7f:	42                   	inc    %edx
  280f80:	00 00                	add    %al,(%eax)
  280f82:	00 00                	add    %al,(%eax)
  280f84:	00 00                	add    %al,(%eax)
  280f86:	00 08                	add    %cl,(%eax)
  280f88:	00 08                	add    %cl,(%eax)
  280f8a:	08 08                	or     %cl,(%eax)
  280f8c:	08 08                	or     %cl,(%eax)
  280f8e:	08 08                	or     %cl,(%eax)
  280f90:	00 00                	add    %al,(%eax)
  280f92:	00 00                	add    %al,(%eax)
  280f94:	00 00                	add    %al,(%eax)
  280f96:	00 04 00             	add    %al,(%eax,%eax,1)
  280f99:	04 04                	add    $0x4,%al
  280f9b:	04 04                	add    $0x4,%al
  280f9d:	04 04                	add    $0x4,%al
  280f9f:	04 44                	add    $0x44,%al
  280fa1:	38 00                	cmp    %al,(%eax)
  280fa3:	00 00                	add    %al,(%eax)
  280fa5:	00 40 40             	add    %al,0x40(%eax)
  280fa8:	40                   	inc    %eax
  280fa9:	42                   	inc    %edx
  280faa:	44                   	inc    %esp
  280fab:	48                   	dec    %eax
  280fac:	50                   	push   %eax
  280fad:	68 44 42 00 00       	push   $0x4244
  280fb2:	00 00                	add    %al,(%eax)
  280fb4:	00 00                	add    %al,(%eax)
  280fb6:	10 10                	adc    %dl,(%eax)
  280fb8:	10 10                	adc    %dl,(%eax)
  280fba:	10 10                	adc    %dl,(%eax)
  280fbc:	10 10                	adc    %dl,(%eax)
  280fbe:	10 10                	adc    %dl,(%eax)
	...
  280fc8:	00 ec                	add    %ch,%ah
  280fca:	92                   	xchg   %eax,%edx
  280fcb:	92                   	xchg   %eax,%edx
  280fcc:	92                   	xchg   %eax,%edx
  280fcd:	92                   	xchg   %eax,%edx
  280fce:	92                   	xchg   %eax,%edx
  280fcf:	92                   	xchg   %eax,%edx
	...
  280fd8:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280fdc:	42                   	inc    %edx
  280fdd:	42                   	inc    %edx
  280fde:	42                   	inc    %edx
  280fdf:	42                   	inc    %edx
	...
  280fe8:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280feb:	42                   	inc    %edx
  280fec:	42                   	inc    %edx
  280fed:	42                   	inc    %edx
  280fee:	42                   	inc    %edx
  280fef:	3c 00                	cmp    $0x0,%al
	...
  280ff9:	5c                   	pop    %esp
  280ffa:	62 42 42             	bound  %eax,0x42(%edx)
  280ffd:	42                   	inc    %edx
  280ffe:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  281002:	00 00                	add    %al,(%eax)
  281004:	00 00                	add    %al,(%eax)
  281006:	00 00                	add    %al,(%eax)
  281008:	00 3a                	add    %bh,(%edx)
  28100a:	46                   	inc    %esi
  28100b:	42                   	inc    %edx
  28100c:	42                   	inc    %edx
  28100d:	42                   	inc    %edx
  28100e:	46                   	inc    %esi
  28100f:	3a 02                	cmp    (%edx),%al
  281011:	02 00                	add    (%eax),%al
  281013:	00 00                	add    %al,(%eax)
  281015:	00 00                	add    %al,(%eax)
  281017:	00 00                	add    %al,(%eax)
  281019:	5c                   	pop    %esp
  28101a:	62 40 40             	bound  %eax,0x40(%eax)
  28101d:	40                   	inc    %eax
  28101e:	40                   	inc    %eax
  28101f:	40                   	inc    %eax
	...
  281028:	00 3c 42             	add    %bh,(%edx,%eax,2)
  28102b:	40                   	inc    %eax
  28102c:	3c 02                	cmp    $0x2,%al
  28102e:	42                   	inc    %edx
  28102f:	3c 00                	cmp    $0x0,%al
  281031:	00 00                	add    %al,(%eax)
  281033:	00 00                	add    %al,(%eax)
  281035:	00 00                	add    %al,(%eax)
  281037:	20 20                	and    %ah,(%eax)
  281039:	78 20                	js     28105b <Font8x16+0x767>
  28103b:	20 20                	and    %ah,(%eax)
  28103d:	20 22                	and    %ah,(%edx)
  28103f:	1c 00                	sbb    $0x0,%al
	...
  281049:	42                   	inc    %edx
  28104a:	42                   	inc    %edx
  28104b:	42                   	inc    %edx
  28104c:	42                   	inc    %edx
  28104d:	42                   	inc    %edx
  28104e:	42                   	inc    %edx
  28104f:	3e 00 00             	add    %al,%ds:(%eax)
  281052:	00 00                	add    %al,(%eax)
  281054:	00 00                	add    %al,(%eax)
  281056:	00 00                	add    %al,(%eax)
  281058:	00 42 42             	add    %al,0x42(%edx)
  28105b:	42                   	inc    %edx
  28105c:	42                   	inc    %edx
  28105d:	42                   	inc    %edx
  28105e:	24 18                	and    $0x18,%al
	...
  281068:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  28106e:	aa                   	stos   %al,%es:(%edi)
  28106f:	44                   	inc    %esp
	...
  281078:	00 42 42             	add    %al,0x42(%edx)
  28107b:	24 18                	and    $0x18,%al
  28107d:	24 42                	and    $0x42,%al
  28107f:	42                   	inc    %edx
	...
  281088:	00 42 42             	add    %al,0x42(%edx)
  28108b:	42                   	inc    %edx
  28108c:	42                   	inc    %edx
  28108d:	42                   	inc    %edx
  28108e:	3e 02 02             	add    %ds:(%edx),%al
  281091:	3c 00                	cmp    $0x0,%al
  281093:	00 00                	add    %al,(%eax)
  281095:	00 00                	add    %al,(%eax)
  281097:	00 00                	add    %al,(%eax)
  281099:	7e 02                	jle    28109d <Font8x16+0x7a9>
  28109b:	04 18                	add    $0x18,%al
  28109d:	20 40 7e             	and    %al,0x7e(%eax)
  2810a0:	00 00                	add    %al,(%eax)
  2810a2:	00 00                	add    %al,(%eax)
  2810a4:	00 00                	add    %al,(%eax)
  2810a6:	08 10                	or     %dl,(%eax)
  2810a8:	10 10                	adc    %dl,(%eax)
  2810aa:	20 40 20             	and    %al,0x20(%eax)
  2810ad:	10 10                	adc    %dl,(%eax)
  2810af:	10 08                	adc    %cl,(%eax)
  2810b1:	00 00                	add    %al,(%eax)
  2810b3:	00 00                	add    %al,(%eax)
  2810b5:	10 10                	adc    %dl,(%eax)
  2810b7:	10 10                	adc    %dl,(%eax)
  2810b9:	10 10                	adc    %dl,(%eax)
  2810bb:	10 10                	adc    %dl,(%eax)
  2810bd:	10 10                	adc    %dl,(%eax)
  2810bf:	10 10                	adc    %dl,(%eax)
  2810c1:	10 10                	adc    %dl,(%eax)
  2810c3:	00 00                	add    %al,(%eax)
  2810c5:	00 20                	add    %ah,(%eax)
  2810c7:	10 10                	adc    %dl,(%eax)
  2810c9:	10 08                	adc    %cl,(%eax)
  2810cb:	04 08                	add    $0x8,%al
  2810cd:	10 10                	adc    %dl,(%eax)
  2810cf:	10 20                	adc    %ah,(%eax)
	...
  2810d9:	00 22                	add    %ah,(%edx)
  2810db:	54                   	push   %esp
  2810dc:	88 00                	mov    %al,(%eax)
	...

002810f4 <ASCII_Table>:
	...
  281124:	00 00                	add    %al,(%eax)
  281126:	80 01 80             	addb   $0x80,(%ecx)
  281129:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28112f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281135:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28113b:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  281141:	00 00                	add    %al,(%eax)
  281143:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281155:	00 00                	add    %al,(%eax)
  281157:	00 cc                	add    %cl,%ah
  281159:	00 cc                	add    %cl,%ah
  28115b:	00 cc                	add    %cl,%ah
  28115d:	00 cc                	add    %cl,%ah
  28115f:	00 cc                	add    %cl,%ah
  281161:	00 cc                	add    %cl,%ah
	...
  28118f:	00 60 0c             	add    %ah,0xc(%eax)
  281192:	60                   	pusha  
  281193:	0c 60                	or     $0x60,%al
  281195:	0c 30                	or     $0x30,%al
  281197:	06                   	push   %es
  281198:	30 06                	xor    %al,(%esi)
  28119a:	fe                   	(bad)  
  28119b:	1f                   	pop    %ds
  28119c:	fe                   	(bad)  
  28119d:	1f                   	pop    %ds
  28119e:	30 06                	xor    %al,(%esi)
  2811a0:	38 07                	cmp    %al,(%edi)
  2811a2:	18 03                	sbb    %al,(%ebx)
  2811a4:	fe                   	(bad)  
  2811a5:	1f                   	pop    %ds
  2811a6:	fe                   	(bad)  
  2811a7:	1f                   	pop    %ds
  2811a8:	18 03                	sbb    %al,(%ebx)
  2811aa:	18 03                	sbb    %al,(%ebx)
  2811ac:	8c 01                	mov    %es,(%ecx)
  2811ae:	8c 01                	mov    %es,(%ecx)
  2811b0:	8c 01                	mov    %es,(%ecx)
  2811b2:	00 00                	add    %al,(%eax)
  2811b4:	00 00                	add    %al,(%eax)
  2811b6:	80 00 e0             	addb   $0xe0,(%eax)
  2811b9:	03 f8                	add    %eax,%edi
  2811bb:	0f 9c 0e             	setl   (%esi)
  2811be:	8c 1c 8c             	mov    %ds,(%esp,%ecx,4)
  2811c1:	18 8c 00 98 00 f8 01 	sbb    %cl,0x1f80098(%eax,%eax,1)
  2811c8:	e0 07                	loopne 2811d1 <ASCII_Table+0xdd>
  2811ca:	80 0e 80             	orb    $0x80,(%esi)
  2811cd:	1c 8c                	sbb    $0x8c,%al
  2811cf:	18 8c 18 9c 18 b8 0c 	sbb    %cl,0xcb8189c(%eax,%ebx,1)
  2811d6:	f0 0f e0 03          	lock pavgb (%ebx),%mm0
  2811da:	80 00 80             	addb   $0x80,(%eax)
	...
  2811e9:	00 0e                	add    %cl,(%esi)
  2811eb:	18 1b                	sbb    %bl,(%ebx)
  2811ed:	0c 11                	or     $0x11,%al
  2811ef:	0c 11                	or     $0x11,%al
  2811f1:	06                   	push   %es
  2811f2:	11 06                	adc    %eax,(%esi)
  2811f4:	11 03                	adc    %eax,(%ebx)
  2811f6:	11 03                	adc    %eax,(%ebx)
  2811f8:	9b                   	fwait
  2811f9:	01 8e 01 c0 38 c0    	add    %ecx,-0x3fc73fff(%esi)
  2811ff:	6c                   	insb   (%dx),%es:(%edi)
  281200:	60                   	pusha  
  281201:	44                   	inc    %esp
  281202:	60                   	pusha  
  281203:	44                   	inc    %esp
  281204:	30 44 30 44          	xor    %al,0x44(%eax,%esi,1)
  281208:	18 44 18 6c          	sbb    %al,0x6c(%eax,%ebx,1)
  28120c:	0c 38                	or     $0x38,%al
	...
  281216:	e0 01                	loopne 281219 <ASCII_Table+0x125>
  281218:	f0 03 38             	lock add (%eax),%edi
  28121b:	07                   	pop    %es
  28121c:	18 06                	sbb    %al,(%esi)
  28121e:	18 06                	sbb    %al,(%esi)
  281220:	30 03                	xor    %al,(%ebx)
  281222:	f0 01 f0             	lock add %esi,%eax
  281225:	00 f8                	add    %bh,%al
  281227:	00 9c 31 0e 33 06 1e 	add    %bl,0x1e06330e(%ecx,%esi,1)
  28122e:	06                   	push   %es
  28122f:	1c 06                	sbb    $0x6,%al
  281231:	1c 06                	sbb    $0x6,%al
  281233:	3f                   	aas    
  281234:	fc                   	cld    
  281235:	73 f0                	jae    281227 <ASCII_Table+0x133>
  281237:	21 00                	and    %eax,(%eax)
	...
  281245:	00 00                	add    %al,(%eax)
  281247:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28124a:	0c 00                	or     $0x0,%al
  28124c:	0c 00                	or     $0x0,%al
  28124e:	0c 00                	or     $0x0,%al
  281250:	0c 00                	or     $0x0,%al
  281252:	0c 00                	or     $0x0,%al
	...
  281274:	00 00                	add    %al,(%eax)
  281276:	00 02                	add    %al,(%edx)
  281278:	00 03                	add    %al,(%ebx)
  28127a:	80 01 c0             	addb   $0xc0,(%ecx)
  28127d:	00 c0                	add    %al,%al
  28127f:	00 60 00             	add    %ah,0x0(%eax)
  281282:	60                   	pusha  
  281283:	00 30                	add    %dh,(%eax)
  281285:	00 30                	add    %dh,(%eax)
  281287:	00 30                	add    %dh,(%eax)
  281289:	00 30                	add    %dh,(%eax)
  28128b:	00 30                	add    %dh,(%eax)
  28128d:	00 30                	add    %dh,(%eax)
  28128f:	00 30                	add    %dh,(%eax)
  281291:	00 30                	add    %dh,(%eax)
  281293:	00 60 00             	add    %ah,0x0(%eax)
  281296:	60                   	pusha  
  281297:	00 c0                	add    %al,%al
  281299:	00 c0                	add    %al,%al
  28129b:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  2812a1:	02 00                	add    (%eax),%al
  2812a3:	00 00                	add    %al,(%eax)
  2812a5:	00 20                	add    %ah,(%eax)
  2812a7:	00 60 00             	add    %ah,0x0(%eax)
  2812aa:	c0 00 80             	rolb   $0x80,(%eax)
  2812ad:	01 80 01 00 03 00    	add    %eax,0x30001(%eax)
  2812b3:	03 00                	add    (%eax),%eax
  2812b5:	06                   	push   %es
  2812b6:	00 06                	add    %al,(%esi)
  2812b8:	00 06                	add    %al,(%esi)
  2812ba:	00 06                	add    %al,(%esi)
  2812bc:	00 06                	add    %al,(%esi)
  2812be:	00 06                	add    %al,(%esi)
  2812c0:	00 06                	add    %al,(%esi)
  2812c2:	00 06                	add    %al,(%esi)
  2812c4:	00 03                	add    %al,(%ebx)
  2812c6:	00 03                	add    %al,(%ebx)
  2812c8:	80 01 80             	addb   $0x80,(%ecx)
  2812cb:	01 c0                	add    %eax,%eax
  2812cd:	00 60 00             	add    %ah,0x0(%eax)
  2812d0:	20 00                	and    %al,(%eax)
	...
  2812de:	00 00                	add    %al,(%eax)
  2812e0:	c0 00 c0             	rolb   $0xc0,(%eax)
  2812e3:	00 d8                	add    %bl,%al
  2812e5:	06                   	push   %es
  2812e6:	f8                   	clc    
  2812e7:	07                   	pop    %es
  2812e8:	e0 01                	loopne 2812eb <ASCII_Table+0x1f7>
  2812ea:	30 03                	xor    %al,(%ebx)
  2812ec:	38 07                	cmp    %al,(%edi)
	...
  28130e:	00 00                	add    %al,(%eax)
  281310:	80 01 80             	addb   $0x80,(%ecx)
  281313:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281319:	01 fc                	add    %edi,%esp
  28131b:	3f                   	aas    
  28131c:	fc                   	cld    
  28131d:	3f                   	aas    
  28131e:	80 01 80             	addb   $0x80,(%ecx)
  281321:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281327:	01 00                	add    %eax,(%eax)
	...
  281355:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  28135b:	01 00                	add    %eax,(%eax)
  28135d:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  28137b:	00 e0                	add    %ah,%al
  28137d:	07                   	pop    %es
  28137e:	e0 07                	loopne 281387 <ASCII_Table+0x293>
	...
  2813b4:	00 00                	add    %al,(%eax)
  2813b6:	c0 00 c0             	rolb   $0xc0,(%eax)
	...
  2813c5:	00 00                	add    %al,(%eax)
  2813c7:	0c 00                	or     $0x0,%al
  2813c9:	0c 00                	or     $0x0,%al
  2813cb:	06                   	push   %es
  2813cc:	00 06                	add    %al,(%esi)
  2813ce:	00 06                	add    %al,(%esi)
  2813d0:	00 03                	add    %al,(%ebx)
  2813d2:	00 03                	add    %al,(%ebx)
  2813d4:	00 03                	add    %al,(%ebx)
  2813d6:	80 03 80             	addb   $0x80,(%ebx)
  2813d9:	01 80 01 80 01 c0    	add    %eax,-0x3ffe7fff(%eax)
  2813df:	00 c0                	add    %al,%al
  2813e1:	00 c0                	add    %al,%al
  2813e3:	00 60 00             	add    %ah,0x0(%eax)
  2813e6:	60                   	pusha  
	...
  2813f3:	00 00                	add    %al,(%eax)
  2813f5:	00 e0                	add    %ah,%al
  2813f7:	03 f0                	add    %eax,%esi
  2813f9:	07                   	pop    %es
  2813fa:	38 0e                	cmp    %cl,(%esi)
  2813fc:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  2813ff:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281402:	0c 18                	or     $0x18,%al
  281404:	0c 18                	or     $0x18,%al
  281406:	0c 18                	or     $0x18,%al
  281408:	0c 18                	or     $0x18,%al
  28140a:	0c 18                	or     $0x18,%al
  28140c:	0c 18                	or     $0x18,%al
  28140e:	0c 18                	or     $0x18,%al
  281410:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  281413:	0e                   	push   %cs
  281414:	f0 07                	lock pop %es
  281416:	e0 03                	loopne 28141b <ASCII_Table+0x327>
	...
  281424:	00 00                	add    %al,(%eax)
  281426:	00 01                	add    %al,(%ecx)
  281428:	80 01 c0             	addb   $0xc0,(%ecx)
  28142b:	01 f0                	add    %esi,%eax
  28142d:	01 98 01 88 01 80    	add    %ebx,-0x7ffe77ff(%eax)
  281433:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281439:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28143f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281445:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  281453:	00 00                	add    %al,(%eax)
  281455:	00 e0                	add    %ah,%al
  281457:	03 f8                	add    %eax,%edi
  281459:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  28145d:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281460:	00 18                	add    %bl,(%eax)
  281462:	00 18                	add    %bl,(%eax)
  281464:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281467:	06                   	push   %es
  281468:	00 03                	add    %al,(%ebx)
  28146a:	80 01 c0             	addb   $0xc0,(%ecx)
  28146d:	00 60 00             	add    %ah,0x0(%eax)
  281470:	30 00                	xor    %al,(%eax)
  281472:	18 00                	sbb    %al,(%eax)
  281474:	fc                   	cld    
  281475:	1f                   	pop    %ds
  281476:	fc                   	cld    
  281477:	1f                   	pop    %ds
	...
  281484:	00 00                	add    %al,(%eax)
  281486:	e0 01                	loopne 281489 <ASCII_Table+0x395>
  281488:	f8                   	clc    
  281489:	07                   	pop    %es
  28148a:	18 0e                	sbb    %cl,(%esi)
  28148c:	0c 0c                	or     $0xc,%al
  28148e:	0c 0c                	or     $0xc,%al
  281490:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281493:	06                   	push   %es
  281494:	c0 03 c0             	rolb   $0xc0,(%ebx)
  281497:	07                   	pop    %es
  281498:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28149b:	18 00                	sbb    %al,(%eax)
  28149d:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2814a0:	0c 18                	or     $0x18,%al
  2814a2:	18 0c f8             	sbb    %cl,(%eax,%edi,8)
  2814a5:	07                   	pop    %es
  2814a6:	e0 03                	loopne 2814ab <ASCII_Table+0x3b7>
	...
  2814b4:	00 00                	add    %al,(%eax)
  2814b6:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2814b9:	0e                   	push   %cs
  2814ba:	00 0f                	add    %cl,(%edi)
  2814bc:	00 0f                	add    %cl,(%edi)
  2814be:	80 0d c0 0c 60 0c 60 	orb    $0x60,0xc600cc0
  2814c5:	0c 30                	or     $0x30,%al
  2814c7:	0c 18                	or     $0x18,%al
  2814c9:	0c 0c                	or     $0xc,%al
  2814cb:	0c fc                	or     $0xfc,%al
  2814cd:	3f                   	aas    
  2814ce:	fc                   	cld    
  2814cf:	3f                   	aas    
  2814d0:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2814d3:	0c 00                	or     $0x0,%al
  2814d5:	0c 00                	or     $0x0,%al
  2814d7:	0c 00                	or     $0x0,%al
	...
  2814e5:	00 f8                	add    %bh,%al
  2814e7:	0f f8 0f             	psubb  (%edi),%mm1
  2814ea:	18 00                	sbb    %al,(%eax)
  2814ec:	18 00                	sbb    %al,(%eax)
  2814ee:	0c 00                	or     $0x0,%al
  2814f0:	ec                   	in     (%dx),%al
  2814f1:	03 fc                	add    %esp,%edi
  2814f3:	07                   	pop    %es
  2814f4:	1c 0e                	sbb    $0xe,%al
  2814f6:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2814f9:	18 00                	sbb    %al,(%eax)
  2814fb:	18 00                	sbb    %al,(%eax)
  2814fd:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281500:	1c 0c                	sbb    $0xc,%al
  281502:	18 0e                	sbb    %cl,(%esi)
  281504:	f8                   	clc    
  281505:	07                   	pop    %es
  281506:	e0 03                	loopne 28150b <ASCII_Table+0x417>
	...
  281514:	00 00                	add    %al,(%eax)
  281516:	c0 07 f0             	rolb   $0xf0,(%edi)
  281519:	0f 38 1c 18          	pabsb  (%eax),%mm3
  28151d:	18 18                	sbb    %bl,(%eax)
  28151f:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281522:	cc                   	int3   
  281523:	03 ec                	add    %esp,%ebp
  281525:	0f 3c                	(bad)  
  281527:	0e                   	push   %cs
  281528:	1c 1c                	sbb    $0x1c,%al
  28152a:	0c 18                	or     $0x18,%al
  28152c:	0c 18                	or     $0x18,%al
  28152e:	0c 18                	or     $0x18,%al
  281530:	18 1c 38             	sbb    %bl,(%eax,%edi,1)
  281533:	0e                   	push   %cs
  281534:	f0 07                	lock pop %es
  281536:	e0 03                	loopne 28153b <ASCII_Table+0x447>
	...
  281544:	00 00                	add    %al,(%eax)
  281546:	fc                   	cld    
  281547:	1f                   	pop    %ds
  281548:	fc                   	cld    
  281549:	1f                   	pop    %ds
  28154a:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28154d:	06                   	push   %es
  28154e:	00 06                	add    %al,(%esi)
  281550:	00 03                	add    %al,(%ebx)
  281552:	80 03 80             	addb   $0x80,(%ebx)
  281555:	01 c0                	add    %eax,%eax
  281557:	01 c0                	add    %eax,%eax
  281559:	00 e0                	add    %ah,%al
  28155b:	00 60 00             	add    %ah,0x0(%eax)
  28155e:	60                   	pusha  
  28155f:	00 70 00             	add    %dh,0x0(%eax)
  281562:	30 00                	xor    %al,(%eax)
  281564:	30 00                	xor    %al,(%eax)
  281566:	30 00                	xor    %al,(%eax)
	...
  281574:	00 00                	add    %al,(%eax)
  281576:	e0 03                	loopne 28157b <ASCII_Table+0x487>
  281578:	f0 07                	lock pop %es
  28157a:	38 0e                	cmp    %cl,(%esi)
  28157c:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28157f:	0c 18                	or     $0x18,%al
  281581:	0c 38                	or     $0x38,%al
  281583:	06                   	push   %es
  281584:	f0 07                	lock pop %es
  281586:	f0 07                	lock pop %es
  281588:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  28158b:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28158e:	0c 18                	or     $0x18,%al
  281590:	0c 18                	or     $0x18,%al
  281592:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  281595:	0f e0 03             	pavgb  (%ebx),%mm0
	...
  2815a4:	00 00                	add    %al,(%eax)
  2815a6:	e0 03                	loopne 2815ab <ASCII_Table+0x4b7>
  2815a8:	f0 07                	lock pop %es
  2815aa:	38 0e                	cmp    %cl,(%esi)
  2815ac:	1c 0c                	sbb    $0xc,%al
  2815ae:	0c 18                	or     $0x18,%al
  2815b0:	0c 18                	or     $0x18,%al
  2815b2:	0c 18                	or     $0x18,%al
  2815b4:	1c 1c                	sbb    $0x1c,%al
  2815b6:	38 1e                	cmp    %bl,(%esi)
  2815b8:	f8                   	clc    
  2815b9:	1b e0                	sbb    %eax,%esp
  2815bb:	19 00                	sbb    %eax,(%eax)
  2815bd:	18 00                	sbb    %al,(%eax)
  2815bf:	0c 00                	or     $0x0,%al
  2815c1:	0c 1c                	or     $0x1c,%al
  2815c3:	0e                   	push   %cs
  2815c4:	f8                   	clc    
  2815c5:	07                   	pop    %es
  2815c6:	f0 01 00             	lock add %eax,(%eax)
	...
  2815dd:	00 00                	add    %al,(%eax)
  2815df:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  2815f1:	00 00                	add    %al,(%eax)
  2815f3:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  28160d:	00 00                	add    %al,(%eax)
  28160f:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281621:	00 00                	add    %al,(%eax)
  281623:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281629:	01 00                	add    %eax,(%eax)
  28162b:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281645:	10 00                	adc    %al,(%eax)
  281647:	1c 80                	sbb    $0x80,%al
  281649:	0f e0 03             	pavgb  (%ebx),%mm0
  28164c:	f8                   	clc    
  28164d:	00 18                	add    %bl,(%eax)
  28164f:	00 f8                	add    %bh,%al
  281651:	00 e0                	add    %ah,%al
  281653:	03 80 0f 00 1c 00    	add    0x1c000f(%eax),%eax
  281659:	10 00                	adc    %al,(%eax)
	...
  281673:	00 f8                	add    %bh,%al
  281675:	1f                   	pop    %ds
  281676:	00 00                	add    %al,(%eax)
  281678:	00 00                	add    %al,(%eax)
  28167a:	00 00                	add    %al,(%eax)
  28167c:	f8                   	clc    
  28167d:	1f                   	pop    %ds
	...
  2816a2:	00 00                	add    %al,(%eax)
  2816a4:	08 00                	or     %al,(%eax)
  2816a6:	38 00                	cmp    %al,(%eax)
  2816a8:	f0 01 c0             	lock add %eax,%eax
  2816ab:	07                   	pop    %es
  2816ac:	00 1f                	add    %bl,(%edi)
  2816ae:	00 18                	add    %bl,(%eax)
  2816b0:	00 1f                	add    %bl,(%edi)
  2816b2:	c0 07 f0             	rolb   $0xf0,(%edi)
  2816b5:	01 38                	add    %edi,(%eax)
  2816b7:	00 08                	add    %cl,(%eax)
	...
  2816c5:	00 e0                	add    %ah,%al
  2816c7:	03 f8                	add    %eax,%edi
  2816c9:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  2816cd:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2816d0:	00 18                	add    %bl,(%eax)
  2816d2:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2816d5:	06                   	push   %es
  2816d6:	00 03                	add    %al,(%ebx)
  2816d8:	80 01 c0             	addb   $0xc0,(%ecx)
  2816db:	00 c0                	add    %al,%al
  2816dd:	00 c0                	add    %al,%al
  2816df:	00 00                	add    %al,(%eax)
  2816e1:	00 00                	add    %al,(%eax)
  2816e3:	00 c0                	add    %al,%al
  2816e5:	00 c0                	add    %al,%al
	...
  2816f7:	00 e0                	add    %ah,%al
  2816f9:	07                   	pop    %es
  2816fa:	18 18                	sbb    %bl,(%eax)
  2816fc:	04 20                	add    $0x20,%al
  2816fe:	c2 29 22             	ret    $0x2229
  281701:	4a                   	dec    %edx
  281702:	11 44 09 44          	adc    %eax,0x44(%ecx,%ecx,1)
  281706:	09 44 09 44          	or     %eax,0x44(%ecx,%ecx,1)
  28170a:	09 22                	or     %esp,(%edx)
  28170c:	11 13                	adc    %edx,(%ebx)
  28170e:	e2 0c                	loop   28171c <ASCII_Table+0x628>
  281710:	02 40 04             	add    0x4(%eax),%al
  281713:	20 18                	and    %bl,(%eax)
  281715:	18 e0                	sbb    %ah,%al
  281717:	07                   	pop    %es
	...
  281724:	00 00                	add    %al,(%eax)
  281726:	80 03 80             	addb   $0x80,(%ebx)
  281729:	03 c0                	add    %eax,%eax
  28172b:	06                   	push   %es
  28172c:	c0 06 c0             	rolb   $0xc0,(%esi)
  28172f:	06                   	push   %es
  281730:	60                   	pusha  
  281731:	0c 60                	or     $0x60,%al
  281733:	0c 30                	or     $0x30,%al
  281735:	18 30                	sbb    %dh,(%eax)
  281737:	18 30                	sbb    %dh,(%eax)
  281739:	18 f8                	sbb    %bh,%al
  28173b:	3f                   	aas    
  28173c:	f8                   	clc    
  28173d:	3f                   	aas    
  28173e:	1c 70                	sbb    $0x70,%al
  281740:	0c 60                	or     $0x60,%al
  281742:	0c 60                	or     $0x60,%al
  281744:	06                   	push   %es
  281745:	c0 06 c0             	rolb   $0xc0,(%esi)
	...
  281754:	00 00                	add    %al,(%eax)
  281756:	fc                   	cld    
  281757:	03 fc                	add    %esp,%edi
  281759:	0f 0c                	(bad)  
  28175b:	0c 0c                	or     $0xc,%al
  28175d:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281760:	0c 18                	or     $0x18,%al
  281762:	0c 0c                	or     $0xc,%al
  281764:	fc                   	cld    
  281765:	07                   	pop    %es
  281766:	fc                   	cld    
  281767:	0f 0c                	(bad)  
  281769:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  28176c:	0c 30                	or     $0x30,%al
  28176e:	0c 30                	or     $0x30,%al
  281770:	0c 30                	or     $0x30,%al
  281772:	0c 18                	or     $0x18,%al
  281774:	fc                   	cld    
  281775:	1f                   	pop    %ds
  281776:	fc                   	cld    
  281777:	07                   	pop    %es
	...
  281784:	00 00                	add    %al,(%eax)
  281786:	c0 07 f0             	rolb   $0xf0,(%edi)
  281789:	1f                   	pop    %ds
  28178a:	38 38                	cmp    %bh,(%eax)
  28178c:	1c 30                	sbb    $0x30,%al
  28178e:	0c 70                	or     $0x70,%al
  281790:	06                   	push   %es
  281791:	60                   	pusha  
  281792:	06                   	push   %es
  281793:	00 06                	add    %al,(%esi)
  281795:	00 06                	add    %al,(%esi)
  281797:	00 06                	add    %al,(%esi)
  281799:	00 06                	add    %al,(%esi)
  28179b:	00 06                	add    %al,(%esi)
  28179d:	00 06                	add    %al,(%esi)
  28179f:	60                   	pusha  
  2817a0:	0c 70                	or     $0x70,%al
  2817a2:	1c 30                	sbb    $0x30,%al
  2817a4:	f0 1f                	lock pop %ds
  2817a6:	e0 07                	loopne 2817af <ASCII_Table+0x6bb>
	...
  2817b4:	00 00                	add    %al,(%eax)
  2817b6:	fe 03                	incb   (%ebx)
  2817b8:	fe 0f                	decb   (%edi)
  2817ba:	06                   	push   %es
  2817bb:	0e                   	push   %cs
  2817bc:	06                   	push   %es
  2817bd:	18 06                	sbb    %al,(%esi)
  2817bf:	18 06                	sbb    %al,(%esi)
  2817c1:	30 06                	xor    %al,(%esi)
  2817c3:	30 06                	xor    %al,(%esi)
  2817c5:	30 06                	xor    %al,(%esi)
  2817c7:	30 06                	xor    %al,(%esi)
  2817c9:	30 06                	xor    %al,(%esi)
  2817cb:	30 06                	xor    %al,(%esi)
  2817cd:	30 06                	xor    %al,(%esi)
  2817cf:	18 06                	sbb    %al,(%esi)
  2817d1:	18 06                	sbb    %al,(%esi)
  2817d3:	0e                   	push   %cs
  2817d4:	fe 0f                	decb   (%edi)
  2817d6:	fe 03                	incb   (%ebx)
	...
  2817e4:	00 00                	add    %al,(%eax)
  2817e6:	fc                   	cld    
  2817e7:	3f                   	aas    
  2817e8:	fc                   	cld    
  2817e9:	3f                   	aas    
  2817ea:	0c 00                	or     $0x0,%al
  2817ec:	0c 00                	or     $0x0,%al
  2817ee:	0c 00                	or     $0x0,%al
  2817f0:	0c 00                	or     $0x0,%al
  2817f2:	0c 00                	or     $0x0,%al
  2817f4:	fc                   	cld    
  2817f5:	1f                   	pop    %ds
  2817f6:	fc                   	cld    
  2817f7:	1f                   	pop    %ds
  2817f8:	0c 00                	or     $0x0,%al
  2817fa:	0c 00                	or     $0x0,%al
  2817fc:	0c 00                	or     $0x0,%al
  2817fe:	0c 00                	or     $0x0,%al
  281800:	0c 00                	or     $0x0,%al
  281802:	0c 00                	or     $0x0,%al
  281804:	fc                   	cld    
  281805:	3f                   	aas    
  281806:	fc                   	cld    
  281807:	3f                   	aas    
	...
  281814:	00 00                	add    %al,(%eax)
  281816:	f8                   	clc    
  281817:	3f                   	aas    
  281818:	f8                   	clc    
  281819:	3f                   	aas    
  28181a:	18 00                	sbb    %al,(%eax)
  28181c:	18 00                	sbb    %al,(%eax)
  28181e:	18 00                	sbb    %al,(%eax)
  281820:	18 00                	sbb    %al,(%eax)
  281822:	18 00                	sbb    %al,(%eax)
  281824:	f8                   	clc    
  281825:	1f                   	pop    %ds
  281826:	f8                   	clc    
  281827:	1f                   	pop    %ds
  281828:	18 00                	sbb    %al,(%eax)
  28182a:	18 00                	sbb    %al,(%eax)
  28182c:	18 00                	sbb    %al,(%eax)
  28182e:	18 00                	sbb    %al,(%eax)
  281830:	18 00                	sbb    %al,(%eax)
  281832:	18 00                	sbb    %al,(%eax)
  281834:	18 00                	sbb    %al,(%eax)
  281836:	18 00                	sbb    %al,(%eax)
	...
  281844:	00 00                	add    %al,(%eax)
  281846:	e0 0f                	loopne 281857 <ASCII_Table+0x763>
  281848:	f8                   	clc    
  281849:	3f                   	aas    
  28184a:	3c 78                	cmp    $0x78,%al
  28184c:	0e                   	push   %cs
  28184d:	60                   	pusha  
  28184e:	06                   	push   %es
  28184f:	e0 07                	loopne 281858 <ASCII_Table+0x764>
  281851:	c0 03 00             	rolb   $0x0,(%ebx)
  281854:	03 00                	add    (%eax),%eax
  281856:	03 fe                	add    %esi,%edi
  281858:	03 fe                	add    %esi,%edi
  28185a:	03 c0                	add    %eax,%eax
  28185c:	07                   	pop    %es
  28185d:	c0 06 c0             	rolb   $0xc0,(%esi)
  281860:	0e                   	push   %cs
  281861:	c0 3c f0 f8          	sarb   $0xf8,(%eax,%esi,8)
  281865:	3f                   	aas    
  281866:	e0 0f                	loopne 281877 <ASCII_Table+0x783>
	...
  281874:	00 00                	add    %al,(%eax)
  281876:	0c 30                	or     $0x30,%al
  281878:	0c 30                	or     $0x30,%al
  28187a:	0c 30                	or     $0x30,%al
  28187c:	0c 30                	or     $0x30,%al
  28187e:	0c 30                	or     $0x30,%al
  281880:	0c 30                	or     $0x30,%al
  281882:	0c 30                	or     $0x30,%al
  281884:	fc                   	cld    
  281885:	3f                   	aas    
  281886:	fc                   	cld    
  281887:	3f                   	aas    
  281888:	0c 30                	or     $0x30,%al
  28188a:	0c 30                	or     $0x30,%al
  28188c:	0c 30                	or     $0x30,%al
  28188e:	0c 30                	or     $0x30,%al
  281890:	0c 30                	or     $0x30,%al
  281892:	0c 30                	or     $0x30,%al
  281894:	0c 30                	or     $0x30,%al
  281896:	0c 30                	or     $0x30,%al
	...
  2818a4:	00 00                	add    %al,(%eax)
  2818a6:	80 01 80             	addb   $0x80,(%ecx)
  2818a9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818af:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818b5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818bb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818c1:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818c7:	01 00                	add    %eax,(%eax)
	...
  2818d5:	00 00                	add    %al,(%eax)
  2818d7:	06                   	push   %es
  2818d8:	00 06                	add    %al,(%esi)
  2818da:	00 06                	add    %al,(%esi)
  2818dc:	00 06                	add    %al,(%esi)
  2818de:	00 06                	add    %al,(%esi)
  2818e0:	00 06                	add    %al,(%esi)
  2818e2:	00 06                	add    %al,(%esi)
  2818e4:	00 06                	add    %al,(%esi)
  2818e6:	00 06                	add    %al,(%esi)
  2818e8:	00 06                	add    %al,(%esi)
  2818ea:	00 06                	add    %al,(%esi)
  2818ec:	00 06                	add    %al,(%esi)
  2818ee:	18 06                	sbb    %al,(%esi)
  2818f0:	18 06                	sbb    %al,(%esi)
  2818f2:	38 07                	cmp    %al,(%edi)
  2818f4:	f0 03 e0             	lock add %eax,%esp
  2818f7:	01 00                	add    %eax,(%eax)
	...
  281905:	00 06                	add    %al,(%esi)
  281907:	30 06                	xor    %al,(%esi)
  281909:	18 06                	sbb    %al,(%esi)
  28190b:	0c 06                	or     $0x6,%al
  28190d:	06                   	push   %es
  28190e:	06                   	push   %es
  28190f:	03 86 01 c6 00 66    	add    0x6600c601(%esi),%eax
  281915:	00 76 00             	add    %dh,0x0(%esi)
  281918:	de 00                	fiadd  (%eax)
  28191a:	8e 01                	mov    (%ecx),%es
  28191c:	06                   	push   %es
  28191d:	03 06                	add    (%esi),%eax
  28191f:	06                   	push   %es
  281920:	06                   	push   %es
  281921:	0c 06                	or     $0x6,%al
  281923:	18 06                	sbb    %al,(%esi)
  281925:	30 06                	xor    %al,(%esi)
  281927:	60                   	pusha  
	...
  281934:	00 00                	add    %al,(%eax)
  281936:	18 00                	sbb    %al,(%eax)
  281938:	18 00                	sbb    %al,(%eax)
  28193a:	18 00                	sbb    %al,(%eax)
  28193c:	18 00                	sbb    %al,(%eax)
  28193e:	18 00                	sbb    %al,(%eax)
  281940:	18 00                	sbb    %al,(%eax)
  281942:	18 00                	sbb    %al,(%eax)
  281944:	18 00                	sbb    %al,(%eax)
  281946:	18 00                	sbb    %al,(%eax)
  281948:	18 00                	sbb    %al,(%eax)
  28194a:	18 00                	sbb    %al,(%eax)
  28194c:	18 00                	sbb    %al,(%eax)
  28194e:	18 00                	sbb    %al,(%eax)
  281950:	18 00                	sbb    %al,(%eax)
  281952:	18 00                	sbb    %al,(%eax)
  281954:	f8                   	clc    
  281955:	1f                   	pop    %ds
  281956:	f8                   	clc    
  281957:	1f                   	pop    %ds
	...
  281964:	00 00                	add    %al,(%eax)
  281966:	0e                   	push   %cs
  281967:	e0 1e                	loopne 281987 <ASCII_Table+0x893>
  281969:	f0 1e                	lock push %ds
  28196b:	f0 1e                	lock push %ds
  28196d:	f0 36 d8 36          	lock fdivs %ss:(%esi)
  281971:	d8 36                	fdivs  (%esi)
  281973:	d8 36                	fdivs  (%esi)
  281975:	d8 66 cc             	fsubs  -0x34(%esi)
  281978:	66                   	data16
  281979:	cc                   	int3   
  28197a:	66                   	data16
  28197b:	cc                   	int3   
  28197c:	c6 c6 c6             	mov    $0xc6,%dh
  28197f:	c6 c6 c6             	mov    $0xc6,%dh
  281982:	c6 c6 86             	mov    $0x86,%dh
  281985:	c3                   	ret    
  281986:	86 c3                	xchg   %al,%bl
	...
  281994:	00 00                	add    %al,(%eax)
  281996:	0c 30                	or     $0x30,%al
  281998:	1c 30                	sbb    $0x30,%al
  28199a:	3c 30                	cmp    $0x30,%al
  28199c:	3c 30                	cmp    $0x30,%al
  28199e:	6c                   	insb   (%dx),%es:(%edi)
  28199f:	30 6c 30 cc          	xor    %ch,-0x34(%eax,%esi,1)
  2819a3:	30 cc                	xor    %cl,%ah
  2819a5:	30 8c 31 0c 33 0c 33 	xor    %cl,0x330c330c(%ecx,%esi,1)
  2819ac:	0c 36                	or     $0x36,%al
  2819ae:	0c 36                	or     $0x36,%al
  2819b0:	0c 3c                	or     $0x3c,%al
  2819b2:	0c 3c                	or     $0x3c,%al
  2819b4:	0c 38                	or     $0x38,%al
  2819b6:	0c 30                	or     $0x30,%al
	...
  2819c4:	00 00                	add    %al,(%eax)
  2819c6:	e0 07                	loopne 2819cf <ASCII_Table+0x8db>
  2819c8:	f8                   	clc    
  2819c9:	1f                   	pop    %ds
  2819ca:	1c 38                	sbb    $0x38,%al
  2819cc:	0e                   	push   %cs
  2819cd:	70 06                	jo     2819d5 <ASCII_Table+0x8e1>
  2819cf:	60                   	pusha  
  2819d0:	03 c0                	add    %eax,%eax
  2819d2:	03 c0                	add    %eax,%eax
  2819d4:	03 c0                	add    %eax,%eax
  2819d6:	03 c0                	add    %eax,%eax
  2819d8:	03 c0                	add    %eax,%eax
  2819da:	03 c0                	add    %eax,%eax
  2819dc:	03 c0                	add    %eax,%eax
  2819de:	06                   	push   %es
  2819df:	60                   	pusha  
  2819e0:	0e                   	push   %cs
  2819e1:	70 1c                	jo     2819ff <ASCII_Table+0x90b>
  2819e3:	38 f8                	cmp    %bh,%al
  2819e5:	1f                   	pop    %ds
  2819e6:	e0 07                	loopne 2819ef <ASCII_Table+0x8fb>
	...
  2819f4:	00 00                	add    %al,(%eax)
  2819f6:	fc                   	cld    
  2819f7:	0f fc 1f             	paddb  (%edi),%mm3
  2819fa:	0c 38                	or     $0x38,%al
  2819fc:	0c 30                	or     $0x30,%al
  2819fe:	0c 30                	or     $0x30,%al
  281a00:	0c 30                	or     $0x30,%al
  281a02:	0c 30                	or     $0x30,%al
  281a04:	0c 18                	or     $0x18,%al
  281a06:	fc                   	cld    
  281a07:	1f                   	pop    %ds
  281a08:	fc                   	cld    
  281a09:	07                   	pop    %es
  281a0a:	0c 00                	or     $0x0,%al
  281a0c:	0c 00                	or     $0x0,%al
  281a0e:	0c 00                	or     $0x0,%al
  281a10:	0c 00                	or     $0x0,%al
  281a12:	0c 00                	or     $0x0,%al
  281a14:	0c 00                	or     $0x0,%al
  281a16:	0c 00                	or     $0x0,%al
	...
  281a24:	00 00                	add    %al,(%eax)
  281a26:	e0 07                	loopne 281a2f <ASCII_Table+0x93b>
  281a28:	f8                   	clc    
  281a29:	1f                   	pop    %ds
  281a2a:	1c 38                	sbb    $0x38,%al
  281a2c:	0e                   	push   %cs
  281a2d:	70 06                	jo     281a35 <ASCII_Table+0x941>
  281a2f:	60                   	pusha  
  281a30:	03 e0                	add    %eax,%esp
  281a32:	03 c0                	add    %eax,%eax
  281a34:	03 c0                	add    %eax,%eax
  281a36:	03 c0                	add    %eax,%eax
  281a38:	03 c0                	add    %eax,%eax
  281a3a:	03 c0                	add    %eax,%eax
  281a3c:	07                   	pop    %es
  281a3d:	e0 06                	loopne 281a45 <ASCII_Table+0x951>
  281a3f:	63 0e                	arpl   %cx,(%esi)
  281a41:	3f                   	aas    
  281a42:	1c 3c                	sbb    $0x3c,%al
  281a44:	f8                   	clc    
  281a45:	3f                   	aas    
  281a46:	e0 f7                	loopne 281a3f <ASCII_Table+0x94b>
  281a48:	00 c0                	add    %al,%al
	...
  281a56:	fe 0f                	decb   (%edi)
  281a58:	fe                   	(bad)  
  281a59:	1f                   	pop    %ds
  281a5a:	06                   	push   %es
  281a5b:	38 06                	cmp    %al,(%esi)
  281a5d:	30 06                	xor    %al,(%esi)
  281a5f:	30 06                	xor    %al,(%esi)
  281a61:	30 06                	xor    %al,(%esi)
  281a63:	38 fe                	cmp    %bh,%dh
  281a65:	1f                   	pop    %ds
  281a66:	fe 07                	incb   (%edi)
  281a68:	06                   	push   %es
  281a69:	03 06                	add    (%esi),%eax
  281a6b:	06                   	push   %es
  281a6c:	06                   	push   %es
  281a6d:	0c 06                	or     $0x6,%al
  281a6f:	18 06                	sbb    %al,(%esi)
  281a71:	18 06                	sbb    %al,(%esi)
  281a73:	30 06                	xor    %al,(%esi)
  281a75:	30 06                	xor    %al,(%esi)
  281a77:	60                   	pusha  
	...
  281a84:	00 00                	add    %al,(%eax)
  281a86:	e0 03                	loopne 281a8b <ASCII_Table+0x997>
  281a88:	f8                   	clc    
  281a89:	0f 1c 0c 0c          	nopl   (%esp,%ecx,1)
  281a8d:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281a90:	0c 00                	or     $0x0,%al
  281a92:	1c 00                	sbb    $0x0,%al
  281a94:	f8                   	clc    
  281a95:	03 e0                	add    %eax,%esp
  281a97:	0f 00 1e             	ltr    (%esi)
  281a9a:	00 38                	add    %bh,(%eax)
  281a9c:	06                   	push   %es
  281a9d:	30 06                	xor    %al,(%esi)
  281a9f:	30 0e                	xor    %cl,(%esi)
  281aa1:	30 1c 1c             	xor    %bl,(%esp,%ebx,1)
  281aa4:	f8                   	clc    
  281aa5:	0f e0 07             	pavgb  (%edi),%mm0
	...
  281ab4:	00 00                	add    %al,(%eax)
  281ab6:	fe                   	(bad)  
  281ab7:	7f fe                	jg     281ab7 <ASCII_Table+0x9c3>
  281ab9:	7f 80                	jg     281a3b <ASCII_Table+0x947>
  281abb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281ac1:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281ac7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281acd:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281ad3:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
	...
  281ae5:	00 0c 30             	add    %cl,(%eax,%esi,1)
  281ae8:	0c 30                	or     $0x30,%al
  281aea:	0c 30                	or     $0x30,%al
  281aec:	0c 30                	or     $0x30,%al
  281aee:	0c 30                	or     $0x30,%al
  281af0:	0c 30                	or     $0x30,%al
  281af2:	0c 30                	or     $0x30,%al
  281af4:	0c 30                	or     $0x30,%al
  281af6:	0c 30                	or     $0x30,%al
  281af8:	0c 30                	or     $0x30,%al
  281afa:	0c 30                	or     $0x30,%al
  281afc:	0c 30                	or     $0x30,%al
  281afe:	0c 30                	or     $0x30,%al
  281b00:	0c 30                	or     $0x30,%al
  281b02:	18 18                	sbb    %bl,(%eax)
  281b04:	f8                   	clc    
  281b05:	1f                   	pop    %ds
  281b06:	e0 07                	loopne 281b0f <ASCII_Table+0xa1b>
	...
  281b14:	00 00                	add    %al,(%eax)
  281b16:	03 60 06             	add    0x6(%eax),%esp
  281b19:	30 06                	xor    %al,(%esi)
  281b1b:	30 06                	xor    %al,(%esi)
  281b1d:	30 0c 18             	xor    %cl,(%eax,%ebx,1)
  281b20:	0c 18                	or     $0x18,%al
  281b22:	0c 18                	or     $0x18,%al
  281b24:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281b27:	0c 38                	or     $0x38,%al
  281b29:	0e                   	push   %cs
  281b2a:	30 06                	xor    %al,(%esi)
  281b2c:	30 06                	xor    %al,(%esi)
  281b2e:	70 07                	jo     281b37 <ASCII_Table+0xa43>
  281b30:	60                   	pusha  
  281b31:	03 60 03             	add    0x3(%eax),%esp
  281b34:	c0 01 c0             	rolb   $0xc0,(%ecx)
  281b37:	01 00                	add    %eax,(%eax)
	...
  281b45:	00 03                	add    %al,(%ebx)
  281b47:	60                   	pusha  
  281b48:	c3                   	ret    
  281b49:	61                   	popa   
  281b4a:	c3                   	ret    
  281b4b:	61                   	popa   
  281b4c:	c3                   	ret    
  281b4d:	61                   	popa   
  281b4e:	66 33 66 33          	xor    0x33(%esi),%sp
  281b52:	66 33 66 33          	xor    0x33(%esi),%sp
  281b56:	66 33 66 33          	xor    0x33(%esi),%sp
  281b5a:	6c                   	insb   (%dx),%es:(%edi)
  281b5b:	1b 6c 1b 6c          	sbb    0x6c(%ebx,%ebx,1),%ebp
  281b5f:	1b 2c 1a             	sbb    (%edx,%ebx,1),%ebp
  281b62:	3c 1e                	cmp    $0x1e,%al
  281b64:	38 0e                	cmp    %cl,(%esi)
  281b66:	38 0e                	cmp    %cl,(%esi)
	...
  281b74:	00 00                	add    %al,(%eax)
  281b76:	0f e0 0c 70          	pavgb  (%eax,%esi,2),%mm1
  281b7a:	18 30                	sbb    %dh,(%eax)
  281b7c:	30 18                	xor    %bl,(%eax)
  281b7e:	70 0c                	jo     281b8c <ASCII_Table+0xa98>
  281b80:	60                   	pusha  
  281b81:	0e                   	push   %cs
  281b82:	c0 07 80             	rolb   $0x80,(%edi)
  281b85:	03 80 03 c0 03 e0    	add    -0x1ffc3ffd(%eax),%eax
  281b8b:	06                   	push   %es
  281b8c:	70 0c                	jo     281b9a <ASCII_Table+0xaa6>
  281b8e:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  281b91:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  281b94:	0e                   	push   %cs
  281b95:	60                   	pusha  
  281b96:	07                   	pop    %es
  281b97:	e0 00                	loopne 281b99 <ASCII_Table+0xaa5>
	...
  281ba5:	00 03                	add    %al,(%ebx)
  281ba7:	c0 06 60             	rolb   $0x60,(%esi)
  281baa:	0c 30                	or     $0x30,%al
  281bac:	1c 38                	sbb    $0x38,%al
  281bae:	38 18                	cmp    %bl,(%eax)
  281bb0:	30 0c 60             	xor    %cl,(%eax,%eiz,2)
  281bb3:	06                   	push   %es
  281bb4:	e0 07                	loopne 281bbd <ASCII_Table+0xac9>
  281bb6:	c0 03 80             	rolb   $0x80,(%ebx)
  281bb9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281bbf:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281bc5:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  281bd3:	00 00                	add    %al,(%eax)
  281bd5:	00 fc                	add    %bh,%ah
  281bd7:	7f fc                	jg     281bd5 <ASCII_Table+0xae1>
  281bd9:	7f 00                	jg     281bdb <ASCII_Table+0xae7>
  281bdb:	60                   	pusha  
  281bdc:	00 30                	add    %dh,(%eax)
  281bde:	00 18                	add    %bl,(%eax)
  281be0:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281be3:	06                   	push   %es
  281be4:	00 03                	add    %al,(%ebx)
  281be6:	80 01 c0             	addb   $0xc0,(%ecx)
  281be9:	00 60 00             	add    %ah,0x0(%eax)
  281bec:	30 00                	xor    %al,(%eax)
  281bee:	18 00                	sbb    %al,(%eax)
  281bf0:	0c 00                	or     $0x0,%al
  281bf2:	06                   	push   %es
  281bf3:	00 fe                	add    %bh,%dh
  281bf5:	7f fe                	jg     281bf5 <ASCII_Table+0xb01>
  281bf7:	7f 00                	jg     281bf9 <ASCII_Table+0xb05>
	...
  281c05:	00 e0                	add    %ah,%al
  281c07:	03 e0                	add    %eax,%esp
  281c09:	03 60 00             	add    0x0(%eax),%esp
  281c0c:	60                   	pusha  
  281c0d:	00 60 00             	add    %ah,0x0(%eax)
  281c10:	60                   	pusha  
  281c11:	00 60 00             	add    %ah,0x0(%eax)
  281c14:	60                   	pusha  
  281c15:	00 60 00             	add    %ah,0x0(%eax)
  281c18:	60                   	pusha  
  281c19:	00 60 00             	add    %ah,0x0(%eax)
  281c1c:	60                   	pusha  
  281c1d:	00 60 00             	add    %ah,0x0(%eax)
  281c20:	60                   	pusha  
  281c21:	00 60 00             	add    %ah,0x0(%eax)
  281c24:	60                   	pusha  
  281c25:	00 60 00             	add    %ah,0x0(%eax)
  281c28:	60                   	pusha  
  281c29:	00 60 00             	add    %ah,0x0(%eax)
  281c2c:	60                   	pusha  
  281c2d:	00 e0                	add    %ah,%al
  281c2f:	03 e0                	add    %eax,%esp
  281c31:	03 00                	add    (%eax),%eax
  281c33:	00 00                	add    %al,(%eax)
  281c35:	00 30                	add    %dh,(%eax)
  281c37:	00 30                	add    %dh,(%eax)
  281c39:	00 60 00             	add    %ah,0x0(%eax)
  281c3c:	60                   	pusha  
  281c3d:	00 60 00             	add    %ah,0x0(%eax)
  281c40:	c0 00 c0             	rolb   $0xc0,(%eax)
  281c43:	00 c0                	add    %al,%al
  281c45:	00 c0                	add    %al,%al
  281c47:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281c4d:	01 00                	add    %eax,(%eax)
  281c4f:	03 00                	add    (%eax),%eax
  281c51:	03 00                	add    (%eax),%eax
  281c53:	03 00                	add    (%eax),%eax
  281c55:	06                   	push   %es
  281c56:	00 06                	add    %al,(%esi)
	...
  281c64:	00 00                	add    %al,(%eax)
  281c66:	e0 03                	loopne 281c6b <ASCII_Table+0xb77>
  281c68:	e0 03                	loopne 281c6d <ASCII_Table+0xb79>
  281c6a:	00 03                	add    %al,(%ebx)
  281c6c:	00 03                	add    %al,(%ebx)
  281c6e:	00 03                	add    %al,(%ebx)
  281c70:	00 03                	add    %al,(%ebx)
  281c72:	00 03                	add    %al,(%ebx)
  281c74:	00 03                	add    %al,(%ebx)
  281c76:	00 03                	add    %al,(%ebx)
  281c78:	00 03                	add    %al,(%ebx)
  281c7a:	00 03                	add    %al,(%ebx)
  281c7c:	00 03                	add    %al,(%ebx)
  281c7e:	00 03                	add    %al,(%ebx)
  281c80:	00 03                	add    %al,(%ebx)
  281c82:	00 03                	add    %al,(%ebx)
  281c84:	00 03                	add    %al,(%ebx)
  281c86:	00 03                	add    %al,(%ebx)
  281c88:	00 03                	add    %al,(%ebx)
  281c8a:	00 03                	add    %al,(%ebx)
  281c8c:	00 03                	add    %al,(%ebx)
  281c8e:	e0 03                	loopne 281c93 <ASCII_Table+0xb9f>
  281c90:	e0 03                	loopne 281c95 <ASCII_Table+0xba1>
  281c92:	00 00                	add    %al,(%eax)
  281c94:	00 00                	add    %al,(%eax)
  281c96:	00 00                	add    %al,(%eax)
  281c98:	c0 01 c0             	rolb   $0xc0,(%ecx)
  281c9b:	01 60 03             	add    %esp,0x3(%eax)
  281c9e:	60                   	pusha  
  281c9f:	03 60 03             	add    0x3(%eax),%esp
  281ca2:	30 06                	xor    %al,(%esi)
  281ca4:	30 06                	xor    %al,(%esi)
  281ca6:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281ca9:	0c 00                	or     $0x0,%al
	...
  281ce3:	00 00                	add    %al,(%eax)
  281ce5:	00 ff                	add    %bh,%bh
  281ce7:	ff                   	(bad)  
  281ce8:	ff                   	(bad)  
  281ce9:	ff 00                	incl   (%eax)
	...
  281cf3:	00 00                	add    %al,(%eax)
  281cf5:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281cf8:	0c 00                	or     $0x0,%al
  281cfa:	0c 00                	or     $0x0,%al
  281cfc:	0c 00                	or     $0x0,%al
  281cfe:	0c 00                	or     $0x0,%al
  281d00:	0c 00                	or     $0x0,%al
	...
  281d2e:	00 00                	add    %al,(%eax)
  281d30:	f0 03 f8             	lock add %eax,%edi
  281d33:	07                   	pop    %es
  281d34:	1c 0c                	sbb    $0xc,%al
  281d36:	0c 0c                	or     $0xc,%al
  281d38:	00 0f                	add    %cl,(%edi)
  281d3a:	f0 0f f8 0c 0c       	lock psubb (%esp,%ecx,1),%mm1
  281d3f:	0c 0c                	or     $0xc,%al
  281d41:	0c 1c                	or     $0x1c,%al
  281d43:	0f f8 0f             	psubb  (%edi),%mm1
  281d46:	f0 18 00             	lock sbb %al,(%eax)
	...
  281d55:	00 18                	add    %bl,(%eax)
  281d57:	00 18                	add    %bl,(%eax)
  281d59:	00 18                	add    %bl,(%eax)
  281d5b:	00 18                	add    %bl,(%eax)
  281d5d:	00 18                	add    %bl,(%eax)
  281d5f:	00 d8                	add    %bl,%al
  281d61:	03 f8                	add    %eax,%edi
  281d63:	0f 38 0c             	(bad)  
  281d66:	18 18                	sbb    %bl,(%eax)
  281d68:	18 18                	sbb    %bl,(%eax)
  281d6a:	18 18                	sbb    %bl,(%eax)
  281d6c:	18 18                	sbb    %bl,(%eax)
  281d6e:	18 18                	sbb    %bl,(%eax)
  281d70:	18 18                	sbb    %bl,(%eax)
  281d72:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  281d75:	0f d8 03             	psubusb (%ebx),%mm0
	...
  281d90:	c0 03 f0             	rolb   $0xf0,(%ebx)
  281d93:	07                   	pop    %es
  281d94:	30 0e                	xor    %cl,(%esi)
  281d96:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281d99:	00 18                	add    %bl,(%eax)
  281d9b:	00 18                	add    %bl,(%eax)
  281d9d:	00 18                	add    %bl,(%eax)
  281d9f:	00 18                	add    %bl,(%eax)
  281da1:	0c 30                	or     $0x30,%al
  281da3:	0e                   	push   %cs
  281da4:	f0 07                	lock pop %es
  281da6:	c0 03 00             	rolb   $0x0,(%ebx)
	...
  281db5:	00 00                	add    %al,(%eax)
  281db7:	18 00                	sbb    %al,(%eax)
  281db9:	18 00                	sbb    %al,(%eax)
  281dbb:	18 00                	sbb    %al,(%eax)
  281dbd:	18 00                	sbb    %al,(%eax)
  281dbf:	18 c0                	sbb    %al,%al
  281dc1:	1b f0                	sbb    %eax,%esi
  281dc3:	1f                   	pop    %ds
  281dc4:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  281dc7:	18 18                	sbb    %bl,(%eax)
  281dc9:	18 18                	sbb    %bl,(%eax)
  281dcb:	18 18                	sbb    %bl,(%eax)
  281dcd:	18 18                	sbb    %bl,(%eax)
  281dcf:	18 18                	sbb    %bl,(%eax)
  281dd1:	18 30                	sbb    %dh,(%eax)
  281dd3:	1c f0                	sbb    $0xf0,%al
  281dd5:	1f                   	pop    %ds
  281dd6:	c0 1b 00             	rcrb   $0x0,(%ebx)
	...
  281ded:	00 00                	add    %al,(%eax)
  281def:	00 c0                	add    %al,%al
  281df1:	03 f0                	add    %eax,%esi
  281df3:	0f 30                	wrmsr  
  281df5:	0c 18                	or     $0x18,%al
  281df7:	18 f8                	sbb    %bh,%al
  281df9:	1f                   	pop    %ds
  281dfa:	f8                   	clc    
  281dfb:	1f                   	pop    %ds
  281dfc:	18 00                	sbb    %al,(%eax)
  281dfe:	18 00                	sbb    %al,(%eax)
  281e00:	38 18                	cmp    %bl,(%eax)
  281e02:	30 1c f0             	xor    %bl,(%eax,%esi,8)
  281e05:	0f c0 07             	xadd   %al,(%edi)
	...
  281e14:	00 00                	add    %al,(%eax)
  281e16:	80 0f c0             	orb    $0xc0,(%edi)
  281e19:	0f c0 00             	xadd   %al,(%eax)
  281e1c:	c0 00 c0             	rolb   $0xc0,(%eax)
  281e1f:	00 f0                	add    %dh,%al
  281e21:	07                   	pop    %es
  281e22:	f0 07                	lock pop %es
  281e24:	c0 00 c0             	rolb   $0xc0,(%eax)
  281e27:	00 c0                	add    %al,%al
  281e29:	00 c0                	add    %al,%al
  281e2b:	00 c0                	add    %al,%al
  281e2d:	00 c0                	add    %al,%al
  281e2f:	00 c0                	add    %al,%al
  281e31:	00 c0                	add    %al,%al
  281e33:	00 c0                	add    %al,%al
  281e35:	00 c0                	add    %al,%al
	...
  281e4f:	00 e0                	add    %ah,%al
  281e51:	0d f8 0f 18 0e       	or     $0xe180ff8,%eax
  281e56:	0c 0c                	or     $0xc,%al
  281e58:	0c 0c                	or     $0xc,%al
  281e5a:	0c 0c                	or     $0xc,%al
  281e5c:	0c 0c                	or     $0xc,%al
  281e5e:	0c 0c                	or     $0xc,%al
  281e60:	0c 0c                	or     $0xc,%al
  281e62:	18 0e                	sbb    %cl,(%esi)
  281e64:	f8                   	clc    
  281e65:	0f e0 0d 00 0c 0c 0c 	pavgb  0xc0c0c00,%mm1
  281e6c:	1c 06                	sbb    $0x6,%al
  281e6e:	f8                   	clc    
  281e6f:	07                   	pop    %es
  281e70:	f0 01 00             	lock add %eax,(%eax)
  281e73:	00 00                	add    %al,(%eax)
  281e75:	00 18                	add    %bl,(%eax)
  281e77:	00 18                	add    %bl,(%eax)
  281e79:	00 18                	add    %bl,(%eax)
  281e7b:	00 18                	add    %bl,(%eax)
  281e7d:	00 18                	add    %bl,(%eax)
  281e7f:	00 d8                	add    %bl,%al
  281e81:	07                   	pop    %es
  281e82:	f8                   	clc    
  281e83:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281e87:	18 18                	sbb    %bl,(%eax)
  281e89:	18 18                	sbb    %bl,(%eax)
  281e8b:	18 18                	sbb    %bl,(%eax)
  281e8d:	18 18                	sbb    %bl,(%eax)
  281e8f:	18 18                	sbb    %bl,(%eax)
  281e91:	18 18                	sbb    %bl,(%eax)
  281e93:	18 18                	sbb    %bl,(%eax)
  281e95:	18 18                	sbb    %bl,(%eax)
  281e97:	18 00                	sbb    %al,(%eax)
	...
  281ea5:	00 c0                	add    %al,%al
  281ea7:	00 c0                	add    %al,%al
  281ea9:	00 00                	add    %al,(%eax)
  281eab:	00 00                	add    %al,(%eax)
  281ead:	00 00                	add    %al,(%eax)
  281eaf:	00 c0                	add    %al,%al
  281eb1:	00 c0                	add    %al,%al
  281eb3:	00 c0                	add    %al,%al
  281eb5:	00 c0                	add    %al,%al
  281eb7:	00 c0                	add    %al,%al
  281eb9:	00 c0                	add    %al,%al
  281ebb:	00 c0                	add    %al,%al
  281ebd:	00 c0                	add    %al,%al
  281ebf:	00 c0                	add    %al,%al
  281ec1:	00 c0                	add    %al,%al
  281ec3:	00 c0                	add    %al,%al
  281ec5:	00 c0                	add    %al,%al
	...
  281ed3:	00 00                	add    %al,(%eax)
  281ed5:	00 c0                	add    %al,%al
  281ed7:	00 c0                	add    %al,%al
  281ed9:	00 00                	add    %al,(%eax)
  281edb:	00 00                	add    %al,(%eax)
  281edd:	00 00                	add    %al,(%eax)
  281edf:	00 c0                	add    %al,%al
  281ee1:	00 c0                	add    %al,%al
  281ee3:	00 c0                	add    %al,%al
  281ee5:	00 c0                	add    %al,%al
  281ee7:	00 c0                	add    %al,%al
  281ee9:	00 c0                	add    %al,%al
  281eeb:	00 c0                	add    %al,%al
  281eed:	00 c0                	add    %al,%al
  281eef:	00 c0                	add    %al,%al
  281ef1:	00 c0                	add    %al,%al
  281ef3:	00 c0                	add    %al,%al
  281ef5:	00 c0                	add    %al,%al
  281ef7:	00 c0                	add    %al,%al
  281ef9:	00 c0                	add    %al,%al
  281efb:	00 c0                	add    %al,%al
  281efd:	00 f8                	add    %bh,%al
  281eff:	00 78 00             	add    %bh,0x0(%eax)
  281f02:	00 00                	add    %al,(%eax)
  281f04:	00 00                	add    %al,(%eax)
  281f06:	0c 00                	or     $0x0,%al
  281f08:	0c 00                	or     $0x0,%al
  281f0a:	0c 00                	or     $0x0,%al
  281f0c:	0c 00                	or     $0x0,%al
  281f0e:	0c 00                	or     $0x0,%al
  281f10:	0c 0c                	or     $0xc,%al
  281f12:	0c 06                	or     $0x6,%al
  281f14:	0c 03                	or     $0x3,%al
  281f16:	8c 01                	mov    %es,(%ecx)
  281f18:	cc                   	int3   
  281f19:	00 6c 00 fc          	add    %ch,-0x4(%eax,%eax,1)
  281f1d:	00 9c 01 8c 03 0c 03 	add    %bl,0x30c038c(%ecx,%eax,1)
  281f24:	0c 06                	or     $0x6,%al
  281f26:	0c 0c                	or     $0xc,%al
	...
  281f34:	00 00                	add    %al,(%eax)
  281f36:	c0 00 c0             	rolb   $0xc0,(%eax)
  281f39:	00 c0                	add    %al,%al
  281f3b:	00 c0                	add    %al,%al
  281f3d:	00 c0                	add    %al,%al
  281f3f:	00 c0                	add    %al,%al
  281f41:	00 c0                	add    %al,%al
  281f43:	00 c0                	add    %al,%al
  281f45:	00 c0                	add    %al,%al
  281f47:	00 c0                	add    %al,%al
  281f49:	00 c0                	add    %al,%al
  281f4b:	00 c0                	add    %al,%al
  281f4d:	00 c0                	add    %al,%al
  281f4f:	00 c0                	add    %al,%al
  281f51:	00 c0                	add    %al,%al
  281f53:	00 c0                	add    %al,%al
  281f55:	00 c0                	add    %al,%al
	...
  281f6f:	00 7c 3c ff          	add    %bh,-0x1(%esp,%edi,1)
  281f73:	7e c7                	jle    281f3c <ASCII_Table+0xe48>
  281f75:	e3 83                	jecxz  281efa <ASCII_Table+0xe06>
  281f77:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
  281f7e:	83 c1 83             	add    $0xffffff83,%ecx
  281f81:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
	...
  281fa0:	98                   	cwtl   
  281fa1:	07                   	pop    %es
  281fa2:	f8                   	clc    
  281fa3:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281fa7:	18 18                	sbb    %bl,(%eax)
  281fa9:	18 18                	sbb    %bl,(%eax)
  281fab:	18 18                	sbb    %bl,(%eax)
  281fad:	18 18                	sbb    %bl,(%eax)
  281faf:	18 18                	sbb    %bl,(%eax)
  281fb1:	18 18                	sbb    %bl,(%eax)
  281fb3:	18 18                	sbb    %bl,(%eax)
  281fb5:	18 18                	sbb    %bl,(%eax)
  281fb7:	18 00                	sbb    %al,(%eax)
	...
  281fcd:	00 00                	add    %al,(%eax)
  281fcf:	00 c0                	add    %al,%al
  281fd1:	03 f0                	add    %eax,%esi
  281fd3:	0f 30                	wrmsr  
  281fd5:	0c 18                	or     $0x18,%al
  281fd7:	18 18                	sbb    %bl,(%eax)
  281fd9:	18 18                	sbb    %bl,(%eax)
  281fdb:	18 18                	sbb    %bl,(%eax)
  281fdd:	18 18                	sbb    %bl,(%eax)
  281fdf:	18 18                	sbb    %bl,(%eax)
  281fe1:	18 30                	sbb    %dh,(%eax)
  281fe3:	0c f0                	or     $0xf0,%al
  281fe5:	0f c0 03             	xadd   %al,(%ebx)
	...
  282000:	d8 03                	fadds  (%ebx)
  282002:	f8                   	clc    
  282003:	0f 38 0c             	(bad)  
  282006:	18 18                	sbb    %bl,(%eax)
  282008:	18 18                	sbb    %bl,(%eax)
  28200a:	18 18                	sbb    %bl,(%eax)
  28200c:	18 18                	sbb    %bl,(%eax)
  28200e:	18 18                	sbb    %bl,(%eax)
  282010:	18 18                	sbb    %bl,(%eax)
  282012:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  282015:	0f d8 03             	psubusb (%ebx),%mm0
  282018:	18 00                	sbb    %al,(%eax)
  28201a:	18 00                	sbb    %al,(%eax)
  28201c:	18 00                	sbb    %al,(%eax)
  28201e:	18 00                	sbb    %al,(%eax)
  282020:	18 00                	sbb    %al,(%eax)
	...
  28202e:	00 00                	add    %al,(%eax)
  282030:	c0 1b f0             	rcrb   $0xf0,(%ebx)
  282033:	1f                   	pop    %ds
  282034:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282037:	18 18                	sbb    %bl,(%eax)
  282039:	18 18                	sbb    %bl,(%eax)
  28203b:	18 18                	sbb    %bl,(%eax)
  28203d:	18 18                	sbb    %bl,(%eax)
  28203f:	18 18                	sbb    %bl,(%eax)
  282041:	18 30                	sbb    %dh,(%eax)
  282043:	1c f0                	sbb    $0xf0,%al
  282045:	1f                   	pop    %ds
  282046:	c0 1b 00             	rcrb   $0x0,(%ebx)
  282049:	18 00                	sbb    %al,(%eax)
  28204b:	18 00                	sbb    %al,(%eax)
  28204d:	18 00                	sbb    %al,(%eax)
  28204f:	18 00                	sbb    %al,(%eax)
  282051:	18 00                	sbb    %al,(%eax)
	...
  28205f:	00 b0 07 f0 03 70    	add    %dh,0x7003f007(%eax)
  282065:	00 30                	add    %dh,(%eax)
  282067:	00 30                	add    %dh,(%eax)
  282069:	00 30                	add    %dh,(%eax)
  28206b:	00 30                	add    %dh,(%eax)
  28206d:	00 30                	add    %dh,(%eax)
  28206f:	00 30                	add    %dh,(%eax)
  282071:	00 30                	add    %dh,(%eax)
  282073:	00 30                	add    %dh,(%eax)
  282075:	00 30                	add    %dh,(%eax)
	...
  28208f:	00 e0                	add    %ah,%al
  282091:	03 f0                	add    %eax,%esi
  282093:	03 38                	add    (%eax),%edi
  282095:	0e                   	push   %cs
  282096:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  282099:	00 f0                	add    %dh,%al
  28209b:	03 c0                	add    %eax,%eax
  28209d:	07                   	pop    %es
  28209e:	00 0c 18             	add    %cl,(%eax,%ebx,1)
  2820a1:	0c 38                	or     $0x38,%al
  2820a3:	0e                   	push   %cs
  2820a4:	f0 07                	lock pop %es
  2820a6:	e0 03                	loopne 2820ab <ASCII_Table+0xfb7>
	...
  2820b8:	80 00 c0             	addb   $0xc0,(%eax)
  2820bb:	00 c0                	add    %al,%al
  2820bd:	00 c0                	add    %al,%al
  2820bf:	00 f0                	add    %dh,%al
  2820c1:	07                   	pop    %es
  2820c2:	f0 07                	lock pop %es
  2820c4:	c0 00 c0             	rolb   $0xc0,(%eax)
  2820c7:	00 c0                	add    %al,%al
  2820c9:	00 c0                	add    %al,%al
  2820cb:	00 c0                	add    %al,%al
  2820cd:	00 c0                	add    %al,%al
  2820cf:	00 c0                	add    %al,%al
  2820d1:	00 c0                	add    %al,%al
  2820d3:	00 c0                	add    %al,%al
  2820d5:	07                   	pop    %es
  2820d6:	80 07 00             	addb   $0x0,(%edi)
	...
  2820ed:	00 00                	add    %al,(%eax)
  2820ef:	00 18                	add    %bl,(%eax)
  2820f1:	18 18                	sbb    %bl,(%eax)
  2820f3:	18 18                	sbb    %bl,(%eax)
  2820f5:	18 18                	sbb    %bl,(%eax)
  2820f7:	18 18                	sbb    %bl,(%eax)
  2820f9:	18 18                	sbb    %bl,(%eax)
  2820fb:	18 18                	sbb    %bl,(%eax)
  2820fd:	18 18                	sbb    %bl,(%eax)
  2820ff:	18 18                	sbb    %bl,(%eax)
  282101:	18 38                	sbb    %bh,(%eax)
  282103:	1c f0                	sbb    $0xf0,%al
  282105:	1f                   	pop    %ds
  282106:	e0 19                	loopne 282121 <ASCII_Table+0x102d>
	...
  282120:	0c 18                	or     $0x18,%al
  282122:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282125:	0c 18                	or     $0x18,%al
  282127:	0c 30                	or     $0x30,%al
  282129:	06                   	push   %es
  28212a:	30 06                	xor    %al,(%esi)
  28212c:	30 06                	xor    %al,(%esi)
  28212e:	60                   	pusha  
  28212f:	03 60 03             	add    0x3(%eax),%esp
  282132:	60                   	pusha  
  282133:	03 c0                	add    %eax,%eax
  282135:	01 c0                	add    %eax,%eax
  282137:	01 00                	add    %eax,(%eax)
	...
  28214d:	00 00                	add    %al,(%eax)
  28214f:	00 c1                	add    %al,%cl
  282151:	41                   	inc    %ecx
  282152:	c1 41 c3 61          	roll   $0x61,-0x3d(%ecx)
  282156:	63 63 63             	arpl   %sp,0x63(%ebx)
  282159:	63 63 63             	arpl   %sp,0x63(%ebx)
  28215c:	36                   	ss
  28215d:	36                   	ss
  28215e:	36                   	ss
  28215f:	36                   	ss
  282160:	36                   	ss
  282161:	36                   	ss
  282162:	1c 1c                	sbb    $0x1c,%al
  282164:	1c 1c                	sbb    $0x1c,%al
  282166:	1c 1c                	sbb    $0x1c,%al
	...
  282180:	1c 38                	sbb    $0x38,%al
  282182:	38 1c 30             	cmp    %bl,(%eax,%esi,1)
  282185:	0c 60                	or     $0x60,%al
  282187:	06                   	push   %es
  282188:	60                   	pusha  
  282189:	03 60 03             	add    0x3(%eax),%esp
  28218c:	60                   	pusha  
  28218d:	03 60 03             	add    0x3(%eax),%esp
  282190:	60                   	pusha  
  282191:	06                   	push   %es
  282192:	30 0c 38             	xor    %cl,(%eax,%edi,1)
  282195:	1c 1c                	sbb    $0x1c,%al
  282197:	38 00                	cmp    %al,(%eax)
	...
  2821ad:	00 00                	add    %al,(%eax)
  2821af:	00 18                	add    %bl,(%eax)
  2821b1:	30 30                	xor    %dh,(%eax)
  2821b3:	18 30                	sbb    %dh,(%eax)
  2821b5:	18 70 18             	sbb    %dh,0x18(%eax)
  2821b8:	60                   	pusha  
  2821b9:	0c 60                	or     $0x60,%al
  2821bb:	0c e0                	or     $0xe0,%al
  2821bd:	0c c0                	or     $0xc0,%al
  2821bf:	06                   	push   %es
  2821c0:	c0 06 80             	rolb   $0x80,(%esi)
  2821c3:	03 80 03 80 03 80    	add    -0x7ffc7ffd(%eax),%eax
  2821c9:	01 80 01 c0 01 f0    	add    %eax,-0xffe3fff(%eax)
  2821cf:	00 70 00             	add    %dh,0x0(%eax)
	...
  2821de:	00 00                	add    %al,(%eax)
  2821e0:	fc                   	cld    
  2821e1:	1f                   	pop    %ds
  2821e2:	fc                   	cld    
  2821e3:	1f                   	pop    %ds
  2821e4:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2821e7:	06                   	push   %es
  2821e8:	00 03                	add    %al,(%ebx)
  2821ea:	80 01 c0             	addb   $0xc0,(%ecx)
  2821ed:	00 60 00             	add    %ah,0x0(%eax)
  2821f0:	30 00                	xor    %al,(%eax)
  2821f2:	18 00                	sbb    %al,(%eax)
  2821f4:	fc                   	cld    
  2821f5:	1f                   	pop    %ds
  2821f6:	fc                   	cld    
  2821f7:	1f                   	pop    %ds
	...
  282204:	00 00                	add    %al,(%eax)
  282206:	00 03                	add    %al,(%ebx)
  282208:	80 01 c0             	addb   $0xc0,(%ecx)
  28220b:	00 c0                	add    %al,%al
  28220d:	00 c0                	add    %al,%al
  28220f:	00 c0                	add    %al,%al
  282211:	00 c0                	add    %al,%al
  282213:	00 c0                	add    %al,%al
  282215:	00 60 00             	add    %ah,0x0(%eax)
  282218:	60                   	pusha  
  282219:	00 30                	add    %dh,(%eax)
  28221b:	00 60 00             	add    %ah,0x0(%eax)
  28221e:	40                   	inc    %eax
  28221f:	00 c0                	add    %al,%al
  282221:	00 c0                	add    %al,%al
  282223:	00 c0                	add    %al,%al
  282225:	00 c0                	add    %al,%al
  282227:	00 c0                	add    %al,%al
  282229:	00 c0                	add    %al,%al
  28222b:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  282231:	00 00                	add    %al,(%eax)
  282233:	00 00                	add    %al,(%eax)
  282235:	00 80 01 80 01 80    	add    %al,-0x7ffe7fff(%eax)
  28223b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282241:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282247:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28224d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282253:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282259:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28225f:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
  282265:	00 60 00             	add    %ah,0x0(%eax)
  282268:	c0 00 c0             	rolb   $0xc0,(%eax)
  28226b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282271:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  282277:	03 00                	add    (%eax),%eax
  282279:	03 00                	add    (%eax),%eax
  28227b:	06                   	push   %es
  28227c:	00 03                	add    %al,(%ebx)
  28227e:	00 01                	add    %al,(%ecx)
  282280:	80 01 80             	addb   $0x80,(%ecx)
  282283:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282289:	01 80 01 c0 00 60    	add    %eax,0x6000c001(%eax)
	...
  2822a3:	00 f0                	add    %dh,%al
  2822a5:	10 f8                	adc    %bh,%al
  2822a7:	1f                   	pop    %ds
  2822a8:	08 0f                	or     %cl,(%edi)
	...
  2822c6:	00 ff                	add    %bh,%bh
  2822c8:	00 00                	add    %al,(%eax)
  2822ca:	00 ff                	add    %bh,%bh
  2822cc:	00 ff                	add    %bh,%bh
  2822ce:	ff 00                	incl   (%eax)
  2822d0:	00 00                	add    %al,(%eax)
  2822d2:	ff                   	(bad)  
  2822d3:	ff 00                	incl   (%eax)
  2822d5:	ff 00                	incl   (%eax)
  2822d7:	ff                   	(bad)  
  2822d8:	ff                   	(bad)  
  2822d9:	ff                   	(bad)  
  2822da:	ff                   	(bad)  
  2822db:	ff c6                	inc    %esi
  2822dd:	c6 c6 84             	mov    $0x84,%dh
  2822e0:	00 00                	add    %al,(%eax)
  2822e2:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
  2822e9:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
  2822f0:	84 84 84 84 2a 2a 2a 	test   %al,0x2a2a2a84(%esp,%eax,4)

002822f4 <cursor.1329>:
  2822f4:	2a 2a                	sub    (%edx),%ch
  2822f6:	2a 2a                	sub    (%edx),%ch
  2822f8:	2a 2a                	sub    (%edx),%ch
  2822fa:	2a 2a                	sub    (%edx),%ch
  2822fc:	2a 2a                	sub    (%edx),%ch
  2822fe:	2a 2a                	sub    (%edx),%ch
  282300:	2a 2a                	sub    (%edx),%ch
  282302:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282307:	4f                   	dec    %edi
  282308:	4f                   	dec    %edi
  282309:	4f                   	dec    %edi
  28230a:	4f                   	dec    %edi
  28230b:	4f                   	dec    %edi
  28230c:	4f                   	dec    %edi
  28230d:	4f                   	dec    %edi
  28230e:	4f                   	dec    %edi
  28230f:	4f                   	dec    %edi
  282310:	2a 2e                	sub    (%esi),%ch
  282312:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282317:	4f                   	dec    %edi
  282318:	4f                   	dec    %edi
  282319:	4f                   	dec    %edi
  28231a:	4f                   	dec    %edi
  28231b:	4f                   	dec    %edi
  28231c:	4f                   	dec    %edi
  28231d:	4f                   	dec    %edi
  28231e:	4f                   	dec    %edi
  28231f:	2a 2e                	sub    (%esi),%ch
  282321:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282327:	4f                   	dec    %edi
  282328:	4f                   	dec    %edi
  282329:	4f                   	dec    %edi
  28232a:	4f                   	dec    %edi
  28232b:	4f                   	dec    %edi
  28232c:	4f                   	dec    %edi
  28232d:	4f                   	dec    %edi
  28232e:	2a 2e                	sub    (%esi),%ch
  282330:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282337:	4f                   	dec    %edi
  282338:	4f                   	dec    %edi
  282339:	4f                   	dec    %edi
  28233a:	4f                   	dec    %edi
  28233b:	4f                   	dec    %edi
  28233c:	4f                   	dec    %edi
  28233d:	2a 2e                	sub    (%esi),%ch
  28233f:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282346:	4f 
  282347:	4f                   	dec    %edi
  282348:	4f                   	dec    %edi
  282349:	4f                   	dec    %edi
  28234a:	4f                   	dec    %edi
  28234b:	4f                   	dec    %edi
  28234c:	2a 2e                	sub    (%esi),%ch
  28234e:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282355:	4f 4f 
  282357:	4f                   	dec    %edi
  282358:	4f                   	dec    %edi
  282359:	4f                   	dec    %edi
  28235a:	4f                   	dec    %edi
  28235b:	4f                   	dec    %edi
  28235c:	2a 2e                	sub    (%esi),%ch
  28235e:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282365:	4f 4f 
  282367:	4f                   	dec    %edi
  282368:	4f                   	dec    %edi
  282369:	4f                   	dec    %edi
  28236a:	4f                   	dec    %edi
  28236b:	4f                   	dec    %edi
  28236c:	4f                   	dec    %edi
  28236d:	2a 2e                	sub    (%esi),%ch
  28236f:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282376:	4f 
  282377:	4f                   	dec    %edi
  282378:	4f                   	dec    %edi
  282379:	2a 2a                	sub    (%edx),%ch
  28237b:	4f                   	dec    %edi
  28237c:	4f                   	dec    %edi
  28237d:	4f                   	dec    %edi
  28237e:	2a 2e                	sub    (%esi),%ch
  282380:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282387:	4f                   	dec    %edi
  282388:	2a 2e                	sub    (%esi),%ch
  28238a:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  28238e:	4f                   	dec    %edi
  28238f:	2a 2e                	sub    (%esi),%ch
  282391:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282397:	2a 2e                	sub    (%esi),%ch
  282399:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  28239f:	4f                   	dec    %edi
  2823a0:	2a 2e                	sub    (%esi),%ch
  2823a2:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  2823a7:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823ae:	4f 4f 
  2823b0:	4f                   	dec    %edi
  2823b1:	2a 2e                	sub    (%esi),%ch
  2823b3:	2e 2a 2a             	sub    %cs:(%edx),%ch
  2823b6:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823bd:	2e 2a 4f 4f 
  2823c1:	4f                   	dec    %edi
  2823c2:	2a 2e                	sub    (%esi),%ch
  2823c4:	2a 2e                	sub    (%esi),%ch
  2823c6:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823cd:	2e 2e 2a 4f 4f 
  2823d2:	4f                   	dec    %edi
  2823d3:	2a 2e                	sub    (%esi),%ch
  2823d5:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823dc:	2e 2e 2e 2e 2a 4f 4f 
  2823e3:	2a 2e                	sub    (%esi),%ch
  2823e5:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  2823ec:	2e 2e 2e 2e 2e 2a 2a 
  2823f3:	2a                   	.byte 0x2a

Disassembly of section .eh_frame:

002823f4 <.eh_frame>:
  2823f4:	14 00                	adc    $0x0,%al
  2823f6:	00 00                	add    %al,(%eax)
  2823f8:	00 00                	add    %al,(%eax)
  2823fa:	00 00                	add    %al,(%eax)
  2823fc:	01 7a 52             	add    %edi,0x52(%edx)
  2823ff:	00 01                	add    %al,(%ecx)
  282401:	7c 08                	jl     28240b <cursor.1329+0x117>
  282403:	01 1b                	add    %ebx,(%ebx)
  282405:	0c 04                	or     $0x4,%al
  282407:	04 88                	add    $0x88,%al
  282409:	01 00                	add    %eax,(%eax)
  28240b:	00 18                	add    %bl,(%eax)
  28240d:	00 00                	add    %al,(%eax)
  28240f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282412:	00 00                	add    %al,(%eax)
  282414:	ec                   	in     (%dx),%al
  282415:	db ff                	(bad)  
  282417:	ff 96 00 00 00 00    	call   *0x0(%esi)
  28241d:	41                   	inc    %ecx
  28241e:	0e                   	push   %cs
  28241f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282425:	47                   	inc    %edi
  282426:	83 03 1c             	addl   $0x1c,(%ebx)
  282429:	00 00                	add    %al,(%eax)
  28242b:	00 38                	add    %bh,(%eax)
  28242d:	00 00                	add    %al,(%eax)
  28242f:	00 66 dc             	add    %ah,-0x24(%esi)
  282432:	ff                   	(bad)  
  282433:	ff 17                	call   *(%edi)
  282435:	00 00                	add    %al,(%eax)
  282437:	00 00                	add    %al,(%eax)
  282439:	41                   	inc    %ecx
  28243a:	0e                   	push   %cs
  28243b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282441:	4e                   	dec    %esi
  282442:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282445:	04 00                	add    $0x0,%al
  282447:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28244a:	00 00                	add    %al,(%eax)
  28244c:	58                   	pop    %eax
  28244d:	00 00                	add    %al,(%eax)
  28244f:	00 5d dc             	add    %bl,-0x24(%ebp)
  282452:	ff                   	(bad)  
  282453:	ff 14 00             	call   *(%eax,%eax,1)
  282456:	00 00                	add    %al,(%eax)
  282458:	00 41 0e             	add    %al,0xe(%ecx)
  28245b:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282461:	4b                   	dec    %ebx
  282462:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282465:	04 00                	add    $0x0,%al
  282467:	00 24 00             	add    %ah,(%eax,%eax,1)
  28246a:	00 00                	add    %al,(%eax)
  28246c:	78 00                	js     28246e <cursor.1329+0x17a>
  28246e:	00 00                	add    %al,(%eax)
  282470:	51                   	push   %ecx
  282471:	dc ff                	fdivr  %st,%st(7)
  282473:	ff                   	(bad)  
  282474:	3e 00 00             	add    %al,%ds:(%eax)
  282477:	00 00                	add    %al,(%eax)
  282479:	41                   	inc    %ecx
  28247a:	0e                   	push   %cs
  28247b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282481:	45                   	inc    %ebp
  282482:	86 03                	xchg   %al,(%ebx)
  282484:	83 04 73 c3          	addl   $0xffffffc3,(%ebx,%esi,2)
  282488:	41                   	inc    %ecx
  282489:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  28248d:	04 04                	add    $0x4,%al
  28248f:	00 24 00             	add    %ah,(%eax,%eax,1)
  282492:	00 00                	add    %al,(%eax)
  282494:	a0 00 00 00 67       	mov    0x67000000,%al
  282499:	dc ff                	fdivr  %st,%st(7)
  28249b:	ff 31                	pushl  (%ecx)
  28249d:	00 00                	add    %al,(%eax)
  28249f:	00 00                	add    %al,(%eax)
  2824a1:	41                   	inc    %ecx
  2824a2:	0e                   	push   %cs
  2824a3:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2824a9:	42                   	inc    %edx
  2824aa:	87 03                	xchg   %eax,(%ebx)
  2824ac:	86 04 64             	xchg   %al,(%esp,%eiz,2)
  2824af:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2824b3:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2824b6:	04 00                	add    $0x0,%al
  2824b8:	20 00                	and    %al,(%eax)
  2824ba:	00 00                	add    %al,(%eax)
  2824bc:	c8 00 00 00          	enter  $0x0,$0x0
  2824c0:	70 dc                	jo     28249e <cursor.1329+0x1aa>
  2824c2:	ff                   	(bad)  
  2824c3:	ff 2f                	ljmp   *(%edi)
  2824c5:	00 00                	add    %al,(%eax)
  2824c7:	00 00                	add    %al,(%eax)
  2824c9:	41                   	inc    %ecx
  2824ca:	0e                   	push   %cs
  2824cb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2824d1:	47                   	inc    %edi
  2824d2:	83 03 63             	addl   $0x63,(%ebx)
  2824d5:	c3                   	ret    
  2824d6:	41                   	inc    %ecx
  2824d7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2824da:	04 00                	add    $0x0,%al
  2824dc:	1c 00                	sbb    $0x0,%al
  2824de:	00 00                	add    %al,(%eax)
  2824e0:	ec                   	in     (%dx),%al
  2824e1:	00 00                	add    %al,(%eax)
  2824e3:	00 7b dc             	add    %bh,-0x24(%ebx)
  2824e6:	ff                   	(bad)  
  2824e7:	ff 28                	ljmp   *(%eax)
  2824e9:	00 00                	add    %al,(%eax)
  2824eb:	00 00                	add    %al,(%eax)
  2824ed:	41                   	inc    %ecx
  2824ee:	0e                   	push   %cs
  2824ef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2824f5:	64 c5 0c 04          	lds    %fs:(%esp,%eax,1),%ecx
  2824f9:	04 00                	add    $0x0,%al
  2824fb:	00 1c 00             	add    %bl,(%eax,%eax,1)
  2824fe:	00 00                	add    %al,(%eax)
  282500:	0c 01                	or     $0x1,%al
  282502:	00 00                	add    %al,(%eax)
  282504:	83 dc ff             	sbb    $0xffffffff,%esp
  282507:	ff 61 01             	jmp    *0x1(%ecx)
  28250a:	00 00                	add    %al,(%eax)
  28250c:	00 41 0e             	add    %al,0xe(%ecx)
  28250f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282515:	03 5d 01             	add    0x1(%ebp),%ebx
  282518:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28251b:	04 1c                	add    $0x1c,%al
  28251d:	00 00                	add    %al,(%eax)
  28251f:	00 2c 01             	add    %ch,(%ecx,%eax,1)
  282522:	00 00                	add    %al,(%eax)
  282524:	c4                   	(bad)  
  282525:	dd ff                	(bad)  
  282527:	ff 1f                	lcall  *(%edi)
  282529:	00 00                	add    %al,(%eax)
  28252b:	00 00                	add    %al,(%eax)
  28252d:	41                   	inc    %ecx
  28252e:	0e                   	push   %cs
  28252f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282535:	5b                   	pop    %ebx
  282536:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282539:	04 00                	add    $0x0,%al
  28253b:	00 24 00             	add    %ah,(%eax,%eax,1)
  28253e:	00 00                	add    %al,(%eax)
  282540:	4c                   	dec    %esp
  282541:	01 00                	add    %eax,(%eax)
  282543:	00 c3                	add    %al,%bl
  282545:	dd ff                	(bad)  
  282547:	ff 50 00             	call   *0x0(%eax)
  28254a:	00 00                	add    %al,(%eax)
  28254c:	00 41 0e             	add    %al,0xe(%ecx)
  28254f:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282555:	48                   	dec    %eax
  282556:	86 03                	xchg   %al,(%ebx)
  282558:	83 04 02 40          	addl   $0x40,(%edx,%eax,1)
  28255c:	c3                   	ret    
  28255d:	41                   	inc    %ecx
  28255e:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282562:	04 04                	add    $0x4,%al
  282564:	24 00                	and    $0x0,%al
  282566:	00 00                	add    %al,(%eax)
  282568:	74 01                	je     28256b <cursor.1329+0x277>
  28256a:	00 00                	add    %al,(%eax)
  28256c:	eb dd                	jmp    28254b <cursor.1329+0x257>
  28256e:	ff                   	(bad)  
  28256f:	ff                   	(bad)  
  282570:	39 00                	cmp    %eax,(%eax)
  282572:	00 00                	add    %al,(%eax)
  282574:	00 41 0e             	add    %al,0xe(%ecx)
  282577:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28257d:	44                   	inc    %esp
  28257e:	86 03                	xchg   %al,(%ebx)
  282580:	43                   	inc    %ebx
  282581:	83 04 6c c3          	addl   $0xffffffc3,(%esp,%ebp,2)
  282585:	41                   	inc    %ecx
  282586:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  28258a:	04 04                	add    $0x4,%al
  28258c:	28 00                	sub    %al,(%eax)
  28258e:	00 00                	add    %al,(%eax)
  282590:	9c                   	pushf  
  282591:	01 00                	add    %eax,(%eax)
  282593:	00 fc                	add    %bh,%ah
  282595:	dd ff                	(bad)  
  282597:	ff 62 00             	jmp    *0x0(%edx)
  28259a:	00 00                	add    %al,(%eax)
  28259c:	00 41 0e             	add    %al,0xe(%ecx)
  28259f:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2825a5:	4b                   	dec    %ebx
  2825a6:	87 03                	xchg   %eax,(%ebx)
  2825a8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2825ab:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  2825b0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2825b4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2825b7:	04 28                	add    $0x28,%al
  2825b9:	00 00                	add    %al,(%eax)
  2825bb:	00 c8                	add    %cl,%al
  2825bd:	01 00                	add    %eax,(%eax)
  2825bf:	00 32                	add    %dh,(%edx)
  2825c1:	de ff                	fdivrp %st,%st(7)
  2825c3:	ff 62 00             	jmp    *0x0(%edx)
  2825c6:	00 00                	add    %al,(%eax)
  2825c8:	00 41 0e             	add    %al,0xe(%ecx)
  2825cb:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2825d1:	4b                   	dec    %ebx
  2825d2:	87 03                	xchg   %eax,(%ebx)
  2825d4:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2825d7:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  2825dc:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2825e0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2825e3:	04 28                	add    $0x28,%al
  2825e5:	00 00                	add    %al,(%eax)
  2825e7:	00 f4                	add    %dh,%ah
  2825e9:	01 00                	add    %eax,(%eax)
  2825eb:	00 68 de             	add    %ch,-0x22(%eax)
  2825ee:	ff                   	(bad)  
  2825ef:	ff aa 00 00 00 00    	ljmp   *0x0(%edx)
  2825f5:	41                   	inc    %ecx
  2825f6:	0e                   	push   %cs
  2825f7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2825fd:	46                   	inc    %esi
  2825fe:	87 03                	xchg   %eax,(%ebx)
  282600:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282603:	05 02 9d c3 41       	add    $0x41c39d02,%eax
  282608:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  28260c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28260f:	04 28                	add    $0x28,%al
  282611:	00 00                	add    %al,(%eax)
  282613:	00 20                	add    %ah,(%eax)
  282615:	02 00                	add    (%eax),%al
  282617:	00 e6                	add    %ah,%dh
  282619:	de ff                	fdivrp %st,%st(7)
  28261b:	ff 51 00             	call   *0x0(%ecx)
  28261e:	00 00                	add    %al,(%eax)
  282620:	00 41 0e             	add    %al,0xe(%ecx)
  282623:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282629:	41                   	inc    %ecx
  28262a:	87 03                	xchg   %eax,(%ebx)
  28262c:	4a                   	dec    %edx
  28262d:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  282630:	05 7d c3 41 c6       	add    $0xc641c37d,%eax
  282635:	41                   	inc    %ecx
  282636:	c7 41 c5 0c 04 04 2c 	movl   $0x2c04040c,-0x3b(%ecx)
  28263d:	00 00                	add    %al,(%eax)
  28263f:	00 4c 02 00          	add    %cl,0x0(%edx,%eax,1)
  282643:	00 0b                	add    %cl,(%ebx)
  282645:	df ff                	(bad)  
  282647:	ff 64 00 00          	jmp    *0x0(%eax,%eax,1)
  28264b:	00 00                	add    %al,(%eax)
  28264d:	41                   	inc    %ecx
  28264e:	0e                   	push   %cs
  28264f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282655:	41                   	inc    %ecx
  282656:	87 03                	xchg   %eax,(%ebx)
  282658:	44                   	inc    %esp
  282659:	86 04 45 83 05 02 53 	xchg   %al,0x53020583(,%eax,2)
  282660:	c3                   	ret    
  282661:	41                   	inc    %ecx
  282662:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282666:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282669:	04 00                	add    $0x0,%al
  28266b:	00 20                	add    %ah,(%eax)
  28266d:	00 00                	add    %al,(%eax)
  28266f:	00 7c 02 00          	add    %bh,0x0(%edx,%eax,1)
  282673:	00 3f                	add    %bh,(%edi)
  282675:	df ff                	(bad)  
  282677:	ff                   	(bad)  
  282678:	3a 00                	cmp    (%eax),%al
  28267a:	00 00                	add    %al,(%eax)
  28267c:	00 41 0e             	add    %al,0xe(%ecx)
  28267f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282685:	44                   	inc    %esp
  282686:	83 03 72             	addl   $0x72,(%ebx)
  282689:	c5 c3 0c             	(bad)  
  28268c:	04 04                	add    $0x4,%al
  28268e:	00 00                	add    %al,(%eax)
  282690:	28 00                	sub    %al,(%eax)
  282692:	00 00                	add    %al,(%eax)
  282694:	a0 02 00 00 55       	mov    0x55000002,%al
  282699:	df ff                	(bad)  
  28269b:	ff 50 00             	call   *0x0(%eax)
  28269e:	00 00                	add    %al,(%eax)
  2826a0:	00 41 0e             	add    %al,0xe(%ecx)
  2826a3:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2826a9:	44                   	inc    %esp
  2826aa:	87 03                	xchg   %eax,(%ebx)
  2826ac:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2826af:	05 02 43 c3 41       	add    $0x41c34302,%eax
  2826b4:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2826b8:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2826bb:	04 2c                	add    $0x2c,%al
  2826bd:	00 00                	add    %al,(%eax)
  2826bf:	00 cc                	add    %cl,%ah
  2826c1:	02 00                	add    (%eax),%al
  2826c3:	00 79 df             	add    %bh,-0x21(%ecx)
  2826c6:	ff                   	(bad)  
  2826c7:	ff 4f 00             	decl   0x0(%edi)
  2826ca:	00 00                	add    %al,(%eax)
  2826cc:	00 41 0e             	add    %al,0xe(%ecx)
  2826cf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2826d5:	41                   	inc    %ecx
  2826d6:	87 03                	xchg   %eax,(%ebx)
  2826d8:	44                   	inc    %esp
  2826d9:	86 04 44             	xchg   %al,(%esp,%eax,2)
  2826dc:	83 05 7f c3 41 c6 41 	addl   $0x41,0xc641c37f
  2826e3:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  2826ea:	00 00                	add    %al,(%eax)
  2826ec:	2c 00                	sub    $0x0,%al
  2826ee:	00 00                	add    %al,(%eax)
  2826f0:	fc                   	cld    
  2826f1:	02 00                	add    (%eax),%al
  2826f3:	00 98 df ff ff 54    	add    %bl,0x54ffffdf(%eax)
  2826f9:	00 00                	add    %al,(%eax)
  2826fb:	00 00                	add    %al,(%eax)
  2826fd:	41                   	inc    %ecx
  2826fe:	0e                   	push   %cs
  2826ff:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282705:	48                   	dec    %eax
  282706:	87 03                	xchg   %eax,(%ebx)
  282708:	86 04 44             	xchg   %al,(%esp,%eax,2)
  28270b:	83 05 02 41 c3 41 c6 	addl   $0xffffffc6,0x41c34102
  282712:	41                   	inc    %ecx
  282713:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  28271a:	00 00                	add    %al,(%eax)
  28271c:	1c 00                	sbb    $0x0,%al
  28271e:	00 00                	add    %al,(%eax)
  282720:	2c 03                	sub    $0x3,%al
  282722:	00 00                	add    %al,(%eax)
  282724:	bc df ff ff 2a       	mov    $0x2affffdf,%esp
  282729:	00 00                	add    %al,(%eax)
  28272b:	00 00                	add    %al,(%eax)
  28272d:	41                   	inc    %ecx
  28272e:	0e                   	push   %cs
  28272f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282735:	66 c5 0c 04          	lds    (%esp,%eax,1),%cx
  282739:	04 00                	add    $0x0,%al
  28273b:	00 20                	add    %ah,(%eax)
  28273d:	00 00                	add    %al,(%eax)
  28273f:	00 4c 03 00          	add    %cl,0x0(%ebx,%eax,1)
  282743:	00 c6                	add    %al,%dh
  282745:	df ff                	(bad)  
  282747:	ff 35 01 00 00 00    	pushl  0x1
  28274d:	41                   	inc    %ecx
  28274e:	0e                   	push   %cs
  28274f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282755:	41                   	inc    %ecx
  282756:	83 03 03             	addl   $0x3,(%ebx)
  282759:	30 01                	xor    %al,(%ecx)
  28275b:	c5 c3 0c             	(bad)  
  28275e:	04 04                	add    $0x4,%al
  282760:	1c 00                	sbb    $0x0,%al
  282762:	00 00                	add    %al,(%eax)
  282764:	70 03                	jo     282769 <cursor.1329+0x475>
  282766:	00 00                	add    %al,(%eax)
  282768:	d7                   	xlat   %ds:(%ebx)
  282769:	e0 ff                	loopne 28276a <cursor.1329+0x476>
  28276b:	ff                   	(bad)  
  28276c:	3a 00                	cmp    (%eax),%al
  28276e:	00 00                	add    %al,(%eax)
  282770:	00 41 0e             	add    %al,0xe(%ecx)
  282773:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282779:	71 c5                	jno    282740 <cursor.1329+0x44c>
  28277b:	0c 04                	or     $0x4,%al
  28277d:	04 00                	add    $0x0,%al
  28277f:	00 18                	add    %bl,(%eax)
  282781:	00 00                	add    %al,(%eax)
  282783:	00 90 03 00 00 f1    	add    %dl,-0xefffffd(%eax)
  282789:	e0 ff                	loopne 28278a <cursor.1329+0x496>
  28278b:	ff                   	(bad)  
  28278c:	3f                   	aas    
  28278d:	00 00                	add    %al,(%eax)
  28278f:	00 00                	add    %al,(%eax)
  282791:	41                   	inc    %ecx
  282792:	0e                   	push   %cs
  282793:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282799:	00 00                	add    %al,(%eax)
	...

Disassembly of section .rodata.str1.1:

0028279c <.rodata.str1.1>:
  28279c:	44                   	inc    %esp
  28279d:	65 62 75 67          	bound  %esi,%gs:0x67(%ebp)
  2827a1:	3a 76 61             	cmp    0x61(%esi),%dh
  2827a4:	72 3d                	jb     2827e3 <cursor.1329+0x4ef>
  2827a6:	25 78 00 69 6e       	and    $0x6e690078,%eax
  2827ab:	74 20                	je     2827cd <cursor.1329+0x4d9>
  2827ad:	32 31                	xor    (%ecx),%dh
  2827af:	28 49 52             	sub    %cl,0x52(%ecx)
  2827b2:	51                   	push   %ecx
  2827b3:	2d 31 29 3a 50       	sub    $0x503a2931,%eax
  2827b8:	53                   	push   %ebx
  2827b9:	2f                   	das    
  2827ba:	32 20                	xor    (%eax),%ah
  2827bc:	6b 65 79 62          	imul   $0x62,0x79(%ebp),%esp
  2827c0:	6f                   	outsl  %ds:(%esi),(%dx)
  2827c1:	61                   	popa   
  2827c2:	72 64                	jb     282828 <cursor.1329+0x534>
	...

Disassembly of section .stab:

00000000 <.stab>:
       0:	01 00                	add    %eax,(%eax)
       2:	00 00                	add    %al,(%eax)
       4:	00 00                	add    %al,(%eax)
       6:	aa                   	stos   %al,%es:(%edi)
       7:	02 1f                	add    (%edi),%bl
       9:	0c 00                	or     $0x0,%al
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
     103:	00 34 72             	add    %dh,(%edx,%esi,2)
     106:	00 00                	add    %al,(%eax)
     108:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     109:	02 00                	add    (%eax),%al
     10b:	00 82 00 00 00 00    	add    %al,0x0(%edx)
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
     1fb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     201:	00 00                	add    %al,(%eax)
     203:	00 ae 04 00 00 80    	add    %ch,-0x7ffffffc(%esi)
     209:	00 00                	add    %al,(%eax)
     20b:	00 00                	add    %al,(%eax)
     20d:	00 00                	add    %al,(%eax)
     20f:	00 3e                	add    %bh,(%esi)
     211:	05 00 00 80 00       	add    $0x800000,%eax
	...
     21e:	00 00                	add    %al,(%eax)
     220:	a2 00 00 00 00       	mov    %al,0x0
     225:	00 00                	add    %al,(%eax)
     227:	00 bc 05 00 00 24 00 	add    %bh,0x240000(%ebp,%eax,1)
     22e:	00 00                	add    %al,(%eax)
     230:	00 00                	add    %al,(%eax)
     232:	28 00                	sub    %al,(%eax)
     234:	00 00                	add    %al,(%eax)
     236:	00 00                	add    %al,(%eax)
     238:	44                   	inc    %esp
     239:	00 10                	add    %dl,(%eax)
	...
     243:	00 44 00 15          	add    %al,0x15(%eax,%eax,1)
     247:	00 0a                	add    %cl,(%edx)
     249:	00 00                	add    %al,(%eax)
     24b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     251:	00 00                	add    %al,(%eax)
     253:	00 11                	add    %dl,(%ecx)
     255:	00 28                	add    %ch,(%eax)
     257:	00 00                	add    %al,(%eax)
     259:	00 00                	add    %al,(%eax)
     25b:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
     25f:	00 11                	add    %dl,(%ecx)
     261:	00 00                	add    %al,(%eax)
     263:	00 01                	add    %al,(%ecx)
     265:	00 00                	add    %al,(%eax)
     267:	00 84 00 00 00 12 00 	add    %al,0x120000(%eax,%eax,1)
     26e:	28 00                	sub    %al,(%eax)
     270:	00 00                	add    %al,(%eax)
     272:	00 00                	add    %al,(%eax)
     274:	44                   	inc    %esp
     275:	00 18                	add    %bl,(%eax)
     277:	00 12                	add    %dl,(%edx)
     279:	00 00                	add    %al,(%eax)
     27b:	00 00                	add    %al,(%eax)
     27d:	00 00                	add    %al,(%eax)
     27f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
     283:	00 19                	add    %bl,(%ecx)
     285:	00 00                	add    %al,(%eax)
     287:	00 00                	add    %al,(%eax)
     289:	00 00                	add    %al,(%eax)
     28b:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
     28f:	00 1f                	add    %bl,(%edi)
     291:	00 00                	add    %al,(%eax)
     293:	00 00                	add    %al,(%eax)
     295:	00 00                	add    %al,(%eax)
     297:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     29b:	00 24 00             	add    %ah,(%eax,%eax,1)
     29e:	00 00                	add    %al,(%eax)
     2a0:	00 00                	add    %al,(%eax)
     2a2:	00 00                	add    %al,(%eax)
     2a4:	44                   	inc    %esp
     2a5:	00 1b                	add    %bl,(%ebx)
     2a7:	00 29                	add    %ch,(%ecx)
     2a9:	00 00                	add    %al,(%eax)
     2ab:	00 00                	add    %al,(%eax)
     2ad:	00 00                	add    %al,(%eax)
     2af:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
     2b3:	00 2e                	add    %ch,(%esi)
     2b5:	00 00                	add    %al,(%eax)
     2b7:	00 00                	add    %al,(%eax)
     2b9:	00 00                	add    %al,(%eax)
     2bb:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
     2bf:	00 38                	add    %bh,(%eax)
     2c1:	00 00                	add    %al,(%eax)
     2c3:	00 00                	add    %al,(%eax)
     2c5:	00 00                	add    %al,(%eax)
     2c7:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
     2cb:	00 56 00             	add    %dl,0x0(%esi)
     2ce:	00 00                	add    %al,(%eax)
     2d0:	00 00                	add    %al,(%eax)
     2d2:	00 00                	add    %al,(%eax)
     2d4:	44                   	inc    %esp
     2d5:	00 30                	add    %dh,(%eax)
     2d7:	00 5e 00             	add    %bl,0x0(%esi)
     2da:	00 00                	add    %al,(%eax)
     2dc:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     2dd:	02 00                	add    (%eax),%al
     2df:	00 84 00 00 00 63 00 	add    %al,0x630000(%eax,%eax,1)
     2e6:	28 00                	sub    %al,(%eax)
     2e8:	00 00                	add    %al,(%eax)
     2ea:	00 00                	add    %al,(%eax)
     2ec:	44                   	inc    %esp
     2ed:	00 5c 00 63          	add    %bl,0x63(%eax,%eax,1)
     2f1:	00 00                	add    %al,(%eax)
     2f3:	00 01                	add    %al,(%ecx)
     2f5:	00 00                	add    %al,(%eax)
     2f7:	00 84 00 00 00 70 00 	add    %al,0x700000(%eax,%eax,1)
     2fe:	28 00                	sub    %al,(%eax)
     300:	00 00                	add    %al,(%eax)
     302:	00 00                	add    %al,(%eax)
     304:	44                   	inc    %esp
     305:	00 3d 00 70 00 00    	add    %bh,0x7000
     30b:	00 00                	add    %al,(%eax)
     30d:	00 00                	add    %al,(%eax)
     30f:	00 44 00 3e          	add    %al,0x3e(%eax,%eax,1)
     313:	00 7f 00             	add    %bh,0x0(%edi)
     316:	00 00                	add    %al,(%eax)
     318:	cd 05                	int    $0x5
     31a:	00 00                	add    %al,(%eax)
     31c:	80 00 00             	addb   $0x0,(%eax)
     31f:	00 f8                	add    %bh,%al
     321:	fe                   	(bad)  
     322:	ff                   	(bad)  
     323:	ff 00                	incl   (%eax)
     325:	00 00                	add    %al,(%eax)
     327:	00 c0                	add    %al,%al
	...
     331:	00 00                	add    %al,(%eax)
     333:	00 e0                	add    %ah,%al
     335:	00 00                	add    %al,(%eax)
     337:	00 96 00 00 00 08    	add    %dl,0x8000000(%esi)
     33d:	06                   	push   %es
     33e:	00 00                	add    %al,(%eax)
     340:	20 00                	and    %al,(%eax)
     342:	00 00                	add    %al,(%eax)
     344:	00 00                	add    %al,(%eax)
     346:	00 00                	add    %al,(%eax)
     348:	32 06                	xor    (%esi),%al
     34a:	00 00                	add    %al,(%eax)
     34c:	20 00                	and    %al,(%eax)
	...
     356:	00 00                	add    %al,(%eax)
     358:	64 00 00             	add    %al,%fs:(%eax)
     35b:	00 96 00 28 00 5a    	add    %dl,0x5a002800(%esi)
     361:	06                   	push   %es
     362:	00 00                	add    %al,(%eax)
     364:	64 00 02             	add    %al,%fs:(%edx)
     367:	00 96 00 28 00 08    	add    %dl,0x8002800(%esi)
     36d:	00 00                	add    %al,(%eax)
     36f:	00 3c 00             	add    %bh,(%eax,%eax,1)
     372:	00 00                	add    %al,(%eax)
     374:	00 00                	add    %al,(%eax)
     376:	00 00                	add    %al,(%eax)
     378:	17                   	pop    %ss
     379:	00 00                	add    %al,(%eax)
     37b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     381:	00 00                	add    %al,(%eax)
     383:	00 41 00             	add    %al,0x0(%ecx)
     386:	00 00                	add    %al,(%eax)
     388:	80 00 00             	addb   $0x0,(%eax)
     38b:	00 00                	add    %al,(%eax)
     38d:	00 00                	add    %al,(%eax)
     38f:	00 5b 00             	add    %bl,0x0(%ebx)
     392:	00 00                	add    %al,(%eax)
     394:	80 00 00             	addb   $0x0,(%eax)
     397:	00 00                	add    %al,(%eax)
     399:	00 00                	add    %al,(%eax)
     39b:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     3a1:	00 00                	add    %al,(%eax)
     3a3:	00 00                	add    %al,(%eax)
     3a5:	00 00                	add    %al,(%eax)
     3a7:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     3ad:	00 00                	add    %al,(%eax)
     3af:	00 00                	add    %al,(%eax)
     3b1:	00 00                	add    %al,(%eax)
     3b3:	00 e1                	add    %ah,%cl
     3b5:	00 00                	add    %al,(%eax)
     3b7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     3bd:	00 00                	add    %al,(%eax)
     3bf:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     3c2:	00 00                	add    %al,(%eax)
     3c4:	80 00 00             	addb   $0x0,(%eax)
     3c7:	00 00                	add    %al,(%eax)
     3c9:	00 00                	add    %al,(%eax)
     3cb:	00 37                	add    %dh,(%edi)
     3cd:	01 00                	add    %eax,(%eax)
     3cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     3d5:	00 00                	add    %al,(%eax)
     3d7:	00 5d 01             	add    %bl,0x1(%ebp)
     3da:	00 00                	add    %al,(%eax)
     3dc:	80 00 00             	addb   $0x0,(%eax)
     3df:	00 00                	add    %al,(%eax)
     3e1:	00 00                	add    %al,(%eax)
     3e3:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     3e9:	00 00                	add    %al,(%eax)
     3eb:	00 00                	add    %al,(%eax)
     3ed:	00 00                	add    %al,(%eax)
     3ef:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     3f5:	00 00                	add    %al,(%eax)
     3f7:	00 00                	add    %al,(%eax)
     3f9:	00 00                	add    %al,(%eax)
     3fb:	00 d2                	add    %dl,%dl
     3fd:	01 00                	add    %eax,(%eax)
     3ff:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     405:	00 00                	add    %al,(%eax)
     407:	00 ec                	add    %ch,%ah
     409:	01 00                	add    %eax,(%eax)
     40b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     411:	00 00                	add    %al,(%eax)
     413:	00 07                	add    %al,(%edi)
     415:	02 00                	add    (%eax),%al
     417:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     41d:	00 00                	add    %al,(%eax)
     41f:	00 28                	add    %ch,(%eax)
     421:	02 00                	add    (%eax),%al
     423:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     429:	00 00                	add    %al,(%eax)
     42b:	00 47 02             	add    %al,0x2(%edi)
     42e:	00 00                	add    %al,(%eax)
     430:	80 00 00             	addb   $0x0,(%eax)
     433:	00 00                	add    %al,(%eax)
     435:	00 00                	add    %al,(%eax)
     437:	00 66 02             	add    %ah,0x2(%esi)
     43a:	00 00                	add    %al,(%eax)
     43c:	80 00 00             	addb   $0x0,(%eax)
     43f:	00 00                	add    %al,(%eax)
     441:	00 00                	add    %al,(%eax)
     443:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     449:	00 00                	add    %al,(%eax)
     44b:	00 00                	add    %al,(%eax)
     44d:	00 00                	add    %al,(%eax)
     44f:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     455:	00 00                	add    %al,(%eax)
     457:	00 34 72             	add    %dh,(%edx,%esi,2)
     45a:	00 00                	add    %al,(%eax)
     45c:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     45d:	02 00                	add    (%eax),%al
     45f:	00 c2                	add    %al,%dl
     461:	00 00                	add    %al,(%eax)
     463:	00 00                	add    %al,(%eax)
     465:	00 00                	add    %al,(%eax)
     467:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     46d:	00 00                	add    %al,(%eax)
     46f:	00 37                	add    %dh,(%edi)
     471:	53                   	push   %ebx
     472:	00 00                	add    %al,(%eax)
     474:	63 06                	arpl   %ax,(%esi)
     476:	00 00                	add    %al,(%eax)
     478:	24 00                	and    $0x0,%al
     47a:	00 00                	add    %al,(%eax)
     47c:	96                   	xchg   %eax,%esi
     47d:	00 28                	add    %ch,(%eax)
     47f:	00 78 06             	add    %bh,0x6(%eax)
     482:	00 00                	add    %al,(%eax)
     484:	a0 00 00 00 08       	mov    0x8000000,%al
     489:	00 00                	add    %al,(%eax)
     48b:	00 00                	add    %al,(%eax)
     48d:	00 00                	add    %al,(%eax)
     48f:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
	...
     49b:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     49f:	00 01                	add    %al,(%ecx)
     4a1:	00 00                	add    %al,(%eax)
     4a3:	00 00                	add    %al,(%eax)
     4a5:	00 00                	add    %al,(%eax)
     4a7:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     4ab:	00 06                	add    %al,(%esi)
     4ad:	00 00                	add    %al,(%eax)
     4af:	00 00                	add    %al,(%eax)
     4b1:	00 00                	add    %al,(%eax)
     4b3:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     4b7:	00 08                	add    %cl,(%eax)
     4b9:	00 00                	add    %al,(%eax)
     4bb:	00 00                	add    %al,(%eax)
     4bd:	00 00                	add    %al,(%eax)
     4bf:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
     4c3:	00 0b                	add    %cl,(%ebx)
     4c5:	00 00                	add    %al,(%eax)
     4c7:	00 00                	add    %al,(%eax)
     4c9:	00 00                	add    %al,(%eax)
     4cb:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     4cf:	00 0d 00 00 00 00    	add    %cl,0x0
     4d5:	00 00                	add    %al,(%eax)
     4d7:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
     4db:	00 15 00 00 00 85    	add    %dl,0x85000000
     4e1:	06                   	push   %es
     4e2:	00 00                	add    %al,(%eax)
     4e4:	40                   	inc    %eax
     4e5:	00 00                	add    %al,(%eax)
     4e7:	00 00                	add    %al,(%eax)
     4e9:	00 00                	add    %al,(%eax)
     4eb:	00 8e 06 00 00 40    	add    %cl,0x40000006(%esi)
     4f1:	00 00                	add    %al,(%eax)
     4f3:	00 02                	add    %al,(%edx)
     4f5:	00 00                	add    %al,(%eax)
     4f7:	00 00                	add    %al,(%eax)
     4f9:	00 00                	add    %al,(%eax)
     4fb:	00 c0                	add    %al,%al
	...
     505:	00 00                	add    %al,(%eax)
     507:	00 e0                	add    %ah,%al
     509:	00 00                	add    %al,(%eax)
     50b:	00 17                	add    %dl,(%edi)
     50d:	00 00                	add    %al,(%eax)
     50f:	00 9b 06 00 00 24    	add    %bl,0x24000006(%ebx)
     515:	00 00                	add    %al,(%eax)
     517:	00 ad 00 28 00 78    	add    %ch,0x78002800(%ebp)
     51d:	06                   	push   %es
     51e:	00 00                	add    %al,(%eax)
     520:	a0 00 00 00 08       	mov    0x8000000,%al
     525:	00 00                	add    %al,(%eax)
     527:	00 00                	add    %al,(%eax)
     529:	00 00                	add    %al,(%eax)
     52b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
	...
     537:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     53b:	00 01                	add    %al,(%ecx)
     53d:	00 00                	add    %al,(%eax)
     53f:	00 00                	add    %al,(%eax)
     541:	00 00                	add    %al,(%eax)
     543:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
     547:	00 06                	add    %al,(%esi)
     549:	00 00                	add    %al,(%eax)
     54b:	00 00                	add    %al,(%eax)
     54d:	00 00                	add    %al,(%eax)
     54f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     553:	00 08                	add    %cl,(%eax)
     555:	00 00                	add    %al,(%eax)
     557:	00 00                	add    %al,(%eax)
     559:	00 00                	add    %al,(%eax)
     55b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     55f:	00 0a                	add    %cl,(%edx)
     561:	00 00                	add    %al,(%eax)
     563:	00 00                	add    %al,(%eax)
     565:	00 00                	add    %al,(%eax)
     567:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     56b:	00 12                	add    %dl,(%edx)
     56d:	00 00                	add    %al,(%eax)
     56f:	00 85 06 00 00 40    	add    %al,0x40000006(%ebp)
	...
     57d:	00 00                	add    %al,(%eax)
     57f:	00 c0                	add    %al,%al
	...
     589:	00 00                	add    %al,(%eax)
     58b:	00 e0                	add    %ah,%al
     58d:	00 00                	add    %al,(%eax)
     58f:	00 14 00             	add    %dl,(%eax,%eax,1)
     592:	00 00                	add    %al,(%eax)
     594:	b0 06                	mov    $0x6,%al
     596:	00 00                	add    %al,(%eax)
     598:	24 00                	and    $0x0,%al
     59a:	00 00                	add    %al,(%eax)
     59c:	c1 00 28             	roll   $0x28,(%eax)
     59f:	00 c4                	add    %al,%ah
     5a1:	06                   	push   %es
     5a2:	00 00                	add    %al,(%eax)
     5a4:	a0 00 00 00 08       	mov    0x8000000,%al
     5a9:	00 00                	add    %al,(%eax)
     5ab:	00 d1                	add    %dl,%cl
     5ad:	06                   	push   %es
     5ae:	00 00                	add    %al,(%eax)
     5b0:	a0 00 00 00 0c       	mov    0xc000000,%al
     5b5:	00 00                	add    %al,(%eax)
     5b7:	00 dc                	add    %bl,%ah
     5b9:	06                   	push   %es
     5ba:	00 00                	add    %al,(%eax)
     5bc:	a0 00 00 00 10       	mov    0x10000000,%al
     5c1:	00 00                	add    %al,(%eax)
     5c3:	00 00                	add    %al,(%eax)
     5c5:	00 00                	add    %al,(%eax)
     5c7:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
	...
     5d3:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     5d7:	00 08                	add    %cl,(%eax)
     5d9:	00 00                	add    %al,(%eax)
     5db:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     5e1:	00 00                	add    %al,(%eax)
     5e3:	00 cc                	add    %cl,%ah
     5e5:	00 28                	add    %ch,(%eax)
     5e7:	00 00                	add    %al,(%eax)
     5e9:	00 00                	add    %al,(%eax)
     5eb:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
     5ef:	01 0b                	add    %ecx,(%ebx)
     5f1:	00 00                	add    %al,(%eax)
     5f3:	00 5a 06             	add    %bl,0x6(%edx)
     5f6:	00 00                	add    %al,(%eax)
     5f8:	84 00                	test   %al,(%eax)
     5fa:	00 00                	add    %al,(%eax)
     5fc:	ce                   	into   
     5fd:	00 28                	add    %ch,(%eax)
     5ff:	00 00                	add    %al,(%eax)
     601:	00 00                	add    %al,(%eax)
     603:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
     607:	00 0d 00 00 00 a6    	add    %cl,0xa6000000
     60d:	02 00                	add    (%eax),%al
     60f:	00 84 00 00 00 cf 00 	add    %al,0xcf0000(%eax,%eax,1)
     616:	28 00                	sub    %al,(%eax)
     618:	00 00                	add    %al,(%eax)
     61a:	00 00                	add    %al,(%eax)
     61c:	44                   	inc    %esp
     61d:	00 5c 00 0e          	add    %bl,0xe(%eax,%eax,1)
     621:	00 00                	add    %al,(%eax)
     623:	00 5a 06             	add    %bl,0x6(%edx)
     626:	00 00                	add    %al,(%eax)
     628:	84 00                	test   %al,(%eax)
     62a:	00 00                	add    %al,(%eax)
     62c:	d4 00                	aam    $0x0
     62e:	28 00                	sub    %al,(%eax)
     630:	00 00                	add    %al,(%eax)
     632:	00 00                	add    %al,(%eax)
     634:	44                   	inc    %esp
     635:	00 3f                	add    %bh,(%edi)
     637:	00 13                	add    %dl,(%ebx)
     639:	00 00                	add    %al,(%eax)
     63b:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     641:	00 00                	add    %al,(%eax)
     643:	00 d7                	add    %dl,%bh
     645:	00 28                	add    %ch,(%eax)
     647:	00 00                	add    %al,(%eax)
     649:	00 00                	add    %al,(%eax)
     64b:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     64f:	00 16                	add    %dl,(%esi)
     651:	00 00                	add    %al,(%eax)
     653:	00 5a 06             	add    %bl,0x6(%edx)
     656:	00 00                	add    %al,(%eax)
     658:	84 00                	test   %al,(%eax)
     65a:	00 00                	add    %al,(%eax)
     65c:	da 00                	fiaddl (%eax)
     65e:	28 00                	sub    %al,(%eax)
     660:	00 00                	add    %al,(%eax)
     662:	00 00                	add    %al,(%eax)
     664:	44                   	inc    %esp
     665:	00 40 00             	add    %al,0x0(%eax)
     668:	19 00                	sbb    %eax,(%eax)
     66a:	00 00                	add    %al,(%eax)
     66c:	00 00                	add    %al,(%eax)
     66e:	00 00                	add    %al,(%eax)
     670:	44                   	inc    %esp
     671:	00 42 00             	add    %al,0x0(%edx)
     674:	1e                   	push   %ds
     675:	00 00                	add    %al,(%eax)
     677:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     67d:	00 00                	add    %al,(%eax)
     67f:	00 e4                	add    %ah,%ah
     681:	00 28                	add    %ch,(%eax)
     683:	00 00                	add    %al,(%eax)
     685:	00 00                	add    %al,(%eax)
     687:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     68b:	00 23                	add    %ah,(%ebx)
     68d:	00 00                	add    %al,(%eax)
     68f:	00 5a 06             	add    %bl,0x6(%edx)
     692:	00 00                	add    %al,(%eax)
     694:	84 00                	test   %al,(%eax)
     696:	00 00                	add    %al,(%eax)
     698:	e5 00                	in     $0x0,%eax
     69a:	28 00                	sub    %al,(%eax)
     69c:	00 00                	add    %al,(%eax)
     69e:	00 00                	add    %al,(%eax)
     6a0:	44                   	inc    %esp
     6a1:	00 43 00             	add    %al,0x0(%ebx)
     6a4:	24 00                	and    $0x0,%al
     6a6:	00 00                	add    %al,(%eax)
     6a8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     6a9:	02 00                	add    (%eax),%al
     6ab:	00 84 00 00 00 eb 00 	add    %al,0xeb0000(%eax,%eax,1)
     6b2:	28 00                	sub    %al,(%eax)
     6b4:	00 00                	add    %al,(%eax)
     6b6:	00 00                	add    %al,(%eax)
     6b8:	44                   	inc    %esp
     6b9:	00 5c 00 2a          	add    %bl,0x2a(%eax,%eax,1)
     6bd:	00 00                	add    %al,(%eax)
     6bf:	00 5a 06             	add    %bl,0x6(%edx)
     6c2:	00 00                	add    %al,(%eax)
     6c4:	84 00                	test   %al,(%eax)
     6c6:	00 00                	add    %al,(%eax)
     6c8:	ec                   	in     (%dx),%al
     6c9:	00 28                	add    %ch,(%eax)
     6cb:	00 00                	add    %al,(%eax)
     6cd:	00 00                	add    %al,(%eax)
     6cf:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     6d3:	00 2b                	add    %ch,(%ebx)
     6d5:	00 00                	add    %al,(%eax)
     6d7:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     6dd:	00 00                	add    %al,(%eax)
     6df:	00 f2                	add    %dh,%dl
     6e1:	00 28                	add    %ch,(%eax)
     6e3:	00 00                	add    %al,(%eax)
     6e5:	00 00                	add    %al,(%eax)
     6e7:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     6eb:	00 31                	add    %dh,(%ecx)
     6ed:	00 00                	add    %al,(%eax)
     6ef:	00 5a 06             	add    %bl,0x6(%edx)
     6f2:	00 00                	add    %al,(%eax)
     6f4:	84 00                	test   %al,(%eax)
     6f6:	00 00                	add    %al,(%eax)
     6f8:	f3 00 28             	repz add %ch,(%eax)
     6fb:	00 00                	add    %al,(%eax)
     6fd:	00 00                	add    %al,(%eax)
     6ff:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
     703:	00 32                	add    %dh,(%edx)
     705:	00 00                	add    %al,(%eax)
     707:	00 00                	add    %al,(%eax)
     709:	00 00                	add    %al,(%eax)
     70b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     70f:	00 35 00 00 00 a6    	add    %dh,0xa6000000
     715:	02 00                	add    (%eax),%al
     717:	00 84 00 00 00 f9 00 	add    %al,0xf90000(%eax,%eax,1)
     71e:	28 00                	sub    %al,(%eax)
     720:	00 00                	add    %al,(%eax)
     722:	00 00                	add    %al,(%eax)
     724:	44                   	inc    %esp
     725:	00 33                	add    %dh,(%ebx)
     727:	01 38                	add    %edi,(%eax)
     729:	00 00                	add    %al,(%eax)
     72b:	00 5a 06             	add    %bl,0x6(%edx)
     72e:	00 00                	add    %al,(%eax)
     730:	84 00                	test   %al,(%eax)
     732:	00 00                	add    %al,(%eax)
     734:	fb                   	sti    
     735:	00 28                	add    %ch,(%eax)
     737:	00 00                	add    %al,(%eax)
     739:	00 00                	add    %al,(%eax)
     73b:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
     73f:	00 3a                	add    %bh,(%edx)
     741:	00 00                	add    %al,(%eax)
     743:	00 f0                	add    %dh,%al
     745:	06                   	push   %es
     746:	00 00                	add    %al,(%eax)
     748:	40                   	inc    %eax
     749:	00 00                	add    %al,(%eax)
     74b:	00 03                	add    %al,(%ebx)
     74d:	00 00                	add    %al,(%eax)
     74f:	00 fd                	add    %bh,%ch
     751:	06                   	push   %es
     752:	00 00                	add    %al,(%eax)
     754:	40                   	inc    %eax
     755:	00 00                	add    %al,(%eax)
     757:	00 01                	add    %al,(%ecx)
     759:	00 00                	add    %al,(%eax)
     75b:	00 09                	add    %cl,(%ecx)
     75d:	07                   	pop    %es
     75e:	00 00                	add    %al,(%eax)
     760:	24 00                	and    $0x0,%al
     762:	00 00                	add    %al,(%eax)
     764:	ff 00                	incl   (%eax)
     766:	28 00                	sub    %al,(%eax)
     768:	00 00                	add    %al,(%eax)
     76a:	00 00                	add    %al,(%eax)
     76c:	44                   	inc    %esp
     76d:	00 1b                	add    %bl,(%ebx)
	...
     777:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     77b:	00 01                	add    %al,(%ecx)
     77d:	00 00                	add    %al,(%eax)
     77f:	00 00                	add    %al,(%eax)
     781:	00 00                	add    %al,(%eax)
     783:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     787:	00 06                	add    %al,(%esi)
     789:	00 00                	add    %al,(%eax)
     78b:	00 00                	add    %al,(%eax)
     78d:	00 00                	add    %al,(%eax)
     78f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     793:	00 0a                	add    %cl,(%edx)
     795:	00 00                	add    %al,(%eax)
     797:	00 00                	add    %al,(%eax)
     799:	00 00                	add    %al,(%eax)
     79b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     79f:	00 0f                	add    %cl,(%edi)
     7a1:	00 00                	add    %al,(%eax)
     7a3:	00 00                	add    %al,(%eax)
     7a5:	00 00                	add    %al,(%eax)
     7a7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     7ab:	00 12                	add    %dl,(%edx)
     7ad:	00 00                	add    %al,(%eax)
     7af:	00 00                	add    %al,(%eax)
     7b1:	00 00                	add    %al,(%eax)
     7b3:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     7b7:	00 15 00 00 00 00    	add    %dl,0x0
     7bd:	00 00                	add    %al,(%eax)
     7bf:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     7c3:	00 1a                	add    %bl,(%edx)
     7c5:	00 00                	add    %al,(%eax)
     7c7:	00 00                	add    %al,(%eax)
     7c9:	00 00                	add    %al,(%eax)
     7cb:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
     7cf:	00 2a                	add    %ch,(%edx)
     7d1:	00 00                	add    %al,(%eax)
     7d3:	00 1e                	add    %bl,(%esi)
     7d5:	07                   	pop    %es
     7d6:	00 00                	add    %al,(%eax)
     7d8:	80 00 00             	addb   $0x0,(%eax)
     7db:	00 d0                	add    %dl,%al
     7dd:	ff                   	(bad)  
     7de:	ff                   	(bad)  
     7df:	ff 00                	incl   (%eax)
     7e1:	00 00                	add    %al,(%eax)
     7e3:	00 c0                	add    %al,%al
	...
     7ed:	00 00                	add    %al,(%eax)
     7ef:	00 e0                	add    %ah,%al
     7f1:	00 00                	add    %al,(%eax)
     7f3:	00 31                	add    %dh,(%ecx)
     7f5:	00 00                	add    %al,(%eax)
     7f7:	00 5a 07             	add    %bl,0x7(%edx)
     7fa:	00 00                	add    %al,(%eax)
     7fc:	24 00                	and    $0x0,%al
     7fe:	00 00                	add    %al,(%eax)
     800:	30 01                	xor    %al,(%ecx)
     802:	28 00                	sub    %al,(%eax)
     804:	6b 07 00             	imul   $0x0,(%edi),%eax
     807:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     80d:	00 00                	add    %al,(%eax)
     80f:	00 78 07             	add    %bh,0x7(%eax)
     812:	00 00                	add    %al,(%eax)
     814:	a0 00 00 00 0c       	mov    0xc000000,%al
     819:	00 00                	add    %al,(%eax)
     81b:	00 78 06             	add    %bh,0x6(%eax)
     81e:	00 00                	add    %al,(%eax)
     820:	a0 00 00 00 10       	mov    0x10000000,%al
     825:	00 00                	add    %al,(%eax)
     827:	00 85 07 00 00 a0    	add    %al,-0x5ffffff9(%ebp)
     82d:	00 00                	add    %al,(%eax)
     82f:	00 14 00             	add    %dl,(%eax,%eax,1)
     832:	00 00                	add    %al,(%eax)
     834:	8f 07                	popl   (%edi)
     836:	00 00                	add    %al,(%eax)
     838:	a0 00 00 00 18       	mov    0x18000000,%al
     83d:	00 00                	add    %al,(%eax)
     83f:	00 99 07 00 00 a0    	add    %bl,-0x5ffffff9(%ecx)
     845:	00 00                	add    %al,(%eax)
     847:	00 1c 00             	add    %bl,(%eax,%eax,1)
     84a:	00 00                	add    %al,(%eax)
     84c:	a3 07 00 00 a0       	mov    %eax,0xa0000007
     851:	00 00                	add    %al,(%eax)
     853:	00 20                	add    %ah,(%eax)
     855:	00 00                	add    %al,(%eax)
     857:	00 00                	add    %al,(%eax)
     859:	00 00                	add    %al,(%eax)
     85b:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
	...
     867:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     86b:	00 0a                	add    %cl,(%edx)
     86d:	00 00                	add    %al,(%eax)
     86f:	00 00                	add    %al,(%eax)
     871:	00 00                	add    %al,(%eax)
     873:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     877:	00 13                	add    %dl,(%ebx)
     879:	00 00                	add    %al,(%eax)
     87b:	00 00                	add    %al,(%eax)
     87d:	00 00                	add    %al,(%eax)
     87f:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     883:	00 18                	add    %bl,(%eax)
     885:	00 00                	add    %al,(%eax)
     887:	00 00                	add    %al,(%eax)
     889:	00 00                	add    %al,(%eax)
     88b:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     88f:	00 1b                	add    %bl,(%ebx)
     891:	00 00                	add    %al,(%eax)
     893:	00 00                	add    %al,(%eax)
     895:	00 00                	add    %al,(%eax)
     897:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     89b:	00 20                	add    %ah,(%eax)
     89d:	00 00                	add    %al,(%eax)
     89f:	00 00                	add    %al,(%eax)
     8a1:	00 00                	add    %al,(%eax)
     8a3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     8a7:	00 23                	add    %ah,(%ebx)
     8a9:	00 00                	add    %al,(%eax)
     8ab:	00 00                	add    %al,(%eax)
     8ad:	00 00                	add    %al,(%eax)
     8af:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     8b3:	00 26                	add    %ah,(%esi)
     8b5:	00 00                	add    %al,(%eax)
     8b7:	00 00                	add    %al,(%eax)
     8b9:	00 00                	add    %al,(%eax)
     8bb:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
     8bf:	00 2c 00             	add    %ch,(%eax,%eax,1)
     8c2:	00 00                	add    %al,(%eax)
     8c4:	ad                   	lods   %ds:(%esi),%eax
     8c5:	07                   	pop    %es
     8c6:	00 00                	add    %al,(%eax)
     8c8:	40                   	inc    %eax
     8c9:	00 00                	add    %al,(%eax)
     8cb:	00 03                	add    %al,(%ebx)
     8cd:	00 00                	add    %al,(%eax)
     8cf:	00 bb 07 00 00 40    	add    %bh,0x40000007(%ebx)
     8d5:	00 00                	add    %al,(%eax)
     8d7:	00 01                	add    %al,(%ecx)
     8d9:	00 00                	add    %al,(%eax)
     8db:	00 c5                	add    %al,%ch
     8dd:	07                   	pop    %es
     8de:	00 00                	add    %al,(%eax)
     8e0:	24 00                	and    $0x0,%al
     8e2:	00 00                	add    %al,(%eax)
     8e4:	5f                   	pop    %edi
     8e5:	01 28                	add    %ebp,(%eax)
     8e7:	00 78 06             	add    %bh,0x6(%eax)
     8ea:	00 00                	add    %al,(%eax)
     8ec:	a0 00 00 00 08       	mov    0x8000000,%al
     8f1:	00 00                	add    %al,(%eax)
     8f3:	00 85 07 00 00 a0    	add    %al,-0x5ffffff9(%ebp)
     8f9:	00 00                	add    %al,(%eax)
     8fb:	00 0c 00             	add    %cl,(%eax,%eax,1)
     8fe:	00 00                	add    %al,(%eax)
     900:	8f 07                	popl   (%edi)
     902:	00 00                	add    %al,(%eax)
     904:	a0 00 00 00 10       	mov    0x10000000,%al
     909:	00 00                	add    %al,(%eax)
     90b:	00 99 07 00 00 a0    	add    %bl,-0x5ffffff9(%ecx)
     911:	00 00                	add    %al,(%eax)
     913:	00 14 00             	add    %dl,(%eax,%eax,1)
     916:	00 00                	add    %al,(%eax)
     918:	a3 07 00 00 a0       	mov    %eax,0xa0000007
     91d:	00 00                	add    %al,(%eax)
     91f:	00 18                	add    %bl,(%eax)
     921:	00 00                	add    %al,(%eax)
     923:	00 00                	add    %al,(%eax)
     925:	00 00                	add    %al,(%eax)
     927:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
     933:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     937:	00 03                	add    %al,(%ebx)
     939:	00 00                	add    %al,(%eax)
     93b:	00 00                	add    %al,(%eax)
     93d:	00 00                	add    %al,(%eax)
     93f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     943:	00 26                	add    %ah,(%esi)
     945:	00 00                	add    %al,(%eax)
     947:	00 d5                	add    %dl,%ch
     949:	07                   	pop    %es
     94a:	00 00                	add    %al,(%eax)
     94c:	24 00                	and    $0x0,%al
     94e:	00 00                	add    %al,(%eax)
     950:	87 01                	xchg   %eax,(%ecx)
     952:	28 00                	sub    %al,(%eax)
     954:	00 00                	add    %al,(%eax)
     956:	00 00                	add    %al,(%eax)
     958:	44                   	inc    %esp
     959:	00 5f 00             	add    %bl,0x0(%edi)
	...
     964:	44                   	inc    %esp
     965:	00 66 00             	add    %ah,0x0(%esi)
     968:	03 00                	add    (%eax),%eax
     96a:	00 00                	add    %al,(%eax)
     96c:	00 00                	add    %al,(%eax)
     96e:	00 00                	add    %al,(%eax)
     970:	44                   	inc    %esp
     971:	00 68 00             	add    %ch,0x0(%eax)
     974:	18 00                	sbb    %al,(%eax)
     976:	00 00                	add    %al,(%eax)
     978:	00 00                	add    %al,(%eax)
     97a:	00 00                	add    %al,(%eax)
     97c:	44                   	inc    %esp
     97d:	00 69 00             	add    %ch,0x0(%ecx)
     980:	30 00                	xor    %al,(%eax)
     982:	00 00                	add    %al,(%eax)
     984:	00 00                	add    %al,(%eax)
     986:	00 00                	add    %al,(%eax)
     988:	44                   	inc    %esp
     989:	00 6a 00             	add    %ch,0x0(%edx)
     98c:	4b                   	dec    %ebx
     98d:	00 00                	add    %al,(%eax)
     98f:	00 00                	add    %al,(%eax)
     991:	00 00                	add    %al,(%eax)
     993:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
     997:	00 63 00             	add    %ah,0x0(%ebx)
     99a:	00 00                	add    %al,(%eax)
     99c:	00 00                	add    %al,(%eax)
     99e:	00 00                	add    %al,(%eax)
     9a0:	44                   	inc    %esp
     9a1:	00 6f 00             	add    %ch,0x0(%edi)
     9a4:	7b 00                	jnp    9a6 <bootmain-0x27f65a>
     9a6:	00 00                	add    %al,(%eax)
     9a8:	00 00                	add    %al,(%eax)
     9aa:	00 00                	add    %al,(%eax)
     9ac:	44                   	inc    %esp
     9ad:	00 70 00             	add    %dh,0x0(%eax)
     9b0:	90                   	nop
     9b1:	00 00                	add    %al,(%eax)
     9b3:	00 00                	add    %al,(%eax)
     9b5:	00 00                	add    %al,(%eax)
     9b7:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     9bb:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
     9c1:	00 00                	add    %al,(%eax)
     9c3:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     9c7:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     9cd:	00 00                	add    %al,(%eax)
     9cf:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     9d3:	00 d5                	add    %dl,%ch
     9d5:	00 00                	add    %al,(%eax)
     9d7:	00 00                	add    %al,(%eax)
     9d9:	00 00                	add    %al,(%eax)
     9db:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
     9df:	00 ea                	add    %ch,%dl
     9e1:	00 00                	add    %al,(%eax)
     9e3:	00 00                	add    %al,(%eax)
     9e5:	00 00                	add    %al,(%eax)
     9e7:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     9eb:	00 08                	add    %cl,(%eax)
     9ed:	01 00                	add    %eax,(%eax)
     9ef:	00 00                	add    %al,(%eax)
     9f1:	00 00                	add    %al,(%eax)
     9f3:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
     9f7:	00 23                	add    %ah,(%ebx)
     9f9:	01 00                	add    %eax,(%eax)
     9fb:	00 00                	add    %al,(%eax)
     9fd:	00 00                	add    %al,(%eax)
     9ff:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
     a03:	00 41 01             	add    %al,0x1(%ecx)
     a06:	00 00                	add    %al,(%eax)
     a08:	00 00                	add    %al,(%eax)
     a0a:	00 00                	add    %al,(%eax)
     a0c:	44                   	inc    %esp
     a0d:	00 7b 00             	add    %bh,0x0(%ebx)
     a10:	5f                   	pop    %edi
     a11:	01 00                	add    %eax,(%eax)
     a13:	00 e9                	add    %ch,%cl
     a15:	07                   	pop    %es
     a16:	00 00                	add    %al,(%eax)
     a18:	24 00                	and    $0x0,%al
     a1a:	00 00                	add    %al,(%eax)
     a1c:	e8 02 28 00 fd       	call   fd003223 <cursor.1329+0xfcd80f2f>
     a21:	07                   	pop    %es
     a22:	00 00                	add    %al,(%eax)
     a24:	a0 00 00 00 08       	mov    0x8000000,%al
     a29:	00 00                	add    %al,(%eax)
     a2b:	00 00                	add    %al,(%eax)
     a2d:	00 00                	add    %al,(%eax)
     a2f:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
	...
     a3b:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     a3f:	00 03                	add    %al,(%ebx)
     a41:	00 00                	add    %al,(%eax)
     a43:	00 00                	add    %al,(%eax)
     a45:	00 00                	add    %al,(%eax)
     a47:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
     a4b:	00 06                	add    %al,(%esi)
     a4d:	00 00                	add    %al,(%eax)
     a4f:	00 00                	add    %al,(%eax)
     a51:	00 00                	add    %al,(%eax)
     a53:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
     a57:	00 0d 00 00 00 00    	add    %cl,0x0
     a5d:	00 00                	add    %al,(%eax)
     a5f:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
     a63:	00 11                	add    %dl,(%ecx)
     a65:	00 00                	add    %al,(%eax)
     a67:	00 00                	add    %al,(%eax)
     a69:	00 00                	add    %al,(%eax)
     a6b:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
     a6f:	00 17                	add    %dl,(%edi)
     a71:	00 00                	add    %al,(%eax)
     a73:	00 00                	add    %al,(%eax)
     a75:	00 00                	add    %al,(%eax)
     a77:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
     a7b:	00 1d 00 00 00 12    	add    %bl,0x12000000
     a81:	08 00                	or     %al,(%eax)
     a83:	00 40 00             	add    %al,0x0(%eax)
     a86:	00 00                	add    %al,(%eax)
     a88:	00 00                	add    %al,(%eax)
     a8a:	00 00                	add    %al,(%eax)
     a8c:	20 08                	and    %cl,(%eax)
     a8e:	00 00                	add    %al,(%eax)
     a90:	24 00                	and    $0x0,%al
     a92:	00 00                	add    %al,(%eax)
     a94:	07                   	pop    %es
     a95:	03 28                	add    (%eax),%ebp
     a97:	00 33                	add    %dh,(%ebx)
     a99:	08 00                	or     %al,(%eax)
     a9b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     aa1:	00 00                	add    %al,(%eax)
     aa3:	00 40 08             	add    %al,0x8(%eax)
     aa6:	00 00                	add    %al,(%eax)
     aa8:	a0 00 00 00 0c       	mov    0xc000000,%al
     aad:	00 00                	add    %al,(%eax)
     aaf:	00 00                	add    %al,(%eax)
     ab1:	00 00                	add    %al,(%eax)
     ab3:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
	...
     abf:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     ac3:	00 0d 00 00 00 00    	add    %cl,0x0
     ac9:	00 00                	add    %al,(%eax)
     acb:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     acf:	00 0f                	add    %cl,(%edi)
     ad1:	00 00                	add    %al,(%eax)
     ad3:	00 00                	add    %al,(%eax)
     ad5:	00 00                	add    %al,(%eax)
     ad7:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
     adb:	00 11                	add    %dl,(%ecx)
     add:	00 00                	add    %al,(%eax)
     adf:	00 00                	add    %al,(%eax)
     ae1:	00 00                	add    %al,(%eax)
     ae3:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
     ae7:	00 27                	add    %ah,(%edi)
     ae9:	00 00                	add    %al,(%eax)
     aeb:	00 00                	add    %al,(%eax)
     aed:	00 00                	add    %al,(%eax)
     aef:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
     af3:	00 2d 00 00 00 00    	add    %ch,0x0
     af9:	00 00                	add    %al,(%eax)
     afb:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
     aff:	00 34 00             	add    %dh,(%eax,%eax,1)
     b02:	00 00                	add    %al,(%eax)
     b04:	00 00                	add    %al,(%eax)
     b06:	00 00                	add    %al,(%eax)
     b08:	44                   	inc    %esp
     b09:	00 a3 00 38 00 00    	add    %ah,0x3800(%ebx)
     b0f:	00 00                	add    %al,(%eax)
     b11:	00 00                	add    %al,(%eax)
     b13:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
     b17:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
     b1b:	00 00                	add    %al,(%eax)
     b1d:	00 00                	add    %al,(%eax)
     b1f:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
     b23:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
     b27:	00 4a 08             	add    %cl,0x8(%edx)
     b2a:	00 00                	add    %al,(%eax)
     b2c:	26 00 00             	add    %al,%es:(%eax)
     b2f:	00 f4                	add    %dh,%ah
     b31:	22 28                	and    (%eax),%ch
     b33:	00 82 08 00 00 40    	add    %al,0x40000008(%edx)
     b39:	00 00                	add    %al,(%eax)
     b3b:	00 00                	add    %al,(%eax)
     b3d:	00 00                	add    %al,(%eax)
     b3f:	00 8b 08 00 00 40    	add    %cl,0x40000008(%ebx)
     b45:	00 00                	add    %al,(%eax)
     b47:	00 06                	add    %al,(%esi)
     b49:	00 00                	add    %al,(%eax)
     b4b:	00 00                	add    %al,(%eax)
     b4d:	00 00                	add    %al,(%eax)
     b4f:	00 c0                	add    %al,%al
	...
     b59:	00 00                	add    %al,(%eax)
     b5b:	00 e0                	add    %ah,%al
     b5d:	00 00                	add    %al,(%eax)
     b5f:	00 50 00             	add    %dl,0x0(%eax)
     b62:	00 00                	add    %al,(%eax)
     b64:	95                   	xchg   %eax,%ebp
     b65:	08 00                	or     %al,(%eax)
     b67:	00 24 00             	add    %ah,(%eax,%eax,1)
     b6a:	00 00                	add    %al,(%eax)
     b6c:	57                   	push   %edi
     b6d:	03 28                	add    (%eax),%ebp
     b6f:	00 ab 08 00 00 a0    	add    %ch,-0x5ffffff8(%ebx)
     b75:	00 00                	add    %al,(%eax)
     b77:	00 08                	add    %cl,(%eax)
     b79:	00 00                	add    %al,(%eax)
     b7b:	00 78 07             	add    %bh,0x7(%eax)
     b7e:	00 00                	add    %al,(%eax)
     b80:	a0 00 00 00 0c       	mov    0xc000000,%al
     b85:	00 00                	add    %al,(%eax)
     b87:	00 b7 08 00 00 a0    	add    %dh,-0x5ffffff8(%edi)
     b8d:	00 00                	add    %al,(%eax)
     b8f:	00 10                	add    %dl,(%eax)
     b91:	00 00                	add    %al,(%eax)
     b93:	00 c5                	add    %al,%ch
     b95:	08 00                	or     %al,(%eax)
     b97:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     b9d:	00 00                	add    %al,(%eax)
     b9f:	00 d3                	add    %dl,%bl
     ba1:	08 00                	or     %al,(%eax)
     ba3:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     ba9:	00 00                	add    %al,(%eax)
     bab:	00 de                	add    %bl,%dh
     bad:	08 00                	or     %al,(%eax)
     baf:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
     bb5:	00 00                	add    %al,(%eax)
     bb7:	00 e9                	add    %ch,%cl
     bb9:	08 00                	or     %al,(%eax)
     bbb:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     bc1:	00 00                	add    %al,(%eax)
     bc3:	00 f4                	add    %dh,%ah
     bc5:	08 00                	or     %al,(%eax)
     bc7:	00 a0 00 00 00 24    	add    %ah,0x24000000(%eax)
     bcd:	00 00                	add    %al,(%eax)
     bcf:	00 00                	add    %al,(%eax)
     bd1:	00 00                	add    %al,(%eax)
     bd3:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
	...
     bdf:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     be3:	00 07                	add    %al,(%edi)
     be5:	00 00                	add    %al,(%eax)
     be7:	00 00                	add    %al,(%eax)
     be9:	00 00                	add    %al,(%eax)
     beb:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
     bef:	00 09                	add    %cl,(%ecx)
     bf1:	00 00                	add    %al,(%eax)
     bf3:	00 00                	add    %al,(%eax)
     bf5:	00 00                	add    %al,(%eax)
     bf7:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     bfb:	00 17                	add    %dl,(%edi)
     bfd:	00 00                	add    %al,(%eax)
     bff:	00 00                	add    %al,(%eax)
     c01:	00 00                	add    %al,(%eax)
     c03:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     c07:	00 1c 00             	add    %bl,(%eax,%eax,1)
     c0a:	00 00                	add    %al,(%eax)
     c0c:	00 00                	add    %al,(%eax)
     c0e:	00 00                	add    %al,(%eax)
     c10:	44                   	inc    %esp
     c11:	00 b8 00 1e 00 00    	add    %bh,0x1e00(%eax)
     c17:	00 00                	add    %al,(%eax)
     c19:	00 00                	add    %al,(%eax)
     c1b:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
     c1f:	00 23                	add    %ah,(%ebx)
     c21:	00 00                	add    %al,(%eax)
     c23:	00 00                	add    %al,(%eax)
     c25:	00 00                	add    %al,(%eax)
     c27:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
     c2b:	00 29                	add    %ch,(%ecx)
     c2d:	00 00                	add    %al,(%eax)
     c2f:	00 00                	add    %al,(%eax)
     c31:	00 00                	add    %al,(%eax)
     c33:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     c37:	00 2c 00             	add    %ch,(%eax,%eax,1)
     c3a:	00 00                	add    %al,(%eax)
     c3c:	00 00                	add    %al,(%eax)
     c3e:	00 00                	add    %al,(%eax)
     c40:	44                   	inc    %esp
     c41:	00 be 00 35 00 00    	add    %bh,0x3500(%esi)
     c47:	00 82 08 00 00 40    	add    %al,0x40000008(%edx)
     c4d:	00 00                	add    %al,(%eax)
     c4f:	00 02                	add    %al,(%edx)
     c51:	00 00                	add    %al,(%eax)
     c53:	00 02                	add    %al,(%edx)
     c55:	09 00                	or     %eax,(%eax)
     c57:	00 40 00             	add    %al,0x0(%eax)
     c5a:	00 00                	add    %al,(%eax)
     c5c:	06                   	push   %es
     c5d:	00 00                	add    %al,(%eax)
     c5f:	00 00                	add    %al,(%eax)
     c61:	00 00                	add    %al,(%eax)
     c63:	00 c0                	add    %al,%al
	...
     c6d:	00 00                	add    %al,(%eax)
     c6f:	00 e0                	add    %ah,%al
     c71:	00 00                	add    %al,(%eax)
     c73:	00 39                	add    %bh,(%ecx)
     c75:	00 00                	add    %al,(%eax)
     c77:	00 00                	add    %al,(%eax)
     c79:	00 00                	add    %al,(%eax)
     c7b:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
     c7f:	00 90 03 28 00 0b    	add    %dl,0xb002803(%eax)
     c85:	09 00                	or     %eax,(%eax)
     c87:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
     c8b:	00 90 03 28 00 08    	add    %dl,0x8002803(%eax)
     c91:	00 00                	add    %al,(%eax)
     c93:	00 3c 00             	add    %bh,(%eax,%eax,1)
     c96:	00 00                	add    %al,(%eax)
     c98:	00 00                	add    %al,(%eax)
     c9a:	00 00                	add    %al,(%eax)
     c9c:	17                   	pop    %ss
     c9d:	00 00                	add    %al,(%eax)
     c9f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     ca5:	00 00                	add    %al,(%eax)
     ca7:	00 41 00             	add    %al,0x0(%ecx)
     caa:	00 00                	add    %al,(%eax)
     cac:	80 00 00             	addb   $0x0,(%eax)
     caf:	00 00                	add    %al,(%eax)
     cb1:	00 00                	add    %al,(%eax)
     cb3:	00 5b 00             	add    %bl,0x0(%ebx)
     cb6:	00 00                	add    %al,(%eax)
     cb8:	80 00 00             	addb   $0x0,(%eax)
     cbb:	00 00                	add    %al,(%eax)
     cbd:	00 00                	add    %al,(%eax)
     cbf:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     cc5:	00 00                	add    %al,(%eax)
     cc7:	00 00                	add    %al,(%eax)
     cc9:	00 00                	add    %al,(%eax)
     ccb:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     cd1:	00 00                	add    %al,(%eax)
     cd3:	00 00                	add    %al,(%eax)
     cd5:	00 00                	add    %al,(%eax)
     cd7:	00 e1                	add    %ah,%cl
     cd9:	00 00                	add    %al,(%eax)
     cdb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     ce1:	00 00                	add    %al,(%eax)
     ce3:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     ce6:	00 00                	add    %al,(%eax)
     ce8:	80 00 00             	addb   $0x0,(%eax)
     ceb:	00 00                	add    %al,(%eax)
     ced:	00 00                	add    %al,(%eax)
     cef:	00 37                	add    %dh,(%edi)
     cf1:	01 00                	add    %eax,(%eax)
     cf3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     cf9:	00 00                	add    %al,(%eax)
     cfb:	00 5d 01             	add    %bl,0x1(%ebp)
     cfe:	00 00                	add    %al,(%eax)
     d00:	80 00 00             	addb   $0x0,(%eax)
     d03:	00 00                	add    %al,(%eax)
     d05:	00 00                	add    %al,(%eax)
     d07:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     d0d:	00 00                	add    %al,(%eax)
     d0f:	00 00                	add    %al,(%eax)
     d11:	00 00                	add    %al,(%eax)
     d13:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     d19:	00 00                	add    %al,(%eax)
     d1b:	00 00                	add    %al,(%eax)
     d1d:	00 00                	add    %al,(%eax)
     d1f:	00 d2                	add    %dl,%dl
     d21:	01 00                	add    %eax,(%eax)
     d23:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d29:	00 00                	add    %al,(%eax)
     d2b:	00 ec                	add    %ch,%ah
     d2d:	01 00                	add    %eax,(%eax)
     d2f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d35:	00 00                	add    %al,(%eax)
     d37:	00 07                	add    %al,(%edi)
     d39:	02 00                	add    (%eax),%al
     d3b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d41:	00 00                	add    %al,(%eax)
     d43:	00 28                	add    %ch,(%eax)
     d45:	02 00                	add    (%eax),%al
     d47:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d4d:	00 00                	add    %al,(%eax)
     d4f:	00 47 02             	add    %al,0x2(%edi)
     d52:	00 00                	add    %al,(%eax)
     d54:	80 00 00             	addb   $0x0,(%eax)
     d57:	00 00                	add    %al,(%eax)
     d59:	00 00                	add    %al,(%eax)
     d5b:	00 66 02             	add    %ah,0x2(%esi)
     d5e:	00 00                	add    %al,(%eax)
     d60:	80 00 00             	addb   $0x0,(%eax)
     d63:	00 00                	add    %al,(%eax)
     d65:	00 00                	add    %al,(%eax)
     d67:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     d6d:	00 00                	add    %al,(%eax)
     d6f:	00 00                	add    %al,(%eax)
     d71:	00 00                	add    %al,(%eax)
     d73:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     d79:	00 00                	add    %al,(%eax)
     d7b:	00 34 72             	add    %dh,(%edx,%esi,2)
     d7e:	00 00                	add    %al,(%eax)
     d80:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     d81:	02 00                	add    (%eax),%al
     d83:	00 c2                	add    %al,%dl
     d85:	00 00                	add    %al,(%eax)
     d87:	00 00                	add    %al,(%eax)
     d89:	00 00                	add    %al,(%eax)
     d8b:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     d91:	00 00                	add    %al,(%eax)
     d93:	00 37                	add    %dh,(%edi)
     d95:	53                   	push   %ebx
     d96:	00 00                	add    %al,(%eax)
     d98:	00 00                	add    %al,(%eax)
     d9a:	00 00                	add    %al,(%eax)
     d9c:	64 00 00             	add    %al,%fs:(%eax)
     d9f:	00 90 03 28 00 12    	add    %dl,0x12002803(%eax)
     da5:	09 00                	or     %eax,(%eax)
     da7:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
     dab:	00 90 03 28 00 08    	add    %dl,0x8002803(%eax)
     db1:	00 00                	add    %al,(%eax)
     db3:	00 3c 00             	add    %bh,(%eax,%eax,1)
     db6:	00 00                	add    %al,(%eax)
     db8:	00 00                	add    %al,(%eax)
     dba:	00 00                	add    %al,(%eax)
     dbc:	17                   	pop    %ss
     dbd:	00 00                	add    %al,(%eax)
     dbf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     dc5:	00 00                	add    %al,(%eax)
     dc7:	00 41 00             	add    %al,0x0(%ecx)
     dca:	00 00                	add    %al,(%eax)
     dcc:	80 00 00             	addb   $0x0,(%eax)
     dcf:	00 00                	add    %al,(%eax)
     dd1:	00 00                	add    %al,(%eax)
     dd3:	00 5b 00             	add    %bl,0x0(%ebx)
     dd6:	00 00                	add    %al,(%eax)
     dd8:	80 00 00             	addb   $0x0,(%eax)
     ddb:	00 00                	add    %al,(%eax)
     ddd:	00 00                	add    %al,(%eax)
     ddf:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     de5:	00 00                	add    %al,(%eax)
     de7:	00 00                	add    %al,(%eax)
     de9:	00 00                	add    %al,(%eax)
     deb:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     df1:	00 00                	add    %al,(%eax)
     df3:	00 00                	add    %al,(%eax)
     df5:	00 00                	add    %al,(%eax)
     df7:	00 e1                	add    %ah,%cl
     df9:	00 00                	add    %al,(%eax)
     dfb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e01:	00 00                	add    %al,(%eax)
     e03:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     e06:	00 00                	add    %al,(%eax)
     e08:	80 00 00             	addb   $0x0,(%eax)
     e0b:	00 00                	add    %al,(%eax)
     e0d:	00 00                	add    %al,(%eax)
     e0f:	00 37                	add    %dh,(%edi)
     e11:	01 00                	add    %eax,(%eax)
     e13:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e19:	00 00                	add    %al,(%eax)
     e1b:	00 5d 01             	add    %bl,0x1(%ebp)
     e1e:	00 00                	add    %al,(%eax)
     e20:	80 00 00             	addb   $0x0,(%eax)
     e23:	00 00                	add    %al,(%eax)
     e25:	00 00                	add    %al,(%eax)
     e27:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     e2d:	00 00                	add    %al,(%eax)
     e2f:	00 00                	add    %al,(%eax)
     e31:	00 00                	add    %al,(%eax)
     e33:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     e39:	00 00                	add    %al,(%eax)
     e3b:	00 00                	add    %al,(%eax)
     e3d:	00 00                	add    %al,(%eax)
     e3f:	00 d2                	add    %dl,%dl
     e41:	01 00                	add    %eax,(%eax)
     e43:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e49:	00 00                	add    %al,(%eax)
     e4b:	00 ec                	add    %ch,%ah
     e4d:	01 00                	add    %eax,(%eax)
     e4f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e55:	00 00                	add    %al,(%eax)
     e57:	00 07                	add    %al,(%edi)
     e59:	02 00                	add    (%eax),%al
     e5b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e61:	00 00                	add    %al,(%eax)
     e63:	00 28                	add    %ch,(%eax)
     e65:	02 00                	add    (%eax),%al
     e67:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e6d:	00 00                	add    %al,(%eax)
     e6f:	00 47 02             	add    %al,0x2(%edi)
     e72:	00 00                	add    %al,(%eax)
     e74:	80 00 00             	addb   $0x0,(%eax)
     e77:	00 00                	add    %al,(%eax)
     e79:	00 00                	add    %al,(%eax)
     e7b:	00 66 02             	add    %ah,0x2(%esi)
     e7e:	00 00                	add    %al,(%eax)
     e80:	80 00 00             	addb   $0x0,(%eax)
     e83:	00 00                	add    %al,(%eax)
     e85:	00 00                	add    %al,(%eax)
     e87:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     e8d:	00 00                	add    %al,(%eax)
     e8f:	00 00                	add    %al,(%eax)
     e91:	00 00                	add    %al,(%eax)
     e93:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     e99:	00 00                	add    %al,(%eax)
     e9b:	00 34 72             	add    %dh,(%edx,%esi,2)
     e9e:	00 00                	add    %al,(%eax)
     ea0:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     ea1:	02 00                	add    (%eax),%al
     ea3:	00 c2                	add    %al,%dl
     ea5:	00 00                	add    %al,(%eax)
     ea7:	00 00                	add    %al,(%eax)
     ea9:	00 00                	add    %al,(%eax)
     eab:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     eb1:	00 00                	add    %al,(%eax)
     eb3:	00 37                	add    %dh,(%edi)
     eb5:	53                   	push   %ebx
     eb6:	00 00                	add    %al,(%eax)
     eb8:	1a 09                	sbb    (%ecx),%cl
     eba:	00 00                	add    %al,(%eax)
     ebc:	24 00                	and    $0x0,%al
     ebe:	00 00                	add    %al,(%eax)
     ec0:	90                   	nop
     ec1:	03 28                	add    (%eax),%ebp
     ec3:	00 27                	add    %ah,(%edi)
     ec5:	09 00                	or     %eax,(%eax)
     ec7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     ecd:	00 00                	add    %al,(%eax)
     ecf:	00 e9                	add    %ch,%cl
     ed1:	08 00                	or     %al,(%eax)
     ed3:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
     ed9:	00 00                	add    %al,(%eax)
     edb:	00 00                	add    %al,(%eax)
     edd:	00 00                	add    %al,(%eax)
     edf:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
	...
     eeb:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     eef:	00 01                	add    %al,(%ecx)
     ef1:	00 00                	add    %al,(%eax)
     ef3:	00 00                	add    %al,(%eax)
     ef5:	00 00                	add    %al,(%eax)
     ef7:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     efb:	00 03                	add    %al,(%ebx)
     efd:	00 00                	add    %al,(%eax)
     eff:	00 00                	add    %al,(%eax)
     f01:	00 00                	add    %al,(%eax)
     f03:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f07:	00 05 00 00 00 00    	add    %al,0x0
     f0d:	00 00                	add    %al,(%eax)
     f0f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f13:	00 0a                	add    %cl,(%edx)
     f15:	00 00                	add    %al,(%eax)
     f17:	00 00                	add    %al,(%eax)
     f19:	00 00                	add    %al,(%eax)
     f1b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f1f:	00 10                	add    %dl,(%eax)
     f21:	00 00                	add    %al,(%eax)
     f23:	00 00                	add    %al,(%eax)
     f25:	00 00                	add    %al,(%eax)
     f27:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f2b:	00 13                	add    %dl,(%ebx)
     f2d:	00 00                	add    %al,(%eax)
     f2f:	00 00                	add    %al,(%eax)
     f31:	00 00                	add    %al,(%eax)
     f33:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f37:	00 16                	add    %dl,(%esi)
     f39:	00 00                	add    %al,(%eax)
     f3b:	00 00                	add    %al,(%eax)
     f3d:	00 00                	add    %al,(%eax)
     f3f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f43:	00 19                	add    %bl,(%ecx)
     f45:	00 00                	add    %al,(%eax)
     f47:	00 00                	add    %al,(%eax)
     f49:	00 00                	add    %al,(%eax)
     f4b:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
     f4f:	00 1e                	add    %bl,(%esi)
     f51:	00 00                	add    %al,(%eax)
     f53:	00 00                	add    %al,(%eax)
     f55:	00 00                	add    %al,(%eax)
     f57:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f5b:	00 22                	add    %ah,(%edx)
     f5d:	00 00                	add    %al,(%eax)
     f5f:	00 00                	add    %al,(%eax)
     f61:	00 00                	add    %al,(%eax)
     f63:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
     f67:	00 25 00 00 00 00    	add    %ah,0x0
     f6d:	00 00                	add    %al,(%eax)
     f6f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f73:	00 27                	add    %ah,(%edi)
     f75:	00 00                	add    %al,(%eax)
     f77:	00 00                	add    %al,(%eax)
     f79:	00 00                	add    %al,(%eax)
     f7b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f7f:	00 28                	add    %ch,(%eax)
     f81:	00 00                	add    %al,(%eax)
     f83:	00 00                	add    %al,(%eax)
     f85:	00 00                	add    %al,(%eax)
     f87:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     f8b:	00 2a                	add    %ch,(%edx)
     f8d:	00 00                	add    %al,(%eax)
     f8f:	00 00                	add    %al,(%eax)
     f91:	00 00                	add    %al,(%eax)
     f93:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     f97:	00 38                	add    %bh,(%eax)
     f99:	00 00                	add    %al,(%eax)
     f9b:	00 00                	add    %al,(%eax)
     f9d:	00 00                	add    %al,(%eax)
     f9f:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     fa3:	00 3a                	add    %bh,(%edx)
     fa5:	00 00                	add    %al,(%eax)
     fa7:	00 00                	add    %al,(%eax)
     fa9:	00 00                	add    %al,(%eax)
     fab:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
     faf:	00 3d 00 00 00 00    	add    %bh,0x0
     fb5:	00 00                	add    %al,(%eax)
     fb7:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     fbb:	00 3f                	add    %bh,(%edi)
     fbd:	00 00                	add    %al,(%eax)
     fbf:	00 00                	add    %al,(%eax)
     fc1:	00 00                	add    %al,(%eax)
     fc3:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     fc7:	00 41 00             	add    %al,0x0(%ecx)
     fca:	00 00                	add    %al,(%eax)
     fcc:	00 00                	add    %al,(%eax)
     fce:	00 00                	add    %al,(%eax)
     fd0:	44                   	inc    %esp
     fd1:	00 1e                	add    %bl,(%esi)
     fd3:	00 45 00             	add    %al,0x0(%ebp)
     fd6:	00 00                	add    %al,(%eax)
     fd8:	00 00                	add    %al,(%eax)
     fda:	00 00                	add    %al,(%eax)
     fdc:	44                   	inc    %esp
     fdd:	00 20                	add    %ah,(%eax)
     fdf:	00 49 00             	add    %cl,0x0(%ecx)
     fe2:	00 00                	add    %al,(%eax)
     fe4:	00 00                	add    %al,(%eax)
     fe6:	00 00                	add    %al,(%eax)
     fe8:	44                   	inc    %esp
     fe9:	00 21                	add    %ah,(%ecx)
     feb:	00 4a 00             	add    %cl,0x0(%edx)
     fee:	00 00                	add    %al,(%eax)
     ff0:	00 00                	add    %al,(%eax)
     ff2:	00 00                	add    %al,(%eax)
     ff4:	44                   	inc    %esp
     ff5:	00 24 00             	add    %ah,(%eax,%eax,1)
     ff8:	56                   	push   %esi
     ff9:	00 00                	add    %al,(%eax)
     ffb:	00 00                	add    %al,(%eax)
     ffd:	00 00                	add    %al,(%eax)
     fff:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    1003:	00 5a 00             	add    %bl,0x0(%edx)
    1006:	00 00                	add    %al,(%eax)
    1008:	34 09                	xor    $0x9,%al
    100a:	00 00                	add    %al,(%eax)
    100c:	80 00 00             	addb   $0x0,(%eax)
    100f:	00 f6                	add    %dh,%dh
    1011:	ff                   	(bad)  
    1012:	ff                   	(bad)  
    1013:	ff 6c 09 00          	ljmp   *0x0(%ecx,%ecx,1)
    1017:	00 40 00             	add    %al,0x0(%eax)
    101a:	00 00                	add    %al,(%eax)
    101c:	02 00                	add    (%eax),%al
    101e:	00 00                	add    %al,(%eax)
    1020:	79 09                	jns    102b <bootmain-0x27efd5>
    1022:	00 00                	add    %al,(%eax)
    1024:	40                   	inc    %eax
    1025:	00 00                	add    %al,(%eax)
    1027:	00 03                	add    %al,(%ebx)
    1029:	00 00                	add    %al,(%eax)
    102b:	00 00                	add    %al,(%eax)
    102d:	00 00                	add    %al,(%eax)
    102f:	00 c0                	add    %al,%al
	...
    1039:	00 00                	add    %al,(%eax)
    103b:	00 e0                	add    %ah,%al
    103d:	00 00                	add    %al,(%eax)
    103f:	00 62 00             	add    %ah,0x0(%edx)
    1042:	00 00                	add    %al,(%eax)
    1044:	84 09                	test   %cl,(%ecx)
    1046:	00 00                	add    %al,(%eax)
    1048:	24 00                	and    $0x0,%al
    104a:	00 00                	add    %al,(%eax)
    104c:	f2 03 28             	repnz add (%eax),%ebp
    104f:	00 91 09 00 00 a0    	add    %dl,-0x5ffffff7(%ecx)
    1055:	00 00                	add    %al,(%eax)
    1057:	00 08                	add    %cl,(%eax)
    1059:	00 00                	add    %al,(%eax)
    105b:	00 e9                	add    %ch,%cl
    105d:	08 00                	or     %al,(%eax)
    105f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1065:	00 00                	add    %al,(%eax)
    1067:	00 00                	add    %al,(%eax)
    1069:	00 00                	add    %al,(%eax)
    106b:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
	...
    1077:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    107b:	00 01                	add    %al,(%ecx)
    107d:	00 00                	add    %al,(%eax)
    107f:	00 00                	add    %al,(%eax)
    1081:	00 00                	add    %al,(%eax)
    1083:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    1087:	00 03                	add    %al,(%ebx)
    1089:	00 00                	add    %al,(%eax)
    108b:	00 00                	add    %al,(%eax)
    108d:	00 00                	add    %al,(%eax)
    108f:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    1093:	00 05 00 00 00 00    	add    %al,0x0
    1099:	00 00                	add    %al,(%eax)
    109b:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    109f:	00 0a                	add    %cl,(%edx)
    10a1:	00 00                	add    %al,(%eax)
    10a3:	00 00                	add    %al,(%eax)
    10a5:	00 00                	add    %al,(%eax)
    10a7:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    10ab:	00 10                	add    %dl,(%eax)
    10ad:	00 00                	add    %al,(%eax)
    10af:	00 00                	add    %al,(%eax)
    10b1:	00 00                	add    %al,(%eax)
    10b3:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    10b7:	00 13                	add    %dl,(%ebx)
    10b9:	00 00                	add    %al,(%eax)
    10bb:	00 00                	add    %al,(%eax)
    10bd:	00 00                	add    %al,(%eax)
    10bf:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    10c3:	00 18                	add    %bl,(%eax)
    10c5:	00 00                	add    %al,(%eax)
    10c7:	00 00                	add    %al,(%eax)
    10c9:	00 00                	add    %al,(%eax)
    10cb:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    10cf:	00 1b                	add    %bl,(%ebx)
    10d1:	00 00                	add    %al,(%eax)
    10d3:	00 00                	add    %al,(%eax)
    10d5:	00 00                	add    %al,(%eax)
    10d7:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    10db:	00 1e                	add    %bl,(%esi)
    10dd:	00 00                	add    %al,(%eax)
    10df:	00 00                	add    %al,(%eax)
    10e1:	00 00                	add    %al,(%eax)
    10e3:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    10e7:	00 25 00 00 00 00    	add    %ah,0x0
    10ed:	00 00                	add    %al,(%eax)
    10ef:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    10f3:	00 2c 00             	add    %ch,(%eax,%eax,1)
    10f6:	00 00                	add    %al,(%eax)
    10f8:	00 00                	add    %al,(%eax)
    10fa:	00 00                	add    %al,(%eax)
    10fc:	44                   	inc    %esp
    10fd:	00 3e                	add    %bh,(%esi)
    10ff:	00 38                	add    %bh,(%eax)
    1101:	00 00                	add    %al,(%eax)
    1103:	00 00                	add    %al,(%eax)
    1105:	00 00                	add    %al,(%eax)
    1107:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    110b:	00 3c 00             	add    %bh,(%eax,%eax,1)
    110e:	00 00                	add    %al,(%eax)
    1110:	00 00                	add    %al,(%eax)
    1112:	00 00                	add    %al,(%eax)
    1114:	44                   	inc    %esp
    1115:	00 3e                	add    %bh,(%esi)
    1117:	00 3f                	add    %bh,(%edi)
    1119:	00 00                	add    %al,(%eax)
    111b:	00 00                	add    %al,(%eax)
    111d:	00 00                	add    %al,(%eax)
    111f:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    1123:	00 41 00             	add    %al,0x0(%ecx)
    1126:	00 00                	add    %al,(%eax)
    1128:	00 00                	add    %al,(%eax)
    112a:	00 00                	add    %al,(%eax)
    112c:	44                   	inc    %esp
    112d:	00 41 00             	add    %al,0x0(%ecx)
    1130:	43                   	inc    %ebx
    1131:	00 00                	add    %al,(%eax)
    1133:	00 00                	add    %al,(%eax)
    1135:	00 00                	add    %al,(%eax)
    1137:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    113b:	00 4a 00             	add    %cl,0x0(%edx)
    113e:	00 00                	add    %al,(%eax)
    1140:	00 00                	add    %al,(%eax)
    1142:	00 00                	add    %al,(%eax)
    1144:	44                   	inc    %esp
    1145:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    1149:	00 00                	add    %al,(%eax)
    114b:	00 00                	add    %al,(%eax)
    114d:	00 00                	add    %al,(%eax)
    114f:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    1153:	00 55 00             	add    %dl,0x0(%ebp)
    1156:	00 00                	add    %al,(%eax)
    1158:	00 00                	add    %al,(%eax)
    115a:	00 00                	add    %al,(%eax)
    115c:	44                   	inc    %esp
    115d:	00 4a 00             	add    %cl,0x0(%edx)
    1160:	5a                   	pop    %edx
    1161:	00 00                	add    %al,(%eax)
    1163:	00 9e 09 00 00 80    	add    %bl,-0x7ffffff7(%esi)
    1169:	00 00                	add    %al,(%eax)
    116b:	00 e2                	add    %ah,%dl
    116d:	ff                   	(bad)  
    116e:	ff                   	(bad)  
    116f:	ff                   	(bad)  
    1170:	79 09                	jns    117b <bootmain-0x27ee85>
    1172:	00 00                	add    %al,(%eax)
    1174:	40                   	inc    %eax
    1175:	00 00                	add    %al,(%eax)
    1177:	00 02                	add    %al,(%edx)
    1179:	00 00                	add    %al,(%eax)
    117b:	00 00                	add    %al,(%eax)
    117d:	00 00                	add    %al,(%eax)
    117f:	00 c0                	add    %al,%al
    1181:	00 00                	add    %al,(%eax)
    1183:	00 00                	add    %al,(%eax)
    1185:	00 00                	add    %al,(%eax)
    1187:	00 6c 09 00          	add    %ch,0x0(%ecx,%ecx,1)
    118b:	00 40 00             	add    %al,0x0(%eax)
    118e:	00 00                	add    %al,(%eax)
    1190:	01 00                	add    %eax,(%eax)
    1192:	00 00                	add    %al,(%eax)
    1194:	00 00                	add    %al,(%eax)
    1196:	00 00                	add    %al,(%eax)
    1198:	c0 00 00             	rolb   $0x0,(%eax)
    119b:	00 2c 00             	add    %ch,(%eax,%eax,1)
    119e:	00 00                	add    %al,(%eax)
    11a0:	00 00                	add    %al,(%eax)
    11a2:	00 00                	add    %al,(%eax)
    11a4:	e0 00                	loopne 11a6 <bootmain-0x27ee5a>
    11a6:	00 00                	add    %al,(%eax)
    11a8:	38 00                	cmp    %al,(%eax)
    11aa:	00 00                	add    %al,(%eax)
    11ac:	6c                   	insb   (%dx),%es:(%edi)
    11ad:	09 00                	or     %eax,(%eax)
    11af:	00 40 00             	add    %al,0x0(%eax)
    11b2:	00 00                	add    %al,(%eax)
    11b4:	01 00                	add    %eax,(%eax)
    11b6:	00 00                	add    %al,(%eax)
    11b8:	00 00                	add    %al,(%eax)
    11ba:	00 00                	add    %al,(%eax)
    11bc:	c0 00 00             	rolb   $0x0,(%eax)
    11bf:	00 3c 00             	add    %bh,(%eax,%eax,1)
    11c2:	00 00                	add    %al,(%eax)
    11c4:	00 00                	add    %al,(%eax)
    11c6:	00 00                	add    %al,(%eax)
    11c8:	e0 00                	loopne 11ca <bootmain-0x27ee36>
    11ca:	00 00                	add    %al,(%eax)
    11cc:	3f                   	aas    
    11cd:	00 00                	add    %al,(%eax)
    11cf:	00 00                	add    %al,(%eax)
    11d1:	00 00                	add    %al,(%eax)
    11d3:	00 e0                	add    %ah,%al
    11d5:	00 00                	add    %al,(%eax)
    11d7:	00 62 00             	add    %ah,0x0(%edx)
    11da:	00 00                	add    %al,(%eax)
    11dc:	c1 09 00             	rorl   $0x0,(%ecx)
    11df:	00 24 00             	add    %ah,(%eax,%eax,1)
    11e2:	00 00                	add    %al,(%eax)
    11e4:	54                   	push   %esp
    11e5:	04 28                	add    $0x28,%al
    11e7:	00 d1                	add    %dl,%cl
    11e9:	09 00                	or     %eax,(%eax)
    11eb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    11f1:	00 00                	add    %al,(%eax)
    11f3:	00 dc                	add    %bl,%ah
    11f5:	09 00                	or     %eax,(%eax)
    11f7:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    11fd:	00 00                	add    %al,(%eax)
    11ff:	00 00                	add    %al,(%eax)
    1201:	00 00                	add    %al,(%eax)
    1203:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
	...
    120f:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    1213:	00 09                	add    %cl,(%ecx)
    1215:	00 00                	add    %al,(%eax)
    1217:	00 00                	add    %al,(%eax)
    1219:	00 00                	add    %al,(%eax)
    121b:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
    121f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1222:	00 00                	add    %al,(%eax)
    1224:	00 00                	add    %al,(%eax)
    1226:	00 00                	add    %al,(%eax)
    1228:	44                   	inc    %esp
    1229:	00 56 00             	add    %dl,0x0(%esi)
    122c:	0f 00 00             	sldt   (%eax)
    122f:	00 00                	add    %al,(%eax)
    1231:	00 00                	add    %al,(%eax)
    1233:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    1237:	00 1f                	add    %bl,(%edi)
    1239:	00 00                	add    %al,(%eax)
    123b:	00 00                	add    %al,(%eax)
    123d:	00 00                	add    %al,(%eax)
    123f:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    1243:	00 21                	add    %ah,(%ecx)
    1245:	00 00                	add    %al,(%eax)
    1247:	00 00                	add    %al,(%eax)
    1249:	00 00                	add    %al,(%eax)
    124b:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    124f:	00 24 00             	add    %ah,(%eax,%eax,1)
    1252:	00 00                	add    %al,(%eax)
    1254:	00 00                	add    %al,(%eax)
    1256:	00 00                	add    %al,(%eax)
    1258:	44                   	inc    %esp
    1259:	00 5a 00             	add    %bl,0x0(%edx)
    125c:	26 00 00             	add    %al,%es:(%eax)
    125f:	00 00                	add    %al,(%eax)
    1261:	00 00                	add    %al,(%eax)
    1263:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    1267:	00 29                	add    %ch,(%ecx)
    1269:	00 00                	add    %al,(%eax)
    126b:	00 00                	add    %al,(%eax)
    126d:	00 00                	add    %al,(%eax)
    126f:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    1273:	00 2b                	add    %ch,(%ebx)
    1275:	00 00                	add    %al,(%eax)
    1277:	00 00                	add    %al,(%eax)
    1279:	00 00                	add    %al,(%eax)
    127b:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    127f:	00 3a                	add    %bh,(%edx)
    1281:	00 00                	add    %al,(%eax)
    1283:	00 00                	add    %al,(%eax)
    1285:	00 00                	add    %al,(%eax)
    1287:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    128b:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    128f:	00 00                	add    %al,(%eax)
    1291:	00 00                	add    %al,(%eax)
    1293:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    1297:	00 52 00             	add    %dl,0x0(%edx)
    129a:	00 00                	add    %al,(%eax)
    129c:	00 00                	add    %al,(%eax)
    129e:	00 00                	add    %al,(%eax)
    12a0:	44                   	inc    %esp
    12a1:	00 63 00             	add    %ah,0x0(%ebx)
    12a4:	59                   	pop    %ecx
    12a5:	00 00                	add    %al,(%eax)
    12a7:	00 00                	add    %al,(%eax)
    12a9:	00 00                	add    %al,(%eax)
    12ab:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    12af:	00 6b 00             	add    %ch,0x0(%ebx)
    12b2:	00 00                	add    %al,(%eax)
    12b4:	00 00                	add    %al,(%eax)
    12b6:	00 00                	add    %al,(%eax)
    12b8:	44                   	inc    %esp
    12b9:	00 63 00             	add    %ah,0x0(%ebx)
    12bc:	71 00                	jno    12be <bootmain-0x27ed42>
    12be:	00 00                	add    %al,(%eax)
    12c0:	00 00                	add    %al,(%eax)
    12c2:	00 00                	add    %al,(%eax)
    12c4:	44                   	inc    %esp
    12c5:	00 64 00 78          	add    %ah,0x78(%eax,%eax,1)
    12c9:	00 00                	add    %al,(%eax)
    12cb:	00 00                	add    %al,(%eax)
    12cd:	00 00                	add    %al,(%eax)
    12cf:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    12d3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    12d9:	00 00                	add    %al,(%eax)
    12db:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    12df:	00 87 00 00 00 00    	add    %al,0x0(%edi)
    12e5:	00 00                	add    %al,(%eax)
    12e7:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    12eb:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
    12f1:	00 00                	add    %al,(%eax)
    12f3:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    12f7:	00 8f 00 00 00 00    	add    %cl,0x0(%edi)
    12fd:	00 00                	add    %al,(%eax)
    12ff:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    1303:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
    1309:	00 00                	add    %al,(%eax)
    130b:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    130f:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
    1315:	00 00                	add    %al,(%eax)
    1317:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    131b:	00 9f 00 00 00 00    	add    %bl,0x0(%edi)
    1321:	00 00                	add    %al,(%eax)
    1323:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
    1327:	00 a2 00 00 00 ea    	add    %ah,-0x16000000(%edx)
    132d:	09 00                	or     %eax,(%eax)
    132f:	00 40 00             	add    %al,0x0(%eax)
    1332:	00 00                	add    %al,(%eax)
    1334:	06                   	push   %es
    1335:	00 00                	add    %al,(%eax)
    1337:	00 fd                	add    %bh,%ch
    1339:	09 00                	or     %eax,(%eax)
    133b:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
    1341:	ff                   	(bad)  
    1342:	ff                   	(bad)  
    1343:	ff 0b                	decl   (%ebx)
    1345:	0a 00                	or     (%eax),%al
    1347:	00 40 00             	add    %al,0x0(%eax)
    134a:	00 00                	add    %al,(%eax)
    134c:	03 00                	add    (%eax),%eax
    134e:	00 00                	add    %al,(%eax)
    1350:	00 00                	add    %al,(%eax)
    1352:	00 00                	add    %al,(%eax)
    1354:	c0 00 00             	rolb   $0x0,(%eax)
	...
    135f:	00 e0                	add    %ah,%al
    1361:	00 00                	add    %al,(%eax)
    1363:	00 aa 00 00 00 16    	add    %ch,0x16000000(%edx)
    1369:	0a 00                	or     (%eax),%al
    136b:	00 24 00             	add    %ah,(%eax,%eax,1)
    136e:	00 00                	add    %al,(%eax)
    1370:	fe 04 28             	incb   (%eax,%ebp,1)
    1373:	00 ab 08 00 00 a0    	add    %ch,-0x5ffffff8(%ebx)
    1379:	00 00                	add    %al,(%eax)
    137b:	00 08                	add    %cl,(%eax)
    137d:	00 00                	add    %al,(%eax)
    137f:	00 78 07             	add    %bh,0x7(%eax)
    1382:	00 00                	add    %al,(%eax)
    1384:	a0 00 00 00 0c       	mov    0xc000000,%al
    1389:	00 00                	add    %al,(%eax)
    138b:	00 27                	add    %ah,(%edi)
    138d:	0a 00                	or     (%eax),%al
    138f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1395:	00 00                	add    %al,(%eax)
    1397:	00 30                	add    %dh,(%eax)
    1399:	0a 00                	or     (%eax),%al
    139b:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    13a1:	00 00                	add    %al,(%eax)
    13a3:	00 78 06             	add    %bh,0x6(%eax)
    13a6:	00 00                	add    %al,(%eax)
    13a8:	a0 00 00 00 18       	mov    0x18000000,%al
    13ad:	00 00                	add    %al,(%eax)
    13af:	00 39                	add    %bh,(%ecx)
    13b1:	0a 00                	or     (%eax),%al
    13b3:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    13b9:	00 00                	add    %al,(%eax)
    13bb:	00 00                	add    %al,(%eax)
    13bd:	00 00                	add    %al,(%eax)
    13bf:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
	...
    13cb:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    13cf:	00 01                	add    %al,(%ecx)
    13d1:	00 00                	add    %al,(%eax)
    13d3:	00 00                	add    %al,(%eax)
    13d5:	00 00                	add    %al,(%eax)
    13d7:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    13db:	00 03                	add    %al,(%ebx)
    13dd:	00 00                	add    %al,(%eax)
    13df:	00 00                	add    %al,(%eax)
    13e1:	00 00                	add    %al,(%eax)
    13e3:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    13e7:	00 06                	add    %al,(%esi)
    13e9:	00 00                	add    %al,(%eax)
    13eb:	00 00                	add    %al,(%eax)
    13ed:	00 00                	add    %al,(%eax)
    13ef:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    13f3:	00 0b                	add    %cl,(%ebx)
    13f5:	00 00                	add    %al,(%eax)
    13f7:	00 00                	add    %al,(%eax)
    13f9:	00 00                	add    %al,(%eax)
    13fb:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    13ff:	00 10                	add    %dl,(%eax)
    1401:	00 00                	add    %al,(%eax)
    1403:	00 00                	add    %al,(%eax)
    1405:	00 00                	add    %al,(%eax)
    1407:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    140b:	00 23                	add    %ah,(%ebx)
    140d:	00 00                	add    %al,(%eax)
    140f:	00 00                	add    %al,(%eax)
    1411:	00 00                	add    %al,(%eax)
    1413:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    1417:	00 26                	add    %ah,(%esi)
    1419:	00 00                	add    %al,(%eax)
    141b:	00 00                	add    %al,(%eax)
    141d:	00 00                	add    %al,(%eax)
    141f:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1423:	00 28                	add    %ch,(%eax)
    1425:	00 00                	add    %al,(%eax)
    1427:	00 00                	add    %al,(%eax)
    1429:	00 00                	add    %al,(%eax)
    142b:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    142f:	00 34 00             	add    %dh,(%eax,%eax,1)
    1432:	00 00                	add    %al,(%eax)
    1434:	00 00                	add    %al,(%eax)
    1436:	00 00                	add    %al,(%eax)
    1438:	44                   	inc    %esp
    1439:	00 9a 00 3a 00 00    	add    %bl,0x3a00(%edx)
    143f:	00 00                	add    %al,(%eax)
    1441:	00 00                	add    %al,(%eax)
    1443:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    1447:	00 40 00             	add    %al,0x0(%eax)
    144a:	00 00                	add    %al,(%eax)
    144c:	00 00                	add    %al,(%eax)
    144e:	00 00                	add    %al,(%eax)
    1450:	44                   	inc    %esp
    1451:	00 aa 00 49 00 00    	add    %ch,0x4900(%edx)
    1457:	00 45 0a             	add    %al,0xa(%ebp)
    145a:	00 00                	add    %al,(%eax)
    145c:	40                   	inc    %eax
    145d:	00 00                	add    %al,(%eax)
    145f:	00 02                	add    %al,(%edx)
    1461:	00 00                	add    %al,(%eax)
    1463:	00 50 0a             	add    %dl,0xa(%eax)
    1466:	00 00                	add    %al,(%eax)
    1468:	40                   	inc    %eax
    1469:	00 00                	add    %al,(%eax)
    146b:	00 01                	add    %al,(%ecx)
    146d:	00 00                	add    %al,(%eax)
    146f:	00 00                	add    %al,(%eax)
    1471:	00 00                	add    %al,(%eax)
    1473:	00 c0                	add    %al,%al
	...
    147d:	00 00                	add    %al,(%eax)
    147f:	00 e0                	add    %ah,%al
    1481:	00 00                	add    %al,(%eax)
    1483:	00 51 00             	add    %dl,0x0(%ecx)
    1486:	00 00                	add    %al,(%eax)
    1488:	5b                   	pop    %ebx
    1489:	0a 00                	or     (%eax),%al
    148b:	00 24 00             	add    %ah,(%eax,%eax,1)
    148e:	00 00                	add    %al,(%eax)
    1490:	4f                   	dec    %edi
    1491:	05 28 00 ab 08       	add    $0x8ab0028,%eax
    1496:	00 00                	add    %al,(%eax)
    1498:	a0 00 00 00 08       	mov    0x8000000,%al
    149d:	00 00                	add    %al,(%eax)
    149f:	00 78 07             	add    %bh,0x7(%eax)
    14a2:	00 00                	add    %al,(%eax)
    14a4:	a0 00 00 00 0c       	mov    0xc000000,%al
    14a9:	00 00                	add    %al,(%eax)
    14ab:	00 27                	add    %ah,(%edi)
    14ad:	0a 00                	or     (%eax),%al
    14af:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    14b5:	00 00                	add    %al,(%eax)
    14b7:	00 30                	add    %dh,(%eax)
    14b9:	0a 00                	or     (%eax),%al
    14bb:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    14c1:	00 00                	add    %al,(%eax)
    14c3:	00 78 06             	add    %bh,0x6(%eax)
    14c6:	00 00                	add    %al,(%eax)
    14c8:	a0 00 00 00 18       	mov    0x18000000,%al
    14cd:	00 00                	add    %al,(%eax)
    14cf:	00 39                	add    %bh,(%ecx)
    14d1:	0a 00                	or     (%eax),%al
    14d3:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    14d9:	00 00                	add    %al,(%eax)
    14db:	00 00                	add    %al,(%eax)
    14dd:	00 00                	add    %al,(%eax)
    14df:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
	...
    14eb:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    14ef:	00 08                	add    %cl,(%eax)
    14f1:	00 00                	add    %al,(%eax)
    14f3:	00 00                	add    %al,(%eax)
    14f5:	00 00                	add    %al,(%eax)
    14f7:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
    14fb:	00 0c 00             	add    %cl,(%eax,%eax,1)
    14fe:	00 00                	add    %al,(%eax)
    1500:	00 00                	add    %al,(%eax)
    1502:	00 00                	add    %al,(%eax)
    1504:	44                   	inc    %esp
    1505:	00 73 00             	add    %dh,0x0(%ebx)
    1508:	0d 00 00 00 00       	or     $0x0,%eax
    150d:	00 00                	add    %al,(%eax)
    150f:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    1513:	00 10                	add    %dl,(%eax)
    1515:	00 00                	add    %al,(%eax)
    1517:	00 00                	add    %al,(%eax)
    1519:	00 00                	add    %al,(%eax)
    151b:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    151f:	00 1a                	add    %bl,(%edx)
    1521:	00 00                	add    %al,(%eax)
    1523:	00 00                	add    %al,(%eax)
    1525:	00 00                	add    %al,(%eax)
    1527:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
    152b:	00 1e                	add    %bl,(%esi)
    152d:	00 00                	add    %al,(%eax)
    152f:	00 00                	add    %al,(%eax)
    1531:	00 00                	add    %al,(%eax)
    1533:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1537:	00 23                	add    %ah,(%ebx)
    1539:	00 00                	add    %al,(%eax)
    153b:	00 00                	add    %al,(%eax)
    153d:	00 00                	add    %al,(%eax)
    153f:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    1543:	00 2f                	add    %ch,(%edi)
    1545:	00 00                	add    %al,(%eax)
    1547:	00 00                	add    %al,(%eax)
    1549:	00 00                	add    %al,(%eax)
    154b:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    154f:	00 32                	add    %dh,(%edx)
    1551:	00 00                	add    %al,(%eax)
    1553:	00 00                	add    %al,(%eax)
    1555:	00 00                	add    %al,(%eax)
    1557:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    155b:	00 3d 00 00 00 00    	add    %bh,0x0
    1561:	00 00                	add    %al,(%eax)
    1563:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
    1567:	00 48 00             	add    %cl,0x0(%eax)
    156a:	00 00                	add    %al,(%eax)
    156c:	00 00                	add    %al,(%eax)
    156e:	00 00                	add    %al,(%eax)
    1570:	44                   	inc    %esp
    1571:	00 85 00 4b 00 00    	add    %al,0x4b00(%ebp)
    1577:	00 00                	add    %al,(%eax)
    1579:	00 00                	add    %al,(%eax)
    157b:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    157f:	00 53 00             	add    %dl,0x0(%ebx)
    1582:	00 00                	add    %al,(%eax)
    1584:	00 00                	add    %al,(%eax)
    1586:	00 00                	add    %al,(%eax)
    1588:	44                   	inc    %esp
    1589:	00 87 00 55 00 00    	add    %al,0x5500(%edi)
    158f:	00 00                	add    %al,(%eax)
    1591:	00 00                	add    %al,(%eax)
    1593:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
    1597:	00 57 00             	add    %dl,0x0(%edi)
    159a:	00 00                	add    %al,(%eax)
    159c:	00 00                	add    %al,(%eax)
    159e:	00 00                	add    %al,(%eax)
    15a0:	44                   	inc    %esp
    15a1:	00 91 00 5c 00 00    	add    %dl,0x5c00(%ecx)
    15a7:	00 82 08 00 00 40    	add    %al,0x40000008(%edx)
    15ad:	00 00                	add    %al,(%eax)
    15af:	00 03                	add    %al,(%ebx)
    15b1:	00 00                	add    %al,(%eax)
    15b3:	00 02                	add    %al,(%edx)
    15b5:	09 00                	or     %eax,(%eax)
    15b7:	00 40 00             	add    %al,0x0(%eax)
    15ba:	00 00                	add    %al,(%eax)
    15bc:	07                   	pop    %es
    15bd:	00 00                	add    %al,(%eax)
    15bf:	00 69 0a             	add    %ch,0xa(%ecx)
    15c2:	00 00                	add    %al,(%eax)
    15c4:	24 00                	and    $0x0,%al
    15c6:	00 00                	add    %al,(%eax)
    15c8:	b3 05                	mov    $0x5,%bl
    15ca:	28 00                	sub    %al,(%eax)
    15cc:	7c 0a                	jl     15d8 <bootmain-0x27ea28>
    15ce:	00 00                	add    %al,(%eax)
    15d0:	a0 00 00 00 08       	mov    0x8000000,%al
    15d5:	00 00                	add    %al,(%eax)
    15d7:	00 27                	add    %ah,(%edi)
    15d9:	0a 00                	or     (%eax),%al
    15db:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    15e1:	00 00                	add    %al,(%eax)
    15e3:	00 00                	add    %al,(%eax)
    15e5:	00 00                	add    %al,(%eax)
    15e7:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    15f3:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    15f7:	00 07                	add    %al,(%edi)
    15f9:	00 00                	add    %al,(%eax)
    15fb:	00 00                	add    %al,(%eax)
    15fd:	00 00                	add    %al,(%eax)
    15ff:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1603:	00 18                	add    %bl,(%eax)
    1605:	00 00                	add    %al,(%eax)
    1607:	00 00                	add    %al,(%eax)
    1609:	00 00                	add    %al,(%eax)
    160b:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    160f:	00 35 00 00 00 85    	add    %dh,0x85000000
    1615:	0a 00                	or     (%eax),%al
    1617:	00 80 00 00 00 e2    	add    %al,-0x1e000000(%eax)
    161d:	ff                   	(bad)  
    161e:	ff                   	(bad)  
    161f:	ff 00                	incl   (%eax)
    1621:	00 00                	add    %al,(%eax)
    1623:	00 c0                	add    %al,%al
	...
    162d:	00 00                	add    %al,(%eax)
    162f:	00 e0                	add    %ah,%al
    1631:	00 00                	add    %al,(%eax)
    1633:	00 3a                	add    %bh,(%edx)
    1635:	00 00                	add    %al,(%eax)
    1637:	00 91 0a 00 00 24    	add    %dl,0x2400000a(%ecx)
    163d:	00 00                	add    %al,(%eax)
    163f:	00 ed                	add    %ch,%ch
    1641:	05 28 00 ab 08       	add    $0x8ab0028,%eax
    1646:	00 00                	add    %al,(%eax)
    1648:	a0 00 00 00 08       	mov    0x8000000,%al
    164d:	00 00                	add    %al,(%eax)
    164f:	00 78 07             	add    %bh,0x7(%eax)
    1652:	00 00                	add    %al,(%eax)
    1654:	a0 00 00 00 0c       	mov    0xc000000,%al
    1659:	00 00                	add    %al,(%eax)
    165b:	00 27                	add    %ah,(%edi)
    165d:	0a 00                	or     (%eax),%al
    165f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1665:	00 00                	add    %al,(%eax)
    1667:	00 30                	add    %dh,(%eax)
    1669:	0a 00                	or     (%eax),%al
    166b:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1671:	00 00                	add    %al,(%eax)
    1673:	00 78 06             	add    %bh,0x6(%eax)
    1676:	00 00                	add    %al,(%eax)
    1678:	a0 00 00 00 18       	mov    0x18000000,%al
    167d:	00 00                	add    %al,(%eax)
    167f:	00 a3 0a 00 00 a0    	add    %ah,-0x5ffffff6(%ebx)
    1685:	00 00                	add    %al,(%eax)
    1687:	00 1c 00             	add    %bl,(%eax,%eax,1)
    168a:	00 00                	add    %al,(%eax)
    168c:	00 00                	add    %al,(%eax)
    168e:	00 00                	add    %al,(%eax)
    1690:	44                   	inc    %esp
    1691:	00 c6                	add    %al,%dh
	...
    169b:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    169f:	00 10                	add    %dl,(%eax)
    16a1:	00 00                	add    %al,(%eax)
    16a3:	00 00                	add    %al,(%eax)
    16a5:	00 00                	add    %al,(%eax)
    16a7:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    16ab:	00 1b                	add    %bl,(%ebx)
    16ad:	00 00                	add    %al,(%eax)
    16af:	00 00                	add    %al,(%eax)
    16b1:	00 00                	add    %al,(%eax)
    16b3:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    16b7:	00 20                	add    %ah,(%eax)
    16b9:	00 00                	add    %al,(%eax)
    16bb:	00 00                	add    %al,(%eax)
    16bd:	00 00                	add    %al,(%eax)
    16bf:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    16c3:	00 31                	add    %dh,(%ecx)
    16c5:	00 00                	add    %al,(%eax)
    16c7:	00 00                	add    %al,(%eax)
    16c9:	00 00                	add    %al,(%eax)
    16cb:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    16cf:	00 33                	add    %dh,(%ebx)
    16d1:	00 00                	add    %al,(%eax)
    16d3:	00 00                	add    %al,(%eax)
    16d5:	00 00                	add    %al,(%eax)
    16d7:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    16db:	00 38                	add    %bh,(%eax)
    16dd:	00 00                	add    %al,(%eax)
    16df:	00 00                	add    %al,(%eax)
    16e1:	00 00                	add    %al,(%eax)
    16e3:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    16e7:	00 3b                	add    %bh,(%ebx)
    16e9:	00 00                	add    %al,(%eax)
    16eb:	00 00                	add    %al,(%eax)
    16ed:	00 00                	add    %al,(%eax)
    16ef:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    16f3:	00 41 00             	add    %al,0x0(%ecx)
    16f6:	00 00                	add    %al,(%eax)
    16f8:	00 00                	add    %al,(%eax)
    16fa:	00 00                	add    %al,(%eax)
    16fc:	44                   	inc    %esp
    16fd:	00 de                	add    %bl,%dh
    16ff:	00 4a 00             	add    %cl,0x0(%edx)
    1702:	00 00                	add    %al,(%eax)
    1704:	45                   	inc    %ebp
    1705:	0a 00                	or     (%eax),%al
    1707:	00 40 00             	add    %al,0x0(%eax)
    170a:	00 00                	add    %al,(%eax)
    170c:	02 00                	add    (%eax),%al
    170e:	00 00                	add    %al,(%eax)
    1710:	50                   	push   %eax
    1711:	0a 00                	or     (%eax),%al
    1713:	00 40 00             	add    %al,0x0(%eax)
    1716:	00 00                	add    %al,(%eax)
    1718:	00 00                	add    %al,(%eax)
    171a:	00 00                	add    %al,(%eax)
    171c:	8e 06                	mov    (%esi),%es
    171e:	00 00                	add    %al,(%eax)
    1720:	40                   	inc    %eax
    1721:	00 00                	add    %al,(%eax)
    1723:	00 03                	add    %al,(%ebx)
    1725:	00 00                	add    %al,(%eax)
    1727:	00 00                	add    %al,(%eax)
    1729:	00 00                	add    %al,(%eax)
    172b:	00 c0                	add    %al,%al
	...
    1735:	00 00                	add    %al,(%eax)
    1737:	00 e0                	add    %ah,%al
    1739:	00 00                	add    %al,(%eax)
    173b:	00 50 00             	add    %dl,0x0(%eax)
    173e:	00 00                	add    %al,(%eax)
    1740:	b7 0a                	mov    $0xa,%bh
    1742:	00 00                	add    %al,(%eax)
    1744:	24 00                	and    $0x0,%al
    1746:	00 00                	add    %al,(%eax)
    1748:	3d 06 28 00 ab       	cmp    $0xab002806,%eax
    174d:	08 00                	or     %al,(%eax)
    174f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1755:	00 00                	add    %al,(%eax)
    1757:	00 78 07             	add    %bh,0x7(%eax)
    175a:	00 00                	add    %al,(%eax)
    175c:	a0 00 00 00 0c       	mov    0xc000000,%al
    1761:	00 00                	add    %al,(%eax)
    1763:	00 27                	add    %ah,(%edi)
    1765:	0a 00                	or     (%eax),%al
    1767:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    176d:	00 00                	add    %al,(%eax)
    176f:	00 30                	add    %dh,(%eax)
    1771:	0a 00                	or     (%eax),%al
    1773:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1779:	00 00                	add    %al,(%eax)
    177b:	00 78 06             	add    %bh,0x6(%eax)
    177e:	00 00                	add    %al,(%eax)
    1780:	a0 00 00 00 18       	mov    0x18000000,%al
    1785:	00 00                	add    %al,(%eax)
    1787:	00 39                	add    %bh,(%ecx)
    1789:	0a 00                	or     (%eax),%al
    178b:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    1791:	00 00                	add    %al,(%eax)
    1793:	00 00                	add    %al,(%eax)
    1795:	00 00                	add    %al,(%eax)
    1797:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
	...
    17a3:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    17a7:	00 0c 00             	add    %cl,(%eax,%eax,1)
    17aa:	00 00                	add    %al,(%eax)
    17ac:	00 00                	add    %al,(%eax)
    17ae:	00 00                	add    %al,(%eax)
    17b0:	44                   	inc    %esp
    17b1:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    17b7:	00 00                	add    %al,(%eax)
    17b9:	00 00                	add    %al,(%eax)
    17bb:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    17bf:	00 1a                	add    %bl,(%edx)
    17c1:	00 00                	add    %al,(%eax)
    17c3:	00 00                	add    %al,(%eax)
    17c5:	00 00                	add    %al,(%eax)
    17c7:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
    17cb:	00 1e                	add    %bl,(%esi)
    17cd:	00 00                	add    %al,(%eax)
    17cf:	00 00                	add    %al,(%eax)
    17d1:	00 00                	add    %al,(%eax)
    17d3:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    17d7:	00 21                	add    %ah,(%ecx)
    17d9:	00 00                	add    %al,(%eax)
    17db:	00 00                	add    %al,(%eax)
    17dd:	00 00                	add    %al,(%eax)
    17df:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    17e3:	00 25 00 00 00 00    	add    %ah,0x0
    17e9:	00 00                	add    %al,(%eax)
    17eb:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    17ef:	00 2d 00 00 00 00    	add    %ch,0x0
    17f5:	00 00                	add    %al,(%eax)
    17f7:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    17fb:	00 31                	add    %dh,(%ecx)
    17fd:	00 00                	add    %al,(%eax)
    17ff:	00 00                	add    %al,(%eax)
    1801:	00 00                	add    %al,(%eax)
    1803:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1807:	00 34 00             	add    %dh,(%eax,%eax,1)
    180a:	00 00                	add    %al,(%eax)
    180c:	00 00                	add    %al,(%eax)
    180e:	00 00                	add    %al,(%eax)
    1810:	44                   	inc    %esp
    1811:	00 bb 00 3f 00 00    	add    %bh,0x3f00(%ebx)
    1817:	00 00                	add    %al,(%eax)
    1819:	00 00                	add    %al,(%eax)
    181b:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    181f:	00 42 00             	add    %al,0x0(%edx)
    1822:	00 00                	add    %al,(%eax)
    1824:	00 00                	add    %al,(%eax)
    1826:	00 00                	add    %al,(%eax)
    1828:	44                   	inc    %esp
    1829:	00 c4                	add    %al,%ah
    182b:	00 47 00             	add    %al,0x0(%edi)
    182e:	00 00                	add    %al,(%eax)
    1830:	82                   	(bad)  
    1831:	08 00                	or     %al,(%eax)
    1833:	00 40 00             	add    %al,0x0(%eax)
    1836:	00 00                	add    %al,(%eax)
    1838:	07                   	pop    %es
    1839:	00 00                	add    %al,(%eax)
    183b:	00 02                	add    %al,(%edx)
    183d:	09 00                	or     %eax,(%eax)
    183f:	00 40 00             	add    %al,0x0(%eax)
    1842:	00 00                	add    %al,(%eax)
    1844:	06                   	push   %es
    1845:	00 00                	add    %al,(%eax)
    1847:	00 00                	add    %al,(%eax)
    1849:	00 00                	add    %al,(%eax)
    184b:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    184f:	00 8c 06 28 00 c6 0a 	add    %cl,0xac60028(%esi,%eax,1)
    1856:	00 00                	add    %al,(%eax)
    1858:	64 00 02             	add    %al,%fs:(%edx)
    185b:	00 8c 06 28 00 08 00 	add    %cl,0x80028(%esi,%eax,1)
    1862:	00 00                	add    %al,(%eax)
    1864:	3c 00                	cmp    $0x0,%al
    1866:	00 00                	add    %al,(%eax)
    1868:	00 00                	add    %al,(%eax)
    186a:	00 00                	add    %al,(%eax)
    186c:	17                   	pop    %ss
    186d:	00 00                	add    %al,(%eax)
    186f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1875:	00 00                	add    %al,(%eax)
    1877:	00 41 00             	add    %al,0x0(%ecx)
    187a:	00 00                	add    %al,(%eax)
    187c:	80 00 00             	addb   $0x0,(%eax)
    187f:	00 00                	add    %al,(%eax)
    1881:	00 00                	add    %al,(%eax)
    1883:	00 5b 00             	add    %bl,0x0(%ebx)
    1886:	00 00                	add    %al,(%eax)
    1888:	80 00 00             	addb   $0x0,(%eax)
    188b:	00 00                	add    %al,(%eax)
    188d:	00 00                	add    %al,(%eax)
    188f:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1895:	00 00                	add    %al,(%eax)
    1897:	00 00                	add    %al,(%eax)
    1899:	00 00                	add    %al,(%eax)
    189b:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    18a1:	00 00                	add    %al,(%eax)
    18a3:	00 00                	add    %al,(%eax)
    18a5:	00 00                	add    %al,(%eax)
    18a7:	00 e1                	add    %ah,%cl
    18a9:	00 00                	add    %al,(%eax)
    18ab:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    18b1:	00 00                	add    %al,(%eax)
    18b3:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    18b6:	00 00                	add    %al,(%eax)
    18b8:	80 00 00             	addb   $0x0,(%eax)
    18bb:	00 00                	add    %al,(%eax)
    18bd:	00 00                	add    %al,(%eax)
    18bf:	00 37                	add    %dh,(%edi)
    18c1:	01 00                	add    %eax,(%eax)
    18c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    18c9:	00 00                	add    %al,(%eax)
    18cb:	00 5d 01             	add    %bl,0x1(%ebp)
    18ce:	00 00                	add    %al,(%eax)
    18d0:	80 00 00             	addb   $0x0,(%eax)
    18d3:	00 00                	add    %al,(%eax)
    18d5:	00 00                	add    %al,(%eax)
    18d7:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    18dd:	00 00                	add    %al,(%eax)
    18df:	00 00                	add    %al,(%eax)
    18e1:	00 00                	add    %al,(%eax)
    18e3:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    18e9:	00 00                	add    %al,(%eax)
    18eb:	00 00                	add    %al,(%eax)
    18ed:	00 00                	add    %al,(%eax)
    18ef:	00 d2                	add    %dl,%dl
    18f1:	01 00                	add    %eax,(%eax)
    18f3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    18f9:	00 00                	add    %al,(%eax)
    18fb:	00 ec                	add    %ch,%ah
    18fd:	01 00                	add    %eax,(%eax)
    18ff:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1905:	00 00                	add    %al,(%eax)
    1907:	00 07                	add    %al,(%edi)
    1909:	02 00                	add    (%eax),%al
    190b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1911:	00 00                	add    %al,(%eax)
    1913:	00 28                	add    %ch,(%eax)
    1915:	02 00                	add    (%eax),%al
    1917:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    191d:	00 00                	add    %al,(%eax)
    191f:	00 47 02             	add    %al,0x2(%edi)
    1922:	00 00                	add    %al,(%eax)
    1924:	80 00 00             	addb   $0x0,(%eax)
    1927:	00 00                	add    %al,(%eax)
    1929:	00 00                	add    %al,(%eax)
    192b:	00 66 02             	add    %ah,0x2(%esi)
    192e:	00 00                	add    %al,(%eax)
    1930:	80 00 00             	addb   $0x0,(%eax)
    1933:	00 00                	add    %al,(%eax)
    1935:	00 00                	add    %al,(%eax)
    1937:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    193d:	00 00                	add    %al,(%eax)
    193f:	00 00                	add    %al,(%eax)
    1941:	00 00                	add    %al,(%eax)
    1943:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1949:	00 00                	add    %al,(%eax)
    194b:	00 34 72             	add    %dh,(%edx,%esi,2)
    194e:	00 00                	add    %al,(%eax)
    1950:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    1951:	02 00                	add    (%eax),%al
    1953:	00 c2                	add    %al,%dl
    1955:	00 00                	add    %al,(%eax)
    1957:	00 00                	add    %al,(%eax)
    1959:	00 00                	add    %al,(%eax)
    195b:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    1961:	00 00                	add    %al,(%eax)
    1963:	00 37                	add    %dh,(%edi)
    1965:	53                   	push   %ebx
    1966:	00 00                	add    %al,(%eax)
    1968:	cf                   	iret   
    1969:	0a 00                	or     (%eax),%al
    196b:	00 24 00             	add    %ah,(%eax,%eax,1)
    196e:	00 00                	add    %al,(%eax)
    1970:	8c 06                	mov    %es,(%esi)
    1972:	28 00                	sub    %al,(%eax)
    1974:	de 0a                	fimul  (%edx)
    1976:	00 00                	add    %al,(%eax)
    1978:	a0 00 00 00 08       	mov    0x8000000,%al
    197d:	00 00                	add    %al,(%eax)
    197f:	00 f0                	add    %dh,%al
    1981:	0a 00                	or     (%eax),%al
    1983:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1989:	00 00                	add    %al,(%eax)
    198b:	00 fd                	add    %bh,%ch
    198d:	0a 00                	or     (%eax),%al
    198f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1995:	00 00                	add    %al,(%eax)
    1997:	00 09                	add    %cl,(%ecx)
    1999:	0b 00                	or     (%eax),%eax
    199b:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    19a1:	00 00                	add    %al,(%eax)
    19a3:	00 00                	add    %al,(%eax)
    19a5:	00 00                	add    %al,(%eax)
    19a7:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
	...
    19b3:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    19b7:	00 0f                	add    %cl,(%edi)
    19b9:	00 00                	add    %al,(%eax)
    19bb:	00 00                	add    %al,(%eax)
    19bd:	00 00                	add    %al,(%eax)
    19bf:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    19c3:	00 12                	add    %dl,(%edx)
    19c5:	00 00                	add    %al,(%eax)
    19c7:	00 00                	add    %al,(%eax)
    19c9:	00 00                	add    %al,(%eax)
    19cb:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    19cf:	00 1a                	add    %bl,(%edx)
    19d1:	00 00                	add    %al,(%eax)
    19d3:	00 00                	add    %al,(%eax)
    19d5:	00 00                	add    %al,(%eax)
    19d7:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    19db:	00 20                	add    %ah,(%eax)
    19dd:	00 00                	add    %al,(%eax)
    19df:	00 00                	add    %al,(%eax)
    19e1:	00 00                	add    %al,(%eax)
    19e3:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    19e7:	00 23                	add    %ah,(%ebx)
    19e9:	00 00                	add    %al,(%eax)
    19eb:	00 00                	add    %al,(%eax)
    19ed:	00 00                	add    %al,(%eax)
    19ef:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    19f3:	00 2d 00 00 00 00    	add    %ch,0x0
    19f9:	00 00                	add    %al,(%eax)
    19fb:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    19ff:	00 2f                	add    %ch,(%edi)
    1a01:	00 00                	add    %al,(%eax)
    1a03:	00 00                	add    %al,(%eax)
    1a05:	00 00                	add    %al,(%eax)
    1a07:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1a0b:	00 32                	add    %dh,(%edx)
    1a0d:	00 00                	add    %al,(%eax)
    1a0f:	00 00                	add    %al,(%eax)
    1a11:	00 00                	add    %al,(%eax)
    1a13:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1a17:	00 35 00 00 00 00    	add    %dh,0x0
    1a1d:	00 00                	add    %al,(%eax)
    1a1f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1a23:	00 37                	add    %dh,(%edi)
    1a25:	00 00                	add    %al,(%eax)
    1a27:	00 00                	add    %al,(%eax)
    1a29:	00 00                	add    %al,(%eax)
    1a2b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1a2f:	00 3a                	add    %bh,(%edx)
    1a31:	00 00                	add    %al,(%eax)
    1a33:	00 00                	add    %al,(%eax)
    1a35:	00 00                	add    %al,(%eax)
    1a37:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1a3b:	00 40 00             	add    %al,0x0(%eax)
    1a3e:	00 00                	add    %al,(%eax)
    1a40:	00 00                	add    %al,(%eax)
    1a42:	00 00                	add    %al,(%eax)
    1a44:	44                   	inc    %esp
    1a45:	00 11                	add    %dl,(%ecx)
    1a47:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1a4b:	00 00                	add    %al,(%eax)
    1a4d:	00 00                	add    %al,(%eax)
    1a4f:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1a53:	00 46 00             	add    %al,0x0(%esi)
    1a56:	00 00                	add    %al,(%eax)
    1a58:	00 00                	add    %al,(%eax)
    1a5a:	00 00                	add    %al,(%eax)
    1a5c:	44                   	inc    %esp
    1a5d:	00 11                	add    %dl,(%ecx)
    1a5f:	00 49 00             	add    %cl,0x0(%ecx)
    1a62:	00 00                	add    %al,(%eax)
    1a64:	00 00                	add    %al,(%eax)
    1a66:	00 00                	add    %al,(%eax)
    1a68:	44                   	inc    %esp
    1a69:	00 12                	add    %dl,(%edx)
    1a6b:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1a6f:	00 00                	add    %al,(%eax)
    1a71:	00 00                	add    %al,(%eax)
    1a73:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1a77:	00 4f 00             	add    %cl,0x0(%edi)
    1a7a:	00 00                	add    %al,(%eax)
    1a7c:	17                   	pop    %ss
    1a7d:	0b 00                	or     (%eax),%eax
    1a7f:	00 40 00             	add    %al,0x0(%eax)
    1a82:	00 00                	add    %al,(%eax)
    1a84:	00 00                	add    %al,(%eax)
    1a86:	00 00                	add    %al,(%eax)
    1a88:	22 0b                	and    (%ebx),%cl
    1a8a:	00 00                	add    %al,(%eax)
    1a8c:	40                   	inc    %eax
    1a8d:	00 00                	add    %al,(%eax)
    1a8f:	00 02                	add    %al,(%edx)
    1a91:	00 00                	add    %al,(%eax)
    1a93:	00 2f                	add    %ch,(%edi)
    1a95:	0b 00                	or     (%eax),%eax
    1a97:	00 40 00             	add    %al,0x0(%eax)
    1a9a:	00 00                	add    %al,(%eax)
    1a9c:	03 00                	add    (%eax),%eax
    1a9e:	00 00                	add    %al,(%eax)
    1aa0:	3b 0b                	cmp    (%ebx),%ecx
    1aa2:	00 00                	add    %al,(%eax)
    1aa4:	40                   	inc    %eax
    1aa5:	00 00                	add    %al,(%eax)
    1aa7:	00 07                	add    %al,(%edi)
    1aa9:	00 00                	add    %al,(%eax)
    1aab:	00 49 0b             	add    %cl,0xb(%ecx)
    1aae:	00 00                	add    %al,(%eax)
    1ab0:	24 00                	and    $0x0,%al
    1ab2:	00 00                	add    %al,(%eax)
    1ab4:	e0 06                	loopne 1abc <bootmain-0x27e544>
    1ab6:	28 00                	sub    %al,(%eax)
    1ab8:	58                   	pop    %eax
    1ab9:	0b 00                	or     (%eax),%eax
    1abb:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1ac1:	00 00                	add    %al,(%eax)
    1ac3:	00 6a 0b             	add    %ch,0xb(%edx)
    1ac6:	00 00                	add    %al,(%eax)
    1ac8:	a0 00 00 00 0c       	mov    0xc000000,%al
    1acd:	00 00                	add    %al,(%eax)
    1acf:	00 78 0b             	add    %bh,0xb(%eax)
    1ad2:	00 00                	add    %al,(%eax)
    1ad4:	a0 00 00 00 10       	mov    0x10000000,%al
    1ad9:	00 00                	add    %al,(%eax)
    1adb:	00 09                	add    %cl,(%ecx)
    1add:	0b 00                	or     (%eax),%eax
    1adf:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
    1ae5:	00 00                	add    %al,(%eax)
    1ae7:	00 00                	add    %al,(%eax)
    1ae9:	00 00                	add    %al,(%eax)
    1aeb:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
	...
    1af7:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1afb:	00 03                	add    %al,(%ebx)
    1afd:	00 00                	add    %al,(%eax)
    1aff:	00 00                	add    %al,(%eax)
    1b01:	00 00                	add    %al,(%eax)
    1b03:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1b07:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1b0a:	00 00                	add    %al,(%eax)
    1b0c:	00 00                	add    %al,(%eax)
    1b0e:	00 00                	add    %al,(%eax)
    1b10:	44                   	inc    %esp
    1b11:	00 1a                	add    %bl,(%edx)
    1b13:	00 0f                	add    %cl,(%edi)
    1b15:	00 00                	add    %al,(%eax)
    1b17:	00 00                	add    %al,(%eax)
    1b19:	00 00                	add    %al,(%eax)
    1b1b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1b1f:	00 16                	add    %dl,(%esi)
    1b21:	00 00                	add    %al,(%eax)
    1b23:	00 00                	add    %al,(%eax)
    1b25:	00 00                	add    %al,(%eax)
    1b27:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1b2b:	00 19                	add    %bl,(%ecx)
    1b2d:	00 00                	add    %al,(%eax)
    1b2f:	00 00                	add    %al,(%eax)
    1b31:	00 00                	add    %al,(%eax)
    1b33:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1b37:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1b3a:	00 00                	add    %al,(%eax)
    1b3c:	00 00                	add    %al,(%eax)
    1b3e:	00 00                	add    %al,(%eax)
    1b40:	44                   	inc    %esp
    1b41:	00 1f                	add    %bl,(%edi)
    1b43:	00 20                	add    %ah,(%eax)
    1b45:	00 00                	add    %al,(%eax)
    1b47:	00 00                	add    %al,(%eax)
    1b49:	00 00                	add    %al,(%eax)
    1b4b:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    1b4f:	00 28                	add    %ch,(%eax)
    1b51:	00 00                	add    %al,(%eax)
    1b53:	00 88 0b 00 00 40    	add    %cl,0x4000000b(%eax)
    1b59:	00 00                	add    %al,(%eax)
    1b5b:	00 00                	add    %al,(%eax)
    1b5d:	00 00                	add    %al,(%eax)
    1b5f:	00 93 0b 00 00 40    	add    %dl,0x4000000b(%ebx)
    1b65:	00 00                	add    %al,(%eax)
    1b67:	00 01                	add    %al,(%ecx)
    1b69:	00 00                	add    %al,(%eax)
    1b6b:	00 a1 0b 00 00 40    	add    %ah,0x4000000b(%ecx)
    1b71:	00 00                	add    %al,(%eax)
    1b73:	00 01                	add    %al,(%ecx)
    1b75:	00 00                	add    %al,(%eax)
    1b77:	00 3b                	add    %bh,(%ebx)
    1b79:	0b 00                	or     (%eax),%eax
    1b7b:	00 40 00             	add    %al,0x0(%eax)
    1b7e:	00 00                	add    %al,(%eax)
    1b80:	02 00                	add    (%eax),%al
    1b82:	00 00                	add    %al,(%eax)
    1b84:	b1 0b                	mov    $0xb,%cl
    1b86:	00 00                	add    %al,(%eax)
    1b88:	24 00                	and    $0x0,%al
    1b8a:	00 00                	add    %al,(%eax)
    1b8c:	0a 07                	or     (%edi),%al
    1b8e:	28 00                	sub    %al,(%eax)
    1b90:	00 00                	add    %al,(%eax)
    1b92:	00 00                	add    %al,(%eax)
    1b94:	44                   	inc    %esp
    1b95:	00 28                	add    %ch,(%eax)
	...
    1b9f:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    1ba3:	00 05 00 00 00 00    	add    %al,0x0
    1ba9:	00 00                	add    %al,(%eax)
    1bab:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    1baf:	00 0a                	add    %cl,(%edx)
    1bb1:	00 00                	add    %al,(%eax)
    1bb3:	00 00                	add    %al,(%eax)
    1bb5:	00 00                	add    %al,(%eax)
    1bb7:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    1bbb:	00 19                	add    %bl,(%ecx)
    1bbd:	00 00                	add    %al,(%eax)
    1bbf:	00 00                	add    %al,(%eax)
    1bc1:	00 00                	add    %al,(%eax)
    1bc3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    1bc7:	00 24 00             	add    %ah,(%eax,%eax,1)
    1bca:	00 00                	add    %al,(%eax)
    1bcc:	00 00                	add    %al,(%eax)
    1bce:	00 00                	add    %al,(%eax)
    1bd0:	44                   	inc    %esp
    1bd1:	00 31                	add    %dh,(%ecx)
    1bd3:	00 37                	add    %dh,(%edi)
    1bd5:	00 00                	add    %al,(%eax)
    1bd7:	00 00                	add    %al,(%eax)
    1bd9:	00 00                	add    %al,(%eax)
    1bdb:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    1bdf:	00 4d 00             	add    %cl,0x0(%ebp)
    1be2:	00 00                	add    %al,(%eax)
    1be4:	00 00                	add    %al,(%eax)
    1be6:	00 00                	add    %al,(%eax)
    1be8:	44                   	inc    %esp
    1be9:	00 34 00             	add    %dh,(%eax,%eax,1)
    1bec:	69 00 00 00 00 00    	imul   $0x0,(%eax),%eax
    1bf2:	00 00                	add    %al,(%eax)
    1bf4:	44                   	inc    %esp
    1bf5:	00 19                	add    %bl,(%ecx)
    1bf7:	00 7f 00             	add    %bh,0x0(%edi)
    1bfa:	00 00                	add    %al,(%eax)
    1bfc:	00 00                	add    %al,(%eax)
    1bfe:	00 00                	add    %al,(%eax)
    1c00:	44                   	inc    %esp
    1c01:	00 1a                	add    %bl,(%edx)
    1c03:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    1c09:	00 00                	add    %al,(%eax)
    1c0b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1c0f:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    1c16:	00 00                	add    %al,(%eax)
    1c18:	44                   	inc    %esp
    1c19:	00 1f                	add    %bl,(%edi)
    1c1b:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
    1c21:	00 00                	add    %al,(%eax)
    1c23:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1c27:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
    1c2e:	00 00                	add    %al,(%eax)
    1c30:	44                   	inc    %esp
    1c31:	00 36                	add    %dh,(%esi)
    1c33:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    1c39:	00 00                	add    %al,(%eax)
    1c3b:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1c3f:	00 b2 00 00 00 00    	add    %dh,0x0(%edx)
    1c45:	00 00                	add    %al,(%eax)
    1c47:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1c4b:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
    1c51:	00 00                	add    %al,(%eax)
    1c53:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1c57:	00 c2                	add    %al,%dl
    1c59:	00 00                	add    %al,(%eax)
    1c5b:	00 00                	add    %al,(%eax)
    1c5d:	00 00                	add    %al,(%eax)
    1c5f:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1c63:	00 cc                	add    %cl,%ah
    1c65:	00 00                	add    %al,(%eax)
    1c67:	00 00                	add    %al,(%eax)
    1c69:	00 00                	add    %al,(%eax)
    1c6b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1c6f:	00 d3                	add    %dl,%bl
    1c71:	00 00                	add    %al,(%eax)
    1c73:	00 00                	add    %al,(%eax)
    1c75:	00 00                	add    %al,(%eax)
    1c77:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1c7b:	00 dc                	add    %bl,%ah
    1c7d:	00 00                	add    %al,(%eax)
    1c7f:	00 00                	add    %al,(%eax)
    1c81:	00 00                	add    %al,(%eax)
    1c83:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1c87:	00 e3                	add    %ah,%bl
    1c89:	00 00                	add    %al,(%eax)
    1c8b:	00 00                	add    %al,(%eax)
    1c8d:	00 00                	add    %al,(%eax)
    1c8f:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    1c93:	00 ea                	add    %ch,%dl
    1c95:	00 00                	add    %al,(%eax)
    1c97:	00 00                	add    %al,(%eax)
    1c99:	00 00                	add    %al,(%eax)
    1c9b:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
    1c9f:	00 f1                	add    %dh,%cl
    1ca1:	00 00                	add    %al,(%eax)
    1ca3:	00 00                	add    %al,(%eax)
    1ca5:	00 00                	add    %al,(%eax)
    1ca7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1cab:	00 f6                	add    %dh,%dh
    1cad:	00 00                	add    %al,(%eax)
    1caf:	00 00                	add    %al,(%eax)
    1cb1:	00 00                	add    %al,(%eax)
    1cb3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1cb7:	00 fc                	add    %bh,%ah
    1cb9:	00 00                	add    %al,(%eax)
    1cbb:	00 00                	add    %al,(%eax)
    1cbd:	00 00                	add    %al,(%eax)
    1cbf:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1cc3:	00 05 01 00 00 00    	add    %al,0x1
    1cc9:	00 00                	add    %al,(%eax)
    1ccb:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1ccf:	00 0e                	add    %cl,(%esi)
    1cd1:	01 00                	add    %eax,(%eax)
    1cd3:	00 00                	add    %al,(%eax)
    1cd5:	00 00                	add    %al,(%eax)
    1cd7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1cdb:	00 15 01 00 00 00    	add    %dl,0x1
    1ce1:	00 00                	add    %al,(%eax)
    1ce3:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
    1ce7:	00 1c 01             	add    %bl,(%ecx,%eax,1)
    1cea:	00 00                	add    %al,(%eax)
    1cec:	00 00                	add    %al,(%eax)
    1cee:	00 00                	add    %al,(%eax)
    1cf0:	44                   	inc    %esp
    1cf1:	00 46 00             	add    %al,0x0(%esi)
    1cf4:	30 01                	xor    %al,(%ecx)
    1cf6:	00 00                	add    %al,(%eax)
    1cf8:	00 00                	add    %al,(%eax)
    1cfa:	00 00                	add    %al,(%eax)
    1cfc:	64 00 00             	add    %al,%fs:(%eax)
    1cff:	00 3f                	add    %bh,(%edi)
    1d01:	08 28                	or     %ch,(%eax)
    1d03:	00 c5                	add    %al,%ch
    1d05:	0b 00                	or     (%eax),%eax
    1d07:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    1d0b:	00 3f                	add    %bh,(%edi)
    1d0d:	08 28                	or     %ch,(%eax)
    1d0f:	00 08                	add    %cl,(%eax)
    1d11:	00 00                	add    %al,(%eax)
    1d13:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1d16:	00 00                	add    %al,(%eax)
    1d18:	00 00                	add    %al,(%eax)
    1d1a:	00 00                	add    %al,(%eax)
    1d1c:	17                   	pop    %ss
    1d1d:	00 00                	add    %al,(%eax)
    1d1f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d25:	00 00                	add    %al,(%eax)
    1d27:	00 41 00             	add    %al,0x0(%ecx)
    1d2a:	00 00                	add    %al,(%eax)
    1d2c:	80 00 00             	addb   $0x0,(%eax)
    1d2f:	00 00                	add    %al,(%eax)
    1d31:	00 00                	add    %al,(%eax)
    1d33:	00 5b 00             	add    %bl,0x0(%ebx)
    1d36:	00 00                	add    %al,(%eax)
    1d38:	80 00 00             	addb   $0x0,(%eax)
    1d3b:	00 00                	add    %al,(%eax)
    1d3d:	00 00                	add    %al,(%eax)
    1d3f:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1d45:	00 00                	add    %al,(%eax)
    1d47:	00 00                	add    %al,(%eax)
    1d49:	00 00                	add    %al,(%eax)
    1d4b:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1d51:	00 00                	add    %al,(%eax)
    1d53:	00 00                	add    %al,(%eax)
    1d55:	00 00                	add    %al,(%eax)
    1d57:	00 e1                	add    %ah,%cl
    1d59:	00 00                	add    %al,(%eax)
    1d5b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d61:	00 00                	add    %al,(%eax)
    1d63:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1d66:	00 00                	add    %al,(%eax)
    1d68:	80 00 00             	addb   $0x0,(%eax)
    1d6b:	00 00                	add    %al,(%eax)
    1d6d:	00 00                	add    %al,(%eax)
    1d6f:	00 37                	add    %dh,(%edi)
    1d71:	01 00                	add    %eax,(%eax)
    1d73:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d79:	00 00                	add    %al,(%eax)
    1d7b:	00 5d 01             	add    %bl,0x1(%ebp)
    1d7e:	00 00                	add    %al,(%eax)
    1d80:	80 00 00             	addb   $0x0,(%eax)
    1d83:	00 00                	add    %al,(%eax)
    1d85:	00 00                	add    %al,(%eax)
    1d87:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1d8d:	00 00                	add    %al,(%eax)
    1d8f:	00 00                	add    %al,(%eax)
    1d91:	00 00                	add    %al,(%eax)
    1d93:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1d99:	00 00                	add    %al,(%eax)
    1d9b:	00 00                	add    %al,(%eax)
    1d9d:	00 00                	add    %al,(%eax)
    1d9f:	00 d2                	add    %dl,%dl
    1da1:	01 00                	add    %eax,(%eax)
    1da3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1da9:	00 00                	add    %al,(%eax)
    1dab:	00 ec                	add    %ch,%ah
    1dad:	01 00                	add    %eax,(%eax)
    1daf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1db5:	00 00                	add    %al,(%eax)
    1db7:	00 07                	add    %al,(%edi)
    1db9:	02 00                	add    (%eax),%al
    1dbb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dc1:	00 00                	add    %al,(%eax)
    1dc3:	00 28                	add    %ch,(%eax)
    1dc5:	02 00                	add    (%eax),%al
    1dc7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dcd:	00 00                	add    %al,(%eax)
    1dcf:	00 47 02             	add    %al,0x2(%edi)
    1dd2:	00 00                	add    %al,(%eax)
    1dd4:	80 00 00             	addb   $0x0,(%eax)
    1dd7:	00 00                	add    %al,(%eax)
    1dd9:	00 00                	add    %al,(%eax)
    1ddb:	00 66 02             	add    %ah,0x2(%esi)
    1dde:	00 00                	add    %al,(%eax)
    1de0:	80 00 00             	addb   $0x0,(%eax)
    1de3:	00 00                	add    %al,(%eax)
    1de5:	00 00                	add    %al,(%eax)
    1de7:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1ded:	00 00                	add    %al,(%eax)
    1def:	00 00                	add    %al,(%eax)
    1df1:	00 00                	add    %al,(%eax)
    1df3:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1df9:	00 00                	add    %al,(%eax)
    1dfb:	00 34 72             	add    %dh,(%edx,%esi,2)
    1dfe:	00 00                	add    %al,(%eax)
    1e00:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    1e01:	02 00                	add    (%eax),%al
    1e03:	00 c2                	add    %al,%dl
    1e05:	00 00                	add    %al,(%eax)
    1e07:	00 00                	add    %al,(%eax)
    1e09:	00 00                	add    %al,(%eax)
    1e0b:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    1e11:	00 00                	add    %al,(%eax)
    1e13:	00 37                	add    %dh,(%edi)
    1e15:	53                   	push   %ebx
    1e16:	00 00                	add    %al,(%eax)
    1e18:	cb                   	lret   
    1e19:	0b 00                	or     (%eax),%eax
    1e1b:	00 24 00             	add    %ah,(%eax,%eax,1)
    1e1e:	00 00                	add    %al,(%eax)
    1e20:	3f                   	aas    
    1e21:	08 28                	or     %ch,(%eax)
    1e23:	00 00                	add    %al,(%eax)
    1e25:	00 00                	add    %al,(%eax)
    1e27:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1e2b:	00 00                	add    %al,(%eax)
    1e2d:	00 00                	add    %al,(%eax)
    1e2f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    1e35:	00 00                	add    %al,(%eax)
    1e37:	00 40 08             	add    %al,0x8(%eax)
    1e3a:	28 00                	sub    %al,(%eax)
    1e3c:	00 00                	add    %al,(%eax)
    1e3e:	00 00                	add    %al,(%eax)
    1e40:	44                   	inc    %esp
    1e41:	00 5c 00 01          	add    %bl,0x1(%eax,%eax,1)
    1e45:	00 00                	add    %al,(%eax)
    1e47:	00 c5                	add    %al,%ch
    1e49:	0b 00                	or     (%eax),%eax
    1e4b:	00 84 00 00 00 45 08 	add    %al,0x8450000(%eax,%eax,1)
    1e52:	28 00                	sub    %al,(%eax)
    1e54:	00 00                	add    %al,(%eax)
    1e56:	00 00                	add    %al,(%eax)
    1e58:	44                   	inc    %esp
    1e59:	00 17                	add    %dl,(%edi)
    1e5b:	00 06                	add    %al,(%esi)
    1e5d:	00 00                	add    %al,(%eax)
    1e5f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    1e65:	00 00                	add    %al,(%eax)
    1e67:	00 47 08             	add    %al,0x8(%edi)
    1e6a:	28 00                	sub    %al,(%eax)
    1e6c:	00 00                	add    %al,(%eax)
    1e6e:	00 00                	add    %al,(%eax)
    1e70:	44                   	inc    %esp
    1e71:	00 5c 00 08          	add    %bl,0x8(%eax,%eax,1)
    1e75:	00 00                	add    %al,(%eax)
    1e77:	00 c5                	add    %al,%ch
    1e79:	0b 00                	or     (%eax),%eax
    1e7b:	00 84 00 00 00 77 08 	add    %al,0x8770000(%eax,%eax,1)
    1e82:	28 00                	sub    %al,(%eax)
    1e84:	00 00                	add    %al,(%eax)
    1e86:	00 00                	add    %al,(%eax)
    1e88:	44                   	inc    %esp
    1e89:	00 5d 00             	add    %bl,0x0(%ebp)
    1e8c:	38 00                	cmp    %al,(%eax)
    1e8e:	00 00                	add    %al,(%eax)
    1e90:	dc 0b                	fmull  (%ebx)
    1e92:	00 00                	add    %al,(%eax)
    1e94:	24 00                	and    $0x0,%al
    1e96:	00 00                	add    %al,(%eax)
    1e98:	79 08                	jns    1ea2 <bootmain-0x27e15e>
    1e9a:	28 00                	sub    %al,(%eax)
    1e9c:	f1                   	icebp  
    1e9d:	0b 00                	or     (%eax),%eax
    1e9f:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1ea5:	00 00                	add    %al,(%eax)
    1ea7:	00 00                	add    %al,(%eax)
    1ea9:	00 00                	add    %al,(%eax)
    1eab:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
	...
    1eb7:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    1ebb:	00 06                	add    %al,(%esi)
    1ebd:	00 00                	add    %al,(%eax)
    1ebf:	00 00                	add    %al,(%eax)
    1ec1:	00 00                	add    %al,(%eax)
    1ec3:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1ec7:	00 18                	add    %bl,(%eax)
    1ec9:	00 00                	add    %al,(%eax)
    1ecb:	00 00                	add    %al,(%eax)
    1ecd:	00 00                	add    %al,(%eax)
    1ecf:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    1ed3:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1ed6:	00 00                	add    %al,(%eax)
    1ed8:	00 00                	add    %al,(%eax)
    1eda:	00 00                	add    %al,(%eax)
    1edc:	64 00 00             	add    %al,%fs:(%eax)
    1edf:	00 b8 08 28 00 04    	add    %bh,0x4002808(%eax)
    1ee5:	0c 00                	or     $0x0,%al
    1ee7:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    1eeb:	00 b8 08 28 00 14    	add    %bh,0x14002808(%eax)
    1ef1:	0c 00                	or     $0x0,%al
    1ef3:	00 84 00 00 00 b8 08 	add    %al,0x8b80000(%eax,%eax,1)
    1efa:	28 00                	sub    %al,(%eax)
    1efc:	00 00                	add    %al,(%eax)
    1efe:	00 00                	add    %al,(%eax)
    1f00:	44                   	inc    %esp
    1f01:	00 06                	add    %al,(%esi)
    1f03:	00 b8 08 28 00 00    	add    %bh,0x2808(%eax)
    1f09:	00 00                	add    %al,(%eax)
    1f0b:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1f0f:	00 ba 08 28 00 00    	add    %bh,0x2808(%edx)
    1f15:	00 00                	add    %al,(%eax)
    1f17:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1f1b:	00 bc 08 28 00 00 00 	add    %bh,0x28(%eax,%ecx,1)
    1f22:	00 00                	add    %al,(%eax)
    1f24:	44                   	inc    %esp
    1f25:	00 09                	add    %cl,(%ecx)
    1f27:	00 bd 08 28 00 00    	add    %bh,0x2808(%ebp)
    1f2d:	00 00                	add    %al,(%eax)
    1f2f:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1f33:	00 bf 08 28 00 00    	add    %bh,0x2808(%edi)
    1f39:	00 00                	add    %al,(%eax)
    1f3b:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    1f3f:	00 c0                	add    %al,%al
    1f41:	08 28                	or     %ch,(%eax)
    1f43:	00 00                	add    %al,(%eax)
    1f45:	00 00                	add    %al,(%eax)
    1f47:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1f4b:	00 c3                	add    %al,%bl
    1f4d:	08 28                	or     %ch,(%eax)
    1f4f:	00 00                	add    %al,(%eax)
    1f51:	00 00                	add    %al,(%eax)
    1f53:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1f57:	00 c5                	add    %al,%ch
    1f59:	08 28                	or     %ch,(%eax)
    1f5b:	00 00                	add    %al,(%eax)
    1f5d:	00 00                	add    %al,(%eax)
    1f5f:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1f63:	00 c7                	add    %al,%bh
    1f65:	08 28                	or     %ch,(%eax)
    1f67:	00 00                	add    %al,(%eax)
    1f69:	00 00                	add    %al,(%eax)
    1f6b:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1f6f:	00 cc                	add    %cl,%ah
    1f71:	08 28                	or     %ch,(%eax)
    1f73:	00 00                	add    %al,(%eax)
    1f75:	00 00                	add    %al,(%eax)
    1f77:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1f7b:	00 cd                	add    %cl,%ch
    1f7d:	08 28                	or     %ch,(%eax)
    1f7f:	00 00                	add    %al,(%eax)
    1f81:	00 00                	add    %al,(%eax)
    1f83:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1f87:	00 ce                	add    %cl,%dh
    1f89:	08 28                	or     %ch,(%eax)
    1f8b:	00 00                	add    %al,(%eax)
    1f8d:	00 00                	add    %al,(%eax)
    1f8f:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    1f93:	00 d0                	add    %dl,%al
    1f95:	08 28                	or     %ch,(%eax)
    1f97:	00 00                	add    %al,(%eax)
    1f99:	00 00                	add    %al,(%eax)
    1f9b:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1f9f:	00 d2                	add    %dl,%dl
    1fa1:	08 28                	or     %ch,(%eax)
    1fa3:	00 00                	add    %al,(%eax)
    1fa5:	00 00                	add    %al,(%eax)
    1fa7:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    1fab:	00 d3                	add    %dl,%bl
    1fad:	08 28                	or     %ch,(%eax)
    1faf:	00 00                	add    %al,(%eax)
    1fb1:	00 00                	add    %al,(%eax)
    1fb3:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1fb7:	00 d8                	add    %bl,%al
    1fb9:	08 28                	or     %ch,(%eax)
    1fbb:	00 00                	add    %al,(%eax)
    1fbd:	00 00                	add    %al,(%eax)
    1fbf:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    1fc3:	00 dd                	add    %bl,%ch
    1fc5:	08 28                	or     %ch,(%eax)
    1fc7:	00 00                	add    %al,(%eax)
    1fc9:	00 00                	add    %al,(%eax)
    1fcb:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1fcf:	00 e2                	add    %ah,%dl
    1fd1:	08 28                	or     %ch,(%eax)
    1fd3:	00 00                	add    %al,(%eax)
    1fd5:	00 00                	add    %al,(%eax)
    1fd7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1fdb:	00 e3                	add    %ah,%bl
    1fdd:	08 28                	or     %ch,(%eax)
    1fdf:	00 00                	add    %al,(%eax)
    1fe1:	00 00                	add    %al,(%eax)
    1fe3:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    1fe7:	00 e8                	add    %ch,%al
    1fe9:	08 28                	or     %ch,(%eax)
    1feb:	00 00                	add    %al,(%eax)
    1fed:	00 00                	add    %al,(%eax)
    1fef:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1ff3:	00 ed                	add    %ch,%ch
    1ff5:	08 28                	or     %ch,(%eax)
    1ff7:	00 00                	add    %al,(%eax)
    1ff9:	00 00                	add    %al,(%eax)
    1ffb:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1fff:	00 f2                	add    %dh,%dl
    2001:	08 28                	or     %ch,(%eax)
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
 411:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 414:	74 5f                	je     475 <bootmain-0x27fb8b>
 416:	69 6e 66 6f 3a 54 28 	imul   $0x28543a6f,0x66(%esi),%ebp
 41d:	31 2c 31             	xor    %ebp,(%ecx,%esi,1)
 420:	29 3d 73 31 32 63    	sub    %edi,0x63323173
 426:	79 6c                	jns    494 <bootmain-0x27fb6c>
 428:	69 6e 64 65 72 3a 28 	imul   $0x283a7265,0x64(%esi),%ebp
 42f:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 432:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
 435:	2c 38                	sub    $0x38,%al
 437:	3b 6c 65 64          	cmp    0x64(%ebp,%eiz,2),%ebp
 43b:	3a 28                	cmp    (%eax),%ch
 43d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 440:	29 2c 38             	sub    %ebp,(%eax,%edi,1)
 443:	2c 38                	sub    $0x38,%al
 445:	3b 63 6f             	cmp    0x6f(%ebx),%esp
 448:	6c                   	insb   (%dx),%es:(%edi)
 449:	6f                   	outsl  %ds:(%esi),(%dx)
 44a:	72 5f                	jb     4ab <bootmain-0x27fb55>
 44c:	6d                   	insl   (%dx),%es:(%edi)
 44d:	6f                   	outsl  %ds:(%esi),(%dx)
 44e:	64 65 3a 28          	fs cmp %fs:%gs:(%eax),%ch
 452:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 455:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
 458:	36                   	ss
 459:	2c 38                	sub    $0x38,%al
 45b:	3b 72 65             	cmp    0x65(%edx),%esi
 45e:	73 65                	jae    4c5 <bootmain-0x27fb3b>
 460:	72 76                	jb     4d8 <bootmain-0x27fb28>
 462:	65 64 3a 28          	gs cmp %fs:%gs:(%eax),%ch
 466:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 469:	29 2c 32             	sub    %ebp,(%edx,%esi,1)
 46c:	34 2c                	xor    $0x2c,%al
 46e:	38 3b                	cmp    %bh,(%ebx)
 470:	78 73                	js     4e5 <bootmain-0x27fb1b>
 472:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
 479:	38 29                	cmp    %ch,(%ecx)
 47b:	2c 33                	sub    $0x33,%al
 47d:	32 2c 31             	xor    (%ecx,%esi,1),%ch
 480:	36 3b 79 73          	cmp    %ss:0x73(%ecx),%edi
 484:	69 7a 65 3a 28 30 2c 	imul   $0x2c30283a,0x65(%edx),%edi
 48b:	38 29                	cmp    %ch,(%ecx)
 48d:	2c 34                	sub    $0x34,%al
 48f:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
 492:	36 3b 76 72          	cmp    %ss:0x72(%esi),%esi
 496:	61                   	popa   
 497:	6d                   	insl   (%dx),%es:(%edi)
 498:	3a 28                	cmp    (%eax),%ch
 49a:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 49d:	29 3d 2a 28 30 2c    	sub    %edi,0x2c30282a
 4a3:	32 29                	xor    (%ecx),%ch
 4a5:	2c 36                	sub    $0x36,%al
 4a7:	34 2c                	xor    $0x2c,%al
 4a9:	33 32                	xor    (%edx),%esi
 4ab:	3b 3b                	cmp    (%ebx),%edi
 4ad:	00 47 44             	add    %al,0x44(%edi)
 4b0:	54                   	push   %esp
 4b1:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
 4b5:	2c 33                	sub    $0x33,%al
 4b7:	29 3d 73 38 6c 69    	sub    %edi,0x696c3873
 4bd:	6d                   	insl   (%dx),%es:(%edi)
 4be:	69 74 5f 6c 6f 77 3a 	imul   $0x283a776f,0x6c(%edi,%ebx,2),%esi
 4c5:	28 
 4c6:	30 2c 38             	xor    %ch,(%eax,%edi,1)
 4c9:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
 4cc:	2c 31                	sub    $0x31,%al
 4ce:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
 4d2:	73 65                	jae    539 <bootmain-0x27fac7>
 4d4:	5f                   	pop    %edi
 4d5:	6c                   	insb   (%dx),%es:(%edi)
 4d6:	6f                   	outsl  %ds:(%esi),(%dx)
 4d7:	77 3a                	ja     513 <bootmain-0x27faed>
 4d9:	28 30                	sub    %dh,(%eax)
 4db:	2c 38                	sub    $0x38,%al
 4dd:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
 4e0:	36                   	ss
 4e1:	2c 31                	sub    $0x31,%al
 4e3:	36 3b 62 61          	cmp    %ss:0x61(%edx),%esp
 4e7:	73 65                	jae    54e <bootmain-0x27fab2>
 4e9:	5f                   	pop    %edi
 4ea:	6d                   	insl   (%dx),%es:(%edi)
 4eb:	69 64 3a 28 30 2c 32 	imul   $0x29322c30,0x28(%edx,%edi,1),%esp
 4f2:	29 
 4f3:	2c 33                	sub    $0x33,%al
 4f5:	32 2c 38             	xor    (%eax,%edi,1),%ch
 4f8:	3b 61 63             	cmp    0x63(%ecx),%esp
 4fb:	63 65 73             	arpl   %sp,0x73(%ebp)
 4fe:	73 5f                	jae    55f <bootmain-0x27faa1>
 500:	72 69                	jb     56b <bootmain-0x27fa95>
 502:	67 68 74 3a 28 30    	addr16 push $0x30283a74
 508:	2c 32                	sub    $0x32,%al
 50a:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
 50d:	30 2c 38             	xor    %ch,(%eax,%edi,1)
 510:	3b 6c 69 6d          	cmp    0x6d(%ecx,%ebp,2),%ebp
 514:	69 74 5f 68 69 67 68 	imul   $0x3a686769,0x68(%edi,%ebx,2),%esi
 51b:	3a 
 51c:	28 30                	sub    %dh,(%eax)
 51e:	2c 32                	sub    $0x32,%al
 520:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
 523:	38 2c 38             	cmp    %ch,(%eax,%edi,1)
 526:	3b 62 61             	cmp    0x61(%edx),%esp
 529:	73 65                	jae    590 <bootmain-0x27fa70>
 52b:	5f                   	pop    %edi
 52c:	68 69 67 68 3a       	push   $0x3a686769
 531:	28 30                	sub    %dh,(%eax)
 533:	2c 32                	sub    $0x32,%al
 535:	29 2c 35 36 2c 38 3b 	sub    %ebp,0x3b382c36(,%esi,1)
 53c:	3b 00                	cmp    (%eax),%eax
 53e:	49                   	dec    %ecx
 53f:	44                   	inc    %esp
 540:	54                   	push   %esp
 541:	3a 54 28 31          	cmp    0x31(%eax,%ebp,1),%dl
 545:	2c 34                	sub    $0x34,%al
 547:	29 3d 73 38 6f 66    	sub    %edi,0x666f3873
 54d:	66                   	data16
 54e:	73 65                	jae    5b5 <bootmain-0x27fa4b>
 550:	74 5f                	je     5b1 <bootmain-0x27fa4f>
 552:	6c                   	insb   (%dx),%es:(%edi)
 553:	6f                   	outsl  %ds:(%esi),(%dx)
 554:	77 3a                	ja     590 <bootmain-0x27fa70>
 556:	28 30                	sub    %dh,(%eax)
 558:	2c 38                	sub    $0x38,%al
 55a:	29 2c 30             	sub    %ebp,(%eax,%esi,1)
 55d:	2c 31                	sub    $0x31,%al
 55f:	36 3b 73 65          	cmp    %ss:0x65(%ebx),%esi
 563:	6c                   	insb   (%dx),%es:(%edi)
 564:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
 569:	3a 28                	cmp    (%eax),%ch
 56b:	30 2c 38             	xor    %ch,(%eax,%edi,1)
 56e:	29 2c 31             	sub    %ebp,(%ecx,%esi,1)
 571:	36                   	ss
 572:	2c 31                	sub    $0x31,%al
 574:	36 3b 64 77 5f       	cmp    %ss:0x5f(%edi,%esi,2),%esp
 579:	63 6f 75             	arpl   %bp,0x75(%edi)
 57c:	6e                   	outsb  %ds:(%esi),(%dx)
 57d:	74 3a                	je     5b9 <bootmain-0x27fa47>
 57f:	28 30                	sub    %dh,(%eax)
 581:	2c 32                	sub    $0x32,%al
 583:	29 2c 33             	sub    %ebp,(%ebx,%esi,1)
 586:	32 2c 38             	xor    (%eax,%edi,1),%ch
 589:	3b 61 63             	cmp    0x63(%ecx),%esp
 58c:	63 65 73             	arpl   %sp,0x73(%ebp)
 58f:	73 5f                	jae    5f0 <bootmain-0x27fa10>
 591:	72 69                	jb     5fc <bootmain-0x27fa04>
 593:	67 68 74 3a 28 30    	addr16 push $0x30283a74
 599:	2c 32                	sub    $0x32,%al
 59b:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
 59e:	30 2c 38             	xor    %ch,(%eax,%edi,1)
 5a1:	3b 6f 66             	cmp    0x66(%edi),%ebp
 5a4:	66                   	data16
 5a5:	73 65                	jae    60c <bootmain-0x27f9f4>
 5a7:	74 5f                	je     608 <bootmain-0x27f9f8>
 5a9:	68 69 67 68 3a       	push   $0x3a686769
 5ae:	28 30                	sub    %dh,(%eax)
 5b0:	2c 38                	sub    $0x38,%al
 5b2:	29 2c 34             	sub    %ebp,(%esp,%esi,1)
 5b5:	38 2c 31             	cmp    %ch,(%ecx,%esi,1)
 5b8:	36 3b 3b             	cmp    %ss:(%ebx),%edi
 5bb:	00 62 6f             	add    %ah,0x6f(%edx)
 5be:	6f                   	outsl  %ds:(%esi),(%dx)
 5bf:	74 6d                	je     62e <bootmain-0x27f9d2>
 5c1:	61                   	popa   
 5c2:	69 6e 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%esi),%ebp
 5c9:	31 38                	xor    %edi,(%eax)
 5cb:	29 00                	sub    %eax,(%eax)
 5cd:	6d                   	insl   (%dx),%es:(%edi)
 5ce:	6f                   	outsl  %ds:(%esi),(%dx)
 5cf:	75 73                	jne    644 <bootmain-0x27f9bc>
 5d1:	65                   	gs
 5d2:	70 69                	jo     63d <bootmain-0x27f9c3>
 5d4:	63 3a                	arpl   %di,(%edx)
 5d6:	28 30                	sub    %dh,(%eax)
 5d8:	2c 31                	sub    $0x31,%al
 5da:	39 29                	cmp    %ebp,(%ecx)
 5dc:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 5e1:	2c 32                	sub    $0x32,%al
 5e3:	30 29                	xor    %ch,(%ecx)
 5e5:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 5ea:	32 30                	xor    (%eax),%dh
 5ec:	29 3b                	sub    %edi,(%ebx)
 5ee:	30 3b                	xor    %bh,(%ebx)
 5f0:	34 32                	xor    $0x32,%al
 5f2:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 5f5:	36                   	ss
 5f6:	37                   	aaa    
 5f7:	32 39                	xor    (%ecx),%bh
 5f9:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 5fe:	32 35 35 3b 28 30    	xor    0x30283b35,%dh
 604:	2c 32                	sub    $0x32,%al
 606:	29 00                	sub    %eax,(%eax)
 608:	41                   	inc    %ecx
 609:	53                   	push   %ebx
 60a:	43                   	inc    %ebx
 60b:	49                   	dec    %ecx
 60c:	49                   	dec    %ecx
 60d:	5f                   	pop    %edi
 60e:	54                   	push   %esp
 60f:	61                   	popa   
 610:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
 614:	47                   	inc    %edi
 615:	28 30                	sub    %dh,(%eax)
 617:	2c 32                	sub    $0x32,%al
 619:	31 29                	xor    %ebp,(%ecx)
 61b:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 620:	2c 32                	sub    $0x32,%al
 622:	30 29                	xor    %ch,(%ecx)
 624:	3b 30                	cmp    (%eax),%esi
 626:	3b 32                	cmp    (%edx),%esi
 628:	32 37                	xor    (%edi),%dh
 62a:	39 3b                	cmp    %edi,(%ebx)
 62c:	28 30                	sub    %dh,(%eax)
 62e:	2c 39                	sub    $0x39,%al
 630:	29 00                	sub    %eax,(%eax)
 632:	46                   	inc    %esi
 633:	6f                   	outsl  %ds:(%esi),(%dx)
 634:	6e                   	outsb  %ds:(%esi),(%dx)
 635:	74 38                	je     66f <bootmain-0x27f991>
 637:	78 31                	js     66a <bootmain-0x27f996>
 639:	36 3a 47 28          	cmp    %ss:0x28(%edi),%al
 63d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 640:	32 29                	xor    (%ecx),%ch
 642:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 647:	2c 32                	sub    $0x32,%al
 649:	30 29                	xor    %ch,(%ecx)
 64b:	3b 30                	cmp    (%eax),%esi
 64d:	3b 32                	cmp    (%edx),%esi
 64f:	30 34 37             	xor    %dh,(%edi,%esi,1)
 652:	3b 28                	cmp    (%eax),%ebp
 654:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 657:	31 29                	xor    %ebp,(%ecx)
 659:	00 73 63             	add    %dh,0x63(%ebx)
 65c:	72 65                	jb     6c3 <bootmain-0x27f93d>
 65e:	65 6e                	outsb  %gs:(%esi),(%dx)
 660:	2e 63 00             	arpl   %ax,%cs:(%eax)
 663:	63 6c 65 61          	arpl   %bp,0x61(%ebp,%eiz,2)
 667:	72 5f                	jb     6c8 <bootmain-0x27f938>
 669:	73 63                	jae    6ce <bootmain-0x27f932>
 66b:	72 65                	jb     6d2 <bootmain-0x27f92e>
 66d:	65 6e                	outsb  %gs:(%esi),(%dx)
 66f:	3a 46 28             	cmp    0x28(%esi),%al
 672:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 675:	38 29                	cmp    %ch,(%ecx)
 677:	00 63 6f             	add    %ah,0x6f(%ebx)
 67a:	6c                   	insb   (%dx),%es:(%edi)
 67b:	6f                   	outsl  %ds:(%esi),(%dx)
 67c:	72 3a                	jb     6b8 <bootmain-0x27f948>
 67e:	70 28                	jo     6a8 <bootmain-0x27f958>
 680:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 683:	29 00                	sub    %eax,(%eax)
 685:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
 68b:	31 29                	xor    %ebp,(%ecx)
 68d:	00 63 6f             	add    %ah,0x6f(%ebx)
 690:	6c                   	insb   (%dx),%es:(%edi)
 691:	6f                   	outsl  %ds:(%esi),(%dx)
 692:	72 3a                	jb     6ce <bootmain-0x27f932>
 694:	72 28                	jb     6be <bootmain-0x27f942>
 696:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 699:	29 00                	sub    %eax,(%eax)
 69b:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 69e:	6f                   	outsl  %ds:(%esi),(%dx)
 69f:	72 5f                	jb     700 <bootmain-0x27f900>
 6a1:	73 63                	jae    706 <bootmain-0x27f8fa>
 6a3:	72 65                	jb     70a <bootmain-0x27f8f6>
 6a5:	65 6e                	outsb  %gs:(%esi),(%dx)
 6a7:	3a 46 28             	cmp    0x28(%esi),%al
 6aa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6ad:	38 29                	cmp    %ch,(%ecx)
 6af:	00 73 65             	add    %dh,0x65(%ebx)
 6b2:	74 5f                	je     713 <bootmain-0x27f8ed>
 6b4:	70 61                	jo     717 <bootmain-0x27f8e9>
 6b6:	6c                   	insb   (%dx),%es:(%edi)
 6b7:	65                   	gs
 6b8:	74 74                	je     72e <bootmain-0x27f8d2>
 6ba:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
 6be:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6c1:	38 29                	cmp    %ch,(%ecx)
 6c3:	00 73 74             	add    %dh,0x74(%ebx)
 6c6:	61                   	popa   
 6c7:	72 74                	jb     73d <bootmain-0x27f8c3>
 6c9:	3a 70 28             	cmp    0x28(%eax),%dh
 6cc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6cf:	29 00                	sub    %eax,(%eax)
 6d1:	65 6e                	outsb  %gs:(%esi),(%dx)
 6d3:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
 6d7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6da:	29 00                	sub    %eax,(%eax)
 6dc:	72 67                	jb     745 <bootmain-0x27f8bb>
 6de:	62 3a                	bound  %edi,(%edx)
 6e0:	70 28                	jo     70a <bootmain-0x27f8f6>
 6e2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6e5:	39 29                	cmp    %ebp,(%ecx)
 6e7:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 6ec:	31 31                	xor    %esi,(%ecx)
 6ee:	29 00                	sub    %eax,(%eax)
 6f0:	73 74                	jae    766 <bootmain-0x27f89a>
 6f2:	61                   	popa   
 6f3:	72 74                	jb     769 <bootmain-0x27f897>
 6f5:	3a 72 28             	cmp    0x28(%edx),%dh
 6f8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6fb:	29 00                	sub    %eax,(%eax)
 6fd:	72 67                	jb     766 <bootmain-0x27f89a>
 6ff:	62 3a                	bound  %edi,(%edx)
 701:	72 28                	jb     72b <bootmain-0x27f8d5>
 703:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 706:	39 29                	cmp    %ebp,(%ecx)
 708:	00 69 6e             	add    %ch,0x6e(%ecx)
 70b:	69 74 5f 70 61 6c 65 	imul   $0x74656c61,0x70(%edi,%ebx,2),%esi
 712:	74 
 713:	74 65                	je     77a <bootmain-0x27f886>
 715:	3a 46 28             	cmp    0x28(%esi),%al
 718:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 71b:	38 29                	cmp    %ch,(%ecx)
 71d:	00 74 61 62          	add    %dh,0x62(%ecx,%eiz,2)
 721:	6c                   	insb   (%dx),%es:(%edi)
 722:	65                   	gs
 723:	5f                   	pop    %edi
 724:	72 67                	jb     78d <bootmain-0x27f873>
 726:	62 3a                	bound  %edi,(%edx)
 728:	28 30                	sub    %dh,(%eax)
 72a:	2c 32                	sub    $0x32,%al
 72c:	30 29                	xor    %ch,(%ecx)
 72e:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 733:	2c 32                	sub    $0x32,%al
 735:	31 29                	xor    %ebp,(%ecx)
 737:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 73c:	32 31                	xor    (%ecx),%dh
 73e:	29 3b                	sub    %edi,(%ebx)
 740:	30 3b                	xor    %bh,(%ebx)
 742:	34 32                	xor    $0x32,%al
 744:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 747:	36                   	ss
 748:	37                   	aaa    
 749:	32 39                	xor    (%ecx),%bh
 74b:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 750:	34 37                	xor    $0x37,%al
 752:	3b 28                	cmp    (%eax),%ebp
 754:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 757:	31 29                	xor    %ebp,(%ecx)
 759:	00 62 6f             	add    %ah,0x6f(%edx)
 75c:	78 66                	js     7c4 <bootmain-0x27f83c>
 75e:	69 6c 6c 38 3a 46 28 	imul   $0x3028463a,0x38(%esp,%ebp,2),%ebp
 765:	30 
 766:	2c 31                	sub    $0x31,%al
 768:	38 29                	cmp    %ch,(%ecx)
 76a:	00 76 72             	add    %dh,0x72(%esi)
 76d:	61                   	popa   
 76e:	6d                   	insl   (%dx),%es:(%edi)
 76f:	3a 70 28             	cmp    0x28(%eax),%dh
 772:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 775:	39 29                	cmp    %ebp,(%ecx)
 777:	00 78 73             	add    %bh,0x73(%eax)
 77a:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
 781:	2c 31                	sub    $0x31,%al
 783:	29 00                	sub    %eax,(%eax)
 785:	78 30                	js     7b7 <bootmain-0x27f849>
 787:	3a 70 28             	cmp    0x28(%eax),%dh
 78a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 78d:	29 00                	sub    %eax,(%eax)
 78f:	79 30                	jns    7c1 <bootmain-0x27f83f>
 791:	3a 70 28             	cmp    0x28(%eax),%dh
 794:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 797:	29 00                	sub    %eax,(%eax)
 799:	78 31                	js     7cc <bootmain-0x27f834>
 79b:	3a 70 28             	cmp    0x28(%eax),%dh
 79e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7a1:	29 00                	sub    %eax,(%eax)
 7a3:	79 31                	jns    7d6 <bootmain-0x27f82a>
 7a5:	3a 70 28             	cmp    0x28(%eax),%dh
 7a8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7ab:	29 00                	sub    %eax,(%eax)
 7ad:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 7b0:	6f                   	outsl  %ds:(%esi),(%dx)
 7b1:	72 3a                	jb     7ed <bootmain-0x27f813>
 7b3:	72 28                	jb     7dd <bootmain-0x27f823>
 7b5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7b8:	31 29                	xor    %ebp,(%ecx)
 7ba:	00 79 30             	add    %bh,0x30(%ecx)
 7bd:	3a 72 28             	cmp    0x28(%edx),%dh
 7c0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7c3:	29 00                	sub    %eax,(%eax)
 7c5:	62 6f 78             	bound  %ebp,0x78(%edi)
 7c8:	66 69 6c 6c 3a 46 28 	imul   $0x2846,0x3a(%esp,%ebp,2),%bp
 7cf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7d2:	38 29                	cmp    %ch,(%ecx)
 7d4:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
 7d8:	77 5f                	ja     839 <bootmain-0x27f7c7>
 7da:	77 69                	ja     845 <bootmain-0x27f7bb>
 7dc:	6e                   	outsb  %ds:(%esi),(%dx)
 7dd:	64 6f                	outsl  %fs:(%esi),(%dx)
 7df:	77 3a                	ja     81b <bootmain-0x27f7e5>
 7e1:	46                   	inc    %esi
 7e2:	28 30                	sub    %dh,(%eax)
 7e4:	2c 31                	sub    $0x31,%al
 7e6:	38 29                	cmp    %ch,(%ecx)
 7e8:	00 69 6e             	add    %ch,0x6e(%ecx)
 7eb:	69 74 5f 73 63 72 65 	imul   $0x65657263,0x73(%edi,%ebx,2),%esi
 7f2:	65 
 7f3:	6e                   	outsb  %ds:(%esi),(%dx)
 7f4:	3a 46 28             	cmp    0x28(%esi),%al
 7f7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7fa:	38 29                	cmp    %ch,(%ecx)
 7fc:	00 62 6f             	add    %ah,0x6f(%edx)
 7ff:	6f                   	outsl  %ds:(%esi),(%dx)
 800:	74 70                	je     872 <bootmain-0x27f78e>
 802:	3a 70 28             	cmp    0x28(%eax),%dh
 805:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 808:	32 29                	xor    (%ecx),%ch
 80a:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 80f:	31 29                	xor    %ebp,(%ecx)
 811:	00 62 6f             	add    %ah,0x6f(%edx)
 814:	6f                   	outsl  %ds:(%esi),(%dx)
 815:	74 70                	je     887 <bootmain-0x27f779>
 817:	3a 72 28             	cmp    0x28(%edx),%dh
 81a:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 81d:	32 29                	xor    (%ecx),%ch
 81f:	00 69 6e             	add    %ch,0x6e(%ecx)
 822:	69 74 5f 6d 6f 75 73 	imul   $0x6573756f,0x6d(%edi,%ebx,2),%esi
 829:	65 
 82a:	3a 46 28             	cmp    0x28(%esi),%al
 82d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 830:	38 29                	cmp    %ch,(%ecx)
 832:	00 6d 6f             	add    %ch,0x6f(%ebp)
 835:	75 73                	jne    8aa <bootmain-0x27f756>
 837:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
 83b:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 83e:	29 00                	sub    %eax,(%eax)
 840:	62 67 3a             	bound  %esp,0x3a(%edi)
 843:	70 28                	jo     86d <bootmain-0x27f793>
 845:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 848:	29 00                	sub    %eax,(%eax)
 84a:	63 75 72             	arpl   %si,0x72(%ebp)
 84d:	73 6f                	jae    8be <bootmain-0x27f742>
 84f:	72 3a                	jb     88b <bootmain-0x27f775>
 851:	56                   	push   %esi
 852:	28 30                	sub    %dh,(%eax)
 854:	2c 32                	sub    $0x32,%al
 856:	33 29                	xor    (%ecx),%ebp
 858:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 85d:	2c 32                	sub    $0x32,%al
 85f:	31 29                	xor    %ebp,(%ecx)
 861:	3b 30                	cmp    (%eax),%esi
 863:	3b 31                	cmp    (%ecx),%esi
 865:	35 3b 28 30 2c       	xor    $0x2c30283b,%eax
 86a:	32 34 29             	xor    (%ecx,%ebp,1),%dh
 86d:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 872:	2c 32                	sub    $0x32,%al
 874:	31 29                	xor    %ebp,(%ecx)
 876:	3b 30                	cmp    (%eax),%esi
 878:	3b 31                	cmp    (%ecx),%esi
 87a:	35 3b 28 30 2c       	xor    $0x2c30283b,%eax
 87f:	32 29                	xor    (%ecx),%ch
 881:	00 78 3a             	add    %bh,0x3a(%eax)
 884:	72 28                	jb     8ae <bootmain-0x27f752>
 886:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 889:	29 00                	sub    %eax,(%eax)
 88b:	62 67 3a             	bound  %esp,0x3a(%edi)
 88e:	72 28                	jb     8b8 <bootmain-0x27f748>
 890:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 893:	29 00                	sub    %eax,(%eax)
 895:	64 69 73 70 6c 61 79 	imul   $0x5f79616c,%fs:0x70(%ebx),%esi
 89c:	5f 
 89d:	6d                   	insl   (%dx),%es:(%edi)
 89e:	6f                   	outsl  %ds:(%esi),(%dx)
 89f:	75 73                	jne    914 <bootmain-0x27f6ec>
 8a1:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
 8a5:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8a8:	38 29                	cmp    %ch,(%ecx)
 8aa:	00 76 72             	add    %dh,0x72(%esi)
 8ad:	61                   	popa   
 8ae:	6d                   	insl   (%dx),%es:(%edi)
 8af:	3a 70 28             	cmp    0x28(%eax),%dh
 8b2:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 8b5:	29 00                	sub    %eax,(%eax)
 8b7:	70 78                	jo     931 <bootmain-0x27f6cf>
 8b9:	73 69                	jae    924 <bootmain-0x27f6dc>
 8bb:	7a 65                	jp     922 <bootmain-0x27f6de>
 8bd:	3a 70 28             	cmp    0x28(%eax),%dh
 8c0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8c3:	29 00                	sub    %eax,(%eax)
 8c5:	70 79                	jo     940 <bootmain-0x27f6c0>
 8c7:	73 69                	jae    932 <bootmain-0x27f6ce>
 8c9:	7a 65                	jp     930 <bootmain-0x27f6d0>
 8cb:	3a 70 28             	cmp    0x28(%eax),%dh
 8ce:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8d1:	29 00                	sub    %eax,(%eax)
 8d3:	70 78                	jo     94d <bootmain-0x27f6b3>
 8d5:	30 3a                	xor    %bh,(%edx)
 8d7:	70 28                	jo     901 <bootmain-0x27f6ff>
 8d9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8dc:	29 00                	sub    %eax,(%eax)
 8de:	70 79                	jo     959 <bootmain-0x27f6a7>
 8e0:	30 3a                	xor    %bh,(%edx)
 8e2:	70 28                	jo     90c <bootmain-0x27f6f4>
 8e4:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8e7:	29 00                	sub    %eax,(%eax)
 8e9:	62 75 66             	bound  %esi,0x66(%ebp)
 8ec:	3a 70 28             	cmp    0x28(%eax),%dh
 8ef:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 8f2:	29 00                	sub    %eax,(%eax)
 8f4:	62 78 73             	bound  %edi,0x73(%eax)
 8f7:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
 8fe:	2c 31                	sub    $0x31,%al
 900:	29 00                	sub    %eax,(%eax)
 902:	79 3a                	jns    93e <bootmain-0x27f6c2>
 904:	72 28                	jb     92e <bootmain-0x27f6d2>
 906:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 909:	29 00                	sub    %eax,(%eax)
 90b:	66 6f                	outsw  %ds:(%esi),(%dx)
 90d:	6e                   	outsb  %ds:(%esi),(%dx)
 90e:	74 2e                	je     93e <bootmain-0x27f6c2>
 910:	63 00                	arpl   %ax,(%eax)
 912:	70 72                	jo     986 <bootmain-0x27f67a>
 914:	69 6e 74 2e 63 00 69 	imul   $0x6900632e,0x74(%esi),%ebp
 91b:	74 6f                	je     98c <bootmain-0x27f674>
 91d:	61                   	popa   
 91e:	3a 46 28             	cmp    0x28(%esi),%al
 921:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 924:	38 29                	cmp    %ch,(%ecx)
 926:	00 76 61             	add    %dh,0x61(%esi)
 929:	6c                   	insb   (%dx),%es:(%edi)
 92a:	75 65                	jne    991 <bootmain-0x27f66f>
 92c:	3a 70 28             	cmp    0x28(%eax),%dh
 92f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 932:	29 00                	sub    %eax,(%eax)
 934:	74 6d                	je     9a3 <bootmain-0x27f65d>
 936:	70 5f                	jo     997 <bootmain-0x27f669>
 938:	62 75 66             	bound  %esi,0x66(%ebp)
 93b:	3a 28                	cmp    (%eax),%ch
 93d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 940:	39 29                	cmp    %ebp,(%ecx)
 942:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 947:	2c 32                	sub    $0x32,%al
 949:	30 29                	xor    %ch,(%ecx)
 94b:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 950:	32 30                	xor    (%eax),%dh
 952:	29 3b                	sub    %edi,(%ebx)
 954:	30 3b                	xor    %bh,(%ebx)
 956:	34 32                	xor    $0x32,%al
 958:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 95b:	36                   	ss
 95c:	37                   	aaa    
 95d:	32 39                	xor    (%ecx),%bh
 95f:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 964:	39 3b                	cmp    %edi,(%ebx)
 966:	28 30                	sub    %dh,(%eax)
 968:	2c 32                	sub    $0x32,%al
 96a:	29 00                	sub    %eax,(%eax)
 96c:	76 61                	jbe    9cf <bootmain-0x27f631>
 96e:	6c                   	insb   (%dx),%es:(%edi)
 96f:	75 65                	jne    9d6 <bootmain-0x27f62a>
 971:	3a 72 28             	cmp    0x28(%edx),%dh
 974:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 977:	29 00                	sub    %eax,(%eax)
 979:	62 75 66             	bound  %esi,0x66(%ebp)
 97c:	3a 72 28             	cmp    0x28(%edx),%dh
 97f:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 982:	29 00                	sub    %eax,(%eax)
 984:	78 74                	js     9fa <bootmain-0x27f606>
 986:	6f                   	outsl  %ds:(%esi),(%dx)
 987:	61                   	popa   
 988:	3a 46 28             	cmp    0x28(%esi),%al
 98b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 98e:	38 29                	cmp    %ch,(%ecx)
 990:	00 76 61             	add    %dh,0x61(%esi)
 993:	6c                   	insb   (%dx),%es:(%edi)
 994:	75 65                	jne    9fb <bootmain-0x27f605>
 996:	3a 70 28             	cmp    0x28(%eax),%dh
 999:	30 2c 34             	xor    %ch,(%esp,%esi,1)
 99c:	29 00                	sub    %eax,(%eax)
 99e:	74 6d                	je     a0d <bootmain-0x27f5f3>
 9a0:	70 5f                	jo     a01 <bootmain-0x27f5ff>
 9a2:	62 75 66             	bound  %esi,0x66(%ebp)
 9a5:	3a 28                	cmp    (%eax),%ch
 9a7:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 9aa:	31 29                	xor    %ebp,(%ecx)
 9ac:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 9b1:	2c 32                	sub    $0x32,%al
 9b3:	30 29                	xor    %ch,(%ecx)
 9b5:	3b 30                	cmp    (%eax),%esi
 9b7:	3b 32                	cmp    (%edx),%esi
 9b9:	39 3b                	cmp    %edi,(%ebx)
 9bb:	28 30                	sub    %dh,(%eax)
 9bd:	2c 32                	sub    $0x32,%al
 9bf:	29 00                	sub    %eax,(%eax)
 9c1:	73 70                	jae    a33 <bootmain-0x27f5cd>
 9c3:	72 69                	jb     a2e <bootmain-0x27f5d2>
 9c5:	6e                   	outsb  %ds:(%esi),(%dx)
 9c6:	74 66                	je     a2e <bootmain-0x27f5d2>
 9c8:	3a 46 28             	cmp    0x28(%esi),%al
 9cb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 9ce:	38 29                	cmp    %ch,(%ecx)
 9d0:	00 73 74             	add    %dh,0x74(%ebx)
 9d3:	72 3a                	jb     a0f <bootmain-0x27f5f1>
 9d5:	70 28                	jo     9ff <bootmain-0x27f601>
 9d7:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 9da:	29 00                	sub    %eax,(%eax)
 9dc:	66 6f                	outsw  %ds:(%esi),(%dx)
 9de:	72 6d                	jb     a4d <bootmain-0x27f5b3>
 9e0:	61                   	popa   
 9e1:	74 3a                	je     a1d <bootmain-0x27f5e3>
 9e3:	70 28                	jo     a0d <bootmain-0x27f5f3>
 9e5:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 9e8:	29 00                	sub    %eax,(%eax)
 9ea:	76 61                	jbe    a4d <bootmain-0x27f5b3>
 9ec:	72 3a                	jb     a28 <bootmain-0x27f5d8>
 9ee:	72 28                	jb     a18 <bootmain-0x27f5e8>
 9f0:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 9f3:	32 29                	xor    (%ecx),%ch
 9f5:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 9fa:	31 29                	xor    %ebp,(%ecx)
 9fc:	00 62 75             	add    %ah,0x75(%edx)
 9ff:	66                   	data16
 a00:	66                   	data16
 a01:	65                   	gs
 a02:	72 3a                	jb     a3e <bootmain-0x27f5c2>
 a04:	28 30                	sub    %dh,(%eax)
 a06:	2c 31                	sub    $0x31,%al
 a08:	39 29                	cmp    %ebp,(%ecx)
 a0a:	00 73 74             	add    %dh,0x74(%ebx)
 a0d:	72 3a                	jb     a49 <bootmain-0x27f5b7>
 a0f:	72 28                	jb     a39 <bootmain-0x27f5c7>
 a11:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 a14:	29 00                	sub    %eax,(%eax)
 a16:	70 75                	jo     a8d <bootmain-0x27f573>
 a18:	74 66                	je     a80 <bootmain-0x27f580>
 a1a:	6f                   	outsl  %ds:(%esi),(%dx)
 a1b:	6e                   	outsb  %ds:(%esi),(%dx)
 a1c:	74 38                	je     a56 <bootmain-0x27f5aa>
 a1e:	3a 46 28             	cmp    0x28(%esi),%al
 a21:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a24:	38 29                	cmp    %ch,(%ecx)
 a26:	00 78 3a             	add    %bh,0x3a(%eax)
 a29:	70 28                	jo     a53 <bootmain-0x27f5ad>
 a2b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a2e:	29 00                	sub    %eax,(%eax)
 a30:	79 3a                	jns    a6c <bootmain-0x27f594>
 a32:	70 28                	jo     a5c <bootmain-0x27f5a4>
 a34:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a37:	29 00                	sub    %eax,(%eax)
 a39:	66 6f                	outsw  %ds:(%esi),(%dx)
 a3b:	6e                   	outsb  %ds:(%esi),(%dx)
 a3c:	74 3a                	je     a78 <bootmain-0x27f588>
 a3e:	70 28                	jo     a68 <bootmain-0x27f598>
 a40:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 a43:	29 00                	sub    %eax,(%eax)
 a45:	72 6f                	jb     ab6 <bootmain-0x27f54a>
 a47:	77 3a                	ja     a83 <bootmain-0x27f57d>
 a49:	72 28                	jb     a73 <bootmain-0x27f58d>
 a4b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a4e:	29 00                	sub    %eax,(%eax)
 a50:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 a53:	3a 72 28             	cmp    0x28(%edx),%dh
 a56:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a59:	29 00                	sub    %eax,(%eax)
 a5b:	70 75                	jo     ad2 <bootmain-0x27f52e>
 a5d:	74 73                	je     ad2 <bootmain-0x27f52e>
 a5f:	38 3a                	cmp    %bh,(%edx)
 a61:	46                   	inc    %esi
 a62:	28 30                	sub    %dh,(%eax)
 a64:	2c 31                	sub    $0x31,%al
 a66:	38 29                	cmp    %ch,(%ecx)
 a68:	00 70 72             	add    %dh,0x72(%eax)
 a6b:	69 6e 74 64 65 62 75 	imul   $0x75626564,0x74(%esi),%ebp
 a72:	67 3a 46 28          	cmp    0x28(%bp),%al
 a76:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a79:	38 29                	cmp    %ch,(%ecx)
 a7b:	00 69 3a             	add    %ch,0x3a(%ecx)
 a7e:	70 28                	jo     aa8 <bootmain-0x27f558>
 a80:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a83:	29 00                	sub    %eax,(%eax)
 a85:	66 6f                	outsw  %ds:(%esi),(%dx)
 a87:	6e                   	outsb  %ds:(%esi),(%dx)
 a88:	74 3a                	je     ac4 <bootmain-0x27f53c>
 a8a:	28 30                	sub    %dh,(%eax)
 a8c:	2c 32                	sub    $0x32,%al
 a8e:	31 29                	xor    %ebp,(%ecx)
 a90:	00 70 75             	add    %dh,0x75(%eax)
 a93:	74 66                	je     afb <bootmain-0x27f505>
 a95:	6f                   	outsl  %ds:(%esi),(%dx)
 a96:	6e                   	outsb  %ds:(%esi),(%dx)
 a97:	74 31                	je     aca <bootmain-0x27f536>
 a99:	36 3a 46 28          	cmp    %ss:0x28(%esi),%al
 a9d:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 aa0:	38 29                	cmp    %ch,(%ecx)
 aa2:	00 66 6f             	add    %ah,0x6f(%esi)
 aa5:	6e                   	outsb  %ds:(%esi),(%dx)
 aa6:	74 3a                	je     ae2 <bootmain-0x27f51e>
 aa8:	70 28                	jo     ad2 <bootmain-0x27f52e>
 aaa:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 aad:	33 29                	xor    (%ecx),%ebp
 aaf:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 ab4:	39 29                	cmp    %ebp,(%ecx)
 ab6:	00 70 75             	add    %dh,0x75(%eax)
 ab9:	74 73                	je     b2e <bootmain-0x27f4d2>
 abb:	31 36                	xor    %esi,(%esi)
 abd:	3a 46 28             	cmp    0x28(%esi),%al
 ac0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 ac3:	38 29                	cmp    %ch,(%ecx)
 ac5:	00 69 64             	add    %ch,0x64(%ecx)
 ac8:	74 67                	je     b31 <bootmain-0x27f4cf>
 aca:	64                   	fs
 acb:	74 2e                	je     afb <bootmain-0x27f505>
 acd:	63 00                	arpl   %ax,(%eax)
 acf:	73 65                	jae    b36 <bootmain-0x27f4ca>
 ad1:	74 67                	je     b3a <bootmain-0x27f4c6>
 ad3:	64                   	fs
 ad4:	74 3a                	je     b10 <bootmain-0x27f4f0>
 ad6:	46                   	inc    %esi
 ad7:	28 30                	sub    %dh,(%eax)
 ad9:	2c 31                	sub    $0x31,%al
 adb:	38 29                	cmp    %ch,(%ecx)
 add:	00 73 64             	add    %dh,0x64(%ebx)
 ae0:	3a 70 28             	cmp    0x28(%eax),%dh
 ae3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 ae6:	39 29                	cmp    %ebp,(%ecx)
 ae8:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 aed:	33 29                	xor    (%ecx),%ebp
 aef:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
 af3:	69 74 3a 70 28 30 2c 	imul   $0x342c3028,0x70(%edx,%edi,1),%esi
 afa:	34 
 afb:	29 00                	sub    %eax,(%eax)
 afd:	62 61 73             	bound  %esp,0x73(%ecx)
 b00:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
 b04:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b07:	29 00                	sub    %eax,(%eax)
 b09:	61                   	popa   
 b0a:	63 63 65             	arpl   %sp,0x65(%ebx)
 b0d:	73 73                	jae    b82 <bootmain-0x27f47e>
 b0f:	3a 70 28             	cmp    0x28(%eax),%dh
 b12:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b15:	29 00                	sub    %eax,(%eax)
 b17:	73 64                	jae    b7d <bootmain-0x27f483>
 b19:	3a 72 28             	cmp    0x28(%edx),%dh
 b1c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b1f:	39 29                	cmp    %ebp,(%ecx)
 b21:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
 b25:	69 74 3a 72 28 30 2c 	imul   $0x342c3028,0x72(%edx,%edi,1),%esi
 b2c:	34 
 b2d:	29 00                	sub    %eax,(%eax)
 b2f:	62 61 73             	bound  %esp,0x73(%ecx)
 b32:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
 b36:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b39:	29 00                	sub    %eax,(%eax)
 b3b:	61                   	popa   
 b3c:	63 63 65             	arpl   %sp,0x65(%ebx)
 b3f:	73 73                	jae    bb4 <bootmain-0x27f44c>
 b41:	3a 72 28             	cmp    0x28(%edx),%dh
 b44:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b47:	29 00                	sub    %eax,(%eax)
 b49:	73 65                	jae    bb0 <bootmain-0x27f450>
 b4b:	74 69                	je     bb6 <bootmain-0x27f44a>
 b4d:	64                   	fs
 b4e:	74 3a                	je     b8a <bootmain-0x27f476>
 b50:	46                   	inc    %esi
 b51:	28 30                	sub    %dh,(%eax)
 b53:	2c 31                	sub    $0x31,%al
 b55:	38 29                	cmp    %ch,(%ecx)
 b57:	00 67 64             	add    %ah,0x64(%edi)
 b5a:	3a 70 28             	cmp    0x28(%eax),%dh
 b5d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 b60:	30 29                	xor    %ch,(%ecx)
 b62:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 b67:	34 29                	xor    $0x29,%al
 b69:	00 6f 66             	add    %ch,0x66(%edi)
 b6c:	66                   	data16
 b6d:	73 65                	jae    bd4 <bootmain-0x27f42c>
 b6f:	74 3a                	je     bab <bootmain-0x27f455>
 b71:	70 28                	jo     b9b <bootmain-0x27f465>
 b73:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b76:	29 00                	sub    %eax,(%eax)
 b78:	73 65                	jae    bdf <bootmain-0x27f421>
 b7a:	6c                   	insb   (%dx),%es:(%edi)
 b7b:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
 b80:	3a 70 28             	cmp    0x28(%eax),%dh
 b83:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b86:	29 00                	sub    %eax,(%eax)
 b88:	67 64 3a 72 28       	cmp    %fs:0x28(%bp,%si),%dh
 b8d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 b90:	30 29                	xor    %ch,(%ecx)
 b92:	00 6f 66             	add    %ch,0x66(%edi)
 b95:	66                   	data16
 b96:	73 65                	jae    bfd <bootmain-0x27f403>
 b98:	74 3a                	je     bd4 <bootmain-0x27f42c>
 b9a:	72 28                	jb     bc4 <bootmain-0x27f43c>
 b9c:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b9f:	29 00                	sub    %eax,(%eax)
 ba1:	73 65                	jae    c08 <bootmain-0x27f3f8>
 ba3:	6c                   	insb   (%dx),%es:(%edi)
 ba4:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
 ba9:	3a 72 28             	cmp    0x28(%edx),%dh
 bac:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 baf:	29 00                	sub    %eax,(%eax)
 bb1:	69 6e 69 74 5f 67 64 	imul   $0x64675f74,0x69(%esi),%ebp
 bb8:	74 69                	je     c23 <bootmain-0x27f3dd>
 bba:	64                   	fs
 bbb:	74 3a                	je     bf7 <bootmain-0x27f409>
 bbd:	46                   	inc    %esi
 bbe:	28 30                	sub    %dh,(%eax)
 bc0:	2c 31                	sub    $0x31,%al
 bc2:	38 29                	cmp    %ch,(%ecx)
 bc4:	00 69 6e             	add    %ch,0x6e(%ecx)
 bc7:	74 2e                	je     bf7 <bootmain-0x27f409>
 bc9:	63 00                	arpl   %ax,(%eax)
 bcb:	69 6e 69 74 5f 70 69 	imul   $0x69705f74,0x69(%esi),%ebp
 bd2:	63 3a                	arpl   %di,(%edx)
 bd4:	46                   	inc    %esi
 bd5:	28 30                	sub    %dh,(%eax)
 bd7:	2c 31                	sub    $0x31,%al
 bd9:	38 29                	cmp    %ch,(%ecx)
 bdb:	00 69 6e             	add    %ch,0x6e(%ecx)
 bde:	74 68                	je     c48 <bootmain-0x27f3b8>
 be0:	61                   	popa   
 be1:	6e                   	outsb  %ds:(%esi),(%dx)
 be2:	64                   	fs
 be3:	6c                   	insb   (%dx),%es:(%edi)
 be4:	65                   	gs
 be5:	72 32                	jb     c19 <bootmain-0x27f3e7>
 be7:	31 3a                	xor    %edi,(%edx)
 be9:	46                   	inc    %esi
 bea:	28 30                	sub    %dh,(%eax)
 bec:	2c 31                	sub    $0x31,%al
 bee:	38 29                	cmp    %ch,(%ecx)
 bf0:	00 65 73             	add    %ah,0x73(%ebp)
 bf3:	70 3a                	jo     c2f <bootmain-0x27f3d1>
 bf5:	70 28                	jo     c1f <bootmain-0x27f3e1>
 bf7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 bfa:	39 29                	cmp    %ebp,(%ecx)
 bfc:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 c01:	31 29                	xor    %ebp,(%ecx)
 c03:	00 2f                	add    %ch,(%edi)
 c05:	74 6d                	je     c74 <bootmain-0x27f38c>
 c07:	70 2f                	jo     c38 <bootmain-0x27f3c8>
 c09:	63 63 77             	arpl   %sp,0x77(%ebx)
 c0c:	72 69                	jb     c77 <bootmain-0x27f389>
 c0e:	49                   	dec    %ecx
 c0f:	4c                   	dec    %esp
 c10:	54                   	push   %esp
 c11:	2e 73 00             	jae,pn c14 <bootmain-0x27f3ec>
 c14:	61                   	popa   
 c15:	73 6d                	jae    c84 <bootmain-0x27f37c>
 c17:	69 6e 74 33 32 2e 53 	imul   $0x532e3233,0x74(%esi),%ebp
	...
