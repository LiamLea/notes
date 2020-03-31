# xml模块
### 基础概念
```xml
<user name="zhangsan" age="18"> 学生 </user>
```
* element_node：上面整个就是一个element_node，element_node可以包含element_node、text_node等等
* attribute_node：上面name="zhangsan"和age="18"就是attribute_node
* text_node：上面 “学生” 就是text_node
### 解析xml文件
#### 1.导入模块
```python
#dom: document object model，文件对象模型
from xml.dom import minidom
```
#### 2.解析xml模块
（1）获取DOM对象
```python
with open('xx.xml', encoding = 'utf8') as fobj:
    dom = minidom.parse(fobj)
```
（2）获取根节点
```python
root = dom.documentElement
```
（3）各节点支持的属性
```python
node.tagName      #该节点的标签名
node.nodeType     #该节点的类型，1代表element_node，2代表attribute_node
node.childNodes   #获得该节点的子节点，返回一个列表
node.parentNode   #获得该节点的父节点
node.getAttribute("xx")           #获取节点xx属性的值
node.getElementsByTagName("xx")   #根据标签获取element_node，返回一个列表
```
