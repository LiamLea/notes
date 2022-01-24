# deploy

[toc]

### 概述

#### 1.节点类型

|节点类型|服务|
|-|-|
|control|基础服务：heat（调度服务），keystone（认证服务），glance（镜像管理服务），cinder（块存储服务），swift（对象存储服务）等|
|compute|nova等|
|network|neutron等|
|storage|ceph等|
|monitoring||

***

### 部署

#### 1.确定相关版本
* kolla-ansible版本
* openstack版本
* 操作系统版本
  * 需要根据openstack版本确定（[参考安装文档](https://docs.openstack.org/kolla-ansible/train/user/support-matrix)）
  * 建议选择ubuntu系统进行安装，因为选择centos时，容易出现一些包的错误
* 每个版本之间都有依赖关系，比如特定kolla-ansible版本只能部署特定的openstack版本，特定的openstack版本只能装在特定的操作系统上
[参考](https://docs.openstack.org/releasenotes/kolla-ansible/)


#### 2.准备openstack相关机器

##### （1）建议选择ubuntu系统
因为选择centos时，容易出现一些包的错误
所有机器执行一下命令
```shell
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer

systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer

systemctl stop apt-daily
systemctl disable apt-daily

systemctl stop apt-daily-upgrade
systemctl disable apt-daily-upgrade

systemctl stop unattended-upgrades.service
systemctl disable unattended-upgrades.service

#关闭防火墙
systemctl stop ufw.service
systemctl disable ufw.service

reboot
```

##### （2）加载kvm模块
所有机器上加载kvm_intel（或者kvm_amd）模块

#### 3.准备好ansible部署机

##### （1）安装ansible所需依赖
```shell
yum -y install python3-devel libffi-devel gcc openssl-devel python3-libselinux

#apt-get -y install python-dev libffi-dev gcc libssl-dev python-selinux python-setuptools python3-venv
```

##### （2）在虚拟环境中安装python包依赖
```shell
python3 -m venv /root/kolla-env
source /root/kolla-env/bin/activate
pip install -U pip
pip install 'ansible<2.10'
pip install 'kolla-ansible == 9.*'
```

##### （3）配置ansible
```shell
$ mkdir /etc/ansible
$ vim /etc/ansible/ansible.cfg

[defaults]
host_key_checking=False
pipelining=True
forks=100
```

##### （4）准备好kolla配置文件
```shell
mkdir -p /etc/kolla
cp -r /root/kolla-env/share/kolla-ansible/etc_examples/kolla/* /etc/kolla

mkdir /root/kolla-deployment
cd /root/kolla-deployment
cp /root/kolla-env/share/kolla-ansible/ansible/inventory/* ./
```

#### 4.配置清单文件（@ansible）
```shell
vim multinode
```
```shell
[control]
control-1 ansible_host=10.172.0.224 ansible_user=lil ansible_password=cangoal ansible_become=true ansible_become_user=root ansible_become_password=cangoal
control-2 ansible_host=10.172.0.225 ansible_user=lil ansible_password=cangoal ansible_become=true ansible_become_user=root ansible_become_password=cangoal

[network:children]
control

[compute]
10.0.0.[13:14] ansible_user=ubuntu ansible_password=foobar ansible_become=true

[monitoring]
10.0.0.10
# This group is for monitoring node.
# Fill it with one of the controllers' IP address or some others.

[storage:children]
compute

[deployment]
localhost       ansible_connection=local become=true
# use localhost and sudo
```
```shell
ansible -i ./multinode all -m ping
```

#### 5.生成密码
```shell
kolla-genpwd

#会在/etc/kolla/passwords.yml文件中生成密码
```

#### 6.配置：`/etc/kolla/globals.yml`
```yaml
#  设置镜像，下面的这些配置决定了镜像的名称：kolla/ubuntu-source-xx:train
kolla_base_distro: "ubuntu"
kolla_install_type: "source"
#  openstack的版本，用默认的，不要修改
#openstack_release: "train"
#openstack_tag: "{{ openstack_release ~ openstack_tag_suffix }}"
#openstack_tag_suffix: "{{ '' if base_distro != 'centos' or ansible_distribution_major_version == '7' else  '-centos8' }}"

#  配置加速镜像源，安装docker时进行配置
docker_custom_config:
  registry-mirrors:
  - http://registry.docker-cn.com

#  指定私有仓库
docker_registry: xx
docker_registry_insecure: yes
docker_registry_username: admin
#  docker_registry_password在passwords.yml文件中设置

kolla_internal_vip_address: "10.172.0.226"

#  openstack集群内部通信的网卡
#   tunnel等网络都会放在上面
network_interface: "eth0"
#  这张网卡用于openstack环境连接公网（网络节点的br-ex会用到该网卡）
#  需要未配置ip，且能够设置为promiscous模式
#  该网卡需要up
neutron_external_interface: "eth1"

enable_ceph: "yes"
enable_cinder: "yes"

#  设置hypervisor类型（默认为：kvm）
#  当openstack安装在虚拟机上时，这里用qemu，用kvm会有问题
nova_compute_virt_type: "kvm"

#glance配置
glance_backend_ceph: "yes"
glance_backend_file: "no"
```

#### 7.使用ceph

注意：ceph osd数量**至少是两个**，否则ceph无法使用，导致相关服务无法使用

* 修改`/etc/kolla/globals.yml`
```yaml
enable_ceph: "yes"
```

* 标记磁盘（@storage-nodes）
这样就会在该磁盘上创建osd
```shell
parted <disk> -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP_BS 1 -1
#为什么这样标记，参考：
# roles/ceph/tasks/bootstrap_osds.yml
# roles/ceph/defaults/main.yml
```

#### 8.进行部署
```shell
kolla-ansible -i ./multinode bootstrap-servers
kolla-ansible -i ./multinode prechecks
#可以提前准备镜像：kolla-ansible -i ./multinode pull
kolla-ansible -i ./multinode deploy
```

#### 9.使用openstack
```shell
#安装openstack客户端
pip install python-openstackclient
#生产admin-openrc.sh文件
kolla-ansible post-deploy
```

#### 10.执行一个demo
```shell
source /etc/kolla/admin-openrc.sh
#会创建example networks、images等待
#需要先修改init-runonce中的相关配置：EXT_NET_CIDR、EXT_NET_RANGE、EXT_NET_GATEWAY
/root/kolla-env/share/kolla-ansible/init-runonce
```

下面的这些操作在init-runonce这个脚本中已经实现了
##### （1）创建供应商网络（即external网络）

![](./imgs/deploy_01.png)

* 创建虚拟网络
```shell
#--provider-physical-network physnet1
#指定这个虚拟网路应用在哪个物理网络，physnet1是在/etc/kolla/neutron-openvswitch-agent/ml2_conf.ini配置文件中定义的：bridge_mappings = physnet1:br-ex
openstack network create --external \
    --provider-physical-network physnet1 \
    --provider-network-type flat \
    public1   #随便取
```

* 创建子网（即创建网段和分配地址，要根据外出网卡的实际情况进行配置）
```shell
openstack subnet create --no-dhcp \
    --network public1 \
    --subnet-range 3.1.5.0/24 --gateway 3.1.5.254 \ #用于外部通信的那张网卡 所在的网段，真实存在的网关
    --allocation-pool start=3.1.5.2,end=3.1.5.11  \ #这个子网能分配的ip地址
     public1-subnet
```

##### （2）创建租户网络

![](./imgs/deploy_02.png)

* 创建虚拟网络
```shell
openstack network create \
    --provider-network-type vxlan \
    demo-net    #随便取
```

* 创建子网（即创建网段和分配地址，网段可以随便设置，只要不冲突就行）
```shell
openstack subnet create \
    --network demo-net \
    --subnet-range 10.0.0.0/24 \    #设置该租户所在网段，该租户创建的虚拟的ip就要从其中分配
    --gateway 10.0.0.1 \    #指定网关地址，之后配置在虚拟路由器上就行
    --dns-nameserver 8.8.8.8 \
    demo-subnet
```

##### （3）创建路由器

![](./imgs/deploy_03.png)

* 创建虚拟路由器
```shell
openstack router create demo-router
```

* 在路由器上创建一个端口，并将该端口加入到某个租户网络
```shell
#在demo-router路由器上创建一个端口，并将该端口加入到demo-subnet这个子网中
#该端口的地址 就是 该子网的gateway地址
openstack router add subnet demo-router demo-subnet
```

* 在路由器上创建一个端口，并将该端口加入到外部子网中
```shell
#在demo-router路由器上创建一个端口，并将该端口加入到外部网络的子网中
#该端口的地址 就是 该子网中可分配地址的随机一个
openstack router set --external-gateway public1 demo-router
```

***

### 添加节点

#### 1.添加controller

```shell
kolla-ansible -i ./multinode bootstrap-servers --limit control
kolla-ansible -i ./multinode pull --limit <new_host>
kolla-ansible -i ./multinode deploy --limit control
```

#### 2.添加compute

```shell
kolla-ansible -i ./multinode bootstrap-servers --limit <new_host>
kolla-ansible -i ./multinode pull --limit <new_host>
kolla-ansible -i ./multinode deploy --limit <new_host>
```
