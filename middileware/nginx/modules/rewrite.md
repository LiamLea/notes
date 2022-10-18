# ngx_http_rewrite_module

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ngx_http_rewrite_module](#ngx_http_rewrite_module)
    - [概述](#概述)
      - [1.作用](#1作用)
    - [使用](#使用)
      - [1.基础配置](#1基础配置)

<!-- /code_chunk_output -->

### 概述

#### 1.作用
在server上下文中，相关语句会按照顺序执行
在location上下文中，**会将该location中的·所有rewrite相关语句拿出来先执行，其他语句暂时不执行**，当location中rewrite相关的语句都执行完后，如果uri被rewirite了，会重新寻找location（最多重复10次）

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
#只要url匹配<regex>，就会用<replcement>完全替换url
#比如，url为/aaa/test1，<regex>为 test1，则能够匹配
#<replcement>中可以使用正则的组变量：$1 $2等

#flag:
#  redirect   返回码为302，告诉客户端，只是临时重定向
#  permanent  返回码为301，告诉客户端，是永久重定向
#  last       相当于conntinute，结束此次处理过程（即下面rewrite相关语句不会再执行），根据新的url进行下一次匹配
#  break      相当于break，即退出rewrite相关语句的执行（也不会根据新的url继续匹配了），执行location中其他语句
```

* break
  * 上下文: server, location, if
  * 停止rewrite，即使rewrite了一个新的地址，也不会进行匹配了，执行其他的非rewrite相关的语句
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
