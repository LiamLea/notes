[toc]
# rsyslog(rocket-fast syslog)
### 概述
#### 1.rsyslog功能
* 接收多种方式的输入
* 转换
* 输出到多种目的地
![](./imgs/rsyslog_vs_journald_01.png)

#### 2.处理流程
```mermaid
graph LR
A("Input") --> B("RuleSet")
B --> C("Output")
```

#### 3.input
|模块名|说明|
|-|-|
|imuxsock|input module unix socket，通过Unix socket 收集系统进程的日志|
|imklog|input module module，收集内核日志|
|imjournal|input module journal，收集journald服务收集到的日志|
|imudp|input module udp，监听在某个UDP端口，接收日志|
|imtcp|input module tcp，监听在某个TCP端口，接收日志|

#### 4.rules
每个rule 由 selector + action 组成
##### （1）selector（选择器）
selector：`<facility>.<level>`

facility：
```shell
#man 3 syslog查看
auth          #security/authorization messages
authpriv      #security/authorization messages (private)

daemon        #没有单独的facility值的系统守护进程
kern          #kernel messages
...
```
level：
```shell
debug
info
notice
warning
error
crit
alert
emerg
```
##### （2）actions
* 文件
* 远程主机
```shell
*.* @<IP>:<PORT>    #通过UDP协议发送
*.* @@<IP>:<PORT>   #通过TCP协议发送
```


***
# systemd-journald
### 概述
#### 1.特点
* journald是systemd自带的服务，**配置文件**/etc/systemd/journald.conf
* 日志以**二进制**形式存放
* 如果存在/var/log/journal/目录，则日志会被**持久化**存储在该目录下
* 如果不存在该目录，则日志会被**临时**存放在/run/log/journal/目录下，重启后里面的内容会丢失
#### 2.收集以下日志：
* 通过kmsg收集**内核日志**
* 通过syslog等库函数收集**简单的系统日志**
* 收集systemd管理的**服务的日志**
* 收集**审计日志**
