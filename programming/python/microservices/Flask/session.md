# session

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [session](#session)
    - [概述](#概述)
      - [1.flask中的session](#1flask中的session)
      - [2.session 在 cookie中对应的key](#2session-在-cookie中对应的key)
      - [3.处理流程（默认是将 session数据 加密 存储到 客户端）](#3处理流程默认是将-session数据-加密-存储到-客户端)
      - [4.flask_session组件能够实现将session数据存储在其他地方](#4flask_session组件能够实现将session数据存储在其他地方)
    - [使用](#使用)
      - [1.flask_session组件的使用](#1flask_session组件的使用)

<!-- /code_chunk_output -->

### 概述

#### 1.flask中的session
在flask中，session本质是一个字典，可以使用字典的所有方法

```python
from flask import session

session[<KEY>] = <VALUE>
```
#### 2.session 在 cookie中对应的key
通过flask配置进行配置的，默认key是"session"
```python
app.config["SESSION_COOKIE_NAME"] = "session"
```

#### 3.处理流程（默认是将 session数据 加密 存储到 客户端）
* 当前请求进来时，flask会在请求头中获取 对应的key的值，并进行解密
  * 如果没有对应的key或者key对应的值为空，则会创建一个session
* 操作session
* 返回响应前，会将session的所有数据 加密 放入到cookie对应的key中


#### 4.flask_session组件能够实现将session数据存储在其他地方

***

### 使用

#### 1.flask_session组件的使用
* session的处理流程没有变，只不过处理接口变了
* 即会把session数据存入redis中，将session的key存入cookie中
  * 而不是将session所有数据都存入cookie了

```python
from flask import session
from flask_session import RedisSessionInterface

#建立redis连接
from redis import Redis
conn = Redis(host = '...', ...)

#更换flask默认的session接口
app.session_interface = RedisSessionInterface(conn, key_prefix = "xx")    #key_prefix设置后，在redis中存储的key会加个前缀
         #不会影响session的任何操作，只不过去redis中查看时能够一目了然

#操作session
@app.route("/")
def index():
  session["xx"] = "yy"
```
