#json模块
>JSON(javaScript Object Notation),是一种轻量级的数据交换格式
可以通过网络传输各种类型的数据
采用完全独立于语言的文本格式，实现语言之间的数据交换
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

#requests模块
>requests是一个HTTP库，内部采用urllib3实现
提供了使用某种方法(如：GET,POST)访问web的函数

* 获取url资源,以str类型返回数据
```python
  reponse=requests.get(url)
  reponse.text
```
* 获取url资源，以bytes类型返回数据（如图片等）
```python
  reponse=requests.get(url)
  reponse.content
```
* 获取url资源，解析json格式，返回特定类型
```python
  reponse=requests.get(url)
  reponse.encoding='utf8'  
#注意url资源的编码，通过html.encoding可以查看现在的编码
  reponse.json()           
#将json格式转换为特定的数据类型
```

#requests+json的框架
>调用其他软件提供的api,如：钉钉机器人，图灵机器人，zabbix
```python
import requests
import json

url='xx'
headers={'xx':'yy'}     #根据软件的手册写

data='...'

reponse=requests.post(url,headers=headers,data=json.dumps(data))
print(reponse.json())
```
