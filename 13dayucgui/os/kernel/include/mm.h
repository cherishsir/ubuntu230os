#ifndef __MM_H__
#define __MM_H__
#include<x86.h>
#define EFLAGS_AC_BIT            0x00040000
#define CR0_CACHE_DISABLE        0x60000000


#define MAX_SHEETS 256
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

struct SHTCTL;

typedef struct SHEET
{
unsigned char * buf;
int bxsize;
int bysize;
int vx0;
int vy0;
int col_inv;
int height;
int flags;
struct SHTCTL * ctl;
}SHEET;

typedef struct SHTCTL
{
 unsigned char * vram,*map;
 int xsize;
 int ysize;
 int top;
 SHEET sheet[MAX_SHEETS];
 SHEET *sheets[MAX_SHEETS];

}SHTCTL;

extern void memman_init(Memman * man);
extern unsigned int getmemorysize(unsigned int start,unsigned int end);//retur all memory size
extern  int memman_alloc(Memman *man,unsigned int size);
extern int memman_alloc_4K(Memman *man,unsigned int size);
extern unsigned int memman_avail(Memman *man);                          //return all available size
extern int memman_free(Memman *man,unsigned int addr,unsigned int size);
extern int memman_free_4k(Memman *man,unsigned int addr,unsigned int size);

extern SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize);
extern SHEET * sheet_alloc(SHTCTL * ctl);
extern void sheet_free(SHEET *sht);
extern void sheet_move(SHEET * sht,int vx0,int vy0);
extern void sheet_refresh(SHEET * sht,int bx0,int by0,int bx1,int by1);
extern void sheet_refreshmap(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer);
extern void sheet_refreshsub(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer,int layerend);
extern void sheet_setbuf(SHEET * sht,unsigned char *buf,int xsize,int ysize,int col_inv);
extern void sheet_updown(SHEET * sht,int height);

#endif
