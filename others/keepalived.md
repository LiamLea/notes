# keepalived

[toc]

### 概述

#### 1.keepalived包含三个部分
* keepalived daemon
* VRRP
* health-check

#### 2.priority值的范围：-245~245

***

### 配置

#### 1.全局配置
一般不用配置，用默认的即可，下面是常用的全局配置
```shell
global_defs {
  vrrp_version <NUM:2>            #2不支持ipv6
  checker_log_all_failures  on    #如果check（健康检查）失败，则记录日志
  default_interface <INTERFACE>   #设置vip设置在哪个网卡上，默认是第一块网卡
  vrrp_iptables <CHAIN_NAME:INPUT>    #用iptables过滤包，默认用INPUT过滤
}

```

#### 2.VRRP配置
```shell
#定义脚本
#只有vrrp实例，track了指定的脚本，相应的脚本才会执行
vrrp_script <CUSTOME_NAME> {
  script "<COMMAND>"               #执行脚本时必须：/bin/bash <script_path>
  interval <INTEGER:1>          #调用脚本的频率，单位秒
  timeout <INTEGER>             #脚本超时时间，超时则认为执行失败
  weight <INTEGER:0>          #默认为0，表示脚本检测失败，则认为该vrrp实例状态是fail的
                              #当weight值 < 0时：
                              #   如果脚本检测成功，则节点优先级不变
                              #   如果脚本检测失败，则节点优先级 = 初始优先级 - 这里的值
                              #当weight值 > 0时：
                              #   如果脚本检测成功，则节点优先级 = 初始优先级 + 这里的值
                              #   如果脚本检测失败，则节点优先级不变
  rise <INTEGER>                #脚本执行成功多少次，则认为对应vrrp实例的状态是ok的
  fail <INTEGER>                #脚本执行失败多少次，则认为对应vrrp实例的状态是fail的
  user <USERNAME>               #指定用什么用户去执行脚本
  init_fail                     #认为对应vrrp实例的初始状态是down的
}


#定义vrrp实例
vrrp_instance <CUSTOME_NAME> {
  state Master                #BACKUP，设置初始状态
  interface <INTERFACE>       #指定vip设置了哪张网卡上，默认是default interface
  priority  100               #设置优先级，用于选举master
  virtual_router_id <1-255>   #标识 所属vrrp组
  advert_int 1                #设置master发送advertisement信息的频率（单位秒）
  accept                      #允许不是vip的机器，接收发给vip的数据包

  #如果用组播，发送网络包会比较多，可能会造成网络拥塞
  unicast_src_ip <IP>         #配置单播的源地址
  unicast_peer {              #配置单播的目标地址，可以有多个
    <IP>
  }

  virtual_ipaddress {         #设置vip
    <IP>
    <IP>/<MASK> dev eth0 label eth0:1
  }

  authentication {            #用于vrrp实例间通信的认证
    auth_type PASS
    auth_pass <PASSWORD>
  }

  #会执行上面定义的脚本
  track_script {
    <SCRIPT_NAME_1>
    <SCRIPT_NAME_2>
  }

  #其中一个网卡down掉且权重为0，则认为该vrrp实例是fail的状态
  track_inerface {
    <INTERFACE_1>
    <INTERFACE_2> weight <INTEGER:0>    #权重的作用同脚本的
  }

  notify_master "<COMMAND>"        #当状态切换为master时，执行
  notify_backup "<COMMAND>"        #当状态切换为backup时，执行
  notify_fault "<COMMAND>"         #当装她爱切换为fault时，执行
  notify "<COMMAND>"               #当状态切换时，执行
}
```

#### 3.demo

##### （1）脚本:`check.sh`
```shell
#/bin/bash
if [ `curl  --insecure -s --write-out  '%{http_code}' --output /dev/null -m 5 https://127.0.0.1:6443/healthz` == 200 ];then exit 0 ;else exit 1;fi
#-m   max-time，设置超时时间
```

##### （2）`keepalived.conf`
```shell
vrrp_script health_check {
    script "/bin/bash /etc/keepalived/check.sh"
    interval 1
    timeout 5
    rise 3
    fall 3
    user root
}

vrrp_instance VI_1 {
    state BACKUP  #当设置成nopreempt时，就必须是BACKUP
    nopreempt   #表示当高优先级加入时，该ip不会漂移过去，这样保证了稳定性（如果高优先级一会成功一会失败）
    virtual_router_id 249
    priority 241
    interface ens160
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    unicast_peer {
        3.1.5.242
        3.1.5.243
    }
    virtual_ipaddress {
        3.1.5.249
    }

    track_script {
      health_check
    }
}
```
