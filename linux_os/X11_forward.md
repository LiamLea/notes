#### 1.安装xorg-x11-xouath
用于授权转发 X11 到X server
```shell
yum -y install xorg-x11-xauth
```
#### 2.安装
转发X11所需要的库
```shell
yum -y install libXtst
```
**安装完成后，退出ssh，重新登录**
#### 3.测试
```shell
yum -y install xorg-x11-apps
xclock
```
#### 4.xmanager设置
设置之后，才能用鼠标点击转发过来的图形界面
```
属性 --> 设备 --> 鼠标设置 --> 取消 “同时单机向左...”
```
