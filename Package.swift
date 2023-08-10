// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Localization",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Localization",
            targets: ["Localization"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Localization",
            dependencies: []
        ),
        .testTarget(
            name: "LocalizationTests",
            dependencies: ["Localization"]
        )
    ]
)
