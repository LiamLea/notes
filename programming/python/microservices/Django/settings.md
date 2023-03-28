#settings

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [settings](#settings)
    - [Django的配置](#django的配置)
      - [1.模板路径的配置](#1模板路径的配置)
      - [2.静态文件路径的配置](#2静态文件路径的配置)
      - [3.配置数据库](#3配置数据库)
      - [4.注册app](#4注册app)
      - [5.session配置](#5session配置)

<!-- /code_chunk_output -->

### Django的配置
#### 1.模板路径的配置
```python
TEMPLATES = [
    {
        #配置模板存放的目录，BASE_DIR是项目的目录，利用os.path.join拼接出一个模板的路径
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
    },
]
```

#### 2.静态文件路径的配置
```python

#当访问/static/这个url时，能够访问的静态文件的路径
STATIC_URL = '/staic/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]
```

#### 3.配置数据库
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '数据库名',
        'USER': 'xx',
        'PASSWORD': 'xx',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

#### 4.注册app
app注册到django才能使用
```python
INSTALLED_APPS = [
    'app01',
]
```

#### 5.session配置
```python
#下面都是默认值，即不设置的话就是下面的值

SESSION_COOKIE_NAME = "sessionid"     #写入客户端的cookie的键名
SESSION_COOKIE_PATH = "/"             #session的cookie生效的路径
SESSION_COOKIE_DOMAIN = False         #session的cookie生效的域名，这里设置使用当前域名
SESSION_COOKIE_SECURE = False         #是否https传输cookie
SESSION_COOKIE_HTTPONLY = True        #是否只支持http传输cookie

SESSION_COOKIE_AGE = 1209600          #session的超时时间（秒）
SESSION_EXPIRE_AT_BROWSER_CLOSE = False   #关闭浏览器是否使得session过期
SESSION_SAVE_EVERY_REQUEST = False      #是否每次请求都保存session，默认是不保存，即如果设置了30分钟超时，如果你在10分钟的时候刷新了页面，过20分钟session还是会超时
```
