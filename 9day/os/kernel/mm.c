#include<mm.h>


unsigned int getmemorysize(unsigned int start,unsigned int end)
{

 unsigned int  i;
 unsigned int old;

 //下面的程度只能检测小于4GB的内存，而且 4GB的内存也只能检测为2488MB
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



