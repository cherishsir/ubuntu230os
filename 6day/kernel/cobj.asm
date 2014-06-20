
cobj.out:     file format elf32-i386


Disassembly of section .text:

00280000 <bootmain>:
#define black 0
#define red   1
#define green 2
typedef void (* fpt)(char color);
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
  clear_screen(1);   	//read
  28000a:	6a 01                	push   $0x1
  28000c:	e8 8f 00 00 00       	call   2800a0 <clear_screen>

static __inline void
sti(void)
{

	__asm __volatile("sti");
  280011:	fb                   	sti    
//while(1);
  sti();		//enable cpu interrupt
  init_screen((struct boot_info * )bootp);
  280012:	c7 04 24 f0 0f 00 00 	movl   $0xff0,(%esp)




//display mouse logo
init_mouse(mousepic,7);//7　means background color:white
  280019:	8d 9d f8 fe ff ff    	lea    -0x108(%ebp),%ebx
char mousepic[256];     //mouse logo buffer
struct boot_info *bootp=(struct boot_info *)ADDR_BOOT;
  clear_screen(1);   	//read
//while(1);
  sti();		//enable cpu interrupt
  init_screen((struct boot_info * )bootp);
  28001f:	e8 ce 02 00 00       	call   2802f2 <init_screen>
  init_palette();  //color table from 0 to 15
  280024:	e8 e0 00 00 00       	call   280109 <init_palette>

  draw_window();  
  280029:	e8 63 01 00 00       	call   280191 <draw_window>




//display mouse logo
init_mouse(mousepic,7);//7　means background color:white
  28002e:	58                   	pop    %eax
  28002f:	5a                   	pop    %edx
  280030:	6a 07                	push   $0x7
  280032:	53                   	push   %ebx
  280033:	e8 d9 02 00 00       	call   280311 <init_mouse>
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
  280051:	e8 0b 03 00 00       	call   280361 <display_mouse>
init_gdtidt();
  280056:	83 c4 30             	add    $0x30,%esp
  280059:	e8 b6 06 00 00       	call   280714 <init_gdtidt>
init_pic();//函数中：　irq 1(keyboard)对应设置中断号int0x21,    irq　12(mouse)对应的中断号是int0x2c 要写中断服务程序了。
  28005e:	e8 e6 07 00 00       	call   280849 <init_pic>
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
fpt cls=clear_screen;
(*cls)(5);
  280070:	83 ec 0c             	sub    $0xc,%esp
  280073:	6a 05                	push   $0x5
  280075:	e8 26 00 00 00       	call   2800a0 <clear_screen>
int * addr=(int *)(0x0026f800+8*0x21);
printdebug(*(addr),0);
  28007a:	59                   	pop    %ecx
  28007b:	5b                   	pop    %ebx
  28007c:	6a 00                	push   $0x0
  28007e:	ff 35 08 f9 26 00    	pushl  0x26f908
  280084:	e8 34 05 00 00       	call   2805bd <printdebug>
printdebug(*(addr+1),160);
  280089:	58                   	pop    %eax
  28008a:	5a                   	pop    %edx
  28008b:	68 a0 00 00 00       	push   $0xa0
  280090:	ff 35 0c f9 26 00    	pushl  0x26f90c
  280096:	e8 22 05 00 00       	call   2805bd <printdebug>
  28009b:	83 c4 10             	add    $0x10,%esp
  28009e:	eb fe                	jmp    28009e <bootmain+0x9e>

002800a0 <clear_screen>:
#include<header.h>

void clear_screen(char color) //15:pure white
{
  2800a0:	55                   	push   %ebp
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  2800a1:	b8 00 00 0a 00       	mov    $0xa0000,%eax
#include<header.h>

void clear_screen(char color) //15:pure white
{
  2800a6:	89 e5                	mov    %esp,%ebp
  2800a8:	8a 55 08             	mov    0x8(%ebp),%dl
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  2800ab:	88 10                	mov    %dl,(%eax)
#include<header.h>

void clear_screen(char color) //15:pure white
{
  int i;
  for(i=0xa0000;i<0xaffff;i++)
  2800ad:	40                   	inc    %eax
  2800ae:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  2800b3:	75 f6                	jne    2800ab <clear_screen+0xb>
  {
  write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  2800b5:	5d                   	pop    %ebp
  2800b6:	c3                   	ret    

002800b7 <color_screen>:

void color_screen(char color) //15:pure white
{
  2800b7:	55                   	push   %ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  2800b8:	b8 00 00 0a 00       	mov    $0xa0000,%eax

  }
}

void color_screen(char color) //15:pure white
{
  2800bd:	89 e5                	mov    %esp,%ebp
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
  2800bf:	88 00                	mov    %al,(%eax)

void color_screen(char color) //15:pure white
{
  int i;
  color=color;
  for(i=0xa0000;i<0xaffff;i++)
  2800c1:	40                   	inc    %eax
  2800c2:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  2800c7:	75 f6                	jne    2800bf <color_screen+0x8>
  {
  write_mem8(i,i);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white

  }
}
  2800c9:	5d                   	pop    %ebp
  2800ca:	c3                   	ret    

002800cb <set_palette>:
   set_palette(0,255,table_rgb);
}

//设置调色板，  只用到了16个color,后面的都没有用到。
void set_palette(int start,int end, unsigned char *rgb)
{
  2800cb:	55                   	push   %ebp
  2800cc:	89 e5                	mov    %esp,%ebp
  2800ce:	56                   	push   %esi
  2800cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  2800d2:	53                   	push   %ebx
  2800d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
  2800d6:	9c                   	pushf  
  2800d7:	5e                   	pop    %esi
  int i,eflag;
  eflag=read_eflags();   //记录从前的cpsr值
 
  io_cli(); // disable interrupt
  2800d8:	fa                   	cli    
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  2800d9:	ba c8 03 00 00       	mov    $0x3c8,%edx
  //为什么写port 0x03c8
  
  //rgb=rgb+;
  outb(0x03c8,start);
  2800de:	0f b6 c3             	movzbl %bl,%eax
  2800e1:	ee                   	out    %al,(%dx)
  2800e2:	b2 c9                	mov    $0xc9,%dl
  for(i=start;i<=end;i++)
  2800e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  2800e7:	7f 1a                	jg     280103 <set_palette+0x38>
  {
    outb(0x03c9,*(rgb)/4);    //outb函数是往指定的设备，送数据。
  2800e9:	8a 01                	mov    (%ecx),%al
  2800eb:	c0 e8 02             	shr    $0x2,%al
  2800ee:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+1)/4);   
  2800ef:	8a 41 01             	mov    0x1(%ecx),%al
  2800f2:	c0 e8 02             	shr    $0x2,%al
  2800f5:	ee                   	out    %al,(%dx)
    outb(0x03c9,*(rgb+2)/4);   
  2800f6:	8a 41 02             	mov    0x2(%ecx),%al
  2800f9:	c0 e8 02             	shr    $0x2,%al
  2800fc:	ee                   	out    %al,(%dx)
    rgb=rgb+3;
  2800fd:	83 c1 03             	add    $0x3,%ecx
  io_cli(); // disable interrupt
  //为什么写port 0x03c8
  
  //rgb=rgb+;
  outb(0x03c8,start);
  for(i=start;i<=end;i++)
  280100:	43                   	inc    %ebx
  280101:	eb e1                	jmp    2800e4 <set_palette+0x19>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
  280103:	56                   	push   %esi
  280104:	9d                   	popf   
  }
  
write_eflags(eflag);  //恢复从前的cpsr
  return;
  
}
  280105:	5b                   	pop    %ebx
  280106:	5e                   	pop    %esi
  280107:	5d                   	pop    %ebp
  280108:	c3                   	ret    

00280109 <init_palette>:
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280109:	55                   	push   %ebp
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  28010a:	b9 0c 00 00 00       	mov    $0xc,%ecx
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  28010f:	89 e5                	mov    %esp,%ebp
  280111:	57                   	push   %edi
  280112:	56                   	push   %esi
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  280113:	be d0 22 28 00       	mov    $0x2822d0,%esi
}

//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  280118:	83 ec 30             	sub    $0x30,%esp
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  28011b:	8d 45 c8             	lea    -0x38(%ebp),%eax
//初始化调色板，table_rgb[]保存了16种color的编码。
//什么调色板是这样进行设置，这个与x86的port 0x03c8 0x03c9
void init_palette(void)
{
  //16种color，每个color三个字节。
unsigned char table_rgb[16*3]={
  28011e:	8d 7d c8             	lea    -0x38(%ebp),%edi
  280121:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    0x00,0x00,0x84,   /*12:dark 青*/
    0x84,0x00,0x84,   /*13:dark purper*/
    0x00,0x84,0x84,   /*14:light blue*/
    0x84,0x84,0x84,   /*15:dark gray*/
  };
   set_palette(0,255,table_rgb);
  280123:	50                   	push   %eax
  280124:	68 ff 00 00 00       	push   $0xff
  280129:	6a 00                	push   $0x0
  28012b:	e8 9b ff ff ff       	call   2800cb <set_palette>
  280130:	83 c4 0c             	add    $0xc,%esp
}
  280133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  280136:	5e                   	pop    %esi
  280137:	5f                   	pop    %edi
  280138:	5d                   	pop    %ebp
  280139:	c3                   	ret    

0028013a <boxfill8>:
  return;
  
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
  28013a:	55                   	push   %ebp
  28013b:	89 e5                	mov    %esp,%ebp
  28013d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  280140:	8b 45 0c             	mov    0xc(%ebp),%eax
  280143:	53                   	push   %ebx
  280144:	8a 5d 10             	mov    0x10(%ebp),%bl
  280147:	0f af c1             	imul   %ecx,%eax
  28014a:	03 45 08             	add    0x8(%ebp),%eax
 int x,y;
 for(y=y0;y<=y1;y++)
  28014d:	3b 4d 20             	cmp    0x20(%ebp),%ecx
  280150:	7f 14                	jg     280166 <boxfill8+0x2c>
  280152:	8b 55 14             	mov    0x14(%ebp),%edx
 {
   for(x=x0;x<=x1;x++)
  280155:	3b 55 1c             	cmp    0x1c(%ebp),%edx
  280158:	7f 06                	jg     280160 <boxfill8+0x26>
   {
      vram[y*xsize+x]=color;
  28015a:	88 1c 10             	mov    %bl,(%eax,%edx,1)
void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
 {
   for(x=x0;x<=x1;x++)
  28015d:	42                   	inc    %edx
  28015e:	eb f5                	jmp    280155 <boxfill8+0x1b>
}

void boxfill8(unsigned char *vram,int xsize,unsigned char color,int x0,int y0,int x1,int y1)
{
 int x,y;
 for(y=y0;y<=y1;y++)
  280160:	41                   	inc    %ecx
  280161:	03 45 0c             	add    0xc(%ebp),%eax
  280164:	eb e7                	jmp    28014d <boxfill8+0x13>
   {
      vram[y*xsize+x]=color;
   }
 }
   
}
  280166:	5b                   	pop    %ebx
  280167:	5d                   	pop    %ebp
  280168:	c3                   	ret    

00280169 <boxfill>:
void boxfill(unsigned char color,int x0,int y0,int x1,int y1)
{
  280169:	55                   	push   %ebp
  28016a:	89 e5                	mov    %esp,%ebp
  boxfill8((unsigned char *)VRAM,320,color,x0,y0,x1,y1);
  28016c:	ff 75 18             	pushl  0x18(%ebp)
  28016f:	ff 75 14             	pushl  0x14(%ebp)
  280172:	ff 75 10             	pushl  0x10(%ebp)
  280175:	ff 75 0c             	pushl  0xc(%ebp)
  280178:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  28017c:	50                   	push   %eax
  28017d:	68 40 01 00 00       	push   $0x140
  280182:	68 00 00 0a 00       	push   $0xa0000
  280187:	e8 ae ff ff ff       	call   28013a <boxfill8>
  28018c:	83 c4 1c             	add    $0x1c,%esp
}
  28018f:	c9                   	leave  
  280190:	c3                   	ret    

00280191 <draw_window>:

void draw_window()
{ 
  280191:	55                   	push   %ebp
  280192:	89 e5                	mov    %esp,%ebp
  int x=320,y=200;
    p=(unsigned char*)VRAM;
//     boxfill8(p,320,110,20,20,250,150);
    
    //draw a window
    boxfill(7 ,0, 0   ,x-1,y-29);
  280194:	68 ab 00 00 00       	push   $0xab
  280199:	68 3f 01 00 00       	push   $0x13f
  28019e:	6a 00                	push   $0x0
  2801a0:	6a 00                	push   $0x0
  2801a2:	6a 07                	push   $0x7
  2801a4:	e8 c0 ff ff ff       	call   280169 <boxfill>
//task button    
    boxfill(8  ,0, y-28,x-1,y-28);
  2801a9:	68 ac 00 00 00       	push   $0xac
  2801ae:	68 3f 01 00 00       	push   $0x13f
  2801b3:	68 ac 00 00 00       	push   $0xac
  2801b8:	6a 00                	push   $0x0
  2801ba:	6a 08                	push   $0x8
  2801bc:	e8 a8 ff ff ff       	call   280169 <boxfill>
    boxfill(7  ,0, y-27,x-1,y-27);
  2801c1:	83 c4 28             	add    $0x28,%esp
  2801c4:	68 ad 00 00 00       	push   $0xad
  2801c9:	68 3f 01 00 00       	push   $0x13f
  2801ce:	68 ad 00 00 00       	push   $0xad
  2801d3:	6a 00                	push   $0x0
  2801d5:	6a 07                	push   $0x7
  2801d7:	e8 8d ff ff ff       	call   280169 <boxfill>
    boxfill(8  ,0, y-26,x-1,y-1);
  2801dc:	68 c7 00 00 00       	push   $0xc7
  2801e1:	68 3f 01 00 00       	push   $0x13f
  2801e6:	68 ae 00 00 00       	push   $0xae
  2801eb:	6a 00                	push   $0x0
  2801ed:	6a 08                	push   $0x8
  2801ef:	e8 75 ff ff ff       	call   280169 <boxfill>
    
    
//left button    
    boxfill(7, 3,  y-24, 59,  y-24);
  2801f4:	83 c4 28             	add    $0x28,%esp
  2801f7:	68 b0 00 00 00       	push   $0xb0
  2801fc:	6a 3b                	push   $0x3b
  2801fe:	68 b0 00 00 00       	push   $0xb0
  280203:	6a 03                	push   $0x3
  280205:	6a 07                	push   $0x7
  280207:	e8 5d ff ff ff       	call   280169 <boxfill>
    boxfill(7, 2,  y-24, 2 ,  y-4);  
  28020c:	68 c4 00 00 00       	push   $0xc4
  280211:	6a 02                	push   $0x2
  280213:	68 b0 00 00 00       	push   $0xb0
  280218:	6a 02                	push   $0x2
  28021a:	6a 07                	push   $0x7
  28021c:	e8 48 ff ff ff       	call   280169 <boxfill>
    boxfill(15, 3,  y-4,  59,  y-4);
  280221:	83 c4 28             	add    $0x28,%esp
  280224:	68 c4 00 00 00       	push   $0xc4
  280229:	6a 3b                	push   $0x3b
  28022b:	68 c4 00 00 00       	push   $0xc4
  280230:	6a 03                	push   $0x3
  280232:	6a 0f                	push   $0xf
  280234:	e8 30 ff ff ff       	call   280169 <boxfill>
    boxfill(15, 59, y-23, 59,  y-5);
  280239:	68 c3 00 00 00       	push   $0xc3
  28023e:	6a 3b                	push   $0x3b
  280240:	68 b1 00 00 00       	push   $0xb1
  280245:	6a 3b                	push   $0x3b
  280247:	6a 0f                	push   $0xf
  280249:	e8 1b ff ff ff       	call   280169 <boxfill>
    boxfill(0, 2,  y-3,  59,  y-3);
  28024e:	83 c4 28             	add    $0x28,%esp
  280251:	68 c5 00 00 00       	push   $0xc5
  280256:	6a 3b                	push   $0x3b
  280258:	68 c5 00 00 00       	push   $0xc5
  28025d:	6a 02                	push   $0x2
  28025f:	6a 00                	push   $0x0
  280261:	e8 03 ff ff ff       	call   280169 <boxfill>
    boxfill(0, 60, y-24, 60,  y-3);  
  280266:	68 c5 00 00 00       	push   $0xc5
  28026b:	6a 3c                	push   $0x3c
  28026d:	68 b0 00 00 00       	push   $0xb0
  280272:	6a 3c                	push   $0x3c
  280274:	6a 00                	push   $0x0
  280276:	e8 ee fe ff ff       	call   280169 <boxfill>

// 
//right button    
    boxfill(15, x-47, y-24,x-4,y-24);
  28027b:	83 c4 28             	add    $0x28,%esp
  28027e:	68 b0 00 00 00       	push   $0xb0
  280283:	68 3c 01 00 00       	push   $0x13c
  280288:	68 b0 00 00 00       	push   $0xb0
  28028d:	68 11 01 00 00       	push   $0x111
  280292:	6a 0f                	push   $0xf
  280294:	e8 d0 fe ff ff       	call   280169 <boxfill>
    boxfill(15, x-47, y-23,x-47,y-4);  
  280299:	68 c4 00 00 00       	push   $0xc4
  28029e:	68 11 01 00 00       	push   $0x111
  2802a3:	68 b1 00 00 00       	push   $0xb1
  2802a8:	68 11 01 00 00       	push   $0x111
  2802ad:	6a 0f                	push   $0xf
  2802af:	e8 b5 fe ff ff       	call   280169 <boxfill>
    boxfill(7, x-47, y-3,x-4,y-3);
  2802b4:	83 c4 28             	add    $0x28,%esp
  2802b7:	68 c5 00 00 00       	push   $0xc5
  2802bc:	68 3c 01 00 00       	push   $0x13c
  2802c1:	68 c5 00 00 00       	push   $0xc5
  2802c6:	68 11 01 00 00       	push   $0x111
  2802cb:	6a 07                	push   $0x7
  2802cd:	e8 97 fe ff ff       	call   280169 <boxfill>
    boxfill(7, x-3, y-24,x-3,y-3);
  2802d2:	68 c5 00 00 00       	push   $0xc5
  2802d7:	68 3d 01 00 00       	push   $0x13d
  2802dc:	68 b0 00 00 00       	push   $0xb0
  2802e1:	68 3d 01 00 00       	push   $0x13d
  2802e6:	6a 07                	push   $0x7
  2802e8:	e8 7c fe ff ff       	call   280169 <boxfill>
  2802ed:	83 c4 28             	add    $0x28,%esp
}
  2802f0:	c9                   	leave  
  2802f1:	c3                   	ret    

002802f2 <init_screen>:


void init_screen(struct boot_info * bootp)
{
  2802f2:	55                   	push   %ebp
  2802f3:	89 e5                	mov    %esp,%ebp
  2802f5:	8b 45 08             	mov    0x8(%ebp),%eax
  bootp->vram=(char *)VRAM;
  2802f8:	c7 40 08 00 00 0a 00 	movl   $0xa0000,0x8(%eax)
  bootp->color_mode=8;
  2802ff:	c6 40 02 08          	movb   $0x8,0x2(%eax)
  bootp->xsize=320;
  280303:	66 c7 40 04 40 01    	movw   $0x140,0x4(%eax)
  bootp->ysize=200;
  280309:	66 c7 40 06 c8 00    	movw   $0xc8,0x6(%eax)
  
}
  28030f:	5d                   	pop    %ebp
  280310:	c3                   	ret    

00280311 <init_mouse>:

///关于mouse的函数
void init_mouse(char *mouse,char bg)
{
  280311:	55                   	push   %ebp
  280312:	31 c9                	xor    %ecx,%ecx
  280314:	89 e5                	mov    %esp,%ebp
  280316:	8a 45 0c             	mov    0xc(%ebp),%al
  280319:	8b 55 08             	mov    0x8(%ebp),%edx
  28031c:	56                   	push   %esi
  28031d:	53                   	push   %ebx
  28031e:	89 c6                	mov    %eax,%esi
  280320:	31 c0                	xor    %eax,%eax
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
  280322:	8a 9c 01 00 23 28 00 	mov    0x282300(%ecx,%eax,1),%bl
  280329:	80 fb 2e             	cmp    $0x2e,%bl
  28032c:	74 10                	je     28033e <init_mouse+0x2d>
  28032e:	80 fb 4f             	cmp    $0x4f,%bl
  280331:	74 12                	je     280345 <init_mouse+0x34>
  280333:	80 fb 2a             	cmp    $0x2a,%bl
  280336:	75 11                	jne    280349 <init_mouse+0x38>
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
	      case '*':mouse[x+16*y]=outline;break;   //outline
  280338:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
  28033c:	eb 0b                	jmp    280349 <init_mouse+0x38>
	{
	  for(x=0;x<16;x++)
	  {
	    switch (cursor[y][x])
	    {
	      case '.':mouse[x+16*y]=bg;break;  //background
  28033e:	89 f3                	mov    %esi,%ebx
  280340:	88 1c 02             	mov    %bl,(%edx,%eax,1)
  280343:	eb 04                	jmp    280349 <init_mouse+0x38>
	      case '*':mouse[x+16*y]=outline;break;   //outline
	      case 'O':mouse[x+16*y]=inside;break;  //inside
  280345:	c6 04 02 02          	movb   $0x2,(%edx,%eax,1)
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
	{
	  for(x=0;x<16;x++)
  280349:	40                   	inc    %eax
  28034a:	83 f8 10             	cmp    $0x10,%eax
  28034d:	75 d3                	jne    280322 <init_mouse+0x11>
  28034f:	83 c1 10             	add    $0x10,%ecx
  280352:	83 c2 10             	add    $0x10,%edx
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x,y;
	for(y=0;y<16;y++)
  280355:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  28035b:	75 c3                	jne    280320 <init_mouse+0xf>
	    
	  }
	  
	}
  
}
  28035d:	5b                   	pop    %ebx
  28035e:	5e                   	pop    %esi
  28035f:	5d                   	pop    %ebp
  280360:	c3                   	ret    

00280361 <display_mouse>:

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  280361:	55                   	push   %ebp
  280362:	89 e5                	mov    %esp,%ebp
  280364:	8b 45 1c             	mov    0x1c(%ebp),%eax
  280367:	56                   	push   %esi
  int x,y;
  for(y=0;y<pysize;y++)
  280368:	31 f6                	xor    %esi,%esi
	}
  
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  28036a:	53                   	push   %ebx
  28036b:	8b 5d 20             	mov    0x20(%ebp),%ebx
  28036e:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280372:	03 45 18             	add    0x18(%ebp),%eax
  280375:	03 45 08             	add    0x8(%ebp),%eax
  int x,y;
  for(y=0;y<pysize;y++)
  280378:	3b 75 14             	cmp    0x14(%ebp),%esi
  28037b:	7d 19                	jge    280396 <display_mouse+0x35>
  28037d:	31 d2                	xor    %edx,%edx
  {
    for(x=0;x<pxsize;x++)
  28037f:	3b 55 10             	cmp    0x10(%ebp),%edx
  280382:	7d 09                	jge    28038d <display_mouse+0x2c>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
  280384:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  280387:	88 0c 10             	mov    %cl,(%eax,%edx,1)
void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  {
    for(x=0;x<pxsize;x++)
  28038a:	42                   	inc    %edx
  28038b:	eb f2                	jmp    28037f <display_mouse+0x1e>
}

void display_mouse(char *vram,int xsize,int pxsize,int pysize,int px0,int py0,char *buf,int bxsize)
{
  int x,y;
  for(y=0;y<pysize;y++)
  28038d:	46                   	inc    %esi
  28038e:	03 5d 24             	add    0x24(%ebp),%ebx
  280391:	03 45 0c             	add    0xc(%ebp),%eax
  280394:	eb e2                	jmp    280378 <display_mouse+0x17>
    {
     vram[(py0+y)*xsize+(px0+x)]=buf[y*bxsize+x];
    }
  }
  
}
  280396:	5b                   	pop    %ebx
  280397:	5e                   	pop    %esi
  280398:	5d                   	pop    %ebp
  280399:	c3                   	ret    

0028039a <itoa>:
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  28039a:	55                   	push   %ebp
    char tmp_buf[10] = {0};
  28039b:	31 c0                	xor    %eax,%eax
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  28039d:	89 e5                	mov    %esp,%ebp
    char tmp_buf[10] = {0};
  28039f:	b9 0a 00 00 00       	mov    $0xa,%ecx
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  2803a4:	57                   	push   %edi
  2803a5:	56                   	push   %esi
  2803a6:	53                   	push   %ebx
  2803a7:	83 ec 10             	sub    $0x10,%esp
  2803aa:	8b 55 08             	mov    0x8(%ebp),%edx
    char tmp_buf[10] = {0};
  2803ad:	8d 7d ea             	lea    -0x16(%ebp),%edi
sprintf(font,"Debug:var=%x" ,i);
puts8((char *)VRAM ,320,x,150,1,font);

}

void itoa(int value,char *buf){
  2803b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    char tmp_buf[10] = {0};
  2803b3:	f3 aa                	rep stos %al,%es:(%edi)
  2803b5:	8d 7d ea             	lea    -0x16(%ebp),%edi
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
  2803b8:	85 d2                	test   %edx,%edx
  2803ba:	79 06                	jns    2803c2 <itoa+0x28>
    { /* neg num */
        *buf++ = '-';//得到负号
  2803bc:	c6 03 2d             	movb   $0x2d,(%ebx)
        value = ~value + 1; //将负数变为正数
  2803bf:	f7 da                	neg    %edx
void itoa(int value,char *buf){
    char tmp_buf[10] = {0};
    char *tbp = tmp_buf;
    if((value >> 31) & 0x1)
    { /* neg num */
        *buf++ = '-';//得到负号
  2803c1:	43                   	inc    %ebx
  2803c2:	89 f9                	mov    %edi,%ecx
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803c4:	be 0a 00 00 00       	mov    $0xa,%esi
  2803c9:	89 d0                	mov    %edx,%eax
  2803cb:	41                   	inc    %ecx
  2803cc:	99                   	cltd   
  2803cd:	f7 fe                	idiv   %esi
  2803cf:	83 c2 30             	add    $0x30,%edx
        value /= 10;
    }while(value);
  2803d2:	85 c0                	test   %eax,%eax
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803d4:	88 51 ff             	mov    %dl,-0x1(%ecx)
        value /= 10;
  2803d7:	89 c2                	mov    %eax,%edx
    }while(value);
  2803d9:	75 ee                	jne    2803c9 <itoa+0x2f>
    
    
  
    do
    {
        *tbp++ = ('0' + (char)(value % 10));//得到低位数字
  2803db:	89 ce                	mov    %ecx,%esi
  2803dd:	89 d8                	mov    %ebx,%eax
        value /= 10;
    }while(value);
    
    
    while(tmp_buf != tbp)
  2803df:	39 f9                	cmp    %edi,%ecx
  2803e1:	74 09                	je     2803ec <itoa+0x52>
    {
      tbp--;
  2803e3:	49                   	dec    %ecx
      *buf++ = *tbp;
  2803e4:	8a 11                	mov    (%ecx),%dl
  2803e6:	40                   	inc    %eax
  2803e7:	88 50 ff             	mov    %dl,-0x1(%eax)
  2803ea:	eb f3                	jmp    2803df <itoa+0x45>
  2803ec:	89 f0                	mov    %esi,%eax
  2803ee:	29 c8                	sub    %ecx,%eax

    }
    *buf='\0';
  2803f0:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)
    
    
}
  2803f4:	83 c4 10             	add    $0x10,%esp
  2803f7:	5b                   	pop    %ebx
  2803f8:	5e                   	pop    %esi
  2803f9:	5f                   	pop    %edi
  2803fa:	5d                   	pop    %ebp
  2803fb:	c3                   	ret    

002803fc <xtoa>:
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2803fc:	55                   	push   %ebp
    char tmp_buf[30] = {0};
  2803fd:	31 c0                	xor    %eax,%eax
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  2803ff:	89 e5                	mov    %esp,%ebp
    char tmp_buf[30] = {0};
  280401:	b9 1e 00 00 00       	mov    $0x1e,%ecx
    else
        value = value + 48;
    return value;
}

void xtoa(unsigned int value,char *buf){
  280406:	57                   	push   %edi
  280407:	56                   	push   %esi
  280408:	53                   	push   %ebx
  280409:	83 ec 20             	sub    $0x20,%esp
  28040c:	8b 55 0c             	mov    0xc(%ebp),%edx
    char tmp_buf[30] = {0};
  28040f:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280412:	f3 aa                	rep stos %al,%es:(%edi)
    char *tbp = tmp_buf;
  280414:	8d 45 d6             	lea    -0x2a(%ebp),%eax

    *buf++='0';
  280417:	c6 02 30             	movb   $0x30,(%edx)
    *buf++='x';
  28041a:	8d 72 02             	lea    0x2(%edx),%esi
  28041d:	c6 42 01 78          	movb   $0x78,0x1(%edx)
  
    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  280421:	8b 5d 08             	mov    0x8(%ebp),%ebx
  280424:	40                   	inc    %eax
  280425:	83 e3 0f             	and    $0xf,%ebx
    
    
}
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
  280428:	83 fb 0a             	cmp    $0xa,%ebx
  28042b:	8d 4b 37             	lea    0x37(%ebx),%ecx
  28042e:	8d 7b 30             	lea    0x30(%ebx),%edi
  280431:	0f 4c cf             	cmovl  %edi,%ecx
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
        
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  280434:	c1 6d 08 04          	shrl   $0x4,0x8(%ebp)
static  inline char fourbtoc(int value){
    if(value >= 10)
        value = value - 10 + 65;
    else
        value = value + 48;
    return value;
  280438:	88 48 ff             	mov    %cl,-0x1(%eax)
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
        
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
  28043b:	75 e4                	jne    280421 <xtoa+0x25>
    *buf++='x';
  
    do
    {
        // *tbp++ = ('0' + (char)(value % 16));//得到低位数字
	*tbp++=fourbtoc(value&0x0000000f);
  28043d:	89 c3                	mov    %eax,%ebx
        //*tbp++ = ((value % 16)>9)?('A' + (char)(value % 16-10)):('0' + (char)(value % 16));//得到低位数字
        value >>= 4;
    }while(value);
    
    
    while(tmp_buf != tbp)
  28043f:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  280442:	39 f8                	cmp    %edi,%eax
  280444:	74 09                	je     28044f <xtoa+0x53>
    {
      tbp--;
  280446:	48                   	dec    %eax
      *buf++ = *tbp;
  280447:	8a 08                	mov    (%eax),%cl
  280449:	46                   	inc    %esi
  28044a:	88 4e ff             	mov    %cl,-0x1(%esi)
  28044d:	eb f0                	jmp    28043f <xtoa+0x43>
  28044f:	29 c3                	sub    %eax,%ebx

    }
    *buf='\0';
  280451:	c6 44 1a 02 00       	movb   $0x0,0x2(%edx,%ebx,1)
    
    
}
  280456:	83 c4 20             	add    $0x20,%esp
  280459:	5b                   	pop    %ebx
  28045a:	5e                   	pop    %esi
  28045b:	5f                   	pop    %edi
  28045c:	5d                   	pop    %ebp
  28045d:	c3                   	ret    

0028045e <sprintf>:



//实现可变参数的打印，主要是为了观察打印的变量。
void sprintf(char *str,char *format ,...)
{
  28045e:	55                   	push   %ebp
  28045f:	89 e5                	mov    %esp,%ebp
  280461:	57                   	push   %edi
  280462:	56                   	push   %esi
  280463:	53                   	push   %ebx
  280464:	83 ec 10             	sub    $0x10,%esp
  280467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
  28046a:	8d 75 10             	lea    0x10(%ebp),%esi
   char buffer[10];
   char *buf=buffer;
  while(*format)
  28046d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  280470:	8a 07                	mov    (%edi),%al
  280472:	84 c0                	test   %al,%al
  280474:	0f 84 83 00 00 00    	je     2804fd <sprintf+0x9f>
  28047a:	8d 4f 01             	lea    0x1(%edi),%ecx
  {
      if(*format!='%')
  28047d:	3c 25                	cmp    $0x25,%al
      {
	*str++=*format++;
  28047f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
   int *var=(int *)(&format)+1; //得到第一个可变参数的地址
   char buffer[10];
   char *buf=buffer;
  while(*format)
  {
      if(*format!='%')
  280482:	74 05                	je     280489 <sprintf+0x2b>
      {
	*str++=*format++;
  280484:	88 03                	mov    %al,(%ebx)
  280486:	43                   	inc    %ebx
	continue;
  280487:	eb e4                	jmp    28046d <sprintf+0xf>
      }
      else
      {
	format++;
	switch (*format)
  280489:	8a 47 01             	mov    0x1(%edi),%al
  28048c:	3c 73                	cmp    $0x73,%al
  28048e:	74 46                	je     2804d6 <sprintf+0x78>
  280490:	3c 78                	cmp    $0x78,%al
  280492:	74 23                	je     2804b7 <sprintf+0x59>
  280494:	3c 64                	cmp    $0x64,%al
  280496:	75 53                	jne    2804eb <sprintf+0x8d>
	{
	  case 'd':itoa(*var,buf);while(*buf){*str++=*buf++;};break;
  280498:	8d 45 ea             	lea    -0x16(%ebp),%eax
  28049b:	50                   	push   %eax
  28049c:	ff 36                	pushl  (%esi)
  28049e:	e8 f7 fe ff ff       	call   28039a <itoa>
  2804a3:	59                   	pop    %ecx
  2804a4:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  2804a7:	58                   	pop    %eax
  2804a8:	89 d8                	mov    %ebx,%eax
  2804aa:	8a 19                	mov    (%ecx),%bl
  2804ac:	84 db                	test   %bl,%bl
  2804ae:	74 3d                	je     2804ed <sprintf+0x8f>
  2804b0:	40                   	inc    %eax
  2804b1:	41                   	inc    %ecx
  2804b2:	88 58 ff             	mov    %bl,-0x1(%eax)
  2804b5:	eb f3                	jmp    2804aa <sprintf+0x4c>
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
  2804b7:	8d 45 ea             	lea    -0x16(%ebp),%eax
  2804ba:	50                   	push   %eax
  2804bb:	ff 36                	pushl  (%esi)
  2804bd:	e8 3a ff ff ff       	call   2803fc <xtoa>
  2804c2:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  2804c5:	58                   	pop    %eax
  2804c6:	89 d8                	mov    %ebx,%eax
  2804c8:	5a                   	pop    %edx
  2804c9:	8a 19                	mov    (%ecx),%bl
  2804cb:	84 db                	test   %bl,%bl
  2804cd:	74 1e                	je     2804ed <sprintf+0x8f>
  2804cf:	40                   	inc    %eax
  2804d0:	41                   	inc    %ecx
  2804d1:	88 58 ff             	mov    %bl,-0x1(%eax)
  2804d4:	eb f3                	jmp    2804c9 <sprintf+0x6b>
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
  2804d6:	8b 16                	mov    (%esi),%edx
  2804d8:	89 d8                	mov    %ebx,%eax
  2804da:	89 c1                	mov    %eax,%ecx
  2804dc:	29 d9                	sub    %ebx,%ecx
  2804de:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
  2804e1:	84 c9                	test   %cl,%cl
  2804e3:	74 08                	je     2804ed <sprintf+0x8f>
  2804e5:	40                   	inc    %eax
  2804e6:	88 48 ff             	mov    %cl,-0x1(%eax)
  2804e9:	eb ef                	jmp    2804da <sprintf+0x7c>
	continue;
      }
      else
      {
	format++;
	switch (*format)
  2804eb:	89 d8                	mov    %ebx,%eax
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
	  
	}
	buf=buffer;
	var++;
	format++;
  2804ed:	83 c7 02             	add    $0x2,%edi
	  case 'x':xtoa(*var,buf);while(*buf){*str++=*buf++;};break;
	  case 's':buf=(char*)(*var);while(*buf){*str++=*buf++;};break;
	  
	}
	buf=buffer;
	var++;
  2804f0:	83 c6 04             	add    $0x4,%esi
	format++;
  2804f3:	89 7d 0c             	mov    %edi,0xc(%ebp)
  2804f6:	89 c3                	mov    %eax,%ebx
  2804f8:	e9 70 ff ff ff       	jmp    28046d <sprintf+0xf>
	
      }
    
  }
  *str='\0';
  2804fd:	c6 03 00             	movb   $0x0,(%ebx)
  
}
  280500:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280503:	5b                   	pop    %ebx
  280504:	5e                   	pop    %esi
  280505:	5f                   	pop    %edi
  280506:	5d                   	pop    %ebp
  280507:	c3                   	ret    

00280508 <putfont8>:
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280508:	55                   	push   %ebp
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280509:	31 d2                	xor    %edx,%edx
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  28050b:	89 e5                	mov    %esp,%ebp
  28050d:	57                   	push   %edi
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  28050e:	bf 80 00 00 00       	mov    $0x80,%edi
}
  
}

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280513:	56                   	push   %esi
  280514:	53                   	push   %ebx
  280515:	83 ec 01             	sub    $0x1,%esp
  280518:	8a 45 18             	mov    0x18(%ebp),%al
  28051b:	88 45 f3             	mov    %al,-0xd(%ebp)
  28051e:	8b 45 14             	mov    0x14(%ebp),%eax
  280521:	0f af 45 0c          	imul   0xc(%ebp),%eax
  280525:	03 45 10             	add    0x10(%ebp),%eax
  280528:	03 45 08             	add    0x8(%ebp),%eax
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
    {
      if(d&(0x80>>col))
  28052b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  28052e:	31 c9                	xor    %ecx,%ecx
    {
      if(d&(0x80>>col))
  280530:	0f be 34 16          	movsbl (%esi,%edx,1),%esi
  280534:	89 fb                	mov    %edi,%ebx
  280536:	d3 fb                	sar    %cl,%ebx
  280538:	85 f3                	test   %esi,%ebx
  28053a:	74 06                	je     280542 <putfont8+0x3a>
      {
	vram[(y+row)*xsize+x+col]=color;
  28053c:	8a 5d f3             	mov    -0xd(%ebp),%bl
  28053f:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  int row,col;
  char d;
  for(row=0;row<16;row++)
  {
    d=font[row];
    for(col=0;col<8;col++)
  280542:	41                   	inc    %ecx
  280543:	83 f9 08             	cmp    $0x8,%ecx
  280546:	75 ec                	jne    280534 <putfont8+0x2c>

void putfont8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  int row,col;
  char d;
  for(row=0;row<16;row++)
  280548:	42                   	inc    %edx
  280549:	03 45 0c             	add    0xc(%ebp),%eax
  28054c:	83 fa 10             	cmp    $0x10,%edx
  28054f:	75 da                	jne    28052b <putfont8+0x23>
    }
    
  }
  return;
  
}
  280551:	83 c4 01             	add    $0x1,%esp
  280554:	5b                   	pop    %ebx
  280555:	5e                   	pop    %esi
  280556:	5f                   	pop    %edi
  280557:	5d                   	pop    %ebp
  280558:	c3                   	ret    

00280559 <puts8>:
  *str='\0';
  
}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280559:	55                   	push   %ebp
  28055a:	89 e5                	mov    %esp,%ebp
  28055c:	57                   	push   %edi
  28055d:	8b 7d 14             	mov    0x14(%ebp),%edi
  280560:	56                   	push   %esi
      y=y+16;
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  280561:	0f be 75 18          	movsbl 0x18(%ebp),%esi
  *str='\0';
  
}

void puts8(char *vram ,int xsize,int x,int y,char color,char *font)//x=0 311 y=0 183
{
  280565:	53                   	push   %ebx
  280566:	8b 5d 10             	mov    0x10(%ebp),%ebx
  
 while(*font)
  280569:	8b 45 1c             	mov    0x1c(%ebp),%eax
  28056c:	0f be 00             	movsbl (%eax),%eax
  28056f:	84 c0                	test   %al,%al
  280571:	74 42                	je     2805b5 <puts8+0x5c>
 {
    if(*font=='\n')
  280573:	3c 0a                	cmp    $0xa,%al
  280575:	75 05                	jne    28057c <puts8+0x23>
    {
      x=0;
      y=y+16;
  280577:	83 c7 10             	add    $0x10,%edi
  28057a:	eb 32                	jmp    2805ae <puts8+0x55>
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  28057c:	c1 e0 04             	shl    $0x4,%eax
  28057f:	05 00 09 28 00       	add    $0x280900,%eax
  280584:	50                   	push   %eax
  280585:	56                   	push   %esi
  280586:	57                   	push   %edi
  280587:	53                   	push   %ebx
    x+=8;
  280588:	83 c3 08             	add    $0x8,%ebx
      y=y+16;
      
    }
    else
    {  
    putfont8((char *)vram ,xsize,x,y,color,(char *)(Font8x16+(*font)*16));
  28058b:	ff 75 0c             	pushl  0xc(%ebp)
  28058e:	ff 75 08             	pushl  0x8(%ebp)
  280591:	e8 72 ff ff ff       	call   280508 <putfont8>
    x+=8;
    if(x>312)
  280596:	83 c4 18             	add    $0x18,%esp
  280599:	81 fb 38 01 00 00    	cmp    $0x138,%ebx
  28059f:	7e 0f                	jle    2805b0 <puts8+0x57>
       {
	  x=0;
	  y+=16;
  2805a1:	83 c7 10             	add    $0x10,%edi
	  if(y>183)
  2805a4:	81 ff b7 00 00 00    	cmp    $0xb7,%edi
  2805aa:	7e 02                	jle    2805ae <puts8+0x55>
	  {
	    x=0;
	    y=0;
  2805ac:	31 ff                	xor    %edi,%edi
       {
	  x=0;
	  y+=16;
	  if(y>183)
	  {
	    x=0;
  2805ae:	31 db                	xor    %ebx,%ebx
	    
	  }
        }    
    }
    
    font++;
  2805b0:	ff 45 1c             	incl   0x1c(%ebp)
  2805b3:	eb b4                	jmp    280569 <puts8+0x10>
}
  
}
  2805b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  2805b8:	5b                   	pop    %ebx
  2805b9:	5e                   	pop    %esi
  2805ba:	5f                   	pop    %edi
  2805bb:	5d                   	pop    %ebp
  2805bc:	c3                   	ret    

002805bd <printdebug>:
#include<header.h>


void printdebug(int i,int x)
{
  2805bd:	55                   	push   %ebp
  2805be:	89 e5                	mov    %esp,%ebp
  2805c0:	53                   	push   %ebx
  2805c1:	83 ec 20             	sub    $0x20,%esp
char font[30];
sprintf(font,"Debug:var=%x" ,i);
  2805c4:	ff 75 08             	pushl  0x8(%ebp)
  2805c7:	8d 5d de             	lea    -0x22(%ebp),%ebx
  2805ca:	68 a8 27 28 00       	push   $0x2827a8
  2805cf:	53                   	push   %ebx
  2805d0:	e8 89 fe ff ff       	call   28045e <sprintf>
puts8((char *)VRAM ,320,x,150,1,font);
  2805d5:	53                   	push   %ebx
  2805d6:	6a 01                	push   $0x1
  2805d8:	68 96 00 00 00       	push   $0x96
  2805dd:	ff 75 0c             	pushl  0xc(%ebp)
  2805e0:	68 40 01 00 00       	push   $0x140
  2805e5:	68 00 00 0a 00       	push   $0xa0000
  2805ea:	e8 6a ff ff ff       	call   280559 <puts8>
  2805ef:	83 c4 24             	add    $0x24,%esp

}
  2805f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2805f5:	c9                   	leave  
  2805f6:	c3                   	ret    

002805f7 <putfont16>:
      
  }
  
}
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  2805f7:	55                   	push   %ebp
  2805f8:	31 c9                	xor    %ecx,%ecx
  2805fa:	89 e5                	mov    %esp,%ebp
  2805fc:	57                   	push   %edi
  2805fd:	56                   	push   %esi
  2805fe:	53                   	push   %ebx
  2805ff:	52                   	push   %edx
  280600:	8b 55 14             	mov    0x14(%ebp),%edx
  280603:	0f af 55 0c          	imul   0xc(%ebp),%edx
  280607:	8b 45 10             	mov    0x10(%ebp),%eax
  28060a:	03 45 08             	add    0x8(%ebp),%eax
  28060d:	8a 5d 18             	mov    0x18(%ebp),%bl
  280610:	01 d0                	add    %edx,%eax
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280612:	31 d2                	xor    %edx,%edx
  280614:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    d=pt[row];
    for(col=0;col<16;col++)
    {
       if( (d&(1 << col) ))
  280617:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  28061a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  28061d:	0f b7 bc 57 00 fa ff 	movzwl -0x600(%edi,%edx,2),%edi
  280624:	ff 
  280625:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280628:	31 c0                	xor    %eax,%eax
    {
       if( (d&(1 << col) ))
  28062a:	0f a3 c7             	bt     %eax,%edi
  28062d:	73 03                	jae    280632 <putfont16+0x3b>
     // if((d<<col)&0x0001)
      {
	vram[(y+row)*xsize+x+col]=color;
  28062f:	88 1c 06             	mov    %bl,(%esi,%eax,1)
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  {
    d=pt[row];
    for(col=0;col<16;col++)
  280632:	40                   	inc    %eax
  280633:	83 f8 10             	cmp    $0x10,%eax
  280636:	75 f2                	jne    28062a <putfont16+0x33>
void putfont16(char *vram ,int xsize,int x,int y,char color,unsigned short *font)//x=0 311 y=0 183
{
  int row,col;
  unsigned short  d;
  unsigned short *pt=(unsigned short *)(font-32*24);
  for(row=0;row<24;row++)
  280638:	42                   	inc    %edx
  280639:	03 4d 0c             	add    0xc(%ebp),%ecx
  28063c:	83 fa 18             	cmp    $0x18,%edx
  28063f:	75 d6                	jne    280617 <putfont16+0x20>
    }
    
  }
  return;
  
}
  280641:	58                   	pop    %eax
  280642:	5b                   	pop    %ebx
  280643:	5e                   	pop    %esi
  280644:	5f                   	pop    %edi
  280645:	5d                   	pop    %ebp
  280646:	c3                   	ret    

00280647 <puts16>:
  return;
  
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  280647:	55                   	push   %ebp
  280648:	89 e5                	mov    %esp,%ebp
  28064a:	57                   	push   %edi
  28064b:	8b 7d 10             	mov    0x10(%ebp),%edi
  28064e:	56                   	push   %esi
  28064f:	8b 75 14             	mov    0x14(%ebp),%esi
  280652:	53                   	push   %ebx
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  280653:	0f be 5d 18          	movsbl 0x18(%ebp),%ebx
}
//print string: big string
void puts16(char *vram ,int xsize,int x,int y,char color,char *font)
{
  unsigned short  *pt;
  while(*font)
  280657:	8b 45 1c             	mov    0x1c(%ebp),%eax
  28065a:	0f be 00             	movsbl (%eax),%eax
  28065d:	84 c0                	test   %al,%al
  28065f:	74 2d                	je     28068e <puts16+0x47>
  {
    if(*font=='\n')
  280661:	3c 0a                	cmp    $0xa,%al
  280663:	75 07                	jne    28066c <puts16+0x25>
    {
      x=0;
      y=y+24;
  280665:	83 c6 18             	add    $0x18,%esi
  unsigned short  *pt;
  while(*font)
  {
    if(*font=='\n')
    {
      x=0;
  280668:	31 ff                	xor    %edi,%edi
  28066a:	eb 1d                	jmp    280689 <puts16+0x42>
      y=y+24;
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
  28066c:	6b c0 30             	imul   $0x30,%eax,%eax
  28066f:	05 00 11 28 00       	add    $0x281100,%eax
	putfont16(vram ,xsize,x,y,color,pt);
  280674:	50                   	push   %eax
  280675:	53                   	push   %ebx
  280676:	56                   	push   %esi
  280677:	57                   	push   %edi
	x=x+16;
  280678:	83 c7 10             	add    $0x10,%edi
      
    }
    else
    {
	pt=(unsigned short *)((*font)*24+ASCII_Table);
	putfont16(vram ,xsize,x,y,color,pt);
  28067b:	ff 75 0c             	pushl  0xc(%ebp)
  28067e:	ff 75 08             	pushl  0x8(%ebp)
  280681:	e8 71 ff ff ff       	call   2805f7 <putfont16>
	x=x+16;
  280686:	83 c4 18             	add    $0x18,%esp
	   
	   
    }
    
     font++;
  280689:	ff 45 1c             	incl   0x1c(%ebp)
  28068c:	eb c9                	jmp    280657 <puts16+0x10>
      
  }
  
}
  28068e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  280691:	5b                   	pop    %ebx
  280692:	5e                   	pop    %esi
  280693:	5f                   	pop    %edi
  280694:	5d                   	pop    %ebp
  280695:	c3                   	ret    

00280696 <setgdt>:
#include<header.h>



void setgdt(struct GDT *sd ,unsigned int limit,int base,int access)//sd: selector describe
{
  280696:	55                   	push   %ebp
  280697:	89 e5                	mov    %esp,%ebp
  280699:	8b 55 0c             	mov    0xc(%ebp),%edx
  28069c:	57                   	push   %edi
  28069d:	8b 45 08             	mov    0x8(%ebp),%eax
  2806a0:	56                   	push   %esi
  2806a1:	8b 7d 14             	mov    0x14(%ebp),%edi
  2806a4:	53                   	push   %ebx
  2806a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(limit>0xffff)
  2806a8:	81 fa ff ff 00 00    	cmp    $0xffff,%edx
  2806ae:	76 09                	jbe    2806b9 <setgdt+0x23>
  {
    access|=0x8000;
  2806b0:	81 cf 00 80 00 00    	or     $0x8000,%edi
    limit /=0x1000;
  2806b6:	c1 ea 0c             	shr    $0xc,%edx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  2806b9:	89 de                	mov    %ebx,%esi
  2806bb:	c1 fe 10             	sar    $0x10,%esi
  2806be:	89 f1                	mov    %esi,%ecx
  2806c0:	88 48 04             	mov    %cl,0x4(%eax)
  sd->access_right=access&0xff;
  2806c3:	89 f9                	mov    %edi,%ecx
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806c5:	c1 ff 08             	sar    $0x8,%edi
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  2806c8:	88 48 05             	mov    %cl,0x5(%eax)
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806cb:	89 f9                	mov    %edi,%ecx
  if(limit>0xffff)
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  2806cd:	66 89 10             	mov    %dx,(%eax)
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806d0:	83 e1 f0             	and    $0xfffffff0,%ecx
  2806d3:	c1 ea 10             	shr    $0x10,%edx
  {
    access|=0x8000;
    limit /=0x1000;
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  2806d6:	66 89 58 02          	mov    %bx,0x2(%eax)
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806da:	09 d1                	or     %edx,%ecx
  sd->base_high=(base>>24)&0xff;
  2806dc:	c1 eb 18             	shr    $0x18,%ebx
  }
  sd->limit_low=limit&0xffff;
  sd->base_low=base &0xffff;
  sd->base_mid=(base>>16)&0xff;
  sd->access_right=access&0xff;
  sd->limit_high=((limit>>16)&0x0f)|((access>>8)&0xf0);//低４位是limt的高位，高４位是访问的权限设置。
  2806df:	88 48 06             	mov    %cl,0x6(%eax)
  sd->base_high=(base>>24)&0xff;
  2806e2:	88 58 07             	mov    %bl,0x7(%eax)
  
}
  2806e5:	5b                   	pop    %ebx
  2806e6:	5e                   	pop    %esi
  2806e7:	5f                   	pop    %edi
  2806e8:	5d                   	pop    %ebp
  2806e9:	c3                   	ret    

002806ea <setidt>:

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  2806ea:	55                   	push   %ebp
  2806eb:	89 e5                	mov    %esp,%ebp
  2806ed:	8b 45 08             	mov    0x8(%ebp),%eax
  2806f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  2806f3:	8b 55 14             	mov    0x14(%ebp),%edx
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2806f6:	66 89 08             	mov    %cx,(%eax)
  gd->offset_high=(offset>>16)&0xffff;
  2806f9:	c1 e9 10             	shr    $0x10,%ecx
  2806fc:	66 89 48 06          	mov    %cx,0x6(%eax)
  
  //16位的selector决定了base address
  gd->selector=selector;
  280700:	8b 4d 10             	mov    0x10(%ebp),%ecx
  
  gd->dw_count=(access>>8)&0xff;
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280703:	88 50 05             	mov    %dl,0x5(%eax)
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  
  //16位的selector决定了base address
  gd->selector=selector;
  280706:	66 89 48 02          	mov    %cx,0x2(%eax)
  
  gd->dw_count=(access>>8)&0xff;
  28070a:	89 d1                	mov    %edx,%ecx
  28070c:	c1 f9 08             	sar    $0x8,%ecx
  28070f:	88 48 04             	mov    %cl,0x4(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  
  
}
  280712:	5d                   	pop    %ebp
  280713:	c3                   	ret    

00280714 <init_gdtidt>:



void  init_gdtidt()
{
  280714:	55                   	push   %ebp
  280715:	89 e5                	mov    %esp,%ebp
  280717:	53                   	push   %ebx
  280718:	53                   	push   %ebx
  280719:	bb 00 00 27 00       	mov    $0x270000,%ebx
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  {
    setgdt(gdt+i,0,0,0);
  28071e:	6a 00                	push   $0x0
  280720:	6a 00                	push   $0x0
  280722:	6a 00                	push   $0x0
  280724:	53                   	push   %ebx
  280725:	83 c3 08             	add    $0x8,%ebx
  280728:	e8 69 ff ff ff       	call   280696 <setgdt>
void  init_gdtidt()
{
  struct GDT *gdt=(struct GDT *)(0x00270000);
  struct IDT *idt=(struct IDT *)(0x0026f800);
  int i;
  for(i=0;i<8192;i++)
  28072d:	83 c4 10             	add    $0x10,%esp
  280730:	81 fb 00 00 28 00    	cmp    $0x280000,%ebx
  280736:	75 e6                	jne    28071e <init_gdtidt+0xa>
  {
    setgdt(gdt+i,0,0,0);
  }
  setgdt(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  280738:	68 92 40 00 00       	push   $0x4092
  28073d:	6a 00                	push   $0x0
  28073f:	6a ff                	push   $0xffffffff
  280741:	68 08 00 27 00       	push   $0x270008
  280746:	e8 4b ff ff ff       	call   280696 <setgdt>
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  28074b:	68 9a 40 00 00       	push   $0x409a
  280750:	6a 00                	push   $0x0
  280752:	68 ff ff 0f 00       	push   $0xfffff
  280757:	68 10 00 27 00       	push   $0x270010
  28075c:	e8 35 ff ff ff       	call   280696 <setgdt>
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  280761:	83 c4 20             	add    $0x20,%esp
  280764:	68 9a 40 00 00       	push   $0x409a
  280769:	68 00 00 28 00       	push   $0x280000
  28076e:	68 ff ff 0f 00       	push   $0xfffff
  280773:	68 18 00 27 00       	push   $0x270018
  280778:	e8 19 ff ff ff       	call   280696 <setgdt>

   load_gdtr(0xfff,0X00270000);//this is right
  28077d:	5a                   	pop    %edx
  28077e:	59                   	pop    %ecx
  28077f:	68 00 00 27 00       	push   $0x270000
  280784:	68 ff 0f 00 00       	push   $0xfff
  280789:	e8 4f 01 00 00       	call   2808dd <load_gdtr>
  28078e:	83 c4 10             	add    $0x10,%esp
  280791:	31 c0                	xor    %eax,%eax
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280793:	66 c7 80 00 f8 26 00 	movw   $0x0,0x26f800(%eax)
  28079a:	00 00 
  28079c:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  28079f:	66 c7 80 fe f7 26 00 	movw   $0x0,0x26f7fe(%eax)
  2807a6:	00 00 
  
  //16位的selector决定了base address
  gd->selector=selector;
  2807a8:	66 c7 80 fa f7 26 00 	movw   $0x0,0x26f7fa(%eax)
  2807af:	00 00 
  
  gd->dw_count=(access>>8)&0xff;
  2807b1:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2807b8:	c6 80 fd f7 26 00 00 	movb   $0x0,0x26f7fd(%eax)
  setgdt(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  setgdt(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB

   load_gdtr(0xfff,0X00270000);//this is right

  for(i=0;i<256;i++)
  2807bf:	3d 00 08 00 00       	cmp    $0x800,%eax
  2807c4:	75 cd                	jne    280793 <init_gdtidt+0x7f>

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  gd->offset_high=(offset>>16)&0xffff;
  2807c6:	ba c2 08 28 00       	mov    $0x2808c2,%edx
  2807cb:	66 31 c0             	xor    %ax,%ax
  2807ce:	c1 ea 10             	shr    $0x10,%edx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2807d1:	bb c2 08 28 00       	mov    $0x2808c2,%ebx
  gd->offset_high=(offset>>16)&0xffff;
  2807d6:	89 d1                	mov    %edx,%ecx
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  2807d8:	66 89 98 00 f8 26 00 	mov    %bx,0x26f800(%eax)
  2807df:	83 c0 08             	add    $0x8,%eax
  gd->offset_high=(offset>>16)&0xffff;
  2807e2:	66 89 88 fe f7 26 00 	mov    %cx,0x26f7fe(%eax)
  
  //16位的selector决定了base address
  gd->selector=selector;
  2807e9:	66 c7 80 fa f7 26 00 	movw   $0x10,0x26f7fa(%eax)
  2807f0:	10 00 
  
  gd->dw_count=(access>>8)&0xff;
  2807f2:	c6 80 fc f7 26 00 00 	movb   $0x0,0x26f7fc(%eax)
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  2807f9:	c6 80 fd f7 26 00 8e 	movb   $0x8e,0x26f7fd(%eax)
  for(i=0;i<256;i++)
  {
    setidt(idt+i,0,0,0);
  }
  
  for(i=0;i<256;i++)
  280800:	3d 00 08 00 00       	cmp    $0x800,%eax
  280805:	75 d1                	jne    2807d8 <init_gdtidt+0xc4>
}

void setidt(struct IDT *gd,int offset,int selector,int access)//gd: gate describe
{
  //idt中有32位的offset address
  gd->offset_low=offset & 0xffff;
  280807:	b8 c2 08 28 00       	mov    $0x2808c2,%eax
  28080c:	66 a3 08 f9 26 00    	mov    %ax,0x26f908
  gd->offset_high=(offset>>16)&0xffff;
  280812:	66 89 15 0e f9 26 00 	mov    %dx,0x26f90e
  
  //16位的selector决定了base address
  gd->selector=selector;
  280819:	66 c7 05 0a f9 26 00 	movw   $0x10,0x26f90a
  280820:	10 00 
  
  gd->dw_count=(access>>8)&0xff;
  280822:	c6 05 0c f9 26 00 00 	movb   $0x0,0x26f90c
  gd->access_right=(char)(access&0xff);//晕倒啊，是不是啊，天啊，访问权限是一个非常重要的量，错一点都不行的
  280829:	c6 05 0d f9 26 00 8e 	movb   $0x8e,0x26f90d
      setidt(idt+i,(int)asm_inthandler21,2*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了
    
  }
  setidt(idt+0x21,(int)asm_inthandler21,2*8,0x008e);//用printdebug显示之后，证明这一部分是写进去了

  load_idtr(0x7ff,0x0026f800);//this is right
  280830:	50                   	push   %eax
  280831:	50                   	push   %eax
  280832:	68 00 f8 26 00       	push   $0x26f800
  280837:	68 ff 07 00 00       	push   $0x7ff
  28083c:	e8 ac 00 00 00       	call   2808ed <load_idtr>
  280841:	83 c4 10             	add    $0x10,%esp

  return;

}
  280844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  280847:	c9                   	leave  
  280848:	c3                   	ret    

00280849 <init_pic>:
#define PIC1_ICW4		0x00a1
*/


void init_pic()
{
  280849:	55                   	push   %ebp
// out:write a data to a port
static __inline void
outb(int port, uint8_t data)
{
  //data是变量0%0 , port是变量word１%w1
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  28084a:	ba 21 00 00 00       	mov    $0x21,%edx
  28084f:	89 e5                	mov    %esp,%ebp
  280851:	b0 ff                	mov    $0xff,%al
  280853:	ee                   	out    %al,(%dx)
  280854:	b2 a1                	mov    $0xa1,%dl
  280856:	ee                   	out    %al,(%dx)
  280857:	b0 11                	mov    $0x11,%al
  280859:	b2 20                	mov    $0x20,%dl
  28085b:	ee                   	out    %al,(%dx)
  28085c:	b0 20                	mov    $0x20,%al
  28085e:	b2 21                	mov    $0x21,%dl
  280860:	ee                   	out    %al,(%dx)
  280861:	b0 04                	mov    $0x4,%al
  280863:	ee                   	out    %al,(%dx)
  280864:	b0 01                	mov    $0x1,%al
  280866:	ee                   	out    %al,(%dx)
  280867:	b0 11                	mov    $0x11,%al
  280869:	b2 a0                	mov    $0xa0,%dl
  28086b:	ee                   	out    %al,(%dx)
  28086c:	b0 28                	mov    $0x28,%al
  28086e:	b2 a1                	mov    $0xa1,%dl
  280870:	ee                   	out    %al,(%dx)
  280871:	b0 02                	mov    $0x2,%al
  280873:	ee                   	out    %al,(%dx)
  280874:	b0 01                	mov    $0x1,%al
  280876:	ee                   	out    %al,(%dx)
  280877:	b0 fb                	mov    $0xfb,%al
  280879:	b2 21                	mov    $0x21,%dl
  28087b:	ee                   	out    %al,(%dx)
  28087c:	b0 ff                	mov    $0xff,%al
  28087e:	b2 a1                	mov    $0xa1,%dl
  280880:	ee                   	out    %al,(%dx)

所以cpu发现是产生了int 0到int0x1f时，就知道是非常重要的中断产生了，是不可mask的，一定要执行的。

   */

}
  280881:	5d                   	pop    %ebp
  280882:	c3                   	ret    

00280883 <inthandler21>:

//interrupt service procedure for keyboard
void inthandler21(int *esp)
{
  280883:	55                   	push   %ebp
  280884:	89 e5                	mov    %esp,%ebp
  280886:	83 ec 14             	sub    $0x14,%esp
  struct  boot_info *binfo=(struct boot_info *)ADDR_BOOT;
  boxfill(0,0,0,32*8-1,15);//一个黑色的小box
  280889:	6a 0f                	push   $0xf
  28088b:	68 ff 00 00 00       	push   $0xff
  280890:	6a 00                	push   $0x0
  280892:	6a 00                	push   $0x0
  280894:	6a 00                	push   $0x0
  280896:	e8 ce f8 ff ff       	call   280169 <boxfill>
  puts8((char *)binfo->vram ,binfo->xsize,0,0,7,"int 21(IRQ-1):PS/2 keyboard");
  28089b:	83 c4 18             	add    $0x18,%esp
  28089e:	68 b5 27 28 00       	push   $0x2827b5
  2808a3:	6a 07                	push   $0x7
  2808a5:	6a 00                	push   $0x0
  2808a7:	6a 00                	push   $0x0
  2808a9:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
  2808b0:	50                   	push   %eax
  2808b1:	ff 35 f8 0f 00 00    	pushl  0xff8
  2808b7:	e8 9d fc ff ff       	call   280559 <puts8>
  2808bc:	83 c4 20             	add    $0x20,%esp
  while(1)
  io_halt();
  2808bf:	f4                   	hlt    
  2808c0:	eb fd                	jmp    2808bf <inthandler21+0x3c>

002808c2 <asm_inthandler21>:
.global asm_inthandler21
.global load_gdtr 
.global load_idtr
.code32
asm_inthandler21:
  pushw %es
  2808c2:	66 06                	pushw  %es
  pushw %ds
  2808c4:	66 1e                	pushw  %ds
  pushal
  2808c6:	60                   	pusha  
  movl %esp,%eax
  2808c7:	89 e0                	mov    %esp,%eax
  pushl %eax
  2808c9:	50                   	push   %eax
  movw %ss,%ax
  2808ca:	66 8c d0             	mov    %ss,%ax
  movw %ax,%ds
  2808cd:	8e d8                	mov    %eax,%ds
  movw %ax,%es
  2808cf:	8e c0                	mov    %eax,%es
  call inthandler21
  2808d1:	e8 ad ff ff ff       	call   280883 <inthandler21>
  
  popl %eax
  2808d6:	58                   	pop    %eax
  popal
  2808d7:	61                   	popa   
  popw %ds
  2808d8:	66 1f                	popw   %ds
  popW %es
  2808da:	66 07                	popw   %es
  iret
  2808dc:	cf                   	iret   

002808dd <load_gdtr>:
load_gdtr:		#; void load_gdtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2808dd:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2808e2:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lgdt 6(%esp)
  2808e7:	0f 01 54 24 06       	lgdtl  0x6(%esp)
  ret
  2808ec:	c3                   	ret    

002808ed <load_idtr>:


load_idtr:		#; void load_idtr(int limit, int addr);
  mov 4(%esp) ,%ax
  2808ed:	66 8b 44 24 04       	mov    0x4(%esp),%ax
  mov %ax,6(%esp)
  2808f2:	66 89 44 24 06       	mov    %ax,0x6(%esp)
  lidt 6(%esp)
  2808f7:	0f 01 5c 24 06       	lidtl  0x6(%esp)
  2808fc:	c3                   	ret    

Disassembly of section .rodata:

00280900 <Font8x16>:
	...
  280b10:	00 00                	add    %al,(%eax)
  280b12:	00 10                	add    %dl,(%eax)
  280b14:	10 10                	adc    %dl,(%eax)
  280b16:	10 10                	adc    %dl,(%eax)
  280b18:	10 00                	adc    %al,(%eax)
  280b1a:	10 10                	adc    %dl,(%eax)
  280b1c:	00 00                	add    %al,(%eax)
  280b1e:	00 00                	add    %al,(%eax)
  280b20:	00 00                	add    %al,(%eax)
  280b22:	00 24 24             	add    %ah,(%esp)
  280b25:	24 00                	and    $0x0,%al
	...
  280b33:	24 24                	and    $0x24,%al
  280b35:	7e 24                	jle    280b5b <Font8x16+0x25b>
  280b37:	24 24                	and    $0x24,%al
  280b39:	7e 24                	jle    280b5f <Font8x16+0x25f>
  280b3b:	24 00                	and    $0x0,%al
  280b3d:	00 00                	add    %al,(%eax)
  280b3f:	00 00                	add    %al,(%eax)
  280b41:	00 00                	add    %al,(%eax)
  280b43:	10 7c 90 90          	adc    %bh,-0x70(%eax,%edx,4)
  280b47:	7c 12                	jl     280b5b <Font8x16+0x25b>
  280b49:	12 7c 10 00          	adc    0x0(%eax,%edx,1),%bh
  280b4d:	00 00                	add    %al,(%eax)
  280b4f:	00 00                	add    %al,(%eax)
  280b51:	00 00                	add    %al,(%eax)
  280b53:	00 62 64             	add    %ah,0x64(%edx)
  280b56:	08 10                	or     %dl,(%eax)
  280b58:	20 4c 8c 00          	and    %cl,0x0(%esp,%ecx,4)
	...
  280b64:	18 24 20             	sbb    %ah,(%eax,%eiz,1)
  280b67:	50                   	push   %eax
  280b68:	8a 84 4a 30 00 00 00 	mov    0x30(%edx,%ecx,2),%al
  280b6f:	00 00                	add    %al,(%eax)
  280b71:	00 00                	add    %al,(%eax)
  280b73:	10 10                	adc    %dl,(%eax)
  280b75:	20 00                	and    %al,(%eax)
	...
  280b7f:	00 00                	add    %al,(%eax)
  280b81:	00 08                	add    %cl,(%eax)
  280b83:	10 20                	adc    %ah,(%eax)
  280b85:	20 20                	and    %ah,(%eax)
  280b87:	20 20                	and    %ah,(%eax)
  280b89:	20 20                	and    %ah,(%eax)
  280b8b:	10 08                	adc    %cl,(%eax)
  280b8d:	00 00                	add    %al,(%eax)
  280b8f:	00 00                	add    %al,(%eax)
  280b91:	00 20                	add    %ah,(%eax)
  280b93:	10 08                	adc    %cl,(%eax)
  280b95:	08 08                	or     %cl,(%eax)
  280b97:	08 08                	or     %cl,(%eax)
  280b99:	08 08                	or     %cl,(%eax)
  280b9b:	10 20                	adc    %ah,(%eax)
	...
  280ba5:	10 54 38 38          	adc    %dl,0x38(%eax,%edi,1)
  280ba9:	54                   	push   %esp
  280baa:	10 00                	adc    %al,(%eax)
	...
  280bb4:	00 10                	add    %dl,(%eax)
  280bb6:	10 7c 10 10          	adc    %bh,0x10(%eax,%edx,1)
	...
  280bca:	10 10                	adc    %dl,(%eax)
  280bcc:	20 00                	and    %al,(%eax)
	...
  280bd6:	00 7c 00 00          	add    %bh,0x0(%eax,%eax,1)
	...
  280bea:	00 10                	add    %dl,(%eax)
	...
  280bf4:	00 02                	add    %al,(%edx)
  280bf6:	04 08                	add    $0x8,%al
  280bf8:	10 20                	adc    %ah,(%eax)
  280bfa:	40                   	inc    %eax
	...
  280c03:	38 44 44 4c          	cmp    %al,0x4c(%esp,%eax,2)
  280c07:	54                   	push   %esp
  280c08:	64                   	fs
  280c09:	44                   	inc    %esp
  280c0a:	44                   	inc    %esp
  280c0b:	38 00                	cmp    %al,(%eax)
  280c0d:	00 00                	add    %al,(%eax)
  280c0f:	00 00                	add    %al,(%eax)
  280c11:	00 00                	add    %al,(%eax)
  280c13:	10 30                	adc    %dh,(%eax)
  280c15:	10 10                	adc    %dl,(%eax)
  280c17:	10 10                	adc    %dl,(%eax)
  280c19:	10 10                	adc    %dl,(%eax)
  280c1b:	38 00                	cmp    %al,(%eax)
  280c1d:	00 00                	add    %al,(%eax)
  280c1f:	00 00                	add    %al,(%eax)
  280c21:	00 00                	add    %al,(%eax)
  280c23:	38 44 04 04          	cmp    %al,0x4(%esp,%eax,1)
  280c27:	08 10                	or     %dl,(%eax)
  280c29:	20 40 7c             	and    %al,0x7c(%eax)
  280c2c:	00 00                	add    %al,(%eax)
  280c2e:	00 00                	add    %al,(%eax)
  280c30:	00 00                	add    %al,(%eax)
  280c32:	00 7c 04 08          	add    %bh,0x8(%esp,%eax,1)
  280c36:	10 38                	adc    %bh,(%eax)
  280c38:	04 04                	add    $0x4,%al
  280c3a:	04 78                	add    $0x78,%al
  280c3c:	00 00                	add    %al,(%eax)
  280c3e:	00 00                	add    %al,(%eax)
  280c40:	00 00                	add    %al,(%eax)
  280c42:	00 08                	add    %cl,(%eax)
  280c44:	18 28                	sbb    %ch,(%eax)
  280c46:	48                   	dec    %eax
  280c47:	48                   	dec    %eax
  280c48:	7c 08                	jl     280c52 <Font8x16+0x352>
  280c4a:	08 08                	or     %cl,(%eax)
  280c4c:	00 00                	add    %al,(%eax)
  280c4e:	00 00                	add    %al,(%eax)
  280c50:	00 00                	add    %al,(%eax)
  280c52:	00 7c 40 40          	add    %bh,0x40(%eax,%eax,2)
  280c56:	40                   	inc    %eax
  280c57:	78 04                	js     280c5d <Font8x16+0x35d>
  280c59:	04 04                	add    $0x4,%al
  280c5b:	78 00                	js     280c5d <Font8x16+0x35d>
  280c5d:	00 00                	add    %al,(%eax)
  280c5f:	00 00                	add    %al,(%eax)
  280c61:	00 00                	add    %al,(%eax)
  280c63:	3c 40                	cmp    $0x40,%al
  280c65:	40                   	inc    %eax
  280c66:	40                   	inc    %eax
  280c67:	78 44                	js     280cad <Font8x16+0x3ad>
  280c69:	44                   	inc    %esp
  280c6a:	44                   	inc    %esp
  280c6b:	38 00                	cmp    %al,(%eax)
  280c6d:	00 00                	add    %al,(%eax)
  280c6f:	00 00                	add    %al,(%eax)
  280c71:	00 00                	add    %al,(%eax)
  280c73:	7c 04                	jl     280c79 <Font8x16+0x379>
  280c75:	04 08                	add    $0x8,%al
  280c77:	10 20                	adc    %ah,(%eax)
  280c79:	20 20                	and    %ah,(%eax)
  280c7b:	20 00                	and    %al,(%eax)
  280c7d:	00 00                	add    %al,(%eax)
  280c7f:	00 00                	add    %al,(%eax)
  280c81:	00 00                	add    %al,(%eax)
  280c83:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c87:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c8b:	38 00                	cmp    %al,(%eax)
  280c8d:	00 00                	add    %al,(%eax)
  280c8f:	00 00                	add    %al,(%eax)
  280c91:	00 00                	add    %al,(%eax)
  280c93:	38 44 44 44          	cmp    %al,0x44(%esp,%eax,2)
  280c97:	3c 04                	cmp    $0x4,%al
  280c99:	04 04                	add    $0x4,%al
  280c9b:	38 00                	cmp    %al,(%eax)
	...
  280ca5:	00 00                	add    %al,(%eax)
  280ca7:	10 00                	adc    %al,(%eax)
  280ca9:	00 10                	add    %dl,(%eax)
	...
  280cb7:	00 10                	add    %dl,(%eax)
  280cb9:	00 10                	add    %dl,(%eax)
  280cbb:	10 20                	adc    %ah,(%eax)
	...
  280cc5:	04 08                	add    $0x8,%al
  280cc7:	10 20                	adc    %ah,(%eax)
  280cc9:	10 08                	adc    %cl,(%eax)
  280ccb:	04 00                	add    $0x0,%al
	...
  280cd5:	00 00                	add    %al,(%eax)
  280cd7:	7c 00                	jl     280cd9 <Font8x16+0x3d9>
  280cd9:	7c 00                	jl     280cdb <Font8x16+0x3db>
	...
  280ce3:	00 00                	add    %al,(%eax)
  280ce5:	20 10                	and    %dl,(%eax)
  280ce7:	08 04 08             	or     %al,(%eax,%ecx,1)
  280cea:	10 20                	adc    %ah,(%eax)
  280cec:	00 00                	add    %al,(%eax)
  280cee:	00 00                	add    %al,(%eax)
  280cf0:	00 00                	add    %al,(%eax)
  280cf2:	38 44 44 04          	cmp    %al,0x4(%esp,%eax,2)
  280cf6:	08 10                	or     %dl,(%eax)
  280cf8:	10 00                	adc    %al,(%eax)
  280cfa:	10 10                	adc    %dl,(%eax)
	...
  280d04:	00 38                	add    %bh,(%eax)
  280d06:	44                   	inc    %esp
  280d07:	5c                   	pop    %esp
  280d08:	54                   	push   %esp
  280d09:	5c                   	pop    %esp
  280d0a:	40                   	inc    %eax
  280d0b:	3c 00                	cmp    $0x0,%al
  280d0d:	00 00                	add    %al,(%eax)
  280d0f:	00 00                	add    %al,(%eax)
  280d11:	00 18                	add    %bl,(%eax)
  280d13:	24 42                	and    $0x42,%al
  280d15:	42                   	inc    %edx
  280d16:	42                   	inc    %edx
  280d17:	7e 42                	jle    280d5b <Font8x16+0x45b>
  280d19:	42                   	inc    %edx
  280d1a:	42                   	inc    %edx
  280d1b:	42                   	inc    %edx
  280d1c:	00 00                	add    %al,(%eax)
  280d1e:	00 00                	add    %al,(%eax)
  280d20:	00 00                	add    %al,(%eax)
  280d22:	7c 42                	jl     280d66 <Font8x16+0x466>
  280d24:	42                   	inc    %edx
  280d25:	42                   	inc    %edx
  280d26:	7c 42                	jl     280d6a <Font8x16+0x46a>
  280d28:	42                   	inc    %edx
  280d29:	42                   	inc    %edx
  280d2a:	42                   	inc    %edx
  280d2b:	7c 00                	jl     280d2d <Font8x16+0x42d>
  280d2d:	00 00                	add    %al,(%eax)
  280d2f:	00 00                	add    %al,(%eax)
  280d31:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280d34:	40                   	inc    %eax
  280d35:	40                   	inc    %eax
  280d36:	40                   	inc    %eax
  280d37:	40                   	inc    %eax
  280d38:	40                   	inc    %eax
  280d39:	40                   	inc    %eax
  280d3a:	42                   	inc    %edx
  280d3b:	3c 00                	cmp    $0x0,%al
  280d3d:	00 00                	add    %al,(%eax)
  280d3f:	00 00                	add    %al,(%eax)
  280d41:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280d45:	42                   	inc    %edx
  280d46:	42                   	inc    %edx
  280d47:	42                   	inc    %edx
  280d48:	42                   	inc    %edx
  280d49:	42                   	inc    %edx
  280d4a:	42                   	inc    %edx
  280d4b:	7c 00                	jl     280d4d <Font8x16+0x44d>
  280d4d:	00 00                	add    %al,(%eax)
  280d4f:	00 00                	add    %al,(%eax)
  280d51:	00 7e 40             	add    %bh,0x40(%esi)
  280d54:	40                   	inc    %eax
  280d55:	40                   	inc    %eax
  280d56:	78 40                	js     280d98 <Font8x16+0x498>
  280d58:	40                   	inc    %eax
  280d59:	40                   	inc    %eax
  280d5a:	40                   	inc    %eax
  280d5b:	7e 00                	jle    280d5d <Font8x16+0x45d>
  280d5d:	00 00                	add    %al,(%eax)
  280d5f:	00 00                	add    %al,(%eax)
  280d61:	00 7e 40             	add    %bh,0x40(%esi)
  280d64:	40                   	inc    %eax
  280d65:	40                   	inc    %eax
  280d66:	78 40                	js     280da8 <Font8x16+0x4a8>
  280d68:	40                   	inc    %eax
  280d69:	40                   	inc    %eax
  280d6a:	40                   	inc    %eax
  280d6b:	40                   	inc    %eax
  280d6c:	00 00                	add    %al,(%eax)
  280d6e:	00 00                	add    %al,(%eax)
  280d70:	00 00                	add    %al,(%eax)
  280d72:	3c 42                	cmp    $0x42,%al
  280d74:	40                   	inc    %eax
  280d75:	40                   	inc    %eax
  280d76:	5e                   	pop    %esi
  280d77:	42                   	inc    %edx
  280d78:	42                   	inc    %edx
  280d79:	42                   	inc    %edx
  280d7a:	42                   	inc    %edx
  280d7b:	3c 00                	cmp    $0x0,%al
  280d7d:	00 00                	add    %al,(%eax)
  280d7f:	00 00                	add    %al,(%eax)
  280d81:	00 42 42             	add    %al,0x42(%edx)
  280d84:	42                   	inc    %edx
  280d85:	42                   	inc    %edx
  280d86:	7e 42                	jle    280dca <Font8x16+0x4ca>
  280d88:	42                   	inc    %edx
  280d89:	42                   	inc    %edx
  280d8a:	42                   	inc    %edx
  280d8b:	42                   	inc    %edx
  280d8c:	00 00                	add    %al,(%eax)
  280d8e:	00 00                	add    %al,(%eax)
  280d90:	00 00                	add    %al,(%eax)
  280d92:	38 10                	cmp    %dl,(%eax)
  280d94:	10 10                	adc    %dl,(%eax)
  280d96:	10 10                	adc    %dl,(%eax)
  280d98:	10 10                	adc    %dl,(%eax)
  280d9a:	10 38                	adc    %bh,(%eax)
  280d9c:	00 00                	add    %al,(%eax)
  280d9e:	00 00                	add    %al,(%eax)
  280da0:	00 00                	add    %al,(%eax)
  280da2:	1c 08                	sbb    $0x8,%al
  280da4:	08 08                	or     %cl,(%eax)
  280da6:	08 08                	or     %cl,(%eax)
  280da8:	08 08                	or     %cl,(%eax)
  280daa:	48                   	dec    %eax
  280dab:	30 00                	xor    %al,(%eax)
  280dad:	00 00                	add    %al,(%eax)
  280daf:	00 00                	add    %al,(%eax)
  280db1:	00 42 44             	add    %al,0x44(%edx)
  280db4:	48                   	dec    %eax
  280db5:	50                   	push   %eax
  280db6:	60                   	pusha  
  280db7:	60                   	pusha  
  280db8:	50                   	push   %eax
  280db9:	48                   	dec    %eax
  280dba:	44                   	inc    %esp
  280dbb:	42                   	inc    %edx
  280dbc:	00 00                	add    %al,(%eax)
  280dbe:	00 00                	add    %al,(%eax)
  280dc0:	00 00                	add    %al,(%eax)
  280dc2:	40                   	inc    %eax
  280dc3:	40                   	inc    %eax
  280dc4:	40                   	inc    %eax
  280dc5:	40                   	inc    %eax
  280dc6:	40                   	inc    %eax
  280dc7:	40                   	inc    %eax
  280dc8:	40                   	inc    %eax
  280dc9:	40                   	inc    %eax
  280dca:	40                   	inc    %eax
  280dcb:	7e 00                	jle    280dcd <Font8x16+0x4cd>
  280dcd:	00 00                	add    %al,(%eax)
  280dcf:	00 00                	add    %al,(%eax)
  280dd1:	00 82 82 c6 c6 aa    	add    %al,-0x5539397e(%edx)
  280dd7:	aa                   	stos   %al,%es:(%edi)
  280dd8:	92                   	xchg   %eax,%edx
  280dd9:	92                   	xchg   %eax,%edx
  280dda:	82                   	(bad)  
  280ddb:	82                   	(bad)  
  280ddc:	00 00                	add    %al,(%eax)
  280dde:	00 00                	add    %al,(%eax)
  280de0:	00 00                	add    %al,(%eax)
  280de2:	42                   	inc    %edx
  280de3:	62 62 52             	bound  %esp,0x52(%edx)
  280de6:	52                   	push   %edx
  280de7:	4a                   	dec    %edx
  280de8:	4a                   	dec    %edx
  280de9:	46                   	inc    %esi
  280dea:	46                   	inc    %esi
  280deb:	42                   	inc    %edx
  280dec:	00 00                	add    %al,(%eax)
  280dee:	00 00                	add    %al,(%eax)
  280df0:	00 00                	add    %al,(%eax)
  280df2:	3c 42                	cmp    $0x42,%al
  280df4:	42                   	inc    %edx
  280df5:	42                   	inc    %edx
  280df6:	42                   	inc    %edx
  280df7:	42                   	inc    %edx
  280df8:	42                   	inc    %edx
  280df9:	42                   	inc    %edx
  280dfa:	42                   	inc    %edx
  280dfb:	3c 00                	cmp    $0x0,%al
  280dfd:	00 00                	add    %al,(%eax)
  280dff:	00 00                	add    %al,(%eax)
  280e01:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280e05:	42                   	inc    %edx
  280e06:	42                   	inc    %edx
  280e07:	7c 40                	jl     280e49 <Font8x16+0x549>
  280e09:	40                   	inc    %eax
  280e0a:	40                   	inc    %eax
  280e0b:	40                   	inc    %eax
  280e0c:	00 00                	add    %al,(%eax)
  280e0e:	00 00                	add    %al,(%eax)
  280e10:	00 00                	add    %al,(%eax)
  280e12:	3c 42                	cmp    $0x42,%al
  280e14:	42                   	inc    %edx
  280e15:	42                   	inc    %edx
  280e16:	42                   	inc    %edx
  280e17:	42                   	inc    %edx
  280e18:	42                   	inc    %edx
  280e19:	42                   	inc    %edx
  280e1a:	4a                   	dec    %edx
  280e1b:	3c 0e                	cmp    $0xe,%al
  280e1d:	00 00                	add    %al,(%eax)
  280e1f:	00 00                	add    %al,(%eax)
  280e21:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280e25:	42                   	inc    %edx
  280e26:	42                   	inc    %edx
  280e27:	7c 50                	jl     280e79 <Font8x16+0x579>
  280e29:	48                   	dec    %eax
  280e2a:	44                   	inc    %esp
  280e2b:	42                   	inc    %edx
  280e2c:	00 00                	add    %al,(%eax)
  280e2e:	00 00                	add    %al,(%eax)
  280e30:	00 00                	add    %al,(%eax)
  280e32:	3c 42                	cmp    $0x42,%al
  280e34:	40                   	inc    %eax
  280e35:	40                   	inc    %eax
  280e36:	3c 02                	cmp    $0x2,%al
  280e38:	02 02                	add    (%edx),%al
  280e3a:	42                   	inc    %edx
  280e3b:	3c 00                	cmp    $0x0,%al
  280e3d:	00 00                	add    %al,(%eax)
  280e3f:	00 00                	add    %al,(%eax)
  280e41:	00 7c 10 10          	add    %bh,0x10(%eax,%edx,1)
  280e45:	10 10                	adc    %dl,(%eax)
  280e47:	10 10                	adc    %dl,(%eax)
  280e49:	10 10                	adc    %dl,(%eax)
  280e4b:	10 00                	adc    %al,(%eax)
  280e4d:	00 00                	add    %al,(%eax)
  280e4f:	00 00                	add    %al,(%eax)
  280e51:	00 42 42             	add    %al,0x42(%edx)
  280e54:	42                   	inc    %edx
  280e55:	42                   	inc    %edx
  280e56:	42                   	inc    %edx
  280e57:	42                   	inc    %edx
  280e58:	42                   	inc    %edx
  280e59:	42                   	inc    %edx
  280e5a:	42                   	inc    %edx
  280e5b:	3c 00                	cmp    $0x0,%al
  280e5d:	00 00                	add    %al,(%eax)
  280e5f:	00 00                	add    %al,(%eax)
  280e61:	00 44 44 44          	add    %al,0x44(%esp,%eax,2)
  280e65:	44                   	inc    %esp
  280e66:	28 28                	sub    %ch,(%eax)
  280e68:	28 10                	sub    %dl,(%eax)
  280e6a:	10 10                	adc    %dl,(%eax)
  280e6c:	00 00                	add    %al,(%eax)
  280e6e:	00 00                	add    %al,(%eax)
  280e70:	00 00                	add    %al,(%eax)
  280e72:	82                   	(bad)  
  280e73:	82                   	(bad)  
  280e74:	82                   	(bad)  
  280e75:	82                   	(bad)  
  280e76:	54                   	push   %esp
  280e77:	54                   	push   %esp
  280e78:	54                   	push   %esp
  280e79:	28 28                	sub    %ch,(%eax)
  280e7b:	28 00                	sub    %al,(%eax)
  280e7d:	00 00                	add    %al,(%eax)
  280e7f:	00 00                	add    %al,(%eax)
  280e81:	00 42 42             	add    %al,0x42(%edx)
  280e84:	24 18                	and    $0x18,%al
  280e86:	18 18                	sbb    %bl,(%eax)
  280e88:	24 24                	and    $0x24,%al
  280e8a:	42                   	inc    %edx
  280e8b:	42                   	inc    %edx
  280e8c:	00 00                	add    %al,(%eax)
  280e8e:	00 00                	add    %al,(%eax)
  280e90:	00 00                	add    %al,(%eax)
  280e92:	44                   	inc    %esp
  280e93:	44                   	inc    %esp
  280e94:	44                   	inc    %esp
  280e95:	44                   	inc    %esp
  280e96:	28 28                	sub    %ch,(%eax)
  280e98:	10 10                	adc    %dl,(%eax)
  280e9a:	10 10                	adc    %dl,(%eax)
  280e9c:	00 00                	add    %al,(%eax)
  280e9e:	00 00                	add    %al,(%eax)
  280ea0:	00 00                	add    %al,(%eax)
  280ea2:	7e 02                	jle    280ea6 <Font8x16+0x5a6>
  280ea4:	02 04 08             	add    (%eax,%ecx,1),%al
  280ea7:	10 20                	adc    %ah,(%eax)
  280ea9:	40                   	inc    %eax
  280eaa:	40                   	inc    %eax
  280eab:	7e 00                	jle    280ead <Font8x16+0x5ad>
  280ead:	00 00                	add    %al,(%eax)
  280eaf:	00 00                	add    %al,(%eax)
  280eb1:	00 38                	add    %bh,(%eax)
  280eb3:	20 20                	and    %ah,(%eax)
  280eb5:	20 20                	and    %ah,(%eax)
  280eb7:	20 20                	and    %ah,(%eax)
  280eb9:	20 20                	and    %ah,(%eax)
  280ebb:	38 00                	cmp    %al,(%eax)
	...
  280ec5:	00 40 20             	add    %al,0x20(%eax)
  280ec8:	10 08                	adc    %cl,(%eax)
  280eca:	04 02                	add    $0x2,%al
  280ecc:	00 00                	add    %al,(%eax)
  280ece:	00 00                	add    %al,(%eax)
  280ed0:	00 00                	add    %al,(%eax)
  280ed2:	1c 04                	sbb    $0x4,%al
  280ed4:	04 04                	add    $0x4,%al
  280ed6:	04 04                	add    $0x4,%al
  280ed8:	04 04                	add    $0x4,%al
  280eda:	04 1c                	add    $0x1c,%al
	...
  280ee4:	10 28                	adc    %ch,(%eax)
  280ee6:	44                   	inc    %esp
	...
  280efb:	00 ff                	add    %bh,%bh
  280efd:	00 00                	add    %al,(%eax)
  280eff:	00 00                	add    %al,(%eax)
  280f01:	00 00                	add    %al,(%eax)
  280f03:	10 10                	adc    %dl,(%eax)
  280f05:	08 00                	or     %al,(%eax)
	...
  280f13:	00 00                	add    %al,(%eax)
  280f15:	78 04                	js     280f1b <Font8x16+0x61b>
  280f17:	3c 44                	cmp    $0x44,%al
  280f19:	44                   	inc    %esp
  280f1a:	44                   	inc    %esp
  280f1b:	3a 00                	cmp    (%eax),%al
  280f1d:	00 00                	add    %al,(%eax)
  280f1f:	00 00                	add    %al,(%eax)
  280f21:	00 40 40             	add    %al,0x40(%eax)
  280f24:	40                   	inc    %eax
  280f25:	5c                   	pop    %esp
  280f26:	62 42 42             	bound  %eax,0x42(%edx)
  280f29:	42                   	inc    %edx
  280f2a:	62 5c 00 00          	bound  %ebx,0x0(%eax,%eax,1)
  280f2e:	00 00                	add    %al,(%eax)
  280f30:	00 00                	add    %al,(%eax)
  280f32:	00 00                	add    %al,(%eax)
  280f34:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280f37:	40                   	inc    %eax
  280f38:	40                   	inc    %eax
  280f39:	40                   	inc    %eax
  280f3a:	42                   	inc    %edx
  280f3b:	3c 00                	cmp    $0x0,%al
  280f3d:	00 00                	add    %al,(%eax)
  280f3f:	00 00                	add    %al,(%eax)
  280f41:	00 02                	add    %al,(%edx)
  280f43:	02 02                	add    (%edx),%al
  280f45:	3a 46 42             	cmp    0x42(%esi),%al
  280f48:	42                   	inc    %edx
  280f49:	42                   	inc    %edx
  280f4a:	46                   	inc    %esi
  280f4b:	3a 00                	cmp    (%eax),%al
	...
  280f55:	3c 42                	cmp    $0x42,%al
  280f57:	42                   	inc    %edx
  280f58:	7e 40                	jle    280f9a <Font8x16+0x69a>
  280f5a:	42                   	inc    %edx
  280f5b:	3c 00                	cmp    $0x0,%al
  280f5d:	00 00                	add    %al,(%eax)
  280f5f:	00 00                	add    %al,(%eax)
  280f61:	00 0e                	add    %cl,(%esi)
  280f63:	10 10                	adc    %dl,(%eax)
  280f65:	10 3c 10             	adc    %bh,(%eax,%edx,1)
  280f68:	10 10                	adc    %dl,(%eax)
  280f6a:	10 10                	adc    %dl,(%eax)
	...
  280f74:	00 3e                	add    %bh,(%esi)
  280f76:	42                   	inc    %edx
  280f77:	42                   	inc    %edx
  280f78:	42                   	inc    %edx
  280f79:	42                   	inc    %edx
  280f7a:	3e 02 02             	add    %ds:(%edx),%al
  280f7d:	3c 00                	cmp    $0x0,%al
  280f7f:	00 00                	add    %al,(%eax)
  280f81:	00 40 40             	add    %al,0x40(%eax)
  280f84:	40                   	inc    %eax
  280f85:	5c                   	pop    %esp
  280f86:	62 42 42             	bound  %eax,0x42(%edx)
  280f89:	42                   	inc    %edx
  280f8a:	42                   	inc    %edx
  280f8b:	42                   	inc    %edx
  280f8c:	00 00                	add    %al,(%eax)
  280f8e:	00 00                	add    %al,(%eax)
  280f90:	00 00                	add    %al,(%eax)
  280f92:	00 08                	add    %cl,(%eax)
  280f94:	00 08                	add    %cl,(%eax)
  280f96:	08 08                	or     %cl,(%eax)
  280f98:	08 08                	or     %cl,(%eax)
  280f9a:	08 08                	or     %cl,(%eax)
  280f9c:	00 00                	add    %al,(%eax)
  280f9e:	00 00                	add    %al,(%eax)
  280fa0:	00 00                	add    %al,(%eax)
  280fa2:	00 04 00             	add    %al,(%eax,%eax,1)
  280fa5:	04 04                	add    $0x4,%al
  280fa7:	04 04                	add    $0x4,%al
  280fa9:	04 04                	add    $0x4,%al
  280fab:	04 44                	add    $0x44,%al
  280fad:	38 00                	cmp    %al,(%eax)
  280faf:	00 00                	add    %al,(%eax)
  280fb1:	00 40 40             	add    %al,0x40(%eax)
  280fb4:	40                   	inc    %eax
  280fb5:	42                   	inc    %edx
  280fb6:	44                   	inc    %esp
  280fb7:	48                   	dec    %eax
  280fb8:	50                   	push   %eax
  280fb9:	68 44 42 00 00       	push   $0x4244
  280fbe:	00 00                	add    %al,(%eax)
  280fc0:	00 00                	add    %al,(%eax)
  280fc2:	10 10                	adc    %dl,(%eax)
  280fc4:	10 10                	adc    %dl,(%eax)
  280fc6:	10 10                	adc    %dl,(%eax)
  280fc8:	10 10                	adc    %dl,(%eax)
  280fca:	10 10                	adc    %dl,(%eax)
	...
  280fd4:	00 ec                	add    %ch,%ah
  280fd6:	92                   	xchg   %eax,%edx
  280fd7:	92                   	xchg   %eax,%edx
  280fd8:	92                   	xchg   %eax,%edx
  280fd9:	92                   	xchg   %eax,%edx
  280fda:	92                   	xchg   %eax,%edx
  280fdb:	92                   	xchg   %eax,%edx
	...
  280fe4:	00 7c 42 42          	add    %bh,0x42(%edx,%eax,2)
  280fe8:	42                   	inc    %edx
  280fe9:	42                   	inc    %edx
  280fea:	42                   	inc    %edx
  280feb:	42                   	inc    %edx
	...
  280ff4:	00 3c 42             	add    %bh,(%edx,%eax,2)
  280ff7:	42                   	inc    %edx
  280ff8:	42                   	inc    %edx
  280ff9:	42                   	inc    %edx
  280ffa:	42                   	inc    %edx
  280ffb:	3c 00                	cmp    $0x0,%al
	...
  281005:	5c                   	pop    %esp
  281006:	62 42 42             	bound  %eax,0x42(%edx)
  281009:	42                   	inc    %edx
  28100a:	62 5c 40 40          	bound  %ebx,0x40(%eax,%eax,2)
  28100e:	00 00                	add    %al,(%eax)
  281010:	00 00                	add    %al,(%eax)
  281012:	00 00                	add    %al,(%eax)
  281014:	00 3a                	add    %bh,(%edx)
  281016:	46                   	inc    %esi
  281017:	42                   	inc    %edx
  281018:	42                   	inc    %edx
  281019:	42                   	inc    %edx
  28101a:	46                   	inc    %esi
  28101b:	3a 02                	cmp    (%edx),%al
  28101d:	02 00                	add    (%eax),%al
  28101f:	00 00                	add    %al,(%eax)
  281021:	00 00                	add    %al,(%eax)
  281023:	00 00                	add    %al,(%eax)
  281025:	5c                   	pop    %esp
  281026:	62 40 40             	bound  %eax,0x40(%eax)
  281029:	40                   	inc    %eax
  28102a:	40                   	inc    %eax
  28102b:	40                   	inc    %eax
	...
  281034:	00 3c 42             	add    %bh,(%edx,%eax,2)
  281037:	40                   	inc    %eax
  281038:	3c 02                	cmp    $0x2,%al
  28103a:	42                   	inc    %edx
  28103b:	3c 00                	cmp    $0x0,%al
  28103d:	00 00                	add    %al,(%eax)
  28103f:	00 00                	add    %al,(%eax)
  281041:	00 00                	add    %al,(%eax)
  281043:	20 20                	and    %ah,(%eax)
  281045:	78 20                	js     281067 <Font8x16+0x767>
  281047:	20 20                	and    %ah,(%eax)
  281049:	20 22                	and    %ah,(%edx)
  28104b:	1c 00                	sbb    $0x0,%al
	...
  281055:	42                   	inc    %edx
  281056:	42                   	inc    %edx
  281057:	42                   	inc    %edx
  281058:	42                   	inc    %edx
  281059:	42                   	inc    %edx
  28105a:	42                   	inc    %edx
  28105b:	3e 00 00             	add    %al,%ds:(%eax)
  28105e:	00 00                	add    %al,(%eax)
  281060:	00 00                	add    %al,(%eax)
  281062:	00 00                	add    %al,(%eax)
  281064:	00 42 42             	add    %al,0x42(%edx)
  281067:	42                   	inc    %edx
  281068:	42                   	inc    %edx
  281069:	42                   	inc    %edx
  28106a:	24 18                	and    $0x18,%al
	...
  281074:	00 82 82 82 92 92    	add    %al,-0x6d6d7d7e(%edx)
  28107a:	aa                   	stos   %al,%es:(%edi)
  28107b:	44                   	inc    %esp
	...
  281084:	00 42 42             	add    %al,0x42(%edx)
  281087:	24 18                	and    $0x18,%al
  281089:	24 42                	and    $0x42,%al
  28108b:	42                   	inc    %edx
	...
  281094:	00 42 42             	add    %al,0x42(%edx)
  281097:	42                   	inc    %edx
  281098:	42                   	inc    %edx
  281099:	42                   	inc    %edx
  28109a:	3e 02 02             	add    %ds:(%edx),%al
  28109d:	3c 00                	cmp    $0x0,%al
  28109f:	00 00                	add    %al,(%eax)
  2810a1:	00 00                	add    %al,(%eax)
  2810a3:	00 00                	add    %al,(%eax)
  2810a5:	7e 02                	jle    2810a9 <Font8x16+0x7a9>
  2810a7:	04 18                	add    $0x18,%al
  2810a9:	20 40 7e             	and    %al,0x7e(%eax)
  2810ac:	00 00                	add    %al,(%eax)
  2810ae:	00 00                	add    %al,(%eax)
  2810b0:	00 00                	add    %al,(%eax)
  2810b2:	08 10                	or     %dl,(%eax)
  2810b4:	10 10                	adc    %dl,(%eax)
  2810b6:	20 40 20             	and    %al,0x20(%eax)
  2810b9:	10 10                	adc    %dl,(%eax)
  2810bb:	10 08                	adc    %cl,(%eax)
  2810bd:	00 00                	add    %al,(%eax)
  2810bf:	00 00                	add    %al,(%eax)
  2810c1:	10 10                	adc    %dl,(%eax)
  2810c3:	10 10                	adc    %dl,(%eax)
  2810c5:	10 10                	adc    %dl,(%eax)
  2810c7:	10 10                	adc    %dl,(%eax)
  2810c9:	10 10                	adc    %dl,(%eax)
  2810cb:	10 10                	adc    %dl,(%eax)
  2810cd:	10 10                	adc    %dl,(%eax)
  2810cf:	00 00                	add    %al,(%eax)
  2810d1:	00 20                	add    %ah,(%eax)
  2810d3:	10 10                	adc    %dl,(%eax)
  2810d5:	10 08                	adc    %cl,(%eax)
  2810d7:	04 08                	add    $0x8,%al
  2810d9:	10 10                	adc    %dl,(%eax)
  2810db:	10 20                	adc    %ah,(%eax)
	...
  2810e5:	00 22                	add    %ah,(%edx)
  2810e7:	54                   	push   %esp
  2810e8:	88 00                	mov    %al,(%eax)
	...

00281100 <ASCII_Table>:
	...
  281130:	00 00                	add    %al,(%eax)
  281132:	80 01 80             	addb   $0x80,(%ecx)
  281135:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28113b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281141:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281147:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  28114d:	00 00                	add    %al,(%eax)
  28114f:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281161:	00 00                	add    %al,(%eax)
  281163:	00 cc                	add    %cl,%ah
  281165:	00 cc                	add    %cl,%ah
  281167:	00 cc                	add    %cl,%ah
  281169:	00 cc                	add    %cl,%ah
  28116b:	00 cc                	add    %cl,%ah
  28116d:	00 cc                	add    %cl,%ah
	...
  28119b:	00 60 0c             	add    %ah,0xc(%eax)
  28119e:	60                   	pusha  
  28119f:	0c 60                	or     $0x60,%al
  2811a1:	0c 30                	or     $0x30,%al
  2811a3:	06                   	push   %es
  2811a4:	30 06                	xor    %al,(%esi)
  2811a6:	fe                   	(bad)  
  2811a7:	1f                   	pop    %ds
  2811a8:	fe                   	(bad)  
  2811a9:	1f                   	pop    %ds
  2811aa:	30 06                	xor    %al,(%esi)
  2811ac:	38 07                	cmp    %al,(%edi)
  2811ae:	18 03                	sbb    %al,(%ebx)
  2811b0:	fe                   	(bad)  
  2811b1:	1f                   	pop    %ds
  2811b2:	fe                   	(bad)  
  2811b3:	1f                   	pop    %ds
  2811b4:	18 03                	sbb    %al,(%ebx)
  2811b6:	18 03                	sbb    %al,(%ebx)
  2811b8:	8c 01                	mov    %es,(%ecx)
  2811ba:	8c 01                	mov    %es,(%ecx)
  2811bc:	8c 01                	mov    %es,(%ecx)
  2811be:	00 00                	add    %al,(%eax)
  2811c0:	00 00                	add    %al,(%eax)
  2811c2:	80 00 e0             	addb   $0xe0,(%eax)
  2811c5:	03 f8                	add    %eax,%edi
  2811c7:	0f 9c 0e             	setl   (%esi)
  2811ca:	8c 1c 8c             	mov    %ds,(%esp,%ecx,4)
  2811cd:	18 8c 00 98 00 f8 01 	sbb    %cl,0x1f80098(%eax,%eax,1)
  2811d4:	e0 07                	loopne 2811dd <ASCII_Table+0xdd>
  2811d6:	80 0e 80             	orb    $0x80,(%esi)
  2811d9:	1c 8c                	sbb    $0x8c,%al
  2811db:	18 8c 18 9c 18 b8 0c 	sbb    %cl,0xcb8189c(%eax,%ebx,1)
  2811e2:	f0 0f e0 03          	lock pavgb (%ebx),%mm0
  2811e6:	80 00 80             	addb   $0x80,(%eax)
	...
  2811f5:	00 0e                	add    %cl,(%esi)
  2811f7:	18 1b                	sbb    %bl,(%ebx)
  2811f9:	0c 11                	or     $0x11,%al
  2811fb:	0c 11                	or     $0x11,%al
  2811fd:	06                   	push   %es
  2811fe:	11 06                	adc    %eax,(%esi)
  281200:	11 03                	adc    %eax,(%ebx)
  281202:	11 03                	adc    %eax,(%ebx)
  281204:	9b                   	fwait
  281205:	01 8e 01 c0 38 c0    	add    %ecx,-0x3fc73fff(%esi)
  28120b:	6c                   	insb   (%dx),%es:(%edi)
  28120c:	60                   	pusha  
  28120d:	44                   	inc    %esp
  28120e:	60                   	pusha  
  28120f:	44                   	inc    %esp
  281210:	30 44 30 44          	xor    %al,0x44(%eax,%esi,1)
  281214:	18 44 18 6c          	sbb    %al,0x6c(%eax,%ebx,1)
  281218:	0c 38                	or     $0x38,%al
	...
  281222:	e0 01                	loopne 281225 <ASCII_Table+0x125>
  281224:	f0 03 38             	lock add (%eax),%edi
  281227:	07                   	pop    %es
  281228:	18 06                	sbb    %al,(%esi)
  28122a:	18 06                	sbb    %al,(%esi)
  28122c:	30 03                	xor    %al,(%ebx)
  28122e:	f0 01 f0             	lock add %esi,%eax
  281231:	00 f8                	add    %bh,%al
  281233:	00 9c 31 0e 33 06 1e 	add    %bl,0x1e06330e(%ecx,%esi,1)
  28123a:	06                   	push   %es
  28123b:	1c 06                	sbb    $0x6,%al
  28123d:	1c 06                	sbb    $0x6,%al
  28123f:	3f                   	aas    
  281240:	fc                   	cld    
  281241:	73 f0                	jae    281233 <ASCII_Table+0x133>
  281243:	21 00                	and    %eax,(%eax)
	...
  281251:	00 00                	add    %al,(%eax)
  281253:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281256:	0c 00                	or     $0x0,%al
  281258:	0c 00                	or     $0x0,%al
  28125a:	0c 00                	or     $0x0,%al
  28125c:	0c 00                	or     $0x0,%al
  28125e:	0c 00                	or     $0x0,%al
	...
  281280:	00 00                	add    %al,(%eax)
  281282:	00 02                	add    %al,(%edx)
  281284:	00 03                	add    %al,(%ebx)
  281286:	80 01 c0             	addb   $0xc0,(%ecx)
  281289:	00 c0                	add    %al,%al
  28128b:	00 60 00             	add    %ah,0x0(%eax)
  28128e:	60                   	pusha  
  28128f:	00 30                	add    %dh,(%eax)
  281291:	00 30                	add    %dh,(%eax)
  281293:	00 30                	add    %dh,(%eax)
  281295:	00 30                	add    %dh,(%eax)
  281297:	00 30                	add    %dh,(%eax)
  281299:	00 30                	add    %dh,(%eax)
  28129b:	00 30                	add    %dh,(%eax)
  28129d:	00 30                	add    %dh,(%eax)
  28129f:	00 60 00             	add    %ah,0x0(%eax)
  2812a2:	60                   	pusha  
  2812a3:	00 c0                	add    %al,%al
  2812a5:	00 c0                	add    %al,%al
  2812a7:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  2812ad:	02 00                	add    (%eax),%al
  2812af:	00 00                	add    %al,(%eax)
  2812b1:	00 20                	add    %ah,(%eax)
  2812b3:	00 60 00             	add    %ah,0x0(%eax)
  2812b6:	c0 00 80             	rolb   $0x80,(%eax)
  2812b9:	01 80 01 00 03 00    	add    %eax,0x30001(%eax)
  2812bf:	03 00                	add    (%eax),%eax
  2812c1:	06                   	push   %es
  2812c2:	00 06                	add    %al,(%esi)
  2812c4:	00 06                	add    %al,(%esi)
  2812c6:	00 06                	add    %al,(%esi)
  2812c8:	00 06                	add    %al,(%esi)
  2812ca:	00 06                	add    %al,(%esi)
  2812cc:	00 06                	add    %al,(%esi)
  2812ce:	00 06                	add    %al,(%esi)
  2812d0:	00 03                	add    %al,(%ebx)
  2812d2:	00 03                	add    %al,(%ebx)
  2812d4:	80 01 80             	addb   $0x80,(%ecx)
  2812d7:	01 c0                	add    %eax,%eax
  2812d9:	00 60 00             	add    %ah,0x0(%eax)
  2812dc:	20 00                	and    %al,(%eax)
	...
  2812ea:	00 00                	add    %al,(%eax)
  2812ec:	c0 00 c0             	rolb   $0xc0,(%eax)
  2812ef:	00 d8                	add    %bl,%al
  2812f1:	06                   	push   %es
  2812f2:	f8                   	clc    
  2812f3:	07                   	pop    %es
  2812f4:	e0 01                	loopne 2812f7 <ASCII_Table+0x1f7>
  2812f6:	30 03                	xor    %al,(%ebx)
  2812f8:	38 07                	cmp    %al,(%edi)
	...
  28131a:	00 00                	add    %al,(%eax)
  28131c:	80 01 80             	addb   $0x80,(%ecx)
  28131f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281325:	01 fc                	add    %edi,%esp
  281327:	3f                   	aas    
  281328:	fc                   	cld    
  281329:	3f                   	aas    
  28132a:	80 01 80             	addb   $0x80,(%ecx)
  28132d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281333:	01 00                	add    %eax,(%eax)
	...
  281361:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281367:	01 00                	add    %eax,(%eax)
  281369:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281387:	00 e0                	add    %ah,%al
  281389:	07                   	pop    %es
  28138a:	e0 07                	loopne 281393 <ASCII_Table+0x293>
	...
  2813c0:	00 00                	add    %al,(%eax)
  2813c2:	c0 00 c0             	rolb   $0xc0,(%eax)
	...
  2813d1:	00 00                	add    %al,(%eax)
  2813d3:	0c 00                	or     $0x0,%al
  2813d5:	0c 00                	or     $0x0,%al
  2813d7:	06                   	push   %es
  2813d8:	00 06                	add    %al,(%esi)
  2813da:	00 06                	add    %al,(%esi)
  2813dc:	00 03                	add    %al,(%ebx)
  2813de:	00 03                	add    %al,(%ebx)
  2813e0:	00 03                	add    %al,(%ebx)
  2813e2:	80 03 80             	addb   $0x80,(%ebx)
  2813e5:	01 80 01 80 01 c0    	add    %eax,-0x3ffe7fff(%eax)
  2813eb:	00 c0                	add    %al,%al
  2813ed:	00 c0                	add    %al,%al
  2813ef:	00 60 00             	add    %ah,0x0(%eax)
  2813f2:	60                   	pusha  
	...
  2813ff:	00 00                	add    %al,(%eax)
  281401:	00 e0                	add    %ah,%al
  281403:	03 f0                	add    %eax,%esi
  281405:	07                   	pop    %es
  281406:	38 0e                	cmp    %cl,(%esi)
  281408:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  28140b:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28140e:	0c 18                	or     $0x18,%al
  281410:	0c 18                	or     $0x18,%al
  281412:	0c 18                	or     $0x18,%al
  281414:	0c 18                	or     $0x18,%al
  281416:	0c 18                	or     $0x18,%al
  281418:	0c 18                	or     $0x18,%al
  28141a:	0c 18                	or     $0x18,%al
  28141c:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  28141f:	0e                   	push   %cs
  281420:	f0 07                	lock pop %es
  281422:	e0 03                	loopne 281427 <ASCII_Table+0x327>
	...
  281430:	00 00                	add    %al,(%eax)
  281432:	00 01                	add    %al,(%ecx)
  281434:	80 01 c0             	addb   $0xc0,(%ecx)
  281437:	01 f0                	add    %esi,%eax
  281439:	01 98 01 88 01 80    	add    %ebx,-0x7ffe77ff(%eax)
  28143f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281445:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28144b:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281451:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  28145f:	00 00                	add    %al,(%eax)
  281461:	00 e0                	add    %ah,%al
  281463:	03 f8                	add    %eax,%edi
  281465:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  281469:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28146c:	00 18                	add    %bl,(%eax)
  28146e:	00 18                	add    %bl,(%eax)
  281470:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281473:	06                   	push   %es
  281474:	00 03                	add    %al,(%ebx)
  281476:	80 01 c0             	addb   $0xc0,(%ecx)
  281479:	00 60 00             	add    %ah,0x0(%eax)
  28147c:	30 00                	xor    %al,(%eax)
  28147e:	18 00                	sbb    %al,(%eax)
  281480:	fc                   	cld    
  281481:	1f                   	pop    %ds
  281482:	fc                   	cld    
  281483:	1f                   	pop    %ds
	...
  281490:	00 00                	add    %al,(%eax)
  281492:	e0 01                	loopne 281495 <ASCII_Table+0x395>
  281494:	f8                   	clc    
  281495:	07                   	pop    %es
  281496:	18 0e                	sbb    %cl,(%esi)
  281498:	0c 0c                	or     $0xc,%al
  28149a:	0c 0c                	or     $0xc,%al
  28149c:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28149f:	06                   	push   %es
  2814a0:	c0 03 c0             	rolb   $0xc0,(%ebx)
  2814a3:	07                   	pop    %es
  2814a4:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2814a7:	18 00                	sbb    %al,(%eax)
  2814a9:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2814ac:	0c 18                	or     $0x18,%al
  2814ae:	18 0c f8             	sbb    %cl,(%eax,%edi,8)
  2814b1:	07                   	pop    %es
  2814b2:	e0 03                	loopne 2814b7 <ASCII_Table+0x3b7>
	...
  2814c0:	00 00                	add    %al,(%eax)
  2814c2:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2814c5:	0e                   	push   %cs
  2814c6:	00 0f                	add    %cl,(%edi)
  2814c8:	00 0f                	add    %cl,(%edi)
  2814ca:	80 0d c0 0c 60 0c 60 	orb    $0x60,0xc600cc0
  2814d1:	0c 30                	or     $0x30,%al
  2814d3:	0c 18                	or     $0x18,%al
  2814d5:	0c 0c                	or     $0xc,%al
  2814d7:	0c fc                	or     $0xfc,%al
  2814d9:	3f                   	aas    
  2814da:	fc                   	cld    
  2814db:	3f                   	aas    
  2814dc:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2814df:	0c 00                	or     $0x0,%al
  2814e1:	0c 00                	or     $0x0,%al
  2814e3:	0c 00                	or     $0x0,%al
	...
  2814f1:	00 f8                	add    %bh,%al
  2814f3:	0f f8 0f             	psubb  (%edi),%mm1
  2814f6:	18 00                	sbb    %al,(%eax)
  2814f8:	18 00                	sbb    %al,(%eax)
  2814fa:	0c 00                	or     $0x0,%al
  2814fc:	ec                   	in     (%dx),%al
  2814fd:	03 fc                	add    %esp,%edi
  2814ff:	07                   	pop    %es
  281500:	1c 0e                	sbb    $0xe,%al
  281502:	00 1c 00             	add    %bl,(%eax,%eax,1)
  281505:	18 00                	sbb    %al,(%eax)
  281507:	18 00                	sbb    %al,(%eax)
  281509:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28150c:	1c 0c                	sbb    $0xc,%al
  28150e:	18 0e                	sbb    %cl,(%esi)
  281510:	f8                   	clc    
  281511:	07                   	pop    %es
  281512:	e0 03                	loopne 281517 <ASCII_Table+0x417>
	...
  281520:	00 00                	add    %al,(%eax)
  281522:	c0 07 f0             	rolb   $0xf0,(%edi)
  281525:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281529:	18 18                	sbb    %bl,(%eax)
  28152b:	00 0c 00             	add    %cl,(%eax,%eax,1)
  28152e:	cc                   	int3   
  28152f:	03 ec                	add    %esp,%ebp
  281531:	0f 3c                	(bad)  
  281533:	0e                   	push   %cs
  281534:	1c 1c                	sbb    $0x1c,%al
  281536:	0c 18                	or     $0x18,%al
  281538:	0c 18                	or     $0x18,%al
  28153a:	0c 18                	or     $0x18,%al
  28153c:	18 1c 38             	sbb    %bl,(%eax,%edi,1)
  28153f:	0e                   	push   %cs
  281540:	f0 07                	lock pop %es
  281542:	e0 03                	loopne 281547 <ASCII_Table+0x447>
	...
  281550:	00 00                	add    %al,(%eax)
  281552:	fc                   	cld    
  281553:	1f                   	pop    %ds
  281554:	fc                   	cld    
  281555:	1f                   	pop    %ds
  281556:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281559:	06                   	push   %es
  28155a:	00 06                	add    %al,(%esi)
  28155c:	00 03                	add    %al,(%ebx)
  28155e:	80 03 80             	addb   $0x80,(%ebx)
  281561:	01 c0                	add    %eax,%eax
  281563:	01 c0                	add    %eax,%eax
  281565:	00 e0                	add    %ah,%al
  281567:	00 60 00             	add    %ah,0x0(%eax)
  28156a:	60                   	pusha  
  28156b:	00 70 00             	add    %dh,0x0(%eax)
  28156e:	30 00                	xor    %al,(%eax)
  281570:	30 00                	xor    %al,(%eax)
  281572:	30 00                	xor    %al,(%eax)
	...
  281580:	00 00                	add    %al,(%eax)
  281582:	e0 03                	loopne 281587 <ASCII_Table+0x487>
  281584:	f0 07                	lock pop %es
  281586:	38 0e                	cmp    %cl,(%esi)
  281588:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28158b:	0c 18                	or     $0x18,%al
  28158d:	0c 38                	or     $0x38,%al
  28158f:	06                   	push   %es
  281590:	f0 07                	lock pop %es
  281592:	f0 07                	lock pop %es
  281594:	18 0c 0c             	sbb    %cl,(%esp,%ecx,1)
  281597:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28159a:	0c 18                	or     $0x18,%al
  28159c:	0c 18                	or     $0x18,%al
  28159e:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  2815a1:	0f e0 03             	pavgb  (%ebx),%mm0
	...
  2815b0:	00 00                	add    %al,(%eax)
  2815b2:	e0 03                	loopne 2815b7 <ASCII_Table+0x4b7>
  2815b4:	f0 07                	lock pop %es
  2815b6:	38 0e                	cmp    %cl,(%esi)
  2815b8:	1c 0c                	sbb    $0xc,%al
  2815ba:	0c 18                	or     $0x18,%al
  2815bc:	0c 18                	or     $0x18,%al
  2815be:	0c 18                	or     $0x18,%al
  2815c0:	1c 1c                	sbb    $0x1c,%al
  2815c2:	38 1e                	cmp    %bl,(%esi)
  2815c4:	f8                   	clc    
  2815c5:	1b e0                	sbb    %eax,%esp
  2815c7:	19 00                	sbb    %eax,(%eax)
  2815c9:	18 00                	sbb    %al,(%eax)
  2815cb:	0c 00                	or     $0x0,%al
  2815cd:	0c 1c                	or     $0x1c,%al
  2815cf:	0e                   	push   %cs
  2815d0:	f8                   	clc    
  2815d1:	07                   	pop    %es
  2815d2:	f0 01 00             	lock add %eax,(%eax)
	...
  2815e9:	00 00                	add    %al,(%eax)
  2815eb:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  2815fd:	00 00                	add    %al,(%eax)
  2815ff:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  281619:	00 00                	add    %al,(%eax)
  28161b:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
	...
  28162d:	00 00                	add    %al,(%eax)
  28162f:	00 80 01 80 01 00    	add    %al,0x18001(%eax)
  281635:	01 00                	add    %eax,(%eax)
  281637:	01 80 00 00 00 00    	add    %eax,0x0(%eax)
	...
  281651:	10 00                	adc    %al,(%eax)
  281653:	1c 80                	sbb    $0x80,%al
  281655:	0f e0 03             	pavgb  (%ebx),%mm0
  281658:	f8                   	clc    
  281659:	00 18                	add    %bl,(%eax)
  28165b:	00 f8                	add    %bh,%al
  28165d:	00 e0                	add    %ah,%al
  28165f:	03 80 0f 00 1c 00    	add    0x1c000f(%eax),%eax
  281665:	10 00                	adc    %al,(%eax)
	...
  28167f:	00 f8                	add    %bh,%al
  281681:	1f                   	pop    %ds
  281682:	00 00                	add    %al,(%eax)
  281684:	00 00                	add    %al,(%eax)
  281686:	00 00                	add    %al,(%eax)
  281688:	f8                   	clc    
  281689:	1f                   	pop    %ds
	...
  2816ae:	00 00                	add    %al,(%eax)
  2816b0:	08 00                	or     %al,(%eax)
  2816b2:	38 00                	cmp    %al,(%eax)
  2816b4:	f0 01 c0             	lock add %eax,%eax
  2816b7:	07                   	pop    %es
  2816b8:	00 1f                	add    %bl,(%edi)
  2816ba:	00 18                	add    %bl,(%eax)
  2816bc:	00 1f                	add    %bl,(%edi)
  2816be:	c0 07 f0             	rolb   $0xf0,(%edi)
  2816c1:	01 38                	add    %edi,(%eax)
  2816c3:	00 08                	add    %cl,(%eax)
	...
  2816d1:	00 e0                	add    %ah,%al
  2816d3:	03 f8                	add    %eax,%edi
  2816d5:	0f 18 0c 0c          	prefetcht0 (%esp,%ecx,1)
  2816d9:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  2816dc:	00 18                	add    %bl,(%eax)
  2816de:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2816e1:	06                   	push   %es
  2816e2:	00 03                	add    %al,(%ebx)
  2816e4:	80 01 c0             	addb   $0xc0,(%ecx)
  2816e7:	00 c0                	add    %al,%al
  2816e9:	00 c0                	add    %al,%al
  2816eb:	00 00                	add    %al,(%eax)
  2816ed:	00 00                	add    %al,(%eax)
  2816ef:	00 c0                	add    %al,%al
  2816f1:	00 c0                	add    %al,%al
	...
  281703:	00 e0                	add    %ah,%al
  281705:	07                   	pop    %es
  281706:	18 18                	sbb    %bl,(%eax)
  281708:	04 20                	add    $0x20,%al
  28170a:	c2 29 22             	ret    $0x2229
  28170d:	4a                   	dec    %edx
  28170e:	11 44 09 44          	adc    %eax,0x44(%ecx,%ecx,1)
  281712:	09 44 09 44          	or     %eax,0x44(%ecx,%ecx,1)
  281716:	09 22                	or     %esp,(%edx)
  281718:	11 13                	adc    %edx,(%ebx)
  28171a:	e2 0c                	loop   281728 <ASCII_Table+0x628>
  28171c:	02 40 04             	add    0x4(%eax),%al
  28171f:	20 18                	and    %bl,(%eax)
  281721:	18 e0                	sbb    %ah,%al
  281723:	07                   	pop    %es
	...
  281730:	00 00                	add    %al,(%eax)
  281732:	80 03 80             	addb   $0x80,(%ebx)
  281735:	03 c0                	add    %eax,%eax
  281737:	06                   	push   %es
  281738:	c0 06 c0             	rolb   $0xc0,(%esi)
  28173b:	06                   	push   %es
  28173c:	60                   	pusha  
  28173d:	0c 60                	or     $0x60,%al
  28173f:	0c 30                	or     $0x30,%al
  281741:	18 30                	sbb    %dh,(%eax)
  281743:	18 30                	sbb    %dh,(%eax)
  281745:	18 f8                	sbb    %bh,%al
  281747:	3f                   	aas    
  281748:	f8                   	clc    
  281749:	3f                   	aas    
  28174a:	1c 70                	sbb    $0x70,%al
  28174c:	0c 60                	or     $0x60,%al
  28174e:	0c 60                	or     $0x60,%al
  281750:	06                   	push   %es
  281751:	c0 06 c0             	rolb   $0xc0,(%esi)
	...
  281760:	00 00                	add    %al,(%eax)
  281762:	fc                   	cld    
  281763:	03 fc                	add    %esp,%edi
  281765:	0f 0c                	(bad)  
  281767:	0c 0c                	or     $0xc,%al
  281769:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  28176c:	0c 18                	or     $0x18,%al
  28176e:	0c 0c                	or     $0xc,%al
  281770:	fc                   	cld    
  281771:	07                   	pop    %es
  281772:	fc                   	cld    
  281773:	0f 0c                	(bad)  
  281775:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  281778:	0c 30                	or     $0x30,%al
  28177a:	0c 30                	or     $0x30,%al
  28177c:	0c 30                	or     $0x30,%al
  28177e:	0c 18                	or     $0x18,%al
  281780:	fc                   	cld    
  281781:	1f                   	pop    %ds
  281782:	fc                   	cld    
  281783:	07                   	pop    %es
	...
  281790:	00 00                	add    %al,(%eax)
  281792:	c0 07 f0             	rolb   $0xf0,(%edi)
  281795:	1f                   	pop    %ds
  281796:	38 38                	cmp    %bh,(%eax)
  281798:	1c 30                	sbb    $0x30,%al
  28179a:	0c 70                	or     $0x70,%al
  28179c:	06                   	push   %es
  28179d:	60                   	pusha  
  28179e:	06                   	push   %es
  28179f:	00 06                	add    %al,(%esi)
  2817a1:	00 06                	add    %al,(%esi)
  2817a3:	00 06                	add    %al,(%esi)
  2817a5:	00 06                	add    %al,(%esi)
  2817a7:	00 06                	add    %al,(%esi)
  2817a9:	00 06                	add    %al,(%esi)
  2817ab:	60                   	pusha  
  2817ac:	0c 70                	or     $0x70,%al
  2817ae:	1c 30                	sbb    $0x30,%al
  2817b0:	f0 1f                	lock pop %ds
  2817b2:	e0 07                	loopne 2817bb <ASCII_Table+0x6bb>
	...
  2817c0:	00 00                	add    %al,(%eax)
  2817c2:	fe 03                	incb   (%ebx)
  2817c4:	fe 0f                	decb   (%edi)
  2817c6:	06                   	push   %es
  2817c7:	0e                   	push   %cs
  2817c8:	06                   	push   %es
  2817c9:	18 06                	sbb    %al,(%esi)
  2817cb:	18 06                	sbb    %al,(%esi)
  2817cd:	30 06                	xor    %al,(%esi)
  2817cf:	30 06                	xor    %al,(%esi)
  2817d1:	30 06                	xor    %al,(%esi)
  2817d3:	30 06                	xor    %al,(%esi)
  2817d5:	30 06                	xor    %al,(%esi)
  2817d7:	30 06                	xor    %al,(%esi)
  2817d9:	30 06                	xor    %al,(%esi)
  2817db:	18 06                	sbb    %al,(%esi)
  2817dd:	18 06                	sbb    %al,(%esi)
  2817df:	0e                   	push   %cs
  2817e0:	fe 0f                	decb   (%edi)
  2817e2:	fe 03                	incb   (%ebx)
	...
  2817f0:	00 00                	add    %al,(%eax)
  2817f2:	fc                   	cld    
  2817f3:	3f                   	aas    
  2817f4:	fc                   	cld    
  2817f5:	3f                   	aas    
  2817f6:	0c 00                	or     $0x0,%al
  2817f8:	0c 00                	or     $0x0,%al
  2817fa:	0c 00                	or     $0x0,%al
  2817fc:	0c 00                	or     $0x0,%al
  2817fe:	0c 00                	or     $0x0,%al
  281800:	fc                   	cld    
  281801:	1f                   	pop    %ds
  281802:	fc                   	cld    
  281803:	1f                   	pop    %ds
  281804:	0c 00                	or     $0x0,%al
  281806:	0c 00                	or     $0x0,%al
  281808:	0c 00                	or     $0x0,%al
  28180a:	0c 00                	or     $0x0,%al
  28180c:	0c 00                	or     $0x0,%al
  28180e:	0c 00                	or     $0x0,%al
  281810:	fc                   	cld    
  281811:	3f                   	aas    
  281812:	fc                   	cld    
  281813:	3f                   	aas    
	...
  281820:	00 00                	add    %al,(%eax)
  281822:	f8                   	clc    
  281823:	3f                   	aas    
  281824:	f8                   	clc    
  281825:	3f                   	aas    
  281826:	18 00                	sbb    %al,(%eax)
  281828:	18 00                	sbb    %al,(%eax)
  28182a:	18 00                	sbb    %al,(%eax)
  28182c:	18 00                	sbb    %al,(%eax)
  28182e:	18 00                	sbb    %al,(%eax)
  281830:	f8                   	clc    
  281831:	1f                   	pop    %ds
  281832:	f8                   	clc    
  281833:	1f                   	pop    %ds
  281834:	18 00                	sbb    %al,(%eax)
  281836:	18 00                	sbb    %al,(%eax)
  281838:	18 00                	sbb    %al,(%eax)
  28183a:	18 00                	sbb    %al,(%eax)
  28183c:	18 00                	sbb    %al,(%eax)
  28183e:	18 00                	sbb    %al,(%eax)
  281840:	18 00                	sbb    %al,(%eax)
  281842:	18 00                	sbb    %al,(%eax)
	...
  281850:	00 00                	add    %al,(%eax)
  281852:	e0 0f                	loopne 281863 <ASCII_Table+0x763>
  281854:	f8                   	clc    
  281855:	3f                   	aas    
  281856:	3c 78                	cmp    $0x78,%al
  281858:	0e                   	push   %cs
  281859:	60                   	pusha  
  28185a:	06                   	push   %es
  28185b:	e0 07                	loopne 281864 <ASCII_Table+0x764>
  28185d:	c0 03 00             	rolb   $0x0,(%ebx)
  281860:	03 00                	add    (%eax),%eax
  281862:	03 fe                	add    %esi,%edi
  281864:	03 fe                	add    %esi,%edi
  281866:	03 c0                	add    %eax,%eax
  281868:	07                   	pop    %es
  281869:	c0 06 c0             	rolb   $0xc0,(%esi)
  28186c:	0e                   	push   %cs
  28186d:	c0 3c f0 f8          	sarb   $0xf8,(%eax,%esi,8)
  281871:	3f                   	aas    
  281872:	e0 0f                	loopne 281883 <ASCII_Table+0x783>
	...
  281880:	00 00                	add    %al,(%eax)
  281882:	0c 30                	or     $0x30,%al
  281884:	0c 30                	or     $0x30,%al
  281886:	0c 30                	or     $0x30,%al
  281888:	0c 30                	or     $0x30,%al
  28188a:	0c 30                	or     $0x30,%al
  28188c:	0c 30                	or     $0x30,%al
  28188e:	0c 30                	or     $0x30,%al
  281890:	fc                   	cld    
  281891:	3f                   	aas    
  281892:	fc                   	cld    
  281893:	3f                   	aas    
  281894:	0c 30                	or     $0x30,%al
  281896:	0c 30                	or     $0x30,%al
  281898:	0c 30                	or     $0x30,%al
  28189a:	0c 30                	or     $0x30,%al
  28189c:	0c 30                	or     $0x30,%al
  28189e:	0c 30                	or     $0x30,%al
  2818a0:	0c 30                	or     $0x30,%al
  2818a2:	0c 30                	or     $0x30,%al
	...
  2818b0:	00 00                	add    %al,(%eax)
  2818b2:	80 01 80             	addb   $0x80,(%ecx)
  2818b5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818bb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818c1:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818c7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818cd:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  2818d3:	01 00                	add    %eax,(%eax)
	...
  2818e1:	00 00                	add    %al,(%eax)
  2818e3:	06                   	push   %es
  2818e4:	00 06                	add    %al,(%esi)
  2818e6:	00 06                	add    %al,(%esi)
  2818e8:	00 06                	add    %al,(%esi)
  2818ea:	00 06                	add    %al,(%esi)
  2818ec:	00 06                	add    %al,(%esi)
  2818ee:	00 06                	add    %al,(%esi)
  2818f0:	00 06                	add    %al,(%esi)
  2818f2:	00 06                	add    %al,(%esi)
  2818f4:	00 06                	add    %al,(%esi)
  2818f6:	00 06                	add    %al,(%esi)
  2818f8:	00 06                	add    %al,(%esi)
  2818fa:	18 06                	sbb    %al,(%esi)
  2818fc:	18 06                	sbb    %al,(%esi)
  2818fe:	38 07                	cmp    %al,(%edi)
  281900:	f0 03 e0             	lock add %eax,%esp
  281903:	01 00                	add    %eax,(%eax)
	...
  281911:	00 06                	add    %al,(%esi)
  281913:	30 06                	xor    %al,(%esi)
  281915:	18 06                	sbb    %al,(%esi)
  281917:	0c 06                	or     $0x6,%al
  281919:	06                   	push   %es
  28191a:	06                   	push   %es
  28191b:	03 86 01 c6 00 66    	add    0x6600c601(%esi),%eax
  281921:	00 76 00             	add    %dh,0x0(%esi)
  281924:	de 00                	fiadd  (%eax)
  281926:	8e 01                	mov    (%ecx),%es
  281928:	06                   	push   %es
  281929:	03 06                	add    (%esi),%eax
  28192b:	06                   	push   %es
  28192c:	06                   	push   %es
  28192d:	0c 06                	or     $0x6,%al
  28192f:	18 06                	sbb    %al,(%esi)
  281931:	30 06                	xor    %al,(%esi)
  281933:	60                   	pusha  
	...
  281940:	00 00                	add    %al,(%eax)
  281942:	18 00                	sbb    %al,(%eax)
  281944:	18 00                	sbb    %al,(%eax)
  281946:	18 00                	sbb    %al,(%eax)
  281948:	18 00                	sbb    %al,(%eax)
  28194a:	18 00                	sbb    %al,(%eax)
  28194c:	18 00                	sbb    %al,(%eax)
  28194e:	18 00                	sbb    %al,(%eax)
  281950:	18 00                	sbb    %al,(%eax)
  281952:	18 00                	sbb    %al,(%eax)
  281954:	18 00                	sbb    %al,(%eax)
  281956:	18 00                	sbb    %al,(%eax)
  281958:	18 00                	sbb    %al,(%eax)
  28195a:	18 00                	sbb    %al,(%eax)
  28195c:	18 00                	sbb    %al,(%eax)
  28195e:	18 00                	sbb    %al,(%eax)
  281960:	f8                   	clc    
  281961:	1f                   	pop    %ds
  281962:	f8                   	clc    
  281963:	1f                   	pop    %ds
	...
  281970:	00 00                	add    %al,(%eax)
  281972:	0e                   	push   %cs
  281973:	e0 1e                	loopne 281993 <ASCII_Table+0x893>
  281975:	f0 1e                	lock push %ds
  281977:	f0 1e                	lock push %ds
  281979:	f0 36 d8 36          	lock fdivs %ss:(%esi)
  28197d:	d8 36                	fdivs  (%esi)
  28197f:	d8 36                	fdivs  (%esi)
  281981:	d8 66 cc             	fsubs  -0x34(%esi)
  281984:	66                   	data16
  281985:	cc                   	int3   
  281986:	66                   	data16
  281987:	cc                   	int3   
  281988:	c6 c6 c6             	mov    $0xc6,%dh
  28198b:	c6 c6 c6             	mov    $0xc6,%dh
  28198e:	c6 c6 86             	mov    $0x86,%dh
  281991:	c3                   	ret    
  281992:	86 c3                	xchg   %al,%bl
	...
  2819a0:	00 00                	add    %al,(%eax)
  2819a2:	0c 30                	or     $0x30,%al
  2819a4:	1c 30                	sbb    $0x30,%al
  2819a6:	3c 30                	cmp    $0x30,%al
  2819a8:	3c 30                	cmp    $0x30,%al
  2819aa:	6c                   	insb   (%dx),%es:(%edi)
  2819ab:	30 6c 30 cc          	xor    %ch,-0x34(%eax,%esi,1)
  2819af:	30 cc                	xor    %cl,%ah
  2819b1:	30 8c 31 0c 33 0c 33 	xor    %cl,0x330c330c(%ecx,%esi,1)
  2819b8:	0c 36                	or     $0x36,%al
  2819ba:	0c 36                	or     $0x36,%al
  2819bc:	0c 3c                	or     $0x3c,%al
  2819be:	0c 3c                	or     $0x3c,%al
  2819c0:	0c 38                	or     $0x38,%al
  2819c2:	0c 30                	or     $0x30,%al
	...
  2819d0:	00 00                	add    %al,(%eax)
  2819d2:	e0 07                	loopne 2819db <ASCII_Table+0x8db>
  2819d4:	f8                   	clc    
  2819d5:	1f                   	pop    %ds
  2819d6:	1c 38                	sbb    $0x38,%al
  2819d8:	0e                   	push   %cs
  2819d9:	70 06                	jo     2819e1 <ASCII_Table+0x8e1>
  2819db:	60                   	pusha  
  2819dc:	03 c0                	add    %eax,%eax
  2819de:	03 c0                	add    %eax,%eax
  2819e0:	03 c0                	add    %eax,%eax
  2819e2:	03 c0                	add    %eax,%eax
  2819e4:	03 c0                	add    %eax,%eax
  2819e6:	03 c0                	add    %eax,%eax
  2819e8:	03 c0                	add    %eax,%eax
  2819ea:	06                   	push   %es
  2819eb:	60                   	pusha  
  2819ec:	0e                   	push   %cs
  2819ed:	70 1c                	jo     281a0b <ASCII_Table+0x90b>
  2819ef:	38 f8                	cmp    %bh,%al
  2819f1:	1f                   	pop    %ds
  2819f2:	e0 07                	loopne 2819fb <ASCII_Table+0x8fb>
	...
  281a00:	00 00                	add    %al,(%eax)
  281a02:	fc                   	cld    
  281a03:	0f fc 1f             	paddb  (%edi),%mm3
  281a06:	0c 38                	or     $0x38,%al
  281a08:	0c 30                	or     $0x30,%al
  281a0a:	0c 30                	or     $0x30,%al
  281a0c:	0c 30                	or     $0x30,%al
  281a0e:	0c 30                	or     $0x30,%al
  281a10:	0c 18                	or     $0x18,%al
  281a12:	fc                   	cld    
  281a13:	1f                   	pop    %ds
  281a14:	fc                   	cld    
  281a15:	07                   	pop    %es
  281a16:	0c 00                	or     $0x0,%al
  281a18:	0c 00                	or     $0x0,%al
  281a1a:	0c 00                	or     $0x0,%al
  281a1c:	0c 00                	or     $0x0,%al
  281a1e:	0c 00                	or     $0x0,%al
  281a20:	0c 00                	or     $0x0,%al
  281a22:	0c 00                	or     $0x0,%al
	...
  281a30:	00 00                	add    %al,(%eax)
  281a32:	e0 07                	loopne 281a3b <ASCII_Table+0x93b>
  281a34:	f8                   	clc    
  281a35:	1f                   	pop    %ds
  281a36:	1c 38                	sbb    $0x38,%al
  281a38:	0e                   	push   %cs
  281a39:	70 06                	jo     281a41 <ASCII_Table+0x941>
  281a3b:	60                   	pusha  
  281a3c:	03 e0                	add    %eax,%esp
  281a3e:	03 c0                	add    %eax,%eax
  281a40:	03 c0                	add    %eax,%eax
  281a42:	03 c0                	add    %eax,%eax
  281a44:	03 c0                	add    %eax,%eax
  281a46:	03 c0                	add    %eax,%eax
  281a48:	07                   	pop    %es
  281a49:	e0 06                	loopne 281a51 <ASCII_Table+0x951>
  281a4b:	63 0e                	arpl   %cx,(%esi)
  281a4d:	3f                   	aas    
  281a4e:	1c 3c                	sbb    $0x3c,%al
  281a50:	f8                   	clc    
  281a51:	3f                   	aas    
  281a52:	e0 f7                	loopne 281a4b <ASCII_Table+0x94b>
  281a54:	00 c0                	add    %al,%al
	...
  281a62:	fe 0f                	decb   (%edi)
  281a64:	fe                   	(bad)  
  281a65:	1f                   	pop    %ds
  281a66:	06                   	push   %es
  281a67:	38 06                	cmp    %al,(%esi)
  281a69:	30 06                	xor    %al,(%esi)
  281a6b:	30 06                	xor    %al,(%esi)
  281a6d:	30 06                	xor    %al,(%esi)
  281a6f:	38 fe                	cmp    %bh,%dh
  281a71:	1f                   	pop    %ds
  281a72:	fe 07                	incb   (%edi)
  281a74:	06                   	push   %es
  281a75:	03 06                	add    (%esi),%eax
  281a77:	06                   	push   %es
  281a78:	06                   	push   %es
  281a79:	0c 06                	or     $0x6,%al
  281a7b:	18 06                	sbb    %al,(%esi)
  281a7d:	18 06                	sbb    %al,(%esi)
  281a7f:	30 06                	xor    %al,(%esi)
  281a81:	30 06                	xor    %al,(%esi)
  281a83:	60                   	pusha  
	...
  281a90:	00 00                	add    %al,(%eax)
  281a92:	e0 03                	loopne 281a97 <ASCII_Table+0x997>
  281a94:	f8                   	clc    
  281a95:	0f 1c 0c 0c          	nopl   (%esp,%ecx,1)
  281a99:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281a9c:	0c 00                	or     $0x0,%al
  281a9e:	1c 00                	sbb    $0x0,%al
  281aa0:	f8                   	clc    
  281aa1:	03 e0                	add    %eax,%esp
  281aa3:	0f 00 1e             	ltr    (%esi)
  281aa6:	00 38                	add    %bh,(%eax)
  281aa8:	06                   	push   %es
  281aa9:	30 06                	xor    %al,(%esi)
  281aab:	30 0e                	xor    %cl,(%esi)
  281aad:	30 1c 1c             	xor    %bl,(%esp,%ebx,1)
  281ab0:	f8                   	clc    
  281ab1:	0f e0 07             	pavgb  (%edi),%mm0
	...
  281ac0:	00 00                	add    %al,(%eax)
  281ac2:	fe                   	(bad)  
  281ac3:	7f fe                	jg     281ac3 <ASCII_Table+0x9c3>
  281ac5:	7f 80                	jg     281a47 <ASCII_Table+0x947>
  281ac7:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281acd:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281ad3:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281ad9:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281adf:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
	...
  281af1:	00 0c 30             	add    %cl,(%eax,%esi,1)
  281af4:	0c 30                	or     $0x30,%al
  281af6:	0c 30                	or     $0x30,%al
  281af8:	0c 30                	or     $0x30,%al
  281afa:	0c 30                	or     $0x30,%al
  281afc:	0c 30                	or     $0x30,%al
  281afe:	0c 30                	or     $0x30,%al
  281b00:	0c 30                	or     $0x30,%al
  281b02:	0c 30                	or     $0x30,%al
  281b04:	0c 30                	or     $0x30,%al
  281b06:	0c 30                	or     $0x30,%al
  281b08:	0c 30                	or     $0x30,%al
  281b0a:	0c 30                	or     $0x30,%al
  281b0c:	0c 30                	or     $0x30,%al
  281b0e:	18 18                	sbb    %bl,(%eax)
  281b10:	f8                   	clc    
  281b11:	1f                   	pop    %ds
  281b12:	e0 07                	loopne 281b1b <ASCII_Table+0xa1b>
	...
  281b20:	00 00                	add    %al,(%eax)
  281b22:	03 60 06             	add    0x6(%eax),%esp
  281b25:	30 06                	xor    %al,(%esi)
  281b27:	30 06                	xor    %al,(%esi)
  281b29:	30 0c 18             	xor    %cl,(%eax,%ebx,1)
  281b2c:	0c 18                	or     $0x18,%al
  281b2e:	0c 18                	or     $0x18,%al
  281b30:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281b33:	0c 38                	or     $0x38,%al
  281b35:	0e                   	push   %cs
  281b36:	30 06                	xor    %al,(%esi)
  281b38:	30 06                	xor    %al,(%esi)
  281b3a:	70 07                	jo     281b43 <ASCII_Table+0xa43>
  281b3c:	60                   	pusha  
  281b3d:	03 60 03             	add    0x3(%eax),%esp
  281b40:	c0 01 c0             	rolb   $0xc0,(%ecx)
  281b43:	01 00                	add    %eax,(%eax)
	...
  281b51:	00 03                	add    %al,(%ebx)
  281b53:	60                   	pusha  
  281b54:	c3                   	ret    
  281b55:	61                   	popa   
  281b56:	c3                   	ret    
  281b57:	61                   	popa   
  281b58:	c3                   	ret    
  281b59:	61                   	popa   
  281b5a:	66 33 66 33          	xor    0x33(%esi),%sp
  281b5e:	66 33 66 33          	xor    0x33(%esi),%sp
  281b62:	66 33 66 33          	xor    0x33(%esi),%sp
  281b66:	6c                   	insb   (%dx),%es:(%edi)
  281b67:	1b 6c 1b 6c          	sbb    0x6c(%ebx,%ebx,1),%ebp
  281b6b:	1b 2c 1a             	sbb    (%edx,%ebx,1),%ebp
  281b6e:	3c 1e                	cmp    $0x1e,%al
  281b70:	38 0e                	cmp    %cl,(%esi)
  281b72:	38 0e                	cmp    %cl,(%esi)
	...
  281b80:	00 00                	add    %al,(%eax)
  281b82:	0f e0 0c 70          	pavgb  (%eax,%esi,2),%mm1
  281b86:	18 30                	sbb    %dh,(%eax)
  281b88:	30 18                	xor    %bl,(%eax)
  281b8a:	70 0c                	jo     281b98 <ASCII_Table+0xa98>
  281b8c:	60                   	pusha  
  281b8d:	0e                   	push   %cs
  281b8e:	c0 07 80             	rolb   $0x80,(%edi)
  281b91:	03 80 03 c0 03 e0    	add    -0x1ffc3ffd(%eax),%eax
  281b97:	06                   	push   %es
  281b98:	70 0c                	jo     281ba6 <ASCII_Table+0xaa6>
  281b9a:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  281b9d:	18 0c 30             	sbb    %cl,(%eax,%esi,1)
  281ba0:	0e                   	push   %cs
  281ba1:	60                   	pusha  
  281ba2:	07                   	pop    %es
  281ba3:	e0 00                	loopne 281ba5 <ASCII_Table+0xaa5>
	...
  281bb1:	00 03                	add    %al,(%ebx)
  281bb3:	c0 06 60             	rolb   $0x60,(%esi)
  281bb6:	0c 30                	or     $0x30,%al
  281bb8:	1c 38                	sbb    $0x38,%al
  281bba:	38 18                	cmp    %bl,(%eax)
  281bbc:	30 0c 60             	xor    %cl,(%eax,%eiz,2)
  281bbf:	06                   	push   %es
  281bc0:	e0 07                	loopne 281bc9 <ASCII_Table+0xac9>
  281bc2:	c0 03 80             	rolb   $0x80,(%ebx)
  281bc5:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281bcb:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281bd1:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
	...
  281bdf:	00 00                	add    %al,(%eax)
  281be1:	00 fc                	add    %bh,%ah
  281be3:	7f fc                	jg     281be1 <ASCII_Table+0xae1>
  281be5:	7f 00                	jg     281be7 <ASCII_Table+0xae7>
  281be7:	60                   	pusha  
  281be8:	00 30                	add    %dh,(%eax)
  281bea:	00 18                	add    %bl,(%eax)
  281bec:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281bef:	06                   	push   %es
  281bf0:	00 03                	add    %al,(%ebx)
  281bf2:	80 01 c0             	addb   $0xc0,(%ecx)
  281bf5:	00 60 00             	add    %ah,0x0(%eax)
  281bf8:	30 00                	xor    %al,(%eax)
  281bfa:	18 00                	sbb    %al,(%eax)
  281bfc:	0c 00                	or     $0x0,%al
  281bfe:	06                   	push   %es
  281bff:	00 fe                	add    %bh,%dh
  281c01:	7f fe                	jg     281c01 <ASCII_Table+0xb01>
  281c03:	7f 00                	jg     281c05 <ASCII_Table+0xb05>
	...
  281c11:	00 e0                	add    %ah,%al
  281c13:	03 e0                	add    %eax,%esp
  281c15:	03 60 00             	add    0x0(%eax),%esp
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
  281c2d:	00 60 00             	add    %ah,0x0(%eax)
  281c30:	60                   	pusha  
  281c31:	00 60 00             	add    %ah,0x0(%eax)
  281c34:	60                   	pusha  
  281c35:	00 60 00             	add    %ah,0x0(%eax)
  281c38:	60                   	pusha  
  281c39:	00 e0                	add    %ah,%al
  281c3b:	03 e0                	add    %eax,%esp
  281c3d:	03 00                	add    (%eax),%eax
  281c3f:	00 00                	add    %al,(%eax)
  281c41:	00 30                	add    %dh,(%eax)
  281c43:	00 30                	add    %dh,(%eax)
  281c45:	00 60 00             	add    %ah,0x0(%eax)
  281c48:	60                   	pusha  
  281c49:	00 60 00             	add    %ah,0x0(%eax)
  281c4c:	c0 00 c0             	rolb   $0xc0,(%eax)
  281c4f:	00 c0                	add    %al,%al
  281c51:	00 c0                	add    %al,%al
  281c53:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  281c59:	01 00                	add    %eax,(%eax)
  281c5b:	03 00                	add    (%eax),%eax
  281c5d:	03 00                	add    (%eax),%eax
  281c5f:	03 00                	add    (%eax),%eax
  281c61:	06                   	push   %es
  281c62:	00 06                	add    %al,(%esi)
	...
  281c70:	00 00                	add    %al,(%eax)
  281c72:	e0 03                	loopne 281c77 <ASCII_Table+0xb77>
  281c74:	e0 03                	loopne 281c79 <ASCII_Table+0xb79>
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
  281c8e:	00 03                	add    %al,(%ebx)
  281c90:	00 03                	add    %al,(%ebx)
  281c92:	00 03                	add    %al,(%ebx)
  281c94:	00 03                	add    %al,(%ebx)
  281c96:	00 03                	add    %al,(%ebx)
  281c98:	00 03                	add    %al,(%ebx)
  281c9a:	e0 03                	loopne 281c9f <ASCII_Table+0xb9f>
  281c9c:	e0 03                	loopne 281ca1 <ASCII_Table+0xba1>
  281c9e:	00 00                	add    %al,(%eax)
  281ca0:	00 00                	add    %al,(%eax)
  281ca2:	00 00                	add    %al,(%eax)
  281ca4:	c0 01 c0             	rolb   $0xc0,(%ecx)
  281ca7:	01 60 03             	add    %esp,0x3(%eax)
  281caa:	60                   	pusha  
  281cab:	03 60 03             	add    0x3(%eax),%esp
  281cae:	30 06                	xor    %al,(%esi)
  281cb0:	30 06                	xor    %al,(%esi)
  281cb2:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281cb5:	0c 00                	or     $0x0,%al
	...
  281cef:	00 00                	add    %al,(%eax)
  281cf1:	00 ff                	add    %bh,%bh
  281cf3:	ff                   	(bad)  
  281cf4:	ff                   	(bad)  
  281cf5:	ff 00                	incl   (%eax)
	...
  281cff:	00 00                	add    %al,(%eax)
  281d01:	00 0c 00             	add    %cl,(%eax,%eax,1)
  281d04:	0c 00                	or     $0x0,%al
  281d06:	0c 00                	or     $0x0,%al
  281d08:	0c 00                	or     $0x0,%al
  281d0a:	0c 00                	or     $0x0,%al
  281d0c:	0c 00                	or     $0x0,%al
	...
  281d3a:	00 00                	add    %al,(%eax)
  281d3c:	f0 03 f8             	lock add %eax,%edi
  281d3f:	07                   	pop    %es
  281d40:	1c 0c                	sbb    $0xc,%al
  281d42:	0c 0c                	or     $0xc,%al
  281d44:	00 0f                	add    %cl,(%edi)
  281d46:	f0 0f f8 0c 0c       	lock psubb (%esp,%ecx,1),%mm1
  281d4b:	0c 0c                	or     $0xc,%al
  281d4d:	0c 1c                	or     $0x1c,%al
  281d4f:	0f f8 0f             	psubb  (%edi),%mm1
  281d52:	f0 18 00             	lock sbb %al,(%eax)
	...
  281d61:	00 18                	add    %bl,(%eax)
  281d63:	00 18                	add    %bl,(%eax)
  281d65:	00 18                	add    %bl,(%eax)
  281d67:	00 18                	add    %bl,(%eax)
  281d69:	00 18                	add    %bl,(%eax)
  281d6b:	00 d8                	add    %bl,%al
  281d6d:	03 f8                	add    %eax,%edi
  281d6f:	0f 38 0c             	(bad)  
  281d72:	18 18                	sbb    %bl,(%eax)
  281d74:	18 18                	sbb    %bl,(%eax)
  281d76:	18 18                	sbb    %bl,(%eax)
  281d78:	18 18                	sbb    %bl,(%eax)
  281d7a:	18 18                	sbb    %bl,(%eax)
  281d7c:	18 18                	sbb    %bl,(%eax)
  281d7e:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  281d81:	0f d8 03             	psubusb (%ebx),%mm0
	...
  281d9c:	c0 03 f0             	rolb   $0xf0,(%ebx)
  281d9f:	07                   	pop    %es
  281da0:	30 0e                	xor    %cl,(%esi)
  281da2:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  281da5:	00 18                	add    %bl,(%eax)
  281da7:	00 18                	add    %bl,(%eax)
  281da9:	00 18                	add    %bl,(%eax)
  281dab:	00 18                	add    %bl,(%eax)
  281dad:	0c 30                	or     $0x30,%al
  281daf:	0e                   	push   %cs
  281db0:	f0 07                	lock pop %es
  281db2:	c0 03 00             	rolb   $0x0,(%ebx)
	...
  281dc1:	00 00                	add    %al,(%eax)
  281dc3:	18 00                	sbb    %al,(%eax)
  281dc5:	18 00                	sbb    %al,(%eax)
  281dc7:	18 00                	sbb    %al,(%eax)
  281dc9:	18 00                	sbb    %al,(%eax)
  281dcb:	18 c0                	sbb    %al,%al
  281dcd:	1b f0                	sbb    %eax,%esi
  281dcf:	1f                   	pop    %ds
  281dd0:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  281dd3:	18 18                	sbb    %bl,(%eax)
  281dd5:	18 18                	sbb    %bl,(%eax)
  281dd7:	18 18                	sbb    %bl,(%eax)
  281dd9:	18 18                	sbb    %bl,(%eax)
  281ddb:	18 18                	sbb    %bl,(%eax)
  281ddd:	18 30                	sbb    %dh,(%eax)
  281ddf:	1c f0                	sbb    $0xf0,%al
  281de1:	1f                   	pop    %ds
  281de2:	c0 1b 00             	rcrb   $0x0,(%ebx)
	...
  281df9:	00 00                	add    %al,(%eax)
  281dfb:	00 c0                	add    %al,%al
  281dfd:	03 f0                	add    %eax,%esi
  281dff:	0f 30                	wrmsr  
  281e01:	0c 18                	or     $0x18,%al
  281e03:	18 f8                	sbb    %bh,%al
  281e05:	1f                   	pop    %ds
  281e06:	f8                   	clc    
  281e07:	1f                   	pop    %ds
  281e08:	18 00                	sbb    %al,(%eax)
  281e0a:	18 00                	sbb    %al,(%eax)
  281e0c:	38 18                	cmp    %bl,(%eax)
  281e0e:	30 1c f0             	xor    %bl,(%eax,%esi,8)
  281e11:	0f c0 07             	xadd   %al,(%edi)
	...
  281e20:	00 00                	add    %al,(%eax)
  281e22:	80 0f c0             	orb    $0xc0,(%edi)
  281e25:	0f c0 00             	xadd   %al,(%eax)
  281e28:	c0 00 c0             	rolb   $0xc0,(%eax)
  281e2b:	00 f0                	add    %dh,%al
  281e2d:	07                   	pop    %es
  281e2e:	f0 07                	lock pop %es
  281e30:	c0 00 c0             	rolb   $0xc0,(%eax)
  281e33:	00 c0                	add    %al,%al
  281e35:	00 c0                	add    %al,%al
  281e37:	00 c0                	add    %al,%al
  281e39:	00 c0                	add    %al,%al
  281e3b:	00 c0                	add    %al,%al
  281e3d:	00 c0                	add    %al,%al
  281e3f:	00 c0                	add    %al,%al
  281e41:	00 c0                	add    %al,%al
	...
  281e5b:	00 e0                	add    %ah,%al
  281e5d:	0d f8 0f 18 0e       	or     $0xe180ff8,%eax
  281e62:	0c 0c                	or     $0xc,%al
  281e64:	0c 0c                	or     $0xc,%al
  281e66:	0c 0c                	or     $0xc,%al
  281e68:	0c 0c                	or     $0xc,%al
  281e6a:	0c 0c                	or     $0xc,%al
  281e6c:	0c 0c                	or     $0xc,%al
  281e6e:	18 0e                	sbb    %cl,(%esi)
  281e70:	f8                   	clc    
  281e71:	0f e0 0d 00 0c 0c 0c 	pavgb  0xc0c0c00,%mm1
  281e78:	1c 06                	sbb    $0x6,%al
  281e7a:	f8                   	clc    
  281e7b:	07                   	pop    %es
  281e7c:	f0 01 00             	lock add %eax,(%eax)
  281e7f:	00 00                	add    %al,(%eax)
  281e81:	00 18                	add    %bl,(%eax)
  281e83:	00 18                	add    %bl,(%eax)
  281e85:	00 18                	add    %bl,(%eax)
  281e87:	00 18                	add    %bl,(%eax)
  281e89:	00 18                	add    %bl,(%eax)
  281e8b:	00 d8                	add    %bl,%al
  281e8d:	07                   	pop    %es
  281e8e:	f8                   	clc    
  281e8f:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281e93:	18 18                	sbb    %bl,(%eax)
  281e95:	18 18                	sbb    %bl,(%eax)
  281e97:	18 18                	sbb    %bl,(%eax)
  281e99:	18 18                	sbb    %bl,(%eax)
  281e9b:	18 18                	sbb    %bl,(%eax)
  281e9d:	18 18                	sbb    %bl,(%eax)
  281e9f:	18 18                	sbb    %bl,(%eax)
  281ea1:	18 18                	sbb    %bl,(%eax)
  281ea3:	18 00                	sbb    %al,(%eax)
	...
  281eb1:	00 c0                	add    %al,%al
  281eb3:	00 c0                	add    %al,%al
  281eb5:	00 00                	add    %al,(%eax)
  281eb7:	00 00                	add    %al,(%eax)
  281eb9:	00 00                	add    %al,(%eax)
  281ebb:	00 c0                	add    %al,%al
  281ebd:	00 c0                	add    %al,%al
  281ebf:	00 c0                	add    %al,%al
  281ec1:	00 c0                	add    %al,%al
  281ec3:	00 c0                	add    %al,%al
  281ec5:	00 c0                	add    %al,%al
  281ec7:	00 c0                	add    %al,%al
  281ec9:	00 c0                	add    %al,%al
  281ecb:	00 c0                	add    %al,%al
  281ecd:	00 c0                	add    %al,%al
  281ecf:	00 c0                	add    %al,%al
  281ed1:	00 c0                	add    %al,%al
	...
  281edf:	00 00                	add    %al,(%eax)
  281ee1:	00 c0                	add    %al,%al
  281ee3:	00 c0                	add    %al,%al
  281ee5:	00 00                	add    %al,(%eax)
  281ee7:	00 00                	add    %al,(%eax)
  281ee9:	00 00                	add    %al,(%eax)
  281eeb:	00 c0                	add    %al,%al
  281eed:	00 c0                	add    %al,%al
  281eef:	00 c0                	add    %al,%al
  281ef1:	00 c0                	add    %al,%al
  281ef3:	00 c0                	add    %al,%al
  281ef5:	00 c0                	add    %al,%al
  281ef7:	00 c0                	add    %al,%al
  281ef9:	00 c0                	add    %al,%al
  281efb:	00 c0                	add    %al,%al
  281efd:	00 c0                	add    %al,%al
  281eff:	00 c0                	add    %al,%al
  281f01:	00 c0                	add    %al,%al
  281f03:	00 c0                	add    %al,%al
  281f05:	00 c0                	add    %al,%al
  281f07:	00 c0                	add    %al,%al
  281f09:	00 f8                	add    %bh,%al
  281f0b:	00 78 00             	add    %bh,0x0(%eax)
  281f0e:	00 00                	add    %al,(%eax)
  281f10:	00 00                	add    %al,(%eax)
  281f12:	0c 00                	or     $0x0,%al
  281f14:	0c 00                	or     $0x0,%al
  281f16:	0c 00                	or     $0x0,%al
  281f18:	0c 00                	or     $0x0,%al
  281f1a:	0c 00                	or     $0x0,%al
  281f1c:	0c 0c                	or     $0xc,%al
  281f1e:	0c 06                	or     $0x6,%al
  281f20:	0c 03                	or     $0x3,%al
  281f22:	8c 01                	mov    %es,(%ecx)
  281f24:	cc                   	int3   
  281f25:	00 6c 00 fc          	add    %ch,-0x4(%eax,%eax,1)
  281f29:	00 9c 01 8c 03 0c 03 	add    %bl,0x30c038c(%ecx,%eax,1)
  281f30:	0c 06                	or     $0x6,%al
  281f32:	0c 0c                	or     $0xc,%al
	...
  281f40:	00 00                	add    %al,(%eax)
  281f42:	c0 00 c0             	rolb   $0xc0,(%eax)
  281f45:	00 c0                	add    %al,%al
  281f47:	00 c0                	add    %al,%al
  281f49:	00 c0                	add    %al,%al
  281f4b:	00 c0                	add    %al,%al
  281f4d:	00 c0                	add    %al,%al
  281f4f:	00 c0                	add    %al,%al
  281f51:	00 c0                	add    %al,%al
  281f53:	00 c0                	add    %al,%al
  281f55:	00 c0                	add    %al,%al
  281f57:	00 c0                	add    %al,%al
  281f59:	00 c0                	add    %al,%al
  281f5b:	00 c0                	add    %al,%al
  281f5d:	00 c0                	add    %al,%al
  281f5f:	00 c0                	add    %al,%al
  281f61:	00 c0                	add    %al,%al
	...
  281f7b:	00 7c 3c ff          	add    %bh,-0x1(%esp,%edi,1)
  281f7f:	7e c7                	jle    281f48 <ASCII_Table+0xe48>
  281f81:	e3 83                	jecxz  281f06 <ASCII_Table+0xe06>
  281f83:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
  281f8a:	83 c1 83             	add    $0xffffff83,%ecx
  281f8d:	c1 83 c1 83 c1 83 c1 	roll   $0xc1,-0x7c3e7c3f(%ebx)
	...
  281fac:	98                   	cwtl   
  281fad:	07                   	pop    %es
  281fae:	f8                   	clc    
  281faf:	0f 38 1c 18          	pabsb  (%eax),%mm3
  281fb3:	18 18                	sbb    %bl,(%eax)
  281fb5:	18 18                	sbb    %bl,(%eax)
  281fb7:	18 18                	sbb    %bl,(%eax)
  281fb9:	18 18                	sbb    %bl,(%eax)
  281fbb:	18 18                	sbb    %bl,(%eax)
  281fbd:	18 18                	sbb    %bl,(%eax)
  281fbf:	18 18                	sbb    %bl,(%eax)
  281fc1:	18 18                	sbb    %bl,(%eax)
  281fc3:	18 00                	sbb    %al,(%eax)
	...
  281fd9:	00 00                	add    %al,(%eax)
  281fdb:	00 c0                	add    %al,%al
  281fdd:	03 f0                	add    %eax,%esi
  281fdf:	0f 30                	wrmsr  
  281fe1:	0c 18                	or     $0x18,%al
  281fe3:	18 18                	sbb    %bl,(%eax)
  281fe5:	18 18                	sbb    %bl,(%eax)
  281fe7:	18 18                	sbb    %bl,(%eax)
  281fe9:	18 18                	sbb    %bl,(%eax)
  281feb:	18 18                	sbb    %bl,(%eax)
  281fed:	18 30                	sbb    %dh,(%eax)
  281fef:	0c f0                	or     $0xf0,%al
  281ff1:	0f c0 03             	xadd   %al,(%ebx)
	...
  28200c:	d8 03                	fadds  (%ebx)
  28200e:	f8                   	clc    
  28200f:	0f 38 0c             	(bad)  
  282012:	18 18                	sbb    %bl,(%eax)
  282014:	18 18                	sbb    %bl,(%eax)
  282016:	18 18                	sbb    %bl,(%eax)
  282018:	18 18                	sbb    %bl,(%eax)
  28201a:	18 18                	sbb    %bl,(%eax)
  28201c:	18 18                	sbb    %bl,(%eax)
  28201e:	38 0c f8             	cmp    %cl,(%eax,%edi,8)
  282021:	0f d8 03             	psubusb (%ebx),%mm0
  282024:	18 00                	sbb    %al,(%eax)
  282026:	18 00                	sbb    %al,(%eax)
  282028:	18 00                	sbb    %al,(%eax)
  28202a:	18 00                	sbb    %al,(%eax)
  28202c:	18 00                	sbb    %al,(%eax)
	...
  28203a:	00 00                	add    %al,(%eax)
  28203c:	c0 1b f0             	rcrb   $0xf0,(%ebx)
  28203f:	1f                   	pop    %ds
  282040:	30 1c 18             	xor    %bl,(%eax,%ebx,1)
  282043:	18 18                	sbb    %bl,(%eax)
  282045:	18 18                	sbb    %bl,(%eax)
  282047:	18 18                	sbb    %bl,(%eax)
  282049:	18 18                	sbb    %bl,(%eax)
  28204b:	18 18                	sbb    %bl,(%eax)
  28204d:	18 30                	sbb    %dh,(%eax)
  28204f:	1c f0                	sbb    $0xf0,%al
  282051:	1f                   	pop    %ds
  282052:	c0 1b 00             	rcrb   $0x0,(%ebx)
  282055:	18 00                	sbb    %al,(%eax)
  282057:	18 00                	sbb    %al,(%eax)
  282059:	18 00                	sbb    %al,(%eax)
  28205b:	18 00                	sbb    %al,(%eax)
  28205d:	18 00                	sbb    %al,(%eax)
	...
  28206b:	00 b0 07 f0 03 70    	add    %dh,0x7003f007(%eax)
  282071:	00 30                	add    %dh,(%eax)
  282073:	00 30                	add    %dh,(%eax)
  282075:	00 30                	add    %dh,(%eax)
  282077:	00 30                	add    %dh,(%eax)
  282079:	00 30                	add    %dh,(%eax)
  28207b:	00 30                	add    %dh,(%eax)
  28207d:	00 30                	add    %dh,(%eax)
  28207f:	00 30                	add    %dh,(%eax)
  282081:	00 30                	add    %dh,(%eax)
	...
  28209b:	00 e0                	add    %ah,%al
  28209d:	03 f0                	add    %eax,%esi
  28209f:	03 38                	add    (%eax),%edi
  2820a1:	0e                   	push   %cs
  2820a2:	18 0c 38             	sbb    %cl,(%eax,%edi,1)
  2820a5:	00 f0                	add    %dh,%al
  2820a7:	03 c0                	add    %eax,%eax
  2820a9:	07                   	pop    %es
  2820aa:	00 0c 18             	add    %cl,(%eax,%ebx,1)
  2820ad:	0c 38                	or     $0x38,%al
  2820af:	0e                   	push   %cs
  2820b0:	f0 07                	lock pop %es
  2820b2:	e0 03                	loopne 2820b7 <ASCII_Table+0xfb7>
	...
  2820c4:	80 00 c0             	addb   $0xc0,(%eax)
  2820c7:	00 c0                	add    %al,%al
  2820c9:	00 c0                	add    %al,%al
  2820cb:	00 f0                	add    %dh,%al
  2820cd:	07                   	pop    %es
  2820ce:	f0 07                	lock pop %es
  2820d0:	c0 00 c0             	rolb   $0xc0,(%eax)
  2820d3:	00 c0                	add    %al,%al
  2820d5:	00 c0                	add    %al,%al
  2820d7:	00 c0                	add    %al,%al
  2820d9:	00 c0                	add    %al,%al
  2820db:	00 c0                	add    %al,%al
  2820dd:	00 c0                	add    %al,%al
  2820df:	00 c0                	add    %al,%al
  2820e1:	07                   	pop    %es
  2820e2:	80 07 00             	addb   $0x0,(%edi)
	...
  2820f9:	00 00                	add    %al,(%eax)
  2820fb:	00 18                	add    %bl,(%eax)
  2820fd:	18 18                	sbb    %bl,(%eax)
  2820ff:	18 18                	sbb    %bl,(%eax)
  282101:	18 18                	sbb    %bl,(%eax)
  282103:	18 18                	sbb    %bl,(%eax)
  282105:	18 18                	sbb    %bl,(%eax)
  282107:	18 18                	sbb    %bl,(%eax)
  282109:	18 18                	sbb    %bl,(%eax)
  28210b:	18 18                	sbb    %bl,(%eax)
  28210d:	18 38                	sbb    %bh,(%eax)
  28210f:	1c f0                	sbb    $0xf0,%al
  282111:	1f                   	pop    %ds
  282112:	e0 19                	loopne 28212d <ASCII_Table+0x102d>
	...
  28212c:	0c 18                	or     $0x18,%al
  28212e:	18 0c 18             	sbb    %cl,(%eax,%ebx,1)
  282131:	0c 18                	or     $0x18,%al
  282133:	0c 30                	or     $0x30,%al
  282135:	06                   	push   %es
  282136:	30 06                	xor    %al,(%esi)
  282138:	30 06                	xor    %al,(%esi)
  28213a:	60                   	pusha  
  28213b:	03 60 03             	add    0x3(%eax),%esp
  28213e:	60                   	pusha  
  28213f:	03 c0                	add    %eax,%eax
  282141:	01 c0                	add    %eax,%eax
  282143:	01 00                	add    %eax,(%eax)
	...
  282159:	00 00                	add    %al,(%eax)
  28215b:	00 c1                	add    %al,%cl
  28215d:	41                   	inc    %ecx
  28215e:	c1 41 c3 61          	roll   $0x61,-0x3d(%ecx)
  282162:	63 63 63             	arpl   %sp,0x63(%ebx)
  282165:	63 63 63             	arpl   %sp,0x63(%ebx)
  282168:	36                   	ss
  282169:	36                   	ss
  28216a:	36                   	ss
  28216b:	36                   	ss
  28216c:	36                   	ss
  28216d:	36                   	ss
  28216e:	1c 1c                	sbb    $0x1c,%al
  282170:	1c 1c                	sbb    $0x1c,%al
  282172:	1c 1c                	sbb    $0x1c,%al
	...
  28218c:	1c 38                	sbb    $0x38,%al
  28218e:	38 1c 30             	cmp    %bl,(%eax,%esi,1)
  282191:	0c 60                	or     $0x60,%al
  282193:	06                   	push   %es
  282194:	60                   	pusha  
  282195:	03 60 03             	add    0x3(%eax),%esp
  282198:	60                   	pusha  
  282199:	03 60 03             	add    0x3(%eax),%esp
  28219c:	60                   	pusha  
  28219d:	06                   	push   %es
  28219e:	30 0c 38             	xor    %cl,(%eax,%edi,1)
  2821a1:	1c 1c                	sbb    $0x1c,%al
  2821a3:	38 00                	cmp    %al,(%eax)
	...
  2821b9:	00 00                	add    %al,(%eax)
  2821bb:	00 18                	add    %bl,(%eax)
  2821bd:	30 30                	xor    %dh,(%eax)
  2821bf:	18 30                	sbb    %dh,(%eax)
  2821c1:	18 70 18             	sbb    %dh,0x18(%eax)
  2821c4:	60                   	pusha  
  2821c5:	0c 60                	or     $0x60,%al
  2821c7:	0c e0                	or     $0xe0,%al
  2821c9:	0c c0                	or     $0xc0,%al
  2821cb:	06                   	push   %es
  2821cc:	c0 06 80             	rolb   $0x80,(%esi)
  2821cf:	03 80 03 80 03 80    	add    -0x7ffc7ffd(%eax),%eax
  2821d5:	01 80 01 c0 01 f0    	add    %eax,-0xffe3fff(%eax)
  2821db:	00 70 00             	add    %dh,0x0(%eax)
	...
  2821ea:	00 00                	add    %al,(%eax)
  2821ec:	fc                   	cld    
  2821ed:	1f                   	pop    %ds
  2821ee:	fc                   	cld    
  2821ef:	1f                   	pop    %ds
  2821f0:	00 0c 00             	add    %cl,(%eax,%eax,1)
  2821f3:	06                   	push   %es
  2821f4:	00 03                	add    %al,(%ebx)
  2821f6:	80 01 c0             	addb   $0xc0,(%ecx)
  2821f9:	00 60 00             	add    %ah,0x0(%eax)
  2821fc:	30 00                	xor    %al,(%eax)
  2821fe:	18 00                	sbb    %al,(%eax)
  282200:	fc                   	cld    
  282201:	1f                   	pop    %ds
  282202:	fc                   	cld    
  282203:	1f                   	pop    %ds
	...
  282210:	00 00                	add    %al,(%eax)
  282212:	00 03                	add    %al,(%ebx)
  282214:	80 01 c0             	addb   $0xc0,(%ecx)
  282217:	00 c0                	add    %al,%al
  282219:	00 c0                	add    %al,%al
  28221b:	00 c0                	add    %al,%al
  28221d:	00 c0                	add    %al,%al
  28221f:	00 c0                	add    %al,%al
  282221:	00 60 00             	add    %ah,0x0(%eax)
  282224:	60                   	pusha  
  282225:	00 30                	add    %dh,(%eax)
  282227:	00 60 00             	add    %ah,0x0(%eax)
  28222a:	40                   	inc    %eax
  28222b:	00 c0                	add    %al,%al
  28222d:	00 c0                	add    %al,%al
  28222f:	00 c0                	add    %al,%al
  282231:	00 c0                	add    %al,%al
  282233:	00 c0                	add    %al,%al
  282235:	00 c0                	add    %al,%al
  282237:	00 80 01 00 03 00    	add    %al,0x30001(%eax)
  28223d:	00 00                	add    %al,(%eax)
  28223f:	00 00                	add    %al,(%eax)
  282241:	00 80 01 80 01 80    	add    %al,-0x7ffe7fff(%eax)
  282247:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28224d:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282253:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282259:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28225f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282265:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28226b:	01 80 01 00 00 00    	add    %eax,0x1(%eax)
  282271:	00 60 00             	add    %ah,0x0(%eax)
  282274:	c0 00 c0             	rolb   $0xc0,(%eax)
  282277:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  28227d:	01 80 01 80 01 00    	add    %eax,0x18001(%eax)
  282283:	03 00                	add    (%eax),%eax
  282285:	03 00                	add    (%eax),%eax
  282287:	06                   	push   %es
  282288:	00 03                	add    %al,(%ebx)
  28228a:	00 01                	add    %al,(%ecx)
  28228c:	80 01 80             	addb   $0x80,(%ecx)
  28228f:	01 80 01 80 01 80    	add    %eax,-0x7ffe7fff(%eax)
  282295:	01 80 01 c0 00 60    	add    %eax,0x6000c001(%eax)
	...
  2822af:	00 f0                	add    %dh,%al
  2822b1:	10 f8                	adc    %bh,%al
  2822b3:	1f                   	pop    %ds
  2822b4:	08 0f                	or     %cl,(%edi)
	...
  2822d2:	00 ff                	add    %bh,%bh
  2822d4:	00 00                	add    %al,(%eax)
  2822d6:	00 ff                	add    %bh,%bh
  2822d8:	00 ff                	add    %bh,%bh
  2822da:	ff 00                	incl   (%eax)
  2822dc:	00 00                	add    %al,(%eax)
  2822de:	ff                   	(bad)  
  2822df:	ff 00                	incl   (%eax)
  2822e1:	ff 00                	incl   (%eax)
  2822e3:	ff                   	(bad)  
  2822e4:	ff                   	(bad)  
  2822e5:	ff                   	(bad)  
  2822e6:	ff                   	(bad)  
  2822e7:	ff c6                	inc    %esi
  2822e9:	c6 c6 84             	mov    $0x84,%dh
  2822ec:	00 00                	add    %al,(%eax)
  2822ee:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
  2822f5:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
  2822fc:	84 84 84 84 2a 2a 2a 	test   %al,0x2a2a2a84(%esp,%eax,4)

00282300 <cursor.1329>:
  282300:	2a 2a                	sub    (%edx),%ch
  282302:	2a 2a                	sub    (%edx),%ch
  282304:	2a 2a                	sub    (%edx),%ch
  282306:	2a 2a                	sub    (%edx),%ch
  282308:	2a 2a                	sub    (%edx),%ch
  28230a:	2a 2a                	sub    (%edx),%ch
  28230c:	2a 2a                	sub    (%edx),%ch
  28230e:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282313:	4f                   	dec    %edi
  282314:	4f                   	dec    %edi
  282315:	4f                   	dec    %edi
  282316:	4f                   	dec    %edi
  282317:	4f                   	dec    %edi
  282318:	4f                   	dec    %edi
  282319:	4f                   	dec    %edi
  28231a:	4f                   	dec    %edi
  28231b:	4f                   	dec    %edi
  28231c:	2a 2e                	sub    (%esi),%ch
  28231e:	2e 2e 2a 4f 4f       	cs sub %cs:0x4f(%edi),%cl
  282323:	4f                   	dec    %edi
  282324:	4f                   	dec    %edi
  282325:	4f                   	dec    %edi
  282326:	4f                   	dec    %edi
  282327:	4f                   	dec    %edi
  282328:	4f                   	dec    %edi
  282329:	4f                   	dec    %edi
  28232a:	4f                   	dec    %edi
  28232b:	2a 2e                	sub    (%esi),%ch
  28232d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  282333:	4f                   	dec    %edi
  282334:	4f                   	dec    %edi
  282335:	4f                   	dec    %edi
  282336:	4f                   	dec    %edi
  282337:	4f                   	dec    %edi
  282338:	4f                   	dec    %edi
  282339:	4f                   	dec    %edi
  28233a:	2a 2e                	sub    (%esi),%ch
  28233c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282343:	4f                   	dec    %edi
  282344:	4f                   	dec    %edi
  282345:	4f                   	dec    %edi
  282346:	4f                   	dec    %edi
  282347:	4f                   	dec    %edi
  282348:	4f                   	dec    %edi
  282349:	2a 2e                	sub    (%esi),%ch
  28234b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282352:	4f 
  282353:	4f                   	dec    %edi
  282354:	4f                   	dec    %edi
  282355:	4f                   	dec    %edi
  282356:	4f                   	dec    %edi
  282357:	4f                   	dec    %edi
  282358:	2a 2e                	sub    (%esi),%ch
  28235a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282361:	4f 4f 
  282363:	4f                   	dec    %edi
  282364:	4f                   	dec    %edi
  282365:	4f                   	dec    %edi
  282366:	4f                   	dec    %edi
  282367:	4f                   	dec    %edi
  282368:	2a 2e                	sub    (%esi),%ch
  28236a:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  282371:	4f 4f 
  282373:	4f                   	dec    %edi
  282374:	4f                   	dec    %edi
  282375:	4f                   	dec    %edi
  282376:	4f                   	dec    %edi
  282377:	4f                   	dec    %edi
  282378:	4f                   	dec    %edi
  282379:	2a 2e                	sub    (%esi),%ch
  28237b:	2e 2e 2e 2e 2e 2a 4f 	cs cs cs cs sub %cs:0x4f(%edi),%cl
  282382:	4f 
  282383:	4f                   	dec    %edi
  282384:	4f                   	dec    %edi
  282385:	2a 2a                	sub    (%edx),%ch
  282387:	4f                   	dec    %edi
  282388:	4f                   	dec    %edi
  282389:	4f                   	dec    %edi
  28238a:	2a 2e                	sub    (%esi),%ch
  28238c:	2e 2e 2e 2e 2a 4f 4f 	cs cs cs sub %cs:0x4f(%edi),%cl
  282393:	4f                   	dec    %edi
  282394:	2a 2e                	sub    (%esi),%ch
  282396:	2e 2a 4f 4f          	sub    %cs:0x4f(%edi),%cl
  28239a:	4f                   	dec    %edi
  28239b:	2a 2e                	sub    (%esi),%ch
  28239d:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  2823a3:	2a 2e                	sub    (%esi),%ch
  2823a5:	2e 2e 2e 2a 4f 4f    	cs cs sub %cs:0x4f(%edi),%cl
  2823ab:	4f                   	dec    %edi
  2823ac:	2a 2e                	sub    (%esi),%ch
  2823ae:	2e 2e 2a 4f 2a       	cs sub %cs:0x2a(%edi),%cl
  2823b3:	2e 2e 2e 2e 2e 2e 2a 	cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823ba:	4f 4f 
  2823bc:	4f                   	dec    %edi
  2823bd:	2a 2e                	sub    (%esi),%ch
  2823bf:	2e 2a 2a             	sub    %cs:(%edx),%ch
  2823c2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823c9:	2e 2a 4f 4f 
  2823cd:	4f                   	dec    %edi
  2823ce:	2a 2e                	sub    (%esi),%ch
  2823d0:	2a 2e                	sub    (%esi),%ch
  2823d2:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823d9:	2e 2e 2a 4f 4f 
  2823de:	4f                   	dec    %edi
  2823df:	2a 2e                	sub    (%esi),%ch
  2823e1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs sub %cs:0x4f(%edi),%cl
  2823e8:	2e 2e 2e 2e 2a 4f 4f 
  2823ef:	2a 2e                	sub    (%esi),%ch
  2823f1:	2e 2e 2e 2e 2e 2e 2e 	cs cs cs cs cs cs cs cs cs cs cs sub %cs:(%edx),%ch
  2823f8:	2e 2e 2e 2e 2e 2a 2a 
  2823ff:	2a                   	.byte 0x2a

Disassembly of section .eh_frame:

00282400 <.eh_frame>:
  282400:	14 00                	adc    $0x0,%al
  282402:	00 00                	add    %al,(%eax)
  282404:	00 00                	add    %al,(%eax)
  282406:	00 00                	add    %al,(%eax)
  282408:	01 7a 52             	add    %edi,0x52(%edx)
  28240b:	00 01                	add    %al,(%ecx)
  28240d:	7c 08                	jl     282417 <cursor.1329+0x117>
  28240f:	01 1b                	add    %ebx,(%ebx)
  282411:	0c 04                	or     $0x4,%al
  282413:	04 88                	add    $0x88,%al
  282415:	01 00                	add    %eax,(%eax)
  282417:	00 18                	add    %bl,(%eax)
  282419:	00 00                	add    %al,(%eax)
  28241b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28241e:	00 00                	add    %al,(%eax)
  282420:	e0 db                	loopne 2823fd <cursor.1329+0xfd>
  282422:	ff                   	(bad)  
  282423:	ff a0 00 00 00 00    	jmp    *0x0(%eax)
  282429:	41                   	inc    %ecx
  28242a:	0e                   	push   %cs
  28242b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282431:	47                   	inc    %edi
  282432:	83 03 1c             	addl   $0x1c,(%ebx)
  282435:	00 00                	add    %al,(%eax)
  282437:	00 38                	add    %bh,(%eax)
  282439:	00 00                	add    %al,(%eax)
  28243b:	00 64 dc ff          	add    %ah,-0x1(%esp,%ebx,8)
  28243f:	ff 17                	call   *(%edi)
  282441:	00 00                	add    %al,(%eax)
  282443:	00 00                	add    %al,(%eax)
  282445:	41                   	inc    %ecx
  282446:	0e                   	push   %cs
  282447:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  28244d:	4e                   	dec    %esi
  28244e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282451:	04 00                	add    $0x0,%al
  282453:	00 1c 00             	add    %bl,(%eax,%eax,1)
  282456:	00 00                	add    %al,(%eax)
  282458:	58                   	pop    %eax
  282459:	00 00                	add    %al,(%eax)
  28245b:	00 5b dc             	add    %bl,-0x24(%ebx)
  28245e:	ff                   	(bad)  
  28245f:	ff 14 00             	call   *(%eax,%eax,1)
  282462:	00 00                	add    %al,(%eax)
  282464:	00 41 0e             	add    %al,0xe(%ecx)
  282467:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  28246d:	4b                   	dec    %ebx
  28246e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282471:	04 00                	add    $0x0,%al
  282473:	00 24 00             	add    %ah,(%eax,%eax,1)
  282476:	00 00                	add    %al,(%eax)
  282478:	78 00                	js     28247a <cursor.1329+0x17a>
  28247a:	00 00                	add    %al,(%eax)
  28247c:	4f                   	dec    %edi
  28247d:	dc ff                	fdivr  %st,%st(7)
  28247f:	ff                   	(bad)  
  282480:	3e 00 00             	add    %al,%ds:(%eax)
  282483:	00 00                	add    %al,(%eax)
  282485:	41                   	inc    %ecx
  282486:	0e                   	push   %cs
  282487:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  28248d:	45                   	inc    %ebp
  28248e:	86 03                	xchg   %al,(%ebx)
  282490:	83 04 73 c3          	addl   $0xffffffc3,(%ebx,%esi,2)
  282494:	41                   	inc    %ecx
  282495:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282499:	04 04                	add    $0x4,%al
  28249b:	00 24 00             	add    %ah,(%eax,%eax,1)
  28249e:	00 00                	add    %al,(%eax)
  2824a0:	a0 00 00 00 65       	mov    0x65000000,%al
  2824a5:	dc ff                	fdivr  %st,%st(7)
  2824a7:	ff 31                	pushl  (%ecx)
  2824a9:	00 00                	add    %al,(%eax)
  2824ab:	00 00                	add    %al,(%eax)
  2824ad:	41                   	inc    %ecx
  2824ae:	0e                   	push   %cs
  2824af:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2824b5:	42                   	inc    %edx
  2824b6:	87 03                	xchg   %eax,(%ebx)
  2824b8:	86 04 64             	xchg   %al,(%esp,%eiz,2)
  2824bb:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2824bf:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2824c2:	04 00                	add    $0x0,%al
  2824c4:	20 00                	and    %al,(%eax)
  2824c6:	00 00                	add    %al,(%eax)
  2824c8:	c8 00 00 00          	enter  $0x0,$0x0
  2824cc:	6e                   	outsb  %ds:(%esi),(%dx)
  2824cd:	dc ff                	fdivr  %st,%st(7)
  2824cf:	ff 2f                	ljmp   *(%edi)
  2824d1:	00 00                	add    %al,(%eax)
  2824d3:	00 00                	add    %al,(%eax)
  2824d5:	41                   	inc    %ecx
  2824d6:	0e                   	push   %cs
  2824d7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2824dd:	47                   	inc    %edi
  2824de:	83 03 63             	addl   $0x63,(%ebx)
  2824e1:	c3                   	ret    
  2824e2:	41                   	inc    %ecx
  2824e3:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2824e6:	04 00                	add    $0x0,%al
  2824e8:	1c 00                	sbb    $0x0,%al
  2824ea:	00 00                	add    %al,(%eax)
  2824ec:	ec                   	in     (%dx),%al
  2824ed:	00 00                	add    %al,(%eax)
  2824ef:	00 79 dc             	add    %bh,-0x24(%ecx)
  2824f2:	ff                   	(bad)  
  2824f3:	ff 28                	ljmp   *(%eax)
  2824f5:	00 00                	add    %al,(%eax)
  2824f7:	00 00                	add    %al,(%eax)
  2824f9:	41                   	inc    %ecx
  2824fa:	0e                   	push   %cs
  2824fb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282501:	64 c5 0c 04          	lds    %fs:(%esp,%eax,1),%ecx
  282505:	04 00                	add    $0x0,%al
  282507:	00 1c 00             	add    %bl,(%eax,%eax,1)
  28250a:	00 00                	add    %al,(%eax)
  28250c:	0c 01                	or     $0x1,%al
  28250e:	00 00                	add    %al,(%eax)
  282510:	81 dc ff ff 61 01    	sbb    $0x161ffff,%esp
  282516:	00 00                	add    %al,(%eax)
  282518:	00 41 0e             	add    %al,0xe(%ecx)
  28251b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282521:	03 5d 01             	add    0x1(%ebp),%ebx
  282524:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282527:	04 1c                	add    $0x1c,%al
  282529:	00 00                	add    %al,(%eax)
  28252b:	00 2c 01             	add    %ch,(%ecx,%eax,1)
  28252e:	00 00                	add    %al,(%eax)
  282530:	c2 dd ff             	ret    $0xffdd
  282533:	ff 1f                	lcall  *(%edi)
  282535:	00 00                	add    %al,(%eax)
  282537:	00 00                	add    %al,(%eax)
  282539:	41                   	inc    %ecx
  28253a:	0e                   	push   %cs
  28253b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282541:	5b                   	pop    %ebx
  282542:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282545:	04 00                	add    $0x0,%al
  282547:	00 24 00             	add    %ah,(%eax,%eax,1)
  28254a:	00 00                	add    %al,(%eax)
  28254c:	4c                   	dec    %esp
  28254d:	01 00                	add    %eax,(%eax)
  28254f:	00 c1                	add    %al,%cl
  282551:	dd ff                	(bad)  
  282553:	ff 50 00             	call   *0x0(%eax)
  282556:	00 00                	add    %al,(%eax)
  282558:	00 41 0e             	add    %al,0xe(%ecx)
  28255b:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282561:	48                   	dec    %eax
  282562:	86 03                	xchg   %al,(%ebx)
  282564:	83 04 02 40          	addl   $0x40,(%edx,%eax,1)
  282568:	c3                   	ret    
  282569:	41                   	inc    %ecx
  28256a:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  28256e:	04 04                	add    $0x4,%al
  282570:	24 00                	and    $0x0,%al
  282572:	00 00                	add    %al,(%eax)
  282574:	74 01                	je     282577 <cursor.1329+0x277>
  282576:	00 00                	add    %al,(%eax)
  282578:	e9 dd ff ff 39       	jmp    3a28255a <cursor.1329+0x3a00025a>
  28257d:	00 00                	add    %al,(%eax)
  28257f:	00 00                	add    %al,(%eax)
  282581:	41                   	inc    %ecx
  282582:	0e                   	push   %cs
  282583:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282589:	44                   	inc    %esp
  28258a:	86 03                	xchg   %al,(%ebx)
  28258c:	43                   	inc    %ebx
  28258d:	83 04 6c c3          	addl   $0xffffffc3,(%esp,%ebp,2)
  282591:	41                   	inc    %ecx
  282592:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
  282596:	04 04                	add    $0x4,%al
  282598:	28 00                	sub    %al,(%eax)
  28259a:	00 00                	add    %al,(%eax)
  28259c:	9c                   	pushf  
  28259d:	01 00                	add    %eax,(%eax)
  28259f:	00 fa                	add    %bh,%dl
  2825a1:	dd ff                	(bad)  
  2825a3:	ff 62 00             	jmp    *0x0(%edx)
  2825a6:	00 00                	add    %al,(%eax)
  2825a8:	00 41 0e             	add    %al,0xe(%ecx)
  2825ab:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2825b1:	4b                   	dec    %ebx
  2825b2:	87 03                	xchg   %eax,(%ebx)
  2825b4:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2825b7:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  2825bc:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2825c0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2825c3:	04 28                	add    $0x28,%al
  2825c5:	00 00                	add    %al,(%eax)
  2825c7:	00 c8                	add    %cl,%al
  2825c9:	01 00                	add    %eax,(%eax)
  2825cb:	00 30                	add    %dh,(%eax)
  2825cd:	de ff                	fdivrp %st,%st(7)
  2825cf:	ff 62 00             	jmp    *0x0(%edx)
  2825d2:	00 00                	add    %al,(%eax)
  2825d4:	00 41 0e             	add    %al,0xe(%ecx)
  2825d7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2825dd:	4b                   	dec    %ebx
  2825de:	87 03                	xchg   %eax,(%ebx)
  2825e0:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2825e3:	05 02 4e c3 41       	add    $0x41c34e02,%eax
  2825e8:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2825ec:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2825ef:	04 28                	add    $0x28,%al
  2825f1:	00 00                	add    %al,(%eax)
  2825f3:	00 f4                	add    %dh,%ah
  2825f5:	01 00                	add    %eax,(%eax)
  2825f7:	00 66 de             	add    %ah,-0x22(%esi)
  2825fa:	ff                   	(bad)  
  2825fb:	ff aa 00 00 00 00    	ljmp   *0x0(%edx)
  282601:	41                   	inc    %ecx
  282602:	0e                   	push   %cs
  282603:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282609:	46                   	inc    %esi
  28260a:	87 03                	xchg   %eax,(%ebx)
  28260c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28260f:	05 02 9d c3 41       	add    $0x41c39d02,%eax
  282614:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282618:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  28261b:	04 28                	add    $0x28,%al
  28261d:	00 00                	add    %al,(%eax)
  28261f:	00 20                	add    %ah,(%eax)
  282621:	02 00                	add    (%eax),%al
  282623:	00 e4                	add    %ah,%ah
  282625:	de ff                	fdivrp %st,%st(7)
  282627:	ff 51 00             	call   *0x0(%ecx)
  28262a:	00 00                	add    %al,(%eax)
  28262c:	00 41 0e             	add    %al,0xe(%ecx)
  28262f:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  282635:	41                   	inc    %ecx
  282636:	87 03                	xchg   %eax,(%ebx)
  282638:	4a                   	dec    %edx
  282639:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  28263c:	05 7d c3 41 c6       	add    $0xc641c37d,%eax
  282641:	41                   	inc    %ecx
  282642:	c7 41 c5 0c 04 04 2c 	movl   $0x2c04040c,-0x3b(%ecx)
  282649:	00 00                	add    %al,(%eax)
  28264b:	00 4c 02 00          	add    %cl,0x0(%edx,%eax,1)
  28264f:	00 09                	add    %cl,(%ecx)
  282651:	df ff                	(bad)  
  282653:	ff 64 00 00          	jmp    *0x0(%eax,%eax,1)
  282657:	00 00                	add    %al,(%eax)
  282659:	41                   	inc    %ecx
  28265a:	0e                   	push   %cs
  28265b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282661:	41                   	inc    %ecx
  282662:	87 03                	xchg   %eax,(%ebx)
  282664:	44                   	inc    %esp
  282665:	86 04 45 83 05 02 53 	xchg   %al,0x53020583(,%eax,2)
  28266c:	c3                   	ret    
  28266d:	41                   	inc    %ecx
  28266e:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  282672:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  282675:	04 00                	add    $0x0,%al
  282677:	00 20                	add    %ah,(%eax)
  282679:	00 00                	add    %al,(%eax)
  28267b:	00 7c 02 00          	add    %bh,0x0(%edx,%eax,1)
  28267f:	00 3d df ff ff 3a    	add    %bh,0x3affffdf
  282685:	00 00                	add    %al,(%eax)
  282687:	00 00                	add    %al,(%eax)
  282689:	41                   	inc    %ecx
  28268a:	0e                   	push   %cs
  28268b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282691:	44                   	inc    %esp
  282692:	83 03 72             	addl   $0x72,(%ebx)
  282695:	c5 c3 0c             	(bad)  
  282698:	04 04                	add    $0x4,%al
  28269a:	00 00                	add    %al,(%eax)
  28269c:	28 00                	sub    %al,(%eax)
  28269e:	00 00                	add    %al,(%eax)
  2826a0:	a0 02 00 00 53       	mov    0x53000002,%al
  2826a5:	df ff                	(bad)  
  2826a7:	ff 50 00             	call   *0x0(%eax)
  2826aa:	00 00                	add    %al,(%eax)
  2826ac:	00 41 0e             	add    %al,0xe(%ecx)
  2826af:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  2826b5:	44                   	inc    %esp
  2826b6:	87 03                	xchg   %eax,(%ebx)
  2826b8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  2826bb:	05 02 43 c3 41       	add    $0x41c34302,%eax
  2826c0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
  2826c4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  2826c7:	04 2c                	add    $0x2c,%al
  2826c9:	00 00                	add    %al,(%eax)
  2826cb:	00 cc                	add    %cl,%ah
  2826cd:	02 00                	add    (%eax),%al
  2826cf:	00 77 df             	add    %dh,-0x21(%edi)
  2826d2:	ff                   	(bad)  
  2826d3:	ff 4f 00             	decl   0x0(%edi)
  2826d6:	00 00                	add    %al,(%eax)
  2826d8:	00 41 0e             	add    %al,0xe(%ecx)
  2826db:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2826e1:	41                   	inc    %ecx
  2826e2:	87 03                	xchg   %eax,(%ebx)
  2826e4:	44                   	inc    %esp
  2826e5:	86 04 44             	xchg   %al,(%esp,%eax,2)
  2826e8:	83 05 7f c3 41 c6 41 	addl   $0x41,0xc641c37f
  2826ef:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  2826f6:	00 00                	add    %al,(%eax)
  2826f8:	2c 00                	sub    $0x0,%al
  2826fa:	00 00                	add    %al,(%eax)
  2826fc:	fc                   	cld    
  2826fd:	02 00                	add    (%eax),%al
  2826ff:	00 96 df ff ff 54    	add    %dl,0x54ffffdf(%esi)
  282705:	00 00                	add    %al,(%eax)
  282707:	00 00                	add    %al,(%eax)
  282709:	41                   	inc    %ecx
  28270a:	0e                   	push   %cs
  28270b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282711:	48                   	dec    %eax
  282712:	87 03                	xchg   %eax,(%ebx)
  282714:	86 04 44             	xchg   %al,(%esp,%eax,2)
  282717:	83 05 02 41 c3 41 c6 	addl   $0xffffffc6,0x41c34102
  28271e:	41                   	inc    %ecx
  28271f:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
  282726:	00 00                	add    %al,(%eax)
  282728:	1c 00                	sbb    $0x0,%al
  28272a:	00 00                	add    %al,(%eax)
  28272c:	2c 03                	sub    $0x3,%al
  28272e:	00 00                	add    %al,(%eax)
  282730:	ba df ff ff 2a       	mov    $0x2affffdf,%edx
  282735:	00 00                	add    %al,(%eax)
  282737:	00 00                	add    %al,(%eax)
  282739:	41                   	inc    %ecx
  28273a:	0e                   	push   %cs
  28273b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282741:	66 c5 0c 04          	lds    (%esp,%eax,1),%cx
  282745:	04 00                	add    $0x0,%al
  282747:	00 20                	add    %ah,(%eax)
  282749:	00 00                	add    %al,(%eax)
  28274b:	00 4c 03 00          	add    %cl,0x0(%ebx,%eax,1)
  28274f:	00 c4                	add    %al,%ah
  282751:	df ff                	(bad)  
  282753:	ff 35 01 00 00 00    	pushl  0x1
  282759:	41                   	inc    %ecx
  28275a:	0e                   	push   %cs
  28275b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  282761:	41                   	inc    %ecx
  282762:	83 03 03             	addl   $0x3,(%ebx)
  282765:	30 01                	xor    %al,(%ecx)
  282767:	c5 c3 0c             	(bad)  
  28276a:	04 04                	add    $0x4,%al
  28276c:	1c 00                	sbb    $0x0,%al
  28276e:	00 00                	add    %al,(%eax)
  282770:	70 03                	jo     282775 <cursor.1329+0x475>
  282772:	00 00                	add    %al,(%eax)
  282774:	d5 e0                	aad    $0xe0
  282776:	ff                   	(bad)  
  282777:	ff                   	(bad)  
  282778:	3a 00                	cmp    (%eax),%al
  28277a:	00 00                	add    %al,(%eax)
  28277c:	00 41 0e             	add    %al,0xe(%ecx)
  28277f:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  282785:	71 c5                	jno    28274c <cursor.1329+0x44c>
  282787:	0c 04                	or     $0x4,%al
  282789:	04 00                	add    $0x0,%al
  28278b:	00 18                	add    %bl,(%eax)
  28278d:	00 00                	add    %al,(%eax)
  28278f:	00 90 03 00 00 ef    	add    %dl,-0x10fffffd(%eax)
  282795:	e0 ff                	loopne 282796 <cursor.1329+0x496>
  282797:	ff                   	(bad)  
  282798:	3f                   	aas    
  282799:	00 00                	add    %al,(%eax)
  28279b:	00 00                	add    %al,(%eax)
  28279d:	41                   	inc    %ecx
  28279e:	0e                   	push   %cs
  28279f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2827a5:	00 00                	add    %al,(%eax)
	...

Disassembly of section .rodata.str1.1:

002827a8 <.rodata.str1.1>:
  2827a8:	44                   	inc    %esp
  2827a9:	65 62 75 67          	bound  %esi,%gs:0x67(%ebp)
  2827ad:	3a 76 61             	cmp    0x61(%esi),%dh
  2827b0:	72 3d                	jb     2827ef <cursor.1329+0x4ef>
  2827b2:	25 78 00 69 6e       	and    $0x6e690078,%eax
  2827b7:	74 20                	je     2827d9 <cursor.1329+0x4d9>
  2827b9:	32 31                	xor    (%ecx),%dh
  2827bb:	28 49 52             	sub    %cl,0x52(%ecx)
  2827be:	51                   	push   %ecx
  2827bf:	2d 31 29 3a 50       	sub    $0x503a2931,%eax
  2827c4:	53                   	push   %ebx
  2827c5:	2f                   	das    
  2827c6:	32 20                	xor    (%eax),%ah
  2827c8:	6b 65 79 62          	imul   $0x62,0x79(%ebp),%esp
  2827cc:	6f                   	outsl  %ds:(%esi),(%dx)
  2827cd:	61                   	popa   
  2827ce:	72 64                	jb     282834 <cursor.1329+0x534>
	...

Disassembly of section .stab:

00000000 <.stab>:
       0:	01 00                	add    %eax,(%eax)
       2:	00 00                	add    %al,(%eax)
       4:	00 00                	add    %al,(%eax)
       6:	ac                   	lods   %ds:(%esi),%al
       7:	02 42 0c             	add    0xc(%edx),%al
       a:	00 00                	add    %al,(%eax)
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
     227:	00 bc 05 00 00 80 00 	add    %bh,0x800000(%ebp,%eax,1)
     22e:	00 00                	add    %al,(%eax)
     230:	00 00                	add    %al,(%eax)
     232:	00 00                	add    %al,(%eax)
     234:	df 05 00 00 24 00    	fild   0x240000
     23a:	00 00                	add    %al,(%eax)
     23c:	00 00                	add    %al,(%eax)
     23e:	28 00                	sub    %al,(%eax)
     240:	00 00                	add    %al,(%eax)
     242:	00 00                	add    %al,(%eax)
     244:	44                   	inc    %esp
     245:	00 10                	add    %dl,(%eax)
	...
     24f:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     253:	00 0a                	add    %cl,(%edx)
     255:	00 00                	add    %al,(%eax)
     257:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     25d:	00 00                	add    %al,(%eax)
     25f:	00 11                	add    %dl,(%ecx)
     261:	00 28                	add    %ch,(%eax)
     263:	00 00                	add    %al,(%eax)
     265:	00 00                	add    %al,(%eax)
     267:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
     26b:	00 11                	add    %dl,(%ecx)
     26d:	00 00                	add    %al,(%eax)
     26f:	00 01                	add    %al,(%ecx)
     271:	00 00                	add    %al,(%eax)
     273:	00 84 00 00 00 12 00 	add    %al,0x120000(%eax,%eax,1)
     27a:	28 00                	sub    %al,(%eax)
     27c:	00 00                	add    %al,(%eax)
     27e:	00 00                	add    %al,(%eax)
     280:	44                   	inc    %esp
     281:	00 19                	add    %bl,(%ecx)
     283:	00 12                	add    %dl,(%edx)
     285:	00 00                	add    %al,(%eax)
     287:	00 00                	add    %al,(%eax)
     289:	00 00                	add    %al,(%eax)
     28b:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
     28f:	00 19                	add    %bl,(%ecx)
     291:	00 00                	add    %al,(%eax)
     293:	00 00                	add    %al,(%eax)
     295:	00 00                	add    %al,(%eax)
     297:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     29b:	00 1f                	add    %bl,(%edi)
     29d:	00 00                	add    %al,(%eax)
     29f:	00 00                	add    %al,(%eax)
     2a1:	00 00                	add    %al,(%eax)
     2a3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
     2a7:	00 24 00             	add    %ah,(%eax,%eax,1)
     2aa:	00 00                	add    %al,(%eax)
     2ac:	00 00                	add    %al,(%eax)
     2ae:	00 00                	add    %al,(%eax)
     2b0:	44                   	inc    %esp
     2b1:	00 1c 00             	add    %bl,(%eax,%eax,1)
     2b4:	29 00                	sub    %eax,(%eax)
     2b6:	00 00                	add    %al,(%eax)
     2b8:	00 00                	add    %al,(%eax)
     2ba:	00 00                	add    %al,(%eax)
     2bc:	44                   	inc    %esp
     2bd:	00 2e                	add    %ch,(%esi)
     2bf:	00 2e                	add    %ch,(%esi)
     2c1:	00 00                	add    %al,(%eax)
     2c3:	00 00                	add    %al,(%eax)
     2c5:	00 00                	add    %al,(%eax)
     2c7:	00 44 00 2f          	add    %al,0x2f(%eax,%eax,1)
     2cb:	00 38                	add    %bh,(%eax)
     2cd:	00 00                	add    %al,(%eax)
     2cf:	00 00                	add    %al,(%eax)
     2d1:	00 00                	add    %al,(%eax)
     2d3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
     2d7:	00 56 00             	add    %dl,0x0(%esi)
     2da:	00 00                	add    %al,(%eax)
     2dc:	00 00                	add    %al,(%eax)
     2de:	00 00                	add    %al,(%eax)
     2e0:	44                   	inc    %esp
     2e1:	00 31                	add    %dh,(%ecx)
     2e3:	00 5e 00             	add    %bl,0x0(%esi)
     2e6:	00 00                	add    %al,(%eax)
     2e8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     2e9:	02 00                	add    (%eax),%al
     2eb:	00 84 00 00 00 63 00 	add    %al,0x630000(%eax,%eax,1)
     2f2:	28 00                	sub    %al,(%eax)
     2f4:	00 00                	add    %al,(%eax)
     2f6:	00 00                	add    %al,(%eax)
     2f8:	44                   	inc    %esp
     2f9:	00 5c 00 63          	add    %bl,0x63(%eax,%eax,1)
     2fd:	00 00                	add    %al,(%eax)
     2ff:	00 01                	add    %al,(%ecx)
     301:	00 00                	add    %al,(%eax)
     303:	00 84 00 00 00 70 00 	add    %al,0x700000(%eax,%eax,1)
     30a:	28 00                	sub    %al,(%eax)
     30c:	00 00                	add    %al,(%eax)
     30e:	00 00                	add    %al,(%eax)
     310:	44                   	inc    %esp
     311:	00 3d 00 70 00 00    	add    %bh,0x7000
     317:	00 00                	add    %al,(%eax)
     319:	00 00                	add    %al,(%eax)
     31b:	00 44 00 3f          	add    %al,0x3f(%eax,%eax,1)
     31f:	00 7a 00             	add    %bh,0x0(%edx)
     322:	00 00                	add    %al,(%eax)
     324:	00 00                	add    %al,(%eax)
     326:	00 00                	add    %al,(%eax)
     328:	44                   	inc    %esp
     329:	00 40 00             	add    %al,0x0(%eax)
     32c:	89 00                	mov    %eax,(%eax)
     32e:	00 00                	add    %al,(%eax)
     330:	f0 05 00 00 80 00    	lock add $0x800000,%eax
     336:	00 00                	add    %al,(%eax)
     338:	f8                   	clc    
     339:	fe                   	(bad)  
     33a:	ff                   	(bad)  
     33b:	ff 00                	incl   (%eax)
     33d:	00 00                	add    %al,(%eax)
     33f:	00 c0                	add    %al,%al
	...
     349:	00 00                	add    %al,(%eax)
     34b:	00 e0                	add    %ah,%al
     34d:	00 00                	add    %al,(%eax)
     34f:	00 a0 00 00 00 2b    	add    %ah,0x2b000000(%eax)
     355:	06                   	push   %es
     356:	00 00                	add    %al,(%eax)
     358:	20 00                	and    %al,(%eax)
     35a:	00 00                	add    %al,(%eax)
     35c:	00 00                	add    %al,(%eax)
     35e:	00 00                	add    %al,(%eax)
     360:	55                   	push   %ebp
     361:	06                   	push   %es
     362:	00 00                	add    %al,(%eax)
     364:	20 00                	and    %al,(%eax)
	...
     36e:	00 00                	add    %al,(%eax)
     370:	64 00 00             	add    %al,%fs:(%eax)
     373:	00 a0 00 28 00 7d    	add    %ah,0x7d002800(%eax)
     379:	06                   	push   %es
     37a:	00 00                	add    %al,(%eax)
     37c:	64 00 02             	add    %al,%fs:(%edx)
     37f:	00 a0 00 28 00 08    	add    %ah,0x8002800(%eax)
     385:	00 00                	add    %al,(%eax)
     387:	00 3c 00             	add    %bh,(%eax,%eax,1)
     38a:	00 00                	add    %al,(%eax)
     38c:	00 00                	add    %al,(%eax)
     38e:	00 00                	add    %al,(%eax)
     390:	17                   	pop    %ss
     391:	00 00                	add    %al,(%eax)
     393:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     399:	00 00                	add    %al,(%eax)
     39b:	00 41 00             	add    %al,0x0(%ecx)
     39e:	00 00                	add    %al,(%eax)
     3a0:	80 00 00             	addb   $0x0,(%eax)
     3a3:	00 00                	add    %al,(%eax)
     3a5:	00 00                	add    %al,(%eax)
     3a7:	00 5b 00             	add    %bl,0x0(%ebx)
     3aa:	00 00                	add    %al,(%eax)
     3ac:	80 00 00             	addb   $0x0,(%eax)
     3af:	00 00                	add    %al,(%eax)
     3b1:	00 00                	add    %al,(%eax)
     3b3:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     3b9:	00 00                	add    %al,(%eax)
     3bb:	00 00                	add    %al,(%eax)
     3bd:	00 00                	add    %al,(%eax)
     3bf:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     3c5:	00 00                	add    %al,(%eax)
     3c7:	00 00                	add    %al,(%eax)
     3c9:	00 00                	add    %al,(%eax)
     3cb:	00 e1                	add    %ah,%cl
     3cd:	00 00                	add    %al,(%eax)
     3cf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     3d5:	00 00                	add    %al,(%eax)
     3d7:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     3da:	00 00                	add    %al,(%eax)
     3dc:	80 00 00             	addb   $0x0,(%eax)
     3df:	00 00                	add    %al,(%eax)
     3e1:	00 00                	add    %al,(%eax)
     3e3:	00 37                	add    %dh,(%edi)
     3e5:	01 00                	add    %eax,(%eax)
     3e7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     3ed:	00 00                	add    %al,(%eax)
     3ef:	00 5d 01             	add    %bl,0x1(%ebp)
     3f2:	00 00                	add    %al,(%eax)
     3f4:	80 00 00             	addb   $0x0,(%eax)
     3f7:	00 00                	add    %al,(%eax)
     3f9:	00 00                	add    %al,(%eax)
     3fb:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     401:	00 00                	add    %al,(%eax)
     403:	00 00                	add    %al,(%eax)
     405:	00 00                	add    %al,(%eax)
     407:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     40d:	00 00                	add    %al,(%eax)
     40f:	00 00                	add    %al,(%eax)
     411:	00 00                	add    %al,(%eax)
     413:	00 d2                	add    %dl,%dl
     415:	01 00                	add    %eax,(%eax)
     417:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     41d:	00 00                	add    %al,(%eax)
     41f:	00 ec                	add    %ch,%ah
     421:	01 00                	add    %eax,(%eax)
     423:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     429:	00 00                	add    %al,(%eax)
     42b:	00 07                	add    %al,(%edi)
     42d:	02 00                	add    (%eax),%al
     42f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     435:	00 00                	add    %al,(%eax)
     437:	00 28                	add    %ch,(%eax)
     439:	02 00                	add    (%eax),%al
     43b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     441:	00 00                	add    %al,(%eax)
     443:	00 47 02             	add    %al,0x2(%edi)
     446:	00 00                	add    %al,(%eax)
     448:	80 00 00             	addb   $0x0,(%eax)
     44b:	00 00                	add    %al,(%eax)
     44d:	00 00                	add    %al,(%eax)
     44f:	00 66 02             	add    %ah,0x2(%esi)
     452:	00 00                	add    %al,(%eax)
     454:	80 00 00             	addb   $0x0,(%eax)
     457:	00 00                	add    %al,(%eax)
     459:	00 00                	add    %al,(%eax)
     45b:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     461:	00 00                	add    %al,(%eax)
     463:	00 00                	add    %al,(%eax)
     465:	00 00                	add    %al,(%eax)
     467:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     46d:	00 00                	add    %al,(%eax)
     46f:	00 34 72             	add    %dh,(%edx,%esi,2)
     472:	00 00                	add    %al,(%eax)
     474:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     475:	02 00                	add    (%eax),%al
     477:	00 c2                	add    %al,%dl
     479:	00 00                	add    %al,(%eax)
     47b:	00 00                	add    %al,(%eax)
     47d:	00 00                	add    %al,(%eax)
     47f:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     485:	00 00                	add    %al,(%eax)
     487:	00 37                	add    %dh,(%edi)
     489:	53                   	push   %ebx
     48a:	00 00                	add    %al,(%eax)
     48c:	86 06                	xchg   %al,(%esi)
     48e:	00 00                	add    %al,(%eax)
     490:	24 00                	and    $0x0,%al
     492:	00 00                	add    %al,(%eax)
     494:	a0 00 28 00 9b       	mov    0x9b002800,%al
     499:	06                   	push   %es
     49a:	00 00                	add    %al,(%eax)
     49c:	a0 00 00 00 08       	mov    0x8000000,%al
     4a1:	00 00                	add    %al,(%eax)
     4a3:	00 00                	add    %al,(%eax)
     4a5:	00 00                	add    %al,(%eax)
     4a7:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
	...
     4b3:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     4b7:	00 01                	add    %al,(%ecx)
     4b9:	00 00                	add    %al,(%eax)
     4bb:	00 00                	add    %al,(%eax)
     4bd:	00 00                	add    %al,(%eax)
     4bf:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     4c3:	00 06                	add    %al,(%esi)
     4c5:	00 00                	add    %al,(%eax)
     4c7:	00 00                	add    %al,(%eax)
     4c9:	00 00                	add    %al,(%eax)
     4cb:	00 44 00 04          	add    %al,0x4(%eax,%eax,1)
     4cf:	00 08                	add    %cl,(%eax)
     4d1:	00 00                	add    %al,(%eax)
     4d3:	00 00                	add    %al,(%eax)
     4d5:	00 00                	add    %al,(%eax)
     4d7:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
     4db:	00 0b                	add    %cl,(%ebx)
     4dd:	00 00                	add    %al,(%eax)
     4df:	00 00                	add    %al,(%eax)
     4e1:	00 00                	add    %al,(%eax)
     4e3:	00 44 00 06          	add    %al,0x6(%eax,%eax,1)
     4e7:	00 0d 00 00 00 00    	add    %cl,0x0
     4ed:	00 00                	add    %al,(%eax)
     4ef:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
     4f3:	00 15 00 00 00 a8    	add    %dl,0xa8000000
     4f9:	06                   	push   %es
     4fa:	00 00                	add    %al,(%eax)
     4fc:	40                   	inc    %eax
     4fd:	00 00                	add    %al,(%eax)
     4ff:	00 00                	add    %al,(%eax)
     501:	00 00                	add    %al,(%eax)
     503:	00 b1 06 00 00 40    	add    %dh,0x40000006(%ecx)
     509:	00 00                	add    %al,(%eax)
     50b:	00 02                	add    %al,(%edx)
     50d:	00 00                	add    %al,(%eax)
     50f:	00 00                	add    %al,(%eax)
     511:	00 00                	add    %al,(%eax)
     513:	00 c0                	add    %al,%al
	...
     51d:	00 00                	add    %al,(%eax)
     51f:	00 e0                	add    %ah,%al
     521:	00 00                	add    %al,(%eax)
     523:	00 17                	add    %dl,(%edi)
     525:	00 00                	add    %al,(%eax)
     527:	00 be 06 00 00 24    	add    %bh,0x24000006(%esi)
     52d:	00 00                	add    %al,(%eax)
     52f:	00 b7 00 28 00 9b    	add    %dh,-0x64ffd800(%edi)
     535:	06                   	push   %es
     536:	00 00                	add    %al,(%eax)
     538:	a0 00 00 00 08       	mov    0x8000000,%al
     53d:	00 00                	add    %al,(%eax)
     53f:	00 00                	add    %al,(%eax)
     541:	00 00                	add    %al,(%eax)
     543:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
	...
     54f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     553:	00 01                	add    %al,(%ecx)
     555:	00 00                	add    %al,(%eax)
     557:	00 00                	add    %al,(%eax)
     559:	00 00                	add    %al,(%eax)
     55b:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
     55f:	00 06                	add    %al,(%esi)
     561:	00 00                	add    %al,(%eax)
     563:	00 00                	add    %al,(%eax)
     565:	00 00                	add    %al,(%eax)
     567:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
     56b:	00 08                	add    %cl,(%eax)
     56d:	00 00                	add    %al,(%eax)
     56f:	00 00                	add    %al,(%eax)
     571:	00 00                	add    %al,(%eax)
     573:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     577:	00 0a                	add    %cl,(%edx)
     579:	00 00                	add    %al,(%eax)
     57b:	00 00                	add    %al,(%eax)
     57d:	00 00                	add    %al,(%eax)
     57f:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
     583:	00 12                	add    %dl,(%edx)
     585:	00 00                	add    %al,(%eax)
     587:	00 a8 06 00 00 40    	add    %ch,0x40000006(%eax)
	...
     595:	00 00                	add    %al,(%eax)
     597:	00 c0                	add    %al,%al
	...
     5a1:	00 00                	add    %al,(%eax)
     5a3:	00 e0                	add    %ah,%al
     5a5:	00 00                	add    %al,(%eax)
     5a7:	00 14 00             	add    %dl,(%eax,%eax,1)
     5aa:	00 00                	add    %al,(%eax)
     5ac:	d3 06                	roll   %cl,(%esi)
     5ae:	00 00                	add    %al,(%eax)
     5b0:	24 00                	and    $0x0,%al
     5b2:	00 00                	add    %al,(%eax)
     5b4:	cb                   	lret   
     5b5:	00 28                	add    %ch,(%eax)
     5b7:	00 e7                	add    %ah,%bh
     5b9:	06                   	push   %es
     5ba:	00 00                	add    %al,(%eax)
     5bc:	a0 00 00 00 08       	mov    0x8000000,%al
     5c1:	00 00                	add    %al,(%eax)
     5c3:	00 f4                	add    %dh,%ah
     5c5:	06                   	push   %es
     5c6:	00 00                	add    %al,(%eax)
     5c8:	a0 00 00 00 0c       	mov    0xc000000,%al
     5cd:	00 00                	add    %al,(%eax)
     5cf:	00 ff                	add    %bh,%bh
     5d1:	06                   	push   %es
     5d2:	00 00                	add    %al,(%eax)
     5d4:	a0 00 00 00 10       	mov    0x10000000,%al
     5d9:	00 00                	add    %al,(%eax)
     5db:	00 00                	add    %al,(%eax)
     5dd:	00 00                	add    %al,(%eax)
     5df:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
	...
     5eb:	00 44 00 37          	add    %al,0x37(%eax,%eax,1)
     5ef:	00 08                	add    %cl,(%eax)
     5f1:	00 00                	add    %al,(%eax)
     5f3:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     5f9:	00 00                	add    %al,(%eax)
     5fb:	00 d6                	add    %dl,%dh
     5fd:	00 28                	add    %ch,(%eax)
     5ff:	00 00                	add    %al,(%eax)
     601:	00 00                	add    %al,(%eax)
     603:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
     607:	01 0b                	add    %ecx,(%ebx)
     609:	00 00                	add    %al,(%eax)
     60b:	00 7d 06             	add    %bh,0x6(%ebp)
     60e:	00 00                	add    %al,(%eax)
     610:	84 00                	test   %al,(%eax)
     612:	00 00                	add    %al,(%eax)
     614:	d8 00                	fadds  (%eax)
     616:	28 00                	sub    %al,(%eax)
     618:	00 00                	add    %al,(%eax)
     61a:	00 00                	add    %al,(%eax)
     61c:	44                   	inc    %esp
     61d:	00 3b                	add    %bh,(%ebx)
     61f:	00 0d 00 00 00 a6    	add    %cl,0xa6000000
     625:	02 00                	add    (%eax),%al
     627:	00 84 00 00 00 d9 00 	add    %al,0xd90000(%eax,%eax,1)
     62e:	28 00                	sub    %al,(%eax)
     630:	00 00                	add    %al,(%eax)
     632:	00 00                	add    %al,(%eax)
     634:	44                   	inc    %esp
     635:	00 5c 00 0e          	add    %bl,0xe(%eax,%eax,1)
     639:	00 00                	add    %al,(%eax)
     63b:	00 7d 06             	add    %bh,0x6(%ebp)
     63e:	00 00                	add    %al,(%eax)
     640:	84 00                	test   %al,(%eax)
     642:	00 00                	add    %al,(%eax)
     644:	de 00                	fiadd  (%eax)
     646:	28 00                	sub    %al,(%eax)
     648:	00 00                	add    %al,(%eax)
     64a:	00 00                	add    %al,(%eax)
     64c:	44                   	inc    %esp
     64d:	00 3f                	add    %bh,(%edi)
     64f:	00 13                	add    %dl,(%ebx)
     651:	00 00                	add    %al,(%eax)
     653:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     659:	00 00                	add    %al,(%eax)
     65b:	00 e1                	add    %ah,%cl
     65d:	00 28                	add    %ch,(%eax)
     65f:	00 00                	add    %al,(%eax)
     661:	00 00                	add    %al,(%eax)
     663:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     667:	00 16                	add    %dl,(%esi)
     669:	00 00                	add    %al,(%eax)
     66b:	00 7d 06             	add    %bh,0x6(%ebp)
     66e:	00 00                	add    %al,(%eax)
     670:	84 00                	test   %al,(%eax)
     672:	00 00                	add    %al,(%eax)
     674:	e4 00                	in     $0x0,%al
     676:	28 00                	sub    %al,(%eax)
     678:	00 00                	add    %al,(%eax)
     67a:	00 00                	add    %al,(%eax)
     67c:	44                   	inc    %esp
     67d:	00 40 00             	add    %al,0x0(%eax)
     680:	19 00                	sbb    %eax,(%eax)
     682:	00 00                	add    %al,(%eax)
     684:	00 00                	add    %al,(%eax)
     686:	00 00                	add    %al,(%eax)
     688:	44                   	inc    %esp
     689:	00 42 00             	add    %al,0x0(%edx)
     68c:	1e                   	push   %ds
     68d:	00 00                	add    %al,(%eax)
     68f:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     695:	00 00                	add    %al,(%eax)
     697:	00 ee                	add    %ch,%dh
     699:	00 28                	add    %ch,(%eax)
     69b:	00 00                	add    %al,(%eax)
     69d:	00 00                	add    %al,(%eax)
     69f:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     6a3:	00 23                	add    %ah,(%ebx)
     6a5:	00 00                	add    %al,(%eax)
     6a7:	00 7d 06             	add    %bh,0x6(%ebp)
     6aa:	00 00                	add    %al,(%eax)
     6ac:	84 00                	test   %al,(%eax)
     6ae:	00 00                	add    %al,(%eax)
     6b0:	ef                   	out    %eax,(%dx)
     6b1:	00 28                	add    %ch,(%eax)
     6b3:	00 00                	add    %al,(%eax)
     6b5:	00 00                	add    %al,(%eax)
     6b7:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
     6bb:	00 24 00             	add    %ah,(%eax,%eax,1)
     6be:	00 00                	add    %al,(%eax)
     6c0:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     6c1:	02 00                	add    (%eax),%al
     6c3:	00 84 00 00 00 f5 00 	add    %al,0xf50000(%eax,%eax,1)
     6ca:	28 00                	sub    %al,(%eax)
     6cc:	00 00                	add    %al,(%eax)
     6ce:	00 00                	add    %al,(%eax)
     6d0:	44                   	inc    %esp
     6d1:	00 5c 00 2a          	add    %bl,0x2a(%eax,%eax,1)
     6d5:	00 00                	add    %al,(%eax)
     6d7:	00 7d 06             	add    %bh,0x6(%ebp)
     6da:	00 00                	add    %al,(%eax)
     6dc:	84 00                	test   %al,(%eax)
     6de:	00 00                	add    %al,(%eax)
     6e0:	f6 00 28             	testb  $0x28,(%eax)
     6e3:	00 00                	add    %al,(%eax)
     6e5:	00 00                	add    %al,(%eax)
     6e7:	00 44 00 44          	add    %al,0x44(%eax,%eax,1)
     6eb:	00 2b                	add    %ch,(%ebx)
     6ed:	00 00                	add    %al,(%eax)
     6ef:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
     6f5:	00 00                	add    %al,(%eax)
     6f7:	00 fc                	add    %bh,%ah
     6f9:	00 28                	add    %ch,(%eax)
     6fb:	00 00                	add    %al,(%eax)
     6fd:	00 00                	add    %al,(%eax)
     6ff:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     703:	00 31                	add    %dh,(%ecx)
     705:	00 00                	add    %al,(%eax)
     707:	00 7d 06             	add    %bh,0x6(%ebp)
     70a:	00 00                	add    %al,(%eax)
     70c:	84 00                	test   %al,(%eax)
     70e:	00 00                	add    %al,(%eax)
     710:	fd                   	std    
     711:	00 28                	add    %ch,(%eax)
     713:	00 00                	add    %al,(%eax)
     715:	00 00                	add    %al,(%eax)
     717:	00 44 00 45          	add    %al,0x45(%eax,%eax,1)
     71b:	00 32                	add    %dh,(%edx)
     71d:	00 00                	add    %al,(%eax)
     71f:	00 00                	add    %al,(%eax)
     721:	00 00                	add    %al,(%eax)
     723:	00 44 00 40          	add    %al,0x40(%eax,%eax,1)
     727:	00 35 00 00 00 a6    	add    %dh,0xa6000000
     72d:	02 00                	add    (%eax),%al
     72f:	00 84 00 00 00 03 01 	add    %al,0x1030000(%eax,%eax,1)
     736:	28 00                	sub    %al,(%eax)
     738:	00 00                	add    %al,(%eax)
     73a:	00 00                	add    %al,(%eax)
     73c:	44                   	inc    %esp
     73d:	00 33                	add    %dh,(%ebx)
     73f:	01 38                	add    %edi,(%eax)
     741:	00 00                	add    %al,(%eax)
     743:	00 7d 06             	add    %bh,0x6(%ebp)
     746:	00 00                	add    %al,(%eax)
     748:	84 00                	test   %al,(%eax)
     74a:	00 00                	add    %al,(%eax)
     74c:	05 01 28 00 00       	add    $0x2801,%eax
     751:	00 00                	add    %al,(%eax)
     753:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
     757:	00 3a                	add    %bh,(%edx)
     759:	00 00                	add    %al,(%eax)
     75b:	00 13                	add    %dl,(%ebx)
     75d:	07                   	pop    %es
     75e:	00 00                	add    %al,(%eax)
     760:	40                   	inc    %eax
     761:	00 00                	add    %al,(%eax)
     763:	00 03                	add    %al,(%ebx)
     765:	00 00                	add    %al,(%eax)
     767:	00 20                	add    %ah,(%eax)
     769:	07                   	pop    %es
     76a:	00 00                	add    %al,(%eax)
     76c:	40                   	inc    %eax
     76d:	00 00                	add    %al,(%eax)
     76f:	00 01                	add    %al,(%ecx)
     771:	00 00                	add    %al,(%eax)
     773:	00 2c 07             	add    %ch,(%edi,%eax,1)
     776:	00 00                	add    %al,(%eax)
     778:	24 00                	and    $0x0,%al
     77a:	00 00                	add    %al,(%eax)
     77c:	09 01                	or     %eax,(%ecx)
     77e:	28 00                	sub    %al,(%eax)
     780:	00 00                	add    %al,(%eax)
     782:	00 00                	add    %al,(%eax)
     784:	44                   	inc    %esp
     785:	00 1b                	add    %bl,(%ebx)
	...
     78f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     793:	00 01                	add    %al,(%ecx)
     795:	00 00                	add    %al,(%eax)
     797:	00 00                	add    %al,(%eax)
     799:	00 00                	add    %al,(%eax)
     79b:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     79f:	00 06                	add    %al,(%esi)
     7a1:	00 00                	add    %al,(%eax)
     7a3:	00 00                	add    %al,(%eax)
     7a5:	00 00                	add    %al,(%eax)
     7a7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     7ab:	00 0a                	add    %cl,(%edx)
     7ad:	00 00                	add    %al,(%eax)
     7af:	00 00                	add    %al,(%eax)
     7b1:	00 00                	add    %al,(%eax)
     7b3:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     7b7:	00 0f                	add    %cl,(%edi)
     7b9:	00 00                	add    %al,(%eax)
     7bb:	00 00                	add    %al,(%eax)
     7bd:	00 00                	add    %al,(%eax)
     7bf:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     7c3:	00 12                	add    %dl,(%edx)
     7c5:	00 00                	add    %al,(%eax)
     7c7:	00 00                	add    %al,(%eax)
     7c9:	00 00                	add    %al,(%eax)
     7cb:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
     7cf:	00 15 00 00 00 00    	add    %dl,0x0
     7d5:	00 00                	add    %al,(%eax)
     7d7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
     7db:	00 1a                	add    %bl,(%edx)
     7dd:	00 00                	add    %al,(%eax)
     7df:	00 00                	add    %al,(%eax)
     7e1:	00 00                	add    %al,(%eax)
     7e3:	00 44 00 33          	add    %al,0x33(%eax,%eax,1)
     7e7:	00 2a                	add    %ch,(%edx)
     7e9:	00 00                	add    %al,(%eax)
     7eb:	00 41 07             	add    %al,0x7(%ecx)
     7ee:	00 00                	add    %al,(%eax)
     7f0:	80 00 00             	addb   $0x0,(%eax)
     7f3:	00 d0                	add    %dl,%al
     7f5:	ff                   	(bad)  
     7f6:	ff                   	(bad)  
     7f7:	ff 00                	incl   (%eax)
     7f9:	00 00                	add    %al,(%eax)
     7fb:	00 c0                	add    %al,%al
	...
     805:	00 00                	add    %al,(%eax)
     807:	00 e0                	add    %ah,%al
     809:	00 00                	add    %al,(%eax)
     80b:	00 31                	add    %dh,(%ecx)
     80d:	00 00                	add    %al,(%eax)
     80f:	00 7d 07             	add    %bh,0x7(%ebp)
     812:	00 00                	add    %al,(%eax)
     814:	24 00                	and    $0x0,%al
     816:	00 00                	add    %al,(%eax)
     818:	3a 01                	cmp    (%ecx),%al
     81a:	28 00                	sub    %al,(%eax)
     81c:	8e 07                	mov    (%edi),%es
     81e:	00 00                	add    %al,(%eax)
     820:	a0 00 00 00 08       	mov    0x8000000,%al
     825:	00 00                	add    %al,(%eax)
     827:	00 9b 07 00 00 a0    	add    %bl,-0x5ffffff9(%ebx)
     82d:	00 00                	add    %al,(%eax)
     82f:	00 0c 00             	add    %cl,(%eax,%eax,1)
     832:	00 00                	add    %al,(%eax)
     834:	9b                   	fwait
     835:	06                   	push   %es
     836:	00 00                	add    %al,(%eax)
     838:	a0 00 00 00 10       	mov    0x10000000,%al
     83d:	00 00                	add    %al,(%eax)
     83f:	00 a8 07 00 00 a0    	add    %ch,-0x5ffffff9(%eax)
     845:	00 00                	add    %al,(%eax)
     847:	00 14 00             	add    %dl,(%eax,%eax,1)
     84a:	00 00                	add    %al,(%eax)
     84c:	b2 07                	mov    $0x7,%dl
     84e:	00 00                	add    %al,(%eax)
     850:	a0 00 00 00 18       	mov    0x18000000,%al
     855:	00 00                	add    %al,(%eax)
     857:	00 bc 07 00 00 a0 00 	add    %bh,0xa00000(%edi,%eax,1)
     85e:	00 00                	add    %al,(%eax)
     860:	1c 00                	sbb    $0x0,%al
     862:	00 00                	add    %al,(%eax)
     864:	c6 07 00             	movb   $0x0,(%edi)
     867:	00 a0 00 00 00 20    	add    %ah,0x20000000(%eax)
     86d:	00 00                	add    %al,(%eax)
     86f:	00 00                	add    %al,(%eax)
     871:	00 00                	add    %al,(%eax)
     873:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
	...
     87f:	00 44 00 4e          	add    %al,0x4e(%eax,%eax,1)
     883:	00 0a                	add    %cl,(%edx)
     885:	00 00                	add    %al,(%eax)
     887:	00 00                	add    %al,(%eax)
     889:	00 00                	add    %al,(%eax)
     88b:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     88f:	00 13                	add    %dl,(%ebx)
     891:	00 00                	add    %al,(%eax)
     893:	00 00                	add    %al,(%eax)
     895:	00 00                	add    %al,(%eax)
     897:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     89b:	00 18                	add    %bl,(%eax)
     89d:	00 00                	add    %al,(%eax)
     89f:	00 00                	add    %al,(%eax)
     8a1:	00 00                	add    %al,(%eax)
     8a3:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     8a7:	00 1b                	add    %bl,(%ebx)
     8a9:	00 00                	add    %al,(%eax)
     8ab:	00 00                	add    %al,(%eax)
     8ad:	00 00                	add    %al,(%eax)
     8af:	00 44 00 54          	add    %al,0x54(%eax,%eax,1)
     8b3:	00 20                	add    %ah,(%eax)
     8b5:	00 00                	add    %al,(%eax)
     8b7:	00 00                	add    %al,(%eax)
     8b9:	00 00                	add    %al,(%eax)
     8bb:	00 44 00 52          	add    %al,0x52(%eax,%eax,1)
     8bf:	00 23                	add    %ah,(%ebx)
     8c1:	00 00                	add    %al,(%eax)
     8c3:	00 00                	add    %al,(%eax)
     8c5:	00 00                	add    %al,(%eax)
     8c7:	00 44 00 50          	add    %al,0x50(%eax,%eax,1)
     8cb:	00 26                	add    %ah,(%esi)
     8cd:	00 00                	add    %al,(%eax)
     8cf:	00 00                	add    %al,(%eax)
     8d1:	00 00                	add    %al,(%eax)
     8d3:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
     8d7:	00 2c 00             	add    %ch,(%eax,%eax,1)
     8da:	00 00                	add    %al,(%eax)
     8dc:	d0 07                	rolb   (%edi)
     8de:	00 00                	add    %al,(%eax)
     8e0:	40                   	inc    %eax
     8e1:	00 00                	add    %al,(%eax)
     8e3:	00 03                	add    %al,(%ebx)
     8e5:	00 00                	add    %al,(%eax)
     8e7:	00 de                	add    %bl,%dh
     8e9:	07                   	pop    %es
     8ea:	00 00                	add    %al,(%eax)
     8ec:	40                   	inc    %eax
     8ed:	00 00                	add    %al,(%eax)
     8ef:	00 01                	add    %al,(%ecx)
     8f1:	00 00                	add    %al,(%eax)
     8f3:	00 e8                	add    %ch,%al
     8f5:	07                   	pop    %es
     8f6:	00 00                	add    %al,(%eax)
     8f8:	24 00                	and    $0x0,%al
     8fa:	00 00                	add    %al,(%eax)
     8fc:	69 01 28 00 9b 06    	imul   $0x69b0028,(%ecx),%eax
     902:	00 00                	add    %al,(%eax)
     904:	a0 00 00 00 08       	mov    0x8000000,%al
     909:	00 00                	add    %al,(%eax)
     90b:	00 a8 07 00 00 a0    	add    %ch,-0x5ffffff9(%eax)
     911:	00 00                	add    %al,(%eax)
     913:	00 0c 00             	add    %cl,(%eax,%eax,1)
     916:	00 00                	add    %al,(%eax)
     918:	b2 07                	mov    $0x7,%dl
     91a:	00 00                	add    %al,(%eax)
     91c:	a0 00 00 00 10       	mov    0x10000000,%al
     921:	00 00                	add    %al,(%eax)
     923:	00 bc 07 00 00 a0 00 	add    %bh,0xa00000(%edi,%eax,1)
     92a:	00 00                	add    %al,(%eax)
     92c:	14 00                	adc    $0x0,%al
     92e:	00 00                	add    %al,(%eax)
     930:	c6 07 00             	movb   $0x0,(%edi)
     933:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     939:	00 00                	add    %al,(%eax)
     93b:	00 00                	add    %al,(%eax)
     93d:	00 00                	add    %al,(%eax)
     93f:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
	...
     94b:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
     94f:	00 03                	add    %al,(%ebx)
     951:	00 00                	add    %al,(%eax)
     953:	00 00                	add    %al,(%eax)
     955:	00 00                	add    %al,(%eax)
     957:	00 44 00 5c          	add    %al,0x5c(%eax,%eax,1)
     95b:	00 26                	add    %ah,(%esi)
     95d:	00 00                	add    %al,(%eax)
     95f:	00 f8                	add    %bh,%al
     961:	07                   	pop    %es
     962:	00 00                	add    %al,(%eax)
     964:	24 00                	and    $0x0,%al
     966:	00 00                	add    %al,(%eax)
     968:	91                   	xchg   %eax,%ecx
     969:	01 28                	add    %ebp,(%eax)
     96b:	00 00                	add    %al,(%eax)
     96d:	00 00                	add    %al,(%eax)
     96f:	00 44 00 5f          	add    %al,0x5f(%eax,%eax,1)
	...
     97b:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
     97f:	00 03                	add    %al,(%ebx)
     981:	00 00                	add    %al,(%eax)
     983:	00 00                	add    %al,(%eax)
     985:	00 00                	add    %al,(%eax)
     987:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
     98b:	00 18                	add    %bl,(%eax)
     98d:	00 00                	add    %al,(%eax)
     98f:	00 00                	add    %al,(%eax)
     991:	00 00                	add    %al,(%eax)
     993:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
     997:	00 30                	add    %dh,(%eax)
     999:	00 00                	add    %al,(%eax)
     99b:	00 00                	add    %al,(%eax)
     99d:	00 00                	add    %al,(%eax)
     99f:	00 44 00 6a          	add    %al,0x6a(%eax,%eax,1)
     9a3:	00 4b 00             	add    %cl,0x0(%ebx)
     9a6:	00 00                	add    %al,(%eax)
     9a8:	00 00                	add    %al,(%eax)
     9aa:	00 00                	add    %al,(%eax)
     9ac:	44                   	inc    %esp
     9ad:	00 6e 00             	add    %ch,0x0(%esi)
     9b0:	63 00                	arpl   %ax,(%eax)
     9b2:	00 00                	add    %al,(%eax)
     9b4:	00 00                	add    %al,(%eax)
     9b6:	00 00                	add    %al,(%eax)
     9b8:	44                   	inc    %esp
     9b9:	00 6f 00             	add    %ch,0x0(%edi)
     9bc:	7b 00                	jnp    9be <bootmain-0x27f642>
     9be:	00 00                	add    %al,(%eax)
     9c0:	00 00                	add    %al,(%eax)
     9c2:	00 00                	add    %al,(%eax)
     9c4:	44                   	inc    %esp
     9c5:	00 70 00             	add    %dh,0x0(%eax)
     9c8:	90                   	nop
     9c9:	00 00                	add    %al,(%eax)
     9cb:	00 00                	add    %al,(%eax)
     9cd:	00 00                	add    %al,(%eax)
     9cf:	00 44 00 71          	add    %al,0x71(%eax,%eax,1)
     9d3:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
     9d9:	00 00                	add    %al,(%eax)
     9db:	00 44 00 72          	add    %al,0x72(%eax,%eax,1)
     9df:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
     9e5:	00 00                	add    %al,(%eax)
     9e7:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
     9eb:	00 d5                	add    %dl,%ch
     9ed:	00 00                	add    %al,(%eax)
     9ef:	00 00                	add    %al,(%eax)
     9f1:	00 00                	add    %al,(%eax)
     9f3:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
     9f7:	00 ea                	add    %ch,%dl
     9f9:	00 00                	add    %al,(%eax)
     9fb:	00 00                	add    %al,(%eax)
     9fd:	00 00                	add    %al,(%eax)
     9ff:	00 44 00 78          	add    %al,0x78(%eax,%eax,1)
     a03:	00 08                	add    %cl,(%eax)
     a05:	01 00                	add    %eax,(%eax)
     a07:	00 00                	add    %al,(%eax)
     a09:	00 00                	add    %al,(%eax)
     a0b:	00 44 00 79          	add    %al,0x79(%eax,%eax,1)
     a0f:	00 23                	add    %ah,(%ebx)
     a11:	01 00                	add    %eax,(%eax)
     a13:	00 00                	add    %al,(%eax)
     a15:	00 00                	add    %al,(%eax)
     a17:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
     a1b:	00 41 01             	add    %al,0x1(%ecx)
     a1e:	00 00                	add    %al,(%eax)
     a20:	00 00                	add    %al,(%eax)
     a22:	00 00                	add    %al,(%eax)
     a24:	44                   	inc    %esp
     a25:	00 7b 00             	add    %bh,0x0(%ebx)
     a28:	5f                   	pop    %edi
     a29:	01 00                	add    %eax,(%eax)
     a2b:	00 0c 08             	add    %cl,(%eax,%ecx,1)
     a2e:	00 00                	add    %al,(%eax)
     a30:	24 00                	and    $0x0,%al
     a32:	00 00                	add    %al,(%eax)
     a34:	f2 02 28             	repnz add (%eax),%ch
     a37:	00 20                	add    %ah,(%eax)
     a39:	08 00                	or     %al,(%eax)
     a3b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     a41:	00 00                	add    %al,(%eax)
     a43:	00 00                	add    %al,(%eax)
     a45:	00 00                	add    %al,(%eax)
     a47:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
	...
     a53:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
     a57:	00 03                	add    %al,(%ebx)
     a59:	00 00                	add    %al,(%eax)
     a5b:	00 00                	add    %al,(%eax)
     a5d:	00 00                	add    %al,(%eax)
     a5f:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
     a63:	00 06                	add    %al,(%esi)
     a65:	00 00                	add    %al,(%eax)
     a67:	00 00                	add    %al,(%eax)
     a69:	00 00                	add    %al,(%eax)
     a6b:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
     a6f:	00 0d 00 00 00 00    	add    %cl,0x0
     a75:	00 00                	add    %al,(%eax)
     a77:	00 44 00 82          	add    %al,-0x7e(%eax,%eax,1)
     a7b:	00 11                	add    %dl,(%ecx)
     a7d:	00 00                	add    %al,(%eax)
     a7f:	00 00                	add    %al,(%eax)
     a81:	00 00                	add    %al,(%eax)
     a83:	00 44 00 83          	add    %al,-0x7d(%eax,%eax,1)
     a87:	00 17                	add    %dl,(%edi)
     a89:	00 00                	add    %al,(%eax)
     a8b:	00 00                	add    %al,(%eax)
     a8d:	00 00                	add    %al,(%eax)
     a8f:	00 44 00 85          	add    %al,-0x7b(%eax,%eax,1)
     a93:	00 1d 00 00 00 35    	add    %bl,0x35000000
     a99:	08 00                	or     %al,(%eax)
     a9b:	00 40 00             	add    %al,0x0(%eax)
     a9e:	00 00                	add    %al,(%eax)
     aa0:	00 00                	add    %al,(%eax)
     aa2:	00 00                	add    %al,(%eax)
     aa4:	43                   	inc    %ebx
     aa5:	08 00                	or     %al,(%eax)
     aa7:	00 24 00             	add    %ah,(%eax,%eax,1)
     aaa:	00 00                	add    %al,(%eax)
     aac:	11 03                	adc    %eax,(%ebx)
     aae:	28 00                	sub    %al,(%eax)
     ab0:	56                   	push   %esi
     ab1:	08 00                	or     %al,(%eax)
     ab3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     ab9:	00 00                	add    %al,(%eax)
     abb:	00 63 08             	add    %ah,0x8(%ebx)
     abe:	00 00                	add    %al,(%eax)
     ac0:	a0 00 00 00 0c       	mov    0xc000000,%al
     ac5:	00 00                	add    %al,(%eax)
     ac7:	00 00                	add    %al,(%eax)
     ac9:	00 00                	add    %al,(%eax)
     acb:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
	...
     ad7:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     adb:	00 0d 00 00 00 00    	add    %cl,0x0
     ae1:	00 00                	add    %al,(%eax)
     ae3:	00 44 00 89          	add    %al,-0x77(%eax,%eax,1)
     ae7:	00 0f                	add    %cl,(%edi)
     ae9:	00 00                	add    %al,(%eax)
     aeb:	00 00                	add    %al,(%eax)
     aed:	00 00                	add    %al,(%eax)
     aef:	00 44 00 a5          	add    %al,-0x5b(%eax,%eax,1)
     af3:	00 11                	add    %dl,(%ecx)
     af5:	00 00                	add    %al,(%eax)
     af7:	00 00                	add    %al,(%eax)
     af9:	00 00                	add    %al,(%eax)
     afb:	00 44 00 a8          	add    %al,-0x58(%eax,%eax,1)
     aff:	00 27                	add    %ah,(%edi)
     b01:	00 00                	add    %al,(%eax)
     b03:	00 00                	add    %al,(%eax)
     b05:	00 00                	add    %al,(%eax)
     b07:	00 44 00 a7          	add    %al,-0x59(%eax,%eax,1)
     b0b:	00 2d 00 00 00 00    	add    %ch,0x0
     b11:	00 00                	add    %al,(%eax)
     b13:	00 44 00 a9          	add    %al,-0x57(%eax,%eax,1)
     b17:	00 34 00             	add    %dh,(%eax,%eax,1)
     b1a:	00 00                	add    %al,(%eax)
     b1c:	00 00                	add    %al,(%eax)
     b1e:	00 00                	add    %al,(%eax)
     b20:	44                   	inc    %esp
     b21:	00 a3 00 38 00 00    	add    %ah,0x3800(%ebx)
     b27:	00 00                	add    %al,(%eax)
     b29:	00 00                	add    %al,(%eax)
     b2b:	00 44 00 a1          	add    %al,-0x5f(%eax,%eax,1)
     b2f:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
     b33:	00 00                	add    %al,(%eax)
     b35:	00 00                	add    %al,(%eax)
     b37:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
     b3b:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
     b3f:	00 6d 08             	add    %ch,0x8(%ebp)
     b42:	00 00                	add    %al,(%eax)
     b44:	26 00 00             	add    %al,%es:(%eax)
     b47:	00 00                	add    %al,(%eax)
     b49:	23 28                	and    (%eax),%ebp
     b4b:	00 a5 08 00 00 40    	add    %ah,0x40000008(%ebp)
     b51:	00 00                	add    %al,(%eax)
     b53:	00 00                	add    %al,(%eax)
     b55:	00 00                	add    %al,(%eax)
     b57:	00 ae 08 00 00 40    	add    %ch,0x40000008(%esi)
     b5d:	00 00                	add    %al,(%eax)
     b5f:	00 06                	add    %al,(%esi)
     b61:	00 00                	add    %al,(%eax)
     b63:	00 00                	add    %al,(%eax)
     b65:	00 00                	add    %al,(%eax)
     b67:	00 c0                	add    %al,%al
	...
     b71:	00 00                	add    %al,(%eax)
     b73:	00 e0                	add    %ah,%al
     b75:	00 00                	add    %al,(%eax)
     b77:	00 50 00             	add    %dl,0x0(%eax)
     b7a:	00 00                	add    %al,(%eax)
     b7c:	b8 08 00 00 24       	mov    $0x24000008,%eax
     b81:	00 00                	add    %al,(%eax)
     b83:	00 61 03             	add    %ah,0x3(%ecx)
     b86:	28 00                	sub    %al,(%eax)
     b88:	ce                   	into   
     b89:	08 00                	or     %al,(%eax)
     b8b:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     b91:	00 00                	add    %al,(%eax)
     b93:	00 9b 07 00 00 a0    	add    %bl,-0x5ffffff9(%ebx)
     b99:	00 00                	add    %al,(%eax)
     b9b:	00 0c 00             	add    %cl,(%eax,%eax,1)
     b9e:	00 00                	add    %al,(%eax)
     ba0:	da 08                	fimull (%eax)
     ba2:	00 00                	add    %al,(%eax)
     ba4:	a0 00 00 00 10       	mov    0x10000000,%al
     ba9:	00 00                	add    %al,(%eax)
     bab:	00 e8                	add    %ch,%al
     bad:	08 00                	or     %al,(%eax)
     baf:	00 a0 00 00 00 14    	add    %ah,0x14000000(%eax)
     bb5:	00 00                	add    %al,(%eax)
     bb7:	00 f6                	add    %dh,%dh
     bb9:	08 00                	or     %al,(%eax)
     bbb:	00 a0 00 00 00 18    	add    %ah,0x18000000(%eax)
     bc1:	00 00                	add    %al,(%eax)
     bc3:	00 01                	add    %al,(%ecx)
     bc5:	09 00                	or     %eax,(%eax)
     bc7:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
     bcd:	00 00                	add    %al,(%eax)
     bcf:	00 0c 09             	add    %cl,(%ecx,%ecx,1)
     bd2:	00 00                	add    %al,(%eax)
     bd4:	a0 00 00 00 20       	mov    0x20000000,%al
     bd9:	00 00                	add    %al,(%eax)
     bdb:	00 17                	add    %dl,(%edi)
     bdd:	09 00                	or     %eax,(%eax)
     bdf:	00 a0 00 00 00 24    	add    %ah,0x24000000(%eax)
     be5:	00 00                	add    %al,(%eax)
     be7:	00 00                	add    %al,(%eax)
     be9:	00 00                	add    %al,(%eax)
     beb:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
	...
     bf7:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     bfb:	00 07                	add    %al,(%edi)
     bfd:	00 00                	add    %al,(%eax)
     bff:	00 00                	add    %al,(%eax)
     c01:	00 00                	add    %al,(%eax)
     c03:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
     c07:	00 09                	add    %cl,(%ecx)
     c09:	00 00                	add    %al,(%eax)
     c0b:	00 00                	add    %al,(%eax)
     c0d:	00 00                	add    %al,(%eax)
     c0f:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     c13:	00 17                	add    %dl,(%edi)
     c15:	00 00                	add    %al,(%eax)
     c17:	00 00                	add    %al,(%eax)
     c19:	00 00                	add    %al,(%eax)
     c1b:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     c1f:	00 1c 00             	add    %bl,(%eax,%eax,1)
     c22:	00 00                	add    %al,(%eax)
     c24:	00 00                	add    %al,(%eax)
     c26:	00 00                	add    %al,(%eax)
     c28:	44                   	inc    %esp
     c29:	00 b8 00 1e 00 00    	add    %bh,0x1e00(%eax)
     c2f:	00 00                	add    %al,(%eax)
     c31:	00 00                	add    %al,(%eax)
     c33:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
     c37:	00 23                	add    %ah,(%ebx)
     c39:	00 00                	add    %al,(%eax)
     c3b:	00 00                	add    %al,(%eax)
     c3d:	00 00                	add    %al,(%eax)
     c3f:	00 44 00 b8          	add    %al,-0x48(%eax,%eax,1)
     c43:	00 29                	add    %ch,(%ecx)
     c45:	00 00                	add    %al,(%eax)
     c47:	00 00                	add    %al,(%eax)
     c49:	00 00                	add    %al,(%eax)
     c4b:	00 44 00 b6          	add    %al,-0x4a(%eax,%eax,1)
     c4f:	00 2c 00             	add    %ch,(%eax,%eax,1)
     c52:	00 00                	add    %al,(%eax)
     c54:	00 00                	add    %al,(%eax)
     c56:	00 00                	add    %al,(%eax)
     c58:	44                   	inc    %esp
     c59:	00 be 00 35 00 00    	add    %bh,0x3500(%esi)
     c5f:	00 a5 08 00 00 40    	add    %ah,0x40000008(%ebp)
     c65:	00 00                	add    %al,(%eax)
     c67:	00 02                	add    %al,(%edx)
     c69:	00 00                	add    %al,(%eax)
     c6b:	00 25 09 00 00 40    	add    %ah,0x40000009
     c71:	00 00                	add    %al,(%eax)
     c73:	00 06                	add    %al,(%esi)
     c75:	00 00                	add    %al,(%eax)
     c77:	00 00                	add    %al,(%eax)
     c79:	00 00                	add    %al,(%eax)
     c7b:	00 c0                	add    %al,%al
	...
     c85:	00 00                	add    %al,(%eax)
     c87:	00 e0                	add    %ah,%al
     c89:	00 00                	add    %al,(%eax)
     c8b:	00 39                	add    %bh,(%ecx)
     c8d:	00 00                	add    %al,(%eax)
     c8f:	00 00                	add    %al,(%eax)
     c91:	00 00                	add    %al,(%eax)
     c93:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
     c97:	00 9a 03 28 00 2e    	add    %bl,0x2e002803(%edx)
     c9d:	09 00                	or     %eax,(%eax)
     c9f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
     ca3:	00 9a 03 28 00 08    	add    %bl,0x8002803(%edx)
     ca9:	00 00                	add    %al,(%eax)
     cab:	00 3c 00             	add    %bh,(%eax,%eax,1)
     cae:	00 00                	add    %al,(%eax)
     cb0:	00 00                	add    %al,(%eax)
     cb2:	00 00                	add    %al,(%eax)
     cb4:	17                   	pop    %ss
     cb5:	00 00                	add    %al,(%eax)
     cb7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     cbd:	00 00                	add    %al,(%eax)
     cbf:	00 41 00             	add    %al,0x0(%ecx)
     cc2:	00 00                	add    %al,(%eax)
     cc4:	80 00 00             	addb   $0x0,(%eax)
     cc7:	00 00                	add    %al,(%eax)
     cc9:	00 00                	add    %al,(%eax)
     ccb:	00 5b 00             	add    %bl,0x0(%ebx)
     cce:	00 00                	add    %al,(%eax)
     cd0:	80 00 00             	addb   $0x0,(%eax)
     cd3:	00 00                	add    %al,(%eax)
     cd5:	00 00                	add    %al,(%eax)
     cd7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     cdd:	00 00                	add    %al,(%eax)
     cdf:	00 00                	add    %al,(%eax)
     ce1:	00 00                	add    %al,(%eax)
     ce3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     ce9:	00 00                	add    %al,(%eax)
     ceb:	00 00                	add    %al,(%eax)
     ced:	00 00                	add    %al,(%eax)
     cef:	00 e1                	add    %ah,%cl
     cf1:	00 00                	add    %al,(%eax)
     cf3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     cf9:	00 00                	add    %al,(%eax)
     cfb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     cfe:	00 00                	add    %al,(%eax)
     d00:	80 00 00             	addb   $0x0,(%eax)
     d03:	00 00                	add    %al,(%eax)
     d05:	00 00                	add    %al,(%eax)
     d07:	00 37                	add    %dh,(%edi)
     d09:	01 00                	add    %eax,(%eax)
     d0b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d11:	00 00                	add    %al,(%eax)
     d13:	00 5d 01             	add    %bl,0x1(%ebp)
     d16:	00 00                	add    %al,(%eax)
     d18:	80 00 00             	addb   $0x0,(%eax)
     d1b:	00 00                	add    %al,(%eax)
     d1d:	00 00                	add    %al,(%eax)
     d1f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     d25:	00 00                	add    %al,(%eax)
     d27:	00 00                	add    %al,(%eax)
     d29:	00 00                	add    %al,(%eax)
     d2b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     d31:	00 00                	add    %al,(%eax)
     d33:	00 00                	add    %al,(%eax)
     d35:	00 00                	add    %al,(%eax)
     d37:	00 d2                	add    %dl,%dl
     d39:	01 00                	add    %eax,(%eax)
     d3b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d41:	00 00                	add    %al,(%eax)
     d43:	00 ec                	add    %ch,%ah
     d45:	01 00                	add    %eax,(%eax)
     d47:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d4d:	00 00                	add    %al,(%eax)
     d4f:	00 07                	add    %al,(%edi)
     d51:	02 00                	add    (%eax),%al
     d53:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d59:	00 00                	add    %al,(%eax)
     d5b:	00 28                	add    %ch,(%eax)
     d5d:	02 00                	add    (%eax),%al
     d5f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     d65:	00 00                	add    %al,(%eax)
     d67:	00 47 02             	add    %al,0x2(%edi)
     d6a:	00 00                	add    %al,(%eax)
     d6c:	80 00 00             	addb   $0x0,(%eax)
     d6f:	00 00                	add    %al,(%eax)
     d71:	00 00                	add    %al,(%eax)
     d73:	00 66 02             	add    %ah,0x2(%esi)
     d76:	00 00                	add    %al,(%eax)
     d78:	80 00 00             	addb   $0x0,(%eax)
     d7b:	00 00                	add    %al,(%eax)
     d7d:	00 00                	add    %al,(%eax)
     d7f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     d85:	00 00                	add    %al,(%eax)
     d87:	00 00                	add    %al,(%eax)
     d89:	00 00                	add    %al,(%eax)
     d8b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     d91:	00 00                	add    %al,(%eax)
     d93:	00 34 72             	add    %dh,(%edx,%esi,2)
     d96:	00 00                	add    %al,(%eax)
     d98:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     d99:	02 00                	add    (%eax),%al
     d9b:	00 c2                	add    %al,%dl
     d9d:	00 00                	add    %al,(%eax)
     d9f:	00 00                	add    %al,(%eax)
     da1:	00 00                	add    %al,(%eax)
     da3:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     da9:	00 00                	add    %al,(%eax)
     dab:	00 37                	add    %dh,(%edi)
     dad:	53                   	push   %ebx
     dae:	00 00                	add    %al,(%eax)
     db0:	00 00                	add    %al,(%eax)
     db2:	00 00                	add    %al,(%eax)
     db4:	64 00 00             	add    %al,%fs:(%eax)
     db7:	00 9a 03 28 00 35    	add    %bl,0x35002803(%edx)
     dbd:	09 00                	or     %eax,(%eax)
     dbf:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
     dc3:	00 9a 03 28 00 08    	add    %bl,0x8002803(%edx)
     dc9:	00 00                	add    %al,(%eax)
     dcb:	00 3c 00             	add    %bh,(%eax,%eax,1)
     dce:	00 00                	add    %al,(%eax)
     dd0:	00 00                	add    %al,(%eax)
     dd2:	00 00                	add    %al,(%eax)
     dd4:	17                   	pop    %ss
     dd5:	00 00                	add    %al,(%eax)
     dd7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     ddd:	00 00                	add    %al,(%eax)
     ddf:	00 41 00             	add    %al,0x0(%ecx)
     de2:	00 00                	add    %al,(%eax)
     de4:	80 00 00             	addb   $0x0,(%eax)
     de7:	00 00                	add    %al,(%eax)
     de9:	00 00                	add    %al,(%eax)
     deb:	00 5b 00             	add    %bl,0x0(%ebx)
     dee:	00 00                	add    %al,(%eax)
     df0:	80 00 00             	addb   $0x0,(%eax)
     df3:	00 00                	add    %al,(%eax)
     df5:	00 00                	add    %al,(%eax)
     df7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
     dfd:	00 00                	add    %al,(%eax)
     dff:	00 00                	add    %al,(%eax)
     e01:	00 00                	add    %al,(%eax)
     e03:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
     e09:	00 00                	add    %al,(%eax)
     e0b:	00 00                	add    %al,(%eax)
     e0d:	00 00                	add    %al,(%eax)
     e0f:	00 e1                	add    %ah,%cl
     e11:	00 00                	add    %al,(%eax)
     e13:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e19:	00 00                	add    %al,(%eax)
     e1b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
     e1e:	00 00                	add    %al,(%eax)
     e20:	80 00 00             	addb   $0x0,(%eax)
     e23:	00 00                	add    %al,(%eax)
     e25:	00 00                	add    %al,(%eax)
     e27:	00 37                	add    %dh,(%edi)
     e29:	01 00                	add    %eax,(%eax)
     e2b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e31:	00 00                	add    %al,(%eax)
     e33:	00 5d 01             	add    %bl,0x1(%ebp)
     e36:	00 00                	add    %al,(%eax)
     e38:	80 00 00             	addb   $0x0,(%eax)
     e3b:	00 00                	add    %al,(%eax)
     e3d:	00 00                	add    %al,(%eax)
     e3f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
     e45:	00 00                	add    %al,(%eax)
     e47:	00 00                	add    %al,(%eax)
     e49:	00 00                	add    %al,(%eax)
     e4b:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
     e51:	00 00                	add    %al,(%eax)
     e53:	00 00                	add    %al,(%eax)
     e55:	00 00                	add    %al,(%eax)
     e57:	00 d2                	add    %dl,%dl
     e59:	01 00                	add    %eax,(%eax)
     e5b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e61:	00 00                	add    %al,(%eax)
     e63:	00 ec                	add    %ch,%ah
     e65:	01 00                	add    %eax,(%eax)
     e67:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e6d:	00 00                	add    %al,(%eax)
     e6f:	00 07                	add    %al,(%edi)
     e71:	02 00                	add    (%eax),%al
     e73:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e79:	00 00                	add    %al,(%eax)
     e7b:	00 28                	add    %ch,(%eax)
     e7d:	02 00                	add    (%eax),%al
     e7f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
     e85:	00 00                	add    %al,(%eax)
     e87:	00 47 02             	add    %al,0x2(%edi)
     e8a:	00 00                	add    %al,(%eax)
     e8c:	80 00 00             	addb   $0x0,(%eax)
     e8f:	00 00                	add    %al,(%eax)
     e91:	00 00                	add    %al,(%eax)
     e93:	00 66 02             	add    %ah,0x2(%esi)
     e96:	00 00                	add    %al,(%eax)
     e98:	80 00 00             	addb   $0x0,(%eax)
     e9b:	00 00                	add    %al,(%eax)
     e9d:	00 00                	add    %al,(%eax)
     e9f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
     ea5:	00 00                	add    %al,(%eax)
     ea7:	00 00                	add    %al,(%eax)
     ea9:	00 00                	add    %al,(%eax)
     eab:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
     eb1:	00 00                	add    %al,(%eax)
     eb3:	00 34 72             	add    %dh,(%edx,%esi,2)
     eb6:	00 00                	add    %al,(%eax)
     eb8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
     eb9:	02 00                	add    (%eax),%al
     ebb:	00 c2                	add    %al,%dl
     ebd:	00 00                	add    %al,(%eax)
     ebf:	00 00                	add    %al,(%eax)
     ec1:	00 00                	add    %al,(%eax)
     ec3:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
     ec9:	00 00                	add    %al,(%eax)
     ecb:	00 37                	add    %dh,(%edi)
     ecd:	53                   	push   %ebx
     ece:	00 00                	add    %al,(%eax)
     ed0:	3d 09 00 00 24       	cmp    $0x24000009,%eax
     ed5:	00 00                	add    %al,(%eax)
     ed7:	00 9a 03 28 00 4a    	add    %bl,0x4a002803(%edx)
     edd:	09 00                	or     %eax,(%eax)
     edf:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
     ee5:	00 00                	add    %al,(%eax)
     ee7:	00 0c 09             	add    %cl,(%ecx,%ecx,1)
     eea:	00 00                	add    %al,(%eax)
     eec:	a0 00 00 00 0c       	mov    0xc000000,%al
     ef1:	00 00                	add    %al,(%eax)
     ef3:	00 00                	add    %al,(%eax)
     ef5:	00 00                	add    %al,(%eax)
     ef7:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
	...
     f03:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f07:	00 01                	add    %al,(%ecx)
     f09:	00 00                	add    %al,(%eax)
     f0b:	00 00                	add    %al,(%eax)
     f0d:	00 00                	add    %al,(%eax)
     f0f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f13:	00 03                	add    %al,(%ebx)
     f15:	00 00                	add    %al,(%eax)
     f17:	00 00                	add    %al,(%eax)
     f19:	00 00                	add    %al,(%eax)
     f1b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f1f:	00 05 00 00 00 00    	add    %al,0x0
     f25:	00 00                	add    %al,(%eax)
     f27:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f2b:	00 0a                	add    %cl,(%edx)
     f2d:	00 00                	add    %al,(%eax)
     f2f:	00 00                	add    %al,(%eax)
     f31:	00 00                	add    %al,(%eax)
     f33:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f37:	00 10                	add    %dl,(%eax)
     f39:	00 00                	add    %al,(%eax)
     f3b:	00 00                	add    %al,(%eax)
     f3d:	00 00                	add    %al,(%eax)
     f3f:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f43:	00 13                	add    %dl,(%ebx)
     f45:	00 00                	add    %al,(%eax)
     f47:	00 00                	add    %al,(%eax)
     f49:	00 00                	add    %al,(%eax)
     f4b:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
     f4f:	00 16                	add    %dl,(%esi)
     f51:	00 00                	add    %al,(%eax)
     f53:	00 00                	add    %al,(%eax)
     f55:	00 00                	add    %al,(%eax)
     f57:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
     f5b:	00 19                	add    %bl,(%ecx)
     f5d:	00 00                	add    %al,(%eax)
     f5f:	00 00                	add    %al,(%eax)
     f61:	00 00                	add    %al,(%eax)
     f63:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
     f67:	00 1e                	add    %bl,(%esi)
     f69:	00 00                	add    %al,(%eax)
     f6b:	00 00                	add    %al,(%eax)
     f6d:	00 00                	add    %al,(%eax)
     f6f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f73:	00 22                	add    %ah,(%edx)
     f75:	00 00                	add    %al,(%eax)
     f77:	00 00                	add    %al,(%eax)
     f79:	00 00                	add    %al,(%eax)
     f7b:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
     f7f:	00 25 00 00 00 00    	add    %ah,0x0
     f85:	00 00                	add    %al,(%eax)
     f87:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f8b:	00 27                	add    %ah,(%edi)
     f8d:	00 00                	add    %al,(%eax)
     f8f:	00 00                	add    %al,(%eax)
     f91:	00 00                	add    %al,(%eax)
     f93:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
     f97:	00 28                	add    %ch,(%eax)
     f99:	00 00                	add    %al,(%eax)
     f9b:	00 00                	add    %al,(%eax)
     f9d:	00 00                	add    %al,(%eax)
     f9f:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     fa3:	00 2a                	add    %ch,(%edx)
     fa5:	00 00                	add    %al,(%eax)
     fa7:	00 00                	add    %al,(%eax)
     fa9:	00 00                	add    %al,(%eax)
     fab:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     faf:	00 38                	add    %bh,(%eax)
     fb1:	00 00                	add    %al,(%eax)
     fb3:	00 00                	add    %al,(%eax)
     fb5:	00 00                	add    %al,(%eax)
     fb7:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     fbb:	00 3a                	add    %bh,(%edx)
     fbd:	00 00                	add    %al,(%eax)
     fbf:	00 00                	add    %al,(%eax)
     fc1:	00 00                	add    %al,(%eax)
     fc3:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
     fc7:	00 3d 00 00 00 00    	add    %bh,0x0
     fcd:	00 00                	add    %al,(%eax)
     fcf:	00 44 00 1b          	add    %al,0x1b(%eax,%eax,1)
     fd3:	00 3f                	add    %bh,(%edi)
     fd5:	00 00                	add    %al,(%eax)
     fd7:	00 00                	add    %al,(%eax)
     fd9:	00 00                	add    %al,(%eax)
     fdb:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
     fdf:	00 41 00             	add    %al,0x0(%ecx)
     fe2:	00 00                	add    %al,(%eax)
     fe4:	00 00                	add    %al,(%eax)
     fe6:	00 00                	add    %al,(%eax)
     fe8:	44                   	inc    %esp
     fe9:	00 1e                	add    %bl,(%esi)
     feb:	00 45 00             	add    %al,0x0(%ebp)
     fee:	00 00                	add    %al,(%eax)
     ff0:	00 00                	add    %al,(%eax)
     ff2:	00 00                	add    %al,(%eax)
     ff4:	44                   	inc    %esp
     ff5:	00 20                	add    %ah,(%eax)
     ff7:	00 49 00             	add    %cl,0x0(%ecx)
     ffa:	00 00                	add    %al,(%eax)
     ffc:	00 00                	add    %al,(%eax)
     ffe:	00 00                	add    %al,(%eax)
    1000:	44                   	inc    %esp
    1001:	00 21                	add    %ah,(%ecx)
    1003:	00 4a 00             	add    %cl,0x0(%edx)
    1006:	00 00                	add    %al,(%eax)
    1008:	00 00                	add    %al,(%eax)
    100a:	00 00                	add    %al,(%eax)
    100c:	44                   	inc    %esp
    100d:	00 24 00             	add    %ah,(%eax,%eax,1)
    1010:	56                   	push   %esi
    1011:	00 00                	add    %al,(%eax)
    1013:	00 00                	add    %al,(%eax)
    1015:	00 00                	add    %al,(%eax)
    1017:	00 44 00 27          	add    %al,0x27(%eax,%eax,1)
    101b:	00 5a 00             	add    %bl,0x0(%edx)
    101e:	00 00                	add    %al,(%eax)
    1020:	57                   	push   %edi
    1021:	09 00                	or     %eax,(%eax)
    1023:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
    1029:	ff                   	(bad)  
    102a:	ff                   	(bad)  
    102b:	ff 8f 09 00 00 40    	decl   0x40000009(%edi)
    1031:	00 00                	add    %al,(%eax)
    1033:	00 02                	add    %al,(%edx)
    1035:	00 00                	add    %al,(%eax)
    1037:	00 9c 09 00 00 40 00 	add    %bl,0x400000(%ecx,%ecx,1)
    103e:	00 00                	add    %al,(%eax)
    1040:	03 00                	add    (%eax),%eax
    1042:	00 00                	add    %al,(%eax)
    1044:	00 00                	add    %al,(%eax)
    1046:	00 00                	add    %al,(%eax)
    1048:	c0 00 00             	rolb   $0x0,(%eax)
	...
    1053:	00 e0                	add    %ah,%al
    1055:	00 00                	add    %al,(%eax)
    1057:	00 62 00             	add    %ah,0x0(%edx)
    105a:	00 00                	add    %al,(%eax)
    105c:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    105d:	09 00                	or     %eax,(%eax)
    105f:	00 24 00             	add    %ah,(%eax,%eax,1)
    1062:	00 00                	add    %al,(%eax)
    1064:	fc                   	cld    
    1065:	03 28                	add    (%eax),%ebp
    1067:	00 b4 09 00 00 a0 00 	add    %dh,0xa00000(%ecx,%ecx,1)
    106e:	00 00                	add    %al,(%eax)
    1070:	08 00                	or     %al,(%eax)
    1072:	00 00                	add    %al,(%eax)
    1074:	0c 09                	or     $0x9,%al
    1076:	00 00                	add    %al,(%eax)
    1078:	a0 00 00 00 0c       	mov    0xc000000,%al
    107d:	00 00                	add    %al,(%eax)
    107f:	00 00                	add    %al,(%eax)
    1081:	00 00                	add    %al,(%eax)
    1083:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
	...
    108f:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    1093:	00 01                	add    %al,(%ecx)
    1095:	00 00                	add    %al,(%eax)
    1097:	00 00                	add    %al,(%eax)
    1099:	00 00                	add    %al,(%eax)
    109b:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    109f:	00 03                	add    %al,(%ebx)
    10a1:	00 00                	add    %al,(%eax)
    10a3:	00 00                	add    %al,(%eax)
    10a5:	00 00                	add    %al,(%eax)
    10a7:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    10ab:	00 05 00 00 00 00    	add    %al,0x0
    10b1:	00 00                	add    %al,(%eax)
    10b3:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    10b7:	00 0a                	add    %cl,(%edx)
    10b9:	00 00                	add    %al,(%eax)
    10bb:	00 00                	add    %al,(%eax)
    10bd:	00 00                	add    %al,(%eax)
    10bf:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    10c3:	00 10                	add    %dl,(%eax)
    10c5:	00 00                	add    %al,(%eax)
    10c7:	00 00                	add    %al,(%eax)
    10c9:	00 00                	add    %al,(%eax)
    10cb:	00 44 00 31          	add    %al,0x31(%eax,%eax,1)
    10cf:	00 13                	add    %dl,(%ebx)
    10d1:	00 00                	add    %al,(%eax)
    10d3:	00 00                	add    %al,(%eax)
    10d5:	00 00                	add    %al,(%eax)
    10d7:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    10db:	00 18                	add    %bl,(%eax)
    10dd:	00 00                	add    %al,(%eax)
    10df:	00 00                	add    %al,(%eax)
    10e1:	00 00                	add    %al,(%eax)
    10e3:	00 44 00 34          	add    %al,0x34(%eax,%eax,1)
    10e7:	00 1b                	add    %bl,(%ebx)
    10e9:	00 00                	add    %al,(%eax)
    10eb:	00 00                	add    %al,(%eax)
    10ed:	00 00                	add    %al,(%eax)
    10ef:	00 44 00 35          	add    %al,0x35(%eax,%eax,1)
    10f3:	00 1e                	add    %bl,(%esi)
    10f5:	00 00                	add    %al,(%eax)
    10f7:	00 00                	add    %al,(%eax)
    10f9:	00 00                	add    %al,(%eax)
    10fb:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    10ff:	00 25 00 00 00 00    	add    %ah,0x0
    1105:	00 00                	add    %al,(%eax)
    1107:	00 44 00 2a          	add    %al,0x2a(%eax,%eax,1)
    110b:	00 2c 00             	add    %ch,(%eax,%eax,1)
    110e:	00 00                	add    %al,(%eax)
    1110:	00 00                	add    %al,(%eax)
    1112:	00 00                	add    %al,(%eax)
    1114:	44                   	inc    %esp
    1115:	00 3e                	add    %bh,(%esi)
    1117:	00 38                	add    %bh,(%eax)
    1119:	00 00                	add    %al,(%eax)
    111b:	00 00                	add    %al,(%eax)
    111d:	00 00                	add    %al,(%eax)
    111f:	00 44 00 2d          	add    %al,0x2d(%eax,%eax,1)
    1123:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1126:	00 00                	add    %al,(%eax)
    1128:	00 00                	add    %al,(%eax)
    112a:	00 00                	add    %al,(%eax)
    112c:	44                   	inc    %esp
    112d:	00 3e                	add    %bh,(%esi)
    112f:	00 3f                	add    %bh,(%edi)
    1131:	00 00                	add    %al,(%eax)
    1133:	00 00                	add    %al,(%eax)
    1135:	00 00                	add    %al,(%eax)
    1137:	00 44 00 3a          	add    %al,0x3a(%eax,%eax,1)
    113b:	00 41 00             	add    %al,0x0(%ecx)
    113e:	00 00                	add    %al,(%eax)
    1140:	00 00                	add    %al,(%eax)
    1142:	00 00                	add    %al,(%eax)
    1144:	44                   	inc    %esp
    1145:	00 41 00             	add    %al,0x0(%ecx)
    1148:	43                   	inc    %ebx
    1149:	00 00                	add    %al,(%eax)
    114b:	00 00                	add    %al,(%eax)
    114d:	00 00                	add    %al,(%eax)
    114f:	00 44 00 43          	add    %al,0x43(%eax,%eax,1)
    1153:	00 4a 00             	add    %cl,0x0(%edx)
    1156:	00 00                	add    %al,(%eax)
    1158:	00 00                	add    %al,(%eax)
    115a:	00 00                	add    %al,(%eax)
    115c:	44                   	inc    %esp
    115d:	00 44 00 4b          	add    %al,0x4b(%eax,%eax,1)
    1161:	00 00                	add    %al,(%eax)
    1163:	00 00                	add    %al,(%eax)
    1165:	00 00                	add    %al,(%eax)
    1167:	00 44 00 47          	add    %al,0x47(%eax,%eax,1)
    116b:	00 55 00             	add    %dl,0x0(%ebp)
    116e:	00 00                	add    %al,(%eax)
    1170:	00 00                	add    %al,(%eax)
    1172:	00 00                	add    %al,(%eax)
    1174:	44                   	inc    %esp
    1175:	00 4a 00             	add    %cl,0x0(%edx)
    1178:	5a                   	pop    %edx
    1179:	00 00                	add    %al,(%eax)
    117b:	00 c1                	add    %al,%cl
    117d:	09 00                	or     %eax,(%eax)
    117f:	00 80 00 00 00 e2    	add    %al,-0x1e000000(%eax)
    1185:	ff                   	(bad)  
    1186:	ff                   	(bad)  
    1187:	ff 9c 09 00 00 40 00 	lcall  *0x400000(%ecx,%ecx,1)
    118e:	00 00                	add    %al,(%eax)
    1190:	02 00                	add    (%eax),%al
    1192:	00 00                	add    %al,(%eax)
    1194:	00 00                	add    %al,(%eax)
    1196:	00 00                	add    %al,(%eax)
    1198:	c0 00 00             	rolb   $0x0,(%eax)
    119b:	00 00                	add    %al,(%eax)
    119d:	00 00                	add    %al,(%eax)
    119f:	00 8f 09 00 00 40    	add    %cl,0x40000009(%edi)
    11a5:	00 00                	add    %al,(%eax)
    11a7:	00 01                	add    %al,(%ecx)
    11a9:	00 00                	add    %al,(%eax)
    11ab:	00 00                	add    %al,(%eax)
    11ad:	00 00                	add    %al,(%eax)
    11af:	00 c0                	add    %al,%al
    11b1:	00 00                	add    %al,(%eax)
    11b3:	00 2c 00             	add    %ch,(%eax,%eax,1)
    11b6:	00 00                	add    %al,(%eax)
    11b8:	00 00                	add    %al,(%eax)
    11ba:	00 00                	add    %al,(%eax)
    11bc:	e0 00                	loopne 11be <bootmain-0x27ee42>
    11be:	00 00                	add    %al,(%eax)
    11c0:	38 00                	cmp    %al,(%eax)
    11c2:	00 00                	add    %al,(%eax)
    11c4:	8f 09                	(bad)  
    11c6:	00 00                	add    %al,(%eax)
    11c8:	40                   	inc    %eax
    11c9:	00 00                	add    %al,(%eax)
    11cb:	00 01                	add    %al,(%ecx)
    11cd:	00 00                	add    %al,(%eax)
    11cf:	00 00                	add    %al,(%eax)
    11d1:	00 00                	add    %al,(%eax)
    11d3:	00 c0                	add    %al,%al
    11d5:	00 00                	add    %al,(%eax)
    11d7:	00 3c 00             	add    %bh,(%eax,%eax,1)
    11da:	00 00                	add    %al,(%eax)
    11dc:	00 00                	add    %al,(%eax)
    11de:	00 00                	add    %al,(%eax)
    11e0:	e0 00                	loopne 11e2 <bootmain-0x27ee1e>
    11e2:	00 00                	add    %al,(%eax)
    11e4:	3f                   	aas    
    11e5:	00 00                	add    %al,(%eax)
    11e7:	00 00                	add    %al,(%eax)
    11e9:	00 00                	add    %al,(%eax)
    11eb:	00 e0                	add    %ah,%al
    11ed:	00 00                	add    %al,(%eax)
    11ef:	00 62 00             	add    %ah,0x0(%edx)
    11f2:	00 00                	add    %al,(%eax)
    11f4:	e4 09                	in     $0x9,%al
    11f6:	00 00                	add    %al,(%eax)
    11f8:	24 00                	and    $0x0,%al
    11fa:	00 00                	add    %al,(%eax)
    11fc:	5e                   	pop    %esi
    11fd:	04 28                	add    $0x28,%al
    11ff:	00 f4                	add    %dh,%ah
    1201:	09 00                	or     %eax,(%eax)
    1203:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1209:	00 00                	add    %al,(%eax)
    120b:	00 ff                	add    %bh,%bh
    120d:	09 00                	or     %eax,(%eax)
    120f:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    1215:	00 00                	add    %al,(%eax)
    1217:	00 00                	add    %al,(%eax)
    1219:	00 00                	add    %al,(%eax)
    121b:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
	...
    1227:	00 44 00 51          	add    %al,0x51(%eax,%eax,1)
    122b:	00 09                	add    %cl,(%ecx)
    122d:	00 00                	add    %al,(%eax)
    122f:	00 00                	add    %al,(%eax)
    1231:	00 00                	add    %al,(%eax)
    1233:	00 44 00 53          	add    %al,0x53(%eax,%eax,1)
    1237:	00 0c 00             	add    %cl,(%eax,%eax,1)
    123a:	00 00                	add    %al,(%eax)
    123c:	00 00                	add    %al,(%eax)
    123e:	00 00                	add    %al,(%eax)
    1240:	44                   	inc    %esp
    1241:	00 56 00             	add    %dl,0x0(%esi)
    1244:	0f 00 00             	sldt   (%eax)
    1247:	00 00                	add    %al,(%eax)
    1249:	00 00                	add    %al,(%eax)
    124b:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    124f:	00 1f                	add    %bl,(%edi)
    1251:	00 00                	add    %al,(%eax)
    1253:	00 00                	add    %al,(%eax)
    1255:	00 00                	add    %al,(%eax)
    1257:	00 44 00 5a          	add    %al,0x5a(%eax,%eax,1)
    125b:	00 21                	add    %ah,(%ecx)
    125d:	00 00                	add    %al,(%eax)
    125f:	00 00                	add    %al,(%eax)
    1261:	00 00                	add    %al,(%eax)
    1263:	00 44 00 58          	add    %al,0x58(%eax,%eax,1)
    1267:	00 24 00             	add    %ah,(%eax,%eax,1)
    126a:	00 00                	add    %al,(%eax)
    126c:	00 00                	add    %al,(%eax)
    126e:	00 00                	add    %al,(%eax)
    1270:	44                   	inc    %esp
    1271:	00 5a 00             	add    %bl,0x0(%edx)
    1274:	26 00 00             	add    %al,%es:(%eax)
    1277:	00 00                	add    %al,(%eax)
    1279:	00 00                	add    %al,(%eax)
    127b:	00 44 00 5b          	add    %al,0x5b(%eax,%eax,1)
    127f:	00 29                	add    %ch,(%ecx)
    1281:	00 00                	add    %al,(%eax)
    1283:	00 00                	add    %al,(%eax)
    1285:	00 00                	add    %al,(%eax)
    1287:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    128b:	00 2b                	add    %ch,(%ebx)
    128d:	00 00                	add    %al,(%eax)
    128f:	00 00                	add    %al,(%eax)
    1291:	00 00                	add    %al,(%eax)
    1293:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    1297:	00 3a                	add    %bh,(%edx)
    1299:	00 00                	add    %al,(%eax)
    129b:	00 00                	add    %al,(%eax)
    129d:	00 00                	add    %al,(%eax)
    129f:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    12a3:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    12a7:	00 00                	add    %al,(%eax)
    12a9:	00 00                	add    %al,(%eax)
    12ab:	00 44 00 62          	add    %al,0x62(%eax,%eax,1)
    12af:	00 52 00             	add    %dl,0x0(%edx)
    12b2:	00 00                	add    %al,(%eax)
    12b4:	00 00                	add    %al,(%eax)
    12b6:	00 00                	add    %al,(%eax)
    12b8:	44                   	inc    %esp
    12b9:	00 63 00             	add    %ah,0x0(%ebx)
    12bc:	59                   	pop    %ecx
    12bd:	00 00                	add    %al,(%eax)
    12bf:	00 00                	add    %al,(%eax)
    12c1:	00 00                	add    %al,(%eax)
    12c3:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    12c7:	00 6b 00             	add    %ch,0x0(%ebx)
    12ca:	00 00                	add    %al,(%eax)
    12cc:	00 00                	add    %al,(%eax)
    12ce:	00 00                	add    %al,(%eax)
    12d0:	44                   	inc    %esp
    12d1:	00 63 00             	add    %ah,0x0(%ebx)
    12d4:	71 00                	jno    12d6 <bootmain-0x27ed2a>
    12d6:	00 00                	add    %al,(%eax)
    12d8:	00 00                	add    %al,(%eax)
    12da:	00 00                	add    %al,(%eax)
    12dc:	44                   	inc    %esp
    12dd:	00 64 00 78          	add    %ah,0x78(%eax,%eax,1)
    12e1:	00 00                	add    %al,(%eax)
    12e3:	00 00                	add    %al,(%eax)
    12e5:	00 00                	add    %al,(%eax)
    12e7:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    12eb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    12f1:	00 00                	add    %al,(%eax)
    12f3:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    12f7:	00 87 00 00 00 00    	add    %al,0x0(%edi)
    12fd:	00 00                	add    %al,(%eax)
    12ff:	00 44 00 60          	add    %al,0x60(%eax,%eax,1)
    1303:	00 8d 00 00 00 00    	add    %cl,0x0(%ebp)
    1309:	00 00                	add    %al,(%eax)
    130b:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    130f:	00 8f 00 00 00 00    	add    %cl,0x0(%edi)
    1315:	00 00                	add    %al,(%eax)
    1317:	00 44 00 68          	add    %al,0x68(%eax,%eax,1)
    131b:	00 92 00 00 00 00    	add    %dl,0x0(%edx)
    1321:	00 00                	add    %al,(%eax)
    1323:	00 44 00 69          	add    %al,0x69(%eax,%eax,1)
    1327:	00 95 00 00 00 00    	add    %dl,0x0(%ebp)
    132d:	00 00                	add    %al,(%eax)
    132f:	00 44 00 6e          	add    %al,0x6e(%eax,%eax,1)
    1333:	00 9f 00 00 00 00    	add    %bl,0x0(%edi)
    1339:	00 00                	add    %al,(%eax)
    133b:	00 44 00 70          	add    %al,0x70(%eax,%eax,1)
    133f:	00 a2 00 00 00 0d    	add    %ah,0xd000000(%edx)
    1345:	0a 00                	or     (%eax),%al
    1347:	00 40 00             	add    %al,0x0(%eax)
    134a:	00 00                	add    %al,(%eax)
    134c:	06                   	push   %es
    134d:	00 00                	add    %al,(%eax)
    134f:	00 20                	add    %ah,(%eax)
    1351:	0a 00                	or     (%eax),%al
    1353:	00 80 00 00 00 f6    	add    %al,-0xa000000(%eax)
    1359:	ff                   	(bad)  
    135a:	ff                   	(bad)  
    135b:	ff 2e                	ljmp   *(%esi)
    135d:	0a 00                	or     (%eax),%al
    135f:	00 40 00             	add    %al,0x0(%eax)
    1362:	00 00                	add    %al,(%eax)
    1364:	03 00                	add    (%eax),%eax
    1366:	00 00                	add    %al,(%eax)
    1368:	00 00                	add    %al,(%eax)
    136a:	00 00                	add    %al,(%eax)
    136c:	c0 00 00             	rolb   $0x0,(%eax)
	...
    1377:	00 e0                	add    %ah,%al
    1379:	00 00                	add    %al,(%eax)
    137b:	00 aa 00 00 00 39    	add    %ch,0x39000000(%edx)
    1381:	0a 00                	or     (%eax),%al
    1383:	00 24 00             	add    %ah,(%eax,%eax,1)
    1386:	00 00                	add    %al,(%eax)
    1388:	08 05 28 00 ce 08    	or     %al,0x8ce0028
    138e:	00 00                	add    %al,(%eax)
    1390:	a0 00 00 00 08       	mov    0x8000000,%al
    1395:	00 00                	add    %al,(%eax)
    1397:	00 9b 07 00 00 a0    	add    %bl,-0x5ffffff9(%ebx)
    139d:	00 00                	add    %al,(%eax)
    139f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    13a2:	00 00                	add    %al,(%eax)
    13a4:	4a                   	dec    %edx
    13a5:	0a 00                	or     (%eax),%al
    13a7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    13ad:	00 00                	add    %al,(%eax)
    13af:	00 53 0a             	add    %dl,0xa(%ebx)
    13b2:	00 00                	add    %al,(%eax)
    13b4:	a0 00 00 00 14       	mov    0x14000000,%al
    13b9:	00 00                	add    %al,(%eax)
    13bb:	00 9b 06 00 00 a0    	add    %bl,-0x5ffffffa(%ebx)
    13c1:	00 00                	add    %al,(%eax)
    13c3:	00 18                	add    %bl,(%eax)
    13c5:	00 00                	add    %al,(%eax)
    13c7:	00 5c 0a 00          	add    %bl,0x0(%edx,%ecx,1)
    13cb:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    13d1:	00 00                	add    %al,(%eax)
    13d3:	00 00                	add    %al,(%eax)
    13d5:	00 00                	add    %al,(%eax)
    13d7:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
	...
    13e3:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    13e7:	00 01                	add    %al,(%ecx)
    13e9:	00 00                	add    %al,(%eax)
    13eb:	00 00                	add    %al,(%eax)
    13ed:	00 00                	add    %al,(%eax)
    13ef:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    13f3:	00 03                	add    %al,(%ebx)
    13f5:	00 00                	add    %al,(%eax)
    13f7:	00 00                	add    %al,(%eax)
    13f9:	00 00                	add    %al,(%eax)
    13fb:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    13ff:	00 06                	add    %al,(%esi)
    1401:	00 00                	add    %al,(%eax)
    1403:	00 00                	add    %al,(%eax)
    1405:	00 00                	add    %al,(%eax)
    1407:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    140b:	00 0b                	add    %cl,(%ebx)
    140d:	00 00                	add    %al,(%eax)
    140f:	00 00                	add    %al,(%eax)
    1411:	00 00                	add    %al,(%eax)
    1413:	00 44 00 94          	add    %al,-0x6c(%eax,%eax,1)
    1417:	00 10                	add    %dl,(%eax)
    1419:	00 00                	add    %al,(%eax)
    141b:	00 00                	add    %al,(%eax)
    141d:	00 00                	add    %al,(%eax)
    141f:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    1423:	00 23                	add    %ah,(%ebx)
    1425:	00 00                	add    %al,(%eax)
    1427:	00 00                	add    %al,(%eax)
    1429:	00 00                	add    %al,(%eax)
    142b:	00 44 00 9a          	add    %al,-0x66(%eax,%eax,1)
    142f:	00 26                	add    %ah,(%esi)
    1431:	00 00                	add    %al,(%eax)
    1433:	00 00                	add    %al,(%eax)
    1435:	00 00                	add    %al,(%eax)
    1437:	00 44 00 9c          	add    %al,-0x64(%eax,%eax,1)
    143b:	00 28                	add    %ch,(%eax)
    143d:	00 00                	add    %al,(%eax)
    143f:	00 00                	add    %al,(%eax)
    1441:	00 00                	add    %al,(%eax)
    1443:	00 44 00 9e          	add    %al,-0x62(%eax,%eax,1)
    1447:	00 34 00             	add    %dh,(%eax,%eax,1)
    144a:	00 00                	add    %al,(%eax)
    144c:	00 00                	add    %al,(%eax)
    144e:	00 00                	add    %al,(%eax)
    1450:	44                   	inc    %esp
    1451:	00 9a 00 3a 00 00    	add    %bl,0x3a00(%edx)
    1457:	00 00                	add    %al,(%eax)
    1459:	00 00                	add    %al,(%eax)
    145b:	00 44 00 97          	add    %al,-0x69(%eax,%eax,1)
    145f:	00 40 00             	add    %al,0x0(%eax)
    1462:	00 00                	add    %al,(%eax)
    1464:	00 00                	add    %al,(%eax)
    1466:	00 00                	add    %al,(%eax)
    1468:	44                   	inc    %esp
    1469:	00 aa 00 49 00 00    	add    %ch,0x4900(%edx)
    146f:	00 68 0a             	add    %ch,0xa(%eax)
    1472:	00 00                	add    %al,(%eax)
    1474:	40                   	inc    %eax
    1475:	00 00                	add    %al,(%eax)
    1477:	00 02                	add    %al,(%edx)
    1479:	00 00                	add    %al,(%eax)
    147b:	00 73 0a             	add    %dh,0xa(%ebx)
    147e:	00 00                	add    %al,(%eax)
    1480:	40                   	inc    %eax
    1481:	00 00                	add    %al,(%eax)
    1483:	00 01                	add    %al,(%ecx)
    1485:	00 00                	add    %al,(%eax)
    1487:	00 00                	add    %al,(%eax)
    1489:	00 00                	add    %al,(%eax)
    148b:	00 c0                	add    %al,%al
	...
    1495:	00 00                	add    %al,(%eax)
    1497:	00 e0                	add    %ah,%al
    1499:	00 00                	add    %al,(%eax)
    149b:	00 51 00             	add    %dl,0x0(%ecx)
    149e:	00 00                	add    %al,(%eax)
    14a0:	7e 0a                	jle    14ac <bootmain-0x27eb54>
    14a2:	00 00                	add    %al,(%eax)
    14a4:	24 00                	and    $0x0,%al
    14a6:	00 00                	add    %al,(%eax)
    14a8:	59                   	pop    %ecx
    14a9:	05 28 00 ce 08       	add    $0x8ce0028,%eax
    14ae:	00 00                	add    %al,(%eax)
    14b0:	a0 00 00 00 08       	mov    0x8000000,%al
    14b5:	00 00                	add    %al,(%eax)
    14b7:	00 9b 07 00 00 a0    	add    %bl,-0x5ffffff9(%ebx)
    14bd:	00 00                	add    %al,(%eax)
    14bf:	00 0c 00             	add    %cl,(%eax,%eax,1)
    14c2:	00 00                	add    %al,(%eax)
    14c4:	4a                   	dec    %edx
    14c5:	0a 00                	or     (%eax),%al
    14c7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    14cd:	00 00                	add    %al,(%eax)
    14cf:	00 53 0a             	add    %dl,0xa(%ebx)
    14d2:	00 00                	add    %al,(%eax)
    14d4:	a0 00 00 00 14       	mov    0x14000000,%al
    14d9:	00 00                	add    %al,(%eax)
    14db:	00 9b 06 00 00 a0    	add    %bl,-0x5ffffffa(%ebx)
    14e1:	00 00                	add    %al,(%eax)
    14e3:	00 18                	add    %bl,(%eax)
    14e5:	00 00                	add    %al,(%eax)
    14e7:	00 5c 0a 00          	add    %bl,0x0(%edx,%ecx,1)
    14eb:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    14f1:	00 00                	add    %al,(%eax)
    14f3:	00 00                	add    %al,(%eax)
    14f5:	00 00                	add    %al,(%eax)
    14f7:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
	...
    1503:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1507:	00 08                	add    %cl,(%eax)
    1509:	00 00                	add    %al,(%eax)
    150b:	00 00                	add    %al,(%eax)
    150d:	00 00                	add    %al,(%eax)
    150f:	00 44 00 73          	add    %al,0x73(%eax,%eax,1)
    1513:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1516:	00 00                	add    %al,(%eax)
    1518:	00 00                	add    %al,(%eax)
    151a:	00 00                	add    %al,(%eax)
    151c:	44                   	inc    %esp
    151d:	00 73 00             	add    %dh,0x0(%ebx)
    1520:	0d 00 00 00 00       	or     $0x0,%eax
    1525:	00 00                	add    %al,(%eax)
    1527:	00 44 00 75          	add    %al,0x75(%eax,%eax,1)
    152b:	00 10                	add    %dl,(%eax)
    152d:	00 00                	add    %al,(%eax)
    152f:	00 00                	add    %al,(%eax)
    1531:	00 00                	add    %al,(%eax)
    1533:	00 44 00 77          	add    %al,0x77(%eax,%eax,1)
    1537:	00 1a                	add    %bl,(%edx)
    1539:	00 00                	add    %al,(%eax)
    153b:	00 00                	add    %al,(%eax)
    153d:	00 00                	add    %al,(%eax)
    153f:	00 44 00 7a          	add    %al,0x7a(%eax,%eax,1)
    1543:	00 1e                	add    %bl,(%esi)
    1545:	00 00                	add    %al,(%eax)
    1547:	00 00                	add    %al,(%eax)
    1549:	00 00                	add    %al,(%eax)
    154b:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    154f:	00 23                	add    %ah,(%ebx)
    1551:	00 00                	add    %al,(%eax)
    1553:	00 00                	add    %al,(%eax)
    1555:	00 00                	add    %al,(%eax)
    1557:	00 44 00 80          	add    %al,-0x80(%eax,%eax,1)
    155b:	00 2f                	add    %ch,(%edi)
    155d:	00 00                	add    %al,(%eax)
    155f:	00 00                	add    %al,(%eax)
    1561:	00 00                	add    %al,(%eax)
    1563:	00 44 00 7f          	add    %al,0x7f(%eax,%eax,1)
    1567:	00 32                	add    %dh,(%edx)
    1569:	00 00                	add    %al,(%eax)
    156b:	00 00                	add    %al,(%eax)
    156d:	00 00                	add    %al,(%eax)
    156f:	00 44 00 81          	add    %al,-0x7f(%eax,%eax,1)
    1573:	00 3d 00 00 00 00    	add    %bh,0x0
    1579:	00 00                	add    %al,(%eax)
    157b:	00 44 00 84          	add    %al,-0x7c(%eax,%eax,1)
    157f:	00 48 00             	add    %cl,0x0(%eax)
    1582:	00 00                	add    %al,(%eax)
    1584:	00 00                	add    %al,(%eax)
    1586:	00 00                	add    %al,(%eax)
    1588:	44                   	inc    %esp
    1589:	00 85 00 4b 00 00    	add    %al,0x4b00(%ebp)
    158f:	00 00                	add    %al,(%eax)
    1591:	00 00                	add    %al,(%eax)
    1593:	00 44 00 88          	add    %al,-0x78(%eax,%eax,1)
    1597:	00 53 00             	add    %dl,0x0(%ebx)
    159a:	00 00                	add    %al,(%eax)
    159c:	00 00                	add    %al,(%eax)
    159e:	00 00                	add    %al,(%eax)
    15a0:	44                   	inc    %esp
    15a1:	00 87 00 55 00 00    	add    %al,0x5500(%edi)
    15a7:	00 00                	add    %al,(%eax)
    15a9:	00 00                	add    %al,(%eax)
    15ab:	00 44 00 8e          	add    %al,-0x72(%eax,%eax,1)
    15af:	00 57 00             	add    %dl,0x0(%edi)
    15b2:	00 00                	add    %al,(%eax)
    15b4:	00 00                	add    %al,(%eax)
    15b6:	00 00                	add    %al,(%eax)
    15b8:	44                   	inc    %esp
    15b9:	00 91 00 5c 00 00    	add    %dl,0x5c00(%ecx)
    15bf:	00 a5 08 00 00 40    	add    %ah,0x40000008(%ebp)
    15c5:	00 00                	add    %al,(%eax)
    15c7:	00 03                	add    %al,(%ebx)
    15c9:	00 00                	add    %al,(%eax)
    15cb:	00 25 09 00 00 40    	add    %ah,0x40000009
    15d1:	00 00                	add    %al,(%eax)
    15d3:	00 07                	add    %al,(%edi)
    15d5:	00 00                	add    %al,(%eax)
    15d7:	00 8c 0a 00 00 24 00 	add    %cl,0x240000(%edx,%ecx,1)
    15de:	00 00                	add    %al,(%eax)
    15e0:	bd 05 28 00 9f       	mov    $0x9f002805,%ebp
    15e5:	0a 00                	or     (%eax),%al
    15e7:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    15ed:	00 00                	add    %al,(%eax)
    15ef:	00 4a 0a             	add    %cl,0xa(%edx)
    15f2:	00 00                	add    %al,(%eax)
    15f4:	a0 00 00 00 0c       	mov    0xc000000,%al
    15f9:	00 00                	add    %al,(%eax)
    15fb:	00 00                	add    %al,(%eax)
    15fd:	00 00                	add    %al,(%eax)
    15ff:	00 44 00 05          	add    %al,0x5(%eax,%eax,1)
	...
    160b:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    160f:	00 07                	add    %al,(%edi)
    1611:	00 00                	add    %al,(%eax)
    1613:	00 00                	add    %al,(%eax)
    1615:	00 00                	add    %al,(%eax)
    1617:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    161b:	00 18                	add    %bl,(%eax)
    161d:	00 00                	add    %al,(%eax)
    161f:	00 00                	add    %al,(%eax)
    1621:	00 00                	add    %al,(%eax)
    1623:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1627:	00 35 00 00 00 a8    	add    %dh,0xa8000000
    162d:	0a 00                	or     (%eax),%al
    162f:	00 80 00 00 00 e2    	add    %al,-0x1e000000(%eax)
    1635:	ff                   	(bad)  
    1636:	ff                   	(bad)  
    1637:	ff 00                	incl   (%eax)
    1639:	00 00                	add    %al,(%eax)
    163b:	00 c0                	add    %al,%al
	...
    1645:	00 00                	add    %al,(%eax)
    1647:	00 e0                	add    %ah,%al
    1649:	00 00                	add    %al,(%eax)
    164b:	00 3a                	add    %bh,(%edx)
    164d:	00 00                	add    %al,(%eax)
    164f:	00 b4 0a 00 00 24 00 	add    %dh,0x240000(%edx,%ecx,1)
    1656:	00 00                	add    %al,(%eax)
    1658:	f7 05 28 00 ce 08 00 	testl  $0xa00000,0x8ce0028
    165f:	00 a0 00 
    1662:	00 00                	add    %al,(%eax)
    1664:	08 00                	or     %al,(%eax)
    1666:	00 00                	add    %al,(%eax)
    1668:	9b                   	fwait
    1669:	07                   	pop    %es
    166a:	00 00                	add    %al,(%eax)
    166c:	a0 00 00 00 0c       	mov    0xc000000,%al
    1671:	00 00                	add    %al,(%eax)
    1673:	00 4a 0a             	add    %cl,0xa(%edx)
    1676:	00 00                	add    %al,(%eax)
    1678:	a0 00 00 00 10       	mov    0x10000000,%al
    167d:	00 00                	add    %al,(%eax)
    167f:	00 53 0a             	add    %dl,0xa(%ebx)
    1682:	00 00                	add    %al,(%eax)
    1684:	a0 00 00 00 14       	mov    0x14000000,%al
    1689:	00 00                	add    %al,(%eax)
    168b:	00 9b 06 00 00 a0    	add    %bl,-0x5ffffffa(%ebx)
    1691:	00 00                	add    %al,(%eax)
    1693:	00 18                	add    %bl,(%eax)
    1695:	00 00                	add    %al,(%eax)
    1697:	00 c6                	add    %al,%dh
    1699:	0a 00                	or     (%eax),%al
    169b:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    16a1:	00 00                	add    %al,(%eax)
    16a3:	00 00                	add    %al,(%eax)
    16a5:	00 00                	add    %al,(%eax)
    16a7:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
	...
    16b3:	00 44 00 c6          	add    %al,-0x3a(%eax,%eax,1)
    16b7:	00 10                	add    %dl,(%eax)
    16b9:	00 00                	add    %al,(%eax)
    16bb:	00 00                	add    %al,(%eax)
    16bd:	00 00                	add    %al,(%eax)
    16bf:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    16c3:	00 1b                	add    %bl,(%ebx)
    16c5:	00 00                	add    %al,(%eax)
    16c7:	00 00                	add    %al,(%eax)
    16c9:	00 00                	add    %al,(%eax)
    16cb:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    16cf:	00 20                	add    %ah,(%eax)
    16d1:	00 00                	add    %al,(%eax)
    16d3:	00 00                	add    %al,(%eax)
    16d5:	00 00                	add    %al,(%eax)
    16d7:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    16db:	00 31                	add    %dh,(%ecx)
    16dd:	00 00                	add    %al,(%eax)
    16df:	00 00                	add    %al,(%eax)
    16e1:	00 00                	add    %al,(%eax)
    16e3:	00 44 00 cf          	add    %al,-0x31(%eax,%eax,1)
    16e7:	00 33                	add    %dh,(%ebx)
    16e9:	00 00                	add    %al,(%eax)
    16eb:	00 00                	add    %al,(%eax)
    16ed:	00 00                	add    %al,(%eax)
    16ef:	00 44 00 d2          	add    %al,-0x2e(%eax,%eax,1)
    16f3:	00 38                	add    %bh,(%eax)
    16f5:	00 00                	add    %al,(%eax)
    16f7:	00 00                	add    %al,(%eax)
    16f9:	00 00                	add    %al,(%eax)
    16fb:	00 44 00 cd          	add    %al,-0x33(%eax,%eax,1)
    16ff:	00 3b                	add    %bh,(%ebx)
    1701:	00 00                	add    %al,(%eax)
    1703:	00 00                	add    %al,(%eax)
    1705:	00 00                	add    %al,(%eax)
    1707:	00 44 00 ca          	add    %al,-0x36(%eax,%eax,1)
    170b:	00 41 00             	add    %al,0x0(%ecx)
    170e:	00 00                	add    %al,(%eax)
    1710:	00 00                	add    %al,(%eax)
    1712:	00 00                	add    %al,(%eax)
    1714:	44                   	inc    %esp
    1715:	00 de                	add    %bl,%dh
    1717:	00 4a 00             	add    %cl,0x0(%edx)
    171a:	00 00                	add    %al,(%eax)
    171c:	68 0a 00 00 40       	push   $0x4000000a
    1721:	00 00                	add    %al,(%eax)
    1723:	00 02                	add    %al,(%edx)
    1725:	00 00                	add    %al,(%eax)
    1727:	00 73 0a             	add    %dh,0xa(%ebx)
    172a:	00 00                	add    %al,(%eax)
    172c:	40                   	inc    %eax
    172d:	00 00                	add    %al,(%eax)
    172f:	00 00                	add    %al,(%eax)
    1731:	00 00                	add    %al,(%eax)
    1733:	00 b1 06 00 00 40    	add    %dh,0x40000006(%ecx)
    1739:	00 00                	add    %al,(%eax)
    173b:	00 03                	add    %al,(%ebx)
    173d:	00 00                	add    %al,(%eax)
    173f:	00 00                	add    %al,(%eax)
    1741:	00 00                	add    %al,(%eax)
    1743:	00 c0                	add    %al,%al
	...
    174d:	00 00                	add    %al,(%eax)
    174f:	00 e0                	add    %ah,%al
    1751:	00 00                	add    %al,(%eax)
    1753:	00 50 00             	add    %dl,0x0(%eax)
    1756:	00 00                	add    %al,(%eax)
    1758:	da 0a                	fimull (%edx)
    175a:	00 00                	add    %al,(%eax)
    175c:	24 00                	and    $0x0,%al
    175e:	00 00                	add    %al,(%eax)
    1760:	47                   	inc    %edi
    1761:	06                   	push   %es
    1762:	28 00                	sub    %al,(%eax)
    1764:	ce                   	into   
    1765:	08 00                	or     %al,(%eax)
    1767:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    176d:	00 00                	add    %al,(%eax)
    176f:	00 9b 07 00 00 a0    	add    %bl,-0x5ffffff9(%ebx)
    1775:	00 00                	add    %al,(%eax)
    1777:	00 0c 00             	add    %cl,(%eax,%eax,1)
    177a:	00 00                	add    %al,(%eax)
    177c:	4a                   	dec    %edx
    177d:	0a 00                	or     (%eax),%al
    177f:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1785:	00 00                	add    %al,(%eax)
    1787:	00 53 0a             	add    %dl,0xa(%ebx)
    178a:	00 00                	add    %al,(%eax)
    178c:	a0 00 00 00 14       	mov    0x14000000,%al
    1791:	00 00                	add    %al,(%eax)
    1793:	00 9b 06 00 00 a0    	add    %bl,-0x5ffffffa(%ebx)
    1799:	00 00                	add    %al,(%eax)
    179b:	00 18                	add    %bl,(%eax)
    179d:	00 00                	add    %al,(%eax)
    179f:	00 5c 0a 00          	add    %bl,0x0(%edx,%ecx,1)
    17a3:	00 a0 00 00 00 1c    	add    %ah,0x1c000000(%eax)
    17a9:	00 00                	add    %al,(%eax)
    17ab:	00 00                	add    %al,(%eax)
    17ad:	00 00                	add    %al,(%eax)
    17af:	00 44 00 ad          	add    %al,-0x53(%eax,%eax,1)
	...
    17bb:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    17bf:	00 0c 00             	add    %cl,(%eax,%eax,1)
    17c2:	00 00                	add    %al,(%eax)
    17c4:	00 00                	add    %al,(%eax)
    17c6:	00 00                	add    %al,(%eax)
    17c8:	44                   	inc    %esp
    17c9:	00 af 00 10 00 00    	add    %ch,0x1000(%edi)
    17cf:	00 00                	add    %al,(%eax)
    17d1:	00 00                	add    %al,(%eax)
    17d3:	00 44 00 b1          	add    %al,-0x4f(%eax,%eax,1)
    17d7:	00 1a                	add    %bl,(%edx)
    17d9:	00 00                	add    %al,(%eax)
    17db:	00 00                	add    %al,(%eax)
    17dd:	00 00                	add    %al,(%eax)
    17df:	00 44 00 b4          	add    %al,-0x4c(%eax,%eax,1)
    17e3:	00 1e                	add    %bl,(%esi)
    17e5:	00 00                	add    %al,(%eax)
    17e7:	00 00                	add    %al,(%eax)
    17e9:	00 00                	add    %al,(%eax)
    17eb:	00 44 00 b3          	add    %al,-0x4d(%eax,%eax,1)
    17ef:	00 21                	add    %ah,(%ecx)
    17f1:	00 00                	add    %al,(%eax)
    17f3:	00 00                	add    %al,(%eax)
    17f5:	00 00                	add    %al,(%eax)
    17f7:	00 44 00 b9          	add    %al,-0x47(%eax,%eax,1)
    17fb:	00 25 00 00 00 00    	add    %ah,0x0
    1801:	00 00                	add    %al,(%eax)
    1803:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    1807:	00 2d 00 00 00 00    	add    %ch,0x0
    180d:	00 00                	add    %al,(%eax)
    180f:	00 44 00 bb          	add    %al,-0x45(%eax,%eax,1)
    1813:	00 31                	add    %dh,(%ecx)
    1815:	00 00                	add    %al,(%eax)
    1817:	00 00                	add    %al,(%eax)
    1819:	00 00                	add    %al,(%eax)
    181b:	00 44 00 ba          	add    %al,-0x46(%eax,%eax,1)
    181f:	00 34 00             	add    %dh,(%eax,%eax,1)
    1822:	00 00                	add    %al,(%eax)
    1824:	00 00                	add    %al,(%eax)
    1826:	00 00                	add    %al,(%eax)
    1828:	44                   	inc    %esp
    1829:	00 bb 00 3f 00 00    	add    %bh,0x3f00(%ebx)
    182f:	00 00                	add    %al,(%eax)
    1831:	00 00                	add    %al,(%eax)
    1833:	00 44 00 c0          	add    %al,-0x40(%eax,%eax,1)
    1837:	00 42 00             	add    %al,0x0(%edx)
    183a:	00 00                	add    %al,(%eax)
    183c:	00 00                	add    %al,(%eax)
    183e:	00 00                	add    %al,(%eax)
    1840:	44                   	inc    %esp
    1841:	00 c4                	add    %al,%ah
    1843:	00 47 00             	add    %al,0x0(%edi)
    1846:	00 00                	add    %al,(%eax)
    1848:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    1849:	08 00                	or     %al,(%eax)
    184b:	00 40 00             	add    %al,0x0(%eax)
    184e:	00 00                	add    %al,(%eax)
    1850:	07                   	pop    %es
    1851:	00 00                	add    %al,(%eax)
    1853:	00 25 09 00 00 40    	add    %ah,0x40000009
    1859:	00 00                	add    %al,(%eax)
    185b:	00 06                	add    %al,(%esi)
    185d:	00 00                	add    %al,(%eax)
    185f:	00 00                	add    %al,(%eax)
    1861:	00 00                	add    %al,(%eax)
    1863:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    1867:	00 96 06 28 00 e9    	add    %dl,-0x16ffd7fa(%esi)
    186d:	0a 00                	or     (%eax),%al
    186f:	00 64 00 02          	add    %ah,0x2(%eax,%eax,1)
    1873:	00 96 06 28 00 08    	add    %dl,0x8002806(%esi)
    1879:	00 00                	add    %al,(%eax)
    187b:	00 3c 00             	add    %bh,(%eax,%eax,1)
    187e:	00 00                	add    %al,(%eax)
    1880:	00 00                	add    %al,(%eax)
    1882:	00 00                	add    %al,(%eax)
    1884:	17                   	pop    %ss
    1885:	00 00                	add    %al,(%eax)
    1887:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    188d:	00 00                	add    %al,(%eax)
    188f:	00 41 00             	add    %al,0x0(%ecx)
    1892:	00 00                	add    %al,(%eax)
    1894:	80 00 00             	addb   $0x0,(%eax)
    1897:	00 00                	add    %al,(%eax)
    1899:	00 00                	add    %al,(%eax)
    189b:	00 5b 00             	add    %bl,0x0(%ebx)
    189e:	00 00                	add    %al,(%eax)
    18a0:	80 00 00             	addb   $0x0,(%eax)
    18a3:	00 00                	add    %al,(%eax)
    18a5:	00 00                	add    %al,(%eax)
    18a7:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    18ad:	00 00                	add    %al,(%eax)
    18af:	00 00                	add    %al,(%eax)
    18b1:	00 00                	add    %al,(%eax)
    18b3:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    18b9:	00 00                	add    %al,(%eax)
    18bb:	00 00                	add    %al,(%eax)
    18bd:	00 00                	add    %al,(%eax)
    18bf:	00 e1                	add    %ah,%cl
    18c1:	00 00                	add    %al,(%eax)
    18c3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    18c9:	00 00                	add    %al,(%eax)
    18cb:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    18ce:	00 00                	add    %al,(%eax)
    18d0:	80 00 00             	addb   $0x0,(%eax)
    18d3:	00 00                	add    %al,(%eax)
    18d5:	00 00                	add    %al,(%eax)
    18d7:	00 37                	add    %dh,(%edi)
    18d9:	01 00                	add    %eax,(%eax)
    18db:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    18e1:	00 00                	add    %al,(%eax)
    18e3:	00 5d 01             	add    %bl,0x1(%ebp)
    18e6:	00 00                	add    %al,(%eax)
    18e8:	80 00 00             	addb   $0x0,(%eax)
    18eb:	00 00                	add    %al,(%eax)
    18ed:	00 00                	add    %al,(%eax)
    18ef:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    18f5:	00 00                	add    %al,(%eax)
    18f7:	00 00                	add    %al,(%eax)
    18f9:	00 00                	add    %al,(%eax)
    18fb:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1901:	00 00                	add    %al,(%eax)
    1903:	00 00                	add    %al,(%eax)
    1905:	00 00                	add    %al,(%eax)
    1907:	00 d2                	add    %dl,%dl
    1909:	01 00                	add    %eax,(%eax)
    190b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1911:	00 00                	add    %al,(%eax)
    1913:	00 ec                	add    %ch,%ah
    1915:	01 00                	add    %eax,(%eax)
    1917:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    191d:	00 00                	add    %al,(%eax)
    191f:	00 07                	add    %al,(%edi)
    1921:	02 00                	add    (%eax),%al
    1923:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1929:	00 00                	add    %al,(%eax)
    192b:	00 28                	add    %ch,(%eax)
    192d:	02 00                	add    (%eax),%al
    192f:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1935:	00 00                	add    %al,(%eax)
    1937:	00 47 02             	add    %al,0x2(%edi)
    193a:	00 00                	add    %al,(%eax)
    193c:	80 00 00             	addb   $0x0,(%eax)
    193f:	00 00                	add    %al,(%eax)
    1941:	00 00                	add    %al,(%eax)
    1943:	00 66 02             	add    %ah,0x2(%esi)
    1946:	00 00                	add    %al,(%eax)
    1948:	80 00 00             	addb   $0x0,(%eax)
    194b:	00 00                	add    %al,(%eax)
    194d:	00 00                	add    %al,(%eax)
    194f:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1955:	00 00                	add    %al,(%eax)
    1957:	00 00                	add    %al,(%eax)
    1959:	00 00                	add    %al,(%eax)
    195b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1961:	00 00                	add    %al,(%eax)
    1963:	00 34 72             	add    %dh,(%edx,%esi,2)
    1966:	00 00                	add    %al,(%eax)
    1968:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    1969:	02 00                	add    (%eax),%al
    196b:	00 c2                	add    %al,%dl
    196d:	00 00                	add    %al,(%eax)
    196f:	00 00                	add    %al,(%eax)
    1971:	00 00                	add    %al,(%eax)
    1973:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    1979:	00 00                	add    %al,(%eax)
    197b:	00 37                	add    %dh,(%edi)
    197d:	53                   	push   %ebx
    197e:	00 00                	add    %al,(%eax)
    1980:	f2 0a 00             	repnz or (%eax),%al
    1983:	00 24 00             	add    %ah,(%eax,%eax,1)
    1986:	00 00                	add    %al,(%eax)
    1988:	96                   	xchg   %eax,%esi
    1989:	06                   	push   %es
    198a:	28 00                	sub    %al,(%eax)
    198c:	01 0b                	add    %ecx,(%ebx)
    198e:	00 00                	add    %al,(%eax)
    1990:	a0 00 00 00 08       	mov    0x8000000,%al
    1995:	00 00                	add    %al,(%eax)
    1997:	00 13                	add    %dl,(%ebx)
    1999:	0b 00                	or     (%eax),%eax
    199b:	00 a0 00 00 00 0c    	add    %ah,0xc000000(%eax)
    19a1:	00 00                	add    %al,(%eax)
    19a3:	00 20                	add    %ah,(%eax)
    19a5:	0b 00                	or     (%eax),%eax
    19a7:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    19ad:	00 00                	add    %al,(%eax)
    19af:	00 2c 0b             	add    %ch,(%ebx,%ecx,1)
    19b2:	00 00                	add    %al,(%eax)
    19b4:	a0 00 00 00 14       	mov    0x14000000,%al
    19b9:	00 00                	add    %al,(%eax)
    19bb:	00 00                	add    %al,(%eax)
    19bd:	00 00                	add    %al,(%eax)
    19bf:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
	...
    19cb:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    19cf:	00 0f                	add    %cl,(%edi)
    19d1:	00 00                	add    %al,(%eax)
    19d3:	00 00                	add    %al,(%eax)
    19d5:	00 00                	add    %al,(%eax)
    19d7:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    19db:	00 12                	add    %dl,(%edx)
    19dd:	00 00                	add    %al,(%eax)
    19df:	00 00                	add    %al,(%eax)
    19e1:	00 00                	add    %al,(%eax)
    19e3:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    19e7:	00 1a                	add    %bl,(%edx)
    19e9:	00 00                	add    %al,(%eax)
    19eb:	00 00                	add    %al,(%eax)
    19ed:	00 00                	add    %al,(%eax)
    19ef:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    19f3:	00 20                	add    %ah,(%eax)
    19f5:	00 00                	add    %al,(%eax)
    19f7:	00 00                	add    %al,(%eax)
    19f9:	00 00                	add    %al,(%eax)
    19fb:	00 44 00 0f          	add    %al,0xf(%eax,%eax,1)
    19ff:	00 23                	add    %ah,(%ebx)
    1a01:	00 00                	add    %al,(%eax)
    1a03:	00 00                	add    %al,(%eax)
    1a05:	00 00                	add    %al,(%eax)
    1a07:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1a0b:	00 2d 00 00 00 00    	add    %ch,0x0
    1a11:	00 00                	add    %al,(%eax)
    1a13:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1a17:	00 2f                	add    %ch,(%edi)
    1a19:	00 00                	add    %al,(%eax)
    1a1b:	00 00                	add    %al,(%eax)
    1a1d:	00 00                	add    %al,(%eax)
    1a1f:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1a23:	00 32                	add    %dh,(%edx)
    1a25:	00 00                	add    %al,(%eax)
    1a27:	00 00                	add    %al,(%eax)
    1a29:	00 00                	add    %al,(%eax)
    1a2b:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1a2f:	00 35 00 00 00 00    	add    %dh,0x0
    1a35:	00 00                	add    %al,(%eax)
    1a37:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1a3b:	00 37                	add    %dh,(%edi)
    1a3d:	00 00                	add    %al,(%eax)
    1a3f:	00 00                	add    %al,(%eax)
    1a41:	00 00                	add    %al,(%eax)
    1a43:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1a47:	00 3a                	add    %bh,(%edx)
    1a49:	00 00                	add    %al,(%eax)
    1a4b:	00 00                	add    %al,(%eax)
    1a4d:	00 00                	add    %al,(%eax)
    1a4f:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1a53:	00 40 00             	add    %al,0x0(%eax)
    1a56:	00 00                	add    %al,(%eax)
    1a58:	00 00                	add    %al,(%eax)
    1a5a:	00 00                	add    %al,(%eax)
    1a5c:	44                   	inc    %esp
    1a5d:	00 11                	add    %dl,(%ecx)
    1a5f:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
    1a63:	00 00                	add    %al,(%eax)
    1a65:	00 00                	add    %al,(%eax)
    1a67:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1a6b:	00 46 00             	add    %al,0x0(%esi)
    1a6e:	00 00                	add    %al,(%eax)
    1a70:	00 00                	add    %al,(%eax)
    1a72:	00 00                	add    %al,(%eax)
    1a74:	44                   	inc    %esp
    1a75:	00 11                	add    %dl,(%ecx)
    1a77:	00 49 00             	add    %cl,0x0(%ecx)
    1a7a:	00 00                	add    %al,(%eax)
    1a7c:	00 00                	add    %al,(%eax)
    1a7e:	00 00                	add    %al,(%eax)
    1a80:	44                   	inc    %esp
    1a81:	00 12                	add    %dl,(%edx)
    1a83:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
    1a87:	00 00                	add    %al,(%eax)
    1a89:	00 00                	add    %al,(%eax)
    1a8b:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1a8f:	00 4f 00             	add    %cl,0x0(%edi)
    1a92:	00 00                	add    %al,(%eax)
    1a94:	3a 0b                	cmp    (%ebx),%cl
    1a96:	00 00                	add    %al,(%eax)
    1a98:	40                   	inc    %eax
    1a99:	00 00                	add    %al,(%eax)
    1a9b:	00 00                	add    %al,(%eax)
    1a9d:	00 00                	add    %al,(%eax)
    1a9f:	00 45 0b             	add    %al,0xb(%ebp)
    1aa2:	00 00                	add    %al,(%eax)
    1aa4:	40                   	inc    %eax
    1aa5:	00 00                	add    %al,(%eax)
    1aa7:	00 02                	add    %al,(%edx)
    1aa9:	00 00                	add    %al,(%eax)
    1aab:	00 52 0b             	add    %dl,0xb(%edx)
    1aae:	00 00                	add    %al,(%eax)
    1ab0:	40                   	inc    %eax
    1ab1:	00 00                	add    %al,(%eax)
    1ab3:	00 03                	add    %al,(%ebx)
    1ab5:	00 00                	add    %al,(%eax)
    1ab7:	00 5e 0b             	add    %bl,0xb(%esi)
    1aba:	00 00                	add    %al,(%eax)
    1abc:	40                   	inc    %eax
    1abd:	00 00                	add    %al,(%eax)
    1abf:	00 07                	add    %al,(%edi)
    1ac1:	00 00                	add    %al,(%eax)
    1ac3:	00 6c 0b 00          	add    %ch,0x0(%ebx,%ecx,1)
    1ac7:	00 24 00             	add    %ah,(%eax,%eax,1)
    1aca:	00 00                	add    %al,(%eax)
    1acc:	ea 06 28 00 7b 0b 00 	ljmp   $0xb,$0x7b002806
    1ad3:	00 a0 00 00 00 08    	add    %ah,0x8000000(%eax)
    1ad9:	00 00                	add    %al,(%eax)
    1adb:	00 8d 0b 00 00 a0    	add    %cl,-0x5ffffff5(%ebp)
    1ae1:	00 00                	add    %al,(%eax)
    1ae3:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1ae6:	00 00                	add    %al,(%eax)
    1ae8:	9b                   	fwait
    1ae9:	0b 00                	or     (%eax),%eax
    1aeb:	00 a0 00 00 00 10    	add    %ah,0x10000000(%eax)
    1af1:	00 00                	add    %al,(%eax)
    1af3:	00 2c 0b             	add    %ch,(%ebx,%ecx,1)
    1af6:	00 00                	add    %al,(%eax)
    1af8:	a0 00 00 00 14       	mov    0x14000000,%al
    1afd:	00 00                	add    %al,(%eax)
    1aff:	00 00                	add    %al,(%eax)
    1b01:	00 00                	add    %al,(%eax)
    1b03:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
	...
    1b0f:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1b13:	00 03                	add    %al,(%ebx)
    1b15:	00 00                	add    %al,(%eax)
    1b17:	00 00                	add    %al,(%eax)
    1b19:	00 00                	add    %al,(%eax)
    1b1b:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1b1f:	00 0c 00             	add    %cl,(%eax,%eax,1)
    1b22:	00 00                	add    %al,(%eax)
    1b24:	00 00                	add    %al,(%eax)
    1b26:	00 00                	add    %al,(%eax)
    1b28:	44                   	inc    %esp
    1b29:	00 1a                	add    %bl,(%edx)
    1b2b:	00 0f                	add    %cl,(%edi)
    1b2d:	00 00                	add    %al,(%eax)
    1b2f:	00 00                	add    %al,(%eax)
    1b31:	00 00                	add    %al,(%eax)
    1b33:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1b37:	00 16                	add    %dl,(%esi)
    1b39:	00 00                	add    %al,(%eax)
    1b3b:	00 00                	add    %al,(%eax)
    1b3d:	00 00                	add    %al,(%eax)
    1b3f:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1b43:	00 19                	add    %bl,(%ecx)
    1b45:	00 00                	add    %al,(%eax)
    1b47:	00 00                	add    %al,(%eax)
    1b49:	00 00                	add    %al,(%eax)
    1b4b:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1b4f:	00 1c 00             	add    %bl,(%eax,%eax,1)
    1b52:	00 00                	add    %al,(%eax)
    1b54:	00 00                	add    %al,(%eax)
    1b56:	00 00                	add    %al,(%eax)
    1b58:	44                   	inc    %esp
    1b59:	00 1f                	add    %bl,(%edi)
    1b5b:	00 20                	add    %ah,(%eax)
    1b5d:	00 00                	add    %al,(%eax)
    1b5f:	00 00                	add    %al,(%eax)
    1b61:	00 00                	add    %al,(%eax)
    1b63:	00 44 00 23          	add    %al,0x23(%eax,%eax,1)
    1b67:	00 28                	add    %ch,(%eax)
    1b69:	00 00                	add    %al,(%eax)
    1b6b:	00 ab 0b 00 00 40    	add    %ch,0x4000000b(%ebx)
    1b71:	00 00                	add    %al,(%eax)
    1b73:	00 00                	add    %al,(%eax)
    1b75:	00 00                	add    %al,(%eax)
    1b77:	00 b6 0b 00 00 40    	add    %dh,0x4000000b(%esi)
    1b7d:	00 00                	add    %al,(%eax)
    1b7f:	00 01                	add    %al,(%ecx)
    1b81:	00 00                	add    %al,(%eax)
    1b83:	00 c4                	add    %al,%ah
    1b85:	0b 00                	or     (%eax),%eax
    1b87:	00 40 00             	add    %al,0x0(%eax)
    1b8a:	00 00                	add    %al,(%eax)
    1b8c:	01 00                	add    %eax,(%eax)
    1b8e:	00 00                	add    %al,(%eax)
    1b90:	5e                   	pop    %esi
    1b91:	0b 00                	or     (%eax),%eax
    1b93:	00 40 00             	add    %al,0x0(%eax)
    1b96:	00 00                	add    %al,(%eax)
    1b98:	02 00                	add    (%eax),%al
    1b9a:	00 00                	add    %al,(%eax)
    1b9c:	d4 0b                	aam    $0xb
    1b9e:	00 00                	add    %al,(%eax)
    1ba0:	24 00                	and    $0x0,%al
    1ba2:	00 00                	add    %al,(%eax)
    1ba4:	14 07                	adc    $0x7,%al
    1ba6:	28 00                	sub    %al,(%eax)
    1ba8:	00 00                	add    %al,(%eax)
    1baa:	00 00                	add    %al,(%eax)
    1bac:	44                   	inc    %esp
    1bad:	00 28                	add    %ch,(%eax)
	...
    1bb7:	00 44 00 28          	add    %al,0x28(%eax,%eax,1)
    1bbb:	00 05 00 00 00 00    	add    %al,0x0
    1bc1:	00 00                	add    %al,(%eax)
    1bc3:	00 44 00 2e          	add    %al,0x2e(%eax,%eax,1)
    1bc7:	00 0a                	add    %cl,(%edx)
    1bc9:	00 00                	add    %al,(%eax)
    1bcb:	00 00                	add    %al,(%eax)
    1bcd:	00 00                	add    %al,(%eax)
    1bcf:	00 44 00 2c          	add    %al,0x2c(%eax,%eax,1)
    1bd3:	00 19                	add    %bl,(%ecx)
    1bd5:	00 00                	add    %al,(%eax)
    1bd7:	00 00                	add    %al,(%eax)
    1bd9:	00 00                	add    %al,(%eax)
    1bdb:	00 44 00 30          	add    %al,0x30(%eax,%eax,1)
    1bdf:	00 24 00             	add    %ah,(%eax,%eax,1)
    1be2:	00 00                	add    %al,(%eax)
    1be4:	00 00                	add    %al,(%eax)
    1be6:	00 00                	add    %al,(%eax)
    1be8:	44                   	inc    %esp
    1be9:	00 31                	add    %dh,(%ecx)
    1beb:	00 37                	add    %dh,(%edi)
    1bed:	00 00                	add    %al,(%eax)
    1bef:	00 00                	add    %al,(%eax)
    1bf1:	00 00                	add    %al,(%eax)
    1bf3:	00 44 00 32          	add    %al,0x32(%eax,%eax,1)
    1bf7:	00 4d 00             	add    %cl,0x0(%ebp)
    1bfa:	00 00                	add    %al,(%eax)
    1bfc:	00 00                	add    %al,(%eax)
    1bfe:	00 00                	add    %al,(%eax)
    1c00:	44                   	inc    %esp
    1c01:	00 34 00             	add    %dh,(%eax,%eax,1)
    1c04:	69 00 00 00 00 00    	imul   $0x0,(%eax),%eax
    1c0a:	00 00                	add    %al,(%eax)
    1c0c:	44                   	inc    %esp
    1c0d:	00 19                	add    %bl,(%ecx)
    1c0f:	00 7f 00             	add    %bh,0x0(%edi)
    1c12:	00 00                	add    %al,(%eax)
    1c14:	00 00                	add    %al,(%eax)
    1c16:	00 00                	add    %al,(%eax)
    1c18:	44                   	inc    %esp
    1c19:	00 1a                	add    %bl,(%edx)
    1c1b:	00 8b 00 00 00 00    	add    %cl,0x0(%ebx)
    1c21:	00 00                	add    %al,(%eax)
    1c23:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1c27:	00 94 00 00 00 00 00 	add    %dl,0x0(%eax,%eax,1)
    1c2e:	00 00                	add    %al,(%eax)
    1c30:	44                   	inc    %esp
    1c31:	00 1f                	add    %bl,(%edi)
    1c33:	00 9d 00 00 00 00    	add    %bl,0x0(%ebp)
    1c39:	00 00                	add    %al,(%eax)
    1c3b:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1c3f:	00 a4 00 00 00 00 00 	add    %ah,0x0(%eax,%eax,1)
    1c46:	00 00                	add    %al,(%eax)
    1c48:	44                   	inc    %esp
    1c49:	00 36                	add    %dh,(%esi)
    1c4b:	00 ab 00 00 00 00    	add    %ch,0x0(%ebx)
    1c51:	00 00                	add    %al,(%eax)
    1c53:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1c57:	00 b2 00 00 00 00    	add    %dh,0x0(%edx)
    1c5d:	00 00                	add    %al,(%eax)
    1c5f:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1c63:	00 bd 00 00 00 00    	add    %bh,0x0(%ebp)
    1c69:	00 00                	add    %al,(%eax)
    1c6b:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1c6f:	00 c2                	add    %al,%dl
    1c71:	00 00                	add    %al,(%eax)
    1c73:	00 00                	add    %al,(%eax)
    1c75:	00 00                	add    %al,(%eax)
    1c77:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1c7b:	00 c4                	add    %al,%ah
    1c7d:	00 00                	add    %al,(%eax)
    1c7f:	00 00                	add    %al,(%eax)
    1c81:	00 00                	add    %al,(%eax)
    1c83:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1c87:	00 ce                	add    %cl,%dh
    1c89:	00 00                	add    %al,(%eax)
    1c8b:	00 00                	add    %al,(%eax)
    1c8d:	00 00                	add    %al,(%eax)
    1c8f:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1c93:	00 d5                	add    %dl,%ch
    1c95:	00 00                	add    %al,(%eax)
    1c97:	00 00                	add    %al,(%eax)
    1c99:	00 00                	add    %al,(%eax)
    1c9b:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1c9f:	00 de                	add    %bl,%dh
    1ca1:	00 00                	add    %al,(%eax)
    1ca3:	00 00                	add    %al,(%eax)
    1ca5:	00 00                	add    %al,(%eax)
    1ca7:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1cab:	00 e5                	add    %ah,%ch
    1cad:	00 00                	add    %al,(%eax)
    1caf:	00 00                	add    %al,(%eax)
    1cb1:	00 00                	add    %al,(%eax)
    1cb3:	00 44 00 3b          	add    %al,0x3b(%eax,%eax,1)
    1cb7:	00 ec                	add    %ch,%ah
    1cb9:	00 00                	add    %al,(%eax)
    1cbb:	00 00                	add    %al,(%eax)
    1cbd:	00 00                	add    %al,(%eax)
    1cbf:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1cc3:	00 f3                	add    %dh,%bl
    1cc5:	00 00                	add    %al,(%eax)
    1cc7:	00 00                	add    %al,(%eax)
    1cc9:	00 00                	add    %al,(%eax)
    1ccb:	00 44 00 1a          	add    %al,0x1a(%eax,%eax,1)
    1ccf:	00 fe                	add    %bh,%dh
    1cd1:	00 00                	add    %al,(%eax)
    1cd3:	00 00                	add    %al,(%eax)
    1cd5:	00 00                	add    %al,(%eax)
    1cd7:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1cdb:	00 05 01 00 00 00    	add    %al,0x1
    1ce1:	00 00                	add    %al,(%eax)
    1ce3:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    1ce7:	00 0e                	add    %cl,(%esi)
    1ce9:	01 00                	add    %eax,(%eax)
    1ceb:	00 00                	add    %al,(%eax)
    1ced:	00 00                	add    %al,(%eax)
    1cef:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    1cf3:	00 15 01 00 00 00    	add    %dl,0x1
    1cf9:	00 00                	add    %al,(%eax)
    1cfb:	00 44 00 42          	add    %al,0x42(%eax,%eax,1)
    1cff:	00 1c 01             	add    %bl,(%ecx,%eax,1)
    1d02:	00 00                	add    %al,(%eax)
    1d04:	00 00                	add    %al,(%eax)
    1d06:	00 00                	add    %al,(%eax)
    1d08:	44                   	inc    %esp
    1d09:	00 46 00             	add    %al,0x0(%esi)
    1d0c:	30 01                	xor    %al,(%ecx)
    1d0e:	00 00                	add    %al,(%eax)
    1d10:	00 00                	add    %al,(%eax)
    1d12:	00 00                	add    %al,(%eax)
    1d14:	64 00 00             	add    %al,%fs:(%eax)
    1d17:	00 49 08             	add    %cl,0x8(%ecx)
    1d1a:	28 00                	sub    %al,(%eax)
    1d1c:	e8 0b 00 00 64       	call   64001d2c <cursor.1329+0x63d7fa2c>
    1d21:	00 02                	add    %al,(%edx)
    1d23:	00 49 08             	add    %cl,0x8(%ecx)
    1d26:	28 00                	sub    %al,(%eax)
    1d28:	08 00                	or     %al,(%eax)
    1d2a:	00 00                	add    %al,(%eax)
    1d2c:	3c 00                	cmp    $0x0,%al
    1d2e:	00 00                	add    %al,(%eax)
    1d30:	00 00                	add    %al,(%eax)
    1d32:	00 00                	add    %al,(%eax)
    1d34:	17                   	pop    %ss
    1d35:	00 00                	add    %al,(%eax)
    1d37:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d3d:	00 00                	add    %al,(%eax)
    1d3f:	00 41 00             	add    %al,0x0(%ecx)
    1d42:	00 00                	add    %al,(%eax)
    1d44:	80 00 00             	addb   $0x0,(%eax)
    1d47:	00 00                	add    %al,(%eax)
    1d49:	00 00                	add    %al,(%eax)
    1d4b:	00 5b 00             	add    %bl,0x0(%ebx)
    1d4e:	00 00                	add    %al,(%eax)
    1d50:	80 00 00             	addb   $0x0,(%eax)
    1d53:	00 00                	add    %al,(%eax)
    1d55:	00 00                	add    %al,(%eax)
    1d57:	00 8a 00 00 00 80    	add    %cl,-0x80000000(%edx)
    1d5d:	00 00                	add    %al,(%eax)
    1d5f:	00 00                	add    %al,(%eax)
    1d61:	00 00                	add    %al,(%eax)
    1d63:	00 b3 00 00 00 80    	add    %dh,-0x80000000(%ebx)
    1d69:	00 00                	add    %al,(%eax)
    1d6b:	00 00                	add    %al,(%eax)
    1d6d:	00 00                	add    %al,(%eax)
    1d6f:	00 e1                	add    %ah,%cl
    1d71:	00 00                	add    %al,(%eax)
    1d73:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d79:	00 00                	add    %al,(%eax)
    1d7b:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    1d7e:	00 00                	add    %al,(%eax)
    1d80:	80 00 00             	addb   $0x0,(%eax)
    1d83:	00 00                	add    %al,(%eax)
    1d85:	00 00                	add    %al,(%eax)
    1d87:	00 37                	add    %dh,(%edi)
    1d89:	01 00                	add    %eax,(%eax)
    1d8b:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1d91:	00 00                	add    %al,(%eax)
    1d93:	00 5d 01             	add    %bl,0x1(%ebp)
    1d96:	00 00                	add    %al,(%eax)
    1d98:	80 00 00             	addb   $0x0,(%eax)
    1d9b:	00 00                	add    %al,(%eax)
    1d9d:	00 00                	add    %al,(%eax)
    1d9f:	00 87 01 00 00 80    	add    %al,-0x7fffffff(%edi)
    1da5:	00 00                	add    %al,(%eax)
    1da7:	00 00                	add    %al,(%eax)
    1da9:	00 00                	add    %al,(%eax)
    1dab:	00 ad 01 00 00 80    	add    %ch,-0x7fffffff(%ebp)
    1db1:	00 00                	add    %al,(%eax)
    1db3:	00 00                	add    %al,(%eax)
    1db5:	00 00                	add    %al,(%eax)
    1db7:	00 d2                	add    %dl,%dl
    1db9:	01 00                	add    %eax,(%eax)
    1dbb:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dc1:	00 00                	add    %al,(%eax)
    1dc3:	00 ec                	add    %ch,%ah
    1dc5:	01 00                	add    %eax,(%eax)
    1dc7:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dcd:	00 00                	add    %al,(%eax)
    1dcf:	00 07                	add    %al,(%edi)
    1dd1:	02 00                	add    (%eax),%al
    1dd3:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1dd9:	00 00                	add    %al,(%eax)
    1ddb:	00 28                	add    %ch,(%eax)
    1ddd:	02 00                	add    (%eax),%al
    1ddf:	00 80 00 00 00 00    	add    %al,0x0(%eax)
    1de5:	00 00                	add    %al,(%eax)
    1de7:	00 47 02             	add    %al,0x2(%edi)
    1dea:	00 00                	add    %al,(%eax)
    1dec:	80 00 00             	addb   $0x0,(%eax)
    1def:	00 00                	add    %al,(%eax)
    1df1:	00 00                	add    %al,(%eax)
    1df3:	00 66 02             	add    %ah,0x2(%esi)
    1df6:	00 00                	add    %al,(%eax)
    1df8:	80 00 00             	addb   $0x0,(%eax)
    1dfb:	00 00                	add    %al,(%eax)
    1dfd:	00 00                	add    %al,(%eax)
    1dff:	00 87 02 00 00 80    	add    %al,-0x7ffffffe(%edi)
    1e05:	00 00                	add    %al,(%eax)
    1e07:	00 00                	add    %al,(%eax)
    1e09:	00 00                	add    %al,(%eax)
    1e0b:	00 9b 02 00 00 c2    	add    %bl,-0x3dfffffe(%ebx)
    1e11:	00 00                	add    %al,(%eax)
    1e13:	00 34 72             	add    %dh,(%edx,%esi,2)
    1e16:	00 00                	add    %al,(%eax)
    1e18:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    1e19:	02 00                	add    (%eax),%al
    1e1b:	00 c2                	add    %al,%dl
    1e1d:	00 00                	add    %al,(%eax)
    1e1f:	00 00                	add    %al,(%eax)
    1e21:	00 00                	add    %al,(%eax)
    1e23:	00 ae 02 00 00 c2    	add    %ch,-0x3dfffffe(%esi)
    1e29:	00 00                	add    %al,(%eax)
    1e2b:	00 37                	add    %dh,(%edi)
    1e2d:	53                   	push   %ebx
    1e2e:	00 00                	add    %al,(%eax)
    1e30:	ee                   	out    %al,(%dx)
    1e31:	0b 00                	or     (%eax),%eax
    1e33:	00 24 00             	add    %ah,(%eax,%eax,1)
    1e36:	00 00                	add    %al,(%eax)
    1e38:	49                   	dec    %ecx
    1e39:	08 28                	or     %ch,(%eax)
    1e3b:	00 00                	add    %al,(%eax)
    1e3d:	00 00                	add    %al,(%eax)
    1e3f:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1e43:	00 00                	add    %al,(%eax)
    1e45:	00 00                	add    %al,(%eax)
    1e47:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    1e4d:	00 00                	add    %al,(%eax)
    1e4f:	00 4a 08             	add    %cl,0x8(%edx)
    1e52:	28 00                	sub    %al,(%eax)
    1e54:	00 00                	add    %al,(%eax)
    1e56:	00 00                	add    %al,(%eax)
    1e58:	44                   	inc    %esp
    1e59:	00 5c 00 01          	add    %bl,0x1(%eax,%eax,1)
    1e5d:	00 00                	add    %al,(%eax)
    1e5f:	00 e8                	add    %ch,%al
    1e61:	0b 00                	or     (%eax),%eax
    1e63:	00 84 00 00 00 4f 08 	add    %al,0x84f0000(%eax,%eax,1)
    1e6a:	28 00                	sub    %al,(%eax)
    1e6c:	00 00                	add    %al,(%eax)
    1e6e:	00 00                	add    %al,(%eax)
    1e70:	44                   	inc    %esp
    1e71:	00 17                	add    %dl,(%edi)
    1e73:	00 06                	add    %al,(%esi)
    1e75:	00 00                	add    %al,(%eax)
    1e77:	00 a6 02 00 00 84    	add    %ah,-0x7bfffffe(%esi)
    1e7d:	00 00                	add    %al,(%eax)
    1e7f:	00 51 08             	add    %dl,0x8(%ecx)
    1e82:	28 00                	sub    %al,(%eax)
    1e84:	00 00                	add    %al,(%eax)
    1e86:	00 00                	add    %al,(%eax)
    1e88:	44                   	inc    %esp
    1e89:	00 5c 00 08          	add    %bl,0x8(%eax,%eax,1)
    1e8d:	00 00                	add    %al,(%eax)
    1e8f:	00 e8                	add    %ch,%al
    1e91:	0b 00                	or     (%eax),%eax
    1e93:	00 84 00 00 00 81 08 	add    %al,0x8810000(%eax,%eax,1)
    1e9a:	28 00                	sub    %al,(%eax)
    1e9c:	00 00                	add    %al,(%eax)
    1e9e:	00 00                	add    %al,(%eax)
    1ea0:	44                   	inc    %esp
    1ea1:	00 5d 00             	add    %bl,0x0(%ebp)
    1ea4:	38 00                	cmp    %al,(%eax)
    1ea6:	00 00                	add    %al,(%eax)
    1ea8:	ff 0b                	decl   (%ebx)
    1eaa:	00 00                	add    %al,(%eax)
    1eac:	24 00                	and    $0x0,%al
    1eae:	00 00                	add    %al,(%eax)
    1eb0:	83 08 28             	orl    $0x28,(%eax)
    1eb3:	00 14 0c             	add    %dl,(%esp,%ecx,1)
    1eb6:	00 00                	add    %al,(%eax)
    1eb8:	a0 00 00 00 08       	mov    0x8000000,%al
    1ebd:	00 00                	add    %al,(%eax)
    1ebf:	00 00                	add    %al,(%eax)
    1ec1:	00 00                	add    %al,(%eax)
    1ec3:	00 44 00 61          	add    %al,0x61(%eax,%eax,1)
	...
    1ecf:	00 44 00 63          	add    %al,0x63(%eax,%eax,1)
    1ed3:	00 06                	add    %al,(%esi)
    1ed5:	00 00                	add    %al,(%eax)
    1ed7:	00 00                	add    %al,(%eax)
    1ed9:	00 00                	add    %al,(%eax)
    1edb:	00 44 00 64          	add    %al,0x64(%eax,%eax,1)
    1edf:	00 18                	add    %bl,(%eax)
    1ee1:	00 00                	add    %al,(%eax)
    1ee3:	00 00                	add    %al,(%eax)
    1ee5:	00 00                	add    %al,(%eax)
    1ee7:	00 44 00 66          	add    %al,0x66(%eax,%eax,1)
    1eeb:	00 3c 00             	add    %bh,(%eax,%eax,1)
    1eee:	00 00                	add    %al,(%eax)
    1ef0:	00 00                	add    %al,(%eax)
    1ef2:	00 00                	add    %al,(%eax)
    1ef4:	64 00 00             	add    %al,%fs:(%eax)
    1ef7:	00 c2                	add    %al,%dl
    1ef9:	08 28                	or     %ch,(%eax)
    1efb:	00 27                	add    %ah,(%edi)
    1efd:	0c 00                	or     $0x0,%al
    1eff:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    1f03:	00 c2                	add    %al,%dl
    1f05:	08 28                	or     %ch,(%eax)
    1f07:	00 37                	add    %dh,(%edi)
    1f09:	0c 00                	or     $0x0,%al
    1f0b:	00 84 00 00 00 c2 08 	add    %al,0x8c20000(%eax,%eax,1)
    1f12:	28 00                	sub    %al,(%eax)
    1f14:	00 00                	add    %al,(%eax)
    1f16:	00 00                	add    %al,(%eax)
    1f18:	44                   	inc    %esp
    1f19:	00 06                	add    %al,(%esi)
    1f1b:	00 c2                	add    %al,%dl
    1f1d:	08 28                	or     %ch,(%eax)
    1f1f:	00 00                	add    %al,(%eax)
    1f21:	00 00                	add    %al,(%eax)
    1f23:	00 44 00 07          	add    %al,0x7(%eax,%eax,1)
    1f27:	00 c4                	add    %al,%ah
    1f29:	08 28                	or     %ch,(%eax)
    1f2b:	00 00                	add    %al,(%eax)
    1f2d:	00 00                	add    %al,(%eax)
    1f2f:	00 44 00 08          	add    %al,0x8(%eax,%eax,1)
    1f33:	00 c6                	add    %al,%dh
    1f35:	08 28                	or     %ch,(%eax)
    1f37:	00 00                	add    %al,(%eax)
    1f39:	00 00                	add    %al,(%eax)
    1f3b:	00 44 00 09          	add    %al,0x9(%eax,%eax,1)
    1f3f:	00 c7                	add    %al,%bh
    1f41:	08 28                	or     %ch,(%eax)
    1f43:	00 00                	add    %al,(%eax)
    1f45:	00 00                	add    %al,(%eax)
    1f47:	00 44 00 0a          	add    %al,0xa(%eax,%eax,1)
    1f4b:	00 c9                	add    %cl,%cl
    1f4d:	08 28                	or     %ch,(%eax)
    1f4f:	00 00                	add    %al,(%eax)
    1f51:	00 00                	add    %al,(%eax)
    1f53:	00 44 00 0b          	add    %al,0xb(%eax,%eax,1)
    1f57:	00 ca                	add    %cl,%dl
    1f59:	08 28                	or     %ch,(%eax)
    1f5b:	00 00                	add    %al,(%eax)
    1f5d:	00 00                	add    %al,(%eax)
    1f5f:	00 44 00 0c          	add    %al,0xc(%eax,%eax,1)
    1f63:	00 cd                	add    %cl,%ch
    1f65:	08 28                	or     %ch,(%eax)
    1f67:	00 00                	add    %al,(%eax)
    1f69:	00 00                	add    %al,(%eax)
    1f6b:	00 44 00 0d          	add    %al,0xd(%eax,%eax,1)
    1f6f:	00 cf                	add    %cl,%bh
    1f71:	08 28                	or     %ch,(%eax)
    1f73:	00 00                	add    %al,(%eax)
    1f75:	00 00                	add    %al,(%eax)
    1f77:	00 44 00 0e          	add    %al,0xe(%eax,%eax,1)
    1f7b:	00 d1                	add    %dl,%cl
    1f7d:	08 28                	or     %ch,(%eax)
    1f7f:	00 00                	add    %al,(%eax)
    1f81:	00 00                	add    %al,(%eax)
    1f83:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
    1f87:	00 d6                	add    %dl,%dh
    1f89:	08 28                	or     %ch,(%eax)
    1f8b:	00 00                	add    %al,(%eax)
    1f8d:	00 00                	add    %al,(%eax)
    1f8f:	00 44 00 11          	add    %al,0x11(%eax,%eax,1)
    1f93:	00 d7                	add    %dl,%bh
    1f95:	08 28                	or     %ch,(%eax)
    1f97:	00 00                	add    %al,(%eax)
    1f99:	00 00                	add    %al,(%eax)
    1f9b:	00 44 00 12          	add    %al,0x12(%eax,%eax,1)
    1f9f:	00 d8                	add    %bl,%al
    1fa1:	08 28                	or     %ch,(%eax)
    1fa3:	00 00                	add    %al,(%eax)
    1fa5:	00 00                	add    %al,(%eax)
    1fa7:	00 44 00 13          	add    %al,0x13(%eax,%eax,1)
    1fab:	00 da                	add    %bl,%dl
    1fad:	08 28                	or     %ch,(%eax)
    1faf:	00 00                	add    %al,(%eax)
    1fb1:	00 00                	add    %al,(%eax)
    1fb3:	00 44 00 14          	add    %al,0x14(%eax,%eax,1)
    1fb7:	00 dc                	add    %bl,%ah
    1fb9:	08 28                	or     %ch,(%eax)
    1fbb:	00 00                	add    %al,(%eax)
    1fbd:	00 00                	add    %al,(%eax)
    1fbf:	00 44 00 16          	add    %al,0x16(%eax,%eax,1)
    1fc3:	00 dd                	add    %bl,%ch
    1fc5:	08 28                	or     %ch,(%eax)
    1fc7:	00 00                	add    %al,(%eax)
    1fc9:	00 00                	add    %al,(%eax)
    1fcb:	00 44 00 17          	add    %al,0x17(%eax,%eax,1)
    1fcf:	00 e2                	add    %ah,%dl
    1fd1:	08 28                	or     %ch,(%eax)
    1fd3:	00 00                	add    %al,(%eax)
    1fd5:	00 00                	add    %al,(%eax)
    1fd7:	00 44 00 18          	add    %al,0x18(%eax,%eax,1)
    1fdb:	00 e7                	add    %ah,%bh
    1fdd:	08 28                	or     %ch,(%eax)
    1fdf:	00 00                	add    %al,(%eax)
    1fe1:	00 00                	add    %al,(%eax)
    1fe3:	00 44 00 19          	add    %al,0x19(%eax,%eax,1)
    1fe7:	00 ec                	add    %ch,%ah
    1fe9:	08 28                	or     %ch,(%eax)
    1feb:	00 00                	add    %al,(%eax)
    1fed:	00 00                	add    %al,(%eax)
    1fef:	00 44 00 1d          	add    %al,0x1d(%eax,%eax,1)
    1ff3:	00 ed                	add    %ch,%ch
    1ff5:	08 28                	or     %ch,(%eax)
    1ff7:	00 00                	add    %al,(%eax)
    1ff9:	00 00                	add    %al,(%eax)
    1ffb:	00 44 00 1e          	add    %al,0x1e(%eax,%eax,1)
    1fff:	00 f2                	add    %dh,%dl
    2001:	08 28                	or     %ch,(%eax)
    2003:	00 00                	add    %al,(%eax)
    2005:	00 00                	add    %al,(%eax)
    2007:	00 44 00 1f          	add    %al,0x1f(%eax,%eax,1)
    200b:	00 f7                	add    %dh,%bh
    200d:	08 28                	or     %ch,(%eax)
    200f:	00 00                	add    %al,(%eax)
    2011:	00 00                	add    %al,(%eax)
    2013:	00 44 00 20          	add    %al,0x20(%eax,%eax,1)
    2017:	00 fc                	add    %bh,%ah
    2019:	08 28                	or     %ch,(%eax)
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
 5bb:	00 66 70             	add    %ah,0x70(%esi)
 5be:	74 3a                	je     5fa <bootmain-0x27fa06>
 5c0:	74 28                	je     5ea <bootmain-0x27fa16>
 5c2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 5c5:	39 29                	cmp    %ebp,(%ecx)
 5c7:	3d 28 30 2c 32       	cmp    $0x322c3028,%eax
 5cc:	30 29                	xor    %ch,(%ecx)
 5ce:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 5d3:	32 31                	xor    (%ecx),%dh
 5d5:	29 3d 66 28 30 2c    	sub    %edi,0x2c302866
 5db:	31 38                	xor    %edi,(%eax)
 5dd:	29 00                	sub    %eax,(%eax)
 5df:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 5e2:	74 6d                	je     651 <bootmain-0x27f9af>
 5e4:	61                   	popa   
 5e5:	69 6e 3a 46 28 30 2c 	imul   $0x2c302846,0x3a(%esi),%ebp
 5ec:	31 38                	xor    %edi,(%eax)
 5ee:	29 00                	sub    %eax,(%eax)
 5f0:	6d                   	insl   (%dx),%es:(%edi)
 5f1:	6f                   	outsl  %ds:(%esi),(%dx)
 5f2:	75 73                	jne    667 <bootmain-0x27f999>
 5f4:	65                   	gs
 5f5:	70 69                	jo     660 <bootmain-0x27f9a0>
 5f7:	63 3a                	arpl   %di,(%edx)
 5f9:	28 30                	sub    %dh,(%eax)
 5fb:	2c 32                	sub    $0x32,%al
 5fd:	32 29                	xor    (%ecx),%ch
 5ff:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 604:	2c 32                	sub    $0x32,%al
 606:	33 29                	xor    (%ecx),%ebp
 608:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 60d:	32 33                	xor    (%ebx),%dh
 60f:	29 3b                	sub    %edi,(%ebx)
 611:	30 3b                	xor    %bh,(%ebx)
 613:	34 32                	xor    $0x32,%al
 615:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 618:	36                   	ss
 619:	37                   	aaa    
 61a:	32 39                	xor    (%ecx),%bh
 61c:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 621:	32 35 35 3b 28 30    	xor    0x30283b35,%dh
 627:	2c 32                	sub    $0x32,%al
 629:	29 00                	sub    %eax,(%eax)
 62b:	41                   	inc    %ecx
 62c:	53                   	push   %ebx
 62d:	43                   	inc    %ebx
 62e:	49                   	dec    %ecx
 62f:	49                   	dec    %ecx
 630:	5f                   	pop    %edi
 631:	54                   	push   %esp
 632:	61                   	popa   
 633:	62 6c 65 3a          	bound  %ebp,0x3a(%ebp,%eiz,2)
 637:	47                   	inc    %edi
 638:	28 30                	sub    %dh,(%eax)
 63a:	2c 32                	sub    $0x32,%al
 63c:	34 29                	xor    $0x29,%al
 63e:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 643:	2c 32                	sub    $0x32,%al
 645:	33 29                	xor    (%ecx),%ebp
 647:	3b 30                	cmp    (%eax),%esi
 649:	3b 32                	cmp    (%edx),%esi
 64b:	32 37                	xor    (%edi),%dh
 64d:	39 3b                	cmp    %edi,(%ebx)
 64f:	28 30                	sub    %dh,(%eax)
 651:	2c 39                	sub    $0x39,%al
 653:	29 00                	sub    %eax,(%eax)
 655:	46                   	inc    %esi
 656:	6f                   	outsl  %ds:(%esi),(%dx)
 657:	6e                   	outsb  %ds:(%esi),(%dx)
 658:	74 38                	je     692 <bootmain-0x27f96e>
 65a:	78 31                	js     68d <bootmain-0x27f973>
 65c:	36 3a 47 28          	cmp    %ss:0x28(%edi),%al
 660:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 663:	35 29 3d 61 72       	xor    $0x72613d29,%eax
 668:	28 30                	sub    %dh,(%eax)
 66a:	2c 32                	sub    $0x32,%al
 66c:	33 29                	xor    (%ecx),%ebp
 66e:	3b 30                	cmp    (%eax),%esi
 670:	3b 32                	cmp    (%edx),%esi
 672:	30 34 37             	xor    %dh,(%edi,%esi,1)
 675:	3b 28                	cmp    (%eax),%ebp
 677:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 67a:	31 29                	xor    %ebp,(%ecx)
 67c:	00 73 63             	add    %dh,0x63(%ebx)
 67f:	72 65                	jb     6e6 <bootmain-0x27f91a>
 681:	65 6e                	outsb  %gs:(%esi),(%dx)
 683:	2e 63 00             	arpl   %ax,%cs:(%eax)
 686:	63 6c 65 61          	arpl   %bp,0x61(%ebp,%eiz,2)
 68a:	72 5f                	jb     6eb <bootmain-0x27f915>
 68c:	73 63                	jae    6f1 <bootmain-0x27f90f>
 68e:	72 65                	jb     6f5 <bootmain-0x27f90b>
 690:	65 6e                	outsb  %gs:(%esi),(%dx)
 692:	3a 46 28             	cmp    0x28(%esi),%al
 695:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 698:	38 29                	cmp    %ch,(%ecx)
 69a:	00 63 6f             	add    %ah,0x6f(%ebx)
 69d:	6c                   	insb   (%dx),%es:(%edi)
 69e:	6f                   	outsl  %ds:(%esi),(%dx)
 69f:	72 3a                	jb     6db <bootmain-0x27f925>
 6a1:	70 28                	jo     6cb <bootmain-0x27f935>
 6a3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6a6:	29 00                	sub    %eax,(%eax)
 6a8:	69 3a 72 28 30 2c    	imul   $0x2c302872,(%edx),%edi
 6ae:	31 29                	xor    %ebp,(%ecx)
 6b0:	00 63 6f             	add    %ah,0x6f(%ebx)
 6b3:	6c                   	insb   (%dx),%es:(%edi)
 6b4:	6f                   	outsl  %ds:(%esi),(%dx)
 6b5:	72 3a                	jb     6f1 <bootmain-0x27f90f>
 6b7:	72 28                	jb     6e1 <bootmain-0x27f91f>
 6b9:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 6bc:	29 00                	sub    %eax,(%eax)
 6be:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 6c1:	6f                   	outsl  %ds:(%esi),(%dx)
 6c2:	72 5f                	jb     723 <bootmain-0x27f8dd>
 6c4:	73 63                	jae    729 <bootmain-0x27f8d7>
 6c6:	72 65                	jb     72d <bootmain-0x27f8d3>
 6c8:	65 6e                	outsb  %gs:(%esi),(%dx)
 6ca:	3a 46 28             	cmp    0x28(%esi),%al
 6cd:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6d0:	38 29                	cmp    %ch,(%ecx)
 6d2:	00 73 65             	add    %dh,0x65(%ebx)
 6d5:	74 5f                	je     736 <bootmain-0x27f8ca>
 6d7:	70 61                	jo     73a <bootmain-0x27f8c6>
 6d9:	6c                   	insb   (%dx),%es:(%edi)
 6da:	65                   	gs
 6db:	74 74                	je     751 <bootmain-0x27f8af>
 6dd:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
 6e1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6e4:	38 29                	cmp    %ch,(%ecx)
 6e6:	00 73 74             	add    %dh,0x74(%ebx)
 6e9:	61                   	popa   
 6ea:	72 74                	jb     760 <bootmain-0x27f8a0>
 6ec:	3a 70 28             	cmp    0x28(%eax),%dh
 6ef:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6f2:	29 00                	sub    %eax,(%eax)
 6f4:	65 6e                	outsb  %gs:(%esi),(%dx)
 6f6:	64 3a 70 28          	cmp    %fs:0x28(%eax),%dh
 6fa:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 6fd:	29 00                	sub    %eax,(%eax)
 6ff:	72 67                	jb     768 <bootmain-0x27f898>
 701:	62 3a                	bound  %edi,(%edx)
 703:	70 28                	jo     72d <bootmain-0x27f8d3>
 705:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 708:	39 29                	cmp    %ebp,(%ecx)
 70a:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 70f:	31 31                	xor    %esi,(%ecx)
 711:	29 00                	sub    %eax,(%eax)
 713:	73 74                	jae    789 <bootmain-0x27f877>
 715:	61                   	popa   
 716:	72 74                	jb     78c <bootmain-0x27f874>
 718:	3a 72 28             	cmp    0x28(%edx),%dh
 71b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 71e:	29 00                	sub    %eax,(%eax)
 720:	72 67                	jb     789 <bootmain-0x27f877>
 722:	62 3a                	bound  %edi,(%edx)
 724:	72 28                	jb     74e <bootmain-0x27f8b2>
 726:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 729:	39 29                	cmp    %ebp,(%ecx)
 72b:	00 69 6e             	add    %ch,0x6e(%ecx)
 72e:	69 74 5f 70 61 6c 65 	imul   $0x74656c61,0x70(%edi,%ebx,2),%esi
 735:	74 
 736:	74 65                	je     79d <bootmain-0x27f863>
 738:	3a 46 28             	cmp    0x28(%esi),%al
 73b:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 73e:	38 29                	cmp    %ch,(%ecx)
 740:	00 74 61 62          	add    %dh,0x62(%ecx,%eiz,2)
 744:	6c                   	insb   (%dx),%es:(%edi)
 745:	65                   	gs
 746:	5f                   	pop    %edi
 747:	72 67                	jb     7b0 <bootmain-0x27f850>
 749:	62 3a                	bound  %edi,(%edx)
 74b:	28 30                	sub    %dh,(%eax)
 74d:	2c 32                	sub    $0x32,%al
 74f:	30 29                	xor    %ch,(%ecx)
 751:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 756:	2c 32                	sub    $0x32,%al
 758:	31 29                	xor    %ebp,(%ecx)
 75a:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 75f:	32 31                	xor    (%ecx),%dh
 761:	29 3b                	sub    %edi,(%ebx)
 763:	30 3b                	xor    %bh,(%ebx)
 765:	34 32                	xor    $0x32,%al
 767:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 76a:	36                   	ss
 76b:	37                   	aaa    
 76c:	32 39                	xor    (%ecx),%bh
 76e:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 773:	34 37                	xor    $0x37,%al
 775:	3b 28                	cmp    (%eax),%ebp
 777:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 77a:	31 29                	xor    %ebp,(%ecx)
 77c:	00 62 6f             	add    %ah,0x6f(%edx)
 77f:	78 66                	js     7e7 <bootmain-0x27f819>
 781:	69 6c 6c 38 3a 46 28 	imul   $0x3028463a,0x38(%esp,%ebp,2),%ebp
 788:	30 
 789:	2c 31                	sub    $0x31,%al
 78b:	38 29                	cmp    %ch,(%ecx)
 78d:	00 76 72             	add    %dh,0x72(%esi)
 790:	61                   	popa   
 791:	6d                   	insl   (%dx),%es:(%edi)
 792:	3a 70 28             	cmp    0x28(%eax),%dh
 795:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 798:	39 29                	cmp    %ebp,(%ecx)
 79a:	00 78 73             	add    %bh,0x73(%eax)
 79d:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
 7a4:	2c 31                	sub    $0x31,%al
 7a6:	29 00                	sub    %eax,(%eax)
 7a8:	78 30                	js     7da <bootmain-0x27f826>
 7aa:	3a 70 28             	cmp    0x28(%eax),%dh
 7ad:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7b0:	29 00                	sub    %eax,(%eax)
 7b2:	79 30                	jns    7e4 <bootmain-0x27f81c>
 7b4:	3a 70 28             	cmp    0x28(%eax),%dh
 7b7:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7ba:	29 00                	sub    %eax,(%eax)
 7bc:	78 31                	js     7ef <bootmain-0x27f811>
 7be:	3a 70 28             	cmp    0x28(%eax),%dh
 7c1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7c4:	29 00                	sub    %eax,(%eax)
 7c6:	79 31                	jns    7f9 <bootmain-0x27f807>
 7c8:	3a 70 28             	cmp    0x28(%eax),%dh
 7cb:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7ce:	29 00                	sub    %eax,(%eax)
 7d0:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 7d3:	6f                   	outsl  %ds:(%esi),(%dx)
 7d4:	72 3a                	jb     810 <bootmain-0x27f7f0>
 7d6:	72 28                	jb     800 <bootmain-0x27f800>
 7d8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7db:	31 29                	xor    %ebp,(%ecx)
 7dd:	00 79 30             	add    %bh,0x30(%ecx)
 7e0:	3a 72 28             	cmp    0x28(%edx),%dh
 7e3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7e6:	29 00                	sub    %eax,(%eax)
 7e8:	62 6f 78             	bound  %ebp,0x78(%edi)
 7eb:	66 69 6c 6c 3a 46 28 	imul   $0x2846,0x3a(%esp,%ebp,2),%bp
 7f2:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 7f5:	38 29                	cmp    %ch,(%ecx)
 7f7:	00 64 72 61          	add    %ah,0x61(%edx,%esi,2)
 7fb:	77 5f                	ja     85c <bootmain-0x27f7a4>
 7fd:	77 69                	ja     868 <bootmain-0x27f798>
 7ff:	6e                   	outsb  %ds:(%esi),(%dx)
 800:	64 6f                	outsl  %fs:(%esi),(%dx)
 802:	77 3a                	ja     83e <bootmain-0x27f7c2>
 804:	46                   	inc    %esi
 805:	28 30                	sub    %dh,(%eax)
 807:	2c 31                	sub    $0x31,%al
 809:	38 29                	cmp    %ch,(%ecx)
 80b:	00 69 6e             	add    %ch,0x6e(%ecx)
 80e:	69 74 5f 73 63 72 65 	imul   $0x65657263,0x73(%edi,%ebx,2),%esi
 815:	65 
 816:	6e                   	outsb  %ds:(%esi),(%dx)
 817:	3a 46 28             	cmp    0x28(%esi),%al
 81a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 81d:	38 29                	cmp    %ch,(%ecx)
 81f:	00 62 6f             	add    %ah,0x6f(%edx)
 822:	6f                   	outsl  %ds:(%esi),(%dx)
 823:	74 70                	je     895 <bootmain-0x27f76b>
 825:	3a 70 28             	cmp    0x28(%eax),%dh
 828:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 82b:	32 29                	xor    (%ecx),%ch
 82d:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 832:	31 29                	xor    %ebp,(%ecx)
 834:	00 62 6f             	add    %ah,0x6f(%edx)
 837:	6f                   	outsl  %ds:(%esi),(%dx)
 838:	74 70                	je     8aa <bootmain-0x27f756>
 83a:	3a 72 28             	cmp    0x28(%edx),%dh
 83d:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 840:	32 29                	xor    (%ecx),%ch
 842:	00 69 6e             	add    %ch,0x6e(%ecx)
 845:	69 74 5f 6d 6f 75 73 	imul   $0x6573756f,0x6d(%edi,%ebx,2),%esi
 84c:	65 
 84d:	3a 46 28             	cmp    0x28(%esi),%al
 850:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 853:	38 29                	cmp    %ch,(%ecx)
 855:	00 6d 6f             	add    %ch,0x6f(%ebp)
 858:	75 73                	jne    8cd <bootmain-0x27f733>
 85a:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
 85e:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 861:	29 00                	sub    %eax,(%eax)
 863:	62 67 3a             	bound  %esp,0x3a(%edi)
 866:	70 28                	jo     890 <bootmain-0x27f770>
 868:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 86b:	29 00                	sub    %eax,(%eax)
 86d:	63 75 72             	arpl   %si,0x72(%ebp)
 870:	73 6f                	jae    8e1 <bootmain-0x27f71f>
 872:	72 3a                	jb     8ae <bootmain-0x27f752>
 874:	56                   	push   %esi
 875:	28 30                	sub    %dh,(%eax)
 877:	2c 32                	sub    $0x32,%al
 879:	33 29                	xor    (%ecx),%ebp
 87b:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 880:	2c 32                	sub    $0x32,%al
 882:	31 29                	xor    %ebp,(%ecx)
 884:	3b 30                	cmp    (%eax),%esi
 886:	3b 31                	cmp    (%ecx),%esi
 888:	35 3b 28 30 2c       	xor    $0x2c30283b,%eax
 88d:	32 34 29             	xor    (%ecx,%ebp,1),%dh
 890:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 895:	2c 32                	sub    $0x32,%al
 897:	31 29                	xor    %ebp,(%ecx)
 899:	3b 30                	cmp    (%eax),%esi
 89b:	3b 31                	cmp    (%ecx),%esi
 89d:	35 3b 28 30 2c       	xor    $0x2c30283b,%eax
 8a2:	32 29                	xor    (%ecx),%ch
 8a4:	00 78 3a             	add    %bh,0x3a(%eax)
 8a7:	72 28                	jb     8d1 <bootmain-0x27f72f>
 8a9:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8ac:	29 00                	sub    %eax,(%eax)
 8ae:	62 67 3a             	bound  %esp,0x3a(%edi)
 8b1:	72 28                	jb     8db <bootmain-0x27f725>
 8b3:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 8b6:	29 00                	sub    %eax,(%eax)
 8b8:	64 69 73 70 6c 61 79 	imul   $0x5f79616c,%fs:0x70(%ebx),%esi
 8bf:	5f 
 8c0:	6d                   	insl   (%dx),%es:(%edi)
 8c1:	6f                   	outsl  %ds:(%esi),(%dx)
 8c2:	75 73                	jne    937 <bootmain-0x27f6c9>
 8c4:	65 3a 46 28          	cmp    %gs:0x28(%esi),%al
 8c8:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8cb:	38 29                	cmp    %ch,(%ecx)
 8cd:	00 76 72             	add    %dh,0x72(%esi)
 8d0:	61                   	popa   
 8d1:	6d                   	insl   (%dx),%es:(%edi)
 8d2:	3a 70 28             	cmp    0x28(%eax),%dh
 8d5:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 8d8:	29 00                	sub    %eax,(%eax)
 8da:	70 78                	jo     954 <bootmain-0x27f6ac>
 8dc:	73 69                	jae    947 <bootmain-0x27f6b9>
 8de:	7a 65                	jp     945 <bootmain-0x27f6bb>
 8e0:	3a 70 28             	cmp    0x28(%eax),%dh
 8e3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8e6:	29 00                	sub    %eax,(%eax)
 8e8:	70 79                	jo     963 <bootmain-0x27f69d>
 8ea:	73 69                	jae    955 <bootmain-0x27f6ab>
 8ec:	7a 65                	jp     953 <bootmain-0x27f6ad>
 8ee:	3a 70 28             	cmp    0x28(%eax),%dh
 8f1:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8f4:	29 00                	sub    %eax,(%eax)
 8f6:	70 78                	jo     970 <bootmain-0x27f690>
 8f8:	30 3a                	xor    %bh,(%edx)
 8fa:	70 28                	jo     924 <bootmain-0x27f6dc>
 8fc:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 8ff:	29 00                	sub    %eax,(%eax)
 901:	70 79                	jo     97c <bootmain-0x27f684>
 903:	30 3a                	xor    %bh,(%edx)
 905:	70 28                	jo     92f <bootmain-0x27f6d1>
 907:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 90a:	29 00                	sub    %eax,(%eax)
 90c:	62 75 66             	bound  %esi,0x66(%ebp)
 90f:	3a 70 28             	cmp    0x28(%eax),%dh
 912:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 915:	29 00                	sub    %eax,(%eax)
 917:	62 78 73             	bound  %edi,0x73(%eax)
 91a:	69 7a 65 3a 70 28 30 	imul   $0x3028703a,0x65(%edx),%edi
 921:	2c 31                	sub    $0x31,%al
 923:	29 00                	sub    %eax,(%eax)
 925:	79 3a                	jns    961 <bootmain-0x27f69f>
 927:	72 28                	jb     951 <bootmain-0x27f6af>
 929:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 92c:	29 00                	sub    %eax,(%eax)
 92e:	66 6f                	outsw  %ds:(%esi),(%dx)
 930:	6e                   	outsb  %ds:(%esi),(%dx)
 931:	74 2e                	je     961 <bootmain-0x27f69f>
 933:	63 00                	arpl   %ax,(%eax)
 935:	70 72                	jo     9a9 <bootmain-0x27f657>
 937:	69 6e 74 2e 63 00 69 	imul   $0x6900632e,0x74(%esi),%ebp
 93e:	74 6f                	je     9af <bootmain-0x27f651>
 940:	61                   	popa   
 941:	3a 46 28             	cmp    0x28(%esi),%al
 944:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 947:	38 29                	cmp    %ch,(%ecx)
 949:	00 76 61             	add    %dh,0x61(%esi)
 94c:	6c                   	insb   (%dx),%es:(%edi)
 94d:	75 65                	jne    9b4 <bootmain-0x27f64c>
 94f:	3a 70 28             	cmp    0x28(%eax),%dh
 952:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 955:	29 00                	sub    %eax,(%eax)
 957:	74 6d                	je     9c6 <bootmain-0x27f63a>
 959:	70 5f                	jo     9ba <bootmain-0x27f646>
 95b:	62 75 66             	bound  %esi,0x66(%ebp)
 95e:	3a 28                	cmp    (%eax),%ch
 960:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 963:	39 29                	cmp    %ebp,(%ecx)
 965:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 96a:	2c 32                	sub    $0x32,%al
 96c:	30 29                	xor    %ch,(%ecx)
 96e:	3d 72 28 30 2c       	cmp    $0x2c302872,%eax
 973:	32 30                	xor    (%eax),%dh
 975:	29 3b                	sub    %edi,(%ebx)
 977:	30 3b                	xor    %bh,(%ebx)
 979:	34 32                	xor    $0x32,%al
 97b:	39 34 39             	cmp    %esi,(%ecx,%edi,1)
 97e:	36                   	ss
 97f:	37                   	aaa    
 980:	32 39                	xor    (%ecx),%bh
 982:	35 3b 3b 30 3b       	xor    $0x3b303b3b,%eax
 987:	39 3b                	cmp    %edi,(%ebx)
 989:	28 30                	sub    %dh,(%eax)
 98b:	2c 32                	sub    $0x32,%al
 98d:	29 00                	sub    %eax,(%eax)
 98f:	76 61                	jbe    9f2 <bootmain-0x27f60e>
 991:	6c                   	insb   (%dx),%es:(%edi)
 992:	75 65                	jne    9f9 <bootmain-0x27f607>
 994:	3a 72 28             	cmp    0x28(%edx),%dh
 997:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 99a:	29 00                	sub    %eax,(%eax)
 99c:	62 75 66             	bound  %esi,0x66(%ebp)
 99f:	3a 72 28             	cmp    0x28(%edx),%dh
 9a2:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 9a5:	29 00                	sub    %eax,(%eax)
 9a7:	78 74                	js     a1d <bootmain-0x27f5e3>
 9a9:	6f                   	outsl  %ds:(%esi),(%dx)
 9aa:	61                   	popa   
 9ab:	3a 46 28             	cmp    0x28(%esi),%al
 9ae:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 9b1:	38 29                	cmp    %ch,(%ecx)
 9b3:	00 76 61             	add    %dh,0x61(%esi)
 9b6:	6c                   	insb   (%dx),%es:(%edi)
 9b7:	75 65                	jne    a1e <bootmain-0x27f5e2>
 9b9:	3a 70 28             	cmp    0x28(%eax),%dh
 9bc:	30 2c 34             	xor    %ch,(%esp,%esi,1)
 9bf:	29 00                	sub    %eax,(%eax)
 9c1:	74 6d                	je     a30 <bootmain-0x27f5d0>
 9c3:	70 5f                	jo     a24 <bootmain-0x27f5dc>
 9c5:	62 75 66             	bound  %esi,0x66(%ebp)
 9c8:	3a 28                	cmp    (%eax),%ch
 9ca:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 9cd:	31 29                	xor    %ebp,(%ecx)
 9cf:	3d 61 72 28 30       	cmp    $0x30287261,%eax
 9d4:	2c 32                	sub    $0x32,%al
 9d6:	30 29                	xor    %ch,(%ecx)
 9d8:	3b 30                	cmp    (%eax),%esi
 9da:	3b 32                	cmp    (%edx),%esi
 9dc:	39 3b                	cmp    %edi,(%ebx)
 9de:	28 30                	sub    %dh,(%eax)
 9e0:	2c 32                	sub    $0x32,%al
 9e2:	29 00                	sub    %eax,(%eax)
 9e4:	73 70                	jae    a56 <bootmain-0x27f5aa>
 9e6:	72 69                	jb     a51 <bootmain-0x27f5af>
 9e8:	6e                   	outsb  %ds:(%esi),(%dx)
 9e9:	74 66                	je     a51 <bootmain-0x27f5af>
 9eb:	3a 46 28             	cmp    0x28(%esi),%al
 9ee:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 9f1:	38 29                	cmp    %ch,(%ecx)
 9f3:	00 73 74             	add    %dh,0x74(%ebx)
 9f6:	72 3a                	jb     a32 <bootmain-0x27f5ce>
 9f8:	70 28                	jo     a22 <bootmain-0x27f5de>
 9fa:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 9fd:	29 00                	sub    %eax,(%eax)
 9ff:	66 6f                	outsw  %ds:(%esi),(%dx)
 a01:	72 6d                	jb     a70 <bootmain-0x27f590>
 a03:	61                   	popa   
 a04:	74 3a                	je     a40 <bootmain-0x27f5c0>
 a06:	70 28                	jo     a30 <bootmain-0x27f5d0>
 a08:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 a0b:	29 00                	sub    %eax,(%eax)
 a0d:	76 61                	jbe    a70 <bootmain-0x27f590>
 a0f:	72 3a                	jb     a4b <bootmain-0x27f5b5>
 a11:	72 28                	jb     a3b <bootmain-0x27f5c5>
 a13:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 a16:	32 29                	xor    (%ecx),%ch
 a18:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 a1d:	31 29                	xor    %ebp,(%ecx)
 a1f:	00 62 75             	add    %ah,0x75(%edx)
 a22:	66                   	data16
 a23:	66                   	data16
 a24:	65                   	gs
 a25:	72 3a                	jb     a61 <bootmain-0x27f59f>
 a27:	28 30                	sub    %dh,(%eax)
 a29:	2c 31                	sub    $0x31,%al
 a2b:	39 29                	cmp    %ebp,(%ecx)
 a2d:	00 73 74             	add    %dh,0x74(%ebx)
 a30:	72 3a                	jb     a6c <bootmain-0x27f594>
 a32:	72 28                	jb     a5c <bootmain-0x27f5a4>
 a34:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 a37:	29 00                	sub    %eax,(%eax)
 a39:	70 75                	jo     ab0 <bootmain-0x27f550>
 a3b:	74 66                	je     aa3 <bootmain-0x27f55d>
 a3d:	6f                   	outsl  %ds:(%esi),(%dx)
 a3e:	6e                   	outsb  %ds:(%esi),(%dx)
 a3f:	74 38                	je     a79 <bootmain-0x27f587>
 a41:	3a 46 28             	cmp    0x28(%esi),%al
 a44:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a47:	38 29                	cmp    %ch,(%ecx)
 a49:	00 78 3a             	add    %bh,0x3a(%eax)
 a4c:	70 28                	jo     a76 <bootmain-0x27f58a>
 a4e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a51:	29 00                	sub    %eax,(%eax)
 a53:	79 3a                	jns    a8f <bootmain-0x27f571>
 a55:	70 28                	jo     a7f <bootmain-0x27f581>
 a57:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a5a:	29 00                	sub    %eax,(%eax)
 a5c:	66 6f                	outsw  %ds:(%esi),(%dx)
 a5e:	6e                   	outsb  %ds:(%esi),(%dx)
 a5f:	74 3a                	je     a9b <bootmain-0x27f565>
 a61:	70 28                	jo     a8b <bootmain-0x27f575>
 a63:	31 2c 32             	xor    %ebp,(%edx,%esi,1)
 a66:	29 00                	sub    %eax,(%eax)
 a68:	72 6f                	jb     ad9 <bootmain-0x27f527>
 a6a:	77 3a                	ja     aa6 <bootmain-0x27f55a>
 a6c:	72 28                	jb     a96 <bootmain-0x27f56a>
 a6e:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a71:	29 00                	sub    %eax,(%eax)
 a73:	63 6f 6c             	arpl   %bp,0x6c(%edi)
 a76:	3a 72 28             	cmp    0x28(%edx),%dh
 a79:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a7c:	29 00                	sub    %eax,(%eax)
 a7e:	70 75                	jo     af5 <bootmain-0x27f50b>
 a80:	74 73                	je     af5 <bootmain-0x27f50b>
 a82:	38 3a                	cmp    %bh,(%edx)
 a84:	46                   	inc    %esi
 a85:	28 30                	sub    %dh,(%eax)
 a87:	2c 31                	sub    $0x31,%al
 a89:	38 29                	cmp    %ch,(%ecx)
 a8b:	00 70 72             	add    %dh,0x72(%eax)
 a8e:	69 6e 74 64 65 62 75 	imul   $0x75626564,0x74(%esi),%ebp
 a95:	67 3a 46 28          	cmp    0x28(%bp),%al
 a99:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 a9c:	38 29                	cmp    %ch,(%ecx)
 a9e:	00 69 3a             	add    %ch,0x3a(%ecx)
 aa1:	70 28                	jo     acb <bootmain-0x27f535>
 aa3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 aa6:	29 00                	sub    %eax,(%eax)
 aa8:	66 6f                	outsw  %ds:(%esi),(%dx)
 aaa:	6e                   	outsb  %ds:(%esi),(%dx)
 aab:	74 3a                	je     ae7 <bootmain-0x27f519>
 aad:	28 30                	sub    %dh,(%eax)
 aaf:	2c 32                	sub    $0x32,%al
 ab1:	31 29                	xor    %ebp,(%ecx)
 ab3:	00 70 75             	add    %dh,0x75(%eax)
 ab6:	74 66                	je     b1e <bootmain-0x27f4e2>
 ab8:	6f                   	outsl  %ds:(%esi),(%dx)
 ab9:	6e                   	outsb  %ds:(%esi),(%dx)
 aba:	74 31                	je     aed <bootmain-0x27f513>
 abc:	36 3a 46 28          	cmp    %ss:0x28(%esi),%al
 ac0:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 ac3:	38 29                	cmp    %ch,(%ecx)
 ac5:	00 66 6f             	add    %ah,0x6f(%esi)
 ac8:	6e                   	outsb  %ds:(%esi),(%dx)
 ac9:	74 3a                	je     b05 <bootmain-0x27f4fb>
 acb:	70 28                	jo     af5 <bootmain-0x27f50b>
 acd:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 ad0:	33 29                	xor    (%ecx),%ebp
 ad2:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 ad7:	39 29                	cmp    %ebp,(%ecx)
 ad9:	00 70 75             	add    %dh,0x75(%eax)
 adc:	74 73                	je     b51 <bootmain-0x27f4af>
 ade:	31 36                	xor    %esi,(%esi)
 ae0:	3a 46 28             	cmp    0x28(%esi),%al
 ae3:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 ae6:	38 29                	cmp    %ch,(%ecx)
 ae8:	00 69 64             	add    %ch,0x64(%ecx)
 aeb:	74 67                	je     b54 <bootmain-0x27f4ac>
 aed:	64                   	fs
 aee:	74 2e                	je     b1e <bootmain-0x27f4e2>
 af0:	63 00                	arpl   %ax,(%eax)
 af2:	73 65                	jae    b59 <bootmain-0x27f4a7>
 af4:	74 67                	je     b5d <bootmain-0x27f4a3>
 af6:	64                   	fs
 af7:	74 3a                	je     b33 <bootmain-0x27f4cd>
 af9:	46                   	inc    %esi
 afa:	28 30                	sub    %dh,(%eax)
 afc:	2c 31                	sub    $0x31,%al
 afe:	38 29                	cmp    %ch,(%ecx)
 b00:	00 73 64             	add    %dh,0x64(%ebx)
 b03:	3a 70 28             	cmp    0x28(%eax),%dh
 b06:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b09:	39 29                	cmp    %ebp,(%ecx)
 b0b:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 b10:	33 29                	xor    (%ecx),%ebp
 b12:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
 b16:	69 74 3a 70 28 30 2c 	imul   $0x342c3028,0x70(%edx,%edi,1),%esi
 b1d:	34 
 b1e:	29 00                	sub    %eax,(%eax)
 b20:	62 61 73             	bound  %esp,0x73(%ecx)
 b23:	65 3a 70 28          	cmp    %gs:0x28(%eax),%dh
 b27:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b2a:	29 00                	sub    %eax,(%eax)
 b2c:	61                   	popa   
 b2d:	63 63 65             	arpl   %sp,0x65(%ebx)
 b30:	73 73                	jae    ba5 <bootmain-0x27f45b>
 b32:	3a 70 28             	cmp    0x28(%eax),%dh
 b35:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b38:	29 00                	sub    %eax,(%eax)
 b3a:	73 64                	jae    ba0 <bootmain-0x27f460>
 b3c:	3a 72 28             	cmp    0x28(%edx),%dh
 b3f:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b42:	39 29                	cmp    %ebp,(%ecx)
 b44:	00 6c 69 6d          	add    %ch,0x6d(%ecx,%ebp,2)
 b48:	69 74 3a 72 28 30 2c 	imul   $0x342c3028,0x72(%edx,%edi,1),%esi
 b4f:	34 
 b50:	29 00                	sub    %eax,(%eax)
 b52:	62 61 73             	bound  %esp,0x73(%ecx)
 b55:	65 3a 72 28          	cmp    %gs:0x28(%edx),%dh
 b59:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b5c:	29 00                	sub    %eax,(%eax)
 b5e:	61                   	popa   
 b5f:	63 63 65             	arpl   %sp,0x65(%ebx)
 b62:	73 73                	jae    bd7 <bootmain-0x27f429>
 b64:	3a 72 28             	cmp    0x28(%edx),%dh
 b67:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b6a:	29 00                	sub    %eax,(%eax)
 b6c:	73 65                	jae    bd3 <bootmain-0x27f42d>
 b6e:	74 69                	je     bd9 <bootmain-0x27f427>
 b70:	64                   	fs
 b71:	74 3a                	je     bad <bootmain-0x27f453>
 b73:	46                   	inc    %esi
 b74:	28 30                	sub    %dh,(%eax)
 b76:	2c 31                	sub    $0x31,%al
 b78:	38 29                	cmp    %ch,(%ecx)
 b7a:	00 67 64             	add    %ah,0x64(%edi)
 b7d:	3a 70 28             	cmp    0x28(%eax),%dh
 b80:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 b83:	30 29                	xor    %ch,(%ecx)
 b85:	3d 2a 28 31 2c       	cmp    $0x2c31282a,%eax
 b8a:	34 29                	xor    $0x29,%al
 b8c:	00 6f 66             	add    %ch,0x66(%edi)
 b8f:	66                   	data16
 b90:	73 65                	jae    bf7 <bootmain-0x27f409>
 b92:	74 3a                	je     bce <bootmain-0x27f432>
 b94:	70 28                	jo     bbe <bootmain-0x27f442>
 b96:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 b99:	29 00                	sub    %eax,(%eax)
 b9b:	73 65                	jae    c02 <bootmain-0x27f3fe>
 b9d:	6c                   	insb   (%dx),%es:(%edi)
 b9e:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
 ba3:	3a 70 28             	cmp    0x28(%eax),%dh
 ba6:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 ba9:	29 00                	sub    %eax,(%eax)
 bab:	67 64 3a 72 28       	cmp    %fs:0x28(%bp,%si),%dh
 bb0:	30 2c 32             	xor    %ch,(%edx,%esi,1)
 bb3:	30 29                	xor    %ch,(%ecx)
 bb5:	00 6f 66             	add    %ch,0x66(%edi)
 bb8:	66                   	data16
 bb9:	73 65                	jae    c20 <bootmain-0x27f3e0>
 bbb:	74 3a                	je     bf7 <bootmain-0x27f409>
 bbd:	72 28                	jb     be7 <bootmain-0x27f419>
 bbf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 bc2:	29 00                	sub    %eax,(%eax)
 bc4:	73 65                	jae    c2b <bootmain-0x27f3d5>
 bc6:	6c                   	insb   (%dx),%es:(%edi)
 bc7:	65 63 74 6f 72       	arpl   %si,%gs:0x72(%edi,%ebp,2)
 bcc:	3a 72 28             	cmp    0x28(%edx),%dh
 bcf:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 bd2:	29 00                	sub    %eax,(%eax)
 bd4:	69 6e 69 74 5f 67 64 	imul   $0x64675f74,0x69(%esi),%ebp
 bdb:	74 69                	je     c46 <bootmain-0x27f3ba>
 bdd:	64                   	fs
 bde:	74 3a                	je     c1a <bootmain-0x27f3e6>
 be0:	46                   	inc    %esi
 be1:	28 30                	sub    %dh,(%eax)
 be3:	2c 31                	sub    $0x31,%al
 be5:	38 29                	cmp    %ch,(%ecx)
 be7:	00 69 6e             	add    %ch,0x6e(%ecx)
 bea:	74 2e                	je     c1a <bootmain-0x27f3e6>
 bec:	63 00                	arpl   %ax,(%eax)
 bee:	69 6e 69 74 5f 70 69 	imul   $0x69705f74,0x69(%esi),%ebp
 bf5:	63 3a                	arpl   %di,(%edx)
 bf7:	46                   	inc    %esi
 bf8:	28 30                	sub    %dh,(%eax)
 bfa:	2c 31                	sub    $0x31,%al
 bfc:	38 29                	cmp    %ch,(%ecx)
 bfe:	00 69 6e             	add    %ch,0x6e(%ecx)
 c01:	74 68                	je     c6b <bootmain-0x27f395>
 c03:	61                   	popa   
 c04:	6e                   	outsb  %ds:(%esi),(%dx)
 c05:	64                   	fs
 c06:	6c                   	insb   (%dx),%es:(%edi)
 c07:	65                   	gs
 c08:	72 32                	jb     c3c <bootmain-0x27f3c4>
 c0a:	31 3a                	xor    %edi,(%edx)
 c0c:	46                   	inc    %esi
 c0d:	28 30                	sub    %dh,(%eax)
 c0f:	2c 31                	sub    $0x31,%al
 c11:	38 29                	cmp    %ch,(%ecx)
 c13:	00 65 73             	add    %ah,0x73(%ebp)
 c16:	70 3a                	jo     c52 <bootmain-0x27f3ae>
 c18:	70 28                	jo     c42 <bootmain-0x27f3be>
 c1a:	30 2c 31             	xor    %ch,(%ecx,%esi,1)
 c1d:	39 29                	cmp    %ebp,(%ecx)
 c1f:	3d 2a 28 30 2c       	cmp    $0x2c30282a,%eax
 c24:	31 29                	xor    %ebp,(%ecx)
 c26:	00 2f                	add    %ch,(%edi)
 c28:	74 6d                	je     c97 <bootmain-0x27f369>
 c2a:	70 2f                	jo     c5b <bootmain-0x27f3a5>
 c2c:	63 63 35             	arpl   %sp,0x35(%ebx)
 c2f:	77 65                	ja     c96 <bootmain-0x27f36a>
 c31:	4c                   	dec    %esp
 c32:	51                   	push   %ecx
 c33:	58                   	pop    %eax
 c34:	2e 73 00             	jae,pn c37 <bootmain-0x27f3c9>
 c37:	61                   	popa   
 c38:	73 6d                	jae    ca7 <bootmain-0x27f359>
 c3a:	69 6e 74 33 32 2e 53 	imul   $0x532e3233,0x74(%esi),%ebp
	...
