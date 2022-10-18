# config

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [config](#config)
    - [tikv](#tikv)
      - [1.忽略大小写（必须在初始化tidb时设置）](#1忽略大小写必须在初始化tidb时设置)
    - [pd](#pd)
      - [1.开启dashboard](#1开启dashboard)

<!-- /code_chunk_output -->

### tikv

#### 1.忽略大小写（必须在初始化tidb时设置）
```shell
new_collations_enabled_on_first_bootstrap = true
```

* 创建数据库
```shell
CREATE DATABASE xx DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
```

***

### pd

#### 1.开启dashboard
```shell
[dashboard]
#能够访问dashboard
internal-proxy = true
```
