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
```
