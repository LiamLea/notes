# usage

[toc]

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
#必须要设置一个fixed ip（不指定的话根据dhcp随机）
#如果该网卡需要设置其他ip，则需要disable port security或者allow指定的ip通过
openstack port create --network <network_name> --disable-port-security
```

#### 3.volume（磁盘）相关
```shell
#size单位默认为GB
openstack volume create --size <size> <volume_name>
```


#### 4.创建虚拟机模板（即image）

* 首先需要利用image启动一个实例
  * 选择不创建新的volume

* 然后创建一个新的volume，挂载到这个实例上
* 然后安装操作系统到这个volume上
* 最后用这个volume生成image（upload to image）（这个过程可能需要一段时间）

#### 5.创建虚拟机
* 必须从image创建虚拟机，所以必须要先制作好image
* 添加网卡
  * 创建port，然后加到这个虚拟机上
* 添加磁盘
  * 创建volume，然后加到这个虚拟机上
