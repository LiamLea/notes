[toc]

#### 1.kafka
logstash从kafka消费数据，会commit offset到kafka，记录消费到哪个offset了
```shell
kafka {
  bootstrap_servers => "<IP:PORT>"
  topics => ["<TOPIC>"]
  auto_offset_reset => "earliest"     #当kafka中没有消费记录，就会使用这个选项
                                      #当设为earliest，表示从最开始开始消费
  group_id => "<GROUP>"     #同一个组，共用相同的消费记录
  codec => json             #反序列化，即输入的是json数据，反序列化成event格式
}
```
