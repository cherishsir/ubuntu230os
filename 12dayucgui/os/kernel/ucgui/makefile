TOPDIR=$(shell pwd)
SUBDIRS=Config GUI
UCGUILIB=libucgui.a
OBJS=$(shell ls *.o)

all:
	@for dir in $(SUBDIRS); \
	do cd $$dir;make;cd ..; \
	done
obj:
	cd ./GUI;make lib && cd ../
lib:obj

	@ar  rcs $(UCGUILIB) $(OBJS)
	@mv $(UCGUILIB) ..
	@rm *.o
clean:
	-rm -f *.o
	@for dir in $(SUBDIRS); \
	do cd $$dir;make clean;cd ..; \
	done




