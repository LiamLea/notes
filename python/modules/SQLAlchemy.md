# SQLAlchemy

[toc]

### 概述

#### 1.架构图
![](./imgs/SQLAlchemy_01.png)

* Engine，框架引擎
* Connection Pooling，数据库连接池
* Dialect，选择连接数据库的DB API类型
* Schema/Types，架构和类型
* SQL Expression Language，SQL表达式语言


***

### 使用

#### 1.创建数据库 连接池
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

engine = create_engine(
    "mysql+pymysql://root:123@127.0.0.1:3306/aiops_db?charset=utf8",
    max_overflow = 2,       #连接池满时，最多再创建多少个连接
    pool_size = 5,          #连接池大小
    pool_timeout = 30,      #等待获取连接池中连接的时长，如果超时，则报错
    pool_recycle = 3600       #多久对连接池中的线程进行一次重置，-1表示不重置
)

Session = sessionmaker(bind = engine)

```

#### 2.获取连接 和 将连接放回连接池
```python
session = Session()

#执行相关操作

session.close()
```

#### 3.创建ORM（即类和表的对应关系）

##### （1）关联并创建表
```python
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String

Base = declarative_base()

class Users(Base):
    __tablename__ = "users"       #表名

    id = Column(Integer, primary_key = True)
    name = Column(String(32), index = True, nullable = False)
```

##### （2）与已有的表进行关联
```python
from sqlalchemy import Table
class Users(Base):
    __table__ = Table('<TABLE_NAME>', Base.metadata, autoload = True, autoload_with = engine)

#该类的属性就是表中的字段名
session = Session()
for obj in session.query(Users).all():
  print(obj.id)

```

#### 4.操作ORM（执行增删改查操作）

##### （1）创建所有表
```python
Base.metadata.create_all(engine)
```

##### （2）插入数据

* 插入一个数据
```python
obj = Users(name = "liyi")
session.add(obj)

session.commit()
```

* 批量插入数据
```python
session.add_all([
  Users(name = "liyi"),
  Users(name = "lier"),
  Users(name = "lisan")
])

session.commit()
```

##### （3）查询数据

* 查询全部
```python
user_list = session.query(Users).all()

for row in user_list:
  print(row.id)
  print(row.name)

#相当于select name from Users;
user_list = session.query(Users.name).all()
```

* 设置条件
```python
user_list = session.query(Users).filter(Users.id > 2).all()

#逗号表示and
user_list = session.query(Users).filter(Users.id > 2, Users.name == "liyi").all()

user_list = session.query(Users).filter(Users.id.between(1, 3)).all()

user_list = session.query(Users).filter(Users.id.in_([1, 3, 4])).all()

from sqlalchemy import and_, or_
user_list = session.query(Users).filter(and_(Users.id > 2, Users.name == "liyi")).all()

user_list = session.query(Users).filter(or_(Users.id > 2, Users.name == "liyi")).all()

#通配符
user_list = session.query(Users).filter( Users.name.like("li%")).all()

#限制
user_list = session.query(Users.name).all()[1:2]

#排序
user_list = session.query(Users).order_by(Users.name.desc()).all()
```

* 子查询（subquery）
将多个查询在一个查询中执行，比如将一个查询的结果用作另一个查询的条件
```python
subquery = session.query(Users).filter(Users.id > 2).subquery()

#在主查询中使用子查询的字段：subquery.c.字段名    （c代表Column）
xx_list = session.query(xx).filter(subquery.c.name == "liyi").all()
```


##### （4）删除数据
```python
session.query(Users).filter(Users.id > 2).delete()

session.commit()
```

##### （5）修改
```python
session.query(Users).filter(Users.id == 1).update({"name": "lier"})
session.commit()

#对于复杂的条件，不能在python中计算条件，需要先select结果到会话中，然后再进行修改
#通过synchronize_session参数设置（默认为"evaluate"，即再python中计算条件）
session.query(Users).filter(Users.id == 1).update({"name": "lier"}, synchronize_session = "fetch")
session.commit()
```

##### （6）`session.flush()`和`session.commit()`区别
```shell
session.flush() #flush之后，会在该事务中看到相应的修改
session.commit()    #提交当前事务
```

#### 5.将两张表建立关联

```python
from sqlalchemy import relationship

class Users(Base):
    __tablename__ = "users"       #表名

    id = Column(Integer, primary_key = True)
    name = Column(String(32), index = True, nullable = False)

    #之后Users对象可以通过 xx.hobby点出Hobby表的相关属性
    #同样Hobby对象可以通过 xx.user点出Users表的相关属性
    hobby = relationship("Hobby", backref = "user")


class Hobby(Base):
    __tablename__ = "hobby"       #表名

    id = Column(Integer, primary_key = True)
    hobby = Column(String(32), index = True, nullable = False)
```

#### 6.使用数据库内置的函数
```python
from sqlalchemy import func
#func.<FUNC_NAME>(<COLOUMN>)

session.query(Users).filter(func.lower(Users.name) == "liyi").all()
```

#### 7.操作json类型数据

```python
session.query(HOST_TABLE.config["base_info"]).filter(HOST_TABLE.config["base_info"]["scan_ip"] == "3.1.5.19").all()
```

* 忽略大小写
```python
session.query(HOST_TABLE.config["base_info"]).filter(func.lower(HOST_TABLE.config["base_info"]["scan_ip"]) == func.json_quote("3.1.5.19")).all()
```
