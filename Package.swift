// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: Products
let products: [Product] = [
    .library(name: "ForestryLoggerLibrary", targets: ["ForestryLoggerLibrary"]),
    .library(name: "ForestryFileLogger", targets: ["ForestryFileLogger"]),
    .library(name: "ForestrySwiftyBeaverSupport", targets: ["ForestrySwiftyBeaverSupport"]),
    .library(name: "ForestryLogRocketSupport", targets: ["ForestryLogRocketSupport"]),
    .library(name: "ForestrySentrySupport", targets: ["ForestrySentrySupport"]),
]

#if os(iOS)
let platformSpecificProducts: [Product] = [.library(name: "ForestryDatadogSupport", targets: ["ForestryDatadogSupport"])]
#else
let platformSpecificProducts: [Product] = []
#endif

// MARK: Targets

let targets: [Target] = [
    .target(name: "ForestryLoggerLibrary", dependencies: []),
    .testTarget(name: "ForestryLoggerLibraryTests", dependencies: ["ForestryLoggerLibrary"]),
    .target(name: "ForestryFileLogger", dependencies: ["ForestryLoggerLibrary"]),
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

#if os(iOS)
let platformSpecificTargets: [Target] = [
    .target(name: "ForestryDatadogSupport",
            dependencies: [
                .product(name: "Datadog", package: "dd-sdk-ios", condition: .when(platforms: [.iOS, .macCatalyst])),
                .target(name: "ForestryLoggerLibrary")
            ]),
]
#else
let platformSpecificTargets: [Target] = []
#endif

// MARK: Package

let package = Package(
    name: "ForestryLogger",
    products: products + platformSpecificProducts,
    dependencies: [
        .package(url: "https://github.com/DataDog/dd-sdk-ios", .upToNextMajor(from: .init(1, 16, 0))),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", .upToNextMajor(from: .init(1, 9, 6))),
        .package(url: "https://github.com/LogRocket/logrocket-ios-swift-package", .upToNextMajor(from: .init(1, 12, 0))),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", .upToNextMajor(from: .init(8, 3, 0))),
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main")
    ],
    targets: targets + platformSpecificTargets
)
