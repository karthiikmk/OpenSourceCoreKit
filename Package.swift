// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "NetworkKit", targets: ["NetworkKit"]),
        .library(name: "TaskKit", targets: ["TaskKit"]),
        .library(name: "DIKit", targets: ["DIKit"]),
    ],
    dependencies: [
        .package(name: "Result", url: "https://github.com/antitypical/Result.git", from: "5.0.0"),
        .package(name: "SwinjectAutoregistration", url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMinor(from: "2.8.0"))
    ],
    targets: [
        .target(name: "CoreKit", dependencies: ["Result"], resources: [
            .process("Resources")
        ]),
        .target(name: "NetworkKit", dependencies: ["CoreKit", "TaskKit"]),
        .target(name: "TaskKit", dependencies: ["CoreKit"]),
        .target(name: "DIKit", dependencies: ["CoreKit", "SwinjectAutoregistration"])
    ],
    swiftLanguageVersions: [.v5]
)
