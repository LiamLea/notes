[toc]
### `/proc/<PID>/`
存放某个进程的详细信息
#### `/proc/<PID>/exe`
链接到该进程的启动程序（绝对路径）

#### `/proc/<PID>/cwd`
链接到该进程的工作目录（current word directory）

#### `/proc/<PID>/root`
链接到该进程的根目录  

#### `/proc/<PID>/cmdline`  
该进程的启动命令  

#### `/proc/<PID>/comm`
执行的文件的名字  

#### `/proc/<PID>/environ`
该进程的一些环境变量

#### `/proc/<PID>/stat`
该进程的状态信息（ps命令用的就是这个文件）
* 计算某个进程的启动时间
```shell
#获取该进程的starttime（即在系统启动多久后启动的）
#starttime =
cat /proc/PID/stat | awk '{print $22}'

#获取clock ticks(即cpu在一秒内有多少ticks)
#CLK_TCK =
getconf CLK_TCK

#在系统启动多少秒后启动的进程
#starttime = starttime/CLK_TCK（单位：秒）
#即该进程在系统启动后的starttime秒后启动
```
* 计算某个进程的cpu使用率
```shell
#计算在cpu中花费的时间
#total_time = （utime + stime [ + cutime + cstime ]）/CLK_TCK

#计算进程运行了多久
#seconds = uptime - starttime

#计算cpu利用率
#cpu_usage = 100 * total_time/seconds
```

#### `/proc/<PID>/statm`
该进程的内存信息

#### `/proc/<PID>/status`
将进程的常用状态和内存等信息以人类可读的方式展示

#### `/proc/<PID>/fd/`
该目录下存放该进程的文件描述符（链接到打开的文件）

#### `/proc/<PID>/maps`
该文件中存储了 被加载到该进程中的文件的 信息

#### `/proc/<PID>/io`
该进程的io使用情况

#### `/proc/<PID>/net/`
* 套接字不与特定进程关联。创建套接字时，其引用计数为1
* 可以为同一套接字创建许多引用

##### `/proc/<PID>/net/tcp`
这个文件存储 该进程**所在的网络名称空间** 中的所有TCPv4套接字
