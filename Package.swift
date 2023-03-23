// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForestryLoggerLibrary",
    products: [
        .library(name: "ForestryLoggerLibrary", targets: ["ForestryLoggerLibrary"]),
        .library(name: "ForestryDatadogSupport", targets: ["ForestryDatadogSupport"]),
        .library(name: "ForestryFileLogger", targets: ["ForestryFileLogger"]),
        .library(name: "ForestrySwiftyBeaverSupport", targets: ["ForestrySwiftyBeaverSupport"]),
        .library(name: "ForestryLogRocketSupport", targets: ["ForestryLogRocketSupport"]),
        .library(name: "ForestrySentrySupport", targets: ["ForestrySentrySupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/DataDog/dd-sdk-ios", from: .init(1, 15, 0)),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: .init(1, 9, 6)),
        .package(url: "https://github.com/LogRocket/logrocket-ios-swift-package", from: .init(1, 12, 0)),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: .init(8, 3, 0))
    ],
    targets: [
        .target(name: "ForestryLoggerLibrary", dependencies: []),
        .testTarget(name: "ForestryLoggerLibraryTests", dependencies: ["ForestryLoggerLibrary"]),
        .target(name: "ForestryFileLogger", dependencies: ["ForestryLoggerLibrary"]),
        .target(name: "ForestryDatadogSupport",
                dependencies: [
                    .product(name: "Datadog", package: "dd-sdk-ios", condition: .when(platforms: [.iOS, .macCatalyst])),
                    .target(name: "ForestryLoggerLibrary")
                ]),
        .target(name: "ForestrySwiftyBeaverSupport",
                dependencies: [
                    .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
                    .target(name: "ForestryLoggerLibrary")
                ]),
        .target(name: "ForestryLogRocketSupport",
                dependencies: [
                    .product(name: "LogRocket", package: "logrocket-ios-swift-package", condition: .when(platforms: [.iOS, .macCatalyst])),
                    .target(name: "ForestryLoggerLibrary")
                ]),
        .target(name: "ForestrySentrySupport",
                dependencies: [
                    .product(name: "Sentry", package: "sentry-cocoa"),
                    .target(name: "ForestryLoggerLibrary")
                ])
    ]
)
