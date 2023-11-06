# ubuntu

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ubuntu](#ubuntu)
    - [修改网络配置](#修改网络配置)
      - [1.配置文件](#1配置文件)
      - [2.修改DNS](#2修改dns)
      - [3.使用systemd-resolved管理DNS解析](#3使用systemd-resolved管理dns解析)
        - [(1) 运行systemd-resolved (相当于在本地启动一个DNS服务)](#1-运行systemd-resolved-相当于在本地启动一个dns服务)
        - [(2) 关闭interface上的DNS (使用NetworkManager时这样关闭)](#2-关闭interface上的dns-使用networkmanager时这样关闭)
        - [(3) DNS解析指向该本地服务](#3-dns解析指向该本地服务)
        - [(4) 管理DNS命令: resolvectl](#4-管理dns命令-resolvectl)
    - [软件相关](#软件相关)
      - [1.下载软件包即其依赖](#1下载软件包即其依赖)
      - [2.安装有依赖关系的包](#2安装有依赖关系的包)
      - [3.关闭自动升级](#3关闭自动升级)
      - [4.查看 某个文件 属于 哪个已安装软件](#4查看-某个文件-属于-哪个已安装软件)
      - [5.查找 哪些软件 提供 需要的文件](#5查找-哪些软件-提供-需要的文件)
      - [6.列出一个软件包的所有版本](#6列出一个软件包的所有版本)
    - [使用相关](#使用相关)
      - [1.创建桌面图标](#1创建桌面图标)
        - [(1) 编辑`<xx>.desktop`文件](#1-编辑xxdesktop文件)
      - [2.设置 某个文件类型 的 默认打开程序](#2设置-某个文件类型-的-默认打开程序)
        - [(1) 修改配置文件](#1-修改配置文件)
      - [3.相关工具推荐](#3相关工具推荐)
      - [4.shortcut冲突:](#4shortcut冲突)
        - [(1) ctl+shift+f: 这个是中文键盘切换简体和繁体的快捷键](#1-ctlshiftf-这个是中文键盘切换简体和繁体的快捷键)
      - [5.安装图形化界面](#5安装图形化界面)
        - [(1) 安装](#1-安装)
        - [(2) 设置分辨率](#2-设置分辨率)
        - [(3) 设置网卡被NetworkManager管控](#3-设置网卡被networkmanager管控)
        - [(4) 命令行开启screen sharing](#4-命令行开启screen-sharing)
      - [6.设置suspend](#6设置suspend)
        - [(1) lock、suspend和hibernate区别](#1-lock-suspend和hibernate区别)
        - [(2) 设置close lid 不 suspend](#2-设置close-lid-不-suspend)
        - [(3) 关闭自动suspend](#3-关闭自动suspend)
        - [(4) 主动suspend](#4-主动suspend)

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

#### 3.使用systemd-resolved管理DNS解析

[参考](https://man.archlinux.org/man/resolved.conf.5)

##### (1) 运行systemd-resolved (相当于在本地启动一个DNS服务)
* 配置文件: `/etc/systemd/resolved.conf`
  * 指定upstream DNS server
```shell
[Resolve]
#注意: 如果interface上设置了DNS，会优先使用interface上的
#会查询第一个，如果第一个超时，才会查下面的（跟/etc/resolv.conf规则一样）
DNS=8.8.8.8 114.114.114.114 8.8.4.4
#当未获取到DNS server，会用这里的
FallbackDNS=1.1.1.1
#使用DNS over TLS协议
DNSOverTLS=true

# 会读取/etc/hosts作为dns server的条目
#ReadEtcHosts=yes

# 监听其他端口，默认只监听127.0.0.53
#DNSStubListenerExtra=0.0.0.0
```

* 重启systemd-resolved

* 查看生效结果
```shell
cat /run/systemd/resolve/resolv.conf
```

##### (2) 关闭interface上的DNS (使用NetworkManager时这样关闭)
* interface上设置DNS时

```shell
#下面生效的DNS是172.20.10.1
$ resolvectl status 
Global
           Protocols: -LLMNR -mDNS +DNSOverTLS DNSSEC=no/unsupported
    resolv.conf mode: stub
  Current DNS Server: 9.9.9.9
         DNS Servers: 8.8.8.8 9.9.9.9 8.8.4.4
Fallback DNS Servers: 1.1.1.1

Link 2 (wlp0s20f3)
    Current Scopes: DNS
         Protocols: +DefaultRoute +LLMNR -mDNS +DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 172.20.10.1
       DNS Servers: 172.20.10.1 fe80::855:4e1c:5315:fb1b%22099

```

* 关闭interface上的DNS
```shell
$ vim /etc/NetworkManager/conf.d/dns.conf

[main]
dns=none
systemd-resolved=false

$ systemctl restart NetworkManager
```

* 查看是否设置成功
```shell
$ resolvectl status 
Global
           Protocols: -LLMNR -mDNS +DNSOverTLS DNSSEC=no/unsupported
    resolv.conf mode: stub
  Current DNS Server: 9.9.9.9
         DNS Servers: 8.8.8.8 9.9.9.9 8.8.4.4
Fallback DNS Servers: 1.1.1.1

Link 2 (wlp0s20f3)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS +DNSOverTLS DNSSEC=no/unsupported
```

##### (3) DNS解析指向该本地服务
```shell
$ cat /etc/resolv.conf

nameserver 127.0.0.53
options edns0 trust-ad
search .
```

##### (4) 管理DNS命令: resolvectl

* 查看DNS状态
```shell
resolvectl status 
```

* 调整systemd-resolved日志级别
```shell
#info等
resolvectl log-level debug 
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

sudo dpkg -i *

#这个命令会自动安装依赖（需要外网）
sudo apt-get -f install
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

#### 6.列出一个软件包的所有版本
```shell
apt-cache  madison <package>
```

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

#### 5.安装图形化界面

##### (1) 安装
```shell
#安装图形化界面
apt-get install gnome-desktop

#安装图形化需要的软件
apt-get install gnome-software
```

##### (2) 设置分辨率
* 当分辨率选项较少时

```shell
$ vim /etc/default/grub

#GRUB_GFXMODE=640x480
GRUB_GFXMODE=1920x1080 

$ update-grub
$ reboot
```

##### (3) 设置网卡被NetworkManager管控

```shell
$ vim /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf

#添加这一项: except:type:ethernet

$ vim /etc/NetworkManager/NetworkManager.conf

...
[ifupdown]
managed=true
...

$ systemctl restart NetworkManager
```

##### (4) 命令行开启screen sharing

```shell
$ vim /etc/gdm3/custom.conf

[daemon]
AutomaticLoginEnable=true
AutomaticLogin=<username>

#获取连接
$ nmcli con
NAME                UUID                                  TYPE      DEVICE 
Wired connection 1  00c60637-2077-3fc7-9de7-6610f1bf960a  ethernet  ens3 

# dconf的配置存在~/.config/dconf/user中

# 查看是否绑定到先有的网络连接上
# 所以网卡重新创建后（比如openstack从镜像创建虚拟机），这里需要重新配置
$ dconf read /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections
$ dconf write /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections "['00c60637-2077-3fc7-9de7-6610f1bf960a  ethernet']"

#设置密码
$ PASSWORD="passwordgoeshere"
$ dconf write /org/gnome/desktop/remote-access/vnc-password \"\'$(echo -n $PASSWORD | base64)\'\"

#其他设置
$ dconf write /org/gnome/desktop/remote-access/authentication-methods "['vnc']"
$ dconf write /org/gnome/desktop/remote-access/prompt-enabled false
```

* 网卡重新生成后
  * 注意要在相关用户下执行这个命令
```shell
$ nmcli con
NAME                UUID                                  TYPE      DEVICE 
Wired connection 1  00c60637-2077-3fc7-9de7-6610f1bf960a  ethernet  ens3 

$ dconf write /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections "['00c60637-2077-3fc7-9de7-6610f1bf960a']"
```

#### 6.设置suspend

##### (1) lock、suspend和hibernate区别

* lock只是锁屏
* suspend，系统暂停运行，状态存储在内存中
* hibernate，系统暂停运行，状态存储在磁盘中，即使电脑没电了，下次启动也能恢复状态

##### (2) 设置close lid 不 suspend

```shell
$ vim /etc/systemd/logind.conf

[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore

$ systemctl restart systemd-logind.service
```

##### (3) 关闭自动suspend
Settings -> Power

* 默认是在inactive一段时间后，自动进入suspend
  * inactive就是没有移动鼠标和打击键盘

##### (4) 主动suspend

```shell
#可以设置快捷键
systemctl suspend
```