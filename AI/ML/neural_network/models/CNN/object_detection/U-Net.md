# U-Net


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [U-Net](#u-net)
    - [概述](#概述)
      - [1.semantic segmentation](#1semantic-segmentation)
      - [2.transpose convolutions](#2transpose-convolutions)
      - [3.U-Net](#3u-net)

<!-- /code_chunk_output -->


### 概述

#### 1.semantic segmentation
* 目的： Assign a specific category label to every single pixel in an image
![](./imgs/un_01.png)

* neural network
![](./imgs/un_02.png)

#### 2.transpose convolutions

* 原图像的每个元素，与filter相乘，然后按照stride叠加起来，最后按照padding进行裁减
![](./imgs/un_03.png)

#### 3.U-Net
![](./imgs/un_04.png)

* 右边深蓝色的都是从左边拷贝过去的