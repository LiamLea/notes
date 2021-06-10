# 部署ceph

[toc]

### 概述

### 安装步骤

#### 1.前期准备

##### （1）时间同步（非常重要）

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

##### （4）安装基础组件
* python3
* docker-ce

#### 2.设置相关服务开启自启
```shell
systemctl restart docker
systemctl enable docker
```

#### 3.初始化第一个节点

* 添加镜像源
镜像源中包含ceph相关服务、ceph客户端、cephadm等包

```shell
./cephadm add-repo --release octopus    #这里添加的是octopus发行版的镜像源
```

* 可以安装客户端软件（建议但不是必须）
```shell
#利用镜像源安装cephadm，可以直接使用cephadm命令：cephadm -h
./cephadm install   
 #利用镜像源安装客户端，可以使用ceph命令：ceph -h
./cephadm install ceph-common  
#也可以通过cephadm使用ceph命令，原理是进启动了一个临时容器执行ceph命令
./cephadm shell -- ceph -h
```

* 初始化集群
```shell
cephadm bootstrap --mon-ip <IP>   #--skip-monitoring-stack  不安装prometheus这些组件
```
做了以下的操作：
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
#其实这时候加入的机器还没有启动任何服务，只是能够通过cephadm操作这些机器
ceph orch host add <newhost> --labels _admin  #打上_admin标签，不打也行，主要是为了在其他节点上也能够使用ceph命令，因为ceph需要依赖`/etc/ceph/ceph.conf`和`/etc/ceph/ceph.client.admin.keyring`这两个文件
```

#### 5.创建osd
```shell
#查看发现的磁盘
ceph orch device ls

#将磁盘加入ceph集群：一个磁盘对应一个osd服务
ceph orch apply osd --all-available-devices
#或者指定磁盘
ceph orch daemon add osd <HOST>:<DEVICE_PATH>
```
