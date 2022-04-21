# config

[toc]

* 老版的修改
* 修改（需要修改指定osd所在的主机上的ceph.conf）
```shell
$ vim /etc/ceph/ceph.conf
osd_backfill_full_ratio = 0.9
```
* 重启
```shell
#start ceph-osd id=<K>
#stop ceph-osd id=<K>
#restart ceph-mon id=nari-controller03
```
* 查看
```shell
ceph daemon {daemon-type}.{id} config show
#ceph daemon osd.0 config show
```
