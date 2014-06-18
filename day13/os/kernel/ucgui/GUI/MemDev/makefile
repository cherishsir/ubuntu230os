TOPDIR=$(shell pwd)
SUBDIRS=AntiAlias ConvertMono Font LCDDriver MultiLayer WM ConvertColor Core JPEG MemDev Widget
SRCS=$(shell ls *.c)
OBJS= $(patsubst %.c,%.o,$(SRCS))
CFLAGS= -I../Core/  -I../../Config -I../WM/ -I./  -I../ -I../Widget
CFLAGS+=-m32
%.o:%.c %.h
	gcc $(CFLAGS) -c  -o $@ $<

lib:$(OBJS)
	@cp $(OBJS) ../


clean:
	rm -f *.o
	@echo "remove done"

	
	

#	do cd $$dir;rm *.bak *.bat *.scc;cd ..; \
