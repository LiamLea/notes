# AWS LBC

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [AWS LBC](#aws-lbc)
    - [Ovewview](#ovewview)
      - [1.what](#1what)
        - [(1) with Envoy Gateway](#1-with-envoy-gateway)
      - [2.LBC vs in-tree CCM](#2lbc-vs-in-tree-ccm)
      - [3.TargetGroupBinding](#3targetgroupbinding)
      - [4.pod readiness gate](#4pod-readiness-gate)
      - [5.pod termination](#5pod-termination)
        - [(1)`ip` targets](#1ip-targets)
        - [(2)`instance` targets](#2instance-targets)

<!-- /code_chunk_output -->


### Ovewview

#### 1.what

AWS Load Balancer Controller: watches k8s resources and creates AWS LBs for them

- `Service` (type `LoadBalancer`, `loadBalancerClass: service.k8s.aws/nlb`) → NLB
- `Ingress` (class `alb`) → ALB

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
spec:
  type: LoadBalancer
  loadBalancerClass: service.k8s.aws/nlb
  selector:
    app: demo
  ports:
  - port: 443
    targetPort: 8443
```

##### (1) with Envoy Gateway

Gateway → Envoy Gateway creates the Envoy proxy Deployment + a `LoadBalancer` Service → LBC creates an NLB for that Service

```yaml
# Service settings for the Envoy proxy
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: nlb
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyDeployment:
        replicas: 3
        pod:
          topologySpreadConstraints:        # pods of one gateway on different nodes
          - labelSelector:
              matchLabels:
                app.kubernetes.io/name: envoy
            matchLabelKeys:
            - gateway.envoyproxy.io/owning-gateway-namespace
            - gateway.envoyproxy.io/owning-gateway-name
            maxSkew: 1
            nodeTaintsPolicy: Honor
            topologyKey: kubernetes.io/hostname
            whenUnsatisfiable: DoNotSchedule
      envoyPDB:
        minAvailable: 2
      envoyService:
        type: LoadBalancer
        loadBalancerClass: service.k8s.aws/nlb     # handled by LBC (in-tree CCM skips it)
        externalTrafficPolicy: Local
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
          service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
          service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'     # keep client IP
---
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: envoy
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller   # ID matched by Envoy Gateway
  parametersRef:
    group: gateway.envoyproxy.io
    kind: EnvoyProxy
    name: nlb
    namespace: envoy-gateway-system
```

#### 2.LBC vs in-tree CCM

in-tree CCM: the built-in AWS cloud provider, uses annotation `service.beta.kubernetes.io/aws-load-balancer-type: nlb`

| | in-tree CCM | LBC |
|-|-|-|
| target type | `instance` only (node + NodePort) | `instance` or `ip` (pod IP) |
| pod readiness gate | no | yes |
| ALB | no | yes |

#### 3.TargetGroupBinding

- a CRD created by LBC for each Service port
- binds a Service to an AWS target group

```yaml
spec:
  serviceRef:
    name: <service>
    port: 443
  targetGroupARN: arn:aws:elasticloadbalancing:...:targetgroup/...
  targetType: ip
```

#### 4.pod readiness gate

a pod is `Ready` only when its NLB target is `healthy`

enable it by labeling the **namespace**:
```yaml
elbv2.k8s.aws/pod-readiness-gate-inject: enabled
```

how it works:
- pod created → LBC webhook adds a gate to the **pod** spec:
  ```yaml
  readinessGates:
  - conditionType: target-health.elbv2.k8s.aws/<targetgroupbinding-name>
  ```
- LBC registers the pod IP → target `initial` → pod not `Ready`
- target `healthy` → LBC sets the condition to `True` → pod `Ready`

#### 5.pod termination

##### (1)`ip` targets

the NLB stops sending to a pod **later** than k8s deletes it → the pod must keep serving until then

how it works:
- pod deleted → LBC deregisters the pod IP → NLB stops new connections after a few seconds (it needs some seconds to apply `DeregisterTargets`)
- at the same time, `preStop` keeps Envoy running and draining (still serving)
- NLB sends to the pod IP directly (no kube-proxy) → traffic always reaches Envoy
- `minDrainDuration`(It controls how long the preStop hook runs) over → Envoy exits

```yaml
# EnvoyProxy
spec:
  shutdown:
    minDrainDuration: 30s   # longer than the deregistration takes
```

##### (2)`instance` targets

target = node, not pod → nothing is deregistered, the NLB relies on the health check

key: a `LoadBalancer` Service with `externalTrafficPolicy: Local` gets **two node ports**
```yaml
spec:
  ports:
  - port: 443
    nodePort: 31234          # traffic
  healthCheckNodePort: 32100 # health check (only with Local)
```

```
NLB health check → node:32100 → HTTP server in kube-proxy → 200 / 503 (counts only ready pods)
NLB traffic      → node:31234 → kernel rules (iptables/IPVS) → pod (ready, else terminating + serving)
```

→ different ports, different logic → health check can fail while traffic still reaches the pod

`healthCheckNodePort`: kube-proxy on each node answers "does **this node** have a `ready` pod for this Service?"

how it works:

1. start deleting the pod
   - pod → `Terminating`, its endpoint → `ready=false`
   - `preStop` runs → Envoy starts draining, but keeps running and serving

2. NLB runs a health check (every 10s)
   - NLB → node's `healthCheckNodePort` → answered by **kube-proxy**, not Envoy
   - kube-proxy: "any `ready` Envoy pod on this node?" → no → 503
   - 1st failure → node still `healthy`; 2nd failure (~20s) → node `unhealthy`

3. new traffic comes in
   - before the node is `unhealthy`: NLB → node → kube-proxy
     - no `ready` pod → kube-proxy falls back to the terminating pod, if its readiness probe still passes → Envoy serves it
     - readiness probe fails → kube-proxy drops it → error
   - after the node is `unhealthy`: NLB sends it to other healthy nodes

4. `minDrainDuration` over (30s > ~20s) → `preStop` returns → Envoy exits

```yaml
# EnvoyProxy
spec:
  shutdown:
    minDrainDuration: 30s   # longer than the health checks take (~20s)
```

risk: readiness fails during the drain → kube-proxy drops traffic → fix: `ip` targets
