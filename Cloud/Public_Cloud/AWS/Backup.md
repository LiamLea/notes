# AWS Buckup

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [AWS Buckup](#aws-buckup)
    - [Overview](#overview)
      - [1.Vaults](#1vaults)
        - [(1) Backup vaults](#1-backup-vaults)
        - [(2) Logically air-gapped vaults](#2-logically-air-gapped-vaults)
      - [2.Backup plans](#2backup-plans)

<!-- /code_chunk_output -->


### Overview

#### 1.Vaults

##### (1) Backup vaults

* User-Owned
    * if the account has been deleted, this vault will no longer exist

##### (2) Logically air-gapped vaults

* AWS-Owned
    * the vault is managed by aws and users can't delete it

* use RAM share with other accounts

#### 2.Backup plans