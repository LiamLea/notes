# operation

[toc]

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
