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

#specify which host to run ansible
[ansible]
master-1
```

#### 2.set global variables
```shell
vim global.yaml
```

```yaml
#if registry is changed,you should pay attention to registry_prefix,docker.insecure-registries
registry: "10.10.10.250"
registry_prefix: "{{ registry }}/"

docker:
  http_proxy:
    enabled: False
    server: http://10.10.10.250:8123
    no_proxy: ["{{ registry }}", "docker.io", "localhost", "127.0.0.1"]

kubernetes:
  apiserver:
    control_plane:
      ip: 10.172.1.10   #must be changed
      port: 16443

#auto-dectect interface
calico:
  nodeAddressAutodetectionV4:
    cidrs:
    - "10.172.1.0/24"
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
