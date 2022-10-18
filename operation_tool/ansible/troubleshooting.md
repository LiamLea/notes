
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [troubleshooting](#troubleshooting)
  - [1.方式](#1方式)
    - [（1）利用`-vvv`查看详细命令](#1利用-vvv查看详细命令)
    - [（2）利用`ANSIBLE_KEEP_REMOTE_FILES=1`这个变量，保留临时文件](#2利用ansible_keep_remote_files1这个变量保留临时文件)

<!-- /code_chunk_output -->

### troubleshooting

#### 1.方式

##### （1）利用`-vvv`查看详细命令

##### （2）利用`ANSIBLE_KEEP_REMOTE_FILES=1`这个变量，保留临时文件

或者
```shell
$ cat ansible.cfg
[defaults]
keep_remote_files = true
```
