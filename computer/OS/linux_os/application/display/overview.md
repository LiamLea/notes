# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [overview](#overview-1)
      - [1.架构](#1架构)

<!-- /code_chunk_output -->


### overview

#### 1.架构
![](./imgs/ov_01.png)

* 查看desktop graphical interface (aka "GUI")
```shell
# 如果使用的X11 display server
$ env | grep -i xdg

XDG_CURRENT_DESKTOP=ubuntu:GNOME
```

* 不同的GUI使用不同的window manager
    * GNOME: GNOME Mutters
    * KDE: KWin