# docker镜像

[toc]

### 概述

#### 1.image
是一个只读模板
#### 2.container
容器是镜像的可运行实例
#### 3.镜像采用分层构建机制
![](./imgs/docker_image_01.png)
##### 3.1 概述
* 最底层为bootfs
```
用于系统引导的文件系统，包括bootloader和kernel，
容器启动后会被卸载以节省内存
```
* 上面的所有层整体称为rootfs
```
表现为容器的根文件系统，
在docker中rootfs只挂载为"只读"模式，
而后通过"联合挂载"技术额外挂载一个"可写"层
```
* 最上层为"可写"层
```
所有的写操作，只能在这一层实现，
如果删除容器，这个层也会被删除，即数据不会发生变化
```
##### 3.2 分层的优点
某些层可以进行共享，所以减轻了分发的压力（比如，底层是一个centos系统，可以将底层与tomcat层或nginx层联合，提供相应的服务）

#### 4.docker支持的存储驱动
|storage driver|支持的后端文件系统|
|-|-|
|overlay2，overlay|xfs，ext4|
|aufs|xfs，ext4|
|devicemapper|direct-lvm|
|btrfs|btrfs|
|zfs|zfs|
|vfs|所有文件系统|

#### 5.overlay2驱动
##### 5.1 特点
* image的每一层，都会在`/var/lib/docker/overlay2/`目录下生成一个目录
* 启动容器后，会在`/var/lib/docker/overlay2/`目录下生成一个目录（即**可写层**），会将**overlay文件系统** **挂载** 在该目录下的`merged`目录上

##### 5.2`/var/lib/docker/overlay2/<id>/`目录下可能有的内容
|目录或文件|说明|
|-|-|
|diff（目录）|包含该层的内容|
|lower（文件）|记录该层下面的层的信息|
|merged（目录，可写层才有）|将底层和可写层合并后的内容|

#### 6.docker registry
一个registry可以存在多个repository（一般一个软件有一个repository，里面存储该软件不通版本的镜像）
repository可分为"顶层仓库"和"用户仓库"
用户仓库名称格式：用户名/仓库名

#### 7.打包镜像
可以打包多个镜像
打包镜像只指定仓库，会将该仓库所有的镜像都打包
打包镜像指定仓库和标签，只会打包指定镜像
打包镜像指定镜像id，只会打包该镜像，不会包括该镜像的仓库和标签
