#include<mm.h>

 //下面的程序只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
unsigned int getmemorysize(unsigned int start,unsigned int end)
{

 unsigned int  i;
 unsigned int old;


 unsigned int pat0=0xaa55aa55;
 volatile unsigned int *p;//注意这里的volatile关键字,
 for(i=start;i<=end;i+=0x1000)
 {
  p=(unsigned int *)i+0x200;
  old=*p;
  *p=pat0;
  if(*p!=pat0)
  {
   *p=old;
   break;
  }
  *p=old;

 }
 return i;//i就是得到的memory size



}

unsigned int memtest(unsigned int start,unsigned int end)
{
 char flg486=0;
 unsigned int eflg,cr0,i;
 eflg=read_eflags();
 eflg|=EFLAGS_AC_BIT;
 write_eflags(eflg);

 eflg=read_eflags();
 if((eflg&EFLAGS_AC_BIT)!=0)
 {
  flg486=1;
  eflg&=~EFLAGS_AC_BIT;
  write_eflags(eflg);
 }
 if(flg486)
 {
  cr0=rcr0();
  cr0|=CR0_CACHE_DISABLE;
  lcr0(cr0);
 }


i=getmemorysize(start,end);
//i=0x100000;

  if(flg486)
  {
  cr0=rcr0();
  cr0&=~CR0_CACHE_DISABLE;
  lcr0(cr0);

  }

  return i;
}


void memman_init(Memman * man)
{
 man->cellnum=0;
 man->maxcell=0;
 man->lostsize=0;
 man->losts=0;
}
//get available memory
unsigned int memman_avail(Memman *man)
{
 unsigned int i;
 unsigned int freemem=0;
 for (i=0;i<man->cellnum;i++)
 {
   freemem+=man->cell[i].size;
 }
 return freemem;
}
//return an integer but is ad  address
int memman_alloc_4K(Memman *man,unsigned int size)
{
  size=(size+0xfff)&0xfffff000;
  return memman_alloc(man,size);
}
//allocate some memory for you
 int memman_alloc(Memman *man,unsigned int size)
{
    unsigned int i,a;
    for (i=0;i<man->cellnum;i++)
    {
        if(man->cell[i].size>size)
        {
            a=man->cell[i].address;
            man->cell[i].address+=size;
            man->cell[i].size-=size;
            if(man->cell[i].size==0)
            {
                man->cellnum--;
                for(;i<man->cellnum;i++)
                {
                    man->cell[i]=man->cell[i+1];
                }

            }

            return a;
        }
    }
    return 0; //no memory can be used
}

//return -1 means free memory failure
int memman_free_4k(Memman *man,unsigned int addr,unsigned int size)
{
  size=(size+0xfff)& 0xfffff000;
  return memman_free(man,addr,size);
}
//return -1 means free memory failure
int memman_free(Memman *man,unsigned int addr,unsigned int size)
{
  int i,j;
  for (i=0;i<man->cellnum;i++)
  {
    if(man->cell[i].address>addr)//这一步可以找到一个合适的i的地址范围
    {
      break;
    }
  }

  //man->cell[i-1].address<addr<man->cell[i].address
  //与前面空间合并
  if(i>0)  //
  {
    if(man->cell[i-1].address+man->cell[i-1].size==addr)
    {
        man->cell[i-1].size+=size;
        if(i<man->cellnum)
        {
            if(addr+size==man->cell[i].address)
            {
                man->cell[i-1].size+=man->cell[i].size;
                man->cellnum--;

                for(;i<man->cellnum;i++)
                {
                man->cell[i]=man->cell[i+1];
                }
            }
        }
        return 0;
    }
     //printdebug(200,100);

  }

  //与后面的空间合并
  if(i<man->cellnum)
  {
     if(addr+size==man->cell[i].address)
     {
        man->cell[i].address=addr;
        man->cell[i].size+=size;

        return 0;
     }
  }

  if(man->cellnum<4090)
  {
        for(j=man->cellnum;j>i;j--)
        {
            man->cell[j]=man->cell[j-1];
        }

        man->cellnum++;
        if(man->maxcell<man->cellnum)
        {
            man->maxcell=man->cellnum;
        }
        man->cell[i].address=addr;
        man->cell[i].size=size;
       // printdebug(man->cellnum,100);
        return 0;
  }


  man->losts++;
  man->lostsize+=size;

  return  -1;
}

SHTCTL * shtctl_init(Memman * memman,unsigned char *vram,int xsize,int ysize)
{
  SHTCTL *ctl;
  int i;
  ctl=(SHTCTL *)memman_alloc_4K(memman,sizeof(SHTCTL));
  if(ctl==0)
  return ctl;
  ctl->map=(unsigned char *)memman_alloc_4K(memman,xsize*ysize);

  if(ctl->map==0)
    {
     memman_free_4k(memman,(int)ctl,sizeof(SHTCTL));
     return 0;
    }
  ctl->vram=vram;
  ctl->xsize=xsize;
  ctl->ysize=ysize;
  ctl->top=-1;  //no sheet
  for(i=0;i<MAX_SHEETS;i++)
  {
    ctl->sheet[i].flags=0;
    ctl->sheet[i].ctl=ctl;
  }
  return ctl;
}

SHEET * sheet_alloc(SHTCTL * ctl)
{
  SHEET *  sht;
  int i;
  for (i=0;i<MAX_SHEETS;i++)
  {
    if (ctl->sheet[i].flags==0)
    {
        sht=&ctl->sheet[i];
        sht->flags=1;
        sht->height=-1;
        return sht;
    }
  }
  return 0;
}



