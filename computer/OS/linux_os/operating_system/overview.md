# OS

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [OS](#os)
    - [概述](#概述)
      - [1.应用程序与内核交互的三种情况：](#1应用程序与内核交互的三种情况)
      - [2.内存有两种：](#2内存有两种)
      - [3.trap和interrupt区别](#3trap和interrupt区别)
      - [6.六种名称空间](#6六种名称空间)

<!-- /code_chunk_output -->

### 概述

#### 1.应用程序与内核交互的三种情况：
* 中断
* 异常
* 系统调用（软中断）

#### 2.内存有两种：
* RAM		  	
random access memory，断电后，这里面的内容都会清空  
</br>
* ROM			
read only memory，用来存储BIOS程序（主要功能：加电自检(检查硬件状况)、加载bootloader）

#### 3.trap和interrupt区别
* trap
  * 同步的
  * 是用户进程中的异常
  * 是由程序员发起，希望将控制权转移到特殊的处理程序
* interrupt
  * 异步的
  * 通常由硬件产生，比如键盘的输入等


#### 6.六种名称空间
* uts（UNIX Timesharing System）
主机名和域名  
* net
网络，主要用于实现协议栈的隔离
* ipc                                               
进程间通信的
* user                                              
用户
* mnt（mount）                                      
挂载文件系统的
* pid                                               
进程 id 的
