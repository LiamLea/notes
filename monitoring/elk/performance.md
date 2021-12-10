# performance

[toc]

### optimizing

#### 1.optimize es

##### (1) jvm heap size
[reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options)
* set 50% of the total memory（max:30G）
```shell
#when allocate 16G for the pod
-Xmx8g -Xms8g
```

#### 2.optimize logstash


##### (1) jvm heap size
[参考](https://www.elastic.co/guide/en/logstash/current/jvm-settings.html)
* no exceed 75% of the total memory
* related to pipeline batch size
```shell
#when allocate 4G for the pod
-Xmx2g -Xms2g
```

##### (2) pipeline batch size

The maximum number of events an individual worker thread will collect from inputs
```yaml
#default: 125
#set 1000 or larger
pipeline.batch.size: 1000
```
