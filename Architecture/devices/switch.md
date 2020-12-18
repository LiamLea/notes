# switch

[toc]

### 基础

#### 1.术语
* optical port（光口）
* electrical port（电口）

The electrical ports support 10/100/1000 Mbps, and optical ports support 1000 Mbps (1 Gbps) using SFP.

#### 2.port的命名

```shell
<TYPE><CHASSIS>/<SLOT>/<PORT>

#<TYPE>表示该端口的类型：
#   Ten-GigabitEthernet：10G以太口
#   FortyGigE：40G以太口
#   M-GigabitEthernet：M表示management，表示是管理口
#<CHASSIS>表示在第几个设备（从0开始）
#<SLOT>表示在第几个插槽（从0开始）
#<PORT>表示在第几个端口上（从0开始）
```

#### 3.`PortIndex`、`IfIndex`和`IfName`

|Item|Description|
|-|-|
|IfName|Interface name|
|IfIndex|Index value of an interface|
|PortIndex|Index value of a port|

```shell
IfName                          IfIndex   PortIndex                             
--------------------------------------------------                              
GigabitEthernet0/0/0            8         0                                     
NULL0                           2         --                                    
Vlanif1                         6         --                                    
Wlan-Capwap0                    7         1                                     
Wlan-Radio0/0/0                 9         --                                    
Wlan-Radio0/0/1                 4         --    
```

#### 4.端口信息

##### （1）端口状态
* Admin status
当为UP，表示该端口可用（enabled）
</br>
* Operation status
当为UP，表示该端口有设备连接此端口，该端口正在使用中

#### 5.分析直连设备

* 首先分析出，直接的交换机，并且记录与哪个端口相连的
  * 可以利用lldp协议

* 分析mac地址表，排除 与交换机之间的端口的所有条目，剩下的条目就是与交换机直连的服务器

***

### 常用命令

#### 1.接口相关

##### （1）查看接口概要信息
```shell
display interface brief

#vlanif 后面跟的数字就表示该vlanif在哪个vlan中
```

##### （2）查看所有ip
```shell
display ip interface brief
```

#### 2.设置日志输出到syslog服务器

* 设置通道
一共有6个通道，每个通道是日志输入到不同的地方的配置（比如：console、telnet终端、syslog服务器等）
```shell
info-center source default channel 2 log level debugging
```

* 指定从哪个接口出去（不设置应该会自动选择）
```shell
info-center loghost source Vlanif1
```

* 指定远程syslog服务器地址
```shell
info-center loghost <IP>
```

***

### 常用oid

* 端口信息
```shell
1.3.6.1.4.1.25506.8.35.18.4.5.1
```

* 接口信息（包括端口）
```shell
1.3.6.1.2.1.2.2.1
```
