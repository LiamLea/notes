# function

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [function](#function)
    - [常用函数](#常用函数)
      - [1.使用python函数](#1使用python函数)
      - [2.合并两个列表](#2合并两个列表)
      - [3.合并两个dict](#3合并两个dict)
      - [4.创建列表](#4创建列表)
        - [（1）方式一](#1方式一)
        - [（2）方式二（利用with_items，推荐）](#2方式二利用with_items推荐)
      - [5.使用原生字符串：`{% raw %} ... {% endraw %}`](#5使用原生字符串-raw-endraw)
      - [6.修改列表的每个item（比如添加后缀）](#6修改列表的每个item比如添加后缀)
      - [7.设置变量时，不要用if语句，因为if语句返回的都是string，无法返回特殊类型](#7设置变量时不要用if语句因为if语句返回的都是string无法返回特殊类型)

<!-- /code_chunk_output -->

### 常用函数

|function|description|
|-|-|
|`select('match', '<regexp>')`|匹配含有该正则的内容|
|`regex_replace('<src_regex>', '<dst_regex>')`|进行正则替换|
|`replace('<src_string>', '<dst_string>')`|进行字符串替换|
|`trim('<string>')`|两端去除<string>内容|
|使用python字符串函数：`{{ <var>.<func> }}`|参考下面的例子|
|`unique`|去重|
|`combine`|合并dict|

```jinja2
{{ result.stdout_lines | select('match', '.*image:.*') | list | regex_replace(' *image: *', '') | replace('\"', '')}}
```

#### 1.使用python函数
```jinja2
{{ xx.split('\n')}}
{{ xx.rstrip() }}
```

#### 2.合并两个列表
```yaml
set_fact:
  list_new: "{{ list1 + list2 }}"
```

#### 3.合并两个dict
```jinja2
{{ {'a':1, 'b':2}|combine({'b':3, 'c':4}) }}
```
* 结果
```python
{'a': 1, 'b':2, 'c':3}
```

#### 4.创建列表

##### （1）方式一
```jinja2
{# (monitor['node_exporter']['port']|string))  使用变量，并且将这个变量转换成字符串 #}
{{ groups['all'] | map('extract', hostvars, ['ansible_host']) | map('regex_replace', '^(.*)$','\\1:' + (monitor['node_exporter']['port']|string)) | list }}
```


##### （2）方式二（利用with_items，推荐）
* 创建的列表元素为: string
```yaml
#最好先设置一下为空，不然如果{{ groups['all'] }}为空的话，dst就会是未定义
- name: set fact
  set_fact:
    dst: []
- name: set fact
  set_fact:
    dst: "{{ dst | default([]) + [hostvars[item]['ansible_host'] + ':' + (monitor['node_exporter']['port']|string)]}}"
  with_items: "{{ groups['all'] }}"
```


* 创建的列表元素为: dict
```yaml
- name: set __prometheus_hosts fact
  set_fact:
    __prometheus_hosts: "{{ __prometheus_hosts + [{'host': (ingress.hosts['prometheus']['host'] + '.' + item).strip('.'), 'path': ingress.hosts['prometheus']['path']}] }}"
  with_items: "{{ ingress.hosts['prometheus']['domains'] }}"
```

#### 5.使用原生字符串：`{% raw %} ... {% endraw %}`
```yaml
# {{ variable_1 }}: {{ aa }}
variable_1: {% raw %} {{ aa }} {% endraw %}

# {{ variable_2 }}: {{ aa }}\nbb
variable_2: |
  {% raw %}
  {{ aa }}
  bb
  {% endraw %}
```

#### 6.修改列表的每个item（比如添加后缀）
```yaml
#添加haha后缀
{{ my_list | map('regex_replace', '^(.*)$','\\1haha') | list }}

#使用变量的话
{{ my_list | map('regex_replace', '^(.*)$','\\1' + var_name) | list }}
```

#### 7.设置变量时，不要用if语句，因为if语句返回的都是string，无法返回特殊类型
