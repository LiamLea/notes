# client

[toc]

### 使用

#### 1.分布式云管理（distributed cloud manager）：dcmanager
```shell
dcmanager subcloud list
dcmanager subcloud show <subcloud>
```

#### 2.故障管理（fault management）：fm

* 查看故障告警
```shell
fm alarm-list --mgmt_affecting --degrade_affecting --uuid
fm alarm-show <uuid>
```

* 查看历史故障告警和历史历史

```shell
fm event-list --alarm
fm event-list --log
```

#### 3.系统管理：system
```shell
#查看系统信息
system show
```

##### （1）主机相关
```shell
system host-list
system host-show <hsotname>   #能看出是active还是standby controller
```

##### （2）服务相关
*
```shell
system servicegroup-list
system service-list
system service-parameter-list
```

##### （3）应用相关
```shell
system application list
system application show <application>

helm-override-list
```

#### 4.打补丁：sw-patch
```shell
sudo sw-patch query
sudo sw-patch upload /home/sysadmin/WRCP_21.05_PATCH_0003.patch
sudo sw-patch apply --all
sudo sw-patch install-local
sudo reboot
```
