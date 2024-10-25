# Terraform

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Terraform](#terraform)
    - [Overview](#overview)
      - [1.Quick start](#1quick-start)
        - [(1) Install Terraform](#1-install-terraform)
        - [(2) Write Configuration](#2-write-configuration)
      - [2.Configuration Achitecture](#2configuration-achitecture)
        - [(1) terraform block](#1-terraform-block)
        - [(2) backend block](#2-backend-block)
      - [3.Configuration Main Components](#3configuration-main-components)
        - [(1) provider](#1-provider)
        - [(2) resource](#2-resource)
      - [3.Modules](#3modules)
      - [4.State](#4state)
        - [(1) basic](#1-basic)
        - [(2) format](#2-format)

<!-- /code_chunk_output -->

### Overview

![](./imgs/tf_01.png)

#### 1.Quick start

##### (1) Install Terraform

[reference](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)

##### (2) Write Configuration

```shell
mkdir terraform-test
cd terraform-test
vim main.tf
```

```tf
terraform {
  # specify provider and its version
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# configure provider (e.g. the target, the secret and etc.)
provider "docker" {}

/*
  then write tasks
*/
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}

```

#### 2.Configuration Achitecture

##### (1) terraform block

[reference](https://developer.hashicorp.com/terraform/language/terraform)

- common configuration

```tf
terraform {
  # Specifies which version of the Terraform CLI is allowed to run the configuration
  required_version = ">= 1.3.9"

  # Specifies all provider plugins
  required_providers {}

  # Specifies a mechanism for storing Terraform state files
  backend "<backend_type>" {}
}
```

##### (2) backend block

[reference](https://developer.hashicorp.com/terraform/language/backend)

#### 3.Configuration Main Components

##### (1) provider

- Child modules receive their provider configurations from the root module

```tf
# default configuration
# "google" is a provider plugin name which must be defined in the required_providers
provider "google" {
  region = "us-central1"
}

# alternate configuration, whose alias is "europe"
provider "google" {
  alias  = "europe"
  region = "europe-west1"
}
```

##### (2) resource

```tf
# create an instance of a resource type
#   different providers provide different resources
resource <resource_type> <instance_name> {}
```

- meta arguments

```tf
resource <resource_type> <instance_name> {
  # this will affect the running order of tasks
  depends_on = []

  # the numer of the resource install
  count = 2

  /*
  accepts a map or a set of strings, and creates an instance for each item in that map or set
    below will create 2 instances:
      instance1: {name: a_group, location: eastus}
      instance2: {name: another_group, location: westus}
  */
  for_each = tomap({
    a_group       = "eastus"
    another_group = "westus2"
  })
  name     = each.key
  location = each.value

  # specifies which provider configuration to use for the resource
  provider = <provider>

  /*
    e.g. create_before_destroy = <bool>
        By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations,
        Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
  */
  lifecycle = <lifecycle>
}
```

#### 3.Modules

to reuse resource configurations

```tf
# load modules e.g.
module "consul" {
  # if not specify repo, use the default modules repo (Terraform Registry)
  source  = "hashicorp/consul/aws"

  version = "0.0.5"

  # other arguments are the inputs of the module (the inputs are the varaibles of the module)
  servers = 3
}
```

#### 4.State

to map real world resources to your configuration

##### (1) basic

- default local storage: `terraform.tfstate`
- Prior to any operation, Terraform does a refresh to update the state with the real infrastructure

##### (2) format
