### 概述
#### 1.目录说明
```shell
项目名                         # 网站的根目录，即http://127.0.0.1访问的目录          
├── manage.py                 # 项目管理文件
├── 项目名                     # 项目管理目录
│   ├── __init__.py           
│   ├── settings.py           # 配置文件
│   ├── urls.py               # URLconf路由文件
│   └── wsgi.py               # 定义socket服务端是如何实现的（开发环境用wsgiref，生产环境用uwsgi）
└── templates                 # 模板目录

应用名
├── admin.py                  #Django自带后台管理的相关配置
├── models.py                 #写操作数据库的类（ORM，object relation model）
├── test.py                   #单元测试
├── views.py                  #视图函数
└──
```

#### 2.基本操作
```shell
python manage.py startapp xx          #创建一个app
python manage.py runserver IP:PORT    #启动django

python manage.py makemigrations       #生产model（模型）
python manage.py migrate              #根据model创建表
```

#### 2.母版（是一种模板）
（1）创建母版
demo.html
```python
... ...

{% block xx %}{% endblock %}

... ..
```
（2）使用母版
```python
{% extends 'demo.html' %}
{% block xx %}
  ... ...
{% endblock %}
```
