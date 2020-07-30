# nginx
[toc]

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
