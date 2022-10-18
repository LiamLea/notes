# ACL

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ACL](#acl)
    - [概述](#概述)
      - [1.特点](#1特点)
      - [2.格式](#2格式)
      - [3.`<WHAT>`（目标，即访问该目标时进行权限控制）](#3what目标即访问该目标时进行权限控制)
        - [（1）基本选取的方式](#1基本选取的方式)
      - [4.`<WHO>`（指定被授权的用户，即该条目有相关权限）](#4who指定被授权的用户即该条目有相关权限)
      - [5.`<ACCESS_LEVEL>`（具体的权限）](#5access_level具体的权限)
      - [6.`<CONTROL>`（匹配后进行的动作）](#6control匹配后进行的动作)

<!-- /code_chunk_output -->

### 概述
#### 1.特点
* ACL的内容都是写在**配置数据库**中的
* **每一次**访问条目，都会进行ACL处理
* 处理时，按照**顺序**进行（顺序是由数字标识的）

#### 2.格式
```shell
olcAccess: {<NUMBER>}to <WHAT>            #NUMBER用于标识和排序（从0开始）
  by <WHO> <ACCESS_LEVEL> <CONTROL>     #以空格开头，表示该行接着上面
  by <WHO> <ACCESS_LEVEL> <CONTROL>
  ...
```

#### 3.`<WHAT>`（目标，即访问该目标时进行权限控制）
格式：
```shell
[<基本选取>][filter=<FILTER>][attrs=<ATTRIBUTES>]

#基本选取和filter用于过滤条目
#atrrs用于指定 具体属性 为目标
```
##### （1）基本选取的方式
* 通过区域选取目标
```shell
dn[.SCOPE]=<CN>
```
比如：
```shell
dn.subtress=ou=People,dc=cangoal,dc=com
#则目标就是，ou=People,dc=cangoal,dc=com下的所有条目及其自身
```

* 通过正则选取目标(比较复杂)
```shell
dn="^.*,uid=([^,]+),ou=users,(.*)$"
```

#### 4.`<WHO>`（指定被授权的用户，即该条目有相关权限）
* `*`
表示所有条目，包括匿名用户（用户）
* anonymous
非认证的用户（条目）
* Users
认证的用户（条目）
* self
该条目本身（即目标条目）

#### 5.`<ACCESS_LEVEL>`（具体的权限）
* none
无权限，拒绝访问
* auth
用于认证
比如：
```shell
olcAccess: {1}to dn.chilren="ou=users,dc=mydomain,dc=org" attrs=userPassword
  by * auth
#所有人都需要通过userPassword这个属性进行认证
```
* compare
比较属性的权限
* search
利用过滤条件搜索的权限
* read
读取搜索结果的权限
* write
更改条目属性的权限

#### 6.`<CONTROL>`（匹配后进行的动作）
* stop（默认）
匹配即停止
* continue
匹配完所有
* break
匹配后，跳出当前的子句进行后一个子句的检查
