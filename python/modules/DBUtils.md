# DBUtils

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [DBUtils](#dbutils)
    - [使用](#使用)
      - [1.创建连接池](#1创建连接池)
      - [2.使用连接池](#2使用连接池)

<!-- /code_chunk_output -->

### 使用

#### 1.创建连接池
```python
from DBUtils.PooledDB import PooledDB

db_pool = PooledDB(
    creator = pymysql,         #使用的数据库模块
    maxconnections = <NUM>,    #最大连接数，0表示不限制
    mincached = <NUM>,         #最小空闲连接数
    maxcached = <NUM>,         #最大空闲连接数，0表示不限制
    blocking = True,           #连接池中没有连接可用时，是否等待，如果不等待会报错
    maxusage = None,           #一个连接可以被重复使用多少次，None表示不限制
    setsession = [],           #开始会话前执行的命令列表。如：["set datestyle to ...", "set time zone ..."]
    ping = 0,                  #0表示不检测连接是否可用，用的时候如果不可用会报错                  #1表示当需要的时候检测，...，4表示一直检测
    host = "",
    port = 3306,
    user = "",
    password = "",
    database = "",
    charset = "utf8"
)
```

#### 2.使用连接池
````python
conn = db_pool.connection()
cursor = conn.cursor()

conn.close()         #这里的close是把连接还回连接池
```
