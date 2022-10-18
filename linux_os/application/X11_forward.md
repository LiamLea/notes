
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [1.安装xorg-x11-xouath](#1安装xorg-x11-xouath)
- [2.安装](#2安装)
- [3.测试（不要使用sudo）](#3测试不要使用sudo)
- [4.xmanager设置](#4xmanager设置)

<!-- /code_chunk_output -->

#### 1.安装xorg-x11-xouath
用于授权转发 X11 到X server
```shell
yum -y install xorg-x11-xauth
#apt-get install xorg openbox
```
#### 2.安装
转发X11所需要的库
```shell
yum -y install libXtst
#apt-get install libxext-dev
```
**安装完成后，退出ssh，重新登录**

#### 3.测试（不要使用sudo）

* xshell的配置

![](./imgs/x11_01.png)

* 测试

```shell
yum -y install xorg-x11-apps
xclock
```
#### 4.xmanager设置
设置之后，才能用鼠标点击转发过来的图形界面
```
属性 --> 设备 --> 鼠标设置 --> 取消 “同时单机向左...”
```
