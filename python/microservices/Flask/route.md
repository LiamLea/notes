# route
[toc]
### 基础
#### 1.路由系统
路由匹配发生在`app.url_map`中
  * app是Flask的一个实例（用户创建的实例）
  * url_map是Map的一个实例（创建Flask实例时生成）
***

### 使用
#### 1.视图函数
* 装饰器（创建视图函数）
```python
#默认仅接受GET、OPTIONS和HEAD方法
@app.route("<URL>", methods = ["POST", "DELETE"])
```
* 变量
将url某个内容赋值给变量，然后在视图函数中，可以使用该变量
格式：`<变量名>`，变量名必须用尖括号括起来这种格式
```python
@app.route("/api/<name>")
def func():
    return jsonify({"xx": name})
```
* url_for函数
根据视图获取url
```python
from flask import url_for

#获取名为VIEW_NAME的视图的url，如果url中有变量的话，需要在调用url_for函数时传入相应的k-v
url_for("<VIEW_NAME>")
```

#### 2.全局变量
```shell
from flask import g

@app.before_request     #在请求被路由前，会调用这个方法
def func():
    g.<VAR> = <VALUE>   #定义了一个全局变量：Var = <VALUE>
```
