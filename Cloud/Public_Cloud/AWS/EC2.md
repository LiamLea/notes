# EC2 


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [EC2](#ec2)
    - [Overview](#overview)
      - [1.IMDS (Instance Metadata Service)](#1imds-instance-metadata-service)
        - [(1) why](#1-why)
        - [(2) access IMDS](#2-access-imds)
      - [2.Auto Scaling Group](#2auto-scaling-group)
        - [(1) refresh](#1-refresh)

<!-- /code_chunk_output -->


### Overview

[REF](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Instances.html)

#### 1.IMDS (Instance Metadata Service)

##### (1) why
* access instance metadata from a **running instance** or **containers** running in the instance
    * container: `AWS_EXECUTION_ENV=AWS_ECS_EC2`
        * This indicates that the container is running inside an AWS EC2 instance within an ECS (Elastic Container Service) environment. This suggests the container might be accessing AWS resources via ECS metadata and IAM roles
* instance access the AWS access **credentials** for the IAM role attached to the instance through IMDS
    * The IMDS exposes this instance metadata through a special “link-local” IP address of `169.254.169.254`

##### (2) access IMDS
[ref](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html) 

#### 2.Auto Scaling Group

##### (1) refresh

update the instance to the latest launch template 