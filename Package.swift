// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EZLayout",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "EZLayout", targets: ["EZLayout"])
    ],
    targets: [
        .target(name: "EZLayout"),
        .testTarget(name: "EZLayoutTests", dependencies: ["EZLayout"])
    ]
)
