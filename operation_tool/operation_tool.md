[toc]

### lsof（list open files）
#### 1.底层原理
基于进程的以下几个文件
`/proc/<PID>/exec`
`/proc/<PID>/cwd`
`/proc/<PID>/root`
`/proc/<PID>/fd/`
`/proc/<PID>/maps`

#### 2.列出所有当前打开的文件，输出的格式：
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
#### 3.选项
```shell
  文件名         #列出打开该文件的进程

  -c 进程名称    #查看该进程打开的文件（并非绝对的名称，COMMAND包含该名称）

  -p pid号      #列出某个进程打开的文件描述符

  -i [4或6] [protocol] [ip]:[port]     #列出与该端口有关的文件描述符（一般是套接字）

  +d 目录/      #列出该目录下被打开的文件的项

  +D 目录/      #类似+d，但是会递归子目录
```

#### 4.应用场景
* 查看进程打开的socket信息（注意：**只能查看所在的netns**）
```shell
lsof -i -a -p <PID>   #-a就是and
```
* 查看哪些进程在使用文件系统（利用+D选项）
* 查看某个文件被哪个进程使用
* 查看进程打开了哪些文件

***

### locate

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

***

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

### io相关
##### `iostat -dx`
显示io详细情况
##### `iotop`
显示所有进程的io情况

***
### `ps`和`top`
#### 1.查看线程信息
```shell
ps -eLf
ps -Lf -p <PID>
top -H <PID>

#LWP：light-weight process
#NLWP：number of light-weight process
```

#### 2.相关指标
##### （1）`STAT`
```shell
R     #running
S     #interruptable sleeping

D     #disk，uninterruptable sleeping
      #处于不可中断的后台进程不能被kill掉（前台的可以被kill）

T     #stopped
Z     #zombie

+     #前台数据
l     #多线程进程
N     #低优先级进程
<     #高优先级进程
s     #session leader
```

##### （2）`%CPU`
当为100%时，表示该进程使用1个CPU
当为50%时，表示该进程使用0.5个CPU
```shell
(process CPU time / process duration) * 100

#process CPU time，进程使用cpu的时长
#process duration，进程运行的时长
#所有进程的cpu使用率，加起来应该 = CPU数 * 100
```


***
### 一些查看的小命令
##### `xxd -b <FILE>`
以二进制形式查看文件
##### `strings <FILE>`
将二进制文件转换成字符串
