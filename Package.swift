// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Neon",   
    platforms: [
        .iOS(.v15),
    ], products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NeonSDK",
            targets: ["NeonSDK"])
    ],
    
    dependencies: [
        
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.15.5"),
        .package(name: "RevenueCat", url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.31.0"),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.3"),
        .package(name: "Hero", url: "https://github.com/HeroTransitions/Hero.git", .upToNextMajor(from: "1.4.0")),
        .package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git",    .upToNextMajor(from: "11.1.0")),
        .package(name: "Localize_Swift", url: "https://github.com/marmelroy/Localize-Swift.git", .upToNextMajor(from: "3.2.0")),
        .package(name: "Adapty", url: "https://github.com/adaptyteam/AdaptySDK-iOS.git", .exact("3.0.0-beta.2")),
        .package(name: "AIProxy", url: "https://github.com/lzell/AIProxySwift.git", from: "0.71.0"),

        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
       
        .target(
            name: "NeonSDK",  dependencies: [
                "RevenueCat",
                "Hero",
                "SnapKit",
                "Localize_Swift",
                "AIProxy",
                .product(name: "Adapty", package: "Adapty", condition: .when(platforms: [.iOS])),
                .product(name: "AdaptyUI", package: "Adapty", condition: .when(platforms: [.iOS])),
                .product(name: "SDWebImage", package: "SDWebImage", condition: .when(platforms: [.iOS])),
                .product(name: "Lottie", package: "Lottie", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseAnalytics", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseRemoteConfig", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseStorage", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseFirestore", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseAuth", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseCrashlytics", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseDynamicLinks", package: "Firebase", condition: .when(platforms: [.iOS])),
                .product(name: "FirebaseMessaging", package: "Firebase", condition: .when(platforms: [.iOS]))
                
            
            ], path: "Neon", resources: [.process("Core/Resources/Animations"), .process("Core/Resources/Fonts"), .process("Core/Resources/Assets")])
        
    ]
)
