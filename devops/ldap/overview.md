# overview
[toc]
### 基础

#### 1.常用名词
##### （1）dc（domain component）
应该从右往左读，最右边为树的根
如：www.baidu.com -> dc=baidu,dc=com

##### （2）uid
用户id

##### （3）ou（organization unit）
组织单位，类似于linux文件系统中的**子目录**，是包含一组对象

##### （4）cn（common name）
通用名称

##### （5）sn（surname）
姓

##### （6）dn（distinguished name）
唯一的名称，类似于linux文件系统中的**绝对路径**
用于唯一标识一条记录

##### （7）rdn（relative dn）
相对唯一名称，类似于linux文件系统中的**相对路径**

##### （8）c（country）

##### （9）o（organization）

##### （10）objectClass
* objectClass是entry的一个属性
* 创建entry时需要指明objectClass
* 一个enry可以有多个objectClass
* objectClass指明了该entry是哪种类型（比如：groupOfNames，organizationUnit等），需要配置哪些属性（比如organizationUnit必须配置ou属性）

##### （11）schema
* Schema是LDAP的一个重要组成部分，类似于数据库的模式定义
* LDAP的Schema定义了LDAP目录所应遵循的结构和规则
比如一个 objectclass会有哪些属性，这些属性又是什么结构等等
* schema给LDAP服务器提供了LDAP目录中类别，属性等信息的**识别方式**
  让这些 可以被LDAP服务器识别

#### 2.ldap目录结构
```plantuml
cloud "ldap目录服务" as a
database "目录数据库" as b
frame "目录信息树（DIT）" as c
card "条目（entry）" as d
a->b:"存储"
b->c:"存储结构"
c->d:"组成元素"
note bottom of d:条目是具有唯一标识（DN)的 属性-值 对 的集合
```

#### 3.BaseDN
* 是一个目录树的**访问点**，即**只能访问该点及其以下的内容**
* 当其他软件配置ldap时，需要设置basedn，指明使用哪个目录下的内容

#### 4.Entry（条目）
* 每个条目都一个DN，用于唯一标识该条目，用于检索该条目

#### 5.有两类属性
* 用户属性
创建条目时指定的属性
</br>
* 操作属性
比如条目的创建时间、修改时间、memberof等等

#### 6.有四类搜索区域（scope）
* base
  * 只匹配DN本身这一个条目
</br>
* one（one-level，一级）
  * 匹配 以DN为父目录 的条目（不包括DN）
</br>
* subtress（默认）
  * 匹配 DN下面的所有条目（包括DN）
</br>
* children
  * 匹配 DN下面的所有条目（不包括DN）

#### 7.LDIF（ldap data interchange format，ldap数据交换格式）
（1）基本的格式
```shell
属性: 属性值
```
（2）用空行分隔条目
（3）注释行以#开头
（4）若以空格开头，表示该行接着上面一行
（5）每行的结尾不允许有空格
（6）属性可以被重复赋值
