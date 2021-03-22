# config

[toc]

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
