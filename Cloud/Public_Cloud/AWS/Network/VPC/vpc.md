# VPC

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [VPC](#vpc)
    - [Overview](#overview)
      - [1.Internet gateways vs NAT gateways](#1internet-gateways-vs-nat-gateways)
      - [2.VPC Attributes](#2vpc-attributes)
        - [(1) enableDnsSupport](#1-enablednssupport)
        - [(2) enableDnsHostnames](#2-enablednshostnames)
      - [3.gateway endpoints](#3gateway-endpoints)
    - [demo](#demo)
      - [1.create vpc](#1create-vpc)

<!-- /code_chunk_output -->


### Overview

#### 1.Internet gateways vs NAT gateways

* Internet gateways
    * allow to expose service in the internet through **1:1 NAT**
* NAT gateways
    * can only allow to access internet because of **Many:1 NAT**
    * can expose service through LB, etc.

#### 2.VPC Attributes

##### (1) enableDnsSupport
* if use AWS provided-DNS server

##### (2) enableDnsHostnames
* Assigns public DNS names to instances with public IPs
* e.g.: `ec2-54-123-45-67.ap-northeast-1.compute.amazonaws.com`

#### 3.gateway endpoints
* only s3 and DynamoDB support [gateway endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html) (free)
    * adds route entry to route table
    * so instances in the subnet can access s3 through internal network
* other AWS services use **Interface endpoints** (paid)

***

### demo

#### 1.create vpc

* create three subnets: private, public, db

```terraform
module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v5.8"

  name = "my-test-vpc"
  cidr = "10.6.0.0/16"

  azs              = ["ap-northeast-1c", "ap-northeast-1d"]
  private_subnets  = ["10.6.1.0/24", "10.6.2.0/24"]
  public_subnets   = ["10.6.3.0/24", "10.6.4.0/24"]
  database_subnets = ["10.6.5.0/24", "10.6.6.0/24"]

  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_route_table    = false

  create_igw           = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}
```