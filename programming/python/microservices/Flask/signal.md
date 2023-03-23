# signal

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [signal](#signal)
    - [概述](#概述)
      - [1.特点](#1特点)
      - [2.使用](#2使用)
        - [（1）定义signal](#1定义signal)
        - [（2）在signal中注册函数](#2在signal中注册函数)
        - [（3）触发信号](#3触发信号)

<!-- /code_chunk_output -->

### 概述

#### 1.特点
* 基于 blinker 模块

#### 2.使用
##### （1）定义signal
flask中定义了相关信号

##### （2）在signal中注册函数
```python
from flask import signals

#将<FUNC>函数注册到request_started这个信号中
signals.request_started.connect(<FUNC>)
```

##### （3）触发信号
flask定义的信号不需要手动触发，达到特定条件flask会触发
* 比如：request_started信号，会在每个request到来时，触发一次
  * 触发时执行的函数就是注册在该信号中的函数
```python
#手动触发
signals.request_started.send()
```
