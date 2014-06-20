src=bootloader.S
obj=bootloader.o
elf=bootloader.elf
boot=bootloader.out
asm=bootloader.asm
kernel=kernel.out
#kernel start 0xc400


all:
	gcc -c $(src) -m32 -o $(obj)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)
	@dd if=/dev/zero of=$(boot) seek=2 count=2878 >> /dev/zero

copy:all
	@ls -al $(boot)
	cd kernel;make address=0xc400;mv kernel.out ../
	sudo mount -o loop   $(boot)  /mnt
	sudo cp $(kernel) /mnt
	sudo umount /mnt

#run os as a harddisk , i don`t use "if=floppy"
run:copy
	#qemu -s -S  $(boot)
	qemu   -drive file=$(boot)






lib:
	cd ./kernel;make lib;

clean:
	-rm *.img *.out *.o *.elf *.asm
	cd ./kernel;make clean;cd ../
cleanall:clean
	cd ./kernel/ucgui;make clean

#write to the usb
dd:
	-sudo umount /dev/sdb
	sudo dd if=$(boot) of=/dev/sdb
#run qemu from usb
runusb:dd
	sudo qemu -drive file=/dev/sdb
#run os as a harddisk , i don`t use "if=floppy"
runfloppy:
	qemu -m 2048M -drive file=$(os),if=floppy


done:
	make clean && make && make copy && make run


