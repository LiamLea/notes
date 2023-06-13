
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [`pg_hba.conf`](#pg_hbaconf)
    - [（1）TYPE:](#1type)
    - [（2）DATABASE：](#2database)
    - [（3）USER：](#3user)
    - [（4）ADDRESS：](#4address)
    - [（4）METHOD：](#4method)

<!-- /code_chunk_output -->

### `pg_hba.conf`
```shell
<TYPE>  <DATABASE>  <USER>  <ADDRESS>  <METHOD>
```
##### （1）TYPE:
```shell
local       #当连接数据库时不加-h
host        #当连接数据库时加-h
```

##### （2）DATABASE：
```shell
all               #对所有的数据库生效
具体的数据库名     #对指定数据库生效（如果与all有冲突，具体的生效）
                  #有多个可以用逗号隔开
replication       #匹配复制请求（注意，复制请求不会指定具体数据库）
sameuser          #数据库名 为 请求的用户名 时匹配
samerole          #数据库名 为 请求的用户所在的role的名 时匹配
```

##### （3）USER：
```shell
all             #对所有的用户生效
具体的用户名     #对指定用户生效（如果与all有冲突，具体的生效）
```

##### （4）ADDRESS：
```shell
0.0.0.0/0       #对所有地址生效
```

##### （4）METHOD：
```shell
trust          #免密登录
reject         #拒绝登录
password       #用没有加密的密码登录
md5            #用md5加密后的密码登录
```
