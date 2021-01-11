# network

[toc]

### 概述


#### 1.物理网卡
```            
                +-------------+   
                | Socket API  |   
                +-------------+              
User Space             |
-----------------------------------------------
Kernel Space           |
                 raw packets
                       |              
                +-------------+  
                |Network Stack|   
                +-------------+  
                       |                  
                +-------------+   
                |    eth0     |  
                +-------------+  
                       |                  
                +-------------+   
                |     NIC     |  
                +-------------+      
                       |   
                      wire
```

#### 2.network namesapce

##### （1）ip netns命令

* 创建netns
```shell
ip netns add <NAME>
```

* 列出所有netns
```shell
 ip netns list
```

* 在指定netns中执行命令
```shell
ip netns exec <NAME> <CMD>

#切换到指定netns中
ip netns exec <NAME> bash
```

##### （2）容器的netns
默认`ip netns`无法显示和操作容器中的netns
* 获取容器的pid
```shell
pid=`docker inspect -f '{{.State.Pid}}' <CONTAINER_ID>`
#根据pid可以找到netns：
#  /proc/<PID>/net/ns
```

* 创建`/var/run/netns/`目录
```shell
mkdir -p /var/run/netns/
```

* 将netns连接到`/var/run/netns/`目录下
```shell
ln -s /proc/<PID>/ns/net /var/run/netns/<CUSTOME_NAME>

#ip netns list就可以看到该netns
```


#### 3.判断设备属于何种类型（TUN/TAP、veth等）

* 判断设备属于哪种类型
```shell
ip -d link show <DEVICE_NAME>
```

* 判断某种类型有哪些设备
```shell
ip link show type <TYPE>  #<TYPE>：veth、bridge、dummy等
ip tuntap show
ip tunnel show
```
