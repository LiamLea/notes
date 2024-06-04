# configuration management


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [configuration management](#configuration-management)
    - [概述](#概述)
      - [1.dconf](#1dconf)
        - [(1) 使用](#1-使用)
        - [(2) profile](#2-profile)
      - [2.gsettings](#2gsettings)
        - [(1) 使用](#1-使用-1)

<!-- /code_chunk_output -->


### 概述

#### 1.dconf

是GNOME的配置管理系统，类似于windows的注册表

##### (1) 使用
* 列出所有路径
```shell
dconf list /
```

* 读取某个key
```shell
dconf read <path>
# dconf read /system/proxy/ignore-hosts
```

##### (2) profile
* 指定dconf db的优先级

```shell
$ cat /etc/dconf/profile/ibus
user-db:user
system-db:ibus

# user db (~/.config/dconf/user) 优先级最高
```

#### 2.gsettings

dconf提供给用户的API

##### (1) 使用
* 列出所有schemas
```shell
gsettings list-schemas
```

* 列出schemas和dconf path的对应关系
```shell
gsettings list-schemas --print-paths
```

* 列出某个schema下的所有keys
```shell
gsettings list-keys <schema>
# gsettings list-keys org.gnome.system.proxy
```

* 读取某个key
```shell
gsettings get <schema> <key>
# gsettings get org.gnome.system.proxy ignore-hosts
```