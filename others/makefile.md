# overview

[toc]

### 概述

#### 1.c语言编译四步（通常说的编译包含指的是前三步）
* preprocessing（预处理）
  * 去除注释
  * 填充宏
  * 填充included文件

* compiling（编译）
  * 生成汇编代码

* assembly（汇编）
  * 将编码转换成二进制机器码

* linking（链接）
  * 将所有目标代码链接到一个文件中

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
  * 执行target时，会用命令创建名为target的文件
  * 这样能够实现，如果文件更新（包括该文件不存在），才会执行该target
* 如果target有依赖，会根据依赖生成target，如果依赖发生变化，才会执行该target
  * 变化是通过：依赖文件的修改时间 比 target文件的修改时间 新 发现的
```shell
#需要置顶的配置
.DEFAULT_GOAL := <TARGET>   #设置默认的target，如果不指定，默认处理第一个不以 .开头的target
.PHONY := <TARGET>     #指定该target不是一个文件，这样即使target文件没有变化，target还是会执行

#定义变量
<VARIABLE> = <VALUE>

#定义target
<TARGET>: <DEPENDECE1> <DEPENDECE2> ...   #依赖的文件名（注意target就是 文件名），当依赖的文件存在时，才会执行该<TARGET>
    <SHELL_COMMAND>   #前面必须是tab键隔开的空格
                      #@<SHELL_COMMAND> 在前面加个@表示，不会打印出命令，只会打印结果
```
