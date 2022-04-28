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
