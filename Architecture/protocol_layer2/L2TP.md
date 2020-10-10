# L2TP
[toc]

### 概述

#### 1.L2TP
layer 2 tunneling protocol

#### 2.加密是通过ipsec实现的
* 使用ipsec的transport模式

#### 3.特点
* l2tp server会监听在 **UDP的1701端口**

#### 4.l2tp frame
![](./imgs/l2tp_01.png)

***

### 部署 L2TP + IPSec

#### 1.部署ipsec

##### （1）安装libreswan

##### （2）配置ipsec

```shell
$ vim /etc/ipsec.d/my.conf
#如果修改配置，需要 rm -rf /etc/ipsec.d/*db

conn L2TP-PSK-noNAT
     authby=secret               #使用密码的方式（即预共享密钥）
     pfs=no
     auto=add
     keyingtries=3
     dpddelay=30
     dpdtimeout=120
     dpdaction=clear
     rekey=no
     ikelifetime=8h
     keylife=1h
     type=trnasport              #使用transport模式，没必要使用tunnel模式，因为l2tp会封装新的ip头
     left=3.1.5.24               #当前主机的ip
     leftprotoport=17/1701       #指定在什么情况下使用ipsec，当连接 UDP的1701端口时（这是l2tp监听的端口）
     right=%any                  #接受任何对端，使用ipsec
     rightprotoport=17/%any      #指定在什么情况下使用ipsec，当对端使用UDP协议时（因为连接l2tp需要使用UDP协议，但是端口随机）
```

##### （3）配置预共享密钥
```shell
$ vim /etc/ipsec.d/my.secrets

<ID_Selector> : PSK "<PASSWORD>"
#<ID_Selector>是id选择器，用于进行身份验证，这里的ID都是ip、域名等，用空格隔开
#比如：%any  表示所有主机都可以用该预共享密钥进行认证
#比如：3.1.1.101 3.1.1.102 3.1.1.103   表示只有这三个ip可以使用该预共享密钥（需要包含本地的ip）
```

#### 2.部署l2tp

##### （1）安装xl2tpd
```shell
yum -y install epel-release
yum -y install xl2tpd
```

##### （2）l2tp配置（地址池）
```shell
$ vim /etc/xl2tpd/xl2tpd.conf

ip range = <VIP_POOL>     #分配出去的VIP地址，比如：10.10.10.100-200
local ip = <LOCAL_VIP>    #设置本地的VIP地址
```

##### （3）配置ppp
* 使用的ppp功能配置
```shell
$ vim /etc/ppp/options.xl2tp
#用默认的就行，一般不用修改
```

* 设置ppp握手认证
```shell
$ vim /etc/ppp/chap-secrets

<USERNAME> <SERVER_ID> <PASSWORD> <CLIENT_IP>

#<SERVER_ID>，服务器标识(在第二个配置文件中有)：* 表示匹配所有
#<CLIENT_IP>，客户端ip：* 表示匹配所有
#比如：liyi * 123 *
```
