[toc]
### 概述
#### 1.git特点
* 利用COW(写时复制技术)
#### 2.流程
```plantuml
database a [
工作区
]
database b [
暂存区
]
database c[
版本仓库（本地仓库）
]
database d[
远程仓库
]
a-->b:"git add"
b-->c:"git commit"
c-->d:"git push"
```
![](./imgs/git_01.png)

### 命令
#### 1.基本操作
```shell
git remote add <NAME> <URL>       #添加一个远程仓库，起名为：<NAME>
git status                        #查看 工作区 文件状态，有哪些文件没有上传到暂存区
git add .                         #将变化的内容上传到暂存区
git commit -m '该版本的详细说明'   #将暂存区的内容上传到本地仓库

#将本地仓库的 <LOCAL_BRANCH>分支 提交到 名为<NAME>的远程仓库 的 <REMOTE_BRANCH>分支
git push <NAME> <LOCAL_BRANCH>:<REMOTE_BRANCH>           
```
#### 2.回滚操作
```shell
git logs                  #查看该版本即之前的版本
git reflog                #查看所有的版本
git reset --hard xx       #回滚到指定版本
```

#### 3.git stash（将修改的内容暂存起来，而不是提交到暂存区，不常用这种方式，而是用branch方式）
* 存储在某个地方（不是暂存区）
* 不受版本控制（git add、commit等）的影响
```shell
git stash                #将改变的内容暂时存放起来
#中间可以做一些修改，然后add，然后commit
git stash pop            #将第一个暂存的记录恢复到工作区


git stash list           #查看有哪些暂存的内容
git stash apply 标号     #将指定的暂存记录恢复到工作区
git stash clear
git stash drop 标号
```

#### 4.分支操作
* 开发新功能和修改bug需要创建新的分支
* 一般不准直接在master分支上修改内容
* 合并是将**创建分支后**变化的部分合并过来，而不是将整个分支合并过来

![](./imgs/git_02.png)
```shell
git branch -a           #查看所有分支（包括本地分支和远程分支）
git branch xx           #创建xx分支，拥有和 当前分支 一样的内容
git branch -d xx        #删除xx分支

git checkout xx         #切换到xx分支
git merge xx            #当xx分支合并到 当前分支
```

#### 5.版本控制（打标签操作）
```shell
#在当前位置打标签
git tag -a <TAG> -m <msg>

#推送所有标签（并没有推送到master，此时master不是最新标签）
git push --tags

#将最新的内容推送到master
git push

#切换到指定标签
git checkout  <TAG>
```
