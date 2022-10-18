# roles

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [roles](#roles)
    - [概述](#概述)
      - [1.基本概念](#1基本概念)
      - [2.角色的目录结构（下面的目录不是必须的）](#2角色的目录结构下面的目录不是必须的)
      - [3.roles的搜索路径在`ansible.cfg`中定义：](#3roles的搜索路径在ansiblecfg中定义)
    - [使用](#使用)
      - [1.playbook调用角色的三种方法](#1playbook调用角色的三种方法)
        - [（1）直接调用：](#1直接调用)
        - [（2）传递变量给role：](#2传递变量给role)
        - [（3）基于条件实现role调用：](#3基于条件实现role调用)
      - [ansible-glaxy命令（提供别人写好的role的网站）](#ansible-glaxy命令提供别人写好的role的网站)

<!-- /code_chunk_output -->

### 概述
#### 1.基本概念
一个角色，有自己的tasks,handlers等

#### 2.角色的目录结构（下面的目录不是必须的）
```shell
角色名/
  │
  ├── tasks/        #至少包含一个main.yml和具体的任务文件，用于说明调用哪些任务和调用的顺序
  │      └── main.yml   		
  │
  ├── files/       #存放由copy或script模块等调用的文件
  │      
  ├── templates/   #存放模板文件的目录
  │
  ├── vars/        #存放变量的目录，至少包含一个main.yml
  │		
  ├── handlers/    #至少包含一个main.yml   
  │		
  ├── meta/        #定义当前角色的特殊设定及其依赖关系,至少包含一个main.yml
  │
  └── defaults/    #设定默认变量时使用此目录中的main.yml文件，当使用变量时，其他地方找不到，最后会在此main.yml中寻找
```

#### 3.roles的搜索路径在`ansible.cfg`中定义：
如：
```shell
roles_path = roles:/opt/dire/purist/ansible:/opt/dire/kolla-ansible/ansible/roles:.
#在此路径下搜索相应的路径
```

***

### 使用

#### 1.playbook调用角色的三种方法

##### （1）直接调用：
```yaml
- hosts: websrvs
  remote_user: root
  roles:
    - mysql
    - memcached
    - nginx
```

##### （2）传递变量给role：
```yaml
- hosts:
  remote_user:
  roles:
    - { role: nginx, username: nginx }     #role用于指定角色名称；后续的k/v用于传递变量给角色
```

##### （3）基于条件实现role调用：
```yaml
roles:
  - { role: nginx, when: "ansible_distribution_major_version == '7' " }
```

#### ansible-glaxy命令（提供别人写好的role的网站）
```shell
ansible-glaxy role list            #列出存在的角色，搜索路径在ansible.cfg中定义了
ansible-glaxy role install 角色名   #从网站获得角色，安装在~/.ansible/roles/目录下
ansible-glaxy role remove 角色名
```
