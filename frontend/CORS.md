[toc]
### 预备知识
#### 1.源（域）的概念
* 协议
* 域名（即ip地址）
* 端口
#### 2.跨域的概念
允许从一个域中访问另一个域

#### 3.同源（same-origin policy）策略的概念
* 浏览器不允许从一个域中访问另一个域
* 当一个域向另一个域发送HTTP请求时，实际的请求发送过了，另一个域也给出了回复，但是**浏览器**会截获这个**回复**，然后给当前域返回一个错误

***

### CORS(cross-origin resource sharing)
实现跨域
#### 1.具体实现
在**回复的请求头**中加上一个键值对
```shell
"Access-Control-Allow-Origin": "*"      
#*表示允许任何域访问
#如果填http://3.1.1.1:8080，表示只允许http://3.1.1.1:8080这个域访问

"Access-Control-Allow-Crendentials": "true"
"Access-Control-Allow-Methods": "GET,PUT,POST,DELTE,OPTIONS"

#用于标识响应头中哪些是可以接受的
#当响应头中包含凭证信息（就是响应头中有 Set-Cookie 或 Authorization等），这里的通配符就只是*符号，没有特殊意义
"Access-Control-Allow-Headers": "*"
```

#### 2.当请求中包含了凭证的请求
##### （1）解决方式一：允许的域需要明确指定
```shell
"Access-Control-Allow-Origin": "<具体的域>"  #这里就不能用通配符     
```

##### （2）标识可以接受带凭证的头：Set-Cookie
```shell
"Access-Control-Allow-Headers": "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,Set-Cookie"
```
