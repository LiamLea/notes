# SDK

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SDK](#sdk)
    - [Overview](#overview)
      - [1.credential provider chain](#1credential-provider-chain)

<!-- /code_chunk_output -->


### Overview

#### 1.credential provider chain

[xRef](https://docs.aws.amazon.com/sdkref/latest/guide/standardized-credentials.html#sdk-chains)

| Credential Provider | Description |
| :--- | :--- |
| **AWS Access Keys** | Uses static credentials for an IAM user (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and optional `AWS_SESSION_TOKEN`). |
| **Federate with Web Identity / OIDC** | Signs in using an external IdP (Login with Amazon, Facebook, Google, or any OIDC-compatible IdP). It assumes an IAM role using a JWT from AWS STS. This is the mechanism used by **EKS IRSA**. |
| **Login Credentials Provider** | Retrieves credentials for a new or existing console session that you are currently logged in to. |
| **IAM Identity Center** | Fetches credentials directly from AWS IAM Identity Center (formerly AWS Single Sign-On). |
| **Assume Role Provider** | Obtains temporary security credentials by assuming a specific IAM role to access resources in different accounts or with different permissions. |
| **Container Credentials** | Specifically for **Amazon ECS** (Task Roles) and **Amazon EKS**. The provider fetches credentials for the containerized application via a local URI injected by the environment. |
| **Process Credentials** | A custom provider that sources credentials from an external process or tool, including **IAM Roles Anywhere** for on-premises workloads. |
| **IMDS Credential Provider** | The "last resort" in the chain. It fetches **EC2 Instance Profile** credentials via the Amazon EC2 Instance Metadata Service (at `169.254.169.254`). |

* Note: 
    * `169.254.169.254` in aws provided ami is intercepted by aws 
    * `169.254.169.254` in pod will route to its node so pod can get the same role as the node