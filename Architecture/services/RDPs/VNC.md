# VNC（Virtual Network Computing）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [VNC（Virtual Network Computing）](#vncvirtual-network-computing)
    - [部署](#部署)
      - [1.安装](#1安装)
      - [2.配置VNC认证信息](#2配置vnc认证信息)
      - [3.启动vncserver](#3启动vncserver)
        - [（1）通过systemd（永久）](#1通过systemd永久)
        - [（2）通过命令行（临时）](#2通过命令行临时)
        - [（3）相关文件放在：`<user_home>/.vnc/`](#3相关文件放在user_homevnc)
      - [4.验证](#4验证)

<!-- /code_chunk_output -->

### 部署

#### 1.安装
```shell
yum install tigervnc-server
```

#### 2.配置VNC认证信息

```shell
su - <user>
vncpasswd
#Would you like to enter a view-only password
#是否需要创建一个只能看的密码，即用这个密码登录，用户只能看，不能操作
```

#### 3.启动vncserver

##### （1）通过systemd（永久）
```shell
#如果有多个以此类推：:1、:2、:3
cp /lib/systemd/system/vncserver@.service  /etc/systemd/system/vncserver@:1.service

vim /etc/systemd/system/vncserver@1.service
#将<USER>修改成上面设置了vncpasswd的账号

systemctl daemon-reload
```

##### （2）通过命令行（临时）
* 启动
```shell
vncserver
```

* 查看启动的vncserver
```shell
vncserver -list
```

* 关闭某个vncserver
```shell
vncserver -kill <X DISPLAY>
```

##### （3）相关文件放在：`<user_home>/.vnc/`

#### 4.验证
* 需要图形化界面
```shell
vncviewer
```
