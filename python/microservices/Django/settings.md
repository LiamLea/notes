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
