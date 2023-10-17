# build


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [build](#build)
    - [构建](#构建)
      - [1.安装repo](#1安装repo)
      - [2.安装git](#2安装git)
        - [(1) 安装git](#1-安装git)
        - [(2) 配置git](#2-配置git)
        - [(3) install lfs](#3-install-lfs)
      - [3.初始化仓库](#3初始化仓库)
      - [4.同步仓库](#4同步仓库)
      - [5.构建](#5构建)
        - [(1) patching](#1-patching)
        - [(2) 安装依赖](#2-安装依赖)
        - [(3) build](#3-build)

<!-- /code_chunk_output -->

### 构建

[参考](https://docs.waydro.id/development/compile-waydroid-lineage-os-based-images#how-to-build)

#### 1.安装repo

[参考](https://source.android.com/docs/setup/download)

* 安装
```shell
# apt-get install repo无法安装，使用下面方法
HTTPS_PROXY="http://10.10.10.250:8123" curl -o /bin/repo https://storage.googleapis.com/git-repo-downloads/repo

chmod +x /bin/repo

ln -s /usr/bin/python3 /usr/bin/python
```

*  验证
```shell
repo version
```

#### 2.安装git

##### (1) 安装git
```shell
apt-get install git git-lfs
```

##### (2) 配置git
```shell
$ vim ~/.gitconfig

#必须要配置email和name，不然repo执行会报错
[user]
        email = liweixiliang@gmail.com
        name = liamlea
[http]
        proxy = http://10.10.10.250:8123
[https]
        proxy = http://10.10.10.250:8123
```

##### (3) install lfs

```shell
git lfs install
```

#### 3.初始化仓库

* 初始化
```shell
HTTPS_PROXY="http://10.10.10.250:8123" repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs
HTTPS_PROXY="http://10.10.10.250:8123" repo sync build/make
```

* 配置wget代理
```shell
$ vim ~/.wgetrc

use_proxy=yes
http_proxy=10.10.10.250:8123
https_proxy=10.10.10.250:8123
```

* 下载manifests
```shell
wget -O - https://raw.githubusercontent.com/waydroid/android_vendor_waydroid/lineage-18.1/manifest_scripts/generate-manifest.sh | bash
```

#### 4.同步仓库

```shell
#这一步很慢，最好使用nohup放在后台同步
nohup /bin/bash -c "HTTPS_PROXY=10.10.10.250:8123 HTTP_PROXY=10.10.10.250:8123 repo sync" &
```

#### 5.构建

##### (1) patching
```shell
. build/envsetup.sh
apply-waydroid-patches
```

##### (2) 安装依赖
```shell
apt-get install libncurses5 unzip zip python3-pip glslang-tools byacc flex

pip install --proxy 10.10.10.250:8123 meson
```

##### (3) build

* 内存需要16G左右
* 存储至少需要400G

```shell
. build/envsetup.sh
lunch lineage_waydroid_x86_64-userdebug
#  支持的options
#lineage_waydroid_arm-userdebug
#lineage_waydroid_arm64-userdebug
#lineage_waydroid_x86-userdebug
#lineage_waydroid_x86_64-userdebug

make systemimage -j$(nproc --all)
make vendorimage -j$(nproc --all)
```

```shell
breakfast tissot
```