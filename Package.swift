// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "LoggerKit", targets: ["LoggerKit"]),
        .library(name: "NetworkKit", targets: ["NetworkKit"]),
        .library(name: "SerializationKit", targets: ["SerializationKit"]),
        .library(name: "TaskKit", targets: ["TaskKit"]),
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "DIKit", targets: ["DIKit"]),
    ],
    dependencies: [
        .package(name: "Result", url: "https://github.com/antitypical/Result.git", from: "5.0.0"),
        .package(name: "SwinjectAutoregistration", url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMinor(from: "2.8.0"))
    ],
    targets: [
        .target(name: "LoggerKit", dependencies: []),        
        .target(name: "SerializationKit", dependencies: ["LoggerKit", "Result"]),
        .target(name: "TaskKit", dependencies: ["LoggerKit"]),
        .target(name: "NetworkKit", dependencies: ["LoggerKit", "SerializationKit", "TaskKit"]),
        .target(name: "DIKit", dependencies: ["LoggerKit", "SwinjectAutoregistration"]),
        .target(name: "CoreKit", dependencies: [], resources: [.process("Resources")])
    ],
    swiftLanguageVersions: [.v5]
)
