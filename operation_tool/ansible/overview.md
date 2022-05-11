# overview

[toc]

### 概述

#### 1.配置文件查找顺序（匹配即停止）
* ANSIBLE_CONFIG变量定义的配置文件
* ./ansible.cfg
* ~/ansible.cfg
* /etc/ansible/ansible.cfg

#### 2.facts
* 在使用 Ansible 对远程主机执行任何一个 playbook 之前，总会先通过 setup 模块获取 facts，
* 并暂存在内存中，直至该 playbook 执行结束
* 有时候需要使用 facts 中的内容，这时候可以设置 facts 的缓存，在需要的时候直接读取缓存进行引用
* Ansible 的配置文件中可以修改 gathering 的值为 smart、implicit 或者 explicit。
  * smart 表示默认收集 facts，但 facts 已有的情况下不会收集，即 使用缓存 facts；
  * implicit 表示默认收集 facts，要禁止收集，必须使用`gather_facts: False`
  * explicit 则表示默认不收集，要显式收集，必须使用 gather_facts: Ture
* Ansible 支持两种 facts 缓存：redis 和 jsonfile

#### 3.变量（变量名不要使用：`-`符合）

#### （1）变量来源
* 外部变量
  ```shell
  -e <KEY=VALUE>
  -e @<FILE>    #文件可以是key=value格式的，也可以是json、yaml格式的
  ```
* 清单文件
* playbook内
* include的文件或roles
* 主机的Facts（ansible_facts.xx）
* special variable（即内置变量，不能被覆盖）
  常用的有：
  ```yaml
  {{groups}}                    #所有组的信息
  {{groups['all']}}             #列出所有主机
  {{group_names}}               #当前主机所在的组
  {{inventory_hostname}}        #当前主机的主机名
  {{inventory_hostname_short}}  #当前主机的主机名的第一部分
  {{hostvars['主机名']['xx']}}       #可以获得其他主机的变量，xx为主机名
  {{hostvars['xx']['ansible_facts']['xxx']}}    #所以需要有facts缓存，或者在此playbook中之前已与该主机进行过通信
  ```

#### （2）管理主机变量和组变量
* 通过host_vars目录管理主机变量
  |对应关系|对应关系|
  |-|-|
  |文件名（可以以.yml，.yaml或.json结尾）|主机名|
	|文件内容|该主机的变量|
	|目录名|主机名|
	|目录下的文件的内容（按字典顺序读取文件）|该主机的变量|

</br>

* 通过group_vars目录管理组变量
  |对应关系|对应关系|
  |-|-|
	|文件名（可以以.yml，.yaml或.json结尾）|组名|
	|文件内容|该组的变量|
	|目录名|组名|
	|目录下的文件的内容（按字典顺序读取文件）|该组的变量|

</br>

* host_vars和group_vars目录的搜索路径
  * 清单文件的所在目录
  * playbook文件的工作目录（比如：当import_playbook时，被import的playbook所在的目录也会被搜索）

#### （3）变量的优先级

[参考](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#understanding-variable-precedence)
```shell
-e > playbook里定义的 > host > child group > parent group > all group
-e > role的vars目录下定义的变量 > playbook里等定义的 > role的default目录下定义的变量
```

***
### 使用
#### 1.自定义配置文件
```shell
[defaults]
inventory = <INVENTORY>     #具体文件或者目录
host_key_checking = False   #连接托管主机时,不需要输入yes
library = <PATH>            #模块的搜索路径
collections_paths = <PATH>  #collections的搜索路径
```

#### 2.使用多个inventory
* 修改ansible.cfg（指定一个目录）
```shell
inventory = <DIRECTORY>     #指向一个目录
```
* 在清单目录下创建清单文件
  * 文件名随便取
  * 读取文件时，会按照文件名的**字母顺序**进行读取
  * 将所有的内容进行合并，**重复的内容会被后读取的覆盖**
#### 3.配置inventory文件
```shell
[组名]
<HOSTNAME>  ansible_host=<IP>  ansible_user=<USER> ansible_password=<PASSWD>  ansible_become_user=<SUDO_USER>  ansible_become_password=<SUDO_PASSWORD>
...
#ansible_become_user如果执行sudo，sudo到哪个用户
#ansible_become_password如果执行sudo，sudo到某个用户需要输入的密码
#
#给单主机设置,只需要在主机名后加参数即可
#
#给组设置
#[组名:vars]     //组名处可以写all,对所有组生效
#参数=xx
#...
#
#
#子组定义:
#[组名:children]    //该组会拥有下面组的所有主机
#组1
#组2
#...
```
#### 4.ansible命令
```shell
ansible 主机集合 命令集合
```
* 主机集合:
  * 组名或者主机名(多个内容逗号隔开)

* 命令集合:
  * `-m 模块名称 -a 模块参数`
  * `-i inventory文件路径`
  * 外部变量：`-e xx`
  * 列出要执行的主机名：`--list-hosts`
