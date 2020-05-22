/proc —— 伪文件系统，内核相关数据
* /proc/PID/ —— 进程信息  
</br>
* /proc/sys/ —— 内核有关参数  
  * /proc/sys/kernel —— 内核参数  
  * /proc/sys/vm —— 内存参数  
  * /proc/sys/fs —— 文件系统参数  
  * /proc/sys/net —— 网络参数  
</br>
* /proc/stat —— 系统的统计数据（自系统启动以来）
  * **cpu ... ...**  
  ```
  #第一行为cpu的统计数据

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
  * **intr ... ...**  
  ```
  第一列 服务的中断总数
  其他列 为特定中断的数量统计
  ```
  * **ctxt ...**  
  ```
  上下文切换的总次数
  ```
  * **btime ...**  
  ```
  系统启动的时间（自1970-01-01以来的秒数）
  ```
  * **processes ...**  
  ```
  forks的总次数
  ```
  * **procs_running ...**  
  ```
  正在运行的进程数
  ```
  * **procs_blocked ...**  
  ```
  等待I/O完成的进程数
  ```
</br>
* /proc/diskstats —— 磁盘的I/O统计数据

  ```
  iostat -x

    rrqm/s        #每秒合并的读请求数量
    r/s           #每秒完成的读请求数量
    rKB/s         #每秒读多少KB
    avgrq-sz      #请求的平均大小（以扇区为基本单位），即每秒平均吞吐量
    avgqu-sz      #请求的平均队列长度
    await         #平均IO响应时间
    r_await       #读请求响应时间
    %util         #磁盘忙于处理读取或写入请求所用时间的百分比
  ```
