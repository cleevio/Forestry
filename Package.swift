// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CleevioLoggerLibrary",
    products: [
        .library(name: "CleevioLoggerLibrary", targets: ["CleevioLoggerLibrary"]),
        .library(name: "DatadogSupport", targets: ["DatadogSupport"]),
        .library(name: "FileLogger", targets: ["FileLogger"]),
        .library(name: "SwiftyBeaverSupport", targets: ["SwiftyBeaverSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/DataDog/dd-sdk-ios", from: .init(1, 13, 0)),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: .init(1, 9, 6))
    ],
    targets: [
        .target(name: "CleevioLoggerLibrary", dependencies: []),
        .target(name: "FileLogger", dependencies: ["CleevioLoggerLibrary"]),
        .target(name: "DatadogSupport",
                dependencies: [
                    .product(name: "Datadog", package: "dd-sdk-ios"),
                    .target(name: "CleevioLoggerLibrary")
                ]),
        .target(name: "SwiftyBeaverSupport",
                dependencies: [
                    .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
                    .target(name: "CleevioLoggerLibrary")
                ])
    ]
)
