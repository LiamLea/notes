# nginx

[toc]

### 概述

#### 1.proxy protocol
该协议，允许当nginx作为负载均衡时，可以传递客户端的原始信息
开启proxy protocol
```shell
http {
    #...
    server {
        listen 80   proxy_protocol;
        listen 443  ssl proxy_protocol;
        #...
    }
}
```

#### 2.`proxy_pass`能够代理的协议
For HTTP: `proxy_pass http://backend;` 或者https
For TCP: `proxy_pass backend:123`

#### 3.内置变量
[内置变量](https://nginx.org/en/docs/varindex.html)

##### （1）`http_<header_name>`
获取某个请求头的值，`<header_name>`表示请求头的字段名（小写，短划线用下划线代替）
比如：有一个header，`Aaa-b: 111`，则`$http_aaa_b`的值就是111
```shell
$http_host          #http请求的Header中的Host字段（包括port）
```

##### （2）`cookie_<cookie_name>`
获取某个cookie的值，<cookie_name>为cookie的名字

##### （3）其他常用变量
```shell
$host               #Header中的Host字段（但不包括port信息）
$proxy_host         #当执行proxy_pass语句后，会添加proxy-host头在http请求中，然后将新的请求转发到后端
```

***

### 配置文件的结构

#### 1.顶层context（上下文）

##### （1）stream
用于处理 **TCP和UDP流量**
```shell
stream {
  ...
}
```

##### （2）http
用于处理 **HTTP流量**
```shell
http {
  ...
}
```

##### （3）events
常规连接处理
```shell
events {
  #一个worker process能够同时打开的最大连接数
  worker_connections <number>;
}
```

##### （4）mail
用于处理mail流量

#### 2.继承
child context会继承parent context的内容，但是可以进行覆盖
