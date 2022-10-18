# masscan

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [masscan](#masscan)
    - [概述](#概述)
      - [1.特点](#1特点)
    - [使用](#使用)
      - [获取banner](#获取banner)

<!-- /code_chunk_output -->

### 概述

#### 1.特点
* 快速和大量的扫描
* 有自己的TCP/IP stack，不是用的系统的


### 使用

#### 获取banner
获取banners需要完成完成的TCP连接，但是由于masscan用的是自己的TCP/IP栈，当数据包返回时，系统不能识别这个包，就会回复RST，导致一些banners无法获取
* 解决：通过`--source-ip`设置源地址，这个地址必须在宿主机所在网段内且没有被用过
```shell
masscan --baners --source-ip <SRC_IP> ...
```
