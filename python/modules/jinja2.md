# jinja2模块

[toc]

### 基本概念

#### 1.基本类型
* variables（变量）
* filters（过滤器）
* tests（判断）
* comments（注释）

***

### 基本语法

#### 1.语法规则

##### （1） `{{ 表达式或变量名 }}`
* 可以使用python内置的熟悉，比如split属性：

```jinja2
{{ ansible_host.split(".")[-1]}}
```

* 当变量的值是list或者dict时
不用to_json的话，输出的值会加上u''
```jinja2
{{ variable | to_json}}
```

##### （2）`{% 控制语句 %}`
* 如果在控制语句中需要引用变量，直接用，不需要加`{{ ... }}`
```jinja2
{% if ansible_host != "3.1.5.19" %}
...
{% endif %}
```
##### （3）`{# 注释 #}`

##### （4）获取列表的某个索引的值
```jinja2
{{ list[0] }}
{{ list[1] }}
```

##### （5） 获取字典的某个键的值
```python
{{ dict.key }}
#或者： {{ dict["key"] }}
```

#### 2.判断
```jinja2
{% if xx %}
...
{% elif xx %}
...
{% else %}
...
{% endif %}
```

#### 3.循环
```python
{% for xx in xx %}
...
#{{ loop.index }}，能够当前获取循环的序号
{% endfor %}
```

#### 4.能够传递的内容

* 字符串、数字、列表等等
* 函数（传递过去的是地址）
  ```python
  def test(v):
      return v

  with open("index.html", "r", encoding = "utf8") as fobj:
      template = jinja2.Template(fobj.read())
  template.render({"func": test})
  ```
  * index.html
  ```jinja2
  {# 通过这种方式可以调用函数 #}
  {{ func("aaa") }}
  ```
* 对象

#### 5.空格控制

* "-" 号开启空格控制
前后的非空格内容（包括：块） 和 这个块开始或结束的之间的空格会被清除

* "+" 号关闭空格控制（默认）

```yaml
{%- xx %}\n
#前后的非空格内容（包括：块，比如这里的"xx %}"） 和 这个开始（"{%-"）之间的空格会被清除

{% xx -%}\n
#前后的非空格内容（包括：块，如"\n"） 和 这个结束（"-%}"）之间的空格会被清除

{%- xx -%}\n
```
##### （1）默认没有进行空格控制
```yaml
<div>
    {% if True %}
        yay
    {% endif %}
</div>
```
结果是
```
<div>

        yay

</div>
```

##### （2）进行空格控制
```yaml
<div>
    {% if True -%}
        yay
    {%- endif %}
</div>
```
结果是
```
<div>
        yay
</div>
```
```yaml
<div>
    {%- if True %}
        yay
    {% endif -%}
</div>
```
结果是
```
<div>
        yay
    </div>
```
#### 6.使用原生字符串（即不进行任何模板化）
```yaml
{% raw %}
#需要转义的内容
{% endraw %}
```

***

### 高级语法

#### 1.模板继承
（1）创建母版
demo.html
```python
... ...

{% block xx %}{% endblock %}
{% block test %}aaa{% endblock %}

... ..
```
（2）继承母版
```python
{% extends 'demo.html' %}
{% block xx %}
  ... ...
{% endblock %}
```
（3）使用的相关块母版
```python
{% extends 'demo.html' %}
{% block test %}
  ...
  {{ super }}       #加载母版test块的内容
  ...
{% endblock %}
```
#### 2.HTML转义
如果不转义，**传过来的变量包含特殊字符**（如：<）等，会被认为是**html的标签**
##### （1）没有开启自动转义时
如果需要转义
```jinja2
{{ name|e }}
```
##### （2）开启了自动转义
如果要关闭转义
```jinja2
{{ name|safe }}
```
#### 3.include其他模板
```jinja2
...
{% include 'xx' %}    #则会用include的模板的内容替换这个块
...
```

***

### 使用

#### 1.相关函数

```python
loader = jinja2.FileSystemLoader(".")      #创建一个loader，指明加载的路径，这里用的是当前目录
env = jinja2.Environment(loader = loader)   #使用指定的loader，创建环境
template = env.get_template("FILENAME")     #创建模板

template = jinja2.Template("STRING")        #创建模板，这样创建的模板，有些高级功能用不了（比如：使用母版等）

template.render()                           #渲染模板
```

#### 2.简单demo

```yaml
#temp.yaml
{% if age<10 %}
child
{% elif 10<=age<18 %}
youth
{% else %}
adult
{% endif %}
```

```python
import jinja2

loader = jinja2.FileSystemLoader('.')
env = jinja2.Environment(loader = loader)
temple = env.get_template('temp.yaml')

#传入变量的值（可以传入一个字典{'age': 15}），渲染模板
data = template.render(age = 15)

print(data)

#输出：
#youth
```

#### 3.自定义过滤器

```python
import jinja2

def test(arg1, arg2):
    return arg1 + arg2

loader = jinja2.FileSystemLoader(".")
env = jinja2.Environment(loader = loader)
env.filters["my_test"] = test

env.get_template("index.html")

data = template.render({"name": "测试"})

print(data)
```
> index.html
```python
<p>{{ name|my_test("ceshi") }}</p>
```
> 输出结果
```
<p>测试ceshi</p>
```
