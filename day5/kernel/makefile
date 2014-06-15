src=head.S
obj=head.o
elf=head.elf
boot=head.out
asm=head.asm
address=0xc400
CFLAGS=-I.  -fno-stack-protector

kernelobj=main.o screen.o idtgdt.o asmint32.o
%.o:%.c
	gcc  -nostdinc $(CFLAGS) -c $< -m32 -o $@

%.o:%.S
	gcc -nostdinc $(CFLAGS) -c $< -m32 -o $@

all: head main
	cat main.out >> head.out
	mv head.out  kernel.out


head:head.o
main:$(kernelobj)
head:
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)


main:
	@echo "addr=0x00"
	ld -m elf_i386  -e bootmain -T kernel.ld -o main.elf $(kernelobj)
	objdump -S -D $@.elf >$@.asm
	objcopy  -S -O binary  $@.elf $@.out


fat12:
	@dd if=/dev/zero of=$(boot) seek=2 count=2878 >> /dev/zero
	@ls -al $(boot)

run:
	qemu -fda $(boot)

writeusb:
	sudo dd if=$(boot) of=/dev/sdb
runusb:writeusb
	sudo qemu   -drive file=/dev/sdb
clean:
	-rm -f $(obj) $(elf) $(boot) $(asm) *.o main.out

umount:
	sudo umount /dev/sdb


