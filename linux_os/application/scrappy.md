[toc]
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
