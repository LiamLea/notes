### 部署

#### 1.启动agent
* 查看配置：https://github.com/pinpoint-apm/pinpoint/tree/master/agent/src/main/resources/profiles
* 默认是使用release中的配置，可通过`-Dpinpoint.profiler.profiles.active=release`更改
```shell
java -javaagent:/usr/local/pinpoint-agent-2.2.1/pinpoint-bootstrap-2.2.1.jar \
     -Dpinpoint.agentId=<INSTANCE_NAME> \
     -Dpinpoint.applicationName=<SERVICE_NAME> \
     -Dprofiler.sampling.rate=1 \
     -Dprofiler.collector.ip=<COLLECTOR_IP> \
     -Dprofiler.transport.grpc.collector.ip=<COLLECTOR_IP> \
     -jar xx.jar
```
