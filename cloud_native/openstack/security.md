# security

[toc]

### port security

#### 1.port security基本原理

* 基本策略（无法修改）：
  * 白名单形式
    * 默认所有外出或进入流量都不允许通过
  * 不在 **allowed_address_pairs** 和 **fixed_ips/mac_address** 中的 ip/mac pair流量都不允许通过
    * pass through（流量经过这个端口，比如：路由转发）和promiscuous模式都无效
    * 所以**路由**的接口需要**disable port security**，否则经过这个interface的流量都不允许通过
* security group
  * 在基本策略的基础上，明确指定哪些数据包能通过，哪些不能通过

#### 2.为什么需要port security
anti-spoofing（即防止ip或mac欺骗），因为openstack是一个云平台，可以供很多租户使用，所以要严格控制port security

#### 3.security group（是应用到port上的）
当disable port security，则这个port的security group就不会生效了

##### （1）默认security group: default
流量只能出，不能主动进
只有在default中的port发来的流量才能主动进
