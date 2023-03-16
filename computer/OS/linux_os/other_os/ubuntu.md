# ubuntu

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ubuntu](#ubuntu)
    - [修改网络配置](#修改网络配置)
      - [1.配置文件](#1配置文件)
      - [2.修改DNS](#2修改dns)
    - [软件相关](#软件相关)
      - [1.下载软件包即其依赖](#1下载软件包即其依赖)
      - [2.安装有依赖关系的包](#2安装有依赖关系的包)
      - [3.关闭自动升级](#3关闭自动升级)
      - [4.查看 某个文件 属于 哪个已安装软件](#4查看-某个文件-属于-哪个已安装软件)
      - [5.查找 哪些软件 提供 需要的文件](#5查找-哪些软件-提供-需要的文件)
    - [使用相关](#使用相关)
      - [1.创建桌面图标](#1创建桌面图标)
        - [(1) 编辑`<xx>.desktop`文件](#1-编辑xxdesktop文件)
      - [2.设置 某个文件类型 的 默认打开程序](#2设置-某个文件类型-的-默认打开程序)
        - [(1) 修改配置文件](#1-修改配置文件)
      - [3.相关工具推荐](#3相关工具推荐)
      - [4.shortcut冲突:](#4shortcut冲突)
        - [(1) ctl+shift+f: 这个是中文键盘切换简体和繁体的快捷键](#1-ctlshiftf-这个是中文键盘切换简体和繁体的快捷键)

<!-- /code_chunk_output -->

### 修改网络配置
[参考](https://wiki.debian.org/NetworkConfiguration#Starting_and_Stopping_Interfaces)
#### 1.配置文件
* 旧的版本
  * `/etc/network/interfaces`
* 新的版本
  * `/etc/netplan/`
  * 使修改生效：`netplan apply`

#### 2.修改DNS
由于ubuntu中`/etc/resolv.conf`是一个软链接
* 永久修改配置
```shell
ln -fs /run/systemd/resolve/resolv.conf /etc/resolv.conf
vim /etc/systemd/resolv.conf
systemctl restart systemd-resolved
```

***

### 软件相关

#### 1.下载软件包即其依赖
```shell
apt-get install <PACKAGE> --download-only

#下载的软件包在 /var/cache/apt/archives/ 目录下
```

#### 2.安装有依赖关系的包
```shell
#在包的目录下执行

dpkg -i *
```

#### 3.关闭自动升级
```shell
#需要按照下面的顺序停止
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer

systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer

systemctl stop apt-daily
systemctl disable apt-daily

systemctl stop apt-daily-upgrade
systemctl disable apt-daily-upgrade

systemctl stop unattended-upgrades.service
systemctl disable unattended-upgrades.service
reboot
```

#### 4.查看 某个文件 属于 哪个已安装软件
```shell
dpkg -S <filePath_or_keyword>
```

#### 5.查找 哪些软件 提供 需要的文件
[查找网站](https://packages.ubuntu.com/)

***

### 使用相关

#### 1.创建桌面图标

##### (1) 编辑`<xx>.desktop`文件
* 存放位置: 
  * `/usr/share/applications/`
  * `~/Desktop/`

* 文件内容
```shell
[Desktop Entry]
Type=Application
Encoding=UTF-8

Name=shadowsocks-qt5
Version=V3.0.1
Comment=shadowsocks qt application
#可以属于多个类型，使用分号隔开: TextEditor;Development;IDE;
Categories=Internet

#图标文件
Icon=/home/liamlea/Downloads/shadowsocks.png
#执行文件（需要使用该应用打开其他文件，执行命令后需要加上相关参数, %F表示文件名的变量）
# 比如: pycharm的 Exec=/opt/pycharm-2021.3.3/bin/pycharm.sh %F
Exec=/usr/local/sbin/Shadowsocks-Qt5-3.0.1-x86_64.AppImage
Terminal=false
StartupNotify=true
```

#### 2.设置 某个文件类型 的 默认打开程序

##### (1) 修改配置文件
* 优先级由高到低: 
  * `~/.config/gnome-mimeapps.list`
  * `~/.config/mimeapps.list`
  * `/usr/share/applications/gnome-mimeapps.list`
  * `/usr/share/applications/mimeapps.list`

```shell
[Default Applications]
#<file_type>=<default_app>
text/x-python=PyCharm.desktop
```

#### 3.相关工具推荐

|工具类型|工具|
|-|-|
|screen shot|flameshot|

#### 4.shortcut冲突: 

##### (1) ctl+shift+f: 这个是中文键盘切换简体和繁体的快捷键