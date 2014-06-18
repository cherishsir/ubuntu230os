src=bootloader.S
obj=bootloader.o
elf=bootloader.elf
boot=bootloader.out
asm=bootloader.asm
kernel=kernel.out
#kernel start 0xc400


$(boot):$(src)
	gcc -c $(src) -m32 -o $(obj)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)
	cd kernel;make address=0xc400;mv kernel.out ../
fat12:$(boot)
	@dd if=/dev/zero of=$(boot) seek=2 count=2878 >> /dev/zero
	@ls -al $(boot)
	sudo mount -o loop   $(boot)  /mnt
	sudo cp $(kernel) /mnt
	sudo umount /mnt

run:
	qemu   -drive file=$(boot)

writeusb:
	sudo dd if=$(boot) of=/dev/sdb
runusb:writeusb
	sudo qemu   -drive file=/dev/sdb
clean:
	-rm -f $(obj) $(elf) $(boot) $(asm) kernel.out
	cd kernel ;make clean; cd ../

umount:
	sudo umount /dev/sdb
