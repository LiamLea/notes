# traceroute
### 1.原理
```
每个ip包都有一个ttl字段，用于设置最大的跳数，
如果超过这个跳数还没到达目的地，则会丢弃该ip包，
并通知发送方（利用类型为time-exceeded的icmp包通知）
```
