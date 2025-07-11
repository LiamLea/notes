# OpenAPI


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OpenAPI](#openapi)
    - [Overview](#overview)
      - [1.OpenAPI](#1openapi)
      - [2.API Hub](#2api-hub)
      - [3.openapi-generator-cli](#3openapi-generator-cli)

<!-- /code_chunk_output -->


### Overview

#### 1.OpenAPI
* a machine-readable spec for API

#### 2.API Hub
* every organization has its own API Hub 
    * machine-readable spec
    * human-readable doc (which is generated from machine-readable spec by tools such as Swagger UI)

#### 3.openapi-generator-cli

* generate github python sdk
```shell
docker run --rm -v /tmp/test/:/tmp/test/ openapitools/openapi-generator-cli generate \
  -i https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json \
  -g python \
  -o /tmp/test/
```

* take `GET /repos/{owner}/{repo}/environments/{environment_name}/secrets` API as an example
    * its definition in the openAPI spec
        ```json
        "/orgs/{org}/actions/runners/{runner_id}/labels": {
            "get": {
                "summary": "List labels for a self-hosted runner for an organization",
                "description": "...",
                "tags": [
                    "actions"
                ],
                "operationId": "actions/list-labels-for-self-hosted-runner-for-org",
                "parameters": [
                    {
                    "$ref": "#/components/parameters/org"
                    },
                    {
                    "$ref": "#/components/parameters/runner-id"
                    }
                ],
                "responses": {
                    "200": {
                    "$ref": "#/components/responses/actions_runner_labels"
                    },
                    "404": {
                    "$ref": "#/components/responses/not_found"
                    }
                },
                
                // ...
            },
        }
        ```
    * generated the corresponding python function
        * `actions_list_labels_for_self_hosted_runner_for_org`

    * generated docs describing how to use this function
        ```python
        import openapi_client
        from openapi_client.models.inline_object3 import InlineObject3
        from openapi_client.rest import ApiException
        from pprint import pprint

        # Defining the host is optional and defaults to https://api.github.com
        # See configuration.py for a list of all supported configuration parameters.
        configuration = openapi_client.Configuration(
            host = "https://api.github.com"
        )


        # Enter a context with an instance of the API client
        with openapi_client.ApiClient(configuration) as api_client:
            # Create an instance of the API class
            api_instance = openapi_client.ActionsApi(api_client)
            org = 'org_example' # str | The organization name. The name is not case sensitive.
            runner_id = 56 # int | Unique identifier of the self-hosted runner.

            try:
                # List labels for a self-hosted runner for an organization
                api_response = api_instance.actions_list_labels_for_self_hosted_runner_for_org(org, runner_id)
                print("The response of ActionsApi->actions_list_labels_for_self_hosted_runner_for_org:\n")
                pprint(api_response)
            except Exception as e:
                print("Exception when calling ActionsApi->actions_list_labels_for_self_hosted_runner_for_org: %s\n" % e)
        ```