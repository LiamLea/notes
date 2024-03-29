# core module

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [core module](#core-module)
    - [配置](#配置)
      - [1.location](#1location)
        - [（1）location寻找顺序](#1location寻找顺序)
        - [（2）当使用正则时，需要注意结尾的`/`](#2当使用正则时需要注意结尾的)

<!-- /code_chunk_output -->

### 配置

#### 1.location

```python
#从上到下，匹配优先级由高到低
# =   url完全匹配
# ^~  表示前缀匹配
# ~   大小写敏感的正则匹配
# ~*  大小写不敏感的正则匹配
# 什么符号都没有，表示前缀匹配
location [ = | ^~ | ~ | ~* ] uri { ... }

#定义一个命名的location，该location只能重定向时使用
#使用：@<name>
location @<name> { ... }
```

##### （1）location寻找顺序
* 从上到下遍历，找到最长的前缀匹配，并记录下来
  * 如果在这个过程中，找到了完全匹配（`=`），则停止
  * 找到的最长前缀匹配，如果有`^~`，表示不进行正则查找了
* 遍历正则匹配
  * 找到符合要求的正则，则停止
  * 找不到，则用最长的前缀匹配

##### （2）当使用正则时，需要注意结尾的`/`
```python
location ~ .*xxx/?$

#这样既能匹配：http://192.168.90.1/xxxx
#又能匹配：http://192.168.90.1/xxxx/
```
