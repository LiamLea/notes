
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [网络相关参数](#网络相关参数)
  - [1.查看最大能够建立的TCP连接数（本地是客户端）](#1查看最大能够建立的tcp连接数本地是客户端)

<!-- /code_chunk_output -->

### 网络相关参数

#### 1.查看最大能够建立的TCP连接数（本地是客户端）
```shell
cat /proc/sys/net/ipv4/ip_local_port_range
#本地用于远程连接的端口范围，一个连接一个端口
#注意这里面既包含了ESTAB状态的，也包含了TIME-WAIT状态的
# 可以通过命令查看这两种状态的数量：ss -tuanp state connected

cat /proc/sys/net/ipv4/tcp_fin_timeout
#设置TIME-WAIT状态持续的时间（秒）
```
