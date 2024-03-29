# pipeline

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [pipeline](#pipeline)
    - [pipeline内容配置（`xx.conf`）](#pipeline内容配置xxconf)
      - [1.配置文件语法](#1配置文件语法)
        - [（1）字符串](#1字符串)
        - [（2）数组（常用列表）](#2数组常用列表)
        - [（3）列表](#3列表)
        - [（4）bool类型](#4bool类型)
        - [（5）hash（也就是字典）](#5hash也就是字典)
        - [（6）数字](#6数字)
      - [2.高级语法](#2高级语法)
        - [（1）字段的引用：`[]`](#1字段的引用)
        - [（2）格式化：`%{}`](#2格式化)
        - [（3）条件判断](#3条件判断)
      - [3.特殊字段：`@metadata`](#3特殊字段metadata)
      - [4.使用系统的环境变量：`${}`](#4使用系统的环境变量)

<!-- /code_chunk_output -->

### pipeline内容配置（`xx.conf`）

```ruby
input {
}

#该element是可选的
filter {
}

output {
}
```

#### 1.配置文件语法
采用的是ruby的语法
`key => value` 相当于 `key: value`

##### （1）字符串
```ruby
name => "liyi"
```
##### （2）数组（常用列表）
```ruby
users => [ {id => 1, name => bob}, {id => 2, name => jane} ]
```

##### （3）列表
```ruby
path => [ "/var/log/messages", "/var/log/*.log" ]
uris => [ "http://elastic.co", "http://example.net" ]
```

##### （4）bool类型
```ruby
ssl_enable => true
```

##### （5）hash（也就是字典）
```ruby
#注意使用空格分隔，而不是逗号分隔
match => {
  "field1" => "value1"
  "field2" => "value2"
  ...
}
```

##### （6）数字
```ruby
age => 18
```

#### 2.高级语法
比如字段结构如下（在input阶段可以添加字段）：
```json
{
  "agent": "Mozilla/5.0 (compatible; MSIE 9.0)",
  "ip": "192.168.24.44",
  "request": "/index.html"
  "response": {
    "status": 200,
    "bytes": 52353
  },
  "ua": {
    "os": "Windows 7"
  }
}
```
##### （1）字段的引用：`[]`

如果需要引用os字段的内容：`"[ua][os]"`

注意在hash（即字典）类型中，字段的引用：`.`
```ruby
mutate {
  convert => {
    "request.time" => "float"   #也就是[request][time]
  }
}
```

##### （2）格式化：`%{}`
格式化和字段引用的区别，格式化引用时，字符串内会有其他内容：
`"操作系统为：%{[ua][os]}"`和`"[ua][os]"`
`"类型为：%{type}"`和`[type]`
```ruby
output {
  statsd {
  increment => "apache.%{[response][status]}"   #会用 key为[reponse][status]的值 的值，填充 %{...}
  }
  file {
    path => "/var/log/%{type}.%{+yyyy.MM.dd.HH}"
  }
}
```

##### （3）条件判断
```ruby
if <EXPRESSION> {
  ...
} else if <EXPRESSION> {
  ...
} else {
  ...
}
```

* `<EXPRESSION>`语法
  * 比较：`==, !=, <, >, <=, >=`
  * 正则：`=~, !~`
  * 包含：`in, not in`
  * 复合表达式：`and, or, nand, xor, !`

比如:
```ruby
filter {
  if [action] == "login" {
    mutate { remove_field => "secret" }
  }
}
```

#### 3.特殊字段：`@metadata`
output时，不会输出该字段
输出`@metadata`字段
```ruby
output {
  stdout { codec => rubydebug { metadata => true }}
}
```

#### 4.使用系统的环境变量：`${}`
```ruby
${<VAR>}    #如果不存在<VAR>这个环境变量，启动logstash会报错
${<VAR>:<DEFAULT_VAR>}    #如果不存在<VAR>这个环境变量，会用默认值：<DEFAULT_VAR>
```
如果环境变量改变了，logstash需要重启才能生效
