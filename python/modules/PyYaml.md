# pyyaml
[toc]
### 使用

#### （1）将 yaml格式内容 转换成 python对象
```python
from yaml import load
from yaml import CLoader

#<CONTEXT>为yaml的内容
#既支持字符串类型，也支持bytes类型
obj = load(<CONTENT>, Loader = CLoader)    #原先默认的Loader被废弃了，需要指定Loader          
```

#### （2）将 python对象 转换成 yaml格式内容
```python
from yaml import dump

content = dump(obj, default_flow_style = False)   #输出yaml格式
```
