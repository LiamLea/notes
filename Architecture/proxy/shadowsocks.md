# shadowsocks

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [shadowsocks](#shadowsocks)
    - [使用](#使用)
      - [1.启动shadowsocks client（sock5 proxy）](#1启动shadowsocks-clientsock5-proxy)
      - [2.启动polipo（http proxy -> sock5 proxy）](#2启动polipohttp-proxy-sock5-proxy)
      - [3.验证](#3验证)

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
