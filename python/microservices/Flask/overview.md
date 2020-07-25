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
def func():
  #构建响应报文
  reponse = jsonify(<DICT>)
  return reponse

#运行该应用
app.run()
```
