# DHCP

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [DHCP](#dhcp)
    - [概述](#概述)
      - [1.DHCP](#1dhcp)
      - [2.原理](#2原理)

<!-- /code_chunk_output -->

### 概述
#### 1.DHCP
dynamic host configuration protocol

#### 2.原理
* DISCOVERY
  * 进行广播,寻找DHCP服务器
* OFFER
  * DHCP提供IP等参数
* REQUEST
  * 客户端发送request请求，请求使用该ip（广播方式）
* ACK
  * 服务端，接受request请求，回复ACK，表示确认

注意:广播进行(因为客户端没有IP)，先到先得，一个网络里只能有一个DHCP服务器
