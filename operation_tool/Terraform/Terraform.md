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
        - [(1) terraform](#1-terraform)
        - [(2) resource](#2-resource)

<!-- /code_chunk_output -->

### Overview

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

# configure provider (i.g. the target, the secret and etc.)
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

```hcl
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

##### (1) terraform

- Child modules receive their provider configurations from the root module

```hcl
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

```hcl
# create an instance of a resource type
#   different providers provide different resources
resource <resource_type> <instance_name> {}
```

- meta arguments

```hcl
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
    i.g. create_before_destroy = <bool>
        By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations,
        Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
  */
  lifecycle = <lifecycle>
}
```
