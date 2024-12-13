# kube-scheduler


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [kube-scheduler](#kube-scheduler)
    - [code analyze](#code-analyze)
      - [1.build command and do some initialization](#1build-command-and-do-some-initialization)
        - [(1) register component](#1-register-component)
      - [2.run command](#2run-command)
      - [3.runs the scheduler](#3runs-the-scheduler)
        - [(1) setup a scheduler](#1-setup-a-scheduler)

<!-- /code_chunk_output -->


### code analyze

#### 1.build command and do some initialization

* `cobra` lib
```go
command := app.NewSchedulerCommand()
```
```go
cmd := &cobra.Command{
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

        //...
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

#### 2.run command

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

#### 3.runs the scheduler

##### (1) setup a scheduler

* Setup creates a completed config and a scheduler based on the command args and options

```go
cc, sched, err := Setup(ctx, opts, registryOptions...)
```

```go
// set defaults using scheme defaultFunc
cfg, err := latest.Default()
opts.ComponentConfig = cfg

// set command config
//   create client, InformerFactory, DynInformerFactory
c, err := opts.Config(ctx)

// make the config completed
//   grant apiserver authrization to it
cc := c.Complete()

sched, err := scheduler.New(ctx,
		cc.Client,
		cc.InformerFactory,
		cc.DynInformerFactory,
		recorderFactory,
		scheduler.WithComponentConfigVersion(cc.ComponentConfig.TypeMeta.APIVersion),
		scheduler.WithKubeConfig(cc.KubeConfig),
		scheduler.WithProfiles(cc.ComponentConfig.Profiles...),
		scheduler.WithPercentageOfNodesToScore(cc.ComponentConfig.PercentageOfNodesToScore),
		scheduler.WithFrameworkOutOfTreeRegistry(outOfTreeRegistry),
		scheduler.WithPodMaxBackoffSeconds(cc.ComponentConfig.PodMaxBackoffSeconds),
		scheduler.WithPodInitialBackoffSeconds(cc.ComponentConfig.PodInitialBackoffSeconds),
		scheduler.WithPodMaxInUnschedulablePodsDuration(cc.PodMaxInUnschedulablePodsDuration),
		scheduler.WithExtenders(cc.ComponentConfig.Extenders...),
		scheduler.WithParallelism(cc.ComponentConfig.Parallelism),
		scheduler.WithBuildFrameworkCapturer(func(profile kubeschedulerconfig.KubeSchedulerProfile) {
			// Profiles are processed during Framework instantiation to set default plugins and configurations. Capturing them for logging
			completedProfiles = append(completedProfiles, profile)
		}),
	)
```