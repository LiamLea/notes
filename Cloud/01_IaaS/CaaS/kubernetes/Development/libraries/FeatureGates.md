# FeatureGates


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [FeatureGates](#featuregates)
    - [Overview](#overview)
      - [1.define FeatureGates](#1define-featuregates)
        - [(1) new FeatureGates in apiserver](#1-new-featuregates-in-apiserver)
        - [(2) register features to FeatureGates](#2-register-features-to-featuregates)

<!-- /code_chunk_output -->


### Overview

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