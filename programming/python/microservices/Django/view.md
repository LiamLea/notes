# view

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [view](#view)
    - [1.视图函数](#1视图函数)
      - [（1）接收一个参数，传入的是请求的所有内容](#1接收一个参数传入的是请求的所有内容)
      - [（2）构造HTTP响应](#2构造http响应)
      - [（3）设置返回的cookie](#3设置返回的cookie)
      - [（4）返回HTTP响应](#4返回http响应)
    - [2.视图类](#2视图类)

<!-- /code_chunk_output -->

### 1.视图函数
#### （1）接收一个参数，传入的是请求的所有内容
```python
def func(request):
    request.method        #请求所有的方法
    request.GET           #获取 请求头中url 中传来的数据（得到的是一个字典）
    request.POST          #获取 请求体 中传来的数据（得到的是一个字典）
    request.COOKIES.get("key")      #获取 请求头中的cookie的某个键的值
    request.get_signed_cookie("key", salt = "xx")            #获取 请求头中加密的cookie的某个键的值
#得到的字典是Django中自定义的字典，当对应的值是列表时，需要用dict.getlist("KEY")来获取这个列表
```
#### （2）构造HTTP响应
* 返回一个字符串
```python
reponse = HttpReponse("xxx")   
```
* 渲染一个模板，并返回（本质也是字符串）
```python
#返回一个字符串，该函数会将该字符串封装成一个HTTP响应报文，返回给客户端
reponse = render(request, xx, {key: value})
```
* 重定向到新的url
```python
#将该请求重定向到某个url
reponse = redirect("http://www.baidu.com")
```
#### （3）设置返回的cookie
```python
reponse.set_cookie("key", "value", max_age = xx, path = "/")
# max_age设置这个cookie在客户端浏览器端保存的时长，超过这个时间，浏览器会自动清楚这个cookie
# path设置服务端哪个url能够读取这个cookie

#上面设置的cookie是明文的，下面设置的cookie是加密的
reponse.set_signed_cookie("key", "value", salt = "xx")
```
#### （4）返回HTTP响应
```python
return reponse
```
示例：
```python
from django.shortcuts import render,HttpResponse,redirect

def func(request):
    pass
    return HttpReponse("xxx")     
````

### 2.视图类
```python
from django.views import View
class Login(View):

    #当使用Get方法时，会执行类中的get函数
    def get(self, request):
        pass

    #当使用Post方法时，会执行类中的post函数
    def post(self, request):
        pass
```
