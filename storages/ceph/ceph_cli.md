# ceph command

[toc]

### orchestrator module：`ceph orch`

#### 1.获取整个集群状态
```shell
ceph status
```

#### 2.管理host：`ceph orch host`
```shell
#查看主机信息
ceph orch host ls

#给host打标签
ceph orch host label add <HOST> <LABEL>

#添加host
ceph orch host add <HOST> --labels <LABEL>

#删除host
ceph orch host rm <HOST>
```

##### （1）特殊的host标签（最新版本）：
|label|说明|
|-|-|
|_no_schedule|不会调度daemon到这个节点上|
|_no_autotune_memory|不会自动对daemon的内存进行调整|
|_admin|会拷贝`/etc/ceph/ceph.conf`和`/etc/ceph/ceph.client.admin.keyring`这两个文件到这个节点上，从而能够使用ceph等客户端命令控制集群|

#### 3.管理服务：`ceph orch <ACTION> <service_type>`

##### （1）查看服务状态
```shell
ceph orch ls      #查看所有服务的信息

ceph orch ls <service_type>   #查看相关服务的信息
                              #比如：ceph orch ls mon
                              #ceph orch ls
```

##### （2）配置daemon的placement并启动：`ceph orch apply <service_type>`

```shell
#只指定数量，会自动放置到合适的位置
ceph orch apply <service_type> <NUM>
#直接指明了daemonset放置在哪些node上
ceph orch apply <service_type> <HOST1,HOST2,HOST3,...>

#常用选项：
--unmanaged   #表示不自动部署，手动部署：ceph orch daemon add ...
```

#### 4.管理存储设备：`ceph orch device`

```shell
#列出发现的块设备
ceph orch device ls   #--hostname=xx --wide --refresh
```

#### 5.管理daemon：`ceph orch daemon`

##### （1）查看daemon状态
```shell
ceph orch ps
```

##### （2）添加daemon
```shell
ceph orch daemon add <service_type> [<placement>]
```

***

### 配置相关：`ceph config`

```shell
#查看所有的配置
ceph config dump
```

#### 1.monitor服务相关：`ceph config set mon`
```shell
ceph config set mon public_network <CIDR>   #声明monitor的网段，当node在这个网段内，才可以部署ceph-mon服务
```

***

### OSD相关

#### 1.pool相关
```shell
ceph osd dump

ceph osd pool ls detail

ceph osd pool autoscale-status
# SIZE            该pool存储的数据量（不包括副本的数据量）
# TARGET SIZE     期望该pool存储的数据量（不包括副本的数据量）
# RATE            是一个乘数（副本的数量），消耗真正的存储空间 = SIZE * RATE
# RAW CAPACITY    真正的存储空间大小（但是实际能够存储的数据量达不到，因为存在副本数据）
# RATIO           存储空间的使用率
```

#### 2.pg相关
```shell
ceph pg ls
```
