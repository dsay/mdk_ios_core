// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "mdk_ios_core",
    platforms: [.iOS(.v13), .tvOS(.v9), .watchOS(.v2)],
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
        
        .library(
            name: "PushNotificationRepository",
            targets: ["PushNotificationRepository"]),
        
        .library(
            name: "LocationRepository",
            targets: ["LocationRepository"]),
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
        
        /// PushNotificationRepository
        .target(
            name: "PushNotificationRepository",
            dependencies: [],
            path: "Sources/PushNotificationRepository"),
        .testTarget(
            name: "PushNotificationRepositoryTests",
            dependencies: ["PushNotificationRepository"]),
        
        /// LocationRepository
        .target(
            name: "LocationRepository",
            dependencies: [],
            path: "Sources/LocationRepository"),
        .testTarget(
            name: "LocationRepositoryTests",
            dependencies: ["LocationRepository"]),
    ]
)
