# sql

[toc]

### 概述

#### 1.sql模块
是golang的标准库，使用需要指定数据库驱动（比如mysql等），相当于又封装了一次，隐藏了使用的数据库

***

### 使用

#### 1.基本使用
```go
//create connection pool
//args:
//    driver name(for example：mysql)
//    database source(which is needed to connect to the database)
db, err := sql.Open("mysql", "user:password@/dbname")
```
