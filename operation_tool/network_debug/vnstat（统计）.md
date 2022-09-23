# vnstat

[toc]

### 使用

#### 1.初始化

* 修改成用root启动vnstatd
```shell
#如果用默认用户，可能存在一些文件读取的问题

$ vim /etc/systemd/system/vnstatd.service
User=root

$ systemctl daemon-reload
```

* 存储指定网卡的流量
```shell
#从执行命令开始存储
vnstat --create -i <INTERFACE>

#需要重启服务
systemctl restart vnstat
```

##### 2.安装前端页面：vnstat-php-frontend
* 将网页文件放到http服务器根目录
* 修改配置
```shell
$ vim vnstat/config.php

#设置vnstat信息：数据目录、可执行文件位置
$data_dir = '/var/lib/vnstat';
$vnstat_bin = '/usr/bin/vnstat';

#指定要展示的网卡
$iface_list = array('ens192', 'ens224');

#设置显示标题
$iface_title['ens192'] = 'ens192 monitoring';
$iface_title['ens224'] = 'ens224 monitoring';

#将语言修改为英语
$language = 'en';

#设置时区
date_default_timezone_set("Asia/Shanghai);
```
