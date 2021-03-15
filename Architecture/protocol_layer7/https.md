# https

[toc]

### 概述

#### 1.SNI
sever name indication
* 用于在TLS协商时，标识访问的主机名，
  * 服务端会根据这个主机名，选择相应的virtual server，从而可以使用不同的配置（比如不同的证书）
  * SNI要和证书里的CN符合（即访问的主机名在证书的CN列表中），不然客户端会认为不安全

![](./imgs/https_01.png)
