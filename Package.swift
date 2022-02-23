// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Prism",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Prism",
            targets: ["Prism"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Prism",
            dependencies: []
        ),
        .testTarget(
            name: "PrismTests",
            dependencies: ["Prism"]),
    ],
    swiftLanguageVersions: [.v5]
)
