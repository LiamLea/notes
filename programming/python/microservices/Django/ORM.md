# ORM(object relation model)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ORM(object relation model)](#ormobject-relation-model)
    - [概述](#概述)
      - [1.功能](#1功能)
      - [2.特点](#2特点)
      - [3.创建表](#3创建表)
      - [4.操作数据行](#4操作数据行)
      - [5.反向操作](#5反向操作)
      - [6.可以取到的数据类型](#6可以取到的数据类型)
      - [7.写原生SQL语句](#7写原生sql语句)

<!-- /code_chunk_output -->

### 概述
#### 1.功能
* 操作表
  * 添加
  * 删除
  * 修改
* 操作数据行
  * 增删改查
#### 2.特点
* ORM使用第三方工具连接数据库
所以需要在**settings**中设置ORM连接mysql的方式

#### 3.创建表
```python
from django.db import models

#一个类对应一个模型，一个模型对应一个表
#必须继承models.Model这个类
#如果类中不明确创建一个自增字段，则会自动创建一个名为"id"的自增字段
class UserInfo(models.Model):   

    #创建"id"字段，AutoFiled代表这个字段为自增字段，类型为int
    id = models.AutoFiled(primary_key = True)

    #创建“username”字段。类型：char(32)
    username = models.CharFiled(max_length = 32)

    #创建”group_id"字段，使用Group表作为外键
    #group这个属性就代表Group表中的 一行数据
    group = models.ForeginKey("Group")

class Group(models.Model):
    #会默认创建"id"字段，自增
    groupname = models.CharFiled(max_length = 32)
```
```shell
python manage.py makemigrations    #生成model（模型）
python manage.py migrate           #根据模型创建表
```
#### 4.操作数据行
```python
from app01 import models

models.UserInfo.objects.create(username = "liyi", class_id = 1)   
#注意不能写class，因为创建的字段名是class_id

#返回一个列表，列表中的每一项是这个类的实例
user_list = models.UserInfo.objects.all()     
#user_list = models.UserInfo.objects.filter(id = 1)
#user_list = models.UserInfo.object.filter(id__gt = 1)

for row in user_list:
    print(row.username, row.class_id)

models.UserInfo.objects.filter(id = 1).delete()

models.UserInfo.objects.filter(id = 1).update(username = "lier")
```

#### 5.反向操作
可以根据Group查询到UserInfo表的信息
```python
group = Group.objects.all().first()   #取出Group表中的一行数据
for row in group.userinfo_set.all():   #查询UserInfo表中与该行数据关联的行
    print(row.username)
```

#### 6.可以取到的数据类型
> all()函数可以换成filter()函数
* 一个对象（类的实例）
```python
user = UserInfo.objects.all().first()
```
* Query_Set，对象的列表
```python
user_list = UserInfo.objects.all()
```
* 字典
```python
user_dict = UserInfo.objects.all().values("id", "name")

#{
# "id": "xx",
# "name": "xx"
#}
```
* 元组
```python
user_list = UserInfo.objects.all().values_list("id", "name")

#(1, "liyi")
#(2, "lier")
```

#### 7.写原生SQL语句
```python
from django.db import connections

cursor = connections["数据源名称"].cursor()
cursor.execte("xx")
rows = cursor.fetchall()
```
