# Flask
[toc]

### 概述

#### 1.基础概念
* 视图（view）
被route方法装饰后的函数，即注册到路由系统中的函数

#### 2.特点
* Flask框架的路口是`flask.app`模块中的**Flask类**
  * 当运行Flask应用时，其实运行的是这个类的一个实例
  * 该实例负责**接收**WSGI请求，然后**分发**给指定的代码，最后返回**响应**
* Flask类提供了route方法，该方法可装饰其他函数，当函数被**route方法** **装饰**后，就会成为一个**视图（view）**，并被注册到**路由系统**中

#### 3.处理流程
```plantuml
rectangle "路由匹配" as a
rectangle "视图" as b

request -d->a: "请求"
a -d->b: "请求"
```

***

### 使用
#### 1.基础demo
```python
from flask import Flask
from flask import jsonify

app = Flask("<应用名称>")

#利用装饰器设置路由系统
@app.route("<URL>")
def func(host = "0.0.0.0", port = 80):
  #构建响应报文
  reponse = jsonify(<DICT>)
  return reponse

#运行该应用
app.run()
```

#### 2.配置app
有很多中方式
* 原始方式：
```python
app.config["<CONFIG_KEY>"] = "<CONFIG_VALUE>"
```
* 从类中读取
```python
#将这个类放在 settings.py
class DevConfig:
  <CONFIG_KEY> = <CONFIG_VALUE>

#main.py
app.config.from_object("settings.DevConfig")
```

#### 3.请求和响应
* 请求对象
```python
from flask import request

request.method
request.args
request.cookies
request.headers
request.url
#... ...
```
* 响应对象
```python
from flask import redirect
from flask import render_template
from flask import make_reponse
from flask import jsonify

return "字符串"
return render_template(<TEMPLATE_PATH>, <ARGS_DICT>)
return redirect("<URL>")

reponse = make_reponse(render_template(<TEMPLATE_PATH>, <ARGS_DICT>))
reponse.set_cookie("<KEY>", "<VALUE>")
reponse.headers["<HEADER>"] = "VALUE"
return reponse

return jsonify(<DICT>)
```

#### 4.session

```python
from flask import session

app.secret_key = "xx"   #用于加密session的内容

@app.route("/")
def func():
  session["k1"] = "v1"
  session["k2"] = "v2"
  return "xx"

#flask会secret_key对session的内容进行加密，然后添加到cookie中
#添加的cookie的key为app.session_cookie_name，value为加密的内容
#通过源码发现，是 这样添加的：reponse.set_cookie(app.session_cookie_name, val)
```

#### 5.请求和响应的扩展（相当于Django的中间件）
##### （1）在所有请求被路由前做的操作（可以用于身份认证）
```python
@app.before_request
def func():
    return None     #表示什么都不做，可以继续执行下面的视图函数
    return "拦截"   #不会执行视图函数和其他被before_request装饰的函数
                    #但是会执行被after_request装饰的函数
```
##### （2）在所有请求后，即执行完视图函数后进行的操作
```python
@app.after_request
def func(reponse):
    return reponse
```

##### （3）当有多个before_request和after_request时的顺序
* before_request是顺序执行的
* after_request是倒序执行的
```python
@app.before_request
def func1():
    print(func1)

@app.before_request
def func2():
    print(func2)

@app.after_request
def func3(reponse):
    print(func3)
    return reponse

@app.after_request
def func4(reponse):
    print(func4)
    return reponse

最后的结果：
  func1
  func2
  func4
  func3
```

##### （4）定制错误信息
```python
@app.errorhandler(404)
def func(arg):
    return "404错误"
```

#### 6.一次请求中的全局变量（即一个线程中的全局变量）
```python
from flask import g

g.<KEY> = <VALUE>
```

#### 7.设置守护线程，进行清理等工作
```python
import threading
import time
import random
from flask import Flask

app = Flask(__name__)

data_store = {'a': 1}
def interval_query():
    while True:
        time.sleep(1)
        vals = {'a': random.randint(0,100)}
        data_store.update(vals)

thread = threading.Thread(name='interval_query', target=interval_query)
thread.setDaemon(True)
thread.start()

@app.route('/')
def hello_world():
    return str(data_store['a'])

if __name__ == "__main__":
    app.run()
```
