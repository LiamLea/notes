# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.各层的数据单元](#1各层的数据单元)
        - [(1) 工作原理](#1-工作原理)
      - [2.session相关概念](#2session相关概念)
        - [(1) session endpoint](#1-session-endpoint)
        - [(2) session](#2-session)
        - [(3) session direction](#3-session-direction)
      - [3.URI vs URL](#3uri-vs-url)
        - [(1) URI (uniform resource identifier)](#1-uri-uniform-resource-identifier)
        - [(2) URL (uniform resource location)](#2-url-uniform-resource-location)
        - [(3) http URL](#3-http-url)
      - [4.URL encoding](#4url-encoding)

<!-- /code_chunk_output -->

### 概述

#### 1.各层的数据单元
|protocol|PDU (protocol data unit)|控制PDU大小的参数|
|-|-|-|
|tcp|segment|MSS (maximum segment size), 默认值: 1500-40=1460|
|ip|packet (fragment)|MTU (maximum transmission unit), 默认值: 1500|
|data link layer|frame|


##### (1) 工作原理

![](./imgs/overview_01.png)

* tcp会根据MSS（maximum segment size），将数据分为多个segment
* 然后将每个segment封装为ip packet
* ip协议会根据MTU（Maximum Transmission Unit），会将ip数据报分为多个fragment
* 接收端会reassemble ip fragment

#### 2.session相关概念

##### (1) session endpoint
ip:port

##### (2) session
一对session endpoints组成session

##### (3) session direction
对于TCP，根据SYN判断
对于UDP，根据谁发送第一个数据包判断

#### 3.URI vs URL

##### (1) URI (uniform resource identifier)

用于唯一标识一个资源

##### (2) URL (uniform resource location)

是一种URI，用于标识资源的位置

##### (3) http URL
是一种基于http协议的URL，不同协议有不同类型（格式）的URL

#### 4.URL encoding

* 有些字符在URL中是有特殊含义的（比如`/`、`&`等）
* 所以当数据包含这些字符时，需要进行encode，数据才能传送出去

* 举例
  * 原始url
  ```perl
  https://www.example.com/search?q=hello world
  ```
  * URL-encoded
  ```python
  https://www.example.com/search?q=hello%20world
  ```