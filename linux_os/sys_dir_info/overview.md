### /sys目录
>/sys挂载的是sysfs文件系统，这是一个虚拟的文件系统（基于ram）  

>用于导出内核系统、硬件和相关设备驱动的信息，方便用户空间进程进行使用  
#### 1.基础
```shell
  /sys/class/net/       #存放所有网络接口
  /sys/class/input/     #存放所有输入设备
  /sys/class/tty/       #存放所有串行设备
  /sys/block/           #存放块设备，由于历史原因才没放在class下的
```
