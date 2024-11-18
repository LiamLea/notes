# Modules


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Modules](#modules)
    - [Overview](#overview)
      - [1.load a module](#1load-a-module)
      - [2.write a module](#2write-a-module)
        - [(1) define input variables](#1-define-input-variables)
      - [2.refacor to using modules](#2refacor-to-using-modules)

<!-- /code_chunk_output -->


### Overview

#### 1.load a module
to reuse resource configurations

```tf
module <instance_name> {
  # if not specify repo, use the default modules repo (Terraform Registry)
  source  = "hashicorp/consul/aws"

  version = "0.0.5"

  # other arguments are the inputs of the module (the inputs are the varaibles of the module)
  servers = 3
}
```

* example
    ```tf
    module "docker" {
    # if not specify repo, use the default modules repo (Terraform Registry)
    source  = "./modules/test"
    }
    ```
    * init
    ```shell
    terraform init
    ```

#### 2.write a module
[reference](https://github.com/hashicorp/learn-terraform-modules-create/tree/main)

* a typical structure
```shell
<module_name>/
    ├── LICENSE
    ├── README.md
    ├── main.tf
    ├── variables.tf  # define input
    ├── outputs.tf

# None of these files are required
```

* `./modules/test/main.tf`
  * modules will inherit `provider` (not `required_providers`)
  * so the best practice is to specify `required_providers` or it will use the default

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

/*
  then write tasks
*/
resource "docker_image" "nginx_2" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx_2" {
  image = docker_image.nginx_2.image_id
  name  = "tutorial_2"

  ports {
    internal = 80
    external = 8004
  }
}
```

##### (1) define input variables

* `varaibles.tf`
```tf
variable "environment" {
  type = string
}

variable "v1" {
  type = object({
    function_name          = string
    debug        = optional(bool, false)
  })
}

variable "v2" {
  type = object({
    log_group_name     = string
    log_filter_name    = optional(string, "test-filter")
  })
}
```

#### 2.refacor to using modules
[Ref](https://developer.hashicorp.com/terraform/tutorials/configuration-language/move-config)

* need to use `moved` to relate the previous resources with the current, or it will delete and create a new 
```tf
moved {
  from = docker_container.nginx_2
  to   = module.mydocker.docker_container.nginx
}
```

