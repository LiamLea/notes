# 部署ceph

[toc]

### 概述

#### 1.最小资源
[参考](https://docs.ceph.com/en/pacific/start/hardware-recommendations/)

|组件（per daemon）|CPU|RAM|STORAGE|
|-|-|-|-|
|OSD|1|4G|根据存储需求|
|MON|2|24G|60G|
|MDS|2|2G|忽略|

#### 2.部署建议
* 一个磁盘驱动，只应该跑一个OSD
* OSD应该尽可能分散在多台机器上
* 如果一台机器上跑多个OSD
  * 需要确保操作系统能支持这种情况
  * 总的OSD驱动吞吐量不应该超过网络带宽

***

### 安装步骤

#### 1.安装前准备

##### （1）时间同步（非常重要，需要安装，不然后面会报错）

##### （2）设置主机名（必须要设置好）
* 主机名之后要保证不变，如果变化了
* 主机名必须能够反向解析
  * 所以在hosts文件中，一个ip最好只对应一个host
  * 否则，反向解析成其他主机名
```shell
/etc/hostname
/etc/hosts
```
##### （3）防火墙关闭

##### （4）安装依赖软件
* python3
* docker-ce

#### 2.修改docker配置
* 如果是私有仓库需要配置好证书或者insecure仓库
```shell
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  }
}
```

#### 3.设置相关服务开启自启
```shell
systemctl restart docker
systemctl enable docker
```

#### 4.初始化第一个节点

##### （1）下载cephadm
[参考](https://docs.ceph.com/en/pacific/cephadm/install/#curl-based-installation)

##### （2）安装客户端工具
* 添加镜像源
镜像源中包含ceph相关服务、ceph客户端、cephadm等包

```shell
./cephadm add-repo --release octopus    #这里添加的是octopus发行版的镜像源
```

* 安装客户端软件（建议安装）
```shell
#利用仓库源安装cephadm，可以直接使用cephadm命令：cephadm -h
./cephadm install   
 #利用仓库源安装ceph客户端，可以使用ceph命令：ceph -h
yum -y install ceph-common
#也可以通过cephadm使用ceph命令，原理是进启动了一个临时容器执行ceph命令
cephadm shell -- ceph -h
```

##### （3）提前准备好镜像
```shell
#查看需要的镜像
$ whereis cephadm
$ vim /usr/sbin/cephadm

DEFAULT_IMAGE = 'quay.io/ceph/ceph:v15'
DEFAULT_PROMETHEUS_IMAGE = 'quay.io/prometheus/prometheus:v2.18.1'
...
```

##### （4）初始化集群
```shell
cephadm -v bootstrap \
        --registry-url harbor.test.com --registry-username admin --registry-password Harbor12345 \
        --skip-monitoring-stack \
        --mon-ip <IP>   

#--skip-monitoring-stack  不安装prometheus, grafana, alertmanager, node-exporter
```
做了以下的操作：
* 安装chronyd服务
* 启动monitor和manager服务
* 生成ssh密钥对，公钥：`/etc/ceph/ceph.pub`，并会添加到`/root/.ssh/authorized_keys`中，私钥存放在monitor服务中
* 生成admin账号的密钥：`/etc/ceph/ceph.client.admin.keyring`
* 生成配置文件：`/etc/ceph/ceph.conf`
* 给该机器打上`_admin`标签（有这个标签的机器，都会拷贝`/etc/ceph/ceph.conf`和`/etc/ceph/ceph.client.admin.keyring`这两个文件）

#### 4.将其他节点加入集群
```shell
#将公钥拷贝到需要加入的机器
ssh-copy-id -f -i /etc/ceph/ceph.pub root@<HOST>

#将机器加入集群
#其实加入的机器还没有启动任何服务，只是能够通过cephadm操作这些机器
ceph orch host add <newhost> --labels _admin  #打上_admin标签，不打也行，主要是为了在其他节点上也能够使用ceph命令，因为ceph需要依赖`/etc/ceph/ceph.conf`和`/etc/ceph/ceph.client.admin.keyring`这两个文件
```

#### 5.创建osd
```shell
#查看加入到集群中的磁盘或者通过osd.all-available-devices服务自动发现的磁盘
ceph orch device ls

#方式一：
#部署osd.all-available-devices这个服务后，会自动发现device，并且会自动把这个磁盘加入到集群中
ceph orch apply osd --all-available-devices

#方式二：
#关闭osd.all-available-devices服务
ceph orch apply osd --all-available-devices --unmanaged=true
#当关闭osd.all-available-devices服务后，可以指定磁盘加入到集群
ceph orch daemon add osd <HOST>:<DEVICE_PATH>
```

#### 6.删除某个osd
```shell

ceph osd rm <osd_id>
#查看删除状态（直到PG数量降为0才算真正的删除）
ceph orch osd rm status

#等osd删除之后，执行这个命令清理磁盘，保证磁盘还可以再次使用
ceph orch device zap <hostname> <device_path> --force
```

* 如果未删干净，请执行
```shell
#删除该osd的crush
ceph osd crush remove <osd_id>
#删除该osd的key
ceph psd del <osd_id>
```
