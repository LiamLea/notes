# CSRF

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [CSRF](#csrf)
    - [概述](#概述)
      - [1.CSRF（cross-site request forgery）](#1csrfcross-site-request-forgery)
      - [2.SSRF（server-side request forgery）](#2ssrfserver-side-request-forgery)
      - [2.实现CSRF攻击条件](#2实现csrf攻击条件)
      - [3.CSRF影响](#3csrf影响)
    - [防护](#防护)
      - [1.添加中间环节](#1添加中间环节)
        - [（1）添加确认过程](#1添加确认过程)
        - [（2）添加验证码](#2添加验证码)
      - [2.验证用户请求的合法性](#2验证用户请求的合法性)
        - [（1）利用token（一般用于post等请求，不用于get请求 ）](#1利用token一般用于post等请求不用于get请求)

<!-- /code_chunk_output -->

### 概述

#### 1.CSRF（cross-site request forgery）
攻击者伪造当前用户的行为，让目标服务器误以为请求由当前用户发起

#### 2.SSRF（server-side request forgery）
服务器从用户的输入提取参数，向第三方发起请求，获取数据，再返回给用户
这样的情况下，会存在SSRF漏洞，攻击者可以利用该漏洞，探测服务器内部环境
此种攻击危害较小，而且较少发生

#### 2.实现CSRF攻击条件
* 用户处于登录状态
* 伪造的请求与正常应用请求一样
* 后台未对用户业务做合法性校验

#### 3.CSRF影响
* 可以执行某些操作（比如删除等）

***

### 防护

#### 1.添加中间环节

##### （1）添加确认过程
执行一些重要的操作时，服务端会返回信息让用户确认（此时攻击者没法收到该信息）

##### （2）添加验证码
本质跟确认过程一样

#### 2.验证用户请求的合法性

##### （1）利用token（一般用于post等请求，不用于get请求 ）
* 用户登录时会在请求体中传入一个token，服务器会获取该token
* 后续的每次访问 请求体都携带该token，服务器会对比登陆时传入的token
  * 如果相同，则验证通过
