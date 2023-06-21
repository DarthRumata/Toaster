// swift-tools-version: 5.8

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
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMinor(from: "1.0.4")
        )
    ],
    targets: [
        .target(
            name: "Toaster",
            dependencies: [
                .product(name: "DequeModule", package: "swift-collections")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ToasterTests",
            dependencies: ["Toaster"],
            path: "Tests",
            exclude: ["Toaster.xctestplan"]
        ),
    ]
)
