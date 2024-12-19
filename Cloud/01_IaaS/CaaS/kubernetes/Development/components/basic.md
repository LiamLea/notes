# basic


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [basic](#basic)
    - [runtime](#runtime)
    - [scheme](#scheme)
      - [1.what is scheme](#1what-is-scheme)
        - [(1) scheme structure](#1-scheme-structure)
        - [(2) gvkToType looks like](#2-gvktotype-looks-like)
        - [(3) converter](#3-converter)
        - [(4) fieldLabelConversionFuncs](#4-fieldlabelconversionfuncs)
        - [(5) defaulterFuncs](#5-defaulterfuncs)
      - [2.define scheme](#2define-scheme)
        - [(1) prepration (e.g. scheduler)](#1-prepration-eg-scheduler)
        - [(2) define shceme (e.g. scheduler)](#2-define-shceme-eg-scheduler)
    - [FeatureGates](#featuregates)
      - [1.define FeatureGates](#1define-featuregates)
        - [(1) new FeatureGates in apiserver](#1-new-featuregates-in-apiserver)
        - [(2) register features to FeatureGates](#2-register-features-to-featuregates)
    - [Event](#event)
      - [1.EventBroadcaster (receive events from the component itself)](#1eventbroadcaster-receive-events-from-the-component-itself)
        - [(1) what](#1-what)
        - [(2) create a new event Broadcaster](#2-create-a-new-event-broadcaster)
      - [2.watchers](#2watchers)
      - [3.recordToSink (write events to apiserver)](#3recordtosink-write-events-to-apiserver)

<!-- /code_chunk_output -->


### runtime

***

### scheme

* every package has its own **scheme** and **shcemeBuilder** which is used to build its own scheme
* define when **import**

#### 1.what is scheme

* **conversion** between **GVK** and **go type**

##### (1) scheme structure
* includes multiple maps which are used to do some mapping (e.g. GVK to go type)
* include a **converter** which stores all registered conversion functions
```go
type Scheme struct {
    // gvkToType allows one to figure out the go type of an object with
    // the given version and name.
    gvkToType map[schema.GroupVersionKind]reflect.Type

    // typeToGVK allows one to find metadata for a given go object.
    // The reflect.Type we index by should *not* be a pointer.
    typeToGVK map[reflect.Type][]schema.GroupVersionKind

    // unversionedTypes are transformed without conversion in ConvertToVersion.
    unversionedTypes map[reflect.Type]schema.GroupVersionKind

    // unversionedKinds are the names of kinds that can be created in the context of any group
    // or version
    // TODO: resolve the status of unversioned types.
    unversionedKinds map[string]reflect.Type

    // Map from version and resource to the corresponding func to convert
    // resource field labels in that version to internal version.
    fieldLabelConversionFuncs map[schema.GroupVersionKind]FieldLabelConversionFunc

    // defaulterFuncs is a map to funcs to be called with an object to provide defaulting
    // the provided object must be a pointer.
    defaulterFuncs map[reflect.Type]func(interface{})

    // converter stores all registered conversion functions. It also has
    // default converting behavior.
    converter *conversion.Converter

    // versionPriority is a map of groups to ordered lists of versions for those groups indicating the
    // default priorities of these versions as registered in the scheme
    versionPriority map[string][]string

    // observedVersions keeps track of the order we've seen versions during type registration
    observedVersions []schema.GroupVersion

    // schemeName is the name of this scheme.  If you don't specify a name, the stack of the NewScheme caller will be used.
    // This is useful for error reporting to indicate the origin of the scheme.
    schemeName string
}
```

##### (2) gvkToType looks like
```go
[
    {Group: "kubescheduler.config.k8s.io", Version: "v1", Kind: "KubeSchedulerConfiguration"}: reflect.TypeOf(&KubeSchedulerConfiguration{}),  //type: v1.KubeSchedulerConfiguration
    ...
]
```

##### (3) converter

* convert between different go types

* why
    * used to convert between different versions (e.g.`*v1.PodSpec` and `*v2.PodSpec`)
        * in v1 and v2, some types don't change
        * if types change, it won't find conversion and only to use new type. 

* two types:
    * conversionFuncs
        * conversions user defined (e.g.`*v1.PodSpec` and `*v2.PodSpec`)
    * generatedConversionFuncs
        * these are generated when register types to scheme 
        * used to convert between a type itself (e.g. `*v1.PodSpec` and `*v1.PodSpec`), which is for **uniform handling** of all conversions

* get the corresponding coversion function through **type pair**
```go
type Converter struct {
    // Map from the conversion pair to a function which can
    // do the conversion.
    conversionFuncs          ConversionFuncs
    generatedConversionFuncs ConversionFuncs

    // Set of conversions that should be treated as a no-op
    ignoredUntypedConversions map[typePair]struct{}
}

// type pair
type typePair struct {
    source reflect.Type
    dest   reflect.Type
}
```

##### (4) fieldLabelConversionFuncs
* When you have multiple versions of an API, field labels in these selectors might need to be renamed or transformed to maintain compatibility

```go
func convertFieldLabel(label, value string) (string, string, error) {
    switch label {
    case "spec.nodeName":
        return "spec.node", value, nil
    case "metadata.name":
        return "metadata.name", value, nil
    default:
        return "", "", fmt.Errorf("field label %q not supported", label)
    }
}

```

##### (5) defaulterFuncs
* used to set default values for an object
* e.g. scheduler package
```go
func RegisterDefaults(scheme *runtime.Scheme) error {
    scheme.AddTypeDefaultingFunc(&v1.DefaultPreemptionArgs{}, func(obj interface{}) { SetObjectDefaults_DefaultPreemptionArgs(obj.(*v1.DefaultPreemptionArgs)) })
    scheme.AddTypeDefaultingFunc(&v1.InterPodAffinityArgs{}, func(obj interface{}) { SetObjectDefaults_InterPodAffinityArgs(obj.(*v1.InterPodAffinityArgs)) })
    scheme.AddTypeDefaultingFunc(&v1.KubeSchedulerConfiguration{}, func(obj interface{}) {
        SetObjectDefaults_KubeSchedulerConfiguration(obj.(*v1.KubeSchedulerConfiguration))
    })
    scheme.AddTypeDefaultingFunc(&v1.NodeResourcesBalancedAllocationArgs{}, func(obj interface{}) {
        SetObjectDefaults_NodeResourcesBalancedAllocationArgs(obj.(*v1.NodeResourcesBalancedAllocationArgs))
    })
    scheme.AddTypeDefaultingFunc(&v1.NodeResourcesFitArgs{}, func(obj interface{}) { SetObjectDefaults_NodeResourcesFitArgs(obj.(*v1.NodeResourcesFitArgs)) })
    scheme.AddTypeDefaultingFunc(&v1.PodTopologySpreadArgs{}, func(obj interface{}) { SetObjectDefaults_PodTopologySpreadArgs(obj.(*v1.PodTopologySpreadArgs)) })
    scheme.AddTypeDefaultingFunc(&v1.VolumeBindingArgs{}, func(obj interface{}) { SetObjectDefaults_VolumeBindingArgs(obj.(*v1.VolumeBindingArgs)) })
    return nil
}
```

#### 2.define scheme

* define the corresponding scheme when import an component 

##### (1) prepration (e.g. scheduler)

* new scheme
    * `pkg/scheduler/apis/config/scheme/scheme.go`
```go
var (
    // Scheme is the runtime.Scheme to which all kubescheduler api types are registered.
    Scheme = runtime.NewScheme()
)
```

* define scheme builder
    * `pkg/scheduler/apis/config/register.go`
```go
var (
    // SchemeBuilder is the scheme builder with scheme init functions to run for this API package
    SchemeBuilder = runtime.NewSchemeBuilder(addKnownTypes)
    // AddToScheme is a global function that registers this API group & version to a scheme
    AddToScheme = SchemeBuilder.AddToScheme
)
```

##### (2) define shceme (e.g. scheduler)


* register api types to shceme
```go
func init() {
    AddToScheme(Scheme)
}

func AddToScheme(scheme *runtime.Scheme) {
    utilruntime.Must(config.AddToScheme(scheme))
    utilruntime.Must(configv1.AddToScheme(scheme))
    utilruntime.Must(scheme.SetVersionPriority(
        configv1.SchemeGroupVersion,
    ))
}
```

```go
/*
    // this registers scheme of internal version which should not be considered stable or serialized
    utilruntime.Must(config.AddToScheme(scheme))

    var SchemeGroupVersion = schema.GroupVersion{Group: GroupName, Version: runtime.APIVersionInternal}
    const GroupName = "kubescheduler.config.k8s.io"
    const APIVersionInternal = "__internal"
*/


func addKnownTypes(scheme *runtime.Scheme) error {
    scheme.AddKnownTypes(SchemeGroupVersion,
        &KubeSchedulerConfiguration{},
        &DefaultPreemptionArgs{},
        &InterPodAffinityArgs{},
        &NodeResourcesFitArgs{},
        &PodTopologySpreadArgs{},
        &VolumeBindingArgs{},
        &NodeResourcesBalancedAllocationArgs{},
        &NodeAffinityArgs{},
    )
    return nil
}

/* 
    utilruntime.Must(configv1.AddToScheme(scheme))

    var SchemeGroupVersion = schema.GroupVersion{Group: GroupName, Version: "v1"}
    const GroupName = "kubescheduler.config.k8s.io"
*/
func addKnownTypes(scheme *runtime.Scheme) error {
    scheme.AddKnownTypes(SchemeGroupVersion,
        &KubeSchedulerConfiguration{},
        &DefaultPreemptionArgs{},
        &InterPodAffinityArgs{},
        &NodeResourcesBalancedAllocationArgs{},
        &NodeResourcesFitArgs{},
        &PodTopologySpreadArgs{},
        &VolumeBindingArgs{},
        &NodeAffinityArgs{},
    )
    return nil
}
```

```go
func (s *Scheme) AddKnownTypes(gv schema.GroupVersion, types ...Object) {
    s.addObservedVersion(gv)
    for _, obj := range types {
        t := reflect.TypeOf(obj)
        if t.Kind() != reflect.Pointer {
            panic("All types must be pointers to structs.")
        }
        t = t.Elem()
        s.AddKnownTypeWithName(gv.WithKind(t.Name()), obj)
    }
}
```
```go
func (s *Scheme) AddKnownTypeWithName(gvk schema.GroupVersionKind, obj Object) {
    s.addObservedVersion(gvk.GroupVersion())

    // ...

    s.gvkToType[gvk] = t

    //...

    s.typeToGVK[t] = append(s.typeToGVK[t], gvk)

    //...
    
    s.AddGeneratedConversionFunc(obj, obj, func(a, b interface{}, scope conversion.Scope) error {
            // copy a to b
            reflect.ValueOf(a).MethodByName("DeepCopyInto").Call([]reflect.Value{reflect.ValueOf(b)})
            // clear TypeMeta to match legacy reflective conversion
            b.(Object).GetObjectKind().SetGroupVersionKind(schema.GroupVersionKind{})
            return nil
        });
}
```

* register defaultFuncs to scheme
    * `import "k8s.io/kubernetes/pkg/scheduler/apis/config/v1"`
```go
func init() {
    // We only register manually written functions here. The registration of the
    // generated functions takes place in the generated files. The separation
    // makes the code compile even when the generated files are missing.
    localSchemeBuilder.Register(addDefaultingFuncs)
}
```

***

### FeatureGates

* **apiserver** creates a feature gate
* **other** components **register** their related features to the apiserver featuregate
* define when **import**

#### 1.define FeatureGates

* FeatureGates are a mechanism used to enable or disable experimental or optional features in the system.

##### (1) new FeatureGates in apiserver
* `staging/src/k8s.io/apiserver/pkg/util/feature/feature_gate.go`

```go
var (
    // DefaultMutableFeatureGate is a mutable version of DefaultFeatureGate.
    // Only top-level commands/options setup and the k8s.io/component-base/featuregate/testing package should make use of this.
    // Tests that need to modify feature gates for the duration of their test should use:
    //   featuregatetesting.SetFeatureGateDuringTest(t, utilfeature.DefaultFeatureGate, features.<FeatureName>, <value>)
    DefaultMutableFeatureGate featuregate.MutableVersionedFeatureGate = featuregate.NewFeatureGate()

    // DefaultFeatureGate is a shared global FeatureGate.
    // Top-level commands/options setup that needs to modify this feature gate should use DefaultMutableFeatureGate.
    DefaultFeatureGate featuregate.FeatureGate = DefaultMutableFeatureGate
)
```

##### (2) register features to FeatureGates

* every component register its related features to the apiserver featuregate
* e.g. `staging/src/k8s.io/apiserver/pkg/features/kube_features.go`
```go
import (
    utilfeature "k8s.io/apiserver/pkg/util/feature"
)
func init() {
    runtime.Must(utilfeature.DefaultMutableFeatureGate.Add(defaultKubernetesFeatureGates))
    runtime.Must(utilfeature.DefaultMutableFeatureGate.AddVersioned(defaultVersionedKubernetesFeatureGates))
}
```

* some default features
```go
var defaultKubernetesFeatureGates = map[featuregate.Feature]featuregate.FeatureSpec{

    AnonymousAuthConfigurableEndpoints: {Default: false, PreRelease: featuregate.Alpha},

    AggregatedDiscoveryEndpoint: {Default: true, PreRelease: featuregate.GA, LockToDefault: true}, // remove in 1.33

}
```

***

### Event

![](./imgs/event_01.png)

#### 1.EventBroadcaster (receive events from the component itself)

##### (1) what
* get events from `incoming` channel in a loop
* distribute events to watchers: `m.distribute(event)`

##### (2) create a new event Broadcaster
* start a loop goroutine to **reveive** events and **distribute** these events to **broadcatser watchers**

```go
func NewBroadcaster(queueLength int, fullChannelBehavior FullChannelBehavior) *Broadcaster {
    m := &Broadcaster{
        watchers:            map[int64]*broadcasterWatcher{},
        incoming:            make(chan Event, incomingQueueLength),
        stopped:             make(chan struct{}),
        watchQueueLength:    queueLength,
        fullChannelBehavior: fullChannelBehavior,
    }
    m.distributing.Add(1)

    // start a loop goroutine
    go m.loop()
    
    return m
}
```

```go
// loop receives from m.incoming and distributes to all watchers.
func (m *Broadcaster) loop() {
    // Deliberately not catching crashes here. Yes, bring down the process if there's a
    // bug in watch.Broadcaster.
    for event := range m.incoming {
        if event.Type == internalRunFunctionMarker {
            event.Object.(functionFakeRuntimeObject)()
            continue
        }
        m.distribute(event)
    }
    m.closeAll()
    m.distributing.Done()
}
```

* blockQueue was used to wait for the function to be done
    * events are not able to be pushed into the channel util the function being done
```go
func (m *Broadcaster) blockQueue(f func()) {
    m.incomingBlock.Lock()
    defer m.incomingBlock.Unlock()
    select {
    case <-m.stopped:
        return
    default:
    }
    var wg sync.WaitGroup
    wg.Add(1)
    m.incoming <- Event{
        Type: internalRunFunctionMarker,
        Object: functionFakeRuntimeObject(func() {
            defer wg.Done()
            f()
        }),
    }
    wg.Wait()
}
```

#### 2.watchers
```go
func (e *eventBroadcasterImpl) startRecordingEvents(ctx context.Context) error {
    eventHandler := func(obj runtime.Object) {
        event, ok := obj.(*eventsv1.Event)
        if !ok {
            klog.FromContext(ctx).Error(nil, "unexpected type, expected eventsv1.Event")
            return
        }
        e.recordToSink(ctx, event, clock.RealClock{})
    }
    stopWatcher, err := e.StartEventWatcher(eventHandler)
    if err != nil {
        return err
    }
    go func() {
        <-ctx.Done()
        stopWatcher()
    }()
    return nil
}
```
```go
func (e *eventBroadcasterImpl) StartEventWatcher(eventHandler func(event runtime.Object)) (func(), error) {
    // add watchers to EventBroadcaster
    watcher, err := e.Watch()
    if err != nil {
        return nil, err
    }

    // start watchers
    go func() {
        defer utilruntime.HandleCrash()
        for {
            watchEvent, ok := <-watcher.ResultChan()
            if !ok {
                return
            }
            eventHandler(watchEvent.Object)
        }
    }()
    return watcher.Stop, nil
}
```
* add watchers to EventBroadcaster
```go
func (m *Broadcaster) Watch() (Interface, error) {
    var w *broadcasterWatcher
    m.blockQueue(func() {
        id := m.nextWatcher
        m.nextWatcher++
        w = &broadcasterWatcher{
            result:  make(chan Event, m.watchQueueLength),
            stopped: make(chan struct{}),
            id:      id,
            m:       m,
        }
        m.watchers[id] = w
    })
    if w == nil {
        return nil, fmt.Errorf("broadcaster already stopped")
    }
    return w, nil
}
```

#### 3.recordToSink (write events to apiserver)

```go
func (e *eventBroadcasterImpl) startRecordingEvents(ctx context.Context) error {
    //...
    e.recordToSink(ctx, event, clock.RealClock{})
    //...
}
```

```go
func (e *eventBroadcasterImpl) recordToSink(ctx context.Context, event *eventsv1.Event, clock clock.Clock) {
    //...
    e.attemptRecording(ctx, evToRecord)
    //...
}
```
```go
func (e *eventBroadcasterImpl) attemptRecording(ctx context.Context, event *eventsv1.Event) {
    tries := 0
    for {
        if _, retry := recordEvent(ctx, e.sink, event); !retry {
            return
        }
        //...
    }
}
```
```go
func recordEvent(ctx context.Context, sink EventSink, event *eventsv1.Event) (*eventsv1.Event, bool) {
    //...
    newEvent, err = sink.Create(ctx, event)
    //...
}
```
```go
// staging/src/k8s.io/client-go/gentype/type.go

func (c *Client[T]) Create(ctx context.Context, obj T, opts metav1.CreateOptions) (T, error) {
    result := c.newObject()
    err := c.client.Post().
        NamespaceIfScoped(c.namespace, c.namespace != "").
        Resource(c.resource).
        VersionedParams(&opts, c.parameterCodec).
        Body(obj).
        Do(ctx).
        Into(result)
    return result, err
}
```