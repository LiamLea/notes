# snmp（simple network management protocol）
[toc]
### 基础概念

#### 1.snmp网络管理框架由三部分组成：
* SMI（structure of management info）
管理信息结构
* MIB（management information base）
管理信息库
* SNMP（simple network management protocol）
管理协议

#### 2.oid（object identity）
对象标识符（树状结构）
用来标识系统内的各种资源（即监控点），是一棵树

#### 3.community（共同体名）
* 支持的版本：v1、v2c
* 就是口令，用于访问snmp存放数据的mib
* 有两种权限划分：只读 和 读写
```shell
rocommunity xx        #只要口令是xx，都是只读共同体  
```

#### 4.v3三种安全级别
认证即对身份进行认证，加密即对信息进行加密，就不需要共同体名了
* noAuthNoPriv           
不认证（authentication）也不加密（privicy）
* authNoPriv             
认证但是不加密
* authPriv              
既认证又加密

#### 5.v2c和v3的区别
* v2c
明文传输，团体名进行安全机制管理，简单
* v3
基于用户的安全模型（认证和加密），开销大

#### 6.USM：user-based security model

#### 7.Context
allow multiple versions of the same MIB objects to be made available by a single SNMPv3 engine, as if you have multiple agents running on the same IP address and port.
* ContextName
* ContextEngineID

***

### 配置
#### 1.修改配置文件
```shell
#注释com2sec和access

#配置视图
view  systemview  included   .1       #可以查看所有的oid

#配置共同体
rocommunity  <COMMUNITY_NAME>  [HOST]  [OID]
#[HOST]为可以访问的主机地址，默认都可以
#[OID]为oid，用于限制可以访问的oid，默认都可以访问

#v3的配置，前面的都相同
#（1）注释group部分，即禁用v1和v2c
#（2）添加一行：
group   notConfigGroup   usm   notConfigUser

#创建用户（仅限于v3）
#创建用户，认证码为xx1，加密方式为MD5，密码为xx2，加密方式为DES  
createUser  '用户名'  MD5  'xx1'  DES 'xx2'      
#指定该用户为只读权限
rouser 用户名
```

#### 2.重启服务

#### 3.验证
```shell
snmpwalk -v 3 -u <USER> -a MD5 -A <认证码> -x DES -X <密码> <IP> <OID>
```

#### 4.采集分区信息
如果需要采集分区的信息，还需要加入以下配置:
```shell
disk / 100000
#添加根分区信息，并判断根分区的总的大小是否小于100000，
#如果根分区小于100M，则会把dskErrorFlag这个置为1（用处不大，可以什么都不写）
```
```shell
snmpwalk  ...   .1.3.6.1.4.1.2021.9.1     #可以查看，有多少关于该分区的信息的信息
```

***
### 扩展
#### 1.自定义oid

##### （1）创建脚本（最后必须输出，三行内容）
```shell
  ... ...
  echo <OID>             #<OID>为定义的oid，这个oid必须没有被使用
  echo integer
  echo xx             #这里输出结果
```

##### （2）修改snmpd.conf
```shell
pass <OID> 脚本         #<OID>为定义的oid，脚本比如：/bin/sh /usr/bin/test.sh
```

***

### 常用指令

* 查看所有oid 或 某个oid以下的oid
```shell
snmpwalk  [options]  ip地址  [oid]         
```

* 查看某个oid具体的值
```shell
snmpget [options] ip地址 [oid]

options:
  -v            #version，指定snmp的版本（1 | 2c | 3）
  -c            #community，指定使用的团体名
  -l            #level，指定安全等级（noAuthNoPriv | authNoPriv | authPriv）
  -On           #输出的oid都是数字，不是MIB resolutions
```

* v1和v2c常用的：
```shell
snmpwalk -v 2c -c public localhost
snmpget -v 2c -c public localhost xx
```

* v3常用的：
```shell
snmpwalk -v 3 -l authPriv -u 用户名 -a MD5 -A 认证码 -x DES -X 密码 ip地址 oid
```
