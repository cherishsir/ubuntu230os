#include<head.h>
void bootmain()
{

int i=0xa0000;
for (;i<=0xaffff;i++)
 *((char*)i)=15;
 init_palette();
/*
for (i=0xa0000;i<=0xaffff;i++)
 *((char*)i)=i&0x0f;

*/
 char *p=0xa0000;
 for (i=0;i<=0xffff;i++)
  *(p+i)=i&0xf;
clear_screen(15);
//boxfill8( (unsigned char *)0xa0000,320,0,    0,0,30,40);
draw_window();

  while(1);
}
