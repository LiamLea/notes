
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

  - [1.REST架构：](#1rest架构)
  - [3.执行脚本最好使用：bash](#3执行脚本最好使用bash)
  - [4.脚本的内容都放在后台执行了，让脚本不放在后台，可以在最后加上：wait](#4脚本的内容都放在后台执行了让脚本不放在后台可以在最后加上wait)
  - [14.当添加了新的动态库目录后，需要更新动态库缓存：ldconfig](#14当添加了新的动态库目录后需要更新动态库缓存ldconfig)
  - [18.\r\n 和 \n 区别：](#18rn-和-n-区别)
  - [22.printf](#22printf)
  - [23.sysrq（system request）](#23sysrqsystem-request)
  - [24.overcommit不会触发oom killer](#24overcommit不会触发oom-killer)
  - [29."cannot allocate memory"，可能的原因：](#29cannot-allocate-memory可能的原因)
  - [32./var/run和/var/lib](#32varrun和varlib)
  - [33.WAL：write-ahead logging](#33walwrite-ahead-logging)
  - [40.SIGs（sepecial interests groups）](#40sigssepecial-interests-groups)
- [42.hash函数用来提取 定长的特征码](#42hash函数用来提取-定长的特征码)
- [31.如何man一个命令的子命令](#31如何man一个命令的子命令)
- [43."No manual entry for xx"的解决方法](#43no-manual-entry-for-xx的解决方法)
- [45.并发访问的响应模型:](#45并发访问的响应模型)
- [50.两个虚拟机之间的传输速度](#50两个虚拟机之间的传输速度)
- [51.执行命令后，没有响应可能的原因：](#51执行命令后没有响应可能的原因)
- [52.解释器](#52解释器)
- [53.如果一个文件和另一个文件相同，但不是软连接，可能的情况：](#53如果一个文件和另一个文件相同但不是软连接可能的情况)
- [55.在k8s上运行的镜像要求](#55在k8s上运行的镜像要求)
- [56.upstream和downstream的区别](#56upstream和downstream的区别)
- [57.处于不可中断(`D`)的后台进程不能被kill掉（前台的可以被kill）](#57处于不可中断d的后台进程不能被kill掉前台的可以被kill)
- [50.Stream（流）](#50stream流)
- [52.`kubectl edit cm xx`导致data中的数据变为一行](#52kubectl-edit-cm-xx导致data中的数据变为一行)
- [53.查看网络设备的参数](#53查看网络设备的参数)
- [54.ping 本地的任何ip，其实都是ping的`127.0.0.1`](#54ping-本地的任何ip其实都是ping的127001)
- [55.`docker restart` 和 `docker restart`都不会清除docker中的临时数据](#55docker-restart-和-docker-restart都不会清除docker中的临时数据)
- [56.buff和cache](#56buff和cache)
- [57.helm仓库无法查找旧的chart问题](#57helm仓库无法查找旧的chart问题)
- [58.out-of-band](#58out-of-band)
  - [(1) out-of-band management](#1-out-of-band-management)
  - [(2) out-of-band data](#2-out-of-band-data)
- [56.在没有工具的请求下：查看容器中的某个端口](#56在没有工具的请求下查看容器中的某个端口)
  - [（1）利用文件查找](#1利用文件查找)
  - [（2）将该容器的网络命名空间挂载出来](#2将该容器的网络命名空间挂载出来)
- [57.格式化磁盘: `wipefs`](#57格式化磁盘-wipefs)
- [58.`ip route`有多个路由表](#58ip-route有多个路由表)
- [59.认证失败的原因：证书过期 或者 时间不同步](#59认证失败的原因证书过期-或者-时间不同步)
- [60.`ls -l`格式](#60ls-l格式)

<!-- /code_chunk_output -->

##### 1.REST架构：
representation state transfer，表现层状态转移
本质：URL定义资源，用HTTP方法处理资源

##### 3.执行脚本最好使用：bash
杀死这个bash，整个脚本就会停止

##### 4.脚本的内容都放在后台执行了，让脚本不放在后台，可以在最后加上：wait

##### 14.当添加了新的动态库目录后，需要更新动态库缓存：ldconfig        
例如在安装了guacamole后

##### 18.\r\n 和 \n 区别：
* 在windows操作系统中，回车换行：\r\n
* 在linux操作系统中，回车换行：\n
* 大部分基于文本的协议，如http等，回车换行：\r\n

##### 22.printf
（1）类似 echo -n -e，但是功能更多
（2）printf "%016x" val
```
16 —— 字宽为16
0 —— 不足的用0补齐
x —— 转换为16进制输出（输出的结果中没有16进制的标记）
```
（3)转义字符：\ （转译成ascii码，如：\n，转换成换行符，其实就是一个ascii码，是一个字节）
```shell
\数字        
#表示后面的数字是八进制，然后进行转换  

\x数字       
#表示后面的数字是十六进制，然后进行转换

#如果后面的数字太大，只取能够转换成ascii的数字值，其余的不做转换
```

##### 23.sysrq（system request）
（1）功能
可以在系统出现故障的时候协助恢复和调试系统，只要系统还能响应键盘的按键中断

（2）开启sysrq功能
```shell
echo 1 > /proc/sys/kernel/sysrq
```
（3）使用sysrq功能
>信息默认会输出到/var/log/messages，可以调整打印级别，使得信息输出到终端  
```shell
echo h > /proc/sysrq-trigger        #查看帮助
echo f > /proc/sysrq-trigger        #人为触发OOM killer
```
（4）调整内核打印的级别设置
```shell
  cat /proc/sys/kernel/printk     #有四个值（数值越小，优先级越高）
#console_loglevel                 #控制台日志级别，优先级高于它的信息都会被打印至控制台
#default_message_loglevel         #用该优先级打印没有优先级的消息（将该值改的小于console_loglevel，sysrq-trigger的输入信息就会到控制台）
#minimum_console_loglevel         #控制台日志最高可以设置成该优先级，如：printk("<6>Hello, world!\n"); 所以尖括号中最小可以设置为该选项指定的值
#default_console_loglevel         #控制台日志级别的缺省值，如：printk("Hello, world!\n"); 所以该消息的级别为该选项设置的默认值
```

##### 24.overcommit不会触发oom killer
* 虚拟内存：是进程使用mmap等命令动态获取的内存，并没有与物理内存一一对应，当程序第一次试图访问该虚拟内存时，才会与物理内存建立对应关系
* overcommit：分配的虚拟内存 > 实际的物理内存


##### 29."cannot allocate memory"，可能的原因：
（1）物理内存不足				
```shell
free -h
```
（2）虚拟内存分配达到上限		
```shell
cat /proc/sys/vm/max_map_count
```
（3）打开的文件描述符达到上限
```shell
ulimit -n
cat /proc/sys/fs/file-max
```
（4）进程过多				
```shell
ulimit -u
cat /proc/sys/kernel/pid_max
```
（5）线程过多					
```shell
cat /proc/sys/kernel/threads-max
```

##### 32./var/run和/var/lib
* /var/run：存放描述应用程序或系统的信息（如：pid）
* /var/lib：存放应用程序或系统有关的状态信息  


##### 33.WAL：write-ahead logging
预写日志，更改**首先记录在日志**中（日志存储在稳定的存储上），然后**再将更改写入数据库**

##### 40.SIGs（sepecial interests groups）
用于研究某一个感兴趣的方面的小组
一般是某一个系统的某一个组件

#### 42.hash函数用来提取 定长的特征码

#### 31.如何man一个命令的子命令
```shell
whatis 子命令      #然后根据查询出来的结果man
```
#### 43."No manual entry for xx"的解决方法
1. 确保下面两个软件已经安装
* man-pages
>man-pages提供linux系统的相关man文档  
* man-db
2. 查找xx的man文档是由哪个软件提供的
```shell
yum provides */xx.*.gz
```

#### 45.并发访问的响应模型:
* 单进程IO模型
* 多进程IO模型
* 复用的IO模型:一个进程响应n个请求
```
多线程:一个进程生成n个线程,一个线程处理一个请求  

事件驱动:一个进程直接处理多个请求,当有事件进行触发时执行,如果io阻塞,则执行其他任务  
```
* 复用的多进程IO模型:启动m个进程,每个进程生成n个线程(nginx就是此方式,而且利用了事件驱动)



#### 50.两个虚拟机之间的传输速度
* 虚拟网络设备的速度取决于于宿主机，该网络设备显示的参数没有任何意义，仅仅是显示而已
* 同一台宿主机上，虚拟机间的传输速度与存储的速度有关
* 不同宿主机上，虚拟机间的传输速度与物理网卡和网络有关

#### 51.执行命令后，没有响应可能的原因：
* 高IO和剩余少量的内存
  * 原因
    * 当文件系统读写频率过高，且内存剩余量很少时，由于内存没办法缓存，导致读写效率很低，因为很多命令是要读写文件的，所以这样会导致，命令执行非常慢
  * 解决
    * 通过`echo 1 > /proc/sys/vm/block_dump`和`dmesg -c`查看高io的进程
    * 通过`ps aux`查看内存使用率高的进程

#### 52.解释器
解释器是一个程序，用于将一个层级的语言转换成**同一层级**的另一种语言
层级：
* 高层语言：C++、java等
* 中层语言：C
* 低层语言：汇编
* 机器语言

#### 53.如果一个文件和另一个文件相同，但不是软连接，可能的情况：
* 所在的目录是软连接
* 文件是硬连接


#### 55.在k8s上运行的镜像要求
* 启动命令不能是`/bin/bash`这样的，这样镜像无法启动，虽然用`docker -itd`可以启动，启动必须是在前台运行（比如：`/usr/sbin/sshd -D`）

#### 56.upstream和downstream的区别
* upstream
发出去的流量
* downstream
接收的流量

#### 57.处于不可中断(`D`)的后台进程不能被kill掉（前台的可以被kill）

#### 50.Stream（流）
流表示对象（对象通常是字节，但不是一定）的序列
流的典型操作：
* read one byte，Next time you read, you'll get the next byte
* read several bytes
* seek (move your current position in the stream, so that next time you read you get bytes from the new position)
  * 输入输出流不能seek，除非有缓冲
* write one byte
* write several bytes into the stream
* skip bytes from the stream
* push back bytes into an input stream（放回）
* peek (look at bytes **without reading them**, so that they're **still there in the stream** to be read later)
  * peek函数返回当前指针指向的字符，指针不会向后移动

#### 52.`kubectl edit cm xx`导致data中的数据变为一行
解决方法：修改后，确保data中的每一行后面没有空格

#### 53.查看网络设备的参数
```shell
modinfo /lib/modules/3.10.0-957.el7.x86_64/kernel/drivers/net/bonding/bonding.ko.xz
```

#### 54.ping 本地的任何ip，其实都是ping的`127.0.0.1`

#### 55.`docker restart` 和 `docker restart`都不会清除docker中的临时数据

#### 56.buff和cache

buff是将内存当磁盘用
cache是将数据存储在内存中，加快数据的访问

#### 57.helm仓库无法查找旧的chart问题

helm repo add的本质就是添加`index.yaml`文件到本地，
由于index的文件过大，且helmhub对各个仓库的index文件大小有限制，所以无法查找到比较旧的chart，
所以需要使用全量的index文件，以bitnami为例（[相关issue](https://github.com/bitnami/charts/issues/10539))：
* 在helmhub上的提供的`index.yaml`: `https://charts.bitnami.com/bitnami`
* 全量的`index.yaml`: `https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami`
  * 通过页面访问的地址：`https://github.com/bitnami/charts/tree/archive-full-index/bitnami`

#### 58.out-of-band

是在定义的电信频带之外的活动，或者，隐喻地，在任何主要通信渠道之外的活动

##### (1) out-of-band management
in-band management 指ssh、VNC等，依赖操作系统等
out-of-band management 指远程管理卡等，当操作系统宕机，依然能够管理机器

##### (2) out-of-band data
独立的数据通道，用作特殊用途

#### 56.在没有工具的请求下：查看容器中的某个端口

##### （1）利用文件查找

* 查看端口是否被打开，并获取inode号
```shell
PORT=4822;cat /proc/net/* | awk -F " " '{print $2 ":" $10 }' | grep -i `printf "%x:" $PORT` | awk -F ":" '{print "PORT=" $2 ", INODE=" $3 }'
```
* 查找出具体的进程
```shell
INODE=8036871;find /proc -lname "socket:\[$INODE\]" 2> /dev/null | head -n 1 | awk -F "/" '{print "PID="$3}'
```

##### （2）将该容器的网络命名空间挂载出来

#### 57.格式化磁盘: `wipefs`
```shell
wipefs -a /dev/sda
```

#### 58.`ip route`有多个路由表
* 查看路由表
```shell
cat /etc/iproute2/rt_tables

255	local
254	main    #平常使用的是这个表（真正路由也只有这个表有效）
253	default
0	unspec
```

* 列出所有路由
```shell
ip route show table <table_id>
#e.g. ip route show table all
```

#### 59.认证失败的原因：证书过期 或者 时间不同步

#### 60.`ls -l`格式

```shell
-rw-r--r-- 1 root root        313 Jan  5 14:16 a.imgs

#1表示硬链接数
```
