# ngx_http_map_module

### 概述

#### 1.作用
自定义一个变量，该变量的值 根据 原字符串 和 映射规则 产生

#### 2.特点
* 当使用变量时，才会计算变量的值

***

### 使用

#### 1.基本使用
* 上下文：http
```shell
map <source_string> <variable> {
  default <value>;    #当所有pattern都不匹配时，<vairable>变量的值就是这里设置的<value>的值

  #<pattern>可以为 字符串 或者 正则（以 ~ 开头表示区分大小写的正则，以 ~* 开头表示不区分大小写的正则）
  <pattern> <value>;
}
```
* `<source_string>`一般都是设置一个或多个变量，如果不用变量，没什么意义
  ```shell
  map "$remote_addr:$remote_port" $remote {
    default 1;                #当不匹配下面任意一种情况时，$remote值为1
    "192.168.90.1:1121" 2;    #当客户端ip为192.168.90.1，port为1121，则$remote值为2
    "~192\.168\.90\.2.*" 3;   #当客户端ip为192.168.90.2，则$remote值为3
  }
  ```

* 不常用的配置
  ```shell
  map <source_string> <variable> {
      hostnames;    #表示下面的<pattern>可以是，带有前缀或后缀掩码的主机名,（*.example.com 或者 example.* 或者.example.com)
      default <value>;
      <pattern> <value>;
  }
  ```
