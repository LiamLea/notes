# usage

[toc]

### project管理

#### 1.project管理

* 列出所有的projects
```shell
openstack project list
```

#### 2.限额（quota）管理

* 查看project的compute、volume、network这三个方面的限额（quota）
```shell
openstacl quota show <project>
```

* 设置限额（quota）
```shell
openstack quota set openstack quota set --cores 60 --ram 102400 --instances 100 --volumes 150 --snapshots 150 <project>
```

***

### 基本使用

#### 1.镜像相关

* 创建镜像
```shell
openstack image create --progress --disk-format <image_format> --public --file <path>  <image_name>
```

#### 2.port（网卡）相关
![](./imgs/usage_01.png)

```shell
openstack port list

#创建端口（即网卡），
# 必须要设置一个fixed ip（不指定的话根据dhcp随机）
# 如果该网卡需要设置其他ip，则需要 --disable-port-security 或者 allow指定的ip通过（--allowed-address ip-address=<ip>）
openstack port create --network <network_name> --fixed-ip ip-address=<ip> --disable-port-security <port_name>
```

#### 3.volume（磁盘）相关
```shell
#size单位默认为GB
openstack volume create --size <size> <volume_name>
```


#### 4.创建虚拟机模板（即image）

* 首先需要利用image启动一个实例
* 然后创建一个新的volume，挂载到这个实例上
* 然后安装操作系统到这个volume上
* 最后用这个volume生成image（upload to image）（这个过程可能需要一段时间）

#### 5.创建虚拟机
* 必须从image创建虚拟机，所以必须要先制作好image
* 添加网卡
  * 创建port，然后加到这个虚拟机上
* 当不需要持久化时，不需要创建新的volume（即删除instance后，这个volume不删除）
* 添加额外磁盘
  * 创建volume，然后加到这个虚拟机上

```shell
openstack server create /
  --availability-zone <zone-name | default=nova> /
  --image <image> /
  --flavor <flavor> /
  --port <port> / #重复使用可以添加多个port（或者 --network <network> ，自动创建一个port）
  --security-group <security-group | default=default> /
  <instance_name>

#--boot-from-volume <volume_size> 当需要持久化时（<volume_size必须 >= 启动image的size）
```

#### 6.虚拟机的调度：zone和aggregate

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
