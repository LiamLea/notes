# confx


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [confx](#confx)
    - [Overview](#overview)
      - [1.what](#1what)
      - [2.how](#2how)

<!-- /code_chunk_output -->


[xRef](https://github.com/qor5/confx)

### Overview

#### 1.what
Go configuration library unifying flags, env, and config files with validation

#### 2.how

```go
// this is a function signature 
type Loader[T any] func(ctx context.Context, confPath string) (T, error)

func Initialize[T any](def T, options ...Option) (Loader[T], error) {
    opts := &initOptions{
        flagSet:       nil,
        envPrefix:     "",
        tagName:       DefaultTagName,
        usageTagName:  DefaultUsageTagName,
        viperInstance: viper.GetViper(),
        validator:     validator.New(validator.WithRequiredStructEnabled()),
    }

    // ...

    // viper: bind key to flag or env 
    var collectBinds []func() error
    err := initializeRecursive(opts, reflect.ValueOf(def), "", &collectBinds)
    if err != nil {
        return nil, err
    }

    // return a function
    return func(ctx context.Context, confPath string) (T, error) {
        // ...

        var conf T

        // use viper to read env
        // and then load env to structure according to tagName (here is confx)
        if err := opts.viperInstance.Unmarshal(&conf, DecoderConfigOption(opts.tagName)); err != nil {
            return zero, errors.Wrapf(err, "failed to unmarshal config to %T", conf)
        }

        // validate config according to tagName (here is validate)
        if err := enhancedValidator.StructCtx(ctx, conf); err != nil {
            return zero, errors.Wrap(err, "validation failed for config")
        }

        return conf, nil
    }, nil
}

```