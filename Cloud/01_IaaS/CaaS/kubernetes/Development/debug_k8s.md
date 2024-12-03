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

FROM golang:1.23.1
RUN go install github.com/go-delve/delve/cmd/dlv@v1.23.1

ENTRYPOINT ["/go/bin/dlv", "--listen=0.0.0.0:2345", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "--"]

$ docker build -t liamlea/dlv:1.23.1
```

* build k8s image
```shell
export KUBE_SCHEDULER_BASE_IMAGE="liamlea/dlv:1.23.1"
make release-images DBG=1
```

* output
```shell
ls ./_output/release-images
```