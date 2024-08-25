//
//  NeonSettingsActionManager.swift
//  AI Note Taker
//
//  Created by Tuna Öztürk on 25.08.2024.
//

import Foundation
import Foundation
import UIKit
import NeonSDK
import StoreKit

class NeonSettingsActionManager {
    
    static func openURL(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func rateApp() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    static func writeReview(appId: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
    
    static func shareApp(from controller: UIViewController, appId: String) {
        let appURL = "https://itunes.apple.com/app/id\(appId)"
        let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        controller.present(activityVC, animated: true, completion: nil)
    }
    
    static func copyUserID(controller: UIViewController) {
        if let userID = AuthManager.currentUserID {
            UIPasteboard.general.string = userID
            NeonAlertManager.default.present(
                title: "User ID Copied",
                message: "You copied your user ID successfully",
                style: .alert,
                viewController: controller
            )
        }
    }
    
    static func contactSupport(email: String) {
        if let mailURL = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(mailURL)
        }
    }
    
    static func upgradeToPremium(completion: (() -> Void)?) {
        // Upgrade to Premium action logic
        completion?()
    }
    
    static func restorePurchases(using service: PurchaseService, mainColor: UIColor, controller: UIViewController) {
        switch service {
        case .revenueCat:
            RevenueCatManager.restorePurchases(vc: controller, animation: .loadingCircle2, animationColor: mainColor, completionSuccess: nil, completionFailure: nil)
        case .adapty:
            AdaptyManager.restorePurchases(vc: controller, animation: .loadingCircle2, animationColor: mainColor, completionSuccess: nil, completionFailure: nil)
        }
    }
}
