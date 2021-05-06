# config

```yaml
#当client idle时间持续<INT>秒时，则关闭这个连接
#默认为0，表示disable这个功能
timeout <INT | default=0>

#当server和client之间没有通信时，server每隔一段时间发送ACK到client
#如果client没有回复，表示该连接已经死了，server会close该连接
#作用：
# 1.检查客户端是否存活（相当于心跳检测）
# 2.用于保活：当server和client中间的网络设备检测到没有流量时，会关闭这个连接
tcp-keepalive <INT | default=300>
```
