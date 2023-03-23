
# Forestry: A Swift iOS Logger

We had once a dream to have a log in our projects where we can set logging services  based on our requirements (e.g. by using different logger based on a scheme, as well as being able to easily switch to other logging service without any code breaking changes). We are excited to introduce you Forestry.

## Features

- Lightweight logging solution without external dependencies
- Easily extensible
- Supports major external logging services out of the box
– Written with Swift
– The public API of ForestryLoggerLibrary has full test coverage. Integration of services has so far been tested only manually when integrated into our projects.

## Installation

### Swift Package Manager
Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Xcode 11+ is required to build Cleevio iOS Logger using Swift Package Manager.

To integrate Cleevio iOS Logger into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```
dependencies: [
    .package(url: "https://gitlab.cleevio.cz/cleevio-dev-ios/ForestryLogger-ios", .upToNextMajor(from: "1.0.0"))
]
```



## Usage/Examples

Core of library is `ForestryLogger` struct. During initialization you provide logging services to log to

Common usage is as follows: 
```swift
#if DEBUG
public let log = ForestryLogger(services: [ConsoleLogger()])
#else
public let log = ForestryLogger(services: [ConsoleLogger(), SwiftyBeaverLogger()])
#endif
```

It is also possible to instantiate services with convenience functions:
```swift
public var log = ForestryLogger(service: .console)
public var log2 = ForestryLogger(services: [.console, .datadog(clientToken: "", environment: "", serviceName: "")])
```

You can always expend the functionality by creating your own logging service via conforming to the `LoggerService` protocol.

## TODO

– Implement Thread support in log() function if possible
– Implement handling UserInfo in SwiftyBeaverLogger
– Implement privacy support
– Implement support for other platforms

## License

[GNU GPL-V3](https://choosealicense.com/licenses/gpl-3.0/#)

## Developed by

The good guys from Cleevio.

![Cleevio logo](https://pbs.twimg.com/profile_images/1531970166946422790/e0DjgYzt_400x400.png)
