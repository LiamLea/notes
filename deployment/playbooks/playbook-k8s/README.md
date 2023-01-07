# k8s deployment

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [k8s deployment](#k8s-deployment)
    - [Quick Start](#quick-start)
      - [1.set inventory](#1set-inventory)
      - [2.set global variables](#2set-global-variables)
      - [3.other configs](#3other-configs)
        - [（1）config  packages repo](#1config-packages-repo)
      - [4.init localhost](#4init-localhost)
      - [5.check all hosts](#5check-all-hosts)
      - [6.prepare images and charts](#6prepare-images-and-charts)
      - [7.run the playbook](#7run-the-playbook)
    - [Initialize K8S](#initialize-k8s)
      - [1.install ceph storageclass](#1install-ceph-storageclass)
        - [（1）set global variables](#1set-global-variables)
        - [（2）run storageclass task](#2run-storageclass-task)
      - [2.install basic service](#2install-basic-service)
        - [（2）set global variables](#2set-global-variables-1)
        - [（2）run basic task](#2run-basic-task)
    - [Other Basic Tasks](#other-basic-tasks)
      - [1.run test tasks](#1run-test-tasks)
        - [（1）define test tasks](#1define-test-tasks)
        - [（2）run test tasks](#2run-test-tasks)
      - [2.install harbor(if need)](#2install-harborif-need)
        - [（1）set inventory](#1set-inventory-1)
        - [（2）install harbor](#2install-harbor)
        - [（3）create repos below](#3create-repos-below)
      - [3.push images to private registry](#3push-images-to-private-registry)
        - [（1） set variables](#1-set-variables)
        - [（2） run push_images task](#2-run-push_images-task)
      - [4.download packages](#4download-packages)
        - [（1） set variables](#1-set-variables-1)
        - [（2） run push_images task](#2-run-push_images-task-1)
    - [Monitor Task](#monitor-task)
      - [1.deploy monitor](#1deploy-monitor)
        - [（1）set global variables](#1set-global-variables-1)
        - [（2）run monitor task](#2run-monitor-task)
    - [Log Task](#log-task)
      - [1.deploy log](#1deploy-log)
        - [（1）set global variables](#1set-global-variables-2)
        - [（2）run log task](#2run-log-task)
    - [Service Task](#service-task)
      - [1.deploy service](#1deploy-service)
        - [（1）set global variables](#1set-global-variables-3)
        - [（2）run service task](#2run-service-task)
    - [Author](#author)
    - [📝 License](#license)

<!-- /code_chunk_output -->

### Quick Start

#### 1.set inventory

```shell
$ vim inventory/hosts

[master]
master-1 ansible_host=3.1.4.121 ansible_user=root ansible_password=cangoal
master-2 ansible_host=3.1.4.122 ansible_user=root ansible_password=cangoal
master-3 ansible_host=3.1.4.123 ansible_user=root ansible_password=cangoal

[node]
node-1 ansible_host=3.1.4.124 ansible_user=root ansible_password=cangoal
node-2 ansible_host=3.1.4.125 ansible_user=root ansible_password=cangoal
node-3 ansible_host=3.1.4.127 ansible_user=lil ansible_password=cangoal ansible_become_user=root ansible_become_password=cangoal

[others]
#some hosts need to install docker

#specify which host to run ansible
[ansible]
master-1
```

#### 2.set global variables
```shell
vim global.yaml
```

```yaml
task_id: 8

ntp:
  server:
  - ntp.aliyun.com

timezone: Asia/Shanghai

dns:
- 114.114.114.114
- 8.8.8.8

hosts:
- ip: 127.0.0.1
  hostname:
  - localhost

http_proxy:
  server: http://10.10.10.250:8123
  no_proxy: ""

#if registry is changed,you should pay attention to registry_prefix
registry: "10.10.10.250"
#when registry is empty, this should be empty too
#must end with / or be empty
registry_prefix: "{{ registry }}/library/"

docker:
  version: 20.10.5
  containerd:
    sandbox_image: "{{ registry_prefix }}k8s.gcr.io/pause:3.6"
  insecure-registries: ["{{ registry }}"]
  registry-mirrors: []
  http_proxy:
    enabled: True
    server: "{{ http_proxy.server }}"
    #must include service and pod network: 10.0.0.0/8
    no_proxy: ["{{ registry }}", "10.0.0.0/8", "quay.io", "docker.com", "docker.io", "localhost", "127.0.0.1", "aliyuncs.com", "myhuaweicloud.com"]

kubernetes:
  version: 1.22.10
  repository: "{{ registry_prefix }}k8s.gcr.io"
  apiserver:
    control_plane:
      ip: 10.172.1.10
      port: 16443
    network:
      service_subnet: 10.96.0.0/12
      pod_subnet: 10.244.0.0/16
    nodeport_range: 10000-65535

calico:
  repository: "{{ registry_prefix }}"
  encapsulation: IPIP
  nodeAddressAutodetectionV4:
    cidrs:
    - "10.172.1.0/24"

nginx:
  image: "{{ registry_prefix }}nginx:latest"
  health_check:
    port: 16442

keepalived:
  id: 120
  vip: "{{ kubernetes.apiserver.control_plane.ip }}"
  health_check:
    url: "http://127.0.0.1:{{ nginx.health_check.port }}/"
  image: "{{ registry_prefix }}osixia/keepalived:latest"

chart:
  http_proxy:
    enabled: True
    server: "{{ http_proxy.server }}"
    no_proxy: "{{ kubernetes.apiserver.control_plane.ip }}, {{ http_proxy.no_proxy }}"
  repo:
    ceph-csi: https://ceph.github.io/csi-charts
    prometheus-community: https://prometheus-community.github.io/helm-charts
    grafana: https://grafana.github.io/helm-charts
    elastic: https://helm.elastic.co
    bitnami: https://charts.bitnami.com/bitnami
    cert-manager: https://charts.jetstack.io
    ingress-nginx: https://kubernetes.github.io/ingress-nginx
    paradeum-team: https://paradeum-team.github.io/helm-charts/
    kfirfer: https://kfirfer.github.io/helm/
    kafka-ui: https://provectus.github.io/kafka-ui

  #if the charts are local, set local directory
  #or will use the remote repo
  local_dir: ""
```

#### 3.other configs

##### （1）config  packages repo
* yum
```shell
ls roles/init/files/repo/centos-7/yum.repos.d/
```
* debian
```shell
cat roles/init/tasks/debian.yaml
```

#### 4.init localhost

* install docker-ce
```shell
make install_docker
```

* specify ansible image
```shell
$ vim Makefile

ansible_image = bongli/ansible:debian-2.10
```

* run init_localhost
```shell
#run multiple times until this task is successful
make init_localhost
```

#### 5.check all hosts

```shell
make check
```

#### 6.prepare images and charts
* list all images
```shell
make list_images
```

* download charts
```shell
#will download to ${ansible_dir}/charts directory
make download_charts
```

#### 7.run the playbook

* enable roles
```shell
vim playbooks/main.yaml
```
```yaml
- hosts: all
  gather_facts: True
  become: True
  become_method: sudo
  become_flags: "-i"
  roles:
  - init
  - docker
  - { role: k8s, when: "inventory_hostname in groups['k8s']" }

```

* run the playbook

```shell
make run
```
* tail the run log
```shell
tail -f run.log
```

* stop the playbook
```shell
make stop
```

***

### Initialize K8S

#### 1.install ceph storageclass

##### （1）set global variables
* `vim global.yaml`
  * set storageclass config
  ```yaml
  storage_class:
    repository: "{{ registry_prefix }}"
    ceph:
      enabled: true
      cluster:
        #id and mons(get from /etc/ceph/ceph.conf)
        id: ""
        mons: []
        #id and key of and user(get from /etc/ceph/*.ketring, e.g. id: admin,  key: 1111)
        admin:
          id: ""
          key: ""
      cephfs:
        namespace: "ceph-csi-cephfs"
        name: "ceph-csi-cephfs"
        chart:
          repo: "{{ chart.repo['ceph-csi'] }}"
          path: "ceph-csi-cephfs"
          version: "3.4.0"
        config:
          default: false
          class_name: "csi-cephfs-sc"
          #volume must exist
          fs_name: "ceph-fs"
          volume_name_prefix: "dev-k8s-vol-"
          #host network mode, so this port must be available
          nodeplugin_metric_port: 8082

      rbd:
        namespace: "ceph-csi-rbd"
        name: "ceph-csi-rbd"
        chart:
          repo: "{{ chart.repo['ceph-csi'] }}"
          path: "ceph-csi-rbd"
          version: "3.4.0"
        config:
          default: true
          class_name: "csi-rbd-sc"
          pool: "rbd-replicated-pool"
          volume_name_prefix: "dev-k8s-vol-"
          #host network mode, so this port must be available
          nodeplugin_metric_port: 8081
  ```

##### （2）run storageclass task
```shell
make storageclass
```

#### 2.install basic service

##### （2）set global variables
* `vim global.yaml`
  * set chart config
    * omitted, refer to global.yaml
  * set ingress config
    * omitted, refer to global.yaml
  * set basic config
  ```yaml
  basic:
    namespace: basic-public
    repository: "{{ registry_prefix }}"
    #use default sc when set null
    storage_class: null
    cert_manager:
      name: "cert-manager"
      chart:
        repo: "{{ chart.repo['cert-manager'] }}"
        path: "cert-manager"
        version: "1.7.2"
    ingress_nginx:
      name: "ingress-nginx"
      chart:
        repo: "{{ chart.repo['ingress-nginx'] }}"
        path: "ingress-nginx"
        version: "4.0.18"
      config:
        ingress_class: nginx
        http_port: 30080
        https_port: 30443
  ```

##### （2）run basic task
```shell
make basic
```

***

### Other Basic Tasks

#### 1.run test tasks

##### （1）define test tasks
```shell
vim test.yaml
```

##### （2）run test tasks
```shell
make test
```

#### 2.install harbor(if need)

##### （1）set inventory
```shell
$ vim inventory/hosts

[harbor]
harbor ansible_host=10.172.1.250 ansible_user=root ansible_password=cangoal

[ntp_server]
master-1 ansible_host=10.172.1.11 ansible_user=root ansible_password=cangoal
```

##### （2）install harbor
run after [step 3](#3init-localhost)
```shell
make install_harbor
```

##### （3）create repos below
* library

#### 3.push images to private registry

##### （1） set variables
```shell
vim push_images.yaml
```
```yaml
vars:
  target_registry: "10.10.10.250"
  username: "admin"
  password: "Harbor12345"

  #匹配的镜像，会用${registry_prefix} 替换 其地址
  #没有匹配这里的镜像，都会在镜像前面加上${registry_prefix}
  #use | to match multiple registries
  prefix_replace_pattern: ""

  #匹配的镜像，会用${my_registry} 替换 其地址
  #没有匹配这里的镜像，都会在镜像前面加上${registry_prefix}
  #use | to match multiple registries
  address_replace_pattern: ""

  #其余镜像都会在前面加上 ${registry_prefix}
```

##### （2） run push_images task
```shell
make push_images
```

#### 4.download packages

##### （1） set variables
```shell
vim global.yaml
```
```yaml
download_packages:
  context: "centos-7"
  download_dir: "/tmp/download/"
  packages_list:
  - name: docker-ce
    version: 20.10.5
  - name: kubeadm
    version: 1.22.10
  - name: kubelet
    version: 1.22.10
  - name: kubectl
    version: 1.22.10
  contexts:
    centos-7:
      image: "centos:7"
      package_manager: "yum"
    ubuntu-18.04:
      image: "ubuntu:18.04"
      package_manager: "apt"
```

##### （2） run push_images task
```shell
make download_packages
```

***

### Monitor Task

#### 1.deploy monitor
##### （1）set global variables
* `vim global.yaml`
  * set chart config
    * omitted, refer to global.yaml
  * set ingress config
    * omitted, refer to global.yaml
  * set monitor config
  ```yaml
  monitor:
    namespace: monitor
    repository: "{{ registry_prefix }}"
    #use default sc when set null
    storage_class: null
    prometheus:
      name: prometheus
      chart:
        repo: "{{ chart.repo['prometheus-community'] }}"
        #the path is relative path
        path: "prometheus"
        version: "15.8.5"
      resources:
        requests:
          cpu: "4000m"
          memory: "8Gi"
        limits:
          cpu: "4000m"
          memory: "8Gi"
        storage: 16Gi
      config:
        #this url will send with alerting msg which user can click to access prometheus to get alerting details
        #  e.g. https://k8s.my.local:30443/prometheus
        #set /prometheus if you don't know the exact external_url or you can't access prometheus
        external_url: "https://{{ domains[0] }}:{{ basic.ingress_nginx.config.https_port }}/prometheus"
        # e.g. {send_resolved: true, url: "<url|no empty>", max_alerts: 10}
        webhook_configs: []
        # e.g. {send_resolved: true, smarthost: smtp.qq.com:587 ,from: 1059202624@qq.com, to: 1059202624@qq.com, auth_username: 1059202624@qq.com, auth_password: 'xx'}
        email_configs: []
        scrape_interval: "30s"
        #e.g. "10.10.10.1"
        icmp_probe: []
        #e.g. "10.10.10.1:80"
        tcp_probe: []
        #e.g. "http://10.10.10.1:80/test"
        http_probe: []
        #e.g. "10.10.10.1:9092"
        node_exporter: []
        jobs:
          #e.g. {"targets": ["10.10.10.10:9283"], "labels": {cluster: "openstack"}}
          ceph_exporter: []
      blackbox:
        name: "blackbox-exporter"
        chart:
          repo: "{{ chart.repo['prometheus-community'] }}"
          path: "prometheus-blackbox-exporter"
          version: "5.7.0"
      adapter:
        name: "prometheus-adapter"
        chart:
          repo: "{{ chart.repo['prometheus-community'] }}"
          path: "prometheus-adapter"
          version: "3.2.2"
      grafana:
        name: "grafana"
        chart:
          repo: "{{ chart.repo['grafana'] }}"
          path: "grafana"
          version: "6.28.0"
        dashboards:
          default:
            node-exporter:
              gnetId: 8919
              revision: 24
              datasource: Prometheus
            node-full:
              gnetID: 1860
              revision: 27
              datasource: Prometheus
            blackbox-exporter:
              gnetId: 7587
              revision: 3
              datasource: Prometheus
            #you may need to add a variable represents datasource or this dashboard would go wrong
            k8s:
              gnetId: 15520
              revision: 1
              datasource: Prometheus
            k8s-pv:
              gnetId: 11454
              revision: 14
              datasource: Prometheus
            apiserver:
              gnetID: 12006
              revision: 1
              datasource: Prometheus
            etcd:
              gnetID: 9733
              revision: 1
              datasource: Prometheus
            ceph:
              gnetID: 2842
              revision: 14
              datasource: Prometheus

    node_exporter:
      version: 1.3.0
      #will download node-exporter when local_dir is empty
      # local_dir: "/root/ansible/files/node_exporter"
      local_dir: ""
      install_path: /usr/local/bin/
      port: 9100
  ```

##### （2）run monitor task
```shell
make monitor
```

***

### Log Task

#### 1.deploy log
##### （1）set global variables
* `vim global.yaml`
  * set chart config
    * omitted, refer to global.yaml
  * set ingress config
    * omitted, refer to global.yaml
  * set log config
  ```yaml
  log:
    namespace: log
    repository: "{{ registry_prefix }}"
    #use default sc when set null
    storage_class: null
    kafka:
      #if false, must set bootstrap_servers to use the existing kafka
      #if true, use service.kafka vars above to install new kafka
      enabled: true
      bootstrap_servers: []

    elastic:
      version: "7.17.3"
      security:
        password: "elastic"
      elasticsearch:
        name: elasticsearch
        chart:
          repo: "{{ chart.repo['elastic'] }}"
          #the path is relative path
          path: "elasticsearch"
        resources:
          requests:
            cpu: "8000m"
            memory: "16Gi"
          limits:
            cpu: "8000m"
            memory: "16Gi"
          storage: 30Gi
          #jvm heap best practice（half of the total memory and less than 30G）
          esJavaOpts: "-Xmx8g -Xms8g"
      kibana:
        name: kibana
        chart:
          repo: "{{ chart.repo['elastic'] }}"
          path: "kibana"
      logstash:
        name: logstash
        chart:
          repo: "{{ chart.repo['elastic'] }}"
          path: "logstash"
        replicas: "3"
        resources:
          requests:
            cpu: "100m"
            memory: "2Gi"
          limits:
            cpu: "1000m"
            memory: "2Gi"
          logstashJavaOpts: "-Xmx1g -Xms1g"
        config:
          batch_size: 1000
          group_id: logstash_log_k8s
      filebeat:
        name: filebeat
        chart:
          repo: "{{ chart.repo['elastic'] }}"
          path: "filebeat"
  ```

##### （2）run log task
```shell
make log
```

***

### Service Task

#### 1.deploy service
##### （1）set global variables
* `vim global.yaml`
  * set chart config
    * omitted, refer to global.yaml
  * set ingress config
    * omitted, refer to global.yaml
  * set service config
  ```yaml
  service:
    namespace: public
    repository: "{{ registry_prefix }}"
    #use default sc when set null
    storage_class: null
    kafka:
      enabled: true
      name: kafka
      chart:
        repo: "{{ chart.repo['bitnami'] }}"
        path: "kafka"
        version: "16.2.10"
      replicas: 3
      node_ports: [19092, 19093, 19094]
      #if empty work_master ip will be used
      domain: ""
      resources:
        heapOpts: "-Xmx1024m -Xms1024m"
        requests:
          cpu: "250m"
          memory: "1.5Gi"
        limits:
          cpu: "1000m"
          memory: "1.5Gi"
        zookeeper:
          jvmFlags: "-Xmx1024m -Xms1024m"
          requests:
            cpu: "250m"
            memory: "1.5Gi"
          limits:
            cpu: "1000m"
            memory: "1.5Gi"

    mysql:
      enabled: true
      name: mysql
      chart:
        repo: "{{ chart.repo['bitnami'] }}"
        path: "mysql"
        version: "8.5.7"
      root_password: cangoal
      replication_password: cangoal
      #standalone or replication
      architecture: replication
      resources:
        requests:
          cpu: "4000m"
          memory: "8Gi"
        limits:
          cpu: "4000m"
          memory: "8Gi"
        storage: 10Gi

    pgsql:
      enabled: true
      name: postgresql
      chart:
        repo: "{{ chart.repo['bitnami'] }}"
        path: "postgresql"
        version: "11.7.3"
      postgres_password: cangoal
      replication_password: cangoal
      #standalone or replication
      architecture: replication
      resources:
        requests:
          cpu: "4000m"
          memory: "8Gi"
        limits:
          cpu: "4000m"
          memory: "8Gi"
        storage: 10Gi

    redis:
      enabled: true
      name: redis
      chart:
        repo: "{{ chart.repo['bitnami'] }}"
        path: "redis"
        version: "17.0.8"
      password: cangoal
      resources:
        requests:
          cpu: "2000m"
          memory: "4Gi"
        limits:
          cpu: "2000m"
          memory: "4Gi"
        storage: 5Gi
      replica:
        count: 2

    tools:
      enabled: true

      #database tool
      adminer:
        name: adminer
        chart:
          repo: "{{ chart.repo['paradeum-team'] }}"
          path: "adminer"
          version: "0.1.9"

      #redis tool
      redis:
        name: redis-commander
        chart:
          repo: "{{ chart.repo['kfirfer'] }}"
          path: "redis-commander"
          version: "0.1.3"

      #kafka tool
      kafka:
        name: kafka-ui
        chart:
          repo: "{{ chart.repo['kafka-ui'] }}"
          path: "kafka-ui"
          version: "0.4.1"
        auth:
          user: admin
          password: cangoal
        #add kafka clusters
        kafka_clusters:
        - name: kafka-k8s
          bootstrapServers: kafka.public:9092
  ```

##### （2）run service task
```shell
make service
```

### Author
 👤 **Li Liang**
* Email: liweixiliang@gmail.com
* Github: https://github.com/LiamLea/cloud

### 📝 License
Copyright © 2022 [Li Liang](https://github.com/LiamLea/cloud).
This project is [Apache 2.0](https://github.com/LiamLea/cloud/blob/master/deployment/playbooks/LICENSE) licensed.
