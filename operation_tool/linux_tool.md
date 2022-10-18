
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [locate](#locate)
  - [1.由四部分组成](#1由四部分组成)
  - [2.配置文件：/etc/updatedb.conf](#2配置文件etcupdatedbconf)
  - [3.locate命令](#3locate命令)
- [traceroute](#traceroute)
  - [1.原理](#1原理)
- [一些查看的小命令](#一些查看的小命令)
    - [`xxd -b <FILE>`](#xxd-b-file)
    - [`strings <FILE>`](#strings-file)

<!-- /code_chunk_output -->

### locate

#### 1.由四部分组成
```shell
  /etc/updatedb.conf
  /var/lib/mlocate/mlocate.db     #存放文件信息的文件
  updatedb                        #该命令用于更新数据库
  locate                          #该命令用于在数据库中查找
```
#### 2.配置文件：/etc/updatedb.conf
```shell
  PRUNE_BIND_MOUNTS = "yes"       #开启过滤
  PRUNEFS = "xx1 xx2"             #过滤到的文件系统类型
  PRUNENAMES = ".git"             #过滤的文件
  PRUNEPATHS = "xx1 xx2"          #过滤的路径
```
#### 3.locate命令
```shell
  -b xx        #basename，文件名包含xx
  -i xx        #忽略大小写
  -q           #安静模式
  -r xx        #正则
  -R           #列出ppid
```

***

### traceroute
#### 1.原理
```
每个ip包都有一个ttl字段，用于设置最大的跳数，
如果超过这个跳数还没到达目的地，则会丢弃该ip包，
并通知发送方（利用类型为time-exceeded的icmp包通知）
```

***

### 一些查看的小命令
##### `xxd -b <FILE>`
以二进制形式查看文件
##### `strings <FILE>`
将二进制文件转换成字符串
