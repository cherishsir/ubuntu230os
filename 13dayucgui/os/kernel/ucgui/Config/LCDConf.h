/*
*********************************************************************************************************
*                                                uC/GUI
*                        Universal graphic software for embedded applications
*
*                       (c) Copyright 2002, Micrium Inc., Weston, FL
*                       (c) Copyright 2002, SEGGER Microcontroller Systeme GmbH
*
*              µC/GUI is protected by international copyright laws. Knowledge of the
*              source code may not be used to write a similar product. This file may
*              only be used in accordance with a license and should not be redistributed
*              in any way. We appreciate your understanding and fairness.
*
----------------------------------------------------------------------
File        : LCDConf_1375_C8_C320x240.h
Purpose     : Sample configuration file
----------------------------------------------------------------------
*/

#ifndef LCDCONF_H
#define LCDCONF_H

/*********************************************************************
*
*                   General configuration of LCD
*
**********************************************************************
*/

#define LCD_XSIZE      (320)   /* X-resolution of LCD, Logical coor. */
#define LCD_YSIZE      (200)   /* Y-resolution of LCD, Logical coor. */

#define LCD_BITSPERPIXEL (8)
//#define LCD_BITSPERPIXEL (16)

#define LCD_CONTROLLER 0

/*********************************************************************
*
*                   Full bus configuration
*
**********************************************************************
*/

#define LCD_READ_MEM(Off)            *((U8*)         (0x400000+(((U32)(Off)))))
#define LCD_WRITE_MEM(Off,data)      *((U8*)         (0x400000+(((U32)(Off)))))=data


/*********************************************************************
*
*                   Init sequence for 16 bit access
*
**********************************************************************
*/



#define LCD_INIT_CONTROLLER()    ;

#endif /* LCDCONF_H */


