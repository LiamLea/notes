# Policy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Policy](#policy)
    - [Overview](#overview)
      - [1.policy format](#1policy-format)
        - [(1) action](#1-action)

<!-- /code_chunk_output -->


### Overview

#### 1.policy format

[ref](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html)

```json
{
  "Version": "2012-10-17",
  "Statement": [
   {
    "Effect": "Deny", 
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::amzn-s3-demo-bucket/*",
    "Condition": {
      "StringNotEquals": {
        "s3:ExistingObjectTag/Team": "${aws:PrincipalTag/Team}"
       }
      }
    }
  ]
}
```

##### (1) action
[ref](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_action.html)

* s3
* ec2
* IAM