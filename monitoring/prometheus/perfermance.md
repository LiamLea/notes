# perfermance

[toc]

### 压测

#### 1.avalanche工具
[github地址](https://github.com/open-fresh/avalanche)

##### （1）拉取镜像
```shell
docker pull quay.io/freshtracks.io/avalanche:latest
```

##### （2）查看命令参数
```shell
docker run  --rm quay.io/freshtracks.io/avalanche:latest --help
```

##### （3）使用参数
```shell
--metric-count=500    #metric数量
--series-count=10     #序列的数量，即每次采集，会有：500*10个sample

--label-count=10      #每个metric的标签数量
```
