[toc]

### quick start

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
#if registry is changed,you should pay attention to registry_prefix
registry: "10.10.10.250"
#when registry is empty, this should be empty too
registry_prefix: "{{ registry }}/library/"

docker:
  #add your insecure registries and must set no proxy
  insecure-registries: ["{{ registry }}"]   
  http_proxy:
    enabled: False
    server: http://10.10.10.250:8123
    no_proxy: ["{{ registry }}", "quay.io", ".docker.com", "docker.io", "localhost", "127.0.0.1", ".aliyuncs.com"]

kubernetes:
  apiserver:
    control_plane:
      ip: 10.172.1.10   #must be changed
      port: 16443

#auto-dectect interface
calico:
  nodeAddressAutodetectionV4:
    cidrs:
    - "10.172.1.0/24"  #must be changed
```

#### 3.init localhost
* specify ansible image
```shell
$ vim Makefile

ansible_image = bongli/ansible:debian-2.10
```

* run init_localhost
```shell
make init_localhost
```

#### 4.check all hosts

```shell
make check
```

#### 5.run the playbook

* enable roles
```shell
vim main.yaml
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

#### 6.run some test tasks

```shell
vim test.yaml
```
```shell
make test
```

#### 7.install harbor(if need)

* set inventory
```shell
$ vim inventory/harbor_hosts

[harbor]
harbor ansible_host=10.172.1.250 ansible_user=root ansible_password=cangoal

[ntp_server]
master-1 ansible_host=10.172.1.11 ansible_user=root ansible_password=cangoal
```

* install harbor
run after [step 3](#3init-localhost)
```shell
make install_harbor
```

* 创建以下公有仓库
  * library

#### 8.push images to private registry

* set variables
```shell
vim push_images.yaml
```
```yaml
vars:
  target_registry: "10.10.10.250"
  username: "admin"
  password: "Harbor12345"
  exception_pattern: ""
```

* run the task
```shell
make push_images
```
