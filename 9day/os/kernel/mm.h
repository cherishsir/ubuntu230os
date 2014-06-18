#ifndef __MM_H__
#define __MM_H__
#include<x86.h>
#define EFLAGS_AC_BIT            0x00040000
#define CR0_CACHE_DISABLE        0x60000000

typedef struct Cell
{
 unsigned int address;
 unsigned int size;
}Cell;
typedef struct Memman
{
unsigned int cellnum;
unsigned int maxcell;
unsigned int lostsize;
unsigned int losts;
Cell  cell[4090];
}Memman;



extern unsigned int memtest(unsigned int start,unsigned int end);
extern unsigned int memman_avail(Memman *man);
extern void memman_init(Memman * man);
extern  int memman_alloc(Memman *man,unsigned int size);
extern int memman_free(Memman *man,unsigned int addr,unsigned int size);



#endif
