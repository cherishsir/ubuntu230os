src=hello.S
obj=hello.o
elf=boot.elf
boot=boot.out
asm=boot.asm



$(boot):$(src)
	gcc -c $(src) -m32 -o $(obj)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)

fat12:$(boot)
	@cd ./secondsector;make address=0x8200;cp second.out ../ ;cd ../
	cat second.out >>$(boot)
	@dd if=/dev/zero of=$(boot) seek=2 count=2878 >> /dev/zero
	@ls -al $(boot)
	@rm second.out

run:
	qemu -fda $(boot)

writeusb:
	sudo dd if=$(boot) of=/dev/sdb
runusb:writeusb
	sudo qemu   -drive file=/dev/sdb
clean:
	-rm -f $(obj) $(elf) $(boot) $(asm)

umount:
	sudo umount /dev/sdb
