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
* 每个input需要加载一个input module
#####（1）常用input module
|模块名|说明|
|-|-|
|imuxsock|input module unix socket，通过Unix socket收集本地日志，**默认加载**，所以无需在配置中指定|
|imjournal|input module journal，收集journald服务收集到的日志|
|imudp|input module udp|监听在某个UDP端口，接收

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
* 通过syslog等库函数收集**系统日志**
* 收集systemd管理的**服务的日志**
* 收集**审计日志**
