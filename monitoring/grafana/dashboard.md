# dashboard

[toc]

### virtualizations组件

#### 1.table
多行合并为一行的条件：
* timestamp
* 可以有多个不同的label，但相同的label的值必须相同

***

### 常用dashboard

[dashboard网站](https://grafana.com/grafana/dashboards/)

#### 1.监控Node（基础信息）：8919

![](./imgs/dashboard_linux_01.png)

* 可能需要修改一下table（存在bug）:
![](./imgs/bug_01.png)

#### 2.监控Node（全量信息）: 1860
* 包括网络的详细信息、系统的详细信息等

![](./imgs/dashboard_linux_02.png)

#### 3.监控prometheus：3681

![](./imgs/dashboard_prometheus_01.png)

#### 4.监控blackbox: 7587
![](./imgs/dashboard_blackbox.png)

#### 5.监控k8s：15520、11454

* 系统状态: 15520
![](./imgs/dashboard_k8s_01.png)
![](./imgs/dashboard_k8s_02.png)

* pv状态: 11454
![](./imgs/dashboard_k8s_03.png)
![](./imgs/dashboard_k8s_04.png)

* apiserver: 12006
![](./imgs/dashboard_k8s_05.png)

#### 6.监控etcd: 9733
![](./imgs/dashboard_etcd_01.png)

#### 7.监控ceph: 2842
![](./imgs/dashboard_ceph_01.png)
