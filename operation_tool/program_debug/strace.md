
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [strace](#strace)
  - [1.选项](#1选项)

<!-- /code_chunk_output -->

### strace
* strace用于跟踪进程运行时的系统调用等，输出的结果：  
  * 每一行都是一条系统调用，等号左边是系统调用的函数名及其参数，右边是该调用的返回值  

#### 1.选项
```shell
  -f            #跟踪由fork调用所产生的子进程
  -c            #进行统计，统计调用哪些系统调用、调用的次数和错误等，最后给出一个统计结果
  -e 表达式     #表达式：
                #trace=open 表示只跟踪open调用
  -p <PID>      #可以跟踪正在运行的进程
```
