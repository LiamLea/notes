# kube-scheduler


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [kube-scheduler](#kube-scheduler)
    - [code analyze](#code-analyze)
      - [1.build command](#1build-command)
      - [2.run command](#2run-command)
      - [3.runs the scheduler](#3runs-the-scheduler)

<!-- /code_chunk_output -->


### code analyze

#### 1.build command

* `cobra` lib
    * build cli command
```go
command := app.NewSchedulerCommand()
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
```go
RunE: func(cmd *cobra.Command, args []string) error {
			return runCommand(cmd, opts, registryOptions...)
		},
```

#### 3.runs the scheduler