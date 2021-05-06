# NFS

[toc]

### 概述

#### 1.nfs v4的优势

* stateful
服务端和客户端保持有状态的连接
</br>
* 防火墙策略容易设置
v4只暴露2049端口
v3依赖rpcbind，需要暴露多个端口
</br>
* 伪文件系统
对客户端来说看到的就是一个根目录
</br>
* 更好的性能


***

### 配置

#### 1.关闭nfsv2和nfsv3

* centos
```shell
$ vim /etc/nfs.conf

[nfsd]
vers2=n
vers3=n

#重启nfs server
```

* ubuntu
```shell
$ vim /etc/default/nfs-kernel-server

RPCMOUNTDOPTS="... --no-nfs-version 2 --no-nfs-version 3"

#重启nfs server
```

* 验证
nfsv4不能使用showmount显示暴露的目录
```shell
$ showmount -e 127.0.0.1
clnt_create: RPC: Program not registered
```

#### 2.配置exports

##### （1）选项
* `rw` or `ro`
* `sync` or `async`
* `fsid=0`
对于客户端而言，当前暴露的目录为根路径
比如：暴露`/mnt`且`fsid=0`，
则客户端`mount -t nfs -o vers=4 <IP>:/`，就是挂载`/mnt`目录
`mount -t nfs -o vers=4 <IP>:/test`，就是挂载`/mnt/test`目录
* `no_subtree_check`
是否检查暴露的目录下的目录，如果检查到下面有目录会自动export，即客户端可以挂载该目录
* `no_root_squash`
客户端的root，对这个挂载的目录有root权限
* `insecure`
secure的话，需要请求的端口小于1024
* `no_auth_nlm`
不需要对加锁请求进行认证
