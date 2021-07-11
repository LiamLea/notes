[toc]

[参考](https://github.com/prometheus/jmx_exporter)

### 使用

#### 1.下载exporter和配置文件
```shell
cp jmx_prometheus_javaagent-0.16.0.jar /opt/apache-tomcat-8.5.39/bin/
cp example_configs/tomcat.yml /opt/apache-tomcat-8.5.39/bin/
```

#### 2.修改启动脚本
```shell
$ vim /opt/apache-tomcat-8.5.39/bin/catalina.sh

#添加下面内容
JAVA_OPTS="$JAVA_OPTS -javaagent:<jmx_jar_path>=<expoter_port>:<tomcat_yml_path>"
#JAVA_OPTS="$JAVA_OPTS -javaagent:/opt/apache-tomcat-8.5.39/bin/jmx_prometheus_javaagent-0.16.0.jar=9105:/opt/apache-tomcat-8.5.39/bin/tomcat.yml"
```

#### 3.重启tomcat
```shell
/opt/apache-tomcat-8.5.39/bin/shutdown.sh
/opt/apache-tomcat-8.5.39/bin/startup.sh
```

#### 4.验证
```shell
curl 3.1.5.19:9105/metrics
```
