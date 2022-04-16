# deploy

[toc]

### deploy
```shell
mkdir /root/nexus-data
chown -R 200 /root/nexus-data

docker run --restart always --name nexus -d -p 8081:8081 -v /root/nexus-data:/nexus-data 10.10.10.250/library/sonatype/nexus3:3.38.1
```
