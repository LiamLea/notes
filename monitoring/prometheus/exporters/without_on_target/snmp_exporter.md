
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [使用](#使用)
  - [1.生成snmp.yml文件](#1生成snmpyml文件)
    - [（1）下载mib库](#1下载mib库)
    - [（2）配置generator](#2配置generator)
    - [（3）生成snmp.yml文件](#3生成snmpyml文件)
  - [2.启动snmp exporter](#2启动snmp-exporter)
  - [3.配置promethwus](#3配置promethwus)

<!-- /code_chunk_output -->

[参考](https://github.com/prometheus/snmp_exporter)

### 使用

#### 1.生成snmp.yml文件
通过[generator](https://github.com/prometheus/snmp_exporter/tree/main/generator)生成

##### （1）下载mib库
```shell
#下面所有的mib库
make mibs

#构建镜像
docker build -t snmp-generator .
```

##### （2）配置generator
* `generator.yml`
```yaml
modules:
  <module_name>:
    walk:    #需要walk的oids
    - 1.3.6.1.2.1.2
    - sysUpTime
    - 1.3.6.1.2.1.31.1.1.1.6.40
    lookups:
      - source_indexes: [ifIndex]
        lookup: ifAlias
      - source_indexes: [ifIndex]
        # Uis OID to avoid conflict with PaloAlto PAN-COMMON-MIB.
        lookup: 1.3.6.1.2.1.2.2.1.2 # ifDescr
      - source_indexes: [ifIndex]
        # Use OID to avoid conflict with Netscaler NS-ROOT-MIB.
        lookup: 1.3.6.1.2.1.31.1.1.1.1 # ifName
    overrides:
      ifAlias:
        ignore: true # Lookup metric
      ifDescr:
        ignore: true # Lookup metric
      ifName:
        ignore: true # Lookup metric
      ifType:
        type: EnumAsInfo
```

##### （3）生成snmp.yml文件
```shell
docker run -ti \
  -v "${PWD}:/opt/" \
  snmp-generator generate
```

#### 2.启动snmp exporter

#### 3.配置promethwus
```yaml
scrape_configs:
  - job_name: 'snmp'
    static_configs:
      - targets: []   #指定采集目标
    metrics_path: /snmp
    params:
      module: []    #指定模块（模块是在snmp.yml中设置的）
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9116  #snmp exporter的地址
```
