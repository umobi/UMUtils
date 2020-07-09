// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UMUtils",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15), .watchOS(.v6)
    ],
    products: [
        .library(name: "UMUtils", targets: ["UMUtils"])
    ],
    dependencies: [
        .package(name: "Request", url: "https://github.com/carson-katri/swift-request", .branch("master"))
    ],
    targets: [
        .target(
            name: "UMUtils",
            dependencies: ["Request"]
        ),
        
        .testTarget(
            name: "UMUtilsTests",
            dependencies: ["UMUtils"]
        ),
    ]
)
