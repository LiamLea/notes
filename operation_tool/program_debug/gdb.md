[toc]
### gdb（GNU debugger）
#### 1.特点
* 可以进入正在执行的某个进程，进入后，进程就**暂停**在进入点

#### 2.基本使用
```shell
gdb -p <PID>      #进入某个进程
```

#### 3.gdb终端命令
利用两下\<Tab>可以查看有什么命令
```shell
call <SYSCALL>      #调用系统调用
                    #man syscalls 或者 按两下tab 可以查看有哪些系统调用

show xx             #常用的有：
                    #   environment
                    #   paths
```
#### 4.利用gdb管理文件描述符
```shell
#关闭某个文件描述符
call close(<FD>)

#清空某个文件描述符（即清空文件，直接删除文件会影响程序）
call ftruncate(<FD>,0)
```
