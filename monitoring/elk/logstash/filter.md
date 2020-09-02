[toc]

#### 1.date
从**给定字段**中，**完全匹配**出日期（即字段不能有其他内容），**作为**`@timestamp`字段

表示方式：
* 年 y
* 月 M
* 日 d
* 时 H
* 分 m
* 秒 s（十分之一秒：S，百分之一秒：SS，千分之一秒：SSS
* 时区 Z    (一个Z表示的格式：+0800)
* 时区名 z
* AM和PM a
比如：`yyyy-MM-dd HH:mm`会匹配`2020-10-1 01:11`这种格式

* 当时间中穿插了其他字母数字时，要用单引号过滤掉
  * 比如：`2020-10-1 0aa1:11`，format就要写成`yyyy-MM-dd H'aa'H:mm`
```shell
date {
  #<FORMAT>为时间的格式
  #当<FORMAT1>不能匹配时，会用后面的format继续匹配
  match => [ "<FIELD>", "<FORMAT1>"，"<FORMAT2>"]    

  #当从上面匹配不到时区时，会用下面设置的时区
  timezone => "Asia/Shanghai"
}
```

#### 2.drop
结合if判断语句，可以实现丢弃某些events
```python
if [loglevel] == "debug" {
  drop { }
}
```

#### 3.fingerprint
```shell
fingerprint {
  source => ["@timestamp", "message"]    #指定根据哪些字段计算hash值
  method => "SHA1"                       #指定使用的hash算法
  key => "0123"                          #指定hmac的key
  target => "[@metadata][generated_id]"  #指定生成的结果保存在哪个字段中
}
```

#### 4.mutate
改变字段，包括增加、删除、重命名、分割等

* 重命名某个字段
```shell
mutate {
  rename => {
    "HOSTORIP" => "client_ip"
  }
}
```

* 删除字段的两端的空格
```shell
mutate {
  strip => ["field1", "field2"]
}
```

* 修改数据类型
```shell
mutate {
  convert => {
    "<FILED_NAME>" => "<TYPE>"
  }
}
```

#### 5.dns（解析域名）
解析域名，并替换成ip
```shell
dns {
  reverse => [ "source_host" ]      #解析哪些字段的值
  action => "replace"               #用ip代替这些字段的值
}
```

#### 6.geoip（添加地理信息）
根据ip添加地理信息
```shell
geoip {
  source => "clientip"
}
```

#### 7.http（获取http接口数据进行解析）
与http接口结合，获取相关数据（header、body等），能够对这些数据进行清洗

#### 8.jdbc_static和jdb_streaming（访问数据库）
从数据库获取数据

#### 9.translate（实现字段映射）
```shell
filter {
  translate {
    field => "response_code"
    destination => "http_response"
    dictionary => {
      "200" => "OK"
      "403" => "Forbidden"
      "404" => "Not Found"
      "408" => "Request Timeout"
    }
    remove_field => "response_code"
  }
}
```

#### 10.grok
* 支持所有的正则表达式
* 在grok的match中，**字段的引用**不使用`[]`，而使用`.`
  * 比如`[filed][type]`就用`field.type`引用
* 使用小技巧：
  * 如果需要 匹配 **可能存在可能不存在的字段**
    * `(?:...)?`，...为需要匹配的pattern
  * **避免使用** **贪婪匹配**

##### （1）基本使用
```python
grok {

  match => {

    #会在<FILED_NAME>这个字段中，进行匹配
    "<FILED_NAME>" => "<PATTERN>"

    #会匹配多个pattern  
    "<FILED_NAME>" => ["<PATTERN>", "<PATTERN>"]  
  }

  overwrite => ["<FILED_NAME>"]   #允许覆盖指定字段的内容

  #默认就为这个，即匹配失败，会生成一个tags字段，内容为_grokparsefailure
  tag_on_failure => ["_grokparsefailure"]   

  keep_empty_captures => false    #默认为false，为true表示，即使没匹配到，也会增加相应字段，字段内容为空
}
```

##### （2）常用内置pattern
使用：`%{<PATTERN_NAME>:<FILED_NAME>}`
```python
IP          #用于匹配所有ip地址包括ipv4和ipv6
MAC         #用于匹配MAC
IPORHOST    #用于匹配 ip地址 或者 主机名
HOSTPORT    #用于匹配 %{IPORHOST}:%{POSINT}这种形式的数据

NUMBER      #用于匹配 数字
WORD        #用于匹配 单词

PATH        #用于匹配 绝对路径
URIPATH     #用于匹配 uri路径
URI         #用于匹配 URI

LOGLEVEL    #用于匹配 日志级别

TIME        #用于匹配时间  时:分:秒
DATE        #用于匹配日期  年/月/日  年-月-日  年.月.日
DATESTAMP   #用于匹配 日期+时间   %{DATE}[- ]%{TIME}
TZ          #用于匹配时区
```

##### （3）自定义pattern
* 方式一：直接写正则
```shell
(?<filed_name>pattern)    #这是正则的写法，将匹配的内容存放在一个组内，并命名这个组为filed_name
                          #所以这里，匹配pattern的内容，会放在field_name中保存
```

* 方式二：将匹配规则写在文件中
  * 创建一个目录，在该目录下创建一个文件，文件格式如下：
  ```shell
  <PATTERN_NAME> <PATTERN>
  ```
  * 使用
  ```shell
  grok {
    patterns_dir => ["<DIR>"]
    match => {
      "message" => "... %{<PATTERN_NAME>:<FILED_NAME> ... }"
    }
  }
  ```
