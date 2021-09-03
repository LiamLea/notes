# systemd

[toc]

### 概述

![](./imgs/systemd_01.png)

#### 1.systemd新特性
* 系统引导时,服务并行启动
* 按需激活
* 指定依赖关系，从而能够控制启动顺序

#### 2.systemd units

|unit类型|扩展名|描述|
|-|-|-|
|service|`.service`|定义系统服务（用于控制进程）|
|socket|`.socket`||
|timer|`.timer`||
|target|`.target`|一系列unit的集合|
|device|`.device`||
|mount|`.mount`||
|automount|`.automount`|
|swap|`.swap`||
|path|`.path`||
|slice|`.slice`||
|scope|`.scope`||

#### 3.systemd units文件位置
|目录|说明|
|-|-|
|`/etc/systemd/system/`（优先级最高）|通常存放一下链接文件，链接到`/usr/lib/systemd/system/`目录中的unit文件|
|`/usr/lib/systemd/system/`|systemd units文件存放位置|
|`/run/systemd/system/`|运行时创建的unit文件|

#### 4.unit的依赖关系和启动顺序

##### （1）定义启动顺序：`After`、`Before`
当多个unit同时启动，就会根据这个两个参数设置的顺序，启动unit

##### （2）定义强依赖：`Requires`、`Requisite`
* 常常与`After`一起使用
* `Requires`
  * `Requires`指定的units和当前unit，**同时启动**，如果`Requires`指定的units中的某个启动失败，则当前unit也会失败
  * 如果`Requires`指定的units中的某个显示地被停止，则该unit也会被停止
* `Requisite`与`Requires`类似
  * 当启动此unit时，`Requisite`指定的units必须已经启动成功，否则此unit会失败

##### （3）定义弱依赖：`Wants`
`Wants`指定的units和当前unit，同时启动，如果其中某个unit启动失败，不影响当前unit

#### 5.unit模板（`<unit-name>@.<unit-type>`）
可以根据该模板，创建多个实例
该模板中可以使用相关变量（比如：`%i`表示实例的名称）
```shell
systemctl start <unit-name>@<instance-name>.<unit-type>
systemctl status <unit-name>@<instance-name>.<unit-type>
```

#### 6.特殊目录
|目录|说明|
|-|-|
|`<unit-name>.<unit-type>.requires`目录下链接的unit文件|就相当于在`<unit-name>.<unit-type>`中`Requires=`指定的unit|
|`<unit-name>.<unit-type>.wants`目录下链接的unit文件|就相当于在`<unit-name>.<unit-type>`中`Wants=`指定的unit|
|`<unit-name>.<unit-type>.d`目录下的`xx.conf`文件|会补充主文件`<unit-name>.<unit-type>`中的配置|

***

### 使用

#### 1.unit文件结构

##### （1）`[Unit]`
参考文档：
* [systemd.unit](https://man7.org/linux/man-pages/man5/systemd.unit.5.html)

跟unit类型无关的通用配置，比如：描述信息、依赖信息

|常用配置项|说明|
|-|-|
|Description|描述信息|
|Documentation|参考文档信息|
|After|定义启动顺序|
|Requires|定义强依赖|
|Wants|定义弱依赖|

##### （2）`[<unit type>]`


##### （3）`[Install]`
参考文档：
* [systemd.unit](https://man7.org/linux/man-pages/man5/systemd.unit.5.html)

关于unit的安装信息（`systemctl enable`和`systemctl disable`）

|常用配置项|说明|
|-|-|
|`WantedBy=`|当enable该unit时，会在`WantedBy=`中列出的unit的`xx.wants/`目录下，创建该unit的链接，disable与之相反|
|`RequiredBy`|当enable该unit时，会在`RequiredBy=`中列出的unit的`xx.requires/`目录下，创建该unit的链接，disable与之相反|
|`Also`|当enable或disable该unit时，`Also`中列出的unit也会被enable或disable|


#### 2.`[service]`配置
参考文档：
* [systemd.service](https://man7.org/linux/man-pages/man5/systemd.service.5.html)
* [systemd.kill](https://man7.org/linux/man-pages/man5/systemd.kill.5.html)

|常用配置项（加粗为必须设置的）|说明|
|-|-|
|**Type**|服务启动类型|
|**ExecStart**|启动服务的命令，可以结合`ExecStartPre`和`ExecStartPost`一起使用|
|ExecStop|停止服务的命令，如果未设置会用`KillSignal`中设置的信号杀死所有进程，如果停止命令没有停止所有进程，剩下的进程根据`KillMode`的设置进行处理|
|ExecReload|重载服务的命令，常用：`/bin/kill -HUP $MAINPID`|
|Restart|服务的重启策略，常用：</br>`on-failure`，当服务异常退出时，则重启该服务|
|KillMode|unit停止后，剩余进程的处理方式，常用：</br>`mixed`表示向主进程和cgroup中的所有进程发送SIGTERM信号，即kill所有进程|
|PIDFile|pid文件位置（一般在`/run/`下），当type为`forking`时，建议指定，否则可能找不到相关进程的pid|

##### （1）Type的类型
|Type|说明|
|-|-|
|`simple`（默认）|当`ExecStart`进程启动后，则认为该服务启动成功|
|`forking`|当`ExecStart`进程调用了`fork()`且主进程退出，则认为该服务启动成功，且产生的子进程会作为该服务大的主进程|
|`oneshot`|一次性的（即该service是`static`的，不能enable），只会执行一次（比如：初始化脚本）|
|`dbus`|与`simple类似`，只不过进程获得了`BusName=`指定的D-bus名称之后，才认为该服务启动成功|
|`notify`|与`simple类似`，只不过通过`sd_notify()`发送了消息后，才认为该服务启动成功|
|`idle`|与`simple类似`，延迟启动服务，当系统idle或者延迟了一定时间|


#### 3.systemd target units

##### （1）跟系统运行有关的targets

|以前的运行级别|target units|说明|
|-|-|-|
|0|`runlevel0.target`或`poweroff.target`|关机|
|1|`runlevel1.target`或`rescue.target`|进入救援模式|
|2、3、4|`runlevel2.target`或`runlevel3.target`或`runlevel4.target`或`multi-user.target`|非图形化的多用户模式|
|5|`runlevel5.target`或`graphical.target`|图形化的多用户模式|
|6|`runlevel6.target`或`reboot.target`|重启|

* 获取当前默认的target（即`default.target`）
```shell
systemctl cat default.target
```

* 启动时进入某个target
```shell
#在bootup阶段，按e进行编辑
#在linux16那行最后添加

systemd.unit=xx.target

#ctrl+x
```

* 系统启动了切换到某个target
```shell
#isolate会启动这个target，并停止其他所有target
systemctl isolate xx.target
```

* 救援模式（`rescue.target`）和紧急模式（`emergency.target`）区别
  * 救援模式会挂载所有的文件系统
  * 紧急模式只会以只读的方式挂载跟文件系统

##### （2）普通targets
```shell
systemctl start xx.target
```
