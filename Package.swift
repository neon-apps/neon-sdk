// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Neon",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Neon Core",
            targets: ["Neon Core"]),
        .library(
            name: "RevenueCat Handler",
            targets: ["RevenueCat Handler"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.15.5"),
        .package(name: "RevenueCat", url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.17.7"),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.3")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
       
        .target(
            name: "Neon Core",
            dependencies: [
                "SDWebImage"
            ], path: "Core"),
        .target(
            name: "RevenueCat Handler",
            dependencies: [
                "Lottie",
                "RevenueCat"
            ], path: "RevenueCat Handler"),
        
    ]
)
