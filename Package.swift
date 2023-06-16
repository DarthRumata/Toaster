// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Toaster",
    platforms: [
        .macOS(.v13), .iOS(.v16), .tvOS(.v16), .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Toaster",
            targets: ["Toaster"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Toaster",
            dependencies: []),
        .testTarget(
            name: "ToasterTests",
            dependencies: ["Toaster"]),
    ]
)
