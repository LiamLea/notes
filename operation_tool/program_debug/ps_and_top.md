
### `ps`和`top`

#### 1.查看线程信息
```shell
ps -eLf
ps -Lf -p <PID>
top -H <PID>

#LWP：light-weight process
#NLWP：number of light-weight process
```

#### 2.相关指标
##### （1）`STAT`
```shell
R     #running
S     #interruptable sleeping

D     #disk，uninterruptable sleeping
      #处于不可中断的后台进程不能被kill掉（前台的可以被kill）

T     #stopped
Z     #zombie

+     #前台数据
l     #多线程进程
N     #低优先级进程
<     #高优先级进程
s     #session leader
```

##### （2）`%CPU`
当为100%时，表示该进程使用1个CPU
当为50%时，表示该进程使用0.5个CPU
```shell
(process CPU time / process duration) * 100

#process CPU time，进程使用cpu的时长
#process duration，进程运行的时长
#所有进程的cpu使用率，加起来应该 = CPU数 * 100
```
