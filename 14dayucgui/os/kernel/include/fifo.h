#ifndef __fifo_h_
#define __fifo_h_

//这个数据结构，就是为fifo数据类型准备的
struct FIFO8
{
  unsigned char *buf;//this  is a pointer which point to fifo queue
  int nw;//next_write
  int nr;//next_read
  int size;//这个地方可以根据外面定义的数组的大小，来赋值。
  int free;//empty bytes
  int flags;//
};
struct FIFO32
{
  unsigned  * buf;//this  is a pointer which point to fifo queue
  int nw;//next_write
  int nr;//next_read
  int size;//这个地方可以根据外面定义的数组的大小，来赋值。
  int free;//empty bytes
  int flags;//
};




extern void fifo8_init(struct FIFO8 *fifo,int size ,unsigned char *buf);
extern int  fifo8_write(struct FIFO8 *fifo,unsigned char data);
extern int  fifo8_read(struct FIFO8 *fifo);
extern int  fifo8_status(struct FIFO8 *fifo);

extern void fifo32_init(struct FIFO32 *fifo,int size ,unsigned  *buf);
extern int  fifo32_write(struct FIFO32 *fifo,unsigned  data);
extern int  fifo32_read(struct FIFO32 *fifo);
extern int  fifo32_status(struct FIFO32 *fifo);




#endif
