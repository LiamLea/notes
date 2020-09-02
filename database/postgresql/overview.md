# postgrelsql
[toc]

### 基本概念

#### 1.相关文件和目录
##### （1）数据目录
`/var/lib/pgsql/11/data`

##### （2）配置文件
`postgresql.conf`，一般在数据目录下

##### （3）hba（host-based authencation）配置文件
`pg_hba`，一般在数据目录下

##### （4）ident_file（用户名映射）
`pg_indent.conf`，一般在数据目录下


#### 1.安装注意事项
* 安装postgresql后会创建postgres用户和数据库
* postgres用户为该postgresql的管理员，所以只有切换为postgres用户才能操作postgresql数据库

***

### 基础操作

#### 1.登录postgres
* 以超级管理员身份登录
```shell
su - postgres
psql
```
* 普通登录
```shell
psql -h 主机ip -U 用户名 -d 数据库名
```

#### 2.创建操作
* 创建数据库
```shell
create database <DATABASSE>;
```

#### 3.查询
```shell
  \l            #list，显示所有的数据库
  \d            #display，显示所有的可见的table、view等
  \c xx         #connect，连接数据库、表等等

  \d *          #显示所有table、view等（即使不可见）
  \d *.*        #显示所有table、view等，及其里面的内容
```

#### 4.授权
**注意**：当导入表时，没有用指定用户的身份导入，权限可能有问题
```shell
su - postgres
psql xx           #进入某个数据库
grant all on all tables in schema public to xx      #这里xx为指定用户
```
