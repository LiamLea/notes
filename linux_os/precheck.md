### 检查磁盘

#### 1.吞吐量
```shell
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync
```

#### 2.时延
```shell
dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync
```

* 或者使用ioping
```shell
ioping -W -y -s 4k .
```

* 或者使用fio
  * 观察fsync部分
  * 测出的延迟要小于dd命令测出的，因为dd那里只是粗略的测试，不只包含了sync操作，还有其他，比如write等
```shell
fio --rw=write --ioengine=sync --fdatasync=1 --size=22m --bs=2300 --name=mytest
```

#### 3.掉速

* 观测
```shell
iotop -o
```

* 不停写数据
```shell
stress-ng -d 8 --hdd-bytes 1M -i 4
```

* 观察 过几分钟是否掉速
