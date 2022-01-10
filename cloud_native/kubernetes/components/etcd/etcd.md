# etcd

[toc]

### 集群概述

#### 1.集群节点必须是奇数个
因为3个挂掉2个，该集群就不能用了
4个挂掉2个，该集群也不能用了，
所以偶数个有一个是浪费的

#### 2.高可用
必须存活一半以上的节点，不然集群无法使用

### 集群搭建

需要注意的内容：
* `--initial-cluster-state=existing`
* 注意协议是http还是https
#### 1.启动第一个etcd
```shell
#注意第一个节点，一定不能加这个参数：--initial-cluster-state=existing
./etcd  \
        #基础配置
        --name=<NAME> \    #该节点的名称，随便取,，默认用主机名
        --listen-client-urls=http://0.0.0.0:2379 \     #监听地址
        --advertise-client-urls=http://<IP>:2379 \ #对外宣告的地址

        #集群配置
        --listen-peer-urls=http://0.0.0.0:2380 \           #集群服务监听地址
        --initial-advertise-peer-urls=http://<IP>:2380 \   #集群服务对外宣告的地址
        --initial-cluster=<NAME>=http://<IP>:2380     #集群成员的信息，一定要包含其自身（当知道其他节点的信息，也可以在这里给出）
```

#### 2.添加集群节点

##### （1）在已存在的etcd中添加member信息
如果在启动etcd时，已经指定了其他节点的信息，这一步可以跳过
```shell
./etcdctl member add <NAME> --peer-urls=http://<IP>:2380

#查看
./etcdctl member list
```

##### （2）启动节点
```shell
./etcd  \
        #基础配置
        --name=<NAME> \    #该节点的名称，随便取,，默认用主机名
        --listen-client-urls=http://0.0.0.0:2379 \     #监听地址
        --advertise-client-urls=http://<IP>:2379 \ #对外宣告的地址

        #集群配置
        --listen-peer-urls=http://0.0.0.0:2380 \           #集群服务监听地址
        --initial-advertise-peer-urls=http://<IP>:2380 \   #集群服务对外宣告的地址
        --initial-cluster=<NAME-1>=http://<IP-1>:2380,<NAME-2>=http://<IP-2>:2380 \    #集群成员的信息
        --initial-cluster-state=existing
```

#### 3.查看集群信息
```shell
#查看集群成员信息
./etcdctl member list

#查看集群成员状态
./etcdctl endpoint status --endpoints="xx,xx"
```

#### 4.备份和恢复

##### （1）备份
备份数据
* 不区分具体节点，因为是连接上去备份的
* 恢复后，集群信息也不存在了

##### （2）恢复

* 在某个节点上恢复备份数据
```shell
etcdctl snapshot restore <back_file> --data-dir=<DATA_DIR>
```

* 启动该节点
```shell
./etcd  \
        --name=<NAME> \ #这个名字也决定了etcd会使用哪个目录
        --listen-client-urls=http://0.0.0.0:2379 \    
        --advertise-client-urls=http://<IP>:2379 \
        --listen-peer-urls=http://0.0.0.0:2380
```

* 修改member的peer address
```shell
etcdctl member update <member-id> --peer-urls=http://<IP>:2380
```

* 添加其他节点的信息
```shell
etcdctl member add ...
```

* 然后重置其他节点，将其他节点加入到该集群中
```shell
#启动节点
./etcd ...
```
