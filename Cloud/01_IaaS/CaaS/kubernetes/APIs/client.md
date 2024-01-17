# client


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [client](#client)
    - [使用](#使用)

<!-- /code_chunk_output -->


### 使用

[参考](https://github.com/kubernetes-client/python)
[more examples](https://github.com/kubernetes-client/python/tree/master/examples)
[All APIs](https://github.com/kubernetes-client/python/blob/master/kubernetes/README.md)
```python
import kubernetes.client
from kubernetes.client.rest import ApiException
from pprint import pprint

configuration = kubernetes.config.load_kube_config("config")

with kubernetes.client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = kubernetes.client.CustomObjectsApi(api_client)
    group = 'kubeovn.io' # str | The custom resource's group name
    version = 'v1' # str | The custom resource's version
    plural = 'vpcs'  # str | the custom object's plural name. For TPRs this would be lowercase plural kind.

    # try:
    #     api_response = api_instance.get_api_resources(group, version)
    #     pprint(api_response)
    # except ApiException as e:
    #     print("Exception when calling CustomObjectsApi->get_api_resources: %s\n" % e)

    try:
        api_response = api_instance.list_cluster_custom_object(group, version,plural)
        pprint(api_response)
    except ApiException as e:
        print("Exception when calling CustomObjectsApi->get_cluster_custom_object: %s\n" % e)

```