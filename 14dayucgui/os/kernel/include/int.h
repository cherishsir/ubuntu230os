#ifndef __INT_H_
#define __INT_H_
#include<fifo.h>
#include<x86.h>
/*与中断有关的函数*/
//pic master is pic 0:port 0x20 0x21 ,
//pic slave  is pic 1:port 0xa0 0xa1
#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021

#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1

//通过下面的port得到keyboard code
#define PORT_KEYDAT 0x0060
#define PORT_KEYSTA 		0X0064
#define PORT_KEYCMD 		0X0064
#define KEYSTA_SEND_NOTREADY 	(1<<1)
#define KEYCMD_WRITE_MODE 	0X60
#define KBC_MODE		0X47
#define KEYCMD_SENDTO_MOUSE 	0XD4
#define MOUSECMD_ENABLE     	0XF4

//about mouse
struct MOUSE_DEC
{
  unsigned char buf[3];
  unsigned char phase;
  int x,y;
  int button;

};


extern void inthandler21(int *esp);
extern void inthandler2c(int *esp);
extern int mouse_decode(struct MOUSE_DEC *mdec,unsigned char data);
extern void init_pic();
//下面3个函数是汇编写的
extern void asm_inthandler21();
extern void asm_inthandler2c();
extern void asm_inthandler20();

extern void init_keyboard(struct FIFO32 *fifo,unsigned data);
extern void enable_mouse(struct FIFO32 *fifo,unsigned data,struct MOUSE_DEC *mdec);

#endif
