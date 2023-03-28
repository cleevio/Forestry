
# Forestry: An iOS Logging Framework

Our team envisioned a versatile logging framework for iOS projects that could easily cater to specific logging needs. We aimed to facilitate seamless switching between logging services without disrupting the existing codebase. Today, we're proud to present Forestry - an open-source logging library designed to meet these objectives.

# Features

- One logger to rule them all: whether you're only interested in logging to the console or need to log billions of records in production, we've got you covered!
- Easy extensibility
- Supports major external logging services & local file logging out of the box
- Written in Swift
- The public API of ForestryLoggerLibrary is fully covered by tests.

## Installation

### Swift Package Manager
Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Xcode 11+ is required to build Forestry iOS Logger using Swift Package Manager.

To integrate Forestry iOS Logger into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```
dependencies: [
    .package(url: "https://github.com/cleevio/Forestry", .upToNextMajor(from: "3.0.0"))
]
```

## Usage/Examples

Core of library is `ForestryLogger` struct. During initialization you provide logging services to log to

Common usage is as follows: 
```swift
#if DEBUG
let log = ForestryLogger(services: [ConsoleLogger()])
#else
let log = ForestryLogger(services: [ConsoleLogger(), SwiftyBeaverLogger()])
#endif
```

It is also possible to instantiate services with convenience functions:
```swift
let log = ForestryLogger(service: .console)
let log2 = ForestryLogger(services: [.console, .datadog(clientToken: "", environment: "", serviceName: "")])
```

You can always expend the functionality by creating your own logging service by conforming to the `LoggerService` protocol.

## Integrations

Forestry currently includes integrations to following third party logging services. 

- DataDog
- Sentry (error logging only)
- SwiftBeaver Cloud
- LogRocket

## TODO

- Implement Thread support in log() function if possible
- Implement handling UserInfo in SwiftyBeaverLogger
- Implement privacy support
- Implement support for other platforms

## License

[MIT](LICENSE.md)

## Developed by

The good guys from [Cleevio](https://cleevio.com).

![Cleevio logo](cleevioLogo.jpg)
