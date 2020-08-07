# switch
[toc]
### 基础
#### 1.port的命名
```shell
<TYPE><SLOT>/<SUBSLOT>/<PORT>

#<TYPE>表示该端口的类型：
#   Ten-GigabitEthernet：10G以太口
#   FortyGigE：40G以太口
#   M-GigabitEthernet：M表示management，表示是管理口
#<SLOT>表示在第几个插槽（从0开始），（堆叠时，一般一个交换机就是一个插槽）
#<SUBSLOT>表示在该插槽上的哪个子插槽（从0开始）
#<PORT>表示在第几个端口上（从0开始）
```

#### 2.`PortIndex`、`IfIndex`和`IfName`
|Item|Description|
|-|-|
|IfName|Interface name|
|IfIndex|Index value of an interface|
|PortIndex|Index value of a port|

```shell
IfName                          IfIndex   PortIndex                             
--------------------------------------------------                              
GigabitEthernet0/0/0            8         0                                     
NULL0                           2         --                                    
Vlanif1                         6         --                                    
Wlan-Capwap0                    7         1                                     
Wlan-Radio0/0/0                 9         --                                    
Wlan-Radio0/0/1                 4         --    
```
***

### 使用
