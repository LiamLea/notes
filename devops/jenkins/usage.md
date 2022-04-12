# usage

[toc]

### 安装jenkins（docker)

```shell
mkdir /root/jenkins-data
mkdir /root/jenkins-docker-certs
chmod 777 /root/jenkins-data
chmod 777 /root/jenkins-docker-certs

docker run --rm --network host -itd --volume /root/jenkins-data:/var/jenkins_home --volume /root/jenkins-docker-certs:/certs/client:ro jenkins/jenkins:2.332.2-jdk11
```

***

### 使用jenkins agent
