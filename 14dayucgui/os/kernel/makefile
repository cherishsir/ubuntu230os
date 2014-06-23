#this makefile will create  "head" file and "ckernel" file
#then cat "ckernel" file  >> "head" ,last mv  "head"  "kernel"
OBJCOPY	:= $(GCCPREFIX)objcopy
OBJDUMP	:= $(GCCPREFIX)objdump
include=-I./include -I./ucgui/GUI/Core/ -I./ucgui/Config -I/usr/include/ -I/usr/include/i386-linux-gnu/
entry_objs= entry.o
ccode_objs=main.o screen.o timer.o font.o  idtgdt.o int.o asmint32.o fifo.o  mm.o \
game.o
CFLAGS := $(CFLAGS) -O1  $(include) -MD
CFLAGS += -fno-omit-frame-pointer -w
CFLAGS += -Wall -Wno-format -Wno-unused  -gstabs -m32  -fno-stack-protector
LDFLAGS = -m elf_i386
addr=0xc400
LIB= -lucgui -lm -L./ -L/usr/lib/i386-linux-gnu/ -L/usr/lib/i386-linux-gnu/

#this format LIB=/usr/lib/i386-linux-gnu/libc.a /usr/lib/i386-linux-gnu/libm.a libucgui.a
#this will make   source compiled  to  object file
%.o:%.c
	$(CC) -nostdinc $(CFLAGS) -Os -c -o $@ $<

#will generate  entry.o asmint32.o
%.o:%.S
	$(CC) -g -nostdinc $(CFLAGS) -c -o $@ $<



kernel.out:head ckernel
	cat ckernel >> head
	cp  head kernel.out

head:$(entry_objs)
ckernel:$(ccode_objs)
lib:
	cd ucgui/;make lib


#generate head file
head:
	@echo "addr=$(addr)"
	$(LD)  $(LDFLAGS) -N -e entry -Ttext 0xc400 -o $@.out $^
	$(OBJDUMP) -S -D $@.out >$@.asm
	$(OBJCOPY) --only-keep-debug $@.out head.sym
	cp head.sym ../
	$(OBJCOPY) -S -O binary -j .text $@.out $@

#generate ckernel
ckernel:
	@echo "addr=0x280000"
	$(LD)  $(LDFLAGS) -N -e bootmain -T kernel.ld -o $@.out $^ $(LIB)
	$(OBJDUMP)  -S -D $@.out >$@.asm
	$(OBJCOPY)  -S -O binary  $@.out $@


clean:
	-rm -f *.d *.o *.out  head ckernel kernel *.asm entry








