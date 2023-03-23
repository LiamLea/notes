# 路由系统

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [路由系统](#路由系统)
    - [概述](#概述)
      - [1.静态路由](#1静态路由)
      - [2.动态路由（正则）](#2动态路由正则)
      - [3.路由分发](#3路由分发)
      - [4.默认匹配（即上面都没有匹配时）](#4默认匹配即上面都没有匹配时)
      - [5.给路由关系取名（只有Django中能用）](#5给路由关系取名只有django中能用)

<!-- /code_chunk_output -->

### 概述
#### 1.静态路由
url和view函数一一对应
```python
urlpatterns = [
    path(r'static.html/', views.static),
    re_path(r'^login.html/', views.Login.as_view())  #当匹配login.html时，会匹配的Login这个类
]
```
#### 2.动态路由（正则）
```python
urlpatterns = [
    re_path(r'^index.html/', views.index),

    #匹配到的内容会按顺序传递给view函数
    re_path(r'^demo.html/(\w+)/(\w+)/', views.demo),

    #匹配的的内容会赋值给view函数中相应的形参
    re_path(r'^test.html/(?P<arg1>\w+)/(?P<arg2>\w+)', views.test),
]
```
```python
def index(request):
    pass

def demo(request, arg1, arg2):    #arg1会接收第一个(\w+)匹配到的内容，arg2会接收第二个(\w+)匹配到的内容
    pass

def test(request, arg1, arg2):
    pass
```

#### 3.路由分发
```python
#匹配到相应的url，然后将该url中剩余的部分交给另一个模块进行匹配
urlpatterns = [
    path(r'^app01/', include(app01.urls)),
    #比如http://xx/app01/index.html
    #匹配到^app01/
    #会将index.html交给app01.urls模块继续进行匹配
]
```

#### 4.默认匹配（即上面都没有匹配时）
```python
urlpatterns = [
    ... ...

    path(r'^', views.default),

]
```

#### 5.给路由关系取名（只有Django中能用）
当url十分长时，取名就很有必要
```python
urlpatterns = [
    path(r'^demo/', view.demo, name = "test1")
    path(r'^index/(\w+)', view.index, name = "test2")
]
```
在python代码中使用别名获取url
```python
from django.urls import reverse
url1 = reverse("test1")
#url1=demo/
url2 = reverse("test2", args = (aa11,) )
#url2=index/aa111
```
在模板中使用别名获取url
```yaml
{% url xx %}    #这里就会被替换为名字为xx对应的url
```
