# sql

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [sql](#sql)
    - [概述](#概述)
      - [1.sql模块](#1sql模块)
    - [使用](#使用)
      - [1.基本使用](#1基本使用)

<!-- /code_chunk_output -->

### 概述

#### 1.sql模块
是golang的标准库，使用需要指定数据库驱动（比如mysql等），相当于又封装了一次，隐藏了使用的数据库

***

### 使用

#### 1.基本使用

```go
//define connection pool
var db *sql.DB
db.SetMaxOpenConns(10)
db.SetMaxIdleConns(5)
var err interface{}

//create connection pool
//args:
//    driver name(for example：mysql)
//    database source(which is needed to connect to the database)
db, err = sql.Open("mysql", "root:cangoal@tcp(3.1.4.220:64231)/test")
if err != nil {
  fmt.Println("open mysql failed", err)
  return
}

qstr := "select * from test;"
rows,err := db.Query(qstr)
if err != nil {
  fmt.Println("query failed", err)
  return
}

//release connection
defer rows.Close()

type user struct {
  name string
  age int
}
for rows.Next() {
  var u1 user
  rows.Scan(&u1.name, &u1.age)
}
```
