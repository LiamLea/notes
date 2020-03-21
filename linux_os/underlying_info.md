[toc]
### DMI(desktop mamanger interface)
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
### system-uuid 和 machine-id区别
* **system-uuid**是写在BIOS中的，在操作系统中无法修改，重装系统也还是不变（/sys/class/dmi/id/product_uuid）
* **machine-id**是安装操作系统时生成的，可以直接修改（/etc/machine-id）
