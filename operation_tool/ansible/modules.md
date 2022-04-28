[toc]

### 概述

#### 1.collections（管理模块）

##### （1）介绍
collections是ansible管理modules的新的方式，即会分类进行管理，比如有以下类别：
* ansible.builtin这个collection存放内置的模块，比如：copy、file等模块
* Community.Kubernetes这个collection存放kubernetes相关的模块，比如：helm模块
  * 使用：`community.kubernetes.helm`

##### （2）利用ansible-galaxy管理collections
```shell
ansible-galaxy collection install <coleection_name> -p <install_path>

#查看其中某个模块的使用，比如：
ansible-doc community.kubernetes.helm
```

##### （3）collections搜索路径
默认：`~/.ansible/collections`
设置搜索路径：`ansible.cfg`
```shell
[defaults]
collections_paths = <PATH>
```

#### 2.查看模块详情
列出所有模块：`ansible-doc -l`
查看具体模块的用法：`ansible-doc <MODULE>`
查看具体模块的参数：`ansible-doc -s <MODULE>`（s：snippet）

***

### 工具模块

#### 1.meta（能够影响ansible内部执行和状态）
```yaml
meta: <META_TASKS>
```
5个meta tasks：
* flush_handlers
  表示立即执行前面已经完成的task对应的handler，而不是等所有tasks执行完后，才执行handers
</br>
* end_host
  * 已成功的形式退出当前主机的playbook（2.8版本才支持）
  * 不要用end_play，会退出所有主机的playbook

#### 2.fail
```yaml
fail: msg="xx"      #已失败的形式退出playbook
```

#### 3.set_fact（在任务运行时，设置变量）
能够修改跟主机相关的变量（比如在hosts文件中设置的变量），无法修改全局变量（比如通过-e引入的变量）
```yaml
set_fact:
  <VARIABLE>: <VALUE>
```

***

### 调试模块
#### 1.ping
不是真正的ping,测试ssh的连通性

#### 2.debug
```yaml
debug:
  msg: <STRING>
```

#### 3.setup     
统计目标主机的信息
用setup可以查出内置变量
```yaml
setup:
  filter: <KEY>         #过滤某项信息,以JSON格式显示
```

***
### 命令模块
#### 1.shell     
远程开启bash执行命令
```yaml
shell: <COMMAND>      #这里可以填：| ,下面就可以写多行命令（相当于脚本）
args:                     #args在命令之前执行
  chdir: <WORKDIR>
  stdin: <INPUT>
  executable: <SHELL>     #比如：/bin/bash
```

* 返回的内容
  |key|说明|
  |-|-|
  |cmd|执行的命令|
  |delta|命令执行时间|
  |start|命令开始时间|
  |end|命令结束时间|
  |rc|返回值|
  |stdout|标准输出|
  |stdout_lines|以行划分，返回一个列表|
  |stderr|标准错误输出|
  |stderr_lines||


#### 2.script    
在远程执行脚本,不局限于shell
```yaml
script: <SCRIPT>
args:
  chdir: <WORKDIR>
  executable: <Invoker>     #调用者，可以是python3、/bin/bash等
```

#### 3.expect（能够响应 需要输入的语句）
```yaml
expect:
  command: <COMMAND>
  responses:
    (?i)<PROMPT>: <INPUT>     #根据提示，回复响应
                              #(?!)表示忽略大小写
```
比如:
```shell
$ passwd root
New password:
Retype new password:
```
```yaml
exepect:
  command: passwd root
  responses:
    (?i)password: 123456
```

***

### 系统模块
#### 1.service
```yaml
service:
  name: <SERVICE>
  state: <STATE>        #reloaded、restarted、started、stopped
  enabled: <BOOLEAN>    #是否开机自启
```

#### 2.user
```yaml
user:
  name: xx
  state: xx       #present和absent
```

