[toc]
### 使用
两台机器都需执行
#### 1.设置GRE
##### （1）启动linux的GRE模块
```shell
modprobe ip_gre
```

##### （2）创建隧道（tunnel）
```shell
ip tunnel add <TUNNEL_NAME> mode gre remote <REMOTE_REAL_IP> local <LOCAL_REAL_IP>
```

##### （3）启动隧道
```shell
ip link set <TUNNEL_NAME> up
```

##### （4）配置VIP
```shell
ip addr add <LOCAL_VIP> peer <REMOTE_VIP> dev <TUNNEL_NAME>
```

##### （5）测试
```shell
ping <REMOTE_VIP>   #能够ping表示配置成功
```

#### 2.使用GRE
场景描述：
机器一无法访问外网，机器二可以访问，
所以需要将机器一的所有流量从机器二走
* 机器一：3.1.5.19（vip：10.10.10.1）
* 机器二：3.1.1.101（vip：10.10.10.2）

##### （1）开启路由转发功能
```shell
echo 1 > /proc/sys/net/ipv4/ip_forward
```

##### （2）在机器一上设置路由
* 内部网络，走的是 之前的网关
```shell
ip route add 3.1.0.0/16 via 3.1.5.254
```

* 将机器二的vip设置为网关
路由的优先级可以通过metric参数调节，metric越小优先级越高
```shell
ip route add 0.0.0.0/0 via 10.10.10.2
```

##### （3）在机器二上设置SNAT
即从机器一来要外出的流量，都将源地址修改成机器二的源地址（3.1.1.101），如果源地址依然为10.10.10.1，则就收不到返回的包（因为机器二的网关根本不认识10.10.10.1）
```shell
iptables -t nat -A POSTROUTING -s 10.10.10.1  -j SNAT --to-source 3.1.1.101
```
