# docker registry
[toc]
### 概述

#### 1.insecure registry
##### （1）没有设置insecure registry
* 则默认使用https协议连接仓库
所以必须信任颁发机构，即有ca证书，才能登录成功

##### （2)设置了insecure registry
* 首先尝试用`https`协议连接
  * 如果该端口提供了https协议，但是提示证书无效，会忽略这个错误，从而成功连接
* 最后尝试用`http`协议连接

#### registry分类
* sponsor registry        
第三方registry，供客户和docker社区使用

* Mirror registry           
第三方registry，只让客户使用

* Vendor registry          
由发布docker镜像的供应商提供的registry

* Private registry            
