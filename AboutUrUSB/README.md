##本程序用来显示u盘的chs有多大：
###程序大小,两个扇区,第二个扇区的程序主要用来显示chs结构
因为软盘的chs比较容易大部分都是chs=80x2x18的情况，但是u盘则不一样
所以不能把软盘的情况和u盘的情况同等的看。

使用方法
make
make fat12
make writeusb


或是插上u盘后，使用qemu来读启动u盘
make runusb
