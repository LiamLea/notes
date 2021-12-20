# calico-node

[toc]

### 概述

[参考文档](https://docs.projectcalico.org/reference/node/configuration)

#### 1.calico-node
calico-node容器运行在每个node上，用于提供网络能力

#### 2.两种配置形式

* 通过环境变量配置
  * 通过资源清单安装需要这样配置
* 通过operator和自定义资源配置
  * 本质也是通过环境变量，但是用户不需要关注这个，只需要修改自定义的资源清单

#### 3.常用环境变量

##### （1）ip pool相关配置
```shell
#当新创建ippool时，隧道模式用这里配置的
#这两个只能启用其中一个，有三种值：Always, CrossSubnet, Never
CALICO_IPV4POOL_IPIP    #默认Always
CALICO_IPV4POOL_VXLAN   #默认Never
```
