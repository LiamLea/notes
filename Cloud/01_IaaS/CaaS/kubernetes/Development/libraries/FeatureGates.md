# FeatureGates


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [FeatureGates](#featuregates)
    - [Overview](#overview)
      - [1.feature gate structure](#1feature-gate-structure)
    - [define](#define)
      - [1.define FeatureGates](#1define-featuregates)
        - [(1) new FeatureGates in apiserver](#1-new-featuregates-in-apiserver)
        - [(2) register features to FeatureGates](#2-register-features-to-featuregates)

<!-- /code_chunk_output -->


### Overview
[reference](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#feature-gates)

* featureGate is used to enable or disable unstable features (alpha/beta)
    * alpha features are usually disabled by default
    * beta features are usually enabled by default
    * stable features cannot be disabled

#### 1.feature gate structure
```go
type featureGate struct {
    featureGateName string

    special map[Feature]func(map[Feature]VersionedSpecs, map[Feature]bool, bool, *version.Version)

    // lock guards writes to all below fields (so when add features to a featureGate will get the lock and then write)
    lock sync.Mutex

    // known holds a map[Feature]FeatureSpec
    known atomic.Value
    // enabled holds a map[Feature]bool
    enabled atomic.Value
    // enabledRaw holds a raw map[string]bool of the parsed flag.
    // It keeps the original values of "special" features like "all alpha gates",
    // while enabled keeps the values of all resolved features.
    enabledRaw atomic.Value

    // closed is set to true when AddFlag is called, and prevents subsequent calls to Add features to this featureGate
    closed bool
    
    // queriedFeatures stores all the features that have been queried through the Enabled interface.
    // It is reset when SetEmulationVersion is called.
    queriedFeatures  atomic.Value
    emulationVersion atomic.Pointer[version.Version]
}
```

***

### define

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