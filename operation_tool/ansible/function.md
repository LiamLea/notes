# function

[toc]

### 常用函数

|function|description|
|-|-|
|`select('match', '<regexp>')`|匹配含有该正则的内容|
|`regex_replace('<src_regex>', '<dst_regex>')`|进行正则替换|
|`replace('<src_string>', '<dst_string>')`|进行字符串替换|
|`trim('<string>')`|两端去除<string>内容|
|使用python字符串函数：`{{ <var>.<func> }}`|参考下面的例子|
|`unique`|去重|

```jinja2
{{ result.stdout_lines | select('match', '.*image:.*') | list | regex_replace(' *image: *', '') | replace('\"', '')}}
```

##### 1.使用python函数
```jinja2
{{ xx.split('\n')}}
{{ xx.rstrip() }}
```

##### 2.合并两个列表
```yaml
set_fact:
  list_new: "{{ list1 + list2 }}"
```

##### 3.创建列表
* 方式一：
```jinja2
{# (monitor['node_exporter']['port']|string))  使用变量，并且将这个变量转换成字符串#}
{{ groups['all'] | map('extract', hostvars, ['ansible_host']) | map('regex_replace', '^(.*)$','\\1:' + (monitor['node_exporter']['port']|string)) | list }}
```

* 方式二（利用with_items）：
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

##### 4.使用原生字符串：`{% raw %} ... {% endraw %}`
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