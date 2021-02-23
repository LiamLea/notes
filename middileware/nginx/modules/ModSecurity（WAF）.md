# WAF

[toc]

### 概述

#### 1.WAF
web application firewall

#### 2.ModSecurity
是一个动态库，nginx可以加载相应的模块，从而使用ModSecurity，从而能够设置各种规则，从而能够成为WAF

#### 2.OWASP CRS
open web application security project core rule set
为NGINX ModSecurity WAF提供规则，用于阻止相关攻击：
* SQL Injection (SQLi)
* Remote Code Execution (RCE)
* Local File Include (LFI)
* cross‑site scripting (XSS)
* 更多的其他攻击

***

### nginx加载ModSecurity动态库

#### 1.安装ModSecurity

##### （1）安装依赖
```shell
apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
```

##### （2）安装ModSecurity
```shell
git clone https://github.com/SpiderLabs/ModSecurity.git
cd ModSecurity
./build.sh
./configure
make
make install
```

#### 2.生成 指定nginx版本 对应的ModSecurity动态库文件

##### （1）下载nginx connector用于连接ModSecurity
```shell
git clone https://github.com/SpiderLabs/ModSecurity-nginx.git
```

##### （2）下载指定版本的nginx源码
比如目前使用的nginx版本是1.18.0
```shell
wget http://nginx.org/download/nginx-1.18.0.tar.gz
```

##### （3）生成相应的ModSecurity动态库文件
```shell
tar -xf nginx-1.18.0.tar.gz
cd nginx-1.18.0/
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
make modules
```

##### （4）将ModSecurity动态库文件移动到当前nginx中
```shell
cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
```
