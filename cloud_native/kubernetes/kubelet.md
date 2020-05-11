# kubelet
[toc]
### 概述
#### 1.相关启动参数
|参数|说明|
|-|-|
|--kubeconfig|kubeconfig文件的路径，指定如何连接API server|
|--config|指定配置文件|
[更多参数](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
### 配置kubelet
#### 1.配置方式
* 通过systemd启动时，在环境变量指定启动参数
EnvironmentFile
Environment
ExecStart
</br>
* 启动kubelet时，通过 --config=xx 参数指定yaml配置文件
```yaml
aipVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
...
```
* 通过configmap动态配置

#### 2.通过--config=xx 指定yaml文件
yaml文件的格式参考：
```yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1

evictionHard:
    memory.available:  "200Mi"    #当memory可用量为小于等于200M时，开始强制终止某些pods
#...
```
[清单格式](https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/kubelet/config/v1beta1/types.go)

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
