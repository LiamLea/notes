# config

[toc]

### 配置

#### 1.通过反向代理访问grafana
* conf/defaults.ini
```shell
#在前端给所有资源的目标地址 前面加一个前缀，但实际在后端的地址是没有前缀的
root_url = %(protocol)s://%(domain)s:%(http_port)s/<prefix>

#是否在后端rewrite
# 不rewrite就会访问加了前缀的地址，但是实际的地址是没有前缀的
#     这样，只能通过反向代理访问了，在反向代理去除掉 前缀
#     直接访问的话，因为前端设置的目标地址都加上了前缀的，但实际是没有前缀的
# rewrite，则kibana服务端接收到这个地址，会进行一个rewrite，即删除这个前缀
#     这样，删除前缀的这步在kibana做了，而上面是在反向代理那里做的
#     建议使用这种方式，这样不通过反向代理就能够访问了
serve_from_sub_path = <boolean | default=false>
```

* 注意如果kibana是部署在k8s上的 且 修改了basePath并进行了rewrite
需要修改健康检查的地址
  * 在chart的`values.yaml`中修改
