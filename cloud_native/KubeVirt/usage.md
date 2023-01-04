# usage

[toc]

### 清单文件
```yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: testvm
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/size: small
        kubevirt.io/domain: testvm
    spec:
      domain:
        devices:
          disks:
            - name: containerdisk
              disk:
                bus: virtio
            - name: cloudinitdisk
              disk:
                bus: virtio
          interfaces:
          - name: default
            masquerade: {}
        resources:
          requests:
            memory: 64M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containerdisk
          containerDisk:
            image: quay.io/kubevirt/cirros-container-disk-demo
        - name: cloudinitdisk
          cloudInitNoCloud:
            userDataBase64: SGkuXG4=
```

#### 1.磁盘配置

##### （1）volumes（实际的存储）
常用的类型：
* persistentVolumeClaim
* containerDisk

```yaml
spec:
  volumes:
    - name: containerdisk
      containerDisk:
        image: quay.io/kubevirt/cirros-container-disk-demo
```

##### （2）disks（虚拟机的磁盘）
* 三类disk：
  * disk（普通磁盘）
  * cdrom（cd）
  * lun（不常用）
```yaml
spec:
  domain:
    devices:
      disks:
        - name: <volume_name>
          #指定disk类型：这里为disk
          disk:
            #指定bus类型，支持的值：virtio, sata, scsi, usb
            bus: virtio
```

#### 2.网卡配置
```yaml
devices:
  interfaces:
  - name: default
    masquerade: {}
```

***

### 使用

#### 1.管理虚拟机
```shell
#查看虚拟机
kubectl get vms -n <ns>

#启动
kubectl patch vms <vm_name> -n <ns> --type merge -p \
    '{"spec":{"running":true}}'
#停止
kubectl patch vms <vm_name> -n <ns> --type merge -p \
    '{"spec":{"running":false}}'
#重启
kubectl delete vms <vm_name> -n <ns>
```

```shell
#使用virtctl
virtctl start <vm_name> -n <ns>
virtctl stop <vm_name> -n <ns>
virtctl restart <vm_name> -n <ns>
virtctl console <vm_name> -n <ns>


virtctl expose virtualmachine <vm_name> -n <ns> --name <service_name> --port 27017 --target-port 22
```

#### 2.访问虚拟机
[参考](https://kubevirt.io/user-guide/virtual_machines/accessing_virtual_machines/)

* 直接访问控制台

```shell
virtctl console testvm
#退出: ctrl + ]
```

* 通过VNC
```shell
virtctl vnc --proxy-only --address=0.0.0.0 --port 39047 testvm
#需要借助guacamole，访问暴露的VNC
```


#### 3.创建windows虚拟机

##### （1）上传windows iso
```shell
#查看暴露的uploadproxy-url地址（即部署时通过node-exporter暴露的地址）
kubectl get svc -n cdi

virtctl image-upload \
   --image-path=/tmp/Windows.iso \
   --pvc-name=iso-win10 \
   --access-mode=ReadWriteMany \
   --pvc-size=5G \
   --insecure \
   --uploadproxy-url=https://10.10.10.163:31001 \
   --wait-secs=240 \
   -n test
```

##### （2）创建windows虚拟机
```shell
vim win10.yaml
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: winhd
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
      ---
      apiVersion: kubevirt.io/v1alpha3
      kind: VirtualMachine
      metadata:
        name: win2k12-iso
      spec:
        running: false
        template:
          metadata:
            labels:
              kubevirt.io/domain: win2k12-iso
          spec:
            domain:
              cpu:
                cores: 4
              devices:
                disks:
                - bootOrder: 2
                  cdrom:
                    bus: sata
                  name: cdromiso
                - bootOrder: 1
                  disk:
                    bus: virtio
                  name: harddrive
                - cdrom:
                    bus: sata
                  name: virtiocontainerdisk
              machine:
                type: q35
              resources:
                requests:
                  memory: 8G
            volumes:
            - name: cdromiso
              persistentVolumeClaim:
                claimName: iso-win10
            - name: harddrive
              persistentVolumeClaim:
                claimName: winhd
            - containerDisk:
                image: kubevirt/virtio-container-disk
              name: virtiocontainerdisk
```
```shell
kubectl apply -f win10.yaml -n test
```

##### （3）启动虚拟机
```shell
virtctl start win2k12-iso -n test
```
