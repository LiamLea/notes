### 内核参数（/proc/sys/kernel）

####1.kernel.sysrq
sysrq功能：可以在系统出现故障的时候协助恢复和调试系统，只要系统还能响应键盘的按键中断
```shell
  echo 1 > /proc/sys/kernel/sysrq     #开启sysrq功能
  echo h > /proc/sysrq-trigger        #查看帮助
  echo f > /proc/sysrq-trigger        #人为触发OOM killer
```

####2.kernel.printk
调整内核打印的级别
```shell
  cat /proc/sys/kernel/printk       #有四个值（数值越小，优先级越高）
#console_loglevel                   #控制台日志级别，优先级高于它的信息都会被打印至控制台
#default_message_loglevel           #用该优先级打印没有优先级的消息（将该值改的小于console_loglevel，sysrq-trigger的输入信息就会到控制台）
#minimum_console_loglevel           #控制台日志最高可以设置成该优先级，如：printk("<6>Hello, world!\n"); 所以尖括号中最小可以设置为该选项指定的值
#default_console_loglevel           #控制台日志级别的缺省值，如：printk("Hello, world!\n"); 所以该消息的级别为该选项设置的默认值
```
####3.vm.max_map_count							
vm：virtual memory
***
###内存参数（/proc/sys/vm）

####1.vm.overcommit_memory
  控制内核对overcommit的策略
```shell
  0 —— OVERCOMMIT_GUESS，让内核自己根据当前的状况进行判断
  1 —— OVERCOMMIT_ALWAYS，不限制overcommit
  2 —— OVERCOMMIT_NEVER，永远不要overcommit
```
####2.vm.overcommit_kbytes
```shell
  CommitLimit=overcommit_kbytes+total_swap_pages   
#CommitLimit就是用来判断什么时候overcommit，可以通过cat /proc/meminfo查看
#overcommit后，再需要创建虚拟内存就会报cannot allcate memory的错误
```
####3.vm.overcommit_ratio
```shell
  CommitLimit=(Physical RAM*overcommit_ratio/100)+Swap
```
####4.vm.admin_reserve_kbytes
保留一定的内存给root用户进行操作，比如登录系统和执行kill命令等

####5.vm.user_reserve_kbytes
为用户空间保留的内存

####6.vm.max_map_count
  一个进程最大能够使用的内存映射区域的数量
```shell
提高这个值的影响：
#  使得整个系统更易到达overcommit
#  降低系统的性能
#  能够防止程序某些程序报内存不足的错误
```
***
###文件描述符

####1./pro/sys/fs/file-max
  整个系统能最多能打开的文件描述符数量

####2./proc/sys/fs/file-nr
  当前已经分配的文件描述符数量	当前已经分配但未被使用的文件描述符数量	整个系统能最多能打开的文件描述符数量

####3.ulimit -n
  一个进程最多能打开的文件描述符数量

####4.查看某个进程打开的文件描述符数量
  ll /proc/{pid}/fd/ | wc -l
***
###进程和线程

####1./proc/sys/kernel/pid_max
  整个系统，最多能同时打开的进程数

####2./proc/sys/kernel/threads_max
  一个进程最多能够使用的线程数

####3.ulimit -u
  一个用户最多能同时打开的进程数

####4.进程的运行参数
  /proc/xx/cmdline
  /proc/xx/comm
  /proc/xx/exe
  /proc/xx/cwd
  /proc/xx/fd/
  /proc/xx/environ
***
###网络参数

####1.socket buffer

（1）查询tcp socket能使用的内存的页数（一页没4k）：
```shell
  cat /proc/sys/net/ipv4/tcp_mem
  低阈值  警告阈值  最大阈值
shell
```
（2）查看允许的tcp孤儿socket最大数量：
```shell
  cat /proc/sys/net/ipv4/tcp_max_orphans
#orphan socket：没有关联文件描述符的socket
```
（3）查看socket的状态：
```shell
  cat /proc/net/socketstat
#当计算orphans socket有没有超过上限值，通常需要x2或者x4
```

####2.all和default和eth*的区别
```shell
  all：应用于所有的网卡
  eth*：应用于指定的网卡
  default：应用于之后创建的网卡

#注意：如果all和eth*设置的不同，需要看该选项的逻辑是OR还是AND，所以最好两个都改一下
```
***
###/sys目录
>/sys挂载的是sysfs文件系统，这是一个虚拟的文件系统（基于ram）  

>用于导出内核系统、硬件和相关设备驱动的信息，方便用户空间进程进行使用  
####1.基础
```shell
  /sys/class/net/       #存放所有网络接口
  /sys/class/input/     #存放所有输入设备
  /sys/class/tty/       #存放所有串行设备
  /sys/block/           #存放块设备，由于历史原因才没放在class下的
```
***
###cpu

####1.基本指标
```shell
user（通常缩写为us），代表用户态CPU时间。注意，它不包括下面的nice时间，但包括了guest时间。

nice（通常缩写为ni），代表低优先级用户态CPU时间，也就是进程nice值被调整为1-19之间的CPU时间。这里注意，nice可取值范围是-20到19，数值越大，优先级反而越低。

system（通常缩写为sys），代表内核态CPU时间。

idle （通常缩写为id），代表空闲时间，注意，它不包括等待I/O的时间（iowait）。

iowait（通常缩写为wa），代表等待I/O的CPU时间。

irq（通常缩写为hi），代表处理硬中断的CPU时间。

softirq（通常缩写为si），代表处理软中断的CPU时间。

steal（通常缩写为st），代表当系统运行在虚拟机中的时候，被其他虚拟机占用的CPU时间。

guest （通常缩写为guest），代表通过虚拟化运行其他操作系统的时间，也就是运行虚拟机的CPU时间。

guest_nice （通常缩写为gnice），代表以低优先级运行虚拟机的时间。
```
***
###IO

####1.iostat -x
```shell
  rrqm/s        #每秒合并的读请求数量
  r/s           #每秒完成的读请求数量
  rKB/s         #每秒读多少KB
  avgrq-sz      #请求的平均大小（以扇区为基本单位），即每秒平均吞吐量
  avgqu-sz      #请求的平均队列长度
  await         #平均IO响应时间
  r_await       #读请求响应时间
  %util         #磁盘忙于处理读取或写入请求所用时间的百分比
```
