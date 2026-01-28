# Event Bridge


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Event Bridge](#event-bridge)
    - [Ovewview](#ovewview)
      - [1.EventBridge](#1eventbridge)
      - [2.Event Structure](#2event-structure)
      - [3.Event Sample](#3event-sample)

<!-- /code_chunk_output -->


### Ovewview

#### 1.EventBridge
delivers system/application events on an event bus

#### 2.Event Structure
[xRef](https://docs.aws.amazon.com/eventbridge/latest/ref/overiew-event-structure.html)

```json
{
  . . . 
  "source": "aws.cloudformation",
  . . .
  "detail-type": "CloudFormation Stack Status Change",
  },
  "detail": {}
}
```

* the `source` and `detail-type` fields identify the service that has generated the event
* the `detail` field are different depending on which service generated the event

#### 3.Event Sample

Amazon EventBridge -> Sandbox -> Sample event