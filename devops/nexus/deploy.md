# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [deploy](#deploy-1)

<!-- /code_chunk_output -->

### deploy
```shell
mkdir /root/nexus-data
chown -R 200 /root/nexus-data

docker run --restart always --name nexus -d -p 8081:8081 -v /root/nexus-data:/nexus-data 10.10.10.250/library/sonatype/nexus3:3.38.1
```
