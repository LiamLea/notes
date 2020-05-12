# Dockerfile
[toc]
### 基础概念
#### 1.`docker build PATH`
* PATH指定目录
会将**PATH目录下**的**所有文件和目录**都**发送到docker daemon**
所以不在这个PATH下的文件，不能被COPY等
</br>
* 默认读取 PATH/Dockerfile

### 基本语法
有引号的地方必须使用双引号
```shell
FROM 镜像                          #指明基础镜像

MAINTAINER xx                     #镜像创建者信息，该指令已被LABLE取代

LABLE key1=value1 key2=value2 ...     #指定元数据

WORKDIR 路径                      #工作目录，即每次RUN所在的目录，即用 . 时表示的目录

COPY src1 src2 ... dest          #拷贝指定文件到容器内
                                 #（src文件支持通配符，src如果是目录，则会递归目录的内容，但不会目录本身）
                                 #（dest为目录，必须以/结尾，如果dest路径不存在，会自动创建前面的所有目录）

ADD src1 src2 ... dest           #与COPY类似，但是支持url路径
                                 #如果是tar包，会自动解压，然后删除压缩包（url下载的是tar包不会自动解压）

ENV key1=value1 key2=value2 ...     #设置变量，变量会注入到生成的镜像中（即在运行容器中，就会有此变量）
                                    #变量也可被后面的指令引用

ARG xx1 xx2 ...                 #可以引入外部变量：docker build --build-arg xx1=xx

RUN 命令                        #表示命令在容器内运行，可以利用 && 连接多条命令

EXPOSE port1[/protocol] port2[/protocol] ...    #声明要暴露的端口，不能指定绑定宿主机的哪个端口，只能随机绑定
                                                #启动容器时使用-P，就会暴露所有声明要暴露的端口，否则不会暴露

VOLUME ["xx"]                         #不能指定宿主机目录，这个VOLUME语句意义不大

CMD ["cmd","arg1","arg2" ...]      #要用双引号
#启动容器时的默认命令,如果没有就默认用基础镜像的启动命令,如果参数有"-"要加上
#
#启动的进程id为1
#如果cmd不是shell进程，就无法使用shell的特性
#如：   CMD ["/bin/httpd","-h ${variable}"] ，就会出错，因为/bin/httpd为上帝进程，不是shell的子进程，无法使用shell的特性
#改为：CMD ["/bin/sh","-c","/bin/httpd","-h ${variable}"]
#
#如果要启动多个命令,则启动命令为自己编写的脚本(通过ADD上传)
#如果启动命令为脚本，一定要记住！！！！！！：
#脚本中要中exec执行命令，这样通过该命令启动的进程号就为1（不是1的话，脚本执行完毕，容器会结束）

ENTRYPOINT ["cmd","arg1","arg2"]        #与CMD类似，当和CMD同时存在时，CMD就会被当作参数传递过来
                                        #docker run后面接的命令会替代CMD当做参数传递过来

HEAlTHCHECK  --interval=xx \            #默认是30s
             --timeout=xx \             #默认是30s
             --start-period=xx \        #容器启动多久后开始检查，默认是0s，建议根据实际情况而定
             --retries=xx \             #默认是3次
             CMD xx                     #CMD后为，执行的命令
                                        #命令返回值（$?，0：健康，1：不健康，2：保留值）

SHELL ["cmd","arg1","arg2",...]         #设置默认的上帝进程
                                        #不设置，默认为：/bin/sh -c
```
***
### 制作镜像
##### 1.制作docker镜像需要考虑的问题：
* 基础镜像
* 镜像时间
* 镜像内的字符编码
* 启动的用户和挂载的目录的权限
* 分层，当用到同样的环境，可以先制作一层
* 僵尸进程问题
  * 容器内的孤儿进程会交给容器内pid为1的进程，如果该进程不回收子进程，则就会出现僵尸进程
  * 解决：让bash进程为pid为1的进程，或者docker run --init ...
  **注意用bash解决的话，最好写入脚本，不然用bash -c可能pid为1的进程不是bash**

#### 2.相关操作
##### （1）清除缓存
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.cache \
  && rm -rf /tmp/*

##### （2）docker run
* 可以在ENV设置环境变量，也可以再docker run -e 设置环境变量，
* 可以设置启动容器后自动执行之前上传的脚本，引用环境变量，就可以实现定制化配置
