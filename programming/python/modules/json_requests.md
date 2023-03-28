
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [json模块](#json模块)
      - [1.可实现的转换](#1可实现的转换)
      - [2.使用](#2使用)
      - [3.FAQ](#3faq)
        - [（1）通过 sql语句 将json数据 插入到 mysql的json_filed类型字段](#1通过-sql语句-将json数据-插入到-mysql的json_filed类型字段)
- [requests模块](#requests模块)
      - [1.基本使用](#1基本使用)
      - [2.处理返回](#2处理返回)
- [requests+json的框架](#requestsjson的框架)

<!-- /code_chunk_output -->

# json模块
JSON(javaScript Object Notation),是一种轻量级的数据交换格式
可以通过网络传输各种类型的数据
采用完全独立于语言的文本格式，实现语言之间的数据交换
#### 1.可实现的转换
|python 数据类型|json 类型|
|-|-|
|dict|json对象：`{}`|
|list, tuple|json数组：`[]`|
|str|json字符串：`""`，且必须将特殊字符转义|

#### 2.使用
```python
import json

json.dumps(adict, indent=2)    #将字典类型，转换为json格式(即字符串）
                              #设置缩进两格，则打印出来的格式很清晰

json.loads(astr)     #将json格式的数据转换为特定类型

#应用：获取网上的数据，例如获得天气情况：
from urllib import request
url='http://www.weather.com.cn/data/sk/101010100.html'
html=request.urlopen(url)
data=html.read()
json.loads(data)
```

#### 3.FAQ
##### （1）通过 sql语句 将json数据 插入到 mysql的json_filed类型字段
利用`json.dumps()`将 **普通的字符串**（这个字符串是json对象格式的字符串）转换成 **json字符串**

插入时mysql需要的是一个 `形如："xxx"` 的字符串，系统会对xxx内容中的特殊字符进行特殊处理（跟print一样），所以xxx内容需要考虑这一点，需要将特殊字符转义，不然会被系统处理成其他内容

```python

a = "dsd\"aaa\t"
b = "haha " + json.dumps(a)

print(b)

#输出：
#haha "dsd\"aaa\t"
```

***

#requests模块
requests是一个HTTP库，内部采用urllib3实现
提供了使用某种方法(如：GET,POST)访问web的函数

#### 1.基本使用
```python
#修改HTTP请求头（没有修改的字段就用默认的）
headers = <DICT>
#设置cookie
cookies = <DICT>

#发送HTTP请求
response=requests.get(url,
  verify = False,     #当采用https时，不进行证书认证
  headers = headers,
  cookies = cookies
)
```
#### 2.处理返回
```python
#以str类型返回数据
response.text

#以bytes类型返回数据（如图片等）
reponse.content

#解析json格式，返回特定类型
#注意url资源的编码，通过html.encoding可以查看现在的编码
reponse.encoding='utf8'  
#将json格式转换为特定的数据类型
reponse.json()           
```

***
# requests+json的框架
调用其他软件提供的api,如：钉钉机器人，图灵机器人，zabbix
```python
import requests
import json

url='xx'
headers={'xx':'yy'}     #根据软件的手册写

data='...'

reponse=requests.post(url,headers=headers,data=json.dumps(data))
print(reponse.json())
```
