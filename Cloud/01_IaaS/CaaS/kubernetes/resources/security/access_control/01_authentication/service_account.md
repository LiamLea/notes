# Service Account

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Service Account](#service-account)
    - [Overview](#overview)
      - [1.Concepts](#1concepts)
        - [(1) What (identity)](#1-what-identity)
        - [(2) JWT Token (ServiceAccount credentials)](#2-jwt-token-serviceaccount-credentials)
      - [2.Must enable issuer](#2must-enable-issuer)
      - [3.Default SA](#3default-sa)
      - [4. JWT Token](#4-jwt-token)
        - [(1) token content](#1-token-content)
        - [(2) generate a token for a SA](#2-generate-a-token-for-a-sa)

<!-- /code_chunk_output -->


### Overview

#### 1.Concepts

##### (1) What (identity)

A service account provides **a distinct identity** in a k8s

##### (2) JWT Token (ServiceAccount credentials)
A token is used to authenticate and prove the identity of the service account

#### 2.Must enable issuer
```shell
# oidc discovery: https://<issuer>/.well-known/openid-configuration
# so to make tokens can be recognized by public services, the <issuer> must be accessed publicly
--service-account-issuer=https://my-test.s3.ap-northeast-1.amazonaws.com

# The "Address" where the public can verify that ID card.
--service-account-jwks-uri=https://my-test.s3.ap-northeast-1.amazonaws.com/openid/v1/jwks

# The public key (stored on disk) used for internal verification.
--service-account-key-file=/srv/kubernetes/kube-apiserver/service-account.pub

# The private key (stored on disk) used to create the tokens.
--service-account-signing-key-file=/srv/kubernetes/kube-apiserver/service-account.key
```

#### 3.Default SA

* every namespace has
  * a serviceaccount: `default`

* when a pod starts, it will mount `token, namespace and ca` on the specific directory (`/var/run/secrets/kubernetes.io/serviceaccount/`) 
  * why this directory?
    * it is **conventional** so that when developers develop a app running in the pod they know how to find the token  
* the app running in the pod can access k8s api with the token

#### 4. JWT Token

##### (1) token content

* decode the token (JWT)
```json
{
  "aud": [
    "api"
  ],
  "iss": "https://my-test.s3.ap-northeast-1.amazonaws.com",
  "sub": "system:serviceaccount:default:test-leo",
  "exp": 1751424577,
  // ...
}
```

##### (2) generate a token for a SA
```shell
kubectl create token <service-account-name> -n <namespace> \
--duration=2h \
--audience=https://my-api.example.com
```

* decode token
```shell
# Decode header
echo $TOKEN | cut -d. -f1 | base64 -d 2>/dev/null | jq .

# Decode payload (the useful part)
echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null | jq .
```



