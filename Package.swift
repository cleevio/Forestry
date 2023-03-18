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
        .library(name: "LogRocketSupport", targets: ["LogRocketSupport"]),
        .library(name: "SentrySupport", targets: ["SentrySupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/DataDog/dd-sdk-ios", from: .init(1, 15, 0)),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: .init(1, 9, 6)),
        .package(url: "https://github.com/LogRocket/logrocket-ios-swift-package", from: .init(1, 12, 0)),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: .init(8, 3, 0))
    ],
    targets: [
        .target(name: "CleevioLoggerLibrary", dependencies: []),
        .target(name: "FileLogger", dependencies: ["CleevioLoggerLibrary"]),
        .target(name: "DatadogSupport",
                dependencies: [
                    .product(name: "Datadog", package: "dd-sdk-ios", condition: .when(platforms: [.iOS, .macCatalyst])),
                    .target(name: "CleevioLoggerLibrary")
                ]),
        .target(name: "SwiftyBeaverSupport",
                dependencies: [
                    .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
                    .target(name: "CleevioLoggerLibrary")
                ]),
        .target(name: "LogRocketSupport",
                dependencies: [
                    .product(name: "LogRocket", package: "logrocket-ios-swift-package"),
                    .target(name: "CleevioLoggerLibrary")
                ]),
        .target(name: "SentrySupport",
                dependencies: [
                    .product(name: "Sentry", package: "sentry-cocoa"),
                    .target(name: "CleevioLoggerLibrary")
                ])
    ]
)
