# NTP（Network Time Protocol）
[toc]

### 概述
#### 1.特点
* 分层设计(不超过15层)
* 缺陷:当闰秒的时候要将服务器暂时关闭,否则会崩溃

#### 2.常用ntp服务器地址
* ntp.ntsc.ac.cn
* ntp1.aliyun.com
* 210.72.145.44 (国家授时中心服务器IP地址)

***

### 配置
#### 1.服务端：`/etc/chrony.conf`
* 指定ntp server
```shell
server <NTP_SERVER> iburst prefer
#当一个远程NTP服务器不可用时，向它发送一系列的并发包进行检测
#prefer优先使用该服务器
```
* 权限设置
```shell
#拒绝IPV4用户和#IPV6用户   
restrict default kod nomodify notrap nopeer noquery  
restrict -6 default kod nomodify notrap nopeer noquery    

#放行ntp server（即指定使用的ntp server，需要放行）
restrict <NTP_SERVER>

#放行本机
restrict 127.0.0.1
restrict -6 ::1

#本地网段授权访问
restrict 192.168.100.0 mask 255.255.255.0 nomodify
```
* 声明所在的层
```shell
#127.127.1.0表示本机系统时间源
#当没有时间同步来源的时候以自身的硬件时钟为准（如果有其他时间服务器，不会使用本地时钟）
server 127.127.1.0
fudge 127.127.1.0 stratum <STRATUM_NUMBER>
```

#### 2.客户端: `/etc/chrony.conf`
```shell
server <NTP_SERVER> iburst
```

***

### 查询ntp状态
