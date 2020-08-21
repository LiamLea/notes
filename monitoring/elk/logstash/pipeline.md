[toc]

### pipeline内容配置（`xx.conf`）

```shell
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
```shell
name => "liyi"
```
##### （2）数组（常用列表）
```shell
users => [ {id => 1, name => bob}, {id => 2, name => jane} ]
```

##### （3）列表
```shell
path => [ "/var/log/messages", "/var/log/*.log" ]
uris => [ "http://elastic.co", "http://example.net" ]
```

##### （4）bool类型
```shell
ssl_enable => true
```

##### （5）hash（键值对的集合）
```shell
#注意使用空格分隔，而不是逗号分隔
match => {
  "field1" => "value1"
  "field2" => "value2"
  ...
}
```

##### （6）数字
```shell
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

如果需要引用os字段的内容：`[ua][os]`

##### （2）格式化：`%{}`
格式化和字段引用的区别，格式化引用时，字符串内会有其他内容：
`"操作系统为：%{[ua][os]}"`和`"[ua][os]"`
```shell
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
```shell
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
```shell
filter {
  if [action] == "login" {
    mutate { remove_field => "secret" }
  }
}
```

#### 3.特殊字段：`@metadata`
output时，不会输出该字段
输出`@metadata`字段
```shell
output {
  stdout { codec => rubydebug { metadata => true }}
}
```

#### 4.使用系统的环境变量：`${}`
```shell
${<VAR>}    #如果不存在<VAR>这个环境变量，启动logstash会报错
${<VAR>:<DEFAULT_VAR>}    #如果不存在<VAR>这个环境变量，会用默认值：<DEFAULT_VAR>
```
如果环境变量改变了，logstash需要重启才能生效
