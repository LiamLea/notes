# File Upload

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [File Upload](#file-upload)
    - [概述](#概述)
      - [1.文件上传攻击](#1文件上传攻击)
      - [2.实现条件](#2实现条件)
    - [防护](#防护)
      - [1.客户端防护措施（效果不好）](#1客户端防护措施效果不好)
        - [（1）javascript检测](#1javascript检测)
        - [（2）MIME检测](#2mime检测)
      - [2.服务端防护措施](#2服务端防护措施)
        - [（1）文件扩展名检测](#1文件扩展名检测)
        - [（2）文件内容检测](#2文件内容检测)

<!-- /code_chunk_output -->

### 概述

#### 1.文件上传攻击
上传木马文件到服务器，并在服务器执行

#### 2.实现条件
* 目标网站具有上传功能
* 上传的文件能够被web服务器解析执行
  * 比如目标网站能够解析php文件，则上传的`xx.php`能够被服务器执行
* 知道文件上到服务器的 路径 和 文件名
  * 知道路径和文件名，然后访问该文件，则服务器就会执行`xx.php`文件
* 目标文件可被用户访问
  * 如果不能被访问，则无法触发服务器运行该文件

***

### 防护

#### 1.客户端防护措施（效果不好）

##### （1）javascript检测
通过javascript检测上传文件的后缀名，比如只允许`.jpg`后缀名
浏览器可以禁止执行javascript脚本，则这种方式就会失效

##### （2）MIME检测
服务端，检测请求头Content-Type字段，从而判断文件类型
客户端可以修改Content-Type，所以这种方式也会失效

#### 2.服务端防护措施

##### （1）文件扩展名检测
利用黑白名单等方式，检测上传文件的后缀名 或者 对文件进行重命名

##### （2）文件内容检测
根据文件前几个字节的内容，能判断出文件的类型
