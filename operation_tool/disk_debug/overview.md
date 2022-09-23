# overview

[toc]

### fio

[参考](https://www.ibm.com/cloud/blog/using-fio-to-tell-whether-your-storage-is-fast-enough-for-etcd)

```shell
fio --rw=write --ioengine=sync --fdatasync=1 --directory=test-data --size=22m --bs=2300 --name=mytest
```

```
mytest: (g=0): rw=write, bs=(R) 2300B-2300B, (W) 2300B-2300B, (T) 2300B-2300B, ioengine=sync, iodepth=1
fio-3.7
Starting 1 process
mytest: Laying out IO file (1 file / 22MiB)
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=238KiB/s][r=0,w=106 IOPS][eta 00m:00s]
mytest: (groupid=0, jobs=1): err= 0: pid=5017: Wed Sep 21 09:30:25 2022
  write: IOPS=75, BW=170KiB/s (174kB/s)(21.0MiB/132313msec)
    clat (usec): min=11, max=1599, avg=36.45, stdev=23.58
     lat (usec): min=13, max=1601, avg=39.32, stdev=24.22
    clat percentiles (usec):
     |  1.00th=[   15],  5.00th=[   19], 10.00th=[   22], 20.00th=[   24],
     | 30.00th=[   27], 40.00th=[   30], 50.00th=[   33], 60.00th=[   36],
     | 70.00th=[   39], 80.00th=[   45], 90.00th=[   57], 95.00th=[   70],
     | 99.00th=[  100], 99.50th=[  115], 99.90th=[  157], 99.95th=[  172],
     | 99.99th=[  506]
   bw (  KiB/s): min=    4, max=  265, per=100.00%, avg=172.11, stdev=48.49, samples=260
   iops        : min=    2, max=  118, avg=76.70, stdev=21.52, samples=260
  lat (usec)   : 20=7.01%, 50=78.29%, 100=13.68%, 250=1.00%, 750=0.01%
  lat (msec)   : 2=0.01%
  fsync/fdatasync/sync_file_range:
    sync (msec): min=4, max=2052, avg=13.13, stdev=26.04
    sync percentiles (msec):
     |  1.00th=[    5],  5.00th=[    6], 10.00th=[    7], 20.00th=[    8],
     | 30.00th=[    9], 40.00th=[   10], 50.00th=[   12], 60.00th=[   13],
     | 70.00th=[   14], 80.00th=[   17], 90.00th=[   20], 95.00th=[   24],
     | 99.00th=[   43], 99.50th=[   58], 99.90th=[  144], 99.95th=[  326],
     | 99.99th=[  953]
  cpu          : usr=0.26%, sys=1.02%, ctx=30827, majf=0, minf=31
  IO depths    : 1=200.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,10029,0,0 short=10029,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=170KiB/s (174kB/s), 170KiB/s-170KiB/s (174kB/s-174kB/s), io=21.0MiB (23.1MB), run=132313-132313msec

Disk stats (read/write):
    dm-0: ios=0/31567, merge=0/0, ticks=0/166079, in_queue=166083, util=97.68%, aggrios=0/23106, aggrmerge=0/1604, aggrticks=0/91754, aggrin_queue=6868, aggrutil=4.50%
  vdb: ios=0/24785, merge=0/3182, ticks=0/90045, in_queue=7513, util=4.50%
  vda: ios=0/21428, merge=0/27, ticks=0/93464, in_queue=6223, util=3.63%
```

* 需要关注的数据
  * wirte数据没什么意义，因为写入内存，所以比较快
  * fsync相关数据

***

### dd

#### 1.特点
* 用**指定大小的块**拷贝一个文件，并在拷贝的同时进行指定的**转换**
* 能够复制磁盘的分区、文件系统等
* 当block size设置合适时，读取效率很高

#### 2.命令
```shell
dd if=输入文件 of=输出文件

#参数
bs=xx         #一次I/O的大小（默认512B）
count=xx      #进行多少次I/O
```

* 设置转换整个文件的参数：conv

|参数|说明|
|-|-|
|fdatasync|操作文件完成（即每次dd命令结束前），同步数据到磁盘|
|fsync|操作文件完成，同步数据（包括元数据）到磁盘|

* 设置write操作（即write系统调用）的参数：oflag

|参数|说明|
|-|-|
|dsync|每次write同步数据到磁盘|
|sync|每次write同步数据（包括元数据）到磁盘|

#### 3.应用

##### (1) backup the entire disk or partition
```shell
#<path> should be another filesystem path in case the capacity isn't enough
#<file> can be a disk(such as /dev/sdb) or a file(such as xx.img)
dd if=/dev/sda of=<path>/<file>
#note: this also will copy the filesystem uuid，you need to generate uuid to use them at the same host
#xfs filesystem to generate new uuid: xfs_admin -U generate  /dev/sdc1
```

##### (2) format(clean) disk
```shell
dd if=/dev/zero of=/dev/sda
```

##### (3) convert data
```shell
dd if=/dev/sda of=<path>/<file> conv=noerror,sync
#the coomand use to copy disk even though there are some demanged blocks
#noerror - continue when encounter errors
#sync - used together with noerror and will patch demanged blocks with NULs
```

##### (4) test disk performance

相关概念和合理的值，查看linux_os/operating_system/basic/disk.md

* 测量throughout
```shell
#进行一次I/O，每次I/O大小为1G
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync
```
```
吞吐量为：60.7 MB/s，即每秒最多写60.7MB数据
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 17.6771 s, 60.7 MB/s
```

* 测试latency
```shell
#进行1000次I/O，每次I/O大小为512字节
dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync
```
```
延迟为0.85ms（0.85029s/1000），即一次 512字节 的请求，需要等0.85ms左右完成
1000+0 records in
1000+0 records out
512000 bytes (512 kB, 500 KiB) copied, 0.85029 s, 602 kB/s
```

***

### io相关

##### `iostat -dx 10`
* 说明
```
第一个report记录的是从开启到现在的一个统计指标，所以相关数据不能反应磁盘目前的状况
10 表示每10s输出一个report，后面输出的report能够反应磁盘目前的状况
```
* 输出结果（[参考](https://coderwall.com/p/utc42q/understanding-iostat)）
```shell
avgqu-sz（aqu-sz） 显示排队或正在服务的操作数（正常值：个位数、偶尔会有两位数）
r_await 读请求从发起到完成的平均时间（单位：ms）
w_await 写请求从发起到完成的平均时间（单位：ms）
%util 用于io的时间使用率（time spent doing I/Os，单位：百分比）（对于并行的设备：比如ssd、raid，这个值参考意义不大）
```


##### `iotop`
* 显示：
  * 所有线程的io情况
  * total DISK READ: 所有进程READ的总和
  * actual DISK READ：内核从磁盘中READ的总和（有可能和上面不相等，因为存在缓存等原因）

* 常用参数
```shell
#-p <pid>   显示指定的进程或线程
#-P         只显示进程（默认显示线程）
#-t         会加上时间戳

#-o只显示真正在做io的进程
iotop -P -o

#-b不进行交互，即将结果打印
#-n 5表示打印5次
iotop -P -b -n 5

#-a表示，统计累计值（即启动iotop，然后一直累计）
iotop -P -o -a
```
