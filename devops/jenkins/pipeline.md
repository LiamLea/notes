# pipeline

[toc]

### 概述

#### 1.相关术语

##### （1）Jenkinsfile
用来存放pipeline脚本的文件

##### （2）node
能够执行pipeline的节点

##### （3）stage
一个stage是一个任务子集（在概念上给任务分类）
  * 比如：Build stage、Test stage、Deploy stage等

##### （4）step
一个任务（执行的最小单元）

#### 2.两种语法
可以在jenkins中利用UI界面，生成pipeline脚本
* 声明式（declarative）pipeline
  * 可读性较高（建立采用这种方式）
  * 语法：![]
* 脚本式（scripted）pipeline

***

### 语法

#### 1.基本格式
```groovy
pipeline {
    agent any             //选择执行的节点，这里表示可以在任何节点上
    stages {              
        stage('Build') {  //定义Build stage
            steps {       
                //执行一些steps
            }
        }
        stage('Test') {
            steps {
                //执行一些steps
            }
        }
        stage('Deploy') {
            steps {
                //执行一些steps
            }
        }
    }
}
```
