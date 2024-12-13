# client


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [client](#client)
    - [client](#client-1)
    - [informer](#informer)
      - [1.what is informer](#1what-is-informer)
        - [(1) informer factory](#1-informer-factory)
        - [(2) informer is an interface](#2-informer-is-an-interface)
      - [2.define informers](#2define-informers)
        - [(1) create empty informer factory](#1-create-empty-informer-factory)
        - [(2) add pod informer in the factory](#2-add-pod-informer-in-the-factory)

<!-- /code_chunk_output -->


### client

***

### informer

#### 1.what is informer 

##### (1) informer factory

* store multiple informers

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
    // startedInformers is used for tracking which informers have been started.
    // This allows Start() to be called multiple times safely.
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
```go
type SharedInformer interface {
	// AddEventHandler adds an event handler to the shared informer using
	// the shared informer's resync period.  Events to a single handler are
	// delivered sequentially, but there is no coordination between
	// different handlers.
	// It returns a registration handle for the handler that can be used to
	// remove the handler again, or to tell if the handler is synced (has
	// seen every item in the initial list).
	AddEventHandler(handler ResourceEventHandler) (ResourceEventHandlerRegistration, error)
	// AddEventHandlerWithResyncPeriod adds an event handler to the
	// shared informer with the requested resync period; zero means
	// this handler does not care about resyncs.  The resync operation
	// consists of delivering to the handler an update notification
	// for every object in the informer's local cache; it does not add
	// any interactions with the authoritative storage.  Some
	// informers do no resyncs at all, not even for handlers added
	// with a non-zero resyncPeriod.  For an informer that does
	// resyncs, and for each handler that requests resyncs, that
	// informer develops a nominal resync period that is no shorter
	// than the requested period but may be longer.  The actual time
	// between any two resyncs may be longer than the nominal period
	// because the implementation takes time to do work and there may
	// be competing load and scheduling noise.
	// It returns a registration handle for the handler that can be used to remove
	// the handler again and an error if the handler cannot be added.
	AddEventHandlerWithResyncPeriod(handler ResourceEventHandler, resyncPeriod time.Duration) (ResourceEventHandlerRegistration, error)
	// RemoveEventHandler removes a formerly added event handler given by
	// its registration handle.
	// This function is guaranteed to be idempotent, and thread-safe.
	RemoveEventHandler(handle ResourceEventHandlerRegistration) error
	// GetStore returns the informer's local cache as a Store.
	GetStore() Store
	// GetController is deprecated, it does nothing useful
	GetController() Controller
	// Run starts and runs the shared informer, returning after it stops.
	// The informer will be stopped when stopCh is closed.
	Run(stopCh <-chan struct{})
	// HasSynced returns true if the shared informer's store has been
	// informed by at least one full LIST of the authoritative state
	// of the informer's object collection.  This is unrelated to "resync".
	//
	// Note that this doesn't tell you if an individual handler is synced!!
	// For that, please call HasSynced on the handle returned by
	// AddEventHandler.
	HasSynced() bool
	// LastSyncResourceVersion is the resource version observed when last synced with the underlying
	// store. The value returned is not synchronized with access to the underlying store and is not
	// thread-safe.
	LastSyncResourceVersion() string

	// The WatchErrorHandler is called whenever ListAndWatch drops the
	// connection with an error. After calling this handler, the informer
	// will backoff and retry.
	//
	// The default implementation looks at the error type and tries to log
	// the error message at an appropriate level.
	//
	// There's only one handler, so if you call this multiple times, last one
	// wins; calling after the informer has been started returns an error.
	//
	// The handler is intended for visibility, not to e.g. pause the consumers.
	// The handler should return quickly - any expensive processing should be
	// offloaded.
	SetWatchErrorHandler(handler WatchErrorHandler) error

	// The TransformFunc is called for each object which is about to be stored.
	//
	// This function is intended for you to take the opportunity to
	// remove, transform, or normalize fields. One use case is to strip unused
	// metadata fields out of objects to save on RAM cost.
	//
	// Must be set before starting the informer.
	//
	// Please see the comment on TransformFunc for more details.
	SetTransform(handler TransformFunc) error

	// IsStopped reports whether the informer has already been stopped.
	// Adding event handlers to already stopped informers is not possible.
	// An informer already stopped will never be started again.
	IsStopped() bool
}
```

#### 2.define informers

##### (1) create empty informer factory
```go
factory := &sharedInformerFactory{
    client:           client,
    namespace:        v1.NamespaceAll,
    defaultResync:    defaultResync,
    informers:        make(map[reflect.Type]cache.SharedIndexInformer),
    startedInformers: make(map[reflect.Type]bool),
    customResync:     make(map[reflect.Type]time.Duration),
}
```

##### (2) add pod informer in the factory

```go
// newPodInformer creates a shared index informer that returns only non-terminal pods.
// The PodInformer allows indexers to be added, but note that only non-conflict indexers are allowed.
func newPodInformer(cs clientset.Interface, resyncPeriod time.Duration) cache.SharedIndexInformer {
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
	informer, exists := f.informers[informerType]
	if exists {
		return informer
	}

	resyncPeriod, exists := f.customResync[informerType]
	if !exists {
		resyncPeriod = f.defaultResync
	}

	informer = newFunc(f.client, resyncPeriod)
	informer.SetTransform(f.transform)
	f.informers[informerType] = informer

	return informer
}
```