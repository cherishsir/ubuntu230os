#include<head.h>
#include<x86.h>

typedef void (* fpt)(char color);
void bootmain()
{
 init_palette();
clear_screen(15);
//boxfill8( (unsigned char *)0xa0000,320,0,    0,0,30,40);
draw_window();
bootinfo *btinfo=(bootinfo *)0xff0;
init_screen(btinfo);

//while(1);


putchar('a',7,30,40);

/*
if(btinfo->xsize=320)
clear_screen(3  );
*/
 puts("1234355656",3,10,70);
 puts("hello world",8,10,100);
 //显示变量，只是实现了%d的处理，后面的以后再完善
 int a=320,b=200;
 char str[20];
 sprintf(str,"xsize=%d,ysize=%d",a,b);
 puts(str,8,10,130);
 char mouse[16*16];

init_gdtidt();
init_mouse(mouse,7);
display_mouse((char*)0xa0000,320,16,16,160,100,mouse,16);
fpt cls=clear_screen;
(*cls)(3);
//display_mouse((char*)0xa0000,320,16,16,160,100,mouse,16);



  while(1);
}
