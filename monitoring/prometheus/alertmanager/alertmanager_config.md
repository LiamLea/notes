[toc]

### 概述

#### 1.有以下部分
* 全局配置：`global`
* 路由配置：`route`
* 接收者配置：`receiver`
* 抑制配置：`inhibit_rules`

#### 2.group
用于对告警分组，当一定时间内有多条告警产生，会将同一个group的告警，通过一条消息发过去
根据label和label的值进行分组，值相同的为一组

***

### 配置

#### 1.配置格式
```yaml
  global: <global>    #全局配置

  receivers:        #接收者设置
  - <receiver>

  route: <route>    #路由配置

  inhibit_rules:    #抑制规则配置
  - <inhibit_rule>
```

#### 2.全局配置（`<global>`）
全局的配置，在单个配置下可以覆盖全局的配置
```yaml
http_config: <http_config>
#等等
```


#### 3.receiver配置（`<receiver>`）

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

##### （3）发送的告警格式
这里只列出关键信息
注意：resolved通过`{{ $value }}`取到的值不是最新的，这是prometheus的机制导致的，[参考](https://www.robustperception.io/why-do-resolved-notifications-contain-old-values)
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
      "labels": {},                   //该条告警的labels
      "annotations": {},              //该条告警的annatations
      "startsAt": "开始时间",
      "endsAt": "结束时间，0001-01-01T00:00:00Z这样表示，信息发送时，该告警未恢复",
      "generatorURL": "url查看该告警的产生原因",
      "Fingerprint": "规则id，唯一标识产生该告警的规则（根据labels生成的指纹）"  
    }
  ]
}
```

#### 4.route和group配置（`<route>`）

##### （1）路由树
* 成功匹配上层路由后，才能继续匹配子路由

##### （2）group
* 当产生告警后，告警会加入相应的grouop中，然后告警的状态一直会存在该group中，当该group中所有告警的状态都变为reloved，才会清空该group中所有告警
* 没有清空时，只要发送一次该group中告警的状态，就会包含reloved的状态的告警

* 没有设置分组时，未分组的属于一组

```yaml
#匹配alert（下面两种匹配方式可以同时使用）
#如果不设置匹配，表示匹配所有alerts
match:    #完全匹配
  <labelname>: <labelvalue>
match_re:   #正则匹配
  <labelname>: <regexp>

#是否继续匹配后面的同级路由（对routes有效）
continue: <boolean | default = false>

#指定接收者的名称
receiver: <string>   

#指定用什么label进行分组（根据label的值进行分组，值相同的为一组）
group_by:
- <labelname>

#准备发送一组alerts，需要等待的时间，一次可以发送更多的告警
#主要是为了抑制告警，因为这个告警的根因是另一个告警，但是这个告警先产生了，根因很快也会产生，所以等待一段时间，如果根因产生了，这个告警就会被抑制
group_wait: <duration | default=30s>

#同一组发送的时间间隔，距离上一次发送通知的间隔（当有新的告警加入该组）
#注意：告警恢复也是新的告警
#如果在这个期间，告警resolved，然后又firing，相当于没有新的告警
group_interval: <duration | default=5m>
#同一组发送的时间间隔（当没有新的告警加入该组）
repeat_interval: <duration | default=4h>

#子路由
routes:
- <route>   #这里的配置格式就是route的配置格式
```

#### 5.inhibit配置（`<inhibit_rule>`）
**注意**：当一个告警 既匹配源告警 又 匹配目标告警，是不会被抑制的

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

***

### 与第三方应用结合

#### 1.发送告警到钉钉

[参考](https://github.com/timonwong/prometheus-webhook-dingtalk)

##### （1）创建配置文件
```shell
vim /etc/dingtalk/config.yaml
```

```yaml
targets:
  webhook1:
    url: https://oapi.dingtalk.com/robot/send?access_token=09935dc01b6beccc3e485abcf7c8f4a74114630fd38a8db126efb612a46c3633
    # secret for signature
    secret: SEC2f054a2c5f2cda5801a3d25ead7c1b741b03f6638bf4a7980c6e05aa8746c13a
```

##### （2）启动
```shell
docker run --rm -itd -v /etc/dingtalk/config.yaml:/etc/dingtalk/config.yaml -p 8060:8060 timonwong/prometheus-webhook-dingtalk:master --config.file=/etc/dingtalk/config.yaml
```

##### （3）获取webhook的地址
查看启动日志，webhook在日志中：
urls=http://localhost:8060/dingtalk/webhook1/send

##### （4）测试
```shell
curl -H "Content-Type: application/json" -d '{"test": "alertmanager"}' http://10.10.10.191:8060/dingtalk/webhook1/send
```

##### 在k8s上部署
```yaml
apiVersion: v1
data:
  config.yaml: |
    targets:
      webhook1:
        url: https://oapi.dingtalk.com/robot/send?access_token=09935dc01b6beccc3e485abcf7c8f4a74114630fd38a8db126efb612a46c3633
        secret: SEC2f054a2c5f2cda5801a3d25ead7c1b741b03f6638bf4a7980c6e05aa8746c13a
kind: ConfigMap
metadata:
  name: alertmanager-webhook-dingtalk

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: alertmanager-webhook-dingtalk
spec:
  selector:
    matchLabels:
      app: alertmanager-webhook-dingtalk
  template:
    metadata:
      labels:
        app: alertmanager-webhook-dingtalk
    spec:
      volumes:
        - name: config
          configMap:
            name: alertmanager-webhook-dingtalk
      containers:
        - name: alertmanager-webhook-dingtalk
          image: timonwong/prometheus-webhook-dingtalk:master
          args:
            - --web.listen-address=:8060
            - --config.file=/config/config.yaml
          volumeMounts:
            - name: config
              mountPath: /config
          resources:
            limits:
              cpu: 100m
              memory: 100Mi
          ports:
            - name: http
              containerPort: 8060

---

apiVersion: v1
kind: Service
metadata:
  name: alertmanager-webhook-dingtalk
spec:
  selector:
    app: alertmanager-webhook-dingtalk
  ports:
    - name: http
      port: 80
      targetPort: http
```
