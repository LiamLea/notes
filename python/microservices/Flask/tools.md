[toc]
### flask sqlalchemy

#### 1.创建sqlalchemy并注册到app中
```python
from flask_sqlalchemy import SQLAlchemy

#凭证信息都是在flask配置中配置的
#创建连接池
db = SQLAlchemy()

db.init_app(app)
```

#### 2.创建表的类
一般在models目录下
```python
class Users(db.Model):
  pass
```

#### 3.操作
```python
db.session.add(Users(name = "liyi"))
db.session.commit()
db.close()    #将连接返回连接池
```

***

### flask scripts

#### 1.用脚本命令管理该app
```python
from flask_scripts import Manager

manager = Manager(app)

manager.run()
```

```shell
python3 xx runserever -h 0.0.0.0 -p 80
```

#### 2.自定义命令

```python
@manager.command
def test(arg):
  print(arg)


@manager.option("-n", "--name", dest = "name")
@manager.option("-u", "--url", dest = "url")
def test2(name, url):
  print(name, url)
```

```shell
python3 xx test lala
#就会输出：lala

python3 xx test2 -n liyi -u http://baidu.om
#输出：liyihttp://baidu.om
```

***

### flask migrate（需要flask_scripts）
能够刷库

```python
from flask_migrate import Migrate, MigrateCommand

migrate = Migrate(app, db)

manager = Manager(app)
manager.add_command("db", MigrateCommand)
```

```shell
python3 xx db init
python3 xx db migrate
python3 xx db upgrade
```
