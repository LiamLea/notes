### security

[toc]

### Config

kibana不能设置密码，只有es能设置密码

#### 1.es配置

* 创建secret
```shell
kubectl create secret generic elastic-certificates --from-file=server.key --from-file=server.crt -n elastic
```

* `values.yaml`
[参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html)
```yaml
esConfig:
  elasticsearch.yml: |
    xpack.security.enabled: true
    xpack.security.transport.ssl.enabled: true
    xpack.security.transport.ssl.verification_mode: none
    xpack.security.transport.ssl.key: /usr/share/elasticsearch/config/certs/server.key
    xpack.security.transport.ssl.certificate: /usr/share/elasticsearch/config/certs/server.crt

extraEnvs:
- name: ELASTIC_PASSWORD
  value: "elastic@Cogiot_2021"
- name: ELASTIC_USERNAME
  value: elastic

secretMounts:
  - name: elastic-certificates
    secretName: elastic-certificates
    path: /usr/share/elasticsearch/config/certs
```

#### 2.kibana配置

* `values.yaml`
```yaml
kibanaConfig:
  kibana.yml: |
    xpack.security.enabled: true

extraEnvs:
  - name: 'ELASTICSEARCH_USERNAME'
    value: "elastic"
  - name: 'ELASTICSEARCH_PASSWORD'
    value: "elastic@Cogiot_2021"
```
