# oauth2.0

[toc]

### 概述

#### 1.oatuh2.0
是一种授权协议

#### 2.基础概念

|概念|说明|
|-|-|
|Authrization server|授权服务|
|Resource server|资源服务|
|UserDetails|用户信息|
|ClientDetails|客户信息|
|authenticate_code|临时授权码|
|access_toke|访问令牌|
|scope|权限范围|
|redirect_uri|客户端消息推送地址|

#### 3.grant types

##### （1）authorization_code
![](./imgs/oauth2_02.png)
* 1: 用户 访问应用
* 2：应用 将用户重定向到 授权服务，让用户输入认证信息
* 3: 授权服务 收到用户认证信息
* 4: 授权服务 发送 授权码 给应用
* 5：应用 用授权码向授权服务申请token
* 6: 授权服务 给 应用 发放token

##### （2）client_credentials
![](./imgs/oauth2_01.jpeg)

* 不需要用户的参与

##### （3）refresh_token
* 当认证成功后，refresh_token会伴随着access_token一起返回
* 当access_token快过期时，利用refresh_token申请新的token
![](./imgs/oauth2_03.png)
