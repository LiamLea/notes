# wmic

[toc]

### 概述

#### 1.wmic
Windows Management Instrumentation command-line

#### 2.相关术语

##### （1）alias
class、property、method的别名，通过wmic看到的都是别名

##### （2）switches
全局开关，就是全局变量
常用switches：
|switch|说明|例子|
|-|-|-|
|/NODE|指定目标机，不指定就是本机|`/NODE:3.1.5.19`|
|/USER|指定用户名|`/USER:Administrator`|
|/PASSWORD|指定密码|`/PASSWORD:!QAZ2wsx`|

##### （3）verbs
verbs跟在alias后面，用于执行相关操作
常用verbs：
|verbs|说明|例子|
|-|-|-|
|GET|获取指定属性的值|`PROCESS GET NAME`|
|LIST|展示数据，后面可以跟：</br>`BRIEF`</br>`FULL`</br>`INSTANCE`</br>`STATUS`</br>`SYSTEM`|`PROCESS LIST BRIEF`|
|CALL|执行一个函数|`SERVICE WHERE CAPTION='TELNET' CALL STARTSERVICE`|
|CREATE|创建一个实例|`ENVIRONMENT CREATE NAME="TEMP"; VARIABLEVALUE="NEW"`|
|DELTE|删除一个实例|`PROCESS WHERE NAME="CALC.EXE" DELETE`|

#### 3.使用的端口
用RPC（端口135，是硬编码的，不允许修改）去协商，然后会在1024和65535之间选择一个随机的端口进行通信

***

### 使用

#### 1.在linux上安装wmic
```shell
ulimit -n 100000
cd /tmp
mkdir wmic
cd wmic

apt install autoconf gcc libdatetime-perl make build-essential g++ python-dev
wget http://www.opsview.com/sites/default/files/wmi-1.3.16.tar_.bz2
bunzip2 wmi-1.3.16.tar_.bz2
tar -xvf wmi-1.3.16.tar_
cd wmi-1.3.16/

vim Samba/source/pidl/pidl
:583 (to jump to line 583)
remove the word defined before @$pidl
:wq

export ZENHOME=/usr
make "CPP=gcc -E -ffreestanding"
cp Samba/source/bin/wmic /bin
```

#### 2.在Linux上使用wmic

##### （1）wmi的所有类
[https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-processor](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-processor)

##### （2）命令
```shell
wmic -U <USERNAME>%<PASSWD> //<IP> "select * from Win32_Processor"
```

#### 3.在windoews上使用wmic

* 查看所有alias
```shell
#查看有哪些alias
wmic /?

#查看某个alias有哪些verbs
wmic BIOS /?

#查看某个verbs能够获取哪些属性
wmic BIOS GET /?
```

* 远程执行wmic命令
```shell
wmic /NODE:3.1.5.19 /USER:root /PASSWORD:123456 ...
```
