# Overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Overview](#overview)
    - [Overview](#overview-1)
      - [1.apimachinery](#1apimachinery)
      - [2.`k8s.io/api`](#2k8sioapi)

<!-- /code_chunk_output -->


### Overview

#### 1.apimachinery

[xRef](https://github.com/kubernetes/apimachinery)

* apimachinery is an library used to **build apis**
    * Its first consumers are `k8s.io/apiserver`, `k8s.io/kubernetes` and `k8s.io/client-go`
* apimachinery is for the machinery, not for the types
    * types: The actual data structures that represent Kubernetes objects such as Pod, Node, etc.
    * machinery: The tools and abstractions used to process those types, such as runtime, versioning, etc.

* apimachinery is not expected to be compatible while api is expected to be compatible
    * so users should use api instead of using apimachinery

#### 2.`k8s.io/api`
* Defines the API Types

```go
type Pod struct {
	metav1.TypeMeta `json:",inline"`
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`

	// Specification of the desired behavior of the pod.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	Spec PodSpec `json:"spec,omitempty" protobuf:"bytes,2,opt,name=spec"`

	// Most recently observed status of the pod.
	// This data may not be up to date.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	Status PodStatus `json:"status,omitempty" protobuf:"bytes,3,opt,name=status"`
}
```