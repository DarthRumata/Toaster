// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Toaster",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7)
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
