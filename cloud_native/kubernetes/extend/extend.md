# 扩展
[toc]
### 概述
#### 1.custome resource
自定义资源，是对kubernetes API的一种扩展（相当于添加新的api）
定义数据格式，描述应用信息
#### 2.custome controller
根据crd，创建相应的应用
将自定义资源和自定义控制器结合，自定义资源才能提供一个真正的声明式API

#### 3.operator
operator是基于resources和controllers，但同时又包含了应用程序特定的领域知识
用于部署、管理特定的k8s应用（一种应用对应一个operator，比如要部署和管理nginx应用，则就需要创建一个operator来管理nginx）