#### 3.reboot
```yaml
reboot:
  reboot_timeout: <int | default=600>   #等待机器重启的时间，默认是600s   
```

#### 4.selinux
```yaml
selinux:
  state: disabled
```

##### 5.sysctl
```yaml
sysctl:
  name: <KEY>
  value: <VALUE>
  sysctl_file: <default=/etc/sysctl.conf>
  state: <present or absent>
  reload: <BOOL | default=yes> #相当于sysctl -p
```

***

### 包管理模块
#### 1.yum
```yaml
yum:
  name: <PACKAGE>
  state: <STATE>      #present（当指定版本时，用present）、latest（安装最新的包）、absent
```

***

### 文件模块

#### 1.copy
```yaml
#src:若路径以"/"结尾,则表示复制目录的内容,若不以"/"结尾,则复制该文件夹
copy:
  #可以用content: <STRING>代替src，即把具体的内容复制到dest
  src: <SRC>
  dest: <DEST>  
  force: <BOOLEAN>    #默认是yes，即会覆盖
  owner: <USER>       #新的文件的属性
  group: <GROUP>
  mode: 0644          #必须已0开始，后面的xx才表示八进制数
```
会返回状态值（表明是否拷贝成功）

#### 2.stat（获取文件的信息）
```yaml
stat:
  path: <PATH>
register: <VARIABLE_NAME>     

#返回的是一组变量（xx.stat）
#xx.stat.exists返回一个bool值，判断该文件是否存在，当不存在时也只有这个变量
#xx.stat.isdir返回一个bool值，判断该文件是否是个目录
```

#### 3.file（对文件进行操作：创建，修改属性等等）
```yaml
file:
  path: <PATH>      #指明文件
  state: <STATE>    #dirctory（创建目录），touch（创建文件），absent（删除文件）
                    #如果文件已存在，则不会覆盖
  owner: <USER>
  group: <GROUP>
  mode: 0664        #必须已0开始，后面的xx才表示八进制数
```

#### 4.unarchive
```yaml
unarchive:
  src: <SRC>              #压缩包
  dest: <DEST>            #目录
  remote_src: <BOOLEAN>   #默认为no，即src为本地路径
                          #如果为yes，表示src为目标主机上的路径
```

#### 5.template
* jinja2模板
* ansible会渲染该模板，然后把渲染后的结果发到dest
```yaml
template:
  src: <PATH>           #模板的位置
  dest: <PATH>
  owner: <USER>
  group: <GROUP>
  mode: 0644            #必须已0开始，后面的xx才表示八进制数
```

#### 6.lineinfile
对文件进行 行操作
```yaml
lineinfile:
  path: <PATH>         

  state: <STATE>        #present（默认）和absent
  inserafter: <REGEX>   #匹配<REHEX>，在后面插入
                        #当为EOF，表示在文件末尾插入

  regexp: <REGEX>       #匹配<REHEX>，进行替换

  line: <STRING>
```

#### 7.blockinfile
对文件进行 多行操作
```yaml
blockinfile:
  path: <PATH>
  inserafter: <REGEX>   #当为EOF，表示在文件末尾插入
  block: |
    ...
    ...
```

***

### kubernetes相关模块

debug方式：通过ansible -vvv获取执行的helm命令，然后去目标机上执行，能够看出报错，
如果不这样，直接看ansible的报错，看不出原因

#### 1.helm
```yaml
kubernetes.core.helm:
  chart_ref: <path> #会先在本地寻找，然后会在url中寻找
  chart_repo_url: <url>
  chart_version: <version>
  release_name: <name>
  release_namespace: <namespace>
  create_namespace: yes #默认为no
  atomic: yes   #默认为no，如果未安装成功，不会发生任何更改
  release_values: {}  #设置values.yaml中某些key的值
#注意不能使用kafka.host这样设置变量
#必须这样：
#release_values：
#  kafka:
#    host: 3.1.5.19
#    port: 19092
```
