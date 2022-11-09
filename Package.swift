// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CleevioLogger",
    products: [
        .library(name: "CleevioLogger", targets: ["CleevioLogger"]),
        .library(name: "DatadogSupport", targets: ["CleevioLogger", "DatadogSupport"]),
        .library(name: "SwiftyBeaverSupport", targets: ["CleevioLogger", "SwiftyBeaverSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/DataDog/dd-sdk-ios", from: .init(1, 13, 0)),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: .init(1, 9, 6))
    ],
    targets: [
        .target(name: "CleevioLogger", dependencies: []),
        .target(name: "DatadogSupport",
                dependencies: [.product(name: "Datadog", package: "dd-sdk-ios")]),
        .target(name: "SwiftyBeaverSupport",
                dependencies: [.product(name: "SwiftyBeaver", package: "SwiftyBeaver")])
    ]
)
