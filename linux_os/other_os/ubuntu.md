[toc]

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
