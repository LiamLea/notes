# 部署ceph
### 概述
### 安装步骤
#### 1.前期准备
* 安装docker
* 安装python3
* 修改hostname和/etc/hosts

#### 1.第一个节点安装cephadm和客户端软件
```shell
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
chmod +x cephadm
./cephadm add-repo --release octopus
./cephadm install

cephadm add-repo --release octopus
cephadm install ceph-common
```

#### 2.初始化第一个节点
```shell
mkdir -p /etc/ceph
cephadm bootstrap --mon-ip <IP>
```
#### 3.将其他节点加入到其中
```shell
ssh-copy-id -f -i /etc/ceph/ceph.pub root@<new-host>
```
```shell
ceph orch host add <newhost>
```

#### 4.设置monitor节点
```shell
ceph orch apply mon <NUMBER>
ceph orch apply mon <host1,host2,host3,...>
ceph orch host label add <HOST> mon
ceph orch apply mon label:mon
```

#### 5.创建osd
```shell
ceph orch daemon add osd <HOST>:<DEVICE_PATH>

#ceph orch device ls
#ceph status
```
