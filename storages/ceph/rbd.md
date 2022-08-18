# rbd

[toc]

### 概述

#### 1.基础概念

##### （1）image
一个image就是一个块设备，image会被分成多个同等大小的chunks，每个chunk是一个对象，然后存储在RADOS中
image默认是thin provision（精简置备，安装时可以设为厚置备），即不会立即分配这么多物理存储给image，当使用到时才会分配

#### 2.使用注意事项
* 只支持 `ReadWriteOnce`

***

### 操作

#### 1.创建pool
```shell
ceph osd pool create <pool_name>
rbd pool init <pool_name>
```

#### 2.创建image
```shell
rbd create --size <int> <pool_name>/<image_name>  #--size的单位是M
```

#### 3.管理image

```shell
#查看该pool中的所有image
rbd ls <pool_name>

#查看某个image的信息
rbd info <pool_name>/<image_name>
#查看image的使用情况
rbd disk-usage <pool_name>/<image_name>

#扩容
rbd resize --size <int> <pool_name>/<image_name>  #--size扩容后的大小
#缩容
rbd resize --size <int> --allow-shrink <pool_name>/<image_name>

#删除image
rdb remove <pool_name>/<image_name>
```

#### 4.利用内核使用rbd

##### （1）提前准备
* 需要存在rbd命令（安装ceph-common）
* 需要存在`/etc/ceph/ceph.conf`
  * 生成ceph.conf文件（需要在ceph机器上生成，然后移动到目标机器）
  ```shell
  ceph config generate-minimal-conf
  ```
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

#如果还不能unmap，使用该参数：-o force
```

#### 5.k8s使用rbd

##### （1）下载ceph-csi-rbd chart

##### （2）根据实际情况修改api（这是一个bug）
* 查看csidriver的api
```shell
kubectl explain CSIDriver
#VERSION:  storage.k8s.io/v1beta1
```
* 修改文件
```shell
vim ceph-csi-rbd/templates/csidriver-crd.yaml
#这里的是 apiVersion: storage.k8s.io/betav1，所以需要修改一下
```

##### （3）修改values.yaml

* 集群信息
```yaml
csiConfig:
- clusterID: 20870fc4-c996-11eb-8c25-005056b80961   #这里的id可以随便写，只要在这里是唯一的就行
  monitors:   #monitor的地址
  - "3.1.5.51:6789"
```

* 集群凭证信息
```yaml
secret:
  create: true
  name: csi-rbd-secret
  userID: admin     #用户名
  userKey: AQC0fsFggv9kLRAAM7JN9TusO+1WB9nZUpVmQg==   #用户的key
  encryptionPassphrase: test_passphrase
```

* storage class信息
```yaml
storageClass:
  create: true
  name: csi-rbd-sc
  clusterID: 20870fc4-c996-11eb-8c25-005056b80961 #刚刚在集群信息中设置的id
  pool: rbd-replicated-pool   #当使用的是replicated pool时，这里指定pool的名字
# data_pool: ""     #当使用的是erasure pool时，在这里指定pool的名字
  volumeNamePrefix: "dev-csi-vol-"    #设置创建的image的前缀（最好设置，当有多个环境时，能够区分）
                                      #csi-dev-vol-大概意思：这是dev环境中，通过csi创建的image
```

##### （4）创建pool
storageClass中指定的pool需提前创建好
```shell
ceph osd pool create rbd-replicated-pool
rbd pool init rbd-replicated-pool
```

##### （5）安装

##### （6）其他能力（提供了统一的接口，即k8s屏蔽后端存储的差异）
需要各种后端存储实现CSI接口，这样就能进行统一
* resize（扩容能力）
* snapshot（快照能力，包括恢复快照的能力）
  * 需要安装snap-controller
* attachment（将volume从某台节点上attch/detach的能力）
[参考](https://github.com/ceph/ceph-csi/tree/devel/docs)

##### （7）static pv创建
[参考](https://github.com/ceph/ceph-csi/blob/devel/docs/static-pvc.md)
