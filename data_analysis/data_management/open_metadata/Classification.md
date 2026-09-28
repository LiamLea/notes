# Classsification

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Classsification](#classsification)
    - [Overview](#overview)
      - [1.What](#1what)
    - [Auto Classification](#auto-classification)
      - [1.Two detection approaches](#1two-detection-approaches)
        - [(1) Column Name Scanner](#1-column-name-scanner)
        - [(2) Entity Recognition](#2-entity-recognition)
      - [2.Auto PII Tagging](#2auto-pii-tagging)
      - [3.External workflow](#3external-workflow)

<!-- /code_chunk_output -->


### Overview

#### 1.What

Classification is a controlled vocabulary and can be used for **labeling data**

***

### Auto Classification

#### 1.Two detection approaches

##### (1) Column Name Scanner

##### (2) Entity Recognition

collect sample data to match pattern
* you can set not to store the sample data

#### 2.Auto PII Tagging
validates them against an Entity Recognition engine that identifies sensitive information from a list of [supported entities](https://presidio.dataprivacystack.org/supported_entities/)

#### 3.External workflow

[example](https://docs.open-metadata.org/v2.0.x/how-to-guides/data-governance/classification/auto-classification/external-workflow) 