void sheet_setbuf(SHEET * sht,unsigned char *buf,int xsize,int ysize,int col_inv)
{
  sht->buf=buf;
  sht->bxsize=xsize;
  sht->bysize=ysize;
  sht->col_inv=col_inv;
  return ;
}


void sheet_updown(SHEET * sht,int height)
{
 int h ,old=sht->height;
 SHTCTL *ctl=sht->ctl;
 if(height>ctl->top+1)
 {
  height=ctl->top+1;
 }

 if(height<-1)
 {
  height=-1;
 }
 sht->height=height;

 if(old>height)
 {
   if(height>=0)
   {
        for(h=old;h>height;h--)
        {
            ctl->sheets[h]=ctl->sheets[h-1];
            ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,sht->height+1);

        sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,sht->height+1,old);

   }
   else
   {
        if(ctl->top>old)
        {
            for(h=old;h<ctl->top;h++)
            {
                ctl->sheets[h]=ctl->sheets[h+1];
                ctl->sheets[h]->height=h;
            }

        }
        ctl->top--;
        sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0);
        sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,0,old-1);

   }
 }
 else if(old<height)
 {

    if(old>0)
    {

        for(h=old;h<height;h++)
        {
         ctl->sheets[h]=ctl->sheets[h+1];
         ctl->sheets[h]->height=h;
        }
        ctl->sheets[height]=sht;
    }
    else
    {

        for(h=ctl->top;h>=height;h--)
        {
            ctl->sheets[h+1]=ctl->sheets[h];
            ctl->sheets[h+1]->height=h+1;
        }
        ctl->sheets[height]=sht;
        ctl->top++;

    }
      sheet_refreshmap(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,height);
      sheet_refreshsub(ctl,sht->vx0,sht->vy0,sht->vx0+sht->bxsize,sht->vy0+sht->bysize,height,height);
 }

}

void sheet_refresh(SHEET * sht,int bx0,int by0,int bx1,int by1)
{
SHTCTL *ctl=sht->ctl;
if (sht->height>=0)
{
    sheet_refreshsub(ctl,sht->vx0+bx0,sht->vy0+by0,
    sht->vx0+bx1,sht->vy0+by1,sht->height,sht->height);

    }
}

void sheet_move(SHEET * sht,int vx0,int vy0)
{
SHTCTL * ctl=sht->ctl;
 int old_vx0=sht->vx0;
 int old_vy0=sht->vy0;

 sht->vx0=vx0;
 sht->vy0=vy0;
 if(sht->height>=0)
 {
    //移动之后map要重新生成
    sheet_refreshmap(ctl,old_vx0,old_vy0,old_vx0+sht->bxsize,old_vy0+sht->bysize,0);
    sheet_refreshmap(ctl,vx0,vy0,vx0+sht->bxsize,vy0+sht->bysize,sht->height);
    //sheet_refresh(ctl);
    sheet_refreshsub(ctl,old_vx0,old_vy0,old_vx0+sht->bxsize,old_vy0+sht->bysize,0,sht->height-1);
    sheet_refreshsub(ctl,vx0,vy0,vx0+sht->bxsize,vy0+sht->bysize,sht->height,sht->height);
 }
 return;
}


void sheet_refreshsub(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer,int layerend)
{
int h,bx,by,vx,vy,bx0,bx1,by0,by1;
unsigned char *buf,*vram=ctl->vram;
unsigned char sid;
unsigned char c;
unsigned char *map=ctl->map;


SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=layerend;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  by1=vy1-sht->vy0;

  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;

            c=map[vy*ctl->xsize+vx];
            if(c==sid)
            {
                vram[vy*ctl->xsize+vx]=buf[by*sht->bxsize+bx];;
            }

    }
  }
 // if(h==1)  while(1);

}
return;

}

void sheet_free(SHEET *sht)
{
 if(sht->height>=0)
 sheet_updown(sht,-1);

sht->flags=0;
return;
}



void sheet_refreshmap(SHTCTL *ctl,int vx0,int vy0,int vx1,int vy1,int layer)
{
int h,bx,by,vx,vy, bx0,by0,bx1,by1;
unsigned char *buf,*vram=ctl->vram;
unsigned char *map=ctl->map;
unsigned char sid;
unsigned char c;


SHEET *sht;
if(vx0<0)vx=0;
if(vy0<0)vy=0;
if(vx1>ctl->xsize)vx1=ctl->xsize;
if(vy1>ctl->ysize)vy1=ctl->ysize;
for (h=layer;h<=ctl->top;h++)
{
  sht=ctl->sheets[h];
  sid=sht-ctl->sheet;
  //printdebug((unsigned)sid,0);
  buf=sht->buf;

  bx0=vx0-sht->vx0;
  by0=vy0-sht->vy0;

  bx1=vx1-sht->vx0;
  by1=vy1-sht->vy0;
  if(bx0<0)bx0=0;
  if(by0<0)by0=0;
  if(bx1>sht->bxsize)bx1=sht->bxsize;
  if(by1>sht->bysize)by1=sht->bysize;
  for(by=by0;by<by1;by++)
  {
    vy=sht->vy0+by;
    for(bx=bx0;bx<bx1;bx++)
    {
        vx=sht->vx0+bx;
            c=buf[by*sht->bxsize+bx];
            if(c!=sht->col_inv)
            {
                map[vy*ctl->xsize+vx]=sid;
            }

    }
  }

}
return;

}
