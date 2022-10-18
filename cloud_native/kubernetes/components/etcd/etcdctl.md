# etcdctl

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [etcdctl](#etcdctl)
    - [使用](#使用)
      - [1.前提：指定使用的API version](#1前提指定使用的api-version)
        - [（1）v2 api只能操作etcd v2 data](#1v2-api只能操作etcd-v2-data)
        - [（2）v3 api只能操作etcd v3 data](#2v3-api只能操作etcd-v3-data)
      - [2.基础命令](#2基础命令)
      - [3.写入操作](#3写入操作)
      - [4.查询操作](#4查询操作)
      - [5.删除操作](#5删除操作)
      - [6.监视一个key（即订阅）](#6监视一个key即订阅)
      - [7.压缩历史版本](#7压缩历史版本)
      - [8.租约相关：lease](#8租约相关lease)
      - [9.实现一致性（获取锁）](#9实现一致性获取锁)
      - [10.其他选项](#10其他选项)
      - [11.快照相关（只能用于v3数据）](#11快照相关只能用于v3数据)
      - [12.备份v2数据（同时也能备份v3数据）](#12备份v2数据同时也能备份v3数据)
      - [13.集群有关](#13集群有关)
        - [（1）查询集群信息](#1查询集群信息)

<!-- /code_chunk_output -->

### 使用

#### 1.前提：指定使用的API version
* 有2和3（跟etcdctl版本无关）两个版本，api version设置不对，无法查询到数据
```shell
export ETCDCTL_API=3
```
* 注意：endpoints有时用127.0.0.1无效，要用具体ip

##### （1）v2 api只能操作etcd v2 data
[etcdctl v2](https://chromium.googlesource.com/external/github.com/coreos/etcd/+/HEAD/etcdctl/READMEv2.md)

```shell
docker run --rm -it \
--network host -v /etc/kubernetes:/etc/kubernetes -v /var/lib:/var/lib -e ETCDCTL_API=2 \
<image> \
etcdctl --endpoints="https://127.0.0.1:2379"  --ca-file=/etc/kubernetes/pki/etcd/ca.crt --cert-file=/etc/kubernetes/pki/etcd/peer.crt  --key-file=/etc/kubernetes/pki/etcd/peer.key \
ls --recursive
```

##### （2）v3 api只能操作etcd v3 data

```shell
docker run --rm -it \
  --network host -v /etc/kubernetes:/etc/kubernetes -v /var/lib:/var/lib -e ETCDCTL_API=3  \
  <image> \
  etcdctl --endpoints="127.0.0.1:2379"  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt  --key=/etc/kubernetes/pki/etcd/peer.key \
  <command>
```


#### 2.基础命令
```shell
etcdctl --version

#能够查看etcdctl version和默认使用的API version
```

#### 3.写入操作
```shell
etcdctl put <KEY> <VALUE>
```

#### 4.查询操作

```shell
-w <FORMAT>   #已指定格式输出，比如：table、json等
```

* 查询所有key和值
```shell
etcdctl get "" --prefix
```

* 读取key和其对应的值
```shell
etcdctl get <KEY>
```

* 只读取 key 对应的值
```shell
etcdctl get <KEY> --print-value-only
```

* 十六进制格式输出
```shell
etcdctl get <KEY> --hex
```

* 读取一个范围
```shell
#读取的范围是：[foo,foo3) ，即会读取foo,foo1,foo2
etcdctl get foo foo3
```

* 按前缀读取
```shell
etcdctl get <key> --prefix
```

* 读取大于等于key的
```shell
#会读取大于等于bc的key（比如：bd、dxx、exx等）
etcdctl get bc --from-key
```

* 访问 指定版本 的 指定key
```shell
#<NUM>为版本号，0表示最新版本（1表示最旧版本，数字越大，版本越新）
etcdctl get <key> --rev=<NUM> --prefix
```

*  查询现在是哪个版本
```shell
etcdctl get <KEY> -w json
```

#### 5.删除操作
* 删除key
```shell
etcdctl del <KEY>
```
* 删除key，并返回key和值
```shell
#prev:previous
etcdctl del <KEY> --prev-kv
```

#### 6.监视一个key（即订阅）
```shell
etcdctl watch <KEY>  
#当该key发生任何命令，都会打印出来，比如：
#etcdtl watch foo
#在另一个终端执行：etcdctl put foo 123
#这边会显示：
# PUT
# foo
# 123
```

#### 7.压缩历史版本
```shell
etcdectl compact <NUM>    #小于等于<NUM>的版本都被删除
```

#### 8.租约相关：lease
用于设置key的生命周期

* 创建租约（单位：秒）
到时间，lease会被删除，绑定该lease的key也会被删除
```shell
etcdctl lease grant <NUM>   
#etcdctl lease grant 60   
#lease 694d7550a55f3f0a granted with TTL(60s)
```

* 删除租约
```shell
etcdctl lease revoke <LEASE>
```

* 刷新租约（即重新计时）
```shell
etcdctl lease keep-alive <LEASE>
```

* key绑定租约
```shell
etcdctl put <KEY> <VALUE> --lease=<LEASE>
```

* 查看租约详细（包括哪些key绑定了该租约）
```shell
etcdctl lease timetolive <LEASE>
etcdctl lease timetolive --keys <LEASE>   #--keys获取绑定了该租约的key
```

#### 9.实现一致性（获取锁）
```shell
etcdctl lock <LOCK,名字随便取> <COMMAND>

#<COMMAND>为shell命令，从而实现了一致性，即执行命令前先获得一把锁
```

#### 10.其他选项
* 指定endponts
```shell
--endpoints="3.1.5.19:2379,3.1.5.20:2379"
#当第一个endpoint无法连接时，会使用第二个
```

* 指定证书
```shell
--cacert=/etc/kubernetes/pki/etcd/ca.crt
--cert=/etc/kubernetes/pki/etcd/peer.crt
--key=/etc/kubernetes/pki/etcd/peer.key
```

#### 11.快照相关（只能用于v3数据）
能够保存、恢复 某个时间点的状态

* 生成快照（保存当前状态，需要能够连接etcd服务器）
```shell
etcdctl snapshot save test.db
```

* 查看快照的状态
```shell
etcdctl snapshot status test.db
```

* 恢复快照（不需要连接服务器）
需要暂停服务（以前的数据可以先移走，恢复时，指定数据目录名，就会生成一个新的数据目录）
```shell
etcdctl snapshot restore test.db --data-dir=<DIR>
```

* 恢复集群
恢复集群的部分参考k8s的backup

#### 12.备份v2数据（同时也能备份v3数据）
```shell
ETCDCTL_API=2 etcdctl backup --data-dir /var/lib/etcd/ --backup-dir /backupdir
```

* 恢复
将备份的数据移动到具体目录下

* 恢复集群
恢复集群的部分参考k8s的backup

#### 13.集群有关

##### （1）查询集群信息

* 查看集群成员信息
```shell
etcdctl member list -w table
```

* 查看集群成员状态
```shell
#endpoints指定哪些，才能查看哪些节点的信息
etcdctl endpoint status -w table --endpoints="xx,xx"
```
