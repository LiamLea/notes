# spoofing attack

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [spoofing attack](#spoofing-attack)
    - [概述](#概述)
      - [1.ip/mac spoofing](#1ipmac-spoofing)
        - [（1）mac spoofing](#1mac-spoofing)
        - [（2）ip spoofing](#2ip-spoofing)
        - [（3）prevent ip/mac spoofing](#3prevent-ipmac-spoofing)
      - [2.arp spoofing（arp poisoning）](#2arp-spoofingarp-poisoning)
      - [3.DNS spoofing](#3dns-spoofing)

<!-- /code_chunk_output -->

### 概述

#### 1.ip/mac spoofing

##### （1）mac spoofing
* 目标:
  * anonymization（匿名，隐藏自己的身份）
  * Identity theft（冒充别人身份，绕过关于mac的相关策略）
* 危害：**难以检测**

##### （2）ip spoofing
* 目标:
  * anonymization（匿名，隐藏自己的身份）
  * Identity theft（冒充别人身份，绕过关于mac的相关策略）
  * DDOS attack
    * 前提：需要有botnet（即僵尸网络，即控制了一些数量的机器）
    * botnet中的所有机器伪造源ip（用于隐藏身份），集中向某一个服务器发起请求，耗尽该服务器的资源
  * Reflected DDoS
    * 前提：需要有botnet（即僵尸网络，即控制了一些数量的机器）
    * botnet中的所有机器伪造源ip发送请求到某个server，该server会响应更大的数据包到这个伪造的源ip（即victim）
* 危害：**难以检测**

##### （3）prevent ip/mac spoofing
无法阻止ip/mac spoofing，但是可以阻止 欺骗数据包 进入网络：

* packet filtering（ingress and egress）
  * 对每个设备进出的包进行过滤，只允许对于的ip/mac地址通过（网络提供商就是采用的这种方式）
* 利用非对称密钥对数据进行加密
* 网络监控（能够及时发现异常流量）
* firewall（过滤不信任的流量）

#### 2.arp spoofing（arp poisoning）

* 影响范围：局域网内的机器
* 目标： man-in-the-middle attack
* 危害：危害性没有以前那么严重了，因为现在数据都进行了加密
* 原理：
  * 场景：
    * A: 192.168.1.11 / 2a:13:6f:06:35:a5
    * B: 192.168.1.12 / 2a:13:6f:06:35:a6（攻击者）
    * router: 192.168.1.254 / 2a:13:6f:06:35:a7
  * B向router发送ARP更新请求，告诉router: 192.168.1.11的mac地址是2a:13:6f:06:35:a6
  * B向A发送ARP更新请求，告诉A: 192.168.1.254的mac地址是2a:13:6f:06:35:a6
  * 所以实现了中间人攻击
    * A发送给router的包都先转给B，然后B再转给router
    * router发送给A的包都先转给B，然后B再转给A

#### 3.DNS spoofing

* 影响范围：
  * 入侵了DNS服务器
  * 已经成功实施了man-in-the-middle攻击
  * DNS cache spoofing（当DNS server向高级别的DNS server请求解析地址时，攻击者可以回复非法地址，这样地址就会被这个DNS server缓存，有一定的时效性）
* 目标：返回非法的ip给请求者
