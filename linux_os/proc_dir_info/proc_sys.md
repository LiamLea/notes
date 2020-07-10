[toc]
### /proc/sys/ —— 内核有关参数
* 用来存放和内核有关的参数
* 这里的参数，可以通过在/etc/sysct.conf中进行永久修改

#### /proc/sys/kernel —— 内核参数

##### /proc/sys/kernel/sysrq
sysrq功能：可以在系统出现故障的时候协助恢复和调试系统，只要系统还能响应键盘的按键中断
```shell
  echo 1 > /proc/sys/kernel/sysrq     #开启sysrq功能
  echo h > /proc/sysrq-trigger        #查看帮助
  echo f > /proc/sysrq-trigger        #人为触发OOM killer
```
##### /proc/sys/kernel/printk
调整内核打印的级别
```shell
  cat /proc/sys/kernel/printk       #有四个值（数值越小，优先级越高）
#console_loglevel                   #控制台日志级别，优先级高于它的信息都会被打印至控制台
#default_message_loglevel           #用该优先级打印没有优先级的消息（将该值改的小于console_loglevel，sysrq-trigger的输入信息就会到控制台）
#minimum_console_loglevel           #控制台日志最高可以设置成该优先级，如：printk("<6>Hello, world!\n"); 所以尖括号中最小可以设置为该选项指定的值
#default_console_loglevel           #控制台日志级别的缺省值，如：printk("Hello, world!\n"); 所以该消息的级别为该选项设置的默认值
```
***
#### /proc/sys/vm —— 虚拟内存参数

##### /proc/sys/vm/overcommit_memory
  控制内核对overcommit的策略
```shell
  0 —— OVERCOMMIT_GUESS，让内核自己根据当前的状况进行判断
  1 —— OVERCOMMIT_ALWAYS，不限制overcommit
  2 —— OVERCOMMIT_NEVER，永远不要overcommit
```
##### /proc/sys/vm/overcommit_kbytes
```shell
  CommitLimit=overcommit_kbytes+total_swap_pages   
#CommitLimit就是用来判断什么时候overcommit，可以通过cat /proc/meminfo查看
#overcommit后，再需要创建虚拟内存就会报cannot allcate memory的错误
```
##### /pro/sys/vm/overcommit_ratio
```shell
  CommitLimit=(Physical RAM*overcommit_ratio/100)+Swap
```
##### /proc/sys/vm/admin_reserve_kbytes
保留一定的内存给root用户进行操作，比如登录系统和执行kill命令等

##### /proc/sys/vm/user_reserve_kbytes
为用户空间保留的内存

##### /proc/sys/vm/max_map_count
  一个进程最大能够使用的内存映射区域的数量
```shell
提高这个值的影响：
#  使得整个系统更易到达overcommit
#  降低系统的性能
#  能够防止程序某些程序报内存不足的错误
```

##### /proc/sys/vm/drop_cache
用于清除buffer/cache
```shell
sync                                #清除前，需要先同步以下，否则数据可能丢失

echo 1 > /proc/sys/vm/drop_cache    #清除pagecache
echo 2 > /proc/sys/vm/drop_cache    #清除dentries和inodes
echo 3 > /proc/sys/vm/drop_cache    #清除pagecache、dentries和inodes
```

##### /proc/sys/vm/block_dump
表示是否打开Block Debug模式，用于记录所有的读写及Dirty Block写回动作
```shell
echo 1 > /proc/sys/vm/block_dump

dmesg -c        #可以查看到读写的日志
                #-c，一边查看一遍删除日志
```
***
#### /proc/sys/fs —— 文件系统参数
##### 1./pro/sys/fs/file-max
  整个系统能最多能打开的文件描述符数量

##### 2./proc/sys/fs/file-nr
  当前已经分配的文件描述符数量	当前已经分配但未被使用的文件描述符数量	整个系统能最多能打开的文件描述符数量

##### 3.ulimit -n
一个 **进程** 最多能打开的文件描述符数量



### 进程和线程

#### 1./proc/sys/kernel/pid_max
  整个系统，最多能同时打开的进程数

#### 2./proc/sys/kernel/threads_max
  一个进程最多能够使用的线程数

#### 3.ulimit -u
  一个用户最多能同时打开的进程数

#### 4.进程的运行参数
  /proc/xx/cmdline
  /proc/xx/comm
  /proc/xx/exe
  /proc/xx/cwd
  /proc/xx/fd/
  /proc/xx/environ
***
### 网络参数

#### 1.socket buffer

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

#### 2.all和default和eth*的区别
```shell
  all：应用于所有的网卡
  eth*：应用于指定的网卡
  default：应用于之后创建的网卡

#注意：如果all和eth*设置的不同，需要看该选项的逻辑是OR还是AND，所以最好两个都改一下
```
