# pymysql模块

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [pymysql模块](#pymysql模块)
    - [使用](#使用)
      - [操作数据库的步骤](#操作数据库的步骤)
      - [增加数据](#增加数据)
      - [查询数据](#查询数据)
      - [修改数据](#修改数据)
      - [删除数据](#删除数据)

<!-- /code_chunk_output -->

### 使用
#### 操作数据库的步骤
* 建立连接:
```python
conn = pymysql.connect(host = "<HOST>",
                       port = <INT>,
                       user = "<USER>",
                       password = "<PASSWD>",
                       databse = "DB",
                       charset = "utf8"
                      )
```
* 创建操作数据库的游标(相当于操作文件时的文件对象)
```python
cursor = conn.cursor()
```
* 通过游标执行sql语句
```python
cursor.execute("sql语句")
```
* 如果涉及对数据库的修改,需要执行commit
```python
conn.commit()
```
* 关闭游标,关闭连接
```python
cursor.close()
conn.close()
```
#### 增加数据
```python
insert = 'insert into table1 values(%s,%s)'
value1 = (10,'c')
value2 = [(1,'a'),(2,'b')]
cursor.execute(insert,value1)       #当只需要执行一次时
cursor.executemany(insert,value2)   #第二个参数为可迭代对象
```
#### 查询数据
```python
select = 'select * from table1'
cursor.execute(select)      #通过游标获得查询结果
cursor.fetchone()           #取出一条数据,取出后游标向下移动(类似于文件指针)
cursor.fetchmany(2)         #取出2条数据
cursor.fetchall()           #取出所有数据
```
#### 修改数据
```python
update = 'update table1 set xx=%s where xx=%s'
data = ('a','b')
cursor.execute(data)
```
#### 删除数据
```python
delete = 'delete from table1 where id=%s'
data = (6,)
cursor.execute(delete,data)
```
