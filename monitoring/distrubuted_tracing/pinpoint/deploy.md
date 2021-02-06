### 部署

#### 1.启动agent
```shell
java -javaagent:/usr/local/pinpoint-agent-2.2.1/pinpoint-bootstrap-2.2.1.jar \
     -Dpinpoint.agentId=<INSTANCE_NAME> \
     -Dpinpoint.applicationName=<SERVICE_NAME> \
     -Dprofiler.collector.ip=<COLLECTOR_IP> \
     -Dprofiler.transport.grpc.collector.ip=<COLLECTOR_IP> \
     -jar xx.jar
```
