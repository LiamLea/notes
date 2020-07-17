[toc]

### 概述
#### 1.相关概念
* vip
* scan_ip

### 查询
* 查看vip
```shell
olsnodes -i
```
* 查看集群名称
```shell
cemutlo -n
```

* 查看scan_ip

* 查看集群状态

### servctl（server control）
#### 1.查询

##### （1）查询数据库信息
* 查询有多少数据库
```shell
$ srvctl config  database

orcl
orclsec
```

* 查询具体数据库的详细信息
```shell
$ srvctl config database -d <DB_NAME>

Database unique name: orcl
Database name: orcl
Oracle home: /u01/oracle/product/11.2.0/db
Oracle user: oracle
Type: RAC
Database instances: orcl11,orcl12
Configured nodes: rac1,rac2
...
```

* 查看数据库状态
```shell
$ srvctl status database -d orcl

Instance orcl11 is running on node rac1
Instance orcl12 is running on node rac2
```

* 查看数据库在指定节点上的实例
```shell
$ srvctl status instance -d <DB_NAME> -node <NODE1>,<NODE2>,...
```

* 查看管理数据库（不一定有）
```shell
srvctl config mgmtdb -all
```

* 查看监听端口（不一定有）
```shell
$ srvctl config mgmtlsnr

Name: MGMTLSNR
Type: Management Listener
Owner: grid
Home: <CRS home>
End points: TCP:1525
Management listener is enabled.
Management listener is individually enabled on nodes:
Management listener is individually disabled on nodes:
```

##### （2）查询端口信息
* 数据库监听器
```shell
$ srvctl config listener

Name: LISTENER
Type: Database Listener
Network: 1, Owner: grid
Home: <CRS home>
End points: TCP:1521

$ srvctl status listener

Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
```

* scan_ip监听器
```shell
$ srvctl config scan_listener

SCAN Listener LISTENER_SCAN1 exists. Port: TCP:1521
SCAN Listener is enabled.

$ srvctl status scan_listener
SCAN Listener LISTENER_SCAN1 is enabled
SCAN listener LISTENER_SCAN1 is running on node rac1
```

##### （3）查看ip信息
* 查看scan_ip
```shell
$ srvctl config scan

SCAN name: rac-scan, Network: 1
SCAN 1 IPv4 VIP: 3.1.3.212
SCAN VIP is enabled.

$ srvctl status scan

SCAN VIP scan1 is enabled
SCAN VIP scan1 is running on node rac1
```

* 查看vip
```shell
$ srvctl config nodeapps

VIP exists: network number 1, hosting node rac1
VIP Name: rac1-vip
VIP IPv4 Address: 3.1.3.210

VIP exists: network number 1, hosting node rac2
VIP Name: rac2-vip
VIP IPv4 Address: 3.1.3.211

$ srvctl config  vip -node <NODE>
```

```shell
srvctl config srvpool
srvctl status srvpool
```

#### （4）查看具体node上的信息
```shell
srvctl status vip -n <NODE>
```

### crsctl
#### （1）查看域名的ip地址
```shell
crsctl status ip -A <IP_NAME>
```
