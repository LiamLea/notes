# playbook
[toc]
### 概述
#### 1.基本格式
```yaml
- hosts: <HOSTS>
  remote_user: <USER>
  gather_facts: <BOOLEAN>
  become: <BOOLEAN>             #是否利用sudo切换身份

  tasks:
  - name: <NAME>
    <MODULE>: ...
```

#### 2.block（将多个tasks整合成一个）
* 实现某个条件成立时，能执行多个任务
* rescue与block连用，当block中的任务执行失败时，会执行rescue中的任务
* always与block连用，不管block的执行结果，都会执行

格式：
```yaml
tasks:
- block:
  - xx
  rescue:
  - xx
  always:
  - xx
```
例子：
```yaml
tasks:
- block:
  - copy:
    src: xx
    dest: xx
  - yum:
      name: xx
      state: xx
  when: 2>1

  resuce:
  - service:
      name: xx
      state: xx
  - debug:
      msg: "xx"
```

#### 3.`include*`和`import*`的比较

##### （1）`include*`			
动态加载，动态的好处就是可以在循环中多次加载执行
```yaml
include: xx           #当加载play列表时，这是一个play，之后会摒弃该模块
include_tasks: <TASK_PATH>       #是一个task
include_role:         #是一个task
  name: <ROLE_NAME>      
include_vars: xx      #是一个task
```
##### （2）`import*	`		
静态加载
```yaml
import_playbook: xx     #是一个play
import_tasks: xx        #是一个task
import_role: xx         #是一个task
```

##### （3）本质区别
* include*在被遇到时，才会处理，属于动态的加载
* import*在预处理时，就会被处理，属于静态的加载

##### （4）使用区别
|动态（include*）|静态（import*）|
|-|-|
|能够应用到循环中，没循环一次，会include一次||
|task选项（如when）不会被应用到子任务|对于静态的加载，task选项会被应用到子任务|
|不能在里面触发外面的handler|不能从外面触发里面的handler|

***

### 使用
#### 1.控制语句
##### （1）条件判断：`when`
* when使用的表达式是原生的jinja2表达式，所以变量不需要加双括号

* 当when中使用了or时，记得加括号
比如：
  ```yaml
  when: A or B and C          #只要A为真就不会判断后面
  when: (A or B) and C        #只有当A或B有一个为真且C为真，条件才成立
  ```

* 判断变量是否存在：`when: xx is definded`

* 判断某个值是否存在某个列表中
  ```yaml
  when: inventory_hostname in groups.<GROUP_NAME>
  ```

##### （2）触发器：`notify`和`handlers`
注意：默认所有tasks执行完，才会执行handlers中的任务，可以通过meta立即执行已经触发的handlers中的任务
```yaml
tasks:
  - name: <NAME>
    <MODULE>: ...
    notify: <TASK_NAME>

  #当该task执行成功且造成了实际的改变,会运行handlers中指定的task
  - name: reboot immediately
     meta: flush_handlers

  - name: <NAME>
    <MODULE>: ...

handlers:
  - name: <NAME>
    <MODULE>: ...
```

##### （3）循环：`with_items`
通过`{{item}}`获取每次迭代的值
```yaml
<MODULE>: ...
with_items: <LIST>
```
举例：
```yaml
 - user:
     name: {{item.name}}
     group: {{item.group}}
     password: {{{{item.pwd}} | password_hash('sha512')}}
   with_items:              
     - {name: "liyi", group: "admin", password: "123"}           
     - {name: "lier", group: "admin", password: "123"}
     - {name: "lisan", group: "admin", password: "123"}
```

* 遍历主机组
```yaml
- name: debug
  debug:
    msg: "{{ item }}"
  with_items: "{{ groups['tidb'] }}"
```

##### （4）循环：`until`
```yaml
...
register: xx
util: xx.rc != 0
delay: 10       #失败后等待多长时间再次执行
retries: 2      #重试的次数
```

#### 2.task通用语句
##### （1）错误处理：`ignore_errors`
```yaml
<MODULE>: ...
ignore_errors: True       #忽略错误继续执行,默认为False,不忽略错误
```

##### （2）打task标签：`tags`
```yaml
<MODULE>: ...
tags: <LABEL>
#ansible-playbook xx.yml -t <LABEL>    //执行指定标签的task
```

##### （3）获取task的返回结果：`register`
```yaml
<MODULE>: ...
register: <VARIABLE_NAME>     #则结果就会存在该变量中
```

##### （4）指定在具体主机上执行某个task：`deltegate_to`
```yaml
<MODULE>:
  ...
delegate_to: <HOSTNAME>   #主机名是在主机清单中定义的
                          #比如这里可以填：localhost
```

##### （5）设置某个task只执行一次
比如在具体主机上删除某个文件（只要执行一次即可），然后再创建
不需要每个主机执行的时候都去具体主机上删除一次，否则有些主机执行的慢，具体主机上刚刚创建出来又被删了，就会有问题
```yaml
<MODULE>:
  ...
run_once: True
```
