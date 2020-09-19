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
用于处理HTTP
```shell
http {
  ...
}
```

##### （3）events
常规连接处理

##### （4）mail
Mail traffic

#### 2.子层结构：virtual servers
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

#### 3.子层结构：uptream
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

#### 4.继承
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
