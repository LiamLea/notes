
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [`/sys/`目录](#sys目录)
  - [`/sys/class/` —— 分类存放设备驱动信息（都是链接文件）](#sysclass-分类存放设备驱动信息都是链接文件)
  - [`/sys/devices/` —— 存放设备驱动信息](#sysdevices-存放设备驱动信息)
  - [`/sys/block/` —— 存放块设备的链接文件，由于历史原因才没放在class下的](#sysblock-存放块设备的链接文件由于历史原因才没放在class下的)

<!-- /code_chunk_output -->

### `/sys/`目录
* `/sys`挂载的是sysfs文件系统，这是一个虚拟的文件系统（基于ram）  

* 用于导出内核系统、硬件和相关设备 **驱动** 的信息，方便用户空间进程进行使用  

#### `/sys/class/` —— 分类存放设备驱动信息（都是链接文件）
* `/sys/class/net/` —— 存放所有网络接口的链接文件
* `/sys/class/input/` —— 存放所有输入设备的链接文件
* `/sys/class/tty/` —— 存放所有串行设备的链接文件

#### `/sys/devices/` —— 存放设备驱动信息
* `/sys/devices/virtual` —— 存放的虚拟设备

#### `/sys/block/` —— 存放块设备的链接文件，由于历史原因才没放在class下的
