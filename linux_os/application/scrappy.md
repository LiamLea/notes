
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [wifi](#wifi)
  - [1.基础概念](#1基础概念)
    - [（1）ssid（service set id）](#1ssidservice-set-id)
    - [（2）wpa](#2wpa)
  - [2.连接wifi](#2连接wifi)
    - [（1）查看wifi设备](#1查看wifi设备)
    - [（2）开启wifi](#2开启wifi)
    - [（3）查看可用的无线网](#3查看可用的无线网)
    - [（4）连接无线网](#4连接无线网)
    - [（5）获取ip](#5获取ip)

<!-- /code_chunk_output -->

### wifi

#### 1.基础概念
##### （1）ssid（service set id）
服务集标识
##### （2）wpa

#### 2.连接wifi

##### （1）查看wifi设备
```shell
iw dev
```
##### （2）开启wifi
```shell
ip link
ip link set <INTERFACE> up

#如果报错
# rfkill unblock all`
```

##### （3）查看可用的无线网
```shell
iw dev <INTERFACE> scan
```

##### （4）连接无线网
* 配置
```shell
vim /etc/wpa_supplicant/wpa_supplicant.conf

network={
  ssid="<SSID>"
  psk="<PASSWD>"
}
```
* 连接
```shell
wpa_supplicant -B -i <INTERFACE>  -c /etc/wpa_supplicant/wpa_supplicant.conf
```
* 查看是否连接成功
```shell
iw dev <INTERFACE> link
```

##### （5）获取ip
```shell
dhclient <INTERFACE>
```
