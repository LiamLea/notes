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
For HTTP: `proxy_pass http://backend;`
For TCP: `proxy_pass backend:123`

***

### 配置文件的结构

#### 1.顶层contexts
contexts就是指令组，即用`<DIRECTIVE>{...}`括起来的指定的集合

##### （1）stream
TCP and UDP traffic
```shell
stream {
  ...
}
```

##### （2）http
HTTP traffic
```shell
http {
  ...
}
```

##### （3）events
常规连接处理

##### （4）mail
Mail traffic

#### 2.子层结构

##### （1）virtual servers
在每个流量处理contexts中，都包含一个或多个server context，用于控制请求处理
```shell
server {
  ...
}
```

#### 3.继承
child context会继承parent context的内容，但是可以进行覆盖

***

### 配置
#### 1.请求转发相关配置
##### （1）`proxy_set_header`    
用于修改或者添加发往后端服务器的请求头
```shell
proxy_set_header Host $http_host;

#如果不设置，转发的请求中的Host字段就是原http请求中的Host字段
#设置后 后端服务器可以通过 Host 头得知用户访问的真正的域名，能够实现动态拼接url
```

#### 2.常用变量
```shell
$http_host          #原http请求的Header中的Host字段（包括ip和port
$host               #原http请求的Header中的Host字段（但不包括port信息）
$proxy_host         #当前代理主机的Host信息（包括ip和port）
$proxy_port         #当前代理主机的port信息
```
