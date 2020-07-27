[toc]
### 相关基础概念
#### 1.cpu相关
* Socket
cpu的插槽（一个插槽代表一个主板上的芯片）
</br>
* Core
cpu的核心，一个核心代表一个独立的处理器（即物理cpu，提供真正的并行能力）
</br>
* Thead
超线程，只是操作系统指令的队列（提高cpu的性能，但不能提供真正的并行能力）
会**欺骗**操作系统，把一个Thread当作一个逻辑CPU
</br>
* CPU（逻辑CPU）
`逻辑CPU = Socket * Core * Thread`
`物理CPU = Socket * Core`
#### 2.系统uuid相关
##### （1）system-serial_number
是服务器的序列码，写在服务器的外部
##### （2）system-uuid 和 machine-id区别
* system-uuid
写在BIOS中的，在操作系统中无法修改，重装系统也还是不变（/sys/class/dmi/id/product_uuid）
</br>
* machine-id
安装操作系统时生成的，可以直接修改（/etc/machine-id）

***
### 获取底层信息
#### 1.DMI(desktop mamanger interface)
桌面管理接口，生成一个行业标准的框架，用于收集和管理当前设备的环境信息（硬件和相关软件等）
```shell
#该命用于显示dmi管理的信息
dmidecode               #显示全部环境信息

-t 类型     
#查看有哪些类型：
#   dmidecode -t --help

-s 关键字
#查看有哪些关键字：
#   dmidecode -t --help

```
