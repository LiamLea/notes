# nethogs

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [nethogs](#nethogs)
    - [使用](#使用)
      - [1.参数](#1参数)
      - [2.常用组合](#2常用组合)

<!-- /code_chunk_output -->

### 使用

#### 1.参数
```shell
nethogs <INTERFACE1> <INTERFACE2>  #不指定网卡的话，就是全部网卡

-p        #开启混杂模式，监控经过该网卡的网络包，不能监控局域网
-t        #text，会连续打印输出，而不是动态变化，这样就可以看到记录
-v <NUM>  #0 = KB/s, 1 = total KB, 2 = total B, 3 = total MB
          #默认是0
```

#### 2.常用组合
* 监控进程网络io实时速率
```shell
nethogs
```

* 监控进程一段时间内网络io总量
```shell
nethogs -v 3
```

* 监控局域网内网络状况
