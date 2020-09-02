[toc]
### stree-ng
#### 1.模拟高负载
* 原理：创建多个进程，争抢cpu
```shell
stress-ng -c <核数>     #核数如果为4，则会创建4个进程，每个进程用满一个核
```

#### 2.模拟高内存
* 原理：持续运行`malloc()`和`free()`
* 注意：
  * 当设置的一个进程消耗的内存过高时，则不能耗尽内存，需要再起一个
```shell
stress-ng -m <NUM> --vm-bytes <BYTES> --vm-keep   
#-m表示开启多少个进程，每个进程消耗那么多vm
#--vm-keep就是占用内存，不重新分配
```
#### 3.模拟高I/O（测试文件系统）
* 原理：持续写、读和删除临时文件
```shell
stress-ng -d <NUM> --hdd-write-size <BYTES> -i <NUM>
#-d：开启<NUM>个负责，执行读、写和删除临时文件
#--hdd-write-size每个负载写的数据量
#-i：开启<NUM>个负载，执行sync()
```
