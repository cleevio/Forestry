// swift-tools-version: 5.11
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
// Only for development checks
//    SwiftSetting.unsafeFlags([
//        "-Xfrontend", "-strict-concurrency=complete",
//        "-Xfrontend", "-warn-concurrency",
//        "-Xfrontend", "-enable-actor-data-race-checks",
//    ])
]

let package = Package(
    name: "ForestryLogger",
    platforms: [
        .iOS(.v11),
        .macOS(.v11),
        .tvOS(.v11),
        .watchOS(.v7)
    ],
    products: [
        .library(name: "ForestryLoggerLibrary", targets: ["ForestryLoggerLibrary"]),
        .library(name: "ForestryFileLogger", targets: ["ForestryFileLogger"]),
        .library(name: "ForestryOSLogSupport", targets: ["ForestryOSLogSupport"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main")
    ],
    targets: [
        .target(name: "ForestryLoggerLibrary", dependencies: []),
        .target(name: "ForestryFileLogger", dependencies: ["ForestryLoggerLibrary"]),
        .testTarget(name: "ForestryLoggerLibraryTests", 
                    dependencies: ["ForestryLoggerLibrary"],
                    swiftSettings: swiftSettings)
    ]
)
