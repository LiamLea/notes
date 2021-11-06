
* daemon.json

```json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  },
  "registry-mirrors": ["http://registry.docker-cn.com"],
  "insecure-registries":[]
}
```
