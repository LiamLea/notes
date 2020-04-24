[toc]
# middleware
### 概述
#### 1.处理流程
```plantuml
agent client

frame "中间件1"{
  card "m1-func1函数" as m1f1
  card "m1-func2函数" as m1f2
}

frame "中间件2"{
  card "m2-func1函数" as m2f1
  card "m2-func2函数" as m2f2
}
frame "server"{
  card "view函数" as v
}
client---->m1f1
m1f1--->m2f1
m2f1--->v
v--->m2f2
m2f2-->m1f2
m1f2-->client
m1f1->m1f2:"可能直接返回"
m2f1->m2f2:"可能直接返回"
```

#### 2.编写一个middleware
my_middleware.py
```python
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import HttpResponse

class MyMiddleWare(MiddlewareMixin):
    def process_request(self, request):
        print("middleware request")
        return HttpResponse("我是一个中间件，你必须先过我这关")

    def process_response(self, request, response):
        print("middleware reponse")
        print(response.content.decode())
        return response

```
settings.py
```python
MIDDLEWARE = [
    ... ...
    'DjangoTest3.my_middleware.MyMiddleWare',
]
```
