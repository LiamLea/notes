[toc]

### 概述

#### 1.有以下部分
* 全局配置：`global`
* 路由配置：`route`
* 接收者配置：`receiver`
* 抑制配置：`inhibit_rules`

***

### 全局配置
全局的配置，在单个配置下可以覆盖全局的配置
```yaml
http_config: <http_config>
#等等
```

***

### receiver配置

##### （1）基础配置
```yaml
name: <string>

email_configs:
- <email_config>

webhook_configs:
- <webhool_config>

#等等
```

##### （2）webhook配置
```yaml
#告警恢复是否发送消息
send_resolved: <boolean | default = true>

url: <string>

http_config: <http_config | default = global.http_config>

#单个消息中最多包含的告警数量
#默认为0，表示不限制
max_alerts: <NUM | default = 0>
```

* 发送消息格式
这里只列出关键信息
```json
{
  "groupKey": "用于唯一标识这个组",    //由标签和标签值生成
  "groupLabels": {"<labelname>":"<labelvalue>"},  //用于分组的标签和标签值（有多个）
  "truncatedAlerts": <int>,        //由于"max_alerts"没有发送alerts的数量

  "status": "<resolved|firing>",   //具体要看alert的status（因为一条消息可以同时包括 告警和恢复 的alerts

  "commonLabels": {},         //下面所有alerts相同的标签
  "commonAnnotations": {},    //下面所有alerts相同的注释

  "alerts": [                       //这次发送的所有alerts详细信息
    {
      "status": "<resolved|firing>",  //resolved是告警恢复时发送的信息
                                      //firing是告警产生时发送的信息
      "labels": "该条告警的labels",
      "annotations": "该条告警的annatations",
      "startsAt": "开始时间",
      "endsAt": "结束时间，0001-01-01T00:00:00Z这样表示，信息发送时，该告警未恢复",
      "generatorURL": "url查看该告警的产生原因"
    }
  ]
}
```

***

### route和group配置
路由树
* 成功匹配上层路由后，才能继续匹配子路由

```yaml
#匹配alert（下面两种匹配方式可以同时使用）
#如果不设置匹配，表示匹配所有alerts
match:    #完全匹配
  <labelname>: <labelvalue>
match_re:   #正则匹配
  <labelname>: <regexp>

#是否继续匹配子路由
continue: <boolean | default = false>

#指定接收者的名称
receiver: <string>   

#指定用什么label进行分组（根据label的值进行分组，值相同的为一组）
group_by:
- <labelname>
#准备发送一组alerts，需要等待的时间，为了一次能发送更多的告警
group_wait: <duration | default=30s>
#同一组发送的时间间隔（当有新的告警加入该组）
group_interval: <duration | default=5m>
#同一组发送的时间间隔（当没有新的告警加入该组）
repeat_interval: <duration | default=4h>

#子路由
routes:
- <route>   #这里的配置格式就是route的配置格式
```

***

### inhibit配置
注意：当一个告警既匹配源告警又匹配目标告警，是不会被抑制的
```yaml
inhibit_rules:
  #匹配出目标告警（即需要被抑制的告警）
- target_match:
    <labelname>: <labelvalue>
  target_match_re:
    <labelname>: <regexp>

  #匹配出源告警（即被依赖的告警，即当源发送，目标告警才有可能被抑制）
  source_match:
    <labelname>: <labelvalue>
  source_match_re:
    <labelname>: <regexp>

  #设置抑制的条件
  #当源告警和目标告警，下面的标签相等时，目标告警才会被抑制
  #注意： 没有相应的标签 和 该标签内容为空 是equal的
  equal:
  - <labelname>
```
