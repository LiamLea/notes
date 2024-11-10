# IAM (Identity and Access Management)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [IAM (Identity and Access Management)](#iam-identity-and-access-management)
    - [Overview](#overview)
      - [1.basic](#1basic)
        - [(1) concepts](#1-concepts)
        - [(2) credentials](#2-credentials)
        - [(3) API](#3-api)
        - [(4) external credentials](#4-external-credentials)
      - [2.role](#2role)
        - [(1) assume a role](#1-assume-a-role)
        - [(2) trust policy](#2-trust-policy)
        - [(3) permission policy](#3-permission-policy)
    - [IRSA (IAM role for serviceaccount)](#irsa-iam-role-for-serviceaccount)
      - [1.Usage](#1usage)
        - [(1) install pod identity webhook](#1-install-pod-identity-webhook)
        - [(2) create an OIDC provider](#2-create-an-oidc-provider)
        - [(3) create a role](#3-create-a-role)
        - [(4) create the serviceaccount](#4-create-the-serviceaccount)
        - [(5) create pods using the serviceaccount](#5-create-pods-using-the-serviceaccount)

<!-- /code_chunk_output -->

### Overview

#### 1.basic 

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

#### 2.role

##### (1) assume a role
* when you assume a role, it provides you with **temporary** security credentials for your role session
* can give AWS access to users who already have identities defined outside of AWS

##### (2) trust policy
[policy grammar](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_grammar.html)

* specify which **principal** can assume this role
  * account
  ```json
  // does not limit permissions to only the root user of the account
  "Principal": { "AWS": "arn:aws:iam::123456789012:root" }
  ```
  * username
  ```json
  "Principal": {
    "AWS": [
      "arn:aws:iam::AWS-account-ID:user/user-name-1", 
      "arn:aws:iam::AWS-account-ID:user/user-name-2"
    ]
  }
  ```
  * role
  ```json
  "Principal": { "AWS": "arn:aws:iam::AWS-account-ID:role/role-name" }
  ```
  * service
  * session
  * ...

* example
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::123456789012:user/test"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

##### (3) permission policy
[policy grammar](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_grammar.html)

* define whcih role this user can assume
  * so if a AWS user wants to assume a role, it needs to 
    * set corresponding permission policy for the user
    * set corresponding trust policy for that role
* define permissions for specific services and resources
* a permission policy can **attach** to role, user and etc.

* example
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::aiops-test-website",
                "arn:aws:s3:::aiops-test-website/*"
            ]
        }
    ]
}
```

***

### IRSA (IAM role for serviceaccount)

#### 1.Usage

##### (1) install pod identity webhook
* insatll [aws pod identity weebhook](https://github.com/aws/amazon-eks-pod-identity-webhook)

##### (2) create an OIDC provider

* OIDC discovery for [self-hosted k8s](https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/SELF_HOSTED_SETUP.md):
  * k8s will use private key sign serviceaccount token
    ```shell
    # k8s private key used to sign serviceaccount token
    --service-account-signing-key-file string

    # k8s public key used to validate serviceaccout token
    --service-account-key-file strings
    ```
  * AWS needs to store the k8s's public key in S3, then use public key to authenticate request to make sure it comes from the k8s
    ```shell
    # store openid related config
    s3://$S3_BUCKET/.well-known/openid-configuration

    # store k8s public key
    s3://$S3_BUCKET/keys.json
    ```
    
* Create an OIDC provider in IAM for your cluster
  * configure OIDC discovery endpoint (i.e. S3 endpoint)

##### (3) create a role
* Create an IAM role and trust policy for an serviceaccount
  * define which role can assume this role
```json
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Federated": "arn:aws:iam::111122223333:oidc-provider/oidc.REGION.eks.amazonaws.com/CLUSTER_ID"
   },
   "Action": "sts:AssumeRoleWithWebIdentity",
   "Condition": {
    "__doc_comment": "scope the role to the service account (optional)",
    "StringEquals": {
     "oidc.REGION.eks.amazonaws.com/CLUSTER_ID:sub": "system:serviceaccount:default:my-serviceaccount"
    },
    "__doc_comment": "scope the role to a namespace (optional)",
    "StringLike": {
     "oidc.REGION.eks.amazonaws.com/CLUSTER_ID:sub": "system:serviceaccount:default:*"
    }
   }
  }
 ]
}
```

##### (4) create the serviceaccount
* create a specific serviceaccount according to the conditions set in the previous step
  * because only a qualified serviceaccount which meet the conditions set in the role can assume that role
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-serviceaccount
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::111122223333:role/s3-reader"
    # optional: Defaults to "sts.amazonaws.com" if not set
    eks.amazonaws.com/audience: "sts.amazonaws.com"
    # optional: When set to "true", adds AWS_STS_REGIONAL_ENDPOINTS env var
    #   to containers
    eks.amazonaws.com/sts-regional-endpoints: "true"
    # optional: Defaults to 86400 for expirationSeconds if not set
    #   Note: This value can be overwritten if specified in the pod 
    #         annotation as shown in the next step.
    eks.amazonaws.com/token-expiration: "86400"
```

##### (5) create pods using the serviceaccount
* All new pod pods launched using this Service Account will be modified to use IAM for pods
    * the environment variables and volume fields added by the webhook.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  namespace: default
  annotations:
    # optional: A comma-separated list of initContainers and container names
    #   to skip adding volumes and environment variables
    eks.amazonaws.com/skip-containers: "init-first,sidecar"
    # optional: Defaults to 86400, or value specified in ServiceAccount
    #   annotation as shown in previous step, for expirationSeconds if not set
    eks.amazonaws.com/token-expiration: "86400"
spec:
  serviceAccountName: my-serviceaccount
  initContainers:
  - name: init-first
    image: container-image:version
  containers:
  - name: sidecar
    image: container-image:version
  - name: container-name
    image: container-image:version
### Everything below is added by the webhook ###
    env:
    - name: AWS_DEFAULT_REGION
      value: us-west-2
    - name: AWS_REGION
      value: us-west-2
    - name: AWS_ROLE_ARN
      value: "arn:aws:iam::111122223333:role/s3-reader"
    - name: AWS_WEB_IDENTITY_TOKEN_FILE
      value: "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
    - name: AWS_STS_REGIONAL_ENDPOINTS
      value: "regional"
    volumeMounts:
    - mountPath: "/var/run/secrets/eks.amazonaws.com/serviceaccount/"
      name: aws-token
  volumes:
  - name: aws-token
    projected:
      sources:
      - serviceAccountToken:
          audience: "sts.amazonaws.com"
          expirationSeconds: 86400
          path: token
```