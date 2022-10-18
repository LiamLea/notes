# RDP

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [RDP](#rdp)
    - [linux部署xDRP](#linux部署xdrp)
      - [1.安装xRDP](#1安装xrdp)
      - [2.配置认证信息](#2配置认证信息)
      - [3.启动xrdp](#3启动xrdp)
      - [4.验证](#4验证)

<!-- /code_chunk_output -->

### linux部署xDRP

#### 1.安装xRDP
```shell
yum install xrdp
```

#### 2.配置认证信息
无需配置，跟系统账号一样

#### 3.启动xrdp
```shell
systemctl restart xrdp
systemctl status xrdp
```

#### 4.验证
windows运行 -> 远程桌面连接 -> 输入地址
![](./imgs/rdp_01.png)
