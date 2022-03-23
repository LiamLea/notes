# usage

[toc]

### 基本使用

#### 1.镜像相关

* 创建镜像
```shell
openstack image create --progress --disk-format <image_format> --public --file <path>  <image_name>
```

#### 2.flavor相关
flavor定义了一个instance的规格模板（RAM、Disk、CPU等）

* 创建flavor
```shell
openstack flavor create --vcpus 2 --ram 4096 --disk 20 2c/4g
openstack flavor create --vcpus 4 --ram 8192 --disk 20 4c/8g
openstack flavor create --vcpus 8 --ram 16384 --disk 50 8c/16g
openstack flavor create --vcpus 8 --ram 32768 --disk 50 8c/32g
openstack flavor create --vcpus 16 --ram 32768 --disk 50 16c/32g
openstack flavor create --vcpus 16 --ram 65536 --disk 50 16c/64g
```


#### 3.port（网卡）相关
![](./imgs/usage_01.png)

* 创建端口（即网卡）
```shell
# 必须要设置一个fixed ip（不指定的话根据dhcp随机）
# 如果该网卡需要设置其他ip，则需要 allow指定的ip通过（--allowed-address ip-address=<ip>） 或者 --disable-port-security
openstack port create --network <network_name> --fixed-ip ip-address=<ip> --allowed-address ip-address=<ip>
```

* 给端口添加放行ip
```shell
openstack port set --allowed-address ip-address=10.172.1.13 <port_id>
```

#### 4.volume（磁盘）相关
volume就是块设备
* voluem source：
  * 默认source是blank，就是空的
  * 可以把source设为image或volume或snapshot，这样创建的volume就不是空的，有内容（比如操作系统、文件系统等）
* bootable:
  * 表示可以从这个volume启动
```shell
#size单位默认为GB
openstack volume create --size <size> <volume_name>
```

#### 5.创建虚拟机模板（即image）

* 首先需要利用image启动一个实例
* 然后创建一个新的volume，挂载到这个实例上
* 然后安装操作系统到这个volume上
* 最后用这个volume生成image（upload to image）（这个过程可能需要一段时间）


#### 6.创建虚拟机
* 必须从image创建虚拟机，所以必须要先制作好image
* 添加网卡
  * 指定网络会自动创建网卡（会随着instance删除而删除）
  * 或者创建port，然后加到这个虚拟机上
* 创建新的volume，则可以对这个volume做snapshot和backup等操作
* 添加额外磁盘
  * 创建volume，然后加到这个虚拟机上

```shell
openstack server create /
  --image <image> /
  --flavor <flavor> /
  --nic net-id=<network>,v4-fixed-ip=<ip> / #重复使用可以添加多个port（可以代替的选项：--network <network> 或者 --port <port>）
  --boot-from-volume <volume_size> /
  --security-group <security-group | default=default> /  #重复使用可以添加多个securiy group（取并集）
  --availability-zone <zone-name | default=nova> /
  <instance_name>

# 添加新的磁盘
# --block-device source_type=blank,destination_type=volume,delete_on_termination=true,volume_size=<size>
```

#### 7.虚拟机的调度：zone和aggregate

##### （1）zone
* 通过aggregate的元信息定义，有一个默认的zone
  * 用于对物理主机进行分区（比如按照位置、网络布局等等方式），
  * 一个物理主机只能属于某一个zone，
  * zone对于用户可见，创建instance时，需要指定该instance放置在哪个zone中

* 创建zone
```shell
#创建aggregate，通过aggregate的元信息创建zone
openstack aggregate create --zone <new_zone> <new_aggregate>

#加机器加入到某个aggregate（即加入相应的zone）
openstack aggregate add host <aggregate> <my_host>

#将某个aggregate与其zone取消关联
openstack aggregate unset --property availability_zone <aggregate>
```

##### （2）aggregate
* 将机器分组
  * 一个机器可以属于多个aggregate
  * aggrgate与flavor关联（对用户不可见）

[参考](https://docs.openstack.org/nova/latest/admin/aggregates.html#:~:text=Host%20aggregates%20are%20a%20mechanism,additional%20hardware%20or%20performance%20characteristics.)

#### 8.snapshot和backup

##### （1）instance snapshot
给当前的系统生成镜像（即快照）
然后可以利用这个镜像，继续创建新的instance

##### （2）volume snapshot
对当前volume生成快照
然后可以利用这个volume。创建新的instance

##### （3）volume backup
备份volume，之后可以用这个备份恢复 **没有挂载的** volume

##### （4）总结
* 备份
  * 利用instance snapshot生成快照（即image）
* 恢复
  * 然后利用这个image，重新创建instance（然后网络配置等要一样），即进行了恢复
* 注意：
  * 制作快照时，刚刚写入的数据可能不会被备份，需要等一会

***

### 管理

#### 1.project管理

##### （1）project管理

* 列出所有的projects
```shell
openstack project list
```

##### （2）限额（quota）管理

* 查看project的compute、volume、network这三个方面的限额（quota）
```shell
openstacl quota show <project>
```

* 设置限额（quota）
```shell
openstack quota set --cores 60 --ram 122880 --instances 100 --volumes 150 --snapshots 150 <project>
```

#### 2.server管理
```shell
openstack server list --all-projects
```