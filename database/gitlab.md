### 安装
#### 1.组件
|名称|说明|是否需要安装|
|-|-|-|
|NGINX Ingress|用于创建ingress|否|
|Registry|
|GitLab/Gitaly|
|GitLab/GitLab Exporter|
|GitLab/GitLab Grafana|
|GitLab/GitLab Shell|
|GitLab/Migrations|
|GitLab/Sidekiq|
|GitLab/Webservice|

#### 配置
```shell
vim gitlab/values.yaml
```
```yaml
glocal:
  edition: ce     #安装社区版


````
