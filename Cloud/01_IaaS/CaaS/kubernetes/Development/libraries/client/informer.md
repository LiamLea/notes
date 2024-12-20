# informer


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [informer](#informer)
    - [Overview](#overview)
      - [1.what is informer](#1what-is-informer)
        - [(1) informer factory](#1-informer-factory)
        - [(2) informer is an interface](#2-informer-is-an-interface)
        - [(3) informer struct (implementing `SharedIndexInformer`)](#3-informer-struct-implementing-sharedindexinformer)
        - [(4) every type has its own informer](#4-every-type-has-its-own-informer)
        - [(5) controller(Reflector)](#5-controllerreflector)
        - [(6) indexer](#6-indexer)
        - [(7) processor (EventHandler)](#7-processor-eventhandler)
      - [2.define informers](#2define-informers)
        - [(1) create empty informer factory](#1-create-empty-informer-factory)
        - [(2) add pod informer in the factory](#2-add-pod-informer-in-the-factory)
        - [(3) other type informers](#3-other-type-informers)
      - [3.run informers](#3run-informers)
        - [(1) run informer's controller(reflector)](#1-run-informers-controllerreflector)
        - [(2) run controllers](#2-run-controllers)
      - [4.every type has its own action inferface](#4every-type-has-its-own-action-inferface)

<!-- /code_chunk_output -->


### Overview

![](./imgs/informer_01.png)

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

##### (4) every type has its own informer
* you can use the function to add default informers for every type and then you can overwrite the default informer of a type
* `staging/src/k8s.io/client-go/informers/generic.go`
```go
func (f *sharedInformerFactory) ForResource(resource schema.GroupVersionResource) (GenericInformer, error) {
    switch resource {

    // Group=apps, Version=v1
    case appsv1.SchemeGroupVersion.WithResource("controllerrevisions"):
        return &genericInformer{resource: resource.GroupResource(), informer: f.Apps().V1().ControllerRevisions().Informer()}, nil
    case appsv1.SchemeGroupVersion.WithResource("daemonsets"):
        return &genericInformer{resource: resource.GroupResource(), informer: f.Apps().V1().DaemonSets().Informer()}, nil
    case appsv1.SchemeGroupVersion.WithResource("deployments"):
        return &genericInformer{resource: resource.GroupResource(), informer: f.Apps().V1().Deployments().Informer()}, nil

    //...

    }
    return nil, fmt.Errorf("no informer found for %v", resource)
}
```
##### (5) controller(Reflector)
* every informer has a **controller** to construct and run a **Reflector**
    * to pump objects/notifications from the Config's **ListerWatcher** to the Config's **Queue**

##### (6) indexer
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

##### (7) processor (EventHandler)
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

##### (2) run controllers
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

	wg.StartWithChannel(stopCh, r.Run)

	wait.Until(c.processLoop, time.Second, stopCh)
	wg.Wait()
}
```

#### 4.every type has its own action inferface
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