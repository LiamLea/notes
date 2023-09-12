# zun


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [zun](#zun)
    - [deploy](#deploy)
      - [1.修改配置](#1修改配置)
      - [2.部署](#2部署)
    - [使用](#使用)
      - [1.上传镜像](#1上传镜像)
      - [2.创建容器](#2创建容器)
      - [3.操作容器](#3操作容器)

<!-- /code_chunk_output -->

### deploy

[参考](https://docs.openstack.org/kolla-ansible/zed/reference/compute/zun-guide.html)

#### 1.修改配置

```shell
vim /etc/kolla/globals.yml
```

```yaml
enable_zun: "yes"
enable_kuryr: "yes"
enable_etcd: "yes"

docker_configure_for_zun: "yes"
containerd_configure_for_zun: "yes"
zun_configure_for_cinder_ceph: "yes"

#Kuryr不支持docker 23之后的版本
docker_apt_package_pin: "5:20.*"
docker_yum_package_pin: "20.*"
```

#### 2.部署
```shell
kolla-ansible -i ./multinode deploy
```

***

### 使用

#### 1.上传镜像
```shell
docker pull cirros
docker save cirros | openstack image create cirros-img --public \
  --container-format docker --disk-format raw
```

#### 2.创建容器

#### 3.操作容器
```shell
openstack appcontainer exec --interactive <container_id> /bin/sh
```