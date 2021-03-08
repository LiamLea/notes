# File Inclusion

[toc]

### 概述

#### 1.File Inclusion
服务端会会调用文件，该文件由用户输入的参数决定
有两类文件包含攻击：
* LFI（local file inclusion）
* RFI（remote file inclusion）

#### 2.实现文件包含攻击的条件
* 服务端通过函数调用相关文件
* 用户能够控制包含文件的参数

***

### 防护

#### 1.文件名验证
利用黑白名单等方式，检测上传文件的后缀名

#### 2.路径限制
只允许包含指定目录下的文件
