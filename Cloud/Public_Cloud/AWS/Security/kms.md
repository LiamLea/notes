# KMS

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [KMS](#kms)
    - [Overview](#overview)
      - [1.Direct Encryption](#1direct-encryption)
      - [2.Envelope Encryption](#2envelope-encryption)

<!-- /code_chunk_output -->


### Overview

#### 1.Direct Encryption

* Upload: Your server calls kms:Encrypt and **sends the raw file** or data payload over the network **to AWS**.
* Process: AWS passes that data into its physical, secure hardware (HSM), where the KMS Root Key encrypts it
* Download: AWS sends the encrypted file (ciphertext) back over the network to your application.

#### 2.Envelope Encryption

* KMS generates a **Data Encryption Key (DEK)** encrypted by your KMS key.
* use DEK to encrypt plaintext data locally

