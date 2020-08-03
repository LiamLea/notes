# route
[toc]
### 基础
#### 1.路由系统
路由匹配发生在`app.url_map`中
  * app是Flask的一个实例（用户创建的实例）
  * url_map是Map的一个实例（创建Flask实例时生成）

#### 2.建议目录结构
```shell
Project
  |
  -views        #不同的路由规则，放在不同的文件中
    |
    -account.py
    -cmdb.py
```
***

### 使用
#### 1.函数详细说明
##### （1）`add_url_rule`函数参数
```python
rule                 #URI规则
endpoint = None      #endpoint的名字，不设置的话默认设置为函数的名字
view_func            #视图函数
methods = None       #允许的请求方法，不设置的话默认允许GET、OPTIONS和HEAD方法

strict_slashes = None     #对URl最后的 / 符号严格匹配
redirect_to = None        #重定向指定地址

subdomain = None          #匹配子域名
                          #www.baidu.com子域名就是www
                          #ftp.baidu.com子域名就是ftp
                          #subdomain = "<xx>"，则匹配所有子域名，将子域名的内容赋值到xx这个变量中，则视图函数可以使用xx变量
```
#### 2.视图函数相关
##### （1）创建视图函数（view）
* 通过装饰器
```python
@app.route("<URL>", methods = ["POST", "GET"], endpoint = "<ENDPOINT_NAME>")
```

* 通过观察源码，还能通过以下方式添加路由规则（**建议采用此方式**，便于管理）
```python
app.add_url_rule(rule = "<URL>", endpoint = "<ENDPOINT_NAME>", view_func = <FUNC_NAME>, **options)

#**options用于接收其他参数，比如：
#   methods = ["POST", "GET"]
```

* 利用类创建视图函数
```python
from flask import views

class A(views.MethodView):
  methods = ["GET", ]
  decorators = [<FUNC_NAME>, ]

  def get(self):
    return "xx"

app.add_url_rule("<URL>", view_func = A.as_view(name = "<ENDPOINT_NAME>"))
```

##### （2）在视图函数中设置变量，变量的值来自url
将url某个内容赋值给变量，然后在视图函数中，可以使用该变量
格式：`<变量名>`，变量名必须用尖括号括起来这种格式
```python
@app.route("/api/<name>")
def func():
    return jsonify({"xx": name})
```

##### （3）根据endpoint获取对应的url：`url_for`函数

```python
from flask import url_for

#获取endpoint为VIEW_NAME的url，如果url中有变量的话，需要在调用url_for函数时传入相应的k-v
url_for("<VIEW_NAME>")
```

#### 2.全局变量
```shell
from flask import g

@app.before_request     #在请求被路由前，会调用这个方法
def func():
    g.<VAR> = <VALUE>   #定义了一个全局变量：Var = <VALUE>
```
