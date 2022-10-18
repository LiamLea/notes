# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.configure](#1configure)
      - [2.makefile](#2makefile)
    - [使用](#使用)
      - [1.make](#1make)
      - [2.makefile格式](#2makefile格式)
      - [3.语法](#3语法)
        - [（1）转义](#1转义)

<!-- /code_chunk_output -->

### 概述

#### 1.configure
* 检查 编译 所需的依赖
* 生成makefile文件

#### 2.makefile
* makefile 用于组织代码编译 的文件
* 不仅仅可用于c语言，还可以用于任何可以用shell命令进行编译的语言

***

### 使用

#### 1.make
```shell
make [options] [targets]

#options:
# -f <makefile>   不指定的话，在当前目录下，按照顺序寻找：GNUmakefile makefile Makefile

#targets:
# 如果不指定，默认处理第一个不以 .开头的target
```

#### 2.makefile格式
* 一个target就是一个文件，target名就是文件名
  * 执行target时，可以用命令创建名为target的文件
  * 这样能够实现，如果文件不存在，才会执行该target
* 如果target有依赖，会根据依赖生成target，如果依赖发生变化，才会执行该target
  * 变化是通过：依赖文件的修改时间 比 target文件的修改时间 新 发现的
```shell
#需要置顶的配置
.DEFAULT_GOAL := <TARGET>   #设置默认的target，如果不指定，默认处理第一个不以 .开头的target
.PHONY := <TARGET>     #指定该target不是一个文件，这样即使target文件没有变化，target还是会执行

#定义变量
#?= 表示如果变量变量不存在，则复制
<VARIABLE> = <VALUE>

#将shell命令的执行结果作为变量
<VARIABLE> = $(shell <COMMAND>)

#定义target
<TARGET>: <DEPENDECE1> <DEPENDECE2> ...   #依赖的文件名（注意target就是 文件名），当依赖的文件存在时，才会执行该<TARGET>
    <SHELL_COMMAND>   #前面必须是tab键隔开的空格
                      #@<SHELL_COMMAND> 在前面加个@表示，不会打印出命令，只会打印结果
                      #使用变量：$(<VARIABLE>) 或 ${<VARIABLE>}

                      #如果需要调用某个target：$(MAKE) <TARGET>
                      #$(MAKE)就是make，就是递归执行make命令
```

#### 3.语法

##### （1）转义

|原字符|转义|
|-|-|
|`$`|`$$`|
|`#`|`\#`|
