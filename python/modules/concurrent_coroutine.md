# coroutine（协程）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [coroutine（协程）](#coroutine协程)
    - [概述](#概述)
      - [1.协程特点](#1协程特点)
      - [2.实现协程和规避IO的模块](#2实现协程和规避io的模块)
        - [（1）gevent](#1gevent)
        - [（2）asyncio](#2asyncio)
    - [使用](#使用)
      - [1.gevent](#1gevent-1)

<!-- /code_chunk_output -->

### 概述
#### 1.协程特点
* 是操作系统不可见的
* 本质是一条线程，多个任务在一条线程上来回切换
* 协程也无法使用多核
* 作用：
  * 规避IO操作（即IO操作时，线程不会阻塞，会执行其他任务）
* 协程是数据安全的
  * 因为协程的切换是用户控制的，切换的单位是一条python命令
  * 线程的切换是系统控制的，切换的单位是一条CPU指令
* 缺点：
  * 只能感知到用户级别的io操作，比如：网络、sleep
  * 无法感知系统级别的io操作，比如：操作文件、input、print
* 好处
  * 减轻了操作系统的负担
  * 一条线程如果开了多个协程，那么给操作系统的印象是线程很忙，这样就能充分利用时间片，减少了切换和等待时间片的时间

#### 2.实现协程和规避IO的模块
##### （1）gevent
利用了用C语言实现的greenlet模块，和自己实现的自动规避IO的功能

##### （2）asyncio
利用了yield语法，和自己实现的自动规避IO的功能
基于python原生的协程
提供协程的关键字：async await

***

### 使用
#### 1.gevent
```python
#在代码的最上方执行patch_all函数
#patch_all函数会修改一些IO函数，从而可以规避相应的IO操作
#查看patch_all参数，就可以看出gevent可以规避哪些IO操作
from gevent import monkey
monkey.patch_all()

import gevent

def func():
    #带IO操作的内容写在函数中
    pass

g1 = gevent.spawn(<func>)

g1.join()                 #阻塞，直到协程执行完成
gevent.joinall(<LIST>)
```
