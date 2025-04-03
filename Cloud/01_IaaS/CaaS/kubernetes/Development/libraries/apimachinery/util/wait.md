# wait


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [wait](#wait)
    - [Overview](#overview)
      - [1.backoff](#1backoff)
        - [(1) `func BackoffUntil`](#1-func-backoffuntil)
      - [2.`func UntilWithContext`](#2func-untilwithcontext)

<!-- /code_chunk_output -->


### Overview

[xRef](https://pkg.go.dev/k8s.io/apimachinery@v0.32.3/pkg/util/wait)

#### 1.backoff
```go
type Backoff struct {
    Duration time.Duration // Initial wait time before first retry
    Factor   float64       // Multiplier for exponential growth
    Jitter   float64       // Adds randomness to each interval
    Steps    int           // Max number of retries (steps)
    Cap      time.Duration // Max delay between retries
}
```
* the n-th (`n <= Steps`) retry, will wait: $min (Factor^{(n-1)} * Duration + random(0, Factor^{(n-1)} * Duration * Jitter), Cap)$

##### (1) `func BackoffUntil`
```go
func BackoffUntil(f func(), backoff BackoffManager, sliding bool, stopCh <-chan struct{})
```
* BackoffUntil loops until stop channel is closed, run f every duration given by BackoffManager.
* If sliding is true, the period is computed after f runs. If it is false then period includes the runtime for f.
* BackoffManager.Backoff() will return a `clock.Timer`:
    * if waittime is reach, it will send a message to the channel
    * Timer.Next() is invoked by wait functions to signal timers that the next interval should begin
    ```go
    type Timer interface {
        // C returns a channel that will receive a struct{} each time the timer fires.
        // The channel should not be waited on after Stop() is invoked. It is allowed
        // to cache the returned value of C() for the lifetime of the Timer.
        C() <-chan time.Time
        // Next is invoked by wait functions to signal timers that the next interval
        // should begin. You may only use Next() if you have drained the channel C().
        // You should not call Next() after Stop() is invoked.
        Next()
        // Stop releases the timer. It is safe to invoke if no other methods have been
        // called.
        Stop()
    }
    ```

#### 2.`func UntilWithContext`

UntilWithContext loops until context is done, running f every period.

```go
func UntilWithContext(ctx context.Context, f func(context.Context), period time.Duration)
```