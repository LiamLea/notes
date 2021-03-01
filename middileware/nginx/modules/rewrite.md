# ngx_http_rewrite_module

[toc]

### 概述

#### 1.作用
在server上下文中，相关语句会按照顺序执行
在location上下文中，如果uri被rewirite了，会重新寻找location（最多重复10次）

***

### 使用

#### 1.基础配置

* if
  * 上下文：server, location
```python
if (<conndition>) {
  ...
}
#等于比较： =     !=
#正则比较： ~     ~*
#文件存在： -f    !-f
#目录存在： -d    !-f
#存在文件或目录：  -e    !-e
#可执行文件存在：  -x    !-x
```

* rewrite
  * 上下文：server, location, if
```shell
rewrite <regex> <replcement> [flag];
#flag:
# redirect   返回码为302，告诉客户端，只是临时重定向
# permanent  返回码为301，告诉客户端，是永久重定向
# last       相当于conntinute，进行下一次重复（即根据新的uri，取匹配location）
# break      不会执行rewrite相关内容，也不会根据新的url，取匹配location
```

* break
  * 上下文: server, location, if
  * 停止rewrite，即使rewrite了一个新的地址，也不会进行匹配了
</br>
* return
  * 上下文：server, location, if
```shell
#直接重定向，返回重定向的内容或地址
return <code> [text];
return code URL;
return URL;
```

* rewrite_log
  * 上下文：server, location, if
```shell
#记录rewrite相关语句执行结果的日志，记录在error_log中（需要将error_log记录的级别设为notice）
rewrite_log on;
```

* set设置变量
  * 上下文：server, location, if
```shell
set <variable> <value>
```
