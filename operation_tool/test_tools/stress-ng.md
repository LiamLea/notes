
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [stree-ng](#stree-ng)
  - [1.模拟高负载](#1模拟高负载)
  - [2.注意：旧版的stress-ng不会触发OOM](#2注意旧版的stress-ng不会触发oom)
  - [3.增加虚拟内存（通过`mmap()`系统调用）](#3增加虚拟内存通过mmap系统调用)
  - [4.模拟高内存（OOM且系统卡死）](#4模拟高内存oom且系统卡死)
  - [5.模拟高I/O（测试文件系统）](#5模拟高io测试文件系统)
  - [6.模拟大量进程](#6模拟大量进程)

<!-- /code_chunk_output -->

### stree-ng

#### 1.模拟高负载
* 原理：创建多个进程，争抢cpu
```shell
stress-ng -c <num> -l <num>
# -c指定核数
# -l指定每个核用百分之多少
# stress-ng -c 4 -l 50
```

#### 2.注意：旧版的stress-ng不会触发OOM
当内存超了，会将旧的stress-ng停掉，然后重新跑一个新的进程
可以通过top命令观察pid看出来
新版的stress-ng支持`--oomable`选项，即可以触发OOM

#### 3.增加虚拟内存（通过`mmap()`系统调用）
注意：增加vm后，不一定能触发OOM，因为系统可能无法overcommit
```shell
stress-ng -m <NUM> --vm-bytes <BYTES> --vm-hang 3600   
#-m表示开启多少个进程，每个进程消耗那么多vm
#--vm-hang就是多久执行free
```

#### 4.模拟高内存（OOM且系统卡死）
```shell
stress-ng --oomable --brk 4 --stack 4 --bigheap 4
```

#### 5.模拟高I/O（测试文件系统）
* 原理：在当前目录下，持续写、读和删除临时文件
```shell
stress-ng -d <NUM> --hdd-write-size <BYTES> -i <NUM>
#-d：开启<NUM>个负责，执行读、写和删除临时文件
#--hdd-write-size每个负载写的数据量
#-i：开启<NUM>个负载，执行sync()
```

#### 6.模拟大量进程
```shell
stress-ng -c 500 -l 0
```
