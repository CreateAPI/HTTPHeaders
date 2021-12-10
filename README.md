# HTTP Headers

Parsing simple HTTP headers using pre-defined header descriptions.

Examples:

```swift
let response = HTTPURLRseponse(..., headers: [
    "X-RateLimit-Reset": "2015-01-01T00:00:00Z"
])

let header = HTTPHeader<Date>(field: "X-RateLimit-Reset")
let date = try header.parse(from: response)
// let date = try header.parseIfPresent(from: response)
```
