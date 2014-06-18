#ifndef _TIMER_H_
#define _TIMER_H_
#include<header.h>
#define MAX_TIMER 500
#define ALLOC   1
#define RUNNING  2
//struct timer count,just one timeout dog
typedef struct{
 unsigned flag;
 unsigned timeout;
 struct FIFO8 *fifo;
 unsigned char data;
}TIMER;

typedef struct{
 unsigned int count;
 unsigned number;
 TIMER timer[MAX_TIMER];
}TIMERCTL;
extern TIMERCTL timerctl;

#endif
