# re模块
[toc]
### 正则补充
#### 1.语法补充
##### （1）基础
* 利用转义符
```python
[^0-9]        #匹配非数字的单个字符
[\^0-9]       #匹配数字或^
[0-9^]        #匹配数字或^

[a-9]         #出错
[a\-9]        #匹配a或9或-
[a9-]         #匹配a或9或-
```

* 贪婪匹配
在量词范围允许的情况下，尽量多的匹配内容（利用的回溯算法）
```python
#123456123456

1\d+6

#匹配到的内容：123456123456
```

* 非贪婪匹配:
```python
#123456123456

1\d+?6

#匹配到的内容：123456
```
**注意：用grep达不到预期效果，因为grep是以行为处理单位的**

* 不匹配指定字符
```python
[^字符]     #注意：[^(字符)]，这种写法和[^字符]是等价的
```

##### （2）分组语法

* 不匹配某个pattern
```python
(?!pattern)
```

* 匹配pattern，但会存储匹配结果，但不会存储在分组中（即不能使用`\1`方式获取匹配结果）
```python
(?:pattern)   #pattern中可以使用"|""
```

* 匹配pattern，但不会存储匹配结果（即匹配到的内容不包括该pattern的内容）
```python
(?=pattern)
```

#### 2.常用正则
##### （1）匹配ipv4地址
```python
([0-9]{1,3}\.){3}(?!255)[0-9]{1,3}
```

##### （2）某行不包含特定字符串
```python
^((?!字符串).)*$
```

##### （3）匹配行头
当搜索整个文本内容时
```python
(?:^|\n)
```

***

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
