
### 访问系统

在本地host解析中`添加`如下解析内容。

- 文件位置:

MAC:  `/etc/hosts`

Linux: `/etc/hosts`

Windows： `c:\windows\system32\drivers\etc\hosts`

> **注意**
>
> windows下的hosts文件可能不允许直接修改，可以将`hosts`先拷贝到桌面，修改完成后再拷贝回原目录。

- 文件内容:

```
172.28.202.161 password.devops.nari
172.28.202.162 gitlab.devops.nari
172.28.202.162 gerrit.devops.nari
172.28.202.160 jenkins.devops.nari
172.28.202.160 sonar.devops.nari
172.28.202.165 harbor.devops.nari
172.28.202.165 grafana.devops.nari
```

---

### gitlab分支管理
先锋分支 master,当有新的release后创建新的分支，新的release只做bug更改,不做新的功能开发
```bash
                                                  /release 2.0-----------
                                                 /
---------\--------------------------------------/---------------------------------master
          \                                     
           \release 1.0-----\--------------------/release
                             \                  /
                              \ bug fix--------/

```




### gerrit创建项目(管理员创建)

#### gerrit 创建和gitlab同名项目

登陆gerrit管理员: `BROWSE`->`Repositories`->`CREATE NEW`

填写项目名称

>  注意： 项目名称需和gitlab上面项目名称一致

<img src="image/image-20200611101128007.png" alt="image-20200611101128007" style="zoom:50%;" />

#### 更新gerrit中的项目

```bash
$ kubectl exec -ti gerrit-master-gerrit-master-deployment-679cd766c4-xd976 -n jenkins bash
$ cd /var/gerrit/review_site/git
$ rm -rf backend-aiops-nx.git
$ git clone --bare ssh://git@gitlab-pro-gitlab-shell.gitlab:30222/aiops-nx/backend-aiops-nx.git
```

### 从gerrit中拉取项目(开发人员)
#### 访问gerrit
浏览器 http://gerrit.devops.nari:30080/
用户名，密码为ldap用户名密码
> 注意:
> 初始密码`123456`,请修改自己的密码
> 修改密码平台为 https://password.devops.nari:30443/

#### 配置ssh免密

`右上角`->`用户名称`->`Settings`->`SSH Keys`

添加公钥，并保存

<img src="image/image-20200611102605816.png" alt="image-20200611102605816" style="zoom:50%;" />

#### 拉取项目

<img src="image/image-20200611102145418.png" alt="image-20200611102145418" style="zoom:50%;" />



1. 选中`SSH`,拷贝上图命令，在命令行执行

```bash
$ git clone "ssh://wanghq@gerrit.devops.nari:30022/backend-aiops-nx" && scp -p -P 30022 wanghq@gerrit.devops.nari:hooks/commit-msg "backend-aiops-nx/.git/hooks/"
Cloning into 'backend-aiops-nx'...
remote: Counting objects: 7820, done
remote: Finding sources: 100% (7820/7820)
remote: Total 7820 (delta 3473), reused 7820 (delta 3473)
Receiving objects: 100% (7820/7820), 7.61 MiB | 1.15 MiB/s, done.
Resolving deltas: 100% (3473/3473), done.
commit-msg                                                                                                        100% 1790    48.2KB/s   00:00    
$

```

2 .执行相关代码编写操作

3 .上传

```bash
admin@kolla00:~/test/backend-aiops-nx$ echo 1> testfile
admin@kolla00:~/test/backend-aiops-nx$
admin@kolla00:~/test/backend-aiops-nx$ git add *
admin@kolla00:~/test/backend-aiops-nx$ git commit -m "test gerrit"
[master 4b4d950] test gerrit
 1 file changed, 1 insertion(+)
# 直接git push显示没有权限
admin@kolla00:~/test/backend-aiops-nx$ git push
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 276 bytes | 276.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1)
remote: error: branch refs/heads/master:
remote: To push into this reference you need 'Push' rights.
remote: User: ttest
remote: Contact an administrator to fix the permissions
remote: Processing changes: refs: 1, done    
To ssh://gerrit.devops.nari:30022/backend-aiops-nx
 ! [remote rejected] master -> master (prohibited by Gerrit: not permitted: update)
error: failed to push some refs to 'ssh://ttest@gerrit.devops.nari:30022/backend-aiops-nx'

# 正确的push方法
admin@kolla00:~/test/backend-aiops-nx$ git push origin master:refs/for/master
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 276 bytes | 276.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1)
remote: Processing changes: refs: 1, new: 1, done    
remote:
remote: SUCCESS
remote:
remote:   http://gerrit.devops.nari:30080/c/backend-aiops-nx/+/23 test gerrit [NEW]
remote:
To ssh://gerrit.devops.nari:30022/backend-aiops-nx
 * [new branch]      master -> refs/for/master
```

#### review 代码

1. 管理员有两票

![image-20200611112035649](image/image-20200611112035649.png)

2. 普通用户有一票

<img src="image/image-20200611114652841.png" alt="image-20200611114652841" style="zoom:50%;" />

> 其中verified 为jenkins自动verified

3. 最后必须得管理员submit，然后提交到gitlab
