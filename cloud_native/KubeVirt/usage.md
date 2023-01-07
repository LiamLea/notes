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
            bridge: {}
        resources:
          requests:
            memory: 64M  #内存一定要给够，不然机器可能无法启动
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containerdisk
          containerDisk:
            image: quay.io/kubevirt/cirros-container-disk-demo
        #如果需要使用cloud-init，一定要设置（具体设置的内容可以为空），这样clou-init才能读取到metadata相关信息
        - name: cloudinitdisk
          cloudInitNoCloud:
            userData: |-
              #cloud-config
              ssh_pwauth: true
              users:
               - name: root
                 lock_passwd: false
                 plain_text_passwd: cangoal
```

#### 1.磁盘配置

##### （1）volumes（实际的存储）
常用的类型：
* cloudInitNoCloud 和 cloudInitConfigDrive（如果需要使用cloud-init，这里必须设置其中一个）
  * 如果需要使用cloud-init，一定要设置（具体设置的内容可以为空），这样clou-init才能读取到metadata相关信息，否则cloud-init不会生效
  * 设置cloud-init，这两个都是cloud-init的配置源（都能配置user data）
```yaml
volumes:
- name: cloudinitdisk
  cloudInitNoCloud:
    userData: |-
      #cloud-config
      ssh_pwauth: true
      users:
       - name: root
         lock_passwd: false
         plain_text_passwd: cangoal
```

* persistentVolumeClaim
  * disk要求
    * 命名：disk.img
    * 目录: /
    * 所属用户id: 107
    * 格式: raw
```yaml
volumes:
  - name: mypvcdisk
    persistentVolumeClaim:
      claimName: mypvc
```

* datavolume（建议）
  * 需要cdi支持，能够自动将镜像传入，不需要手动创建pvc，并上传image
  * 先创建一个nginx服务，然后把需要的镜像放在里面：http://10.10.10.250:8080/cirros-0.4.0-x86_64-disk.img
  * 注意：当虚拟机删除，相应的datavolume和pvc也会被删除（如果需要保留，使用另一种方式，即先创建datavolume，然后创建虚拟机时，指定使用该datavolume）
```yaml
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  creationTimestamp: null
  labels:
    kubevirt.io/vm: vm-cirros-datavolume
  name: vm-cirros-datavolume
spec:
  dataVolumeTemplates:
  - metadata:
      creationTimestamp: null
      name: cirros-dv
    spec:
      pvc:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 30G  #要大于操作系统磁盘的大小（不是镜像的大小）
      source:
        http:
          url: http://10.10.10.250:8080/centos-7-cloud-template
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/vm: vm-datavolume
    spec:
      networks:
      - name: default
        pod: {}
      domain:
        devices:
          disks:
          - disk:
              bus: virtio
            name: datavolumevolume
          - name: cloudinitdisk
            disk:
              bus: virtio
          interfaces:
          - name: default
            bridge: {}
        machine:
          type: ""
        resources:
          requests:
            memory: 2G      #内存一定要给够，不然机器可能无法启动
      terminationGracePeriodSeconds: 0
      volumes:
      - dataVolume:
          name: cirros-dv
        name: datavolumevolume
      - name: cloudinitdisk
        cloudInitNoCloud:
          userData: |-
            #cloud-config
```

* containerDisk
  * 提供了将vm disks存储在镜像仓库的能力
  * 不能提供持久化存储
  * 制作containerDisk镜像
```shell
cat << END > Dockerfile
FROM scratch
ADD --chown=107:107 fedora25.qcow2 /disk/
END

docker build -t vmidisks/fedora25:latest .
```

```yaml
metadata:
  name: testvmi-containerdisk
apiVersion: kubevirt.io/v1
kind: VirtualMachineInstance
spec:
  domain:
    resources:
      requests:
        memory: 64M
    devices:
      disks:
      - name: containerdisk
        disk: {}
  volumes:
    - name: containerdisk
      containerDisk:
        image: vmidisks/fedora25:latest
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
spec:
  domain:
    devices:
      #配置网卡
      interfaces:
      - name: <interface_name>   #不是虚拟机中显示的网卡名
        bridge: {}    #使用bridge和pod网络，则分配的ip就是pod的pid
  #配置网络
  networks:
  - name: <interface_name>
    pod: {}           #只有一个网卡能够使用pod网络
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
[参考](https://kubevirt.io/2020/KubeVirt-installing_Microsoft_Windows_from_an_iso.html)
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

#### 4.导出虚拟机磁盘
[参考](https://kubevirt.io/user-guide/operations/export_api/)
注意：要导出的pvc等，需要支持fsgroup
##### （1）导出pvc

* 需要先停止虚拟机
```shell
virtctl vmexport create <vm_exporter_name> --pvc=<pvc> -n <ns>
kubectl get virtualmachineexports -n <ns>

#查看下载链接: links.internal
kubectl get virtualmachineexports -n <ns> -o yaml

#当virtualmachineexports状态为ready时，就可以下载了
#暴露service
kubectl edit svc <vm_exporter_name> -n <ns>

#查看token，并且需要解码：base64 -d
kubectl get secret <secret_name> -n <ns>  -o yaml

#下载镜像，根据暴露的地址修改链接
curl -v --insecure -H "x-kubevirt-export-token: c0Gtf2nq9tryghgCRhVd" https://10.10.10.163:33137/volumes/cirros-dv/disk.img --output a.img


#下面这种下载方法，需要external link（只有创建ingress，与virt-exportpross这个service关联，才会有自动生产external link）
virtctl vmexport download --insecure <vm_exporter_name> --output=<output_name> -n test

#删除vmexport
virtctl vmexport delete <vm_exporter_name> -n test
```
