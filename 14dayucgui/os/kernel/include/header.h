#ifndef header
#define header
#include<x86.h>
#include<types.h>

#include<font.h>
#include<mm.h>
#include<timer.h>
#include<screen.h>
#include<idtgdt.h>
#include<int.h>
#include<fontascii.h>
#include<GUIType.h>
#include<GUI.h>
#include<errno.h>
#include<math.h>
#include<game.h>
/*global variable is here*/
extern  GUI_CONTEXT GUI_Context; //in gui.h maybe
extern  TIMERCTL *gtimerctl;     //in timer.c
extern struct FIFO32 *keyfifo;     //in int.c
extern struct FIFO32 *mousefifo;   //in int.c
extern struct boot_info *gboot;
extern  char keytable[0x54];
#endif
