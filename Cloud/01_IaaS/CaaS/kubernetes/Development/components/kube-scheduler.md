# kube-scheduler


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [kube-scheduler](#kube-scheduler)
    - [run kube-scheduler](#run-kube-scheduler)
      - [1.setup a scheduler](#1setup-a-scheduler)
      - [2.run basic services](#2run-basic-services)

<!-- /code_chunk_output -->


### run kube-scheduler

#### 1.setup a scheduler

* Setup creates a completed config and a scheduler based on the command args and options

```go
cc, sched, err := Setup(ctx, opts, registryOptions...)
```

```go
// set defaults using scheme defaultFunc
cfg, err := latest.Default()

// componentConfig is the config of the current component(e.g. kubeScheduler) 
opts.ComponentConfig = cfg

// set command config, including
//   common config: client, EventBroadcaster, InformerFactory, DynInformerFactory
//   ComponentConfig
c, err := opts.Config(ctx)

// make the config completed
//   grant apiserver authrization to it
cc := c.Complete()

/*
set up the scheduler and complement some configs, such as 
    * add informers to informer factory
    * add eventhandlers
*/
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

#### 2.run basic services

```go
// Start events processing pipeline.
cc.EventBroadcaster.StartRecordingToSink(ctx.Done())
defer cc.EventBroadcaster.Shutdown()

// Start up the healthz server.
// ...

// start informerss
startInformersAndWaitForSync := func(ctx context.Context) {
    // Start all informers.
    cc.InformerFactory.Start(ctx.Done())
    // DynInformerFactory can be nil in tests.
    if cc.DynInformerFactory != nil {
        cc.DynInformerFactory.Start(ctx.Done())
    }

    // WaitForCacheSync blocks until all started informers' caches were synced
    cc.InformerFactory.WaitForCacheSync(ctx.Done())
    // DynInformerFactory can be nil in tests.
    if cc.DynInformerFactory != nil {
        cc.DynInformerFactory.WaitForCacheSync(ctx.Done())
    }

    // Wait for all handlers to sync (all items in the initial list delivered) before scheduling.
    if err := sched.WaitForHandlersSync(ctx); err != nil {
        logger.Error(err, "waiting for handlers to sync")
    }

    close(handlerSyncReadyCh)
    logger.V(3).Info("Handlers synced")
}
if !cc.ComponentConfig.DelayCacheUntilActive || cc.LeaderElection == nil {
    startInformersAndWaitForSync(ctx)
}

// start scheduler
sched.Run(ctx)
```