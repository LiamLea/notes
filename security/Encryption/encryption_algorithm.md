
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [概述](#概述)
  - [1.BASE 64编码](#1base-64编码)
  - [2.HASH](#2hash)
    - [（1）常用HASH加密算法](#1常用hash加密算法)
    - [（2）特点](#2特点)
    - [（3）应用场景：用户密码](#3应用场景用户密码)
    - [（4）缺点](#4缺点)
  - [3.散列碰撞](#3散列碰撞)
  - [4.HMAC](#4hmac)
    - [（1）特点](#1特点)

<!-- /code_chunk_output -->

### 概述

#### 1.BASE 64编码
将任意二进制数据进行编码，编码成由65个字符（`0~9 a~z A-Z + / =`）中的某些字符组成 的文本文件
* 会使文件比原来更大

#### 2.HASH

##### （1）常用HASH加密算法
* MD5
* SHA1
* SHA256
* HMAC

##### （2）特点
* 得到的结果是**定长**的
* 信息摘要，信息指纹，用于做**数据校验**
* 不可逆运算

##### （3）应用场景：用户密码
* 用户在客户端**注册**时，将**密码的hash值**，**发送**到服务器，服务器保存用户密码的hash值
* 用户登录时，在客户端将**密码的hash值**，**发送**到服务器，服务器**比对**本地保存的用户hash值和用户发来的hash值，如果一样，表明用户密码正确
* 所以现在都**没有找回密码**这个功能，只有**重置密码**这个功能

##### （4）缺点
可以在cmd5网站中查找，从而破解密码
* 早期解决方法：加盐（salt）
  * 加salt的缺点：salt是在程序里写死的，一旦泄露会密码就不安全了
* 现在的解决方法：HMAC

#### 3.散列碰撞
两个数据的hash值是一样的，这样的情况叫做散列碰到

#### 4.HMAC
* 用户注册时，服务端会发送一个key到客户端，客户端用这个key对密码进行hash，服务端会保存这个hash结果
* 用户登录时，会将hash结果加上时间戳，再次进行hash，然后发送给服务端，服务端同样这个做进行验证
  * 注意，加的时间戳最多精确到分钟，如果服务器用当前时间计算出来的与客户端发来的不匹配，服务端会将时间减1分钟，再进行hash匹配

##### （1）特点
* 一个账号一个key
