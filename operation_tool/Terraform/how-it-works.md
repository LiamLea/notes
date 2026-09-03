
# How it works

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [How it works](#how-it-works)
    - [Init](#init)
      - [1.Init Process](#1init-process)
        - [(1) Configuration File Discovery (`.tf`)](#1-configuration-file-discovery-tf)
        - [(2) Module Installation](#2-module-installation)
        - [(3) Provider Initialization](#3-provider-initialization)
        - [(4) Backend Initialization](#4-backend-initialization)
        - [(5) Compatibility Check](#5-compatibility-check)
      - [2.reconfigure](#2reconfigure)
      - [3.upgrade](#3upgrade)
    - [Plan](#plan)
      - [1.Plan Process](#1plan-process)
        - [(1) Refresh State](#1-refresh-state)
        - [(2) Compare](#2-compare)
      - [2.Plan File](#2plan-file)
        - [(1) File Structure](#1-file-structure)
    - [Apply](#apply)
        - [1.Apply Process](#1apply-process)

<!-- /code_chunk_output -->


### Init

#### 1.Init Process

##### (1) Configuration File Discovery (`.tf`)

##### (2) Module Installation
modules are plain HCL text whose exact version or Git commit hash is explicitly declared directly within your `.tf` files, so it won't need to be locked in `.terraform.lock.hcl`

- install into `.terraform/modules` according to `source` and `version`

##### (3) Provider Initialization
- resolution
    - read `.terraform.lock.hcl` to resolve version
    - if not in `.terraform.lock.hcl`, then resolve according to required_providers

- installation
    - `.terraform/providers`

- Locking
    - updates `.terraform.lock.hcl`

##### (4) Backend Initialization

- read the backend block inside the configuration (s3)
- caches the backend settings: `.terraform/terraform.tfstate`
    - why need this: the resolved location isn't always in your config (partial config comes from CLI flags)

##### (5) Compatibility Check

- compare provider found in the configuration (in step 2) with provider found in the state

#### 2.reconfigure

- terraform init
    - if it sees difference between backend settings and `.terraform/terraform.tfstate`, it will ask if you want to migrate you state data

- terraform init -reconfigure
    - generate new `.terraform/terraform.tfstate`

#### 3.upgrade

- ignore cache and `.terraform.lock.hcl`

***

### Plan

#### 1.Plan Process

##### (1) Refresh State
- **loads** the state file, **refreshes** it in memory against the real world via each provider's ReadResource

##### (2) Compare
- compare terraform code with refreshed state to generate diff

#### 2.Plan File

The plan file is a **snapshot**

```shell
terraform plan -out <planfile>
terraform show -json <planfile>
```

##### (1) File Structure

```json
{
    "format_version": "1.2",
    "terraform_version": "1.15.2",
    "planned_values": {
        // The expected final state
    },
    "resource_drift": {
        // unexpected differences between your real-world cloud infrastructure and the Terraform state file
    },
    "resource_changes": {
        // The step-by-step diff/delta between prior_state and planned_values (contains specific actions like ["create"], ["update"], ["delete"]).
    },
    "prior_state": {
        // The complete snapshot
    },

    "configuration": {
        // The raw representation of your local .tf code at plan time
    },

    "relevant_attributes": {
        // any change to one attribute directly forces a change on the downstream resources which relies on the attribute.
    }
}
```

***

### Apply

##### 1.Apply Process

- Refresh State
    - update state file according to resource_drift

- Apply Changes

- Final State
    - writes the cloud's exact post-execution response (ids,etc) into the state file
