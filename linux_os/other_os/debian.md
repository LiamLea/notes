# debian

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [debian](#debian)
    - [修改网络配置](#修改网络配置)
      - [1.配置文件](#1配置文件)
      - [2.安装一些基础软件](#2安装一些基础软件)
      - [3.修改易用配置](#3修改易用配置)

<!-- /code_chunk_output -->

### 修改网络配置

#### 1.配置文件
* `/etc/network/interfaces`
```shell
#auto 表示当执行ifup -d时，该网卡会被启动（必须要设置，不然网卡不能自动启动）
auto ens33
iface ens33 inet static
  address 192.168.6.114/24
  gateway 192.168.6.254
```

* 重启服务：`systemctl restart networking`

#### 2.安装一些基础软件
```shell
apt-get -y install vim sudo curl gnupg software-properties-common sshpass parted
```

#### 3.修改易用配置

* 修改vim配置

```shell
find / -iname defaults.vim

#修改找出来的文件
vim defaults.vim
#set mouse-=a
```

* 修改bash配置
```shell
$ vim /etc/bash.bashrc

alias ls='ls --color=auto'
alias grep='grep --color=auto'
```
