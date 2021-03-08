# SQL Injection

[toc]

### 概述

#### 1.SQL injection
攻击者将SQL代码插入到参数中
比如：
```sql
select * from user where username='用户输入';

--用户输入的参数为：user1' and username = 'user2
select * from user where username='user1' and username = 'user2';
```

#### 2.SQL注入类型

##### （1）回显注入
查询结果会显示在前端

##### （2）盲注
查询结果不会显示在前端

***

### 攻击

#### 1.寻找注入点
* 回显 利用恒真和恒假进行测试
* 盲注 利用sleep语句等，观察是否有延迟，如果有延迟，代表存在SQL注入
```SQL
--正常查询，如果是回显，则前端会显示该user的信息
select * from user where userid='1';

--恒真测试
select * from use where userid='1' and '1'='1';

--恒假测试
select * from use where userid='1' and '1'='2';

--如果恒真能够得到正确的输出，恒假没有正确的输出，代表存在SQL注入
```

#### 2.进一步获取数据库信息
* 回显 利用相关查询语句获取表中的字段、列数等等
* 盲注 利用等于，从而一步步猜出相关信息（`select * from user where userid='1' and len(usr()=14`)

#### 3.实施注入
窃取或者修改数据库的数据

***

### 防护

#### 1.参数类型的严格限制
比如只允许用户输入数字

#### 2.参数长度的限制

#### 3.危险参数过滤
* 黑名单过滤
* 白名单过滤
* 参数转义（转义单引号、双引号等）
