# rbd

[toc]

### 概述

#### 1.基础概念

##### （1）image
一个image就是一个块设备，image会被分成多个同等大小的chunks，每个chunk是一个对象，然后存储在RADOS中
image是thin provision（精简置备），即不会立即分配这么多物理存储给image，当使用到时才会分配

***

### 操作

#### 1.创建image
```shell
ceph osd pool create <pool_name>
rbd pool init <pool_name>
rbd create --size <int> <pool_name>/<image_name>  #--size的单位是M
```

#### 2.管理image

```shell
#查看该pool中的所有image
rbd ls <pool_name>

#查看某个image的信息
rbd info <pool_name>/<image_name>

#扩容
rbd resize --size <int> <pool_name>/<image_name>  #--size扩容后的大小
#缩容
rbd resize --size <int> --allow-shrink <pool_name>/<image_name>

#删除image
rdb remove <pool_name>/<image_name>
```

#### 3.利用内核使用rbd

##### （1）提前准备
* 需要存在rbd命令（安装ceph-common）
* 需要存在`/etc/ceph/ceph.conf`
* 需要一个用户（`rbd ... --id xx --keyring xx`，或者直接拷贝`/etc/ceph/ceph.client.admin.keyring`文件，就不需要指定用户了）

##### （2）加载image
```shell
rbd device map <pool_name>/<image_name>

#如果rbd的某些功能与kernel不匹配，需要按照提示disable这些功能
```

##### （3）查看加载的image（即块设备）
```shell
rbd device ls
lsblk
```

##### （4）卸载image（即块设备）
```shell
#如果mount了，需要先unmount
rbd device unmap /dev/rbd0
```
