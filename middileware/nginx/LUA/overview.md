# LUA

[toc]

[参考资料](https://github.com/openresty?page=1)

### 概述

#### 1.lua指令执行的顺序
![](./imgs/lua_01.png)

#### 2.lua提供的功能模块

* encrypted-session-nginx-module
加密某个字段的值（比如可以加密cookie的值）

* lua-resty-redis
可以连接redis，将数据存入redis

* lua-cjson
处理json格式

***

### nginx加载lua动态模块

#### 1.生成相关动态模块

##### （1）安装和下载依赖
* 安装luajit
```shell
apt-get -y install libssl-dev

git clone https://github.com/openresty/luajit2.git
make
make install
```

##### （2）下载相关模块的源码

* ngx_devel_kit（前提条件）
* lua-nginx-module（只能在http块中使用lua脚本，即处理七层流量）
* lua-upstream-nginx-module（可以使用http uptream的api）
* stream-lua-nginx-module（只能在stream块中使用lua脚本，即处理四层流量）

```shell
git clone https://github.com/vision5/ngx_devel_kit.git
git clone https://github.com/openresty/lua-nginx-module.git
git clone https://github.com/openresty/lua-upstream-nginx-module.git
git clone https://github.com/openresty/stream-lua-nginx-module.git
````

##### （3）下载指定版本的nginx源码
比如目前使用的nginx版本是1.18.0
```shell
wget http://nginx.org/download/nginx-1.18.0.tar.gz
```

##### （4）生成动态模块
```shell
tar -xf nginx-1.18.0.tar.gz
cd nginx-1.18.0/

#设置lua库的环境变量
export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.1

./configure --with-compat \
            #添加动态链接的选项，要指定正确的路径，否则动态模块找不到相应的动态库
            --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
            --add-dynamic-module=../ngx_devel_kit \
            --add-dynamic-module=../lua-nginx-module \
            --add-dynamic-module=../lua-upstream-nginx-module \
            --with-stream --with-stream_ssl_module --add-dynamic-module=../stream-lua-nginx-module

make modules

cp objs/{ndk_http_module.so,ngx_http_lua_module.so,ngx_http_lua_upstream_module.so,ngx_stream_lua_module.so} /etc/nginx/modules/
```

#### 2.下载基础lua代码
```shell
mkdir -p /etc/nginx/lua/ngx /etc/nginx/lua/resty

#导入lua core代码
git clone https://github.com/openresty/lua-resty-core.git
cp -r lua-resty-core/lib/resty/* /etc/nginx/lua/resty/
cp -r lua-resty-core/lib/ngx/* /etc/nginx/lua/ngx/

git clone https://github.com/openresty/lua-resty-lrucache.git
cp -r lua-resty-lrucache/lib/resty/*  /etc/nginx/lua/resty/
```

#### 3.使用
```shell
$ vim /etc/nginx/nginx.conf

load_module modules/ndk_http_module.so;
load_module modules/ngx_http_lua_module.so;
load_module modules/ngx_http_lua_upstream_module.so;
load_module modules/ngx_stream_lua_module.so;

http {
  lua_package_path "/etc/nginx/lua/?.lua;;";
  ...
}
```

#### 4.验证

* 添加下面配置

```shell
location /test {
   content_by_lua_block {
     ngx.say("hello the world!!!!!!!!!!!!!")
   }
}
```

* 访问该url

```shell
hello the world!!!!!!!!!!!!!
```

#### 5.添加其他功能（比如redis）

##### （1）下载相应lua代码
```shell
git clone https://github.com/openresty/lua-resty-redis.git
cp -r lua-resty-redis/lib/resty/* /etc/nginx/lua/resty/
```

##### （2）配置nginx进行测试
```python
location /test {
  content_by_lua_block {
  local redis = require "resty.redis"
  local red = redis:new()

  red:set_timeouts(1000, 1000, 1000)

#这个是判断能否连接成功，而不是登录，所以不需要密码
  local ok, err = red:connect("<ip>", <port>)
  if not ok then
      ngx.say("failed to connect: ", err)
      return
  else
      ngx.say("successed to connect", err)
      return
  end
  }
}
```

##### （3）访问该url进行验证

***

### 使用
[参考文档](https://github.com/openresty/lua-nginx-module)
