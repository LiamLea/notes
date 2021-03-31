[toc]
#### 1.常用公式

* 过滤
```shell
METRIC{KEY=VALUE}
#比如：node_cpu_seconds_total{mode="idle"}
#得到cpu处于idle的总时间
```

* `increate(METRIC[TIME])`
```shell
last值-first值
#比如：increase(node_cpu_seconds_total{mode="idle"}[1m])
#得到每个cpu每1分钟，cpu处于idle增长的时间
```

* `sum(METRIC)`
```shell
#把输出的结果集进行加和（因为可能有多个instance的数据）
#比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))
#得到所有服务器的所有cpu每1分钟，cpu处于idle增长的时间
```

* 按标签分类
```shell
by(LABEL)
#比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))by(instance)
#得到每台服务器的所有cpu每1分钟，cpu处于dle增长的时间
```

* `rate(METRIC[TIME])`（当TIME >= 采集周期 时，则rate不会返回任何结果）
```shell
(last值-first值)/时间差s
#配合counter类型数据使用
```

* `topk(N,METRIC)`
选出该指标项的前N个较大值
</br>
* `count(EXPRESSION)`

#### 2.常用语句
```shell
count({instance=~".+"})by(instance)

{instance="192.168.41.167:9100"}
```
