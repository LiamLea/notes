##### 1.REST架构：
representation state transfer，表现层状态转移
本质：URL定义资源，用HTTP方法处理资源
##### 2.利用ansible执行脚本的排错方法：
加上参数-vvv

##### 3.执行脚本最好使用：bash
杀死这个bash，整个脚本就会停止

##### 4.脚本的内容都放在后台执行了，让脚本不放在后台，可以在最后加上：wait

##### 6.net.ipv4.conf.all.rp_filter=0     
reverse path filter，反向路径过滤
```
原理：
  一台主机（或路由器）从接口A收到一个包，其源地址和目的地址分别是10.3.0.2和10.2.0.2，即<saddr=10.3.0.2, daddr=10.2.0.2, iif=A>,
  如果启用反向路径过滤功能，它就会以<saddr=10.2.0.2, daddr=10.3.0.2>为关键字去查找路由表，
  如果得到的输出接口不为A，则认为反向路径过滤检查失败，它就会丢弃该包。
```
##### 7.net.bridge.bridge-nf-call-iptables=1
iptables对规则也会对流经bridge的数据生效

##### 8.同一台主机上的虚拟交换机是不能直接互连的

##### 9.java命令
```shell
  java [options] class 二进制文件 [args]
  java [options] -jar jar包文件 [args]

#查看具体的args
  java -jar jar包 --help       #能查看到这个jar包的具体用法和参数
```
##### 10.veth pair
是一对的虚拟设备接口，一端连着协议栈，一端彼此相连着
一个端口收到协议栈的数据发送请求后，会将数据发送到对应的端口上去
可以用来跨越网络命名空间
可以用来连接一台主机上的两个虚拟交换机
```shell
ip link add xx1 type veth peer name xx2
```
##### 11.access
（1）接收
  一般只接收 未打标签 的数据帧，则根据端口的pvid给帧打上标签，即插入4字节的vlan id字段
（2）发送
  若帧的vid（vlan id）和端口的pvid（port vlan id）相等，去除标签并发送
  不相等，则不处理

##### 12.trunk
（1）接收
  对于 未打标签 的数据帧，则根据端口的pvid给帧打上标签
  对于 已打标签 的数据帧，则直接接收
（2）发送
  如帧的vid和端口的pvid相等，则去除标签并发送
  不相等则直接发送

##### 13.gre
```shell
#封装格式：
  ethernet ip gre ip payload
```
  在已经封装的ip协议基础上，添加gre头部，再封装一层ip，然后再封装ethernet
  是L3层的隧道技术
  本质是在隧道的两端的L4层建立UDP连接 传输重新包装的L3层包头
  gre封装的数据包基于 ip路由表 进行路由的

##### 14.当在zabbix中添加新的oid，一定要先用snmpget看看有没有数据，snmpwalk有数据没用，因为可能没有到底

##### 15.模拟cpu高负载
  cat /dev/urandom | gzip -9 | gzip -d > /dev/null        //当需要更高的负载，则可以继续压缩解压

##### 16.SPAN（switch port analyzer，交换机的端口镜像技术）
  利用SPAN技术，可以把交换机上的某些端口的数据流 copy 一份，发往到指定端口

##### 17.如何获取交换机上其他端口的流量：
（1）SPAN技术
（2）利用arp欺骗攻击
（3）mac地址泛洪

##### 18. shell中  --  表示选项的结束，即后面的都当参数处理

##### 19.set 用于设置shell
  set [-+选项] [-o 选项] [参数]
  set -- arg1 即重置此shell的位置参数（$1=arg1）

##### 11.for后面只有一个变量名，表示遍历位置参数
```shell
for xx                  
do
    echo $xx
done
```
##### 12.6种名称空间
* uts（UNIX Timesharing System）
主机名和域名  
* net
网络，主要用于实现协议栈的隔离
* ipc                                               
进程间通信的
* user                                              
用户
* mnt（mount）                                      
挂载文件系统的
* pid                                               
进程 id 的

##### 13.查看网卡的带宽
```shell
dmesg | grep xx
```
##### 14.当添加了新的动态库目录后，需要更新动态库缓存：ldconfig        
例如在安装了guacamole后

##### 15.非交互式执行命令，当需要多次输入，可以利用如下方式实现：
```shell
  echo -e "xx\nxx" | passwd root
```
##### 16.用容器启动ftp时，需要把网络模式设为netwoek，否则客户端无法用被动模式连接ftp服务器

##### 17.tcp中用序列号标识数据段
* 所以序列号是递增的，当恢复ACK=n时，表示序列号<=n的数据段都收到了
* 当数据段长度为0时，即只有头部，没有数据时，回复的ACK序列号就不用增加
* 在建立连接和断开连接阶段，为什么ACK序列号都加1，这是协议中定义的规定

##### 18.\r\n 和 \n 区别：
* 在windows操作系统中，回车换行：\r\n
* 在linux操作系统中，回车换行：\n
* 大部分基于文本的协议，如http等，回车换行：\r\n

