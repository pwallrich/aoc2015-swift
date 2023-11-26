// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2015",
    platforms: [ .macOS(.v13) ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "AOC2015",
            dependencies: [
                "AOC2015Core",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "AOC2015Core",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            resources: [
                .process("Inputs")
            ]
        ),
        .testTarget(
            name: "AOC2015Tests",
            dependencies: ["AOC2015"]),
        .testTarget(
            name: "AOC2015CoreTests",
            dependencies: ["AOC2015Core"]),
    ]
)
