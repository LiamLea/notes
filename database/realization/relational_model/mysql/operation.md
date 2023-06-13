# operation

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [operation](#operation)
    - [基本使用](#基本使用)
      - [1.不进入数据库，获取所有配置](#1不进入数据库获取所有配置)
      - [2.查看连接情况](#2查看连接情况)
      - [3.查看内存使用情况](#3查看内存使用情况)
    - [操作json类型](#操作json类型)
      - [1.生成json类型数据的函数](#1生成json类型数据的函数)
        - [（1）生成数组：`json_array`](#1生成数组json_array)
        - [（2）生成字典：`json_object`](#2生成字典json_object)
        - [（3）生成字符串：`json_quote`](#3生成字符串json_quote)
      - [2.查询json数据](#2查询json数据)
        - [（1）`json_extract`](#1json_extract)

<!-- /code_chunk_output -->

### 基本使用

#### 1.不进入数据库，获取所有配置

```shell
mysqld <启动参数> --verbose --help
```

#### 2.查看连接情况
* 查看过往连接情况
```shell
show status like 'Con%'
```

* 查看当前连接情况
```shell
show status like 'Threads%';
show processlist;
```

#### 3.查看内存使用情况
```shell
show status like 'Innodb_page_size';  #默认16k

show status like 'Innodb_buffer_pool_pages%';
```

***

### 操作json类型

#### 1.生成json类型数据的函数

##### （1）生成数组：`json_array`

```mysql
SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());
```
```
+---------------------------------------------+

| JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME()) |

+---------------------------------------------+

| [1, "abc", null, true, "11:30:24.000000"]   |

+---------------------------------------------+
```

##### （2）生成字典：`json_object`
```mysql
SELECT JSON_OBJECT('id', 87, 'name', 'carrot');
```
```
+-----------------------------------------+

| JSON_OBJECT('id', 87, 'name', 'carrot') |

+-----------------------------------------+

| {"id": 87, "name": "carrot"}            |

+-----------------------------------------+
```

##### （3）生成字符串：`json_quote`
```mysql
SELECT JSON_QUOTE('null'), JSON_QUOTE('"null"'),
```
```
+--------------------+----------------------+

| JSON_QUOTE('null') | JSON_QUOTE('"null"') |

+--------------------+----------------------+

| "null"             | "\"null\""           |

+--------------------+----------------------+
```

#### 2.查询json数据

##### （1）`json_extract`
```python
json_extact(<FIELD>, '<JSON_PATH>')
#取出来的数据是有双引号的
```
下面三种方式等价：
* `JSON_UNQUOTE( JSON_EXTRACT(column, path) )`
* `JSON_UNQUOTE(column -> path)`
* `column->>path`
