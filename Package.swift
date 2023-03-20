// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Neon",    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NeonSDK",
            targets: ["NeonSDK"])
    ],
    
    dependencies: [
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.15.5"),
        .package(name: "RevenueCat", url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.17.7"),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.3"),
        .package(name: "Hero", url: "https://github.com/HeroTransitions/Hero.git", .upToNextMajor(from: "1.4.0")),
        .package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git",    .upToNextMajor(from: "10.4.0")),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
       
        .target(
            name: "NeonSDK",  dependencies: [
                "Lottie",
                "RevenueCat",
                "SDWebImage",
                "Hero",
                "SnapKit",
               .product(name: "FirebaseAnalytics", package: "Firebase"),
                /*
                .product(name: "FirebaseRemoteConfig", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase"),
                .product(name: "FirebaseDynamicLinks", package: "Firebase"),
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseCrashlytics", package: "Firebase")
               */
            ], path: "Neon", resources: [.process("Core/Resources")])
        
    ]
)