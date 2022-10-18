
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [基础内容](#基础内容)
  - [1.set](#1set)
  - [2.预置变量](#2预置变量)
  - [3.设置命令的超时时间：`timeout`](#3设置命令的超时时间timeout)
  - [4.重定向](#4重定向)
    - [（1）概述](#1概述)
    - [（2）重定向](#2重定向)
    - [（3）高级重定向](#3高级重定向)
    - [（4）永久重定向](#4永久重定向)
  - [4.查看用户登录信息](#4查看用户登录信息)
  - [6.连接相关](#6连接相关)
    - [（1）查看文件是否是硬连接](#1查看文件是否是硬连接)
    - [（2）查找一个文件的所有硬连接](#2查找一个文件的所有硬连接)
    - [（3）查看是否在链接的目录中](#3查看是否在链接的目录中)
  - [7.查看时区](#7查看时区)
  - [8.在shell中建立tcp连接](#8在shell中建立tcp连接)
  - [9.查看和设置系统支持的字符集](#9查看和设置系统支持的字符集)
  - [10.getent：查找相关信息（包括域名解析等），特别通用的命令](#10getent查找相关信息包括域名解析等特别通用的命令)
    - [（1）常用database类型](#1常用database类型)
  - [11.for后面只有一个变量名，表示遍历位置参数](#11for后面只有一个变量名表示遍历位置参数)
  - [12.非交互式执行命令，当需要多次输入，可以利用如下方式实现：](#12非交互式执行命令当需要多次输入可以利用如下方式实现)
  - [13.以指定用户身份执行命令](#13以指定用户身份执行命令)
  - [14.find 去除指定目录](#14find-去除指定目录)
  - [15.替换字符串](#15替换字符串)
  - [16.查看一个文件是否有硬连接](#16查看一个文件是否有硬连接)
  - [17. 截断一个 正被使用的 文件](#17-截断一个-正被使用的-文件)
  - [18.查看系统支持的字符集](#18查看系统支持的字符集)
  - [19.`getconf` —— 获取系统的变量](#19getconf-获取系统的变量)
  - [20.kill父进程和其所有的子进程](#20kill父进程和其所有的子进程)
  - [21.强制卸载某个文件系统](#21强制卸载某个文件系统)
  - [22.base64](#22base64)

<!-- /code_chunk_output -->

### 基础内容

shell中 `--` 表示选项的结束，即后面的都当参数处理

#### 1.set
```shell
set [-+选项] [-o 选项] [参数]

#常用选项
  -x	   #用于脚本调试
  -e	   #只要脚本中的一个命令执行失败，立马退出

set -- arg1 #即重置此shell的位置参数（$1=arg1）
```

#### 2.预置变量
|变量|说明|
|-|-|
|$$|Shell本身的PID（ProcessID）|
|$!|Shell最后运行的后台Process的PID|
|$?|最后运行的命令的结束代码（返回值）|
|$-|使用Set命令设定的Flag一览|
|$*|所有参数列表。如"\$*"用「"」括起来的情况、以"\$1 \$2 … \$n"的形式输出所有参数|
|$@|所有参数列表。如"\$@"用「"」括起来的情况、以"\$1" "\$2" … "\$n" 的形式输出所有参数|
|$#|添加到Shell的参数个数|
|$0|Shell本身的文件名|
|\$1～$n|添加到Shell的各参数值。\$1是第1参数、\$2是第2参数|

#### 3.设置命令的超时时间：`timeout`
```shell
timeout <sec> <COMMAND>
```

#### 4.重定向
说明：
* [xx] 表示需要替换的变量
* [FILE] 表示文件名
##### （1）概述
* 每个进程有3三基本的文件描述符

  |文件描述符|说明|指向的文件|
  |-|-|-|
  |0|标准输入|/dev/pts/0|
  |1|标准输出|/dev/pts/0|
  |2|标准错误输出|/dev/pts/0|
* 重定向，就是将**文件描述符**与**另一个文件** **相关联**

##### （2）重定向
输入重定向：`[FILE_DESCRIPTOR]< [FILE]`
输出重定向：`[FILE_DESCRIPTOR]> [FILE]`
常用：
* 标准输入重定向：`0< [FILE]`
* 标准输出重定向：`1> [FILE]`
* 标准错误输出重定向：`2> [FILE]`
* 标准输出和标准错误输出重定向： `&> [FILE]`

##### （3）高级重定向
`&`表示后面是一个文件描述符，而不是一个文件名
* 将文件描述符1复制文件描述符2，即文件描述符1指向文件描述符2所指向的文件
`[FILE_DESCRIPTOR_1]<& [FILE_DESCRIPTOR_2]`
等价于
`[FILE_DESCRIPTOR_1]>& [FILE_DESCRIPTOR_2]`

##### （4）永久重定向
`exec <REDIRECT>`

#### 4.查看用户登录信息
* 查看当前登录的用户
```shell
w
```
* 查看指定用户的登录记录
```shell
last <USER>
```
* 查看所有用户的登录状态（是否登陆过，上一次的登录时间）
```shell
lastlog
```

#### 6.连接相关
##### （1）查看文件是否是硬连接
```shell
stat <FILE>   #看Links字段
#或者
ll <FILE>     #看第二个字段
```
##### （2）查找一个文件的所有硬连接
```shell
find / -inum <NUMBER>    #<NUMBER>通过stat <FILE>命令中的Inode字段
```
##### （3）查看是否在链接的目录中
```shell
pwd         #显示逻辑路径，即在链接目录中的路径
pwd -P      #P:physical，显示真实的路径
```

#### 7.查看时区
```shell
date +"%Z %z"
```

#### 8.在shell中建立tcp连接
```shell
exec FD<>/dev/tcp/HOST/PORT		
#会在 /proc/self/fd/ 目录下生成一个描述符
```


#### 9.查看和设置系统支持的字符集
```shell
locale -a
```
设置字符集（必须是上面存在的）
```shell
export LANG="C.UTF-8"
```

#### 10.getent：查找相关信息（包括域名解析等），特别通用的命令
get entries，从管理员database中查看指定key的信息
```shell
getent <DATABASE> <KEY>
```

##### （1）常用database类型
* hosts
查看域名解析记录（包括hosts文件和DNS），会解析出域名对应的所有ip
```shell
getent hosts baidu.com
```

* services
查看server名和端口号对应关系
```shell
getent services
getent services 22
getent services ssh
```

* protocols
查看本系统支持的协议类型
```shell
getent protocols
getent protocols <协议号>
```

#### 11.for后面只有一个变量名，表示遍历位置参数
```shell
for xx                  
do
    echo $xx
done
```

#### 12.非交互式执行命令，当需要多次输入，可以利用如下方式实现：
```shell
  echo -e "xx\nxx" | passwd root
```

#### 13.以指定用户身份执行命令

* 且获得该用户的环境变量
```shell
su - 用户名 -c 命令
```

* 使用原用户的环境变量
```shell
su 用户 -c 命令
```  

#### 14.find 去除指定目录
```shell
find / -path '/tmp' -prune -o -iname 'test*' | grep -v '/tmp'

#跳过/tmp目录，这个执行的结果为false
#-o or
```

#### 15.替换字符串
```shell
  tr "xx" "xx"
```

#### 16.查看一个文件是否有硬连接
```shell
ll /etc/httpd/logs/error_log
#-rw-r--r-- 2 root root 18961 Jul 28 21:03 /etc/httpd/logs/error_log
#2代表有两个硬连接（加上本身）

stat /etc/httpd/logs/error_log
#看Links字段
````

#### 17. 截断一个 正被使用的 文件

注意：不能直接删除该文件，即使删除也不会释放存储

* 可以通过gdb来清空
```shell
gdb -p <PID>
call ftruncate(<FD>,0)
```

* 用echo

```shell
echo > <FILE>
```

#### 18.查看系统支持的字符集
```shell
locale -a
```
设置字符集（**必须是上面存在的**）
```shell
export LANG="xx"
```

#### 19.`getconf` —— 获取系统的变量
```shell
getconf -a      #显示所有系统变量（比如 PAGESIZE，CLK_TCK等)
#CLK_TCK这个变量用于计量与cpu有关的时间，标识一秒内cpu有多少次滴答（ticks）

getconf xx    #显示具体变量的值
```

#### 20.kill父进程和其所有的子进程
```shell
kill -- -<PPID>
```

#### 21.强制卸载某个文件系统
```shell
umount -f <PATH>
```

#### 22.base64

* base64编码
```shell
echo -n '<CONTENT>' | base64 -w 0    #wrap，0表示禁止换行
```
