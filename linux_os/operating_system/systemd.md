# systemd

[toc]

### 概述

![](./imgs/systemd_01.png)

#### 1.systemd新特性
* 系统引导时,服务并行启动
* 按需激活（通过`<unit-name>.socket`实现）
  * 首先启动`<unit-name>.socket`，会创建一个socket
  * 当有请求到达该socket，会启动`<unit-name>.service`或者`<unit-name>@.socket`，并且把这个socket传递传递给service
* 指定依赖关系，从而能够控制启动顺序

#### 2.systemd units

|unit类型|扩展名|描述|
|-|-|-|
|service|`.service`|封装后台服务进程|
|socket|`.socket`|封装socket|
|timer|`.timer`|封装一个基于时间触发的动作|
|target|`.target`|一系列unit的集合|
|device|`.device`|封装一个设备文件|
|mount|`.mount`|封装一个 文件系统 挂载点|
|automount|`.automount`|封装一个 文件系统 自动挂载点|
|swap|`.swap`|封装一个交换分区或交换文件|
|path|`.path`|用于根据文件系统上特定对象的变化来启动其他服务|
|slice|`.slice`|用于控制特定 CGroup 内(例如一组 service 与 scope 单元)所有进程的总体资源占用|
|scope|`.scope`|它与 service 单元类似，但是由 systemd 根据 D-bus 接口接收到的信息自动创建， 可用于管理外部创建的进程|

##### （1）socket unit：`<unit-name>.socket`
可用于实现服务的 按需启动
* 首先启动`<unit-name>.socket`，会创建一个socket，会监听在某个端口，用于接收请求数据
* 当有请求到达该socket，会启动`<unit-name>.service`或者`<unit-name>@.socket`，并且把这个socket传递传递给service
  * 所以该service必须有能够接收systemd传递的socket的能力（即实现systemd的相关接口）

#### 3.systemd units文件位置
|目录|说明|
|-|-|
|`/etc/systemd/system/`（优先级最高）|通常存放一下链接文件，链接到`/usr/lib/systemd/system/`目录中的unit文件|
|`/run/systemd/system/`（优先级较高）|运行时创建的unit文件|
|`/usr/lib/systemd/system/`|systemd units文件存放位置|


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

##### （4）隐含依赖
* 当service的Type=dbus时，有隐含依赖：
  * `Requires=dbus.socket`和`After=dbus.socket`
* 当service有同名的socket，则该service会隐含依赖该socket

#### 5.unit模板（`<unit-name>@.<unit-type>`）
可以根据该模板，创建多个实例
该模板中可以使用相关变量（比如：`%i`表示实例的名称）
```shell
#创建实例
systemctl start <unit-name>@<instance-name>.<unit-type>
```

#### 6.特殊目录
|目录|说明|
|-|-|
|`<unit-name>.<unit-type>.requires/`下的unit链接文件|就相当于在`<unit-name>.<unit-type>`中`Requires=`指定的unit|
|`<unit-name>.<unit-type>.wants/`下unit链接文件|就相当于在`<unit-name>.<unit-type>`中`Wants=`指定的unit|
|`<unit-name>.<unit-type>.d/`下的`xx.conf`文件|会补充主文件`<unit-name>.<unit-type>`中的配置|

#### 7.unit日志
参考log.md中systemd-log部分

##### （1）查看某个unit的日志
```shell
journalctl -u <unit>
```

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


##### （3）`[Install]`（没有这个，service就是`static`的，不能enable）
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
|**ExecStart**|启动服务的命令（必须是绝对路径），可以结合`ExecStartPre`和`ExecStartPost`一起使用|
|ExecStop|停止服务的命令，如果未设置会用`KillSignal`中设置的信号杀死所有进程，如果停止命令没有停止所有进程，剩下的进程根据`KillMode`的设置进行处理|
|ExecReload|重载服务的命令，常用：`/bin/kill -HUP $MAINPID`|
|Restart|服务的重启策略，常用：</br>`on-failure`，当服务异常退出时，则重启该服务|
|KillMode|unit停止后，剩余进程的处理方式，常用：</br>`mixed`表示向主进程和cgroup中的所有进程发送SIGTERM信号，即kill所有进程|
|PIDFile|pid文件位置（一般在`/run/`下），当type为`forking`时，建议指定，否则可能找不到相关进程的pid|

##### （1）Type的类型
需要根据程序的具体启动形式，选择合适的Type
* 比如`nginx -d`必须使用forking形式

|Type|说明|
|-|-|
|`simple`（默认）|当`ExecStart`进程启动后，则认为该服务启动成功|
|`forking`|用于**会将自身切换到后台**的服务（比如：`nginx -d`命令）</br>当`ExecStart`进程调用了`fork()`且主进程退出，则认为该服务启动成功，且产生的子进程会作为该服务大的主进程|
|`oneshot`|一次性的，只有当进程执行完才认为服务启动成功（比如：初始化脚本），如果进程一直在运行，则该服务一直处于activating状态|
|`dbus`|用于需要在 D-Bus 系统总线上注册一个名字的服务</br>与`simple类似`，只不过进程获得了`BusName=`指定的D-bus名称之后，才认为该服务启动成功|
|`notify`|用于会向systemd发送启动成功信息的服务（如果该服务不发送，则服务一直处于activating状态，systemd不认为其启动成功）</br>与`simple类似`，只不过通过`sd_notify()`发送了消息后，才认为该服务启动成功|
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
