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
        
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.15.5"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "5.50.1"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.1.3"),
        .package(url: "https://github.com/HeroTransitions/Hero.git", from: "1.4.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.2.0"),
        .package(url: "https://github.com/marmelroy/Localize-Swift.git", from: "3.2.0"),
        .package(url: "https://github.com/adaptyteam/AdaptySDK-iOS.git", from: "3.15.5"),
        .package(url: "https://github.com/lzell/AIProxySwift.git", from: "0.71.0"),
        

    ],
    targets: [
            .target(
                name: "NeonSDK",
                dependencies: [
                    "Hero",
                    "SnapKit",
                    // Note: Package name is now "Localize-Swift" (from URL), product is "Localize_Swift"
                    .product(name: "Localize_Swift", package: "Localize-Swift"),
                    // Note: Package name is now "AIProxySwift" (from URL)
                    .product(name: "AIProxy", package: "AIProxySwift"),

                    // RevenueCat: Package name changed to "purchases-ios"
                    .product(name: "RevenueCatUI", package: "purchases-ios", condition: .when(platforms: [.iOS])),
                    .product(name: "RevenueCat", package: "purchases-ios", condition: .when(platforms: [.iOS])),

                    // Adapty: Package name changed to "AdaptySDK-iOS"
                    .product(name: "Adapty", package: "AdaptySDK-iOS", condition: .when(platforms: [.iOS])),
                    .product(name: "AdaptyUI", package: "AdaptySDK-iOS", condition: .when(platforms: [.iOS])),

                    .product(name: "SDWebImage", package: "SDWebImage", condition: .when(platforms: [.iOS])),

                    // Lottie: Package name changed to "lottie-spm"
                    .product(name: "Lottie", package: "lottie-spm", condition: .when(platforms: [.iOS])),

                    // Firebase: Package name changed to "firebase-ios-sdk"
                    .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseStorage", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseFirestore", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseAuth", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS])),
                    .product(name: "FirebaseMessaging", package: "firebase-ios-sdk", condition: .when(platforms: [.iOS]))
                ],
                path: "Neon",
                resources: [.process("Core/Resources/Animations"), .process("Core/Resources/Fonts"), .process("Core/Resources/Assets")]
            )
        ],
    swiftLanguageVersions: [.v5]
)
