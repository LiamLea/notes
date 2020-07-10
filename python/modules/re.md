[toc]
# re模块
### 正则补充
#### 1.利用转义符
```python
[^0-9]        #匹配非数字的单个字符
[\^0-9]       #匹配数字或^
[0-9^]        #匹配数字或^

[a-9]         #出错
[a\-9]        #匹配a或9或-
[a9-]         #匹配a或9或-
```

#### 2.贪婪匹配
在量词范围允许的情况下，尽量多的匹配内容（利用的回溯算法）
```python
#123456123456

1\d+6

#匹配到的内容：123456123456
```

#### 2.非贪婪匹配:
```python
#123456123456

1\d+?6

#匹配到的内容：123456
```
**注意：用grep达不到预期效果，因为grep是以行为处理单位的**

### 函数
**匹配对象,需要用其group()方法才能获取匹配内容**
```python
m.group()       #输出匹配的内容
m.group(1)      #输出匹配内容的第一个子串
... ...
```
```python
search('regexp','string', re.IGNORECASE)  #返回第一个匹配的对象
                                          #re.IGNORECASE代表忽略大小写


m=search('f..','seafood is faad')     #m.group()为foo
```
```python
findall('regexp','string')             #匹配所以的内容,返回一个列表

findall('f..','seafood is faad')      #结果为['foo','faa']
```
```python
finditer('regexp','string')           #返回匹配对象的迭代器

for m in finditer('f..','seafood is faad')
    print(m.group())                  #输出'foo' \n 'faa'
```
```python
split('regexp','string')              #用于分割

split('f..','seafood is faad')        #结果为['sea','d is ','d']
split('\.|-','how-are-you.tar')       #以.或-作为分割符号,输出一个列表
```
```python
sub('regexp','replace','string')      #用于替换

sub('f..','0','seafood is faad')      #结果为'sea0d is 0d'

sub(r'f..',r'\1a','seafood is faad') #结果为‘seafooad is faad’
```
* 常常先将模式进行编译,可以得到更好的效率
```python
pattern=re.compile('regexp', re.IGNORECASE)   #re.IGNORECASE表示忽略大小写
m=pattern.search('string')
pattern.split('string')
```
