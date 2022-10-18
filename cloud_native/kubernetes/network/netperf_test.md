# netperf test

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [netperf test](#netperf-test)
    - [使用](#使用)
      - [1.修改nptest源码并生成镜像](#1修改nptest源码并生成镜像)
        - [（1）修改nptest源码](#1修改nptest源码)
        - [（2）生成镜像](#2生成镜像)
      - [2.修改launch源码（存在一个bug）并编译](#2修改launch源码存在一个bug并编译)
        - [（1）修改launch.go源码](#1修改launchgo源码)
        - [（2）构建代码](#2构建代码)
      - [3.执行测试](#3执行测试)
      - [4.查看执行进度（如果MSS跨度大的话，需要很久）](#4查看执行进度如果mss跨度大的话需要很久)
      - [5.分析执行结果](#5分析执行结果)
        - [（1）先将csv DATA数据复制出来](#1先将csv-data数据复制出来)
        - [（2）生成图表](#2生成图表)

<!-- /code_chunk_output -->

### 使用
[github地址](https://github.com/kubernetes/perf-tests/tree/master/network/benchmarks/netperf)

**如何使用查看：Makefile文件**

#### 1.修改nptest源码并生成镜像

##### （1）修改nptest源码
设置MSS的范围、设置测试哪几种情形等
```go
const (
	workerMode           = "worker"
	orchestratorMode     = "orchestrator"
	iperf3Path           = "/usr/local/bin/iperf3"
	netperfPath          = "/usr/local/bin/netperf"
	netperfServerPath    = "/usr/local/bin/netserver"
	outputCaptureFile    = "/tmp/output.txt"
	mssMin               = 1200
	mssMax               = 1460
	mssStepSize          = 64
	parallelStreams      = "8"
	rpcServicePort       = "5202"
	localhostIPv4Address = "127.0.0.1"
)

testcases = []*testcase{
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "1 iperf TCP. Same VM using Pod IP", Type: iperfTCPTest, ClusterIP: false, MSS: mssMin},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "2 iperf TCP. Same VM using Virtual IP", Type: iperfTCPTest, ClusterIP: true, MSS: mssMin},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w3", Label: "3 iperf TCP. Remote VM using Pod IP", Type: iperfTCPTest, ClusterIP: false, MSS: mssMin},
	{SourceNode: "netperf-w3", DestinationNode: "netperf-w2", Label: "4 iperf TCP. Remote VM using Virtual IP", Type: iperfTCPTest, ClusterIP: true, MSS: mssMin},
	{SourceNode: "netperf-w2", DestinationNode: "netperf-w2", Label: "5 iperf TCP. Hairpin Pod to own Virtual IP", Type: iperfTCPTest, ClusterIP: true, MSS: mssMin},

//不支持SCTP
//	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "6 iperf SCTP. Same VM using Pod IP", Type: iperfSctpTest, ClusterIP: false, MSS: mssMin},
//	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "7 iperf SCTP. Same VM using Virtual IP", Type: iperfSctpTest, ClusterIP: true, MSS: mssMin},
//	{SourceNode: "netperf-w1", DestinationNode: "netperf-w3", Label: "8 iperf SCTP. Remote VM using Pod IP", Type: iperfSctpTest, ClusterIP: false, MSS: mssMin},
//	{SourceNode: "netperf-w3", DestinationNode: "netperf-w2", Label: "9 iperf SCTP. Remote VM using Virtual IP", Type: iperfSctpTest, ClusterIP: true, MSS: mssMin},
//	{SourceNode: "netperf-w2", DestinationNode: "netperf-w2", Label: "10 iperf SCTP. Hairpin Pod to own Virtual IP", Type: iperfSctpTest, ClusterIP: true, MSS: mssMin},

	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "11 iperf UDP. Same VM using Pod IP", Type: iperfUDPTest, ClusterIP: false, MSS: mssMax},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "12 iperf UDP. Same VM using Virtual IP", Type: iperfUDPTest, ClusterIP: true, MSS: mssMax},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w3", Label: "13 iperf UDP. Remote VM using Pod IP", Type: iperfUDPTest, ClusterIP: false, MSS: mssMax},
	{SourceNode: "netperf-w3", DestinationNode: "netperf-w2", Label: "14 iperf UDP. Remote VM using Virtual IP", Type: iperfUDPTest, ClusterIP: true, MSS: mssMax},

	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "15 netperf. Same VM using Pod IP", Type: netperfTest, ClusterIP: false},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w2", Label: "16 netperf. Same VM using Virtual IP", Type: netperfTest, ClusterIP: true},
	{SourceNode: "netperf-w1", DestinationNode: "netperf-w3", Label: "17 netperf. Remote VM using Pod IP", Type: netperfTest, ClusterIP: false},
	{SourceNode: "netperf-w3", DestinationNode: "netperf-w2", Label: "18 netperf. Remote VM using Virtual IP", Type: netperfTest, ClusterIP: true},
}
```

##### （2）生成镜像
```shell
$ vim Makefile
...
DOCKERREPO       := docker.repo.local:5000/netperf:v1
...

$ make docker
```

#### 2.修改launch源码（存在一个bug）并编译

##### （1）修改launch.go源码
```go
//注释关于sctp的内容

//portSpec = append(portSpec, api.ContainerPort{ContainerPort: iperf3Port, Protocol: api.ProtocolSCTP})

//{
//  Name:       "netperf-w2-sctp",
//  Protocol:   api.ProtocolSCTP,
//  Port:       iperf3Port,
//  TargetPort: intstr.FromInt(iperf3Port),
//},
```

##### （2）构建代码
```shell
#如果提示某些包没有，需要下载（go get ...）
go build -o launch launch.go
```

#### 3.执行测试
```shell
#注意可能需要很久，没必要等着
./launch -image docker.repo.local:5000/netperf:v1 -kubeConfig ~/.kube/config
```

#### 4.查看执行进度（如果MSS跨度大的话，需要很久）
```shell
kubectl logs netperf-orch-xx -n netperf

#当出现：END CSV DATA 表明执行结束
```

#### 5.分析执行结果

##### （1）先将csv DATA数据复制出来
```csv
MSS                                          , Maximum, 96, 352, 608, 864, 1120, 1376,
1 iperf TCP. Same VM using Pod IP            ,35507.000000,33835,33430,35372,35220,35373,35507,
2 iperf TCP. Same VM using Virtual IP        ,32997.000000,32689,32997,32256,31995,31904,31830,
3 iperf TCP. Remote VM using Pod IP          ,10652.000000,8793,9836,10602,9959,9941,10652,
4 iperf TCP. Remote VM using Virtual IP      ,11046.000000,10429,11046,10064,10622,10528,10246,
5 iperf TCP. Hairpin Pod to own Virtual IP   ,32400.000000,31473,30253,32075,32058,32400,31734,
6 iperf UDP. Same VM using Pod IP            ,10642.000000,10642,
7 iperf UDP. Same VM using Virtual IP        ,8983.000000,8983,
8 iperf UDP. Remote VM using Pod IP          ,11143.000000,11143,
9 iperf UDP. Remote VM using Virtual IP      ,10836.000000,10836,
10 netperf. Same VM using Pod IP             ,11675.380000,11675.38,
11 netperf. Same VM using Virtual IP         ,0.000000,0.00,
12 netperf. Remote VM using Pod IP           ,6646.820000,6646.82,
13 netperf. Remote VM using Virtual IP       ,0.000000,0.00,
```

##### （2）生成图表
* 使用自己编写的python
```python
import pandas
from matplotlib import pyplot

data = pandas.read_csv("test.csv", sep=r'\s*,\s*', engine="python")

pyplot.axis([0, 1500, 0, 10000])

#Same VM using Virtual IP
pyplot.plot(data.columns.tolist()[2:], data.loc[0].tolist()[2:], color="r")
#Same VM using Pod IP
pyplot.plot(data.columns.tolist()[2:], data.loc[1].tolist()[2:], color="b")
#Remote VM using Pod IP
pyplot.plot(data.columns.tolist()[2:], data.loc[2].tolist()[2:], color="g")
#Remote VM using Virtual IP
pyplot.plot(data.columns.tolist()[2:], data.loc[3].tolist()[2:], color="y")

pyplot.xticks([0, 200, 400, 600, 800, 1000, 1200, 1400])

pyplot.grid(True)
pyplot.show()
```

* 利用提供的分析工具
```shell
#数据需要保存在netperf-latest.csv这个文件中，然后会在该目录下生成相应的图片
docker run --detach=false -v /root/test:/plotdata girishkalele/netperf-plotperf --csv /plotdata/netperf-latest.csv girishkalele/netperf-plotperf
```
