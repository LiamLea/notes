[toc]

### 概述
#### 1.特点
* 用于创建k8s集群
* 配置的主要内容：
  * 集群的基本信息（集群名称）
  * etcd的存储目录
  * 网络相关（域名、使用的网段）

***

### 配置
#### 1.`kubeadm-config`配置文件
* kubeadm init
会在kube-system命名空间下生成一个名为kubeadm-config的configmap资源
</br>
* kubeadm join等
会读取kubeadm-config这个configmap里面的配置
