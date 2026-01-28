
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Event Structure](#event-structure)
  - [1.Cloudfront Function](#1cloudfront-function)
  - [2.Lambda@Edge](#2lambdaedge)

<!-- /code_chunk_output -->


### Event Structure

#### 1.Cloudfront Function

[xRef](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-event-structure.html)

* CloudFront Functions passes an event object to your function code as input when it runs the function

```json
{
    "version": "1.0",
    "context": {
        <context object>
    },
    "viewer": {
        <viewer object>
    },
    "request": {
        <request object>
    },
    "response": {
        <response object>
    }
}
```

#### 2.Lambda@Edge

[xRef](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html)