// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftShell",
    products: [
        .library(name: "SwiftShell", targets: ["SwiftShell"]),
    ],
    targets: [
        .target(
            name: "SwiftShell"
        ),
        .testTarget(
            name: "SwiftShellTests",
            dependencies: ["SwiftShell"]
        ),
    ]
)
