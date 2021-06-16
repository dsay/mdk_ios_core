// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "mdk_ios_core",
    products: [
        .library(
            name: "ForceUpdate",
            targets: ["ForceUpdate"]),
        .library(
            name: "ServiceLocator",
            targets: ["ServiceLocator"]),
        .library(
            name: "UserDefault",
            targets: ["UserDefault"]),
        .library(
            name: "Validator",
            targets: ["Validator"]),
    ],
    dependencies: [

    ],
    targets: [
        
        /// ForceUpdate
        .target(
            name: "ForceUpdate",
            dependencies: [],
            path: "Sources/ForceUpdate"),
        .testTarget(
            name: "ForceUpdateTests",
            dependencies: ["ForceUpdate"]),
        
        /// ServiceLocator
        .target(
            name: "ServiceLocator",
            dependencies: [],
            path: "Sources/ServiceLocator"),
        .testTarget(
            name: "ServiceLocatorTests",
            dependencies: ["ServiceLocator"]),
        
        /// UserDefault
        .target(
            name: "UserDefault",
            dependencies: [],
            path: "Sources/UserDefault"),
        .testTarget(
            name: "UserDefaultTests",
            dependencies: ["UserDefault"]),
        
        /// Validator
        .target(
            name: "Validator",
            dependencies: [],
            path: "Sources/Validator"),
        .testTarget(
            name: "ValidatorTests",
            dependencies: ["Validator"]),
    ]
)
