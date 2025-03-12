# demo


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [demo](#demo)
    - [work with custom plugin jb](#work-with-custom-plugin-jb)
      - [1.modify manifests](#1modify-manifests)
        - [(1) generate dependency file](#1-generate-dependency-file)
        - [(2) add preSync hook](#2-add-presync-hook)
        - [(3) parameterize the image tag](#3-parameterize-the-image-tag)

<!-- /code_chunk_output -->


### work with custom plugin jb

#### 1.modify manifests

##### (1) generate dependency file
```shell
jb init
jb install github.com/theplant/plantbuild/jsonnetlib@master
```

##### (2) add preSync hook
* if the manifests has some dependencies
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: schema-migrate-
  annotations:
    argocd.argoproj.io/hook: PreSync
```

##### (3) parameterize the image tag

```shell
#only works with GNU sed! Don't use MacOS(bsd) sed
sed -i "s/:latest'/:'+image_tag/" plantbuild/test/*.jsonnet

find plantbuild/test/ -type f -exec grep -l "+ image_tag" {} \; -exec sed -i "1i\local image_tag = import './image.jsonnet';" {} \;

jsonnetfmt -i plantbuild/test/*.jsonnet
```