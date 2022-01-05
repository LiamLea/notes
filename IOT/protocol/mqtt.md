# mqtt

[toc]

### Introduction

#### 1.mqtt
message queue telemetry transport

#### 2.topic

##### (1) format
* one topic consistes of one or more topic level
  * every topic level is sperated by forward slash
  * `level1/level2/level3`

![](./imgs/mqtt_01.png)

##### (2) wildcards

* single level: `+`
  * `myhome/groundfloor/+/temperature`
  * match:
    * `myhome/groundfloor/aa/temperature`
    * `myhome/groundfloor/bb/temperature`
  * not match
    * `myhome/groundfloor/aa/bb/temperature`

* multi level: `#`
  * must be placed as the last character and preceded by a forward slash
  * `myhome/groundfloor/#`
    * match all topics with the prefix of `myhome/groundfloor/`

* topics that start with `$` are reserved which can't be subscribed
