# usage

[toc]

### 安装jenkins（docker)

```shell
mkdir /root/jenkins-data
mkdir /root/jenkins-docker-certs
chmod 777 /root/jenkins-data
chmod 777 /root/jenkins-docker-certs

docker run --restart always -p 8080:8080 -itd -v /root/jenkins-data:/var/jenkins_home -v /root/jenkins-docker-certs:/certs/client:ro -v /bin/docker:/bin/docker -v /var/run/docker.sock:/var/run/docker.sock --group-add <docker_group_id> 10.10.10.250/library/jenkins/jenkins:2.332.2-jdk11
```

***

### 使用jenkins agent

agent用于执行controller下发的任务，安装好jenkins后，默认有一个build-in agent（即本地的agent）

#### 1.传统的静态agent
agent需要一直运行着，并与controller保持连接，通过ssh或者其他相关协议

#### 2.基于云（docker或者k8s）的动态agent
需要创建agent模板，当指定用该agent执行任务时，会自动创建agent（即容器或者pod）去执行任务，当任务执行完成会自动删除该agent

#### 3.常用agent镜像（必须安装好了java）

* 能够方面使用，需要添加以下参数：
  * `-v /bin/docker:/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -u root`

|agent image|extra args|description|
|-|-|-|
|`maven:3.8.5-openjdk-8`||提供maven|
