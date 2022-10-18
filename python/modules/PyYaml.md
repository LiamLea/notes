# pyyaml

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [pyyaml](#pyyaml)
    - [使用](#使用)
      - [（1）将 yaml格式内容 转换成 python对象](#1将-yaml格式内容-转换成-python对象)
      - [（2）将 python对象 转换成 yaml格式内容](#2将-python对象-转换成-yaml格式内容)

<!-- /code_chunk_output -->

### 使用

#### （1）将 yaml格式内容 转换成 python对象
```python
from yaml import load
from yaml import CLoader

#<CONTEXT>为yaml的内容
#既支持字符串类型，也支持bytes类型
obj = load(<CONTENT>, Loader = CLoader)    #原先默认的Loader被废弃了，需要指定Loader          

#或者加载yaml文件
with open(filename, "r", encoding="utf8") as fobj:
    obj = load(fobj, Loader=CLoader)
```

#### （2）将 python对象 转换成 yaml格式内容
```python
from yaml import dump

content = dump(obj, default_flow_style = False)   #输出yaml格式
```
