# Proxy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Proxy](#proxy)
    - [Overview](#overview)
      - [1.Tcp Proxy Over SSH Tunnel](#1tcp-proxy-over-ssh-tunnel)
        - [(1) command](#1-command)
        - [(2) config file](#2-config-file)

<!-- /code_chunk_output -->


### Overview

#### 1.Tcp Proxy Over SSH Tunnel

##### (1) command

```shell
ssh -L <listening_port>:<target_host>:<target_port> <ssh_user>@<ssh_host>
```

* ssh will listen at `<listening_port>` tcp port
* every tcp taffic sent to the `<listening_port>` will be proxied to `<target_host>:<target_port>` by `<ssh_host>`

##### (2) config file

```shell
$ vim ~/.ssh/config

Host shared-k8s-test-*
  HostName shared-k8s-test
  User <user>
  IdentityFile <key_path>

Host shared-k8s-test-cluster-forward
  LocalForward 9443 test.com:443
```

* to listen at 9443 tcp
```shell
# set up the ssh connection (i.e. build the tunnel) and then will listen at 9443 tcp
ssh shared-k8s-test-cluster-forward
```

* check port
```shell
ss -tulnp | grep 9443
```

