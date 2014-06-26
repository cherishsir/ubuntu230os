src=water.c
asm:
	nasm -f elf -o hello.o hello.asm
	gcc  -c -m32 -o water.o water.c
	ld -m elf_i386 hello.o water.o -e entry -Ttext 0x7c00 -o hello.img
os:
	dd if=/dev/zero of=os.img count=2880
	cat hello.img> os.img
run: 
	qemu -drive file=os.img,if=floppy

clean:
	-rm *.img  *.o
