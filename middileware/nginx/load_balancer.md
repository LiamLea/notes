# load balancer

[toc]

### 概述

### 配置
#### 1.virtual servers
在每个 流量处理上下文 中，都包含一个或多个server context，用于设置请求处理
```python
server {...}
```

##### （1）在stream上下文中的server
```python
server {

  #<ADDRESS>可以省略，<PORT>可以写一个范围，比如:80-82
  #ssl表示所有与该端口的连接应该采用ssl模式
  #udp表示监听在udp端口
  #还有其他更多选项
  listen <ADDRESS>:<PORT> [ssl] [udp];

  #可以指定该server中设置的upstream
  #也可以指定 <DOMAIN_OR_IP>:<PORT>，如果域名能够解析出多个ip地址，则可以进行轮询转发到这些地址
  proxy_pass <UPSTREAM>;
}
```

##### （2）在http上下文中的server
```python
server {

  #支持多个主机名
  #主机名支持：
  #   域名后缀，比如：.example.com 等价于 example.com和*.example.com
  #   在域名的第一部分或最后一个部分使用通配符（*），比如：*.example.com
  #   正则（~），
  server_name <SERVER_NAME_1> <SERVER_NAME_2>;

  #跟stream差不多
  #这里的listen可以省略，<PORT>也可以省略，默认就是80
  listen <ADDRESS>:<PORT> [ssl] [udp];

  location <PATH>{

    #与stream相似，区别：
    #  <PROTOCOL>可以为http、https
    #  <UPSTREAM>处可以换成<DOMIAN_OR_IP>:<PORT>
    #  <PATH>可以省略
    proxy_pass <PROTOCOL>://<UPSTREAM><PATH>;
  }
}
```

#### 2.子层结构：uptream
用于定义能被引用的服务器组

##### （1）在stream上下文中的upstream
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

##### （2）在http上下文中的upstream
```python
upstream <NAME> {
  #与stream相似，区别：
  #<PORT>可以省略，省略的话就是80
  server <DOMAIN_OR_IP>:<PORT>;

  #其他配置基本都与stream上下文的一样
}
```

#### 3.转发http请求相关配置
* 可以配置在 http、server和location 这三个block中
* 只有当前block未配置，才会从上层继承
  * 比如在http、server和location都配置了proxy_set_header，只有location中的生效
  * 比如当前location中未定义proxy_set_header，会从server中继承proxy_set_header，如果server中没有，会继承http中的proxy_set_header配置

##### （1）`proxy_set_header`    
用于修改或者添加发往后端服务器的**请求头**
```python
proxy_set_header <HEADER> <VALUE>;

#比如：proxy_set_header Host $http_host;
#如果不设置，转发的请求中的Host字段就是原http请求中的Host字段
#设置后 后端服务器可以通过 Host 头得知用户访问的真正的域名，能够实现动态拼接url
```

##### （2）`add_header`
用于添加发往客户端的**响应头**
```python
add_header <HEADER> <VALUE>;
```

#### 4.转发websocket请求的配置
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
