[toc]

#### 1.elasticsearch
```shell
elasticsearch {
  hosts => "<IP:PORT>"
  index => "<INDEX>"
  pipeline => "<PIPELINE_NAME>"
}
```

#### 2.debug
```shell
stdout{}    #不要用codec=>json，因为可能不立即输出，需要删除相应的topic后才输出
```
