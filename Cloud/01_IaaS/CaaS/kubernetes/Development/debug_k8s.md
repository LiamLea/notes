# Debug k8s
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Debug k8s](#debug-k8s)
    - [Usage](#usage)
      - [1.start a local k8s cluster](#1start-a-local-k8s-cluster)
      - [2.build debug images](#2build-debug-images)
        - [(1) clone k8s code](#1-clone-k8s-code)
        - [(2) build](#2-build)
        - [(3) build images](#3-build-images)

<!-- /code_chunk_output -->


### Usage

#### 1.start a local k8s cluster
```shel
minikube start

minikube status
```

#### 2.build debug images

##### (1) clone k8s code
```shell
git clone https://github.com/kubernetes/kubernetes.git
cd kubernetes
```

##### (2) build

* create build image
```shell
./build/run.sh

# output: ls ./_output/images
```

* build codes
```shell
# how: copy k8s source to the build image and execute make command (check Makefile)
# if [[ "${DBG:-}" == 1 ]]; then
#     # Debugging - disable optimizations and inlining and trimPath
#     gogcflags="${gogcflags} all=-N -l"
# else
#     # Not debugging - disable symbols and DWARF, trim embedded paths
#     goldflags="${goldflags} -s -w"
#     goflags+=("-trimpath")
# fi
./build/run.sh make DBG=1

# Build all binaries for all platforms
# ./build/run.sh make cross DBG=1
```

* output: `kubernetes/_ouput/`
```shell
ls ./_output/dockerized/bin/linux/
```

##### (3) build images

* build base image
    * choose go version according to go version in the go.mod
```shell
$ cat Dockerfile

FROM golang:1.22.0
RUN go install github.com/go-delve/delve/cmd/dlv@v1.22.0

ENTRYPOINT ["/go/bin/dlv", "--listen=0.0.0.0:2345", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "--"]

$ docker buildx build --push --platform=linux/amd64,linux/arm64,linux/s390x,linux/ppc64le -t liamlea/dlv:1.22.0 .
```

* check base image
```shell
$ cat ./build/common.sh

...
readonly KUBE_GORUNNER_IMAGE="${KUBE_GORUNNER_IMAGE:-$KUBE_BASE_IMAGE_REGISTRY/go-runner:$__default_go_runner_version}"
readonly KUBE_APISERVER_BASE_IMAGE="${KUBE_APISERVER_BASE_IMAGE:-$KUBE_GORUNNER_IMAGE}"
readonly KUBE_CONTROLLER_MANAGER_BASE_IMAGE="${KUBE_CONTROLLER_MANAGER_BASE_IMAGE:-$KUBE_GORUNNER_IMAGE}"
readonly KUBE_SCHEDULER_BASE_IMAGE="${KUBE_SCHEDULER_BASE_IMAGE:-$KUBE_GORUNNER_IMAGE}"
readonly KUBE_PROXY_BASE_IMAGE="${KUBE_PROXY_BASE_IMAGE:-$KUBE_BASE_IMAGE_REGISTRY/distroless-iptables:$__default_distroless_iptables_version}"
readonly KUBECTL_BASE_IMAGE="${KUBECTL_BASE_IMAGE:-$KUBE_GORUNNER_IMAGE}"
...

```
* build k8s image
```shell
export KUBE_SCHEDULER_BASE_IMAGE="liamlea/dlv:1.22.0"
make release-images DBG=1
```

* output
```shell
ls ./_output/release-images
```