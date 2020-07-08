[toc]
### gdb（GNU debugger）
#### 1.特点
* 可以进入正在执行的某个进程，进入后，进程就**暂停**在进入点

#### 2.基本使用
```shell
gdb -p <PID>      #进入某个进程
```

#### 3.gdb终端命令
利用两下\<Tab>可以查看有什么命令
```shell
call <SYSCALL>      #调用系统调用
                    #man syscalls 或者 按两下tab 可以查看有哪些系统调用

show xx             #常用的有：
                    #   environment
                    #   paths
```
#### 4.利用gdb管理文件描述符
```shell
#关闭某个文件描述符
call close(<FD>)

#清空某个文件描述符（即清空文件，直接删除文件会影响程序）
call ftruncate(<FD>,0)
```
***
### lsof（list open files）
#### 1.列出所有当前打开的文件，输出的格式：
```shell
  COMMAND     #进程名称
  PID         #pid号
  USER        #进程所有者
  FD          #文件描述符的号码，或者代号：
#cwd：current working directory，即该应用程序启动的目录（需要结合根目录，才能确定该目录在系统的哪个位置）
#rtd：root directory，即根目录
#txt：programm text，即启动程序（如：/usr/bin/mysqld）
#mem：memory-mapped file，即加载到虚拟内存中的文件

  TYPE        #文件类型
#DIR：directory，即目录
#REG：regular file，即文件
#CHR：character special file，即字符设备
#BLK：block special file，即块设备

  DEVICE      #所在磁盘
  SIZE/OFF    #文件大小
  NODE        #索引节点
  NAME        #文件的名称
```
#### 2.选项
```shell
  文件名         #列出打开该文件的进程

  -c 进程名称    #查看该进程打开的文件（并非绝对的名称，COMMAND包含该名称）

  -p pid号      #列出某个进程打开的文件描述符

  -i [4或6] [protocol] [ip]:[port]     #列出与该端口有关的文件描述符（一般是套接字）

  +d 目录/      #列出该目录下被打开的文件的项

  +D 目录/      #类似+d，但是会递归子目录
```
#### 3.应用场景
* 查看哪些进程在使用文件系统（利用+D选项）
* 查看某个文件被哪个进程使用
* 查看进程打开了哪些文件
***
### strace
>strace用于跟踪进程运行时的系统调用等，输出的结果：  
>>每一行都是一条系统调用，等号左边是系统调用的函数名及其参数，右边是该调用的返回值  

#### 1.选项
```shell
  -f            #跟踪由fork调用所产生的子进程
  -c            #进行统计，统计调用哪些系统调用、调用的次数和错误等，最后给出一个统计结果
  -e 表达式     #表达式：
                #trace=open 表示只跟踪open调用
  -p <PID>      #可以跟踪正在运行的进程
```
***
#### locate

#### 1.由四部分组成
```shell
  /etc/updatedb.conf
  /var/lib/mlocate/mlocate.db     #存放文件信息的文件
  updatedb                        #该命令用于更新数据库
  locate                          #该命令用于在数据库中查找
```
#### 2.配置文件：/etc/updatedb.conf
```shell
  PRUNE_BIND_MOUNTS = "yes"       #开启过滤
  PRUNEFS = "xx1 xx2"             #过滤到的文件系统类型
  PRUNENAMES = ".git"             #过滤的文件
  PRUNEPATHS = "xx1 xx2"          #过滤的路径
```
#### 3.locate命令
```shell
  -b xx        #basename，文件名包含xx
  -i xx        #忽略大小写
  -q           #安静模式
  -r xx        #正则
  -R           #列出ppid
```
***
### traceroute
#### 1.原理
```
每个ip包都有一个ttl字段，用于设置最大的跳数，
如果超过这个跳数还没到达目的地，则会丢弃该ip包，
并通知发送方（利用类型为time-exceeded的icmp包通知）
```
### dd
#### 1.特点
* 用**指定大小的块**拷贝一个文件，并在拷贝的同时进行指定的**转换**
* 能够复制磁盘的分区、文件系统等
* 当block size设置合适时，读取效率很高
#### 2.命令
```shell
dd if=输入文件 of=输出文件

#参数
bs=xx         #设置读入/输出的 块大小 为 xx 个字节
count=xx      #仅拷贝xx个块
```
#### 3.应用
* 彻底清空磁盘
```shell
dd if=/dev/zero of=/dev/sda
```
***
### stree-ng
#### 1.模拟高负载
* 原理：创建多个进程，争抢cpu
```shell
stress-ng -c <核数>     #核数如果为4，则会创建4个进程，每个进程用满一个核
```

#### 2.模拟高内存
* 原理：持续运行`malloc()`和`free()`
* 注意：
  * 当设置的一个进程消耗的内存过高时，则不能耗尽内存，需要再起一个
```shell
stress-ng -m <NUM> --vm-bytes <BYTES> --vm-keep   
#-m表示开启多少个进程，每个进程消耗那么多vm
#--vm-keep就是占用内存，不重新分配
```
#### 3.模拟高I/O（测试文件系统）
* 原理：持续写、读和删除临时文件
```shell
stress-ng -d <NUM> --hdd-write-size <BYTES> -i <NUM>
#-d：开启<NUM>个负责，执行读、写和删除临时文件
#--hdd-write-size每个负载写的数据量
#-i：开启<NUM>个负载，执行sync()
```
***
### io相关
##### `iostat -dx`
显示io详细情况
##### `iotop`
显示所有进程的io情况

***
### tcpdump
#### 1.在宿主机上抓取容器中某个网卡的数据包
* 进入容器执行
```shell
$ cat /sys/class/net/<INTERFACE>/iflink

28
```
* 在宿主机执行
```shell
$ ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:50:56:b8:6d:a3 brd ff:ff:ff:ff:ff:ff
... ...
28: cali5ddcf4a2547@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netnsid 7
```

* 在宿主机上 抓取 容器中指定网卡 的数据包
```shell
tcpdump -i cali5ddcf4a2547 -nn
```
***
### 一些查看的小命令
##### `xxd -b <FILE>`
以二进制形式查看文件
##### `strings <FILE>`
将二进制文件转换成字符串
