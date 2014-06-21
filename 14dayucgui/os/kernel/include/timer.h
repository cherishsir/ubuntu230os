#ifndef _TIMER_H_
#define _TIMER_H_
#define MAX_TIMER 500
#define ALLOC   1
#define RUNNING  2
//struct timer count,just one timeout dog
typedef struct{
 unsigned flag;
 unsigned timeout;
 struct FIFO32 *fifo;
 unsigned  data;
}TIMER;

typedef struct{
 unsigned int count;
 unsigned number;
 TIMER timer[MAX_TIMER];
}TIMERCTL;

extern void init_pit(TIMERCTL *timerctl);
extern void inthandler20(int* esp);
extern TIMER * timer_alloc(TIMERCTL * timerctl,unsigned i);
extern void timer_init(TIMER *timer,struct FIFO32 *fifo,unsigned  data);
extern void timer_free(TIMER *timer);
extern void timer_settime(TIMER *timer,unsigned timeout,TIMERCTL * timerctl);
#endif
