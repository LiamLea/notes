# Lambda

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Lambda](#lambda)
    - [Ovewiew](#ovewiew)
      - [1.Permission](#1permission)
        - [(1) Lambda Permission](#1-lambda-permission)
        - [(2) Lambda Execution Role](#2-lambda-execution-role)
      - [2.Cross Account Permission](#2cross-account-permission)
        - [(1) Lambda Permission](#1-lambda-permission-1)
        - [(2) Assume role in other accounts](#2-assume-role-in-other-accounts)

<!-- /code_chunk_output -->


### Ovewiew

#### 1.Permission

##### (1) Lambda Permission

Inbound (Who can access the Lambda)

##### (2) Lambda Execution Role

Outbound (What the Lambda can access)
* the roles needs to be able to been assumed by `Service = "lambda.amazonaws.com"`

#### 2.Cross Account Permission

##### (1) Lambda Permission

* all organization can invoke this lambda:
* Users in the other account must have the corresponding user permissions to use the Lambda API

```tf
resource "aws_lambda_permission" "allow_organization" {
  statement_id  = "AllowOrganizationInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bcdr_tags_rule.function_name
  
  # Wildcard principal combined with the Org ID limits it strictly to your Organization
  principal        = "*"
  principal_org_id = data.aws_organizations_organization.my_org.id
}
```

##### (2) Assume role in other accounts

* ToAssumeRole in the memeber accounts
* ToAssumeRole needs to be allowed to be assumed by the execution role in lambda account
* ToAssumeRole is passed to lambda through parameters

* e.g. (ToAssumeRole is ExecutionRoleName parameter)
```python
def get_client(service, event, region=None):
    """Return the service boto client. It should be used instead of directly calling the client.

    Keyword arguments:
    service -- the service name used for calling the boto.client()
    event -- the event variable given in the lambda handler
    region -- the region where the client is called (default: None)
    """
    if not ASSUME_ROLE_MODE:
        return boto3.client(service, region)
    credentials = get_assume_role_credentials(get_execution_role_arn(event), region)
    return boto3.client(service, aws_access_key_id=credentials['AccessKeyId'],
                        aws_secret_access_key=credentials['SecretAccessKey'],
                        aws_session_token=credentials['SessionToken'],
                        region_name=region
                       )

# Get execution role for Lambda function
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