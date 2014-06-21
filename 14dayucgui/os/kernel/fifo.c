#include<fifo.h>
#include<font.h>

//初始化fifo8,是对一个结构体类型的变量进行初始化，这个结构体类型的变量就是一个fifo对象。
void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf)
{
  fifo->buf=buf;
  fifo->size=size;
  fifo->free=size;
  fifo->nr=0;
  fifo->nw=0;
  fifo->flags=0;
}
void fifo32_init(struct FIFO32 *fifo,int size ,unsigned  *buf)
{
  fifo->buf=buf;
  fifo->size=size;
  fifo->free=size;
  fifo->nr=0;
  fifo->nw=0;
  fifo->flags=0;
}


#define FLAGS_OVERRUN 0X0001
//下面的函数是对fifo类型的变量，写入数据。
int fifo8_write(struct FIFO8 *fifo,unsigned char data)
{
  if(fifo->free==0)//fifo is full ,no room for any data
  {
    fifo->flags|=FLAGS_OVERRUN;//if fifo->flags is TRUE, fifo已经满了，不能再写了。
    return -1; //write error
  }


 fifo->buf[fifo->nw]=data;
 fifo->nw++;
 if(fifo->nw==fifo->size)
 {
  fifo->nw=0;
 }
 fifo->free--;
 return 0;//write sucessful

}

int fifo32_write(struct FIFO32 *fifo,unsigned  data)
{
  if(fifo->free==0)//fifo is full ,no room for any data
  {
    fifo->flags|=FLAGS_OVERRUN;//if fifo->flags is TRUE, fifo已经满了，不能再写了。
    return -1; //write error
  }


 fifo->buf[fifo->nw]=data;
 fifo->nw++;
 if(fifo->nw==fifo->size)
 {
  fifo->nw=0;
 }
 fifo->free--;
 return 0;//write sucessful

}


//只有写fifo 会有fifo full的情况，
//读fifo时，会有empty的情况。
int fifo8_read(struct FIFO8 *fifo)
{
  int data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  }

  data=fifo->buf[fifo->nr];
  fifo->nr++;
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;

  return data;


}

int fifo32_read(struct FIFO32 *fifo)
{
   unsigned  data;
  if(fifo->free==fifo->size)//fifo is empty ,no data is useful
  {
    return -1;
  }

  data=fifo->buf[fifo->nr];
  fifo->nr++;
  if(fifo->nr==fifo->size)
  {
    fifo->nr=0;
  }
  fifo->free++;

  return data;


}

int fifo32_status(struct FIFO32 *fifo)
{
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
}

int fifo8_status(struct FIFO8 *fifo)
{
  return fifo->size-fifo->free;//总数－空的＝有多个data在fifo中。
}
