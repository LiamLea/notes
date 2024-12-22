# cobra


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [cobra](#cobra)
    - [build and run kube command](#build-and-run-kube-command)
      - [1.build kube command](#1build-kube-command)
        - [(1) register component](#1-register-component)
      - [2.run kube command](#2run-kube-command)

<!-- /code_chunk_output -->


### build and run kube command

#### 1.build kube command

* e.g. kube-sheduler
```go
func NewSchedulerCommand(registryOptions ...Option) *cobra.Command {
    // explicitly register (if not already registered) the kube effective version and feature gate in DefaultComponentGlobalsRegistry,
    // which will be used in NewOptions.
    _, _ = utilversion.DefaultComponentGlobalsRegistry.ComponentGlobalsOrRegister(
        utilversion.DefaultKubeComponent, utilversion.DefaultBuildEffectiveVersion(), utilfeature.DefaultMutableFeatureGate)
    opts := options.NewOptions()

    cmd := &cobra.Command{
        Use: "kube-scheduler",
        Long: `The Kubernetes scheduler is a control plane process which assigns ...`,

        // define prerun function
        PersistentPreRunE: func(*cobra.Command, []string) error {
            return opts.ComponentGlobalsRegistry.Set()
        },

        // define run function (core)
        RunE: func(cmd *cobra.Command, args []string) error {
            return runCommand(cmd, opts, registryOptions...)
        },

        // define args
        Args: func(cmd *cobra.Command, args []string) error {
            for _, arg := range args {
                if len(arg) > 0 {
                    return fmt.Errorf("%q does not take any arguments, got %q", cmd.CommandPath(), args)
                }
            }
            return nil
        },
    }

    // ...

    return cmd
}
```

##### (1) register component

```go
_, _ = utilversion.DefaultComponentGlobalsRegistry.ComponentGlobalsOrRegister(
    utilversion.DefaultKubeComponent, utilversion.DefaultBuildEffectiveVersion(), utilfeature.DefaultMutableFeatureGate)
``` 

* registry looks like
```yaml
components: 
- key: "kube"
  effectiveVersion: [...]
  featureGate: [...]
```

#### 2.run kube command

* normalize all flags
    * So it would be possible to create a flag named "getURL" and have it translated to "geturl"
```go
cmd.SetGlobalNormalizationFunc(cliflag.WordSepNormalizeFunc)
```

* load position args
```go
if c.args == nil && filepath.Base(os.Args[0]) != "cobra.test" {
    args = os.Args[1:]
}

c.initCompleteCmd(args)
```

* run command
    ```go
    err = cmd.execute(flags)
    ```
    ```go
    if c.RunE != nil {
        if err := c.RunE(c, argWoFlags); err != nil {
            return err
        }
    } else {
        c.Run(c, argWoFlags)
    }
    ```
    * defined in `func NewSchedulerCommand(...)`
    ```go
    RunE: func(cmd *cobra.Command, args []string) error {
                return runCommand(cmd, opts, registryOptions...)
            },
    ```
