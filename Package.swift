// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UMUtils",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "UMUtils", targets: ["UMUtils"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/CosmicMind/Material", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/cocoatoucher/AIFlatSwitch", .upToNextMajor(from: "1.0.7")),
        .package(url: "https://github.com/umobi/ConstraintBuilder", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/umobi/UIContainer", from: "1.2.0-beta")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "UMUtils",
            dependencies: [
                "Material", "ConstraintBuilder", "UIContainer", "RxSwift",
                "AIFlatSwitch", "Moya",
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),
        
        .testTarget(
            name: "UMUtilsTests",
            dependencies: ["UMUtils"]
        ),
    ]
)
