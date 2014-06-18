#usage:make && make copy && make run
#write os.img to usb:      make dd


subdir=./kernel ./ucgui
bootsector=bootloader.asm
usb=1
ifeq ($(usb),1)
bootsector=bootloaderusb.asm
endif
#bootloader 512bytes
bootbin=bootloader.img
#real fat12 os img
os=os.img

%.img:%.asm
	nasm -o $@  $^
all:
	nasm -o $(bootbin)  $(bootsector)
	cd ./kernel;make

#@cd $(subdir);make clean;make addr=0xc400

img:
	dd if=$(bootbin) of=$(os) bs=512 count=1
	dd if=/dev/zero of=$(os) bs=512 seek=1 skip=1 count=2879
copy:img
	sudo mount -o loop $(os) /mnt -o fat=12
	sudo cp kernel/kernel /mnt
	sudo umount /mnt
lib:
	cd ./kernel;make lib;

clean:
	-rm *.img
	cd ./kernel;make clean;cd ../
cleanall:clean
	cd ./kernel/ucgui;make clean

#write to the usb
dd:
	-sudo umount /dev/sdb
	sudo dd if=$(os) of=/dev/sdb
#run qemu from usb
runusb:dd
	sudo qemu -drive file=/dev/sdb
#run os as a harddisk , i don`t use "if=floppy"
runfloppy:
	qemu -m 2048M -drive file=$(os),if=floppy
#run os as a harddisk , i don`t use "if=floppy"
run:
	qemu -m 2048M -drive file=$(os)
done:
	make clean && make && make copy && make run


