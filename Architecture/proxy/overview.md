# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.VPN vs Proxy](#1vpn-vs-proxy)

<!-- /code_chunk_output -->

### 概述

#### 1.VPN vs Proxy

||VPN|Proxy|
|-|-|-|
|范围|系统范围的（会虚拟出一个网卡）|APP范围的，每个APP需要自己设置proxy|
|原理|有专门的协议|socks5（伪装成https协议）|
