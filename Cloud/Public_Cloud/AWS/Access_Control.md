# Access Control

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Access Control](#access-control)
    - [Overview](#overview)
      - [IAM (Identity and Access Management)](#iam-identity-and-access-management)
        - [(1) concepts](#1-concepts)
        - [(2) credentials](#2-credentials)
        - [(3) API](#3-api)
        - [(4) external credentials](#4-external-credentials)

<!-- /code_chunk_output -->

### Overview

#### IAM (Identity and Access Management)

##### (1) concepts

* Account ID
    * when logging in with a non-root user account

##### (2) credentials

* access key
    * enable access key id and secret access key for the AWS API

* username/password
    * use account id and password for web login

* temperary Credentials
    * access key id
    * secret access key
    * session token

##### (3) API

* first need to sign request
    * use access key id and secret access key to get token
    * add `Authrization: <token>` to the header of a request

##### (4) external credentials

* `~/.aws/config`

```
[profile developer]
credential_process = <shell_command>
```

* Expected output from the Credentials program

```json
{
    "Version": 1,
    "AccessKeyId": "an AWS access key",
    "SecretAccessKey": "your AWS secret access key",
    "SessionToken": "the AWS session token for temporary credentials",
    "Expiration": "ISO8601 timestamp when the credentials expire"
}
```
