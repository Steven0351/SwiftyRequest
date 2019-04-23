# SwiftyRequest
[![Build Status](https://travis-ci.org/Steven0351/SwiftyRequest.svg?branch=master)](https://travis-ci.org/Steven0351/SwiftyRequest)
### These are some HTTP related helpers that I like to use when building out network communication managers. This is not meant to be a complete solution for all networking needs: it just adds some additional goodies on top of existing Foundation types, plus support for very minimal Futures ( which was wholesale taken from a John Sundell blog post).

#### Note: I'm not supporting anything outside of my own use. As such, you will notice things like the TransportProtocol enum:
```swift
enum TransportProtocol {
  case http, https
}
```
#### There are plenty of other url schemes that are valid such as `ftp`, `ws`, etc, but I personally don't use them enough to care to add them or worry about testing them. That being said, if you want to use these helpers but it doesn't have a feature you need, feel free to fork the repo and add whatever you need.

### Endpoint Configuration
The `Endpoint` (a typealias for URLComponents) helpers largely let you configure your endpoints in a manner that doesn't require them to be nested in any kind of helper function. For example:
```swift
let baseEndpoint = Endpoint { base in
  base.protocol = .https
  base.host = "somewebservice.com"
  base.pathComponents = ["api", "v1"]
  // https://somewebservice.com/api/v1
}
```
This could also be achieved in a similar manner using property evaluation:
```swift
let base: URLComponents = {
  var components = URLComponents()
  components.scheme = "https"
  components.host = "somewebservice.com"
  components.path = "/api/v1"
  return components
}()
```
I personally like to omit the creation of a local variable and then returning it at the end. I prefer the former because I get a clean declarative block.

I've found that in most cases, endpoints that I need to fetch data from are typically unchanged except from a path here or a query parameter there. (Note: `Query` is a typealias for `URLQueryItem`)
```swift
let peopleEndpoint = baseEndpoint.appending(pathComponent: "people")
// https://somewebservice.com/api/v1/people
let peopleWithBlackHairEndpoint = peopleEndpoint.appending(query:
  Query(name: "haircolor", value: "black")
)
// https://somewebservice.com/api/v1/people?haircolor=black
```
Query values are oftentimes supplied by the user. You could manage query names in a constants file or an enum, and initialize a URLQueryItem using one of those predefined keys and allow the user defined input as the value. However, I prefer to take inspiration from strict functional languages and utilize something called "Partial Application". Partial Application is a concept in many functional languages that allow you to pass fewer parameters than the function takes, and it returns a function that takes the remaining parameters and returns what the original function intended. Swift does not support this natively, so to achieve a similar result I've added a static function on `Query`/`URLQueryItem` called `partialInit(name:)` that returns `(String) -> Query`:
```swift
let queryHairColor = Query.partialInit(name: "haircolor")
...
let peopleWithBlackHairEndpoint = peopleEndpoint.appending(
  query: queryHairColor("black")
)
// https://somewebservice.com/api/v1/people?haircolor=black
```
I've never personally run into a case where I've allowed a user to freely input text to define what property to search on, so being able to predefine queries with the appropriate key that is a partially applied `Query` initializer can reduce boilerplate setup at the call-site.

### Request Configuration
Request (a typealias for `URLRequest`) uses the same style of configuration as above.
```swift
let peopleRequest = Request(endpoint: peopleEndpoint) { request in
  request.method = .post
  request.headerFields = [
    .authorization: "Bearer ==wqeoriuj943ru8sajdf",
    .contentType: "application/json"
  ]
  request.httpBody = try? JSONEncoder().encode(person)
}
```
A simple GET request that requires no authentication is as simple as
```swift
let peopleRequest = Request(endpoint: peopleEndpoint)
```

### Futures
The futures implementation was completely taken from John Sundell's blog post [Under the Hood of Futures and Promises in Swift](https://www.swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift). Rather than rehashing the details here, just read that blog post. My only change was making the URLSession extension `request(_:)` function generic over `Decodable` to return a value that needs no further processing rather than have it return `Future<Data>` by default.
