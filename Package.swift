// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CleevioLogger",
    products: [
        .library(name: "CleevioLogger", targets: ["CleevioLogger"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CleevioLogger", dependencies: []),
    ]
)
