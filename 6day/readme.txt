第六天的课程：

要有一个态度，有一个好的心态，问题越多，学到的越多。坚持下去就行了。

halt的机器码为0xf4

整个过程恢复正常，可以利用sprintf打印变量是非常好的事。
拉下来可以封装一个函数，专业用来在右下角打印变量，方便知道程序做了什么，和变量的值。

下面开始研究gdt idt,如果没有猜错，mouse是利用中断控制的，而现在进行了32位的分段模式下，原来由bios在低内存空间建立的bios中断向量表和中断服务程序，现在都不能用了。
所以如果要能控制mouse，就要能利用中断服务程序，但是中断服务程序在32位的分段 模式下，是需要idt这个表，来放中断服务程序的入口地址的。

所以说，要控制mouse，就要先学习idt的配置，然后写mouse的中断服务程序，然后把中断服务程序的入口地址放到idt表中，最后把idt表的首地址给cpu的一个寄存器。
如同lgdt gdt
一样，肯定有一个lidt idt
／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
idt:
   number
   .long table_address
   
  
table_address:
第一个中断服务程序的入口
第二个中断服务程序的入口

／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／


gdt,idt都是保存在cpu中的一个特殊的寄存器当中的，这些寄存器都是由于发展的需要，而增加的。
32位的模式的关键就是gdt,idt.


分段啊，中断啊，中断好理解，分段的好处我还没有理解到。先懂个大概，后面慢慢深入理解，细化。学习之道。


安装可以调度的bochs的过程：ubuntu 13.10
上面这种方法直接安的二进制的程序，不能调试，所以要从源码开始编译起
1:准备工作

  $    sudo apt-get install build-essential
  $    sudo apt-get install xorg-dev
  $    sudo apt-get install bison
  $    sudo apt-get install libgtk2.0-dev

  
    $    tar xvfz bochs-2.3.5.tar.gz
    2.进入bochs-2.3.5目录
        $    cd bochs-2.3.5
        
        $    sh ./configure --prefix=/opt/bochs/debug --enable-plugins --enable-debugger --enable-disasm


   4. 编译
        $    make
    5. 安装
        $    sudo make install
    6.加一个符号连接
        $    sudo ln -s /opt/bochs/debug/bin/bochs /usr/bin/bochsdbg
   然后你就可以用bochsdbg了

   注意：这里非常的麻烦。
   make 之后报这样的错，网上找不到答案，可能是太简单的原因，尝试在Makefile中加了一行LIBS= -lpthread　就搞定了
/usr/bin/ld: note: 'pthread_create@@GLIBC_2.1' is defined in DSO /lib/i386-linux-gnu/libpthread.so.0 so try adding it to the linker command line
/lib/i386-linux-gnu/libpthread.so.0: 


实在是找不到答案了，不知道为什么进不去中断，课程无法进行下去了。以后再学吧，不能一直在这上面浪费时间了，把oranges的书看下
还是不愿意放弃，现在用bochs看了看sreg发现idtr gdtr都有问题，不是我们想要的值

看内存
xp /16wx 0x26f900

调断点
pbreak 0x280070 
下面是　bochs的　user manual
http://bochs.sourceforge.net/cgi-bin/topper.pl?name=New+Bochs+Documentation&url=http://bochs.sourceforge.net/doc/docbook/user/index.html

经过bochs的查看gdtr idtr后，发现没有什么错误，内存中的数所也是对的


好好研究下init pic?????
现在非常的怀疑是init pic有问题，是不是没有正常的init

最后发现了问题：

gd->access_right=(char)(access&0xff);
上面的代码中我把&写成了｜　这样导致程序发生中断的时候，访问内存失败


在没有init_pic()时，也就是中断的irq没有remap 时，按键的中断对应的是int 9，
调用了init_pic()后，按键的中断被映射到了int 0x21,
也就是两片8059映射的irq0到irq15　remap到了int 0x20到int 0x2f





产生软盘镜像
sudo -s
make 
make copy
make run

产生从u盘启动的镜像：
sudo -s
make usb=1
make copy
make u
make dd      //这个命令是写os.img到u盘

















