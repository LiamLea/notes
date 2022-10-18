# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.APM](#1apm)
      - [2.架构](#2架构)
        - [（1）apm agent](#1apm-agent)
        - [（2）apm server](#2apm-server)

<!-- /code_chunk_output -->

### 概述

#### 1.APM
application performance monitoring

#### 2.架构
![](./imgs/overview_01.png)

##### （1）apm agent
负责数据的采集

python采集的三种方式：
* framework integration（框架集成）
  * 将采集的功能集成到相应框架中（比如Flask），然后代码调用集成后的框架
  * 需要少量的代码改动
* instrumentation（测量仪）
  * 给相应的包（比如http）装测量仪（即相应的函数），来获取响应等数据
  * 无需更改代码
* backgroup collection（后台采集）
  * 采集系统和进程的相关指标

java apm agent是利用jvm的功能来检测类的字节码，来进行数据采集，所以无需代码改动，只不过启动程序时，需要加载agent的包

##### （2）apm server
负责接收apm agent的数据，并且将数据存入es中
