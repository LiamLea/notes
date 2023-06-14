
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [容器启动](#容器启动)

<!-- /code_chunk_output -->

### 容器启动
```shell
docker run -d --rm  --network host \
percona/mongodb_exporter:0.39 \
#mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]
#指定账号密码，数据库地址，和认证的数据库（如果不指定，认证数据库默认为admin）
--mongodb.uri=mongodb://root:password123@127.0.0.1:27017 \
#收集所有指标
--collect-all
```
