[toc]

### 概述
### 配置
#### 1.`kubeadm-config`配置文件
* kubeadm init
会在kube-system命名空间下生成一个名为kubeadm-config的configmap资源
</br>
* kubeadm join等
会读取kubeadm-config这个configmap里面的配置
