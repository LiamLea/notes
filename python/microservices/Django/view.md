### 1.处理函数
#### （1）接收一个参数，传入的是请求的所有内容
```python
def func(request):
    request.method        #请求所有的方法
    request.GET           #获取 请求头中url 中传来的数据（得到的是一个字典）
    request.POST          #获取 请求体 中传来的数据（得到的是一个字典）
#得到的字典是Django中自定义的字典，当对应的值是列表时，需要用dict.getlist("KEY")来获取这个列表
```
#### （2）需要返回一个HTTP响应
* 返回一个字符串
```python
return HttpReponse("xxx")   
```
* 渲染一个模板，并返回（本质也是字符串）
```python
#返回一个字符串，该函数会将该字符串封装成一个HTTP响应报文，返回给客户端
return render(request, xx, {key: value})
```
* 重定向到新的url
```python
#将该请求重定向到某个url
return redirect("http://www.baidu.com")
```
示例：
```python
from django.shortcuts import render,HttpResponse,redirect

def func(request):
    pass
    return HttpReponse("xxx")     
````
