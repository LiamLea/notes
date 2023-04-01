# shadowsocks

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [shadowsocks](#shadowsocks)
    - [使用](#使用)
      - [1.启动shadowsocks client（sock5 proxy）](#1启动shadowsocks-clientsock5-proxy)
      - [2.启动polipo（http proxy -> sock5 proxy）](#2启动polipohttp-proxy---sock5-proxy)
      - [3.验证](#3验证)
    - [其他使用](#其他使用)
      - [1.ssh -> socks5 proxy](#1ssh---socks5-proxy)
        - [(1) 添加ssh配置](#1-添加ssh配置)
      - [2.tcp -> socks5](#2tcp---socks5)
        - [(1) 安装redsocks](#1-安装redsocks)
        - [(2) 设置iptables规则，将tcp流量转发到redsocks](#2-设置iptables规则将tcp流量转发到redsocks)
        - [(3)不能使用http proxy这种应用层转发方式将流量转发给redsocks](#3不能使用http-proxy这种应用层转发方式将流量转发给redsocks)
        - [(4) 测试](#4-测试)
      - [3.udp -> socks5（比较复杂）](#3udp---socks5比较复杂)
      - [4.DNS -> tcp -> socks](#4dns---tcp---socks)

<!-- /code_chunk_output -->

### 使用

[参考](https://github.com/shadowsocks/shadowsocks-libev)
#### 1.启动shadowsocks client（sock5 proxy）

* 创建配置文件
```shell
vim /etc/shadowsocks.json
```
```json
{
  "server":"t.91tianlu.pw",
  "server_port":13863,
  "local_address": "127.0.0.1",
  "local_port":1080,
  "password":"***",
  "timeout":600,
  "method":"aes-256-cfb"
}
```

* 启动客户端
```shell
docker run --network host --restart always -itd -v /etc/shadowsocks.json:/etc/shadowsocks.json shadowsocks/shadowsocks-libev ss-local -c /etc/shadowsocks.json
```

#### 2.启动polipo（http proxy -> sock5 proxy）

* 注意: http proxy时域名也会丢给proxy进行解析
  * 所以不存在DNS污染问题

* 配置polipo
```shell
$ mkdir /etc/polipo
$ vim /etc/polipo/config

proxyAddress = "0.0.0.0"

#因为ss-local只支持sock5转发，需要需要利用polipo
socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5

chunkHighMark = 50331648
objectHighMark = 16384

serverMaxSlots = 64
serverSlots = 16
serverSlots1 = 32
```

* 启动polipo
```shell
docker run --network host --restart always  -itd -v /etc/polipo:/etc/polipo lsiocommunity/polipo polipo -c /etc/polipo/config
```

#### 3.验证

```shell
HTTPS_PROXY="http://127.0.0.1:8123" curl https://google.com
```

***

### 其他使用

#### 1.ssh -> socks5 proxy

##### (1) 添加ssh配置
```shell
vim ~/.ssh/config

#当用ssh协议连接github.com这个域名时进行proxy
#-X 5 指定proxy协议, 支持: 4 (socks4)、5 (socks5, 默认)、connect (https)
#127.0.0.1:1080指定proxy的地址
#指定需要转发的地址，使用变量: %h %p
Host  github.com
  ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
```

* 当无法连接到sock5 proxy时，会报如下错误（请检查sock5 proxy）:
  * Connection closed by UNKNOWN port 65535

#### 2.tcp -> socks5

##### (1) 安装redsocks
* 配置: `/etc/redsocks.conf`
```go
base {
  log_debug = on;
  log_info = on;
  log = "stderr";
  daemon = off;
  user = redsocks;
  group = redsocks;
  redirector = iptables;
}

redsocks {
  //本地监听地址
  local_ip = 0.0.0.0;
  local_port = 12345;

  //socks5地址
  type = socks5;
  ip = 127.0.0.1;
  port = 1080;
}
```

* 启动服务
```shell
docker run --rm --privileged=true  -itd --network host -v /etc/redsocks.conf:/etc/redsocks.conf --entrypoint /usr/sbin/redsocks  ncarlier/redsocks -c /etc/redsocks.conf
```

##### (2) 设置iptables规则，将tcp流量转发到redsocks
* 注意:
  * iptables的output不影响回复流量（即对方发起的，然后需要回复给对方的流量）
```shell
iptables -t nat -N REDSOCKS
#设置哪些不转发
iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 172.17.0.0/24 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
#其余的都转发
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

#使规则生效
iptables -t nat -A OUTPUT -p tcp   -j REDSOCKS
```

##### (3)不能使用http proxy这种应用层转发方式将流量转发给redsocks
因为使用tcp proxy和http proxy转发的内容是不一样的
* 比如需要转发https请求时
  * http proxy转发，是将http的请求内容转发过去
  * 而tcp proxy转发，则将TLS转发过去

##### (4) 测试
```shell
curl https://google.com
```

#### 3.udp -> socks5（比较复杂）

#### 4.DNS -> tcp -> socks