##### 19.HTTP 1.0 和 1.1 的区别
（1）连接时长

1.0 每次请求建议一个TCP，服务器完成处理后，立即关闭连接
1.1 支持长连接（keep-alive），一次连接可以发送多次请求

（2）1.1增加Host字段

##### 20.建立tcp连接
```shell
exec FD<>/dev/tcp/HOST/PORT		
#会在 /proc/self/fd/ 目录下生成一个描述符
```

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

##### 25.yaml语法补充

（1）当使用{{var}}变量时，需要给整行加上引号，否则会产生歧义（因为以花括号开头，playbook会认为这是一个字典类型）
```yaml
如：
  key: {{var}}/2      #这种写法是错误的
  key: "{{var}}/2"  
```
（2）yaml有其他数据类型（json只有字符串类型）
```yaml
如：
  key: 1        #这里的key值类型是整型（如果需要计算，要用到过滤器）
  key: '1'      #这里的key值类型是字符串
```  
##### 27.VIRT and RES
* VIRT：virtual memory，指该进程申请到的内存
* RES：resident memory，指该进程实际消耗的物理内存

##### 28.docker启动报错，排错：
dockerd --debug

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
cat /proc/sys/kernel/thereads_max
```
##### 30.制作docker镜像需要考虑的问题：
（1）基础镜像

（2）镜像时间

（3）启动的用户和挂载的目录的权限

（4）分层，当用到同样的环境，可以先制作一层

（5）僵尸进程问题
    容器内的孤儿进程会交给容器内pid为1的进程，如果该进程不回收子进程，则就会出现僵尸进程
  解决：让bash进程为pid为1的进程，或者docker run --init ...
**注意用bash解决的话，最好写入脚本，不然用bash -c可能pid为1的进程不是bash**

##### 31.如何man一个命令的子命令
```shell
whatis 子命令      #然后根据查询出来的结果man
```
##### 32./var/run和/var/lib
* /var/run：存放描述应用程序或系统的信息（如：pid）
* /var/lib：存放应用程序或系统有关的状态信息  

##### 33.利用awk给一组数据加标题
（1）利用自带标题
```shell
awk 'NR==1{print};/xx/{print}' xx
```
（2）自己设置标题
```shell
  awk 'BEGIN{print "title1 title2"}/xx/{print}' xx
```
##### 33.WAL：write-ahead logging
  预写日志，更改首先记录在日志中（日志存储在稳定的存储上），然后再将更改写入数据库

##### 34.以指定用户身份执行命令
（1）且获得该用户的环境变量
```shell
su - 用户名 -c 命令
```
（2）使用原用户的环境变量
```shell
su 用户 -c 命令
```  
##### 35.find 去除指定目录
```shell
find / -path '/tmp' -prune -o -iname 'test*' | grep -v '/tmp'

#跳过/tmp目录，这个执行的结果为false
#-o or
```
##### 36.调试iptables
（1）开启内核功能
```shell
modprobe nf_log_ipv4
sysctl net.netfilter.nf_log.2=nf_log_ipv4
```
（2）添加跟踪规则（只能在raw表中添加）
```shell
iptables -t raw -A PREROUTING xx(这里填需要跟踪的包的条件) -j TRACE
iptables -t raw -A OUTPUT xx(比如：-s 1.1.1.1) -j TRACE
```
（3）查看日志：/var/log/messages

##### 37.docker的端口映射，需要开启主机的ip转发功能

##### 38.使用“|”标注的文本内容缩进表示的块，可以保留块中已有的回车换行
```yaml
#如下：
  value: |
    hello
    world!
#输出：hello 换行 world！
```
##### 39.监控指标：
（1）RED
* rate			
每秒的请求数和被处理的请求数
* errors		
失败的请求数
* duration		
处理每个请求花费的时间

（2）USE
* utilization
cpu、内存、网络、存储使用率
* saturation
衡量当前服务的饱和度（看哪个指标用的多，快满了）
* errors

##### 40.SIGs（sepecial interests groups）
用于研究某一个感兴趣的方面的小组
一般是某一个系统的某一个组件

##### 41.替换字符串
```shell
  tr "xx" "xx"
```
#### 42.hash函数用来提取 定长的特征码

#### 43."No manual entry for xx"的解决方法
1. 确保下面两个软件已经安装
* man-pages
>man-pages提供linux系统的相关man文档  
* man-db
2. 查找xx的man文档是由哪个软件提供的
```shell
yum provides */xx.*.gz
```

#### 44.getconf —— 获取系统的变量
```shell
getconf -a      #显示所有系统变量（比如 PAGESIZE，CLK_TCK等)
#CLK_TCK这个变量用于计量与cpu有关的时间，标识一秒内cpu有多少次滴答（ticks）

getconf xx    #显示具体变量的值
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
