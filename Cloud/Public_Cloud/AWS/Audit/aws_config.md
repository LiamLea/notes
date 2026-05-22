# AWS Config

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [AWS Config](#aws-config)
    - [Overview](#overview)
      - [1.Settings](#1settings)
        - [(1) Configuration Recorder](#1-configuration-recorder)
        - [(2) Data and delivery](#2-data-and-delivery)
      - [2. Aggregators](#2-aggregators)
      - [3. Rules](#3-rules)
        - [(1) Scope](#1-scope)
        - [(2) AWS managed rule](#2-aws-managed-rule)
        - [(2) Custom Lambda rule](#2-custom-lambda-rule)
        - [(3) Custom rule using Guard](#3-custom-rule-using-guard)
      - [4. Advanced queries](#4-advanced-queries)
    - [Usage](#usage)
      - [1.Organization Custome Rule (Lambda)](#1organization-custome-rule-lambda)
        - [(1) Lambda Permission](#1-lambda-permission)
        - [(2) Lambda function](#2-lambda-function)

<!-- /code_chunk_output -->


### Overview

AWS Config is a service that continuously records and evaluates the configuration of your AWS resources. It tracks resource changes over time, checks compliance against rules, and lets you query current resource state.

#### 1.Settings

```tf
resource "aws_config_delivery_channel" "awsconfig_delivery_channel" {
  name           = "awsconfig-delivery-channel"
  # this s3 is in main account 
  s3_bucket_name = "aiops-aws-org-config-bucket"
  depends_on     = [aws_config_configuration_recorder.awsconfig_recorder]
}

resource "aws_iam_service_linked_role" "service_linked_role_config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "awsconfig_recorder" {
  name     = "awsconfig-recorder"
  role_arn = aws_iam_service_linked_role.service_linked_role_config.arn

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }
}

resource "aws_config_configuration_recorder_status" "awsconfig_rec_status" {
  name       = aws_config_configuration_recorder.awsconfig_recorder.name
  is_enabled = "true"
  depends_on = [aws_config_delivery_channel.awsconfig_delivery_channel]
}
```

##### (1) Configuration Recorder

Records resource configuration changes. One recorder per region per account — must be enabled in each region you want to monitor.

- **Continuous** — records on every change (default)
- **Daily** — records once per day if a change occurred (lower cost)

##### (2) Data and delivery

Defines where Config ships recorded data.

- **S3 bucket** — required; receives configuration snapshots and history
- **SNS topic** — optional; sends notifications on configuration changes and rule evaluations
- **Data retention period** — how long Config retains configuration history and snapshots (30 days to 7 years, default 7 years)

#### 2. Aggregators

Collects AWS Config data from multiple accounts and regions into a single view. Source accounts must authorize the aggregator account (automatic if using AWS Organizations).

#### 3. Rules

Evaluate whether resources comply with desired configurations. Non-compliant resources are flagged; auto-remediation can be set up via SSM Automation.

Rules are **regional** — must be deployed in each region you want to monitor. S3 buckets are regional in Config's view (despite global names), so S3 rules follow the same constraint.

Rules are evaluated when:
- A resource configuration changes (change-triggered)
- On a schedule (e.g. every 1/3/6/12/24 hours)
- Manually triggered on demand

##### (1) Scope

- **Account-level** — current account only
- **Organization-level** — auto-propagates to all member accounts; management/delegated admin account only; no console support (API/CLI/Terraform only); still regional

##### (2) AWS managed rule

Pre-built rules maintained by AWS. Cover common compliance checks (e.g. `required-tags-s3-rds`, `encrypted-volumes`, `root-mfa-enabled`). No code required — just enable and configure.

##### (2) Custom Lambda rule

You provide a Lambda function that receives a configuration item and returns `COMPLIANT`, `NON_COMPLIANT`, or `NOT_APPLICABLE`. Triggered either when a specific resource changes (change-triggered) or on a schedule (periodic).

##### (3) Custom rule using Guard

[xRef](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_cfn-guard.html)

Uses AWS CloudFormation Guard (policy-as-code DSL) instead of Lambda. Write Guard rules in a `.guard` file and attach them directly — no Lambda needed. Simpler for straightforward attribute checks.

#### 4. Advanced queries

Query current resource state using SQL. Runs against a live inventory snapshot (not historical).

```sql
SELECT resourceId, resourceName, awsRegion
WHERE resourceType = 'AWS::S3::Bucket'
  AND configuration.versioningConfiguration.status <> 'Enabled'
```

***

### Usage

#### 1.Organization Custome Rule (Lambda)

[xRed](https://aws.amazon.com/blogs/mt/deploying-custom-aws-config-rules-in-an-aws-organization-environment/)

##### (1) Lambda Permission

```tf
resource "aws_lambda_permission" "test_rule_config" {
  statement_id  = "AllowConfigInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_rule.function_name
  principal     = "config.amazonaws.com"
}
```

##### (2) Lambda function
[aws config rule events](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_lambda-functions.html)

* resultToken
    * this param is passed to `AWS_CONFIG_CLIENT.put_evaluations` to write results to rule
* executionRoleArn
    * to assume this role in lambda function to have permissions to write in the member account
* ruleParameters
    * user-defined parameters in rule

* [function example](https://github.com/awslabs/aws-config-rules/blob/b54d4a6c99e105c25ca46af9305770e4ba51c422/python/EC2_INSTANCE_LICENSE_INCLUDED_DEDICATED_HOST/EC2_INSTANCE_LICENSE_INCLUDED_DEDICATED_HOST.py)
```python
# enable assume (note: the executionRole must allow this assume)
ASSUME_ROLE_MODE = True

def get_execution_role_arn(event):
    role_arn = None
    if 'ruleParameters' in event:
        rule_params = json.loads(event['ruleParameters'])
        role_name = rule_params.get("ExecutionRoleName")
        if role_name:
            execution_role_prefix = event["executionRoleArn"].split("/")[0]
            role_arn = "{}/{}".format(execution_role_prefix, role_name)

    if not role_arn:
        role_arn = event['executionRoleArn']

    return role_arn
```

```tf
resource "aws_config_organization_custom_rule" "org_custom_rule" {

  # ...

  # Optional: Pass input parameters to your Lambda function
  input_parameters = jsonencode({
    tagKey   = "ExecutionRoleName"
    tagValue = "ToAssumeRole"
  })
}
```
