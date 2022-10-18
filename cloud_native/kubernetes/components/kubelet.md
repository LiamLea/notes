# kubelet

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kubelet](#kubelet)
    - [概述](#概述)
      - [1.相关启动参数](#1相关启动参数)
    - [配置kubelet](#配置kubelet)
      - [1.配置方式](#1配置方式)
        - [（1）启动kubeley时指定](#1启动kubeley时指定)
        - [（2）通过configmap动态配置](#2通过configmap动态配置)
      - [2.kubelet配置文件格式](#2kubelet配置文件格式)
      - [3.通过configmap动态配置](#3通过configmap动态配置)
    - [kubelet重要配置](#kubelet重要配置)
      - [1.DNS相关](#1dns相关)
      - [2.network plugin相关](#2network-plugin相关)
      - [3.kubelet预留资源](#3kubelet预留资源)
        - [（1）为k8s组件预留资源](#1为k8s组件预留资源)
        - [（2）为系统（非k8s组件）预留资源](#2为系统非k8s组件预留资源)

<!-- /code_chunk_output -->

### 概述
#### 1.相关启动参数
|参数|说明|
|-|-|
|--kubeconfig|指定如何连接API server的配置文件，</br>里面设置了API server的地址，<br>如果设置错误，该节点就无法加入k8s集群|
|--config|指定kubelet的配置文件|
[更多参数](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

***

### 配置kubelet

#### 1.配置方式

##### （1）启动kubeley时指定
* 通过systemd启动时，在环境变量指定启动参数
EnvironmentFile
Environment
ExecStart
</br>
* 启动kubelet时，通过 `--config=xx` 参数指定yaml配置文件
```yaml
aipVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
...
```

##### （2）通过configmap动态配置

#### 2.kubelet配置文件格式
yaml文件的格式参考：
```yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1

evictionHard:
    memory.available:  "200Mi"    #当memory可用量为小于等于200M时，开始强制终止某些pods
#...
```
[清单格式](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/)

#### 3.通过configmap动态配置
（1）前提条件是，kubelet启动时开起了允许动态配置
```shell
kubelet --feature-gates DynamicKubeletConfig=true
```
（2）修改configmap
```shell
kubectl edit cm kubelet-config... -n kube-system
```
（3）下发到指定node
```shell
kubectl edit nodes xx
```
```yaml
spec:
  configSource:
    configMap:
        name: CONFIG_MAP_NAME
        namespace: kube-system
        kubeletConfigKey: kubelet
```
（4）查看是否应用
```shell
kubectl get nodes xx -o yaml

#Node.Status.Config 检查节点状态配置
```

***

### kubelet重要配置

#### 1.DNS相关
```yaml
#指定cluster内部使用的dns地址
clusterDNS: <LIST>
#指定cluster所在的域
clusterDomain: <domain>

#当DNS policy设置Default时，就会使用这个文件配置dns
resolvConf: <resolv_file_path> #如果是redhaht系统，就设为/etc/resolv.conf
```

#### 2.network plugin相关
```shell
#指定使用的网络插件类型为cni
--network-plugin=cni

#指定cni的配置文件目录（当有多个文件时，按照字典顺序，读取第一个文件）
--cni-conf-dir=/etc/cni/net.d   #默认：/etc/cni/net.d

#指定cni类型插件的二进制可执行文件的目录（在上面的配置文件中，会指定具体使用哪些插件，会在该目录下寻找这些插件的二进制文件）
--cni-bin-dir=/opt/cni/bin      #默认：/opt/cni/bin
```

#### 3.kubelet预留资源

##### （1）为k8s组件预留资源
```yaml
kubeReserved:
  cpu: 1000m
  memory: 1Gi
  ephemeral: xx
  pid: "100"
```

##### （2）为系统（非k8s组件）预留资源
```yaml
systemReserved:
  cpu: 1000m
  memory: 1Gi
  ephemeral: xx
  pid: "100"
```
