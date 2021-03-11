# proxy and upstream

[toc]

### 概述

#### 1.相关模块
* ngx_http_proxy_module
* ngx_http_upstream_module
* ngx_stream_proxy_module
* ngx_stream_upstream_module

#### 2.`proxy_pass`能够代理的协议
For HTTP: `proxy_pass http://backend` 或者https
For TCP: `proxy_pass backend:123`

***

### 配置

#### 1.http proxy
* `proxy_pass`
  * 上下文：location, if in location，limit_except
```python
#与stream相似，区别：
#  <PROTOCOL>可以为http、https
#  <UPSTREAM>处可以换成<DOMIAN_OR_IP>:<PORT>
#  <PATH>可以省略
proxy_pass <PROTOCOL>://<UPSTREAM><PATH>;
```

* `proxy_http_version`
  * 上下文：http, server, location
```python
#默认是1.0，有些网站1.0无法访问，所以最好升为1.1
proxy_http_version <1.0 | 1.1>;
```


#### 2.stream proxy

* `proxy_pass`
  * 上下文：server
```python
#可以指定该server中设置的upstream
#也可以指定 <DOMAIN_OR_IP>:<PORT>，如果域名能够解析出多个ip地址，则可以进行轮询转发到这些地址
proxy_pass <UPSTREAM>;
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
  #  fail_timeout=10s，一个探测周期
  #  resolve，如果server用的是域名，当该域名对应的ip变化时，nginx会自动更新
  #  service=<SRV_NAME>，该选项必须和resolve连用，且server必须用的是域名且不用指定端口，因为该配置会去DNS的SRV记录中找到名为<SRV_NAME>的port
  server <DOMAIN_OR_IP>:<PORT>;

  #采用ip hash算法（默认是round-robin，轮询）
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
```python
upstream <NAME> {
  #与stream相似，区别：
  #<PORT>可以省略，省略的话就是80
  server <DOMAIN_OR_IP>:<PORT>;

  #其他配置基本都与stream上下文的一样
}
```
