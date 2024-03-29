# FTP

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [FTP](#ftp)
    - [概述](#概述)
      - [1.ftp的主动模式和被动模式](#1ftp的主动模式和被动模式)
      - [2.用容器启动ftp时，需要把网络模式设为network，否则客户端无法用被动模式连接ftp服务器](#2用容器启动ftp时需要把网络模式设为network否则客户端无法用被动模式连接ftp服务器)
    - [配置](#配置)

<!-- /code_chunk_output -->

### 概述

#### 1.ftp的主动模式和被动模式
默认为被动模式,即命令连接和数据连接都由客户端建立
```shell  
#ftp关闭被动模式:
  ftp xxx
  > passive
```
```shell
#wget下载ftp内容:
  wget --no-passive-ftp ftp://xx
```

#### 2.用容器启动ftp时，需要把网络模式设为network，否则客户端无法用被动模式连接ftp服务器

***

### 配置

```shell
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
local_root=/home/kangpaas
xferlog_enable=YES
pam_service_name=ftp        #先用vsftpd，如果有问题再改
                            #默认是vsftpd，如果pam认证设置有问题，会导致530错误
#填写的ftp是不存在的，即没有设置pam验证
userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/vsftpd/user_list
```
