### lsof（list open files）
#### 1.底层原理
基于进程的以下几个文件
`/proc/<PID>/exec`
`/proc/<PID>/cwd`
`/proc/<PID>/root`
`/proc/<PID>/fd/`
`/proc/<PID>/maps`

#### 2.列出所有当前打开的文件，输出的格式：
```shell
  COMMAND     #进程名称
  PID         #pid号
  USER        #进程所有者
  FD          #文件描述符的号码，或者代号：
#cwd：current working directory，即该应用程序启动的目录（需要结合根目录，才能确定该目录在系统的哪个位置）
#rtd：root directory，即根目录
#txt：programm text，即启动程序（如：/usr/bin/mysqld）
#mem：memory-mapped file，即加载到虚拟内存中的文件

  TYPE        #文件类型
#DIR：directory，即目录
#REG：regular file，即文件
#CHR：character special file，即字符设备
#BLK：block special file，即块设备

  DEVICE      #所在磁盘
  SIZE/OFF    #文件大小
  NODE        #索引节点
  NAME        #文件的名称
```
#### 3.选项
```shell
  文件名         #列出打开该文件的进程

  -c 进程名称    #查看该进程打开的文件（并非绝对的名称，COMMAND包含该名称）

  -p pid号      #列出某个进程打开的文件描述符

  -i [4或6] [protocol] [ip]:[port]     #列出与该端口有关的文件描述符（一般是套接字）

  +d 目录/      #列出该目录下被打开的文件的项

  +D 目录/      #类似+d，但是会递归子目录
```

#### 4.应用场景
* 查看进程打开的socket信息（注意：**只能查看所在的netns**）
```shell
lsof -i -a -p <PID>   #-a就是and
```
* 查看哪些进程在使用文件系统（利用+D选项）
* 查看某个文件被哪个进程使用
* 查看进程打开了哪些文件
