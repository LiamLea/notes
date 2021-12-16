# TrackCentral(network server)

[toc]

### 概述

#### 1.TrackCentral network server
* hybrid "inside-out" deployment model
  * include inside gateways and outside gateways, so there will be **many gateways**

* TrackCentral is optimized for hybrid "inside-out" deployments that need to track tens of millions of gateways and billions of sensors

#### 2.core components

##### (1) station
* relays traffic between devices and Dispatch(adding metadata including timestamp,etc)

##### (2) dispatch
* LNS core with network management

![](./imgs/dispatch_01.png)


##### (3) IO
* relays traffic application server and dispatch
* there is one IO instance per application backen

##### (4) terminal management console
* management console

```shell
swark.apis list
swark.nwks list
```
