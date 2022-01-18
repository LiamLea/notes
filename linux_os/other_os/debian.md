[toc]

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
