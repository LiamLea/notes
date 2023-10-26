# upgrade


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [upgrade](#upgrade)
    - [upgrade (以zed为例)](#upgrade-以zed为例)
      - [1.升级策略](#1升级策略)
      - [2.阅读升级要求和限制](#2阅读升级要求和限制)
      - [3.备份](#3备份)
      - [4.升级kolla-ansible](#4升级kolla-ansible)
      - [5.修改配置](#5修改配置)
        - [(1) 配置inventory](#1-配置inventory)
        - [(2) 修改`global.yml`](#2-修改globalyml)
        - [(3) 修改`passwords.yml`](#3-修改passwordsyml)
      - [6.进行升级](#6进行升级)

<!-- /code_chunk_output -->

### upgrade (以zed为例)

[参考](https://docs.openstack.org/kolla-ansible/zed/user/operating-kolla.html#)


#### 1.升级策略
 * 一个版本一个版本的升级
    * 一下子升级多个版本容易出现问题

#### 2.阅读升级要求和限制
* Upgrade procedure¶
* Limitations and Recommendations

#### 3.备份

* 备份kolla-ansible
```shell
cp -r /root/kolla-env /root/kolla-env-bak
```

* 备份配置
```shell
cp -r /etc/kolla /root/kolla-config-bak
```

#### 4.升级kolla-ansible

* 升级ansible
    * 具体升级到哪个版本，参考[quick start](https://docs.openstack.org/kolla-ansible/zed/user/quickstart.html#)
```shell
pip install 'ansible>=4,<6'
```

* 升级kolla-ansible
```shell
$ source /root/kolla-env/bin/activate

#设置一下git代理，不然下载太慢
$ vim ~/.gitconfig
[user]
        email = liweixiliang@gmail.com
        name = liamlea
[http]
        proxy = http://10.10.10.250:8123
[https]
        proxy = http://10.10.10.250:8123

$ pip3 install --upgrade git+https://opendev.org/openstack/kolla-ansible@stable/zed
```

* 安装依赖
```shell
kolla-ansible install-deps
```

#### 5.修改配置

##### (1) 配置inventory

* 备份原先的inventory
```shell
cd /root/kolla-deployment
mv multinode multinode.bak
mv all-in-one all-in-one.bak
cp /root/kolla-env/share/kolla-ansible/ansible/inventory/* ./
```

* 根据旧的修改新的inventory

##### (2) 修改`global.yml`
* 备份旧的创建新的
```shell
mv /etc/kolla/globals.yml /etc/kolla/globals-bak.yml
cp /root/kolla-env/share/kolla-ansible/etc_examples/kolla/globals.yml /etc/kolla/
```

* 根据旧的修改新的配置

##### (3) 修改`passwords.yml`
```shell
cd /tmp/
cp /etc/kolla/passwords.yml passwords.yml.old
cp /root/kolla-env/share/kolla-ansible/etc_examples/kolla/passwords.yml passwords.yml.new
kolla-genpwd -p passwords.yml.new
kolla-mergepwd --old passwords.yml.old --new passwords.yml.new --final /etc/kolla/passwords.yml
```

#### 6.进行升级

```shell
cd /root/kolla-deployment
#可以提前准备镜像：
kolla-ansible -i ./multinode pull

kolla-ansible -i ./multinode prechecks

kolla-ansible -i ./multinode upgrade
```

* 升级后
```shell
#zed版本需要执行这个操作
kolla-ansible deploy --tags keystone

kolla-ansible post-deploy
```