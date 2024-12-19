# client


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [client](#client)
    - [client](#client-1)
      - [1.what](#1what)
        - [(1) restclient (foundamental client)](#1-restclient-foundamental-client)
        - [(2) Clientset (including DiscoveryClient)](#2-clientset-including-discoveryclient)
        - [(3) dynamic client](#3-dynamic-client)
      - [2.create a clientset](#2create-a-clientset)
        - [(4) difference between clientset vs dynamic client](#4-difference-between-clientset-vs-dynamic-client)
    - [other basics](#other-basics)
      - [1.every type has its own inferface](#1every-type-has-its-own-inferface)
      - [2.list and watch](#2list-and-watch)
        - [(1) List](#1-list)
        - [(2) Watch](#2-watch)
        - [(3) listWatch](#3-listwatch)
    - [informer](#informer)
      - [1.what is informer](#1what-is-informer)
        - [(1) informer factory](#1-informer-factory)
        - [(2) informer is an interface](#2-informer-is-an-interface)
        - [(3) informer struct (implementing `SharedIndexInformer`)](#3-informer-struct-implementing-sharedindexinformer)
        - [(4) controller(Reflector)](#4-controllerreflector)
        - [(5) indexer](#5-indexer)
        - [(6) processor (EventHandler)](#6-processor-eventhandler)
      - [2.define informers](#2define-informers)
        - [(1) create empty informer factory](#1-create-empty-informer-factory)
        - [(2) add pod informer in the factory](#2-add-pod-informer-in-the-factory)
        - [(3) other type informers](#3-other-type-informers)
      - [3.run informers](#3run-informers)
        - [(1) run informer's controller(reflector)](#1-run-informers-controllerreflector)

<!-- /code_chunk_output -->


### client

#### 1.what

##### (1) restclient (foundamental client)
* `staging/src/k8s.io/client-go/rest/client.go`
```go
type Interface interface {
    GetRateLimiter() flowcontrol.RateLimiter
    Verb(verb string) *Request
    Post() *Request
    Put() *Request
    Patch(pt types.PatchType) *Request
    Get() *Request
    Delete() *Request
    APIVersion() schema.GroupVersion
}
```

##### (2) Clientset (including DiscoveryClient)
* DiscoveryClient
```go
type DiscoveryClient struct {
    restClient restclient.Interface

    LegacyPrefix string
    // Forces the client to request only "unaggregated" (legacy) discovery.
    UseLegacyDiscovery bool
}
```
* Clientset

```go
// Clientset contains the clients for groups.
type Clientset struct {
    *discovery.DiscoveryClient
    admissionregistrationV1       *admissionregistrationv1.AdmissionregistrationV1Client
    admissionregistrationV1alpha1 *admissionregistrationv1alpha1.AdmissionregistrationV1alpha1Client
    admissionregistrationV1beta1  *admissionregistrationv1beta1.AdmissionregistrationV1beta1Client
    internalV1alpha1              *internalv1alpha1.InternalV1alpha1Client
    appsV1                        *appsv1.AppsV1Client
    appsV1beta1                   *appsv1beta1.AppsV1beta1Client
    appsV1beta2                   *appsv1beta2.AppsV1beta2Client
    authenticationV1              *authenticationv1.AuthenticationV1Client
    authenticationV1alpha1        *authenticationv1alpha1.AuthenticationV1alpha1Client
    authenticationV1beta1         *authenticationv1beta1.AuthenticationV1beta1Client
    authorizationV1               *authorizationv1.AuthorizationV1Client
    authorizationV1beta1          *authorizationv1beta1.AuthorizationV1beta1Client
    autoscalingV1                 *autoscalingv1.AutoscalingV1Client
    autoscalingV2                 *autoscalingv2.AutoscalingV2Client
    autoscalingV2beta1            *autoscalingv2beta1.AutoscalingV2beta1Client
    autoscalingV2beta2            *autoscalingv2beta2.AutoscalingV2beta2Client
    batchV1                       *batchv1.BatchV1Client
    batchV1beta1                  *batchv1beta1.BatchV1beta1Client
    certificatesV1                *certificatesv1.CertificatesV1Client
    certificatesV1beta1           *certificatesv1beta1.CertificatesV1beta1Client
    certificatesV1alpha1          *certificatesv1alpha1.CertificatesV1alpha1Client
    coordinationV1alpha1          *coordinationv1alpha1.CoordinationV1alpha1Client
    coordinationV1beta1           *coordinationv1beta1.CoordinationV1beta1Client
    coordinationV1                *coordinationv1.CoordinationV1Client
    coreV1                        *corev1.CoreV1Client
    discoveryV1                   *discoveryv1.DiscoveryV1Client
    discoveryV1beta1              *discoveryv1beta1.DiscoveryV1beta1Client
    eventsV1                      *eventsv1.EventsV1Client
    eventsV1beta1                 *eventsv1beta1.EventsV1beta1Client
    extensionsV1beta1             *extensionsv1beta1.ExtensionsV1beta1Client
    flowcontrolV1                 *flowcontrolv1.FlowcontrolV1Client
    flowcontrolV1beta1            *flowcontrolv1beta1.FlowcontrolV1beta1Client
    flowcontrolV1beta2            *flowcontrolv1beta2.FlowcontrolV1beta2Client
    flowcontrolV1beta3            *flowcontrolv1beta3.FlowcontrolV1beta3Client
    networkingV1                  *networkingv1.NetworkingV1Client
    networkingV1alpha1            *networkingv1alpha1.NetworkingV1alpha1Client
    networkingV1beta1             *networkingv1beta1.NetworkingV1beta1Client
    nodeV1                        *nodev1.NodeV1Client
    nodeV1alpha1                  *nodev1alpha1.NodeV1alpha1Client
    nodeV1beta1                   *nodev1beta1.NodeV1beta1Client
    policyV1                      *policyv1.PolicyV1Client
    policyV1beta1                 *policyv1beta1.PolicyV1beta1Client
    rbacV1                        *rbacv1.RbacV1Client
    rbacV1beta1                   *rbacv1beta1.RbacV1beta1Client
    rbacV1alpha1                  *rbacv1alpha1.RbacV1alpha1Client
    resourceV1alpha3              *resourcev1alpha3.ResourceV1alpha3Client
    schedulingV1alpha1            *schedulingv1alpha1.SchedulingV1alpha1Client
    schedulingV1beta1             *schedulingv1beta1.SchedulingV1beta1Client
    schedulingV1                  *schedulingv1.SchedulingV1Client
    storageV1beta1                *storagev1beta1.StorageV1beta1Client
    storageV1                     *storagev1.StorageV1Client
    storageV1alpha1               *storagev1alpha1.StorageV1alpha1Client
    storagemigrationV1alpha1      *storagemigrationv1alpha1.StoragemigrationV1alpha1Client
}
```

##### (3) dynamic client

You specify resources by their GroupVersionResource (GVR) instead of using typed interfaces

* `staging/src/k8s.io/client-go/dynamic/interface.go`
```go
type Interface interface {
    Resource(resource schema.GroupVersionResource) NamespaceableResourceInterface
}

type ResourceInterface interface {
    Create(ctx context.Context, obj *unstructured.Unstructured, options metav1.CreateOptions, subresources ...string) (*unstructured.Unstructured, error)
    Update(ctx context.Context, obj *unstructured.Unstructured, options metav1.UpdateOptions, subresources ...string) (*unstructured.Unstructured, error)
    UpdateStatus(ctx context.Context, obj *unstructured.Unstructured, options metav1.UpdateOptions) (*unstructured.Unstructured, error)
    Delete(ctx context.Context, name string, options metav1.DeleteOptions, subresources ...string) error
    DeleteCollection(ctx context.Context, options metav1.DeleteOptions, listOptions metav1.ListOptions) error
    Get(ctx context.Context, name string, options metav1.GetOptions, subresources ...string) (*unstructured.Unstructured, error)
    List(ctx context.Context, opts metav1.ListOptions) (*unstructured.UnstructuredList, error)
    Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
    Patch(ctx context.Context, name string, pt types.PatchType, data []byte, options metav1.PatchOptions, subresources ...string) (*unstructured.Unstructured, error)
    Apply(ctx context.Context, name string, obj *unstructured.Unstructured, options metav1.ApplyOptions, subresources ...string) (*unstructured.Unstructured, error)
    ApplyStatus(ctx context.Context, name string, obj *unstructured.Unstructured, options metav1.ApplyOptions) (*unstructured.Unstructured, error)
}

type NamespaceableResourceInterface interface {
    Namespace(string) ResourceInterface
    ResourceInterface
}
```

#### 2.create a clientset
```go
import (
    clientset "k8s.io/client-go/kubernetes"
)

// createClients creates a kube client and an event client from the given kubeConfig
func createClients(kubeConfig *restclient.Config) (clientset.Interface, clientset.Interface, error) {
    client, err := clientset.NewForConfig(restclient.AddUserAgent(kubeConfig, "xx"))
    if err != nil {
        return nil, nil, err
    }

    eventClient, err := clientset.NewForConfig(kubeConfig)
    if err != nil {
        return nil, nil, err
    }

    return client, eventClient, nil
}
```

```go
func NewForConfig(c *rest.Config) (*Clientset, error) {
    configShallowCopy := *c

    if configShallowCopy.UserAgent == "" {
        configShallowCopy.UserAgent = rest.DefaultKubernetesUserAgent()
    }

    // share the transport between all clients
    httpClient, err := rest.HTTPClientFor(&configShallowCopy)
    if err != nil {
        return nil, err
    }

    return NewForConfigAndClient(&configShallowCopy, httpClient)
}
```

##### (4) difference between clientset vs dynamic client
* Clientsets provide a strongly-typed way to interact with **standard** Kubernetes resources, which **can't discover CRD**
```go
import (
    corev1 "k8s.io/api/core/v1"
)

pod := &corev1.Pod{
    ObjectMeta: metav1.ObjectMeta{
        Name: "my-pod",
    },
    Spec: corev1.PodSpec{
        Containers: []corev1.Container{
            {
                Name:  "my-container",
                Image: "nginx:latest",
            },
        },
    },
}

createdPod, err := clientset.CoreV1().Pods("default").Create(context.Background(), pod, metav1.CreateOptions{})
```
* dynamic client provides flexibility to work with arbitrary or unknown resources
```go
gvr := schema.GroupVersionResource{Group: "", Version: "v1", Resource: "pods"}
// List all Pods in the "default" namespace:
podList, err := dynamicClient.Resource(gvr).Namespace("default").List(context.Background(), v1.ListOptions{})
```

***

### other basics

#### 1.every type has its own inferface
* e.g. ReplicaSet: `staging/src/k8s.io/client-go/kubernetes/typed/apps/v1/replicaset.go`

```go
type ReplicaSetInterface interface {
	Create(ctx context.Context, replicaSet *v1.ReplicaSet, opts metav1.CreateOptions) (*v1.ReplicaSet, error)
	Update(ctx context.Context, replicaSet *v1.ReplicaSet, opts metav1.UpdateOptions) (*v1.ReplicaSet, error)
	// Add a +genclient:noStatus comment above the type to avoid generating UpdateStatus().
	UpdateStatus(ctx context.Context, replicaSet *v1.ReplicaSet, opts metav1.UpdateOptions) (*v1.ReplicaSet, error)
	Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error
	DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error
	Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.ReplicaSet, error)
	List(ctx context.Context, opts metav1.ListOptions) (*v1.ReplicaSetList, error)
	Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
	Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.ReplicaSet, err error)
	Apply(ctx context.Context, replicaSet *appsv1.ReplicaSetApplyConfiguration, opts metav1.ApplyOptions) (result *v1.ReplicaSet, err error)
	// Add a +genclient:noStatus comment above the type to avoid generating ApplyStatus().
	ApplyStatus(ctx context.Context, replicaSet *appsv1.ReplicaSetApplyConfiguration, opts metav1.ApplyOptions) (result *v1.ReplicaSet, err error)
	GetScale(ctx context.Context, replicaSetName string, options metav1.GetOptions) (*autoscalingv1.Scale, error)
	UpdateScale(ctx context.Context, replicaSetName string, scale *autoscalingv1.Scale, opts metav1.UpdateOptions) (*autoscalingv1.Scale, error)
	ApplyScale(ctx context.Context, replicaSetName string, scale *applyconfigurationsautoscalingv1.ScaleApplyConfiguration, opts metav1.ApplyOptions) (*autoscalingv1.Scale, error)

	ReplicaSetExpansion
}
```

#### 2.list and watch

* every type has its corresponding listWatch
    * e.g. `*v1.Pod` (`staging/src/k8s.io/client-go/kubernetes/typed/core/v1/pod.go`)
    ```go
    type PodInterface interface {
        Create(ctx context.Context, pod *v1.Pod, opts metav1.CreateOptions) (*v1.Pod, error)
        Update(ctx context.Context, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)
        // Add a +genclient:noStatus comment above the type to avoid generating UpdateStatus().
        UpdateStatus(ctx context.Context, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)
        Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error
        DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error
        Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.Pod, error)
        List(ctx context.Context, opts metav1.ListOptions) (*v1.PodList, error)
        Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
        Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.Pod, err error)
        Apply(ctx context.Context, pod *corev1.PodApplyConfiguration, opts metav1.ApplyOptions) (result *v1.Pod, err error)
        // Add a +genclient:noStatus comment above the type to avoid generating ApplyStatus().
        ApplyStatus(ctx context.Context, pod *corev1.PodApplyConfiguration, opts metav1.ApplyOptions) (result *v1.Pod, err error)
        UpdateEphemeralContainers(ctx context.Context, podName string, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)

        PodExpansion
    }
    ```

##### (1) List
* `staging/src/k8s.io/client-go/gentype/type.go`
```go
func (l *alsoLister[T, L]) List(ctx context.Context, opts metav1.ListOptions) (L, error) {
	if watchListOptions, hasWatchListOptionsPrepared, watchListOptionsErr := watchlist.PrepareWatchListOptionsFromListOptions(opts); watchListOptionsErr != nil {
		klog.Warningf("Failed preparing watchlist options for $.type|resource$, falling back to the standard LIST semantics, err = %v", watchListOptionsErr)
	} else if hasWatchListOptionsPrepared {
		result, err := l.watchList(ctx, watchListOptions)
		if err == nil {
			consistencydetector.CheckWatchListFromCacheDataConsistencyIfRequested(ctx, "watchlist request for "+l.client.resource, l.list, opts, result)
			return result, nil
		}
		klog.Warningf("The watchlist request for %s ended with an error, falling back to the standard LIST semantics, err = %v", l.client.resource, err)
	}
	result, err := l.list(ctx, opts)
	if err == nil {
		consistencydetector.CheckListFromCacheDataConsistencyIfRequested(ctx, "list request for "+l.client.resource, l.list, opts, result)
	}
	return result, err
}
```
```go
func (l *alsoLister[T, L]) list(ctx context.Context, opts metav1.ListOptions) (L, error) {
	list := l.newList()
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	err := l.client.client.Get().
		NamespaceIfScoped(l.client.namespace, l.client.namespace != "").
		Resource(l.client.resource).
		VersionedParams(&opts, l.client.parameterCodec).
		Timeout(timeout).
		Do(ctx).
		Into(list)
	return list, err
}
```

* output a list (e.g. pod)
```go
{
    "list": {
        "items": [
            <v1.Pod>,
            <v1.Pod>,
        ]
    }
}
```

##### (2) Watch
* `staging/src/k8s.io/client-go/gentype/type.go`
```go
func (c *Client[T]) Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	opts.Watch = true
	return c.client.Get().
		NamespaceIfScoped(c.namespace, c.namespace != "").
		Resource(c.resource).
		VersionedParams(&opts, c.parameterCodec).
		Timeout(timeout).
		Watch(ctx)
}
```

* establish a long connection to watch a specific resource and then send event to result channel
    ```go
    // receive reads result from the decoder in a loop and sends down the result channel.
    func (sw *StreamWatcher) receive() {
        defer utilruntime.HandleCrash()
        defer close(sw.result)
        defer sw.Stop()
        for {
            action, obj, err := sw.source.Decode()
            if err != nil {
                switch err {
                case io.EOF:
                    // watch closed normally
                case io.ErrUnexpectedEOF:
                    klog.V(1).Infof("Unexpected EOF during watch stream event decoding: %v", err)
                default:
                    if net.IsProbableEOF(err) || net.IsTimeout(err) {
                        klog.V(5).Infof("Unable to decode an event from the watch stream: %v", err)
                    } else {
                        select {
                        case <-sw.done:
                        case sw.result <- Event{
                            Type:   Error,
                            Object: sw.reporter.AsObject(fmt.Errorf("unable to decode an event from the watch stream: %v", err)),
                        }:
                        }
                    }
                }
                return
            }
            select {
            case <-sw.done:
                return
            case sw.result <- Event{
                Type:   action,
                Object: obj,
            }:
            }
        }
    }
    ```
    * e.g. pod
    ![](./imgs/watch_01.png)
        * `sw.source.decoder.reader.r.cs.res.Request.URL.RawQuery`: `allowWatchBookmarks=true&fieldSelector=status.phase%21%3DSucceeded%2Cstatus.phase%21%3DFailed&resourceVersion=333899&timeout=6m51s&timeoutSeconds=411&watch=true`

* action:
    * ADDED
    * MODIFIED
    * DELETED
    * BOOKMARK
        * Bookmarks are intended to let the client know that the server has sent the client all events up to the resourceVersion specified in the Bookmark event. This is to make sure that if the watch on the client side fails or the channel closes (after timeout), the client can resume the watch from resourceVersion last returned in the Bookmark event. It's more like a **checkpoint** event in the absence of real mutating events like Added, Modified, Deleted
    * ERROR

##### (3) listWatch
* `staging/src/k8s.io/client-go/gentype/type.go`
```go
// watchList establishes a watch stream with the server and returns the list of resources.
func (l *alsoLister[T, L]) watchList(ctx context.Context, opts metav1.ListOptions) (result L, err error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	result = l.newList()
	err = l.client.client.Get().
		NamespaceIfScoped(l.client.namespace, l.client.namespace != "").
		Resource(l.client.resource).
		VersionedParams(&opts, l.client.parameterCodec).
		Timeout(timeout).
		WatchList(ctx).
		Into(result)
	return
}
```

***

### informer

#### 1.what is informer 

##### (1) informer factory

* store multiple informers
    * every type has an informer: `"<informer_type>": <informer>`
        * `<informer>` has `objectType` field which corresponds with `<informer_type>`
    * e.g.
    ```go
    imformers: {
        "v1.StorageClass": <informer1>,
    }
    ```
```go
type sharedInformerFactory struct {
    // client used to fetch
    client           kubernetes.Interface

    // specify fetch which namespaces
    namespace        string

    tweakListOptions internalinterfaces.TweakListOptionsFunc
    lock             sync.Mutex
    defaultResync    time.Duration
    customResync     map[reflect.Type]time.Duration
    transform        cache.TransformFunc

    informers map[reflect.Type]cache.SharedIndexInformer

    // record which type informer has been started
    startedInformers map[reflect.Type]bool

    // wg tracks how many goroutines were started.
    wg sync.WaitGroup
    // shuttingDown is true when Shutdown has been called. It may still be running
    // because it needs to wait for goroutines.
    shuttingDown bool
}
```

##### (2) informer is an interface
```go
type SharedIndexInformer interface {
    SharedInformer
    // AddIndexers add indexers to the informer before it starts.
    AddIndexers(indexers Indexers) error
    GetIndexer() Indexer
}
```

##### (3) informer struct (implementing `SharedIndexInformer`)

```go
type sharedIndexInformer struct {
    indexer    Indexer
    controller Controller

    processor             *sharedProcessor
    cacheMutationDetector MutationDetector

    listerWatcher ListerWatcher

    // determine which informer type this informer is
    objectType runtime.Object

    // objectDescription is the description of this informer's objects. This typically defaults to
    objectDescription string

    // resyncCheckPeriod is how often we want the reflector's resync timer to fire so it can call
    // shouldResync to check if any of our listeners need a resync.
    resyncCheckPeriod time.Duration
    // defaultEventHandlerResyncPeriod is the default resync period for any handlers added via
    // AddEventHandler (i.e. they don't specify one and just want to use the shared informer's default
    // value).
    defaultEventHandlerResyncPeriod time.Duration
    // clock allows for testability
    clock clock.Clock

    started, stopped bool
    startedLock      sync.Mutex

    // blockDeltas gives a way to stop all event distribution so that a late event handler
    // can safely join the shared informer.
    blockDeltas sync.Mutex

    // Called whenever the ListAndWatch drops the connection with an error.
    watchErrorHandler WatchErrorHandler

    transform TransformFunc
}
```

##### (4) controller(Reflector)
* every informer has a **controller** to construct and run a **Reflector**
    * to pump objects/notifications from the Config's **ListerWatcher** to the Config's **Queue**

##### (5) indexer
* every informer has a corresponding **indexer**
    * **cache** implements indexer interfaces which **store and retrieve** objects from the informer
        * `informer.GetIndexer().ListKeys()`
        * objects stored in a map, looks like (e.g. namespace informer)
        ```go
        {
            "default": <*v1.Namespace>,
            "kube-system": <*v1.Namespace>,
            "kube-public": <*v1.Namespace>
        }
        ```

##### (6) processor (EventHandler)
* sharedProcessor has a collection of processorListener and can distribute a notification object to its listeners

#### 2.define informers

##### (1) create empty informer factory
```go
factory := &sharedInformerFactory{
    client:           client,
    namespace:        v1.NamespaceAll,
    defaultResync:    defaultResync,

    // store the corresponding informer of an go type(e.g. *v1.pod)
    informers:        make(map[reflect.Type]cache.SharedIndexInformer),

    startedInformers: make(map[reflect.Type]bool),
    customResync:     make(map[reflect.Type]time.Duration),
}
```

##### (2) add pod informer in the factory

```go
// return a struct which implements all SharedIndexInformer interfaces
func newPodInformer(cs clientset.Interface, resyncPeriod time.Duration) cache.SharedIndexInformer {

    // status.phase!=Succeeded,status.phase!=Failed
    selector := fmt.Sprintf("status.phase!=%v,status.phase!=%v", v1.PodSucceeded, v1.PodFailed)
    tweakListOptions := func(options *metav1.ListOptions) {
        options.FieldSelector = selector
    }
    informer := coreinformers.NewFilteredPodInformer(cs, metav1.NamespaceAll, resyncPeriod, cache.Indexers{}, tweakListOptions)

    // Dropping `.metadata.managedFields` to improve memory usage.
    // The Extract workflow (i.e. `ExtractPod`) should be unused.
    trim := func(obj interface{}) (interface{}, error) {
        if accessor, err := meta.Accessor(obj); err == nil {
            if accessor.GetManagedFields() != nil {
                accessor.SetManagedFields(nil)
            }
        }
        return obj, nil
    }
    informer.SetTransform(trim)
    return informer
}

factory.InformerFor(&v1.Pod{}, newPodInformer)
```

```go
func (f *sharedInformerFactory) InformerFor(obj runtime.Object, newFunc internalinterfaces.NewInformerFunc) cache.SharedIndexInformer {
    f.lock.Lock()
    defer f.lock.Unlock()

    informerType := reflect.TypeOf(obj)

    // if the type has an informer then return
    informer, exists := f.informers[informerType]
    if exists {
        return informer
    }

    resyncPeriod, exists := f.customResync[informerType]
    if !exists {
        resyncPeriod = f.defaultResync
    }

    // create an informer for the go type if not exist
    informer = newFunc(f.client, resyncPeriod)

    informer.SetTransform(f.transform)
    f.informers[informerType] = informer

    return informer
}
```

##### (3) other type informers

* `staging/src/k8s.io/client-go/informers/core/v1/`
    * e.g. create an informer for pod type:
        * `staging/src/k8s.io/client-go/informers/core/v1/pod.go`
        * return a struct which implements all SharedIndexInformer interfaces
        ```go
        // NewFilteredPodInformer constructs a new informer for Pod type.
        // Always prefer using an informer factory to get a shared informer instead of getting an independent
        // one. This reduces memory footprint and number of connections to the server.
        func NewFilteredPodInformer(client kubernetes.Interface, namespace string, resyncPeriod time.Duration, indexers cache.Indexers, tweakListOptions internalinterfaces.TweakListOptionsFunc) cache.SharedIndexInformer {
            return cache.NewSharedIndexInformer(
                &cache.ListWatch{
                    ListFunc: func(options metav1.ListOptions) (runtime.Object, error) {
                        if tweakListOptions != nil {
                            tweakListOptions(&options)
                        }
                        return client.CoreV1().Pods(namespace).List(context.TODO(), options)
                    },
                    WatchFunc: func(options metav1.ListOptions) (watch.Interface, error) {
                        if tweakListOptions != nil {
                            tweakListOptions(&options)
                        }
                        return client.CoreV1().Pods(namespace).Watch(context.TODO(), options)
                    },
                },
                &corev1.Pod{},
                resyncPeriod,
                indexers,
            )
        }
        ```

#### 3.run informers

```go
func (f *sharedInformerFactory) Start(stopCh <-chan struct{}) {
	f.lock.Lock()
	defer f.lock.Unlock()

	if f.shuttingDown {
		return
	}

	for informerType, informer := range f.informers {
		if !f.startedInformers[informerType] {
			f.wg.Add(1)
			// We need a new variable in each loop iteration,
			// otherwise the goroutine would use the loop variable
			// and that keeps changing.
			informer := informer
			go func() {
				defer f.wg.Done()
				informer.Run(stopCh)
			}()
			f.startedInformers[informerType] = true
		}
	}
}
```

##### (1) run informer's controller(reflector)
```go
func (c *controller) Run(stopCh <-chan struct{}) {
    defer utilruntime.HandleCrash()
    go func() {
        <-stopCh
        c.config.Queue.Close()
    }()
    r := NewReflectorWithOptions(
        c.config.ListerWatcher,
        c.config.ObjectType,
        c.config.Queue,
        ReflectorOptions{
            ResyncPeriod:    c.config.FullResyncPeriod,
            MinWatchTimeout: c.config.MinWatchTimeout,
            TypeDescription: c.config.ObjectDescription,
            Clock:           c.clock,
        },
    )
    r.ShouldResync = c.config.ShouldResync
    r.WatchListPageSize = c.config.WatchListPageSize
    if c.config.WatchErrorHandler != nil {
        r.watchErrorHandler = c.config.WatchErrorHandler
    }

    c.reflectorMutex.Lock()
    c.reflector = r
    c.reflectorMutex.Unlock()

    var wg wait.Group

    // Add object to delta FIFO queue
    wg.StartWithChannel(stopCh, r.Run)

    // pop object from delta FIFO queue to its informer's indexer store
    wait.Until(c.processLoop, time.Second, stopCh)
    wg.Wait()
}
```

* Add object to delta FIFO queue

```go
func (r *Reflector) Run(stopCh <-chan struct{}) {
    klog.V(3).Infof("Starting reflector %s (%s) from %s", r.typeDescription, r.resyncPeriod, r.name)
    wait.BackoffUntil(func() {
        if err := r.ListAndWatch(stopCh); err != nil {
            r.watchErrorHandler(r, err)
        }
    }, r.backoffManager, true, stopCh)
    klog.V(3).Infof("Stopping reflector %s (%s) from %s", r.typeDescription, r.resyncPeriod, r.name)
}
```

* add object to its informer's indexer store
```go
func processDeltas(
	// Object which receives event notifications from the given deltas
	handler ResourceEventHandler,
	clientState Store,
	deltas Deltas,
	isInInitialList bool,
) error {
	// from oldest to newest
	for _, d := range deltas {
		obj := d.Object

		switch d.Type {
		case Sync, Replaced, Added, Updated:
			if old, exists, err := clientState.Get(obj); err == nil && exists {
				if err := clientState.Update(obj); err != nil {
					return err
				}
				handler.OnUpdate(old, obj)
			} else {
				if err := clientState.Add(obj); err != nil {
					return err
				}
				handler.OnAdd(obj, isInInitialList)
			}
		case Deleted:
			if err := clientState.Delete(obj); err != nil {
				return err
			}
			handler.OnDelete(obj)
		}
	}
	return nil
}
```