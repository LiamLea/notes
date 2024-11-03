# External Secrets


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [External Secrets](#external-secrets)
    - [Usage](#usage)
      - [1.Quick Start](#1quick-start)
        - [(1) Install External Secrets Operator](#1-install-external-secrets-operator)
        - [(2) Create SecretStore (i.e. provider)](#2-create-secretstore-ie-provider)
        - [(3) get the secret](#3-get-the-secret)

<!-- /code_chunk_output -->


### Usage

use external secrets, such as get db passwords from aws secret manager

#### 1.Quick Start

##### (1) Install External Secrets Operator

[ref](https://external-secrets.io/latest/introduction/getting-started/)

##### (2) Create SecretStore (i.e. provider)

* also can create a cluster-wide secret store: `kind: ClusterSecretStore`

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: secretstore-sample
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        secretRef:
          accessKeyIDSecretRef:
            name: awssm-secret
            key: access-key
          secretAccessKeySecretRef:
            name: awssm-secret
            key: secret-access-key
```

##### (3) get the secret

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: example
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: secretstore-sample
    kind: SecretStore
  target:
    name: secret-to-be-created
    creationPolicy: Owner
  data:
  - secretKey: secret-key-to-be-managed
    remoteRef:
      key: provider-key
      version: provider-key-version
      property: provider-key-property
  dataFrom:
  - extract:
      key: remote-key-in-the-provider
```