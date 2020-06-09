### 配置
```shell
#设置（名称:协议）的映射，一个名称就是一个listener
#这里定义了两个listener，一个是EXTERNAL，一个是INTERNAL
listener.security.protocol.map = EXTERNAL:PLAINTEXT,INTERNAL:PLAINTEXT

#设置listener监听的地址（listener已经在上面定义）
listeners = EXTERNAL://:9092,INTERNAL://:9093

#对外宣称的listener地址（listener已经在上面定义）
advertised.listeners = EXTERNAL://3.1.5.15:30909,INTERNAL:3.1.5.15:30910

#用于设置broker之间进行通信时采用的listener名称
inter.broker.listener.name = INTERNAL
```
