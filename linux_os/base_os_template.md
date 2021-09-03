### 需要安装的软件
|软件名|说明|
|-|-|
|bash-completion|用于自动补全|
|python3||
|lsof||
|strace||
|tree||
|man-pages|能够查看系统的相关帮助|
|tcpdump||
|lrzsz||
|zip、unzip||

### 需要的配置
|文件名|配置项|说明|
|-|-|-|
|sshd_config|UseDNS no</br>GSSAPIAuthentication no|能够快速连接ssh|

### 需要关闭的服务
|服务名|说明|
|-|-|
|NetworkManager|会影响相关网络的配置|
|firewalld|防火墙|
|selinux||
