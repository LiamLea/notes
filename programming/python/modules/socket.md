# socket模块

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [socket模块](#socket模块)
    - [基础概念](#基础概念)
      - [1.socket](#1socket)
      - [2.协议族（family）](#2协议族family)
      - [3.套接字类型（type）](#3套接字类型type)
      - [4.某个协议（protocol）](#4某个协议protocol)
    - [socket函数](#socket函数)
      - [1.创建socket](#1创建socket)
      - [2.服务端套接字](#2服务端套接字)
      - [3.客户端套接字](#3客户端套接字)
    - [相关函数](#相关函数)

<!-- /code_chunk_output -->

### 基础概念
#### 1.socket
socket是一种数据结构（**文件**），用于存储通信需要的重要信息
#### 2.协议族（family）
* AF_INET    IPv4
* AF_INET6   IPv6
* AF_UNIX   UNIX域协议
* AF_ROUTE   路由套接字
* AF_KEY     密钥套接字
#### 3.套接字类型（type）
* SOCK_STREAM（流式套接字）提供面向连接的服务
* SOCK_DGRAM（数据报式套接字） 提供无连接的服务
* SOCK_SEQPACKET（有序分组套接字）
* SOCK_RAW（原始套接字）
#### 4.某个协议（protocol）
若为0，根据前面两个设置的参数自动匹配，有的无法匹配要指明
* IPPROTO_TCP
* IPPROTO_UDP
* IPPROTO_SCTP
***
### socket函数
#### 1.创建socket
```python
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#protocol默认为0
#返回一个套接字
```
* 返回一个套接字
```shell
<socket.socket
fd=3,                                   #文件描述符，即能通过这个文件描述符找到该套接字
family=AddressFamily.AF_INET,           #协议族
type=SocketKind.SOCK_STREAM, proto=0,   #套接字类型
laddr=('0.0.0.0', 0)>                   #绑定的地址，默认是本机所有地址和随机端口
```
#### 2.服务端套接字
```python
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("0.0.0.0", 80))
sock.listen()
while True:
    conn, client_addr = socket.accept
```
#### 3.客户端套接字
```python
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("192.168.1.1", 80))
sock.getsockname()          #获取本地地址
```

***

### 相关函数
```python
import socket

socket.gethostname()      #获取本地的主机名

socket.gethostbyname("主机名")       #只返回一个地址
socket.gethostbyname_ex("主机名")    #返回：[name, aliaslist, addresslist]
```
