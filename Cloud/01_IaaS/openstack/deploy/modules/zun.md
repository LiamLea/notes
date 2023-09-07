# zun


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [zun](#zun)
    - [deploy](#deploy)
      - [1.修改配置](#1修改配置)
      - [2.部署](#2部署)

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
