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
