# proxy and upstream

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [proxy and upstream](#proxy-and-upstream)
    - [概述](#概述)
      - [1.相关模块](#1相关模块)
      - [2.`proxy_pass`能够代理的协议](#2proxy_pass能够代理的协议)
      - [3.proxy基本过程](#3proxy基本过程)
      - [4.unsuccessful attempt（失败的请求）](#4unsuccessful-attempt失败的请求)
      - [5.ip transparency](#5ip-transparency)
    - [配置](#配置)
      - [1.http proxy](#1http-proxy)
      - [2.stream proxy](#2stream-proxy)
      - [3.转发websocket请求的配置](#3转发websocket请求的配置)
      - [4.在stream上下文中的upstream](#4在stream上下文中的upstream)
      - [5.在http上下文中的upstream](#5在http上下文中的upstream)
      - [6.http反向代理 需要注意 解码问题](#6http反向代理-需要注意-解码问题)
        - [（1）`proxy_pass`后面不加任何url](#1proxy_pass后面不加任何url)
        - [（2）利用`$request_uri`这个变量](#2利用request_uri这个变量)
        - [（3）在ingress中的解决方案](#3在ingress中的解决方案)

<!-- /code_chunk_output -->

### 概述

#### 1.相关模块
* ngx_http_proxy_module
* ngx_http_upstream_module
* ngx_stream_proxy_module
* ngx_stream_upstream_module

#### 2.`proxy_pass`能够代理的协议
For HTTP: `proxy_pass http://backend` 或者https
For TCP: `proxy_pass backend:123`

#### 3.proxy基本过程
* 根据负载策略，将将流量负载到后端的server
* 如果负载到某个server，失败（即unsuccessful attempt）
  * 则继续将请求发送到其他server，如果尝试过所有server，仍然失败，则返回最新的失败的结果
  * 如果有一个成功，则返回成功的结果

#### 4.unsuccessful attempt（失败的请求）
* http_500, http_502, http_503, http_504, and http_429
* http_403 and http_404不认为是失败的请求

#### 5.ip transparency
[参考](https://www.nginx.com/blog/ip-transparency-direct-server-return-nginx-plus-transparent-proxy/)
[proxy protocol方式](https://docs.nginx.com/nginx/admin-guide/load-balancer/using-proxy-protocol/?_ga=2.229775452.1571476713.1652681920-1927445333.1652432980)

***

### 配置

#### 1.http proxy
* `proxy_pass`
  * 上下文：location, if in location，limit_except

```python
#  <PROTOCOL>可以为http、https
#  如果用主机名且能够解析出多个ip地址，则可以进行轮询转发到这些地址
proxy_pass <PROTOCOL>://<UPSTREAM_or_HOST>[PATH]

#传递的url:
#  当没有[PATH]，则整个url都会传递过去
#  当有[PATH]，则与location匹配的部分会被[PATH]替换，然后传递过去
#  当location中使用正则时，proxy_pass后面就不能设置[PATH]

#当proxy_pass到https协议时，需要设置证书，见下面的配置
```

* `proxy_http_version`
  * 上下文：http, server, location
```python
#默认是1.0，有些网站1.0无法访问，所以最好升为1.1
proxy_http_version <1.0 | 1.1>;
```

* `proxy_pass`到https协议     
```shell
#默认不检查证书
proxy_ssl_verify <on | off | default=off>;


#当检查证书时
#检查深度
#第一层，检查该证书的签署证书（看该是否在信任列表中）
#第二层，检查签署证书的签署证书（看该是否在信任列表中）
#依次类推
proxy_ssl_verify_depth 0;   

#当用的自签证书时，指定相应的ca文件
proxy_ssl_trusted_certificate <file>
```

#### 2.stream proxy

* `proxy_pass`
  * 上下文：server
```python
#如果用主机名且能够解析出多个ip地址，则可以进行轮询转发到这些地址
proxy_pass <UPSTREAM_or_HOST>;
```

#### 3.转发websocket请求的配置
```shell
location /chat/ {
    proxy_pass http://backend;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

* 更通用的设置
这样既能转发http，也能转发websocket
```shell
http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    server {
        ...

        location /chat/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }
    }
}
```

#### 4.在stream上下文中的upstream
```python
upstream <NAME> {
  #地址和端口都不能省略
  #可配置参数：
  #  weight=<NUM>，权重（当为轮询方式时有用）
  #  max_conns=<NUM>，限制后端服务器的并发连接数
  #  max_fails=1 ，在一个探测周期内，如果失败次数达到了，则标记该服务器不可用，并等待下一个周期再检测（如果为0，标记该服务器一直可用）
  #  fail_timeout=10s，一个探测周期（不是主动的健康检查，而是当有请求来，进行负载时）
  #  resolve，如果server用的是域名，当该域名对应的ip变化时，nginx会自动更新
  #  service=<SRV_NAME>，该选项必须和resolve连用，且server必须用的是域名且不用指定端口，因为该配置会去DNS的SRV记录中找到名为<SRV_NAME>的port
  server <DOMAIN_OR_IP>:<PORT>;

  #采用ip hash算法（默认是round-robin，轮询，不需要指定）
  ip_hash;

  #利用指定的key进行hash
  hash <KEY>;

  # 缓存 与后端服务器的连接数
  keepalive <NUM>;
  #当该连接处理的请求数超过了这个值，就会关闭该连接
  keepalive_requests <NUM>;
  #当该连接在该时间段内一直空闲，就会关闭该连接
  keepalive_timeout <TIME,60s>;
}
```

#### 5.在http上下文中的upstream

* **注意**
  * 这里的`<NAME>`，影响http的头: `Host: <NAME>`
  
```python
upstream <NAME> {
  #与stream相似，区别：
  #<PORT>可以省略，省略的话就是80
  server <DOMAIN_OR_IP>:<PORT>;

  #其他配置基本都与stream上下文的一样
}
```

#### 6.http反向代理 需要注意 解码问题
比如url中有`%`，**在location匹配前**会被解码成具体的字符，rewrite replcement默认使用的url就是解码后的url（如果需要原url，就需要用`$request_uri`这个变量

解决方案：

##### （1）`proxy_pass`后面不加任何url
这样就不会发生url替换，即使在location匹配前发生了解码，然而传送到upstream的是未解码的内容
```shell
proxy_pass http://backend;
```

##### （2）利用`$request_uri`这个变量
```shell
rewrite ^ $request_uri;

#进行自己想要的转换
#(?i) starts case-insensitive mode
#比如：rewrite "(?i)/(argocd.*)" /$1 break;

proxy_pass http://backend$uri;
```


```shell
if ($request_uri ~ "^/argocd.*") {
  rewrite ^ $request_uri;
  rewrite "(?i)/(argocd.*)" /$1 break;
  proxy_pass http://backend$uri;
  break;
}

#或者在if的时候直接匹配（这两种方法本质是一样的）

if ($request_uri ~ "^(/argocd.*)") {
  proxy_pass http://backend$1;
  break;
}
```


##### （3）在ingress中的解决方案
明确指定url进行替换，比如：
```yaml
...
  nginx.ingress.kubernetes.io/rewrite-target: /argocd/api/v1/repositories/git%40$1%3A$2%2F$3
...
- path: /argocd/api/v1/repositories/git@(.*?):(.*?)/(.*)
```
