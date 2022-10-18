
# Cleevio iOS Logger
![Cleevio logo](https://pbs.twimg.com/profile_images/1531970166946422790/e0DjgYzt_400x400.png)
## Features

- Lightweight logging solution without external dependencies
- Easily extensible
- Supports major external logging services out of box


## Installation

### Swift Package Manager
Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Xcode 11+ is required to build Cleevio iOS Logger using Swift Package Manager.

To integrate Cleevio iOS Logger into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```
dependencies: [
    .package(url: "https://gitlab.cleevio.cz/cleevio-dev-ios/cleeviologger-ios", .upToNextMajor(from: "1.0.0"))
]
```



## Usage/Examples

Core of library is `CleevioLogger` struct. During initialization you're required to provide 1 or more logging services to log to. 

Common usage is as follows: 
```swift
#if DEBUG
public var Log = CleevioLogger(services: [ConsoleLogger()])
#else
public var Log = CleevioLogger(services: [ConsoleLogger(), SwiftyBeaverLogger()])
#endif

```


## License

[GNU GPL-V3](https://choosealicense.com/licenses/gpl-3.0/#)

