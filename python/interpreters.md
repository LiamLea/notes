# 解释器
[toc]

### pypy解释器

#### 概述

##### 1.特点
* 还是存在GIL锁
* 速度比较cpython快

#### 2.为什么pypy比cpython快

***

#### 安装

* 安装编译好的包

```shell
tar xf pypy-x.y.z.tar.bz2
```

* 使用
```shell
./pypy-xxx/bin/pypy
```

* 安装pip和相关包
 ```shell
 ./pypy-xxx/bin/pypy -m ensurepip
  ./pypy-xxx/bin/pypy -m pip install xx
 ```

 ***

### jython解释器

#### 概述

##### 1.特点
* 没有GIL锁
* 速度比较cpython快
* 不能兼容cpython的相关c扩展库（比如paramiko，其中有些功能使用了c扩展库）
