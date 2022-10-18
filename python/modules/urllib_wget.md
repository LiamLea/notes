# urllib模块
* **包含4个子模块**
>request     
>>用于发送request和获取request的结果

>error       
>>包含了request时产生的异常,用于忽略错误,能够完成爬虫

>parse       
>>用来解析和处理url

>robots.txt  
>>用来解析页面的robots.txt文件

* **获取指定url内容**
```python
from urllib import request
    html=request.urlopen(url)
    data=html.read()      
#返回bytes类型数据,readlines返回一个列表
#当内容多时,每次读取4096,要保存的话就写入本地即可
```

* **忽略HTTPError异常**
```python
from urllib import error
    try:
        pass
    except error.HTTPError:
        pass
```
* **模拟客户端(因为某些网站会拒绝相应的客户端)**
```python
  header={'User-Agent':'xx'}
  robj=request.Request(url,headers=header)  #建立请求对象
  html=request.urlopen(robj)
  data=html.read()
```

* **url只允许一部分ascii字符,如果有其他字符需要编码**
```python
  url='http://www.sougou,com/web?query=中国'
  request.urlopen(url)  //出错

正确的是:

  url='http://www.sougou/web?query='+request.quote('中国')
  request.urlopen(url)
```
#wet模块
* **下载**
```python
  wget.download(url,out='/tmp/aa')
```
