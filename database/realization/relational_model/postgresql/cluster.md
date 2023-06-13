# cluster

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [cluster](#cluster)
    - [基础概念](#基础概念)
      - [1.replication slot](#1replication-slot)
      - [2.hot standby](#2hot-standby)
    - [安装](#安装)
      - [1.前期准备](#1前期准备)
      - [2.Master设置](#2master设置)
        - [（1）修改监听端口](#1修改监听端口)
        - [（2）创建用于同步的用户](#2创建用于同步的用户)
        - [（3）创建replication slot](#3创建replication-slot)
        - [（4）设置访问权限](#4设置访问权限)
      - [3.Standby设置](#3standby设置)
        - [（1）复制master的数据](#1复制master的数据)
        - [（2）开启hot standby](#2开启hot-standby)
        - [（3）开启standby模式](#3开启standby模式)
        - [（4）设置文件所属并重启](#4设置文件所属并重启)
      - [4.验证](#4验证)
    - [扩展](#扩展)
      - [1.使用归档的wal](#1使用归档的wal)
        - [（1）master的配置](#1master的配置)
        - [（2）standby的配置](#2standby的配置)
      - [2.开启同步模式](#2开启同步模式)

<!-- /code_chunk_output -->

### 基础概念

#### 1.replication slot
所有standby都收到WAL段 之后，才会删除WAL相应段
确保了所有standby都能够同步到数据，即使有些standby延迟可能有些大

#### 2.hot standby
当server处于archive recovery或者standby模式时，客户端能够连接该server并运行查询

***

### 安装

#### 1.前期准备
* 都安装好postgresql并且完成初始化

#### 2.Master设置

##### （1）修改监听端口
```shell
$ vim /var/lib/pgsql/11/data/postgresql.conf

listen_addresses = '*'

$ systemctl restart postgresql-11.service
```

##### （2）创建用于同步的用户
```shell
su - postgres
psql

> CREATE ROLE <USER> LOGIN REPLICATION ENCRYPTED PASSWORD '<PASSWD>';
```

##### （3）创建replication slot
```shell
#后面需要用到该slot
> SELECT * FROM pg_create_physical_replication_slot('<SLOT_NAME>');

#查看slot
> SELECT * FROM pg_replication_slots;
```

##### （4）设置访问权限
```shell
$ vim /var/lib/pgsql/11/data/pg_hba.conf

host    replication     <USER>      0.0.0.0/0          md5

$ systemctl restart postgresql-11.service
```

#### 3.Standby设置

##### （1）复制master的数据
```shell
mv /var/lib/pgsql/11/data/* /tmp/
pg_basebackup -h master_ip_address -U replicator -D /var/lib/pgsql/11/data/ -P --password --slot replicator
```

##### （2）开启hot standby
```shell
$ vim /var/lib/pgsql/11/data/postgresql.conf

hot_standby = on
```

##### （3）开启standby模式
* 11版本即之前的版本需要创建一个文件：`recovery.conf`
* 12版本之后的版本，直接在`postgresql.conf`中修改即可
```shell
$ vim /var/lib/pgsql/11/data/recovery.conf

#开启standby模式
standby_mode = 'on'

#master的信息
#application_name随便设置，用于标识该standby server
primary_conninfo = 'host=<IP> port=<PORT> user=<USER> password=<PASSWORD> application_name=<STANDBY_NAME>'

#指定slot
primary_slot_name = '<SLOT_NAME>'

trigger_file = '/var/lib/pgsql/11/data/failover.trigger'
```

##### （4）设置文件所属并重启
```shell
chown -R postgres:postgres /var/lib/pgsql/11/data/
systemctl restart postgresql-11.service
```

#### 4.验证
* master上创建数据库
```shell
su - postgres
psql

> create database test;
> \l
```

* 在standby上查看
```shell
su - postgres
psql

> \l
```

***

### 扩展

#### 1.使用归档的wal
##### （1）master的配置
`postgresql.conf`
```shell
archive_mode = ON
archive_command = 'cp %p /archives/%f'    #路径需要具体指定
                                          #%p和%f就是特殊写法
```


##### （2）standby的配置
`recovery.conf`
```shell
restore_command = 'cp /archives/%f %p'
```

#### 2.开启同步模式
master配置`postgresql.conf`
```shell
#当有多个standby时，只有当 任意<NUMBER>个 standby commit了，则这次才算commit
#standby_name是在primary_conninfo中设置
synchronous_standby_names ANY <NUMBER> (<standby_name1>, <standby_name2>)
```
