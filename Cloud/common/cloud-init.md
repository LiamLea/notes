# cloud-init

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [cloud-init](#cloud-init)
    - [Overview](#overview)
      - [1.module frequency](#1module-frequency)
      - [2.Initialization data sources](#2initialization-data-sources)
        - [(1) cloud metadata](#1-cloud-metadata)
        - [(2) user data](#2-user-data)
        - [(3) vendor data](#3-vendor-data)
        - [(4) cloud-init configuration files](#4-cloud-init-configuration-files)
      - [3.Related files and directories](#3related-files-and-directories)
        - [(1) Configuration files](#1-configuration-files)
        - [(2) Log files](#2-log-files)
        - [(3) Runtime and cache directories](#3-runtime-and-cache-directories)
    - [Usage](#usage)
      - [1.cloud-config format](#1cloud-config-format)
      - [2.best practice for user scripts](#2best-practice-for-user-scripts)

<!-- /code_chunk_output -->

### Overview

#### 1.module frequency
* `per-instance`
  * Runs once per instance, determined by cache to check if the instance has executed:
    * openstack: `/var/lib/cloud/instances/<sn>/`
    * aws ec2: `/var/lib/cloud/instances/<instance_id>/`

* `per-boot`
  * Runs every time the system boots
  
* `per-once`
  * Runs only once (across all instances)

#### 2.Initialization data sources

##### (1) cloud metadata
Instance metadata provided by the cloud platform (e.g., instance ID, hostname, network configuration)

##### (2) user data
User-provided data for input, supports two formats:

* cloud config data
  * Cloud-init configuration file format, starts with `#cloud-config`
  * YAML-based configuration for declarative system setup

* user scripts
  * Executable user scripts, starts with `#!`
  * Can be shell scripts or any executable script

##### (3) vendor data
Data provided by the cloud vendor, similar to user data but controlled by the cloud provider

##### (4) cloud-init configuration files
Configuration files located in `/etc/cloud/cloud.cfg` and `/etc/cloud/cloud.cfg.d/`

#### 3.Related files and directories

##### (1) Configuration files
* `/etc/cloud/cloud.cfg` - Main configuration file
* `/etc/cloud/cloud.cfg.d/` - Additional configuration directory
* `/etc/cloud/templates/` - Template files for various services

##### (2) Log files
* `/var/log/cloud-init.log` - Main cloud-init log file with detailed execution stages
* `/var/log/cloud-init-output.log` - Captures all output (stdout/stderr) from user scripts and cloud-config modules

##### (3) Runtime and cache directories
* `/var/lib/cloud/` - Instance data and cache
  * `/var/lib/cloud/instance/` - Current instance data
  * `/var/lib/cloud/instances/<instance-id>/` - Per-instance cache and data
  * `/var/lib/cloud/data/` - Cached cloud metadata
  * `/var/lib/cloud/scripts/` - User scripts cache

***

### Usage

#### 1.cloud-config format
[xRef](https://docs.cloud-init.io/en/latest/reference/modules.html)

#### 2.best practice for user scripts

```shell
#!/bin/sh
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error.
# -x: Print commands to stdout (great for cloud-init logs in /var/log/cloud-init-output.log).
set -eux

# Ensures that if a command in a pipeline (like curl | sh) fails, the whole pipeline is considered a failure.
set -o pipefail

# run command with retry
for i in {1..5}; do
    curl -fssL https://tailscale.com/install.sh | sh && break
    if [ $i -eq 5 ]; then echo "Failed after 5 tries"; exit 1; fi
    sleep 5
done

# hidden secret
set +x
for i in {1..5}; do
    TSKEY=$(aws secretsmanager get-secret-value \
        --secret-id "$SECRET_ARN" \
        --region "$AWS_REGION" \
        --query "SecretString" \
        --output text 2>/dev/null) && break 
    if [ $i -eq 5 ]; then echo "Failed after 5 tries"; exit 1; fi
    sleep 5
done
set -x

for i in {1..5}; do
    echo "Attempt $i: Installing Go..."
    
    # We use a subshell ( ... ) to group the Go installation steps
    if (
        LATEST=$(curl -s "https://go.dev/VERSION?m=text" | head -n1)
        TARBALL="${LATEST}.${ARCH}.tar.gz"
        URL="https://go.dev/dl/${TARBALL}"
        
        curl -fLO "$URL"
        tar -C /usr/local -xzf "$TARBALL"
        rm "$TARBALL"
    ); then
        echo "Go installed successfully."
        break
    fi

    # If we reached here, the block above failed
    if [ $i -eq 5 ]; then
        echo "Error: Failed to install Go after 5 attempts. Exiting." >&2
        exit 1
    fi

    echo "Attempt $i failed. Retrying in 5s..."
    sleep 5
done
```