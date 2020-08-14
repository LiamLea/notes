[toc]
### 基础内容
#### 1.set
```shell
set
    -x	   #用于脚本调试
    -e	   #只要脚本中的一个命令执行失败，立马退出
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

#### 5.awk高级用法
##### （1）将命令的输出存入变量
```shell
awk '{"<COMMAND>"|getline <VARIABLE_NAME>;print <VARIABLE_NAME>}' <FILE>

#<COMMAND>可以由位置变量组成，比如：
# ps -o pid ax | awk '{"readlink /proc/"$1"/exe"|getline a;print a}'
# awk '{"readlink /proc/22/exe"|getline a;print a}' <FILE>

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
